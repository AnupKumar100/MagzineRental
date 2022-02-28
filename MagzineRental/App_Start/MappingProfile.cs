using AutoMapper;
using MagzineRental.Dto;
using MagzineRental.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MagzineRental.App_Start
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            Mapper.CreateMap<Customer, CustomerDto>();
            Mapper.CreateMap<CustomerDto, Customer>();
            Mapper.CreateMap<Magzine, MagzinesDto>();
            Mapper.CreateMap<MagzinesDto, Magzine>();
            Mapper.CreateMap<MemberShipType, MembershipTypeDto>();
            Mapper.CreateMap<MembershipTypeDto, MemberShipType>();
            Mapper.CreateMap<Genre, GenreDto>();
            Mapper.CreateMap<GenreDto, Genre>();
        }

        protected override void Configure()
        {
            //throw new NotImplementedException();
        }
    }
}