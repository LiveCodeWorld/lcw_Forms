script "Global | Image | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Image | Menu
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
   -- called once for each menu
   return the display_View of tObject
end menu_Target


--> Global | Image | Menu
-
on menu_ChooseImage mTarget
   answer file "Select an image..."
   if it is empty then exit to top
   
   set the image_File of mTarget to it
   set the image_ResizeQuality of mTarget to "best"
end menu_ChooseImage

on menu_ClearImage mTarget
   set the show_Image of mTarget to false
   set the image_Contents of mTarget to empty
end menu_ClearImage

on _
end _

on submenu_Image
   return "Global | Image | Menu"
end submenu_Image

on submenu_Masked
   return "Global | Image | Masked | Menu"
end submenu_Masked

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on _TestImageRect viewObject
   set the image_Rect of viewObject to the rect of viewObject
end _TestImageRect
