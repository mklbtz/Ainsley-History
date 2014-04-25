class Event < ActiveRecord::Base

    # Returns the earliest creation date in the database.
    def self.earliestDate
        return ActiveRecord::Base.connection.execute('SELECT min(created_at) FROM events;').first[0]
    end

    # Returns the number of events that occured on the given date.
    def self.onDate(date)
        dayStart = date.midnight
        dayEnd = dayStart + 1.day - 1.second
        return Event.where(created_at: (dayStart..dayEnd))
    end

    # Returns the number of door openings from date to now.
    def self.dailyCountsInRange(first, last)
        counts = []
        while first <= last
            count = Event.onDate(first).where(action:'open').count
            counts << [first, count]
            first += 1.day
        end
        return counts
    end

    def self.wdayAveragesInRange(first, last)
        counts_and_sums = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
        while first <= last
            cs = counts_and_sums[first.wday]
            cs[0] += 1
            cs[1] += Event.onDate(first).where(action:'open').count
            first += 1.day
        end
        averages = counts_and_sums.map { |cs| cs[1]/cs[0] }
    end
end