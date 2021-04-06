function OnMsg.ClassesPostprocess()
	if(table.find(XTemplates.POIAdditionalContent,"__class","XText")) then
		return
	end

	table.insert(XTemplates.POIAdditionalContent, 
		PlaceObj("XTemplateWindow", {
			"__class", "XText",
			"Padding", box(0, 0, 0, 0),
			"HandleMouse", false,
			"TextStyle", "PGChallengeDescription",
			"Translate", true,
			"Text", T("Altitude <Altitude> m Temperature <Temperature>°C")
			})
		)

end

