using MagzineRental.Dto;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace MagzineRental.Models
{
    public class Min18YearMember: ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            var customer = (Customer)validationContext.ObjectInstance;
            if(customer.MembershipId == 0 || customer.MembershipId == 1)
            {
                return ValidationResult.Success;
            }
            if(customer.BirthDate == null)
            {
                return new ValidationResult("Birthdate is required");
            }

            var age = System.DateTime.Now.Year - customer.BirthDate.Value.Year;

            return (age >= 18) ? ValidationResult.Success : new ValidationResult("Customer should be at least 18 years old to go on a membership.");
        }

    }

    public class Min18YearMember2 : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            var customerdto = (CustomerDto)validationContext.ObjectInstance;
            if (customerdto.MembershipId == 0 || customerdto.MembershipId == 1)
            {
                return ValidationResult.Success;
            }
            if (customerdto.BirthDate == null)
            {
                return new ValidationResult("Birthdate is required");
            }

            var age = System.DateTime.Now.Year - customerdto.BirthDate.Value.Year;

            return (age >= 18) ? ValidationResult.Success : new ValidationResult("Customer should be at least 18 years old to go on a membership.");
        }

    }
}