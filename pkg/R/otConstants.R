#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

# Contains opentick protocol constants
OT <- list()

# Message for successful stream data cancellation
OT$CANCEL_MESSAGE <- "Request canceled"

# Version of protocol used by API
# 2 bytes
OT$PROTOCOL_VER <- 2

# OT message types
# 4 bytes
OT$MES_REQUEST  <- 1 # Request to the server
OT$MES_RESPONSE <- 2 # Response from the server

# message codes
OT$MSG_END_OF_DATA    <- 10 # End of data
OT$MSG_END_OF_REQUEST <- 20 # Confirmation of the cancel command

# OT command status
# 1 byte
OT$STATUS_OK    <- 1 # Successful command status
OT$STATUS_ERROR <- 2 # Error command status

# API status
OT$STATUS_INACTIVE   <- 1 # API state: the client is inactive
OT$STATUS_CONNECTING <- 2 # API state: the client is trying to connect
OT$STATUS_CONNECTED  <- 3 # API state: the client is connected, but still not logged in
OT$STATUS_LOGGED_IN  <- 4 # API state: the client is logged in

# Symbol types
OT$INSTRUMENT_STOCK  <- 1 # STOCK symbol type
OT$INSTRUMENT_INDEX  <- 2 # INDEX symbol type
OT$INSTRUMENT_FUTURE <- 4 # FUTURE symbol type
OT$INSTRUMENT_OPTION <- 3 # OPTION symbol type

# Tick types
OT$TICK_TYPE_QUOTE   <- 1  # Quote tick type
OT$TICK_TYPE_MMQUOTE <- 2  # MMQuote tick type
OT$TICK_TYPE_TRADE   <- 3  # Trade tick type
OT$TICK_TYPE_BBO     <- 4  # BBO

# Mask types
# 4 bytes
OT$MASK_TYPE_QUOTE   <- 1  # Quote tick type
OT$MASK_TYPE_MMQUOTE <- 2  # MMQuote tick type
OT$MASK_TYPE_TRADE   <- 4  # Trade tick type
OT$MASK_TYPE_BBO     <- 8  # BBO
OT$MASK_TYPE_LEVEL1  <- 13 # Level1 data
OT$MASK_TYPE_LEVEL2  <- 2  # Level2 data
OT$MASK_TYPE_BOTH    <- 15 # Both levels data
OT$MASK_TYPE_ALL     <- 15 # All data

# Book types
# 4 bytes
OT$BOOK_TYPE_CANCEL  <- 5  # Cancel book type
OT$BOOK_TYPE_CHANGE  <- 6  # Change book type
OT$BOOK_TYPE_DELETE  <- 7  # Delete book type
OT$BOOK_TYPE_EXECUTE <- 8  # Execute book type
OT$BOOK_TYPE_ORDER   <- 9  # Order book type
OT$BOOK_TYPE_LEVEL   <- 10 # Price level book type
OT$BOOK_TYPE_PURGE   <- 11 # Purge book type
OT$BOOK_TYPE_REPLACE <- 12 # Replace book level

# Delete types
OT$DELETE_TYPE_ORDER    <- "1" # Delete the referenced order
OT$DELETE_TYPE_PREVIOUS <- "2" # Remove the order and all orders on that side to the top of book
OT$DELETE_TYPE_ALL      <- "3" # Remove all orders in the book on that side
OT$DELETE_TYPE_AFTER    <- "A" # Remove the order and all orders on that side to the bottom of the book

# Flag Types
OT$FLAG_OPEN	      <- 1 # Open
OT$FLAG_HIGH	      <- 2 # High
OT$FLAG_LOW	      <- 4 # Low
OT$FLAG_CLOSE	      <- 8 # Close
OT$FLAG_UPDATE_LAST  <- 16 # Update last
OT$FLAG_UPDATE_VOLUME<- 32 # Update volume
OT$FLAG_CANCEL       <- 64 # Cancel
OT$FLAG_FROM_BOOK    <- 128 # From book

# Request history data type codes
# 1 byte
OT$HIST_RAW_TICKS       <- 1 # All tick data for specified period
OT$HIST_OHLC_TICK_BASED <- 2 # Tick based OHLC data for specified period
OT$HIST_OHLC_MINUTELY   <- 3 # Minutely OHLC data for specified period
OT$HIST_OHLC_HOURLY     <- 4 # Hourly OHLC data for specified period
OT$HIST_OHLC_DAILY      <- 5 # Daily OHLC data for specified period
OT$HIST_OHLC_WEEKLY     <- 6 # Weekly OHLC data for specified period
OT$HIST_OHLC_MONTHLY    <- 7 # Monthly OHLC data for specified period
OT$HIST_OHLC_YEARLY     <- 8 # Yearly OHLC data for specified period
OT$HIST_OHL_TODAY       <- 9 # Today's OHL data

# Response history data type codes
OT$HIST_CODE_EOD          <- 0  # End of data
OT$HIST_CODE_TICK_QUOTE   <- 1  # Quote tick data
OT$HIST_CODE_TICK_MMQUOTE <- 2  # MMQoute tick data
OT$HIST_CODE_TICK_TRADE   <- 3  # Trade tick data
OT$HIST_CODE_TICK_BBO     <- 4  # BBO tick data
OT$HIST_CODE_OHLC         <- 50 # OHLC data
OT$HIST_CODE_OHL_TODAY    <- 51 # Today's OHL data

# OT command type
# 4 bytes
OT$INT_UNKNOWN            <- 0  # Unknown command
OT$LOGIN                  <- 1  # Login command
OT$LOGOUT                 <- 2  # Logout command
OT$REQUEST_TICK_STREAM    <- 3  # Create tick stream command
OT$REQUEST_TICK_STREAM_EX <- 15 # Create tick stream extended
OT$CANCEL_TICK_STREAM     <- 4  # Cancel tick stream command
OT$REQUEST_HIST_DATA      <- 5  # Create history stream command
OT$REQUEST_HIST_TICKS     <- 17
OT$CANCEL_HIST_DATA       <- 6  # Cancel history stream command
OT$REQUEST_LIST_EXCHANGES <- 7  # Request exchanges list command
OT$REQUEST_LIST_SYMBOLS   <- 8  # Request symbols list command
OT$HEARTBEAT              <- 9  # Heartbeat
OT$REQUEST_EQUITY_INIT    <- 10 # Request EquityInit
OT$REQUEST_OPTION_CHAIN   <- 11
OT$REQUEST_OPTION_CHAIN_EX<- 16
OT$CANCEL_OPTION_CHAIN    <- 12
OT$REQUEST_BOOK_STREAM	  <- 13 # Request Book stream
OT$CANCEL_BOOK_STREAM     <- 14 # Cancel Book stream

# Error types
# 2 bytes
OT$ERR_OPENTICK           <- 1000 # Opentick error
OT$ERR_SYSTEM             <- 2000 # System error
OT$ERR_SOCK               <- 3000 # Network error

# OT (server) error codes and descriptions
# 2 bytes
OT$ERR_INCORRECT_LOGIN    <- list(value=1001, desc='Incorrect login (username and/or password); or already logged in.')
OT$ERR_NOT_LOGGED_IN      <- list(value=1002, desc='You are not logged in.')
OT$ERR_NO_DATA            <- list(value=1003, desc='The requested data does not exist.')
OT$ERR_INVALID_CANCEL_ID  <- list(value=1004, desc='Invalid ID in cancel request.')
OT$ERR_INVALID_INTERVAL   <- list(value=1005, desc='Invalid interval type or value of request for historical data.')
OT$ERR_NO_LICENSE         <- list(value=1006, desc='You do not have a license to request real-time data from the specified exchange.')
OT$ERR_LIMIT_EXCEEDED     <- list(value=1007, desc='Your symbol limit has been exceeded.')
OT$ERR_DUPLICATE_REQUEST  <- list(value=1008, desc='You have requested this tick stream already.')
OT$ERR_INACTIVE_ACCOUNT   <- list(value=1009, desc='Your account is inactive.')
OT$ERR_LOGGED_IN          <- list(value=1010, desc='You are already logged in.')
OT$ERR_BAD_REQUEST        <- list(value=1011, desc='Parameters of the request are incorrect.')
OT$ERR_NO_HIST_PACKAGE    <- list(value=1012, desc='You are not subscribed to a historical data package.')
OT$ERR_NO_SOCKETS_DLL     <- list(value=2001, desc='Cannot initialize WinSockets library.')
OT$ERR_SERVER_ERROR       <- list(value=2002, desc='Server error.')
OT$ERR_CANNOT_CONNECT     <- list(value=2003, desc='Cannot connect to the server.')
OT$ERR_BROKEN_CONNECTION  <- list(value=2004, desc='The connection has been broken.')
OT$ERR_NO_THREAD          <- list(value=2005, desc='Cannot create thread.')
OT$ERR_NO_SOCKET          <- list(value=2006, desc='Cannot initialize socket.')
OT$ERR_RECIEVE            <- list(value=3001, desc='Error occured while recieving: probably connection related.')


# Operational Systems IDs
# 1 byte
OT$OS_UNKNOWN <- 1  # Unknown
OT$OS_WIN95   <- 2  # Windows 95
OT$OS_WIN98   <- 3  # Windows 98
OT$OS_WIN98SE <- 4  # Windows 98SE
OT$OS_WINME   <- 5  # Windows Milleniem
OT$OS_WINNT   <- 6  # Windows NT
OT$OS_WIN2000 <- 7  # Windows 2000
OT$OS_WINXP   <- 8  # Windows XP
OT$OS_LINUX   <- 20 # Linux

# Platform IDs
# 1 byte
OT$PLATFORM_OT          <- 1 # opentick
OT$PLATFORM_WEALTHLAB   <- 3 # WealthLab
OT$PLATFORM_QUANTSTUDIO <- 2 # QuantStudio

