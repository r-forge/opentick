'otRequest' <-
function(connection, messageHeader, messageBody) {

  # Construct Client Request
  reqLen <- packBits(binary(NROW(c(messageHeader,messageBody)),4*8))
  writeBin(c(reqLen,messageHeader,messageBody), connection$connection)

  # Retrieve Server Response
  resLen <- readBin(connection$connection, integer(), size=4)
  message <- readBin(connection$connection, raw(), resLen)

  # Parse Server Response
  header <- readBin(message, raw(), 12)
  body <- readBin(message[13:resLen], raw(), resLen-12)

  return(list(length=resLen,header=header,body=body))
}

'buildHeader' <- 
function(commandType, requestID, ...) {

  # Create Request Message Header
  header <-
    c( packBits(binary(1, 1*8)),            # Message Type
       packBits(binary(1, 1*8)),            # Command Status
       packBits(binary(0, 2*8)),            # Reserved Bytes
       packBits(binary(commandType, 4*8)),  # Command Type
       packBits(binary(requestID, 4*8)) )   # Request ID
}

'parseHeader' <-
function(header) {

  # Parse Server Response Header
  header <- list(
    messageType   = readBin(header[1]   , integer(), size=1),
    commandStatus = readBin(header[2]   , integer(), size=1),
    reserved      = readBin(header[3:4] , integer(), size=2),
    commandType   = readBin(header[5:8] , integer(), size=4),
    requestID     = readBin(header[9:12], integer(), size=4) )

  return(header)
}

#'pack' <-
#'unpack' <-
#'otEventHandler' <- function(connection, command, ...)
#'getMAC' <- function()

binary <-
function(x, dim) {

  pos <- ifelse( x==0, 1, floor(log(x,2))+1 )
  
  if(!missing(dim)) {
    if(pos<=dim) {
      pos <- dim
    } else {
      warning("the value of `dim` is too small")
    }  
  }

  bin <- rep(0, pos)
  dicotomy <- rep(FALSE, pos)
  for (i in pos:1) {
    bin[i] <- floor(x/2^(i-1))
    dicotomy[i] <- bin[i]==1
    x <- x-((2^(i-1))*bin[i])
  }
  return(as.integer(bin))
}

'getOS' <- function() {
  
  os <- OT_OS_UNKNOWN
  osStr <- sessionInfo()$R.version$os

  # This is probably a bug-prone way to determine the OS...
  if( regexpr('.*(nux|nix|osx).*', osStr, TRUE)>0 ) {
    os <- OT_OS_LINUX
  } else if( regexpr('.*XP.*',   osStr)>0 ) {
    os <- OT_OS_WINXP
  } else if( regexpr('.*2000.*', osStr)>0 ) {
    os <- OT_OS_WIN2000
  } else if( regexpr('.*NT.*',   osStr)>0 ) {
    os <- OT_OS_WINNT
  } else if( regexpr('.*Mill.*', osStr)>0 ) {
    os <- OT_OS_WINME
  } else if( regexpr('.*98SE.*', osStr)>0 ) {
    os <- OT_OS_WIN98SE
  } else if( regexpr('.*98.*',   osStr)>0 ) {
    os <- OT_OS_WIN98
  } else if( regexpr('.*95.*',   osStr)>0 ) {
    os <- OT_OS_WIN95
  }
  return(os)
}
