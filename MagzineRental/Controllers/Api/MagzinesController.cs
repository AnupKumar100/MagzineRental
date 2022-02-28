using AutoMapper;
using MagzineRental.Models.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using MagzineRental.Dto;
using MagzineRental.Models;

namespace MagzineRental.Controllers.Api
{
    public class MagzinesController : ApiController
    {
        [HttpGet]
        public IHttpActionResult GetMagzines(string mov_name = null)
        {
            var Magzineslist = MagzineSql.Magzines();
            if (!string.IsNullOrWhiteSpace(mov_name))
            {
                Magzineslist = Magzineslist.Where(x => x.Name.Contains(mov_name) && x.NumberAvailable > 0).ToList();
            }
            var Magzinesdto = Magzineslist.Select(Mapper.Map<Magzine, MagzinesDto>);
            return Ok(Magzinesdto);
        }


        [HttpGet]
        public IHttpActionResult GetMagzine(int id)
        {
            var Magzine = MagzineSql.GetMagzineOne(id);
            var genretypes = MagzineSql.GetGenre();
            if (Magzine.Id == 0)
            {
                return NotFound();
            }
            Magzine.genre.Name = genretypes.Single(x => x.Id == Magzine.GenreId).Name;

            return Ok(Mapper.Map<Magzine, MagzinesDto>(Magzine));
        }

        [HttpPost]
        [Authorize(Roles = CanManageData.ManageData)]
        public IHttpActionResult CreateMagzine(MagzinesDto Magzinedto)
        {
            var Magzine = Mapper.Map<MagzinesDto, Magzine>(Magzinedto);
            if (!ModelState.IsValid)
            {
                return Content(HttpStatusCode.BadRequest, new { Success = false, Message = string.Join("; ", ModelState.Values.SelectMany(x => x.Errors).Select(x => x.ErrorMessage)) });
            }
            else
            {
                int i = MagzineSql.SaveMagzine(Magzine);
                if (i > 0)
                {
                    return Content(HttpStatusCode.Created, new { Success = true });
                }
                else
                {
                    return Content(HttpStatusCode.InternalServerError, new { Success = false });
                }
            }
            //return Ok(Mapper.Map<Customer, CustomerDto>(customer));
        }

        [HttpPut]
        [Authorize(Roles = CanManageData.ManageData)]
        public IHttpActionResult UpdateMagzine(MagzinesDto Magzinedto)
        {
            var Magzine = Mapper.Map<MagzinesDto, Magzine>(Magzinedto);
            if (!ModelState.IsValid)
            {
                return Content(HttpStatusCode.BadRequest, new { Success = false, Message = string.Join("; ", ModelState.Values.SelectMany(x => x.Errors).Select(x => x.ErrorMessage)) });
            }
            else
            {
                int i = MagzineSql.SaveMagzine(Magzine);
                if (i > 0)
                {
                    return Content(HttpStatusCode.OK, new { Success = true });
                }
                else
                {
                    return Content(HttpStatusCode.NotAcceptable, new { Success = false, Message = "Invalid Id" });
                }
            }
            //return Ok(Mapper.Map<Customer, CustomerDto>(customer));
        }

        [HttpDelete]
        [Authorize(Roles = CanManageData.ManageData)]
        public IHttpActionResult DeleteMagzine(int Id)
        {
            int stats = MagzineSql.DeleteRecord(Id);
            if (stats > 0)
            {
                return Ok(new { Success = true });
            }
            else
            {
                return NotFound();
            }
        }
    }
}
