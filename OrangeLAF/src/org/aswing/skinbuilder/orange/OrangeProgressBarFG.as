package org.aswing.skinbuilder.orange{

import flash.display.*;
import flash.utils.*;
import flash.geom.*;

import org.aswing.*;
import org.aswing.geom.*;
import org.aswing.graphics.*;
import org.aswing.plaf.ComponentUI;
import org.aswing.skinbuilder.SkinProgressBarForeground;

public class OrangeProgressBarFG extends SkinProgressBarForeground{
	
	protected var verticalBM:BitmapData;
	protected var horizotalBM:BitmapData;
	
	public function OrangeProgressBarFG(){
		super();
	}
		
	override protected function checkReloadAssets(c:Component):void{
		if(!loaded){
			var ui:ComponentUI = c.getUI();
			verticalImage = ui.getInstance(getPropertyPrefix()+"verticalFGImage") as DisplayObject;
			horizotalImage = ui.getInstance(getPropertyPrefix()+"horizotalFGImage") as DisplayObject;
			fgMargin = ui.getInsets(getPropertyPrefix()+"fgMargin");
			loaded = true;
			
			verticalBM = new BitmapData(verticalImage.width, verticalImage.height, true, 0x0);
			verticalBM.draw(verticalImage);
			horizotalBM = new BitmapData(horizotalImage.width, horizotalImage.height, true, 0x0);
			horizotalBM.draw(horizotalImage);
		}
	}
	
	override public function updateDecorator(com:Component, g:Graphics2D, bounds:IntRectangle):void{
		checkReloadAssets(com);
		var bar:JProgressBar = JProgressBar(com);
		var image:DisplayObject;
		if(bar.getOrientation() == AsWingConstants.HORIZONTAL){
			image = horizotalImage;
		}else{
			image = verticalImage;
		}

		if(image){
			g = new Graphics2D(imageContainer.graphics);
			g.clear();
		}else{
			return;
		}
		var percent:Number;
		if(bar.isIndeterminate()){
			percent = indeterminatePercent;
			indeterminatePercent += 0.05;
			if(indeterminatePercent > 1){
				indeterminatePercent = 0;
			}
		}else{
			percent = bar.getPercentComplete();
		}
		var bounds:IntRectangle = bounds.clone();
		if(fgMargin != null){
			bounds = fgMargin.getInsideBounds(bounds);
		}
		imageContainer.x = bounds.x;
		imageContainer.y = bounds.y;
		if(image){
			var brush:BitmapBrush;
			var matrix:Matrix = new Matrix();
			if(bar.getOrientation() == AsWingConstants.HORIZONTAL){
				brush = new BitmapBrush(horizotalBM, null, true, true);
				var scaleY:Number = bounds.height / image.height;
				matrix.scale(1, scaleY);
				brush.setMatrix(matrix);
				g.fillRectangle(brush, 0, 0, Math.round(bounds.width * percent), bounds.height);
			}else{
				brush = new BitmapBrush(verticalBM, null, true, true);
				var scaleX:Number = bounds.width / image.width;
				matrix.scale(scaleX, 1);
				brush.setMatrix(matrix);
				g.fillRectangle(brush, 0, 0, bounds.width, Math.round(bounds.height * percent));
			}
		}
	}
}
}