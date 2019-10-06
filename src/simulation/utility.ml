let rec insert x l comparator = 
    match l with
    | [] -> x::[]
    | h::t -> if (comparator h x) then x::l else h::(insert x t comparator)

let ascending_insert x l = insert x l (>)

let descending_insert x l = insert x l (<)

let maybe_head l = 
    match l with
    | [] -> None
    | h::_ -> Some h