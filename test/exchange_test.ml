open OUnit2

open Stockexsim

(* Test suite *)
let exchange_test_suite = "Exchange module test suite" >::: [
    "Add 1 bid test" >:: (fun _ -> 
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        Exchange.add_offer exchange (Offer.Bid {agent_id = 67; quantity = 3; price = 0.64; actual_price = 0.0});
        assert_equal exchange.order_book {bids = [{agent_id = 67; quantity = 3; price = 0.64; partials = []}]; asks = []}
    );

    "Add 1 ask test" >:: (fun _ -> 
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        Exchange.add_offer exchange (Offer.Bid {agent_id = 67; quantity = 3; price = 0.64; actual_price = 0.0});
        assert_equal exchange.order_book {bids = [{agent_id = 67; quantity = 3; price = 0.64; partials = []}]; asks = []}
    );

    "Add 3 bids test" >:: (fun _ -> 
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        Exchange.add_offer exchange (Offer.Bid {agent_id = 67; quantity = 3; price = 0.64; actual_price = 0.0});
        Exchange.add_offer exchange (Offer.Bid {agent_id = 45; quantity = 10; price = 0.34; actual_price = 0.0});
        Exchange.add_offer exchange (Offer.Bid {agent_id = 20; quantity = 8; price = 0.74; actual_price = 0.0});
        assert_equal exchange.order_book {
            bids = [
                {agent_id = 20; quantity = 8; price = 0.74; partials = []};
                {agent_id = 67; quantity = 3; price = 0.64; partials = []};
                {agent_id = 45; quantity = 10; price = 0.34; partials = []};
            ]; 
            asks = []
        }
    );

    "Add 3 asks test" >:: (fun _ -> 
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        Exchange.add_offer exchange (Offer.Ask {agent_id = 67; quantity = 3; price = 0.64; actual_price = 0.0});
        Exchange.add_offer exchange (Offer.Ask {agent_id = 45; quantity = 10; price = 0.34; actual_price = 0.0});
        Exchange.add_offer exchange (Offer.Ask {agent_id = 20; quantity = 8; price = 0.74; actual_price = 0.0});
        assert_equal exchange.order_book {
            bids = [];
            asks = [
                {agent_id = 45; quantity = 10; price = 0.34; partials = []};
                {agent_id = 67; quantity = 3; price = 0.64; partials = []};
                {agent_id = 20; quantity = 8; price = 0.74; partials = []};
            ];
        }
    );

    "2 asks, 1 bid, 1 transaction test" >:: (fun _ ->
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        let _ = Exchange.resolve_offers (Exchange.add_offer exchange (Offer.Bid {agent_id = 67; quantity = 3; price = 0.64; actual_price = 0.0}); exchange) in
        let _ = Exchange.resolve_offers (Exchange.add_offer exchange (Offer.Ask {agent_id = 20; quantity = 8; price = 0.74; actual_price = 0.0}); exchange) in
        let transactions = Exchange.resolve_offers (Exchange.add_offer exchange (Offer.Ask {agent_id = 45; quantity = 10; price = 0.34; actual_price = 0.0}); exchange) in
        assert_equal (exchange.order_book, transactions) ({
            bids = [];
            asks = [
                {agent_id = 45; quantity = 7; price = 0.34; partials = [{quantity = 3; price = 0.34}]};
                {agent_id = 20; quantity = 8; price = 0.74; partials = []};
            ];
        }, 
        [
            Bid {agent_id = 67; quantity = 3; price = 0.64; actual_price = 0.34}
        ])
    );

    "2 asks, 1 bid, 2 transactions test" >:: (fun _ ->
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        let _ = Exchange.resolve_offers (Exchange.add_offer exchange (Offer.Ask {agent_id = 20; quantity = 10; price = 0.63; actual_price = 0.0}); exchange) in
        let _ = Exchange.resolve_offers (Exchange.add_offer exchange (Offer.Ask {agent_id = 45; quantity = 2; price = 0.52;  actual_price = 0.0}); exchange) in
        let transactions = Exchange.resolve_offers (Exchange.add_offer exchange (Offer.Bid {agent_id = 67; quantity = 9; price = 0.64; actual_price = 0.0}); exchange) in
        assert_equal (exchange.order_book, transactions) ({
            bids = [];
            asks = [
                {agent_id = 20; quantity = 3; price = 0.63; partials = [{quantity = 7; price = 0.63}]}
            ];
        }, 
        [
            Bid {agent_id = 67; quantity = 9; price = 0.64; actual_price = 0.6056};
            Ask {agent_id = 45; quantity = 2; price = 0.52; actual_price = 0.52};
        ])
    );

    "best ask empty book test" >:: (fun _ -> 
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        assert_equal (Exchange.best_ask exchange) None
    );

    "best ask non empty book test" >:: (fun _ -> 
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        Exchange.add_offer exchange (Offer.Ask {agent_id = 20; quantity = 10; price = 0.63; actual_price = 0.0});
        Exchange.add_offer exchange (Offer.Ask {agent_id = 45; quantity = 2; price = 0.52; actual_price = 0.0});
        assert_equal (Exchange.best_ask exchange) (Some (Offer.Ask {agent_id = 45; quantity = 2; price = 0.52; actual_price = 0.0}))
    );

    "best bid empty book test" >:: (fun _ -> 
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        assert_equal (Exchange.best_bid exchange) None
    );

    "best bid non empty book test" >:: (fun _ -> 
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        Exchange.add_offer exchange (Offer.Bid {agent_id = 20; quantity = 10; price = 0.63; actual_price = 0.0});
        Exchange.add_offer exchange (Offer.Bid {agent_id = 45; quantity = 2; price = 0.52; actual_price = 0.0});
        assert_equal (Exchange.best_bid exchange) (Some (Offer.Bid {agent_id = 20; quantity = 10; price = 0.63; actual_price = 0.0}))
    );
]

(* Run tests *)
let () = run_test_tt_main exchange_test_suite;;