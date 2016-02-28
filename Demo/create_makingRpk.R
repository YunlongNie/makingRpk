name_package = "makingRpk"
title_package = "R package to make R package"
build_dir = '/Users/joha/Dropbox/Rpackages/'
code_dir = "makingRpk_source/Rcode"
(R_code = list.files(file.path(build_dir,code_dir), pattern=".R",full.names=TRUE))
(package_dir = file.path(build_dir,name_package))

library("devtools")
library("roxygen2")
library(dplyr)

install_github('YunlongNie/makingRpk')
library(makingRpk)



# # first remove the yourworkingdir/yourpackagename folder if it exists
# package_dir%>%sprintf('rm -R %s',.)%>%system(.)
# # then create this folder again
# package_dir%>%dir.create

## Step 1 make the DESCRIPTION file 

DESCRIPTION_make(name_package=name_package,build_dir= build_dir,title_package=title_package,version="1.0")

## Step 3 move the R code into R folder 

move_Rcode(code_dir = code_dir,name_package=name_package,build_dir=build_dir)

## Step 4 generate documentation files Rd file 
roxygenise(package.dir=package_dir)


## Step 5 copy the data into data folder 

## Step 5b move the demo code

demo_folder = file.path(build_dir,"makingRpk_source/Demo") # full path name 

sprintf('cp -r %s %s',demo_folder,package_dir)

# if this is your first time set up the package on github go to Step 6 - 7 other wise go to Step 8

## Step 6 create a rep using your github acount using the same name_package on line 

## Step 7 add the local rep to github online 

git_Username = "YunlongNie"
sprintf('cd %s', package_dir)%>%system
"git init"%>%system
sprintf('git remote add origin https://github.com/%s/%s.git',git_Username,name_package)%>%system(.,intern=TRUE)
"git push -u origin master"%>%system(.,intern=TRUE)

# Step 8 go to the folder using command line and run these bach code: 
git_push(git_dir = package_dir)
git_push(git_dir = package_dir,commit=TRUE,comment="add another function git push")


## Step 9 reinstall 
install_github(sprintf('%s/%s',git_Username,name_package))



