script "behavior_ViewDataView" with behavior "DataView Array Controller Behavior"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewDataView
type: behavior
version: 0.1


local LocalArray

--> Working on
-

--> DataView | Row
-
getprop row_Type
   put the row_Value ["@style"] of the target into rowType
   return rowType
end row_Type

setprop row_Type rowType
   put the dvRowControl of the target into rowView
   if exists (rowView) is false then return empty
   --
   put the dvRow of rowView into rowNum
   
   put the dvData of me into dData
   put rowType into dData [rowNum]["@style"]
   set the dvData of me to dData
   --
   return dData
end row_Type


--> Row
-
getprop row_Data
   put the dvRowControl of the target into rowView
   if exists (rowView) is false then return empty
   put the dvRow of rowView into rowNum
   --
   put the dvRowData [rowNum] of rowView into rowData
   return rowData
end row_Data

setprop row_Data [rowType] rowData
   put the dvRowControl of the target into rowView
   if exists (rowView) is false then return empty
   put the dvRow of rowView into rowNum
   --
   if rowType is not empty then put rowType into rowData ["@style"]
   --
   put the dvData of me into dData
   put rowData into dData [rowNum]
   set the dvData of me to dData
   --
   return dvData
end row_Data

getprop row_Value [someKey]
   put the row_Data of the target into rowData
   return rowData [someKey]
end row_Value

setprop row_Value [someKey] someValue
   put the dvRowControl of the target into rowView
   if exists (rowView) is false then return empty
   --
   put the dvData of rowView into dData
   put the dvRow of rowView into rowNum
   --
   put someValue into dData [rowNum][someKey]
   set the dvData of rowView to dData
   --
   return dData
end row_Value


--> DataView
-
getprop dv_CanDrag
   return LocalArray ["dvCanDrag"] is true
end dv_CanDrag

setprop dv_CanDrag someBoolean
   put someBoolean into LocalArray ["dvCanDrag"]
end dv_CanDrag

setprop dv_MoveRowNum [startedRow] droppedOnRow
   _MoveRow startedRow, droppedOnRow
   put the result into rowNum
   return rowNum
end dv_MoveRowNum

getprop dv_RowTemplateName [rowStyleName]
   put the dv_RowTemplate [rowStyleName] of the target into templateObject
   if exists (templateObject) is falsee then return templateObject
   
   put the vieew_Name of templateObject into viewName
   return viewName
end dv_RowTemplateName

setprop dv_RowTemplateName [rowStyleName] viewName
   put view_GetTemplateObject (viewName) into templateObject
   set the dv_RowTemplate [rowStyleName] of the target to templateObject
   return the result
end dv_RowTemplateName

getprop dv_RowTemplate [rowStyleName]
   put the dvControl of the target into dView
   if exists (dView) is false then return empty
   --
   put the viewProp ["row style templates"] of dView into dvRowStyleArray
   put dvRowStyleArray [rowStyleName] into templateObject
   return templateObject
end dv_RowTemplate

setprop dv_RowTemplate [rowStyleName] templateObject
   put the dvControl of the target into dView
   if exists (dView) is false then return "error, not a DataView"
   --
   if exists (templateObject) is false then
      return "error, rowTemplate does not exist"
   else
      put revRuggedId (templateObject) into templateObject
   end if
   --
   put the viewProp ["row style templates"] of dView into dvRowStyleArray
   put templateObject into dvRowStyleArray [rowStyleName]
   set the viewProp ["row style templates"] of dView to dvRowStyleArray
   
   -- make sure it si in the stackfile
   set the stackFile_LinkObject of dView to templateObject
   --
   return dvRowStyleArray
end dv_RowTemplate

getprop dv_RowBehavior [rowNum]
   if rowNum is empty then put the dvClickRow of target into rowNum
   
   put the dvRowData [rowNum] of the target into rowData
   --
   put rowData ["@style"] into rowStyle
   put the dv_RowStyleArray of target into rowStyleArray
   put rowStyleArray [rowStyle] into rowBehavior
   return rowBehavior
end dv_RowBehavior

getprop dv_RowStyleNames
   put the dv_RowStyleArray of the target into dvRowStyleArray
   put keys (dvRowStyleArray) into styleNames
   return styleNames
end dv_RowStyleNames

getprop dv_RowStyleArray
   put the dvControl of the target into dView
   if exists (dView) is false then return empty
   --
   put the viewProp ["row style templates"] of dView into dvRowStyleArray
   return dvRowStyleArray
end dv_RowStyleArray

setprop dv_RowStyleArray [rowName] someValue
   put the dvControl of the target into dView
   if exists (dView) is false then return empty
   --
   switch
      case rowName is empty and someValue is an array
         set the viewProp ["row style templates"] of dView to dvRowStyleArray
         break
      case rowName is not empty and someValue is not an array
         set the dv_RowTemplate [rowName] of dView to someValue
         break
      default
         breakpoint
   end switch
end dv_RowStyleArray


--> Geometry
-
/*
This DataView already has geometry handers triggered by "resizeControl" => "ResizeToFit" in the "DataView Behavior" stack script.
To make it compatible with LCW Layouts we add the follwoing handlers.
*/

on LayoutControl pControlRect
   -- not a good idea as nesting can causee issues. let's dop a check
   if the long id of the target is not the long id of me then pass LayoutControl
   
   ResizeToFit
end LayoutControl


--> Events
-
on mouseDown pButton
   switch pButton
      case 3
         menu_PopUp "Global | DataView | Row | Menu"
         break
      default
         pass mouseDown
   end switch
end mouseDown

on mouseDoubleUp
   put the row_Data of the target into rowData
   put rowData ["text"] into itemText
   -- put the row_Value ["text"] of the target into itemText
   
   put rowData ["@style"] into itemStyle
   switch itemStyle
      case "markdown"
         put mergMarkdownToXHTML (itemText,,true) into someHTML
         dv_TidyHTML someHTML
         put someHTML
         break
      default
         put itemStyle & CR & itemText
   end switch
   --
   if the optionKey is "Down" then
      put the dv_RowBehavior of the target into rowTemplate
      put the behavior of rowTemplate into bObject
      edit the script of bObject
   end if
end mouseDoubleUp

on preOpenControl
   dispatch "ResetView" to me
   dispatch "RenderView" to me
end preOpenControl


--> DataView | Row | Dragging
-
on ValidateRowDrop pDraggingInfoA, pProposedRow, pProposedDropOperation
   -- message is not sent
   -- the presence of this handler enables visual effect of dragging
   -- if IsDeleted is true then return true
   
   put the dragData ["private"] into startedRow
   --   
   -- _MoveRow startedRow, pProposedRow
   /*
   if pProposedRow is not startedRow then
      put "Dragging" && pProposedRow && pProposedDropOperation
   else
      put "Same" && pProposedRow && pProposedDropOperation 
   end if
   */
   return true
end ValidateRowDrop

on AcceptRowDrop pDraggingInfoA, droppedOnRow, pDropOperation
   put the dragData ["private"] into startedRow
   --
   _MoveRow startedRow, droppedOnRow
   --
   -- put droppedOnRow && pDropOperation
end AcceptRowDrop


--> Drop
-
command drop_URL
   put the keys of the dragData into dropKeys
   put the dragData ["text"] into droppedURL
   --
   put the dragData ["html"] into droppedHTML
   put "<p><a href='(.+\.html)'>.+</a></p>" into wikiHtmlURlReg
   replace "'" with quote in wikiHtmlURlReg
   --
   switch
      case matchText (droppedHTML, wikiHtmlURlReg, wikiHtmlURl)
         drop_WikiHtmlUrl wikiHtmlURl
         break
         /*
      case droppedURL begins with "https://www.c-span.org/video/?"
         drop_Youtube droppedURL
         break
      case "Files" is among the lines of dropKeys
         drop_File
         break
      case "image" is among the lines of dropKeys
         put the dragData ["image"] into imageContents
         put "image" & CR & line 1 of imageContents
         break
      case droppedURL begins with "https://www.bbc.co.uk/iplayer/episode/"
      case matchtext (droppedURL, "https://www.bbc.co.uk/iplayer/episode/(.+)")
         drop_BBC droppedURL
         break
      case droppedURL begins with "https://www.youtube.com/watch?v="
      case matchText (droppedURL, "https://www.youtube.com/watch?v=(.+)", tubeID)
         drop_Youtube droppedURL
         break
      case matchText (droppedURL, "https://vimeo.com/(.+)", vimeoID)
      case matchText (droppedURL, "https://vimeo.com/channels/staffpicks/(.+)", vimeoID)
         drop_Vimeo vimeoID
         break
         */
      default
         -- do nothing
         answer warning "I don't recognise this url!"
         put droppedURL
         break
      default
         put dropKeys
   end switch
end drop_URL


--> Drop
-
command drop_WikiHtmlUrl wikiHtmlURl
   put "http://(.+)\/(.+)\.html" into someReg
   if matchText (wikiHtmlURl, someReg, wikiDomain, pageSlug) is true then
      set the dv_Wikidomain [pageSlug] of me to wikiDomain
   else
      return empty
   end if
end drop_WikiHtmlUrl

/*
command drop_Video
   put the keys of the dragData into dropKeys
   put the dragData ["text"] into droppedURL
   --
   put the dragData ["html"] into droppedHTML
   put "<p><a href='(.+\.html)'>.+</a></p>" into wikiHtmlURlReg
   replace "'" with quote in wikiHtmlURlReg
   --
   switch
      case droppedURL begins with "https://www.c-span.org/video/?"
         drop_Youtube droppedURL
         break
      case "Files" is among the lines of dropKeys
         drop_File
         break
      case "image" is among the lines of dropKeys
         put the dragData ["image"] into imageContents
         put "image" & CR & line 1 of imageContents
         break
      case droppedURL begins with "https://www.bbc.co.uk/iplayer/episode/"
      case matchtext (droppedURL, "https://www.bbc.co.uk/iplayer/episode/(.+)")
         drop_BBC droppedURL
         break
      case droppedURL begins with "https://www.youtube.com/watch?v="
      case matchText (droppedURL, "https://www.youtube.com/watch?v=(.+)", tubeID)
         drop_Youtube droppedURL
         break
      case matchText (droppedURL, "https://vimeo.com/(.+)", vimeoID)
      case matchText (droppedURL, "https://vimeo.com/channels/staffpicks/(.+)", vimeoID)
         drop_Vimeo vimeoID
         break
      case matchText (droppedHTML, wikiHtmlURlReg, wikiHtmlURl)
         drop_WikiHtmlUrl wikiHtmlURl
         break
      default
         -- do nothing
         answer warning "I don't recognise this url!"
         put droppedURL
         break
      default
         put dropKeys
   end switch
end drop_Video

command drop_Vimeo vimeoID
   put vimeoID
end drop_Vimeo

command drop_Youtube youTubeURL
   -- https://www.youtube.com/watch?v=BvDpNtbrr5Y
   put youtube_ListFormats (youTubeURL) into availableFormats
   switch
      case availableFormats contains "webm"
         youtube_DownloadVideo youTubeURL, "webm", true
         break
      case availableFormats contains "ogg"
         youtube_DownloadVideo youTubeURL, "ogg", true
         break
      default
         youtube_DownloadVideo youTubeUrl, "mp4", true
   end switch   
   put the result into videoFile
   set the movie_File of me to videoFile
   return videoFile
end drop_Youtube

command drop_BBC droppedURL
   -- Horizon_2020_-_Pluto_Back_From_the_Dead_m000kqm9_original.mp4
   
   iplayer_DownloadVideo droppedURL
   put the result into infoArray
   --
   display_Data infoArray
   --
   -- now add it to player
   --
   put iplayer_GetDownloadFolder() into iplayerFolder
   finder_Reveal iplayerFolder
end drop_BBC

command drop_File
   put line 1 of dragData ["files"] into videoFile
   switch
      case file_IsVideo (videoFile)
         set the movie_File of me to videoFile
         set the movie_Paused of me to false
         break
      case videoFile ends with ".m3u"
         put url ("file:" & videoFile) into m3uPlayList
         set the m3u_Text of me to m3uPlayList
         break
      default
         put "Dropped file:" && videoFile
   end switch
end drop_File
*/

--> Events | Drag
-
on dragStart
   if the dv_CanDrag of me is true then
      put false into IsDeleted
      set the dvDragImageRow of me to item 1 of the dvHilitedRows of me
      set the dvTrackDragReorder[the dvHilitedRows of me] of me to true
      set the dragData ["private"] to the dvHilitedRows of me # dragdata has to be set to something.
   end if
end dragStart

on dragDrop
   -- if the dv_CanDrag of me is false then
   get the dragData ["private"]
   if it is empty then
      drop_URL
   end if
end dragDrop

on dragEnter
   -- if the dv_CanDrag of me is false then
   if the dragData ["private"] is empty then
      set the allowableDragActions to "link"
      set the dragAction to "Link"
   end if
end dragEnter


--> Private
-
private command _MoveRow startedRow, droppedOnRow
   put the dvData of me into dData
   indexedArray_Delete dData, startedRow
   put the result into CutRowData
   --
   if droppedOnRow < startedRow then
      put droppedOnRow into rowNum
   else
      put droppedOnRow - 1 into rowNum
   end if
   indexedArray_Add dData, CutRowData, rowNum
   --
   -- lock screen
   set the dvData of me to dData
   set the dvHilitedRow of me to rowNum
   -- unlock screen
   --
   return rowNum
end _MoveRow
