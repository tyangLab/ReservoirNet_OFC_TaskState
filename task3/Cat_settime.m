function timePara = Cat_settime(time)

n_t1 = ceil(time.t1/time.dt); 
n_delay = ceil(time.delay/time.dt); 
n_sdur = ceil(time.sdur/time.dt);              

nsecs = time.t1+time.sdur+time.delay;
simutime = 0:time.dt:nsecs;

timePara.dt = time.dt;
timePara.tau = time.tau;
timePara.sdur = n_sdur;
timePara.tdelay = n_delay;
timePara.simuTime = simutime;

timePara.trial_on = 1;
timePara.offer_on = n_t1;
timePara.offer_off = timePara.offer_on + timePara.sdur;
timePara.bef_choice = timePara.offer_off + timePara.tdelay;
