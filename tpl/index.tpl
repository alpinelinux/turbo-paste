<!DOCTYPE html>
<html>
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
    use <a href='data:text/html,<form action="{{{url}}}" method="POST" accept-charset="UTF-8"><textarea name="tpaste" cols="80" rows="24"></textarea><br><button type="submit">paste</button></form>'>this form</a> to paste from a browser

EXAMPLES
    ~$ cat bin/ching | curl -F 'tpaste=&lt;-' {{{url}}}
       {{{url}}}aXZI
    ~$ firefox {{{url}}}aXZI

SEE ALSO
    http://github.com/clandmeter

        </pre>
    </body>
</html>
