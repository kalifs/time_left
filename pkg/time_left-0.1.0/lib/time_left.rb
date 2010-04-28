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
  #
  #   t2=TimeLeft.new()
  #   while data_processed?
  #     data=collect_data_from_remote
  #     t.tick do
  #       data=collect_data_from_remote unless data
  #       self.total=data.size if data
  #       show_when Time.now-self.start_time>0.5
  #     end
  #   end
  attr_accessor :start_time,:visible,:format,:total,:value

  def initialize(options={})
    self.reset(options)
  end

  def reset(options={})
    options.each{|k,v| self.send(:"#{k}=",v)}
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
      self.visible=true
    end
    if self.visible
      self.time_out
      self.visible=false
    end
  end

  # Use conditions to output time.
  # ===Exammple
  #   show_when a%5==0
  #   show_when Time.now-self.start_time>0.5 # every half second
  def show_when conditions
    self.visible=true if conditions
  end

  # Available format
  # * %H - Hours of day (0..23)
  # * %M - Minutes of hour (0..59)
  # * %S - Seconds of minute (0..59)
  # * %U - Miliseconds of second (0..999)
  def use_format format
    self.format=format
  end

  def time_out
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
        puts self.format.gsub(/%H/,h).gsub(/%M/,m).gsub(/%S/,s).gsub(/%U/,ms)
      end
    end
  end
end
