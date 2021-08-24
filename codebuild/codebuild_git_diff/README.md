# Get Changed File List
## Overview
This module gets the most recently changed files for a given repository and 
checks them against a supplied list of files to decide whether or not the pipeline needs
to rebuild certain infrastructure. 

## How it works
This module calls the `bin/get_pr_changed_files_list.sh` found inside the cd base image, which
calls the Github API in order to return a list of files changed in the most recently merged PR. 
These files, along with a supplied list of files that you want to watch for changes, are then passed
into `bin/check_for_changed_files.py` which checks the two lists for overlaps. Whether or not an overlap 
is found is saved as a boolean inside an artifact file and passed to the next stage of the pipeline, which 
can use this decide whether or not to rebuild its infrastructure. 
