#' install
#'
#' @param token token
#'
#' @return install
#' @export
#'
install_faersR <- function(token){
    e <- tryCatch(detach("package:faersR", unload = TRUE),error=function(e) 'e')
    # check
    (td <- tempdir(check = TRUE))
    td2 <- '1'
    while(td2 %in% list.files(path = td)){
        td2 <- as.character(as.numeric(td2)+1)
    }
    (dest <- paste0(td,'/',td2))
    do::formal_dir(dest)
    dir.create(path = dest,recursive = TRUE,showWarnings = FALSE)
    (tf <- paste0(dest,'/faersR.zip'))

    if (do::is.windows()){
        download.file(url = 'https://codeload.github.com/faerszj/faersR_win/zip/refs/heads/main',
                      destfile = tf,
                      mode='wb',
                      headers = c(NULL,Authorization = sprintf("token %s",token)))
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }else{
        download.file(url = 'https://codeload.github.com/faerszj/faersR_mac/zip/refs/heads/main',
                      destfile = tf,
                      mode='wb',
                      headers = c(NULL,Authorization = sprintf("token %s",token)))
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }

    if (do::is.windows()){
        main <- paste0(dest,'/faersR_win-main')
        (faersR <- list.files(main,'faersR_',full.names = TRUE))
        (faersR <- faersR[do::right(faersR,3)=='zip'])
        (k <- do::Replace0(faersR,'.*faersR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max())
        unzip(faersR[k],files = 'faersR/DESCRIPTION',exdir = main)
    }else{
        main <- paste0(dest,'/faersR_mac-main')
        faersR <- list.files(main,'faersR_',full.names = TRUE)
        faersR <- faersR[do::right(faersR,3)=='tgz']
        k <- do::Replace0(faersR,'.*faersR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max()
        untar(faersR[k],files = 'faersR/DESCRIPTION',exdir = main)
    }

    (desc <- paste0(main,'/faersR'))
    check_package(desc)

    install.packages(pkgs = faersR[k],repos = NULL,quiet = FALSE)
    message('Done(faersR)')
    x <- suppressWarnings(file.remove(list.files(dest,recursive = TRUE,full.names = TRUE)))
    invisible()
}


