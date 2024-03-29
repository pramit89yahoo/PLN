<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<section class="content-header">
	<h1>
		Missionary<small>Add/Edit/Delete</small>
	</h1>
</section>
<section class="content missionaryContent">
	<div class=" col-md-12">
		<div class="Row">
			<div class="col-md-4">
				<input id="mMissionarySearch" type="text" class="form-control " placeholder="Search Missionary"></input>
			</div>
			<div class="col-md-2">
				<button type="button" onclick="Missionary.loadGrid();" class="btn btn-primary" style="margin-right: 5px;">
			            	<i class="fa fa-search"></i> Search  	</button>
			</div>
			<button class="btn btn-success pull-right" onclick="Missionary.addMissionary();">Add Missionary</button>
		</div>
		<div class="TaskRow">
            <div class="col-sm-12 paddingTop" id='misGridDiv'> </div>
            <div class="col-sm-12" id='misGridPaginationDiv'> </div>
		</div>
	</div>
	
</section>


<script>
	Missionary = function() {
	};
	Missionary.addMissionary = function() {
		Missionary.addDialog=BootstrapDialog.show({
			autodestroy : true,
			closeByBackdrop: false,
	        closeByKeyboard: false,
			size : BootstrapDialog.SIZE_NORMAL,
			cssClass : 'addMissionary-dialog',
			message : $('<div></div>').load(
					"${pageContext.request.contextPath}/addMissionary.jsp"),
			title : "<b style='font-size: 14px;'>Add Missionary</b>",
			draggable : true,
			closable : true,
			onshown : function() {
				$(".addMissionary-dialog .modal-body").css("height",
						$(".addMissionary").height() + 5 + 'px');
				$(".addMissionary-dialog .modal-body").css("padding", "0px");
			},
			draggable : true,
			buttons : [ {
				label : 'Save',
				icon : 'fa fa-check',
				cssClass : 'btn-success',
				action : function(dialog) {
					addMissionary.savedata(dialog);
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
	};
	
	
	Missionary.loadGrid=function(){
		var reqJson = {};
		if($("#mMissionarySearch").val()!= '' && Missionary.cmid != 0)
		{
			reqJson.cmid= Missionary.cmid;
		}
		console.log('in load grid');
		
		var url = "${pageContext.request.contextPath}/rest/Missionary/loadGrid?m="+Math.random();
		pagersss = new SortableGrid('misGridDiv', url, reqJson, 1000,'pagersss','misGridPaginationDiv',true);
		pagersss.showPage(1);
		
	}
	misGridPaginationDiv = function(data){
		$('.missionaryContent thead .th0').css("width","5%");
		$('.missionaryContent thead .th1').css("width","15%");
		$('.missionaryContent thead .th2').css("width","15%");
		$('.missionaryContent thead .th3').css("width","15%");
		$('.missionaryContent thead .th6').css("width","10%");
		$('.missionaryContent thead .th7').css("width","8%");
	 	$('.td7').each(function(){
	 		var id=$(this).parent('tr').children('.td0').text();
			$(this).empty();
			$(this).append('<i class="fa fa-pencil" style="padding:8px;color:blue" onclick="Missionary.editMissionary('+id+')">  </i>');
			$(this).append('<i class="fa fa-remove" style="padding:8px;color:red"  onclick="Missionary.deleteMissionary('+id+')">  </i>');
		});
	};
	
	Missionary.deleteMissionary=function(mid){
		BootstrapDialog.show({
        	message: "Are you sure you want to delete this Missionary ?", 
         	title: "Delete Missionary",
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
        	 		url = "${pageContext.request.contextPath}/rest/Missionary/deleteMissionary";
        			$.get(url,{'mid':mid,loginuser:Home.loginUser},function(response){
        				if(response=="success")
        				{
        					dialogRef.close();
        					Missionary.loadGrid();
        				}
        				else{
        					alert('Error occurred');
        				}
        			});
        	 	}
        	 }],
        	 cssClass: "DeleteMisssionary"      	
     	});
	}
	Missionary.editMissionary=function(uid){
		Missionary.editDialog=BootstrapDialog.show({
			autodestroy : true,
			closeByBackdrop: false,
	        closeByKeyboard: false,
			size : BootstrapDialog.SIZE_NORMAL,
			cssClass : 'editMissionary-dialog',
			message : $('<div></div>').load(
					"${pageContext.request.contextPath}/addMissionary.jsp"),
			title : "<b style='font-size: 14px;'>Edit Missionary</b>",
			draggable : true,
			closable : true,
			onshown : function() {
				$(".editMissionary-dialog .modal-body").css("height",$(".addMissionary").height()+5+'px');
				$(".editMissionary-dialog .modal-body").css("padding", "0px");
				addMissionary.loadValues(uid);
			},
			draggable : true,
			buttons : [ {
				label : 'Save',
				icon : 'fa fa-check',
				cssClass : 'btn-success',
				action : function(dialog) {
					addMissionary.savedata(dialog);
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
	$(document).ready(function(){
		Missionary.loadGrid();		
		$("#mMissionarySearch").autocomplete({
	        source: "${pageContext.request.contextPath}/rest/Missionary/getMissionary?limit=10&m="+Math.random(),
	        minLength: 2,
	        select: function(event, ui) {
	        	$("#mMissionarySearch").val(ui.item.label);
	        	Missionary.cmid = ui.item.id;
	        }
	    });
	});
</script>