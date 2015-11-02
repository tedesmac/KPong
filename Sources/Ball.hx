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

class Ball{

	var pos:Vector2;
	var mov:Vector2;
	var rec:kha.Rectangle;

	var modelID:ConstantLocation;
	var modelMatrix:Matrix4;

	var colorID:ConstantLocation;
	public var color:Vector4;

	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;

	var speed = 1.5;


	public function new(program:Program, structure:VertexStructure){

		mov = new Vector2(0, 0);

		var angle:Float = Std.random(50) + 25;
		angle = (2*Math.PI*angle) / 360;

		mov = new Vector2(0.5, 0.5);
		mov = mov.mult(speed);

		rec = new kha.Rectangle(0, 0, 0.5, 0.5);

		colorID = program.getConstantLocation("color");
		color = new Vector4(0.3, 0.8, 0.5, 1.0);

		modelID = program.getConstantLocation("model");

		modelMatrix = Matrix4.identity();
		modelMatrix = modelMatrix.multmat(Matrix4.scale(0.5, 0.5, 0.5));

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

		pos = pos.add(mov);

		if(pos.x < -3){
			mov.x *= -1;
			pos.x = -3;
		}
		if(pos.x > 2){
			mov.x *= -1;
			pos.x = 2;
		}

		if(pos.y < -5){
			mov.y *= -1;
			pos.y = -5;
		}
		if(pos.y > 4){
			mov.y *= -1;
			pos.y = 4;
		}

		modelMatrix = Matrix4.identity();
		modelMatrix = modelMatrix.multmat(Matrix4.translation(pos.x, 0, pos.y));
		modelMatrix = modelMatrix.multmat(Matrix4.scale(0.5, 0.5, 0.5));

	}

	public function render(g:Graphics){

		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);

		g.setMatrix(modelID, modelMatrix);

		g.setFloat4(colorID, color.x, color.y, color.z, color.w);

		g.drawIndexedVertices();

	}


}
