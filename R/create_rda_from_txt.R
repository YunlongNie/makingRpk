#' This function read the txtfile first and create a rda object using the same name as txt file and save it into the data folder 
#' @param txtfile txtfile name and location
#' @param package_dir package directory 
#' @export
#' @import dplyr 
#' @examples
#' \dontrun{
#' create_rda_from_txt(txtfile='data_folder/sample.txt',package_dir = "mypackage/")
#' }


create_rda_from_txt = function(txtfile,package_dir,rda_name)
{
if (missing(rda_name)) 
{
	rda_name = txtfile%>%strsplit(.,'/')%>%unlist%>%grep('\\.',.,value=TRUE)%>%gsub('.txt','',.)
}

file.path(package_dir,'data')%>%dir.create

temp = txtfile%>%read.delim
assign(rda_name,get("temp"))

save_code = txtfile%>%strsplit(.,'/')%>%unlist%>%grep('\\.',.,value=TRUE)%>%file.path(package_dir,'data',.)%>%gsub('.txt','.rda',.)%>%sprintf("save(%s,file='%s')",rda_name,.)
save_code
eval(parse(text =save_code))
}