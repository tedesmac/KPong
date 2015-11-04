package;


import kha.Rectangle;
import kha.Loader;

import kha.graphics4.Graphics;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;
import kha.graphics4.Program;
import kha.graphics4.Usage;

import kha.math.Matrix4;
import kha.math.Vector2;
import kha.math.Vector4;


class Paddle{


	var pos:Vector2;
	var mov:Vector2;
	var rec:kha.Rectangle;

	var modelID:ConstantLocation;
	var modelMatrix:Matrix4;

	var colorID:ConstantLocation;
	var color:Vector4;

	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;

	var speed = 0.5;


	public function new(program:Program, structure:VertexStructure, pos:Vector2){

		rec = new kha.Rectangle(0, 0, 2, 1);

		this.pos = pos;
		mov = new Vector2(speed, 0);

		colorID = program.getConstantLocation("color");
		color = new Vector4();

		modelID = program.getConstantLocation("model");

		modelMatrix = Matrix4.identity();
		modelMatrix = modelMatrix.multmat(Matrix4.scale(2, 1, 1));

		var cube = new ObjLoader(Loader.the.getBlob("cube").toString());
		var data = cube.data;
		var indices = cube.indices;

		vertexBuffer = new VertexBuffer(
				Std.int(data.length/cube.structureLength),
				structure,
				Usage.StaticUsage
		);

		var vbData = vertexBuffer.lock();
		for(i in 0...vbData.length){
			vbData.set(i, data[i]);
		}
		vertexBuffer.unlock();

		indexBuffer = new IndexBuffer(
			indices.length,
			Usage.StaticUsage
		);

		var iData = indexBuffer.lock();
		for(i in 0...iData.length){
			iData[i] = indices[i];
		}
		indexBuffer.unlock();

	}

	public function update(){

	}

	public function render(g:Graphics){

		g.setMatrix(modelID, modelMatrix);

		g.setFloat4(colorID, color.x, color.y, color.z, color.w);

		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);

		g.drawIndexedVertices();

	}

	public function moveLeft(){

		pos.x -= mov.x;

		modelMatrix = modelMatrix.multmat(Matrix4.translation(pos.x, 0, 0));

	}

	public function moveRight(){

		pos.x += mov.x;

		modelMatrix = modelMatrix.multmat(Matrix4.translation(pos.x, 0, 0));

	}


}
