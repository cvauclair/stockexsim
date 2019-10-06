type prediction_output = {
    price: float;
    stake: float;
}

let prediction_function w1 b1 w2 b2 x = {
    price = 2.0 *. (Math.logistic (w1 *. x +. b1)) -. 1.0;
    stake = Math.logistic (w2 *. x +. b2);
}

let generate_prediction_function () = 
    prediction_function 
    (Math.random_normal_distribution ())
    (Math.random_normal_distribution ())
    (Math.random_normal_distribution ())
    (Math.random_normal_distribution ())