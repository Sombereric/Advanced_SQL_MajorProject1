using System.Text.RegularExpressions;

namespace WorkerSimulation
{
    internal class Program
    {
        //the pattern for employee id to not allow anything but numbers. similar to conestoga ID
        private static string pattern = @"^[0-9]+$";
        private static DatabaseReader databaseReader = new DatabaseReader();
        static void Main(string[] args)
        {
            bool stopProgram = false;

            while (!stopProgram)
            {
                Console.Clear();
                Console.WriteLine("___Please_Login___");
                Console.WriteLine("___enter_stop_to_exit___");
                Console.Write("EmployeeId: ");

                string userID = Console.ReadLine() ?? "";
                stopProgram = exitProgram(userID);
                if (stopProgram)
                {
                    break;
                }

                if (!Regex.IsMatch(userID, pattern))
                {
                    Console.WriteLine("Employee Id Must be numeric. Press enter to continue:");
                    Console.ReadKey();
                    continue;
                }

                Console.Clear();
                Console.WriteLine("___Please_Enter_Password");
                Console.WriteLine("___enter_stop_to_exit___");
                Console.Write("Password: ");
                string userPassword = Console.ReadLine() ?? "";
                stopProgram = exitProgram(userPassword);
                if (stopProgram)
                {
                    break;
                }

                if (userPassword.Length == 0)
                {
                    Console.WriteLine("Password must not be empty. Press enter to continue:");
                    Console.ReadKey();
                    continue;
                }

                //now checks the database if the password is correct or not.
                if (databaseReader.checkWorkerLogin(userID, userPassword))
                {
                    Console.WriteLine("Login Successful! press enter to start simulation: ");
                    Console.ReadKey();

                    WorkStationSimulation workStationSimulation = new WorkStationSimulation();
                    workStationSimulation.workStationSimulationRunner();

                    break;
                }
                else
                {
                    Console.WriteLine("Invalid Login");
                    Console.ReadKey();
                }
            }
        }
        /// <summary>
        /// Checks user input to determine if they entered stop to shut the workstation simulation down
        /// </summary>
        /// <param name="message">the message the user inputted</param>
        /// <returns>returns whether the program shuold stop or not</returns>
        static private bool exitProgram(string message)
        {
            message = message.Trim().ToLower();
            return message == "stop";
        }
    }
}
