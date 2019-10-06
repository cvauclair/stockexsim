(** Order book module which handles adding orders to the exchange and resolving those offers *)

(** The [partial] type represents a partial fulfillment of an order *)
type partial = {quantity: int; price: float}

(** [create_partial quantity price] returns a new partial *)
val create_partial: int -> float -> partial

(** [add_partial a b] returns a new partial with quantity and price the sum of the two argument partials *)
val add_partial: partial -> partial -> partial

(** The [order] type is the main type used within the order book and represents the bids and asks of agents *)
type order = {agent_id: int; quantity: int; price: float; partials: partial list}

(** [create_order agent_id quantity price] returns a new order *)
val create_order: int -> int -> float -> order

(** The order_book contains all offers currently in the system *)
type order_book = {bids: order list; asks: order list;}

(** [create_order_book bids asks] returns order book with the specified orders *)
val create_order_book: order list -> order list -> order_book

(** an empty order book*)
val empty_book: order_book

(** [add_bid order_book order] returns an order book with the new order added *)
val add_bid: order_book -> order -> order_book

(** [add_ask order_book order] returns an order book with the new order added *)
val add_ask: order_book -> order -> order_book

(** [best_ask order_book] returns the offer with the lowest ask price (if any) else None *)
val best_ask: order_book -> order option

(** [best_bid order_book] returns the offer with the highest bid price (if any) else None *)
val best_bid: order_book -> order option
