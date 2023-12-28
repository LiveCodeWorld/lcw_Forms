script "behavior_ViewCodeLine"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewCodeLine
type: behavior
version: 0.1

/*
Here you make make notes as a basic form of help for this view.
Full help text can be found on the linked wiki for the view.
*/

--> Variable
-
local LocalArray


--> Working on
-
on do_Script
   put the script_Text of me into doScript
   put the do_Language of me into doLanguage
   --
   switch doLanguage
      case "javascript"
         
         break
      case "shell"
         
         break
      default
         do doScript
   end switch
end do_Script


--> Props
-
getprop script_Text
   return the text of _FieldObject()
end script_Text

setprop script_Text sText
   set the text of _FieldObject() to sText
end script_Text

getprop dont_Wrap
   return the dontwrap of _FieldObject()
end dont_Wrap

setprop dont_Wrap sBoolean
   set the dontwrap of _FieldObject() to sBoolean is true
end dont_Wrap


--> Menu | Props
-
getprop menu_Title
   put the view_Name of me into viewName
   put menu_GlobalTitleFromViewName (viewName) into mTitle
   return mTitle
end menu_Title



--> Events
-
on mouseDown pButtonNumber
   switch pButtonNumber
      case 3
         put true into LocalArray ["Menu Active"]
         --
         put the long id of me into tObject
         put the menu_Title of tObject into mTitle
         put the menu_Button of tObject into mButton
         --
         mArray_PopUp mTitle, mButton, tObject
         break
      default
         put false into LocalArray ["Menu Active"]
         pass mouseDown
   end switch
end mouseDown

on mouseUp
   if LocalArray ["Menu Active"] is treu then
      pass mouseUp
   end if
   
   do_Script
end mouseUp

on resizeControl
   put the rect of me into viewRect
   LayoutControl viewRect
end resizeControl

private function _ButtonWidth minFieldHeight, sButton, btnMargin
   if the showborder of sButton is true then
      put the borderWidth of sButton into bWidth
      put minFieldHeight - 2 * bWidth into minFieldHeight
   end if
   return minFieldHeight
   
   put the formattedwidth of sButton into formattedButtonWidth
   put formattedButtonWidth + btnMargin into btnWidth
end _ButtonWidth

command LayoutControl pRect
   lock screen
   if pRect is empty then put the rect of me into pRect
   put _ButtonObject() into sButton
   put _FieldObject() into sField
   
   # Work out geometry   
   put the inner_Rect [pRect] of me into innerRect
   put 4 into btnMargin
   
   put the formattedheight of sField into minFieldHeight
   put _ButtonWidth (minFieldHeight, sButton, btnMargin) into btnWidth
   
   # innerRect
   if _CheckSetFieldHeight (innerRect, minFieldHeight) then
      rect_SetHeight innerRect, minFieldHeight
   end if
   
   # btnRect
   -- put rect_Subtract (btnMargin, innerRect) into btnRect
   put innerRect into btnRect
   put item 1 of btnRect + btnWidth into btnRight
   put btnRight into item 3 of btnRect
   rect_SetHeight btnRect, btnWidth
   
   # fldRect
   put innerRect into fldRect
   put btnRight + btnMargin into item 1 of fldRect
   
   # Set Rects
   -- set lockmessages to true
   set the rect of sButton to btnRect
   set the rect of sField to fldRect
   -- set lockmessages to false
   unlock screen
end LayoutControl

private function _CheckSetFieldHeight innerRect, minFieldHeight
   return true
   
   put item 4 of innerRect - item 2 of innerRect into fHeight
   return fHeight < minFieldHeigh
end _CheckSetFieldHeight


--> Objects
-
private function _ButtonObject
   return the long id of button 1 of me
end _ButtonObject

private function _FieldObject
   return the long id of field 1 of me
end _FieldObject

getprop view_Object
   return the long id of me
end view_Object
