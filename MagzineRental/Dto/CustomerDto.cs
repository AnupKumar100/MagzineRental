using MagzineRental.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace MagzineRental.Dto
{
    public class CustomerDto
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Enter customer name")]
        public String Name { get; set; }


        public bool IsSubscribedToNewsLetter { get; set; }


        [Min18YearMember2]
        public DateTime? BirthDate { get; set; }


        [Required(ErrorMessage = "Select Membership type")]
        public int MembershipId { get; set; }

        public MembershipTypeDto MembershipType { get; set; }

        public CustomerDto()
        {
            Id = 0;
            MembershipType = new MembershipTypeDto();
        }
    }
}