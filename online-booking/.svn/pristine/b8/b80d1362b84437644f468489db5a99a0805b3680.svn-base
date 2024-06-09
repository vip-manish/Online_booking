using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using PingaUnitBooking.Core.Domain;
using PingaUnitBooking.Infrastructure.Interfaces;
using System.ComponentModel.Design;
using System.Text.RegularExpressions;

namespace PingaUnitBooking.UI.Controllers
{
    [Route("api/UnitController")]
    public class UnitController : Controller
    {

        private readonly IUnitInterface _unitInterface;
        private readonly LocalStorageData _ld;
        public UnitController(IUnitInterface unitInterface, LocalStorageData _ld)
        {
            this._unitInterface = unitInterface;
            this._ld = _ld;
        }

        [HttpGet]
        [Route("unitDetailsList")]
        public async Task<IActionResult> unitDetailsList([FromQuery] int ProjectID, int TowerID)
        {
            try
            {
                var responseData = await _unitInterface.unitDetailsList(_ld.GroupID, _ld.UserID, ProjectID, TowerID);
                if (responseData.IsSuccess)
                {
                    foreach (var item in responseData.Data)
                    {
                        item.roleName = _ld.RoleName;
                    }

                    return Json(new { success = true, data = responseData.Data });
                }
                return Json(new { success = false, data = responseData.Message });
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }

        [HttpGet]
        [Route("paymentPlanList")]
        public async Task<IActionResult> paymentPlanList(decimal blockID, decimal unitID, decimal companyID, decimal locationID)
        {
            try
            {
                var responseData = await _unitInterface.paymentPlanList(blockID, unitID, companyID, locationID);
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

        [HttpGet]
        [Route("intrestPlanList")]
        public async Task<IActionResult> intrestPlanList(decimal companyID, decimal locationID)
        {
            try
            {

                var responseData = await _unitInterface.intrestPlanList(companyID, locationID, _ld.GroupID);
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


        [HttpGet]
        [Route("changeUnitStatus")]
        public async Task<IActionResult> changeUnitStatus([FromQuery] int unitID, int status)
        {
            try
            {
                var responseData = await _unitInterface.changeUnitStatus(unitID, _ld.GroupID, status);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, message = responseData.Message });
                }
                return Json(new { success = false, message = responseData.Message });
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }
        [HttpPost]
        [Route("addUbmUnit")]
        public async Task<IActionResult> addUbmUnit([FromBody] UnitData _unitData)
        {
            try
            {
                if (_unitData == null)
                    throw new Exception("Issue in unit configuration!");
                _unitData.userID = _ld.UserID;
                _unitData.groupID = _ld.GroupID;
                var responseData = await _unitInterface.addUbmUnit(_unitData);
                if (responseData.IsSuccess)
                {
                    return Json(new { success = true, message = responseData.Message });
                }
                return Json(new { success = false, message = responseData.Message });
            }
            catch (Exception ex)
            {
                return Json(new { succes = false, message = ex.Message });
            }
        }

        [HttpGet]
        [Route("GetUserProjects")]
        public async Task<IActionResult> GetUserProjects()
        {
            try
            {
                var GroupID = _ld.GroupID;
                var ubmUserId = _ld.UserID;
                var responseData = await _unitInterface.GetUserProjects(GroupID, ubmUserId);
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
        [HttpGet]
        [Route("GetTowerByProjectId")]
        public async Task<IActionResult> GetTowerByProjectId([FromQuery] int ProjectId)
        {
            try
            {
                var GroupID = _ld.GroupID;
                var ubmUserId = _ld.UserID;
                var responseData = await _unitInterface.GetTowerByProjectId(GroupID, ubmUserId, ProjectId);
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
    }
}
