// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(function($){
	$.datepicker.regional['ja'] = {
		closeText: '閉じる',
		prevText: '&#x3c;前',
		nextText: '次&#x3e;',
		currentText: '今日',
		monthNames: ['1月','2月','3月','4月','5月','6月',
		'7月','8月','9月','10月','11月','12月'],
		monthNamesShort: ['1月','2月','3月','4月','5月','6月',
		'7月','8月','9月','10月','11月','12月'],
		dayNames: ['日曜日','月曜日','火曜日','水曜日','木曜日','金曜日','土曜日'],
		dayNamesShort: ['日','月','火','水','木','金','土'],
		dayNamesMin: ['日','月','火','水','木','金','土'],
		weekHeader: '週',
		dateFormat: 'yy-mm-dd',
		firstDay: 0,
		isRTL: false,
		showMonthAfterYear: true,
		yearSuffix: '年'};
	$.datepicker.setDefaults($.datepicker.regional['ja']);
});

$('#keyword').click(function() {
	$(this).css("background-color","yellow");
});

$(function (){
    $('#coupon_start_at').datepicker({maxDate: '+3m', minDate: '-0', autoSize: false, altField: '#actualDate', altFormat: 'yy-mm-dd', disabled: true, hideIfNoPrevNext: true });
});

$(function (){
    $('#coupon_start_at').datepicker({maxDate: '+3m', minDate: '-0', autoSize: false, altField: '#actualDate', altFormat: 'yy-mm-dd', disabled: true, hideIfNoPrevNext: true });
});

$(function (){
    $('#coupon_end_at').datepicker({maxDate: '+3m', minDate: '-0', autoSize: false, altField: '#actualDate', altFormat: 'yy-mm-dd', disabled: true, hideIfNoPrevNext: true });
});

$(function (){
    $('#record_start_at').datepicker({autoSize: false, altField: '#actualDate', altFormat: 'yy-mm-dd', disabled: true, hideIfNoPrevNext: true });
});

$(function (){
    $('#record_end_at').datepicker({autoSize: false, altField: '#actualDate', altFormat: 'yy-mm-dd', disabled: true, hideIfNoPrevNext: true });
});

$(function (){
    $('#customer_birthday').datepicker({autoSize: false, altField: '#actualDate', altFormat: 'yy-mm-dd', disabled: true, hideIfNoPrevNext: true });
});

function remove_field(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".sub_field").hide();
}

function add_field(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

function loadMap() {
	if (address != null) {
		if (GBrowserIsCompatible()) {
	    map = new GMap2(document.getElementById("old_map"));
	    geocoder = new GClientGeocoder();
	    showAddress(address);
		}
	}
}

function showAddress(address) {
  if (geocoder) {
    geocoder.getLatLng(
      address,
      function(point) {
        if (!point) {
          alert(address +
              " \u304C\u898B\u3064\u304B\u308A\u307E\u305B\u3093\u3002");
        } else {
          map.clearOverlays();
          map.setCenter(point, 15);
          var marker = new GMarker(point);
          map.addOverlay(marker);
        }
      }
    );
  }
}


function selectReplacement(obj) {
  obj.className += ' replaced';
  var ul = document.createElement('ul');
  ul.className = 'selectReplacement';
  var opts = obj.options;
  for (var i=0; i<opts.length; i++) {
    var selectedOpt;
    if (opts[i].selected) {
      selectedOpt = i;
      break;
    } else {
      selectedOpt = 0;
    }
  }
  for (var i=0; i<opts.length; i++) {
    var li = document.createElement('li');
    var txt = document.createTextNode(opts[i].text);
    li.appendChild(txt);
    li.selIndex = opts[i].index;
    li.selectID = obj.id;
    li.onclick = function() {
      selectMe(this);
    }
    if (i == selectedOpt) {
      li.className = 'selected';
      li.onclick = function() {
        this.parentNode.className += ' selectOpen';
        this.onclick = function() {
          selectMe(this);
        }
      }
    }
    if (window.attachEvent) {
      li.onmouseover = function() {
        this.className += ' hover';
      }
      li.onmouseout = function() {
        this.className = 
          this.className.replace(new RegExp(" hover\\b"), '');
      }
    }
    ul.appendChild(li);
  }
  obj.parentNode.insertBefore(ul,obj);
}

function selectMe(obj) {
  var lis = obj.parentNode.getElementsByTagName('li');
  for (var i=0; i<lis.length; i++) {
    if (lis[i] != obj) {
      lis[i].className='';
      lis[i].onclick = function() {
        selectMe(this);
      }
    } else {
      setVal(obj.selectID, obj.selIndex);
      obj.className='selected';
      obj.parentNode.className = 
        obj.parentNode.className.replace(new RegExp(" selectOpen\\b"), '');
      obj.onclick = function() {
        obj.parentNode.className += ' selectOpen';
        this.onclick = function() {
          selectMe(this);
        }
      }
    }
  }
}

function setVal(objID, selIndex) {
  var obj = document.getElementById(objID);
  obj.selectedIndex = selIndex;
}

function setForm() {
  var s = document.getElementsByTagName('select');
  for (var i=0; i<s.length; i++) {
    selectReplacement(s[i]);
  }
}