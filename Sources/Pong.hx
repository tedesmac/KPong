package;

import kha.Game;
import kha.Framebuffer;
import kha.Loader;
import kha.LoadingScreen;
import kha.Configuration;
import kha.FontStyle;
import kha.Color;

import kha.math.Matrix4;


class Pong extends Game {
	public function new() {
		super("Empty", false);
	}

	override public function init(){

		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("level0", onLoading);

	}

	function onLoading(){

		Configuration.setScreen(this);

	}

	override public function render(frame:Framebuffer){

		var g = frame.g4;

		g.begin();

			g.clear();

		g.end();

	}
}
