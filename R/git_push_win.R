#' This function automatically commit and push the changes on to github in window system
#' @param commit TRUE or FALSE, whether to commit or not
#' @param git_dir repo directory 
#' @param git_exe a string with the full name of git-cmd.exe, 'C:/Users/ynie01/AppData/Local/GitHub/PortableGit_c7e0cbde92ba565cb218a521411d0e854079a28c/git-cmd.exe'
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
#' git_push_win(git_dir=getwd(),commit=FALSE)
#' git_push_win(git_dir=getwd(),commit=TRUE,comment="first git push")
#' }

git_push_win = function(git_dir = '~/Dropbox/Yunlong/',commit=FALSE,comment = " ", keyword="no_filter", limit_size=5000,verbose=TRUE,type=c("deleted","modified","new file",'renamed'),git_exe="git-cmd")
{


setwd(git_dir)


(Lines = system(sprintf('%s git status',git_exe),intern=TRUE))

if (any(grepl("nothing to commit, working directory clean",Lines)))
{
	cat(Lines)
} else {
if (verbose) Lines%>%paste(.,collapse="\n")%>%cat

(file_size = type%>%data.frame(type=.)%>%group_by(type)%>%do(data.frame(lines = grep(.$type,Lines,value=TRUE,fixed=TRUE)))%>%separate(.,lines,c("useless","filename"),":" )%>%mutate(file=gsub(" ","",filename))%>%ungroup%>%mutate(folder=!file.exists(file))%>%mutate(filesize=file.size(file)/1000)%>%select(type,file,folder,filesize)%>%arrange(type,filesize)%>%data.frame)	

if (any(grepl('Untracked files:',Lines,fixed=TRUE)))
{
file_size= Lines[(grep('Untracked files:',Lines,fixed=TRUE)+2):(length(Lines)-1)]%>%grep('\t',.,value=TRUE)%>%gsub('\t',"",.)%>%data.frame(type="untracked",file=.)%>%mutate(folder=!file.exists(as.vector(file)))%>%mutate(filesize=ifelse(folder,NA,file.size(as.vector(file))/1000))%>%data.frame%>%rbind.data.frame(.,file_size)
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

other_files = file_size%>%dplyr::filter(filesize<=limit_size|is.na(filesize))%>%arrange(filesize)

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
git_pull_out = sprintf('%s git pull',git_exe)%>%system(.,intern=TRUE)

if (verbose) git_pull_out%>%paste(.,collapse="\n")%>%cat

(git_add = other_files%>%dplyr::filter(type!="deleted")%>%select(file)%>%first%>%paste0(.,collapse=" ")%>%sprintf("%s git add %s",git_exe,.))
# comment = "'this is a R function for pushing git files but leaves the larges files out'"
(git_commit= sprintf("%s git commit -m '%s'", git_exe,comment))
(git_push = sprintf("%s git push",git_exe))
(git_rm = other_files%>%dplyr::filter(type=="deleted")%>%select(file)%>%first%>%paste(.,collapse=" ")%>%sprintf("%s git rm %s",git_exe,.))

if  (other_files%>%dplyr::filter(type!="deleted")%>%nrow)
{
cat('\nrun git add...\n')
system(git_add,intern=TRUE)%>%paste(.,collapse="\n")%>%cat
}

if (other_files%>%dplyr::filter(type=="deleted")%>%nrow)
{
(git_rm = other_files%>%dplyr::filter(type=="deleted")%>%select(file)%>%first%>%paste(.,collapse=" ")%>%sprintf("%s git rm %s",git_exe,.))
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



# git config credential.helper store pass the confidential setting 
# search for the git-cmd.exe and the full path goes to the git_exe augment 