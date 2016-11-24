function readFile(folder, encoder, response){	
	var jsonList = [];
	var encodedFile;
	fs.readdir(folder,function (err, files){	
	console.log("Reading in music folder filtered : " + files.filter(junk.not));
	//remove unnecessary files from directory : file system .DS_Store
		//encoder(files.filter(junk.not));
		
		var filteredFile = files.filter(junk.not);
		encodedFile = encoder(filteredFile);

		for (var i = 0; i < encodedFile.length; i++) {
			jsonList.push({	
			'm_id':i+1,
			'm_data' : encodedFile[i]
			});
		};
		response.json(jsonList);
		response.end();
	});
}

function sendData (musicData) {

	//console.log(musicData.length);
	var musicList = [];
	
	for (var i = 0; i < musicData.length; i++) {
		musicList.push({
			'm_id':i+1,
			'm_data' : musicData[i]
		});
	};
	var list = JSON.stringify(musicList);
	//console.log(list);

	return list;
}

function streamRead() {
	var filePath = path.join("./music","song1.mp3");
	var stat = fs.statSync(filePath);
	console.log(filePath + "\n" + stat.size);
	res.writeHeader(200, {
		'Content-Type' : 'audio/mpeg',
		'Content-Size' : stat.size
	});

	/*var readStream = fs.createReadStream(filePath);
	readStream.pipe(res);*/

	fs.createReadStream(filePath).pipe(binarysplit()).on('data', function (line) {
  		//console.log(line);
  		base64File = new Buffer(line).toString("base64");
  		console.log(base64File+"\n\n\n");
	});
}