<section class="content-header">
	<h1>
		Users<small>Add/Edit/Delete</small>
	</h1>
</section>
<section class="userContent content">
	<div class=" col-md-12">
		<div class="row">
			<button class="btn btn-success pull-right" onclick="User.addUser();">Add
				User</button>
		</div>
		<div class="TaskRow">
            <div class="col-sm-12 paddingTop" id='gridDiv'> </div>
            <div class="col-sm-12" id='gridPaginationDiv'> </div>
		</div>
	</div>
</section>


<script>
	User = function() {
	};
	User.addUser = function() {
		User.addDialog=BootstrapDialog.show({
			autodestroy : true,
			closeByBackdrop: false,
	        closeByKeyboard: false,
			size : BootstrapDialog.SIZE_NORMAL,
			cssClass : 'addUsers-dialog',
			message : $('<div></div>').load(
					"${pageContext.request.contextPath}/addUser.jsp"),
			title : "<b style='font-size: 14px;'>Add User</b>",
			draggable : true,
			closable : true,
			onshown : function() {
				$(".addUsers-dialog .modal-body").css("height",$(".addUser").height()+5+'px');
				$(".addUsers-dialog .modal-body").css("padding", "0px");
			},
			draggable : true,
			buttons : [ {
				label : 'Save',
				icon : 'fa fa-check',
				cssClass : 'btn-success',
				action : function(dialog) {
					addUser.saveData(dialog);
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
	
	User.loadGrid=function(){
		console.log('in load grid');
		var reqJson = {};
		var url = "${pageContext.request.contextPath}/rest/Users/loadGrid?m="+Math.random();
		pagersss = new SortableGrid('gridDiv', url, reqJson, 10,'pagersss','gridPaginationDiv',true);
		pagersss.showPage(1);
		
	}
	gridPaginationDiv = function(data){
		$('.usercontent thead .th0').css("width","5%");
		$('.usercontent thead .th1').css("width","12%");
		$('.usercontent thead .th2').css("width","12%");
		$('.usercontent thead .th3').css("width","12%");
		$('.usercontent thead .th6').css("width","10%");
	 	$('.td6').each(function(){
	 		var id=$(this).parent('tr').children('.td0').text();
			$(this).empty();
			$(this).append('<i class="fa fa-pencil" style="padding:8px;color:blue" onclick="User.editUser('+id+')">  </i>');
			$(this).append('<i class="fa fa-remove" style="padding:8px;color:red"  onclick="User.deleteUser('+id+')">  </i>');
		});
	};
	User.editUser=function(uid){
		User.editDialog=BootstrapDialog.show({
			autodestroy : true,
			closeByBackdrop: false,
	        closeByKeyboard: false,
			size : BootstrapDialog.SIZE_NORMAL,
			cssClass : 'editUsers-dialog',
			message : $('<div></div>').load(
					"${pageContext.request.contextPath}/addUser.jsp"),
			title : "<b style='font-size: 14px;'>Edit User</b>",
			draggable : true,
			closable : true,
			onshown : function() {
				$(".editUsers-dialog .modal-body").css("height",$(".addUser").height()+5+'px');
				$(".editUsers-dialog .modal-body").css("padding", "0px");
				addUser.loadValues(uid);
			},
			draggable : true,
			buttons : [ {
				label : 'Save',
				icon : 'fa fa-check',
				cssClass : 'btn-success',
				action : function(dialog) {
					addUser.saveData(dialog);
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
	User.deleteUser=function(uid){
		BootstrapDialog.show({
        	message: "Are you sure you want to delete this user ?", 
         	title: "Delete User",
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
        	 		url = "${pageContext.request.contextPath}/rest/Users/deleteUser";
        			$.get(url,{userid:uid,loginuser:1},function(response){
        				if(response=="success")
        				{
        					dialogRef.close();
        					User.loadGrid();
        				}
        				else{
        					alert('Error occurred');
        				}
        			});
        	 	}
        	 }],
        	 cssClass: "DeleteUser"      	
     	});
	}
	
	
	$(document).ready(function(){
		User.loadGrid();		
	});
	
	
</script>