using PingaUnitBooking.Core.Domain;


namespace PingaUnitBooking.Infrastructure.Interfaces
{
    public interface IUnitInterface
    {
        Task<ResponseDataResults<List<UnitData>>> unitDetailsList(decimal? groupID, int? userID,int? ProjectID,int? TowerID);
        Task<ResponseDataResults<List<paymentPlan>>> paymentPlanList(decimal? blockID, decimal? unitID, decimal? companyID, decimal? locationID);
        Task<ResponseDataResults<List<intrestPlan>>> intrestPlanList(decimal? companyID, decimal? locationID, decimal? groupID);
        Task<ResponseDataResults<int>> addUbmUnit(UnitData _unitData);
        Task<ResponseDataResults<List<KeyValuePair<int, string>>>> GetUserProjects(decimal GroupId, int ubmUserId);
        Task<ResponseDataResults<List<KeyValuePair<int, string>>>> GetTowerByProjectId(decimal GroupId, int ubmUserId,int ProjectID);
        Task<ResponseDataResults<int>> changeUnitStatus(int? unitID, decimal? groupID, int? status);

    }
}
