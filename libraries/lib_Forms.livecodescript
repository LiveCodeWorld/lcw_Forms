script "lib_Forms"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: lib_Forms
type: library
version: 0.1

/*Some help*/


--> Working on
-
on mDoubleUp_DataView displayView, someLine
   put the title_Text of displayView into someTitle
   return displayView
end mDoubleUp_DataView

command display_DataView dView, pTopLeft
   put the behavior_Objects of dView into bObjects
   put the short name of dView into sTitle
   --
   display_Data bObjects, sTitle, "DataView", "", "", pTopLeft
   put the result into displayView
   display_SetInteractions displayView, "DataView | Tree", "mDoubleUp_DataView"
   --
   set the displayed_Object of displayView to dView
   --
   return displayView
end display_DataView


--> Forms
-
getprop test_Name
   return "David Bovill"
end test_Name


--> Private
-
