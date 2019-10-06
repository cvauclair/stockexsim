(** Broker module to handle the translation from the Agent's decition (i.e.: Buy/Sell) to a market order (Bid/Ask) *)

(** [ask_price_for_quantity order_book quantity] returns the highest price for which an Ask will successfully sell quantity number of shares (if any) or None *)
val ask_price_for_quantity: Order_book.order_book -> int -> float option

(** [bid_price_for_quantity order_book quantity] returns the lowest price for which an Bid will successfully buy quantity number of shares (if any) or None *)
val bid_price_for_quantity: Order_book.order_book -> int -> float option

(** [ask_for_capital order_book capital] returns a (quantity, price) tuple which represents the 
maximum quantity of shares (and their price) that one can sell with the current capital *)
(* val ask_for_capital: order_book -> float -> (int * float) *)

(** [bid_for_capital order_book capital] returns a (quantity, price) tuple which represents the 
maximum quantity of shares (and their price) that one can purchase with the current capital *)
val bid_for_capital: Order_book.order_book -> float -> (int * float) option


(** [process_action market_action agent] returns an offer if possible, else None *)
(* val process_action: Agent.market_action -> Agent.agent -> Offer.offer option *)

(** [generate_offer exchange market_action] returns an offer if possible, else None *)
(* val generate_offer: Exchange.exchange -> Agent.market_action -> Offer.offer option *)

(** [update_agent agent offer] returns an updated agent after completing the offer *)
val update_agent: Agent.agent -> Offer.offer -> Agent.agent