﻿
$(document).ready(function () {
    getPermission();
   
    $('#projectID').select2({
        closeOnSelect: true,
        placeholder: "Select Project"
    });
    $('#towerID').select2({
        closeOnSelect: true,
        placeholder: "Select Tower"
    });
    $('#floorID').select2({
        closeOnSelect: true,
        placeholder: "Select Floor"
    });
    $('#unitID').select2({
        closeOnSelect: true,
        placeholder: "Select Unit"
    });
    $("#custom-tabs-five-tabContent :input").prop("disabled", false);
});

var isCreate="", isEdit="", isView="", isDelete="", isApproved="";

function getPermission() {
    $.ajax({
        url: '/api/AuthController/GetPermissions?pageType=' + "UnitBooking",
        type: 'GET',
        contentType: 'application/json',
        success: function (data) {
            if (data.success) {
                isCreate = data.data[0].isCreate;
                isEdit = data.data[0].isEdit;
                isView = data.data[0].isView;
                isDelete = data.data[0].isDelete;
                isApproved = data.data[0].isApproved;
                bookingUnitList();
            }
            else {
                ErrorMessage(data.message);

            }
        }
    });
}



document.getElementById("tncCheckBox").addEventListener("change", function () {
    const finalSubmitBtn = document.getElementById("finalSubmitBtn");

    if (this.checked) {
        finalSubmitBtn.disabled = false;
    } else {
        finalSubmitBtn.disabled = true;
    }
});



document.getElementById('applicantAge').addEventListener('input', function () {
    const value = parseInt(this.value, 10);
    if (isNaN(value) || value < 0 || value > 99) {
        document.getElementById("applicantAgeLabel").style.display = "block";
    } else {
        document.getElementById("applicantAgeLabel").style.display = "none";
    }
});

/*document.getElementById('coapplicantAge').addEventListener('input', function () {
    const COvalue = parseInt(this.value, 10);
    if (isNaN(COvalue) || COvalue < 0 || COvalue > 99) {
        document.getElementById("coapplicantAgeLabel").style.display = "block";
    } else {
        document.getElementById("coapplicantAgeLabel").style.display = "none";
    }
});*/

document.getElementById('applicantTel').addEventListener('input', function () {
    const value = this.value.trim();
    const isValidMobile = /^\d{10}$/.test(value);

    if (!isValidMobile) {
        document.getElementById("applicantTelLabel").style.display = "block";
    } else {
        document.getElementById("applicantTelLabel").style.display = "none";
    }
});
/*document.getElementById('coapplicantTel').addEventListener('input', function () {
    const value = this.value.trim();
    const isValidMobile = /^\d{10}$/.test(value);

    if (!isValidMobile) {
        document.getElementById("coapplicantTelLabel").style.display = "block";
    } else {
        document.getElementById("coapplicantTelLabel").style.display = "none";
    }
});*/
document.getElementById('applicantMob').addEventListener('input', function () {
    const value = this.value.trim();
    const isValidMobile = /^\d{10}$/.test(value);

    if (!isValidMobile) {
        document.getElementById("applicantMobLabel").style.display = "block";
    } else {
        document.getElementById("applicantMobLabel").style.display = "none";
    }
});
/*document.getElementById('coapplicantMob').addEventListener('input', function () {
    const value = this.value.trim();
    const isValidMobile = /^\d{10}$/.test(value);

    if (!isValidMobile) {
        document.getElementById("coapplicantMobLabel").style.display = "block";
    } else {
        document.getElementById("coapplicantMobLabel").style.display = "none";
    }
});
*/

document.getElementById('applicantEmail').addEventListener('input', function () {
    const email = this.value.trim();
    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (emailPattern.test(email)) {
        document.getElementById("applicantEmailLabel").style.display = "none";
    } else {
        document.getElementById("applicantEmailLabel").style.display = "block";

    }
});
/*document.getElementById('coapplicantEmail').addEventListener('input', function () {
    const email = this.value.trim();
    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (emailPattern.test(email)) {
        document.getElementById("coapplicantEmailLabel").style.display = "none";
    } else {
        document.getElementById("coapplicantEmailLabel").style.display = "block";

    }
});
*/


Toast = Swal.mixin({
    toast: true,
    position: 'top-end',
    showConfirmButton: false,
    timer: 5000,
    timerProgressBar: true,
    didOpen: (toast) => {
        toast.addEventListener('mouseenter', Swal.stopTimer)
        toast.addEventListener('mouseleave', Swal.resumeTimer)
    }
})


function bookingUnitList() {
    isCreate == false ? document.getElementById("BookUnitButton").style.display = "none" : document.getElementById("BookUnitButton").style.display = "block"
    $('#empLoader').show();
    $.ajax({
        url: '/api/bookingController/bookingUnitList',
        type: 'GET',
        contentType: 'application/json',
        success: function (res) {
            $('#empLoader').hide();
            if (!res.success) {
                ErrorMessage(res.data);
                return
            }
           var dataTable = $("#bookingUnitListTable").DataTable({
                data: res.data,
                columns: [
                    {
                        'data': null,
                        'width': '1%', 'font-size': '6px'
                    },
                    {
                        'data': 'unitNo',
                        'render': function (data, type, row) {
                            return `<a href="" data-backdrop="static" data-keyboard="false"  data-toggle="modal" data-target="#bookUnitModal" data-row='${JSON.stringify(row)}' onclick="viewUnitDetails(this)"">${row.unitNo}</a>`
                        },
                        'width': '10%',
                        'font-size': '6px'
                    },
                    
                    {
                        'data': 'customerName',
                        'width': '20%', 'font-size': '6px'
                    },
                    {
                        'data': 'projectName',
                        'width': '15%', 'font-size': '6px'
                    },
                    {
                        'data': 'status',
                        'render': function (data, type, row) {
                            return `<button type="button" onclick=showLogs("${row.ubmID}")  data-toggle="modal" data-target="#viewLogModel"  class="btn btn-danger">Logs </button>`
                        },
                        'width': '10%',
                        'font-size': '6px'
                    },
                    {
                        'data': 'customerEmail',
                        'width': '5%', 'font-size': '6px'
                    },
                    {
                        'data': 'customerMobileNo',
                        'width': '10%', 'font-size': '6px'
                    },
                    {
                        'data': 'customerMobileNo',
                        'render': function (data, type, row) {
                            if (row.status == 1) {
                                if (isEdit == true) {
                                    return `<button  data-backdrop="static" data-keyboard="false"  data-toggle="modal" data-target="#bookUnitModal" data-row='${JSON.stringify(row)}' onclick="editUnitBooking(this)"   type="button" class="btn btn-primary"><i class="fa fa-edit mr-1"></i>Edit </button>`
                                }
                                else {
                                    return `<span></span>`
                                }
                            }
                            else {
                                if (row.isVisible == 1) {
                                    return `<button data-toggle="modal" data-target="#viewAuthorizationSSModel" data-row='${JSON.stringify(row)}' onclick="openAuthorizationModel(this)"   type="button" class="btn btn-success">Change Status </button>`
                                }
                                else {
                                    return `<span></span>`
                                }
                            }
                        },
                        'width': '15%',
                        'font-size': '6px'
                    },

                ],

               "bDestroy": true,
            });

            dataTable.on('order.dt ', function () {
                dataTable.column(0, { order: 'applied' }).nodes().each(function (cell, i) {
                    cell.innerHTML = i + 1;
                });
            }).draw();

        }
    });
}
function editUnitBooking(button) {
        var rowData = JSON.parse(button.getAttribute('data-row'));
        applicantType(rowData.unitType)
        document.getElementById("custMobileNo").value = rowData.customerMobileNo;
        document.getElementById("custEmail").value = rowData.customerEmail;
        var datePart = rowData.releaseUnitDate.split('T')[0];
        document.getElementById("releaseUD").value = datePart;
        document.getElementById("ubmID").innerHTML = rowData.ubmID;

        document.getElementById("appType").value = rowData.applicationType;
        // Fill dropdown
        /*    getProjectDataforBooking('Project', rowData.projectID).then(() => {
        
                return getProjectDataforBooking('Tower', rowData.towerID).then(() => {
                    return getProjectDataforBooking('Floor', rowData.floorID).then(() => {
                        getProjectDataforBooking('Unit', rowData.unitID)
                    })
                })
            });*/

        getProjectDataforBooking('Project', rowData.projectID)
            .then(() => {
                return new Promise((resolve) => {
                    setTimeout(() => {
                        resolve();
                    }, 200);
                });
            })
            .then(() => {
                return getProjectDataforBooking('Tower', rowData.towerID);
            })
            .then(() => {
                return new Promise((resolve) => {
                    setTimeout(() => {
                        resolve();
                    }, 200);
                });
            })
            .then(() => {
                return getProjectDataforBooking('Floor', rowData.floorID);
            })
            .then(() => {
                return new Promise((resolve) => {
                    setTimeout(() => {
                        resolve();
                    }, 200);
                });
            })
            .then(() => {
                return getProjectDataforBooking('Unit', rowData.unitID);
            });


    }


    function applicantType(type) {
        if (type.value == "UnitBooking" || type == "UnitBooking") {
            document.querySelector(".projectDiv").style.display = "block";
            document.querySelector(".projectDiv").style.display = "flex";
            document.querySelector(".projectDiv").style.visibility = "visible";
            document.querySelector(".RequiredDocDiv").style.display = "block";
            document.querySelector(".RequiredDocDiv").style.display = "flex";
            document.querySelector(".RequiredDocDiv").style.visibility = "visible";
        }
        else {

            document.querySelector(".projectDiv").style.visibility = "hidden";
            document.querySelector(".projectDiv").style.display = "none";
            document.querySelector(".customerDiv").style.visibility = "visible";
            document.querySelector(".RequiredDocDiv").style.visibility = "hidden";
            document.querySelector(".RequiredDocDiv").style.display = "none";
        }
    }

function addBookedUnitBtn() {
    $("#custom-tabs-five-tabContent :input").prop("disabled", false);
    getProjectDataforBooking('Project')
}


function getProjectDataforBooking(type, dropDownID = null) {
  


        return new Promise((resolve, reject) => {
            var dataToSend = {
                type: type,
                projectAllData: {}
            };

            if (type === "Tower") {
                dataToSend.projectAllData.project = [{ projectID: document.getElementById("projectID").value }];
            } else if (type === "Floor") {
                dataToSend.projectAllData.tower = [{ towerID: document.getElementById("towerID").value }];
            } else if (type === "Unit") {
                dataToSend.projectAllData.floor = [{ floorID: document.getElementById("floorID").value }];
            }

            $.ajax({
                url: '/api/bookingController/getProjectDataforBooking',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(dataToSend),
                success: function (data) {
                    if (data.success) {
                        if (type === "Project") {
                            fillProjectDropDown(data.data, dropDownID);
                        } else if (type === "Tower") {
                            fillTowerDropDown(data.data, dropDownID);
                        } else if (type === "Floor") {
                            fillFloorDropdown(data.data, dropDownID);
                        } else if (type === "Unit") {
                            fillUnitDropdown(data.data, dropDownID);
                        }
                        resolve();
                    } else {
                        if (data.message !== undefined) ErrorMessage(data.message);
                        reject(data.message);
                    }
                },
                error: function (error) {
                    reject(error);
                }
            });
        });
    }

    function fillProjectDropDown(results, dropDownID = null) {
        var $projectDropdown = $('#projectID');
        $projectDropdown.empty();

        var defaultOption = new Option('Select Project', '', false, false);
        $projectDropdown.append(defaultOption);
        $('#projectID').append('<option>Select</option>');
        results.forEach(function (item) {
            if (item && item.project && Array.isArray(item.project) && item.project.length > 0) {
                item.project.forEach(function (project) {
                    if (project.projectName && project.projectID) {
                        var option = new Option(project.projectName, project.projectID, false, false);
                        $projectDropdown.append(option);
                    }
                });
            }
        });

        $projectDropdown.trigger('change.select2');

        if (dropDownID) {
            $projectDropdown.val(dropDownID).trigger('change');

        }
    }


    // BIND TOWER DROPDOWN DATA


    function fillTowerDropDown(results, dropDownID = null) {
        var $towerDropdown = $('#towerID');
        $towerDropdown.empty();

        var defaultOption = new Option('Select Tower', '', false, false);
        $towerDropdown.append(defaultOption);
        $('#towerID').append('<option>Select</option>');
        results.forEach(function (item) {
            if (item && item.tower && Array.isArray(item.tower) && item.tower.length > 0) {
                item.tower.forEach(function (tower) {
                    if (tower.towerName && tower.towerID) {
                        var option = new Option(tower.towerName, tower.towerID, false, false);
                        $towerDropdown.append(option);
                    }
                });
            }
        });

        $towerDropdown.trigger('change.select2');
        if (dropDownID) {
            $towerDropdown.val(dropDownID).trigger('change');
        }
    }

    // BIND FLOOR DROPDOWN DATA


    function fillFloorDropdown(results, dropDownID = null) {

        var $floorDropdown = $('#floorID');
        $floorDropdown.empty();

        var defaultOption = new Option('Select Floor', '', false, false);
        $floorDropdown.append(defaultOption);
        $('#floorID').append('<option>Select</option>');
        results.forEach(function (item) {
            if (item && item.floor && Array.isArray(item.floor) && item.floor.length > 0) {
                item.floor.forEach(function (floor) {
                    if (floor.floorName && floor.floorID) {
                        var option = new Option(floor.floorName, floor.floorID, false, false);
                        $floorDropdown.append(option);
                    }
                });
            }
        });
        $floorDropdown.trigger('change.select2');
        if (dropDownID) {
            $floorDropdown.val(dropDownID).trigger('change');
        }

    }


    function fillUnitDropdown(results, dropDownID = null) {

        var $unitDropdown = $('#unitID');
        $unitDropdown.empty();

        var defaultOption = new Option('Select Unit', '', false, false);
        $unitDropdown.append(defaultOption);
        $('#unitID').append('<option>Select</option>');
        results.forEach(function (item) {
            if (item && item.unitData && Array.isArray(item.unitData) && item.unitData.length > 0) {
                item.unitData.forEach(function (unitData) {
                    if (unitData.unitName && unitData.unitID) {
                        var option = new Option(unitData.unitName, unitData.unitID, false, false);
                        $unitDropdown.append(option);
                    }
                });
            }
        });
        $unitDropdown.trigger('change.select2');
        if (dropDownID) {
            $unitDropdown.val(dropDownID).trigger('change');
        }
    }


    function addBookedUnit() {


        var projectId = document.getElementById("projectID").value;
        var unitType = document.getElementById("ubCheck").checked ? document.getElementById("ubCheck").value : document.getElementById("ubeoi").value;
        var UnitID = document.getElementById("unitID").value;
        var customerMobileNo = document.getElementById("custMobileNo").value;
        var customerEmail = document.getElementById("custEmail").value;
        var releaseUnitDate = document.getElementById("releaseUD").value;
        var applicationType = document.getElementById("appType").value;
        var ubmID = document.getElementById("ubmID").innerHTML;
        if (UnitID == "Select") {
            return ErrorMessage("Kindly Select Unit");
        }

        else if (customerMobileNo == "") {
            return ErrorMessage("Kindly Add Mobile No");
        }
        else if (customerEmail == "") {
            return ErrorMessage("Kindly Add Email No") ;
        }

        else if (unitType == "UnitBooking") {
            if (UnitID == "") {
                return ErrorMessage("Kindly Select any Unit");
            }
            if (releaseUnitDate == "") {
                return ErrorMessage("Kindly Select Release Unit Date");
            }
            if (applicationType == "") {
                return ErrorMessage("Kindly Select any Application Type");
            }
        }


        var UBPayLoad = {
            unitType: unitType,
            unitID: UnitID,
            customerMobileNo: customerMobileNo,
            customerEmail: customerEmail,
            releaseUnitDate: releaseUnitDate,
            applicationType: applicationType,
            ubmID: ubmID != "" ? ubmID : null,
            ProjectID: projectId

        }
        var EOIPayLoad = {
            unitType: unitType,
            customerMobileNo: customerMobileNo,
            customerEmail: customerEmail,
            ubmID: ubmID

        }

        $.ajax({
            url: '/api/bookingController/addBookedUnit',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(unitType == "UnitBooking" ? UBPayLoad : EOIPayLoad),
            success: function (data) {
                if (data.success) {
                    // SuccessMessage(data.message);

                    if (unitType == "UnitBooking") {
                        document.getElementById("ubmID").innerHTML = data.data["ubmID"];
                        console.log(data.data["ubmID"]);
                        $('#pd-tab').tab('show');
                        $('#pd-tab').addClass('active');
                        $('#pd-tab-home').addClass('active show');
                        ubmPaymentList(data.data["ubmID"]);
                    }
                    else {
                        $("#bookingUnitListTable").DataTable().ajax.reload();
                        $('#bookUnitModal').modal('hide');
                        $('.modal-backdrop').remove();
                    }
                }
                else {

                    bookingUnitList();
                    $('#bookUnitModal').modal('hide');
                    $('.modal-backdrop').remove();
                    $("#bookingUnitListTable").DataTable().ajax.reload();
                    $('#bookUnitModal').modal('hide');
                    $('.modal-backdrop').remove();

                    ErrorMessage(data.message);

                }
            }
        })
    }


    function addPayment() {

        var payMode = document.getElementById("payMode").value;
        var chequeNo = document.getElementById("chequeNo").value;
        var branchName = document.getElementById("branchName").value;
        var Chqamount = document.getElementById("Chqamount").value;
        var ubmID = document.getElementById("ubmID").innerHTML;

        if (Chqamount == "") {
            return ErrorMessage("Kindly Add Amount No");
        }
        var payLoad = {
            PaymentMode: payMode,
            chequeNo: chequeNo,
            branchName: branchName,
            amount: Chqamount,
            ubmID: ubmID
        }

        $.ajax({
            url: '/api/bookingController/addPaymentModel',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(payLoad),
            success: function (data) {
                if (data.success) {
                    SuccessMessage(data.message);
                    document.getElementById("chequeNo").value = "";
                    document.getElementById("branchName").value = "";
                    document.getElementById("Chqamount").value = "";
                    ubmPaymentList(ubmID)
                    /* $("#ubmPaymentTable").DataTable().ajax.reload();*/

                }
                else {
                    ErrorMessage(data.message);

                }
            }
        })

    }


    function ubmPaymentList(ubmID) {

        dataTable = $("#ubmPaymentTable").DataTable({

            ajax: {
                url: '/api/bookingController/getPaymentModelList?ubmID=' + ubmID,
                type: 'GET',
                contentType: 'application/json',
            },
            columns: [
                {
                    'data': 'paymentMode',
                    'width': '10%', 'font-size': '6px'
                },
                {
                    'data': 'chequeNo',
                    'width': '15%', 'font-size': '6px'
                },
                {
                    'data': 'branchName',
                    'width': '15%', 'font-size': '6px'
                },
                {
                    'data': 'amount',
                    'width': '10%', 'font-size': '6px'
                },
                {
                    'data': 'ubmPaymentId',
                    'render': function (data, type, row) {
                        return `<button id="paymentDeleteIcon" onclick=deletePaymentPlan("${row.ubmPaymentId}") type="button" class="btn btn-danger"><i class="fa fa-trash-o"></i> </button>`
                    },
                    'width': '5%',
                    'font-size': '6px'
                },

            ],

            "font- size": '1em',
            dom: 'lBfrtip',
            "bDestroy": true,
            "paging": false,
            "searching": false,
            "ordering": false,
            "scrollX": true,
            "info": false,

            language: {
                searchPlaceholder: "Search records",
                emptyTable: "No Payment details found",
                width: '100%',
            },

        }
        );

    }


    function paymentSave() {
        $('#ad-tab').tab('show');
        $('#ad-tab').addClass('active');
        $('#ad-tab-home').addClass('active show');
        getApplicantDetails(1)
        stateList();
    }



    function applicantDocumentList() {
        var ubmID = document.getElementById("ubmID").innerHTML;

        $.ajax({
            url: '/api/bookingController/getApplicantDocument?ubmID=' + ubmID,
            type: 'GET',
            contentType: 'application/json',
            success: function (response) {
                if (response.success) {
                    var dataTable = $("#ApplicantDocTable").DataTable({
                        data: response.data,
                        columns: [
                            {
                                'data': null,
                                'width': '1%',
                                'font-size': '6px'
                            },
                            {
                                'data': 'documentName',
                                'width': '55%',
                                'font-size': '6px'
                            },
                            {
                                'data': 'documentUrl',
                                'render': function (data, type, row) {
                                    if (row.documentUrl != "") {
                                        let fileType = (row.documentUrl)
                                        if (fileType.includes("pdf")) {
                                            return `<div style="text-align: center;">
                                                          <a target="_blank" href="../../${row.documentUrl}">
                                                           <i class="fa fa-file-pdf-o" style="font-size:48px;color:red"></i>  
                                                           </a>
                                                   </div>`;

                                        } else {
                                            return `<div style="text-align: center;">
                                                          <a target="_blank" href="../../${row.documentUrl}">
                                                                  <img src="../../${row.documentUrl}" style="width:80px; height:60px;">
                                                           </a>
                                                   </div>`;
                                        }
                                       
                                    } else {
                                        return `<input type="file" id="ApplicantFile" class="form-control" accept="image/jpeg,image/png,application/pdf" placeholder="File" aria-label="File browser example">`;
                                    }
                                },
                                'width': '25%',
                                'font-size': '6px'
                            },
                            {
                                'data': 'documentID',
                                'render': function (data, type, row) {
                                    if (row.ubmKycid == 0) {
                                        return `<button data-row='${JSON.stringify(row)}' onclick="uploadApplicantDocs(this)" type="button" class="btn btn-primary">Upload</button>`;
                                    } else {
                                        return `<button data-row='${JSON.stringify(row)}' onclick="deleteAttachments(this)" type="button" class="btn btn-danger">Remove</button>`;
                                    }
                                },
                                'width': '3%',
                                'font-size': '6px'
                            }
                        ],

                        "font-size": '1em',
                        dom: 'lBfrtip',
                        "bDestroy": true,
                        "paging": false,
                        "searching": false,
                        "ordering": true,
                        "scrollX": false,
                        "info": false,

                        language: {
                            searchPlaceholder: "Search records",
                            emptyTable: "No data found",
                            width: '100%',
                        }
                    });

                    // Add index column
                    dataTable.on('order.dt', function () {
                        dataTable.column(0, { order: 'applied' }).nodes().each(function (cell, i) {
                            cell.innerHTML = i + 1;
                        });
                    }).draw();
                }
                else {
                    ErrorMessage(response.message);
                }

            }
        });
    }


    function uploadApplicantDocs(button) {

        var rowData = JSON.parse(button.getAttribute('data-row'));
        var ubmID = document.getElementById("ubmID").innerHTML;
        let docFile = $("#ApplicantFile")[0].files;
        if (docFile != null) {
            var formData = new FormData();
            for (i = 0; i < docFile.length; i++) {
                formData.append('DocumentFile', docFile[i]);
                formData.append('UbmID', ubmID);
                formData.append('DocumentID', rowData.documentID)
                formData.append('DocumentName', rowData.documentName)
                formData.append('MobileNo', rowData.mobileNo)
                formData.append('UnitID', rowData.unitID)
            }

            $.ajax({
                type: 'Post',
                url: "/api/bookingController/addApplicantDocument",
                async: false,
                cache: false,
                contentType: false,
                enctype: 'multipart/form-data',
                processData: false,
                data: formData,
                success: function (data) {
                    if (data.success) {
                        applicantDocumentList()
                        /*  $("#ApplicantDocTable").DataTable().ajax.reload();*/
                        SuccessMessage(data.message);

                    }
                    else {
                        ErrorMessage(data.message);
                    }
                }
            });
        }
        else {


        }
    }


    function deleteAttachments(button) {
        var rowData = JSON.parse(button.getAttribute('data-row'));

        var payLoad = {
            documentUrl: rowData.documentUrl,
            UbmKycid: rowData.ubmKycid,
        }
        $.ajax({
            url: '/api/bookingController/deleteAttachments',
            type: 'DELETE',
            contentType: 'application/json',
            data: JSON.stringify(payLoad),
            success: function (data) {
                if (data.success) {
                    SuccessMessage(data.message);
                    applicantDocumentList();
                }
                else {
                    ErrorMessage(data.message);
                }
            }
        })


    }



    function addApplicantDetails() {
        /* var applicantUnitDate = document.getElementById("applicantUnitDate").value;*/
        var applicantBuyerName = document.getElementById("applicantBuyerName").value;
        var applicantswd = document.getElementById("applicantswd").value;
        var applicantdob = document.getElementById("applicantdob").value;
        var applicantAge = document.getElementById("applicantAge").value;
        var applicantNationality = document.getElementById("applicantNationality").value;
        var applicantOccupation = document.getElementById("applicantOccupation").value;
        var applicantPan = document.getElementById("applicantPan").value;
        var applicantAdharNo = document.getElementById("applicantAdharNo").value;
        var applicantCorrAddress = document.getElementById("applicantCorrAddress").value;
        var applicantCity = document.getElementById("applicantCity").value;
        var applicantState = document.getElementById("applicantState").value;
        var applicantCountry = document.getElementById("applicantCountry").value;
        var applicantPIN = document.getElementById("applicantPIN").value;
        var applicantEmail = document.getElementById("applicantEmail").value;
        var applicantTel = document.getElementById("applicantTel").value;
        var applicantMob = document.getElementById("applicantMob").value;
      
      
        var ubmID = document.getElementById("ubmID").innerHTML;
        var ApplicantID = document.getElementById("applicantID").innerHTML;


        if (applicantBuyerName == "" || applicantswd == "" || applicantdob == "" || applicantAge == "" || applicantNationality == "" ||
            applicantOccupation == "" || applicantOccupation == "" || applicantPan == "" || applicantAdharNo == "" || applicantCorrAddress == ""
            || applicantCountry == "" || applicantPIN == "" || applicantEmail == "" || applicantTel == "" || applicantMob == "" || applicantCity == "" || applicantState == "" || applicantCity == "Select" || applicantState == "Select" 
             ) {
            return ErrorMessage("Please Fill All Mandatory Fileds");
          
        }

        var payLoad = {
            applicantType: 1,
            /* applicantUnitDate: applicantUnitDate,*/
            applicantBuyerName: applicantBuyerName,
            applicantswd: applicantswd,
            applicantdob: applicantdob,
            applicantAge: applicantAge,
            applicantNationality: applicantNationality,
            applicantOccupation: applicantOccupation,
            applicantPan: applicantPan,
            applicantAdharNo: applicantAdharNo,
            applicantCorrAddress: applicantCorrAddress,
            applicantCityID: applicantCity,
            applicantStateID: applicantState,
            applicantCountry: applicantCountry,
            applicantPIN: applicantPIN,
            applicantEmail: applicantEmail,
            applicantTel: applicantTel,
            applicantMob: applicantMob,
            ubmID: ubmID,
            applicantID: ApplicantID != "" ? ApplicantID : null
        }
        $.ajax({
            url: '/api/bookingController/addApplicantDetails',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(payLoad),
            success: function (data) {
                if (data.success) {
                    //SuccessMessage(data.message);
                    $('#cad-tab').tab('show');
                    $('#cad-tab').addClass('active');
                    $('#cad-tab-home').addClass('active show');
                    applicantList(2);
                    CoApplicantstateList();
                    clearApplicant();

                }
                else {
                    ErrorMessage(data.message);

                }
            }
        })
    }





    function ProceedApplicantDoc() {
        $('#du-tab').tab('show');
        $('#du-tab').addClass('active');
        $('#du-tab-home').addClass('active show');
        applicantDocumentList();
    }



    function ProceeddocumentUpload() {
        $('#tmc-tab').tab('show');
        $('#tmc-tab').addClass('active');
        $('#tmc-tab-home').addClass('active show');
        getTncTemplate();    
    }
    function clearApplicant() {
        document.getElementById("applicantUnitDate").value = "";
        document.getElementById("applicantBuyerName").value = "";
        document.getElementById("applicantswd").value = "";
        document.getElementById("applicantdob").value = "";
        document.getElementById("applicantAge").value = "";
        document.getElementById("applicantNationality").value = "";
        document.getElementById("applicantOccupation").value = "";
        document.getElementById("applicantPan").value = "";
        document.getElementById("applicantAdharNo").value = "";
        document.getElementById("applicantCorrAddress").value = "";
        document.getElementById("applicantCity").value = "";
        document.getElementById("applicantState").value = "";
        document.getElementById("applicantCountry").value = "";
        document.getElementById("applicantPIN").value = "";
        document.getElementById("applicantEmail").value = "";
        document.getElementById("applicantTel").value = "";
        document.getElementById("applicantMob").value = "";
       
    }

    function CoApplicantDetails() {
        var applicantBuyerName = document.getElementById("coApplicantName").value;
        var applicantswd = document.getElementById("coApplicantSwd").value;
        var applicantdob = document.getElementById("coApplicantDOB").value;
        var applicantAge = document.getElementById("coApplicantAge").value;
        var applicantNationality = document.getElementById("coApplicantNationality").value;
        var applicantOccupation = document.getElementById("coApplicantOccupation").value;
        var applicantPan = document.getElementById("coApplicantPAN").value;
        var applicantAdharNo = document.getElementById("coApplicantAdharNo").value;
        var applicantCorrAddress = document.getElementById("coApplicantAddress").value;
        var applicantCity = document.getElementById("coApplicantCityID").value;
        var applicantState = document.getElementById("coApplicantStateID").value;
        var applicantCountry = document.getElementById("coApplicantCountry").value;
        var applicantPIN = document.getElementById("coApplicantPIN").value;
        var applicantEmail = document.getElementById("coApplicantEmail").value;
        var applicantTel = document.getElementById("coApplicantTel").value;
        var applicantMob = document.getElementById("coApplicantMobile").value;
        var ubmID = document.getElementById("ubmID").innerHTML;

        if (applicantBuyerName == "" || applicantswd == "" || applicantdob == "" || applicantAge == "" || applicantNationality == "" ||
            applicantOccupation == "" || applicantOccupation == "" || applicantPan == "" || applicantAdharNo == "" || applicantCorrAddress == "" || applicantState == "" || applicantState == "Select" || applicantCity == "" || applicantCity == "Select" 
            || applicantCountry == "" || applicantPIN == "" || applicantEmail == "" || applicantTel == "" || applicantMob == "") {
            return ErrorMessage("Please Fill All Mandatory Fileds"); 
        }



        var payLoad = {
            applicantType: 2,
            applicantBuyerName: applicantBuyerName,
            applicantswd: applicantswd,
            applicantdob: applicantdob,
            applicantAge: applicantAge,
            applicantNationality: applicantNationality,
            applicantOccupation: applicantOccupation,
            applicantPan: applicantPan,
            applicantAdharNo: applicantAdharNo,
            applicantCorrAddress: applicantCorrAddress,
            applicantCityID: applicantCity,
            applicantStateID: applicantState,
            applicantCountry: applicantCountry,
            applicantPIN: applicantPIN,
            applicantEmail: applicantEmail,
            applicantTel: applicantTel,
            applicantMob: applicantMob,
            ubmID: ubmID
        }
        $.ajax({
            url: '/api/bookingController/addApplicantDetails',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(payLoad),
            success: function (data) {
                if (data.success) {
                    SuccessMessage(data.message);
                    $("#coApplicantTable").DataTable().ajax.reload();
                    clearCoApplicant();

                }
                else {
                    ErrorMessage(data.message);

                }
            }
        })
    }

    function clearCoApplicant() {
        document.getElementById("coApplicantName").value = "";
        document.getElementById("coApplicantSwd").value = "";
        document.getElementById("coApplicantDOB").value = "";
        document.getElementById("coApplicantAge").value = "";
        document.getElementById("coApplicantNationality").value = "";
        document.getElementById("coApplicantOccupation").value = "";
        document.getElementById("coApplicantPAN").value = "";
        document.getElementById("coApplicantAdharNo").value = "";
        document.getElementById("coApplicantAddress").value = "";
        document.getElementById("coApplicantCityID").value = "";
        document.getElementById("coApplicantStateID").value = "";
        document.getElementById("coApplicantCountry").value = "";
        document.getElementById("coApplicantPIN").value = "";
        document.getElementById("coApplicantEmail").value = "";
        document.getElementById("coApplicantTel").value = "";
        document.getElementById("coApplicantMobile").value = "";
    }



    function getApplicantDetails(appType) {
        var ubmID = document.getElementById("ubmID").innerHTML;

        $.ajax({
            url: '/api/bookingController/getApplicantList?ubmID=' + ubmID + '&appType=' + appType,
            type: 'GET',
            contentType: 'application/json',
            success: function (data) {
                if (data.success) {
                    document.getElementById("applicantID").innerHTML = data.data[0].applicantID;
                    document.getElementById("applicantBuyerName").value = data.data[0].applicantBuyerName;
                    document.getElementById("applicantswd").value = data.data[0].applicantswd;
                    var formatapplicantdob = data.data[0].applicantdob.split('T')[0];
                    document.getElementById("applicantdob").value = formatapplicantdob;
                    document.getElementById("applicantAge").value = data.data[0].applicantAge;
                    document.getElementById("applicantNationality").value = data.data[0].applicantNationality;
                    document.getElementById("applicantOccupation").value = data.data[0].applicantOccupation;
                    document.getElementById("applicantPan").value = data.data[0].applicantPan;
                    document.getElementById("applicantAdharNo").value = data.data[0].applicantAdharNo;
                    document.getElementById("applicantCorrAddress").value = data.data[0].applicantCorrAddress;


                    $('#applicantState').val(data.data[0].applicantStateID).trigger('change');
                    setTimeout(function () {
                        $('#applicantCity').val(data.data[0].applicantCityID).trigger('change');
                    }, 500);

                    document.getElementById("applicantCountry").value = data.data[0].applicantCountry;
                    document.getElementById("applicantPIN").value = data.data[0].applicantPIN;
                    document.getElementById("applicantEmail").value = data.data[0].applicantEmail;
                    document.getElementById("applicantTel").value = data.data[0].applicantMob;
                    document.getElementById("applicantMob").value = data.data[0].applicantMob;
                }
                else {
                    ErrorMessage(data.message);


                $('#applicantState').val(data.data[0].applicantStateID).trigger('change');
                setTimeout(function () {
                    $('#applicantCity').val(data.data[0].applicantCityID).trigger('change');
                }, 100); 

                document.getElementById("applicantCountry").value = data.data[0].applicantCountry;
                document.getElementById("applicantPIN").value = data.data[0].applicantPIN;
                document.getElementById("applicantEmail").value = data.data[0].applicantEmail;
                document.getElementById("applicantTel").value = data.data[0].applicantMob;
                document.getElementById("applicantMob").value = data.data[0].applicantMob;
                }

            }
        })
    }


    function applicantList(appType) {
        var ubmID = document.getElementById("ubmID").innerHTML;

        dataTable = $("#coApplicantTable").DataTable({

            ajax: {
                url: '/api/bookingController/getApplicantList?ubmID=' + ubmID + '&appType=' + appType,
                type: 'GET',
                contentType: 'application/json',
            },
            columns: [
                {
                    'data': null,
                    'width': '1%', 'font-size': '6px'
                },
                {
                    'data': 'applicantBuyerName',
                    'width': '20%', 'font-size': '6px'
                },
                {
                    'data': 'applicantCorrAddress',
                    'width': '70%', 'font-size': '6px'
                },

                {
                    'data': 'applicantID',
                    'render': function (data, type, row) {
                        return `<button data-row='${JSON.stringify(row)}' onclick="deleteCoApplicant(this)"  type="button" class="btn btn-danger">Delete </button>`

                    },
                    'width': '9%',
                    'font-size': '6px'
                },

            ],

            "font- size": '1em',
            dom: 'lBfrtip',
            "bDestroy": true,
            "paging": false,
            "searching": false,
            "ordering": true,
            "scrollX": false,
            "info": false,

            language: {
                searchPlaceholder: "Search records",
                emptyTable: "No data found",
                width: '100%',
            },

        }
        );
        dataTable.on('order.dt ', function () {
            dataTable.column(0, { order: 'applied' }).nodes().each(function (cell, i) {
                cell.innerHTML = i + 1;
            });
        }).draw();

    }



    function deleteCoApplicant(button) {
        var rowData = JSON.parse(button.getAttribute('data-row'));

        var payLoad = {
            applicantID: rowData.applicantID,
        }
        $.ajax({
            url: '/api/bookingController/deleteCoApplicant',
            type: 'DELETE',
            contentType: 'application/json',
            data: JSON.stringify(payLoad),
            success: function (data) {
                if (data.success) {
                    SuccessMessage(data.message);
                    $("#coApplicantTable").DataTable().ajax.reload();
                }
                else {
                    ErrorMessage(data.message);
                }
            }
        })
    }



function ChangeUbmStatus() {
    var ubmID = document.getElementById("ubmID").innerHTML;
    var remarks = document.getElementById("ssremarks").value;
    var authorizationDropdown = document.getElementById("authorizationDropdown").value;
    var payLoad = {
        UbmID: ubmID,
        Remarks: remarks,
        authorizationDropdown: authorizationDropdown
    }
    $.ajax({
        url: '/api/bookingController/ChangeUbmStatus',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(payLoad),
        success: function (data) {
            if (data.success) {
                SuccessMessage(data.message);
                $('#viewAuthorizationSSModel').modal('hide');
                $('.modal-backdrop').remove();
                bookingUnitList();
            }
        }
    })
}



    function ChangeUbmAuthorization() {
        var ubmID = document.getElementById("ubmID").innerHTML;
        var remarks = document.getElementById("remarks").value;
        var payLoad = {
            UbmID: ubmID,
            Remarks: remarks,
        }
        $.ajax({
            url: '/api/bookingController/ChangeUbmAuthorization',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(payLoad),
            success: function (data) {
                if (data.success) {
                    SuccessMessage(data.message);
                    $('#viewAuthorizationModel').modal('hide');
                    $('#bookUnitModal').modal('hide');
                    $('.modal-backdrop').remove();
                    bookingUnitList();

                }
                else {
                    ErrorMessage(data.message);
                }
            }
        })
    }

    function openAuthorizationModel(button) {
        var rowData = JSON.parse(button.getAttribute('data-row'));
        document.getElementById("ubmID").innerHTML = rowData.ubmID;
    }




    function stateList() {
        $.ajax({
            url: '/api/StateCityController/StateList',
            type: 'GET',
            contentType: 'application/json',
            success: function (data) {
                if (data.success) {
                    $('#applicantState').append('<option> Select </option>');
                    for (i = 0; i < data.data.length; i++) {
                        $('#applicantState').append('<option value=' + data.data[i]['stateID'] + '> ' + data.data[i]['stateName'] + ' </option>')
                    }
                    $('#applicantState').select2();
                }
                else {
                    ErrorMessage(data.message);

                }
            }
        });
    }

    function CityList() {
        var StateID = $('#applicantState').val();
        $.ajax({
            url: '/api/StateCityController/CityList?stateID=' + StateID,
            type: 'GET',
            contentType: 'application/json',
            success: function (data) {
                if (data.success) {
                    $('#applicantCity').empty();
                    $('#applicantCity').append('<option> Select </option>');
                    for (i = 0; i < data.data.length; i++) {
                        $('#applicantCity').append('<option value=' + data.data[i]['cityID'] + '> ' + data.data[i]['cityName'] + ' </option>')
                    }
                    $('#applicantCity').select2();
                }
                else {
                    ErrorMessage(data.message);

                }
            }
        });
    }


    function CoApplicantstateList() {
        $.ajax({
            url: '/api/StateCityController/StateList',
            type: 'GET',
            contentType: 'application/json',
            success: function (data) {
                if (data.success) {
                    $('#coApplicantStateID').append('<option> Select </option>');
                    for (i = 0; i < data.data.length; i++) {
                        $('#coApplicantStateID').append('<option value=' + data.data[i]['stateID'] + '> ' + data.data[i]['stateName'] + ' </option>')
                    }
                    $('#coApplicantStateID').select2();
                }
                else {
                    ErrorMessage(data.message);

                }
            }
        });
    }

    function CoApplicantCityList() {
        var StateID = $('#coApplicantStateID').val();
        $.ajax({
            url: '/api/StateCityController/CityList?stateID=' + StateID,
            type: 'GET',
            contentType: 'application/json',
            success: function (data) {
                if (data.success) {
                    $('#coApplicantCityID').empty();
                    $('#coApplicantCityID').append('<option> Select </option>');
                    for (i = 0; i < data.data.length; i++) {
                        $('#coApplicantCityID').append('<option value=' + data.data[i]['cityID'] + '> ' + data.data[i]['cityName'] + ' </option>')
                    }
                    $('#coApplicantCityID').select2();
                }
                else {
                    ErrorMessage(data.message);

                }
            }
        });
    }

    function ChangeApplicationType(ApplicationType) {
        if (ApplicationType != "Select") {
            $("#dvShowDoc").show()
        }
        else {
            $("#dvShowDoc").hide()
        }
    }
    function ShowDocuments() {
        var ApplicationType = $('#appType').val();
        $.ajax({
            url: '/api/bookingController/GetApplicationDocument?ApplicationType=' + ApplicationType,
            type: 'GET',
            contentType: 'application/json',
            success: function (res) {
                if (res.success) {

                }
                else {
                    ErrorMessage(res.data);
                }
            }
        });
    }


    function previousPaymentButton() {
        $('#unit-tab').tab('show');
        $('#unit-tab').addClass('active');
        $('#unit-tab-home').addClass('active show');
    }

    function previousApplicantTab() {
        $('#pd-tab').tab('show');
        $('#pd-tab').addClass('active');
        $('#pd-tab-home').addClass('active show');
    }

    function previousCoApplicantTab() {
        $('#ad-tab').tab('show');
        $('#ad-tab').addClass('active');
        $('#ad-tab-home').addClass('active show');
    }


    function previousDocumentButton() {
        $('#cad-tab').tab('show');
        $('#cad-tab').addClass('active');
        $('#cad-tab-home').addClass('active show');
    }

function previousTNCTab() {
    $('#du-tab').tab('show');
    $('#du-tab').addClass('active');
    $('#du-tab-home').addClass('active show');
}



function deletePaymentPlan(paymentID) {
    var ubmID = $('#ubmID').text();
    $.ajax({
        url: '/api/bookingController/deletepaymentPlan?paymentID=' + paymentID,
        type: 'DELETE',
        contentType: 'application/json',
        success: function (data) {
            if (data.success) {
                SuccessMessage(data.message);
                ubmPaymentList(ubmID)
            }
            else {
                ErrorMessage(data.message);
            }
        }
    })
}




function previousDocumentButton() {
    $('#cad-tab').tab('show');
    $('#cad-tab').addClass('active');
    $('#cad-tab-home').addClass('active show');
}

function previousDocumentButton() {
    $('#cad-tab').tab('show');
    $('#cad-tab').addClass('active');
    $('#cad-tab-home').addClass('active show');
}

  


    function getTncTemplate() {
        var ubmID = $('#ubmID').text();

        $.ajax({
            url: '/api/bookingController/getTncTemplate?ubmID=' + ubmID,
            type: 'GET',
            contentType: 'application/json',
            success: function (data) {
                if (data.success) {
                    document.getElementById("tncTemplate").innerHTML = data.data;
                }
                else {
                    ErrorMessage(data.message);
                }

            }
        })

    }
    function GetUnitInfo() {
        var UnitId = $('#unitID').val();
        if (UnitId == 'Select')
            return;
        $.ajax({
            url: '/api/bookingController/GetUnitInfo?UnitID=' + UnitId,
            type: 'GET',
            contentType: 'application/json',
            success: function (res) {
                if (res.success) {
                    $('#spFlatType').html(res.data["unitTypeName"]);
                    $('#spTowerName').html(res.data["blockName"]);
                    $('#spUnitNo').html(res.data["unitNo"]);
                    $('#spUnitCarpetArea').html(res.data["unitCarpetArea"]);
                }
                else {
                    ErrorMessage(res.data);
                }
            }
       
    });
}


function clearTabData() {
    $('#unit-tab').tab('show');
    $('#unit-tab').addClass('active');
    $('#unit-tab-home').addClass('active show');

    $('#towerID').empty();
    $('#floorID').empty();
    $('#unitID').empty();
    $('#custMobileNo').val("");
    $('#custEmail').val("");
    $('#releaseUD').val("");
    $('#appType').val("");
    $('#dvShowDoc').val("");
    $("#custom-tabs-five-tabContent :input").prop("disabled", false);
    location.reload()
  }



function showLogs(ubmID) {
    $.ajax({
        url: '/api/bookingController/unitLogs?ubmID=' + ubmID,
        type: 'GET',
        contentType: 'application/json',
        success: function (res) {
            if (res.success) {
                const logs = res.data; 
                const timelineContainer = $('#timeline-container');
                timelineContainer.empty(); 

                logs.forEach(log => {
                    const logEntry = `
                        <div class="vertical-timeline-item vertical-timeline-element">
                            <div>
                                <span class="vertical-timeline-element-icon bounce-in">
                                    <i class="badge badge-dot badge-dot-xl badge-success"></i>
                                </span>
                                <div class="vertical-timeline-element-content bounce-in">
                                    <h4 class="timeline-title">${log.statusName}</h4>
                                    <p>${log.remarks}</p>
                                    <span style="font-weight:bold">Created At  :  <span style="font-weight:300">${log.createdAt}<span></span>
                                    <span class="vertical-timeline-element-date">${log.userName}</span>
                                </div>
                            </div>
                        </div>
                    `;
                    timelineContainer.append(logEntry);
                });
            } else {
                ErrorMessage(res.data);
            }
        }
    });
}



function viewUnitDetails(button) {
    $("#custom-tabs-five-tabContent :input").prop("disabled", true);
    $("paymentDeleteIcon").prop("disabled", true);

    editUnitBooking(button)
    var rowData = JSON.parse(button.getAttribute('data-row'));
    $(document).on('click', '#unit-tab', function () {
        $('#unit-tab').tab('show');
        $('#unit-tab').addClass('active');
        $('#unit-tab-home').addClass('active show');
      
       
    });
    $(document).on('click', '#pd-tab', function () {
        $('#pd-tab').tab('show');
        $('#pd-tab').addClass('active');
        $('#pd-tab-home').addClass('active show');
        ubmPaymentList(rowData.ubmID);
    
    });
    $(document).on('click', '#ad-tab', function () {
        $('#ad-tab').tab('show');
        $('#ad-tab').addClass('active');
        $('#ad-tab-home').addClass('active show');
        getApplicantDetails(1)
        stateList();
      
    });
    $(document).on('click', '#cad-tab', function () {
        $('#cad-tab').tab('show');
        $('#cad-tab').addClass('active');
        $('#cad-tab-home').addClass('active show');
        applicantList(2);
        CoApplicantstateList();
       
    });
    $(document).on('click', '#du-tab', function () {
        $('#du-tab').tab('show');
        $('#du-tab').addClass('active');
        $('#du-tab-home').addClass('active show');
        applicantDocumentList();
       
    });
    $(document).on('click', '#tmc-tab', function () {
        $('#tmc-tab').tab('show');
        $('#tmc-tab').addClass('active');
        $('#tmc-tab-home').addClass('active show');
        getTncTemplate();   
        
    });
}