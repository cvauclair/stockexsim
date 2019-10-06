(** The prediction module handles all prediciton logic  *)

type prediction_output = {price: float; stake: float}

(** [prediction_function w1 b1 w2 b2] returns a prediction function with specified parameters *)
val prediction_function: float -> float -> float -> float -> (float -> prediction_output)

(** [generate_prediction_function ()] returns a random prediction function *)
val generate_prediction_function: unit -> (float -> prediction_output)