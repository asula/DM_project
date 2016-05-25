aa_keywords <- read.delim("Datasets/aa_keywords.txt", header=FALSE)

rz_keywords <- read.delim("Datasets/rz_keywords.txt", header=FALSE)

rz_genres <- read.delim("Datasets/rz_genres.txt", header=FALSE)
aa_genres <- read.delim("Datasets/aa_genres.txt", header=FALSE)

rz_movies <- read.delim("Datasets/rz_movie_wins.txt", header=FALSE)
aa_movies <- read.delim("Datasets/aa_movie_wins.txt", header=FALSE)

test_keywords <- read.delim("Datasets/test_keywords.txt", header=FALSE)
colnames(test_keywords) <- c("id","keyword")

colnames(aa_keywords) <- c("id","keyword")

colnames(rz_keywords) <- c("id","keyword")

colnames(aa_genres) <- c("id","genre")
colnames(rz_genres) <- c("id","genre")

colnames(aa_movies) <- c("id","name","year")
colnames(rz_movies) <- c("id","name","year")

n.elems <- function(freqs,min_freq){
  return(length(unique(freqs[freqs>=min_freq])))
}


# ------------------------------------------------------------ #
# Find keyword and genre frequencies
# ------------------------------------------------------------ #


# 1. Academy Award keywords and corresponding frequencies

aa_kw_freqs <- as.numeric(table(aa_keywords$keyword))
aa_kws <- sort(unique(aa_keywords$keyword))


# 2. Academy Award genres and corresponding frequencies

aa_gnr_freqs <- as.numeric(table(aa_genres$genre))
aa_gnrs <- sort(unique(aa_genres$genre))

# 3. Razzie keywords and correspinding frequencies

rz_kw_freqs <- as.numeric(table(rz_keywords$keyword))
rz_kws <- sort(unique(rz_keywords$keyword))

rz_lim_indx = match(setdiff(rz_kws,c("worst picture razzie winner")),rz_kws)
rz_lim_kws = rz_kws[rz_lim_indx]
rz_lim_kw_freqs = rz_kw_freqs[rz_lim_indx]
# 4. Razzie genres and corresponding frequencies

rz_gnr_freqs <- as.numeric(table(rz_genres$genre))
rz_gnrs <- sort(unique(rz_genres$genre))

# Keywords only present in AA-s:

aa_un_kw_indx  = match(setdiff(aa_kws,rz_kws),aa_kws)
aa_un_kws = aa_kws[aa_un_kw_indx]
aa_un_kw_freqs = aa_kw_freqs[aa_un_kw_indx]

# Keywords only present in RZ-s:

#"box office flop","critically bashed",
rz_un_kw_indx = match(setdiff(setdiff(rz_kws,aa_kws),c("worst picture razzie winner")),rz_kws)
rz_un_kws = rz_kws[rz_un_kw_indx]
rz_un_kw_freqs = rz_kw_freqs[rz_un_kw_indx]


# ------------------------------------------------------------ #
# Prediction model :s
# ------------------------------------------------------------ #

aa_kws_lim <- aa_kws[aa_kw_freqs>10]
aa_kw_freqs_lim <- aa_kw_freqs[aa_kw_freqs>10]

rz_kws_lim <- rz_kws[rz_kw_freqs>5]
rz_kw_freqs_lim <- rz_kw_freqs[rz_kw_freqs>5]

all_kws <- union(rz_kws_lim,aa_kws_lim)
wrds_to_remove <- c("box office flop","box office hit","blockbuster","worst picture razzie winner")
all_kws <- setdiff(all_kws,wrds_to_remove)

nr = nrow(aa_movies) + nrow(rz_movies)
nc = length(all_kws)

aa_movies$id.2 <- c(1:89)
rz_movies$id.2 <- c(90:129)

pred.data <- matrix(data = rep(0,nr*nc),ncol= nc,nrow =nr)


i = 1
for (id in aa_movies$id){
  present_kws <- match(intersect(aa_keywords$keyword[which(aa_keywords$id == id)],all_kws),all_kws) 
  pred.data[i,present_kws] <- rep(1,length(present_kws))
  i = i+1
}

for (id in rz_movies$id){
  present_kws <- match(intersect(rz_keywords$keyword[which(rz_keywords$id == id)],all_kws),all_kws) 
  pred.data[i,present_kws] <- rep(1,length(present_kws))
  i = i+1
}


testv <- rep(0,175)
present_kws <- match(intersect(test_keywords$keyword[which(test_keywords$id == 7)],all_kws),all_kws) 
testv[present_kws] <- rep(1,length(present_kws))

class <- c(rep(1,89),rep(0,40))

df = data.frame(pred.data)
colnames(df) = all_kws
rownames(df) = c(aa_movies$id.2,rz_movies$id.2)
df$class = class



train_indx <- sample(c(1:129),100)
test_indx <- setdiff(c(1:129),train_indx)

train <- df[train_indx,]
test <- df[test_indx,]

mt <- matrix(data=testv,nrow=1)
df2 <- data.frame(mt)
colnames(df2) <- all_kws

library(e1071)
model <- naiveBayes(class ~ ., data = df)
predictions <- predict(model,test[,c(1:179)])

mod <- glm(class ~ ., family = "binomial",data = df)
preds <- predict(mod,df2,type="response")

#test[,c(1:176)]

match(intersect(rz_keywords$keyword[which(rz_keywords$id == 1)],all_kws),all_kws)

# ------------------------------------------------------------ #
# Visualizing with word cloud
# ------------------------------------------------------------ #

library(wordcloud)

# AA keywords
wordcloud(aa_kws,aa_kw_freqs, scale = c(3.5,.000005),min.freq = 16,
          colors = rev(rainbow(n.elems(aa_kw_freqs,16),start=0,end=0.3)))

# AA genres
wordcloud(aa_gnrs, aa_gnr_freqs, scale = c(6,1),min.freq = 1,
          colors = rev(rainbow(n.elems(aa_gnr_freqs,1),start=0,end=0.3)))

# RZ keywords
wordcloud(rz_kws, rz_kw_freqs, scale = c(4,.005),min.freq = 6,
          colors = (rainbow(n.elems(rz_kw_freqs,6),start=0.7,end=1)))

# RZ keywords vol 2
wordcloud(rz_lim_kws, rz_lim_kw_freqs, scale = c(4,.05),min.freq = 6,
          colors = (rainbow(n.elems(rz_lim_kw_freqs,6),start=0.7,end=1)))

# RZ genres
wordcloud(rz_gnrs, rz_gnr_freqs, scale = c(5,1),min.freq = 2,
          colors = (rainbow(n.elems(rz_gnr_freqs,2),start=0.7,end=1)))

# AA unique keywords

#length(aa_un_kw_freqs[aa_un_kw_freqs > 8])

wordcloud(aa_un_kws, aa_un_kw_freqs, scale = c(3.3,0.0000005),min.freq = 8,
          colors = rev(rainbow(n.elems(aa_un_kw_freqs,8),start=0,end=0.3)))

# RZ unique keywords

wordcloud(rz_un_kws, rz_un_kw_freqs, scale = c(5,1),min.freq = 3
          ,colors = (rainbow(n.elems(rz_un_kw_freqs,3),start=0.7,end=1)))


most_oscar_film = aa_movies[which((as.numeric(rowSums(df))[c(1:89)])==max((rowSums(df))[c(1:89)])),][2]
most_razzie_film = rz_movies[which((as.numeric(rowSums(df))[c(90:129)])==max((rowSums(df))[c(90:129)])),][2]

