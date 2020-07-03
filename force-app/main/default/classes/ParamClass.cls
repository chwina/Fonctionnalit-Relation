public with sharing class ParamClass {
   
    @AuraEnabled
    public static void updateParamNodevalues(String color, String Backgroudfit,Decimal fontsize,String shape,Decimal width,Decimal height) {
       
        NodeParam__c Nodesetting = NodeParam__c.getOrgDefaults();
        if (Backgroudfit != null) Nodesetting.Background_fit__c = Backgroudfit;
        if (color != null)  Nodesetting.color__c = color;
        if (fontsize != null) Nodesetting.Font_size__c = fontsize;
        if (height != null) Nodesetting.height__c = height;
        if (shape != null) Nodesetting.shape__c = shape;
        if (width != null) Nodesetting.Width__c = width;

        upsert Nodesetting;
        
    }
    @AuraEnabled
    public static void updateParamEdgevalues(String color, String linecolor,Decimal fontsize,String curve,String textrotation) {
       
        EdgeParam__c edgesetting = EdgeParam__c.getOrgDefaults();
        if (color != null)  edgesetting.color__c = color;
        if(linecolor != null)  edgesetting.Linecolor__c = linecolor;
        if(curve != null) edgesetting.curvestyle__c = curve;
        if(fontsize != null) edgesetting.Font_size__c = fontsize;
        if(textrotation != null) edgesetting.textrotation__c = textrotation;
       
        upsert edgesetting;
        
    }

    @AuraEnabled
    public static void updateObjectParamvalues(String Objectname, String RelationName,List<String> nodesfields,List<String> edgefields,String ParentRelation,String Lookuprelation,String image) {
       
        Object_param_setting__c objsetting = Object_param_setting__c.getOrgDefaults();
        if(Objectname != null) objsetting.Object_Name__c = Objectname;
        if(RelationName != null) objsetting.Relation_Name__c = RelationName;
        if(nodesfields.size() != 0)  objsetting.fields__c = string.join(nodesfields,',');
        if(edgefields.size() != 0) objsetting.edgefields__c = String.join(edgefields, ',');
        if(ParentRelation != null) objsetting.Parent_Relation__c = ParentRelation;
        if(Lookuprelation != null) objsetting.Lookup_relation__c = Lookuprelation;
        if(image != null) objsetting.formulaimage__c = image;
        

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
                objectList.put(objResult.getLabel(),objResult.getName());
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
                fieldsList.put(fmap.get(fieldName).getDescribe().getLabel(), fmap.get(fieldName).getDescribe().getName());
            
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
    
    @AuraEnabled(cacheable=true)
    public static map<string, string> getFieldsFormula(String objectName){
        map<string, string> fieldsList = new map<string, string>();
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SobjectField> fmap = convertType.getDescribe().fields.getMap();
        for(String fieldName: fmap.keySet()){
            if( fmap.get(fieldName).getDescribe().isCalculated() && fmap.get(fieldName).getDescribe().getType() == DisplayType.STRING){

                fieldsList.put(fmap.get(fieldName).getDescribe().getLabel(), fmap.get(fieldName).getDescribe().getName());
                
            }
            
        }
        return fieldsList;
    }
}
