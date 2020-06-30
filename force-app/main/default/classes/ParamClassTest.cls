@isTest
public with sharing class ParamClassTest {
   
    public static testmethod void updateParamNodevaluestest() {
       
        NodeParam__c node = new NodeParam__c();
        node.Width__c = 120;
        node.height__c = 40;
        node.Font_size__c = 10;
        node.color__c =  '#000000';
        node.Background_fit__c = 'cover';
        node.shape__c =  'round-rectangle'; 

        insert node;

       
        paramclass.updateParamNodevalues('#000000', 'contain',100,'rectangle',13,20);
        NodeParam__c b = [SELECT Id,Background_fit__c FROM NodeParam__c WHERE Id =:node.Id];
        System.debug('Background ' + b.Background_fit__c);
        System.assertEquals('contain', b.Background_fit__c);


      }

      
    public static testmethod void updateParamEdgevaluestest() {
        EdgeParam__c edge = new EdgeParam__c();
        edge.color__c = '#000000';
        edge.curvestyle__c = 'unbundled-bezier';
        edge.Font_size__c = 13;
        edge.Linecolor__c = '#000000';
        edge.textrotation__c = 'autorotate';

        insert edge;

       
        paramclass.updateParamEdgevalues('#000000', 'bezier',10,'#000000','autorotate');
        EdgeParam__c b = [SELECT Id,Font_size__c FROM EdgeParam__c WHERE Id =:edge.Id];
        System.debug('fontsize ' + b.Font_size__c);
        System.assertEquals(10, b.Font_size__c);


      }

      
    public static testmethod void updateObjectParamvaluestest() {
        Object_param_setting__c objset = new Object_param_setting__c();
        objset.Object_Name__c = 'Account';
        objset.Relation_Name__c = 'Relation';
        objset.fields__c = 'id,name';
        objset.Lookup_relation__c = 'AccountInRelation__c';
        objset.Parent_Relation__c = 'ParentRelation__c';
        

        insert objset;

       
        paramclass.updateObjectParamvalues('opportunity', 'Relation',new List<String>{'a', 'b'},new List<String>{'c', 'd'},'ParentRelation__c','AccountInRelation__c');
        Object_param_setting__c b = [SELECT Id,Object_Name__c FROM Object_param_setting__c WHERE Id =:objset.Id];
        System.debug('opportunity ' + b.Object_Name__c);
        System.assertEquals('opportunity', b.Object_Name__c);
        }

          public static testmethod void getAllObjectstest() {
               map<string, string> objectList = paramclass.getAllObjects();
               map<string, string> childobjectList = paramclass.getAllchildObjects('Account');
               map<string, string> fieldsobjectList = paramclass.getFields('Account');
               map<string, string> fieldsReferenceobjectList = paramclass.getFieldsReference('Relation__c');
               System.debug('le nombre des standards && Custom objects ' + objectList.values().size());
               System.debug('le nombre des fils de l\'objet account  ' + childobjectList.values().size());
               System.debug('le nombre des champs de l\'objet account ' + fieldsobjectList.values().size());
               System.debug('le nombre des champs lookup de l\'objet relation ' + fieldsReferenceobjectList.values().size());
               System.assertEquals( objectList.values().size(),488);
               System.assertEquals(childobjectList.values().size(),62);
               System.assertEquals(fieldsobjectList.values().size(), 7);
               System.assertEquals(fieldsReferenceobjectList.values().size(), 2);
        }
}
