type partial = {
    quantity: int;
    price: float;
}

let create_partial (quantity: int) (price: float): partial = {quantity = quantity; price = price}

let add_partial a b: partial = 
    let total_quantity = a.quantity + b.quantity in
    let total_price = (a.price *. (float a.quantity)) +. (b.price *. (float b.quantity)) in
    create_partial total_quantity (total_price /. (float total_quantity))

type order = {
    agent_id: int;
    quantity: int;
    price: float;
    partials: partial list;
}

let create_order agent_id quantity price = {
    agent_id = agent_id;
    quantity = quantity;
    price = price;
    partials = [];
}

type order_book = {
    bids: order list;
    asks: order list;
}

let create_order_book bids asks = {bids = bids; asks = asks}

let empty_book = create_order_book [] []

let add_bid order_book order = {order_book with bids = (Utility.insert order order_book.bids (fun a b -> a.price < b.price))}
let add_ask order_book order = {order_book with asks = (Utility.insert order order_book.asks (fun a b -> a.price > b.price))}

let best_bid order_book = List.nth_opt order_book.bids 0
let best_ask order_book = List.nth_opt order_book.asks 0