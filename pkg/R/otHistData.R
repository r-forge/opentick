#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

'otHistData' <-
function(connection, exchange='Q', symbol='MSFT', dates=NULL,
  dataType='ohlc.day', interval=1) {

  # Handle dates
  if(is.null(dates)) {
    dates <- c(unclass(Sys.time()-60*60*24*365),unclass(Sys.time()))
  } else
  if( !all(class(dates) %in% c('POSIXt','POSIXct')) ) {
    stop('\'dates\' must be of class POSIXt')
  } else {
    dates <- unclass(dates)
  }

  # Handle type
  dataType <- match.arg(dataType,
    c('raw.tick','ohlc.tick','ohlc.min','ohlc.hour','ohlc.day',
      'ohlc.week','ohlc.month','ohlc.year','ohlc.today'))
  type <-
    switch(dataType,
      raw.tick   = 1,
      ohlc.tick  = 2,
      ohlc.min   = 3,
      ohlc.hour  = 4,
      ohlc.day   = 5,
      ohlc.week  = 6,
      ohlc.month = 7,
      ohlc.year  = 8,
      ohlc.today = 9 )

  # Construct Message Body
  msgBody <-
    pack('a64 a15 a15 x x V V C x v',
      connection$sessionID, # Session ID
      exchange,             # Exchange Code
      symbol,               # Symbol Code
      dates[1],             # Start Date
      dates[2],             # End Date
      type,                 # Data Type
      interval)             # Interval Value

  # Transmit to OT Server
  response <- transmit(connection, OT$REQUEST_HIST_DATA, msgBody)
  
  # Need Error Handling
  if( response$header[[2]] == 2 )
    stop('User error ;-)')
  
  # Parse Server Response Body
  resBody <- unpack('V a*', response$body)
  nRows <- resBody[[1]]

  # Initialize results data.frame
  results <- data.frame( timeStamp=rep(0,nRows), Open=rep(0,nRows), High=rep(0,nRows),
                         Low=rep(0,nRows), Close=rep(0,nRows), Volume=rep(0,nRows) )

  # Get information for each observation
  remain <- resBody[[2]]
  for(i in 1:nRows) {
    row <- unpack('C V d d d d a8 a*', remain)
    results[i,] <- c(row[2:6],rawToNum(row[[7]],8))
    remain <- row[[8]]
  }
  
  results <- xts(results[,-1], as.POSIXct(results[,1],origin='1970-01-01'))
  # Only keep subscription URL
  #resBody[2:3] <- NULL

  return(results)
}
