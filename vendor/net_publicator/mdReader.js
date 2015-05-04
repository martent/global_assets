/* Modified material from Net Publicator.
   Displays a file browser with Platina documents.
*/
function runmd() {
  masterMD.overlay = $('#myoverlay').mdReaderO();
  masterMD.breadCrumb = $('#breadCrumb').mdReaderB({
    'itemClick': function(clickedData) {
      masterMD.breadCrumb.mdvDisable();
      masterMD.table.mdvLock();
      var to = 0;
      for (var n = 0; n < masterMD.history.length; n++) {
        if (masterMD.history[n] == clickedData.id) {
          n = n + 1;
          var rest = masterMD.history.slice((to || masterMD.history.length) + 1 || masterMD.history.length);
          masterMD.history.length = n < 0 ? masterMD.history.length + n : n;
          masterMD.history.push.apply(masterMD.history, rest);
          break;
        }
      }
      setHash(buildHash());
    }
  });

  masterMD.table = $('#tableList').mdReaderT({
    'Footer': false,
    'Header': false,
    'Checking': false,
    'Sortnumber': false,
    'Sorting': false,
    'ClickedBackwards': function(dataObject) {
      masterMD.breadCrumb.mdvDisable();
      masterMD.table.mdvLock();
      var to = 0;
      var n = masterMD.history.length - 1;
      var rest = masterMD.history.slice((to || masterMD.history.length) + 1 || masterMD.history.length);
      masterMD.history.length = n < 0 ? masterMD.history.length + n : n;
      masterMD.history.push.apply(masterMD.history, rest);
      setHash(buildHash());

    },
    'ClickedRow': function(dataObject) {
      if (dataObject.type != "document") {
        masterMD.breadCrumb.mdvDisable();
        masterMD.table.mdvLock();
        addCompleteHistory(dataObject);
        masterMD.history.push(dataObject.id);
        setHash(buildHash());
      } else {
        window.open('https://docs.netpublicator.com/api/public/' + masterMD.readerName + '/document/' + dataObject.id + '?hash=' + buildHash() + '&cache=' + new Date());
      }
    }
  });

  // Open the first table
  if (window.location.hash != '') {
    var hash = window.location.hash.replace('#', '');
    var reader = 'false';
    if (hash.split('-').length <= 1) {
      reader = 'true';
    }
    if (reader == 'true') {
      masterMD.history.push(masterMD.rootID);
      addCompleteHistory({
        'id': masterMD.rootID,
        'text': 'Dokument',
        'type': 'root',
        'index': 0,
        'data': {}
      });
      openTable(masterMD.rootID, masterMD.rootID);
    } else {
      $.getJSON('https://docs.netpublicator.com/api/public/' + masterMD.readerName + '?jsoncallback=?', {
        'hash': hash,
        'isr': reader
      }, function(data) {
        if (data.length > 0) {
          masterMD.history.push(masterMD.rootID);
          addCompleteHistory({
            'id': masterMD.rootID,
            'text': 'Dokument',
            'type': 'root',
            'index': 0,
            'data': {}
          });
          var hashSplit = hash.split('-');
          for (var t = 0; t < hashSplit.length; t++) {
            for (var n = 0; n < data.length; n++) {
              var item = data[n];
              if (hashSplit[t] == item.id) {
                masterMD.history.push(item.id);
                addCompleteHistory(item);
              }
            }
          }
          openTable(masterMD.history[masterMD.history.length - 1], hash);
        } else {
          masterMD.history.push(masterMD.rootID);
          addCompleteHistory({
            'id': masterMD.rootID,
            'text': 'Dokument',
            'type': 'root',
            'index': 0,
            'data': {}
          });
          window.location.hash = '';
        }
      }).error(function(jqXHR, textStatus, errorThrown) {
        masterMD.history.push(masterMD.rootID);
        addCompleteHistory({
          'id': masterMD.rootID,
          'text': 'Dokument',
          'type': 'root',
          'index': 0,
          'data': {}
        });
        window.location.hash = '';
      });
    }
  } else {
    masterMD.history.push(masterMD.rootID);
    addCompleteHistory({
      'id': masterMD.rootID,
      'text': 'Dokument',
      'type': 'root',
      'index': 0,
      'data': {}
    });
    openTable(masterMD.rootID, masterMD.rootID);
  }

  $(window).bind('hashchange', function() {
    hashChanged(this.location.hash.replace('#', ''));
  });
}

function openTable(useData, hash) {
  masterMD.overlay.mdvDisplay(100, 'Laddar data', function() {});
  var reader = "false";
  if (hash.split('-').length <= 1) {
    reader = "true";
  }
  $.getJSON('https://docs.netpublicator.com/api/public/' + masterMD.readerName + '/channel/' + useData + '?jsoncallback=?', {
    'hash': hash,
    'isr': reader
  }, function(data) {
    var hist = getHistory(hash);
    if (hist.length > 0) {
      masterMD.table.mdvOpenPage({
        "_items": data,
        "parent": hist[hist.length - 2]
      });
    } else {
      masterMD.table.mdvOpenPage({
        "_items": data
      });
    }
    // Build breadcrumb
    masterMD.breadCrumb.mdvFill(hist);
    masterMD.breadCrumb.mdvEnable();
    masterMD.table.mdvUnlock();
    masterMD.overlay.mdvHide(100, function() {});
  }).error(function(jqXHR, textStatus, errorThrown) {
    masterMD.overlay.mdvHide(100, function() {
      LoadError();
    });
  });
}

function buildHash() {
  var hash = '';
  for (var n = 0; n < masterMD.history.length; n++) {
    if (n > 0) {
      hash += '-';
    }
    hash += masterMD.history[n];
  }
  return hash;
}

function setHash(hash) {
  window.location.hash = hash;
  // $.browser not supported in jQuery
  // if ($.browser.msie && $.browser.version == "7.0" || $.browser.msie && $.browser.version == "6.0") {
  //     hashChanged(hash);
  // }
}

function hashChanged(hash) {
  if (hash == '') {
    hash = masterMD.rootID;
  }
  var parts = hash.split("-");
  var currentPage = parts[parts.length - 1];
  masterMD.history = parts;
  openTable(currentPage, hash);
}

function addCompleteHistory(addItem) {
  var itemExists = false;
  for (var n = 0; n < masterMD.completeHistory.length; n++) {
    var item = masterMD.completeHistory[n];
    if (item.id == addItem.id) {
      itemExists = true;
    }
  }
  if (!itemExists) {
    masterMD.completeHistory.push(addItem);
  }
}

function getHistory(hash) {
  var hashItems = hash.split("-");
  var returnObj = [];
  for (var t = 0; t < hashItems.length; t++) {
    var hashItem = hashItems[t];
    for (var n = 0; n < masterMD.completeHistory.length; n++) {
      var item = masterMD.completeHistory[n];
      if (item.id == hashItem) {
        returnObj.push(item);
      }
    }
  }
  return returnObj;
}

function LoadError() {
  $("#jsPage").hide();
  $("#jsError").show();
}






//MD javascript plugins for jquery (C) 2012 https://docs.netpublicator.com

(function($) {
  $.fn.mdReaderB = function(options) {
    // support mutltiple elements
    if (this.length > 1) {
      this.each(function() {
        $(this).mdReaderB(options)
      });
      return this;
    }

    // private variables
    var visible = false;
    var thisID = "";
    var isDisabled = false;
    var settings = {
      'itemClick': function(clickedData) {}
    }

    // public methods
    this.init = function() {
      // If there is options, append them with our settings
      if (options) {
        $.extend(settings, options);
      }

      // Set the id of this table
      thisID = $(this).attr("id");

      $(this).toggleClass('rbDiv', true);
      return this;
    };

    this.mdvFill = function(items) {
      $('#' + thisID).empty();
      var liBreadCrumb = '';
      for (var i = 0; i < items.length; i++) {
        var myItem = items[i];
        if ((i + 1) == items.length) {
          liBreadCrumb += '<div>' + myItem.text + '</div>';
        } else {
          liBreadCrumb += '<div class="rbDivArrow"><a href=\"#' + myItem.id + '\">' + myItem.text + '</a></div>';
        }
      }
      $(this).append(liBreadCrumb);

      $('#' + thisID + ' div a').click(function(e) {
        e.preventDefault();
        if (!isDisabled) {
          settings.itemClick({
            id: $(this).attr("href").split('#')[1],
            text: $(this).text()
          });
        }
      });
      return this;
    };

    this.mdvEmpty = function() {
      $('#' + thisID).empty();
      return this;
    };
    this.mdvShow = function() {
      // Show the menu
      this.show();
      visible = true;
      return this;
    };
    this.mdvHide = function() {
      // Hide the menu
      this.hide();
      visible = false;
      return this;
    };
    this.mdvDisable = function() {
      isDisabled = true;
      return this;
    };
    this.mdvEnable = function() {
      isDisabled = false;
      return this;
    };
    return this.init();
  }
})(jQuery);


(function($) {
  $.fn.mdReaderT = function(options) {
    // support mutltiple elements
    if (this.length > 1) {
      this.each(function() {
        $(this).mdReaderT(options)
      });
      return this;
    }

    //::::::::::::::::
    // private variables
    //::::::::::::::::
    var currentItems = [];
    var previousParent = {
      'id': '',
      'text': '',
      'type': '',
      'index': '',
      'data': ''
    };
    var thisID = '';
    var locked = false;
    var settings = {
      'ClickedRow': function(dataObject) {},
      'ClickedBackwards': function(dataObject) {},
      'Header': true
    }

    //::::::::::::::::
    // PRIVATE METHODS
    //::::::::::::::::
    function getItem(itemID) {
      for (var n = 0; n < currentItems.length; n++) {
        if (itemID.replace(thisID + '_', '') == currentItems[n].id) {
          return currentItems[n];
        }
      }
    }

    function bindBehavior() {
      // Handle item hover effects
      $('#' + thisID + '_rdivBody .rdivItem').unbind();
      $('#' + thisID + '_rdivBody .rdivItem').hover(function(e) {
        if (!locked) {
          $(this).toggleClass("rdivItemHover", true);
          currentRowHover = $(this).attr('id');
        }
      }, function(e) {
        if (!locked) {
          $(this).toggleClass("rdivItemHover", false);
          currentRowHover = 0;
        }
      });

      // Handle body clicks
      $('#' + thisID + '_rdivBody .rdivItem').click(function(e) {
        if (!locked) {
          e.preventDefault();
          settings.ClickedRow(getItem($(this).attr("id")));
        }
      });
    }

    //::::::::::::::::
    // public methods
    //::::::::::::::::

    this.init = function() {
      // If there is options, append them with our settings
      if (options) {
        $.extend(settings, options);
      }

      // Set the id of this table
      thisID = $(this).attr("id");
      //            $(this).toggleClass("mdScrollMenu", true);

      var printer = '';

      // Start printing out the table
      printer += '<div id="' + thisID + '_rdiv" class="rdiv">';

      // Header
      printer += '<div id="' + thisID + '_rdivHeader" class="rdivHeader"></div>';

      // Body
      printer += '<div id="' + thisID + '_rdivBody" class="rdivBody"></div>';

      // Close up
      printer += '</div>';

      // Append the printer to the element which the menu is bound to
      this.append(printer);

      return this;
    };


    this.mdvOpenPage = function(pageOpenOpt) {
      var pageSettings = {
        "_items": [],
        "parent": {
          'id': '',
          'text': '',
          'type': '',
          'index': '',
          'data': ''
        },
        "html": ''
      }
      if (pageOpenOpt) {
        $.extend(pageSettings, pageOpenOpt);
      }
      // Clean up previous calls
      $('#' + thisID + '_rdivBody').empty();
      if (previousParent.id != '') {
        $('#' + thisID + '_p_' + previousParent.id).remove();
      }

      // Print the parent if he exists
      if (pageSettings.parent.id != '') {
        previousParent = pageSettings.parent;
        var liParent = '';
        if (previousParent.id != '') {
          var AddItem = previousParent.text;
          liParent += '<div class="rdivItemParent rdivItemIcon_Backwards" id = ' + thisID + '_p_' + previousParent.id + '>' + AddItem + '</div>';
        }
        $('#' + thisID + '_rdivBody').append(liParent);

        // Handle parent hover effects
        $('#' + thisID + '_p_' + previousParent.id).hover(function() {
          if (!locked) {
            $(this).toggleClass("rdivItemParentHover", true);
          }
        }, function() {
          if (!locked) {
            $(this).toggleClass("rdivItemParentHover", false);
          }
        });

        // Handle parent click
        $('#' + thisID + '_p_' + previousParent.id).click(function(e) {
          e.preventDefault();
          if (!locked) {
            settings.ClickedBackwards(previousParent);
          }
        });
      }

      // Print the items
      currentItems = pageSettings._items;
      var printer = '';
      if (pageSettings.html != '') {

      } else {
        for (var n = 0; n < currentItems.length; n++) {
          var item = currentItems[n];
          var itemImageClass = "";
          if (item.type == "document") {
            itemImageClass = "rdivItemIcon_Document";
          } else if (item.type == "meeting") {
            itemImageClass = "rdivItemIcon_Meeting";
          } else if (item.type == "channel") {
            itemImageClass = "rdivItemIcon_Channel";
          }
          printer += '<div class="rdivItem ' + itemImageClass + '" id = ' + thisID + '_' + item.id + '>' + item.text + '</div>';
        }
        $('#' + thisID + '_rdivBody').append(printer);
      }
      bindBehavior();
    };
    this.mdvGetCurrentItems = function() {
      return currentItems;
    };
    this.mdvLock = function() {
      locked = true;
    };
    this.mdvUnlock = function() {
      locked = false;
    };
    return this.init();
  }
})(jQuery);
(function($) {
  $.fn.mdReaderO = function() {
    // support mutltiple elements
    if (this.length > 1) {
      this.each(function() {
        $(this).mdReaderO()
      });
      return this;
    }

    //::::::::::::::::
    // private variables
    //::::::::::::::::

    var visible = false;
    var thisID = "";
    var ignoreTimeout = false;

    //::::::::::::::::
    // public methods
    //::::::::::::::::

    this.init = function() {
      // Set the id of this overlay
      thisID = $(this).attr("id");
      $(this).toggleClass("rOverlay", true);
      var that = this;

      return this;
    };
    this.mdvDisplay = function(duration, text, openedFunction) {
      this.stop();
      visible = true;
      $('#' + thisID).fadeIn(duration, function() {
        openedFunction();
      });
      return this;
    };
    this.mdvHide = function(duration, closedFunction) {
      var m = $('#' + thisID);
      m.fadeOut(duration, function() {
        visible = false;
        closedFunction();
      });
      return this;
    };

    return this.init();
  };
})(jQuery);

jQuery(document).ready(function() {
  if (masterMD.rootID !== 0) {
    runmd();
  }
});
var masterMD = {
  'breadCrumb': 0,
  'table': 0,
  'history': [],
  'completeHistory': [],
  'currentPage': 0,
  'rootID': 'ded8716df49637',
  'readerName': 'r56703224',
  'sortOpen': false,
  'previousHash': '',
  'overlay': 0
};
