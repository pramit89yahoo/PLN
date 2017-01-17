<%@page import="general.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Log in</title>
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/ui/bootstrap/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/ui/dist/css/AdminLTE.min.css">
</head>
<% 	int wrongUPW = 0;
	int inValidSession=0;
	session.removeAttribute("uid");
	session.invalidate();
	try{
		wrongUPW = CommonUtil.getParamInt(request.getParameter("notfound"),0);
		inValidSession = CommonUtil.getParamInt(request.getParameter("invalid"),0);
	}
	catch(Exception e){
		e.printStackTrace();
	} 
%>
<body class="hold-transition login-page">
<div class="login-box">
  <div class="login-logo">
   <b>PLN</b>
  </div>
  <div class="login-box-body">
    <p class="login-box-msg">Sign in to start your session</p>
    <form action="${pageContext.request.contextPath}/Login" method="post">
      <div class="form-group has-feedback">
        <input type="text" class="form-control" placeholder="Username" id="uname" name="uname">
        <span class="glyphicon glyphicon-user form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="password" class="form-control" placeholder="Password" id="upwd" name="upwd">
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
      </div>
      <div class="row">
        <div class="col-xs-8">
        </div>
        <div class="col-xs-4">
          <button type="submit" class="btn btn-primary btn-block btn-flat">Sign In</button>
        </div>
      </div>
       <div class="col-sm-12 text-center" id='errorMsg' style="color: red; display: none;"></div>
      
    </form>
  </div>
</div>

<script src="${pageContext.request.contextPath}/ui/jQuery/jquery-2.2.3.min.js"></script>
<script src="${pageContext.request.contextPath}/ui/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/ui/iCheck/icheck.min.js"></script>
<script>
$(document).ready(function() {
	<%
		if(wrongUPW==1){
	%>
		$("#errorMsg").text("Invalid username or password").show(0).delay(5000).hide(0);
	<%}%>
	<%
	if(inValidSession==1){
%>
	$("#errorMsg").text("Invalid Session. Please login again.").show(0).delay(5000).hide(0);
<%}%>
});
</script>
</body>
</html>
