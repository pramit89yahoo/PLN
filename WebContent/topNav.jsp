<%@page import="general.CommonUtil"%>
<% 
	   	if (null == session.getAttribute("uid")) {
	        response.sendRedirect("login.jsp?invalid=1");
       		return;
	   	}
%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/ui/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/ui/dist/css/AdminLTE.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/ui/dist/css/skins/_all-skins.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/ui/css/bootstrap-dialog.css">
<link href="${pageContext.request.contextPath}/ui/bootstrap/css/bootstrap-datetimepicker.css"
	rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/ui/css/sortablecustomgrid.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/ui/jQuery/jquery-ui.css" rel="stylesheet" type="text/css" />		
	
	

<script
	src="${pageContext.request.contextPath}/ui/jQuery/jquery-2.2.3.min.js"></script>
<script
	src="${pageContext.request.contextPath}/ui/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/ui/iCheck/icheck.min.js"></script>
<script
	src="${pageContext.request.contextPath}/ui/js/bootstrap-dialog.js"></script>

<script
	src="${pageContext.request.contextPath}/ui/input-mask/jquery.inputmask.js"></script>
<script
	src="${pageContext.request.contextPath}/ui/input-mask/jquery.inputmask.extensions.js"></script>
<script
	src="${pageContext.request.contextPath}/ui/input-mask/jquery.inputmask.date.extensions.js"></script>
<script
	src="${pageContext.request.contextPath}/ui/input-mask/jquery.inputmask.phone.extensions.js"></script>
<script src="${pageContext.request.contextPath}/ui/js/jquery.form.js"></script>
<script src="${pageContext.request.contextPath}/ui/js/moment.js"
	type="text/javascript"></script>
<script
	src="${pageContext.request.contextPath}/ui/bootstrap/js/bootstrap-datetimepicker.min.js"
	type="text/javascript"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/ui/js/sortablecustomgrid.js"></script>
<script src="${pageContext.request.contextPath}/ui/jQuery/jquery-ui.min.js"	type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/ui/js/utils.js"	type="text/javascript"></script>

