(** Offer module ecapsulating bid and ask offers *)

type offer_data = {agent_id: int; quantity: int; price: float; actual_price: float}

type offer = Ask of offer_data | Bid of offer_data

(** [create_ask agent_id quantity price] returns a new Ask offer *)
val create_ask: int -> int -> float -> offer

(** [create_bid agent_id quantity price] returns a new Bid offer *)
val create_bid: int -> int -> float -> offer

(** [get_data offer] return the offer_data of the offer *)
val get_data: offer -> offer_data

(** [to_string offer] returns a string with the offer's info *)
val to_string: offer -> string