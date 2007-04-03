/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

import org.aswing.graphics.Graphics2D;
import org.aswing.geom.IntRectangle;
import org.aswing.*;
import flash.display.DisplayObject;
import org.aswing.plaf.UIResource;
import flash.display.Sprite;
import org.aswing.plaf.ComponentUI;

public class SkinFrameBackground implements GroundDecorator, UIResource{
	
	protected var imageContainer:Sprite;
	protected var activeBG:DisplayObject;
	protected var inactiveBG:DisplayObject;
	
	public function SkinFrameBackground(){
		imageContainer = AsWingUtils.createSprite(null, "bgContainer");
	}
	
	private function reloadAssets(ui:ComponentUI):void{
		activeBG = ui.getInstance("Frame.activeBG") as DisplayObject;
		inactiveBG = ui.getInstance("Frame.inactiveBG") as DisplayObject;
		imageContainer.addChild(activeBG);
		imageContainer.addChild(inactiveBG);
		inactiveBG.visible = false;
	}
	
	public function updateDecorator(com:Component, g:Graphics2D, bounds:IntRectangle):void{
		if(activeBG == null){
			reloadAssets(com.getUI());
		}
		var frame:JFrame = JFrame(com);
		activeBG.visible = frame.getFrameUI().isPaintActivedFrame();
		inactiveBG.visible = !frame.getFrameUI().isPaintActivedFrame();
		//not use bounds, avoid the border
		activeBG.width = inactiveBG.width = com.width;
		activeBG.height = inactiveBG.height = com.height;
	}
	
	public function getDisplay():DisplayObject{
		return imageContainer;
	}
	
}
}