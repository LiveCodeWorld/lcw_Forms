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
on menu_TestImageRect viewObject
   set the image_Rect of viewObject to the rect of viewObject
end menu_TestImageRect

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_Experiment displayView
   put displayView
end menu_Experiment


--> Deps
-
