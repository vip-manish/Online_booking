using MailKit.Security;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Hosting.Server;
using MimeKit;
using PingaUnitBooking.Core.Domain;
using PingaUnitBooking.Infrastructure.Interfaces;
using System.Net;
using System.Net.Mail;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text.RegularExpressions;


namespace PingaUnitBooking.Infrastructure.Helpers
{
    public class Notification : INotificationService
    {


        private readonly ITemplateInterface _templateinterface;
        private readonly IMailConfigureInterface _mailConfigureInterface;
        private readonly LocalStorageData _localStorage;
        private readonly IHostingEnvironment _hostingEnvironment;
        public const string MatchEmailPattern = @"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*";
        public Notification(IMailConfigureInterface mailConfigureInterface, ITemplateInterface templateinterface, LocalStorageData localStorage,
            IHostingEnvironment hostingEnvironment)
        {
            _templateinterface = templateinterface;
            _mailConfigureInterface = mailConfigureInterface;
            _localStorage = localStorage;
            _hostingEnvironment = hostingEnvironment;
        }
        public async Task SendNotifiction(int ProjectID, int BookingID, string ProcessType)
        {
            try
            {
                decimal GroupID = _localStorage.GroupID;
                ResponseDataResults<List<MailConfigure>> MailConfigure = await _mailConfigureInterface.GetMailConfigure(GroupID);
                if (!MailConfigure.IsSuccess)
                {
                    return;
                }
                ResponseDataResults<List<Template>> responseDataResults = await _mailConfigureInterface.GetNotificationTemplate(GroupID, ProcessType);
                if (!responseDataResults.IsSuccess)
                {
                    return;
                }
                ResponseDataResults<Communication> Communicationobj = await _mailConfigureInterface.GetCustomerUnitDetail(BookingID);
                if (!Communicationobj.IsSuccess)
                {
                    return;
                }
                MailConfigure EmailConfig = MailConfigure.Data.ToList().Find(x => x.ConfigureType == "Email" && x.IsActive == true);
                if (EmailConfig == null)
                {
                    return;
                }
                else
                {
                    Template template = responseDataResults.Data.ToList().Find(x => x.TemplateType == "Email");
                    if (template == null)
                    {
                        return;
                    }
                    string body = Replace(template.TemplateMsg, Communicationobj.Data);
                }
                MailConfigure WhatsAppConfig = MailConfigure.Data.ToList().Find(x => x.ConfigureType == "WhatsApp" && x.IsActive == true);
                if (WhatsAppConfig == null)
                {
                    return;
                }
                else
                {

                    Template template = responseDataResults.Data.ToList().Find(x => x.TemplateType == "WhatsApp");
                    if (template == null)
                    {
                        return;
                    }
                    string body = Replace(template.TemplateMsg, Communicationobj.Data);


                }

                MailConfigure smsConfig = MailConfigure.Data.ToList().Find(x => x.ConfigureType == "SMS" && x.IsActive == true);
                if (smsConfig == null)
                {
                    return;
                }
                else
                {
                    Template template = responseDataResults.Data.ToList().Find(x => x.TemplateType == "SMS");
                    if (template == null)
                    {
                        return;
                    }
                    string body = Replace(template.TemplateMsg, Communicationobj.Data);
                    string status = await SendSms(Communicationobj.Data.MobileNo, body, template.VendorTemplateID, smsConfig);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<ResponseDataResults<string>> TestMailConfigure(decimal GroupID, int MailConfigureID, string Type, string ToEmail, string ToMobileNo, string TemplateID, string Message)
        {
            string status = string.Empty;
            if (Type == "SMS")
            {
                ResponseDataResults<List<MailConfigure>> MailConfigure = await _mailConfigureInterface.GetMailConfigure(GroupID);
                MailConfigure smsConfig = MailConfigure.Data.ToList().Find(x => x.ConfigureType == "SMS" && x.MailConfigureID == MailConfigureID);
                status = await SendSms(ToMobileNo, Message, TemplateID, smsConfig);
            }
            else if (Type == "WhatsApp")
            {
                ResponseDataResults<List<MailConfigure>> MailConfigure = await _mailConfigureInterface.GetMailConfigure(GroupID);
                MailConfigure smsConfig = MailConfigure.Data.ToList().Find(x => x.ConfigureType == "WhatsApp" && x.MailConfigureID == MailConfigureID);
                status = await SendWhatsApp(ToMobileNo, Message, TemplateID, smsConfig);
            }
            else  
            {
                ResponseDataResults<List<MailConfigure>> MailConfigure = await _mailConfigureInterface.GetMailConfigure(GroupID);
                MailConfigure emailConfig = MailConfigure.Data.ToList().Find(x => x.ConfigureType == "Email" && x.MailConfigureID == MailConfigureID);
                status = await SendEmail(ToEmail, Message,"", emailConfig);
            }
            return new ResponseDataResults<string>
            {
                IsSuccess = true,
                Message =  "Send Successfully!",
                Data = status
            };
             
        }

        private async Task<string> SendSms(string MobileNo, string Message, string TemplateID, MailConfigure smsConfig)
        {
            string status = string.Empty;
            string SMSUserName;
            string SMSPassword;
            string SMSFrom;
            string SMSAPI;
            SMSUserName = EnDcHelper.Base64Decode(smsConfig.UserName); //c.Decrypt(SMSUserName);
            SMSFrom = EnDcHelper.Base64Decode(smsConfig.SenderName); //c.Decrypt(SMSFrom);
            SMSPassword = EnDcHelper.Base64Decode(smsConfig.Password); //c.Decrypt(SMSPassword);
            SMSAPI = EnDcHelper.Base64Decode(smsConfig.SmsUrl); //c.Decrypt(SMSAPI);
            SMSAPI = SMSAPI.Replace("=username", "=" + SMSUserName);
            SMSAPI = SMSAPI.Replace("=password", "=" + SMSPassword);
            SMSAPI = SMSAPI.Replace("=number", "=" + MobileNo);
            SMSAPI = SMSAPI.Replace("=message", "=" + Message);
            SMSAPI = SMSAPI.Replace("=templateid", "=" + TemplateID);
            Uri objURI = new Uri(SMSAPI);
            WebRequest objWebRequest = WebRequest.Create(objURI);
            WebResponse objWebResponse = objWebRequest.GetResponse();
            System.IO.Stream objStream = objWebResponse.GetResponseStream();
            System.IO.StreamReader objStreamReader = new System.IO.StreamReader(objStream);
            status = objStreamReader.ReadToEnd();
            return await Task.FromResult<string>(status);
        }
        private async Task<string> SendWhatsApp(string MobileNo, string Message,string TemplateID, MailConfigure whatsappConfigure)
        {
            string status = string.Empty;
            return await Task.FromResult<string>(status);
        }
        private async Task<string> SendEmail(string ToEmail, string body, string Subject, MailConfigure mailConfigure)
        {
            string status = string.Empty;
        
            if (mailConfigure.BasedOn.ToUpper() == "TLS")
            {
                var builder = new BodyBuilder();
                int port1 = Convert.ToInt32(mailConfigure.PortNo) != 0 ? Convert.ToInt32(mailConfigure.PortNo) : 25;
                var email = new MimeMessage();
                var smtpTLS = new MailKit.Net.Smtp.SmtpClient();
                smtpTLS.Connect(mailConfigure.SMTPServer, port1, SecureSocketOptions.Auto);

                if (mailConfigure.SenderName.Trim() != "" && IsEmail(mailConfigure.SenderName))
                {
                    email.From.Add(MailboxAddress.Parse(mailConfigure.SenderName));
                }
                else
                {
                    return "";
                }
                if (IsEmail(ToEmail.Trim()))
                {
                    email.To.Add(MailboxAddress.Parse(ToEmail.Trim()));
                }
                else
                {
                    return "";
                }

                email.From.Add(MailboxAddress.Parse(mailConfigure.SenderName));
                email.Subject = Subject;
                body = body.Replace("&nbsp;", "");
                builder.TextBody = body;
                List<LinkedResource> listLinkedResource = new List<LinkedResource>();
                string messageStr = body;
                if (messageStr.Contains("src"))
                {
                    string[] msgArray = messageStr.Split(' ');
                    msgArray = msgArray.Where(itemObject => itemObject.Contains("src")).ToArray<string>();
                    int k = 1;
                    foreach (string m in msgArray)
                    {
                        if (m.Contains("src"))
                        {
                            string srcpath = m;
                            srcpath = srcpath.Replace("src=", "").Replace("\"", "");

                            string webRootPath = _hostingEnvironment.WebRootPath;
                            string contentRootPath = _hostingEnvironment.ContentRootPath;

                            string ImagePath = webRootPath + "\n" + contentRootPath + "\n" + srcpath;
                            LinkedResource LinkedImage = new LinkedResource(ImagePath);
                            LinkedImage.ContentId = "Image" + k;
                            messageStr = messageStr.Replace(m, "src=cid:" + LinkedImage.ContentId);
                            listLinkedResource.Add(LinkedImage);
                            k = k + 1;
                        }
                    }
                }

                AlternateView htmlView = AlternateView.CreateAlternateViewFromString(messageStr, null, "text/html");
                if (listLinkedResource.Count > 0)
                {
                    foreach (LinkedResource linkResource in listLinkedResource)
                    {
                        htmlView.LinkedResources.Add(linkResource);
                    }
                }



                email.Body = builder.ToMessageBody();

                smtpTLS.Timeout = 2147483647;
                smtpTLS.Authenticate(mailConfigure.UserName, mailConfigure.Password);
                smtpTLS.Send(email);
                email.Dispose();
                status = "Email sent!";

            }

            //// start mtalk

            else if (mailConfigure.Provider.ToUpper() == "MTALK")
            {
                MailMessage objMM = new MailMessage();
                // System.Net.Mail.SmtpClient mailClient = new System.Net.Mail.SmtpClient(SmtpServer);
                System.Net.Mail.SmtpClient mailClient;

                if (Convert.ToString(mailConfigure.PortNo) == "")
                {
                    mailClient = new System.Net.Mail.SmtpClient(mailConfigure.SMTPServer);
                }
                else
                {
                    mailClient = new System.Net.Mail.SmtpClient(mailConfigure.SMTPServer, Convert.ToInt32(mailConfigure.PortNo));
                }

                System.Net.NetworkCredential Auth = new System.Net.NetworkCredential(mailConfigure.UserName, mailConfigure.Password);
                mailClient.UseDefaultCredentials = false;
                mailClient.Credentials = Auth;
                //if (IsSSL == true)
                //{
                //    mailClient.EnableSsl = IsSSL;
                //}


                if (mailConfigure.SenderName.Trim() != "" && IsEmail(mailConfigure.SenderName))
                {

                    MailAddress from = new MailAddress(mailConfigure.SenderName);
                    objMM.From = new MailAddress(from.ToString());

                }
                else
                {
                    return "";
                }
                if (IsEmail(ToEmail.Trim()))
                {
                    objMM.To.Add(new MailAddress(ToEmail.ToString()));
                }
                else
                {
                    return "";
                }
                objMM.Subject = Subject;// "Notification";

                objMM.Priority = MailPriority.High;
                objMM.IsBodyHtml = true;
                string msg = body;
                //Session["FailedAddress"] = FailedAddress;
                msg = msg.Replace("&nbsp;", "");
                objMM.Body = msg;

                List<LinkedResource> listLinkedResource = new List<LinkedResource>();
                string messageStr = msg;
                if (messageStr.Contains("src"))
                {
                    string[] msgArray = messageStr.Split(' ');
                    msgArray = msgArray.Where(itemObject => itemObject.Contains("src")).ToArray<string>();
                    int k = 1;
                    foreach (string m in msgArray)
                    {
                        if (m.Contains("src"))
                        {
                            string srcpath = m;
                            srcpath = srcpath.Replace("src=", "").Replace("\"", "");
                            string webRootPath = _hostingEnvironment.WebRootPath;
                            string contentRootPath = _hostingEnvironment.ContentRootPath;
                            string ImagePath = webRootPath + "\n" + contentRootPath + "\n" + srcpath;
                            LinkedResource LinkedImage = new LinkedResource(ImagePath);
                            LinkedImage.ContentId = "Image" + k;
                            messageStr = messageStr.Replace(m, "src=cid:" + LinkedImage.ContentId);
                            listLinkedResource.Add(LinkedImage);
                            k = k + 1;
                        }
                    }
                }

                AlternateView htmlView = AlternateView.CreateAlternateViewFromString(messageStr, null, "text/html");
                if (listLinkedResource.Count > 0)
                {
                    foreach (LinkedResource linkResource in listLinkedResource)
                    {
                        htmlView.LinkedResources.Add(linkResource);
                    }
                }

                mailClient.Send(objMM);
                objMM.Dispose();
                status = "Email sent!";
            }
            else
            {
                System.Net.Mail.SmtpClient mailClient;

                if (Convert.ToString(mailConfigure.PortNo) == "")
                {
                    //  mailClient = new SmtpClient(SmtpServer);
                    mailClient = new System.Net.Mail.SmtpClient(mailConfigure.SMTPServer);
                }
                else
                {
                    //  mailClient = new SmtpClient(SmtpServer, Convert.ToInt32(port));
                    mailClient = new System.Net.Mail.SmtpClient(mailConfigure.SMTPServer, Convert.ToInt32(mailConfigure.PortNo));
                }

                System.Net.NetworkCredential Auth = new System.Net.NetworkCredential(mailConfigure.UserName, mailConfigure.Password);
                mailClient.UseDefaultCredentials = false;
                mailClient.Credentials = Auth;
                if (mailConfigure.BasedOn == "SSL")
                {
                    mailClient.EnableSsl = true;
                }

                if (mailConfigure.SenderName.Trim() != "" && IsEmail(mailConfigure.SenderName))
                {
                    MailAddress mfrom = new MailAddress(mailConfigure.SenderName);
                }
                else
                {
                    return "";
                }

                MailAddress to;
                if (IsEmail(ToEmail.ToString()))//validate TO eMail ID
                {
                    to = new MailAddress(ToEmail.ToString());
                }
                else
                {

                    return "";
                }

                MailAddress from = new MailAddress(mailConfigure.SenderName);

                MailMessage objMM = new MailMessage(from, to);


                objMM.Subject = Subject;

                objMM.Priority = MailPriority.High;
                objMM.IsBodyHtml = true;
                string msg = body;
                //Session["FailedAddress"] = FailedAddress;
                msg = msg.Replace("&nbsp;", "");
                objMM.Body = msg;
                List<LinkedResource> listLinkedResource = new List<LinkedResource>();
                string messageStr = msg;
                if (messageStr.Contains("src"))
                {
                    string[] msgArray = messageStr.Split(' ');
                    msgArray = msgArray.Where(itemObject => itemObject.Contains("src")).ToArray<string>();
                    int k = 1;
                    foreach (string m in msgArray)
                    {
                        if (m.Contains("src"))
                        {
                            string srcpath = m;
                            srcpath = srcpath.Replace("src=", "").Replace("\"", "");
                            string webRootPath = _hostingEnvironment.WebRootPath;
                            string contentRootPath = _hostingEnvironment.ContentRootPath;
                            string ImagePath = webRootPath + "\n" + contentRootPath + "\n" + srcpath;
                            LinkedResource LinkedImage = new LinkedResource(ImagePath);
                            LinkedImage.ContentId = "Image" + k;
                            messageStr = messageStr.Replace(m, "src=cid:" + LinkedImage.ContentId);
                            listLinkedResource.Add(LinkedImage);
                            k = k + 1;
                        }
                    }
                }

                AlternateView htmlView = AlternateView.CreateAlternateViewFromString(messageStr, null, "text/html");
                if (listLinkedResource.Count > 0)
                {
                    foreach (LinkedResource linkResource in listLinkedResource)
                    {
                        htmlView.LinkedResources.Add(linkResource);
                    }
                }
                //validate(bypass) x509 certificate
                ServicePointManager.ServerCertificateValidationCallback = delegate (object s, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) { return true; };
                objMM.AlternateViews.Add(htmlView);
                mailClient.Timeout = 2147483647;
                mailClient.Send(objMM);
                objMM.Dispose();
                status = "Email sent!";
            }
            return await Task.FromResult<string>(status);
        }
        private string Replace(string original, Communication bookingdetail)
        {
            string tempstring = original;
            tempstring = ReplaceEx(tempstring, "[|UnitNo|]", bookingdetail.UnitDetail.unitNo);
            tempstring = ReplaceEx(tempstring, "[|Email|]", bookingdetail.Email);
            tempstring = ReplaceEx(tempstring, "[|MobileNo|]", bookingdetail.MobileNo);
            tempstring = ReplaceEx(tempstring, "[|BookingDate|]", Convert.ToString(bookingdetail.BookingDate));
            tempstring = ReplaceEx(tempstring, "[|ProjectName|]", bookingdetail.UnitDetail.projectName);
            tempstring = ReplaceEx(tempstring, "[|ProjectAddress|]", bookingdetail.UnitDetail.projectAddress);
            tempstring = ReplaceEx(tempstring, "[|ApplicationType|]", bookingdetail.ApplicationType);
            tempstring = ReplaceEx(tempstring, "[|TowerName|]", bookingdetail.UnitDetail.towerName);
            tempstring = ReplaceEx(tempstring, "[|FloorName|]", bookingdetail.UnitDetail.floorName);
            tempstring = ReplaceEx(tempstring, "[|Area|]", Convert.ToString(bookingdetail.UnitDetail.area));
            tempstring = ReplaceEx(tempstring, "[|Rate|]", Convert.ToString(bookingdetail.UnitDetail.rate));
            tempstring = ReplaceEx(tempstring, "[|BasicAmount|]", Convert.ToString(bookingdetail.UnitDetail.basicAmount));
            tempstring = ReplaceEx(tempstring, "[|AdditionalAmount|]", Convert.ToString(bookingdetail.UnitDetail.additionalCharge));
            tempstring = ReplaceEx(tempstring, "[|DiscountAmount|]", Convert.ToString(bookingdetail.UnitDetail.discountAmount));
            tempstring = ReplaceEx(tempstring, "[|CarpetArea|]", Convert.ToString(bookingdetail.UnitDetail.unitCarpetArea));
            tempstring = ReplaceEx(tempstring, "[|CarpetAreaRate|]", Convert.ToString(bookingdetail.UnitDetail.unitCarpetAreaRate));
            tempstring = ReplaceEx(tempstring, "[|UnitBalconyArea|]", Convert.ToString(bookingdetail.UnitDetail.unitBalconyArea));
            tempstring = ReplaceEx(tempstring, "[|UnitBalconyAreaRate|]", Convert.ToString(bookingdetail.UnitDetail.unitBalconyAreaRate));
            tempstring = ReplaceEx(tempstring, "[|UnitCarpetArea|]", Convert.ToString(bookingdetail.UnitDetail.unitCarpetArea));
            tempstring = ReplaceEx(tempstring, "[|UnitCarpetAreaRate|]", Convert.ToString(bookingdetail.UnitDetail.unitCarpetAreaRate));
            tempstring = ReplaceEx(tempstring, "[|BookingAmount|]", Convert.ToString(bookingdetail.BookingAmount));
            tempstring = ReplaceEx(tempstring, "[|SalesPerson|]", bookingdetail.SalesPerson);
            return tempstring;
        }
        private string ReplaceEx(string original, string pattern, string replacement)
        {
            int count, position0, position1;
            count = position0 = position1 = 0;
            string upperString = original.ToUpper();
            string upperPattern = pattern.ToUpper();
            int inc = (original.Length / pattern.Length) *
                      (replacement.Length - pattern.Length);
            char[] chars = new char[original.Length + Math.Max(0, inc)];
            while ((position1 = upperString.IndexOf(upperPattern,
                                              position0)) != -1)
            {
                for (int i = position0; i < position1; ++i)
                    chars[count++] = original[i];
                for (int i = 0; i < replacement.Length; ++i)
                    chars[count++] = replacement[i];
                position0 = position1 + pattern.Length;
            }
            if (position0 == 0) return original;
            for (int i = position0; i < original.Length; ++i)
                chars[count++] = original[i];
            return new string(chars, 0, count);
        }
        public static bool IsEmail(string email)
        {
            /// <summary>
            /// Checks whether the given Email-Parameter is a valid E-Mail address.
            /// </summary>
            /// <param name="email">Parameter-string that contains an E-Mail address.</param>
            /// <returns>True, when Parameter-string is not null and 
            /// contains a valid E-Mail address;
            /// otherwise false.</returns>
            if (email != null && email != "") return System.Text.RegularExpressions.Regex.IsMatch(email, MatchEmailPattern);
            else return false;
        }
    }
}

