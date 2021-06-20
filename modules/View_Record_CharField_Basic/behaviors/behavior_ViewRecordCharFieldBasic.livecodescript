script "behavior_ViewRecordCharFieldBasic"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: behavior_ViewRecordCharFieldBasic
type: behavior
version: 0.1

/*
This charfield record should have char error checking added.
*/

getprop record_View
   return the long id of me
end record_View

getprop view_Object
    return the long id of me
end view_Object


--> Datagrid
-
on FillInData testArray
   set the text of fld 1 of me to (testArray["First"] && "Simple")
end FillInData

getprop dgDataControl
   return the long id of me
end dgDataControl
  
  
--> Record
-
getprop record_Value
    put the value_View of me into valueField
    return the text of valueField
end record_Value

setprop record_Value someText
    put the value_View of me into valueField
    set the text of valueField to someText
end record_Value

getprop record_Label
    put the label_View of me into labelField
    return the text of labelField
end record_Label

setprop record_Label someText
    put the label_View of me into labelField
    set the text of labelField to someText
end record_Label

setprop record_IsLocked boolean
    put the value_View of me into valueObject
    set the locktext of valueObject to boolean
    set the showfocusborder of valueObject to boolean
end record_IsLocked

getprop record_IsLocked
   put the value_View of me into valueObject
   return the locktext of valueObject
end record_IsLocked


--> Events
-
on mouseDown
   if the long id of the target is not the label_View of me then pass mouseDown
   menu_PullDown
end mouseDown


--> Geometry
-
/*
In order to allow all form elements (records) toshare the same heights and label width etc
do not put handlers here.

These should instead be handled by the enclosing form group or simply not handled at all.
if these properties are empty (ie not handled) then the "view_Rect" and similar handlers should
use sensible defaults.

However just in case an individual record needs to have its own resize properties,
and not the default form properties, there are setprop handlers here that mimic the same
handlers that should be in the form itself.

Handlers should first check to see if the record has a custom property set before returning the forms
default value.
*/

on resizeControl
   if the long id of me is not the long id of the target then pass resizeControl
   LayoutControl
end resizeControl

setprop view_Rect someRect
   if the long id of me is not the long id of the target then pass view_Rect
   LayoutControl someRect
end view_Rect

on LayoutControl pRect
   if the long id of me is not the long id of the target then pass LayoutControl
   if pRect is empty then put the rect of me into pRect
   put the inner_Rect [pRect] of me into innerRect
   
   lock screen
   put the value_View of me into valueObject
   put the label_View of me into labelObject
   
   put the record_LabelWidth of me into recordLabelWidth
   if recordLabelWidth is empty then put the record_DefaultLabelWidth of me into recordLabelWidth
   put the record_Height of me into recordHeight
   
   put item 1 of innerRect + recordLabelWidth into labelRight
   
   rect_SetHeight pRect, recordHeight  -- could only set if greater
   
   put innerRect into recordLabelRect
   put labelRight into item 3 of recordLabelRect
   
   put innerRect into fieldRect
   put labelRight into item 1 of fieldRect
   
   set the rect of labelObject to recordLabelRect
   set the rect of valueObject to fieldRect
   -- set the rect of me to pRect
   unlock screen
end LayoutControl

on ResizeLabel recordLabelWidth
   -- upward (top down) chaining
   dispatch "ResizeLabel" to of the owner of me with recordLabelWidth
   if it is not "handled" then
      set the view_DisplayProperty [word 1 of the params] of me to recordLabelWidth
      LayoutControl
   end if
end ResizeLabel

getprop record_DefaultLabelWidth
   return 60
end record_DefaultLabelWidth

-- getprop record_LabelWidth
    put the view_DisplayProperty [word 1 of the params] of me into recordLabelWidth
    if recordLabelWidth is empty then put 160 into recordLabelWidth
    return recordLabelWidth
end record_LabelWidth

-- setprop record_LabelWidth recordLabelWidth
   set the view_DisplayProperty [word 1 of the params] of me to recordLabelWidth
   LayoutControl
end record_LabelWidth

getprop record_FieldColour
   put the value_View of me into valueObject
   put the backgroundcolor of valueObject into someColour
   return someColour
end record_FieldColour

setprop record_FieldColour someColour
   put the value_View of me into valueObject
   lock screen
   set the backgroundcolor of valueObject to someColour
   if someColour is not empty then set the opaque of valueObject to true
   unlock screen
end record_FieldColour

getprop record_Height
    -- from top to bottom of me
    put the record_Heights of the owner of me into recordHeight
    if recordHeight is empty then
        put the uOPN ["record_Height"] of me into recordHeight
        if recordHeight is not a number then
            put the height of me into recordHeight
            set the uOPN ["record_Height"] of me to recordHeight
        end if
        return recordHeight
    else
        return recordHeight
    end if
end record_Height

setprop record_Height recordHeight
    set the uOPN ["record_Height"] of me to recordHeight
    set the view_Rect of me to the rect of me
end record_Height

getprop label_FormattedWidth
    put the label_View of me into labelObject
    return the formattedwidth of labelObject
end label_FormattedWidth

getprop label_FormattedHeight
    put the label_View of me into labelObject
    return the formattedheight of labelObject
end label_FormattedHeight


--> Objects
-
getprop value_View
    return the long id of control "Record Value" of me
end value_View

getprop label_View
    return the long id of control "_Record Label" of me
end label_View

