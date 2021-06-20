script "Global | Form | Simple | Menu"
--> MetaData
-
copyright: Anonymous
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
on menu_Init tObject
   -- called only once for top menu
   pass menu_Init
end menu_Init


--> Global | Form | Simple | Menu
-
on menu_TestForm viewObject
   put "View|Layout|Placeholder" & CR after vNames
   put "View|Record|File" & CR after vNames
   put "View|Record|CharField|Basic" & CR after vNames
   put "View|Layout|Placeholder" & CR after vNames
   put "View|Layout|Placeholder" & CR after vNames
   delete char -1 of vNames
   --
   set the form_InsertView of viewObject to vNames
end menu_TestForm

on menu_EmptyForm viewObject
   set the form_Records of viewObject to empty
end menu_EmptyForm

on _
end _

getprop checked_FormIsRed [viewObject]
   put the form_IsRed of viewObject into isRed
   return isRed
end checked_FormIsRed

on menu_FormIsRed viewObject
   -- put menu_GetChecked (the params)
   put the form_IsRed of viewObject is false into notRed
   --
   set the form_IsRed of viewObject to notRed
end menu_FormIsRed

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_Experiment viewObject
   edit the script of viewObject
end menu_Experiment


--> Deps
-
