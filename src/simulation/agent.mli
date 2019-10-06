(** Agent module which represents the agent's state and decision making process *)

type agent = {id: int; funds: float; num_shares: int; mutable placed_offer: bool; prediction_function: float -> Prediction.prediction_output}

(** Global agent counter *)
val agent_counter: int ref

(** [reset_counter ()] resets the global agent counter *)
val reset_counter: unit -> unit

(** [create funds num_shares] returns a new agent with specified parameters *)
val create: float -> int -> (float -> Prediction.prediction_output) -> agent
