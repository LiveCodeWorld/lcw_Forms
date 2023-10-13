script "Global | Form | Simple | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Form | Simple | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-

--> Global | Form | Simple | Menu
-
on menu_EmptyForm viewObject
   set the form_Records of viewObject to empty
end menu_EmptyForm

on _
end _

on submenu_Dev
   return menu_DevTitle()
end submenu_Dev
