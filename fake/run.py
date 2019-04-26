#!/usr/bin/env python
import rhoban
from simulation import Simulation

h = rhoban.execute()
sim = Simulation(field=True)
sim.spawnBall('right')
sim.resetRobot()

while True:
  h.lockScheduler()
  targets = {}
  for name in sim.joints:
    targets[name] = h.getAngle(name)
  h.unlockScheduler()
  print(targets['left_knee'])
  sim.setJoints(targets)
  sim.tick()