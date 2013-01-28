/**
 * AudioVisualiserExample1.as by Lee Burrows
 * Jan 14, 2011
 * Visit blog.leeburrows.com for more stuff
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 **/
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	[SWF(backgroundColor="#333333", frameRate="30", width="350", height="200")]
	public class AudioVisualiserExample1 extends Sprite
	{
		private var sound:Sound;
		private var channel:SoundChannel;
		private var bytes:ByteArray;
		
		private var isPlaying:Boolean;
		private var playPosition:uint;
		
		public function AudioVisualiserExample1()
		{
			//set as sound not playing
			isPlaying = false;
			//set initial sound position to start of track
			playPosition = 0;
			//listen for mouse click on stage
			stage.addEventListener(MouseEvent.CLICK, clickHandler);

			//setup storage for sampled sound data
			bytes = new ByteArray();
			//load mp3
			buildSound();
			//call loop once to draw something
			loop(null);
		}
		
		private function buildSound():void
		{
			//create a sound object
			sound = new Sound();
			//load mp3
			sound.load(new URLRequest("test-track.mp3"));
		}

		private function loop(event:Event):void
		{
			//get sampled sound data
			SoundMixer.computeSpectrum(bytes, false, 0);
			//clear display
			graphics.clear();
			//left sound channel
			graphics.lineStyle(2, 0xFF0000);
			//loop thru left channel data
			graphics.moveTo(46, 100);
			for (var i:uint=0;i<256;i++)
			{
				graphics.lineTo(47+i, 100+bytes.readFloat()*80);
			}
			graphics.lineTo(47+i, 100);
			//right sound channel
			graphics.lineStyle(2, 0x00FF00);
			//loop thru right channel data
			graphics.moveTo(46, 100);
			for (i=0;i<256;i++)
			{
				graphics.lineTo(47+i, 100+bytes.readFloat()*80);
			}
			graphics.lineTo(47+i, 100);
		}

		//respond to stage mouse click
		private function clickHandler(event:MouseEvent):void
		{
			if (isPlaying)
			{
				//if sound currently playing, store position and stop sound
				playPosition = channel.position;
				channel.stop();
				channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				//stop loop
				removeEventListener(Event.ENTER_FRAME, loop);
			}
			else
			{
				//if sound not currently playing, start sound at stored position
				channel = sound.play(playPosition);
				channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				//start loop
				addEventListener(Event.ENTER_FRAME, loop);
			}
			//toggle isPlaying flag
			isPlaying = !isPlaying;
		}
		
		private function soundCompleteHandler(event:Event):void
		{
			//clear up existing event listener
			channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			//create new SoundChannel instance and play sound
			channel = sound.play(playPosition);
			channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		}

	}
}