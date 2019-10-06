open Stockexsim

let () =
    Logger.set_logging false;
    Random.init 0;
    (* Random.self_init (); *)
    let sim = Simulation.create 3000 in
    let sim = Simulation.run sim 30 in
    Simulation.save sim