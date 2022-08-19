package android.flixel;

import android.flixel.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;
import openfl.utils.Assets;

/**
 * A zone with 4 hint's (A hitbox).
 * It's really easy to customize the layout.
 *
 * @author: Saw (M.A. Jigsaw)
 */
class FlxHitbox extends FlxSpriteGroup
{
	public var buttonLeft:FlxButton = new FlxButton(0, 0);
	public var buttonDown:FlxButton = new FlxButton(0, 0);
	public var buttonUp:FlxButton = new FlxButton(0, 0);
	public var buttonRight:FlxButton = new FlxButton(0, 0);

	public var buttonDodge:FlxButton = new FlxButton(0, 0);
	public var buttonAttackLeft:FlxButton = new FlxButton(0, 0);
	public var buttonAttackRight:FlxButton = new FlxButton(0, 0);

	/**
	 * Create the zone.
	 */
	public function new(mode:Modes)
	{
		super();

		final offsetFir:Int = (FlxG.save.data.mechsInputVariants ? Std.int(FlxG.height / 4) * 3 : 0);
		final offsetSec:Int = (FlxG.save.data.mechsInputVariants ? 0 : Std.int(FlxG.height / 4));

		switch (mode)
		{
			case DEFAULT:
				add(buttonLeft = createHint(0, 0, Std.int(FlxG.width / 4), FlxG.height, 0xFF00FF));
				add(buttonDown = createHint(FlxG.width / 4, 0, Std.int(FlxG.width / 4), FlxG.height, 0x00FFFF));
				add(buttonUp = createHint(FlxG.width / 2, 0, Std.int(FlxG.width / 4), FlxG.height, 0x00FF00));
				add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), 0, Std.int(FlxG.width / 4), FlxG.height, 0xFF0000));
			case SINGLEATTACK:
				add(buttonLeft = createHint(0, offsetSec, Std.int(FlxG.width / 4), 540, 0xFF00FF));
				add(buttonDown = createHint(FlxG.width / 4, offsetSec, Std.int(FlxG.width / 4), 540, 0x00FFFF));
				add(buttonUp = createHint(FlxG.width / 2, offsetSec, Std.int(FlxG.width / 4), 540, 0x00FF00));
				add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), offsetSec, Std.int(FlxG.width / 4), 540, 0xFF0000));
				add(buttonAttackLeft = createHint(0, offsetFir, FlxG.width, Std.int(FlxG.height / 4), 0xFF0000));
			case SINGLEDODGE:
				add(buttonLeft = createHint(0, offsetSec, Std.int(FlxG.width / 4), 540, 0xFF00FF));
				add(buttonDown = createHint(FlxG.width / 4, offsetSec, Std.int(FlxG.width / 4), 540, 0x00FFFF));
				add(buttonUp = createHint(FlxG.width / 2, offsetSec, Std.int(FlxG.width / 4), 540, 0x00FF00));
				add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), offsetSec, Std.int(FlxG.width / 4), 540, 0xFF0000));
				add(buttonDodge = createHint(0, offsetFir, FlxG.width, Std.int(FlxG.height / 4), 0xFFFF00));
			case DOUBLE:
				add(buttonLeft = createHint(0, offsetSec, Std.int(FlxG.width / 4), 540, 0xFF00FF));
				add(buttonDown = createHint(FlxG.width / 4, offsetSec, Std.int(FlxG.width / 4), 540, 0x00FFFF));
				add(buttonUp = createHint(FlxG.width / 2, offsetSec, Std.int(FlxG.width / 4), 540, 0x00FF00));
				add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), offsetSec, Std.int(FlxG.width / 4), 540, 0xFF0000));
				add(buttonDodge = createHint(Std.int(FlxG.width / 2), offsetFir, Std.int(FlxG.width / 2), Std.int(FlxG.height / 4), 0xFFFF00));
				add(buttonAttackLeft = createHint(0, offsetFir, Std.int(FlxG.width / 2), Std.int(FlxG.height / 4), 0xFF0000));
			case TRIPLE:
				add(buttonLeft = createHint(0, offsetSec, Std.int(FlxG.width / 4), 540, 0xFF00FF));
				add(buttonDown = createHint(FlxG.width / 4, offsetSec, Std.int(FlxG.width / 4), 540, 0x00FFFF));
				add(buttonUp = createHint(FlxG.width / 2, offsetSec, Std.int(FlxG.width / 4), 540, 0x00FF00));
				add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), offsetSec, Std.int(FlxG.width / 4), 540, 0xFF0000));
				add(buttonAttackRight = createHint(Std.int(FlxG.width / 3) * 2, offsetFir, Std.int(FlxG.width / 3), Std.int(FlxG.height / 4), 0xFF0000));
				add(buttonDodge = createHint(Std.int(FlxG.width / 3), offsetFir, Std.int(FlxG.width / 3), Std.int(FlxG.height / 4), 0xFFFF00));
				add(buttonAttackLeft = createHint(0, offsetFir, Std.int(FlxG.width / 3), Std.int(FlxG.height / 4), 0xFF0000));
		}

		scrollFactor.set();
	}

	/**
	 * Clean up memory.
	 */
	override function destroy()
	{
		super.destroy();

		buttonLeft = null;
		buttonDown = null;
		buttonUp = null;
		buttonRight = null;
		buttonDodge = null;
		buttonAttackLeft = null;
		buttonAttackRight = null;
	}

	private function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:Int = 0xFFFFFF):FlxButton
	{
		var hintTween:FlxTween = null;
		var hint:FlxButton = new FlxButton(X, Y);
		hint.makeGraphic(Width, Height, Color);
		hint.solid = false;
		hint.immovable = true;
		hint.scrollFactor.set();
		hint.alpha = 0.00001;
		hint.onDown.callback = function()
		{
			if (hintTween != null)
				hintTween.cancel();

			hintTween = FlxTween.tween(hint, {alpha: AndroidControls.getOpacity()}, AndroidControls.getOpacity() / 10, {
				ease: FlxEase.circInOut,
				onComplete: function(twn:FlxTween)
				{
					hintTween = null;
				}
			});
		}
		hint.onUp.callback = function()
		{
			if (hintTween != null)
				hintTween.cancel();

			hintTween = FlxTween.tween(hint, {alpha: 0.00001}, 0.1, {
				ease: FlxEase.circInOut,
				onComplete: function(twn:FlxTween)
				{
					hintTween = null;
				}
			});
		}
		hint.onOut.callback = function()
		{
			if (hintTween != null)
				hintTween.cancel();

			hintTween = FlxTween.tween(hint, {alpha: 0.00001}, 0.1, {
				ease: FlxEase.circInOut,
				onComplete: function(twn:FlxTween)
				{
					hintTween = null;
				}
			});
		}
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		return hint;
	}
}

enum Modes
{
	DEFAULT;
	SINGLEATTACK;
	SINGLEDODGE;
	DOUBLE;
	TRIPLE;
}
