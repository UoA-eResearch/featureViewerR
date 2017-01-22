HTMLWidgets.widget({

  name: 'featureViewer',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    var x;
    var fv;
    var div = "#" + el.id;

    window.add_features = function() {
      if (fv) {
        fv.clearInstance();
        $(div).empty();
      }
      fv = new FeatureViewer(x.sequence, div, x.settings);

      for (var i in x.features) {
        var f = JSON.parse(JSON.stringify(x.features[i])); // Shallow copy. This is necessary as addFeature may modify the object
        var checked = "";
        if (!f.hidden) {
          fv.addFeature(f);
          checked = "checked";
        }

        var checkbox = $("<label class='checkbox-inline'><input type='checkbox' " + checked + " class='featureToggle' name='" + f.className + "'> " + f.name + "</label>");
        $("div.svgHeader").append(checkbox);
      }

      $(".featureToggle").click(function(e) {
        console.log("click");
        var className = e.target.name;
        for (var i in x.features) {
          if (x.features[i].className == className) {
            x.features[i].hidden = !e.target.checked;
          }
        }
        add_features();
      });

      $("div.svgHeader").append('<button id="modalButton" style="display:none; margin-left: 15px" type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">View feature</button>')

      fv.onFeatureSelected(function (d) {
          $("#myModalLabel").text(d.detail.description || "Feature");
          console.log(d.detail);
          var segment = x.sequence.substring(d.detail.start - 1, d.detail.end);
          $("#myModalBody").text(segment);
          $("#modalButton").show();
      });
    }


    $("body").append('<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">      <div class="modal-dialog" role="document">        <div class="modal-content">          <div class="modal-header">            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>            <h4 class="modal-title" id="myModalLabel">Feature</h4>          </div>          <div id="myModalBody" style="word-wrap:break-word;" class="modal-body">          </div>          <div class="modal-footer">            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>          </div>        </div>      </div>    </div>');

    return {

      renderValue: function(_x) {
        x = _x;
        add_features();
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
