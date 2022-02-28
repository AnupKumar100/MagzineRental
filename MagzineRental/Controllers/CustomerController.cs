using MagzineRental.Models;
using MagzineRental.Models.Data;
using MagzineRental.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MagzineRental.Controllers
{
    public class CustomerController : Controller
    {
        // GET: Customer
        public ActionResult Index()
        {
            ViewBag.delete = Request.QueryString["del"];
            var Customers = CustomerSql.Customers();
            if (User.IsInRole(CanManageData.ManageData))
                return View(Customers);
            else
                return View("IndexReadOnly", Customers);
        }

        public ActionResult New()
        {
            ViewBag.stat = "New";
            var membershiptypes = CustomerSql.GetMembership();
            CustmerViewModel customerviewmodel = new CustmerViewModel()
            {
                membershiptype = membershiptypes
            };
            return View(customerviewmodel);
        }

        [HttpPost, ValidateAntiForgeryToken]
        public ActionResult Save(CustmerViewModel customerviewmodel)
        {
            
            var membershiptypes = CustomerSql.GetMembership();
            customerviewmodel.membershiptype = membershiptypes;
           
            if (ModelState.IsValid)
            {
                try
                {
                    int status = CustomerSql.SaveCustomer(customerviewmodel.customer);

                    if (status > 0)
                    {
                        ViewBag.update = "Data update successfully";
                        ViewBag.state = "0";
                    }
                    else
                    {
                        ViewBag.update = "Error while updating data";
                        ViewBag.state = "1";
                    }
                        


                    if (customerviewmodel.customer.Id == 0)
                    {
                        ViewBag.stat = "New";
                        CustmerViewModel newcustomerviewmodel = new CustmerViewModel()
                        {
                            membershiptype = membershiptypes
                        };

                        return RedirectToAction("Index", "Customer");
                    }
                    else
                    {
                        ViewBag.stat = "Edit";
                        return View("New", customerviewmodel);
                    }

                    
                }
                catch (Exception ep)
                {
                    return Content(ep.ToString());
                }
            }
            else
            {
                //string messages = string.Join("; ", ModelState.Values
                //                        .SelectMany(x => x.Errors)
                //                        .Select(x => x.ErrorMessage));
               // ModelState.AddModelError("", messages);
                if (customerviewmodel.customer.Id == 0)
                {
                    ViewBag.stat = "New";
                }
                else
                {
                    ViewBag.stat = "Edit";
                }
                return View("New", customerviewmodel);
            }
            
            //return View("New");
        }


        public ActionResult Details(int id)
        {
            ViewBag.stat = "Edit";
            var membershiptypes = CustomerSql.GetMembership();
            CustmerViewModel customerviewmodel = new CustmerViewModel()
            {
                customer = CustomerSql.GetCustomerOne(id),
                membershiptype = membershiptypes
            };

            if(customerviewmodel.customer.Id == 0)
            {
                return HttpNotFound();
            }
            return View("New",customerviewmodel);
        }

        [Authorize(Roles = CanManageData.ManageData)]
        public ActionResult Delete(int Id)
        {
            int stats = CustomerSql.DeleteRecord(Id);

            if (stats > 0)
                return Redirect(Url.Content("/Customer/Index?del=1"));
            else
                return Redirect(Url.Content("/Customer/Index?del=2"));
            
        }

        public ActionResult ApiCustomer()
        {
            if (User.IsInRole(CanManageData.ManageData))
                return View();

            return View("ApiCustomerReadOnly");
        }

        public ActionResult NewApi()
        {
            var membershiptypes = CustomerSql.GetMembership();
            CustmerViewModel customerviewmodel = new CustmerViewModel()
            {
                membershiptype = membershiptypes
            };
            return View(customerviewmodel);
        }

        public ActionResult DetailsApi(int id)
        {
            ViewBag.stat = "Edit";
            var membershiptypes = CustomerSql.GetMembership();

            ViewBag.custid = id;
            CustmerViewModel customerviewmodel = new CustmerViewModel()
            {
                //customer = CustomerSql.GetCustomerOne(id),
                membershiptype = membershiptypes
            };

            return View(customerviewmodel);
        }
    }
}