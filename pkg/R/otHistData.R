#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

'otHistData' <-
function(exchange='Q', symbol='MSFT', dates=NULL,
  dataType='day', interval=1) {
  
  loggedIn()
  .otReconnect()

  # Create connection parameters
  otPar <- getParams()

  # Handle dates
  if(is.null(dates)) {
    dates <- unclass(c(Sys.time()-60*60*24*65, Sys.time()))
  } else
  if( !all(class(dates) %in% c('POSIXt','POSIXct')) ) {
    stop('\'dates\' must be of class POSIXct')
  } else {
    dates <- unclass(dates)
  }

  # Handle type
  dataType <- match.arg(dataType,
    c('raw.tick','tick','min','hour','day',
      'week','month','year','today'))
  type <-
    switch(dataType,
      raw.tick = OT$HIST_RAW_TICKS,
      tick     = OT$HIST_OHLC_TICK_BASED,
      min      = OT$HIST_OHLC_MINUTELY,
      hour     = OT$HIST_OHLC_HOURLY,
      day      = OT$HIST_OHLC_DAILY,
      week     = OT$HIST_OHLC_WEEKLY,
      month    = OT$HIST_OHLC_MONTHLY,
      year     = OT$HIST_OHLC_YEARLY,
      today    = OT$HIST_OHL_TODAY )

  # Construct Message Body
  msgBody <- pack('a64 a15 a15 x x V V C x v',
    otPar$sessionID,  # Session ID
    exchange,         # Exchange Code
    symbol,           # Symbol Code
    min(dates),       # Start Date
    max(dates),       # End Date
    type,             # Data Type
    interval)         # Interval Value

  # Transmit to OT Server
  reqID <- getRequestID()
  sendRequest(OT$REQUEST_HIST_DATA, reqID, msgBody)

  on.exit(cancelRequest(OT$CANCEL_HIST_DATA,reqID,ok=1004))

  results <- NULL
  loop <- TRUE
  while(loop) {
    
    # Server response
    response <- getResponse(nullError=TRUE)
  
    # Parse Server Response Body
    resBody <- unpack('V H*', response$body)
    nRows <- resBody[[1]]-1  # REMOVE EOD ROW
    remain <- resBody[[2]]

    # Initialize results data.frame
    result <- data.frame(
      timeStamp=rep(0,nRows),
      Open=rep(0,nRows),
      High=rep(0,nRows),
      Low=rep(0,nRows),
      Close=rep(0,nRows),
      Volume=rep(0,nRows) )

    # Loop over rows
    for(i in 1:(nRows+1)) {
      
      # Data Type Code
      remain <- unpack('C H*', remain)
      code <- remain[[1]]
      remain <- remain[[2]]

      # 0  End-Of-Data
      if( code == OT$HIST_CODE_EOD ) {
        loop <- FALSE
        break
      } else
      # 50 OHLC Data
      if( code == OT$HIST_CODE_OHLC ) {
        row <- unpack('V d d d d H8 H*', remain)
        result[i,] <- c(row[1:5],rawToNum(row[[6]],8))
        remain <- row[[7]]
      }
      # 51 Today's OHL Data
      if( code == OT$HIST_CODE_OHL_TODAY ) {
        row <- unpack('V d d d H8 H*', remain)
        result[i,] <- c(row[1:4],rawToNum(row[[5]],8))
        remain <- row[[6]]
      }
    }
    
    results <- rbind(results,result)
  }

  results <- xts(results[,-1], as.POSIXct(results$timeStamp,origin='1970-01-01'))

  return(results)
}

'.otHistTicks' <-
function(exchange='Q', symbol='MSFT', dates=NULL,
  dataType='ohlc.day', interval=1) {
  
  loggedIn()

  # Get connection parameters
  otPar <- getParams()
  
  # Handle dates
  if(is.null(dates)) {
    dates <- unclass(c(Sys.time()-60*60*24*65, Sys.time()))
  } else
  if( !all(class(dates) %in% c('POSIXt','POSIXct')) ) {
    stop('\'dates\' must be of class POSIXct')
  } else {
    dates <- unclass(dates)
  }

  # Handle type
  dataType <- match.arg(dataType,
    c('raw.tick','ohlc.tick','ohlc.min','ohlc.hour','ohlc.day',
      'ohlc.week','ohlc.month','ohlc.year','ohlc.today'))
  type <-
    switch(dataType,
      raw.tick   = OT$HIST_RAW_TICKS,
      ohlc.tick  = OT$HIST_OHLC_TICK_BASED,
      ohlc.min   = OT$HIST_OHLC_MINUTELY,
      ohlc.hour  = OT$HIST_OHLC_HOURLY,
      ohlc.day   = OT$HIST_OHLC_DAILY,
      ohlc.week  = OT$HIST_OHLC_WEEKLY,
      ohlc.month = OT$HIST_OHLC_MONTHLY,
      ohlc.year  = OT$HIST_OHLC_YEARLY,
      ohlc.today = OT$HIST_OHL_TODAY )

  # Construct Message Body
  msgBody <- pack('a64 a15 a15 x x V V C x v',
    otPar$sessionID,  # Session ID
    exchange,         # Exchange Code
    symbol,           # Symbol Code
    min(dates),       # Start Date
    max(dates),       # End Date
    type,             # Data Type
    interval)         # Interval Value

  # Transmit to OT Server
  reqID <- getRequestID()
  sendRequest(OT$REQUEST_HIST_DATA, reqID, msgBody)

  on.exit(cancelRequest(OT$CANCEL_HIST_DATA,reqID,ok=1004))

  results <- NULL
  loop <- TRUE
  while(loop) {
    
    # Server response
    response <- getResponse(nullError=TRUE)
  
    # Parse Server Response Body
    resBody <- unpack('V H*', response$body)
    nRows <- resBody[[1]]-1  # REMOVE EOD ROW
    remain <- resBody[[2]]

    # Initialize results data.frame
    if( type == OT$HIST_OHL_TODAY ) {
      result <- data.frame(
        timeStamp=rep(0,nRows),
        Open=rep(0,nRows),
        High=rep(0,nRows),
        Low=rep(0,nRows) )
    } else {
      result <- data.frame(
        timeStamp=rep(0,nRows),
        Open=rep(0,nRows),
        High=rep(0,nRows),
        Low=rep(0,nRows),
        Close=rep(0,nRows),
        Volume=rep(0,nRows) )
    }

    # Loop over rows
    for(i in 1:(nRows+1)) {
      
      # Data Type Code
      remain <- unpack('C H*', remain)
      code <- remain[[1]]
      remain <- remain[[2]]

      # 0  End-Of-Data
      if( code == OT$HIST_CODE_EOD ) {
        loop <- FALSE
        break
      } else
      # 1  Quote Tick Data
      if( code == OT$HIST_TICK_QUOTE ) {
        row <- unpack('V V d d A2 A A H*', remain)
        result[i,] <- row[1:7]
        remain <- row[[8]]
      }
      # 2  Market Maker Quote Tick Data
      if( code == OT$HIST_TICK_MMQUOTE ) {
        #row <- unpack('V d d d d H8 H*', remain)
        #result[i,] <- c(row[1:5],rawToNum(row[[6]],8))
        #remain <- row[[7]]
      }
      # 3  Trade Tick Data
      if( code == OT$HIST_TICK_TRADE ) {
        #row <- unpack('V d d d d H8 H*', remain)
        #result[i,] <- c(row[1:5],rawToNum(row[[6]],8))
        #remain <- row[[7]]
      }
      # 4  BBO Tick Data
      if( code == OT$HIST_TICK_BBO ) {
        #row <- unpack('V d d d d H8 H*', remain)
        #result[i,] <- c(row[1:5],rawToNum(row[[6]],8))
        #remain <- row[[7]]
      }
      # 50 OHLC Data
      if( code == OT$HIST_CODE_OHLC ) {
        row <- unpack('V d d d d H8 H*', remain)
        result[i,] <- c(row[1:5],rawToNum(row[[6]],8))
        remain <- row[[7]]
      }
      # 51 Today's OHL Data
      if( code == OT$HIST_CODE_OHL_TODAY ) {
        row <- unpack('V d d d d H8 H*', remain)
        result[i,] <- c(row[1:5],rawToNum(row[[6]],8))
        remain <- row[[7]]
      }
    }
    
    results <- rbind(results,result)
  }

  results <- xts(results[,-1], as.POSIXct(results$timeStamp,origin='1970-01-01'))

  return(results)
}

