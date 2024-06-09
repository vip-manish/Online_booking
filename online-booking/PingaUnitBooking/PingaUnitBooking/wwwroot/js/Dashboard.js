
$(document).ready(function () {
    GetDashboardSummary();
});
function GetDashboardSummary() {

    $('#eLoader').show();
    $.ajax({

        'type': 'GET',
        'url': '/api/DashboardController/GetDashboardSummary',
        'contentType': 'application/json',
        dataType: 'json',
        success: function (response) {
            debugger
            $('#eLoader').hide();
            if (response.success == false) {
                ErrorMessage(response.data);
            }
            else {
                $("#totalUnit").html(response.data.totalUnit);
                $("#soldUnit").html(response.data.soldUnit);
                $("#progressUnit").html(response.data.progressUnit);
                $("#cancelUnit").html(response.data.cancelUnit);
                BindSaleSummary(response.data.saleSummary);
                CollectionSummary(response.data.bookingAmount);
                SaleProgress(response.data.unitSaleProgress);
            }
        }
    })

}
function BindSaleSummary(saleSummary) {
    let xValues = [];
    let yValues = [];
    for (var i = 0; i < saleSummary.length; i++) {
        xValues.push(saleSummary[i].saleMonth);
        yValues.push(saleSummary[i].totalUnit);
    }


    new Chart("myChart", {
        type: "line",
        data: {
            labels: xValues,
            datasets: [{
                fill: false,
                lineTension: 0,
                backgroundColor: "rgba(0,0,255,1.0)",
                borderColor: "rgba(0,0,255,0.1)",
                data: yValues
            }]
        },
        options: {
            legend: { display: false },
            scales: {
                yAxes: [{ ticks: { min: 1, max: 100 } }],
            }
        }
    });
}
function CollectionSummary(bookingAmount) {


    let xValues = [];
    let yValues = [];
    var maxamt = Number.parseInt(Math.max(...bookingAmount.map(o => o.amount)));
    var minamt = Number.parseInt(Math.min(...bookingAmount.map(o => o.amount)));
    for (var i = 0; i < bookingAmount.length; i++) {
        xValues.push(bookingAmount[i].collectionMonth);
        var amt = Number.parseInt(bookingAmount[i].amount);
        yValues.push(amt);
    }
    var barColors = ["#CD6155", "#C39BD3", "#2980B9", "#76D7C4", "#73C6B6", "#82E0AA", "#F9E79F", "#F8C471", "#F0B27A", "#DC7633", "#2C3E50", "#FFBF00"];

    new Chart("myBarChart", {
        type: "bar",
        data: {
            labels: xValues,
            datasets: [{
                backgroundColor: barColors,
                data: yValues
            }]
        },
        options: {
            legend: { display: false },
            title: {
                display: true,
                text: "Month wise booking amount in lakh"
            },
            scales: {
                xAxes: [{ ticks: { min: minamt, max: maxamt } }]
            }
        }
    });
}

function SaleProgress(unitSaleProgress) {
     

    var html = "<table id='SaleProgress' class='table table-bordered table-hover' style='width:100%'>";
    html += "<thead>";
    html += "<tr>";
    html += "<th style='font-family: 'sans-serif'; font-weight: normal;'>Sr.</th>";
    html += "<th style='font-family: 'sans-serif'; font-weight: normal;'>Project</th>";
    html += "<th style='font-family: 'sans-serif'; font-weight: normal;'>Unit No</th>";
    html += "<th style='font-family: 'sans-serif'; font-weight: normal;'>Type</th>";
    html += "<th style='font-family: 'sans-serif'; font-weight: normal;'>Booking Amount</th>";
    html += "<th style='font-family: 'sans-serif'; font-weight: normal;'>Status</th>";
    html += "<th style='font-family: 'sans-serif'; font-weight: normal;'>Date</th>";
    html += "<th style='font-family: 'sans-serif'; font-weight: normal;'>Sale Person</th>";
    html += "</tr>";
    html += "</thead>";
    var i = 1;
    if (unitSaleProgress.length > 0) {
        unitSaleProgress.forEach(function (entry) {
            html += "<tr>";
            html += "<td>" + i++ + "</td>";
            html += "<td>" + entry.projectName + "</td>";
            html += "<td>" + entry.unitNo + "</td>";
            html += "<td>" + entry.bookingType + "</td>";          
            html += "<td>" + entry.bookingAmount + "</td>";
            html += "<td>" + entry.statusName + "</td>";
            html += "<td>" + entry.statusDate + "</td>";
            html += "<td>" + entry.salesPersonName + "</td>";
            html += "</tr>";
        });
    }
    else {
        html += "<tr>";
        html += "<td colspan='8' style='text-align:center'>No Record Found!</td>";
        html += "</tr>";
    }

    html += "</table>";
    document.getElementById("divSaleProgress").innerHTML = html;
    
}
  
 
