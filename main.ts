import * as event from "./event";
import sleep = os.sleep;

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
  Down = 'DOWN',
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

  return Object.values(FUEL_TYPES).includes(name);
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

  private readonly length: number
  private readonly width: number

  private collected = 0
  private unloaded = 0

  private amountMoves = 0
  private maxMoves = 50

  constructor(
    len: string, wid: string
  ) {
    this.length = parseInt(len, 10)
    this.width = parseInt(wid, 10)
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

  logPosition() {
    return
    print(`current position: x ${this.xPos} z ${this.zPos} y ${this.yPos}`)
    print(`xDir ${this.xDirection} zDir ${this.zDirection}`)
    sleep(0.5)
  }

  /**
   * Check the total against the previous total
   * to see if we have collected anything.
   *
   * Returns true if turtle picked something up.
   */
  tryCollect(): boolean {
    let allSlotsFull = true
    let totalItems = 0

    for (let i = 0; i < INVENTORY_SIZE; i++) {
      const count = turtle.getItemCount(i + 1)
      if (count === 0) {
        allSlotsFull = false
      }
      totalItems += count
    }

    if (totalItems > this.collected) {
      this.collected = totalItems
      if ((this.collected + this.unloaded) % 50 === 0) {
        print(`Mined ${this.collected + this.unloaded} items.`)
      }
    }

    if (allSlotsFull) {
      print('No empty slots left')
      return false
    }

    return true
  }

  returnSupplies(): void {
    const { xPos, yPos, zPos, xDirection, zDirection } = this
    print('Returning to surface...')
    this.goTo(0, 0, 0, 0, -1)

    const fuelNeeded = 2 * (xPos + yPos + zPos) + 1
    if (!this.attemptRefuel(fuelNeeded)) {
      this.unload(true)
      print('Waiting for fuel')
      while (!this.attemptRefuel(fuelNeeded)) {
        event.pullEventAs(event.TurtleInventoryEvent, "turtle_inventory")
      }
    } else {
      this.unload(true)
    }

    print('Resuming mining...')
    this.goTo(xPos, yPos, zPos, xDirection, zDirection)
  }

  unload(keepOneFuelStack: boolean = true): void {
    print('Unloading items...')
    for (let i = 0; i < INVENTORY_SIZE; i++) {
      const slotIndex = i + 1
      let amountItemsInSlot = turtle.getItemCount(slotIndex)

      if (amountItemsInSlot > 0) {
        turtle.select(slotIndex)
        let shouldDrop = true
        if (keepOneFuelStack && turtle.refuel(0)) {
          shouldDrop = false
          keepOneFuelStack = false
        }
        if (shouldDrop) {
          turtle.drop()
          this.unloaded += amountItemsInSlot
        }
      }
    }
    this.collected = 0
    turtle.select(1)
  }

  goTo(x: number, y: number, z: number, xDir: number, zDir: number) {
    // Move up
    while (this.yPos > y) {
      print(`moving up: ${this.xPos} ${this.yPos} ${this.zPos}`)
      if (turtle.up()) {
        this.yPos--
      } else if (turtle.digUp() || turtle.attackUp()) {
        this.tryCollect()
      } else {
        sleep(0.5)
      }
    }

    // move left or right
    if (this.xPos > x) {
      while (this.xDirection != -1) {
        this.turnLeft()
      }
      while (this.xPos > x) {
        print(`moving sideways X: ${this.xPos} ${this.yPos} ${this.zPos}`)
        if (turtle.forward()) {
          this.xPos--
        } else if (turtle.dig() || turtle.attack()) {
          this.tryCollect()
        } else {
          sleep(0.5)
        }
      }
    } else if (this.xPos < x) {
      while (this.xDirection != 1) {
        this.turnLeft()
      }
      while (this.xPos < x) {
        print(`moving sideways X: ${this.xPos} ${this.yPos} ${this.zPos}`)
        if (turtle.forward()) {
          this.xPos++
        } else if (turtle.dig() || turtle.attack()) {
          this.tryCollect()
        } else {
          sleep(0.5)
        }
      }
    }

    // move forward or backwards
    if (this.zPos > z) {
      while (this.zDirection != -1) {
        this.turnLeft()
      }
      while (this.zPos > z) {
        print(`moving sideways Z: ${this.xPos} ${this.yPos} ${this.zPos}`)
        if (turtle.forward()) {
          this.zPos--
        } else if (turtle.dig() || turtle.attack()) {
          this.tryCollect()
        } else {
          sleep(0.5)
        }
      }
    } else if (this.zPos < z) {
      while (this.zDirection != 1) {
        this.turnLeft()
      }
      while (this.zPos < z) {
        print(`moving sideways Z: ${this.xPos} ${this.yPos} ${this.zPos}`)
        if (turtle.forward()) {
          this.zPos++
        } else if (turtle.dig() || turtle.attack()) {
          this.tryCollect()
        } else {
          sleep(0.5)
        }
      }
    }

    // move down
    while (this.yPos < y) {
      print(`moving down: ${this.xPos} ${this.yPos} ${this.zPos}`)
      if (turtle.down()) {
        this.yPos++
      } else if (turtle.digDown() || turtle.attackDown()) {
        this.tryCollect()
      } else {
        sleep(0.5)
      }
    }

    while(this.zDirection != zDir || this.xDirection !== xDir) {
      this.turnLeft()
    }
  }

  turnLeft() {
    turtle.turnLeft()
    const prevXDirection = this.xDirection
    const prevZDirection = this.zDirection

    this.xDirection = -prevZDirection
    this.zDirection = prevXDirection
  }

  turnRight() {
    turtle.turnRight()
    const prevXDirection = this.xDirection
    this.xDirection = this.zDirection
    this.zDirection = -prevXDirection
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

    // if (this.amountMoves >= this.maxMoves) {
    //   print('Stopping due to max moves reached')
    //   this.returnSupplies()
    // }

    let move: () => boolean
    let detect: () => boolean
    let dig: () => boolean
    let attack: () => boolean

    switch (direction) {
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
        break;
      }
      default: {
        break;
      }
    }

    print('before move')
    this.logPosition()

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
    switch (direction) {
      case DIRECTIONS.Forwards: {
        this.xPos += this.xDirection
        this.zPos += this.zDirection
        this.amountMoves++
        break;
      }
      case DIRECTIONS.Down: {
        this.yPos += 1
        if (this.yPos % 10 === 0) {
          print(`Descended ${this.yPos} metres.`)
        }
        this.amountMoves++
        break;
      }
      default: {
        break;
      }
    }

    return true
  }

  tryForwards() {
    return this.tryDirection(DIRECTIONS.Forwards)
  }

  tryDown() {
    return this.tryDirection(DIRECTIONS.Down)
  }

  public start() {
    // this.checkInitialFuel(true)
    // if (!this.hasFuel) {
    //   return
    // }

    if (!this.attemptRefuel()) {
      print('Out of fuel.')
      return
    }

    print('Excavating...')

    let reseal = false
    let done = false
    let alternate = 0

    while (!done) {
      for (let widthMined = 0; widthMined < this.width; widthMined++) {
        for (let lengthMined = 0; lengthMined < this.length - 1; lengthMined++) {
          print('length mined: ', lengthMined)
          if (!this.tryForwards()) {
            done = true
            break
          }
        }

        if (done) {
          break
        }

        print('width mined: ', widthMined)
        if (widthMined < (this.width - 1)) {
          if (((widthMined + 1) + alternate) % 2 === 0) {
            print('turning left')
            this.turnLeft()
            if (!this.tryForwards()) {
              done = true
              break
            }
            print('turning left again')
            this.turnLeft()
          } else {
            print('turning right')
            this.turnRight()
            if (!this.tryForwards()) {
              done = true
              break
            }
            print('turning right again')
            this.turnRight()
          }
        } else {
          print('Repositioning to go down...')
        }
      }

      if (done) {
        break
      }

      if (this.width > 1) {
        if (this.width % 2 === 0) {
          this.turnRight()
        } else {
          if (alternate === 0) {
            this.turnLeft()
            // this.turnLeft()
            // alternate = 1
          } else {
            this.turnRight()
            // this.turnRight()
          }
          alternate = 1 - alternate
        }

      }

      if (!this.tryDown()) {
        done = true
        break
      }
    }
  }
}

function main(...args) {
  print("\nExcavator Pro by MeguminGG")
  print("https://github.com/carl-eis")
  print("------------------------------------")
  print("Excavation initiated, please monitor occasionally.")

  if (!validateArgs(...args)) {
    return
  }

  const length = args[0]
  const width = args[1]

  const TurtleInstance = new TurtleEngine(length, width)
  TurtleInstance.start()
}

main(...$vararg)

