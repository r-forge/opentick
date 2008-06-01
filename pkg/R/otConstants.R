#-------------------------------------------------------------------------#
# TTR, copyright (C) Joshua M. Ulrich, 2007-2008                          #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

# Contains constants for R API

# Message for successful stream data cancellation
OT_CANCEL_MESSAGE = "Request canceled";

# Version of protocol used by API
# 2 bytes
OT_PROTOCOL_VER = 2;

# OT message types
# 4 bytes
OT_MES_REQUEST  = 1; # Request to the server
OT_MES_RESPONSE = 2; # Response from the server

# message codes
OT_MSG_END_OF_DATA    = 10; # End of data
OT_MSG_END_OF_REQUEST = 20; # Confirmation of the cancel command

# OT command status
# 1 byte
OT_STATUS_OK    = 1; # Successful command status
OT_STATUS_ERROR = 2; # Error command status

# API status
OT_STATUS_INACTIVE   = 1; # API state: the client is inactive
OT_STATUS_CONNECTING = 2; # API state: the client is trying to connect
OT_STATUS_CONNECTED  = 3; # API state: the client is connected, but still not logged in
OT_STATUS_LOGGED_IN  = 4; # API state: the client is logged in

# Symbol types
OT_INSTRUMENT_STOCK  = 1; # STOCK symbol type
OT_INSTRUMENT_INDEX  = 2; # INDEX symbol type
OT_INSTRUMENT_FUTURE = 4; # FUTURE symbol type
OT_INSTRUMENT_OPTION = 3; # OPTION symbol type

# Tick types
OT_TICK_TYPE_QUOTE   = 1;  # Quote tick type
OT_TICK_TYPE_MMQUOTE = 2;  # MMQuote tick type
OT_TICK_TYPE_TRADE   = 3;  # Trade tick type
OT_TICK_TYPE_BBO     = 4;  # BBO

# Mask types
# 4 bytes
OT_MASK_TYPE_QUOTE   = 1;  # Quote tick type
OT_MASK_TYPE_MMQUOTE = 2;  # MMQuote tick type
OT_MASK_TYPE_TRADE   = 4;  # Trade tick type
OT_MASK_TYPE_BBO     = 8;  # BBO
OT_MASK_TYPE_LEVEL1  = 13; # Level1 data
OT_MASK_TYPE_LEVEL2  = 2;  # Level2 data
OT_MASK_TYPE_BOTH    = 15; # Both levels data
OT_MASK_TYPE_ALL     = 15; # All data

# Book types
# 4 bytes
OT_BOOK_TYPE_CANCEL  = 5;  # Cancel book type
OT_BOOK_TYPE_CHANGE  = 6;  # Change book type
OT_BOOK_TYPE_DELETE  = 7;  # Delete book type
OT_BOOK_TYPE_EXECUTE = 8;  # Execute book type
OT_BOOK_TYPE_ORDER   = 9;  # Order book type
OT_BOOK_TYPE_LEVEL   = 10; # Price level book type
OT_BOOK_TYPE_PURGE   = 11; # Purge book type
OT_BOOK_TYPE_REPLACE = 12; # Replace book level

# Delete types
OT_DELETE_TYPE_ORDER    = "1"; # Delete the referenced order
OT_DELETE_TYPE_PREVIOUS = "2"; # Remove the order and all orders on that side to the top of book
OT_DELETE_TYPE_ALL      = "3"; # Remove all orders in the book on that side
OT_DELETE_TYPE_AFTER    = "A"; # Remove the order and all orders on that side to the bottom of the book

# Flag Types
OT_FLAG_OPEN	      = 1; # Open
OT_FLAG_HIGH	      = 2; # High
OT_FLAG_LOW	      = 4; # Low
OT_FLAG_CLOSE	      = 8; # Close
OT_FLAG_UPDATE_LAST  = 16; # Update last
OT_FLAG_UPDATE_VOLUME= 32; # Update volume
OT_FLAG_CANCEL       = 64; # Cancel
OT_FLAG_FROM_BOOK    = 128; # From book

# Request history data type codes
# 1 byte
OT_HIST_RAW_TICKS       = 1; # All tick data for specified period
OT_HIST_OHLC_TICK_BASED = 2; # Tick based OHLC data for specified period
OT_HIST_OHLC_MINUTELY   = 3; # Minutely OHLC data for specified period
OT_HIST_OHLC_HOURLY     = 4; # Hourly OHLC data for specified period
OT_HIST_OHLC_DAILY      = 5; # Daily OHLC data for specified period
OT_HIST_OHLC_WEEKLY     = 6; # Weekly OHLC data for specified period
OT_HIST_OHLC_MONTHLY    = 7; # Monthly OHLC data for specified period
OT_HIST_OHLC_YEARLY     = 8; # Yearly OHLC data for specified period
OT_HIST_OHL_TODAY       = 9; # Today's OHL data

# Response history data type codes
OT_HIST_CODE_EOD          = 0;  # End of data
OT_HIST_CODE_TICK_QUOTE   = 1;  # Quote tick data
OT_HIST_CODE_TICK_MMQUOTE = 2;  # MMQoute tick data
OT_HIST_CODE_TICK_TRADE   = 3;  # Trade tick data
OT_HIST_CODE_TICK_BBO     = 4;  # BBO tick data
OT_HIST_CODE_OHLC         = 50; # OHLC data
OT_HIST_CODE_OHL_TODAY    = 51; # Today's OHL data

# OT command type
# 4 bytes
OT_INT_UNKNOWN            = 0;  # Unknow command
OT_LOGIN                  = 1;  # Login command
OT_LOGOUT                 = 2;  # Logout command
OT_REQUEST_TICK_STREAM    = 3;  # Create tick stream command
OT_REQUEST_TICK_STREAM_EX = 15; # Create tick stream extended
OT_CANCEL_TICK_STREAM     = 4;  # Cancel tick stream command
OT_REQUEST_HIST_DATA      = 5;  # Create history stream command
OT_REQUEST_HIST_TICKS     = 17;
OT_CANCEL_HIST_DATA       = 6;  # Cancel history stream command
OT_REQUEST_LIST_EXCHANGES = 7;  # Request exchanges list command
OT_REQUEST_LIST_SYMBOLS   = 8;  # Request symbols list command
OT_HEARTBEAT              = 9;  # Heartbeat
OT_REQUEST_EQUITY_INIT    = 10; # Request EquityInit
OT_REQUEST_OPTION_CHAIN   = 11;
OT_REQUEST_OPTION_CHAIN_EX= 16;
OT_CANCEL_OPTION_CHAIN    = 12;
OT_REQUEST_BOOK_STREAM	  = 13; # Request Book stream
OT_CANCEL_BOOK_STREAM     = 14; # Cancel Book stream

# Error types
# 2 bytes
OT_ERR_OPENTICK           = 1000; # Opentick error
OT_ERR_SYSTEM             = 2000; # System error
OT_ERR_SOCK               = 3000; # Network error

# OT (server) error codes
# 2 bytes
OT_ERR_BAD_LOGIN         = 1001; # Bad login error
OT_ERR_NOT_LOGGED_IN     = 1002; # Not logged in error
OT_ERR_NO_DATA           = 1003; # No tick data error
OT_ERR_INVALID_CANCEL_ID = 1004; # Bad cancel tick stream ID error
OT_ERR_INVALID_INTERVAL  = 1005; # Invalid history interval error
OT_ERR_NO_LICENSE        = 1006; # No license error
OT_ERR_LIMIT_EXCEEDED    = 1007; # Limit of symbols exceeded error
OT_ERR_DUPLICATE_REQUEST = 1008; # Duplicate request error
OT_ERR_INACTIVE_ACCOUNT  = 1009; # Inactive account error
OT_ERR_LOGGED_IN         = 1010; # Already logged in error (for login command)
OT_ERR_BAD_REQUEST       = 1011; # Bad request error
OT_ERR_NO_HIST_PACKAGE   = 1012; # No subscription on history package
OT_ERR_SERVER_ERROR      = 2002; # Server error
OT_ERR_CANNOT_CONNECT    = 2003; # Cannot connect to the server
OT_ERR_BROKEN_CONNECTION = 2004; # The connection has been broken
OT_ERR_NO_THREAD         = 2005; # Cannot create thread
OT_ERR_NO_SOCKET         = 2006; # Cannot initialize socket

# Operational Systems IDs
# 1 byte
OT_OS_UNKNOWN = 1;  # Unknown
OT_OS_WIN95   = 2;  # Windows 95
OT_OS_WIN98   = 3;  # Windows 98
OT_OS_WIN98SE = 4;  # Windows 98SE
OT_OS_WINME   = 5;  # Windows Milleniem
OT_OS_WINNT   = 6;  # Windows NT
OT_OS_WIN2000 = 7;  # Windows 2000
OT_OS_WINXP   = 8;  # Windows XP
OT_OS_LINUX   = 20; # Linux

# Platform IDs
# 1 byte
OT_PLATFORM_OT          = 1; # opentick
OT_PLATFORM_WEALTHLAB   = 3; # WealthLab
OT_PLATFORM_QUANTSTUDIO = 2; # QuantStudio

