/**
   * @description : Test class for PicklistDescriber.
   * @createdBy : 
   * @Date : 19-09-2019
   */
@isTest
private class PicklistDescriberTest {
    @testSetup
    public static void createRequiredData(){
        Id recordTypeId =  Schema.SObjectType.MultiPicklistDescriber__c.getRecordTypeInfosByName().get('RType1').getRecordTypeId();
        System.debug('recordTypeID '+recordTypeId);
        MultiPicklistDescriber__c m = new MultiPicklistDescriber__c();
        m.Name='MultiPicklistDes1';
        m.PicklistValue__c='PV1';
        m.RecordTypeId= recordTypeId;
        insert m; 
    }
    @isTest
    public static void describeTest_1(){
        // This method is used when we have record Id and picklist value name.
         MultiPicklistDescriber__c obj=[SELECT Id,RecordTypeId,Name FROM MultiPicklistDescriber__c where name='MultiPicklistDes1'];
        PicklistDescriber.TEST_XML_CONTENT = '<form id="j_id0:j_id1" name="j_id0:j_id1" method="post" action="https://sagarr-dev-ed--c.visualforce.com'+
            '/apex/picklistdesc?id='+obj.Id+'" enctype="application/x-www-form-urlencoded">'+
            '<input type="hidden" name="j_id0:j_id1" value="j_id0:j_id1" />'+
            '<select  id="j_id0:j_id1:j_id2" name="j_id0:j_id1:j_id2"><option value="">--None--</option>'+
            '<option value="PV1" selected="selected">PV1</option>'+
            '<option value="PV2">PV2</option><option value="PV3">PV3</option>'+
            '</select><div id="j_id0:j_id1:j_id3"></div></form>';
        System.debug('obj '+obj);
        List<String> options = PicklistDescriber.describe(obj.Id, 'PicklistValue__c');
        system.assertEquals(3,options.size());
    }
    @isTest
    public static void describeTest_2(){
        // This method is used when we have Object Name, Record type Name and picklist value name.
        PicklistDescriber.TEST_XML_CONTENT ='<form id="j_id0:j_id1" name="j_id0:j_id1" method="post" action="https://sagarr-dev-ed--c.visualforce.com/apex/picklistdesc" enctype="application/x-www-form-urlencoded">'+
            '<input type="hidden" name="j_id0:j_id1" value="j_id0:j_id1" />'+
            '<select  id="j_id0:j_id1:j_id2" name="j_id0:j_id1:j_id2"><option value="">--None--</option><option value="PV1">PV1</option>'+
            '<option value="PV2">PV2</option>'+
            '<option value="PV3">PV3</option>'+
            '</select><div id="j_id0:j_id1:j_id3"></div></form>';
        MultiPicklistDescriber__c obj=[Select recordTypeId, RecordType.Name from MultiPicklistDescriber__c limit 1];
        List<String> options = PicklistDescriber.describe('MultiPicklistDescriber__c', obj.RecordType.Name, 'PicklistValue__c');
        system.assertEquals(3,options.size());
    }
    
    @isTest
    public static void describeTest_3(){
        // This method is used when we have Object Name, Record Type Id and picklist value name.
        PicklistDescriber.TEST_XML_CONTENT ='<form id="j_id0:j_id1" name="j_id0:j_id1" method="post" action="https://sagarr-dev-ed--c.visualforce.com/apex/picklistdesc" enctype="application/x-www-form-urlencoded">'+
            '<input type="hidden" name="j_id0:j_id1" value="j_id0:j_id1" />'+
            '<select  id="j_id0:j_id1:j_id2" name="j_id0:j_id1:j_id2"><option value="">--None--</option><option value="PV1">PV1</option>'+
            '<option value="PV2">PV2</option>'+
            '<option value="PV3">PV3</option>'+
            '</select><div id="j_id0:j_id1:j_id3"></div></form>';
        MultiPicklistDescriber__c obj=[Select recordTypeId from MultiPicklistDescriber__c limit 1];
        List<String> options = PicklistDescriber.describe('MultiPicklistDescriber__c',obj.RecordTypeId, 'PicklistValue__c');
        system.assertEquals(3,options.size());
    }
}