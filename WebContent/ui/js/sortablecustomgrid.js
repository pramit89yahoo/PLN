SortableGridObj = function(){};
SortableGridObj.requestList = new Array();
function SortableGrid(tableName, url, params, itemsPerPage, pagerName, positionId,abortPreviousRequest,showPerPageOption,noToolTip) {
    this.tableName = tableName;
    this.itemsPerPage = itemsPerPage;
    this.showPerPageOption = showPerPageOption;
    this.count = 0;
    this.currentPage = 1;
    this.pages = 0;
    this.start = 0;
    this.pagerName = pagerName;
    this.positionId = positionId;
    this.abortPreviousRequest = abortPreviousRequest;
    this.url = url;
    this.params = params;
    this.maxRowPerPage = 200;
    this.data;
    this.resize = false;
    this.columnMaxSize = 600;
    this.requestArray = [];
    this.latreqJson = {};
    this.noToolTip = noToolTip; // added by Rohan
    this.oldRowsPerPages = itemsPerPage;
    this.orderByType = "ASC";
    this.orderby = "";
    this.showRecords = function(from, to) {
    	
    	$(".gridloading").fadeIn(150);
    	
        var tempParams = this.params;
        tempParams["gridCustomParams"] = {
        		start : from,
        		limit : to,
        	orderType : this.orderByType,
        	orderby : this.orderby
        };
        this.latreqJson = tempParams;
        
        if(this.abortPreviousRequest){
        	for(var i = 0; i < SortableGridObj.requestList.length; i++){
            	SortableGridObj.requestList[i].abort();
            }
        }
        SortableGridObj.requestList.push($.ajax({
            url: this.url,
            type: "POST",
            cache: false,
            context: this,
            data: {data : (JSON.stringify(tempParams))},
            success: this.successFun,
            dataType:'json'
        }));
    };
    this.successFun = function(returnValOfFun) {
        var valueForCount = this.createTable(returnValOfFun, this.tableName);
        this.count = valueForCount;
        this.pages = Math.ceil(this.count / this.itemsPerPage);
        this.showPageNav(this.positionId);
        this.data = returnValOfFun;
        try {
            var tempdata = JSON.stringify(returnValOfFun);
            var myCode = positionId + "('" + escape(tempdata)
                    + "');";
            var func = new Function(myCode);
            func();
            if(this.resize){
            	this.setResizable(this.tableName)
            }
        } catch (e) {
        	//alert(e)
        	console.log(e);
        }
    };
    this.setResizable = function(tableName){
    	var maxSize = this.columnMaxSize;
    	$("#"+tableName+" thead tr th").each(function(){
    		$(this).css("max-width",maxSize);
    		$( this ).resizable({
    	        grid: 2
    	    });
    	});
    };
    
    this.createTable = function(data, containerDiv) {
        var gList = data;
        count = gList.count;

        var tbl = document.createElement("table");
        tbl.style.width = '100%';
        tbl.setAttribute('cellSpacing', '0');
        tbl.setAttribute('cellPadding', '0');
        //tbl.className = "table";
        tbl.setAttribute('class', 'table table-hover table-condensed table-bordered customsortablegrid');
        tbl.id = "imagetable" + this.pagerName;

        var headers = gList.headers;
        var headersLength = headers.length;

        var tbody = document.createElement('TBODY');
        
        var thead = document.createElement('THEAD');
        
        tbody.className = "tbodyIE";
        var tr = document.createElement('tr');

        for (var k = 0; k < headersLength; k++) {
            var td = document.createElement('th');
            td.className = "thIE th" + k + " th" + headers[k].replace(/\s+/g, '');
            td.innerHTML = headers[k];
            tr.appendChild(td);
        }
        thead.appendChild(tr);
        
        tbl.appendChild(thead);
        
        var columns = gList.columns;
        var columnsLength = columns.length;

        var data = gList.data;
        var dataLength = data.length;
        if (dataLength > 0) {
            for (var i = 0; i < dataLength; i++) {
                tr = document.createElement('tr');
                var currentRecord = data[i];
                for (var k = 0; k < columnsLength; k++) {
                    var td = document.createElement('td');
                    td.className = "tdIE td"+k;
                    if (currentRecord[columns[k]] == undefined || currentRecord[columns[k]] == null || currentRecord[columns[k]] == "") {
                        td.appendChild(document.createTextNode("--"));
                    } else {
                        td.innerHTML = currentRecord[columns[k]];
                    }
                    tr.appendChild(td);
                }
                tbody.appendChild(tr);
            }
        }

        tbl.appendChild(tbody);
        $("#"+containerDiv).addClass("tableParentDiv");
        document.getElementById(containerDiv).innerHTML = "";
        document.getElementById(containerDiv).style.visibility = "visible";
        document.getElementById(containerDiv).appendChild(tbl);
        
        if(gList.sort != undefined &&  gList.sort !=null && gList.sort.length > 0){
        	var $ths = $("#imagetable" + this.pagerName+" thead tr").find('th');
        	for(var sort=0;sort<gList.sort.length;sort++){
        		if($.trim(gList.sort[sort]).length > 0){
        			var tempData = gList.sort[sort];
	        		var text = $ths.eq(sort).html();
	        		console.log(typeof tempData);
	        		if(typeof tempData == "string"){
		        		if(this.orderby == gList.sort[sort]){
		        			if(this.orderByType == "ASC"){
		        				$ths.eq(sort).html("<a onclick='"+this.pagerName+".sortGrid("+sort+");' href='javascript:;' class='textnone'>"+text+"<i class='fa fa-sort-asc'></i></a>");
		        			}else{
		        				$ths.eq(sort).html("<a onclick='"+this.pagerName+".sortGrid("+sort+");' href='javascript:;' class='textnone'>"+text+"<i class='fa fa-sort-desc'></i></a>");
		        			}
		        		}else{
		        			$ths.eq(sort).html("<a onclick='"+this.pagerName+".sortGrid("+sort+");' href='javascript:;' class='textnone'>"+text+"<i class='fa fa-unsorted'></i></a>");
		        		}
	        		}else if(typeof tempData == "object"){
	        			var tempSort = $.trim(tempData.sortby);
	        			var tempSortData = $.trim(tempData.dataType);
	        			if(this.orderby == tempSort){
		        			if(this.orderByType == "ASC"){
		        				if(tempSortData == "numeric"){
		        					$ths.eq(sort).html("<a onclick='"+this.pagerName+".sortGrid("+sort+");' href='javascript:;' class='textnone'>"+text+"<i class='fa fa-sort-numeric-asc'></i></a>");
		        				}else if(tempSortData == "string"){
		        					$ths.eq(sort).html("<a onclick='"+this.pagerName+".sortGrid("+sort+");' href='javascript:;' class='textnone'>"+text+"<i class='fa fa-sort-alpha-asc'></i></a>");
		        				}else{
		        					$ths.eq(sort).html("<a onclick='"+this.pagerName+".sortGrid("+sort+");' href='javascript:;' class='textnone'>"+text+"<i class='fa fa-sort-asc'></i></a>");	
		        				}
		        			}else{
		        				if(tempSortData == "numeric"){
		        					$ths.eq(sort).html("<a onclick='"+this.pagerName+".sortGrid("+sort+");' href='javascript:;' class='textnone'>"+text+"<i class='fa fa-sort-numeric-desc'></i></a>");
		        				}else if(tempSortData == "string"){
		        					$ths.eq(sort).html("<a onclick='"+this.pagerName+".sortGrid("+sort+");' href='javascript:;' class='textnone'>"+text+"<i class='fa fa-sort-alpha-desc'></i></a>");
		        				}else{
		        					$ths.eq(sort).html("<a onclick='"+this.pagerName+".sortGrid("+sort+");' href='javascript:;' class='textnone'>"+text+"<i class='fa fa-sort-desc'></i></a>");	
		        				}
		        			}
		        		}else{
		        			$ths.eq(sort).html("<a onclick='"+this.pagerName+".sortGrid("+sort+");' href='javascript:;' class='textnone'>"+text+"<i class='fa fa-unsorted'></i></a>");
		        		}
	        		}
        		}
        	}
        }
        $(".gridloading").fadeOut(150);
        try {
        	if(!this.noToolTip) { // change by Rohan
        		this.tooltip();
        	}
        } catch (e) {
        }
        return count;
    };
    
    this.sortGrid = function(columnId){
    	var sortBy = this.data.sort[columnId];
    	if(typeof sortBy == "object"){
    		sortBy = sortBy.sortby;
    	}
    	if(this.orderby == sortBy){
    		if(this.orderByType == "ASC"){
    			this.orderByType = "DESC";
    		}else{
    			this.orderByType = "ASC";
    		}
    	}else{
    		this.orderByType = "ASC";
    	}
    	this.orderby = sortBy;
    	this.showPage(1);
    };
    
    // changes by kewal
    this.tooltip = function() {
        $('.tdIE').each(function() {
            var $ele = $(this);
            if ((this.offsetWidth < this.scrollWidth)) {
                $ele.addClass('classToolTip');
                $ele.tooltip({container: 'body',html : true,title :$ele.text()});
            }
        });
	};
//    this.tooltip = function() {
//        $('.tdIE').each(function() {
//            var $ele = $(this);
//            if ((this.offsetWidth < this.scrollWidth)) {
//                $ele.attr('title', $ele.text());
//                $ele.attr('class', 'tdIE classToolTip');
//            }
//        });
//        $(".classToolTip").tooltip({container: 'body'});
//
//    };
    this.showPerPage = function(display){
    	if(display > this.maxRowPerPage){
    		utils.showWaitMessage("You can set Max 200 Rows per page.");
    		setTimeout(function(){
    			utils.hideWaitMessage();
    		},2000);
    		return false;
    	}
    	this.itemsPerPage = display;
    	this.currentPage = 1;
    	this.start = ((this.currentPage - 1) * this.itemsPerPage);
        this.showRecords(this.start, this.itemsPerPage);
    };
    
    this.showPage = function(pageNumber) {
        this.currentPage = pageNumber;
        this.start = ((this.currentPage - 1) * this.itemsPerPage);
        this.showRecords(this.start, this.itemsPerPage);
    };

    this.first = function() {
        if (this.currentPage > 1) {
            this.showPage(1);
        }

    };
    this.prev = function() {
        if (this.currentPage > 1)
            this.showPage(this.currentPage - 1);
    };

    this.next = function() {
        if (this.currentPage < this.pages) {
            this.showPage(this.currentPage + 1);
        }
    };
    this.last = function() {
        if (this.currentPage < this.pages) {
            this.showPage(this.pages);
        }
    };

    this.showPageNav = function(positionId) {
        var element = document.getElementById(positionId);
        var TempFrom = ((this.currentPage - 1) * this.itemsPerPage) + 1;
        var TempTo = (this.currentPage < this.pages ? (parseInt(TempFrom) + parseInt(this.itemsPerPage)) - 1 : this.count);
        var startPage = this.currentPage;
        var endPage = this.pages;
        if (this.currentPage == 1 || this.currentPage == 2 || this.currentPage == 3) {
            startPage = 1;
        } else if (this.currentPage > 0) {
            startPage = this.currentPage - 2;
        }
        if (this.currentPage == this.pages || this.currentPage == (this.pages - 1) || this.currentPage == (this.pages - 2)) {
            endPage = this.pages;
        } else if (this.pages > 0) {
            endPage = (this.currentPage + 2);
        }
        var temp = this.pagerName.replace('.', '');
        var strVar = "";
        strVar += "				<div class=\"col-sm-12\">";
        strVar += "				<div class=\"col-sm-4 pagination pull-left\">";
        strVar += "					<div>Showing " + TempFrom + " to " + TempTo + " of " + this.count + " entries<\/div>";
        strVar += "				<\/div>";
        strVar += "				<div class=\"col-sm-2 pagination pull-left\">";
        if(this.showPerPageOption){
        	strVar += "					Rows <input type='text' id=\""+this.pagerName+"_display\" class=\"form-control input-sm\" style=\"width:30%;display:inline;\"> / Page"        	
        }
        strVar += "				<\/div>";
        strVar += "				<div class=\"col-sm-6 text-right pull-right\">";
        strVar += "						<ul class=\"pagination pagination-sm\">";
        strVar += "						<li class=\"prev\" id=\"" + temp + "_first\"><a onclick=\"" + this.pagerName + ".first();\"> First<\/a><\/li>";
        strVar += "							<li class=\"prev\" id=\"" + temp + "_prev\"><a onclick=\"" + this.pagerName + ".prev();\"> Prev<\/a><\/li>";
        for (var page = startPage; page <= endPage; page++) {
            strVar += "							<li id=\"" + this.pagerName + "pg" + page + "\"><a onclick=\"" + this.pagerName + ".showPage(" + page + ");\">" + page + "<\/a><\/li>";
        }
        strVar += "							<li class=\"next\" id=\"" + temp + "_next\"><a onclick=\"" + this.pagerName + ".next();\">Next <\/a><\/li>";
        strVar += "							<li class=\"next\" id=\"" + temp + "_last\"><a onclick=\"" + this.pagerName + ".last();\">Last <\/a><\/li>";
        strVar += "						<\/ul>";
        strVar += "				<\/div>";
        strVar += "			<\/div>";
        element.innerHTML = strVar;
//        alert(this.itemsPerPage);
        if(this.showPerPageOption){
        	 $("#"+this.pagerName+"_display").val(this.itemsPerPage);
             var tempPager = this.pagerName;
             $("#"+this.pagerName+"_display").unbind("keypress");
             $("#"+this.pagerName+"_display").bind("keypress",function(e){
             	if(e.which==13){
             		var tempVal = this.value;
	               	 if(tempVal == ""){
	               		 tempVal = this.oldRowsPerPages;
	               	 }
	               	 this.value = tempVal;
            		eval(tempPager).showPerPage(tempVal);
             	}else if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                     e.preventDefault();
                     return false;
                 }
             });     
             
             $("#"+this.pagerName+"_display").off("blur");
             $("#"+this.pagerName+"_display").on("blur",function(e){
            	 var tempVal = this.value;
            	 if(tempVal == ""){
            		 tempVal =  this.oldRowsPerPages;
            	 }
            	 this.value = tempVal;
         		eval(tempPager).showPerPage(tempVal);
             });   
             
             $("#"+this.pagerName+"_display").off("focus");
             $("#"+this.pagerName+"_display").on("focus",function(e){
            	 this.oldRowsPerPages = this.value;
             });  
             
        }
        if (this.count > 0) {
            var newPageAnchor = document.getElementById(this.pagerName + 'pg' + this.currentPage);
            newPageAnchor.className = 'active';
        }
        else {
            element.innerHTML = "<center style='font-size: 12px;'>No Record(s) Found</center>";
        }
        if (this.currentPage == 1) {
            $("#" + temp + "_first").addClass("disabled");
            $("#" + temp + "_prev").addClass("disabled");
        }
        if (this.currentPage == this.pages) {
            $("#" + temp + "_next").addClass("disabled");
            $("#" + temp + "_last").addClass("disabled");

        }
    };

    this.rowsPerPagesToDisplay = function(obj){
    	var tempVal = $.trim(obj.val());
    	if(tempVal==""){
    		tempVal = this.oldRowsPerPages;
    	}
    	this.pagerName.showPerPage(tempVal);
    };
}

