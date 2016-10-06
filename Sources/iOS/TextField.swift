/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
<<<<<<< HEAD
 *	*	Neither the name of CosmicMind nor the names of its
=======
 *	*	Neither the name of Material nor the names of its
>>>>>>> 597bb57... Add left view supporte for place holder
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit

public protocol TextFieldDelegate: UITextFieldDelegate {}

@IBDesignable
<<<<<<< HEAD
open class TextField: UITextField {
    /// Default size when using AutoLayout.
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 32)
    }
    
    /// A Boolean that indicates if the TextField is in an animating state.
	open private(set) var animating = false
	
	/// A property that accesses the backing layer's backgroundColor.
	@IBInspectable
    open override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.cgColor
		}
	}
	
    /// Reference to the divider.
	open private(set) var divider: CAShapeLayer!
	
	/// Divider height.
	@IBInspectable
    open var dividerHeight: CGFloat = 1
	
	/// Divider active state height.
	@IBInspectable
    open var dividerActiveHeight: CGFloat = 2
	
	/// Sets the divider.
	@IBInspectable
    open var dividerColor: UIColor = Color.darkText.dividers {
		didSet {
			if !isEditing {
				divider.backgroundColor = dividerColor.cgColor
			}
		}
	}
	
	/// Sets the divider.
	@IBInspectable
    open var dividerActiveColor: UIColor? {
		didSet {
			if let v: UIColor = dividerActiveColor {
				if isEditing {
					divider.backgroundColor = v.cgColor
				}
			}
		}
	}
	
	/// The placeholderLabel font value.
	@IBInspectable
    open override var font: UIFont? {
		didSet {
			placeholderLabel.font = font
		}
	}
 
	/// TextField's text property observer.
	@IBInspectable
    open override var text: String? {
		didSet {
			if true == text?.isEmpty && !isFirstResponder {
				placeholderEditingDidEndAnimation()
			}
		}
	}
	
	/// The placeholderLabel text value.
	@IBInspectable
    open override var placeholder: String? {
		get {
			return placeholderLabel.text
		}
		set(value) {
			placeholderLabel.text = value
			if let v: String = value {
				placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderColor])
			}
		}
	}
	
	/// The placeholder UILabel.
	@IBInspectable
    open private(set) var placeholderLabel: UILabel!
	
	/// Placeholder textColor.
	@IBInspectable
    open var placeholderColor = Color.darkText.others {
		didSet {
			if !isEditing {
				if let v: String = placeholder {
					placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderColor])
				}
			}
		}
	}
	
	/// Placeholder active textColor.
	@IBInspectable
    open var placeholderActiveColor = Color.blue.base {
		didSet {
			if isEditing {
				if let v: String = placeholder {
					placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderActiveColor])
				}
			}
			tintColor = placeholderActiveColor
		}
	}
	
	/// This property adds a padding to placeholder y position animation
	open var placeholderVerticalOffset: CGFloat = 0
	
	/// The detailLabel UILabel that is displayed.
	@IBInspectable
    open private(set) lazy var detailLabel = UILabel(frame: .zero)
	
	
	/// The detailLabel text value.
	@IBInspectable
    open var detail: String? {
		get {
			return detailLabel.text
		}
		set(value) {
			detailLabel.text = value
			if let v: String = value {
				detailLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: detailColor])
			}
			layoutDetailLabel()
		}
	}
	
	/// Detail textColor.
	@IBInspectable
    open var detailColor = Color.darkText.others {
		didSet {
			if let v: String = detailLabel.text {
				detailLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: detailColor])
			}
		}
	}
    
	/// Vertical distance for the detailLabel from the divider.
	@IBInspectable
    open var detailVerticalOffset: CGFloat = 8 {
		didSet {
			layoutDetailLabel()
		}
	}
	
	/// Handles the textAlignment of the placeholderLabel.
	open override var textAlignment: NSTextAlignment {
		get {
			return super.textAlignment
		}
		set(value) {
			super.textAlignment = value
			placeholderLabel.textAlignment = value
			detailLabel.textAlignment = value
		}
	}
	
	/// Enables the clearIconButton.
	@IBInspectable
    open var enableClearIconButton: Bool {
		get {
			return nil != clearIconButton
		}
		set(value) {
			if value {
				if nil == clearIconButton {
                    clearIconButton = IconButton(image: Icon.cm.clear, tintColor: placeholderColor)
					clearIconButton!.contentEdgeInsets = .zero
					clearIconButton!.pulseAnimation = .center
                    clearButtonMode = .never
					rightViewMode = .whileEditing
					rightView = clearIconButton
					clearIconButtonAutoHandle = clearIconButtonAutoHandle ? true : false
				}
			} else {
				clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
				clearIconButton = nil
			}
		}
	}
	
	/// Enables the automatic handling of the clearIconButton.
	@IBInspectable
    open var clearIconButtonAutoHandle = true {
		didSet {
			clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
			if clearIconButtonAutoHandle {
				clearIconButton?.addTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
			}
		}
	}
	
	/// Enables the visibilityIconButton.
	@IBInspectable
    open var enableVisibilityIconButton: Bool {
		get {
			return nil != visibilityIconButton
		}
		set(value) {
			if value {
				if nil == visibilityIconButton {
                    visibilityIconButton = IconButton(image: Icon.visibility, tintColor: placeholderColor.withAlphaComponent(isSecureTextEntry ? 0.38 : 0.54))
					visibilityIconButton!.contentEdgeInsets = .zero
					visibilityIconButton!.pulseAnimation = .center
					isSecureTextEntry = true
					clearButtonMode = .never
					rightViewMode = .whileEditing
					rightView = visibilityIconButton
					visibilityIconButtonAutoHandle = visibilityIconButtonAutoHandle ? true : false
				}
			} else {
				visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
				visibilityIconButton = nil
			}
		}
	}
	
	/// Enables the automatic handling of the visibilityIconButton.
	@IBInspectable
    open var visibilityIconButtonAutoHandle: Bool = true {
		didSet {
			visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
			if visibilityIconButtonAutoHandle {
				visibilityIconButton?.addTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
			}
		}
	}
	
	/// A reference to the clearIconButton.
	open private(set) var clearIconButton: IconButton?
	
	/// A reference to the visibilityIconButton.
	open private(set) var visibilityIconButton: IconButton?
	
    /**
     `layoutIfNeeded` is called within `becomeFirstResponder` to
     fix an issue that when the TextField calls `becomeFirstResponder`
     immediately when launching an instance, the TextField is not
     calculated correctly.
     */
    open override func becomeFirstResponder() -> Bool {
        layoutIfNeeded()
        return super.becomeFirstResponder()
    }
    
	/**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareView()
	}
	
	/**
     An initializer that initializes the object with a CGRect object.
     If AutoLayout is used, it is better to initilize the instance
     using the init() initializer.
     - Parameter frame: A CGRect instance.
     */
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: .zero)
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
        layoutToSize()
	}
	
	open override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		if self.layer == layer {
            layoutShape()
			layoutDivider()
		}
	}
	
	/// Handles the text editing did begin state.
	open func handleEditingDidBegin() {
        dividerEditingDidBeginAnimation()
		placeholderEditingDidBeginAnimation()
	}
	
	/// Handles the text editing did end state.
	open func handleEditingDidEnd() {
		dividerEditingDidEndAnimation()
		placeholderEditingDidEndAnimation()
	}
	
	/// Handles the clearIconButton TouchUpInside event.
	open func handleClearIconButton() {
		if false == delegate?.textFieldShouldClear?(self) {
			return
		}
		text = nil
	}
	
	/// Handles the visibilityIconButton TouchUpInside event.
	open func handleVisibilityIconButton() {
		isSecureTextEntry = !isSecureTextEntry
		if !isSecureTextEntry {
			super.font = nil
			font = placeholderLabel.font
		}
		visibilityIconButton?.tintColor = visibilityIconButton?.tintColor.withAlphaComponent(isSecureTextEntry ? 0.38 : 0.54)
	}
	
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepareView method
     to initialize property values and other setup operations.
     The super.prepareView method should always be called immediately
     when subclassing.
     */
	open func prepareView() {
		super.placeholder = nil
        clipsToBounds = false
		borderStyle = .none
		backgroundColor = nil
		contentScaleFactor = Device.scale
		prepareDivider()
		preparePlaceholderLabel()
		prepareDetailLabel()
		prepareTargetHandlers()
        prepareTextAlignment()
	}
    
	/// Ensures that the components are sized correctly.
	open func layoutToSize() {
		if !animating {
            layoutPlaceholderLabel()
			layoutDetailLabel()
			layoutClearIconButton()
			layoutVisibilityIconButton()
		}
	}
	
	/// Layout the divider.
	open func layoutDivider() {
        divider.frame = CGRect(x: 0, y: height, width: width, height: isEditing ? dividerActiveHeight : dividerHeight)
	}
	
	/// Layout the placeholderLabel.
	open func layoutPlaceholderLabel() {
		if !isEditing && true == text?.isEmpty {
			placeholderLabel.frame = bounds
		} else if placeholderLabel.transform.isIdentity {
			placeholderLabel.frame = bounds
			placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
			switch textAlignment {
			case .left, .natural:
				placeholderLabel.x = 0
			case .right:
				placeholderLabel.x = width - placeholderLabel.width
			default:break
			}
			placeholderLabel.y = -placeholderLabel.height + placeholderVerticalOffset
			placeholderLabel.textColor = placeholderColor
		} else {
			switch textAlignment {
			case .left, .natural:
				placeholderLabel.x = 0
			case .right:
				placeholderLabel.x = width - placeholderLabel.width
			case .center:
				placeholderLabel.center.x = width / 2
			default:break
			}
			placeholderLabel.width = width * 0.75
		}
	}
	
	/// Layout the detailLabel.
	open func layoutDetailLabel() {
		let h: CGFloat = nil == detail ? 12 : detailLabel.font.stringSize(string: detail!, constrainedToWidth: Double(width)).height
        detailLabel.frame = CGRect(x: 0, y: divider.y + detailVerticalOffset, width: width, height: h)
	}
	
	/// Layout the clearIconButton.
	open func layoutClearIconButton() {
		if let v = clearIconButton {
			if 0 < width && 0 < height {
                v.frame = CGRect(x: width - height, y: 0, width: height, height: height)
			}
		}
	}
	
	/// Layout the visibilityIconButton.
	open func layoutVisibilityIconButton() {
		if let v = visibilityIconButton {
			if 0 < width && 0 < height {
                v.frame = CGRect(x: width - height, y: 0, width: height, height: height)
			}
		}
	}
	
	/// The animation for the divider when editing begins.
	open func dividerEditingDidBeginAnimation() {
		divider.height = dividerActiveHeight
		divider.backgroundColor = nil == dividerActiveColor ? placeholderActiveColor.cgColor : dividerActiveColor!.cgColor
	}
	
	/// The animation for the divider when editing ends.
	open func dividerEditingDidEndAnimation() {
		divider.frame.size.height = dividerHeight
		divider.backgroundColor = dividerColor.cgColor
	}
	
	/// The animation for the placeholder when editing begins.
	open func placeholderEditingDidBeginAnimation() {
		if placeholderLabel.transform.isIdentity {
			animating = true
			UIView.animate(withDuration: 0.15, animations: { [weak self] in
				if let s = self {
					s.placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
					switch s.textAlignment {
					case .left, .natural:
						s.placeholderLabel.x = 0
					case .right:
						s.placeholderLabel.x = s.width - s.placeholderLabel.width
					default:break
					}
					s.placeholderLabel.y = -s.placeholderLabel.height + s.placeholderVerticalOffset
					s.placeholderLabel.textColor = s.placeholderActiveColor
				}
			}) { [weak self] _ in
				self?.animating = false
			}
		} else if isEditing {
			placeholderLabel.textColor = placeholderActiveColor
		}
	}
	
	/// The animation for the placeholder when editing ends.
	open func placeholderEditingDidEndAnimation() {
		if !placeholderLabel.transform.isIdentity && true == text?.isEmpty {
			animating = true
			UIView.animate(withDuration: 0.15, animations: { [weak self] in
				if let s = self {
					s.placeholderLabel.transform = CGAffineTransform.identity
					s.placeholderLabel.x = 0
					s.placeholderLabel.y = 0
					s.placeholderLabel.textColor = s.placeholderColor
				}
			}) { [weak self] _ in
				self?.animating = false
			}
		} else if !isEditing {
			placeholderLabel.textColor = placeholderColor
		}
	}
	
	/// Prepares the divider.
	private func prepareDivider() {
        divider = CAShapeLayer()
		dividerColor = Color.darkText.dividers
		layer.addSublayer(divider)
	}
	
	/// Prepares the placeholderLabel.
	private func preparePlaceholderLabel() {
        placeholderLabel = UILabel(frame: .zero)
		placeholderColor = Color.darkText.others
        font = RobotoFont.regular(with: 16)
        addSubview(placeholderLabel)
	}
	
	/// Prepares the detailLabel.
	private func prepareDetailLabel() {
        detailLabel.font = RobotoFont.regular(with: 12)
		detailColor = Color.darkText.others
		addSubview(detailLabel)
	}
	
	/// Prepares the target handlers.
	private func prepareTargetHandlers() {
		addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
		addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
	}
    
    /// Prepares the textAlignment.
    private func prepareTextAlignment() {
<<<<<<< HEAD
<<<<<<< HEAD
        textAlignment = .rightToLeft == UIApplication.shared.userInterfaceLayoutDirection ? .right : .left
=======
        //textAlignment = .RightToLeft == UIApplication.sharedApplication().userInterfaceLayoutDirection ? .Right : .Left
=======
>>>>>>> d28e1f5... Clean code and conversion to swift 2.3
        #if MATERIAL_APP_EXTENSIONS
            //can't use shared in app extension
            //fall back to checking the bundle's preferred localization character direction
            //Courtesy of PureLayout
            let isRightToLeftLayout = NSLocale.characterDirectionForLanguage(NSBundle.mainBundle().preferredLocalizations[0]) == .RightToLeft
        #else
            let isRightToLeftLayout = UIApplication.sharedApplication().userInterfaceLayoutDirection == .RightToLeft
        #endif
=======
public class TextField : UITextField {
  /// A Boolean that indicates if the TextField is in an animating state.
  public private(set) var animating: Bool = false

  /**
   This property is the same as clipsToBounds. It crops any of the view's
   contents from bleeding past the view's frame.
   */
  @IBInspectable public var masksToBounds: Bool {
    get {
      return layer.masksToBounds
    }
    set(value) {
      layer.masksToBounds = value
    }
  }

  /// A property that accesses the backing layer's backgroundColor.
  @IBInspectable public override var backgroundColor: UIColor? {
    didSet {
      layer.backgroundColor = backgroundColor?.CGColor
    }
  }

  /// A property that accesses the layer.frame.origin.x property.
  @IBInspectable public var x: CGFloat {
    get {
      return layer.frame.origin.x
    }
    set(value) {
      layer.frame.origin.x = value
    }
  }

  /// A property that accesses the layer.frame.origin.y property.
  @IBInspectable public var y: CGFloat {
    get {
      return layer.frame.origin.y
    }
    set(value) {
      layer.frame.origin.y = value
    }
  }

  /// A property that accesses the layer.frame.size.width property.
  @IBInspectable public var width: CGFloat {
    get {
      return layer.frame.size.width
    }
    set(value) {
      layer.frame.size.width = value
    }
  }

  /// A property that accesses the layer.frame.size.height property.
  @IBInspectable public var height: CGFloat {
    get {
      return layer.frame.size.height
    }
    set(value) {
      layer.frame.size.height = value
    }
  }

  /// A property that accesses the layer.position property.
  @IBInspectable public var position: CGPoint {
    get {
      return layer.position
    }
    set(value) {
      layer.position = value
    }
  }

  /// A property that accesses the layer.zPosition property.
  @IBInspectable public var zPosition: CGFloat {
    get {
      return layer.zPosition
    }
    set(value) {
      layer.zPosition = value
    }
  }

  /// Reference to the divider.
  public private(set) lazy var divider: CAShapeLayer = CAShapeLayer()

  /// Divider height.
  @IBInspectable public var dividerHeight: CGFloat = 1
>>>>>>> 597bb57... Add left view supporte for place holder

  /// Divider active state height.
  @IBInspectable public var dividerActiveHeight: CGFloat = 2

<<<<<<< HEAD
>>>>>>> 10a61d8... Extension safe for swift 2.3
=======
  /// Sets the divider.
  @IBInspectable public var dividerColor: UIColor = MaterialColor.darkText.dividers {
    didSet {
      if !editing {
        divider.backgroundColor = dividerColor.CGColor
      }
>>>>>>> 597bb57... Add left view supporte for place holder
    }
  }

  /// Sets the divider.
  @IBInspectable public var dividerActiveColor: UIColor? {
    didSet {
      if let v: UIColor = dividerActiveColor {
        if editing {
          divider.backgroundColor = v.CGColor
        }
      }
    }
  }

  /// The placeholderLabel font value.
  @IBInspectable public override var font: UIFont? {
    didSet {
      placeholderLabel.font = font
    }
  }

  /// TextField's text property observer.
  @IBInspectable public override var text: String? {
    didSet {
      if true == text?.isEmpty && !isFirstResponder() {
        placeholderEditingDidEndAnimation()
      }
    }
  }

  /// The placeholderLabel text value.
  @IBInspectable public override var placeholder: String? {
    get {
      return placeholderLabel.text
    }
    set(value) {
      placeholderLabel.text = value
      if let v: String = value {
        placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderColor])
      }
    }
  }

  /// The placeholder UILabel.
  @IBInspectable public private(set) lazy var placeholderLabel: UILabel = UILabel(frame: CGRect.zero)

  /// Placeholder textColor.
  @IBInspectable public var placeholderColor: UIColor = MaterialColor.darkText.others {
    didSet {
      if !editing {
        if let v: String = placeholder {
          placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderColor])
        }
      }
    }
  }

  /// Placeholder active textColor.
  @IBInspectable public var placeholderActiveColor: UIColor = MaterialColor.blue.base {
    didSet {
      if editing {
        if let v: String = placeholder {
          placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderActiveColor])
        }
      }
      tintColor = placeholderActiveColor
    }
  }

  /// This property adds a padding to placeholder y position animation
  public var placeholderVerticalOffset: CGFloat = 0

  /// The detailLabel UILabel that is displayed.
  @IBInspectable public private(set) lazy var detailLabel: UILabel = UILabel(frame: CGRect.zero)


  /// The detailLabel text value.
  @IBInspectable public var detail: String? {
    get {
      return detailLabel.text
    }
    set(value) {
      detailLabel.text = value
      if let v: String = value {
        detailLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: detailColor])
      }
      layoutDetailLabel()
    }
  }

  /// Detail textColor.
  @IBInspectable public var detailColor: UIColor = MaterialColor.darkText.others {
    didSet {
      if let v: String = detailLabel.text {
        detailLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: detailColor])
      }
    }
  }

  /// Vertical distance for the detailLabel from the divider.
  @IBInspectable public var detailVerticalOffset: CGFloat = 8 {
    didSet {
      layoutDetailLabel()
    }
  }

  /// Handles the textAlignment of the placeholderLabel.
  public override var textAlignment: NSTextAlignment {
    get {
      return super.textAlignment
    }
    set(value) {
      super.textAlignment = value
      placeholderLabel.textAlignment = value
      detailLabel.textAlignment = value
    }
  }

  /// Enables the clearIconButton.
  @IBInspectable public var enableClearIconButton: Bool {
    get {
      return nil != clearIconButton
    }
    set(value) {
      if value {
        if nil == clearIconButton {
          let image: UIImage? = MaterialIcon.cm.clear
          clearIconButton = IconButton(frame: CGRect.zero)
          clearIconButton!.contentEdgeInsets = UIEdgeInsetsZero
          clearIconButton!.pulseAnimation = .Center
          clearIconButton!.tintColor = placeholderColor
          clearIconButton!.setImage(image, forState: .Normal)
          clearIconButton!.setImage(image, forState: .Highlighted)
          clearButtonMode = .Never
          rightViewMode = .WhileEditing
          rightView = clearIconButton
          clearIconButtonAutoHandle = clearIconButtonAutoHandle ? true : false
        }
      } else {
        clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), forControlEvents: .TouchUpInside)
        clearIconButton = nil
      }
    }
  }

  /// Enables the automatic handling of the clearIconButton.
  @IBInspectable public var clearIconButtonAutoHandle: Bool = true {
    didSet {
      clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), forControlEvents: .TouchUpInside)
      if clearIconButtonAutoHandle {
        clearIconButton?.addTarget(self, action: #selector(handleClearIconButton), forControlEvents: .TouchUpInside)
      }
    }
  }

  /// Enables the visibilityIconButton.
  @IBInspectable public var enableVisibilityIconButton: Bool {
    get {
      return nil != visibilityIconButton
    }
    set(value) {
      if value {
        if nil == visibilityIconButton {
          let image: UIImage? = MaterialIcon.visibility
          visibilityIconButton = IconButton(frame: CGRect.zero)
          visibilityIconButton!.contentEdgeInsets = UIEdgeInsetsZero
          visibilityIconButton!.pulseAnimation = .Center
          visibilityIconButton!.tintColor = placeholderColor
          visibilityIconButton!.setImage(image, forState: .Normal)
          visibilityIconButton!.setImage(image, forState: .Highlighted)
          visibilityIconButton!.tintColor = placeholderColor.colorWithAlphaComponent(secureTextEntry ? 0.38 : 0.54)
          secureTextEntry = true
          clearButtonMode = .Never
          rightViewMode = .WhileEditing
          rightView = visibilityIconButton
          visibilityIconButtonAutoHandle = visibilityIconButtonAutoHandle ? true : false
        }
      } else {
        visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), forControlEvents: .TouchUpInside)
        visibilityIconButton = nil
      }
    }
  }

  /// Enables the automatic handling of the visibilityIconButton.
  @IBInspectable public var visibilityIconButtonAutoHandle: Bool = true {
    didSet {
      visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), forControlEvents: .TouchUpInside)
      if visibilityIconButtonAutoHandle {
        visibilityIconButton?.addTarget(self, action: #selector(handleVisibilityIconButton), forControlEvents: .TouchUpInside)
      }
    }
  }

  /// A reference to the clearIconButton.
  public private(set) var clearIconButton: IconButton?

  /// A reference to the visibilityIconButton.
  public private(set) var visibilityIconButton: IconButton?

  /**
   An initializer that initializes the object with a NSCoder object.
   - Parameter aDecoder: A NSCoder instance.
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepareView()
  }

  /**
   An initializer that initializes the object with a CGRect object.
   If AutoLayout is used, it is better to initilize the instance
   using the init() initializer.
   - Parameter frame: A CGRect instance.
   */
  public override init(frame: CGRect) {
    super.init(frame: frame)
    prepareView()
  }

  /// A convenience initializer.
  public convenience init() {
    self.init(frame: CGRect.zero)
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    layoutToSize()
  }

  public override func layoutSublayersOfLayer(layer: CALayer) {
    super.layoutSublayersOfLayer(layer)
    if self.layer == layer {
      layoutDivider()
    }
  }

  /// Default size when using AutoLayout.
  public override func intrinsicContentSize() -> CGSize {
    return CGSizeMake(width, 32)
  }

  /**
   A method that accepts CAAnimation objects and executes them on the
   view's backing layer.
   - Parameter animation: A CAAnimation instance.
   */
  public func animate(animation: CAAnimation) {
    animation.delegate = self
    if let a: CABasicAnimation = animation as? CABasicAnimation {
      a.fromValue = (nil == layer.presentationLayer() ? layer : layer.presentationLayer() as! CALayer).valueForKeyPath(a.keyPath!)
    }
    if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
      layer.addAnimation(a, forKey: a.keyPath!)
    } else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
      layer.addAnimation(a, forKey: nil)
    } else if let a: CATransition = animation as? CATransition {
      layer.addAnimation(a, forKey: kCATransition)
    }
  }

  /**
   A delegation method that is executed when the backing layer starts
   running an animation.
   - Parameter anim: The currently running CAAnimation instance.
   */
  public override func animationDidStart(anim: CAAnimation) {
    (delegate as? MaterialAnimationDelegate)?.materialAnimationDidStart?(anim)
  }

  /**
   A delegation method that is executed when the backing layer stops
   running an animation.
   - Parameter anim: The CAAnimation instance that stopped running.
   - Parameter flag: A boolean that indicates if the animation stopped
   because it was completed or interrupted. True if completed, false
   if interrupted.
   */
  public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    if let a: CAPropertyAnimation = anim as? CAPropertyAnimation {
      if let b: CABasicAnimation = a as? CABasicAnimation {
        if let v: AnyObject = b.toValue {
          if let k: String = b.keyPath {
            layer.setValue(v, forKeyPath: k)
            layer.removeAnimationForKey(k)
          }
        }
      }
      (delegate as? MaterialAnimationDelegate)?.materialAnimationDidStop?(anim, finished: flag)
    } else if let a: CAAnimationGroup = anim as? CAAnimationGroup {
      for x in a.animations! {
        animationDidStop(x, finished: true)
      }
    }
  }

  /// Handles the text editing did begin state.
  public func handleEditingDidBegin() {
    dividerEditingDidBeginAnimation()
    placeholderEditingDidBeginAnimation()
  }

  /// Handles the text editing did end state.
  public func handleEditingDidEnd() {
    dividerEditingDidEndAnimation()
    placeholderEditingDidEndAnimation()
  }

  /// Handles the clearIconButton TouchUpInside event.
  public func handleClearIconButton() {
    if false == delegate?.textFieldShouldClear?(self) {
      return
    }
    text = nil
  }

  /// Handles the visibilityIconButton TouchUpInside event.
  public func handleVisibilityIconButton() {
    secureTextEntry = !secureTextEntry
    if !secureTextEntry {
      super.font = nil
      font = placeholderLabel.font
    }
    visibilityIconButton?.tintColor = visibilityIconButton?.tintColor.colorWithAlphaComponent(secureTextEntry ? 0.38 : 0.54)
  }

  /**
   Prepares the view instance when intialized. When subclassing,
   it is recommended to override the prepareView method
   to initialize property values and other setup operations.
   The super.prepareView method should always be called immediately
   when subclassing.
   */
  public func prepareView() {
    super.placeholder = nil
    masksToBounds = false
    borderStyle = .None
    backgroundColor = nil
    font = RobotoFont.regularWithSize(16)
    contentScaleFactor = MaterialDevice.scale
    prepareDivider()
    preparePlaceholderLabel()
    prepareDetailLabel()
    prepareTargetHandlers()
    prepareTextAlignment()
  }

  /// Ensures that the components are sized correctly.
  public func layoutToSize() {
    if !animating {
      layoutPlaceholderLabel()
      layoutDetailLabel()
      layoutClearIconButton()
      layoutVisibilityIconButton()
    }
  }

  /// Layout the divider.
  public func layoutDivider() {
    divider.frame = CGRectMake(0, height, width, editing ? dividerActiveHeight : dividerHeight)
  }

  /// Layout the placeholderLabel.
  public func layoutPlaceholderLabel() {



    if !editing && true == text?.isEmpty {
      if let leftView = self.leftView {
        placeholderLabel.frame = CGRectMake(leftView.frame.size.width, bounds.origin.y, bounds.size.width - 30, bounds.size.height)
      } else {
        placeholderLabel.frame = bounds
      }
    } else if CGAffineTransformIsIdentity(placeholderLabel.transform) {
      placeholderLabel.frame = bounds
      placeholderLabel.transform = CGAffineTransformMakeScale(0.75, 0.75)
      switch textAlignment {
      case .Left, .Natural:
        placeholderLabel.frame.origin.x = 0
      case .Right:
        placeholderLabel.frame.origin.x = width - placeholderLabel.frame.width
      default:break
      }
      placeholderLabel.frame.origin.y = -placeholderLabel.frame.size.height + placeholderVerticalOffset
      placeholderLabel.textColor = placeholderColor
    } else {
      switch textAlignment {
      case .Left, .Natural:
        placeholderLabel.frame.origin.x = 0
      case .Right:
        placeholderLabel.frame.origin.x = width - placeholderLabel.frame.width
      case .Center:
        placeholderLabel.center.x = width / 2
      default:break
      }
      placeholderLabel.frame.size.width = width * 0.75
    }
  }

  /// Layout the detailLabel.
  public func layoutDetailLabel() {
    let h: CGFloat = nil == detail ? 12 : detailLabel.font.stringSize(detail!, constrainedToWidth: Double(width)).height
    detailLabel.frame = CGRectMake(0, divider.frame.origin.y + detailVerticalOffset, width, h)
  }

  /// Layout the clearIconButton.
  public func layoutClearIconButton() {
    if let v: IconButton = clearIconButton {
      if 0 < width && 0 < height {
        v.frame = CGRectMake(width - height, 0, height, height)
      }
    }
  }

  /// Layout the visibilityIconButton.
  public func layoutVisibilityIconButton() {
    if let v: IconButton = visibilityIconButton {
      if 0 < width && 0 < height {
        v.frame = CGRectMake(width - height, 0, height, height)
      }
    }
  }

  /// The animation for the divider when editing begins.
  public func dividerEditingDidBeginAnimation() {
    divider.frame.size.height = dividerActiveHeight
    divider.backgroundColor = nil == dividerActiveColor ? placeholderActiveColor.CGColor : dividerActiveColor!.CGColor
  }

  /// The animation for the divider when editing ends.
  public func dividerEditingDidEndAnimation() {
    divider.frame.size.height = dividerHeight
    divider.backgroundColor = dividerColor.CGColor
  }

  /// The animation for the placeholder when editing begins.
  public func placeholderEditingDidBeginAnimation() {
    if CGAffineTransformIsIdentity(placeholderLabel.transform) {
      animating = true
      UIView.animateWithDuration(0.15, animations: { [weak self] in
        if let v: TextField = self {
          v.placeholderLabel.transform = CGAffineTransformMakeScale(0.75, 0.75)
          switch v.textAlignment {
          case .Left, .Natural:
            v.placeholderLabel.frame.origin.x = 0
          case .Right:
            v.placeholderLabel.frame.origin.x = v.width - v.placeholderLabel.frame.width
          default:break
          }
          v.placeholderLabel.frame.origin.y = -v.placeholderLabel.frame.size.height + v.placeholderVerticalOffset
          v.placeholderLabel.textColor = v.placeholderActiveColor
        }
      }) { [weak self] _ in
        self?.animating = false
      }
    } else if editing {
      placeholderLabel.textColor = placeholderActiveColor
    }
  }

  /// The animation for the placeholder when editing ends.
  public func placeholderEditingDidEndAnimation() {
    if !CGAffineTransformIsIdentity(placeholderLabel.transform) && true == text?.isEmpty {
      animating = true
      UIView.animateWithDuration(0.15, animations: { [weak self] in
        if let v: TextField = self {
          var originX = CGFloat(0)
          var originY = CGFloat(0)

          if let leftView = v.leftView {
            originX = leftView.frame.size.width
          }

          v.placeholderLabel.transform = CGAffineTransformIdentity
          v.placeholderLabel.frame.origin.x = originX
          v.placeholderLabel.frame.origin.y = originY
          v.placeholderLabel.textColor = v.placeholderColor
        }
      }) { [weak self] _ in
        self?.animating = false
      }
    } else if !editing {
      placeholderLabel.textColor = placeholderColor
    }
  }

  /// Prepares the divider.
  private func prepareDivider() {
    dividerColor = MaterialColor.darkText.dividers
    layer.addSublayer(divider)
  }
  
  /// Prepares the placeholderLabel.
  private func preparePlaceholderLabel() {
    placeholderColor = MaterialColor.darkText.others
    addSubview(placeholderLabel)
  }
  
  /// Prepares the detailLabel.
  private func prepareDetailLabel() {
    detailLabel.font = RobotoFont.regularWithSize(12)
    detailColor = MaterialColor.darkText.others
    addSubview(detailLabel)
  }
  
  /// Prepares the target handlers.
  private func prepareTargetHandlers() {
    addTarget(self, action: #selector(handleEditingDidBegin), forControlEvents: .EditingDidBegin)
    addTarget(self, action: #selector(handleEditingDidEnd), forControlEvents: .EditingDidEnd)
  }
  
  /// Prepares the textAlignment.
  private func prepareTextAlignment() {
    #if MATERIAL_APP_EXTENSIONS
      //can't use shared in app extension
      //fall back to checking the bundle's preferred localization character direction
      //Courtesy of PureLayout
      let isRightToLeftLayout = NSLocale.characterDirectionForLanguage(NSBundle.mainBundle().preferredLocalizations[0]) == .RightToLeft
    #else
      let isRightToLeftLayout = UIApplication.sharedApplication().userInterfaceLayoutDirection == .RightToLeft
    #endif
    
    textAlignment = isRightToLeftLayout ? .Right : .Left
    
  }
}
