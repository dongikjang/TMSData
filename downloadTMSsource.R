extval <- function(val){
  require(stringr)
  val <- gsub("<cell><![[:punct:]]CDATA[[:punct:]]", "", val)
  val <- strsplit(val, "]]></cell>")[[1]][-2]
  
  val <- str_trim(gsub("[[:blank:]]+", " ", val))
  #val
  out <- list(spot = val[1], addr = val[2], x = as.numeric(val[4]), 
              y = as.numeric(val[3]), lev = as.numeric(val[5]),
              aadt = as.numeric(val[6])
  )
  out
}

downloadTMS <- function(left, right, bottom, top){
  url1 <- "http://www.road.re.kr/elecmap/search_xml.asp?mode=mapcontrol"
  url2 <- paste("&left=", left, 
                "&top=", top, 
                "&right=", right, 
                "&bottom=", bottom, sep="")
  urladdr <- paste(url1, url2, sep="")
  a <- readLines(urladdr, encoding = "UTF-8", warn=FALSE)
  ind1 <- gregexpr("<row id='0'", a)
  ind2 <- gregexpr("</rows>", a)
  b <- substring(a, ind1, ind2[[1]]-1)
  
  ind3 <- gregexpr("<row id='[0-9]*'>", b)
  lenind3 <- attr(ind3[[1]], "match.length")
  ind4 <- gregexpr("</row>", b)
  lenind4 <- attr(ind4[[1]], "match.length")
  val <- substring(b, ind3[[1]] + lenind3, ind4[[1]] - 1)
  
  out <- sapply(val, extval, USE.NAMES = FALSE)
  out <- data.frame(spot = unlist(out[1,]), addr = unlist(out[2,]), 
                    x = as.numeric(unlist(out[3,])),  
                    y = as.numeric(unlist(out[4,])), 
                    lev = as.numeric(unlist(out[5,])), 
                    aadt = as.numeric(unlist(out[6,])),
                    stringsAsFactors = FALSE)
  return(out)
}

newdownloadTMS <- function(left, right, bottom, top){
  require(data.table)
  require(XML)
  url1 <- "http://www.road.re.kr/elecmap/search_xml.asp?mode=mapcontrol"
  url2 <- paste("&left=", left, 
                "&top=", top, 
                "&right=", right, 
                "&bottom=", bottom, sep="")
  urladdr <- paste(url1, url2, sep="")
  
  a <- readLines(urladdr, warn = FALSE, encoding="UTF-8")
  b <- xmlTreeParse(a)
  dd <- xmlRoot(b)
  dd["text"] <- NULL
  if(length(dd) < 1) return(NULL)
  out1 <- lapply(dd[1:length(dd)], function(xx) data.frame(t(xmlSApply(xx, xmlValue)), stringsAsFactors = FALSE)[-2])
  
  
  out2 <- rbindlist(out1)
  setnames(out2, c("spot", "addr", "x", "y", "lev", "aadt"))
  Encoding(out2$addr) <- "UTF-8"
  
  return(out2)
}

findspotid <- function(spot, lev){
  urlval <- paste("http://www.road.re.kr/elecmap/statusinfo.asp?infoid=",
                  spot, "&level=", lev, sep="")
  thepage <- readLines(urlval)
  ind <- grep('name=\"spot\"', thepage, perl=TRUE)
  thepage <- thepage[ind]
  ind1 <- gregexpr("value=", thepage)[[1]][1] + 7
  ind2 <- gregexpr("name=", thepage)[[1]][1] - 3
  substring(thepage, ind1, ind2)
}
