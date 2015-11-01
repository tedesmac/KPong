package;

import kha.Game;
import kha.Framebuffer;
import kha.Loader;
import kha.LoadingScreen;
import kha.Configuration;
import kha.FontStyle;
import kha.Color;

import kha.graphics4.Program;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.graphics4.ConstantLocation;
import kha.graphics4.CompareMode;
import kha.graphics4.CullMode;
import kha.graphics4.Graphics2;

import kha.math.Matrix4;
import kha.math.Vector3;
import kha.math.Vector2;


class Pong extends Game {


	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var program:Program;

	var mvp:Matrix4;
	var mvpID:ConstantLocation;
	var viewMatrixID:ConstantLocation;
	var modelMatrixID:ConstantLocation;

	var model:Matrix4;
	var view:Matrix4;
	var projection:Matrix4;

	var ballPos:Vector2;
	var ballMovement:Vector2;


	public function new() {
		super("Empty", false);
	}

	override public function init(){

		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("level0", onLoading);

	}

	function onLoading(){

		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		structure.add("uv", VertexData.Float2);
		structure.add("nor", VertexData.Float3);
		var structureLength = 8;

		var vertexShader = new VertexShader(Loader.the.getShader("simple.vert"));
		var fragmentShader = new FragmentShader(Loader.the.getShader("simple.frag"));

		program = new Program();
		program.setVertexShader(vertexShader);
		program.setFragmentShader(fragmentShader);
		program.link(structure);

		mvpID = program.getConstantLocation("MVP");

		projection = Matrix4.perspectiveProjection(45.0, 4.0/3.0, 0.1, 100.0);

		view = Matrix4.lookAt(
			new Vector3(0, 9, 13),
			new Vector3(0, 0, 0),
			new Vector3(0, 1, 0)
		);

		model = Matrix4.identity();

		mvp = Matrix4.identity();
		mvp = mvp.multmat(projection);
		mvp = mvp.multmat(view);
		mvp = mvp.multmat(model);

		var cube = new ObjLoader(Loader.the.getBlob("cube").toString());
		var data = cube.data;
		var indices = cube.indices;

		vertexBuffer = new VertexBuffer(
			Std.int(data.length/structureLength),
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

		Configuration.setScreen(this);

	}

	override public function render(frame:Framebuffer){

		var g = frame.g4;

		g.begin();

			g.setDepthMode(true, CompareMode.Less);
			g.setCullMode(CullMode.CounterClockwise);

			g.clear(Color.Pink);

			g.setVertexBuffer(vertexBuffer);
			g.setIndexBuffer(indexBuffer);
			g.setProgram(program);

			g.setMatrix(mvpID, mvp);

			g.drawIndexedVertices();

		g.end();

	}

}
