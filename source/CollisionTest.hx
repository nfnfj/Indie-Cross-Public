package;

import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;

class CollisionTest extends FlxState
{
	var heart:Balls;
	var collisionTest:FlxSprite;

	var pixelPerfectbox:FlxSprite;

	var overlapBox:FlxSprite;

	override function create()
	{
		heart = new Balls();

		collisionTest = new FlxSprite().makeGraphic(1270, 188, FlxColor.WHITE);
		add(collisionTest);

		pixelPerfectbox = new FlxSprite(1000, 100).makeGraphic(200, 200, FlxColor.GREEN);
		add(pixelPerfectbox);
		overlapBox = new FlxSprite(1000, 100).makeGraphic(200, 200, FlxColor.BLUE);
		add(overlapBox);
		overlapBox.y += pixelPerfectbox.width;
		add(heart);
	}

	override function update(e:Float)
	{
		super.update(e);

		if (FlxG.keys.pressed.UP)
			heart.y -= 5;
		if (FlxG.keys.pressed.DOWN)
			heart.y += 5;
		if (FlxG.keys.pressed.LEFT)
			heart.x -= 5;
		if (FlxG.keys.pressed.RIGHT)
			heart.x += 5;
		if (FlxG.mouse.wheel < 0)
			collisionTest.angle -= 2;
		if (FlxG.mouse.wheel > 0)
			collisionTest.angle += 2;

		if (FlxCollision.pixelPerfectCheck(heart, collisionTest))
			pixelPerfectbox.alpha = 1;
		else
			pixelPerfectbox.alpha = 0.00001;

		if (FlxG.overlap(heart, collisionTest))
			overlapBox.alpha = 1;
		else
			overlapBox.alpha = 0.00001;
	}
}
