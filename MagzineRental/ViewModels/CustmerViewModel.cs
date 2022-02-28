using MagzineRental.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagzineRental.ViewModels
{
    public class CustmerViewModel
    {
        public Customer customer { get; set; }
        public IEnumerable<MemberShipType> membershiptype { get; set; }

       public CustmerViewModel()
        {
            customer = new Customer();
        }
    }
}