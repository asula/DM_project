Folder "Datasets" contains following folders:

AA_keywords - containins all Academy Award Best Picture winning movie keywords in separate files as a very raw text

RZ_keywords - containins all Golden Rasberry Worst Picture winning movie keywords in separate files as a very raw text

Pre - contains files "aa_noms_plaintxt.txt" with information for all the Academy Award Best Picture nominees in form of a very unprocessed text; "aa_wins_plaintxt.txt" with information for all the Academy Award Best Picture winners in form of a very unprocessed text; "rz_plaintxt.txt" with information for all the Golden Raspberry Worst Picture nominees in form of a very unprocessed text

Test - contains keyword files for a few movies which have won neither a Best Picture Oscar nor a Worst Picture Razzie and a file with the name of the movies for mapping the indeces in the keyword files


Folder "Datasets" contains following files:


"aa_genres.txt" - a data file for with features ("movie_id","genre") in each line; separated by tab

"aa_keywords.txt" - a data file with features ("movie_id","keyword") in each line; separated by tab

"aa_movie_noms.txt" - a data file with features ("movie_id","movie_name") in each line; separated by tab

"aa_movie_win.txt"  - a data file with features ("movie_id","movie_name") in each line; separated by tab

"rz_genres.txt" - a data file for with features ("movie_id","genre") in each line; separated by tab

"rz_keywords.txt" - a data file with features ("movie_id","keyword") in each line; separated by tab

"rz_movie_noms.txt" - a data file with features ("movie_id","movie_name") in each line; separated by tab

"rz_movie_win.txt"  - a data file with features ("movie_id","movie_name") in each line; separated by tab

"test_keywords" - a data file with features ("movie_id","keyword") in each line; separated by tab


File "file_processing.py" contains scripts that were used for processing and obtaining the files in the folder "Datasets"

File "DM_project.R" contains code for finding the most frequent keywords based on the datasets in Datasets, visualizing the keywords as wordmaps and sucky attempt to build a prediction model

