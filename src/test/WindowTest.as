package
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flexunit.framework.Test;
	import org.flexunit.async.Async;
	import org.flexunit.Assert;
	
	import fin.desktop.ExternalWindow;
	import fin.desktop.InterApplicationBus;
	import fin.desktop.RuntimeConfiguration;
	import fin.desktop.RuntimeLauncher;
	import fin.desktop.Window;
	import fin.desktop.Application;
	import fin.desktop.ApplicationOptions;
	import fin.desktop.WindowOptions;
	import fin.desktop.connection.DesktopConnection;
	
	public class WindowTest
	{
		private var app:Application;
		
		[Before(async)]
		public function createApplication():void
		{
			trace("WindowTest: create application");
			var applicationOptions:ApplicationOptions = new ApplicationOptions("windowTest", "https://www.google.com");
			var windowOptions:WindowOptions = new WindowOptions();
			windowOptions.minimizable = true;
			windowOptions.maximizable = true;
			windowOptions.autoShow = true;
			windowOptions.showTaskbarIcon = true;
			windowOptions.frame = true;
			
			var testHandler:Function = function(event:Event, passThroughData:Object):void 
			{
			}
			
			var testErrorHandler:Function = function(passThroughData:Object):void 
			{
				Assert.fail("error creating application:" + passThroughData);
			}
			
			var asyncHandler = Async.asyncHandler(this, testHandler, 15000, null, testErrorHandler)
			
			var handler:Function = function():void 
			{
				app.run(function ():void 
				{
					asyncHandler();
				});
			}

			var errorHandler:Function = function(reason:String):void 
			{
				trace("error creating application: " + reason);
				testErrorHandler(reason);
			}
			
			app = new Application(applicationOptions, handler, errorHandler);
		}
		
		[Test(async)]
		public function moveWindow():void 
		{
			app.window.moveTo(100, 100, Async.asyncHandler(this, 
					function(event:Event, passThroughData:Object):void 
					{
						trace("window moveTo call succeed");
						//verify window location.
					}, 
					15000, 
					null, 
					function(passThroughData:Object):void 
					{
						Assert.fail("error moving window");
					}));
		}
		
		
		[After(async)]
		public function closeApplication():void
		{
			app.close(false, 
				Async.asyncHandler(this, 
					function(event:Event, passThroughData:Object):void 
					{
						
					}, 
					15000, 
					null, 
					function(passThroughData:Object):void 
					{
						Assert.fail("error closing application:" + passThroughData);
					}));
		}
		
		
	}
}