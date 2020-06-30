import { LightningElement,track, api } from 'lwc';
import updateParamNodevalues from '@salesforce/apex/ParamClass.updateParamNodevalues';
import updateParamEdgevalues from '@salesforce/apex/ParamClass.updateParamEdgevalues';
import updateObjectParamvalues  from '@salesforce/apex/ParamClass.updateObjectParamvalues';
import getAllObjects from '@salesforce/apex/ParamClass.getAllObjects';
import getAllchildObjects from '@salesforce/apex/ParamClass.getAllchildObjects';
import getFields from  '@salesforce/apex/ParamClass.getFields';
import getFieldsReference from  '@salesforce/apex/ParamClass.getFieldsReference';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Paraminterface extends LightningElement {
    
    @track multiple = true;
    @track backgroundfitvalue ;
    @track shapevalue  ;
    @track curvevalue ;
    @track Objectvalue ;
    @track Relationvalue ;
    @track textrotation ;

    @track nodecolor;
    @track nodefontsize;
    @track nodewidth;
    @track nodeheight;
    @track Edgecolor;
    @track Edgefontsize;
    @track Edgelinecolor;
    @track _selectedfields =[];
    @track _selectedlookup =[];
   
     @api obs = [];
     @track objects = [];
     @track relationsoptions = [];
     @track Relationobjects = [];
     @track fieldsoptions = [];
     @track relationfieldsoptions = [];
     @track parentRelation = [];
     @track lookupRelation = [];

     @track parentrelationvalue;
     @track lookuprelationvalue;
       
    connectedCallback(){
        getAllObjects()
            .then(result => {
                this.obs = result;

            })
            .catch(error => {
                this.error = error;
            });
        }
  
    handleChangefields(e) {
        this._selectedfields = e.detail.value;
        console.log('selectedfields'+this._selectedfields);
    }

    

    handleChangelookup(e) {
        this._selectedlookup = e.detail.value;
        console.log('selectedlookup'+this._selectedlookup);
        
    }

    edgelinecolor(event){
        this.Edgelinecolor = event.target.value;
        console.log('edgecolorline'+this.Edgelinecolor);
     }
    edgefontsizeChange(event){
        this.Edgefontsize = event.target.value;
        console.log('edgefontsize'+this.Edgefontsize);
     }
    edgecolorChange(event){

        this.Edgecolor = event.target.value;
        console.log('edgecolor'+this.Edgecolor);
     }
    nodecolorChange(event){

        this.nodecolor= event.target.value;
        console.log('nodecolor'+this.nodecolor);
     }

     nodefontsizeChange(event){

        this.nodefontsize= event.target.value;
        console.log('nodefontsize'+this.nodefontsize);
     }
     nodewidthChange(event){

        this.nodewidth= event.target.value;
        console.log('nodewidth'+this.nodewidth);
     }
     nodeheightChange(event){

        this.nodeheight= event.target.value;
        console.log('nodeheight'+this.nodeheight);
     }


    get backgroundfitoptions() {
        return [
                 { label: 'cover', value: 'cover' },
                 { label: 'contain', value: 'contain' },
                 { label: 'none', value: 'none' },
               ];
    }
    handleChangebackgroundfit(event) {
            this.backgroundfitvalue = event.detail.value;
            console.log('backgroundfit'+this.backgroundfitvalue);
         }
    
         get Objectoptions() {
             console.log('rehqdjqfkj');
             let options = [];
               
                for(let key in (this.obs)) {
                
                       options.push({label:key , value:(this.obs)[key]});
                    
                }
               
            return options;   
        
        }
        handleChangeObject(event) {
            this.Objectvalue = event.detail.value;
                console.log('Objectoption'+this.Objectvalue);
                getFields({objectName : this.Objectvalue })
                .then(data => {
                    let fieoptions = [];
                    for(let key in data){
                        fieoptions.push({label : data[key],value : data[key]});
                    }
                     this.fieldsoptions = fieoptions;
                })
                .catch(error => {
                    this.error = error;
                }); 
                
                getAllchildObjects({parentobject : this.Objectvalue})
                .then(data => {
                    this.Relationobjects = data;
                    console.log('relation2'+this.Relationobjects);
                    let relationsoptions = [];
            const listoptions = [];
            var count = {};
            Object.values((this.Relationobjects)).forEach(function(i) { count[i] = (count[i]||0) + 1;});
            console.log(count);
            for (var element in count) {

                console.log(element + ' = ' + count[element]);
              } 
               for(let key in (this.Relationobjects)) {
                   if(count[(this.Relationobjects)[key]] > 1){
                       listoptions.push((this.Relationobjects)[key]);
                    }
                }
               let unique = listoptions.filter((item,index) => {return listoptions.indexOf(item) === index});
               console.log('listoptions'+unique);
               for(let el in unique){
                relationsoptions.push({label:unique[el] , value:unique[el]});
               }
                  this.relationsoptions = relationsoptions;
                })
                .catch(error => {
                    this.error = error;
                }); 
             }

             handleChangeparentrelation(event) {
                this.parentrelationvalue = event.detail.value;
                console.log('parent'+this.parentrelationvalue);
            }
            handleChangelookuprelation(event) {
                this.lookuprelationvalue = event.detail.value;
                console.log('lookup'+this.lookuprelationvalue);
    }
            
      
        handleChangeRelation(event) {
                    this.Relationvalue = event.detail.value;
                    console.log('Relation'+this.Relationvalue);
                    getFields({objectName : this.Relationvalue })
                .then(data => {
                    let fierelationoptions = [];
                    for(let key in data){
                        fierelationoptions.push({label : data[key],value : data[key]});
                    }
                     this.relationfieldsoptions = fierelationoptions;
                })
                .catch(error => {
                    this.error = error;
                }); 
                getFieldsReference({objectName : this.Relationvalue })
                .then(data => {
                    let Referencerelation = [];
                    for(let key in data){
                        Referencerelation.push({label : data[key],value : data[key]});
                    }
                     this.parentRelation = Referencerelation;
                     this.Referencerelation = Referencerelation;
                })
                .catch(error => {
                    this.error = error;
                }); 
                 }
     get shapeoptions() {
            return [
                     { label: 'triangle', value: 'triangle' },
                     { label: 'ellipse', value: 'ellipse' },
                     { label: 'rectangle', value: 'rectangle' },
                   ];
        }
        handleChangeshape(event) {
                this.shapevalue = event.detail.value;
                console.log('shape'+this.shapevalue);
             }
        get curveoptions() {
                return [
                         { label: 'bezier', value: 'bezier' },
                         { label: 'unbundled-bezier', value: 'unbundled-bezier' },
                         { label: 'haystack', value: 'haystack' },
                       ];
            }
        handleChangecurve(event) {
                    this.curvevalue = event.detail.value;
                    console.log('curve'+this.curvevalue);
        }
        get textrotationoptions() {
            return [
                     { label: 'autorotate', value: 'autorotate' },
                   ];
        }
    handleChangetextrotate(event) {
                this.textrotation = event.detail.value;
                console.log('textrotate'+this.textrotation);
    }

    handleClick(e) {
        Promise.all([
            updateParamNodevalues({
                color: this.nodecolor,
                Backgroudfit: this.backgroundfitvalue,
                fontsize : this.nodefontsize,
                shape : this.shapevalue ,
                width : this.nodewidth,
                 height : this.nodeheight
            }),
            updateParamEdgevalues({
                color: this.Edgecolor,
                linecolor: this.Edgelinecolor,
                fontsize : this.Edgefontsize,
                curve : this.curvevalue ,
                textrotation : this.textrotation
            }),
            updateObjectParamvalues({
                Objectname : this.Objectvalue,
                RelationName : this.Relationvalue,
                nodesfields :   this._selectedfields,
                edgefields : this._selectedlookup,
                ParentRelation : this.parentrelationvalue,
                Lookuprelation : this.lookuprelationvalue
            }),
            
         ])
        .then(() => {
            const evt = new ShowToastEvent({
                title: 'Record Update',
                message: 'Custom setting is loaded ',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
            location.reload();
        })
        .catch((error) => {
            this.message = 'Error received: code'+error;
        });
    }



}