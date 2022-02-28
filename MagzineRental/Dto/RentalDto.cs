using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagzineRental.Dto
{
    public class RentalDto
    {
        public int CustomerId { get; set; }
        public List<int> MagzinesId { get; set; }

    }
}