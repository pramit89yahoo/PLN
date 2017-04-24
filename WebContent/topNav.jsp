<%@page import="general.CommonUtil"%>
<% 
	   	if (null == session.getAttribute("uid")) {
	        response.sendRedirect("login.jsp?invalid=1");
       		return;
	   	}
%>
<link href="${pageContext.request.contextPath}/ui/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/ui/dist/css/AdminLTE.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/ui/dist/css/skins/_all-skins.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/ui/css/bootstrap-dialog.css"  rel="stylesheet">
<link href="${pageContext.request.contextPath}/ui/bootstrap/css/bootstrap-datetimepicker.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/ui/css/sortablecustomgrid.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/ui/jQuery/jquery-ui.css" rel="stylesheet" type="text/css" />		
<link href="${pageContext.request.contextPath}/ui/css/token-input-facebook.css"	rel='stylesheet' />	
<link href="${pageContext.request.contextPath}/ui/css/bootstrap-multiselect.css" rel='stylesheet' />

<script	src="${pageContext.request.contextPath}/ui/jQuery/jquery-2.2.3.min.js"></script>
<script	src="${pageContext.request.contextPath}/ui/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/ui/iCheck/icheck.min.js"></script>
<script	src="${pageContext.request.contextPath}/ui/js/bootstrap-dialog.js"></script>
<script	src="${pageContext.request.contextPath}/ui/input-mask/jquery.inputmask.js"></script>
<script	src="${pageContext.request.contextPath}/ui/input-mask/jquery.inputmask.extensions.js"></script>
<script	src="${pageContext.request.contextPath}/ui/input-mask/jquery.inputmask.date.extensions.js"></script>
<script	src="${pageContext.request.contextPath}/ui/input-mask/jquery.inputmask.phone.extensions.js"></script>
<script src="${pageContext.request.contextPath}/ui/js/jquery.form.js"></script>
<script src="${pageContext.request.contextPath}/ui/js/moment.js" type="text/javascript"></script>
<script	src="${pageContext.request.contextPath}/ui/bootstrap/js/bootstrap-datetimepicker.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/ui/js/sortablecustomgrid.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/ui/jQuery/jquery-ui.min.js"	type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/ui/js/utils.js"	type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/ui/js/jquery.tokeninput.js" type="text/javascript"></script>
<script	src="${pageContext.request.contextPath}/ui/js/bootstrap-multiselect.js"	type="text/javascript"></script>	
