train <- function(df, n) {	# df - input dataframe, n - learning rate
	l <- length(df$X1)	# records in dataframe
	alpha <- rep(0,times=l)
	b <- 0
	R <- max(sqrt(df$X1^2 + df$X2^2))
	
	
	repeat {
		mistake <- FALSE
		for (i in 1:l) {
			xi <- c(df$X1[i],df$X2[i])
			yi <- df$Y[i]
			w <- make.w(alpha,df)
			if (sign(sum(w*xi) - b) != yi) {
				mistake <- TRUE
				alpha[i] <- alpha[i] + 1
				b <- b - n*yi*R^2
			}
		}
		#print(c("w=",w,"alpha=",alpha))
		if (w[1] != 0 && w[2] != 0)
			surface(list("w"=w,"b"=b)) # keep plotting the evolving decision surface
		if (interactive)
			readline(prompt="Paused")
		if (!mistake) 
			break
	}

	finalsurface(list("w"=w,"b"=b)) 	
	slope = -(w[1]/w[2])
#	offset = - (b/w[2])
	offset =  (b/w[2])
	alpha.values(alpha,df)
	list("slope"=slope,"offset"=offset)

}

make.w <- function(alpha,df) {
	l <- length(df$X1)	# records in dataframe
	w1 <- 0
	w2 <- 0
	for (i in 1:l) {
		yi <- df$Y[i]
		ai <- alpha[i]
		w1 <- w1 + ai*yi*df$X1[i]
		w2 <- w2 + ai*yi*df$X2[i]
	}
	#print(c("w1=",w1,"w2=",w2))
	w <- c(w1,w2)
	#print(w)
	w # return
}

surface <- function(m) {
	w <- m$w
	b <- m$b
	
	slope = -(w[1]/w[2])
#	offset = - (b/w[2])
	offset =  (b/w[2])

	# assumes that there was something like this, plot(0:9,0:9,type="n"), before
	abline(offset,slope,lty="dashed")
}

finalsurface <- function(m) {
	w <- m$w
	b <- m$b
	
	slope = -(w[1]/w[2])
#	offset = - (b/w[2])
	offset =  (b/w[2])
	
	# assumes that there was something like this, plot(0:9,0:9,type="n"), before
	abline(offset,slope,lty="solid",lwd=2,col="green")
}


alpha.values <-function(alpha,df) {
	# plot the support points
	
	sa <- sort(alpha,decreasing=TRUE)
	
	for (i in 1:length(df$X1))
		if (alpha[i] == sa[1] || alpha[i] == sa[2])
			points(df$X1[i],df$X2[i],col="green")
}

dataset <- function(df) {
	quartz(width=8,height=8)
	# setup the plot
	plot(-20:20,-20:20,type="n",main="Perceptron Learning",xlab="X1",ylab="X2")
	abline(h=0)
	abline(v=0)
	
	# plot the classes
	for (i in 1:length(df$X1))
		if (df$Y[i] > 0 )
			points(df$X1[i],df$X2[i],col="red")
		else
			points(df$X1[i],df$X2[i],col="blue")
}

#### main driver routine ###
#ds <- read.table("ds1.csv", header=TRUE, sep=",")
ds <- as.data.frame(list("X1" = c(1,3,4,5,1,2,2.5,3), "X2"=c(6,7,1,3,4,1,1.5,1), "Y"=c(-1,-1,-1,-1,1,1,1,1)))
interactive <- TRUE

run <- function(learningrate) {
	dataset(ds)
	train(ds,learningrate)
}
