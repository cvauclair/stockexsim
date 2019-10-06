let pi = 4.0 *. atan 1.0

let e = exp 1.0

(** Normal distribution from the Box–Muller transform *)
let random_normal_distribution () = (sqrt (-2.0 *. log (Random.float 1.0)) *. cos (2.0 *. pi *. Random.float 1.0))

let logistic x = (1.0 /. (1.0 +. e ** (-1.0 *. x)))

let bound x lbound ubound =
    if x < lbound then lbound
    else if x > ubound then ubound
    else x

let lower_bound x lbound =
    if x < lbound then lbound else x

let upper_bound x ubound =
    if x > ubound then ubound else x

let round n decimals =
    let shift = 10. ** (float decimals) in
    (floor ((n *. shift) +. 0.5)) /. shift