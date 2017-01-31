<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<div class="addConvert col-md-12 ui-front">
		<div class="box box-primary">
			<div class="box-header with-border">Select Missionary</div>
			<form class="form-horizontal">
				<div class="box-body">
					<div class="form-group">
						<label class="col-md-2 control-label">Missionary</label>
						<div class="col-md-2">
							<input id="cmissionary" type="text" class="form-control requiredfield"
								placeholder="Missionary name"></input>
						</div>
						<label class="col-md-2 control-label">Date Time</label>
						<div class="col-md-2 ">
							<input id="cdate" class="form-control requiredfield" readonly type="text" placeholder="click to select" ></input>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">Ward</label>
						<div class="col-md-2 ">
							<input id="cward" class="form-control requiredfield" type="text" placeholder="Ward" ></input>
						</div>
						<label class="col-md-2 control-label">Stake</label>
						<div class="col-md-2 ">
							<input id="cstake" class="form-control requiredfield" type="text" placeholder="Stake" ></input>
						</div>
						<label class="col-md-2 control-label">Baptism</label>
						<div class="col-md-2 ">
							<input id="cbaptism" class="form-control requiredfield" type="text" placeholder="Bapism" value="1"></input>
						</div>
					</div>
				</div>
			</form>
		</div>

		<div class="box box-info">
			<div class="box-header with-border">Add Connects</div>
			<form class="form-horizontal">
				<div class="box-body">
					<div class="form-group">
						<label class="col-md-3 ">Name</label> 
						<label class="col-md-3">Age</label>
						<label class="col-md-3 ">Gender</label>
					</div>
					
					<div class="convertdatatable">
						<div id="rowid1" class="datarow form-group">
							<div class="col-md-3">
								<input id="cname" type="text" class="form-control requiredfield"
									placeholder="Convert name"> </input>
							</div>
							<div class="col-md-3">
								<input id="cage" type="number" class="form-control requiredfield"
									placeholder="Age"> </input>
							</div>
							<div class="col-md-3">
								<select id="cgender" class="form-control requiredfield">
									<option value="">Select</option>
									<option value="male">Male</option>
									<option value="female">Female</option>
								</select>
							</div>
							<div class="col-md-1">
								<button class="btn btn-danger" type="button" onclick="addConvert.deleteRow(\'rowid1\')"><i class="fa fa-fw fa-minus"></i></button>
							</div>
						</div>
					</div>
					<div class="pull-right">
					<button class="btn btn-info" type="button" onclick="addConvert.addRow()"><i class="fa fa-fw fa-plus"></i></button>
				</div>
				</div>
			</form>
		</div>
		<div id="errorDetails"></div>
	</div>

</body>
</html>
<script>
addConvert=function(){};
addConvert.cmid;

addConvert.savedata=function(dialog){
	console.log('in save data for convert');
	if (addConvert.validate()) {
		console.log('convert verified data')
		var data = {};
		var convertArray=[];
		
		data["mid"] = addConvert.cmid != null ? addConvert.cmid.toString() : "0";
		data["cdate"] = $("#cdate").val() != null ? $("#cdate").val().toString() : "";
		data["cward"] = $("#cward").val() != null ? $("#cward").val().toString() : "";
		data["cstake"] = $("#cstake").val() != null ? $("#cstake").val().toString() : "";
		data["cbaptism"] = $("#cbaptism").val() != null ? $("#cbaptism").val().toString() : "";
		data["clastmodifiedby"]=Home.loginUser != null ? Home.loginUser : "0";
		data["clastmodifiedtime"]="NOW()";
		$(".datarow").each(function(){
			var convertDetails={};
			convertDetails["cname"]=$(this).children().children("#cname").val();
			convertDetails["cage"]=$(this).children().children("#cage").val();
			convertDetails["cgender"]=$(this).children().children("#cgender").val();
			convertArray.push(convertDetails);
		});
		
		
		var url="${pageContext.request.contextPath}/rest/Convert/saveConvert";
		$.post(url,{data:JSON.stringify(data),convertArray:JSON.stringify(convertArray)},function(responseText){
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

addConvert.validate=function(){
	console.log('in missionary validate data');
	var valid = 0;
	$(".addConvert #errorDetails").css("display", "none");
	
	$(".requiredfield").each(function(){
			if ($(this).val() == undefined || $(this).val() == 0 || $(this).val() == "" || $(this).val() == null) {
				$(this).css("border-color", "red");
				$(".addConvert #errorDetails").text("Please fill all mandatory fields");
				$(".addConvert #errorDetails").css("display", "");
				$(".addConvert #errorDetails").css("color","red");
				valid = 1;
			} else {
				$(this).css("border-color", "");
			}
		});
		
		if(addConvert.cmid==0 || addConvert.cmid==undefined)
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
addConvert.addRow=function(){
	
	var div='<div id=rowid'+addConvert.rowid+' class="datarow form-group">';
	div+='	<div class="col-md-3">';
	div+='		<input id="cname" type="text" class="form-control requiredfield"';
	div+='			placeholder="Convert name"> </input>';
	div+='	</div>';
	div+='	<div class="col-md-3">';
	div+='		<input id="cage" type="number" class="form-control requiredfield"';
	div+='			placeholder="Age"> </input>';
	div+='	</div>';
	div+='	<div class="col-md-3">';
	div+='		<select id="cgender" class="form-control requiredfield">';
	div+='			<option value="">Select</option>';
	div+='			<option value="male">Male</option>';
	div+='			<option value="female">Female</option>';
	div+='		</select>';
	div+='	</div>';
	div+='	<div class="col-md-1">';
	div+='		<button class="btn btn-danger" type="button" onclick="addConvert.deleteRow(\'rowid'+addConvert.rowid+'\')"><i class="fa fa-fw fa-minus"></i></button>';
	div+='	</div>';
	div+='	</div>';
	
	$('.convertdatatable').append(div);
	addConvert.rowid++;
}

addConvert.deleteRow=function(rowid)
{
	$('#'+rowid).remove();
}

$(document).ready(function(id){
	$(".addConvert #errorDetails").css("display", "none");
	addConvert.rowid=2;
	$("#cdate").datetimepicker({pickTime:false,format: 'DD-MMM-YYYY'});
	$("#cmissionary").autocomplete({
        source: "${pageContext.request.contextPath}/rest/Missionary/getMissionary?limit=10&m="+Math.random(),
        minLength: 2,
        select: function(event, ui) {
        	$("#cmissionary").val(ui.item.label);
        	addConvert.cmid = ui.item.id;
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