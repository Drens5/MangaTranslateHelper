# MangaTranslateHelper
Put your apikey in configuration/apikey.txt, like the example with dummy apikey shows.

Specify in configuration/requestdata.txt the remote urls to read the pictures from and the
names (filepaths) under which you want their results to be saved, like the example provided
(that is on each line: first the name (filepath), then whitespace, then the url).
Remark: the paths are relative to the response folder, so after
running a request your results will be in that folder.
Remark 2: the name (filepath) may not contain whitespaces.

Move to the MangaTranslateHelper directory.

Build with stack: stack build.

Run the executable: stack exec MangaTranslateHelper-exe (or run main from within stack ghci).

The responses will be in the response folder.


For debugging a request: one can run singleUrlRequestRawResponse "remote/url" from within (the REPL) stack ghci
to see the full json response for the request to that remote url. The response is written to response/response.txt.