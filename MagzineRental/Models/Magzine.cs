using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace MagzineRental.Models
{
    public class Magzine
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Please enter Magzine name")]
        [Display(Name = "Magzine Name")]
        public string Name { get; set; }


        [Required(ErrorMessage = "Please enter Release Date")]
        [Display(Name = "Date of Release")]
        public DateTime? ReleaseDate { get; set; }


        [Required(ErrorMessage = "Please enter no. of stock")]
        [Display(Name = "Number of Stock")]
        [Range(1, 20)]
        public int NumberofStock { get; set; }

        public int NumberAvailable { get; set; }

        [Required(ErrorMessage = "Please select Genre from Dropdown")]
        [Display(Name = "Genre")]
        public Byte GenreId { get; set; }

        public Genre genre { get; set; }

        public Magzine()
        {
            genre = new Genre();
        }
    }
}   