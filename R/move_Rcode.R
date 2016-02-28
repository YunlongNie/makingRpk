#' This function moves the R source code into the R folder
#'
#' @param name_package package name
#' @param build_dir package directory 
#' @param code_dir R code dir, full name, put the all the R code here.
#' @export
#' @import dplyr 
#' @examples
#' \dontrun{
#' move_Rcode(code_dir="Rcode/",name_package="my_packge",build_dir="~/Dropbox/Rpackage/")

#' }

move_Rcode= function(code_dir,name_package,build_dir,verbose=TRUE)
{
(Rfiles_from = list.files(file.path(build_dir,code_dir),pattern='.R',full.names=TRUE))
if(length(Rfiles_from)<=0) cat('no R files in the folder!')

if (length(Rfiles_from))
{
(Rfiles_to =list.files(file.path(build_dir,code_dir),pattern='.R')%>%file.path(build_dir,name_package,'R',.))
file.path(build_dir,name_package,'R')%>%dir.create
if (verbose)
{
cat("Copy files from: \n")
cat("\n##############\n")
paste0(Rfiles_from,collapse="\n")%>%cat
cat("\n##############\n")
cat("\nto\n")	
cat("\n##############\n")
paste0(Rfiles_to,collapse="\n")%>%cat
cat("\n##############\n")
}
if (all(file.copy(Rfiles_from,Rfiles_to,overwrite=TRUE))) cat("\nDone!\n")
}
}