import scala.actors.Actor._
import scala.compat.Platform
import scala.actors.Scheduler

object Client {
  val counter = new CounterActor

  def main(args: Array[String]) {
    runTest(3000000)
    Scheduler.shutdown
  }

  def runTest(msgCount: Int) {
    val start = Platform.currentTime
    val count = theTest(msgCount)
    val finish = Platform.currentTime
    val elapsedTime = (finish - start) / 1000.0

    printf("Count is %s%n",count)
    printf("Test took %s seconds%n", elapsedTime)
    printf("Throughput=%s per sec%n", msgCount / elapsedTime)
  }

  def theTest(msgCount: Int) :Any = {
    val bytesPerMsg = 100
    val updates = (1 to msgCount).par.foreach((x: Int) => counter ! new AddCount(bytesPerMsg))

    val count = counter !? new GetAndReset
    return count
  }
}