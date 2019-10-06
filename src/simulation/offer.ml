(* Offer: offertype, agent id, quantity, price *)
type offer_data = {
    agent_id: int;
    quantity: int;
    price: float;
    actual_price: float;
}

type offer = 
    | Ask of offer_data
    | Bid of offer_data

let create_ask agent_id quantity price = Ask {agent_id = agent_id; quantity = quantity; price = price; actual_price = 0.0}
let create_bid agent_id quantity price = Bid {agent_id = agent_id; quantity = quantity; price = price; actual_price = 0.0}

let get_data offer = 
    match offer with
    | Ask (offer_data) | Bid (offer_data) -> offer_data

let to_string offer = 
    match offer with
    | Ask (offer_data) -> Printf.sprintf "Ask: %d %d %f %f" offer_data.agent_id offer_data.quantity offer_data.price offer_data.actual_price
    | Bid (offer_data) -> Printf.sprintf "Bid: %d %d %f %f" offer_data.agent_id offer_data.quantity offer_data.price offer_data.actual_price