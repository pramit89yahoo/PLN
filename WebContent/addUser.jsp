<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
	<div class="addUser col-md-12">
		<form class="form-horizontal" id="addUserForm">
			<div class="box-body">
				<div class="form-group">
					<label class="col-md-4 control-label">First Name *</label>
					<div class="col-md-8">
						<input id="ufname" type="text" class="form-control requiredfield"
							placeholder="First Name"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-4 control-label">Last Name *</label>
					<div class="col-md-8">
						<input id="ulname" type="text" class="form-control requiredfield"
							placeholder="Last Name"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-4 control-label">Email Address *</label>
					<div class="col-md-8">
						<input id="uemail" type="email" class="form-control requiredfield"
							placeholder="Email Address"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-4 control-label">Phone # *</label>
					<div class="col-md-8">
						<input id="upphone" type="text" class="form-control requiredfield"
							data-inputmask="&quot;mask&quot;: &quot;(999) 999-9999&quot;"
							data-mask="" placeholder="Phone #"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-4 control-label">Login ID *</label>
					<div class="col-md-8">
						<input id="uname" type="text" class="form-control requiredfield"
							placeholder="Login Name"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-4 control-label">Login Password *</label>
					<div class="col-md-8">
						<input id="upwd" type="password"
							class="form-control requiredfield" placeholder="Login Password">
						</input>
					</div>
				</div>
				<div id="errorDetails"></div>
			</div>
		</form>
		
	</div>
</body>
</html>

<script>
	
	addUser = function() {};
	addUser.id=0;
	addUser.saveData = function(dialog) {
		console.log('called savedata');
		if (addUser.varifyForm()) {
			console.log('verified data')
			var data = {};
			var whereObjData = {};
			if(addUser.id > 0){
			whereObjData["uid"] =addUser.id;
			}
			
			data["ufname"] = $("#ufname").val() != null ? $("#ufname").val()
					.toString() : "";
			data["ulname"] = $("#ulname").val() != null ? $("#ulname").val()
					.toString() : "";
			data["uemail"] = $("#uemail").val() != null ? $("#uemail").val()
					.toString() : "";
			data["uphone"] = $("#upphone").val() != null ? $("#upphone").val()
					.toString() : "";
			data["uname"] = $("#uname").val() != null ? $("#uname").val()
					.toString() : "";
			data["upwd"] = $("#upwd").val() != null ? $("#upwd").val()
					.toString() : "";
			data["ulastmodifiedby"]=Home.loginUser != null ? Home.loginUser : "0";
			data["ulastmodifiedtime"]="NOW()";
			
			var url="${pageContext.request.contextPath}/rest/Users/saveUser";
			$.post(url,{data:JSON.stringify(data),whereObjData:JSON.stringify(whereObjData)},function(responseText){
				if(responseText== "AlreadyTaken")
				{
					$("#addUserForm #errorDetails").text("Username already taken, please select another.");
					$("#addUserForm #errorDetails").css("display","");
					$("#addUserForm #errorDetails").css("color","red");
					$("#addUserForm #uname").css("border-color","red");
				}
				else if(responseText=="Success")
				{
					alert('User saved.');
					dialog.close();
					User.loadGrid();
				}
				else {
					alert('An error occurred');
					dialog.close();
				}
			});
		}
	}

	addUser.varifyForm = function() {
		var valid = 0;
		$("#addUserForm #errorDetails").css("display","none");
		console.log('called verify form');
		if(!utils.validateEmail($("#uemail").val())){
			$("#addUserForm #errorDetails").text("Invalid email format");
			$("#addUserForm #errorDetails").css("display","");
			$("#addUserForm #errorDetails").css("color","red");
			return false;
		}
		$(".requiredfield").each(
				function() {
					if ($(this).val() == undefined || $(this).val() == 0
							|| $(this).val() == "" || $(this).val() == null) {
						$(this).css("border-color", "red");
						valid = 1;
						$("#addUserForm #errorDetails").text("Please fill all mandatory fields");
						$("#addUserForm #errorDetails").css("display","");
						$("#addUserForm #errorDetails").css("color","red");
					}
					else{
						$(this).css("border-color", "");
					}
				});
		if (valid == 1) {
			return false;
		} else {
			return true;
		}
	}
	
	addUser.loadValues=function(uid){
		var url="${pageContext.request.contextPath}/rest/Users/editUser";
		$.get(url,{'uid':uid},function(response){
			var resp = JSON.parse(response);
        	addUser.id = resp["uid"];
        	$("#ufname").val(resp["ufname"]);
        	$("#ulname").val(resp["ulname"]);
        	$("#uemail").val(resp["uemail"]);
        	$("#upphone").val(resp["uphone"]);
        	$("#uname").val(resp["uname"]);
        	$("#upwd").val(resp["upwd"]);
		});
	}
	
	$(document).ready(function() {
		$("[data-mask]").inputmask();
		$("#addUserForm #errorDetails").css("display","none");
	});
</script>