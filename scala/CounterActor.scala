import scala.actors.Actor

case class GetAndReset
case class AddCount(number:Long)

class CounterActor extends Actor {
  var count: Long = 0

  def act() {
      react {
        case GetAndReset() =>
          val current = count
          count = 0
          reply(current)
          act
        case AddCount(extraCount) =>
          count=count+extraCount
          act
      }
  }
  start()
}