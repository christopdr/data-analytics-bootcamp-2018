// from data.js
var tableData = data;

// YOUR CODE HERE!
var columns = ['Date','City','State','Country','Shape','Duration','Comments']
function generateDynamicTable(data, columns) {
      $('#ufo-table').empty();
      var table = d3.select('#ufo-table');
      var thead = table.append('thead');
      var tbody = table.append('tbody');
      var key_values = Object.keys(data[0]);
      // append the header row
      thead.append('tr')
          .selectAll('th')
          .data(columns).enter()
          .append('th')
          .text(function (column) {
              return column;
          });

      // create a row for each object in the data
      var rows = tbody.selectAll('tr')
          .data(data)
          .enter()
          .append('tr');

      // create a cell in each row for each column
      var cells = rows.selectAll('td')
          .data(function (row) {
              return key_values.map(function (column) {
                  return {
                      column: column,
                      value: row[column]
                  };
              });
          })
          .enter()
          .append('td')
          .text(function (d) {
              return d.value;
          });

      return table;
}

function loadDateRangeAvaliable(data) {
    var date_list = []
    for (var i = 0; i < data.length; i++) {
        if (date_list.indexOf(data[i].datetime) === -1) {
            date_list.push(data[i].datetime);
        }
    }
    return date_list;
}
function loadCityAvaliable(data) {
    var date_list = []
    for (var i = 0; i < data.length; i++) {
        if (date_list.indexOf(data[i].city) === -1) {
            date_list.push(data[i].city);
        }
    }
    return date_list;
}
function loadCountryAvaliable(data) {
    var date_list = []
    for (var i = 0; i < data.length; i++) {
        if (date_list.indexOf(data[i].country) === -1) {
            date_list.push(data[i].country);
        }
    }
    return date_list;
}
function loadStateAvaliable(data) {
    var date_list = []
    for (var i = 0; i < data.length; i++) {
        if (date_list.indexOf(data[i].state) === -1) {
            date_list.push(data[i].state);
        }
    }
    return date_list;
}
function loadShapeAvaliable(data) {
    var date_list = []
    for (var i = 0; i < data.length; i++) {
        if (date_list.indexOf(data[i].shape) === -1) {
            date_list.push(data[i].shape);
        }
    }
    return date_list;
}
function generateDropDownLists(tableData){
   dates_available = loadDateRangeAvaliable(tableData);
   var select_drop = d3.select("#dates_drop");
   var option_drop = select_drop.selectAll('option')
                        .data(dates_available)
                        .enter()
                        .append('option')
                        .text(function(n){
                            return n;
                        });
    /*****************************/
   city_available = loadCityAvaliable(tableData);
   var select_drop = d3.select("#city_drop");
   var option_drop = select_drop.selectAll('option')
                        .data(city_available)
                        .enter()
                        .append('option')
                        .text(function(n){
                            return n;
                        });
    /*****************************/
   country_available = loadCountryAvaliable(tableData);
   var select_drop = d3.select("#country_drop");
   var option_drop = select_drop.selectAll('option')
                        .data(country_available)
                        .enter()
                        .append('option')
                        .text(function(n){
                            return n;
                        });
    /*****************************/
   state_available = loadStateAvaliable(tableData);
   var select_drop = d3.select("#state_drop");
   var option_drop = select_drop.selectAll('option')
                        .data(state_available)
                        .enter()
                        .append('option')
                        .text(function(n){
                            return n;
                        });
    /*****************************/
   shape_available = loadShapeAvaliable(tableData);
   var select_drop = d3.select("#shape_drop");
   var option_drop = select_drop.selectAll('option')
                        .data(shape_available)
                        .enter()
                        .append('option')
                        .text(function(n){
                            return n;
                        });
}
//function generateFilterSearch
generateDropDownLists(tableData);
generateDynamicTable(tableData.slice(0,5), columns);

//alert(tableData);