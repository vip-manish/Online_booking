using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PingaUnitBooking.Core.Domain
{
    public class PaymentModel
    {
        public int UbmPaymentId { get;set;}
        public int UbmID  {get;set;}
        public string PaymentMode { get; set; }
        public string ChequeNo { get; set; }
        public DateTime ChequeDate { get; set; }
        public string BankName { get; set; }
        public string BranchName { get; set; }
        public decimal Amount { get; set; }
        public int CreatedBy { get; set; }
        public decimal GroupID { get; set; }
    }
}
