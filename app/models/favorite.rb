class Favorite < ActiveRecord::Base
    belongs_to :user
    belongs_to :crypto

    # def self.save

    #     save_new_favorite = Favorite.create(name: )

    # end

end