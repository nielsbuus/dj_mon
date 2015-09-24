window.populateTab = function(tab, data) {
  var per_page = tab.data('per-page');
  var template = $('#dj_reports_template').html();

  data.pages = []
  for(var i = 0; i < Math.ceil(data.count / per_page); i++) {
    data.pages.push(i+1);
  }
  console.log(data);
  if(data.items.length > 0) {
    var output = Mustache.render(template, data);
  } else {
    var output = "<div class='alert alert-warning'>No Jobs</div>";
  }

  tab.html(output);
  bindModals();
  bindRemote();
  bindPagination();
};

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
};

window.bindPagination = function() {
  $('.pagination a').on('click', function(e) {
    var page = $(e.target).data('page');
    var activeTab = $('.nav-tabs .active a');
    var tabContent = $($(activeTab).attr('href'));
    tabContent.data('page', page);

    var dataUrl = tabContent.data('url') + "?page=" + page;

    $.getJSON(dataUrl).success(function(data) {
      populateTab(tabContent, data);

    }).done(function() {
      $('.pagination a').parent().removeClass('active')
      $('.pagination a[data-page="' + page + '"]').parent().addClass('active');
    });
  });

  $('.pagination a[data-page="1"]').parent().addClass('active');
};

$(document).ready(function() {
  $('a[data-toggle="tab"]').bind('shown.bs.tab', function(e) {
    var currentTab = e.target;
    var tabContent = $($(currentTab).attr('href'));
    var dataUrl = tabContent.data('url') + "?page=" + tabContent.data('page');

    $.getJSON(dataUrl).success(function(data) {
      populateTab(tabContent, data);
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
