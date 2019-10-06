open Order_book

type exchange = {
    mutable order_book: order_book;
    mutable last_trade_price: float;
    mutable last_price_change: float;
}

let create order_book last_price last_change = {
    order_book = order_book; 
    last_trade_price = last_price;
    last_price_change = last_change;
}

let to_offer order: Offer.offer_data = 
    match order.partials with
    | [] -> {
            agent_id = order.agent_id; 
            quantity = order.quantity;
            price = order.price;
            actual_price = 0.0;
        }
    | _ -> 
        let total_partial = List.fold_left (fun a b -> add_partial a b) (create_partial 0 0.0) order.partials in {
            agent_id = order.agent_id;
            quantity = total_partial.quantity;
            price = order.price;
            actual_price = Math.round total_partial.price 4;
        }

let to_order (offer_data: Offer.offer_data): order = create_order offer_data.agent_id offer_data.quantity offer_data.price

let resolve_offers exchange =
    let rec resolve order_book fulfilled_offers = 
        match (order_book.bids, order_book.asks) with
        | ([], _) -> (order_book, fulfilled_offers)
        | (_, []) -> (order_book, fulfilled_offers)
        | (bids_h::bids_t, asks_h::asks_t) -> if bids_h.price >= asks_h.price 
            then
                let max_qty = min bids_h.quantity asks_h.quantity in
                let partial = create_partial max_qty asks_h.price in
                let bids_h = {bids_h with quantity = bids_h.quantity - max_qty; partials = partial::bids_h.partials} in
                let asks_h = {asks_h with quantity = asks_h.quantity - max_qty; partials = partial::asks_h.partials} in
                let full_offers = ((if bids_h.quantity > 0 then None else Some bids_h), (if asks_h.quantity > 0 then None else Some asks_h)) in
                match full_offers with
                | (None, None) -> resolve {bids = bids_h::bids_t; asks = asks_h::asks_t} []
                | (Some bid, None) -> resolve {bids = bids_t; asks = asks_h::asks_t} ((Offer.Bid (to_offer bid))::fulfilled_offers)
                | (None, Some ask) -> resolve {bids = bids_h::bids_t; asks = asks_t} ((Offer.Ask (to_offer ask))::fulfilled_offers)
                | (Some bid, Some ask) -> resolve {bids = bids_t; asks = asks_t} ((Offer.Bid (to_offer bid))::((Offer.Ask (to_offer ask))::fulfilled_offers))
            else
                (order_book, fulfilled_offers)
    in
    let (order_book, fulfilled_offers) = resolve exchange.order_book [] in
    let last_offer_fulfilled = List.nth_opt fulfilled_offers 0 in
    let new_trade_price = (
        match last_offer_fulfilled with
        | Some offer -> let offer_data = Offer.get_data offer in (Logger.log "last fulfilled" (Offer.to_string offer); offer_data.actual_price)
        | None -> exchange.last_trade_price
    )
    in
    exchange.order_book <- order_book;
    exchange.last_price_change <- ((new_trade_price /. exchange.last_trade_price) -. 1.0);
    exchange.last_trade_price <- new_trade_price;
    (* Printf.printf "last fulfilled price = %f | last trade price = %f | last price change = %f\n" new_trade_price exchange.last_trade_price exchange.last_price_change; *)
    fulfilled_offers

let add_offer exchange offer =
    Logger.log "new offer" (Offer.to_string offer);
    match offer with
    | Offer.Bid (offer_data) -> exchange.order_book <- (add_bid exchange.order_book (to_order offer_data))
    | Offer.Ask (offer_data) -> exchange.order_book <- (add_ask exchange.order_book (to_order offer_data))

let best_bid exchange = Option.map (fun order -> Offer.Bid (to_offer order)) (Order_book.best_bid exchange.order_book)
let best_ask exchange = Option.map (fun order -> Offer.Ask (to_offer order)) (Order_book.best_ask exchange.order_book)


