<section class="content-header">
	<h1>
		Converts<small>Add/Edit/Delete</small>
	</h1>
</section>
<section class="content convertContent">
	<div class="col-md-12">
		<div class="Row">
			<div class="col-md-4">
				<input id="cConvertSearch" type="text" class="form-control " placeholder="Search Convert"></input>
			</div>
			<div class="col-md-2">
				<button type="button" onclick="Convert.loadGrid();" class="btn btn-primary" style="margin-right: 5px;">
			            	<i class="fa fa-search"></i> Search  	</button>
			</div>
			<button class="btn btn-success pull-right" onclick="Convert.addConvert();">Add Converts</button>
		</div>
		<div class="TaskRow">
            <div class="col-sm-12 paddingTop" id='convertGridDiv'> </div>
            <div class="col-sm-12" id='convertGridPaginationDiv'> </div>
		</div>
	</div>
	
</section>
<script>
Convert=function(){};
Convert.addConvert=function(){
	BootstrapDialog.show({
		autodestroy: true,
		closeByBackdrop: false,
        closeByKeyboard: false,
		size: BootstrapDialog.SIZE_WIDE, 
		cssClass: 'addConverts-dialog',
		message: $('<div></div>').load("${pageContext.request.contextPath}/addConvert.jsp"),
		title: "<b style='font-size: 14px;'>Add Converts</b>",
		draggable : true,
		closable : true,
		onshown : function(){
      	$(".addConverts-dialog .modal-body").css("height",$(".addConvert").height()+5+'px');
      	$(".addConverts-dialog .modal-body").css("padding","0px");
      },
      draggable : true,
      buttons: [
					 {
    			    label: 'Save',
    			    icon: 'fa fa-check',
    			    cssClass: 'btn-success',
    			    action: function(dialog) {
    			    	addConvert.savedata(dialog);
    			    }
    			} ,  
              {
                 label: 'Close',
                 icon: 'fa fa-times',
                 cssClass:'btn-warning',
                 action: function(dialog) {
                     dialog.close();
                 }
             }]
});
};

Convert.loadGrid=function(){
	var reqJson = {};
	if($("#cConvertSearch").val()!= '' && Convert.cid != 0)
	{
		reqJson.cid= Convert.cid;
	}
	console.log('in load grid');
	var url = "${pageContext.request.contextPath}/rest/Convert/loadGrid?m="+Math.random();
	pagersss = new SortableGrid('convertGridDiv', url, reqJson, 100,'pagersss','convertGridPaginationDiv',true);
	pagersss.showPage(1);
	
}
convertGridPaginationDiv = function(data){
	$('.convertContent thead .th0').css("width","5%");
	$('.convertContent thead .th1').css("width","12%");
	$('.convertContent thead .th2').css("width","12%");
	$('.convertContent thead .th3').css("width","12%");
	$('.convertContent thead .th9').css("width","10%");
 	$('.td9').each(function(){
 		var id=$(this).parent('tr').children('.td0').text();
		$(this).empty();
		$(this).append('<i class="fa fa-pencil" style="padding:8px;color:blue" onclick="Convert.editConvert('+id+')">  </i>');
		$(this).append('<i class="fa fa-remove" style="padding:8px;color:red"  onclick="Convert.deleteConvert('+id+')">  </i>');
	});
};
Convert.editConvert=function(cid){
	Convert.editDialog=BootstrapDialog.show({
		autodestroy : true,
		closeByBackdrop: false,
        closeByKeyboard: false,
		size : BootstrapDialog.SIZE_NORMAL,
		cssClass : 'editConverts-dialog',
		message : $('<div></div>').load(
				"${pageContext.request.contextPath}/editConvert.jsp"),
		title : "<b style='font-size: 14px;'>Edit Convert</b>",
		draggable : true,
		closable : true,
		onshown : function() {
			$(".editConverts-dialog .modal-body").css("height",$(".addConvert").height()+5+'px');
			$(".editConverts-dialog .modal-body").css("padding", "0px");
			editConvert.loadValues(cid);
		},
		draggable : true,
		buttons : [ {
			label : 'Save',
			icon : 'fa fa-check',
			cssClass : 'btn-success',
			action : function(dialog) {
				editConvert.saveData(dialog);
			}
		},
		{
			label : 'Close',
			icon : 'fa fa-times',
			cssClass : 'btn-warning',
			action : function(dialog) {
				dialog.close();
			}
		} ]
	});
	
}
Convert.deleteConvert=function(cid){
	BootstrapDialog.show({
    	message: "Are you sure you want to delete this convert ?", 
     	title: "Delete Convert",
     	draggable : true,
        buttons: [{
        	 cssClass : 'btn-default btn-sm' ,
    		 label: '<i class="fa fa-times" aria-hidden="true"></i> No',
    		 action: function(dialogRef) {
    			dialogRef.close();
    		}
    	 },{
    	 	cssClass : 'btn-success btn-sm',
    	 	label : '<i class="fa fa-check"></i> Yes',
    	 	action : function(dialogRef){
    	 		url = "${pageContext.request.contextPath}/rest/Convert/deleteConvert";
    			$.get(url,{'cid':cid,loginuser:Home.loginUser},function(response){
    				if(response=="success")
    				{
    					dialogRef.close();
    					Convert.loadGrid();
    				}
    				else{
    					alert('Error occurred');
    				}
    			});
    	 	}
    	 }],
    	 cssClass: "DeleteConvert"      	
 	});
}



$(document).ready(function(){
	Convert.loadGrid();	
	$("#cConvertSearch").autocomplete({
        source: "${pageContext.request.contextPath}/rest/Convert/getConvertByName?limit=10&m="+Math.random(),
        minLength: 2,
        select: function(event, ui) {
        	$("#cConvertSearch").val(ui.item.label);
        	Convert.cid = ui.item.id;
        }
    });
});

</script>