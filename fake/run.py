#!/usr/bin/env python
import rhoban
import time
import math
import sys
from simulation import Simulation

h = rhoban.execute()
sim = Simulation(field=True)
sim.spawnBall('right')
sim.setRobotPos(0, 0, 0)
sim.setBallPos(0.25, -0.05)
rhio = rhoban.PyRhio()
lastUpdate = -1

while True:
  h.setSchedulerClock(sim.t)

  # Checking data from rhio
  if rhio.hasFriction:
    sim.setFrictions(rhio.lateralFriction, rhio.spinningFriction, rhio.rollingFriction)
    rhio.hasFriction = False
    
  if rhio.hasPos:
    sim.setRobotPos(rhio.posX, rhio.posY, rhio.posTheta)
    rhio.hasPos = False

  if rhio.hasBall:
    sim.setBallPos(rhio.ballX, rhio.ballY)
    rhio.hasBall = False

  if time.time()-lastUpdate > 0.01:
      lastUpdate = time.time()
      pose = sim.getRobotPose()
      yaw = pose[1][2]+math.pi/2
      pitch = -(pose[1][0]-math.pi)
      if pitch > math.pi:
        pitch -= 2*math.pi
      roll = pose[1][0]+math.pi
      if roll > math.pi:
        roll -= 2*math.pi
      h.setFakeIMU(yaw, pitch, roll)
      h.setFakePosition(pose[0][0], pose[0][1], yaw)
      ballPos = sim.getBallPos()
      h.setFakeBallPosition(ballPos[0], ballPos[1])

      # h.setFakePressure(0, 0, 1, 1, 0, 0, 1, 1)

  targets = {}

  h.lockScheduler()
  # Getting joints goal angles
  for name in sim.joints:
    targets[name] = h.getAngle(name)
  h.unlockScheduler()

  sim.setJoints(targets)
  sim.tick()
