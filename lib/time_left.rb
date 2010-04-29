class TimeLeft
  # Monitor time that is left to do some stuff.
  # Usage
  #   total_records=1000
  #   t=TimeLeft.new(:total=>total_records)
  #   1.upto(1000) do |i|
  #     t.tick(i) do
  #       show_when i%100==0
  #       use_format "%S.%U"
  #     end
  #   end
  #   t.finish
  #
  #   TimeLeft.timer(:total=>total_records) do |t|
  #     1.upto(100) do |i|
  #       t.tick(i)
  #     end
  #   end
  #   
  attr_accessor :start_time,:format,:total,:value

  def initialize(options={},out=STDERR)
    @out=out
    @finished=false
    @terminal_width=80
    self.reset(options)
  end

  def self.timer(options={},out=STDERR)
    timer=self.new(options,out)
    yield timer
    timer.finish
  end

  def reset(options={})
    options.each{|k,v| self.send(:"#{k}=",v)}
    self.format="%H:%M:%S" unless self.format
  end

  def finish
    @finished=true
    self.calculate_time
    show
  end
  # Start to show time
  # ===Example
  #    t=TimeLeft.new(:total=>1000)
  #    1.upto(10) do |i|
  #      t.tick(i) do
  #        show_when i>1
  #      end
  #    end
  def tick(value=nil,&block)
    self.start_time=Time.now if !self.start_time
    self.value=value || Time.now.to_i
    
    if block_given?
      self.instance_eval(&block)
    else
      @visible=true
    end
    if @visible
      self.calculate_time
      self.show if @current_time
      @visible=false
    end
  end

  # Use conditions to output time.
  # ===Exammple
  #   show_when a%5==0
  #   show_when Time.now-self.start_time>0.5 # every half second
  def show_when conditions
    @visible=true if conditions
  end

  # Available format
  # * %H - Hours of day (0..23)
  # * %M - Minutes of hour (0..59)
  # * %S - Seconds of minute (0..59)
  # * %U - Miliseconds of second (0..999)
  def use_format format
    self.format=format
  end

  def calculate_time
    @current_time=nil
    if self.total.to_f>0
      part_done=self.value.to_f/self.total.to_f
    end
    if part_done>0
      spent_time=(Time.now-self.start_time)
      total_time=spent_time/part_done
      difference=total_time-spent_time
      if difference>0
        time_left=Time.at(difference)
        h,m,s,ms=(time_left.hour-2),time_left.min,time_left.sec,time_left.usec
        h,m,s,ms=(h>9 ? h.to_s : "0#{h}"),(m>9 ? m.to_s : "0#{m}"),(s>9 ? s.to_s : "0#{s}"),(ms>99 ? ms.to_s : (ms>9 ? "0#{ms}" : "00#{ms}"))[0..2]
        @current_time=self.format.gsub(/%H/,h).gsub(/%M/,m).gsub(/%S/,s).gsub(/%U/,ms)
      end
    end
  end

  def get_width #from ruby progress_bar
    default_width = 80
    begin
      tiocgwinsz = 0x5413
      data = [0, 0, 0, 0].pack("SSSS")
      if @out.ioctl(tiocgwinsz, data) >= 0 then
        rows, cols, xpixels, ypixels = data.unpack("SSSS")
        if cols >= 0 then cols else default_width end
      else
        default_width
      end
    rescue Exception
      default_width
    end
  end

  def eol
    @finished ? "\n" : "\r"
  end
  
  def show
    line =@current_time 
    width = get_width
    if line.to_s.length < width - 1
      @out.print("#{line}#{eol}")
    elsif line.length >= width
      @out.print("#{line}\n")
    end
    @out.flush
  end
end
