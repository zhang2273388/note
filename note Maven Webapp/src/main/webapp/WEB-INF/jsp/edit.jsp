<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%><%@
taglib
	prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%><!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<title>${note.title }- Honey Note</title>
<link rel="stylesheet" href="static/css/bootstrap.min.css">
<link rel="stylesheet" href="static/css/bootstrap-switch.min.css">
<link rel="stylesheet" href="static/css/style.css">
</head>
<body>
	<form action="." id="form" method="post">
		<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
			<div class="container">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle collapsed"
						data-toggle="collapse" data-target="#navbar" aria-expanded="false"
						aria-controls="navbar">
						<span class="sr-only">Toggle navigation</span> <span
							class="icon-bar"></span> <span class="icon-bar"></span> <span
							class="icon-bar"></span>
					</button>
					<a class="navbar-brand" href=".">Honey Note <sup>Alpha</sup></a>
				</div>
				<div id="navbar" class="collapse navbar-collapse">
					<ul class="nav navbar-nav">
						<li class="active"><a href="."><span
								class="glyphicon glyphicon-edit"></span> Write</a></li>
					</ul>
					<ul class="nav navbar-nav navbar-right">
						<!-- <li class="navbar-container">
							<div class="input-group">
								<input type="text" class="form-control"
									placeholder="${note.url }" value="${note.url }"> <span
									class="input-group-btn">
									<button class="btn btn-default" type="submit">Go!</button>
								</span>
						</li> -->
						<%@ include file="includes/qr.jsp" %>
						<li class="navbar-container">
								<c:choose>
									<c:when test="${note.language eq 'markdown' }">
										<input type="checkbox" name="language" value="markdown"  data-label-text="Markdown" data-size="normal" checked="checked" autocomplete="off">
									</c:when>
									<c:otherwise>
										<input type="checkbox" name="language" value="markdown"  data-label-text="Markdown" data-size="normal" autocomplete="off">
									</c:otherwise>
								</c:choose>
						</li>
					</ul>
				</div>
				<!--/.nav-collapse -->
			</div>
		</nav>

		<div class="container">
			<textarea class="form-control" rows="20" name="content" id="content"
				autofocus="autofocus"  placeholder="Paste text or write something…">${note.content }</textarea>
			<noscript>
			<p><button type="submit" id="submit" class="btn btn-default"
				data-loading-text="正在保存……" data-complete-text="已经保存">保存</button></p></noscript>
		</div>
		<!-- /.container -->

	</form>

	<%@ include file="includes/footer.jsp"%>

	<script src="static/js/jquery-2.1.1.min.js"></script>
	<script src="static/js/bootstrap.min.js"></script>
	<script src="static/js/bootstrap-switch.min.js"></script>
	<script src="static/js/common.js"></script>
	<script>
		(function($) {
			$(function() {
				var lastForm = '';
				var lastSaveAt = 0;
				var delay = 1000; //ms
				var name = "Honey Note";
				var description = "paste and share";

				$content = $('#content');

				var timer = setTimeout(saveData, delay);

				$("#form").submit(
						function() {
							$.post("api/1.0/${note.url}", $(this)
									.serializeArray(), function(response) {
								alert(response);
							});
							return false;
						});

				$(document).ajaxStart(function() {
					$('#submit').button('loading');
				}).ajaxComplete(function() {
					$('#submit').button('complete');
					clearTimeout(timer);
					timer = setTimeout(saveData, delay);
				});

				function saveData() {
					var currentData = $('#form').serializeArray();
					var currentForm = $('#form').serialize();
					
					if (lastForm === currentForm) {
						clearTimeout(timer);
						timer = setTimeout(saveData, delay);
						return;
					}
					$.ajax({
						url : 'api/1.0/${note.url}',
						type : 'POST',
						dataType : 'json',
						data : currentData,
						success : function(json) {
							if ( json.title){
								document.title = json.title+' - '+ name;
							}else{
								document.title = name + ' - ' + description;;
							}
						},
						error : function(response) {
							alert("Saved failed, please copy your text and save it in another place now!");
						},
						complete : function() {
							lastForm = currentForm;
							lastSaveAt = (+new Date);
						}
					});
				}
			});
		})(jQuery);
	</script>
	<script type="text/javascript">
		var _gaq = _gaq || [];
		_gaq.push([ '_setAccount', 'UA-12034228-6' ]);
		_gaq.push([ '_trackPageview' ]);

		(function() {
			var ga = document.createElement('script');
			ga.type = 'text/javascript';
			ga.async = true;
			ga.src = ('https:' == document.location.protocol ? 'https://ssl'
					: 'http://www')
					+ '.google-analytics.com/ga.js';
			var s = document.getElementsByTagName('script')[0];
			s.parentNode.insertBefore(ga, s);
		})();
	</script>

	<!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
	<!--[if lt IE 9]><script src="static/assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
	<script src="static/assets/js/ie-emulation-modes-warning.js"></script>

	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!--[if lt IE 9]>
      <script src="static/assets/js//html5shiv.js"></script>
      <script src="static/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</body>
</html>
