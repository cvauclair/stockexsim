(** Useful math functions and constants *)

(** The constant pi *)
val pi: float

(** The constant e *)
val e: float

(** [random_normal_distribution ()] returns a random variable sampled from a normal distribution *)
val random_normal_distribution: unit -> float

(** [logistic x] returns 1/(1 + e^-x) *)
val logistic: float -> float

(** [bound x lbound ubound] returns x if x E [lbound, ubound] else lbound of ubound if outside *)
val bound: 'a -> 'a -> 'a -> 'a

(** [lower_bound x lbound] returns x if x >= lbound else lbound *)
val lower_bound: 'a -> 'a -> 'a

(** [upper_bound x ubound] returns x if x <= ubound else ubound  *)
val upper_bound: 'a -> 'a -> 'a

(** [round n decimals] returns n rounded to specified number of decimals *)
val round: float -> int -> float