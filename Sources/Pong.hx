package;

import kha.Game;
import kha.Framebuffer;
import kha.Loader;
import kha.LoadingScreen;
import kha.Configuration;
import kha.FontStyle;
import kha.Color;
import kha.Button;

import kha.graphics4.Program;
import kha.graphics4.VertexStructure;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexData;
import kha.graphics4.ConstantLocation;
import kha.graphics4.CompareMode;
import kha.graphics4.CullMode;

import kha.math.Matrix4;
import kha.math.Vector3;
import kha.math.Vector2;
import kha.math.Vector4;


class Pong extends Game {


	var program:Program;

	var projectionMatrixID:ConstantLocation;
	var viewMatrixID:ConstantLocation;

	var viewMatrix:Matrix4;
	var projectionMatrix:Matrix4;

	var ball:Ball;
	var player:Player;


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

		var vertexShader = new VertexShader(Loader.the.getShader("uber.vert"));
		var fragmentShader = new FragmentShader(Loader.the.getShader("uber.frag"));

		program = new Program();
		program.setVertexShader(vertexShader);
		program.setFragmentShader(fragmentShader);
		program.link(structure);

		projectionMatrixID = program.getConstantLocation("projection");
		viewMatrixID = program.getConstantLocation("view");

		projectionMatrix = Matrix4.perspectiveProjection(45.0, 4.0/3.0, 0.1, 100.0);

		viewMatrix = Matrix4.lookAt(
			new Vector3(0, 9, 13),
			new Vector3(0, 0, 0),
			new Vector3(0, 1, 0)
		);

		ball = new Ball(program, structure);

		player = new Player(program, structure);

		Configuration.setScreen(this);

	}

	override public function update(){

		ball.update();
		player.update();

	}

	override public function render(frame:Framebuffer){

		var g = frame.g4;

		g.begin();

			g.setDepthMode(true, CompareMode.Less);
			g.setCullMode(CullMode.CounterClockwise);

			g.clear(Color.Pink);

			g.setProgram(program);

			g.setMatrix(projectionMatrixID, projectionMatrix);
			g.setMatrix(viewMatrixID, viewMatrix);

			ball.render(g);

			player.render(g);

		g.end();

	}

	override public function buttonDown(button:Button){

	}

	override public function buttonUp(button:Button){

	}


}
