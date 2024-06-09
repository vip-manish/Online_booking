using PingaUnitBooking.Core.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PingaUnitBooking.Infrastructure.Interfaces
{
    public  interface INotificationService
    {
        Task SendNotifiction(int ProjectID, int BookingID, string ProcessType);
        Task<ResponseDataResults<string>> TestMailConfigure(decimal GroupID,int MailConfigureID,string Type, string ToEmail, string ToMobileNo, string TemplateID, string Message);
    }
}
