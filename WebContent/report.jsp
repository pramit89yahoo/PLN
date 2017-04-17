<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
</head>
<body>
	<div class="viewReport col-md-12" style="overflow:auto">
		<form class="form-horizontal" id="viewReport">
			<div class="box-body">
				<div class="form-group">
					<label class="col-md-1 control-label">Date</label>
					<div class="col-md-2">
						<input id="rstartdate" type="text" class="form-control requiredfield" placeholder="Start Date"> </input>
					</div>
					<div class="col-md-2">
						<input id="renddate" type="text" class="form-control requiredfield" placeholder="End Date"> </input>
					</div>
					<div class="col-md-2">
						<select id="rtitle" class="form-control ">
							<option value="">Select Title</option>
							<option value="Elder">Elder</option>
							<option value="Sister">Sister</option>
						</select>
					</div>
					<div class="col-md-2">
						<select id="rnationality" class="form-control ">
							<option value="">Select Nationality</option>
							<option value="American">American</option>
							<option value="Latino">Latino</option>
						</select>
					</div>
					<div class="col-md-2">
						<button type="button" onclick="reportView.loadReport()" class="btn btn-primary pull-right" style="margin-right: 5px;">
			            	<i class="fa fa-search"></i> Lookup
			          	</button>
			        </div>
				</div>
				<div class="form-group">
						<label class="col-md-1 control-label">Missionary</label>
							<div class="col-md-2">
								<input id="rmissionary" type="text" class="form-control "
									placeholder="Missionary name"></input>
							</div>
						<label class="col-md-1 control-label">Ward</label>
							<div class="col-md-2 ">
								<input id="rward" class="form-control " type="text" placeholder="Ward" ></input>
							</div>
						<label class="col-md-1 control-label">Stake</label>
							<div class="col-md-2 ">
								<input id="rstake" class="form-control " type="text" placeholder="Stake" ></input>
							</div>
							<div class="col-md-3">
							<label class="radio-inline">
								<input type="radio" name ="viewType" checked value="graph"> Graph
							</label>
							<label class="radio-inline">
								<input type="radio" name ="viewType" value="data"> Data
							</label>
							</div>
							
				</div>
				<div class="form-group">
					<div class="col-md-12" id=errorDetails>
					</div>
				</div>
				<div id="graphView">
					<div class="form-group">
						<div class="col-md-4" id="pieMissionary" onclick="reportView.showData('Missionary','Missionary');">
						</div>
				 		<div class="col-md-8" id="monthViseColumn" onclick="reportView.showData('month','Month');">
						</div>
					</div>
					<div class="form-group">
				 		<div class="col-md-3" id="pieTitle" onclick="reportView.showData('title','Title');">
						</div>
						<div class="col-md-3" id="pieWard" onclick="reportView.showData('cward','Ward');">
						</div>
						<div class="col-md-3" id="pieStake" onclick="reportView.showData('rstake','Stake');">
						</div>
						<div class="col-md-3" id="pieNationality" onclick="reportView.showData('mnationality','Nationality');">
						</div>
					</div>
				</div>
				<div id="dataView">
					<div class="col-sm-12 paddingTop" id='reportGridDiv'> </div>
            		<div class="col-sm-12" id='reportGridPaginationDiv'> </div>
				</div>
			</div>
		</form>
	</div>
	
</body>
</html>
<script>
reportView=function(){};
reportView.yAxis = [];
reportView.xAxis = [];
reportView.pieData=[];


reportView.loadReport=function(){
	reportView.yAxis = [];
	reportView.xAxis = [];
	reportView.pieData=[];
	reportView.DataResp={};
	if(reportView.validate())
	{
		if($("input[name=viewType]:checked").val()=='graph')
		{
			$('#dataView').css('display','none');
			$('#graphView').css('display','');
			var data = {};
			data["rstartdate"] = $("#rstartdate").val() != null ? $("#rstartdate").val().toString() : "";
			data["renddate"] = $("#renddate").val() != null ? $("#renddate").val().toString() : "";
			data["rtitle"] = $("#rtitle").val() != null ? $("#rtitle").val().toString() : "";
			data["rnationality"] = $("#rnationality").val() != null ? $("#rnationality").val().toString() : "";
			data["rmissionary"] = ($("#rmissionary").val() != "" && reportView.cmid != null) ? reportView.cmid.toString() : "0";
			data["rward"] = $("#rward").val() != null ? $("#rward").val().toString() : "";
			data["rstake"] = $("#rstake").val() != null ? $("#rstake").val().toString() : "";
			
			var url="${pageContext.request.contextPath}/rest/Convert/getMonthlyConverts";
			$.post(url,{data:JSON.stringify(data)},function(responseText){
				var resp = JSON.parse(responseText);
				reportView.DataResp.month=responseText;
				for(var i=0;i<resp.length;i++)
				{
					reportView.xAxis.push(resp[i].entity);
					reportView.yAxis.push(parseInt(resp[i].cnt));
				}
				reportView.loadColumnChart('Monthly Converts');
			});
			
			var reqdata = {};
			reqdata["rstartdate"] = $("#rstartdate").val() != null ? $("#rstartdate").val().toString() : "";
			reqdata["renddate"] = $("#renddate").val() != null ? $("#renddate").val().toString() : "";
			reqdata["rtitle"] = $("#rtitle").val() != null ? $("#rtitle").val().toString() : "";
			reqdata["rnationality"] = $("#rnationality").val() != null ? $("#rnationality").val().toString() : "";
			reqdata["rmissionary"] = ($("#rmissionary").val() != "" && reportView.cmid != null) ? reportView.cmid.toString() : "0";
			reqdata["rward"] = $("#rward").val() != null ? $("#rward").val().toString() : "";
			reqdata["rstake"] = $("#rstake").val() != null ? $("#rstake").val().toString() : "";
			var url="${pageContext.request.contextPath}/rest/Convert/getConvertsByGroups";
			var reqJson = {
		            data:JSON.stringify(reqdata)
		    };
			$.ajax ({
			    url: url,
			    cache: false,
			    type: "POST",
			    data: reqJson,
			    dataType: "json",
			    success: function(respText){
			    	reportView.DataResp.pie=respText;
			    	var resp = JSON.parse(respText.Missionary);
			    	reportView.getPieData(resp);
			    	reportView.loadPieChart('By Missionary',reportView.pieData,'#pieMissionary','Missionary');
			    	
			    	resp = JSON.parse(respText.cward);
			    	reportView.getPieData(resp);
			    	reportView.loadPieChart('By Ward',reportView.pieData,'#pieWard','Ward');
			    	
			    	resp = JSON.parse(respText.title);
			    	reportView.getPieData(resp);
			    	reportView.loadPieChart('By Title',reportView.pieData,'#pieTitle','Title');
			    	
			    	resp = JSON.parse(respText.mnationality);
			    	reportView.getPieData(resp);
			    	reportView.loadPieChart('By Nationality',reportView.pieData,'#pieNationality','Nationality');
			    	
			    	resp = JSON.parse(respText.rstake);
			    	reportView.getPieData(resp);
			    	reportView.loadPieChart('By Stake',reportView.pieData,'#pieStake','Stake');
			    }
			});
			
		}
		else{
			$('#graphView').css('display','none');
			$('#dataView').css('display','');
			reportView.loadGrid();
		}
	}
	}
reportView.getPieData=function(resp){

	reportView.pieData=[];
	for(var i=0;i<resp.length;i++)
	{
		var temp=[];
		temp.push(resp[i].entity);
		temp.push(parseInt(resp[i].cnt));
		reportView.pieData.push(temp);
	}
}

reportView.loadColumnChart=function(title){
	$('#monthViseColumn').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'column'
        },
        title: {
            text: title
        },
        tooltip: {
        	
        },
        xAxis: {
            categories: reportView.xAxis,
            crosshair: true
        },
        yAxis: {
            min: 0,
            title: {
                text: 'No of converts'
            }
        },
        series: [{
            name: 'Month',
            data: reportView.yAxis
        }],
    });
}
reportView.loadPieChart=function(title,data,container,name){
	$(container).highcharts({
        chart: {
        	plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie'
        },
        title: {
            text: title
        },
        tooltip: {
        	pointFormat: '{series.name}: <b>{point.percentage:.1f}% ({point.y})</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                depth: 35,
                dataLabels: {
                    enabled: true,
                    format: '{point.name}'
                }
            }
        },
        series: [{
        	type: 'pie',
            name: name,
            data: data
        }]
    });
};
reportView.validate=function(){
	$(".viewReport #errorDetails").css("display","none");
	var valid = 0;
	$(".requiredfield").each(
			function() {
				if ($(this).val() == undefined || $(this).val() == 0 || $(this).val() == "" || $(this).val() == null) {
					$(this).css("border-color", "red");
					valid = 1;
					$(".viewReport #errorDetails").text("Please fill all mandatory fields");
					$(".viewReport #errorDetails").css("display","");
					$(".viewReport #errorDetails").css("color","red");
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

reportView.loadGrid=function(){
	var reqdata = {};
	reqdata["rstartdate"] = $("#rstartdate").val() != null ? $("#rstartdate").val().toString() : "";
	reqdata["renddate"] = $("#renddate").val() != null ? $("#renddate").val().toString() : "";
	reqdata["rtitle"] = $("#rtitle").val() != null ? $("#rtitle").val().toString() : "";
	reqdata["rnationality"] = $("#rnationality").val() != null ? $("#rnationality").val().toString() : "";
	reqdata["rmissionary"] = ($("#rmissionary").val() != "" && reportView.cmid != null) ? reportView.cmid.toString() : "0";
	reqdata["rward"] = $("#rward").val() != null ? $("#rward").val().toString() : "";
	reqdata["rstake"] = $("#rstake").val() != null ? $("#rstake").val().toString() : "";
	var url = "${pageContext.request.contextPath}/rest/Convert/getDataReportConverts?m="+Math.random();
	pagersss = new SortableGrid('reportGridDiv', url, reqdata, 1000,'pagersss','reportGridPaginationDiv',true);
	pagersss.showPage(1);
}
reportGridPaginationDiv = function(data){
	$('.viewReport thead .th0').css("width","5%");
	$('.viewReport tr').each(function(){
		$(this).dblclick(function(){
			var id=$(this).children('.td0').text();
			Convert.editConvert(id);
		});
	});
};

reportView.showData=function(optionvalue,optionname){
	
	if(optionname=="Month")
	{
		var tempobj=JSON.parse(reportView.DataResp.month);
	}
	else{
		var tempobj=JSON.parse(reportView.DataResp.pie[optionvalue]);
	}
	var chartDetailsData='<table class="table table-striped">';
		chartDetailsData+='<th>'+optionname+'</th>';
		//chartDetailsData+='<th>Average</th>';
		chartDetailsData+='<th>Count</th>';
		for(var i=0;i<tempobj.length;i++)
	    {
			chartDetailsData +="<tr>";
			chartDetailsData +="<td>"+tempobj[i]["entity"]+"</td>";
			//chartDetailsData +="<td>avg</td>";
			chartDetailsData +="<td>"+tempobj[i]["cnt"]+"</td></tr>";
	    } 
		chartDetailsData+='</table>';
		
	BootstrapDialog.show({
		autodestroy: true,
		closeByBackdrop: false,
        closeByKeyboard: false,
		size: BootstrapDialog.SIZE_MEDIUM, 
		cssClass: 'reportdata',
		message: $('<div></div>').html(chartDetailsData),
		title: "<b style='font-size: 14px;'>Detail data</b>",
		draggable : true,
		closable : true,
		onshown : function(){
      		
      	},
      draggable : true,
      buttons: [
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

$(document).ready(function() {
	$(".viewReport #errorDetails").css("display","none");
	$(".viewReport #rstartdate").datetimepicker({
		format: 'MM/DD/YYYY',
		pickTime : false
	});
	$(".viewReport #renddate").datetimepicker({
		format: 'MM/DD/YYYY',
		pickTime : false
	});
	$("#rmissionary").autocomplete({
        source: "${pageContext.request.contextPath}/rest/Missionary/getMissionary?limit=10&m="+Math.random(),
        minLength: 2,
        select: function(event, ui) {
        	$("#rmissionary").val(ui.item.label);
        	reportView.cmid = ui.item.id;
        }
    });
	$("#rward").autocomplete({
        source: "${pageContext.request.contextPath}/rest/Convert/getWard?limit=10&m="+Math.random(),
        minLength: 1,
        select: function(event, ui) {
        	$("#rward").val(ui.item.label);
        }
    });
	$("#rstake").autocomplete({
        source: "${pageContext.request.contextPath}/rest/Convert/getStake?limit=10&m="+Math.random(),
        minLength: 1,
        select: function(event, ui) {
        	$("#rstake").val(ui.item.label);
        }
    });
	
	try{
		Highcharts
	}catch(e){
		$.getScript("${pageContext.request.contextPath}/ui/highchart/js/highcharts.js", function(){});
	}
});


</script>