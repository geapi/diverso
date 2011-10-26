// <form data-remote-content=true data-remote=true>
TestApp.RemoteContent = {

  updateContent : function(newContent) {

    var $contentKeyElements = $(newContent).filter('[data-content-key]');
    $contentKeyElements.each(function() {
      var $newElement = $(this);
      var contentKey = $newElement.attr("data-content-key");
      $("[data-content-key=" + contentKey + "]").
        html($newElement.html()).
        trigger("TestApp:ready").
        trigger("content-updated");
    });
  }


};
$("form[data-remote-content=true], a[data-remote-content=true]").live("ajax:success", function(e, data, status, xhr) {
  TestApp.RemoteContent.updateContent(data);
  TestApp.positionAndScheduleCloseForNotificationBox();
  TestApp.removingLoadingClassFromButtons();
});

$("form[data-remote-content=true], a[data-remote-content=true]").live("ajax:beforeSend", function(e, data, status, xhr) {
  TestApp.setLoadingIconOnFormButton($(e.target));
});

$("form[data-remote-content=true], a[data-remote-content=true]").live("ajax:error", function(e, xhr, status, error) {
  if (xhr.status == 401) {
    TestApp.SessionManager.signOut();
  }
});