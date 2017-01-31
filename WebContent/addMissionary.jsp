<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<div class="addMissionary col-md-12">
		<form class="form-horizontal addMissionaryForm">
			<div class="box-body">
				<div class="form-group">
					<label class="col-md-5 control-label">Title</label>
					<div class="col-md-7">
						<select id="mtitle" class="form-control requiredfield">
							<option value="">Select</option>
							<option value="Elder">Elder</option>
							<option value="Sister">Sister</option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-5 control-label">First Name</label>
					<div class="col-md-7">
						<input id="mfname" type="text" class="form-control requiredfield" placeholder="First Name"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-5 control-label">Last Name</label>
					<div class="col-md-7">
						<input id="mlname" type="text" class="form-control requiredfield" placeholder="Last name"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-5 control-label">ArrivalDate</label>
					<div class="col-md-7">
						<input id="marrivaldate" type="text" class="form-control requiredfield" readonly placeholder="Arrival Date"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-5 control-label">departed Date</label>
					<div class="col-md-7">
						<input id="mdepartdate" type="text" class="form-control requiredfield" readonly placeholder="Departed Date"> </input>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-5 control-label">Nationality</label>
					<div class="col-md-7">
						<select id="mnationality" class="form-control requiredfield">
							<option value="">Select</option>
							<option value="American">American</option>
							<option value="Latino">Latino</option>
						</select>
					</div>
				</div>
				<div id="errorDetails"></div>
			</div>
		</form>
	</div>
</body>
</html>
<script>
	addMissionary = function() {
	};
	addMissionary.id=0;
	addMissionary.savedata = function(dialog) {
		console.log('in save data');
		if (addMissionary.validate()) {
			console.log('missionary verified data')
			var data = {};
			var whereObjData = {};
			if(addMissionary.id > 0){
			whereObjData["mid"] =addMissionary.id;
			}
			data["mtitle"] = $("#mtitle").val() != null ? $("#mtitle").val().toString() : "";
			data["mfname"] = $("#mfname").val() != null ? $("#mfname").val().toString() : "";
			data["mlname"] = $("#mlname").val() != null ? $("#mlname").val().toString() : "";
			data["marrivaldate"] = $("#marrivaldate").val() != null ? $("#marrivaldate").val().toString() : "";
			data["mnationality"] = $("#mnationality").val() != null ? $("#mnationality").val().toString() : "";
			data["mdepartdate"] = $("#mdepartdate").val() != null ? $("#mdepartdate").val().toString() : "";
			data["mlastmodifiedby"]=Home.loginUser != null ? Home.loginUser : "0";
			data["mlastmodifiedtime"]="NOW()";
			var url="${pageContext.request.contextPath}/rest/Missionary/saveMissionary";
			$.post(url,{data:JSON.stringify(data),whereObjData:JSON.stringify(whereObjData)},function(responseText){
				if(responseText=="Success")
				{
					alert('Missionary saved.');
					dialog.close();
					Missionary.loadGrid();
				}
				else {
					alert('An error occurred');
					dialog.close();
				}
			});
		}

	}
	addMissionary.validate = function() {
		console.log('in missionary validate data');
		var valid = 0;
		$(".addMissionaryForm #errorDetails").css("display", "none");
		$(".requiredfield").each(
				function() {
					if ($(this).val() == undefined || $(this).val() == 0
							|| $(this).val() == "" || $(this).val() == null) {
						$(this).css("border-color", "red");
						valid = 1;
						$(".addMissionaryForm #errorDetails").text(
								"Please fill all mandatory fields");
						$(".addMissionaryForm #errorDetails")
								.css("display", "");
						$(".addMissionaryForm #errorDetails").css("color",
								"red");
					} else {
						$(this).css("border-color", "");
					}
				});
		if (valid == 1) {
			return false;
		} else {
			return true;
		}
	}
	addMissionary.loadValues=function(mid){
		var url="${pageContext.request.contextPath}/rest/Missionary/editMissionary";
		$.get(url,{'mid':mid},function(response){
			var resp = JSON.parse(response);
			addMissionary.id = resp["mid"];
        	$("#mtitle").val(resp["mtitle"]);
        	$("#mfname").val(resp["mfname"]);
        	$("#mlname").val(resp["mlname"]);
        	$("#marrivaldate").val(resp["marrivaldate"]);
        	$("#mdepartdate").val(resp["mdepartdate"]);
        	$("#mnationality").val(resp["mnationality"]);
		});
	}
	$(document).ready(function() {
		$(".addMissionaryForm #errorDetails").css("display", "none");

		$(".addMissionary #marrivaldate").datetimepicker({
			format: 'DD-MMM-YYYY',
			pickTime : false
		});
		$(".addMissionary #mdepartdate").datetimepicker({
			format: 'DD-MMM-YYYY',
			pickTime : false
		});
	});
</script>