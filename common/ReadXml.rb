require 'rexml/document'
require 'xmlsimple'

class ReadXml

	def readValue(res,value)
		doc = REXML::Document.new(res.body)
		return doc.elements[value].text
	end

	def changeHash(res,body=true)
		
		if body
			hash = XmlSimple.xml_in(res.body)
		else
			hash = XmlSimple.xml_in(res)
		end

		return hash
	end

end