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
    public class MagzineController : Controller
    {
        // GET: Magzines
        public ActionResult Index()
        {
            ViewBag.delete = Request.QueryString["del"];
            var Magzines = MagzineSql.Magzines();
            if (User.IsInRole(CanManageData.ManageData))
                return View(Magzines);
            else
                return View("IndexReadOnly", Magzines);
            
        }

        [Authorize(Roles = CanManageData.ManageData)]
        public ActionResult New()
        {
            ViewBag.stat = "New";
            var genretypes = MagzineSql.GetGenre();
            MagzineViewModel Magzineviewmodel = new MagzineViewModel()
            {
                genretypes = genretypes
            };
            return View(Magzineviewmodel);
        }

        public ActionResult Save()
        {
            return RedirectToAction("New", "Magzine");
        }


        [HttpPost, ValidateAntiForgeryToken]
        [Authorize(Roles = CanManageData.ManageData)]
        public ActionResult Save(MagzineViewModel Magzineviewmodel)
        {

            var genretypes = MagzineSql.GetGenre();
            Magzineviewmodel.genretypes = genretypes;

            if (ModelState.IsValid)
            {
                try
                {
                    int status = MagzineSql.SaveMagzine(Magzineviewmodel.Magzine);

                    if (status > 0)
                    {
                        ViewBag.update = "Data update successfully";
                        if (Magzineviewmodel.Magzine.Id == 0)
                        {
                            ViewBag.stat = "New";
                            MagzineViewModel newMagzineviewmodel = new MagzineViewModel()
                            {
                                genretypes = genretypes
                            };

                            return RedirectToAction("Index", "Magzine");
                        }
                        else
                        {
                            ViewBag.stat = "Edit";
                            ViewBag.state = "0";
                            return View("New", Magzineviewmodel);
                        }
                    }

                    else
                    {
                        ViewBag.update = "Error while updating data";
                        if (Magzineviewmodel.Magzine.Id == 0)
                        {
                            ViewBag.stat = "New";
                        }
                        else
                        {
                            ViewBag.stat = "Edit";
                            ViewBag.state = "1";
                        }
                        return View("New", Magzineviewmodel);
                    }

                }
                catch (Exception ep)
                {
                    return Content(ep.ToString());
                }
            }
            else
            {
                if (Magzineviewmodel.Magzine.Id == 0)
                {
                    ViewBag.stat = "New";
                }
                else
                {
                    ViewBag.stat = "Edit";
                }
                return View("New", Magzineviewmodel);
            }
        }


        public ActionResult Details(int id)
        {
            ViewBag.stat = "Edit";
            var genretypes = MagzineSql.GetGenre();
            MagzineViewModel Magzineviewmodel = new MagzineViewModel()
            {
                Magzine = MagzineSql.GetMagzineOne(id),
                genretypes = genretypes
            };
            Magzineviewmodel.Magzine.genre.Name = genretypes.Single(x => x.Id == Magzineviewmodel.Magzine.GenreId).Name;
            
            if (Magzineviewmodel.Magzine.Id == 0)
            {
                return HttpNotFound();
            }

            if (User.IsInRole(CanManageData.ManageData))
                return View("New", Magzineviewmodel);
            else
                return View(Magzineviewmodel);
        }

        [Authorize(Roles = CanManageData.ManageData)]
        public ActionResult Delete(int Id)
        {
            int stats = MagzineSql.DeleteRecord(Id);

            if (stats > 0)
                return Redirect(Url.Content("/Magzine/Index?del=1"));
            else
                return Redirect(Url.Content("/Magzine/Index?del=2"));

        }

        public ActionResult ApiMagzines()
        {
            if (User.IsInRole(CanManageData.ManageData))
                return View();

            return View("ApiMagzinesReadOnly");
        }

        [Authorize(Roles = CanManageData.ManageData)]
        public ActionResult NewApi()
        {
            var genretypes = MagzineSql.GetGenre();
            MagzineViewModel Magzineviewmodel = new MagzineViewModel()
            {
                genretypes = genretypes
            };
            return View(Magzineviewmodel);
        }

        public ActionResult DetailsApi(int id)
        {
            var genretypes = MagzineSql.GetGenre();

            ViewBag.Magzineid = id;
            MagzineViewModel Magzineviewmodel = new MagzineViewModel()
            {
                genretypes = genretypes
            };

            if (User.IsInRole(CanManageData.ManageData))
                return View(Magzineviewmodel);

            return View("DetailsApiReadOnly", Magzineviewmodel);
        }
    }
}