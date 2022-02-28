using MagzineRental.Models.General;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MagzineRental.Models.Data
{
    public class CustomerSql
    {
        public static List<Customer> Customers()
        {
            List<Customer> customers = new List<Customer>();
            using (SqlConnection conn = new SqlConnection(Appsettings.Connection()))
            {
                SqlCommand cmd = new SqlCommand("usp_getCustomer", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Customer cus = new Customer();
                    cus.Id = Convert.ToInt16(reader["Id"]);
                    cus.Name = reader["Name"].ToString();
                    cus.MemberShipType.Id = Convert.ToByte(reader["MemberId"]);
                    cus.MemberShipType.Name = reader["Membername"].ToString();
                    cus.MemberShipType.DiscountRate = Convert.ToByte(reader["DiscountRate"]);
                    customers.Add(cus);
                }
            }

            return customers;
        }


        public static List<MemberShipType> GetMembership()
        {
            List<MemberShipType> membershiptype = new List<MemberShipType>();
            using (SqlConnection conn = new SqlConnection(Appsettings.Connection()))
            {
                SqlCommand cmd = new SqlCommand("usp_getMembership", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    MemberShipType mem = new MemberShipType();
                    mem.Id = Convert.ToByte(reader["Id"]);
                    mem.Name = reader["Name"].ToString();
                    membershiptype.Add(mem);
                }
            }

            return membershiptype;
        }

        public static int SaveCustomer(Customer customer)
        {
            
            using (SqlConnection conn = new SqlConnection(Appsettings.Connection()))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("usp_insert_update_customer", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Id", customer.Id);
                    cmd.Parameters.AddWithValue("@name", customer.Name);
                    cmd.Parameters.AddWithValue("@memberid", customer.MembershipId);
                    cmd.Parameters.AddWithValue("@Birthdate", customer.BirthDate);
                    cmd.Parameters.AddWithValue("@IsSubscribe", customer.IsSubscribedToNewsLetter);
                    conn.Open();

                    int a =cmd.ExecuteNonQuery();
                    return a;
                }
                catch (Exception et)
                {
                    Console.WriteLine(et.ToString());
                    return 0;
                }

            }
        }

        public static Customer GetCustomerOne(int Id)
        {
            Customer customer = new Customer();
            DataSet dataset = new DataSet();
            using (SqlConnection conn = new SqlConnection(Appsettings.Connection()))
            {
                SqlCommand cmd = new SqlCommand("usp_getOneCustomer", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Id", Id);

                SqlDataAdapter sda = new SqlDataAdapter();
                sda.SelectCommand = cmd;
                sda.Fill(dataset, "OneCustomer");
            }
            foreach(DataRow dr in dataset.Tables["OneCustomer"].Rows)
            {
                customer.Id = Convert.ToInt16(dr["Id"]);
                customer.Name = dr["Name"].ToString();
                try
                {
                    customer.BirthDate = Convert.ToDateTime(dr["Birthdate"]);
                }
                catch { }
                customer.MembershipId = Convert.ToInt16(dr["MemberId"]);

                try
                {
                    customer.IsSubscribedToNewsLetter = Convert.ToBoolean(dr["IsSubscribedToNewsLetter"]);
                }
                catch { }
                
            }

            return customer;
        }

        internal static int DeleteRecord(int id)
        {
            int st = 0;
            using(SqlConnection con = new SqlConnection(Appsettings.Connection()))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("usp_deleteRecord", con);
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