<%@page import="general.CommonUtil"%>
<% 
	   	if (null == session.getAttribute("uid")) {
	        response.sendRedirect("login.jsp?invalid=1");
       		return;
	   	}
%>
	
		<jsp:include page="/topNav.jsp"></jsp:include>
		<jsp:include page="/sideNav.jsp"></jsp:include>


<script>
	Home = function() {
	};
	Home.loginUser=<%=session.getAttribute("uid")%>;
	
	$(document).ready(function(){
		Home.loadPage('${pageContext.request.contextPath}/convert.jsp');
	});
	Home.loadPage = function(url, data) {
		Home.UnBindWindowScrollEvent();
		$.post(url, {}, function(resp) {
			$("#container").empty().append(resp);
		});
	}
	//to set active for the selected li
	$("#mainSidebar ").children('li').click(function () {
		var d=$(this);
		d.parent('ul').children('li').removeClass('active');
		$(this).addClass('active');
     });
	
	Home.UnBindWindowScrollEvent = function ()
    {
        $(window).unbind('scroll');
    }
	$( "#content").bind( "click", function() {
		  alert( $( this ).text() );
		});
</script>