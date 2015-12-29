var wines = require('./routes/wines');
var wineAddon = require('bindings')('wineAddon');

// Register AddWine method so we can call it from native side
Mobile('AddWine').register(function(wine){
                           console.log("Socket IO Wine Add: " + wine);
                           var done = wines.addWine(wine);
                           Mobile('OnWineAdded').call(wine);
                           });

// Register WineSelected method so we can call it from native side
Mobile('WineSelected').register(function(wine){
                                console.log("Wine Selected: " + data);
                                var message = wineAddon.getMessage();
                                Mobile('OnWineSelected').call(message);
                                });