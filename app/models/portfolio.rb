require 'pry'

class Portfolio < ActiveRecord::Base
    belongs_to :user
    has_many :trades

    def self.find
        
    end

end