function timePara = two_settime(time)

n_Aonset = ceil(time.fix/time.dt); 
n_Aoffset = ceil((time.fix + time.Sdur)/time.dt); 
n_Bonset = ceil((time.fix + time.Sdur + time.SSinter)/time.dt);              
n_Boffset = ceil((time.fix + 2*time.Sdur + time.SSinter)/time.dt); 
n_Ronset = ceil((time.fix + 2*time.Sdur + time.SSinter + time.SRinter)/time.dt);              
n_Roffset = ceil((time.fix + 2*time.Sdur + time.SSinter + time.SRinter + time.Rdur)/time.dt); 

nsecs = time.fix + 2*time.Sdur + time.SSinter + time.SRinter + time.Rdur + time.delay;
simutime = 0:time.dt:nsecs;

timePara.dt = time.dt;
timePara.tau = time.tau;
timePara.Aonset = n_Aonset;
timePara.Aoffset = n_Aoffset;
timePara.Bonset = n_Bonset;
timePara.Boffset = n_Boffset;
timePara.Ronset = n_Ronset;
timePara.Roffset = n_Roffset;
timePara.simuTime = simutime;
