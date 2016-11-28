console.log("project is running");

var express = require('express');
var app = express();

const path = require('path');
const fs = require('fs');
const junk = require('junk');
const NodeCache = require( "node-cache" );
const myCache = new NodeCache( { stdTTL: 100, checkperiod: 120 } );
const playlistFolder = "./playlistcenter/shuffle";


//Welcome route
app.get('/', function(req, res) {
	console.log('Welcome to MusicCenter!');
	res.send('Welcome to MusicCenter!');
});

//Playlist route : GET for all track
app.get('/playlist', function(req, res) {
	//Read available local file
	readFile (playlistFolder,res);
});

//Playlist route : GET for a track
app.get('/playlist/:name', function(req, res) {

	console.log("Looking for track : "+playlistFolder+"/"+req.params.name);

	//Use NodeCache package for keeping data in memory
	myCache.get( req.params.name, function( err, value ){
	//If no KEY is found for cache, download data from local file
	  if( !err ){
	    if(value == undefined){
	      downloadFile(req.params.name,res);
	    }else{
	      console.log("GET cache file");
	      //Return data for cache KEY
	      res.json(value);
	    }
	  }
	});
	
});

//Server listen on port 8000
app.listen(8000, function() {
	console.log('listening on 8000');
});


function readFile(folder,response){	
	
	var jsonList = {"list":[]};
	
	//Read asynchronously in directory 
	fs.readdir(folder,function (err, files){	
	
	console.log("Reading in music folder filtered : " + files.filter(junk.not));
	
	//remove unnecessary files from directory : file system .DS_Store
		//encoder(files.filter(junk.not));
		
		var filteredFile = files.filter(junk.not);

		for (var i = 0; i < filteredFile.length; i++) {
			jsonList["list"].push({	
			'm_id': i+1,
			'm_name': filteredFile[i].substring(0, filteredFile[i].lastIndexOf("."))
			});
		};
		response.json(jsonList);
	});
}

//Read file and encode in Base64
function downloadFile(file,response){	
	var jsonList = {"list":[]};
	var downloadPath = playlistFolder+"/"+file+".mp3";
	var musicFile = fs.readFileSync(downloadPath);
	console.log("The file to download : " + downloadPath);
	var encodedFile = new Buffer(musicFile).toString("base64");
	jsonList["list"].push({	
		'm_id': 0,
		'm_name': file,
		'm_data' : encodedFile
	});

	//Put downloaded file data in cache memory with file name as KEY
	myCache.set( file, jsonList, function( err, success ){
	  if( !err && success ){
	    console.log( "File is set in cache memory : " + success );
	  }
});

	response.json(jsonList);
}
