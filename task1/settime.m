function timePara = settime(time,modelPara)

n_Son = ceil((time.intertrial+time.start)/time.dt);
n_Soff = ceil((time.intertrial+time.start+time.sdur)/time.dt);
if modelPara.simutan
    n_Ron = ceil((time.intertrial+time.start)/time.dt);
    n_Roff = ceil((time.intertrial+time.start+time.sdur)/time.dt);
    time.inter = 0;
    time.rdur = 0;
else
    n_Ron = ceil((time.intertrial+time.start+time.sdur+time.inter)/time.dt);
    n_Roff = ceil((time.intertrial+time.start+time.sdur+time.inter+time.rdur)/time.dt);
end
n_dec = ceil((time.intertrial+time.start+time.sdur+time.inter+time.rdur+time.delay)/time.dt);
nsecs = time.intertrial+time.start+time.sdur+time.inter+time.rdur+time.delay;
simutime = 0:time.dt:nsecs;

timePara.dt = time.dt;
timePara.tau = time.tau;
timePara.Son = n_Son;
timePara.Soff = n_Soff;
timePara.Ron = n_Ron;
timePara.Roff = n_Roff;
timePara.Roff = n_Roff;
timePara.dec = n_dec;

timePara.simuTime = simutime;
