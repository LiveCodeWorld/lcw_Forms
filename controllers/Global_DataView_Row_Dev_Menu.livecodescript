﻿script "Global | DataView | Row | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | DataView | Row | Dev | Menu
type: controller
author: David Bovill
version: 0.1

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/

--> Variables
-
local LocalArray

--> Menu | Props
-
-- on menu_Init tObject
put tObject into LocalArray ["tObject"]
put the display_View of tObject into displayView
put displayView into LocalArray ["displayView"]
--
put the dv_LinkedDataView of tObject into dView
put dView into LocalArray ["dView"]
end menu_Init

getprop menu_Target [tObject]
   put the dvRowControl of tObject into rowView
   return rowView
end menu_Target

getprop disabled_RowBehavior [rowView]
   if exists (rowView) then
      return false
   else
      put the view_Object of tObject into viewObject
      if exists (viewObject) is false then
         return true
      else
         -- should add "getprop dvRowControl"
         return viewObject
      end if
   end if
   return false
end disabled_RowBehavior

private function _ClickedLinkedModuleName dView
   put _ClickedRowData (dView) into rowData
   --
   put rowData ["@style"] into itemStyle
   put "View|Wiki|" & text_InitialCaps(itemStyle) into moduleName
   --
   return moduleName
end _ClickedLinkedModuleName

private function _ClickedLinkedModule dView
   put _ClickedLinkedModuleName (dView) into moduleName
   put view_GetTemplateObject (moduleName) into rowModule
   --  put module_GetTemplateObject (moduleName) into rowModule
   return rowModule
end _ClickedLinkedModule

private function _ClickedRowData dView
   put the dvClickRow of dView into rowNum
   put the dvRowData [rowNum] of dView into rowData
   return rowData
end _ClickedRowData

getprop disabled_CreateRowModule [dView]
   put _ClickedLinkedModule (dView) into rowModule
   if exists (rowModule) then
      return "delete"
   else
      return false
   end if
end disabled_CreateRowModule

getprop SetTemplateForThisStyle_Param [rowView]
   put the dv_RowStyle of rowView into styleName
   put the dv_RowTemplateName [styleName] of rowView into moduleName
   return moduleName
end SetTemplateForThisStyle_Param

getprop SetTemplateForThisStyle_Params
   -- quick hack
   put the openStacks into stackNames
   filter stackNames with "View|*"
   return stackNames
end SetTemplateForThisStyle_Params


--> Global | DataView | Row | Dev | Menu
-
on menu_CreateRowModule rowView
   put LocalArray ["displayView"] into displayView
   put _ClickedLinkedModuleName (rowView) into moduleName
   --
   put lcw_Ask ("Do you want to create a new module for this row?", moduleName, displayView) into moduleName
   --
   module_CreateWithObject moduleName, "lcw_Forms",  "", displayView
end menu_CreateRowModule

on menu_GoToRowTemplate rowView
   get the name of rowView
   put the view_Name of rowView into viewName
   if viewName is empty then
      lcw_AnswerWarning "This row object is not a view!"
      --
      edit the script of rowView
      display_ObjectProperties rowView
   else
      put view_GetTemplateObject (viewName) into templateObject
      object_GoTo templateObject
   end if
end menu_GoToRowTemplate

on menu_RowProperties rowView
   display_ObjectProperties rowView
end menu_RowProperties

private on ___
end ___

on menu_RowData rowView
   put the dvClickRow of rowView into rowNum
   put the dvRowData [rowNum] of rowView into rowData
   --
   display_Data rowData, rowNum, "Row Data"
end menu_RowData

on menu_RowBehavior rowView
   put the behavior of rowView into bObject
   if exists (bObject) is false then
      put bObject
      lcw_AnswerWarning "Cannot locate behavior!"
   end if
   --
   edit the script of bObject
end menu_RowBehavior

private on ____
end ____

on menu_DisplayRowModule rowView
   put _ClickedLinkedModuleName (rowView) into moduleName
   put view_GetTemplateObject (moduleName) into rowModule
   --
   object_GoTo rowModule
   display_ModuleTools moduleName, true
end menu_DisplayRowModule

on menu_DisplayRowCardObject rowView
   put the dvControl of rowView into dView
   put the dvRowCardObject of dView
end menu_DisplayRowCardObject

private on _____
end _____

on menu_SetTemplateForThisStyle rowView, moduleName
   put the dv_RowStyle of rowView into styleName
   set the dv_RowTemplateName [styleName] of rowView to moduleName
end menu_SetTemplateForThisStyle

on menu_RenameStyle rowView
   breakpoint
   put lcw_Ask ("What style would you like to associate the template with?", "clause", dView) into styleName
end menu_RenameStyle

on submenu_RowMenu
   -- DynamicMenu
   put LocalArray ["dView"] into dView
   if exists (dView) is false then return empty
   --
   put the dvClickRow of dView into rowNum
   put the dvRowData [rowNum] of dView into rowData
   put rowData ["@style"] into itemStyle
   put merge ("Global | Wiki | [[itemStyle]] | Menu") into gMenuTitle
   switch itemStyle
      case "Text"
         return "Global | Wiki | Markdown | Menu"
      case "video"
         return "Global | Glitch | Menu"
      default
         -- important to include this as returning an array or other bad data mucks up recursion checking
         return gMenuTitle
   end switch
end submenu_RowMenu
