# Testing parallel


```r
library(parallel)
```

See https://www.r-bloggers.com/how-to-go-parallel-in-r-basics-tips/

Set up cluster:

```r
# Calculate the number of cores
n_cores <- detectCores() - 1
 
# Initiate cluster
cl <- makeCluster(n_cores, type="FORK") # so all vars & envs go to and it also saves memomry space
```

Using 3 of the available 4 cores.

Do something:


```r
myList <- list(1:20)
parLapply(cl, myList,
          tryCatch({
            function(exponent)
              2^exponent
          }, error = function(e) return(paste0("The variable '",
                                               exponent, "'", 
                                               " caused the error: '", 
                                               e, "'"))
          )
)
```

```
## [[1]]
##  [1]       2       4       8      16      32      64     128     256
##  [9]     512    1024    2048    4096    8192   16384   32768   65536
## [17]  131072  262144  524288 1048576
```

Close the cluster:


```r
stopCluster(cl)
```
