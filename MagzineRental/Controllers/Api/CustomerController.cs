using AutoMapper;
using MagzineRental.Dto;
using MagzineRental.Models;
using MagzineRental.Models.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MagzineRental.Controllers.Api
{
    public class CustomerController : ApiController
    {
        //api/customers

        [HttpGet]
        public IHttpActionResult GetCustomers(string cust_name = null)
        {
            var customerslist = CustomerSql.Customers();
            if(!string.IsNullOrWhiteSpace(cust_name))
            {
                customerslist = customerslist.Where(x => x.Name.Contains(cust_name)).ToList();
            }

            var customersdtos = customerslist.Select(Mapper.Map<Customer, CustomerDto>);
            
            return Ok(customersdtos);
        }


        [HttpGet]
        public IHttpActionResult GetCustomer(int id)
        {
            var customer = CustomerSql.GetCustomerOne(id);
            if(customer.Id == 0)
            {
                return NotFound();
            }

            return Ok(Mapper.Map<Customer, CustomerDto>(customer));
        }

        [HttpPost]
        public IHttpActionResult CreateCustomer(CustomerDto customerdto)
        {
            var customer = Mapper.Map<CustomerDto, Customer>(customerdto);
            if (!ModelState.IsValid)
            {
                return Content(HttpStatusCode.BadRequest, new { Success = false, Message = string.Join("; ", ModelState.Values.SelectMany(x => x.Errors).Select(x => x.ErrorMessage)) });
            }
            else
            {
                int i = CustomerSql.SaveCustomer(customer);
                if(i > 0)
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
        public IHttpActionResult UpdateCustomer(CustomerDto customerdto)
        {
            var customer = Mapper.Map<CustomerDto, Customer>(customerdto);
            if (!ModelState.IsValid)
            {
                return Content(HttpStatusCode.BadRequest, new { Success = false, Message = string.Join("; ", ModelState.Values.SelectMany(x => x.Errors).Select(x => x.ErrorMessage)) });
            }
            else
            {
                int i = CustomerSql.SaveCustomer(customer);
                if (i > 0)
                {
                    return Content(HttpStatusCode.OK, new { Success = true });
                }
                else
                {
                    return Content(HttpStatusCode.InternalServerError, new { Success = false, Message = "Invalid id" });
                }
            }
            //return Ok(Mapper.Map<Customer, CustomerDto>(customer));
        }

        [HttpDelete]
        [Authorize(Roles = CanManageData.ManageData)]
        public IHttpActionResult DeleteCustomer(int Id)
        {
            int stats = CustomerSql.DeleteRecord(Id);
            if(stats > 0)
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
