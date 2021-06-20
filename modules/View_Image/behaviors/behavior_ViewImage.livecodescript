script "behavior_ViewImage"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewImage
type: behavior
version: 0.1

--> MetaData
-
author: David Bovill
copyright: David Bovill
name: View|Image|Fit Inside
type: view behavior

/*
Everything you'd want an image to be :)
*/

--> Working on
-

--> Props
-
getprop formatted_Width
   put the image_Object of me into imageObject
   put the formattedwidth of imageObject into fWidth
   return fWidth
end formatted_Width

getprop formatted_Height
   put the image_Object of me into imageObject
   put the formattedheight of imageObject into fHeight
   return fHeight
end formatted_Height

getprop formatted_Rect [pHow]
   put the image_Object of me into imageObject
   --
   put the rect of me into oRect
   put the formattedwidth of imageObject into fWidth
   put the formattedheight of imageObject into fHeight
   --
   switch char 1 of pHow
      case "f" -- "fit inside"
         put rect_FitInside (fWidth, fHeight, oRect) into imageRect
         return imageRect
      case "c" -- centred
         put oRect into imageRect
         rect_SetWidth imageRect, fWidth, false
         rect_SetHeight imageRect, fHeight, false
         return imageRect
      default -- aligned left
         put item 1 of oRect + fWidth into item 3 of oRect
         put item 2 of oRect + fHeight into item 4 of oRect
         return oRect
   end switch
end formatted_Rect

getprop image_FormattedDimensions
   put the image_Object of me into imageObject
   put the formattedwidth of imageObject into fWidth
   put the formattedheight of imageObject into fHeight
   return fWidth,fHeight
end image_FormattedDimensions


/*
--> Events
-
on mouseDown pButtonNum
   if pButtonNum = 3 then
      put the title_Menu of me into titleMenu
      menu_PopUp titleMenu
   else
      pass mouseDown
   end if
end mouseDown

on mouseDoubleUp
   gif_ToggleRepeatCount
   pass mouseDoubleUp
end mouseDoubleUp

--> Events | Background
-
/*
These events are only triggered when this group is a shared background.
*/

on arrowkey pWhich
   put the image_Object of me into imageObject
   put the currentframe of imageObject into cFrame
   switch pWhich
      case "up"
         set the currentframe of imageObject to 1
         break
      case "left"
         set the currentframe of imageObject to (cFrame - 1)
         break
      case "right"
         set the currentframe of imageObject to (cFrame + 1)
         break
      case "down"
         set the currentframe of imageObject to the framecount of imageObject
         break
   end switch
end arrowkey

on keydown pWhich
   switch pWhich
      case " "
         put the image_Object of me into imageObject
         gif_ToggleRepeatCount imageObject
         break
      default
         pass keydown
   end switch
end keydown


--> Gif
-
command gif_ToggleRepeatCount pImageObject
   if exists (pImageObject) is false then 
      put the long id of the target into pImageObject
   end if
   if word 1 of pImageObject is not "image" then
      return empty
   end if
   
   if the repeatcount of pImageObject is not 0 then
      set the repeatcount of pImageObject to 0
   else
      set the repeatcount of pImageObject to -1
   end if
   return pImageObject
end gif_ToggleRepeatCount
*/


--> Events | Drag and Drop
-
on dragDrop
   put the dragdata["files"] into imageFiles
   
   set the cursor to watch
   put line 1 of imageFiles into imageFile
   if the shiftKey is "Down" then
      put "binfile:" & imageFile into imageUrl
      put url imageUrl into someImage
      set the image_Contents of me to someImage
   else
      set the image_File of me to imageFile
   end if
end dragDrop

on dragEnter
   set the dragaction to "link"
   pass dragEnter
end dragEnter


--> Image
-
getprop image_Angle
   put the image_Object of me into imageObject
   put the angle of imageObject into imageAngle
   return imageAngle
end image_Angle

setprop image_Angle someAngle
   put the image_Object of me into imageObject
   lock screen
   set the angle of imageObject to someAngle
   LayoutControl
   unlock screen
end image_Angle

getprop image_Angles
   return "-180,-90,0,90,180"
end image_Angles

getprop image_Rotation
   -- not tested
   put the image_Object of me into imageObject
   put the uOPN ["image_Rotation"] of me into someAngle
   if someAngle is empty then put 0 into someAngle
   return someAngle
end image_Rotation

setprop image_Rotation someAngle
   -- not tested
   put the image_Object of me into imageObject
   lock screen
   rotate imageObject by someAngle
   set the uOPN ["image_Rotation"] of me to someAngle
   LayoutControl
   unlock screen
end image_Rotation

getprop image_Rotations
   return "-180,-90,0,90,180"
end image_Rotations

getprop resize_Style
   set lockmessages to true
   put the resize_Style of me into resizeStyle
   set lockmessages to false
   --
   if resizeStyle is empty then put "fit inside frame" into resizeStyle
   return resizeStyle
end resize_Style

setprop resize_Style resizeStyle
   put the rect of me into oRect
   set the image_Rect [resizeStyle] of me to oRect
   put the result into imageRect
   
   set lockmessages to true
   set the resize_Style of me to resizeStyle
   set lockmessages to false
   -- LayoutControl oRect
   return imageRect
end resize_Style

getprop resize_Styles
   return "centre,fit inside frame,fit to width"
end resize_Styles

getprop image_IsResized
   put the image_Object of me into imageObject
   put the formattedwidth of imageObject = the width of imageObject into widthSame
   put the formattedheight of imageObject = the height of imageObject into heightSame
   return not (widthSame and heightSame)
end image_IsResized

setprop image_IsResized someBoolean
   -- only makes sense if false
   if someBoolean is false then
      put the image_Object of me into imageObject
      put the formattedwidth of imageObject into fWidth
      put the formattedheight of imageObject into fHeight
      put the rect of imageObject into someRect
      rect_CentreWidthAndHeight someRect, fWidth, fHeight
      rect_AddMargins someRect, the margins of me
      LayoutControl someRect
   end if
end image_IsResized

getprop image_Contents [imageFileType]
   put the image_Object of me into imageObject
   --
   put the filename of imageObject into someFile
   if someFile is not empty then
      put url ("binfile:" & someFile) into someImage
   else if imageFileType is empty then
      put the text of imageObject into someImage
   else
      put merge ("export [[imageObject]] to someImage as [[imageFileType]]") into doScript
      replace "'" with quote in doScript
      do doScript
   end if
   return someImage
end image_Contents

setprop image_Contents [someRect] someImage
   put the image_Object of me into imageObject
   
   lock screen
   set the text of imageObject to someImage
   --
   switch
      case someRect is a point
         set the rect of me to someRect
         break
      case someRect is a point
         put item 1 of someRect into someWidth
         put item 2 of someRect into someHeight
         rect_CentreWidthAndHeight someRect, someWidth, someHeight
         set the rect of me to someRect
         break
   end switch
   unlock screen
end image_Contents

getprop resized_Image
   put the image_Object of me into imageObject
   -- set the imagedata of imageObject to the imagedata of imageObject
   get the text of imageObject
   return it
end resized_Image

setprop resized_Image [someRect] someImage
   put the image_Object of me into imageObject
   
   if someRect is not a rect then
      put item 1 of someRect into someWidth
      put item 2 of someRect into someHeight
      put the rect of imageObject into someRect
      rect_CentreWidthAndHeight someRect, someWidth, someHeight
      rect_SubtractMargins someRect
   end if
   
   lock screen
   set the text of imageObject to someImage
   -- set the rect of imageObject to someRect
   LayoutControl
   -- set the imagedata of imageObject to the imagedata of imageObject
   unlock screen
   
   put the text of imageObject into resizedImage
   return resizedImage
end resized_Image

setprop image_File someFile
   put the image_Object of me into imageObject
   
   lock screen
   -- put the rect of me into oRect
   set the filename of imageObject to empty
   set the filename of imageObject to someFile
   Layoutcontrol -- oRect
   unlock screen
end image_File

getprop image_File
   put the image_Object of the target into imageObject
   if exists(imageObject) is false then return empty
   return the filename of imageObject
end image_File


--> Image | Asynchronous
-
/*
As "load" sends a specific message to the target it must be in the view,
as other wise there is no way to know what the view is without hacking.
*/

setprop image_Loaded [unloadAfter] photoURL
   set the loading_Photo of me to photoURL
   if unloadAfter is false then
      load url photoURL with message "image_DisplayLoaded"
   else
      load url photoURL with message "image_DisplayAndUnload"
   end if
end image_Loaded

on image_DisplayAndUnload someURL, someStatus
   if someStatus is "cached" then
      put url someURL into someImage
      set the image_Contents of me to someImage
      
      unload url someURL
      set the loading_Photo of me to empty
   else
      set the error_Display of me to someStatus
   end if
end image_DisplayAndUnload

on image_DisplayLoaded someURL, someStatus
   if someStatus is "cached" then
      put url someURL into someImage
      set the image_Contents of me to someImage
      
      set the loading_Photo of me to empty
   else
      set the error_Display of me to someStatus
   end if
end image_DisplayLoaded


--> Geometry
-
getprop image_Width [pResizeStyle]
   put the rect of me into sRect
   put _GetResizedRect (sRect, pResizeStyle) into imageRect
   put item 3 of imageRect - item 1 of imageRect into imageWidth
   return imageWidth
end image_Width

getprop image_Height [pResizeStyle]
   put the rect of me into sRect
   put _GetResizedRect (sRect, pResizeStyle) into imageRect
   put item 4 of imageRect - item 2 of imageRect into imageHeight
   return imageHeight
end image_Height

getprop image_Rect [pResizeStyle]
   put the rect of me into sRect
   put _GetResizedRect (sRect, pResizeStyle) into imageRect
   return imageRect
end image_Rect

setprop image_Rect [pResizeStyle] sRect
   put _GetResizedRect (sRect, pResizeStyle) into imageRect
   set the rect of me to imageRect
   return imageRect
end image_Rect

private function _GetResizedRect sRect, pResizeStyle
   if _ImageIsEmpty() then
      return sRect
   else
      if pResizeStyle is empty then
         put the resize_Style of me into pResizeStyle
      end if
      put the formattedwidth of me into fWidth
      put the formattedheight of me into fHeight
      put _GetImageRect (sRect, fWidth, fHeight, pResizeStyle) into imageRect
      return imageRect
   end if
end _GetResizedRect

on resizeControl
   LayoutControl
end resizeControl

on LayoutControl pRect
   if pRect is empty then put the rect of me into pRect
   
   if _ImageIsEmpty() then
      -- put pRect into imageRect
      set the rect of me to pRect
   else
      /*
      put the formattedwidth of me into fWidth
      put the formattedheight of me into fHeight
      put the resize_Style of me into resizeStyle
      put _GetImageRect (pRect, fWidth, fHeight, resizeStyle) into imageRect
      */
      set the image_Rect of me to pRect
   end if
end LayoutControl

getprop formatted_Width
   if the long id of the target is not the long id of me then pass formatted_Width
   put the image_Object of me into imageObject
   
   put the formattedwidth of imageObject into fWidth
   put the margins of me into myMargins
   margin_Normalize myMargins, lMargin, tMargin, rMargin, bMargin   
   add (lMargin + rMargin) to fWidth
   return fWidth
end formatted_Width

getprop formatted_Height
   if the long id of the target is not the long id of me then pass formatted_Height
   put the image_Object of me into imageObject
   
   put the formattedheight of imageObject into fHeight
   put the margins of me into myMargins
   margin_Normalize myMargins, lMargin, tMargin, rMargin, bMargin
   add (tMargin + bMargin) to fHeight
   return fHeight
end formatted_Height


--> Private
-
private function _GetImageRect pRect, fWidth, fHeight, resizeStyle
   switch resizeStyle
      case "fit to width"
         put rect_FitToTopWidth (fWidth, fHeight, pRect) into imageRect
         break
      case "fit inside frame"
         put rect_FitInside (fWidth, fHeight, pRect) into imageRect
         break
      default
         put pRect into imageRect
         rect_SetWidth imageRect, fWidth, false
         rect_SetHeight imageRect, fHeight, false
   end switch
   --
   return imageRect
end _GetImageRect

private function _ImageIsEmpty
   switch
      case the filename of me is not empty
      case the text of me is not empty
         return false
      default
         return true
   end switch
end _ImageIsEmpty


--> Objects
-
getprop image_Object
   return the long id of me
end image_Object

getprop view_Object
   return the long id of me
end view_Object
