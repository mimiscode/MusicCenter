console.log("project is running");

var express = require('express');
var app = express();

const path = require('path');
const fs = require('fs');
const junk = require('junk');
const playlistFolder = "./playlistcenter/cat";


app.get('/', function(req, res) {
	console.log('Welcome to MusicCenter!');
	res.send('Welcome to MusicCenter!');
});


app.get('/playlist', function(req, res) {

	readFile (playlistFolder,encoder,res);
	//res.send({"hello" :"hello"});
});

app.get('/playlist/:name', function(req, res) {

	var trackId = req.params.name;
	res.send("Track id :" + trackId);

});

app.listen(8000, function() {
	console.log('listening on 8000');
});


function readFile(folder, encoder, response){	
	var jsonList = {"list":[]};
	var encodedFile;
	fs.readdir(folder,function (err, files){	
	console.log("Reading in music folder filtered : " + files.filter(junk.not));
	//remove unnecessary files from directory : file system .DS_Store
		//encoder(files.filter(junk.not));
		
		var filteredFile = files.filter(junk.not);
		encodedFile = encoder(filteredFile);

		for (var i = 0; i < encodedFile.length; i++) {
			jsonList["list"].push({	
			'm_id':i+1,
			'm_data' : encodedFile[i]
			});
		};
		//response.json({"hello" :"hello"});
		//response.json({"list" : [{"hello":"hello"},{"hello":"hello"}]});
		response.json(jsonList);
		//response.end();
	});
}

function encoder(filteredFile){
	
	var musicArray = [];

	for (var i = 0; i < filteredFile.length; i++) {
		//console.log(filteredFile[i]);
		var file = playlistFolder+"/"+filteredFile[i];
		var musicFile = fs.readFileSync(file);
		console.log(musicFile);
		base64File = new Buffer(musicFile).toString("base64");
		//console.log(base64File);
		//var dataFormatted = util.format("data:%s;base64,%s", mime.lookup(musicFolder), base64File);
		//console.log(dataFormatted);
		musicArray.push(base64File);

	}
	
	return musicArray;

}
