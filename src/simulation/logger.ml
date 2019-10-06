let log_on = ref false

let set_logging flag = log_on := flag

let log tag msg = 
    if !log_on then 
        Printf.printf "[%s] %s\n" tag msg