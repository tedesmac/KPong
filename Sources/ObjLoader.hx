/*
	Improved version of ObjLoader.hx by LubosLenco
*/

package ;


class ObjLoader{


	public var data:Array<Float>;
	public var indices:Array<Int>;
	public var structureLength:Int;

	var hasUVs = false;

	static var indexedVertices:Array<Float>;
	static var indexedUVs:Array<Float>;
	static var indexedNormals:Array<Float>;
	static var index:Int;


	public function new(objData:String){

		var vertices:Array<Float> = [];
		var uvs:Array<Float> = [];
		var normals:Array<Float> = [];

		var vertexIndices:Array<Int> = [];
		var uvIndices:Array<Int> = [];
	   	var normalIndices:Array<Int> = [];

		var tempVertices:Array<Array<Float>> = [];
		var tempUVs:Array<Array<Float>> = [];
		var tempNormals:Array<Array<Float>> = [];

		var lines:Array<String> = objData.split("\n");

		for(i in 0...lines.length){

			var words:Array<String> = lines[i].split(" ");

			if(words[0] == "v"){
				var vector:Array<Float> = [];
				vector.push(Std.parseFloat(words[1]));
				vector.push(Std.parseFloat(words[2]));
				vector.push(Std.parseFloat(words[3]));
				tempVertices.push(vector);
			}
			else if(words[0] == "vt"){
				hasUVs = true;
				var vector:Array<Float> = [];
				vector.push(Std.parseFloat(words[1]));
				vector.push(Std.parseFloat(words[2]));
				tempUVs.push(vector);
			}
			else if(words[0] == "vn"){
				var vector:Array<Float> = [];
				vector.push(Std.parseFloat(words[1]));
				vector.push(Std.parseFloat(words[2]));
				vector.push(Std.parseFloat(words[3]));
				tempNormals.push(vector);
			}
			else if(words[0] == "f"){
				if(hasUVs){
					var sec1:Array<String> = words[1].split("/");
					var sec2:Array<String> = words[2].split("/");
					var sec3:Array<String> = words[3].split("/");

					vertexIndices.push(Std.parseInt(sec1[0]));
					vertexIndices.push(Std.parseInt(sec2[0]));
					vertexIndices.push(Std.parseInt(sec3[0]));

					uvIndices.push(Std.parseInt(sec1[1]));
					uvIndices.push(Std.parseInt(sec2[1]));
					uvIndices.push(Std.parseInt(sec3[1]));

					normalIndices.push(Std.parseInt(sec1[2]));
					normalIndices.push(Std.parseInt(sec2[2]));
					normalIndices.push(Std.parseInt(sec3[2]));
				}
				else{
					var sec1:Array<String> = words[1].split("//");
					var sec2:Array<String> = words[2].split("//");
					var sec3:Array<String> = words[3].split("//");

					vertexIndices.push(Std.parseInt(sec1[0]));
					vertexIndices.push(Std.parseInt(sec2[0]));
					vertexIndices.push(Std.parseInt(sec3[0]));

					normalIndices.push(Std.parseInt(sec1[1]));
					normalIndices.push(Std.parseInt(sec2[1]));
					normalIndices.push(Std.parseInt(sec3[1]));
				}
			}

		}

		for(i in 0...vertexIndices.length){
			var vertex:Array<Float> = tempVertices[vertexIndices[i] - 1];
			var normal:Array<Float> = tempNormals[normalIndices[i] -1];

			vertices.push(vertex[0]);
			vertices.push(vertex[1]);
			vertices.push(vertex[2]);

			if(hasUVs){
				var uv:Array<Float> = tempUVs[uvIndices[i] - 1];
				uvs.push(uv[0]);
				uvs.push(uv[1]);
			}

			normals.push(normal[0]);
			normals.push(normal[1]);
			normals.push(normal[2]);
		}

		build(vertices, uvs, normals);

		data = [];
		for(i in 0...Std.int(vertices.length / 3)){
			data.push(indexedVertices[i * 3]);
			data.push(indexedVertices[i * 3 + 1]);
			data.push(indexedVertices[i * 3 + 2]);

			if(hasUVs){
				data.push(indexedUVs[i * 2]);
				data.push(1-indexedUVs[i * 2 + 1]);
			}

			data.push(indexedNormals[i * 3]);
			data.push(indexedNormals[i * 3 + 1]);
			data.push(indexedNormals[i * 3 + 2]);
		}

		if(hasUVs){
			structureLength = 8;
		}
		else{
			structureLength = 6;
		}

	}

	function build(vertices:Array<Float>, uvs:Array<Float>, normals:Array<Float>){

		indexedVertices = [];
		indexedUVs = [];
		indexedNormals = [];
		indices = [];

		for(i in 0...Std.int(vertices.length / 3)){

			var found:Bool = getSimilarVertexIndex(
				vertices[i * 3], vertices[i * 3 + 1], vertices[i * 3 + 2],
				normals[i * 3], normals[i * 3 + 1], normals[i * 3 + 2]
				);

			if(found){
				indices.push(index);
			}
			else{
				indexedVertices.push(vertices[i * 3]);
				indexedVertices.push(vertices[i * 3 + 1]);
				indexedVertices.push(vertices[i * 3 + 2]);

				if(hasUVs){
					indexedUVs.push(uvs[i * 2 ]);
					indexedUVs.push(uvs[i * 2 + 1]);
				}

				indexedNormals.push(normals[i * 3]);
				indexedNormals.push(normals[i * 3 + 1]);
				indexedNormals.push(normals[i * 3 + 2]);

				indices.push(Std.int(indexedVertices.length / 3) - 1);
			}

		}

	}

	function isNear(v1:Float, v2:Float):Bool {
		return Math.abs(v1 - v2) < 0.001;
	}

	function getSimilarVertexIndex(
					vertexX:Float, vertexY:Float, vertexZ:Float,
					normalX:Float, normalY:Float, normalZ:Float
	):Bool {

		for (i in 0...Std.int(indexedVertices.length / 3)) {
			if (
				isNear(vertexX, indexedVertices[i * 3]) &&
				isNear(vertexY, indexedVertices[i * 3 + 1]) &&
				isNear(vertexZ, indexedVertices[i * 3 + 2]) &&
				isNear(normalX, indexedNormals [i * 3]) &&
				isNear(normalY, indexedNormals [i * 3 + 1]) &&
				isNear(normalZ, indexedNormals [i * 3 + 2])
			) {
				index = i;
				return true;
			}
		}

		return false;

	}

}
