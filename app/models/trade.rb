class Trade < ActiveRecord::Base
    belongs_to :crypto
    belongs_to :portfolio


        def self.new_trade
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
                    purchase_confirmation = PROMPT.select("Looks like you want to purchase #{buy_amount.light_green } #{buy_choice.light_green}, is that correct?", ["Yes", "No"])
                

                # case purchase_confirmation
                if purchase_confirmation == "Yes"
                    portfolio_id = Portfolio.last.id +=1
                    crypto = Crypto.find_by(name: "#{buy_choice}")
                    crypto_id = crypto.id
                    save_confirmed_trade = Trade.create(portfolio_id: portfolio_id, crypto_id: crypto_id, count: buy_amount) #<<<<< IN PROGRESS
                else purchase_confirmation == "No"
                    self.new_trade
                end

                case save_confirmed_trade
                when save_confirmed_trade != nil
                    menu_selection = PROMPT.select("Your trade has been confirmed! Would you like to return to the Main Menu or Exit?", %w(MainMenu Exit))
                end

                case menu_selection
                when "MainMenu"
                    main_menu
                else "Exit"
                    exit
                end

            when "Sell"
                puts "Not taking sell orders on Gamestop!!" #code to sell a crypto? this may be a strecth goal
            else "Exit"
                exit
            end

        end

        # def find_crypto_id_by_name
            crypto = Crypto.find_by(name: "#{buy_choice}")
            crypto_id = crypto.id
            crypto_id
        # end
    end

end