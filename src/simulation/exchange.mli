open Order_book

(** The Exchange module acts as an interface between the order_book and the rest of the 
simulation and provides most of the order resolving logic *)

(** The [exchange] type wraps around order_book to allow updates without return *)
type exchange = {mutable order_book: order_book; mutable last_trade_price: float; mutable last_price_change: float}

(** [create order_book] returns a new exchange *)
val create: order_book -> float -> float -> exchange

(** [to_offer order] returns an offer matching the order *)
val to_offer: order -> Offer.offer_data

(** [to_order offer] returns an order matching the offer *)
val to_order: Offer.offer_data -> order

(** [resolve_offers exchange] updates the exchange by executing all possible orders
 and returns a list of transactions records *)
val resolve_offers: exchange -> Offer.offer list

(** [add_offer exchange offer] updates exchange with the new offer *)
val add_offer: exchange -> Offer.offer -> unit

(** [best_bid exchange] returns the best bid (i.e.: the bid with the highest price) in the exchange *)
val best_bid: exchange -> Offer.offer option

(** [best_ask exchange] returns the best ask (i.e.: the ask with the lowest price) in the exchange *)
val best_ask: exchange -> Offer.offer option