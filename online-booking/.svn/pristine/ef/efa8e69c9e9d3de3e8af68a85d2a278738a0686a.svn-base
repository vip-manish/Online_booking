using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace PingaUnitBooking.UI.Pages.Dashboard
{
    public class DashboardModel : PageModel
    {
        public void OnGet()
        {
            if (HttpContext.Session.GetString("Dashboard") != "True")
            {
             Response.Redirect("../Index");
            }
        }
    }
}






