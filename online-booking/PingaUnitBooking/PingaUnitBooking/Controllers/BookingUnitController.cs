using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using PingaUnitBooking.Core.Domain;
using PingaUnitBooking.Infrastructure.Helpers;
using PingaUnitBooking.Infrastructure.Interfaces;
using System.Net.Mail;
using System.Text;
using System.Text.RegularExpressions;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace PingaUnitBooking.UI.Controllers
{
    [Route("api/bookingController")]
    public class BookingUnitController : Controller
    {
        private readonly IBookingInterface bookingInterface;
        private readonly INotificationService _notificationService;
        private readonly LocalStorageData _ld;
        private IWebHostEnvironment Environment;
        public BookingUnitController(IBookingInterface bookingInterface, INotificationService notificationService, LocalStorageData _localStorage, IWebHostEnvironment webHost)
        {
            this.bookingInterface = bookingInterface;
            this._ld = _localStorage;
            this.Environment = webHost;
            _notificationService = notificationService;
        }
        [HttpGet]
        // [Authorize(AuthenticationSchemes = Microsoft.AspNetCore.Authentication.JwtBearer.JwtBearerDefaults.AuthenticationScheme)]
        [Route("bookingUnitList")]
        public async Task<IActionResult> bookingUnitList()
        {
            try
            {
                var responseData = await bookingInterface.bookingUnitList(_ld.GroupID, _ld.UserID);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, data = responseData.Data });
                }
                return Json(new { success = false, message = responseData.Message });
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }

        [HttpGet]
        // [Authorize(AuthenticationSchemes = Microsoft.AspNetCore.Authentication.JwtBearer.JwtBearerDefaults.AuthenticationScheme)]
        [Route("ubmDetailsByUnitID")]
        public async Task<IActionResult> ubmDetailsByUnitID([FromQuery] int ubmID)
        {
            try
            {
                var responseData = await bookingInterface.ubmDetailsByUnitID(_ld.GroupID, ubmID);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, data = responseData.Data });
                }
                return Json(new { success = false, message = responseData.Message });
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }


        [HttpPost]
        [Route("getProjectDataforBooking")]
        public async Task<IActionResult> getProjectDataforBooking([FromBody] SearchData searchData)
        {
            try
            {
                if (searchData != null)
                {
                    searchData.groupID = _ld.GroupID;
                    searchData.userID = _ld.UserID;
                    var responseData = await bookingInterface.getProjectDataforBooking(searchData);

                    if (responseData.IsSuccess)

                    {
                        return Json(new { success = true, data = responseData.Data });
                        //return Json(new { success = true, data = responseData.Data });
                    }
                    else
                    {
                        return Json(new { success = false, message = responseData.Message });
                    }
                }
                return Ok();
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }


        [HttpPost]
        [Route("addBookedUnit")]
        public async Task<IActionResult> addBookedUnit([FromBody] BookingData _bookingData)
        {
            try
            {

                _bookingData.groupID = _ld.GroupID;
                _bookingData.createdBy = _ld.UserID;
                var responseData = await bookingInterface.addBookedUnit(_bookingData);

                if (responseData.IsSuccess)
                {
                    await _notificationService.SendNotifiction(Convert.ToInt32(_bookingData.ProjectID), Convert.ToInt32(responseData.Data.ubmID), "Initiate Booking");
                    return Json(new { success = true, message = responseData.Message, data = responseData.Data });
                    //return Json(new { success = true, data = responseData.Data });
                }
                else
                {
                    return Json(new { success = false, message = responseData.Message });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }



        [HttpPost]
        [Route("addApplicantDetails")]
        public async Task<IActionResult> addApplicantDetails([FromBody] ApplicantData _applicantData)
        {
            try
            {
                _applicantData.GroupID = _ld.GroupID;
                _applicantData.CreatedBy = _ld.UserID;
                var responseData = await bookingInterface.addApplicantDetails(_applicantData);

                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, message = responseData.Message, });
                    //return Json(new { success = true, data = responseData.Data });
                }
                else
                {
                    return Json(new { success = false, message = responseData.Message });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }


        [HttpGet]
        [Route("getApplicantList")]
        public async Task<IActionResult> getApplicantList([FromQuery] int ubmID, int appType)
        {
            try
            {

                var responseData = await bookingInterface.getApplicantList(_ld.GroupID, ubmID, appType);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, data = responseData.Data });
                }
                return Json(new { success = false, message = responseData.Message });
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }




        [HttpPost]
        [Route("addPaymentModel")]
        public async Task<IActionResult> addPaymentModel([FromBody] PaymentModel _paymentModel)
        {
            try
            {

                _paymentModel.GroupID = _ld.GroupID;
                _paymentModel.CreatedBy = _ld.UserID;
                var responseData = await bookingInterface.addPaymentModel(_paymentModel);

                if (responseData.IsSuccess)

                {
                    return Json(new { success = true, message = responseData.Message, data = responseData.Data });
                    //return Json(new { success = true, data = responseData.Data });
                }
                else
                {
                    return Json(new { success = false, message = responseData.Message });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }


        [HttpGet]
        [Route("getPaymentModelList")]
        public async Task<IActionResult> getPaymentModelList([FromQuery] int ubmID)
        {
            try
            {

                var responseData = await bookingInterface.getPaymentModelList(_ld.GroupID, ubmID);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, data = responseData.Data });
                }
                return Json(new { success = false, message = responseData.Message });
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }



        [HttpGet]
        [Route("getApplicantDocument")]
        public async Task<IActionResult> getApplicantDocument([FromQuery] int ubmID)
        {
            try
            {

                var responseData = await bookingInterface.getApplicantDocument(_ld.GroupID, ubmID);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, data = responseData.Data });
                }
                return Json(new { success = false, message = responseData.Message });
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }


        [HttpPost]
        [Route("addApplicantDocument")]
        public async Task<IActionResult> addApplicantDocument([FromForm] ApplicationDoc _doc)
        {
            try
            {

                foreach (var attachment in _doc.DocumentFile)
                {
                    //ADDING IMAGE PATH IN FOLDER 
                    var uniqueName = _doc.unitID.ToString() + "_" + _doc.MobileNo.ToString() + "_" + _doc.DocumentName.ToString();
                    //var uniqueName = Regex.Replace(Convert.ToBase64String(Guid.NewGuid().ToByteArray()), "[/+=]", "");
                    string uploadsFolder = Path.Combine("Attachments", _ld.GroupID.ToString(), _doc.unitID.ToString() + "_" + _doc.MobileNo.ToString());
                    if (!Directory.Exists(uploadsFolder))
                    {
                        System.IO.Directory.CreateDirectory(Path.Combine(this.Environment.WebRootPath, uploadsFolder));
                    }
                    var exten = System.IO.Path.GetExtension((attachment.FileName));
                    var newFileName = uniqueName + exten;
                    string filePath = Path.Combine(uploadsFolder, newFileName);
                    var filepp = filePath;
                    filePath = Path.Combine(this.Environment.WebRootPath, filePath);
                    bool add = false;
                    var fileName1 = attachment.FileName;
                    while (add == false)
                    {

                        if (System.IO.File.Exists(filePath))
                        {
                            System.IO.File.Delete(filePath);
                        }
                        else
                        {
                            add = true;
                        }
                    }
                    filePath = Path.Combine(this.Environment.WebRootPath, filePath);
                    using (var fileStream = new FileStream(filePath, FileMode.Create))
                    {
                        attachment.CopyTo(fileStream);
                    }
                    _doc.DocumentUrl = Path.Combine(uploadsFolder, newFileName);
                }
                _doc.GroupID = _ld.GroupID;
                var responseData = await bookingInterface.addApplicantDocuments(_doc);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, data = responseData.Data });
                }
                return Json(new { success = false, data = responseData.Message });
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }


        [HttpDelete]
        [Route("deleteAttachments")]
        public async Task<IActionResult> deleteAttachments([FromBody] ApplicationDoc _doc)
        {
            try
            {
                if (_doc.DocumentUrl != null)
                {
                    var FilePath = Path.Combine(this.Environment.WebRootPath, _doc.DocumentUrl);
                    System.IO.File.Delete(FilePath);
                    _doc.GroupID = _ld.GroupID;
                    var responseData = await bookingInterface.DeleteAttachments(_doc);
                    if (responseData.IsSuccess)
                    {
                        return Json(new { success = true, message = responseData.Message });
                    }
                    else
                    {
                        return Json(new { success = false, message = responseData.Message });
                    }

                }
                else
                {
                    return Json(new { success = false, message = "Document Url is Missing" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }

        [HttpDelete]
        [Route("deleteCoApplicant")]
        public async Task<IActionResult> deleteCoApplicant([FromBody] ApplicantData _applicantData)
        {
            try
            {
                _applicantData.GroupID = _ld.GroupID;
                var responseData = await bookingInterface.deleteCoApplicant(_applicantData);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, message = responseData.Message });
                }
                else
                {
                    return Json(new { success = false, message = responseData.Message });
                }


            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }


        [HttpPost]
        [Route("ChangeUbmStatus")]
        public async Task<IActionResult> ChangeUbmStatus([FromBody] UbmStatus _ubmStatus)
        {
            try
            {
                _ubmStatus.GroupID = _ld.GroupID;
                _ubmStatus.CreatedBy = _ld.UserID;

                var responseData = await bookingInterface.ChangeUbmStatus(_ubmStatus);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, message = responseData.Message });
                }
                else
                {
                    return Json(new { success = false, message = responseData.Message });
                }


            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }


        [HttpPost]
        [Route("ChangeUbmAuthorization")]
        public async Task<IActionResult> ChangeUbmAuthorization([FromBody] UbmStatus _ubmStatus)
        {
            try
            {
                _ubmStatus.GroupID = _ld.GroupID;
                _ubmStatus.CreatedBy = _ld.UserID;

                var responseData = await bookingInterface.ChangeUbmAuthorization(_ubmStatus);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, message = responseData.Message });
                }
                else
                {
                    return Json(new { success = false, message = responseData.Message });
                }


            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }

        [HttpGet]
        [Route("GetApplicationDocument")]
        public async Task<IActionResult> GetApplicationDocument([FromQuery] string ApplicationType)
        {
            try
            {

                var responseData = await bookingInterface.GetApplicationDocument(_ld.GroupID, ApplicationType);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, data = responseData.Data });
                }
                return Json(new { success = false, data = responseData.Message });
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, data = ex.Message });
            }
        }

        [HttpDelete]
        [Route("deletepaymentPlan")]
        public async Task<IActionResult> deletepaymentPlan([FromQuery] int paymentID)
        {
            try
            {
                var responseData = await bookingInterface.DeletePaymentPlan(_ld.GroupID, paymentID);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, message = responseData.Message });
                }
                else
                {
                    return Json(new { success = false, message = responseData.Message });
                }


            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }


        [HttpGet]
        [Route("getTncTemplate")]
        public async Task<IActionResult> getTncTemplate([FromQuery] int ubmID)
        {
            try
            {
                var responseData = await bookingInterface.getTncTemplate(_ld.GroupID, ubmID);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, data = responseData.Data });
                }
                else
                {
                    return Json(new { success = false, message = responseData.Message });
                }
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }

        [HttpGet]
        [Route("GetUnitInfo")]
        public async Task<IActionResult> GetUnitInfo([FromQuery] int UnitID)
        {
            try
            {


                var responseData = await bookingInterface.GetUnitInfo(_ld.GroupID, UnitID);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, data = responseData.Data });
                }
                return Json(new { success = false, data = responseData.Message });
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, data = ex.Message });
            }
        }
        [HttpGet]
        [Route("unitLogs")]
        public async Task<IActionResult> unitLogs([FromQuery] int ubmID)
        {
            try
            {
                var responseData = await bookingInterface.GetUnitLogs(_ld.GroupID, ubmID);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, data = responseData.Data });
                }
                return Json(new { success = false, data = responseData.Message });
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, data = ex.Message });
            }
        }


        
    }
}
