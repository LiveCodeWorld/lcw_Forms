script "Global | DataView | Behaviors | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | DataView | Behaviors | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
command display_DataView dView
   put the behavior_Objects of dView into bObjects
   put the short name of dView into sTitle
   --
   display_Data bObjects, sTitle, "DataView"
   put the result into displayView
   display_SetInteractions displayView, "DataView | Tree", "mDoubleUp_DataView"
   --
   return displayView
end display_DataView

on menu_Init tObject
   put tObject into LocalArray ["tObject"]
end menu_Init

-- getprop menu_Target [tObject]
put the dv_LinkedDataView of tObject into dView
put dView into LocalArray ["dView"]
return dView
end menu_Target

-- getprop menu_CheckTarget [dView]
return exists (dView)
end menu_CheckTarget


--> Global | DataView | Behaviors | Menu
-
on menu_EditDataViewBehavior dView, stackName
   edit the script of stack stackName
end menu_EditDataViewBehavior

on menu_SetDataViewBehaviors dView
   /*
   put the module_Name of dView into moduleName
   put "behavior_ViewDataView,DataView Array Controller Behavior,DataView Behavior" into bStackNames
   breakpoint
   set the behavior_StackNames of dView to bStackNames
   */
   
   put the behavior of dView into bObject
   put the long id of stack "DataView Array Controller Behavior" into bOfbObject
   --
   if exists (bObject) is true then
      set the behavior of bObject to bOfbObject
   else
      set the behavior of dView to bOfbObject
   end if
   --
   put the behavior_Objects of dView into bObjects
   repeat for each line bObject in bObjects
      set the stackFile_LinkObject of dView to bObject
   end repeat
   --
   display_DataView dView
end menu_SetDataViewBehaviors

on _
end _

on menu_StackIsKnown dView
   put the stack_Name of dView into stackName
   put the stack_IsKnown of stack stackName into isKnown
   --
   set the stack_IsKnown of stack stackName to (isKnown is false)
end menu_StackIsKnown

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu | Props
-
getprop dataviewScripts_Params
   put the mainstacks into sNames
   filter sNames with "*DataView*"
   return sNames
end dataviewScripts_Params

getprop editDataViewBehavior_Params [dView]
   put the behavior_StackNames of dView into bStackNames
   return bStackNames
end editDataViewBehavior_Params

getprop checked_StackIsKnown [dView]
   put the stack_IsKnown of dView into isKnown
   return isKnown
end checked_StackIsKnown


--> Dev | Menu
-
on menu_DataviewScripts displayView, stackName
   edit the script of stack stackName
end menu_DataviewScripts
