import { LightningElement,api,track } from 'lwc';
import cytos from '@salesforce/resourceUrl/cytos_label_min';
import { loadScript } from 'lightning/platformResourceLoader';
import getData from '@salesforce/apex/SchemaCtrlMdt.getData'
export default class Finalfoyercomponent extends LightningElement {
      
    /* test gitworkflow */
    @track foyers;
    @track nombre;
    @api recordId;
    @api edges1 = [];
    @api nodes1 = [];
     
    renderedCallback() {

        Promise.all([
            loadScript(this, cytos + '/cytos2.js'),
        ])
            .then(() => {
                this.initializecytos();
            })
           
    }

    initializecytos(){
        getData({record : this.recordId})
        .then(result => {
           this.foyers =  JSON.parse(result);  
              this.nombre = (this.foyers).length;     
        for(var i = 0 ; i< this.nombre ; i++){ 
         
          if((this.foyers)[i].groupe =='nodes'){  
            console.log('acclist'+(this.foyers)[i].dat.acclist);
              this.nodes1.push({ 
                data: { 
                    id: (this.foyers)[i].dat.acc.Id, 
                    name: (this.foyers)[i].dat.acc.Name,
                    acc: (this.foyers)[i].dat.acc,
                    accList : (this.foyers)[i].dat.acclist,
                    urlimage : (this.foyers)[i].dat.formulaimage,
                    codeCouleur : (this.foyers)[i].dat.codeCouleur,
                    Backgroundfit : (this.foyers)[i].dat.Backgroundfit,
                    shape : (this.foyers)[i].dat.shape,
                    Width : (this.foyers)[i].dat.width+'px',
                    height : (this.foyers)[i].dat.height+'px',
                    Fontsize  : (this.foyers)[i].dat.Fontsize+'px',
                },
                classes: (this.foyers)[i].dat.acc.Id == this.recordId ? 'init':''
            });
          }
          else{
            
             this.edges1.push({
                data: { id: 'e'+(this.foyers)[i].data2.source+(this.foyers)[i].data2.target,
                source:(this.foyers)[i].data2.source, 
                target: (this.foyers)[i].data2.target, 
                linecolor :(this.foyers)[i].data2.lineColor,
                couleurEdge : (this.foyers)[i].data2.edgeColor,
                curvestyle :  (this.foyers)[i].data2.curvestyle,
                textrotation : (this.foyers)[i].data2.textrotation,
                Fontsize  :  (this.foyers)[i].data2.Fontsize+'px',
                label :  (this.foyers)[i].data2.edgelist
            },
            classes:'background'
             }) ;
         }
         
      } 

      let cy = cytoscape({
        
        container: this.template.querySelector('.cy'),  
        boxSelectionEnabled: true, 
        ready: function(event){
          console.log('ready');
          
        }, 
        elements: {
            nodes : this.nodes1,
            edges : this.edges1
        },
        style: cytoscape.stylesheet()
        .selector('edge')
        .css({
              'width': 1,
              'line-color': 'data(linecolor)',
              'target-arrow-color': 'black',
              'target-arrow-shape': 'triangle',
              'arrow-scale':1,
              'curve-style': 'data(curvestyle)', 
              'text-rotation' : 'data(textrotation)',
              'text-wrap' :'wrap',
              'text-max-width' :'100px',
              'control-point-distance': 40,
              'label': 'data(label)',
              'text-valign': 'top',
              'word-wrap': 'break-word',
              'font-size': 'data(Fontsize)',
              'line-height': '1.7px',
              'color': 'data(couleurEdge)' 
          
          }) 
          .selector('.background') 
          .css({ 
              'text-background-opacity' : 1,
              'text-background-color':'white',
          }) 
          .selector('node') 
          .css({ 
              'content':'data(name)', 
              'text-valign': 'center',
              'color': 'data(codeCouleur)',   
              'background-fit': 'data(Backgroundfit)', 
              'shape': 'data(shape)', 
              'width':'data(Width)',
              'height':'data(height)',
              'text-wrap' :'wrap',
              'text-max-width' :'110px',
              'font-size': 'data(Fontsize)', 
              'background-color' : '#B0C4DE'
          }) 
          .selector('.init')
          .css({ 
             "background-color":"#0169D9",
              "line-color":"#0169D9",
              "source-arrow-color":"#0169D9",
              "target-arrow-color":"#0169D9",
              "mid-source-arrow-color":"#0169D9",
              "mid-target-arrow-color":"#0169D9"
           })
           .selector('node:selected')
           .css({
            "border-width": 2,
            "border-style": "solid",
            "border-color": "#3f3f3f",
            "border-opacity": 1
           }), 
        layout: {
            name: 'circle',
            rows: 4,
            animate: 'end',
						animationDuration: 3000,
						animationEasing: 'spring(500, 40)'
        },
        
       
    });
    
    var layout = cy.layout({
        name: 'circle',
        
      });           
      layout.run();
     
      cy.nodeHtmlLabel([{
        query: 'node',
        cssClass: 'cy-title',
        valign: "top",
        valignBox: "top",  
        
        tpl(data){  
           
           var acc2 = data.acc.Name;
           var accUrl = data.acc.id;
         
          
           var urlImage = data.urlimage;
           var iddiv = data.id + 'myUl';
            return   '<article id="'+data.id+'" style="visibility: hidden; margin-left : -60px; cursor: pointer; position : relative;" class="slds-card slds-m-top_large slds-card_boundary"  >'+
            '<div class="slds-card__header slds-grid">'+
                '<header class="slds-media slds-media_center slds-has-flexi-truncate">'+
                    '<div class="slds-media__figure" style = "margin-top: -10px ;width : 40px; height : 45px;">'+
                        '<img src="'+urlImage+'" alt="'+urlImage+'" />'+
                    '</div>'+
                    '<div class="slds-media__body" style = "margin-top : -30px;   width : 60px;">'+
                        '<h2 class="slds-card__header-title" style = "margin-top : 10px ;font-size : 10px;text-align:center; margin-left :-10px;">'+
                            '<a href="/'+accUrl+'">'+ 
                                '<span style= "word-break: break-word;">'+acc2+'</span>'+
                            '</a>'+
                        '</h2>'+
                    '</div>'+
                '</header>'+
            '</div>'+
            '<div class="slds-card__body slds-card__body_inner" Style=" border-top-style: outset; text-align:center;padding: 10px 10px;font-weight: bold;box-sizing: border-box; margin-top : -10px;">'+
               '<div id="'+iddiv+'"></div>'+
            '</div>'+
            
        '</article>';
            

                                              
        }
    }],
    {enablePointerEvents:true}
); 
    
cy.on('tap','node', function(e){  
  
    var ele = e.target;
    var sl = ele.data('accList');
    var slides = sl.split(',');
    console.log('sl'+ele.data('accList'));
    var iddiv = ele.id() + 'myUl';
    if ( document.getElementById(iddiv).innerHTML === "" ) {
    slides.forEach(function(item) {
     var li = document.createElement("p");
     var text = document.createTextNode(item);
     li.appendChild(text);
     document.getElementById(iddiv).appendChild(li);
    });
     
    
}
     
    
    var visible = document.getElementById(ele.id()).style.visibility; 
    document.getElementById(ele.id()).style.visibility = visible == 'hidden'? 'visible' : 'hidden';
   
   
    
});

window.onscroll = function() {
    cy.resize();
};



        });
    
    

     

    }
  
  

      

}