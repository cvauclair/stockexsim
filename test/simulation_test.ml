open OUnit2

open Stockexsim

(* Test suite *)
let simulation_test_suite = "Simulation module test suite" >::: [
    "[test] generate ask offer, normal conditions" >:: (fun _ -> 
        let agent = Agent.create 1000.0 10 (fun _ -> {price = -0.1; stake = 0.5}) in
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        let offer = Simulation.generate_offer agent exchange in
        match offer with Some offer' -> print_endline (Offer.to_string offer') | _ -> ();
        assert_equal offer (Some (Ask {agent_id = 1; quantity = 5; price = 9.0; actual_price = 0.0}))
    );

    "[test] generate bid offer, normal conditions" >:: (fun _ -> 
        let agent = Agent.create 1000.0 10 (fun _ -> {price = 0.1; stake = 0.5}) in
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        let offer = Simulation.generate_offer agent exchange in
        match offer with Some offer' -> print_endline (Offer.to_string offer') | _ -> ();
        assert_equal offer (Some (Ask {agent_id = 1; quantity = 5; price = 11.0; actual_price = 0.0}))
    );

    "[test] generate ask offer, no shares" >:: (fun _ -> 
        let agent = Agent.create 1000.0 0 (fun _ -> {price = -0.1; stake = 0.5}) in
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        let offer = Simulation.generate_offer agent exchange in
        match offer with Some offer' -> print_endline (Offer.to_string offer') | _ -> ();
        assert_equal offer None
    );

    "[test] generate bid offer, no cash" >:: (fun _ -> 
        let agent = Agent.create 0.0 10 (fun _ -> {price = 0.1; stake = 0.5}) in
        let exchange = Exchange.create (Order_book.empty_book) 10.0 0.05 in
        let offer = Simulation.generate_offer agent exchange in
        match offer with Some offer' -> print_endline (Offer.to_string offer') | _ -> ();
        assert_equal offer None
    );
]

(* Run tests *)
let () = run_test_tt_main simulation_test_suite;;