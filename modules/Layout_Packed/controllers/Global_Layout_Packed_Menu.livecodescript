script "Global | Layout | Packed | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Layout | Packed | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   -- return display_MenuTarget(tObject)
   return the display_View of tObject
end menu_Target

getprop menu_Target [tObject]
   switch
      case mName contains "Global | View | Script | Menu"
         put the layout_View of tObject into layoutView
         if exists (layoutView) is false then return imageObject
         put the inner_Control of layoutView into iconView
         if exists (iconView) is false then return imageObject
         return iconView
      case mName contains "Global | View | Properties | Menu"
         put the layout_View of  imageObject into layoutView
         if exists (layoutView) is false then return imageObject
         put the inner_Control of layoutView into iconView
         if exists (iconView) is false then return imageObject
         return iconView
      default
         return imageObject
   end switch
end menu_Target

getprop disabled_ExportIconImage [imageObject]
if word 1 of imageObject is not "image" then return true

put the filename of imageObject into imageFile
if imageFile is empty then return false 
if there is a file imageFile then return true

return false
end disabled_ExportIconImage

getprop disabled_ImportIconImage [imageObject]
   if word 1 of imageObject is not "image" then return true
   
   put the filename of imageObject into imageFile
   if imageFile is empty or there is not a file imageFile then return true
   
   return false
end disabled_ImportIconImage

getprop disabled_RevertToFileImage [imageObject]
   if word 1 of imageObject is not "image" then return true
   
   put the image_OriginalFile of imageObject into imageFile
   if there is not a file imageFile then return true
   
   return false
end disabled_RevertToFileImage

getprop disabled_ImportAllIcons [mTarget]
   put the icon_Images of mTarget into imageObjects
   repeat for each line imageObject in imageObjects
      put the text of imageObject is empty into notImported
      if notImported is true then
         return false
      end if
   end repeat
   return true
end disabled_ImportAllIcons

getprop disabled_ImportIconImage [mTarget]
   if word 1 of mTarget = "image" then
      return the text of mTarget is not empty
   else
      return "delete"
   end if
end disabled_ImportIconImage

getprop disabled_EditCardBehavior [mTarget]
   if exists (the behavior of mTarget) then
      return false
   else
      return true
   end if
end disabled_EditCardBehavior

getprop set_CardBehavior [mTarget]
   put the card_Object of mTarget into cardObject
   get the behavior_Name of cardObject
   return it = "Card Icons" 
end set_CardBehavior

command image_Export imageObject, pSavedFile, pImageFileType
   put the short id of imageObject into imageID
   -- put the stack_Name of imageObject into stackName
   put the stack_Object of imageObject into stackObject
   
   if pSavedFile is empty then
      put merge("Export this image as a [[imageFileType]]...") into someComment
      ask file someComment
      put it into pSavedFile
      if pSavedFile is empty then exit to top
   end if
   
   if the platform is MacOS then
      put the filetype into oFileType
   end if
   
   switch pImageFileType
      case "JPG"
         set the filetype to "prvwJPEG"
         export image id imageID of stackObject to file pSavedFile as JPEG 
         break
      case "JPEG"
         set the filetype to "prvwJPEG"
         export image id imageID of stackObject to file pSavedFile as JPEG 
         break
      case "GIF"
         export image id imageID of stackObject to file pSavedFile as GIF 
         break
      default
         set the filetype to "prvwPNGf"
         export image id imageID of stackObject to file pSavedFile as PNG 
   end switch
   
   if the platform is MacOS then
      set the filetype to oFileType
   end if
   return pSavedFile
end image_Export


--> Global | Layout | Packed | Menu
-
on menu_DisplayImage imageObject
   local pResizeStyle, pStackStyle, pStackRect, pKeepInvisible
   
   put the short name of imageObject into pStackLabel
   put the text of imageObject into someImage
   put "orange" into pBackgroundColour
   if someImage is empty then
      put the filename of imageObject into imageFile
      display_Image imageFile, pResizeStyle, pStackStyle, pStackLabel, pKeepInvisible, pStackRect, pBackgroundColour
   else
      display_ImageContents someImage, pResizeStyle, pStackStyle, pStackLabel, pKeepInvisible, pStackRect, pBackgroundColour
   end if
   put the result into imageView
   set the image_ToolTitle of imageView to "Global | Image | Magick | Menu"
end menu_DisplayImage

on menu_ResizeImage imageObject, someWidth
   put the loc of imageObject into someLoc
   put rect_LocWidthHeight (someLoc, someWidth, someWidth) into newRect
   set the lockloc of imageObject to true
   set the rect of imageObject to newRect
   set the imagedata of imageObject to the imagedata of imageObject
   set the lockloc of imageObject to false
   
   dispatch "LayoutControl" to imageObject
   dispatch "LayoutControl" to imageObject
end menu_ResizeImage

on _
end _

on submenu_Image
   return "Global | Image | Menu"
end submenu_Image

on menu_EditImageMenu imageObject, imageMenuTitle
   put menu_GetGlobalController (imageMenuTitle) into mController
   menu_EditScript imageMenuTitle
end menu_EditImageMenu

getprop image_MenuTitles
   put menu_ListGlobalTitles ("Global | Image *") into mTitles
   -- line_Delete "Global | Image | Menu", mTitles
   -- line_Insert "Global | Movie | Record | Menu", mTitles
   return mTitles
end image_MenuTitles


on submenu_Sips
    return "Global | Image | SIPS | Menu"
end submenu_Sips

on submenu_Exif
    return "Global | Exif | Menu"
end submenu_Exif

on submenu_Effects
   return "Global | Image | Effects | Menu"
end submenu_Effects

on submenu_Magick subMenu
    return "Global | Image | Magick | Menu", subMenu
end submenu_Magick

getprop some_Widths [imageObject]
   return "256,128,64,32"
end some_Widths

getprop some_Width [imageObject]
   put the width of imageObject into someWidth
   return someWidth
end some_Width

on _
end _

on menu_DeleteIcon imageObject
   put menu_GetTopTargetObject() into imageObject
   if word 1 of imageObject = "image" then
      send "delete imageObject" to imageObject in 0 ticks
   end if
end menu_DeleteIcon

on menu_DeleteOtherIcons imageObject
   put menu_GetTopTargetObject() into imageObject
   set the icon_Images of imageObject to imageObject
end menu_DeleteOtherIcons

on _
end _

on menu_ImportIconImage imageObject
   image_ImportFileData imageObject
   lcw_Notify the filename of imageObject -- into someFile
end menu_ImportIconImage

on menu_ExportIconImage imageObject
   image_Export imageObject
   put the result into imageFile
   set the filename of imageObject to imageFile
   set the image_OriginalFile of imageObject to imageFile
   
   lcw_Notify the filename of imageObject -- into someFile
end menu_ExportIconImage

on menu_RevertToFileImage imageObject  
   put the image_OriginalFile of imageObject into imageFile
   set the filename of imageObject to imageFile
   lcw_Notify the filename of imageObject -- into someFile
end menu_RevertToFileImage

on menu_ImportAllIcons mTarget
   put the icon_Images of mTarget into imageObjects
   repeat for each line imageObject in imageObjects
      set the cursor to busy
      image_ImportFileData imageObject
   end repeat
end menu_ImportAllIcons

on _
end _

on menu_RefreshLayout imageObject
   -- put menu_GetTopTargetObject() into imageObject
   dispatch "LayoutControl" to imageObject
end menu_RefreshLayout

on menu_UpdatePackedView imageObject
   put the layout_View of imageObject into packedView
   set the view_Swap of packedView to "View|Layout|Placeholder"
   set the view_Swap of packedView to "View|Layouts|Resize|Packed"
end menu_UpdatePackedView

on _
end _

on menu_SetCardBehavior mTarget, someBoolean
   put the card_Object of mTarget into cardObject
   set the behavior_Name of cardObject to "Card Icons"
end menu_SetCardBehavior

on menu_EditCardBehavior mTarget
   put the card_Object of mTarget into cardObject
   put the behavior of cardObject into someBeahviour
   edit the script of someBeahviour
end menu_EditCardBehavior

on submenu_View
   return "Global | View | Properties | Menu"
end submenu_View

on submenu_Script
   return "Global | View | Script | Menu"
end submenu_Script

on _
end _

on submenu_Development
   return "Dev | Menu"
end submenu_Development

on submenu_IconGroup
   return "Global | Image | Icon Group | Menu"
end submenu_IconGroup

on submenu_Dev
   return menu_DevTitle ("Global | Layout | Packed | Menu")
end submenu_Dev
