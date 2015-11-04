package;


import kha.graphics4.Program;
import kha.graphics4.VertexStructure;
import kha.Key;

import kha.input.Keyboard;

import kha.math.Vector2;
import kha.math.Vector4;


class Player extends Paddle{


	var left:Bool = false;
	var right:Bool = false;


	public function new(program:Program, structure:VertexStructure){

		super(program, structure);

		pos = new Vector2(0, 5);

		color = new Vector4(1.0, 1.0, 1.0, 1.0);

		Keyboard.get().notify(onKeyUp, onKeyDown);

	}

	override public function update(){

		if(left){
			moveLeft();
		}
		else if(right){
			moveRight();
		}

	}

	function onKeyDown(k:Key, c:String){

		if(k == Key.LEFT){
			left = true;
		}
		else if(k == Key.RIGHT){
			right = true;
		}

	}

	function onKeyUp(k:Key, c:String){

		if(k == Key.LEFT){
			left = false;
		}
		else if(k == Key.RIGHT){
			right = false;
		}

	}


}
