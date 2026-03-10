using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Configuration;
using Microsoft.Data.SqlClient;

namespace WorkerSimulation
{
    internal class DatabaseReader
    {

        private string connectionString = "";

        public DatabaseReader()
        {
            connectionString = ConfigurationManager.ConnectionStrings["FogLampDB"].ConnectionString;
        }
        /// <summary>
        /// checks the workers inputted login information with the database
        /// </summary>
        /// <param name="employeeNumber">the employee id</param>
        /// <param name="password">the employee password</param>
        /// <returns>returns if it passed or not</returns>
        public bool checkWorkerLogin(string employeeNumber, string password)
        {
            //creates the connection to the database
            using (SqlConnection connection = new SqlConnection(connectionString))
            //creates the procedure command
            using (SqlCommand command = new SqlCommand("sp_CheckWorkerLogin", connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@EmployeeNumber", employeeNumber);
                command.Parameters.AddWithValue("@WorkerPassword", password);

                connection.Open();

                object result = command.ExecuteScalar();

                //returns the result of the procedure running. login successful or not
                if (result != null && result != DBNull.Value)
                {
                    return Convert.ToBoolean(result);
                }
                //if no connetion to the server was made the login attempt fails automatically
                return false;
            }
        }
        public void binLevelReaderDB()
        {
            // Reads current bin/material levels for the workstation.
            // Used during the simulation loop to determine whether
            // enough materials are available to keep building lamps.
            // May later also read low-bin or alert status if needed.
        }

        public void workerInfoReader()
        {
            // Reads worker information after login.
            // This should likely include worker ID, name,
            // experience level, efficiency rating, and possibly
            // a failure-rate modifier used by the simulation logic.
        }

        public void workStationInfo()
        {
            // Reads workstation and assignment information for the worker.
            // This should determine which workstation the worker is assigned to,
            // whether the station is active, and possibly the station's current state.
            // Could also include workstation-specific settings if needed.
        }

        public void configurationReader()
        {
            // Reads system configuration values used by the simulation.
            // Examples: default lamp build time, simulation speed multiplier,
            // failure thresholds, refresh values, and other admin-set values.
            // This may be read once on startup or refreshed when needed.
        }

        public void orderReader()
        {
            // Reads the current order assigned to the workstation or worker.
            // This should likely include order ID, lamp type, target quantity,
            // completed quantity, failed quantity, and current order status.
            // Used to determine whether production should continue.
        }
    }
}
