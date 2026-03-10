using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WorkerSimulation
{
    internal class WorkStationSimulation
    {
        DatabaseReader databaseReader = new DatabaseReader();
        private bool workStationRunning = true;
        private int lampFailureCounter = 0;
        //once data is gathered begins "creating" foglamps using a timer 
        //the timer is based off of the 60 seconds plus or minus the workers skill

        //logs to the db each time a step is complete.

        //for example
        //fog lamp material gathered (assuming material is available 
        //fog lamp production started
        //fog lamp production complete
        //does a simple random chance to determine if the fog lamp failed or not
        //success log and starts anew if order is incomplete
        //failure is logged and a new order is started
        //if three failures in a row employee stops? 

        //use procedure to add a single fog 
        public void workStationSimulationRunner(/*double WorkerFailureRate*/)
        {
            while (workStationRunning)
            {
                //logs workstation manned (theres someone there)

                //reads the bin levels from the program
                databaseReader.binLevelReaderDB();

                if (binLevelChecker())
                {
                    workStationRunning = false;
                    //log to db about lack of materials for fog lamps
                    break;
                }

                //logs lamp creation started (the fog lamp being actively worked on

                //this sleep simulates the time taken to create a lamp thread
                Thread.Sleep(100);

                if (lampCreationSuccess(WorkerFailureRate))
                {
                    //logs workstation as done
                    //logs a lamp creation
                    lampFailureCounter = 0;
                }
                else
                {
                    //logs workstation as done
                    //logs lamp failure
                    lampFailureCounter++;
                }

                if (lampFailureCounter >= 3)
                {
                    workStationRunning = false;
                    //logs workstation failure and flags employee
                    //stops workstation and stops production
                    //simulates manager beating his ass
                    //flags workstation as broken or stopped
                }
            }
        }
        private bool lampCreationSuccess(double WorkerFailureRate)
        {
            //does a simple number generator to determine the chance of success
            //returns whether it failed or not
            return true;
        }
        private bool binLevelChecker()
        {
            return true;
        }
    }
}
