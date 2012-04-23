package net.flashpunk.masks 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.FP;
	

	public class TransformedPixelmask extends Pixelmask 
	{
		public function TransformedPixelmask(source:*, x:int = 0, y:int = 0, i:Image = null) 
		{
			//For now create our source, but just pass it along to the super function to be our mask
			//We'll only create a buffer and do all the fancy stuff if we need to
			if (source is BitmapData) _sourceData = source;
			if (source is Class) _sourceData = FP.getBitmap(source);
			if (source is Spritemap) _sourceData = (Spritemap)(source).buffer;
			_source.bitmapData = _sourceData;
			super(_sourceData, x, y);
			_check[Pixelmask] = collideTransformPixelmask;
			_check[TransformedPixelmask] = collideTransformPixelmask;
			link(i);
		}
		
		private function collideTransformPixelmask(other:Pixelmask):Boolean
		{
			_point.x = parent.x + x;
			_point.y = parent.y + y;
			_point2.x = other.parent.x + other.x;
			_point2.y = other.parent.y + other.y;
			return data.hitTest(_point, threshold, other.data, _point2, other.threshold);
		}
		
		protected function createBuffer():void
		{
			//newData will eventually be what we set data to. tempData is what we do all our work on first
			var newData:BitmapData;
			var tempData:BitmapData;
			
			//Calculate the maxlength, and use that to create our new buffer
			//The effectiveWidth and Height are twice the distance from the origin point of the picture to furthest relevent side.
			//i.e., if the origin point is 0,0, then the effective width and height are doubled because it's rotating on the corner
			var effectiveWidth:Number = 0;
			var effectiveHeight:Number = 0;
			
			if (this.originX >= (_sourceData.width / 2)) { 
				effectiveWidth = this.originX * 2;
			} else if (this.originX < _sourceData.width / 2) {
				effectiveWidth = (_sourceData.width - this.originX) * 2;
			}
			effectiveWidth *= this.scaleX;
			
			if (this.originY >= (_sourceData.height / 2)) { 
				effectiveHeight = this.originY * 2;
			} else if (this.originY < _sourceData.height / 2) {
				effectiveHeight = (_sourceData.height - this.originY) * 2;
			}
			effectiveHeight *= this.scaleY;
			
			//Calculate new width and height values, and account for scale
			var maxLength:int = Math.ceil(Math.sqrt(effectiveWidth * effectiveWidth + effectiveHeight * effectiveHeight));
			maxLength = Math.ceil(maxLength * this.scale);
			
			//Create the buffer
			tempData = new BitmapData(maxLength, maxLength, true, 0);
			var newOrigin:int = maxLength / 2;
			
			//Calculate offsets
			_offsetX = newOrigin - originX;
			_offsetY = newOrigin - originY;
			
			//Draw our buffer
			_matrix.b = _matrix.c = 0;
			_matrix.a = scaleX * scale;
			_matrix.d = scaleY * scale;
			_matrix.tx = -originX * _matrix.a;
			_matrix.ty = -originY * _matrix.d;
			if (angle != 0) _matrix.rotate(angle * FP.RAD);
			_matrix.tx += newOrigin;
			_matrix.ty += newOrigin;
			tempData.draw(_source, _matrix, null, null, null, false);
			
			//Get the bounds of our non-transparent pixels
			var crop:Rectangle = tempData.getColorBoundsRect(0xFF000000, 0, false);
			
			//Now create our actual data buffer, copy over the pixels, and adjust our offsets based on how much in front got cut off
			newData = new BitmapData(crop.width, crop.height, true, 0);
			newData.copyPixels(tempData, crop, new Point(0, 0), null, null, true);
			tempData.dispose();
			_offsetX -= crop.x;
			_offsetY -= crop.y;
			
			//Set our internal offsets to match our transform offsets. Note that our overloaded set x and y functions automatically
			//take into account offset.
			this.x = _sourceX;
			this.y = _sourceY;
			
			//Finally, set our data variable which will call the Pixelmask's set fucntion which will also update our entity's bounds
			if (data && data != _sourceData) data.dispose();
			data = newData;
		}
		
		/**
		 * Purpose of this function is to 'sync' the mask with its parent graphic. This is called only by the BSWorld class as part of the overridden update() function.
		 * If not using BSWorld, this will have to be manually called as FlashPunk doesn't normally have an update system for masks.
		 */
		public function sync():void
		{
			//If we have a linked image, use that. Otherwise check to see if our parent's graphic is an image and link to that and use it
			if (!_link) {
				if (parent && parent.graphic && parent.graphic is Image) link((Image)(parent.graphic));
			}
			
			//Only worry about syncing if are linked to an Image class
			if (_link) {
				
				var frameChanged:Boolean = angle != _link.angle || scale != _link.scale || scaleX != _link.scaleX || scaleY != _link.scaleY || originX != _link.originX || originY != _link.originY;
				
				var sprite:Spritemap = _link as Spritemap;
				if (sprite)
				{	
					if (sprite.frame != _currentFrame)
					{
						_currentFrame = sprite.frame;
						_sourceData = sprite.buffer;
						_source.bitmapData = _sourceData;
						frameChanged = true;
					}
				}
				
				//Check if something has changed. Note that as long as long as the linked image stays at angle 0 and scale 1, this class will perform like
				//a normal pixelmask. Once it starts changing, then this class will start manipulating _data
				if (frameChanged) {
					//Sync our values and then create the buffer
					//Unlike ImageBuffer and the like, there is only create buffer because we always crop the buffer after drawing to maintain a more accurate hitbox
					//and ensure faster hitdetection.
					angle = _link.angle;
					scale = _link.scale;
					scaleX = _link.scaleX;
					scaleY = _link.scaleY;
					originX = _link.originX;
					originY = _link.originY;
					angle = _link.angle;
					createBuffer();
				}
			}
		}
		
		public function link(i:Image = null):void
		{
			if (_link == i) return;
			//Remake our buffer in addition to linking
			_link = i;
			if(_link) {
				angle = _link.angle;
				scale = _link.scale;
				scaleX = _link.scaleX;
				scaleY = _link.scaleY;
				originX = _link.originX;
				originY = _link.originY;
				angle = _link.angle;
				createBuffer();	
			}
		}
		
		public function release(): void
		{
			_link = null;
			if(data && data != _sourceData) data.dispose();
		}
		
		override protected function update():void 
		{
			if(parent) super.update(); //No point in updating our parent if we don't have one
		}
		
		override public function set x(value:int):void
		{
			_sourceX = value;
			super.x = _sourceX - _offsetX;
		}
		
		override public function set y(value:int):void
		{
			_sourceY = value;
			super.y = _sourceY - _offsetY;
		}
		
		public var originX:int = 0;
		public var originY:int = 0;
		public var angle:Number = 0;
		public var scale:Number = 1;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		
		protected var _sourceData:BitmapData;
		protected var _source:Bitmap = new Bitmap;
		
		/**
		 * The followed 4 variables are all positional related variables
		 * 		_sourceX		Original X offset of this hitbox
		 * 		_sourceY		Original Y offset of this hitbox
		 * 		_offsetX		X Offset of the transformed hitbox from the original hitbox
		 * 		_offsetY		Y Offset of the transformed hitbox from the original hitbox
		 * 		_x				Combined X offset from the above. Defined in class Hitbox.
		 * 		_y				Combined Y offset from the above. Defined in the class Hitbox.
		 * 
		 * 		Since all the hitchecking functions reference _x and _y directly, those become our true offset vars
		 * 		and when createBuffer is called, it sets these values. 
		 */
		
		protected var _sourceX:int = 0;
		protected var _sourceY:int = 0;
		protected var _offsetX:int = 0;
		protected var _offsetY:int = 0;
		protected var _currentFrame:int = 0;
		
		protected var _link:Image = null;
		
		protected var _matrix:Matrix = FP.matrix;
		
		/** @private */ protected var _point:Point = FP.point;
		/** @private */ protected var _point2:Point = FP.point2;
		
	}

}