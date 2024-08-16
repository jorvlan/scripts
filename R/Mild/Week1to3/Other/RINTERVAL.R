rinterval <- function(data, id, datetime, min_int, no_night = F){
  
  if (!requireNamespace('lubridate', quietly = TRUE)) { # install & load lubridate
    install.packages('lubridate')
  }
  
  library('lubridate')
  
  min_int <- min_int * 60 # minutes to seconds
  data_new <- list() # list to store individual datasets in
  init_t <- c() # vector to keep score of initial number of timepoints
  
  for(i in 1:length(unique(data[, id]))){
    
    data_i <- data[data[, id] == unique(data[, id])[i], ] # data for each participant
    data_i <- data_i[!is.na(data_i[, datetime]), ] # exclude rows with missing datetime
    init_t[i] <- nrow(data_i) # number of initial time points
    data_i$stamp <- as.numeric(as.POSIXct(data_i[, datetime])) # create time stamp
    data_i$dt <- c(diff(data_i$stamp), NA) # create time difference
    
    n_na_i <- c() # number of NA values in between observations
    int_na_i <- c() # difference in time divided by number of observations (+1)
    data_i_l <- list() # list with original rows
    n_na_i_l <- list() # list with rows of NA values in between observations
    
    for(t in 1:nrow(data_i)){
      
      if(no_night){ # If NA's are not added between the last observation of a day and the first observation of the next
        
        data_i$day <- match(as.Date(lubridate::as_datetime(data_i$stamp)), unique(as.Date(lubridate::as_datetime(data_i$stamp)))) # create day variable
        
        if(t < nrow(data_i)){ # for all but the last row
          
          if(data_i$day[t] == data_i$day[t + 1]){ # only within the same day (day variable does not change)
            
            n_na_i[t] <- round(data_i$dt[t] / min_int) - 1 # number of intervals to be added in between measurements (hence -1)
            n_na_i[n_na_i < 0] <- 0 # cannot be lower than zero
            
            int_na_i[t] <- round(data_i$dt[t]/(n_na_i[t] + 1)) # divide the time between measurements by the number of intervals
            
            n_na_i_l[[t]] <- as.data.frame(matrix(NA, n_na_i[t], ncol(data_i))) # NA rows
            names(n_na_i_l[[t]]) <- names(data_i) # same names in order to merge later
            
            if(nrow(n_na_i_l[[t]]) > 0){  # if there are any rows of NA to add
              
              n_na_i_l[[t]][[id]] <- data_i[, id][t] # add id
              n_na_i_l[[t]]$stamp <- data_i$stamp[t] + seq_along(n_na_i_l[[t]]$stamp) * int_na_i[t] # add timestamp
              n_na_i_l[[t]]$day <- data_i$day[t] # add day
              
            }
            
          }
          
        }
        
        else if(t == nrow(data_i)){ # for last row (add in order to merge)
          
          n_na_i_l[[t]] <- as.data.frame(matrix(NA, 0, ncol(data_i))) 
          names(n_na_i_l[[t]]) <- names(data_i)
          
        }
        
      } else { # If NA's are also added for nights 
        
        n_na_i[t] <- round(data_i$dt[t]/min_int) - 1 # number of minimal intervals between measurements
        n_na_i[n_na_i < 0 ] <- 0 # cannot be lower than zero
        n_na_i[is.na(n_na_i)] <- 0 # last time difference between measurements per participant is NA; this ensures no NA between participants
        
        int_na_i[t] <- round(data_i$dt[t]/(n_na_i[t] + 1)) # divide the time between measurements by the number of intervals
        
        n_na_i_l[[t]] <- as.data.frame(matrix(NA, n_na_i[t], ncol(data_i))) # NA rows
        names(n_na_i_l[[t]]) <- names(data_i) # same names in order to merge later
        
        if(nrow(n_na_i_l[[t]]) > 0){  # if there are any rows of NA to add
          
          n_na_i_l[[t]][[id]] <- data_i[, id][t] # add id
          n_na_i_l[[t]]$stamp <- data_i$stamp[t] + seq_along(n_na_i_l[[t]]$stamp) * int_na_i[t] # add timestamp
          
        }
        
      }
      
      data_i_l[[t]] <- as.data.frame(data_i[t, ]) # store each row in the list
      
    }
    
    merged_l <- list() # list to merge data and NA's in
    
    for(t in 1:nrow(data_i)) {
      
      merged_l <- c(merged_l, list(data_i_l[[t]], n_na_i_l[[t]])) # merge data and NA's
      
    }
    
    merged_l <- Filter(function(x) !is.null(x), merged_l) # delete Nulls
    data_i <- do.call(rbind, lapply(merged_l, function(x) { do.call(cbind, x) })) # merge in one list
    data_i <- as.data.frame(data_i) # as data frame
    data_i[, datetime] <- lubridate::as_datetime(data_i$stamp) # overwrite original date
    data_i$dif.m <- c(round(diff(data_i$stamp) / 60), NA) # create difference in minutes
    data_i$cs.dif.m <- c(0, cumsum(data_i$dif.m[-length(data_i$dif.m)])) # create cumulative difference in minutes
    
    if(no_night){
      
      data_i <- data_i[, c('day', names(data_i)[names(data_i) != 'day'])] 
      
    }
    
    # reorder to first columns and remove temporary columns
    data_i <- data_i[, c('cs.dif.m', names(data_i)[names(data_i) != 'cs.dif.m'])]
    data_i <- data_i[, c('dif.m', names(data_i)[names(data_i) != 'dif.m'])]
    data_i <- data_i[, c(as.character(datetime), names(data_i)[names(data_i) != as.character(datetime)])]
    data_i <- data_i[, c(as.character(id), names(data_i)[names(data_i) != as.character(id)])]
    data_i <- data_i[, - which(names(data_i) == 'stamp')] # remove stamp variable
    data_i <- data_i[, - which(names(data_i) == 'dt')] # remove difference variable
    
    cat(paste0("participant ", unique(data_i[, id]), ", NA's added: ", nrow(data_i) - init_t[i], " (", round((nrow(data_i) - init_t[i])/nrow(data_i) , 2) * 100, "%)\n"))
    
    data_new[[i]] <- data_i
    
  }
  
  data <- do.call(rbind, data_new)
  
  cat(paste0("total NA added:", round((nrow(data) - sum(init_t)) / nrow(data), 2) * 100, "%\n")) 
  
  return(data) 
  
}