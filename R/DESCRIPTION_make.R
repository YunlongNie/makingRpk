#' This function create the DESCRIPTION file
#'
#' @param name_package package name
#' @param build_dir package directory 
#' @param title_package packge title
#' @param version package version; a character if possible, like "1.1" 
#' @param author author name 
#' @param email  email address
#' @param description description what the package does
#' @export
#' @import dplyr 
#' @examples
#' \dontrun{
#' make_DESCRIPTION(name_package="mypackage",build_dir= "~/Dropbox/Rpackage/",title_package="My package",version="1.1")
#' }

DESCRIPTION_make = function(name_package,build_dir, title_package,version,author="Yunlong",email="nyunlong AT sfu.ca", description="no discription")
{
sink(file.path(build_dir,name_package,'DESCRIPTION'))
name_package%>%sprintf('Package: %s\n',.)%>%cat
"Type: Package\n"%>%cat
title_package%>%sprintf('Title: %s\n',.)%>%cat
version%>%sprintf('Version: %s\n',.)%>%cat
Sys.time()%>%sprintf('Build Time: %s\n',.)%>%cat
author%>%sprintf('Author: %s\n',.)%>%cat
email%>%sprintf("Contact: %s\n",.)%>%cat
description%>%sprintf("DESCRIPTION: %s\n",.)%>%cat
name_package%>%sprintf("Url: https://github.com/YunlongNie/%s\n",.)%>%cat
sink()
}