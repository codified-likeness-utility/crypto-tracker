class User < ActiveRecord::Base 
    has_many :portfolios
    has_many :trades, through: :portfolios

    has_many :favorites
    has_many :cryptos, through: :favorites


    def self.create_new_user
        new_user = self.new_username 
        new_user.password = self.set_password 
        new_user.save
        @current_user = new_user
    end

    def self.new_username
        set_username = PROMPT.ask("What would you like your username to be?", required: true)
        username_confirmation = PROMPT.yes?("You entered #{set_username .light_blue.bold}, is that correct?") do |q|
            q.suffix 'Yes/No'
        end
        
        if username_confirmation
            if User.find_by(user_name: set_username ) == nil 
                User.create(user_name: set_username )
            else
                puts "#{set_usernameight_red.bold} is NOT available. Please try another username..."
                self.new_username
            end
        else
            self.new_username 
        end
    end

    def self.set_password
        user_password = PROMPT.mask("What would you like your password to be?", required: true) do |q|
            q.validate(/^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/)
            q.messages[:valid?] = "Password needs at least 6 characters with a minimum of one letter and one number" 
        end
        password_confirmation = PROMPT.mask("Confirm Password".light_blue, required: true)
        if user_password == password_confirmation
            user_password
        else
            puts "Hmmm...looks like thos passwords dont match.  Try again..."
            self.set_password
        end
    end

    def self.change_user_info
        change_choice = PROMPT.select("Would you like to change your Username or Password?", %w(Username Password Cancel))
        case change_choice
        when "Username"
            self.change_username
            main_menu
        when "Password"
            self.change_password
            main_menu
        else "Cancel"
            main_menu
        end
    end

    def self.change_username
        set_username = PROMPT.ask("What would you like your username to be?", required: true)
        username_confirmation = PROMPT.yes?("You entered #{set_username .light_blue.bold}, is that correct?") do |q|
            q.suffix 'Yes/No'
        end
        if username_confirmation
            if User.find_by(user_name: set_username ) == nil
                self.user_name = nil
                self.user_name = set_username
                self.save
            else
                puts "#{set_username.light_red} is already exists. Try again..."
                self.change_username
            end
        else
            self.change_user_info
    end

    def self.change_password
        current_password = PROMPT.mask("What is you current password?", required: true)
        if current_password == self.user_password
            new_password = PROMPT.mask("What would you like your NEW password to be?", required: true) do |q|
                q.validate(/^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/)
                q.messages[:valid?] = "Password needs at least 6 characters with a minimum of one letter and one number" 
            end
            password_confirmation = PROMPT.mask("Confirm Password".light_blue, required: true)
            if new_password == password_confirmation
                self.user_password = new_password
            else
                puts "Hmmm...looks like thos passwords dont match.  Try again..."
                self.set_password
            end
        else
            puts "Hmmm...looks like the password you entered does not match your current password.  Try again..."
            self.change_password
        end
    end


end