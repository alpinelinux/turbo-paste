<!DOCTYPE html>
<html lang="en">
    <head>
        <style> a { text-decoration: none } </style>
        <meta charset="UTF-8">
        <title>Turbo paste</title>
    </head>

    <body>
        <pre>
tpaste(1)                          TPASTE                          tpaste(1)

NAME
    tpaste: command line pastebin.

SYNOPSIS
    &lt;command&gt; | curl -F 'tpaste=&lt;-' {{{url}}}

DESCRIPTION
    use <a href='form'>this form</a> to paste from a browser
    add ?hl=true to resulting url for highlight.js syntax highlighting via cdnjs

EXAMPLES
    ~$ cat bin/ching | curl -F 'tpaste=&lt;-' {{{url}}}
       {{{url}}}aXZI
    ~$ firefox {{{url}}}aXZI

SEE ALSO
    http://github.com/alpinelinux/turbo-paste

        </pre>
    </body>
</html>
