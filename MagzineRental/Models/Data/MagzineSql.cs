using MagzineRental.Models.General;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagzineRental.Models.Data
{
    public class MagzineSql
    {
        public static List<Magzine> Magzines()
        {
            List<Magzine> Magzinelist = new List<Magzine>();
            using (SqlConnection conn = new SqlConnection(Appsettings.Connection()))
            {
                SqlCommand cmd = new SqlCommand("usp_getMagzine", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Magzine Mov = new Magzine();
                    Mov.Id = Convert.ToInt16(reader["Id"]);
                    Mov.Name = reader["Name"].ToString();
                    Mov.GenreId = Convert.ToByte(reader["GenreId"]);
                    Mov.NumberofStock = Convert.ToInt16( reader["NumberInStock"]);
                    Mov.NumberAvailable = Convert.ToInt16(reader["NumberAvailable"]);
                    Mov.genre.Name = reader["GenreName"].ToString();
                    Magzinelist.Add(Mov);
                }
            }

            return Magzinelist;
        }

        internal static int SaveMagzine(Magzine Magzine)
        {
            using (SqlConnection conn = new SqlConnection(Appsettings.Connection()))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("usp_insert_update_Magz", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Id", Magzine.Id);
                    cmd.Parameters.AddWithValue("@name", Magzine.Name);
                    cmd.Parameters.AddWithValue("@genreid", Magzine.GenreId);
                    cmd.Parameters.AddWithValue("@realeasedate", Magzine.ReleaseDate);
                    cmd.Parameters.AddWithValue("@stock", Magzine.NumberofStock);
                    conn.Open();

                    int a = cmd.ExecuteNonQuery();
                    return a;
                }
                catch (Exception et)
                {
                    Console.WriteLine(et.ToString());
                    return 0;
                }

            }
        }

        public static List<Genre> GetGenre()
        {
            List<Genre> Genretypes = new List<Genre>();
            using (SqlConnection conn = new SqlConnection(Appsettings.Connection()))
            {
                SqlCommand cmd = new SqlCommand("usp_getGenre", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Genre gen = new Genre();
                    gen.Id = Convert.ToByte(reader["Id"]);
                    gen.Name = reader["Name"].ToString();
                    Genretypes.Add(gen);
                }
            }

            return Genretypes;
        }

        internal static Magzine GetMagzineOne(int Id)
        {
            Magzine Magzine = new Magzine();
            DataSet dataset = new DataSet();
            using (SqlConnection conn = new SqlConnection(Appsettings.Connection()))
            {
                SqlCommand cmd = new SqlCommand("usp_getOneMagz", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Id", Id);

                SqlDataAdapter sda = new SqlDataAdapter();
                sda.SelectCommand = cmd;
                sda.Fill(dataset, "OneMagzine");
            }
            foreach (DataRow dr in dataset.Tables["OneMagzine"].Rows)
            {
                Magzine.Id = Convert.ToInt16(dr["Id"]);
                Magzine.Name = dr["Name"].ToString();
                try
                {
                    Magzine.ReleaseDate = Convert.ToDateTime(dr["ReleaseDate"]);
                }
                catch { }
                Magzine.GenreId = Convert.ToByte(dr["GenreId"]);


                Magzine.NumberofStock =Convert.ToInt16(dr["NumberInStock"]);

            }

            return Magzine;
        }

        internal static int DeleteRecord(int id)
        {
            int st = 0;
            using (SqlConnection con = new SqlConnection(Appsettings.Connection()))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("usp_deleteMagz", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Id", id);
                    con.Open();
                    st = cmd.ExecuteNonQuery();
                }
                catch (Exception et)
                {
                    string exep = et.ToString();
                    st = 0;
                }
            }
            return st;
        }
    }
}