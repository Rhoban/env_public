#!/usr/bin/env python
import rhoban
import time
import math
import sys
import pybullet as p
from simulation import Simulation

h = rhoban.execute()
sim = Simulation(field=True)
sim.spawnBall('right')
sim.setRobotPos(0, 0, 0)
sim.setBallPos(0.25, -0.05)
rhio = rhoban.PyRhio()
lastUpdate = -1

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

      # Setting the IMU
      pose = sim.getRobotPose()
      yaw = pose[1][2]+math.pi/2
      pitch = -(pose[1][0]-math.pi)
      if pitch > math.pi:
        pitch -= 2*math.pi
      roll = pose[1][0]+math.pi
      if roll > math.pi:
        roll -= 2*math.pi
      h.setFakeIMU(yaw, pitch, roll)

      # Setting the position of the robot and the ball
      h.setFakePosition(pose[0][0], pose[0][1], yaw)
      ballPos = sim.getBallPos()
      h.setFakeBallPosition(ballPos[0], ballPos[1])

      # Setting the pressure
      pressure = sim.footSensorState()
      leftWeight = pressure['left']['weight']*100000
      rightWeight = pressure['right']['weight']*100000
      h.setFakePressure(pressure['left']['x'], pressure['left']['y'], leftWeight,
        pressure['right']['x'], pressure['right']['y'], rightWeight)

      # FootStep drawing
      # if leftWeight > rightWeight:
      #   s = 'left'
      # else:
      #   s = 'right'
      # if s != supportFoot:
      #   supportFoot=s
      #   frames = sim.getFrames()
      #   pos = frames[supportFoot+'_foot_frame'][0]
      #   p.addUserDebugLine([pos[0]-0.02, pos[1], pos[2]], [pos[0]+0.02, pos[1], pos[2]], [1, 0.5, 0], 2, 20)
      #   p.addUserDebugLine([pos[0], pos[1]-0.02, pos[2]], [pos[0], pos[1]+0.02, pos[2]], [1, 0.5, 0], 2, 20)

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
