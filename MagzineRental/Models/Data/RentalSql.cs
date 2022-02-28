using MagzineRental.Models.General;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagzineRental.Models.Data
{
    public class RentalSql
    {
        public static void AddRental(int cust_id, List<int> Magzine_id)
        {
            using (SqlConnection conn = new SqlConnection(Appsettings.Connection()))
            {
                conn.Open();
                foreach (int Magzineid in Magzine_id)
                {
                    try
                    {
                        SqlCommand cmd = new SqlCommand("insertRental", conn);
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@cust_id", cust_id);
                        cmd.Parameters.AddWithValue("@mag_id", Magzineid);
                        int a = cmd.ExecuteNonQuery();
                        
                    }
                    catch (Exception et)
                    {
                        Console.WriteLine(et.ToString());
                    }
                }
            }
        }
    }
}