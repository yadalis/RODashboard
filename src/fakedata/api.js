var jsonServer = require('json-server')

// Returns an Express server
var server = jsonServer.create()

// Set default middlewares (logger, static, cors and no-cache)
server.use(jsonServer.defaults())

//var router = jsonServer.router('src/fakedata/db.json')
//var router = jsonServer.router('src/fakedata/actionrequired.json')
//var router = jsonServer.router('src/fakedata/inprocess.json')
var router = jsonServer.router('src/fakedata/rodata.json')

server.use(router)

console.log('Listening at 5004')

server.listen(5004)