(** The main simulation data structure, olds the agents and the order book *)
type simulation = {agents: (int, Agent.agent) Hashtbl.t; exchange: Exchange.exchange; mutable trade_history: (int * float) list}

(** [create num_agents] returns a new simulation with num_agents agents *)
val create: int -> simulation

(** [generate_offer agent exchange] returns the agent's market offer (if possible) *)
val generate_offer: Agent.agent -> Exchange.exchange -> Offer.offer option

(** [run simulation ticks] returns the simulation state after ticks number of timesteps *)
val run: simulation -> int -> simulation

(** [save simulation] save simulation data to files *)
val save: simulation -> unit
