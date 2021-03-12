require_relative '../config/environment'

# Favorite.user_favorites
# binding.pry

def welcome
    title = Artii::Base.new(:font => "slant")
    puts title.asciify("Crypto Tracker")
    puts "\n" * 1
    puts "Buy, Sell & Track all of your favorite Crytocurrencies!"
    puts "\n" * 1

    tp.set Crypto, :rank, :name, :symbol, :price, :percent_change_1hr
        top_cryptos = tp Crypto.all, :except => :id
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
        main_menu.choice "Buy Cryptos"
        main_menu.choice "Today's Top 10 Cryptos"
        main_menu.choice "Change Account Info"
        main_menu.choice "Exit"
    end 

    case menu_selection
    when "My Portfolio"
        user_portfolio
    when "My Favorites"
        user_favorites 
    when "Buy Cryptos"
        new_trade
    when "Today's Top 10 Cryptos"
        title = Artii::Base.new(:font => "slant")
        puts title.asciify("Today's Top 10 Crypto's")
        puts "\n" * 2
        tp.set Crypto, :rank, :name, :symbol, :price, :percent_change_1hr
        top_cryptos = tp Crypto.all, :except => :id
    when "Change Account Info"
        User.change_user_info
    else "Exit"
        exit
    end
end

def user_portfolio
    title = Artii::Base.new(:font => "slant")
        puts title.asciify("#{@current_user.user_name}'s Portfolio")
        puts "\n" * 2
        @current_user.portfolios.first.trades.each {|trade|
            puts "Crypto: #{trade.crypto.name} / Price: #{trade.crypto.price} / Amount Purchased: #{trade.count} / Total Value: #{trade.count * trade.crypto.price}"
        }
        last_trade = @current_user.portfolios.last.trades.each {|trade|}
            last_trade.each {|trade| puts "Crypto: #{trade.crypto.name} / Price: #{trade.crypto.price} / Amount Purchased: #{trade.count} / Total Value: #{trade.count * trade.crypto.price}"}
        puts "\n" * 2
        binding.pry
        menu_selection = PROMPT.select("Please select from the following options:") do |main_menu|
            main_menu.enum "."
            main_menu.choice "Main Menu"
            main_menu.choice "Buy Cryptos"
            main_menu.choice "Exit"
        end
        case menu_selection
        when "Main Menu"
            main_menu
        when "Buy Cryptos"
            new_trade
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

    case buy_or_sell
    when "Buy"
        crypto_list = ["Bitcoin", "Ethereum","Tether", "Cardano", "Binance Coin", "Polkadot", "XRP", "Uniswap", "Litecoin", "Chainlink" ]
        buy_choice = PROMPT.select("Select which Crypto you would like to purchase", crypto_list, filter: true)
        
        case buy_choice
        when buy_choice
            buy_amount = PROMPT.ask("How many #{buy_choice} would you like to purchase?") { |q|
                q.in("1-99")
            }
        end
            case buy_amount
            when buy_amount
                purchase_confirmation = PROMPT.yes?("Looks like you want to purchase #{buy_amount.light_green } #{buy_choice.light_green}, is that correct?") do |q|
                    q.suffix "Yes/No"
            end
                case purchase_confirmation
                when purchase_confirmation
                        portfolio_id = Portfolio.last.id +=1
                        crypto = Crypto.find_by(name: "#{buy_choice}")
                        crypto_id = crypto.id
                        save_confirmed_trade = Trade.create(portfolio_id: portfolio_id, crypto_id: crypto_id, count: buy_amount)
                        puts "Trade Oder Processing".light_red
             
                    case save_confirmed_trade        
                    when save_confirmed_trade
                        save_new_portfolio = Portfolio.create(id: portfolio_id, user_id: @current_user.id)
                            menu_selection = PROMPT.select("Your trade has been confirmed!".light_green, %w(Menu Exit))
                        case menu_selection
                        when "Menu"
                                main_menu
                        when "Exit"
                                exit
                        else
                            puts "You did not confirm your trade, please try again!"
                            new_trade
                        end
                    end
                end
            end
    when "Sell"
        sell_menu_selection = PROMPT.select("Sorry, we are currently not accepting sell orders." %w(Menu Exit))
    else "Exit"
        exit
    end
end

def exit 
    title = Artii::Base.new(:font => "slant")
    puts title.asciify("Adios!!!")
end

welcome
intro
