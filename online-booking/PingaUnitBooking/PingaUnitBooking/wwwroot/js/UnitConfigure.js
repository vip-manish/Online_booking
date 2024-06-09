$(document).ready(function () {
   
    $('#ddlUserProjects').select2();
    $('#ddlTower').select2();
    $('#interestPlan').select2();
    UnitConfigureList();
    GetUserProjects();
});
var unitcounter = 0;

function UnitConfigureList() {
    unitcounter = 0;
    $('#empLoader').show();
    var projectid = $("#ddlUserProjects").val() == null ? 0 : $("#ddlUserProjects").val();
    var towerid = $("#ddlTower").val() == null ? 0 : $("#ddlTower").val();
    $.ajax({
        url: '/api/UnitController/unitDetailsList',
        type: 'GET',
        contentType: 'application/json',
        data: {
            ProjectID: projectid,
            TowerID: towerid
        },
        success: function (res) {
            $('#empLoader').hide();
            if (!res.success) {
                ErrorMessage(res.data);
                return
            }
            dataTable = $('#unitConfigureListTable').DataTable({
                data: res.data, 
                columns: [
                    { 
                        'data': 'unitID', 'render': function (data, type, row) {
                            unitcounter++; // Increment counter
                            return `<span>${unitcounter}</span>`;
                        },
                        'width': '1%', 'font-size': '6px'
                    },
                    {
                        'data': 'unitNo', 
                        'width': '10%', 'font-size': '6px'
                    },
                    {
                        'data': 'towerName', 
                        'width': '15%', 'font-size': '6px'
                    },
                    {
                        'data': 'projectName', 
                        'width': '15%', 'font-size': '6px'
                    },
                    {
                        'data': 'locationName', 
                        'width': '10%', 'font-size': '6px'
                    },
                    {
                        'data': 'netAmount',
                        'width': '15%', 'font-size': '6px'
                    },

                    {
                        'data': 'unitID',
                        'render': function (data, type, row) {
                            if (row.roleName == "Admin/CFO") {

                                if (row.unitStatus == 1) {
                                    return `<button type="button" onclick=changeUnitStatus("${row.unitID}") class="btn btn-warning"><i class="fa fa-clock-o mr-2"></i>Change Status</button>`
                                }
                                else if (row.unitStatus == 2)
                                    return ` <button  type="button" class="btn btn-success"><i class="fa fa-check mr-2"></i>Approved</button>`
                                else
                                    return `<apn></span>`
                            }
                            else {

                                if (row.unitStatus == 0) {
                                    return `<button data-row='${JSON.stringify(row)}' data-toggle="modal" data-backdrop="static" data-keyboard="false" onclick="getUnitDetailsByID(this)" data-target="#addUnitmodal" type="button" class="btn btn-primary"><i class="fa fa-edit mr-2"></i>Approval Request </button>`
                                }
                                else if (row.unitStatus == 1) {
                                    return `<button type="button" class="btn btn-warning"><i class="fa fa-clock-o mr-2"></i>Approval Pending</button>`
                                }
                                else if (row.unitStatus == 2)
                                    return ` <button  type="button" class="btn btn-success"><i class="fa fa-check mr-2"></i>Approved</button>`
                            }

                        },
                        'width': '22%',
                        'font-size': '6px'
                    },

                ],

                "font- size": '1em',
                dom: 'lBfrtip',
                "bDestroy": true,
                "paging": true,
                "searching": true,
                "ordering": true,
                "scrollX": true,
                "info": false,

                language: {
                    searchPlaceholder: "Search records",
                    emptyTable: "No data found",
                    width: '100%',
                },
            });
        }
    });



    //dataTable = $("#unitConfigureListTable").DataTable({

    //    ajax: {
    //        'type': 'GET',
    //        'url': '/api/UnitController/unitDetailsList',
    //        'contentType': 'application/json',
    //        data: {
    //            ProjectID: projectid,
    //            TowerID: towerid
    //        }
    //    },


    //    columns: [
    //        {

    //            'data': 'unitID', 'render': function (data, type, row) {
    //                unitcounter++; // Increment counter
    //                return `<span>${unitcounter}</span>`;
    //            },
    //            'width': '1%', 'font-size': '6px'
    //        },
    //        {
    //            'data': 'unitNo', 'render': function (data, type, row) {
    //                return `<span>${row.unitNo}</span>`;
    //            },
    //            'width': '10%', 'font-size': '6px'
    //        },
    //        {
    //            'data': 'towerName', 'render': function (data, type, row) {
    //                return `<span>${row.towerName}</span>`;
    //            },
    //            'width': '15%', 'font-size': '6px'
    //        },
    //        {
    //            'data': 'projectName', 'render': function (data, type, row) {
    //                return `<span>${row.projectName}</span>`;
    //            },
    //            'width': '15%', 'font-size': '6px'
    //        },
    //        {
    //            'data': 'locationName', 'render': function (data, type, row) {
    //                return `<span>${row.locationName}</span>`;
    //            },
    //            'width': '10%', 'font-size': '6px'
    //        },
    //        {
    //            'data': 'netAmount', 'render': function (data, type, row) {
    //                return `<span>₹ ${row.netAmount}</span>`;
    //            },
    //            'width': '15%', 'font-size': '6px'
    //        },

    //        {
    //            'data': 'unitID',
    //            'render': function (data, type, row) {
    //                if (row.roleName == "Admin/CFO") {

    //                    if (row.unitStatus == 1) {
    //                        return `<button type="button" onclick=changeUnitStatus("${row.unitID}") class="btn btn-warning"><i class="fa fa-clock-o mr-2"></i>Change Status</button>`
    //                    }
    //                    else if (row.unitStatus == 2)
    //                        return ` <button  type="button" class="btn btn-success"><i class="fa fa-check mr-2"></i>Approved</button>`
    //                    else
    //                        return `<apn></span>`
    //                }
    //                else {

    //                    if (row.unitStatus == 0) {
    //                        return `<button data-row='${JSON.stringify(row)}' data-toggle="modal" onclick="getUnitDetailsByID(this)" data-target="#addUnitmodal" type="button" class="btn btn-primary"><i class="fa fa-edit mr-2"></i>Approval Request </button>`
    //                    }
    //                    else if (row.unitStatus == 1) {
    //                        return `<button type="button" class="btn btn-warning"><i class="fa fa-clock-o mr-2"></i>Approval Pending</button>`
    //                    }
    //                    else if (row.unitStatus == 2)
    //                        return ` <button  type="button" class="btn btn-success"><i class="fa fa-check mr-2"></i>Approved</button>`
    //                }

    //            },
    //            'width': '22%',
    //            'font-size': '6px'
    //        },

    //    ],

    //    "font- size": '1em',
    //    dom: 'lBfrtip',
    //    "bDestroy": true,
    //    "paging": true,
    //    "searching": true,
    //    "ordering": true,
    //    "scrollX": true,
    //    "info": false,

    //    language: {
    //        searchPlaceholder: "Search records",
    //        emptyTable: "No data found",
    //        width: '100%',
    //    },

    //}
    //);

}

function getUnitDetailsByID(button) {
    var rowData = JSON.parse(button.getAttribute('data-row'));
    document.getElementById("projectName").value = rowData.projectName;
    document.getElementById("categoryName").value = rowData.categoryName;
    document.getElementById("towerName").value = rowData.towerName;
    document.getElementById("unitNo").value = rowData.unitNo;
    document.getElementById("unitID").value = rowData.unitID;
    document.getElementById("floorName").value = rowData.floorName;
    document.getElementById("area").value = rowData.area;
    document.getElementById("superArea").value = rowData.unitSuperArea;
    document.getElementById("rate").value = rowData.rate;
    document.getElementById("builtUpArea").value = rowData.unitBuiltUpArea;
    document.getElementById("superAreaRate").value = rowData.unitSuperAreaRate;
    document.getElementById("terraceArea").value = rowData.unitTerraceArea;
    document.getElementById("builtUpAreaRate").value = rowData.unitBuiltUpAreaRate;
    document.getElementById("terraceAreaRate").value = rowData.unitTerraceAreaRate;
    document.getElementById("carpetArea").value = rowData.unitCarpetArea;
    document.getElementById("balconyArea").value = rowData.unitBalconyArea;
    document.getElementById("basicAmount").value = rowData.basicAmount;
    document.getElementById("additionalCharge").value = rowData.additionalCharge;
    rowData.discountAmount != 0 ? document.getElementById("discountAmount").value = rowData.discountAmount : document.getElementById("discountAmount").value= 0;
    rowData.minSaleAmount != 0 ? document.getElementById("minSaleAmount").value = rowData.minSaleAmount : document.getElementById("minSaleAmount").value= 0;
    rowData.maxSaleAmount != 0 ? document.getElementById("maxSaleAmount").value = rowData.maxSaleAmount : document.getElementById("maxSaleAmount").value= 0;
    netAmount();
    getPaymentPlan(rowData.floorID, rowData.unitID, rowData.companyID, rowData.locationID);
    getIntrestPlan(rowData.companyID, rowData.locationID);

    if (rowData.intPlanID != 0) {
       
        setTimeout(function () {
            $('#interestPlan').val(rowData.intPlanID).trigger('change');
        }, 500);
        setTimeout(function () {
            $('#paymentPlan').val(rowData.payplanID).trigger('change');
        }, 500);
    } 
}

function getPaymentPlan(blockID, unitID, companyID, locationID) {
    $.ajax({
        url: '/api/UnitController/paymentPlanList',
        type: 'GET',
        contentType: 'application/json',
        data: {
            blockID: blockID,
            unitID: unitID,
            companyID: companyID,
            locationID: locationID
        },
        success: function (data) {
            if (data.success) {
                $('#paymentPlan').empty(); // Clear existing options
                $('#paymentPlan').append('<option value="">Select</option>');

                for (var i = 0; i < data.data.length; i++) {

                    $('#paymentPlan').append('<option value="' + data.data[i]['payplanID'] + '">' + data.data[i]['payplanName'] + '</option>');
                }
                $('#paymentPlan').select2();

            }

            else {
                ErrorMessage(data.message);

            }
        }
    })
}

function getIntrestPlan(companyID, locationID) {
    $.ajax({
        url: '/api/UnitController/intrestPlanList',
        type: 'GET',
        contentType: 'application/json',
        data: {
            companyID: companyID,
            locationID: locationID
        },
        success: function (data) {
            if (data.success) {
                $('#interestPlan').empty(); // Clear existing options
                $('#interestPlan').append('<option value="">Select</option>');

                for (var i = 0; i < data.data.length; i++) {

                    $('#interestPlan').append('<option value="' + data.data[i]['intPlanID'] + '">' + data.data[i]['intPlanName'] + '</option>');
                }
                $('#interestPlan').select2();
            }
            else {
                ErrorMessage(data.message);

            }
        }
    })
}

function netAmount() {


    var basicAmount = $('#basicAmount').val();
    var discountAmount = $('#discountAmount').val();
    if (parseInt(discountAmount) > parseInt(basicAmount)) {
        document.getElementById("discountAmount").value = 0;
        document.getElementById("netAmount").value =
            parseInt(document.getElementById("basicAmount").value) +
            parseInt(document.getElementById("additionalCharge").value) -
            parseInt(document.getElementById("discountAmount").value != "" ? document.getElementById("discountAmount").value : '0')

        return alert("Discount Amount cannot not be greater than basic amount");
    }
    else {
        document.getElementById("netAmount").value =
            parseInt(document.getElementById("basicAmount").value) +
            parseInt(document.getElementById("additionalCharge").value) -
            parseInt(document.getElementById("discountAmount").value != "" ? document.getElementById("discountAmount").value : '0')

    }
   

}


function minSaleAmount() {
    var netAmount = $('#netAmount').val();
    var minSaleAmt = $('#minSaleAmount').val();
    if (parseInt(minSaleAmt) < parseInt(netAmount)) {
        return false;
    } else {
        return true
    }
}


function addUbmUnit() {

    var UnitID = document.getElementById("unitID").value;
    var BasicAmount = document.getElementById("basicAmount").value;
    var AdditionalAmount = document.getElementById("additionalCharge").value;
    var DiscountAmount = document.getElementById("discountAmount").value;
    var NetAmount = document.getElementById("netAmount").value;
    var minSaleAmount = document.getElementById("minSaleAmount").value;
    var maxSaleAmount = document.getElementById("maxSaleAmount").value;
    var IntPlanID = document.getElementById("interestPlan").value == "" ? 0 : document.getElementById("interestPlan").value;
    var PayPlanID = document.getElementById("paymentPlan").value;
    if (minSaleAmount == "" || DiscountAmount == "" || PayPlanID == "") {
        ErrorMessage('Please fill all required fields');
        return;
    }
    if (minSaleAmount == false) {
        ErrorMessage('Minimum Sale Amount cannot not be Smaller than Net amount');
        return;
    }

    var dataToSend = {
        UnitID: UnitID,
        BasicAmount: BasicAmount,
        additionalCharge: AdditionalAmount,
        DiscountAmount: DiscountAmount,
        NetAmount: NetAmount,
        minSaleAmount: minSaleAmount,
        maxSaleAmount: maxSaleAmount,
        payment: { payplanID: PayPlanID },
        intrest: { intPlanID: IntPlanID }, 
    }

    $.ajax({
        url: '/api/UnitController/addUbmUnit',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(dataToSend),
        success: function (data) {
            if (data.success) {
                SuccessMessage(data.message);
                $('#addUnitmodal').modal('hide');
                $('.modal-backdrop').remove();
                UnitConfigureList();
            }
            else {
                ErrorMessage(data.message);

            }
        }
    })
}
function changeUnitStatus(unitID) {


    Swal.fire({
        title: "Are you sure Change the Status?",
        showDenyButton: true,
        showCloseButton: true,
        showCancelButton: false,
        confirmButtonText: "Approved",
        denyButtonText: `Not Approved`
    }).then((result) => {

        if (result.isConfirmed) {
            $.ajax({
                type: 'GET',
                url: '/api/UnitController/changeUnitStatus?unitID=' + unitID + '&status=2',
                success: function (data) {
                    if (data.success == true) {
                        SuccessMessage(data.message);
                        UnitConfigureList();
                    }
                    else {
                        ErrorMessage(data.message);

                    }
                }
            });
        }
        else if (result.isDenied) {
            $.ajax({
                type: 'GET',
                url: '/api/UnitController/changeUnitStatus?unitID=' + unitID + '&status=0',
                success: function (data) {
                    if (data.success == true) {
                        SuccessMessage(data.message);
                        UnitConfigureList();
                    }
                    else {
                        ErrorMessage(data.message);


                    }
                }
            });
        }

    });

}
function GetUserProjects() {
    $('#ddlUserProjects').empty();
    $.ajax({
        url: '/api/UnitController/GetUserProjects',
        type: 'GET',
        contentType: 'application/json',
        success: function (res) {
            if (res.success) {

                $('#ddlUserProjects').append('<option>Select</option>');
                for (i = 0; i < res.data.length; i++) {
                    $('#ddlUserProjects').append('<option value=' + res.data[i].key + '> ' + res.data[i].value + ' </option>')
                }
                $('#ddlUserProjects').select2();
            }
            else {
                ErrorMessage(res.data)

            }
        }
    })
    $('#ddlTower').append('<option>Select</option>');
}



function GetTowerByProjectId(projectId) {
  
    if (projectId == 0)
        return
    $('#ddlTower').empty();
    $.ajax({
        url: '/api/UnitController/GetTowerByProjectId',
        type: 'GET',
        contentType: 'application/json',
        data: {
            ProjectID: projectId
        },
        success: function (res) {
            if (res.success) {
                $('#ddlTower').append('<option>Select</option>');
                for (i = 0; i < res.data.length; i++) {
                    $('#ddlTower').append('<option value=' + res.data[i].key + '> ' + res.data[i].value + ' </option>')
                }
                $('#ddlTower').select2();
            }
            else {
                ErrorMessage(res.data);
            }
        }
    })

    $('#ddlTower').select2({
        closeOnSelect: true,
        placeholder: "Select Tower"
    });
}
