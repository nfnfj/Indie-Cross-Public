package;

#if android
import android.net.Uri;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.events.Event;
import vlc.VlcBitmap;

// THIS IS FOR TESTING
// DONT STEAL MY CODE >:(
class VideoHandler
{
	public var finishCallback:Void->Void;
	public var stateCallback:FlxState;
	public var bitmap:VlcBitmap;
	public var sprite:FlxSprite;
	public var fadeToBlack:Bool = false;
	public var fadeFromBlack:Bool = false;
	public var allowSkip:Bool = false;

	public function new()
	{
		FlxG.autoPause = false;
	}

	public function playMP4(path:String, ?repeat:Bool = false, ?outputTo:FlxSprite = null, ?isWindow:Bool = false, ?isFullscreen:Bool = false,
			?midSong:Bool = false):Void
	{
		#if cpp
		if (!midSong && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		bitmap = new VlcBitmap();
		bitmap.set_width(bitmap.calc(0));
		bitmap.set_height(bitmap.calc(1));
		bitmap.onVideoReady = onVLCVideoReady;
		bitmap.onComplete = onVLCComplete;
		bitmap.onError = onVLCError;

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);

		#if android
		if (repeat)
			bitmap.repeat = 65535;
		else
			bitmap.repeat = 0;
		#else
		if (repeat)
			bitmap.repeat = -1;
		else
			bitmap.repeat = 0;
		#end

		bitmap.inWindow = isWindow;
		bitmap.fullscreen = isFullscreen;

		FlxG.addChildBelowMouse(bitmap);
		bitmap.play(checkFile(path));

		if (outputTo != null)
		{
			bitmap.alpha = 0;
			sprite = outputTo;
		}
		#end
	}

	function checkFile(fileName:String):String
	{
		#if android
		return Uri.fromFile(fileName);
		#elseif linux
		return 'file://' + Sys.getCwd() + fileName;
		#elseif windows
		return 'file:///' + Sys.getCwd() + fileName;
		#end
	}

	/////////////////////////////////////////////////////////////////////////////////////

	function onVLCVideoReady()
	{
		trace("video loaded!");

		#if cpp
		if (sprite != null)
			sprite.loadGraphic(bitmap.bitmapData);
		#end

		if (fadeFromBlack)
			FlxG.camera.fade(FlxColor.BLACK, 0, false);
	}

	public function onVLCComplete()
	{
		#if cpp
		bitmap.stop();

		// Clean player, just in case! Actually no.

		if (fadeToBlack)
			FlxG.camera.fade(FlxColor.BLACK, 0, false);

		if (fadeFromBlack)
			FlxG.camera.fade(FlxColor.BLACK, 1, true);

		trace("Big, Big Chungus, Big Chungus!");

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			if (finishCallback != null)
				finishCallback();
			else if (stateCallback != null)
				LoadingState.loadAndSwitchState(stateCallback);

			bitmap.dispose();

			if (FlxG.game.contains(bitmap))
				FlxG.game.removeChild(bitmap);
		});
		#end
	}

	public function kill()
	{
		#if cpp
		bitmap.visible = false;
		bitmap.stop();

		if (finishCallback != null)
			finishCallback();
		#end
	}

	function onVLCError()
	{
		if (finishCallback != null)
			finishCallback();
		else if (stateCallback != null)
			LoadingState.loadAndSwitchState(stateCallback);
	}

	function update(e:Event)
	{
		if (FlxG.keys.justPressed.ENTER #if android || FlxG.android.justReleased.BACK #end && (allowSkip && bitmap.isPlaying))
			onVLCComplete();

		if (FlxG.sound.volume <= 0.1)
			bitmap.volume = 0;
		else
			bitmap.volume = FlxG.sound.volume;
	}
}
