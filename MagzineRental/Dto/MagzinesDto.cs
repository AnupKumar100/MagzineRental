using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace MagzineRental.Dto
{
    public class MagzinesDto
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Please enter Magzine name")]
        public string Name { get; set; }


        [Required(ErrorMessage = "Please enter Release Date")]
        public DateTime? ReleaseDate { get; set; }


        [Required(ErrorMessage = "Please enter no. of stock")]
        [Range(1, 20)]
        public int NumberofStock { get; set; }

        public int NumberAvailable { get; set; }

        [Required(ErrorMessage = "Please select Genre from Dropdown")]
        public Byte GenreId { get; set; }

        public GenreDto genre { get; set; }

        public MagzinesDto()
        {
            genre = new GenreDto();
        }

    }
}