script "Global | DataView | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | DataView | Menu
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
   put tObject into LocalArray ["tObject"]
   get the name of tObject
   put the display_View of tObject into displayView
   put displayView into LocalArray ["displayView"]
   put stacks_ListOpen() into LocalArray ["oStackNames"]
end menu_Init

getprop menu_Target [tObject]
   -- _SelectedDataView()
   put the dv_LinkedDataView of tObject into dView
   --
   if exists (dView) is true then
      put the dv_RowStyleNames of dView into rowStyleNames
      sort rowStyleNames
   else
      put empty into rowStyleNames
   end if
   put rowStyleNames into LocalArray ["rowStyleNames"]
   --
   put dView into LocalArray ["dView"]
   return dView
end menu_Target

private function _SelectedRowView dView
   if exists (dView) is false then return empty
   
   put the dvClickRow of dView into rowNum
   put the dvControlOfRow [rowNum] of dView into rowView
   return rowView
end _SelectedRowView

private function _SelectedDataView
   get the selectedObject
   if it is empty then return empty
   put the dvControl of it into dView
   return dView
end _SelectedDataView

private function stacks_ListOpen
   put the openstacks into oStackNames
   filter oStackNames without "Display *"
   filter oStackNames without "rev*"
   filter oStackNames without "com.*"
   return oStackNames
end stacks_ListOpen

getprop disabled_DataViewData [dView]
   put _GetLinkedDataView() into dView
   return exists (dView) is false
end disabled_DataViewData

getprop disabled_RefreshSelected [dView]
   -- put _GetLinkedDataView() into dView
   return exists (dView) is false
end disabled_RefreshSelected

getprop disabled_Deselect [dView]
   put _SelectedDataView() into dView
   if exists (dView) then
      return false
   else
      return "delete"
   end if
end disabled_Deselect

getprop disabled_OpenRowStack [dView]
   put the dv_LinkedRowStack of dView into stackName
   if exists (stack stackName) then
      return false
   else
      return true
   end if
end disabled_OpenRowStack

getprop checked_SetLinkedDataView [dView]
   -- put _GetLinkedDataView() into dView
   return exists (dView)
end checked_SetLinkedDataView

getprop checked_CanDrag [dView]
   put the dv_CanDrag of dView into canDrag
   return canDrag
end checked_CanDrag

getprop openStackfile_Params [dView]
   put the stackfile_Array of dView into stackfileArray
   put keys (stackfileArray) into stackNames
   sort stackNames
   return stackNames
end openStackfile_Params

getprop checked_DataViewPalette [dView]
   put the view_Name of dView into viewName
   put display_FindView ("DataView", viewName) into displayView
   return exists (displayView)
end checked_DataViewPalette


--> Global | DataView | Menu
-
on menu_ObjectInspector dView, stackName
   object_Inspect dView
end menu_ObjectInspector

on menu_DataViewPalette dView
   display_DataView dView, "click"
end menu_DataViewPalette

private command _
end _

on submenu_ImportData
   return "Global | Wiki | Data | Menu"
end submenu_ImportData

on menu_CanDrag dView
   put the dv_CanDrag of dView is false into cantDrag
   set the dv_CanDrag of dView to cantDrag
end menu_CanDrag

on menu_RefreshDataView dView
   dispatch "ResetView" to dView
   dispatch "RenderView" to dView
   --
   set the behavior_Objects of dView to the behavior_Objects of dView -- no idea why
end menu_RefreshDataView

private command __
end __

on submenu_Templates
   return "Global | DataView | Template | Menu"
end submenu_Templates

on submenu_Behaviors
   return "Global | DataView | Behaviors | Menu"
end submenu_Behaviors

private command ___
end ___

on menu_OpenStackfile dView, stackName
   put the dv_LinkedRowStack of dView into stackName
   go to stack stackName
end menu_OpenStackfile

on menu_DisplayStackFileArray dView
   put the stackFile_Array of dView into stackFileArray
   put "DataView" && kwote (the short name of dView) into sTitle
   --
   display_Data stackFileArray, "Stackfile Array", sTitle
end menu_DisplayStackFileArray

private command ____
end ____

on menu_SetLinkedDataView dView
   put the selectedObject into someContainer
   if someContainer is empty then
      put the long id of the current card of the topStack into someContainer
   end if
   --
   put the dv_Controls of someContainer into dvControls
   put line 1 of dvControls into dView
   
   put the short id of dView into dvID
   put the stack_Name of someContainer into stackName
   select group id dvID of stack stackName
   
   lcw_Answer "Do you want to set the linked dataview of this menu to the selectedobj?"
   --
   set the dv_LinkedDataView of dView to dView
   --
   put the card_Object of dView into cObject
   set the dv_LinkedDataView of cObject to dView
   --
   put LocalArray ["displayView"] into displayView
   if exists (displayView) is true then
      set the dv_LinkedDataView of displayView to dView
   end if
end menu_SetLinkedDataView

on menu_Deselect
   select empty
end menu_Deselect

private command _____
end _____

on menu_Documentation
   launch url "https://github.com/trevordevore/levurehelper-dataview"
end menu_Documentation

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Props
-
command levure_CreateDataViewDialog pTargetCard, pBehavior, pRowStyleTemplateGroupsA
   local tError, tPropsA, tBehavior, tControl
   
   if pBehavior is empty then
      put the long id of stack "DataView Array Controller Behavior" into pBehavior
   end if 
   if pTargetCard is empty then
      put the long id of the current card of the topStack into pTargetCard
   end if
   
   modal stack "dvIdeCreateDataViewDialog"
   if the dialogData is "cancel" then
      put "cancel" into tError
   end if
   
   if tError is empty then
      put the dialogData into tPropsA
      
      if tPropsA["behavior name"] is not empty then
         local tParentBehavior
         
         put pBehavior into tParentBehavior
         if tParentBehavior is empty then
            put the long id of stack "DataView Behavior" into tParentBehavior
         end if
         
         dvIdeCreateBehaviorStack tPropsA["behavior name"], tPropsA["behavior filename"], \
               the long id of the owner of pTargetCard, tParentBehavior
         put the result into tError
         
         if tError is empty then
            put the long id of stack tPropsA["behavior name"] into pBehavior
         end if
      end if
   end if
   
   if tError is empty then
      dvIdeCreateDataViewControl tPropsA["name"], pTargetCard, pBehavior
      put it into tControl
      
      if tPropsA["create row template"] then
         local tStyle
         
         dvIdeCreateRowTemplates tControl, tPropsA["row template styles"], pRowStyleTemplateGroupsA
         put the result into tError
      end if
   end if
   
   if tError is empty then
      return tControl for value
   else
      if tError is not "cancel" then
         answer error tError
      end if
      return tError for error
   end if
end levure_CreateDataViewDialog


--> Dev | Menu
-
on menu_CreateDialogue dView
   local pTargetCard, pBehavior, pRowStyleTemplateGroupsA
   --
   put the stack_Name of dView into stackName
   toplevel stack stackName
   --
   -- dvIdeCreateDataViewControlUsingDialog pTargetCard, pBehavior, pRowStyleTemplateGroupsA
   levure_CreateDataViewDialog
   put it into dView
   --
   levure_SetData dView
end menu_CreateDialogue

on menu_CreateDataView dView
   put "LexonWiki DataView" into pName
   --
   put the long id of stack "DataView Array Controller Behavior" into pBehavior
   put the stack_Name of dView into stackName
   put the long id of card 1 of stack stackName into pTargetCard
   --
   dvIdeCreateDataViewControl pName, pTargetCard, pBehavior
   --
   put "Line 1" into tA[1]["label"]
   put "Line 2" into tA[2]["label"]
   put "Line 3" into tA[3]["label"]
   put "Line 4" into tA[4]["label"]
   --
   set the dvData of group pName of stack helperTargetStackName to tA
end menu_CreateDataView
