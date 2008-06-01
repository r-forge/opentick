'print.otConnection' <-
function(x, ...) {
  cat(#' connection:\n',
      #'   open: ', summary(x$connection)$opened=='opened', '\n',
      #'   read: ', summary(x$connection)$'can read'=='yes', '\n',
      #'   write:', summary(x$connection)$'can write'=='yes', '\n',
      ' host:', x$host, '\n',
      'port:', x$port, '\n',
      'platform:', x$platform, '\n',
      'platformPassword:', x$platformPassword, '\n',
      'loggedIn:', x$loggedIn, '\n')
}

'str.otConnection' <-
function(object, ...) {
  utils:::str.default(object)
}
