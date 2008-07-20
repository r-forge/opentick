'otConnect' <-
function(host='delayed1.opentick.com', port=10015,
         login=FALSE, open=TRUE,
         platform=OT$PLATFORM_OT, platformPassword='', ...) {

  # Add capability for connection to contain multiple hosts.  Then you can
  # try the other hosts if one fails.
  
  # Open connection
  con <- socketConnection(host[1], port, open='r+b', blocking=TRUE)

  if(login) {
    stop('This feature not currently implemented')
  } else {
    username <- ''
    password <- ''
    requestID <- 0
  }
  
  # Return connection object
  structure(list(connection=con,
                 host=host,
                 port=port,
                 platform=platform,
                 platformPassword=platformPassword,
                 username=username,
                 password=password,
                 loggedIn=login,
                 requestID=requestID),
            class=c('otConnection'))
}
