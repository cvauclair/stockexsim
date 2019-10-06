open OUnit2

open Stockexsim.Order_book
open Stockexsim.Exchange

(* Test suite *)
let order_book_test_suite = "Order book test suite" >::: [

]

(* Run tests *)
let () = run_test_tt_main order_book_test_suite;;