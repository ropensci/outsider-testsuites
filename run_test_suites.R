start_time <- Sys.time()
cat(cli::rule(), '\n')
cat('Running test suites (' , as.character(start_time), ') ....\n', sep = '')
cat(cli::rule(), '\n')
suite_paths <- list.dirs(path = getwd(), recursive = FALSE)
suite_paths <- suite_paths[grepl(pattern = 'suite', x = basename(suite_paths))]
suite_paths <- sort(suite_paths)
res <- NULL
for (suite_path in suite_paths) {
  cat('.... ', crayon::green(basename(suite_path)), '\n', sep = '')
  script <- file.path(suite_path, 'script.R')
  if (file.exists(script)) {
    suite_env <- new.env()
    temp_res <- tryCatch(expr = {
      source(file = script, echo = FALSE, local = suite_env, print.eval = TRUE)
      TRUE
      }, error = function(e) {
        message(e)
        FALSE
      }
      # Windows raises warning during `untar`
      #, warning = function(e) {
      #  message(e)
      #  FALSE
      #}
      )
    res <- c(res, temp_res)
  } else {
    cat('.... no `script.R` found -- skipping\n')
  }
}
end_time <- Sys.time()
duration <- difftime(end_time, start_time, units = 'mins')
cat('Complete. Duration: ', crayon::red(round(x = duration, digits = 3)),
    ' minutes.\n')
cat(cli::rule(), '\n')
if (sum(res) != length(res)) {
  stop('Fail: Not all test suites completed successfully.', call. = FALSE)
}
