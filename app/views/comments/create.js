$('#comments').html("<%= escape_javascript(render('comments/comments', :issue => @issue, :doDisplay => true )) %>");
