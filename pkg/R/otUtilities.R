#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

'transmit' <-
function(connection, commandType, msgBody) {


  # Create Message Header
  # Message Type, Command Status, Reserved Bytes, Command Type, Request ID
  #msgHeader <- pack("C C x x V V", 1, 1, commandType, requestID)
  msgHeader <- pack("C C x x V V", 1, 1, commandType, 1)
  
  # Get Message Length
  msgLength <- pack("V",NROW(c(msgHeader,msgBody)))
  
  # Send Message
  writeBin(c(msgLength,msgHeader,msgBody), connection$connection)

  # Server Response Length
  resLength <- readBin(connection$connection, integer(), size=4)
  
  # Server Response Header
  # Message Type, Command Status, Reserved Bytes, Command Type, Request ID
  resHeader <- unpack('C C v V V', readBin(connection$connection, raw(), 12))
  
  # Server Response Body
  resBody <- readBin(connection$connection, raw(), resLength-12)

  result <- list(length=resLength,header=resHeader,body=resBody)
  return(result)
  #return(structure(result, class='otResponse'))
}

#'getMAC' <- function()

'getOS' <- function() {
  
  os <- OT$OS_UNKNOWN
  osStr <- sessionInfo()$R.version$os

  # This is probably a bug-prone way to determine the OS...
  # but it works for me ;)
  if( regexpr('.*(nux|nix|osx).*', osStr, TRUE)>0 ) {
    os <- OT$OS_LINUX
  } else if( regexpr('.*XP.*',   osStr)>0 ) {
    os <- OT$OS_WINXP
  } else if( regexpr('.*2000.*', osStr)>0 ) {
    os <- OT$OS_WIN2000
  } else if( regexpr('.*NT.*',   osStr)>0 ) {
    os <- OT$OS_WINNT
  } else if( regexpr('.*Mill.*', osStr)>0 ) {
    os <- OT$OS_WINME
  } else if( regexpr('.*98SE.*', osStr)>0 ) {
    os <- OT$OS_WIN98SE
  } else if( regexpr('.*98.*',   osStr)>0 ) {
    os <- OT$OS_WIN98
  } else if( regexpr('.*95.*',   osStr)>0 ) {
    os <- OT$OS_WIN95
  }
  return(os)
}

'numToRaw' <-
function(x, nBytes=1) {

  # from 'wle' package
  # Supporting function to convert numbers to a
  # raw vector of length 'nBytes'

  pos <- ifelse( x==0, 1, floor(log(x,2))+1 )
  if( pos <= nBytes*8 )
    pos <- nBytes*8
  else
    stop('the value of \"nBytes\" is too small')

  bin <- rep(0, pos)
  for( i in pos:1 ) {
    bin[i] <- floor(x/2^(i-1))
    x <- x-((2^(i-1))*bin[i])
  }
  return(packBits(as.integer(bin)))
}

'rawToNum' <-
function(x, nBytes=1) {
  
  # Supporting function to convert raw vectors
  # to numbers according to 'nBytes'

  i <- as.logical(rawToBits(x))
  num <- sum(2^.subset(0:(nBytes*8-1), i))

  return(num)
}

'pack' <-
function(template, ...) {

  # http://perldoc.perl.org/functions/pack.html
  
  template <- unlist(strsplit(template,"\\s"))
  values <- list(...)

  types <- gsub('[0-9]|\\*','',template)
  bytes <- gsub('[a-Z]','',template)
  bytes <- as.numeric( gsub('\\*','-1',bytes) )
  result <- NULL

  # Loop over template / value pairs
  shift <- 0
  for( i in 1:length(template) ) {
    type <- types[i]
    byte <- bytes[i]

    # A null byte
    if( type == 'x' ) {
      val <- as.raw(0)
      nul <- raw(0)
      shift <- shift + 1
    } else {
      value <- values[[i-shift]]
    }

    # A null padded string
    if( type == 'a' ) {
      # In the case of 'a*'
      if( byte == -1 ) {
        val <- charToRaw( value )
        nul <- raw(0)
      } else {
        if( nchar(value) > byte )
          stop(paste('list value (',value,') too large for template value',sep=''))
        val <- charToRaw( value )
        nul <- rep( as.raw(0), byte-nchar(value) )
      }
    } else
    # A space padded ASCII string
    if( type == 'A' ) {
      if( nchar(value) > byte )
        stop(paste('list value (',value,') too large for template value',sep=''))
      val <- charToRaw( value )
      nul <- rep( charToRaw(' '), byte-nchar(value) )
    } else
    # An unsigned char (octet) value.
    if( type == 'C' ) {
      val <- numToRaw( value, 1 )
      nul <- raw(0)
    } else
    # An unsigned short (16-bit) in "VAX" (little-endian) order.
    if( type == 'v' ) {
      val <- numToRaw( value, 2 )
      nul <- raw(0)
    } else
    # An unsigned long (32-bit) in "VAX" (little-endian) order.
    if( type == 'V' ) {
      val <- numToRaw( value, 4 )
      nul <- raw(0)
    }
    
    # Combine result
    result <- c(result,val,nul)
  }
  return(result)
}

'unpack' <-
function(template, values) {

  # http://perldoc.perl.org/functions/unpack.html
  
  template <- unlist(strsplit(template,"\\s"))

  types <- gsub('[0-9]|\\*','',template)
  bytes <- gsub('[a-Z]|/','',template)
  bytes <- gsub('\\*','-1',bytes)
  bytes <- as.numeric(bytes)
  result <- NULL
  
  # Loop over template / value pairs
  for( i in 1:length(template) ) {
    type <- types[i]
    byte <- bytes[i]

    # A null byte
    if( type == 'x' ) {
      val <- list(NULL)
      values <- values[-1]
    }

    # A null padded string
    if( type == 'a' ) {
      # In the case of 'a*'
      if( byte == -1 ) {
        val <- values
      } else {
        if( byte > length(values) )
          stop('template too long for values')
        val <- values[1:byte]
        values <- values[-(1:byte)]
      }
    } else
    # A space padded ASCII string
    if( type == 'A' ) {
      if( byte > length(values) )
        stop('template too long for values')
      val <- rawToChar( values[1:byte] )
      values <- values[-(1:byte)]
    } else
    # An unsigned char (octet) value.
    if( type == 'C' ) {
      val <- as.integer( values[1] )
      values <- values[-1]
    } else
    # An unsigned short (16-bit) in "VAX" (little-endian) order.
    if( type == 'v' ) {
      val <- rawToNum( values[1:2], 2 )
      values <- values[-(1:2)]
    } else
    # An unsigned long (32-bit) in "VAX" (little-endian) order.
    if( type == 'V' ) {
      val <- rawToNum( values[1:4], 4 )
      values <- values[-(1:4)]
    } else
    # Packed item count followed by packed items
    if( regexpr('/',type) ) {
      seq <- unlist(strsplit(type,'/'))
      num <- unpack(paste(seq[1],'a*'), values)
      val <- unpack(paste(seq[2],num[[1]],' a*',sep=''),num[[2]])
      values <- val[[2]]
      val <- unlist(val[[1]])
    }
    
    # Combine result
    result <- c(result,list(val))
  }
  return(result)
}
