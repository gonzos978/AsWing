/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing{

import org.aswing.geom.IntDimension;
import org.aswing.geom.IntRectangle;
import org.aswing.geom.IntPoint;
import org.aswing.event.InteractiveEvent;

/**
 * JViewport is an basic viewport to view normal components. Generally JViewport works 
 * with JScrollPane together, for example:<br>
 * <pre>
 *     var scrollPane:JScrollPane = new JScrollPane();
 *     var viewport:JViewport = new JViewport(yourScrollContentComponent, true, false);
 *     scrollPane.setViewport(viewport);
 * </pre>
 * Then you'll get a scrollpane with scroll content and only vertical scrollbar. And 
 * the scroll content will always tracks the scroll pane width.
 * @author iiley
 */
public class JViewport extends Container implements Viewportable{
 	
 	/**
 	 * The default unit/block increment, it means auto count a value.
 	 */
 	public static const AUTO_INCREMENT:int = -999999999;
 	
	private var verticalUnitIncrement:int;
	private var verticalBlockIncrement:int;
	private var horizontalUnitIncrement:int;
	private var horizontalBlockIncrement:int;
	
	private var tracksHeight:Boolean;
	private var tracksWidth:Boolean;
	
	private var view:Component;
	
	/**
	 * Create a viewport with view and size tracks properties.
	 * @see #setView()
	 * @see #setTracksWidth()
	 * @see #setTracksHeight()
	 */
	public function JViewport(view:Component=null, tracksWidth:Boolean=false, tracksHeight:Boolean=false){
		super();
		setName("JViewport");
		this.tracksWidth = tracksWidth;
		this.tracksHeight = tracksHeight;
		verticalUnitIncrement = AUTO_INCREMENT;
		verticalBlockIncrement = AUTO_INCREMENT;
		horizontalUnitIncrement = AUTO_INCREMENT;
		horizontalBlockIncrement = AUTO_INCREMENT;
		if(view != null) setView(view);
		setLayout(new ViewportLayout());
		updateUI();
	}
    
	override public function updateUI():void{
    	setUI(UIManager.getUI(this));
    }
	
	override public function getUIClassID():String{
		return "ViewportUI";
	}	

	/**
	 * @throws Error if the layout is not a ViewportLayout
	 */
	override public function setLayout(layout:LayoutManager):void{
		if(layout is ViewportLayout){
			super.setLayout(layout);
		}else{
			throw new Error("Only on set ViewportLayout to JViewport");
		}
	}
	
	/**
	 * Sets whether the view tracks viewport width. Default is false<br>
	 * If true, the view will always be set to the same size as the viewport.<br>
	 * If false, the view will be set to it's preffered size.
	 * @param b tracks width
	 */
	public function setTracksWidth(b:Boolean):void{
		if(b != tracksWidth){
			tracksWidth = b;
			revalidate();
		}
	}
	
	/**
	 * Returns whether the view tracks viewport width. Default is false<br>
	 * If true, the view will always be set to the same width as the viewport.<br>
	 * If false, the view will be set to it's preffered width.
	 * @return whether tracks width
	 */
	public function isTracksWidth():Boolean{
		return tracksWidth;
	}
	
	/**
	 * Sets whether the view tracks viewport height. Default is false<br>
	 * If true, the view will always be set to the same height as the viewport.<br>
	 * If false, the view will be set to it's preffered height.
	 * @param b tracks height
	 */
	public function setTracksHeight(b:Boolean):void{
		if(tracksHeight != b){
			tracksHeight = b;
			revalidate();
		}
	}
	
	/**
	 * Returns whether the view tracks viewport height. Default is false<br>
	 * If true, the view will always be set to the same height as the viewport.<br>
	 * If false, the view will be set to it's preffered height.
	 * @return whether tracks height
	 */
	public function isTracksHeight():Boolean{
		return tracksHeight;
	}
	
	/**
	 * Sets the view component.
	 * 
	 * <p>The view is the visible content of the JViewPort.</p>
	 * 
	 * <p>JViewport use to manage the scroll view of a component.
	 * the component will be set size to its preferred size, then scroll in the viewport.<br>
	 * </p>
	 * <p>If the component's isTracksViewportWidth method is defined and return true,
	 * when the viewport's show size is larger than the component's,
	 * the component will be widen to the show size, otherwise, not widen.
	 * Same as isTracksViewportHeight method.
	 * </p>
	 */
	public function setView(view:Component):void{
		if(this.view != view){
			this.view = view;
			removeAll();
			
			if(view != null){
				insertImp(-1, view);
			}
			fireStateChanged();
		}
	}
	
	public function getView():Component{
		return view;
	}
		
	/**
	 * Sets the unit value for the Vertical scrolling.
	 */
    public function setVerticalUnitIncrement(increment:int):void{
    	if(verticalUnitIncrement != increment){
    		verticalUnitIncrement = increment;
			fireStateChanged();
    	}
    }
    
    /**
     * Sets the block value for the Vertical scrolling.
     */
    public function setVerticalBlockIncrement(increment:int):void{
    	if(verticalBlockIncrement != increment){
    		verticalBlockIncrement = increment;
			fireStateChanged();
    	}
    }
    
	/**
	 * Sets the unit value for the Horizontal scrolling.
	 */
    public function setHorizontalUnitIncrement(increment:int):void{
    	if(horizontalUnitIncrement != increment){
    		horizontalUnitIncrement = increment;
			fireStateChanged();
    	}
    }
    
    /**
     * Sets the block value for the Horizontal scrolling.
     */
    public function setHorizontalBlockIncrement(increment:int):void{
    	if(horizontalBlockIncrement != increment){
    		horizontalBlockIncrement = increment;
			fireStateChanged();
    	}
    }		
			
	
	/**
	 * In fact just call setView(com) in this method
	 * @see #setView()
	 */
	override public function append(com:Component, constraints:Object=null):void{
		setView(com);
	}
	
	/**
	 * In fact just call setView(com) in this method
	 * @see #setView()
	 */	
	override public function insert(i:int, com:Component, constraints:Object=null):void{
		setView(com);
	}
	
	//--------------------implementatcion of Viewportable---------------

	/**
	 * Returns the unit value for the Vertical scrolling.
	 */
    public function getVerticalUnitIncrement():int{
    	if(verticalUnitIncrement != AUTO_INCREMENT){
    		return verticalUnitIncrement;
    	}else{
    		return Math.max(getExtentSize().height/100, 1);
    	}
    }
    
    /**
     * Return the block value for the Vertical scrolling.
     */
    public function getVerticalBlockIncrement():int{
    	if(verticalBlockIncrement != AUTO_INCREMENT){
    		return verticalBlockIncrement;
    	}else{
    		return getExtentSize().height-1;
    	}
    }
    
	/**
	 * Returns the unit value for the Horizontal scrolling.
	 */
    public function getHorizontalUnitIncrement():int{
    	if(horizontalUnitIncrement != AUTO_INCREMENT){
    		return horizontalUnitIncrement;
    	}else{
    		return Math.max(getExtentSize().width/100, 1);
    	}
    }
    
    /**
     * Return the block value for the Horizontal scrolling.
     */
    public function getHorizontalBlockIncrement():int{
    	if(horizontalBlockIncrement != AUTO_INCREMENT){
    		return horizontalBlockIncrement;
    	}else{
    		return getExtentSize().width - 1;
    	}
    }
    
    public function setViewportTestSize(s:IntDimension):void{
    	setSize(s);
    }

	public function getExtentSize() : IntDimension {
		return getInsets().getInsideSize(getSize());
	}
	
	/**
     * Usually the view's preffered size.
     * @return the view's size, (0, 0) if view is null.
	 */
	public function getViewSize() : IntDimension {
		if(view == null){
			return new IntDimension();
		}else{
			if(isTracksWidth() && isTracksHeight()){
				return getExtentSize();
			}else{
				var viewSize:IntDimension = view.getPreferredSize();
				var extentSize:IntDimension = getExtentSize();
				if(isTracksWidth()){
					viewSize.width = extentSize.width;
				}else if(isTracksHeight()){
					viewSize.height = extentSize.height;
				}
				return viewSize;
			}
		}
	}
	
	/**
	 * Returns the view's position, if there is not any view, return null.
	 * @return the view's position, null if view is null.
	 */
	public function getViewPosition() : IntPoint {
		if(view != null){
			var p:IntPoint = view.getLocation();
			var ir:IntRectangle = getInsets().getInsideBounds(getSize().getBounds());
			p.x = ir.x - p.x;
			p.y = ir.y - p.y;
			return p;
		}else{
			return null;
		}
	}

	public function setViewPosition(p : IntPoint) : void {
		restrictionViewPos(p);
		if(!p.equals(getViewPosition())){
			var ir:IntRectangle = getInsets().getInsideBounds(getSize().getBounds());
			view.setLocationXY(ir.x-p.x, ir.y-p.y);
			fireStateChanged();
		}
	}

	public function scrollRectToVisible(contentRect : IntRectangle) : void {
		setViewPosition(new IntPoint(contentRect.x, contentRect.y));
	}
	
	/**
	 * Scrolls view vertical with delta pixels.
	 */
	public function scrollVertical(delta:int):void{
		setViewPosition(getViewPosition().move(0, delta));
	}
	
	/**
	 * Scrolls view horizontal with delta pixels.
	 */
	public function scrollHorizontal(delta:int):void{
		setViewPosition(getViewPosition().move(delta, 0));
	}
	
	/**
	 * Scrolls to view bottom left content. 
	 * This will make the scrollbars of <code>JScrollPane</code> scrolled automatically, 
	 * if it is located in a <code>JScrollPane</code>.
	 */
	public function scrollToBottomLeft():void{
		setViewPosition(new IntPoint(0, getViewMaxPos().y));
	}
	/**
	 * Scrolls to view bottom right content. 
	 * This will make the scrollbars of <code>JScrollPane</code> scrolled automatically, 
	 * if it is located in a <code>JScrollPane</code>.
	 */	
	public function scrollToBottomRight():void{
		setViewPosition(getViewMaxPos());
	}
	/**
	 * Scrolls to view top left content. 
	 * This will make the scrollbars of <code>JScrollPane</code> scrolled automatically, 
	 * if it is located in a <code>JScrollPane</code>.
	 */	
	public function scrollToTopLeft():void{
		setViewPosition(new IntPoint(0, 0));
	}
	/**
	 * Scrolls to view to right content. 
	 * This will make the scrollbars of <code>JScrollPane</code> scrolled automatically, 
	 * if it is located in a <code>JScrollPane</code>.
	 */	
	public function scrollToTopRight():void{
		setViewPosition(new IntPoint(getViewMaxPos().x, 0));
	}
	
	/**
	 * Restrict the view pos in valid range.(between min, max value)
	 */
	protected function restrictionViewPos(p:IntPoint):IntPoint{
		var maxPos:IntPoint = getViewMaxPos();
		p.x = Math.max(0, Math.min(maxPos.x, p.x));
		p.y = Math.max(0, Math.min(maxPos.y, p.y));
		return p;
	}
	
	private function getViewMaxPos():IntPoint{
		var showSize:IntDimension = getExtentSize();
		var viewSize:IntDimension = getViewSize();
		var p:IntPoint = new IntPoint(viewSize.width-showSize.width, viewSize.height-showSize.height);
		if(p.x < 0) p.x = 0;
		if(p.y < 0) p.y = 0;
		return p;
	}
    	
	/**
	 * Add a listener to listen the viewpoat state change event.
	 * <p>
	 * When the viewpoat's state changed, the state is all about:
	 * <ul>
	 * <li>viewPosition
	 * </ul>
	 * @param listener the listener
	 * @param priority the priority
	 * @param useWeakReference Determines whether the reference to the listener is strong or weak.
	 * @see org.aswing.event.AWEvent#STATE_CHANGED
	 */
	public function addStateListener(listener:Function, priority:int=0, useWeakReference:Boolean=false):void{
		addEventListener(InteractiveEvent.STATE_CHANGED, listener, false, priority);
	}	
	
	/**
	 * Removes a state listener.
	 * @param listener the listener to be removed.
	 * @see org.aswing.event.AWEvent#STATE_CHANGED
	 */	
	public function removeStateListener(listener:Function):void{
		removeEventListener(InteractiveEvent.STATE_CHANGED, listener);
	}
	
	protected function fireStateChanged():void{
		dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
	}
	
	public function getViewportPane() : Component {
		return this;
	}
}
}