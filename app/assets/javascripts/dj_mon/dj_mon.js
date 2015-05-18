window.bindModals = function() {
  $('a[data-toggle=modal]').on('click', function() {
    var template = $($(this).attr('href')).html();
    var output = Mustache.render(template, { content: $(this).data('content') });
    $(output).appendTo($('body'));

    $('.modal').on('hidden.bs.modal', function(e) {
      $(this).remove();
    });
  });
};

window.bindRemote = function() {
  $('a[data-remote]').on('click', function(e) {
    e.preventDefault();
    var el = $(this),
        method = el.data('method').toUpperCase();

    if (method === 'DELETE') {
      el.closest('tr').fadeOut();
    }

    $.ajax({
      url: el.attr('href'),
      method: method
    })
  });
}

$(document).ready(function() {
  $('a[data-toggle="tab"]').bind('shown.bs.tab', function(e) {
    var currentTab = e.target;
    var tabContent = $($(currentTab).attr('href'));
    var dataUrl = tabContent.data('url');

    $.getJSON(dataUrl).success(function(data){
      var template = $('#dj_reports_template').html();

      if(data.length > 0) {
        var output = Mustache.render(template, data);
      } else {
        var output = "<div class='alert alert-warning'>No Jobs</div>";
      }

      tabContent.html(output);
      bindModals();
      bindRemote();
    });
  });

  $('.nav.nav-tabs li.active a[data-toggle="tab"]').trigger('shown.bs.tab');

  (function refreshCount() {
    $.getJSON(dj_counts_dj_reports_path).success(function(data){
      var template = $('#dj_counts_template').html();
      var output = Mustache.render(template, data);
      $('#dj-counts-view').html(output);
      setTimeout(refreshCount, 5000);
    });
  })();
});
