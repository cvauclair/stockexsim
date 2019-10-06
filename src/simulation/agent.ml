(* AGENT *)
type agent = {
    id: int;
    funds: float;
    num_shares: int;
    mutable placed_offer: bool;
    prediction_function: float -> Prediction.prediction_output
}

(** [generate_prediction ()] returns a prediction tuple (sentiment, confidence). 
The sentiment represents the stock movement in % [-1.0, 1.0].
The confidence represents the agent's confidence in his prediction [0.0, 1.0] *)
(* let generate_prediction agent market_data = {
    sentiment = bound (agent.prediction_function market_data.last_trade_price) (-1.0) 1.0;
    confidence = bound (agent.prediction_function market_data.last_trade_price) 0.0 1.0;
} *)
(* let generate_prediction agent (exchange: Exchange.exchange) = agent.prediction_function exchange.last_trade_price *)

let agent_counter = ref 0

let reset_counter () = agent_counter := 0

let create funds num_shares pfun = {
    id = (agent_counter := (!agent_counter) + 1; !agent_counter); 
    funds = funds; 
    num_shares = num_shares;
    placed_offer = false;
    prediction_function = pfun;
}