library("devtools")
library("roxygen2")
library(dplyr)

install_github('YunlongNie/makingRpk')

name_package = "yourpackagename"
build_dir = 'yourworkingdir' # it will create a folder under this working dir with name as "yourpackagename"
code_dir = "yourRcode_folder"
package_dir = file.path(build_dir,name_package)

# first remove the yourworkingdir/yourpackagename folder if it exists
package_dir%>%sprintf('rm -R %s',.)%>%system(.)
# then create this folder again
package_dir%>%dir.create

## Step 1 make the DESCRIPTION file 

DESCRIPTION_make(name_package=name_package,build_dir= build_dir,title_package=title_package,version="1.0")

## Step 3 move the R code into R folder 

move_Rcode(code_dir = code_dir,name_package=name_package,build_dir=build_dir)

## Step 4 generate documentation files Rd file 
roxygenise(package.dir=package_dir)


## Step 5 copy the data into data folder 

txtfile = "yourdata.txt" # with full name
create_rda_from_txt(txtfile,package_dir = package_dir)

## Step 5b move the demo code

demo_folder = "yourdemofolder" # full path name 

sprintf('cp -r %s %s',demo_folder,package_dir)

## Step 6 create a rep using your github acount using the same name_package on line 

git_Username = "yourusername"

# go to the folder using command line and run these bach code: 
sprintf('cd %s', package_dir)%>%system
sprintf('git remote add origin https://github.com/%s/%s.git',git_Username,name_package)%>%system

"git push -u origin master"%>%system


## step 6 reinstall 
install_github(sprintf('%s/%s',git_Username,name_package))



