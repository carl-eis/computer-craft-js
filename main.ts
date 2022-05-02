import * as event from "./event";

/* =================== Constants ===================*/

const FUEL_TYPES = {
  LAVA_BUCKET: 'minecraft:lava_bucket',
  COAL: 'minecraft:coal',
  CHARCOAL: 'minecraft:charcoal',
  LOG: 'minecraft:log'
}

const INVENTORY_SIZE = 16

const FUEL_BUFFER_AMOUNT = 2

enum DIRECTIONS {
  Down ='DOWN',
  Forwards = 'FORWARDS'
}

/* =================== Helpers ===================*/

function validateArgs(...args) {
  if (args.length === 2) {
    return true
  } else {
    print('Please specify length and width.')
    print('Usage: miner <length> <width>')
    return false
  }
}

function isFuel(index: number): boolean {
  if (turtle.getItemCount(index) === 0) {
    return false
  }
  const data = turtle.getItemDetail(index)
  const { name, damage, count } = data as any

  const isFuelItem = Object.values(FUEL_TYPES).includes(name)
  if (!isFuelItem) {
    return false
  }
  return true
}

function checkFuelExists() {
  let hasFuel = false

  for (let i = 1; i < (INVENTORY_SIZE + 1); i++) {
    if (isFuel(i)) {
      hasFuel = true
      print('Fuel found at slot', i)
      break
    }
  }

  return hasFuel
}

function refillFromAllSlots(fuelRequiredToReturn: number): boolean {
  let fueled = false

  for (let i = 1; i < (INVENTORY_SIZE + 1); i++) {
    if (turtle.getItemCount(i) > 0) {
      turtle.select(i)
      if (turtle.refuel(1)) {
        while (
          turtle.getItemCount(i) > 0
          && turtle.getFuelLevel() < fuelRequiredToReturn
        ) {
          turtle.refuel(1)
        }
        if (turtle.getFuelLevel() >= fuelRequiredToReturn) {
          fueled = true
        }
      }
    }
  }

  turtle.select(1)
  return fueled
}

/* =================== Main ===================*/

class TurtleEngine {
  private hasFuel = false

  private xPos = 0
  private yPos = 0
  private zPos = 0

  // North  0,1
  // East   1,0
  // South  0,-1
  // West   -1,0
  private xDirection = 0
  private zDirection = 1

  private length: number
  private width: number

  constructor(
    len: string, wid: string
  ) {
    this.length = parseInt(len, 10)
    this.width = parseInt(wid, 10)

    this.checkInitialFuel(true)
    if (!this.hasFuel) {
      return
    }
    this.start()
  }

  /**
   * Attempt to refuel until there is enough
   * to return home. Will return false if unsuccessful.
   * @param manualAmount
   */
  attemptRefuel(manualAmount?: number): boolean {
    const fuelLevel = turtle.getFuelLevel()
    if ((fuelLevel as any) === "unlimited") {
      return true
    }

    const fuelRequiredToReturn = manualAmount
      ?? this.xPos + this.zPos + Math.abs(this.yPos) + FUEL_BUFFER_AMOUNT

    if (fuelLevel > fuelRequiredToReturn) {
      return true
    }

    return refillFromAllSlots(fuelRequiredToReturn)
  }

  checkInitialFuel(isInitialCheck = false): void {
    this.hasFuel = checkFuelExists()
    if (!this.hasFuel && isInitialCheck) {
      print('\nNo fuel found. Please add fuel into an inventory slot and try again.')
      return
    }
  }

  tryCollect(): boolean {
    // TODO: Implement collect
    return true
  }

  returnSupplies(): void {
    // TODO: Implement returnSupplies
  }

  unload(keepOneFuelStack: boolean = true): void {
    // TODO: Implement unload
  }

  goTo(x: number, y: number, z: number, xDir: number, zDir: number) {
    // TODO: Implement goTo
  }


  turnLeft() {
    turtle.turnLeft()
    this.xDirection = -this.zDirection
    this.zDirection = this.xDirection
  }

  turnRight() {
    turtle.turnRight()
    this.xDirection = this.zDirection
    this.zDirection = -this.xDirection
  }

  tryDirection(direction: DIRECTIONS): boolean {
    if (!this.attemptRefuel()) {
      print('\nOut of fuel. Returning to surface')
      this.returnSupplies()
    }

    const collectOrReturn = () => {
      if (!this.tryCollect()) {
        print('\nUnable to collect, returning back to base.')
        this.returnSupplies()
      }
    }

    let move: () => boolean
    let detect: () => boolean
    let dig: () => boolean
    let attack: () => boolean

    switch(direction) {
      case DIRECTIONS.Forwards: {
        move = turtle.forward
        detect = turtle.detect
        dig = turtle.dig
        attack = turtle.attack
        break;
      }
      case DIRECTIONS.Down: {
        move = turtle.down
        detect = turtle.detectDown
        dig = turtle.digDown
        attack = turtle.attackDown
      }
      default: {
        break;
      }
    }

    /**
     * If the turtle is blocked,
     * try get past the obstacle by digging or attacking.
     *
     * If it can't collect an item, return back to base.
     */
    while (!move()) {
      if (detect()) {
        if (dig()) {
          collectOrReturn()
        } else {
          print('Unable to dig. Possibly stuck')
          return false
        }
      } else if (attack()) {
        collectOrReturn()
      } else {
        sleep(0.5)
      }
    }

    // Update positions after moving
    switch(direction) {
      case DIRECTIONS.Forwards: {
        this.xPos += this.xDirection
        this.zPos += this.zDirection
        break;
      }
      case DIRECTIONS.Down: {
        this.yPos += 1
        if (this.yPos % 10 === 0) {
          print(`Descended ${this.yPos} metres.`)
        }
        break;
      }
      default: {
        break;
      }
    }

    return true
  }

  start() {
    if (!this.attemptRefuel()) {
      print('Out of fuel.')
      return
    }

    print('Excavating...')

    let reseal = false
    let done = false
    let alternate = 0

    while (!done) {
      for (let length = 1; length < (this.length + 1); length++) {
        for (let width = 1; width < (this.width); width++) {
          if (!this.tryDirection(DIRECTIONS.Forwards)) {
            done = true
            break
          }
        }
        if (done) {
          break
        }
        if (length < (this.length + 1)) {
          if ((length+alternate) % 2 === 0) {
            this.turnLeft()
            if (!this.tryDirection(DIRECTIONS.Forwards)) {
              done = true
              break
            }
            this.turnLeft()
          }
        } else {
          this.turnRight()
          if (!this.tryDirection(DIRECTIONS.Forwards)) {
            done = true
            break
          }
          this.turnRight()
        }
      }

      if (done) {
        break
      }

      if (this.length > 1) {
        if (this.length % 2 === 0) {
          this.turnRight()
        } else {
          if (alternate === 0) {
            this.turnLeft()
          } else {
            this.turnRight()
          }
          alternate = 1 - alternate
        }
      }

      if (!this.tryDirection(DIRECTIONS.Down)) {
        done = true
        break
      }
    }
  }
}

function main(...args) {
  print("\nExcavator Pro by MeguminGG")
  print("https://github.com/sunset-developer")
  print("------------------------------------")
  print("Excavation initiated, please monitor occasionally.")

  if (!validateArgs(...args)) {
    return
  }

  const length = args[0]
  const width = args[1]

  const TurtleInstance = new TurtleEngine(length, width)
}

main(...$vararg)

