HTMLWidgets.widget({

  name: 'featureViewer',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {
        console.log(x, el);

        $("#" + el.id).empty();

        var ft = new FeatureViewer(x.sequence, "#" + el.id, x.settings);

        for (var i in x.features) {
          ft.addFeature(x.features[i]);
        }

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
