using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace MagzineRental.Models
{
    public class Customer
    {
        public int Id { get; set; }

        [Required(ErrorMessage ="Enter customer name")]
        [Display(Name="Customer Name")]
        public String Name { get; set; }

        [Display(Name = "Subscribed to Newsletter?")]
        public bool IsSubscribedToNewsLetter { get; set; }

        [Display(Name="Date of Birth")]
        [Min18YearMember]
        public DateTime? BirthDate { get; set; }

        [Required(ErrorMessage ="Select Membership type")]
        [Display(Name="Membership Type")]
        public int MembershipId { get; set; }
        public MemberShipType MemberShipType { get; set; }

        public Customer()
        {
            Id = 0;
            MemberShipType = new MemberShipType();
        }
    }
}