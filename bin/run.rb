require_relative '../config/environment'

# Favorite.user_favorites
# binding.pry

def welcome
    title = Artii::Base.new(:font => "slant")
    puts title.asciify("Crypto Tracker")
    puts "\n" * 1
    puts "Buy, Sell & Track all of your favorite Crytocurrencies!"
    puts "\n" * 1

    #put Top 5 cryptos
end

def intro
    new_user_answer = PROMPT.yes?("Is this your first time using Crypto Tracker?") do |q|
        q.suffix "Yes/No"
    end
    if new_user_answer
        new_user_sign_up
    else
        puts "\n" * 1
        existing_user_login
    end
end

def new_user_sign_up
    new_account = PROMPT.select("Welcome! Please Create a New Account or Login", %w(Create Login))
    case new_account
    when "Create"
        @current_user = User.create_new_user
        main_menu
    else "Login"
        existing_user_login
    end
end

def existing_user_login
    login_prompt = PROMPT.select("", %w(Login Exit))
    case login_prompt
    when "Login"
        find_username = PROMPT.ask("Enter your username:".light_blue, required: true)
        @current_user = User.find_by(user_name: find_username)
        if @current_user == nil
            puts "Incorrect username".light_red
            puts "Try Again!".light_green
            existing_user_login
        end
        valididate_password = PROMPT.mask("Enter your password:".light_blue, required: true)
        if valididate_password == @current_user.password
            @current_user
            main_menu
        else
            puts "Hacker detected!!!...".light_red
            puts "Well, maybe we will let you try again....ok, go for it!".light_green
            existing_user_login
        end
    else "Exit"
        exit
    end
end

def main_menu
    title = Artii::Base.new(:font => "slant")
    puts title.asciify("Welcome #{@current_user.user_name}")
    puts "\n" * 1
    menu_selection = PROMPT.select("Select a menu option") do |main_menu|
        main_menu.enum "."
        main_menu.choice "My Portfolio"
        main_menu.choice "My Favorites"
        main_menu.choice "Buy or Sell Crypto"
        main_menu.choice "Top 20 Cryptos"
        main_menu.choice "Exit"
    end 

    case menu_selection
    when "My Portfolio"
        title = Artii::Base.new(:font => "slant")
        puts title.asciify("#{@current_user.user_name}'s Portfolio")
        puts "\n" * 2
        @current_user.portfolios.first.trades.each {|trade|
            puts "Crypto: #{trade.crypto.name} / Price: #{trade.crypto.price} / Amount Purchased: #{trade.count} / Total Value: #{trade.count * trade.crypto.price}"
        }
    when "My Favorites"
        user_favorites #<<<< Method NOT Done >>>>>#
    when "Buy or Sell Crypto"
        new_trade
    when "Top 20 Cryptos"
        Crypto.top_20 #<<<< Method NOT Done >>>>>#
    else "Exit"
        exit
    end
end

def user_favorites
    title = Artii::Base.new(:font => "slant")
    puts title.asciify("#{@current_user.user_name}'s Favorites")

    tp.set Crypto, :rank, :name, :symbol, :price, :percent_change_1hr
    top_cryptos = tp Crypto.all, :except => :id
    puts "\n" * 2
    menu_selection = PROMPT.select("Please select from the following options:") do |main_menu|
        main_menu.enum "."
        main_menu.choice "Add Favorite"
        main_menu.choice "Remove Favorite"
        main_menu.choice "Back"
    end
    case menu_selection
    when "Add Favorite"
        favorites_list = ["Bitcoin", "Ethereum","Tether", "Cardano", "Binance Coin", "Polkadot", "XRP", "Uniswap", "Litecoin", "Chainlink" ]
        new_favorites = PROMPT.multi_select("Select your favorite crypto's to start tracking!", favorites_list, filter: true)
        new_favorites
    when "Remove Favorite"
        #prompt for which crypto you would like to delete
    else "Back"
        main_menu
    end
end

def new_trade
    buy_or_sell = PROMPT.select("Would you like to Buy or Sell a Crypto?", %w(Buy Sell Exit))

    if buy_or_sell == "Buy"
        crypto_list = ["Bitcoin", "Ethereum","Tether", "Cardano", "Binance Coin", "Polkadot", "XRP", "Uniswap", "Litecoin", "Chainlink" ]
        buy_choice = PROMPT.select("Select which Crypto you would like to purchase", crypto_list, filter: true)
        if buy_choice
            buy_amount = PROMPT.ask("How many #{buy_choice} would you like to purchase?") { |q|
                q.in("1-99")
            }
        end
        
        if buy_amount != nil
            purchase_confirmation = PROMPT.yes?("Looks like you want to purchase #{buy_amount.light_green } #{buy_choice.light_green}, is that correct?") do |q|
                q.suffix "Yes/No"
        

        if purchase_confirmation == "Yes"
            portfolio_id = Portfolio.last.id +=1
            crypto = Crypto.find_by(name: "#{buy_choice}")
            crypto_id = crypto.id
            save_confirmed_trade = Trade.create(portfolio_id: portfolio_id, crypto_id: crypto_id, count: buy_amount) #<<<<< IN PROGRESS
        else purchase_confirmation == "No"
            new_trade
        end

        if save_confirmed_trade
            menu_selection = PROMPT.select("Your trade has been confirmed! Would you like to return to the Main Menu or Exit?", %w(MainMenu Exit))
        end

        if menu_selection == "MainMenu"
            main_menu
        else menu_selection == "Exit"
            exit
        end

    elsif buy_or_sell == "Sell"
        puts "Not taking sell orders on Gamestop!!" #code to sell a crypto? this may be a strecth goal
    else buy_or_sell == "Exit"
        exit
    end
end

def exit 
    title = Artii::Base.new(:font => "slant")
    puts title.asciify("Adios!!!")
end

welcome
intro
