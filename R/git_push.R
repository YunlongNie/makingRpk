#' This function automatically commit and push the changes on to github
#' @param commit TRUE or FALSE, whether to commit or not
#' @param git_dir repo directory 
#' @param comment comment message, a string, only matters when commit is TRUE
#' @param keyword a string for keyword filtering, for you only want commit a certain folder each time
#' @param type a string or a string vector, one of "deleted","modified","new file" and "renamed"
#' @param limit_size large file limit, default is 5000 which means 5MB
#' @param verbose TRUE or FALSE, print the git messages
#' @export
#' @import dplyr 
#' @import tidyr
#' @examples
#' \dontrun{
#' git_push(git_dir=getwd(),commit=FALSE)
#' git_push(git_dir=getwd(),commit=TRUE,comment="first git push")
#' }

git_push = function(git_dir = '~/Dropbox/Yunlong/',commit=FALSE,comment = " ", keyword="no_filter", limit_size=5000,verbose=TRUE,type=c("deleted","modified","new file",'renamed'))
{


setwd(git_dir)
(Lines = system('git status',intern=TRUE))

if (any(grepl("nothing to commit, working directory clean",Lines)))
{
	cat(Lines)
} else {
if (verbose) Lines%>%paste(.,collapse="\n")%>%cat

file_size = type%>%data.frame(type=.)%>%group_by(type)%>%do(data.frame(lines = grep(.$type,Lines,value=TRUE,fixed=TRUE)))%>%separate(.,lines,c("useless","filename"),":" )%>%mutate(file=gsub(" ","",filename))%>%ungroup%>%mutate(filesize=file.size(file)/1000)%>%select(type,file,filesize)%>%arrange(type,filesize)%>%data.frame

if (any(grepl('Untracked files:',Lines,fixed=TRUE)))
{
file_size= Lines[(grep('Untracked files:',Lines,fixed=TRUE)+2):(length(Lines)-1)]%>%grep('\t',.,value=TRUE)%>%gsub('\t',"",.)%>%data.frame(type="untracked",file=.)%>%mutate(filesize=file.size(file)/1000)%>%data.frame%>%rbind.data.frame(.,file_size)
}

if(keyword!="no_filter") file_size = file_size%>%dplyr::filter(grepl(keyword,file))


if(any(grepl(' ',file_size$file))) {
	cat('#########################\n')
	cat('\nWarning!\n')
	cat('The following file contains a space in the name:\n')
	grep(' ',file_size$file,value=TRUE)%>%print
	cat('\n')
}

large_files = file_size%>%dplyr::filter(filesize>limit_size)

if(nrow(large_files)) {
	cat('Warning!!! Large files detected:\n')
	cat('#########################\n')
	print(large_files)
	cat('\n#########################\n')
} else {

	cat("\nNo large files detected\n")
}

other_files = file_size%>%dplyr::filter(filesize<=limit_size|is.na(filesize))

if (nrow(other_files))
{

cat("\nFiles ready to commit\n")
cat('#########################\n')
other_files%>%dplyr::filter(type!="deleted")%>%print
cat('\n#########################\n')

cat("\nFiles need to rm\n")
cat('#########################\n')
other_files%>%dplyr::filter(type=="deleted")%>%print
cat('\n#########################\n')

} else 
{
	cat(sprintf('No files need to commit with keyword %s',keyword))
}

if (commit&nrow(other_files))
{
cat('\nrun git pull...\n')	
git_pull_out = 'git pull'%>%system(.,intern=TRUE)

if (verbose) git_pull_out%>%paste(.,collapse="\n")%>%cat

(git_add = other_files%>%dplyr::filter(type!="deleted")%>%select(file)%>%first%>%paste0(.,collapse=" ")%>%sprintf("git add %s",.))
# comment = "'this is a R function for pushing git files but leaves the larges files out'"
(git_commit= sprintf("git commit -m '%s'", comment))
(git_push = "git push")
(git_rm = other_files%>%dplyr::filter(type=="deleted")%>%select(file)%>%first%>%paste(.,collapse=" ")%>%sprintf("git rm %s",.))
cat('\nrun git add...\n')
system(git_add,intern=TRUE)%>%paste(.,collapse="\n")%>%cat

if (other_files%>%dplyr::filter(type=="deleted")%>%nrow)
{
(git_rm = other_files%>%dplyr::filter(type=="deleted")%>%select(file)%>%first%>%paste(.,collapse=" ")%>%sprintf("git rm %s",.))
cat('\nrun git rm...\n')
system(git_rm,intern=TRUE)%>%paste(.,collapse="\n")%>%cat
}

cat('\nrun git commit...\n')
system(git_commit,intern=TRUE)%>%paste(.,collapse="\n")%>%cat
cat('\nrun git push...\n')
system(git_push,intern=TRUE)%>%paste(.,collapse="\n")%>%cat
cat('\nDONE\n')
}

}


}

