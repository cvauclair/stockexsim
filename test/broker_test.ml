open OUnit2

open Stockexsim

(* Test suite *)
let broker_test_suite = "Broker test suite" >::: [
    "Ask price for quantity, empty bids test" >:: (fun _ -> 
        let exchange = Exchange.create (Order_book.empty_book) in
        Exchange.add_offer exchange (Offer.Ask {agent_id = 2; quantity = 5; price = 7.1; actual_price = 0.0});
        assert_equal (Broker.ask_price_for_quantity exchange.order_book 4) None
    );

    "Bid price for quantity, empty asks test" >:: (fun _ -> 
        let exchange = Exchange.create (Order_book.empty_book) in
        Exchange.add_offer exchange (Offer.Bid {agent_id = 3; quantity = 8; price = 9.4; actual_price = 0.0});
        assert_equal (Broker.bid_price_for_quantity exchange.order_book 4) None
    );

    "Ask price for quantity, non empty bids test" >:: (fun _ -> 
        let exchange = Exchange.create (Order_book.empty_book) in
        Exchange.add_offer exchange (Offer.Bid {agent_id = 3; quantity = 8; price = 9.4; actual_price = 0.0});
        Exchange.add_offer exchange (Offer.Ask {agent_id = 2; quantity = 5; price = 7.1; actual_price = 0.0});
        assert_equal (Broker.ask_price_for_quantity exchange.order_book 4) (Some 9.4)
    );

    "Bid price for quantity, non empty asks test" >:: (fun _ -> 
        let exchange = Exchange.create (Order_book.empty_book) in
        Exchange.add_offer exchange (Offer.Bid {agent_id = 3; quantity = 8; price = 9.4; actual_price = 0.0});
        Exchange.add_offer exchange (Offer.Ask {agent_id = 2; quantity = 5; price = 7.1; actual_price = 0.0});
        assert_equal (Broker.bid_price_for_quantity exchange.order_book 4) (Some 7.1)
    );

    "Buy action to Bid offer test" >:: (fun _ ->
        let agent = (Agent.reset_counter (); Agent.create_agent 1000.0 0) in
        assert_equal (Broker.process_action Agent.Buy agent) (Some (Offer.Bid {agent_id = 1; quantity = 1; price = 1.0; actual_price = 0.0}))
    );

    "Buy action to Bid offer, no funds test" >:: (fun _ ->
        let agent = (Agent.reset_counter (); Agent.create_agent 0.0 0) in
        assert_equal (Broker.process_action Agent.Buy agent) None
    );

    "Sell action to Ask offer test" >:: (fun _ ->
        let agent = (Agent.reset_counter (); Agent.create_agent 0.0 4) in
        assert_equal (Broker.process_action Agent.Sell agent) (Some (Offer.Ask {agent_id = 1; quantity = 1; price = 1.0; actual_price = 0.0}))
    );

    "Sell action to Ask offer, no shares test" >:: (fun _ ->
        let agent = (Agent.reset_counter (); Agent.create_agent 20.0 0) in
        assert_equal (Broker.process_action Agent.Sell agent) None
    );

    "Hold action to None offer test" >:: (fun _ ->
        let agent = (Agent.reset_counter (); Agent.create_agent 20.0 8) in
        assert_equal (Broker.process_action Agent.Hold agent) None
    );


]

(* Run tests *)
let () = run_test_tt_main broker_test_suite;;