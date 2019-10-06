open OUnit2

open Stockexsim.Agent

(* Test suite *)
let agent_test_suite = "Agent module test suite" >::: [
    "Create 3 agents test" >:: (fun _ -> 
        let agents = List.init 3 (fun _ -> create 0.0 0 (fun _ -> {price = 0.5; stake = 0.5})) in
        assert_equal agents [
            {id = 1; funds = 0.0; num_shares = 0; prediction_function = (fun _ -> {price = 0.5; stake = 0.5})};
            {id = 2; funds = 0.0; num_shares = 0; prediction_function = (fun _ -> {price = 0.5; stake = 0.5})};
            {id = 3; funds = 0.0; num_shares = 0; prediction_function = (fun _ -> {price = 0.5; stake = 0.5})};
        ]
    );
]

(* Run tests *)
let () = run_test_tt_main agent_test_suite;;