#!/usr/bin/env python
import rhoban
import time
import math
import sys
import numpy as np
import pybullet as p
from simulation import Simulation

h = rhoban.execute()
sim = Simulation(field=True)
sim.spawnBall('right')
sim.setRobotPos(0, 0, 0)
sim.setBallPos(0.25, -0.05)
rhio = rhoban.PyRhio()
lastUpdate = -1
lastLeft = None
lastLeftOrn = 0

supportFoot = 'left'

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

      # Setting the position and pose of robot
      pose = sim.getRobotPose()
      h.setFakeIMU(pose[1][0], pose[1][1], pose[1][2])
      h.setFakePosition(pose[0][0], pose[0][1], pose[1][0])

      # Setting position of the ball
      ballPos = sim.getBallPos()
      h.setFakeBallPosition(ballPos[0], ballPos[1])

      # Setting the pressure
      pressure = sim.footSensorState()
      leftWeight = pressure['left']['weight']*100000
      rightWeight = pressure['right']['weight']*100000
      h.setFakePressure(pressure['left']['x'], pressure['left']['y'], leftWeight,
        pressure['right']['x'], pressure['right']['y'], rightWeight)

      # FootStep drawing
      s = None
      if leftWeight > rightWeight*5:
        s = 'left'
        c = [1, 0.5, 0]
      if rightWeight > leftWeight*5:
        s = 'right'
        c = [0, 1, 0.5]
      if s is not None and s != supportFoot:
        supportFoot=s
        frames = sim.getFrames()
        tmp = frames[supportFoot+'_foot_frame']
        pos = tmp[0]
        orn = tmp[1]
        p.addUserDebugLine([pos[0]-0.02, pos[1], pos[2]], [pos[0]+0.02, pos[1], pos[2]], c, 2, 200)
        p.addUserDebugLine([pos[0], pos[1]-0.02, pos[2]], [pos[0], pos[1]+0.02, pos[2]], c, 2, 200)

        if supportFoot == 'left':
          if lastLeft is not None:
            print('DIST: %g %g' % (np.linalg.norm(np.array(pos)-lastLeft), np.rad2deg(orn[2]-lastLeftOrn)))
            sys.stdout.flush()
          lastLeft = np.array(pos)
          lastLeftOrn = orn[2]
      
      # Targeting robot
      # sim.lookAt(pose[0])

  # Reading goal angles
  h.lockScheduler()
  targets = {}
  # Getting joints goal angles
  for name in sim.joints:
    targets[name] = h.getAngle(name)
  h.unlockScheduler()
  sim.setJoints(targets)

  # Updating the simulation
  sim.tick()
   
  # Slow down
  # time.sleep(0.005)
