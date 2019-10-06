open Order_book
open Agent

let rec price_for_quantity orders quantity =
    match orders with
    | [] -> None
    | h::t -> if h.quantity >= quantity 
        then Some h.price
        else price_for_quantity t (quantity - h.quantity)

let ask_price_for_quantity order_book quantity = price_for_quantity order_book.bids quantity
let bid_price_for_quantity order_book quantity = price_for_quantity order_book.asks quantity

let rec offer_for_capital orders capital = 
    match orders with
    | [] -> None
    | h::t -> let cost = (float h.quantity) *. h.price in
        if cost >= capital then Some (h.quantity, h.price) else offer_for_capital t (capital -. cost)

(* let ask_for_capital order_book capital = offer_for_capital order_book.bids capital *)
let bid_for_capital order_book capital = offer_for_capital order_book.asks capital

(* let process_action market_action agent =
    match market_action with
    | Buy (capital)-> if agent.num_shares > 0 || agent.funds = 0.0 then None else 
        let (quantity, price) = bid_for_capital capital in
        Some (Offer.create_bid agent.id quantity price)
    | Sell (quantity) -> if agent.num_shares = 0 then None else 
        Some (Offer.create_ask agent.id quantity (ask_price_for_quantity quantity))
    | Hold -> None *)

(* let generate_offer (exchange: Exchange.exchange) (market_action: Agent.market_action) =
    let order_book = exchange.order_book in
    match market_action with
    | Agent.Buy (agent_id, capital, confidence) -> (
        match bid_for_capital order_book capital with
        | Some (quantity, price) -> Some (Offer.create_bid agent_id quantity price)
        | None -> Some (Offer.create_bid agent_id (truncate (((capital /. exchange.last_trade_price) +. 0.5) *. confidence)) (Utility.round (exchange.last_trade_price *. (1.0 +. confidence /. 5.0)) 4))
    )
    | Agent.Sell (agent_id, quantity, confidence) -> (
        match ask_price_for_quantity order_book quantity with
        | Some price -> Some (Offer.create_ask agent_id quantity price)
        | None -> Some (Offer.create_ask agent_id quantity (Utility.round (exchange.last_trade_price *. (1.0 -. confidence /. 5.0)) 4))
    )
    | Agent.Hold -> None *)

let update_agent agent offer = 
    match offer with
    | Offer.Ask (offer_data) -> {agent with 
        funds = agent.funds +. ((float offer_data.quantity) *. offer_data.price); 
        num_shares = agent.num_shares - offer_data.quantity;
        placed_offer = false;
    }
    | Offer.Bid (offer_data) -> {agent with 
        funds = agent.funds -. ((float offer_data.quantity) *. offer_data.price); 
        num_shares = agent.num_shares + offer_data.quantity;
        placed_offer = false;
    }
