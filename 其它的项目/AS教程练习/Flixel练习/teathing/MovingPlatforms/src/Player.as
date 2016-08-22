package
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source="../media/spaceman.png")] 
		protected var PlayerImage:Class;
		
		[Embed(source="../media/jump.mp3")] 
		protected var SndJump:Class;
		
		[Embed(source="../media/land.mp3")] 
		protected var SndLand:Class;
		
		protected static const PLAYER_START_X:int = 300;
		protected static const PLAYER_START_Y:int = 300;
		protected static const PLAYER_RUN_SPEED:int = 80;
		protected static const GRAVITY_ACCELERATION:Number = 420;
		protected static const JUMP_ACCELERATION:Number = 200;
		protected static const BULLET_VELOCITY:Number = 360;
		protected static const BULLET_BOOST:Number = 36;
		
		protected var bullets:FlxArray;
		protected var currentBullet:uint = 0;
		protected var aimingUp:Boolean = false;
		protected var aimingDown:Boolean = false;
		
		public function Player(bullets:FlxArray)
		{
			super(PlayerImage, PLAYER_START_X, PLAYER_START_Y, true, true);
			
			drag.x = PLAYER_RUN_SPEED * 8;
			acceleration.y = GRAVITY_ACCELERATION;
			maxVelocity.x = PLAYER_RUN_SPEED;
			maxVelocity.y = JUMP_ACCELERATION;
			
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 0], 12);
			addAnimation("jump", [4]);
			addAnimation("idle_up", [5]);
			addAnimation("run_up", [6, 7, 8, 5], 12);
			addAnimation("jump_up", [9]);
			addAnimation("jump_down", [10]);
			
			this.bullets = bullets;
		}
		
		public override function update():void
		{
			acceleration.x = 0;
			if(FlxG.keys.LEFT)
			{
				facing = LEFT;
				acceleration.x = -drag.x;
			}
			else if(FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				acceleration.x = drag.x;
			}
			if(FlxG.keys.justPressed("X") && !velocity.y)
			{
				velocity.y = -JUMP_ACCELERATION;
				FlxG.play(SndJump);
			}
			
			if(velocity.y != 0)
			{
				play("jump");
			}
			else if(velocity.x == 0)
			{
				play("idle");
			}
			else
			{
				play("run");
			}
			
			aimingUp = false;
			aimingDown = false;
			if(FlxG.keys.UP) aimingUp = true;
			else if(FlxG.keys.DOWN && velocity.y) aimingDown = true;
			
			if(FlxG.keys.justPressed("C"))
			{
				var bXVel:int = 0;
				var bYVel:int = 0;
				var bX:int = x;
				var bY:int = y;
				if(aimingUp)
				{
					bY -= bullets[currentBullet].height - 4;
					bYVel = -BULLET_VELOCITY;
				}
				else if(aimingDown)
				{
					bY += height - 4;
					bYVel = BULLET_VELOCITY;
					velocity.y -= BULLET_BOOST;
				}
				else if(facing == RIGHT)
				{
					bX += width - 4;
					bXVel = BULLET_VELOCITY;
				}
				else
				{
					bX -= bullets[currentBullet].width - 4;
					bXVel = -BULLET_VELOCITY;
				}
				
				bullets[currentBullet].shoot(bX,bY,bXVel,bYVel);
				
				++currentBullet;
				currentBullet %= bullets.length;
			}
			
			super.update();
		}
		
		override public function hitFloor(Contact:FlxCore=null):Boolean
		{
			if(velocity.y > 50)
				FlxG.play(SndLand);
			return super.hitFloor();
		}
		


	}
}
