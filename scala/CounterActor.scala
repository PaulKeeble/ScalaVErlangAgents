import scala.actors.Actor

case class GetAndReset
case class AddCount(number:Long)

class CounterActor extends Actor {
  var count: Long = 0

  def act() {
    loop {
      react {
        case GetAndReset() =>
          val current = count
          count = 0
          reply(current)
        case AddCount(extraCount) =>
          count=count+extraCount
      }
    }
  }
  start()
}