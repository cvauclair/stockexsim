type simulation = {
    agents: (int, Agent.agent) Hashtbl.t;
    exchange: Exchange.exchange;
    mutable trade_history: (int * float) list;
}

let create num_agents = 
    let simulation = {
        agents = Hashtbl.create num_agents;
        exchange = Exchange.create (Order_book.empty_book) 1.0 0.05;
        trade_history = [];
    }
    in
    (* for _ = 0 to (num_agents / 2) - 1 do 
        let agent1 = Agent.create 1000.0 0 (Prediction.generate_prediction_function ()) in
        let agent2 = Agent.create 0.0 100 (Prediction.generate_prediction_function ()) in
        Hashtbl.add simulation.agents agent1.id agent1;
        Hashtbl.add simulation.agents agent2.id agent2;
    done; *)
    for _ = 0 to num_agents - 1 do 
        let agent1 = Agent.create 1000.0 100 (Prediction.generate_prediction_function ()) in
        Hashtbl.add simulation.agents agent1.id agent1;
    done;
    simulation 

let generate_offer (agent: Agent.agent) (exchange: Exchange.exchange) =
    let action = agent.prediction_function exchange.last_price_change in
    Logger.log "prediction" (Printf.sprintf "price = %f | stake = %f" action.price action.stake);
    let price = Math.round ((1.0 +. action.price) *. exchange.last_trade_price) 4 in
    (* Check if aagent has offer already *)
    if agent.placed_offer then
        None
    else if action.price < 0.0 then
        let quantity = truncate (action.stake *. (float agent.num_shares)) in
        if price > 0.0 && quantity > 0 then (
            (* agent.placed_offer <- true; *)
            Some (Offer.Ask {
                agent_id = agent.id;
                quantity = quantity;
                price = price;
                actual_price = 0.0;
            }))
        else
            None
    else if action.price > 0.0 then
        let capital = action.stake *. agent.funds in
        let quantity = truncate (capital /. price) in
        if capital > 0.0  && quantity > 0 then (
            (* agent.placed_offer <- true; *)
            Some (Offer.Bid {
                agent_id = agent.id;
                quantity = quantity;
                price = price;
                actual_price = 0.0;
            }))
        else None
    else None

let add_prices simulation fulfilled_offers =
    simulation.trade_history <- simulation.trade_history @ (List.rev (List.filter_map (fun offer ->
        match offer with
        | Offer.Bid offer_data -> Some (offer_data.quantity, offer_data.actual_price)
        | _ -> None
    ) fulfilled_offers))

let run simulation ticks =
    for i = 1 to ticks do
        Logger.log "info" (Printf.sprintf "last_trade_price = %f" simulation.exchange.last_trade_price);
        let offers = Hashtbl.fold (fun _ agent acc -> (generate_offer agent simulation.exchange)::acc) simulation.agents [] in
        let filtered_offers = List.filter_map (fun x -> x) offers in
        let fulfilled = List.flatten (List.map (fun offer -> Exchange.add_offer simulation.exchange offer; Exchange.resolve_offers simulation.exchange) filtered_offers) in
        let _ = List.map (fun offer -> 
            let offer_data = Offer.get_data offer in 
            (* (
                match offer with 
                | Bid (offer_data) -> Logger.log "info" (Printf.sprintf "%d @ %0.*f" offer_data.quantity 4 (offer_data.actual_price));
                (* | Bid (offer_data) -> Printf.printf "%f\n" (offer_data.actual_price) *)
                | _ -> ()
            ); *)
            Hashtbl.replace simulation.agents offer_data.agent_id (Broker.update_agent (Hashtbl.find simulation.agents offer_data.agent_id) offer)
        ) fulfilled
        in
        add_prices simulation fulfilled;
        (* Logger.log "info" (Printf.sprintf "t = %d: | offers added = %d | offers fullfilled = %d" i (List.length offers) (List.length fulfilled)); *)
        Printf.printf "t = %d:\t| offers added = %d\t| offers fullfilled = %d\n" i (List.length filtered_offers) (List.length fulfilled);
    done;
    simulation

let save simulation =
    let prices_file = open_out "prices.csv" in
    Printf.fprintf prices_file "quantity,price\n";
    let _ = List.map (fun (q, p) -> Printf.fprintf prices_file "%d,%f\n" q p) simulation.trade_history in
    close_out prices_file;
    
    let agents_file = open_out "agents.csv" in
    Printf.fprintf agents_file "id,funds,num_shares\n";
    let agents = Hashtbl.fold (fun _ x acc -> x::acc) simulation.agents [] in
    let _ = List.map (fun (agent: Agent.agent) -> Printf.fprintf agents_file "%d,%f,%d\n" agent.id agent.funds agent.num_shares) agents in
    close_out agents_file;
