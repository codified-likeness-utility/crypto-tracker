class Crypto < ActiveRecord::Base
    has_many :trades
    has_many :portfolios, through: :trades

    has_many :favorites 
    has_many :users, through: :favorites

end