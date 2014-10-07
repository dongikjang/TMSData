library(fields)
ncols <- 60
cols <- val2col(full$aadt, col=tim.colors(ncols))
#cols <- c("#D7191C", "#FDAE61", "#FFFFBF", "#A6D96A", "#1A9641")



data_ <- list()
for(i in 1:nrow(full)){
  spot <- full[i, "spot"]
  datacodes <- c("수시조사지점", "수시조사지점*", "상시조사지점", "상시조사지점*")
  data_[[i]] <- list(spot=spot, 
                     addr=full[i, "addr"],
                     lev=full[i, "lev"],
                     datacode =full[i, "datacode"], 
                     lanes=full[i, "lanes"], 
                     lanenumber=full[i, "lanenumber"],
                     aadt=full[i, "aadt"],
                     longitude=full[i, "x"], latitude=full[i, "y"],
                     popup=paste("<b>지점번호: </b>", 
                                 full[i, "spot"], 
                                 " <br>\n        <b>자료분류:</b> ",
                                 datacodes[match(full[i, "datacode"], c("수", "수*", "상", "상*"))],
                                 " <br>\n        <b>지  역: </b> ", 
                                 full[i, "addr"],
                                 " <br>\n         <b>도로등급:</b> ",
                                 c("고속국도", "일반국도", "지방도", "국가지원지방도")[full[i, "lev"]],
                                 " <br>\n         <b>노선번호:</b> ",
                                 full[i, "lanenumber"],
                                 " <br>\n        <b>차선수 :</b> ",
                                 full[i, "lanes"],
                                 " <br>\n        <b>평균일교통량:</b> ",
                                 full[i, "aadt"],
                                 sep=""),
                     fillColor=cols[i])
                     #fillColor=factor(cols[i], levels=tim.colors(ncols)))
}

save(data_, file="TMSList.RData")