var http = require('http');var server = http.createServer();var url = require('url');var wines = require('./routes/wines');var io = require('socket.io')(server);var wineAddon = require('bindings')('wineAddon.node');server.listen(3000);console.log('Listening on port 3000...');server.on('request', function(req, res) {          console.log("Method %s %s", req.method, req.url);          if (req.method === 'GET' && req.url === '/wines')          {                var body = wines.getAll();                console.log("Data: %s", body);                res.writeHead(200, {                            'Content-Length': body.length,                            'Content-Type': 'application/json' });                res.write(body);          }          else if (req.method === 'POST' && req.url === '/wines')          {              var body = '';                        req.on('data', function(data) {                     console.log("Raw Data: " + data);                     body += data.toString();                     });                            req.on('end', function () {                     var start = body.indexOf("{");                     var end = body.indexOf("}");                     var wineJsonData = body.substr(start, (end - start) + 1);                     wineJsonData = wineJsonData.replace(/^\s+|\s+$/gm,'');                     wineJsonData = wineJsonData.replace(/\n/g, '');                     wineJsonData = wineJsonData.replace(/ /g, '');                     wineData = JSON.parse(wineJsonData);                     console.log("Wine Data: " + wineJsonData);                     var done = wines.addWine(wineData);                                          res.writeHead(200, {                                   'Content-Length': wineJsonData.length,                                   'Content-Type': 'application/json' });                     res.write(wineJsonData);                     });          }});server.on('end', function () {          console.log("Done");});server.on('error', function(err) {          console.log('problem with request: ' + err.message);});io.on('connection', function(socket){      console.log("Connected");            //recieve AddWine data      socket.on('AddWine', function(data){                console.log("Socket IO Wine Add: " + data);                var done = wines.addWine(data);                socket.emit('OnWineAdded', data);                });            // Test wine c file      socket.on('WineSelected', function(data){                console.log("Wine Selected: " + data);                var message = wineAddon.getMessage();                socket.emit('OnWineSelected', message);                });      });