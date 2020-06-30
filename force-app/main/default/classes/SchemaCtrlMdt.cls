public with sharing class SchemaCtrlMdt {
      
  
    public class JData{
        @AuraEnabled public String Ident {get;set;}
        @AuraEnabled public SObject acc {get;set;}
        @AuraEnabled public String acclist {get;set;}
        @AuraEnabled public String codeCouleur {get;set;}
        @AuraEnabled public String Backgroundfit {get;set;}  
        @AuraEnabled public String shape {get;set;}  
        @AuraEnabled public Decimal width {get;set;} 
        @AuraEnabled public Decimal height {get;set;} 
        @AuraEnabled public Decimal Fontsize {get;set;}
                   
 
        public JData(String Ident, Account acc,String codeCouleur,String Backgroundfit,String shape,Decimal width,Decimal height,decimal Fontsize){
            this.Ident = Ident;
            this.acc = acc;
            this.codeCouleur = codeCouleur;
            this.Backgroundfit = Backgroundfit;
            this.shape = shape;
            this.width = width;
            this.height = height;
            this.Fontsize = Fontsize;
            this.acclist = '';
           
        } 
    }
    
    
    public class Jdata2{
        @AuraEnabled public ID source {get;set;}
        @AuraEnabled public ID target {get;set;}
        @AuraEnabled public String curvestyle  {get;set;}
        @AuraEnabled public String textrotation  {get;set;}               
        @AuraEnabled public Decimal Fontsize  {get;set;} 
        @AuraEnabled public String edgeColor {get;set;}
        @AuraEnabled public String lineColor {get;set;}
        @AuraEnabled public String edgelist {get;set;}
        
        public JData2(Id source , Id target,String curvestyle,String textrotation,Decimal Fontsize,String edgeColor,String lineColor){
            this.source = source;
            this.target = target; 
            this.curvestyle = curvestyle;
            this.textrotation = textrotation;
            this.Fontsize = Fontsize;
            this.edgeColor = edgeColor;
            this.lineColor = lineColor;
            this.edgelist  = '';
        }    
    }   
 
    public class Wrapper{ 
        @AuraEnabled public String groupe; //edges , nodes 
        @AuraEnabled public JData dat;
        @AuraEnabled public JData2 data2; 
    
        
        //Nodes
        public Wrapper(String groupe , JData dat){
            this.groupe = groupe;
            this.dat = dat;
        } 
        //Edges
        public Wrapper(String groupe , JData2 data2){
            this.groupe = groupe;
            this.data2 = data2; 
        } 
    }  
    
  
    @AuraEnabled(cacheable=true)
    public static String getData(Id record){
        List<Wrapper> liste = new List<Wrapper>();
        Set<Id> ids_level1 = new Set<Id>();
        Set<Id> ids_level2 = new Set<Id>();
        Set<Id> ids_level3 = new Set<Id>();
        Set<Id> ids_level4 = new Set<Id>();
        ids_level1.add(record); 
        Map<Set<Id>,List<Wrapper>> mymap = new Map<Set<Id>,List<Wrapper>>();  
        String objectname = record.getSObjectType().getDescribe().getName();
        
        mymap = getNextLevel(ids_level1,objectname);  
        for(List<Wrapper> items : mymap.values()){
           liste.addAll(items);
        }
        for(Set<ID> keys : mymap.keyset()){
            if(keys!=null){
                ids_level2.addALL(keys); 
            }
        }   
        if(!ids_level2.isempty()){    
            mymap = getNextLevel(ids_level2,objectname);
            for(List<Wrapper> items : mymap.values()){
                if(items!=null) liste.addAll(items);
            }
            for(Set<ID> keys : mymap.keyset()){
                if(keys!=null){
                    ids_level3.addALL(keys); 
                }
                
            } 
            if(!ids_level3.isempty()){  
                //Add to liste wrapper 
                ids_level2.add(record);
                mymap = getNextLevel(ids_level3,objectname);
                for(List<Wrapper> items : mymap.values()){
                    if(items!=null) liste.addAll(items);
                }
               
                
            }   
            
            }
        return JSON.serialize(liste) ;
    }
   
    public static Map<Set<Id>,List<Wrapper>> getNextLevel(Set<Id> includeParent,String objectname){
        EdgeParam__c edge = EdgeParam__c.getOrgDefaults();
        NodeParam__c node = NodeParam__c.getOrgDefaults();
        Object_param_setting__c objsetting = Object_param_setting__c.getOrgDefaults();

        List<Wrapper> liste = new List<Wrapper>();
        Set<Id> id_accounts = new Set<Id>();

        Set<Id> ids_level = new Set<Id>();
         
        /* debut */
        String edgefiel = objsetting.edgefields__c;	
        List<String> fieldedgelist = edgefiel.split(',');
        String query1 = 'SELECT ';
        for (String fieldName : fieldedgelist) {
            query1 += fieldName+' ,';
        }
       String ParentRelation = objsetting.Parent_Relation__c+'__c';
       String lookupRelation = objsetting.Lookup_relation__c+'__c';
        query1 +=  ParentRelation + ' , ' + lookupRelation;
       
        List<SObject> listeRelations;
        String relationName = objsetting.Relation_Name__c;
        
            query1+=' FROM '+relationName+'  WHERE ' + ParentRelation + ' in :includeParent AND '+ ParentRelation +' !=null AND '+lookupRelation+ ' !=null'; 
            listeRelations =Database.query(query1);
            
            if(listeRelations.size()>0){ 
                for(SObject relation : listeRelations ){ 
                     
                    ids_level.add(String.valueOf(relation.get(lookupRelation)));
                     Wrapper parentNode = new Wrapper('nodes', new JData(String.valueOf(relation.get(ParentRelation)),null,node.color__c,node.Background_fit__c,node.shape__c,node.Width__c,node.height__c,node.Font_size__c));
                     liste.add(parentNode);
                    
                     Wrapper childNode = new Wrapper('nodes', new JData(String.valueOf(relation.get(lookupRelation)),null,node.color__c,node.Background_fit__c,node.shape__c,node.Width__c,node.height__c,node.Font_size__c));
                     liste.add(childNode);
                     String con = '';
                     for(String a :fieldedgelist){
                        String fieldedgevalue = a +' : '+ String.valueOf(relation.get(a))+'\n';
                        con = con + fieldedgevalue + ',';
                    }                                     
                     Wrapper wrpEdge = new Wrapper('edges', new Jdata2(String.valueOf(relation.get(ParentRelation)), String.valueOf(relation.get(lookupRelation)),edge.curvestyle__c,edge.textrotation__c,edge.Font_size__c,edge.color__c,edge.Linecolor__c));                    		 
                     wrpEdge.data2.edgelist = con;
                     liste.add(wrpEdge);
                    
                     id_accounts.add(String.valueOf(relation.get(ParentRelation)));
                     id_accounts.add(String.valueOf(relation.get(lookupRelation)));


                }
                
        }
        
          
        
        
        String fiel = objsetting.fields__c;	
        List<String> fieldlist = fiel.split(',');
        String query = 'SELECT ';
        for (String fieldName : fieldlist) {
            query += fieldName+' ,';
        }
        query=query.removeEnd(',');
         query+=' FROM '+objectname+' WHERE id in :id_accounts';
        if(!id_accounts.isempty()){ 
        List<Sobject> accounts = Database.query(query);
             
            if(accounts.size()>0){ 
                System.debug('accounts'+accounts);
                for(Wrapper wrp : liste){  
                    for(SObject acc : accounts){   
                        String con = '';
                        if(wrp.dat!=null){
                            if(wrp.dat.Ident == acc.id){ 
                                wrp.dat.acc = acc;
                                for(String a :fieldlist ){
                                    String fieldvalue = a +' : '+ String.valueOf(acc.get(a));
                                    con = con + fieldvalue + ',';
                                }
                                wrp.dat.acclist = con;
                            }
                        } 
                    } 
                } 
            }
             
       // } 
        }
        Map<Set<Id>,List<Wrapper>> mymap = new Map<Set<Id>,List<Wrapper>>();
        mymap.put(ids_level,liste);
        return mymap;
    }
        
  
    
     


     
    
}

