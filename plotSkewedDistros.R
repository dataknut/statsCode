# create skewed histograms as examples
# http://stackoverflow.com/questions/20254084/plot-normal-left-and-right-skewed-distribution-in-r

N <- 10000
x <- rnbinom(N, 8, .5)
hist(x, 
     xlim=c(min(x),max(x)), probability=T, nclass=max(x)-min(x)+1, 
     col='lightblue', xlab=' ', ylab=' ', axes=F
     #main='Positive Skewed'
     )
lines(density(x,bw=1), col='red', lwd=3)

x <- rbeta(10000,2,5)
hist(x,xlab='value',ylab='count', main = '')
