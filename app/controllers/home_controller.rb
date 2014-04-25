class HomeController < ApplicationController

    def index
        # Generate a hash with dates as keys and number-of-door-events as values.
        # Note: Dividing .count by 2 because open & close should go together.
        first = Event.earliestDate
        today = Time.now.midnight

        @earliestDate = first.strftime("%B %-d, %Y")

        @counts = Event.dailyCountsInRange(first, today)
        @counts = @counts.map { |date,count| "{date:'#{date.strftime('%Y-%m-%d')}', count:#{count}}" }

        weekdays = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday']
        @averages = Event.wdayAveragesInRange(first, today)
        @averages = weekdays.zip(@averages)
        @averages = @averages.map { |wday,count| "{wday:'#{wday}', count:#{count}}" }
    end

    def hello
        unless params[:id].blank?
            door = params[:id]
            c = Event.new(door: door, action:'open')
            if c.save
                redirect_to(action:'index')
            else
                raise 'error'
            end
        else
            redirect_to(action:'index')
        end
    end

    def bye
        unless params[:id].blank?
            door = params[:id]
            c = Event.new(door: door, action:'close')
            if c.save
                redirect_to(action:'index')
            else
                raise 'error'
            end
        else
            redirect_to(action:'index')
        end
    end


end
