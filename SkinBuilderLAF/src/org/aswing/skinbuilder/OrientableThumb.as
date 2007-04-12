/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.skinbuilder{

import org.aswing.graphics.Graphics2D;
import org.aswing.geom.*;
import org.aswing.event.*;
import org.aswing.*;
import flash.display.*;
import org.aswing.plaf.*;
import flash.events.*;
import org.aswing.error.ImpMissError;

public class OrientableThumb implements GroundDecorator, Icon, UIResource{
	
    protected var thumb:AWSprite;
    protected var verticalContainer:ButtonStateObject;
    protected var horizontalContainer:ButtonStateObject;
    
    protected var verticalDefaultImage:DisplayObject;
    protected var verticalPressedImage:DisplayObject;
    protected var verticalDisabledImage:DisplayObject;
    protected var verticalRolloverImage:DisplayObject;
    
    protected var horizontalDefaultImage:DisplayObject;
    protected var horizontalPressedImage:DisplayObject;
    protected var horizontalDisabledImage:DisplayObject;
    protected var horizontalRolloverImage:DisplayObject;
    
    protected var size:IntDimension;
    protected var verticle:Boolean;
    
    protected var enabled:Boolean;
	protected var rollover:Boolean;
	protected var pressed:Boolean;
	
	protected var origWidth:int;
	protected var origHeight:int;
	
	public function OrientableThumb(){
		thumb = new AWSprite();
		thumb.tabEnabled = false;
		rollover = false;
		pressed = false;
		enabled = true;
		verticle = false;
		initSelfHandlers();
	}
	
	private function checkReloadAssets(c:Component):void{
		if(verticalContainer){
			return;
		}
		verticalContainer = new ButtonStateObject();
		horizontalContainer = new ButtonStateObject();
		var ui:ComponentUI = c.getUI();
		verticalContainer.setDefaultImage(getAsset(ui, "thumbVertical.defaultImage"));
		verticalContainer.setPressedImage(getAsset(ui, "thumbVertical.pressedImage"));
		verticalContainer.setDisabledImage(getAsset(ui, "thumbVertical.disabledImage"));
		verticalContainer.setRolloverImage(getAsset(ui, "thumbVertical.rolloverImage"));
		
		var defaultHori:DisplayObject = getAsset(ui, "thumbHorizontal.defaultImage");
		origWidth = defaultHori.width;
		origHeight = defaultHori.height;
		horizontalContainer.setDefaultImage(defaultHori);
		horizontalContainer.setPressedImage(getAsset(ui, "thumbHorizontal.pressedImage"));
		horizontalContainer.setDisabledImage(getAsset(ui, "thumbHorizontal.disabledImage"));
		horizontalContainer.setRolloverImage(getAsset(ui, "thumbHorizontal.rolloverImage"));
	}
	
	
    protected function getAsset(ui:ComponentUI, exName:String):DisplayObject {
        return ui.getInstance(getPropertyPrefix()+exName) as DisplayObject;
    }
    
    protected function getPropertyPrefix():String{
    	throw new ImpMissError();
    	return null;
    }
	
	public function updateDecorator(c:Component, g:Graphics2D, bounds:IntRectangle):void{
		checkReloadAssets(c);
		thumb.x = bounds.x;
		thumb.y = bounds.y;
		size = bounds.getSize();
		var sb:Orientable = Orientable(c);
		enabled = c.isEnabled();
		verticle = (sb.getOrientation() == AsWingConstants.VERTICAL);
		paint();
	}
	
	public function updateIcon(c:Component, g:Graphics2D, x:int, y:int):void{
		checkReloadAssets(c);
		thumb.x = x;
		thumb.y = y;
		size = null;
		var sb:Orientable = Orientable(c);
		enabled = c.isEnabled();
		verticle = (sb.getOrientation() == AsWingConstants.VERTICAL);
		paint();
	}
	
	public function getIconHeight(c:Component):int{
		checkReloadAssets(c);
		return verticle ? origWidth : origHeight;
	}
	
	public function getIconWidth(c:Component):int{
		checkReloadAssets(c);
		return verticle ? origHeight : origWidth;
	}
	
	public function getDisplay(c:Component):DisplayObject{
		checkReloadAssets(c);
		return thumb;
	}
	
	protected function paint():void{
		if(verticle){
			if(!thumb.contains(verticalContainer)){
				thumb.addChild(verticalContainer);
			}
			if(thumb.contains(horizontalContainer)){
				thumb.removeChild(horizontalContainer);
			}
			verticalContainer.setEnabled(enabled);
			verticalContainer.setPressed(pressed);
			verticalContainer.setRollovered(rollover);
			verticalContainer.updateRepresent(size != null ? size.getBounds() : null);
		}else{
			if(!thumb.contains(horizontalContainer)){
				thumb.addChild(horizontalContainer);
			}
			if(thumb.contains(verticalContainer)){
				thumb.removeChild(verticalContainer);
			}
			horizontalContainer.setEnabled(enabled);
			horizontalContainer.setPressed(pressed);
			horizontalContainer.setRollovered(rollover);
			horizontalContainer.updateRepresent(size != null ? size.getBounds() : null);
		}
	}

	private function initSelfHandlers():void{
		thumb.addEventListener(MouseEvent.ROLL_OUT, __rollOutListener);
		thumb.addEventListener(MouseEvent.ROLL_OVER, __rollOverListener);
		thumb.addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownListener);
		thumb.addEventListener(ReleaseEvent.RELEASE, __mouseUpListener);
	}
	
	private function __rollOverListener(e:Event):void{
		rollover = true;
		paint();
	}
	private function __rollOutListener(e:Event):void{
		rollover = false;
		if(!pressed){
			paint();
		}
	}
	private function __mouseDownListener(e:Event):void{
		pressed = true;
		paint();
	}
	private function __mouseUpListener(e:Event):void{
		if(pressed){
			pressed = false;
			paint();
		}
	}
}
}