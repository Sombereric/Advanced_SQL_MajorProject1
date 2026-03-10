using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Data.SqlClient;

namespace WorkerSimulation
{
    internal class DatabaseReader
    {

        private string connectionString = "";

        public DatabaseReader()
        {
            connectionString = ConfigurationManager.ConnectionStrings["FogLampDB"].ConnectionString;
        }

        public bool checkWorkerLogin(string userID, string userPassword)
        {
            //uses a procedure to read from the database and checks if the password
            //and id match if not return false or true
            //that way passwords and such arent exposed to the outside world
            
            //stub
            return true;
        }
        public void binLevelReaderDB()
        {

        }
    }
}
