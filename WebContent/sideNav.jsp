<!DOCTYPE html>

<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>Home</title>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

</head>
<body class="skin-blue fixed wysihtml5-supported">
	<div class="wrapper">
		<div class="main-header">
			<a href="${pageContext.request.contextPath}/home.jsp" class="logo">
				PLN </a>

			<nav class="navbar navbar-static-top">
				<div class="navbar-custom-menu">
					<ul class="nav navbar-nav">
						<li class="dropdown messages-menu"><a
							href="${pageContext.request.contextPath}/login.jsp"> Logout <i class="fa fa-user"></i>
						</a></li>
					</ul>
				</div>
			</nav>
		</div>

		<div class="main-sidebar">
			<div class="sidebar">

				<ul class="sidebar-menu" id="mainSidebar">
					<li class="header">NAVIGATION</li>

					<li><a id="missionary"
						onclick="Home.loadPage('${pageContext.request.contextPath}/missionary.jsp');">
							<i class="fa fa-th"></i> <span>Missionary</span>
					</a></li>
					<li class="active"><a id="convert"
						onclick="Home.loadPage('${pageContext.request.contextPath}/convert.jsp');">
							<i class="fa fa-th"></i> <span>Convert</span>
					</a></li>
					<li><a id="report"
						onclick="Home.loadPage('${pageContext.request.contextPath}/report.jsp');">
							<i class="fa fa-dashboard "></i> <span>Reports</span>
					</a></li>
					<li><a id="admin"
						onclick="Home.loadPage('${pageContext.request.contextPath}/user.jsp');">
							<i class="fa fa-users"></i> <span>Admin</span>
					</a></li>
				</ul>
			</div>
		</div>
		<div class="content-wrapper" id="container" style="min-height:1050px"></div>
	</div>
	 <footer class="main-footer">
  	</footer>
</body>