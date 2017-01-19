<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
	<div class="editConvert col-md-12 ui-front">
		<form class="form-horizontal" id="addUserForm">
			<div class="box-body">
				<div class="form-group">
					<label class="col-md-4 control-label">Convert Name *</label>
					<div class="col-md-8">
						<input id="cname" type="text" class="form-control requiredfield" placeholder="Convert Name"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-4 control-label">Age *</label>
					<div class="col-md-8">
						<input id="cage" type="number" class="form-control requiredfield" placeholder="Age"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-4 control-label">Gender *</label>
					<div class="col-md-8">
						<select id="cgender" class="form-control requiredfield">
									<option value="">Select</option>
									<option value="male">Male</option>
									<option value="female">Female</option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-4 control-label">Missionary *</label>
					<div class="col-md-8">
						<input id="cmissionary" type="text" class="form-control requiredfield" placeholder="Missionary Name"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-4 control-label">Date *</label>
					<div class="col-md-8">
						<input id="cdate" type="text" class="form-control requiredfield" placeholder="Date"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-4 control-label">Ward *</label>
					<div class="col-md-8">
						<input id="cward" type="text" class="form-control requiredfield" placeholder="Ward"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-4 control-label">Stake *</label>
					<div class="col-md-8">
						<input id="cstake" type="text" class="form-control requiredfield" placeholder="Stake"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-4 control-label">Baptism *</label>
					<div class="col-md-8">
						<input id="cbaptism" type="text" class="form-control requiredfield" placeholder="Baptism"> </input>
					</div>
				</div>
			</div>
			</form>
			<div id="errorDetails"></div>
		</div>
	</body>
</html>
<script>
	editConvert=function(){};
	editConvert.cid=0;
	editConvert.cmid;
	editConvert.loadValues=function(cid){
		var url="${pageContext.request.contextPath}/rest/Convert/editConvert";
		$.get(url,{'cid':cid},function(response){
			var resp = JSON.parse(response);
        	editConvert.cid = resp["cid"];
        	$("#cname").val(resp["cname"]);
        	$("#cage").val(resp["cage"]);
        	$("#cgender").val(resp["cgender"]);
        	$("#cmissionary").val(resp["mname"]);
        	$("#cdate").val(resp["cdate"]);
        	$("#cward").val(resp["cward"]);
        	$("#cstake").val(resp["cstake"]);
        	$("#cbaptism").val(resp["cbaptism"]);
        	editConvert.cmid=resp["mid"];
		});
	}
	editConvert.saveData=function(dialog){
		console.log('in save data for convert');
		if (editConvert.validate()) {
			console.log('convert verified data')
			var data = {};
			var convertArray=[];
			var whereObjData = {};
			
			data["mid"] = editConvert.cmid != null ? editConvert.cmid.toString() : "0";
			data["cdate"] = $("#cdate").val() != null ? $("#cdate").val().toString() : "";
			data["cward"] = $("#cward").val() != null ? $("#cward").val().toString() : "";
			data["cstake"] = $("#cstake").val() != null ? $("#cstake").val().toString() : "";
			data["cbaptism"] = $("#cbaptism").val() != null ? $("#cbaptism").val().toString() : "";
			data["clastmodifiedby"] = Home.loginUser != null ? Home.loginUser : "0";
			data["clastmodifiedtime"]="NOW()";
			
			var convertDetails={};
			convertDetails["cname"]=$("#cname").val() != null ? $("#cname").val().toString() : "";
			convertDetails["cage"]=$("#cage").val() != null ? $("#cage").val().toString() : "";
			convertDetails["cgender"]=$("#cgender").val() != null ? $("#cgender").val().toString() : "";
			convertArray.push(convertDetails);
			
			whereObjData["cid"] =editConvert.cid;
			
			var url="${pageContext.request.contextPath}/rest/Convert/saveConvert";
			$.post(url,{data:JSON.stringify(data),convertArray:JSON.stringify(convertArray),whereObjData:JSON.stringify(whereObjData)},function(responseText){
				if(responseText=="Success")
				{
					alert('convert saved.');
					dialog.close();
					Convert.loadGrid();
				}
				else {
					alert('An error occurred');
					dialog.close();
				}
			});
		}
	}
	editConvert.validate=function(){
		console.log('in edit convert validate data');
		var valid = 0;
		$(".editConvert #errorDetails").css("display", "none");
		
		$(".requiredfield").each(function(){
				if ($(this).val() == undefined || $(this).val() == 0 || $(this).val() == "" || $(this).val() == null) {
					$(this).css("border-color", "red");
					$(".editConvert #errorDetails").text("Please fill all mandatory fields");
					$(".editConvert #errorDetails").css("display", "");
					$(".editConvert #errorDetails").css("color","red");
					valid = 1;
				} else {
					$(this).css("border-color", "");
				}
			});
		if(editConvert.cmid==0 || editConvert.cmid==undefined)
		{
			valid = 1;
			$('#cmissionary').css("border-color", "red");
		}
		if (valid == 1) {
			return false;
		} else {
			return true;
		}
	}

	$(document).ready(function(id){
		$(".editConvert #errorDetails").css("display", "none");
		$("#cdate").datetimepicker({pickTime:false,format: 'MM/DD/YYYY'});
		$("#cmissionary").autocomplete({
	        source: "${pageContext.request.contextPath}/rest/Missionary/getMissionary?limit=10&m="+Math.random(),
	        minLength: 2,
	        select: function(event, ui) {
	        	$("#cmissionary").val(ui.item.label);
	        	editConvert.cmid = ui.item.id;
	        }
	    });
		$("#cward").autocomplete({
	        source: "${pageContext.request.contextPath}/rest/Convert/getWard?limit=10&m="+Math.random(),
	        minLength: 1,
	        select: function(event, ui) {
	        	$("#cward").val(ui.item.label);
	        }
	    });
		$("#cstake").autocomplete({
	        source: "${pageContext.request.contextPath}/rest/Convert/getStake?limit=10&m="+Math.random(),
	        minLength: 1,
	        select: function(event, ui) {
	        	$("#cstake").val(ui.item.label);
	        }
	    });
		
	});

</script>