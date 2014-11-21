(function() {

  // Escape jQuery selector metacharacters: !"#$%&'()*+,./:;<=>?@[\]^`{|}~
  var $escape = function(val) {
    return val.replace(/([!"#$%&'()*+,.\/:;<=>?@\[\\\]^`{|}~])/g, '\\$1');
  };

  var sliderBS2InputBinding = {};

  $.extend(sliderBS2InputBinding, Shiny.textInputBinding, {
    getId: function(el) {
      return el['data-input-id'] || el.id;
    },
    getType: function() { return false; },
    find: function(scope) {
      // Check if jslider plugin is loaded
      if (!$.fn.slider)
        return [];

      return $(scope).find('input.jslider');
    },
    getValue: function(el) {
      var sliderVal = $(el).slider("value");
      if (/;/.test(sliderVal)) {
        var chunks = sliderVal.split(/;/, 2);
        return [+chunks[0], +chunks[1]];
      }
      else {
        return +sliderVal;
      }
    },
    setValue: function(el, value) {
      if (value instanceof Array) {
        $(el).slider("value", value[0], value[1]);
      } else {
        $(el).slider("value", value);
      }
    },
    subscribe: function(el, callback) {
      $(el).on('change.sliderBS2InputBinding', function(event) {
        callback(!$(el).data('animating'));
      });
    },
    unsubscribe: function(el) {
      $(el).off('.sliderBS2InputBinding');
    },
    receiveMessage: function(el, data) {
      if (data.hasOwnProperty('value'))
        this.setValue(el, data.value);

      if (data.hasOwnProperty('label'))
        $(el).parent().find('label[for="' + $escape(el.id) + '"]').text(data.label);

      // jslider doesn't support setting other properties

      $(el).trigger('change');
    },
    getRatePolicy: function() {
      return {
        policy: 'debounce',
        delay: 250
      };
    },
    getState: function(el) {
      var $el = $(el);
      var settings = $el.slider().settings;

      return { label: $el.parent().find('label[for="' + $escape(el.id) + '"]').text(),
               value:  this.getValue(el),
               min:    Number(settings.from),
               max:    Number(settings.to),
               step:   Number(settings.step),
               round:  settings.round,
               format: settings.format.format,
               locale: settings.format.locale
             };
    },
    initialize: function(el) {
      var $el = $(el);
      $el.slider();
      $el.next('span.jslider').css('width', $el.data('width'));
    }
  });

  Shiny.inputBindings.register(sliderBS2InputBinding, 'shiny.sliderBS2Input');

})();
