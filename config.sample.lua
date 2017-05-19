-- configuration
-- salt: used to create a hash based on current counter
-- url: the url to access the appliation
-- port: the port number use by turbo http server
-- address: ip or hostname to listen on
-- templates: templates directory
-- kwargs: arguments passed on to HTTPServer
-- kwargs: max_body_size: set the maximum paste size
-- redis: table with redis settings (see lua-redis for options)

return {
    salt = "CHANGE ME!",
    url = "http://172.16.3.80:8888/",
    port = 8888,
    address = "0.0.0.0",
    templates = "./tpl",
    kwargs = {
        max_body_size=1024*1024*1
    },
    redis = {
        host = "127.0.0.1",
        port = 6379
    }
}
