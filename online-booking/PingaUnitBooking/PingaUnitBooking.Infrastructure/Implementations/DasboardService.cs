using PingaUnitBooking.Core.Domain;
using PingaUnitBooking.Infrastructure.Interfaces;
using System.Data.SqlClient;
using System.Data;

namespace PingaUnitBooking.Infrastructure.Implementations
{
    public class DashboardService : IDashboardInterface
    {
        private readonly IDbInterface _dbInterface;
        public DashboardService(IDbInterface _dbInterface)
        {
            this._dbInterface = _dbInterface;
        }


        public async Task<ResponseDataResults<Dashboard>> GetDashboardSummary(decimal GroupID, int UserID,string YearMonth)
        {
            Dashboard dasboard = new Dashboard();
            List<SaleSummary> salesummarylist = new List<SaleSummary>();
            List<BookingAmount> bookingamountList = new List<BookingAmount>();
            List<UnitSaleProgress> unitSaleProgressList = new List<UnitSaleProgress>();
            try
            {
                using (SqlConnection connection = new SqlConnection(await _dbInterface.getREMSConnectionString()))
                {
                    await connection.OpenAsync();

                    using (SqlCommand command = new SqlCommand("ubm_DashboardSummary", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add(new SqlParameter("@GroupID", GroupID));
                        command.Parameters.Add(new SqlParameter("@ubmUserID", UserID));
                        command.Parameters.Add(new SqlParameter("@YearMonth", YearMonth));
                        using (SqlDataReader reader = await command.ExecuteReaderAsync())
                        {
                            while (reader.Read())
                            {
                                dasboard.TotalUnit = Convert.ToInt32(reader["TotalUnit"]);
                                dasboard.SoldUnit = Convert.ToInt32(reader["SoldUnit"]);
                                dasboard.ProgressUnit = Convert.ToInt32(reader["ProgressUnit"]);
                                dasboard.CancelsUnit = Convert.ToInt32(reader["CancelsUnit"]);
                            }
                            reader.NextResult();
                            while (reader.Read())
                            {
                                SaleSummary salesummary = new SaleSummary();
                                salesummary.SaleMonth = Convert.ToString(reader["SaleMonth"]);
                                salesummary.TotalUnit = Convert.ToInt32(reader["TotalUnit"]); 
                                salesummarylist.Add(salesummary);
                            }
                            dasboard.SaleSummary = salesummarylist;
                            reader.NextResult();
                            while (reader.Read())
                            {
                                BookingAmount bookingAmount = new BookingAmount();
                                bookingAmount.CollectionMonth = Convert.ToString(reader["CollectionMonth"]);
                                bookingAmount.Amount = Convert.ToInt32(reader["Amount"]);
                                bookingamountList.Add(bookingAmount);
                            }
                            dasboard.BookingAmount = bookingamountList;
                            reader.NextResult();
                            while (reader.Read())
                            {
                                UnitSaleProgress unitSaleProgressObj = new UnitSaleProgress();
                                unitSaleProgressObj.ProjectName = Convert.ToString(reader["ProjectName"]);
                                unitSaleProgressObj.UnitNo = Convert.ToString(reader["UnitNo"]);
                                unitSaleProgressObj.BookingType = Convert.ToString(reader["BookingType"]);
                                unitSaleProgressObj.SalesPersonName = Convert.ToString(reader["SalesPersonName"]);
                                unitSaleProgressObj.BookingAmount = Convert.ToInt32(reader["BookingAmount"]);
                                unitSaleProgressObj.StatusDate = Convert.ToString(reader["StatusDate"]);
                                unitSaleProgressObj.StatusName = Convert.ToString(reader["StatusName"]);
                                unitSaleProgressList.Add(unitSaleProgressObj);
                            }
                            dasboard.UnitSaleProgress = unitSaleProgressList;
                        }
                    }
                    return new ResponseDataResults<Dashboard>
                    {
                        IsSuccess = true,
                        Message = "Data Reterival Successfully..",
                        Data = dasboard
                    };
                }
            }
            catch (SqlException ex)
            {
                return new ResponseDataResults<Dashboard>
                {
                    IsSuccess = false,
                    Message = ex.Message,
                    Data = dasboard
                };
            }
            catch (Exception ex)
            {
                return new ResponseDataResults<Dashboard>
                {
                    IsSuccess = false,
                    Message = "An error occurred: " + ex.Message,
                    Data = dasboard
                };
            }
        }

    }
}
