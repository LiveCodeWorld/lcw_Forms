script "behavior_LayoutPacked"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_LayoutPacked
type: behavior
version: 0.1

/*This layout has a graphic background and a central area fro a group or objects.*/


--> Objects
-
private function background_Button
   return the long id of button "_Background Button" of me
end background_Button


--> Icon
-
getprop icon_ID [iconName]
   put the number of images of me into maxNum
   repeat with imageNum = 1 to maxNum
      put the short name of image imageNum of me into testName
      if testName = iconName then
         return the short id of image imageNum of me
      end if
   end repeat
   return empty
end icon_ID

getprop icon_Name [iconID]
   put the short name of image id iconID of me into imageName
   return imageName
end icon_Name

getprop icon_Names
   put the number of images of me into maxNum
   repeat with imageNum = 1 to maxNum
      put the short name of image imageNum of me & CR after imageNames
   end repeat
   delete char -1 of imageNames
   return imageNames
end icon_Names

getprop icon_Images
   return _MyIconImages()
end icon_Images

setprop icon_Images iconImages 
   -- put the icon_Images of me into oldImages
   lock screen
   put _MyIconImages() into oldImages
   
   -- lets check iconImages
   repeat for each line imageObject in iconImages
      if exists (imageObject) is false then next repeat
      put the rugged_ID of imageObject into imageObject
      if imageObject is among the lines of oldImages then
         put imageObject & CR into imagesAlreadyThere
         next repeat -- lets ignore
      end if
      put imageObject & CR into imagesToAdd
   end repeat
   delete char -1 of imagesAlreadyThere
   delete char -1 of imagesToAdd
   
   -- lets delete everything that is not in imagesAlreadyThere
   repeat for each line imageObject in oldImages
      if imageObject is not among the lines of imagesAlreadyThere then
         delete imageObject
      end if
   end repeat
   
   -- lets add everything that is in imagesToAdd
   put imagesAlreadyThere into newImages
   repeat for each line imageObject in imagesToAdd
      copy imageObject to me
      put it into createdObject
      put createdObject & CR after newImages
   end repeat
   delete char -1 of newImages
   
   LayoutControl
   unlock screen
   return newImages
end icon_Images

setprop icon_NewImages newImages
   icon_AddImages newImages
end icon_NewImages

command icon_AddImages newImages
   lock screen
   repeat for each line imageObject in newImages
      copy imageObject to me
   end repeat
   LayoutControl
   unlock screen
   
   put the icon_Images of me into iconImages
   return iconImages
end icon_AddImages

private function _MyIconImages
   put the number of images of me into maxNum
   repeat with imageNum = 1 to maxNum
      put the rugged_ID of image imageNum of me & CR after iconImages
   end repeat
   delete char -1 of iconImages
   return iconImages
end _MyIconImages

on icons_DeleteAll
   repeat the number of images of me
      delete image 1 of me
   end repeat
end icons_DeleteAll

getprop icon_PushedDown
   if the dropShadow ["distance"] of the target = 5 then
      return false
   else
      return true
   end if
end icon_PushedDown

setprop icon_PushedDown someBoolean
   -- display_Lines the mobile_Name of the target
   if someBoolean = true then
      pushDown
   else
      popBack
   end if
end icon_PushedDown


--> Image
-
getprop image_Contents [imageFileType]
   put the long id of the target into imageObject
   if word 1 of imageObject is not "image" then return empty
   
   put the text of imageObject into someImage
   if the number of lines of someImage = 1 and there is a file someImage then
      put url ("binfile:" & someFile) into someImage
   end if
   return someImage
end image_Contents

setprop image_Contents someImage
   put the long id of the target into imageObject
   if word 1 of imageObject is not "image" then return empty
   
   lock screen
   if the number of lines of someImage = 1 and there is a file someImage then
      put someImage into someFile
      put url ("binfile:" & someFile) into someImage
   end if
   set the text of imageObject to someImage
end image_Contents


--> Events
-
on mouseEnter
   if word 1 of the target = "image" then
      set the colorOverlay ["color"] of the target to "255,254,207"
      set the colorOverlay ["blendmode"] of the target to "multiply"
      
      set the tooltip of the target to (the short name of the target && "(" & the short id of the target & ")")
   end if
end mouseEnter

on mouseLeave
   if word 1 of the target = "image" then
      set the colorOverlay of the target to empty
   end if
end mouseLeave

on mouseDown pMouseButton
   if pMouseButton = 3 then
      menu_PopUp "Global | Layouts | Resize | Packed | Menu"
   else if the drag_IconImage of me is true then
      drag_SetGlobalStatus true
      set the dragData ["private"] to the "View|Image|Icons"
   else
      pushDown
      pass mouseDown
   end if
end mouseDown

getprop menu_Target
   -- put menu_GetTopTargetObject
   return the long id of the target
end menu_Target

getprop drag_Enter
   put the dragdestination into testButton
   if word 1 of testButton is "button" then
      set the dragAction to "copy"
   end if
end drag_Enter

on mouseDown pMenuButton
   if pMenuButton = 3 then
      menu_PullDown "Global | Twitter | Tools | Button | Menu"
   else
      
   end if
end mouseDown

-- on mouseRelease
popBack
end mouseRelease

-- on mouseUp
popBack
end mouseUp


--> Events | Drag
-
on dragEnd
   put the dragsource into imageObject
   put the dragdestination into templateView
   if exists(templateView) is false then return empty
   view_CreateTemplateIconGroup templateView
   put the result into createdView
   set the icon_NewImages of createdView to imageObject
   return the result
end dragEnd

on dragEnter
   if the dragData ["files"] is empty then
      set the dragAction to "none"
   else
      set the dragAction to "copy"
   end if
end dragEnter

on dragDrop
   put the dragData ["files"] into someFiles
   put the rect of me into oRect
   repeat for each line someFile in someFiles
      if there is a folder someFile then
         put folder_NestedFilesInside (someFile) into foundFiles
         repeat for each line someFile in foundFiles
            set the cursor to busy
            create_IconImage someFile
         end repeat
      else if file_IsImage (someFile) then
         create_IconImage someFile
      end if
   end repeat
   set the view_Rect of me to oRect
end dragDrop

command create_IconImage someFile, pLinkToFile
   if file_IsImage (someFile) is false then return empty
   
   file_Deconstruct someFile, someRoot, shortName, fileExtension
   create image shortName in me
   put it into imageObject
   if pLinkToFile is true then
      set the filename of imageObject to someFile
   else
      set the image_Contents of imageObject to someFile
   end if
   set the icon_PushedDown of imageObject to false
   return imageObject
end create_IconImage

function file_IsImage someFile
   put file_GetType (someFile) into fType
   return fType = "image"
end file_IsImage


--> Drag | Utilities
-
getprop drag_IconImage
   put Local_Array ["drag_IconImage"] into dragIconImage
   if dragIconImage is empty then return true
   return dragIconImage
end drag_IconImage

setprop drag_IconImage isTrue
   put dragIconImage is true into Local_Array ["drag_IconImage"] 
end drag_IconImage


--> Private
-
private command pushDown
   set the dropShadow ["distance"] of the target to 1
   set the margins of the target to "2,2,0,0"
end pushDown

private command popBack
   set the dropShadow ["distance"] of the target to 5
   set the margins of the target to 0
end popBack


--> Geometry
-
getprop view_Spacer
   return 4
end view_Spacer

on resizeControl
    if the long id of target is not the long id of me then pass resizeControl
    LayoutControl
end resizeControl

setprop view_Rect someRect
   if the long id of target is not the long id of me then pass view_Rect
   lock screen
   set the rect of me to someRect
   LayoutControl someRect
   unlock screen
end view_Rect

getprop image_Spacer
   return 8
end image_Spacer

on LayoutControl someRect
   if the long id of the target is not the long id of me then return empty -- this is important for nested datagrids at the moment.
   if someRect is empty then put the rect of me into someRect
   
   lock screen 
   put the inner_Rect [someRect] of me into graphicRect
   
   put background_Button() into bButton
   put the image_Spacer of me into imageSpacer
   put rect_Subtract (imageSpacer, graphicRect) into innerRect
   
   put item 1 of innerRect into innerLeft
   put item 2 of innerRect into lastTop
   put item 3 of innerRect into innerRight
   put item 4 of innerRect into innerBottom
   
   put 0 into rowHeight
   put innerLeft into lastLeft
   put item 3 of innerRect - item 1 of innerRect into innerWidth
   set the vScrollbar of me to false
   repeat with imageNum = 1 to the number of images of me
      put the long id of image imageNum of me into imageObject
      
      put the formattedWidth of imageObject into fWidth
      put the formattedHeight of imageObject into fHeight
      put lastLeft + fWidth into imageRight
      
      if imageRight > innerRight then
         -- lets move it down a row
         add rowHeight + imageSpacer to lastTop
         put 0 into rowHeight
         put innerLeft into lastLeft
         put lastLeft + fWidth into imageRight
      end if
      
      put lastLeft,lastTop into imageRect
      put imageRight into item 3 of imageRect
      put lastTop + fHeight into lastBottom
      put lastBottom into item 4 of imageRect
      
      if lastBottom >innerBottom then
         set the vScrollbar of me to true
      end if
      
      set the rect of imageObject to imageRect
      
      put max (rowHeight, fHeight) into rowHeight
      add fWidth + imageSpacer to lastLeft
   end repeat
   
   set the rect of bButton to innerRect
   unlock screen
end LayoutControl
