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
  Forwards = 'FORWARDS',
  Up = 'UP'
}

enum PROGRAMS {
  MINE = 'mine',
  TUNNEL = 'tunnel',
  FLOOR = 'floor'
}

const PROGRAM_DESCRIPTIONS = {
  [PROGRAMS.MINE]: {
    usage: 'mine <length> <width>',
    amountArguments: [3],
    description: 'Mine directly down to bedrock in a cuboid shape',
    shortDescription: 'quarry (downwards)'
  },
  [PROGRAMS.TUNNEL]: {
    usage: 'tunnel <width> <height> <length>',
    amountArguments: [4],
    description: 'Tunnel forward in the specified cuboid shape',
    shortDescription: 'dig forwards'
  },
  [PROGRAMS.FLOOR]: {
    usage: 'floor <width> <length> <shift?>',
    amountArguments: [3,4],
    description: 'Place object used as floor in slot 2. Builds a floor.',
    shortDescription: 'build a floor'
  },
}

/* =================== Helpers ===================*/

function getDirection(xDir: number, zDir: number): string {
  // North  0,1
  // East   1,0
  // South  0,-1
  // West   -1,0
  if (xDir === 0) {
    if (zDir === 1) {
      return 'NORTH'
    } else if (zDir === 0) {
      return 'SOUTH'
    }
  }
  if (xDir === 1) {
    if (zDir === 0) {
      return 'EAST'
    } else if (zDir === 1) {
      return 'WEST'
    }
  }

  return 'UNKNOWN'
}

function isFuel(index: number): boolean {
  if (turtle.getItemCount(index) === 0) {
    return false
  }

  const data = turtle.getItemDetail(index)
  const { name } = data as any

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

function getSlotContainingItem(floorItem: string): number {
  for (let i = 0; i < (INVENTORY_SIZE); i++) {
    if (turtle.getItemCount(i+1) > 0) {
      const data = turtle.getItemDetail(i+1)
      const { name } = data as any

      if (floorItem === name) {
        return i + 1
      }
    }
  }

  return -1
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
  private selectedProgram: string
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
  private height: number

  private collected = 0
  private unloaded = 0

  private amountMoves = 0
  private maxMoves = 50

  private readonly cliArguments: string[]

  constructor(
    ...args
  ) {
    this.cliArguments = args

    // Defaults
    this.height = 0
    this.length = 0
    this.width = 0

    this.tryUp = this.tryUp.bind(this)
    this.tryDown = this.tryDown.bind(this)
    this.tryForwards = this.tryForwards.bind(this)

    this.turnRight = this.turnRight.bind(this)
    this.turnLeft = this.turnLeft.bind(this)
  }

  validateArgs = () => {
    const programName: PROGRAMS = this.cliArguments[0] as PROGRAMS
    const possiblePrograms = Object.keys(PROGRAM_DESCRIPTIONS)

    const printHelp = () => {
      print('Please choose a program.\n')
      Object.keys(PROGRAM_DESCRIPTIONS).forEach((key) => {
        const { shortDescription } = PROGRAM_DESCRIPTIONS[key]
        print(`${key} - ${shortDescription}`)
      })
    }

    if (!possiblePrograms.includes(programName)) {
      term.clear()
      printHelp()
      return false
    }

    const selectedDescription = PROGRAM_DESCRIPTIONS[programName]
    if (!selectedDescription) {
      term.clear()
      printHelp()
      return false
    }

    if (!selectedDescription.amountArguments.includes(this.cliArguments.length)) {
      term.clear()
      print('Usage:')
      print('- ' + selectedDescription.usage)
      print(`\n${selectedDescription.description}`)
      return false
    }

    this.selectedProgram = programName
    return true
  }

  logPosition = () => {
    print(`${this.xPos}x ${this.yPos}y ${this.zPos}z facing ${getDirection(this.xDirection, this.zDirection)}`)
  }

  /**
   * Attempt to refuel until there is enough
   * to return home. Will return false if unsuccessful.
   * @param manualAmount
   */
  attemptRefuel = (manualAmount?: number): boolean => {
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

  checkInitialFuel = (isInitialCheck = false): void => {
    this.hasFuel = checkFuelExists()
    if (!this.hasFuel && isInitialCheck) {
      print('\nNo fuel found. Please add fuel into an inventory slot and try again.')
      return
    }
  }

  /**
   * Check the total against the previous total
   * to see if we have collected anything.
   *
   * Returns true if turtle picked something up,
   * or if there are still empty slots available
   */
  tryCollect = (): boolean => {
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
  };

  returnSupplies = (resume = true): void => {
    const { xPos, yPos, zPos, xDirection, zDirection } = this
    print('Returning to surface...')
    this.goTo(0, 0, 0, 0, -1)

    if (!resume) {
      this.unload(true)
      this.turnRight()
      this.turnRight()
      return
    }

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
  };

  unload = (keepOneFuelStack: boolean = true): void => {
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
  };

  goTo = (x: number, y: number, z: number, xDir: number, zDir: number) => {
    // Move up
    while (this.yPos > y) {
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
  };

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

  collectOrReturn = () => {
    if (!this.tryCollect()) {
      print('\nUnable to collect, returning back to base.')
      this.returnSupplies()
    }
  }

  tryDirection = (direction: DIRECTIONS): boolean => {
    if (!this.attemptRefuel()) {
      print('\nOut of fuel. Returning to surface')
      this.returnSupplies()
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
      case DIRECTIONS.Up: {
        move = turtle.up
        detect = turtle.detectUp
        dig = turtle.digUp
        attack = turtle.attackUp
        break;
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
          this.collectOrReturn()
        } else {
          print('Unable to dig. Possibly stuck')
          return false
        }
      } else if (attack()) {
        this.collectOrReturn()
      } else {
        sleep(0.1)
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
      case DIRECTIONS.Up: {
        this.yPos -= 1
        this.amountMoves++
        break;
      }
      default: {
        break;
      }
    }

    return true
  };

  tryForwards = () => this.tryDirection(DIRECTIONS.Forwards);

  tryDown = () => this.tryDirection(DIRECTIONS.Down);

  tryUp = () => this.tryDirection(DIRECTIONS.Up);

  dig = () => {
    if (!this.attemptRefuel()) {
      print('Out of fuel.')
      return
    }

    print('Digging...')

    let done = false
    let alternate = 0

    while (!done) {
      for (let widthMined = 0; widthMined < this.width; widthMined++) {
        for (let lengthMined = 0; lengthMined < this.length - 1; lengthMined++) {
          if (!this.tryForwards()) {
            done = true
            break
          }
        }

        if (done) {
          break
        }

        if (widthMined < (this.width - 1)) {
          if (((widthMined + 1) + alternate) % 2 === 0) {
            this.turnLeft()
            if (!this.tryForwards()) {
              done = true
              break
            }
            this.turnLeft()
          } else {
            this.turnRight()
            if (!this.tryForwards()) {
              done = true
              break
            }
            this.turnRight()
          }
        }
      }

      if (done) {
        break
      }

      if (this.width > 1) {
        this.turnRight()
        this.turnRight()
        if (this.width % 2 !== 0) {
          alternate = 1 - alternate
        }
      }

      if (!this.tryDown()) {
        done = true
        break
      }
    }
  };

  tunnel = () => {
    if (!this.attemptRefuel()) {
      print('Out of fuel.')
      return
    }

    print('Tunneling...')

    let done = false
    let alternate = 0
    let isMiningUp = true

    if (!this.tryForwards()) {
      return
    }

    this.turnRight()

    for (let lengthMined = 0; lengthMined < this.length; lengthMined++) {
      for (let widthMined = 0; widthMined < this.width; widthMined++) {
        for (let heightMined = 0; heightMined < this.height - 1; heightMined++) {
          let miningMethod = isMiningUp ? this.tryUp : this.tryDown
          if (!miningMethod()) {
            done = true
            break
          }
        }

        isMiningUp = !isMiningUp

        if (widthMined < this.width - 1) {
          if (!this.tryForwards()) {
            done = true
            break
          }
        }
      }

      if (lengthMined < this.length - 1) {
        // Face forwards
        const turnDirection = alternate === 0 ? this.turnLeft : this.turnRight
        turnDirection()
        if (!this.tryForwards()) {
          done = true
          break
        }
        turnDirection()
        alternate = 1 - alternate
      }
    }

    print('Job complete, returning.')
    this.returnSupplies(false)
  };

  floor = (shiftOne = false) => {
    let selectedFloorType: string
    let done = false

    if (turtle.getItemCount(2) > 0) {
      const { name } = (turtle.getItemDetail(2) as any)
      selectedFloorType = name
    } else {
      print('Please place a building material in block 2!')
      done = true
      return
    }

    print(`Selected floor type: ${selectedFloorType}`)

    if (!this.attemptRefuel()) {
      print('Out of fuel.')
      return
    }

    const itemSlot = getSlotContainingItem(selectedFloorType)
    if (itemSlot === -1) {
      print('No floor items found!')
      return
    }

    turtle.select(itemSlot)
    // Move forward once block from starting position, if desired
    if (shiftOne) {
      this.tryForwards()
    }

    this.turnRight()

    const placeFloor = (): boolean => {
      if (!turtle.placeDown()) {
        const itemSlot = getSlotContainingItem(selectedFloorType)
        if (itemSlot === -1) {
          print('No building materials remaining!')
          done = true
          return
        } else {
          turtle.select(itemSlot)
        }

        if (turtle.detectDown()) {
          // Blocks are the same, no need to place
          if (turtle.compareDown()) {
            return
          }

          // Blocks are different, dig first
          if (turtle.digDown()) {
            this.collectOrReturn()
          } else {
            print('Unable to dig. Possibly stuck')
            return false
          }
        } else if (turtle.attackDown()) {
          this.collectOrReturn()
        } else {
          sleep(0.1)
        }

        if (!turtle.placeDown()) {
          return false
        }
      }
    }

    let lengthMoved = 0
    let alternate = 0

    while (lengthMoved < this.length && !done) {
      let j = 0;
      while (j < this.width - 1 && !done) {
        placeFloor()
        if (done) {
          break
        }
        this.tryForwards()
        j++
      }

      let turn = alternate === 1 ? this.turnRight : this.turnLeft

      turn()
      placeFloor()
      if (done) {
        break
      }

      if (lengthMoved < this.length - 1) {
        if (!this.tryForwards()) {
          break
        }
        placeFloor()
        if (done) {
          break
        }
        turn()
      } else {
        done = true
      }

      alternate = 1 - alternate
      lengthMoved++
    }

    print('Job complete, returning.')
    this.logPosition()

    this.returnSupplies(false)
  }

  public runSelectedProgram = () => {
    switch(this.selectedProgram) {
      case PROGRAMS.MINE: {
        this.length = parseInt(this.cliArguments[1], 10)
        this.width = parseInt(this.cliArguments[2], 10)

        this.dig()
        return
      }
      case PROGRAMS.TUNNEL: {
        this.width = parseInt(this.cliArguments[1], 10)
        this.height = parseInt(this.cliArguments[2], 10)
        this.length = parseInt(this.cliArguments[3], 10)

        this.tunnel()
        return
      }
      case PROGRAMS.FLOOR: {
        this.width = parseInt(this.cliArguments[1], 10)
        this.length = parseInt(this.cliArguments[2], 10)
        const shiftOne = (this.cliArguments[3] === 'true')

        this.floor(shiftOne)
        return
      }
      default: {
        return
      }
    }
  };
}

function main(...args) {
  print("\nExcavator Pro by Megumin_GG")
  print("https://github.com/carl-eis/computer-craft-js")
  print("------------------------------------")

  const TurtleInstance = new TurtleEngine(...args)
  if (!TurtleInstance.validateArgs()) {
    return
  }

  TurtleInstance.runSelectedProgram()
}

main(...$vararg)

