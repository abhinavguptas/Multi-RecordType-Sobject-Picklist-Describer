/*
Copyright (c) 2012 tgerm.com
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
	Visualforce controller for the page that renders the XML output for the picklist options
	@author Abhinav 
*/
public class PickListDescController {
    public Sobject sobj {get;set;}
    public String pickListFieldName {get;set;}        
    
    public PickListDescController() {
        Map<String, String> reqParams = ApexPages.currentPage().getParameters();
        String sobjId = reqParams.get('id');
        String recordTypeId = reqParams.get('recordTypeId');
        String recordTypeName = reqParams.get('recordTypeName');
        String sobjectTypeName = reqParams.get('sobjectType'); 
        this.pickListFieldName = reqParams.get('picklistFieldName'); 
        
        Schema.SobjectType sobjectType = null;
        
        if (sobjectTypeName != null && sobjectTypeName.trim().length() > 0) {
            sobjectType = Schema.getGlobalDescribe().get(sobjectTypeName);
            // create blank sobject record
            sobj = sobjectType.newSobject();
            
            // if no recordTypeId passed explicitly by user, try loading one from the RecordType table
            if (isBlank(recordTypeId) && !isBlank(recordTypeName)) {
                // queryexception is fine, we don't want to return anything good for bad recordtype
                RecordType recType = [Select Id from RecordType Where SobjectType =:sobjectTypeName 
                                            AND DeveloperName like :recordTypeName];
                recordTypeid = recType.id;                                            
            }
            sobj.put('RecordTypeId', recordTypeid);                                            

        } else if (sobjId != null && sobjId.trim().length() > 0) {
        	// find the so
            for (SobjectType sobjType : Schema.getGlobalDescribe().values()){
                String sobjPrefix = sobjType.getDescribe().getKeyPrefix();
                if (sobjPrefix == null) continue;
                System.debug('SobjectType ' + sobjType + ', ' + sobjPrefix);
                if (sobjId.toLowerCase().startsWith(sobjPrefix.toLowerCase())) {
                    sobjectType = sobjType;
                    break;
                }
            }
            // following not working with input:field
            //sobj = sobjectType.newSobject(sobjId);
            sobj = Database.query ('SELECT ' + pickListFieldName + ' FROM ' + sobjectType + ' WHERE ID =:sobjId');
        }
            
    }  
    
    static boolean isBlank(String val) {
        return val == null || val.trim().length() == 0;
    }
}