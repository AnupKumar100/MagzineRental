using MagzineRental.Dto;
using MagzineRental.Models.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MagzineRental.Controllers.Api
{
    public class NewRentalController : ApiController
    {
        [HttpPost]
        public IHttpActionResult CreateRental(RentalDto rentaldto )
        {
            if (rentaldto.MagzinesId.Count == 0)
                return BadRequest("No Magzine Ids have been given");

            var cust = CustomerSql.GetCustomerOne(rentaldto.CustomerId);
            if (cust.Id == 0)
                return BadRequest("Customer Id is not valid");

            var Magzines = MagzineSql.Magzines().Where(m => rentaldto.MagzinesId.Contains(m.Id)).ToList();
            if (Magzines.Count != rentaldto.MagzinesId.Count)
                return BadRequest("One or More Magzine ids are invalid");

            int checknumberofMagzines = 0;
            foreach(var mov in Magzines)
            {
                if (mov.NumberAvailable > 0)
                    checknumberofMagzines++;

            }
            if (checknumberofMagzines != rentaldto.MagzinesId.Count)
                return BadRequest("Some Magzines are not available");

            RentalSql.AddRental(rentaldto.CustomerId, rentaldto.MagzinesId);
            return Ok();
            //string CustomerId = rentaldto.CustomerId.ToString();

            ////short cut of using foreach loop here rentaldto.MagzinesId.ToList();
            //string Magzinesid = String.Join(" ", rentaldto.MagzinesId.ToList());

            //return Content(HttpStatusCode.OK, new { Customer_Id = CustomerId , MagzinesId = Magzinesid });
        }
    }
}
