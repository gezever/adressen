!#/bin/bash
# https://developers.google.com/maps/documentation/geocoding/intro
x=0 ;  
while read  i ; do  
	straat=`echo $i | cut -d ';' -f 2`; 
	nummer=`echo $i | cut -d ';' -f 3` ;  postcode=`echo $i | cut -d ';' -f 6`;  
	gemeente=`echo $i | cut -d ';' -f 7` ; 
	 echo $straat $nummer $postcode $gemeente ;  
	 curl -o /tmp/$x.xml https://maps.googleapis.com/maps/api/geocode/xml?address=$straat+$nummer,+$postcode+$gemeente,+BE&key=AIzaSyAUA6DjeDROcnPTLShr-uw680pJ8xkzPDo  ; 
	 let x=$x+1; 
done < '../data/wel_en_niet_INTEGO_Antwerpen2.csv
