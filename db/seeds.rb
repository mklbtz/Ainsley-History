# This file contains all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

class WeightedCoin < Object

    attr_accessor :weight

    def initialize(weight)
        @weight = weight
    end
    
    # Returns true or false based on the weighting of the coin.
    def flip
        return @weight >= rand()
    end

    # Returns result of a fair 50-50 coin toss.
    def self.fair_toss
        return 0.50 >= rand()
    end
end

# Nuke everything and lay waste to these lands.
puts "1) Deleting existing records from database."
Event.destroy_all
ActiveRecord::Base.connection.execute("ALTER TABLE Events AUTO_INCREMENT = 1;");

# Date ranges for seed loop. Beginning of 2014 to now.
beginDate = Time.parse("2014-01-01 00:00:00")
endDate = Time.now.midnight

# Probability that a door will open on a given weekday.
# Array runs from Sunday to Saturday
wdayProbs = [0.05, 0.95, 0.85, 0.65, 0.77, 0.50, 0.23]
wdayProbs = wdayProbs.map { |p| WeightedCoin.new(p) }

# Max number of door openings in a day
openMax = 25

# Max amount of time between door open and close.
durMax = 45 # seconds

# Inform user of what's about to happen
puts "2) Seeding with new records.\n   From #{beginDate.strftime("%Y-%m-%d")} to \
#{endDate.strftime("%Y-%m-%d")} with a max of #{openMax} openings per day."


date = beginDate
while date != endDate

    # A door will be opened some number of times today.
    for i in (0..openMax) do
        # Stochastically open a door.
        if wdayProbs[date.wday].flip
            # Pick front or back door.
            door = if WeightedCoin.fair_toss then 'front' else 'back' end

            # Pick a time in this day.
            creation = rand(date.midnight..(date + 23.hours))

            # Determine duration of door staying open.
            duration = rand(durMax)

            # Generate the db rows for door opening & closing.
            Event.create(door:door, action:'open', created_at:creation)
            Event.create(door:door, action:'close', created_at:creation + duration.seconds)
        end
    end

    # Move on to the next day.
    date = date + 1.day
end