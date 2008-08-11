'otConnect' <-
function(host='delayed1.opentick.com', port=10015,
         platform=OT$PLATFORM_OT, platformPassword='', ...) {

  # Make sure host/port args agree
  host <- match.arg(host, c('feed1.opentick.com','feed2.opentick.com',
                            'delayed1.opentick.com','delayed2.opentick.com'), several.ok=FALSE)
  
  if( !(regexpr('^[fF]',host) > 0 && port == 10010) &&
      !(regexpr('^[dD]',host) > 0 && port == 10015) )
    stop('\'host\' and \'port\' do not align')
  
  if(NROW(host)!=NROW(port)) {
    stop('\'host\' and \'port\' must have same length')
  }

  # Create connection parameters
  otPar <- getParams()
  otPar$host <- host
  otPar$port <- port
  otPar$platform <- platform
  otPar$platformPassword <- platformPassword

  # Get environment
  env <- as.environment("package:opentick")

  # Check if binding locked; unlock if needed
  locked <- bindingIsLocked('.otConnection', env)
  if(locked) {
    unlockBinding('.otConnection', env)
  }

  for(i in 1:NROW(host)) {
    if(inherits(try(
      assign('.otConnection',socketConnection(host[i], port[i], open='r+b', blocking=TRUE),env),
    silent=TRUE),'try-error')) {
      next
    } else {
      otPar$host <- host[i]
      otPar$port <- port[i]
      break
    }
  }
  setParams(otPar)
  
  # Re-lock, if needed
  if(locked) {
    suppressWarnings({
      lockBinding('.otConnection', env)
    })
  }

  return(invisible(1))
}

'otReconnect' <-
function() {
  
  # Try a request that *will* fail
  req <- cancelHistData(0, ok=1004)
  
  if(is.null(req)) {
    
    # Create connection parameters
    otPar <- getParams()

    otConnect()
    otLogin(otPar$username,otPar$password)
  
  } else {

    return(invisible())

  }
}

'.otAddHost' <-
function(host, port) {

  if( !(regexpr('^[fF]',host) > 0 && port == 10010) &&
      !(regexpr('^[dD]',host) > 0 && port == 10015) )
    stop('\'host\' and \'port\' do not align')
  
  x <- getParams()
  x$host <- c(host,x$host)
  x$port <- c(port,x$port)
  setParams(x)
}

# Actual Socket Connection
'.otConnection' <- list()

'getSocket' <- function() {
   x <- get('.otConnection',as.environment("package:opentick"))
}

# Socket Connection Parameters
'.otParams' <- list(
  host=NULL,
  port=NULL,
  redirect=FALSE,
  redirectHost=NULL,
  redirectPort=NULL,
  username='',
  password='',
  loggedIn=FALSE,
  sessionID='',
  requestID=0,
  platform=NULL,
  platformPassword=NULL)

'getParams' <- function() {
   x <- get('.otParams',as.environment("package:opentick"))
}

'setParams' <- function(x) {
  
  # Get environment
  env <- as.environment("package:opentick")
  environment(x) <- env

  # Check if binding locked; unlock if needed
  locked <- bindingIsLocked('.otParams', env)
  if(locked) {
    unlockBinding('.otParams', env)
  }
  
  # Assign new parameter to object
  #assign('.otParams', { otp <- get('.otParams'); otp[param] <- value; otp }, env )
  assign('.otParams', x, env)

  # Re-lock, if needed
  if(locked) {
    suppressWarnings({
      lockBinding('.otParams', env)
    })
   }
  return(invisible(1))
}
