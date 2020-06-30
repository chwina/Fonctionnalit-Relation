public with sharing class ParamClass {
    @AuraEnabled
    public static void updateParamNodevalues(String color, String Backgroudfit,Decimal fontsize,String shape,Decimal width,Decimal height) {
       
        NodeParam__c Nodesetting = NodeParam__c.getOrgDefaults();
        Nodesetting.Background_fit__c = Backgroudfit;
        Nodesetting.color__c = color;
        Nodesetting.Font_size__c = fontsize;
        Nodesetting.height__c = height;
        Nodesetting.shape__c = shape;
        Nodesetting.Width__c = width;

        upsert Nodesetting;
        
    }
    @AuraEnabled
    public static void updateParamEdgevalues(String color, String linecolor,Decimal fontsize,String curve,String textrotation) {
       
        EdgeParam__c edgesetting = EdgeParam__c.getOrgDefaults();
        edgesetting.color__c = color;
        edgesetting.curvestyle__c = curve;
        edgesetting.Font_size__c = fontsize;
        edgesetting.Linecolor__c = linecolor;
        edgesetting.textrotation__c = textrotation;
        

        upsert edgesetting;
        
    }

    @AuraEnabled
    public static void updateObjectParamvalues(String Objectname, String RelationName,List<String> nodesfields,List<String> edgefields,String ParentRelation,String Lookuprelation) {
       
        Object_param_setting__c objsetting = Object_param_setting__c.getOrgDefaults();
        objsetting.Object_Name__c = Objectname;
        objsetting.Relation_Name__c = RelationName;
        objsetting.fields__c = string.join(nodesfields,',');
        objsetting.edgefields__c = String.join(edgefields, ',');
        objsetting.Parent_Relation__c = ParentRelation;
        objsetting.Lookup_relation__c = Lookuprelation;
        
        

        upsert objsetting;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static map<string, string> getAllObjects(){
        map<string, string> objectList = new map<string, string>();

        for ( Schema.SObjectType o : Schema.getGlobalDescribe().values() )
        {

            Schema.DescribeSObjectResult objResult = o.getDescribe();
            String name = objResult.getName();
            if(!name.containsignorecase('history') && !name.containsignorecase('tag') && !name.containsignorecase('share') && !name.containsignorecase('feed') && !name.containsignorecase('ChangeEvent')){
                objectList.put(objResult.getName(), objResult.getLabel());
            }

            

        }

        return objectList;

    }
 
    @AuraEnabled(cacheable=true)
    public static map<string, string> getAllchildObjects(String parentobject){
        map<string, string> RelationobjectList = new map<string, string>();
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(parentobject);
        Schema.DescribeSObjectResult R = convertType.getDescribe();
        for (Schema.ChildRelationship cr: R.getChildRelationships()) 
        {
           RelationobjectList.put(cr.getRelationshipName(),cr.getChildSObject().getDescribe().getName());
          system.debug('====child object==='+cr.getChildSObject());
        }
        return RelationobjectList;
    }

    @AuraEnabled(cacheable=true)
    public static map<string, string> getFields(String objectName){
        map<string, string> fieldsList = new map<string, string>();
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SobjectField> fmap = convertType.getDescribe().fields.getMap();
        for(String fieldName: fmap.keySet()){

                System.debug('lookup'+fmap.get(fieldName).getDescribe().getLabel()+' '+ fmap.get(fieldName).getDescribe().getType());
                fieldsList.put(fieldName, fmap.get(fieldName).getDescribe().getLabel());
                
            
        }
        return fieldsList;
    }
    @AuraEnabled(cacheable=true)
    public static map<string, string> getFieldsReference(String objectName){
        map<string, string> fieldsList = new map<string, string>();
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SobjectField> fmap = convertType.getDescribe().fields.getMap();
        for(String fieldName: fmap.keySet()){
            if(fmap.get(fieldName).getDescribe().getName().toLowerCase().right(3) ==  '__c' && fmap.get(fieldName).getDescribe().getType() == DisplayType.REFERENCE){
                System.debug('lookup'+fmap.get(fieldName).getDescribe().getLabel()+' '+ fmap.get(fieldName).getDescribe().getType());
                fieldsList.put(fieldName, fmap.get(fieldName).getDescribe().getLabel());
                
            }
            
        }
        return fieldsList;
    }
}
