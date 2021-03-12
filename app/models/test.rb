def self.login
    login_or_exit = PROMPT.select("", %w(Login Exit))
    case login_or_exit
    when "Login"
        puts "\n" * 35
        find_user = PROMPT.ask("What is your username?".light_cyan, required: true)
        @@current_user = User.find_by(username: find_user)
        if @@current_user == nil
            puts "User not found".light_red
            puts "Please try again!"
            self.login
        end
        enter_password = PROMPT.mask('password:', echo: true,required: true)
        if enter_password == @@current_user.password
            @@current_user
            self.main
        else
            puts "\n" * 35
            puts "Access denied.".light_red
            puts "Please try again!".light_yellow
            self.login 
        end
    else "Exit"
        IceBreaker.quit  
             
    end       
end

def self.main
    puts "\n" * 30
    if @@current_user == nil
        puts "You have to be logged in to use IceBreaker :("
        IceBreaker.login
    else
    IceBreaker.banner_icebreaker
    puts "Hello #{@@current_user.username.light_yellow.bold}!"
    puts "\n" 
    menu_selection = PROMPT.select("Select from the following options?", %w(MyIceBreakers RandomIcebreaker DateIcebreaker YearIcebreaker EditMyInfo LogOut))
    case menu_selection
    when "MyIceBreakers"
        menu_selection = PROMPT.select('Select from the following options.', %w(ShowAll DeleteAll Main))
        case menu_selection
        when "ShowAll"
            puts "\n" * 35
            IceBreaker.display(@@current_user.facts)
            menu_selection = PROMPT.select('Select from the following options.', %w( Back))
            case menu_selection
            when "Back"
                IceBreaker.main
            end
        when "DeleteAll"
            are_you_sure = PROMPT.yes?('Are you sure you want to delete all?') do |q|
            q.suffix 'Y/N'
                end
            if are_you_sure
            @@current_user.facts.delete_all
            IceBreaker.main
            else
              IceBreaker.main
            end
        else "Main"
            IceBreaker.main
        end
    when "RandomIcebreaker"
         requested_type = PROMPT.select("Please select a category.", %w(Trivia Math Back))
        case requested_type
        when "Trivia"
            puts "\n" * 35
            trivia_fact = [Fact.get_random_fact(requested_type.downcase)]
            # self.banner_fascinating
            IceBreaker.display(trivia_fact)
            save_or_exit = PROMPT.select("Save or exit?", %w(Save Exit))
            case save_or_exit
            when "Save"
                save_fact = FactUser.save_icebreaker(@@current_user.id,trivia_fact[0].id)
                @@current_user.facts << trivia_fact
                IceBreaker.main
            else "Exit"
                IceBreaker.main
            end
        when "Math"
            puts "\n" * 35
            trivia_fact = [Fact.get_random_fact(requested_type.downcase)]
            # self.banner_wow
            IceBreaker.display(trivia_fact)
            save_or_exit = PROMPT.select("Save or exit?", %w(Save Exit))
            case save_or_exit
            when "Save"
                save_fact = FactUser.save_icebreaker(@@current_user.id,trivia_fact[0].id)
                @@current_user.facts << trivia_fact
                IceBreaker.main
            else "Exit"
                IceBreaker.main
            end
        else "Back"
            IceBreaker.main            
        end
    when "DateIcebreaker"
        month = PROMPT.ask("Please enter a month (MM) of interest.".light_cyan, required: true) do |q|
            q.in('01-12')
        end
        day = PROMPT.ask('Please enter the day (DD) of interest'.light_cyan, required: true) do |q|
            q.in('01-31')
        end
        puts "\n" * 35
        # self.banner_didyouknow
        trivia_fact = [Fact.get_date_fact(month,day)]
        IceBreaker.display(trivia_fact)
        save_or_exit = PROMPT.select("Save or exit?", %w(Save Exit))
        case save_or_exit
        when "Save"
          save_fact = FactUser.save_icebreaker(@@current_user.id,trivia_fact[0].id)
          @@current_user.facts << trivia_fact
          IceBreaker.main
        else "Exit"
          IceBreaker.main
        end
        
        
    when "YearIcebreaker"
        year = PROMPT.ask('Please enter the year (YYYY) of interest'.light_cyan, required: true) do |q|
            q.in(1..Date.today.year)
        end
        puts "\n" * 35
        trivia_fact = [Fact.get_year_fact(year)]
        IceBreaker.display(trivia_fact)
        save_or_exit = PROMPT.select("Save or exit?", %w(Save Exit))
        case save_or_exit
        when "Save"
          save_fact = FactUser.save_icebreaker(@@current_user.id,trivia_fact[0].id)
          @@current_user.facts << trivia_fact
          IceBreaker.main
        else "Exit"
          IceBreaker.main
        end 
        
        
    when "EditMyInfo"
        self.edit_my_info
    else "LogOut"
        @@current_user = nil
        IceBreaker.main
        end
    end
end