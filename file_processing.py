import os

# --------------------------------------------------------------------------#
# Read in genres 
# --------------------------------------------------------------------------#
f = open("Datasets\\razzies.txt")

f_out = open("Datasets\\raz_genres.txt","w")
indx = ""
pot_indx = ""
indicator = False
for line in f:
    line = line.strip()
    if line == "new": # Line == "-"
        indx = pot_indx
    elif "+" in line:
        indicator = True
    elif line == "movie":
        indicator = False
    elif indicator == True:
        
        f_out.write(indx)
        f_out.write("\t")
        f_out.write(line)
        f_out.write("\n")
    else:
        pot_indx = line

f.close()
f_out.close()

# --------------------------------------------------------------------------#
# Read in Academy Award nominees and winners
# --------------------------------------------------------------------------#
f = open("Datasets\\Pre\\aa_noms_plaintxt.txt")
f_out = open("Datasets\\aa_movie_noms.txt","w")

d = {}
indx = ""
pot_indx = ""
movie = ""
indicator = False
indicator_2 = False
for line in f:
    line = line.strip()
    if indicator_2 == True:
        f_out.write(indx)
        f_out.write("\t")
        f_out.write(movie)
        f_out.write("\t")
        f_out.write(line)
        f_out.write("\n")
        d[movie] = indx
        indicator_2 = False
    elif indicator == True:
        movie = line
        indicator = False
    elif line == "new" or line == "-":
        indx = pot_indx
        indicator = True
    elif line == "icheckmovies":
        indicator_2 = True
    else:
        pot_indx = line

f.close()
f_out.close()

# --------------------------------------------------------------------------#

f2 = open("Datasets\\Pre\\aa_wins_plaintxt.txt")
f_out2 = open("Datasets\\aa_movie_wins.txt","w")
movie = ""
indicator = False
indicator_2 = False
for line in f2:
    line = line.strip()
    if indicator_2 == True:
        f_out2.write(d[movie])
        f_out2.write("\t")
        f_out2.write(movie)
        f_out2.write("\t")
        f_out2.write(line)
        f_out2.write("\n")
        indicator_2 = False
    elif indicator == True:
        movie = line
        indicator = False
    elif line == "new" or line == "-":
        indicator = True
    elif line == "icheckmovies":
        indicator_2 = True

f2.close()
f_out2.close()

# --------------------------------------------------------------------------#
# Read in razzie winners and nominations from wiki file
# --------------------------------------------------------------------------#

f = open("Datasets\\all_razzies.txt")
f_out = open("Datasets\\rz_movie_noms.txt","w")
f_outw = open("Datasets\\rz_movie_wins.txt","w")
# —
d2 = {}
year = ""
indx = 1
for line in f:
    line = line.strip()
    tokens_1 = line.split(" ")
    tokens_2 = line.split("\x97")
    if len(tokens_1[0]) == 5 and tokens_1[0][4]==":":
        year = tokens_1[0][:-1]
        movie = tokens_2[0][6:]
        f_outw.write(str(indx))
        f_outw.write("\t")
        f_outw.write(movie)
        f_outw.write("\t")
        f_outw.write(year)
        f_outw.write("\n")
        
        
    else:
        movie = tokens_2[0]
    f_out.write(str(indx))
    f_out.write("\t")
    f_out.write(movie)
    f_out.write("\t")
    f_out.write(year)
    f_out.write("\n")
    indx+=1
    d2[movie] = str(indx)
        

f.close()
f_out.close()
f_outw.close()

# --------------------------------------------------------------------------#

def find_keywords(f_dir,only_relevant):
    f = open(f_dir)
    kwords = []
    for line in f:
        tokens = line.strip().split()
        if len(tokens) > 0:
            if only_relevant:
                
                first = tokens[0].lower()
                if first == "is" or first == "0":
                    break
            if "relevant" not in tokens and "relevant?" not in tokens:
                kwords.append(line.strip())
    f.close()
    return kwords
# --------------------------------------------------------------------------#
    
f = open("Datasets\\znr.txt")
f_out = open("Datasets\\rz_genres.txt","w")

for line in f:
    line = line.strip()
    tokens_1 = line.split("\t")
    indx = tokens_1[0]
    genres = tokens_1[1].split(", ")
    for genre in genres:
        f_out.write(indx)
        f_out.write("\t")
        f_out.write(genre)
        f_out.write("\n")
    


f.close()
f_out.close()

# --------------------------------------------------------------------------#
# Write keywords to one file
# --------------------------------------------------------------------------#
rootdir =  "Datasets\\Test"
out_dir =  "Datasets"

f_out = open(out_dir+"\\test_keywords.txt","w")
for subdir, dirs, files in os.walk(rootdir):
    for file in files:
        
        filepath = subdir + os.sep + file
        indx = file[:-4]
        kws = find_keywords(filepath,False)
        
        for kw in kws:
            f_out.write(str(indx))
            f_out.write("\t")
            f_out.write(kw)
            f_out.write("\n")
f_out.close()
        
