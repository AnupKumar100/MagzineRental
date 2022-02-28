using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagzineRental.Models
{
    public class MemberShipType
    {
        public byte Id { get; set; }
        public string Name { get; set; }
        public DateTime DurationInMonths { get; set; }
        public byte DiscountRate { get; set; }

    }
}