using MagzineRental.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagzineRental.ViewModels
{
    public class MagzineViewModel
    {
        public Magzine Magzine { get; set; }
        public IEnumerable<Genre> genretypes { get; set; }

        public MagzineViewModel()
        {
            Magzine = new Magzine();
        }
    }
}