<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

;function table for the IR

gicon   ftgen     1, 0, -sr, 2, 0
giblank ftgen     2, 0, -sr, 2, 0

seed 0

opcode raytrace, 0, iiiiiiiiop

ixcod, iycod, ilength, ibreadth, iraydensity, ireflectionorder, idiffusion, iabsorption, icount, icount2  xin

;idivider to divide 0 - 360 degree equally based on the desired ray density

idivider =  iraydensity/358

ideg = (icount+0.1)/idivider

irad = ideg*($M_PI)/180

tableiw  1, 0, gicon

;icx and icy are the coordinates for the origin of the ray

icx = ixcod
icy = iycod

;iux and iuy are the coordinates for the unit cirlce drawn from the point of origin of the ray

iux = icx+cos(irad)
iuy = icy+sin(irad)

iraytotallength = 0
irefelections = 1

;line equation of the north boundary

iy = ibreadth/2

;iix and iiy are the intersection point of the ray and the boundaries

iiy = iy

it = (iiy-icy)/(iuy-icy)

iix = (1-it)*icx + it*iux

;check whether the intersection point is whithin the boundary length

if ((iix >= 0) && (iix <= ilength)) && ((ideg > 0) && (ideg < 180)) then

ia = iix-icx
ib = iiy-icy

;pythagorean theorem to calculate the length of the ray

iraylength = sqrt((ia*ia)+(ib*ib))

iraytotallength += iraylength

irefelections += 1

; to randomize the reflected ray's angle

iran random 1, idiffusion

; angle of the reflected ray

ideg = 360-ideg + iran

irad = ideg*($M_PI)/180

;the point of intersection is the point of origin for the new reflected ray

icx = iix
icy = iiy

;coordinates of the unit circle drawn from the origin of the reflected ray

iux = icx+cos(irad)
iuy = icy+sin(irad)

else 

;line equation of the east boundary,  repeat the whole process to find intersection point

ix = ilength

iix = ix

it = (iix-icx)/(iux-icx)

iiy = (1-it)*icy + it*iuy

if ((iiy >= -ibreadth/2) && (iiy <= ibreadth/2)) && (((ideg >= 0) && (ideg < 90)) || ((ideg > 270) && (ideg <= 360))) then 

ia = iix-icx
ib = iiy-icy

iraylength = sqrt((ia*ia)+(ib*ib))

iraytotallength += iraylength

irefelections += 1

iran random 1, idiffusion

ideg = 360-ideg + iran

irad = ideg*($M_PI)/180

icx = iix
icy = iiy

iux = icx+cos(irad)
iuy = icy+sin(irad)

else

;line equation of the south boundary,  repeat the whole process to find intersection point

iy = -ibreadth/2

iiy = iy

it = (iiy-icy)/(iuy-icy)

iix = (1-it)*icx + it*iux

if ((iix >= 0) && (iix <= ilength)) && ((ideg > 180) && (ideg < 360)) then


ia = iix-icx
ib = iiy-icy

iraylength = sqrt((ia*ia)+(ib*ib))

iraytotallength += iraylength

irefelections += 1

iran random 1, idiffusion

ideg = 360-ideg + iran

irad = ideg*($M_PI)/180

icx = iix
icy = iiy

iux = icx+cos(irad)
iuy = icy+sin(irad)

else

;line equation of the west boundary,  repeat the whole process to find intersection point

ix = 0.0

iix = ix

it = (iix-icx)/(iux-icx)

iiy = (1-it)*icy + it*iuy

if ((iiy >= -ibreadth/2) && (iiy < -0.1) || (iiy > 0.1) && (iiy <= ibreadth/2)) && ((ideg > 90) && (ideg < 270)) then

ia = iix-icx
ib = iiy-icy

iraylength = sqrt((ia*ia)+(ib*ib))

iraytotallength += iraylength

irefelections += 1

iran random 1, idiffusion

ideg = 360-ideg + iran

irad = ideg*($M_PI)/180

icx = iix
icy = iiy

iux = icx+cos(irad)
iuy = icy+sin(irad)

else

;since the listener lies on the west boundary, check whether the ray hits the listener

if (iiy >= -0.1) && (iiy <= 0.1) then 

ia = iix-icx
ib = iiy-icy

iraylength = sqrt((ia*ia)+(ib*ib))

;calculates the total distance the ray has travelled before reaching the listener

iraytotallength += iraylength

;calculates the time it took to reach the listener

itime = iraytotallength/340

;based on the time, calculates the index on which the echo has to be written

iindex = 44100 * itime

iindex = int (iindex)

;based on the no of reflections, the amount of sound energy absorption is calculated

ivalue = 1-(iabsorption*irefelections)

ivalue = ivalue >= 0 ? ivalue : 0

;based on the no of reflections, the phase of the reflected ray is calculated

ifraction = frac (irefelections/2)

ivalue = ifraction = 0 ? ivalue : -ivalue

;writes the value in the ftable

tableiw ivalue, iindex, gicon

igoto loopend

endif
endif
endif 
endif
endif


;loop the whole process to calculate consecutive reflections

while icount2 < ireflectionorder do

iy = ibreadth/2

iiy = iy

it = (iiy-icy)/(iuy-icy)

iix = (1-it)*icx + it*iux

if ((iix >= 0) && (iix <= ilength)) && ((iix != icx) && (iiy !=icy)) then

ia = iix-icx
ib = iiy-icy

iraylength = sqrt((ia*ia)+(ib*ib))

iraytotallength += iraylength

irefelections += 1

iran random 1, idiffusion

ideg = 360-ideg + iran

irad = ideg*($M_PI)/180

icx = iix
icy = iiy

iux = icx+cos(irad)
iuy = icy+sin(irad)

else 

ix = ilength

iix = ix

it = (iix-icx)/(iux-icx)

iiy = (1-it)*icy + it*iuy

if ((iiy >= -ibreadth/2) && (iiy <= ibreadth/2)) && ((iix != icx) && (iiy !=icy)) then 

ia = iix-icx
ib = iiy-icy

iraylength = sqrt((ia*ia)+(ib*ib))

iraytotallength += iraylength

irefelections += 1

iran random 1, idiffusion

ideg = 360-ideg + iran

irad = ideg*($M_PI)/180

icx = iix
icy = iiy

iux = icx+cos(irad)
iuy = icy+sin(irad)

else

iy = -ibreadth/2

iiy = iy

it = (iiy-icy)/(iuy-icy)

iix = (1-it)*icx + it*iux

if ((iix >= 0) && (iix <= ilength)) && ((iix != icx) && (iiy !=icy)) then


ia = iix-icx
ib = iiy-icy

iraylength = sqrt((ia*ia)+(ib*ib))

iraytotallength += iraylength

irefelections += 1

iran random 1, idiffusion

ideg = 360-ideg + iran

irad = ideg*($M_PI)/180

icx = iix
icy = iiy

iux = icx+cos(irad)
iuy = icy+sin(irad)

else


ix = 0.0

iix = ix

it = (iix-icx)/(iux-icx)

iiy = (1-it)*icy + it*iuy

if ((iiy >= -ibreadth/2) && (iiy < -0.1) || (iiy > 0.1) && (iiy <= ibreadth/2)) && ((iix != icx) && (iiy !=icy)) then

ia = iix-icx
ib = iiy-icy

iraylength = sqrt((ia*ia)+(ib*ib))

iraytotallength += iraylength

irefelections += 1

iran random 1, idiffusion 

ideg = 360-ideg + iran

irad = ideg*($M_PI)/180

icx = iix
icy = iiy

iux = icx+cos(irad)
iuy = icy+sin(irad)

else

if (iiy >= -0.1) && (iiy <= 0.1) then 

ia = iix-icx
ib = iiy-icy

iraylength = sqrt((ia*ia)+(ib*ib))

iraytotallength += iraylength

itime = iraytotallength/340

iindex = 44100 * itime

iindex = int (iindex)

ivalue = 1-(iabsorption*irefelections)

ivalue = ivalue >= 0 ? ivalue : 0

ifraction = frac (irefelections/2)

ivalue = ifraction = 0 ? ivalue : -ivalue

tableiw ivalue, iindex, gicon

igoto loopend

endif
endif
endif 
endif
endif

icount2 += 1

od


loopend:

;call the UDO recursively to trace all the rays

	if icount <iraydensity then
 		  raytrace ixcod, iycod, ilength, ibreadth, iraydensity, ireflectionorder, idiffusion, iabsorption, icount+1, 1
 	endif


endop


instr 1

tableicopy gicon, giblank

ixcoordinate invalue "x"
iycoordinate invalue "y"
ilength  invalue "length"
ibreadth invalue "breadth"
iraydensity   invalue "raydensity"
idiffusion    invalue "diffusion"
iabsorption   invalue "absorption"   
ireflectionorder invalue "reflection"
ireflectionorder = int (ireflectionorder)

ixcod = ixcoordinate*ilength
iycod = iycoordinate*ibreadth

raytrace ixcod, iycod, ilength, ibreadth, iraydensity, ireflectionorder, idiffusion, iabsorption


endin


instr 2

kxcoordinate invalue "x"
kycoordinate invalue "y"
klength  invalue "length"
kbreadth invalue "breadth"

kxcod = kxcoordinate*klength
kycod = kycoordinate*kbreadth

outvalue "newx", kxcod
outvalue "newy", kycod


kreinit	invalue	"reinit"
if trigger:k(kreinit,0.5,1) == 1 then
reinit IRtable
endif
IRtable:
event_i "i",1,0,0


ain,aignore soundin "tha.wav"

;ain mpulse 1, 0

;convolute the input with the IR ftable

aout ftconv ain, gicon, 2048

ain delay ain, 2048/sr

kmix invalue "mix"

amix ntrpol ain, aout, kmix

outs amix, amix

endin


</CsInstruments>
<CsScore>
i 1 0 0
i 2 0 3
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>486</x>
 <y>102</y>
 <width>556</width>
 <height>402</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="background">
  <r>128</r>
  <g>128</g>
  <b>128</b>
 </bgcolor>
 <bsbObject version="2" type="BSBKnob">
  <objectName>diffusion</objectName>
  <x>62</x>
  <y>268</y>
  <width>80</width>
  <height>80</height>
  <uuid>{a92e0991-1c21-4e0d-b5d2-860ab47c566a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>30.00000000</maximum>
  <value>9.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>61</x>
  <y>239</y>
  <width>80</width>
  <height>25</height>
  <uuid>{0e7a22f4-3685-452c-9c4d-39dce018f2b4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>Diffusion</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBKnob">
  <objectName>reflection</objectName>
  <x>159</x>
  <y>268</y>
  <width>80</width>
  <height>80</height>
  <uuid>{f794d996-53d4-4520-a3ee-fd5bedcaa524}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>1.00000000</minimum>
  <maximum>20.00000000</maximum>
  <value>20.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>156</x>
  <y>239</y>
  <width>80</width>
  <height>25</height>
  <uuid>{a27728d7-af29-4c79-9d00-15b435518ed5}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>reflection order</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>diffusion</objectName>
  <x>64</x>
  <y>352</y>
  <width>80</width>
  <height>25</height>
  <uuid>{38ebe898-3820-42ab-b12f-3c3bd2358d3d}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>9.000</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>reflection</objectName>
  <x>160</x>
  <y>353</y>
  <width>80</width>
  <height>25</height>
  <uuid>{0a5dc791-6bc1-4156-8346-84083e39ff95}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>20.000</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>length</objectName>
  <x>280</x>
  <y>70</y>
  <width>20</width>
  <height>135</height>
  <uuid>{f64bea7e-17a2-4db9-9566-f830a83c6436}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>2.00000000</minimum>
  <maximum>25.00000000</maximum>
  <value>25.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>breadth</objectName>
  <x>358</x>
  <y>70</y>
  <width>22</width>
  <height>136</height>
  <uuid>{73529b3a-b3a8-4250-b1c1-ff57cc8671aa}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>2.00000000</minimum>
  <maximum>25.00000000</maximum>
  <value>25.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>249</x>
  <y>44</y>
  <width>80</width>
  <height>25</height>
  <uuid>{9422bdc3-07af-4517-b722-d2acb64b184c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>Length</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>325</x>
  <y>44</y>
  <width>80</width>
  <height>25</height>
  <uuid>{39740a57-1587-4834-948a-38cfb106f6cd}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>Breadth</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>length</objectName>
  <x>255</x>
  <y>206</y>
  <width>80</width>
  <height>25</height>
  <uuid>{06664b66-3b55-48ee-86c8-7ce6eb9625bf}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>25.000</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>breadth</objectName>
  <x>335</x>
  <y>206</y>
  <width>80</width>
  <height>25</height>
  <uuid>{6d362820-a749-430f-8793-cef116cb5bea}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>25.000</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBKnob">
  <objectName>raydensity</objectName>
  <x>251</x>
  <y>268</y>
  <width>80</width>
  <height>80</height>
  <uuid>{a865b505-1e99-40db-8394-cda360585e86}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>100.00000000</minimum>
  <maximum>5000.00000000</maximum>
  <value>5000.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>250</x>
  <y>239</y>
  <width>80</width>
  <height>25</height>
  <uuid>{dbe1678d-b2e2-4873-bbf1-151f4e727c69}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>Ray density</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBKnob">
  <objectName>absorption</objectName>
  <x>348</x>
  <y>268</y>
  <width>80</width>
  <height>80</height>
  <uuid>{78702b95-670d-4977-ba9e-9678e02f0510}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.02500000</minimum>
  <maximum>0.25000000</maximum>
  <value>0.09250000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>345</x>
  <y>239</y>
  <width>80</width>
  <height>25</height>
  <uuid>{a995128f-a994-49dc-a748-fd95d58e6d5d}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>Absorption</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>raydensity</objectName>
  <x>253</x>
  <y>352</y>
  <width>80</width>
  <height>25</height>
  <uuid>{cd1eb259-e16f-405d-b577-1cb89d61c8b3}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>5000.000</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>absorption</objectName>
  <x>349</x>
  <y>353</y>
  <width>80</width>
  <height>25</height>
  <uuid>{c7259472-8adf-4337-b520-1786f92fa0d5}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>0.092</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>x</objectName>
  <x>51</x>
  <y>46</y>
  <width>195</width>
  <height>150</height>
  <uuid>{642b3d6f-52be-4513-93e1-3779d5378704}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>y</objectName2>
  <xMin>0.01000000</xMin>
  <xMax>0.99000000</xMax>
  <yMin>-0.49000000</yMin>
  <yMax>0.49000000</yMax>
  <xValue>0.44220513</xValue>
  <yValue>0.00653333</yValue>
  <type>crosshair</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable group="0" mode="both">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>newx</objectName>
  <x>56</x>
  <y>207</y>
  <width>80</width>
  <height>25</height>
  <uuid>{1c2ada27-c90d-4028-9c10-8b4d75d6fcb0}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>11.055</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>newy</objectName>
  <x>158</x>
  <y>207</y>
  <width>80</width>
  <height>25</height>
  <uuid>{614907a7-3385-4d42-aba3-7d4e4ea3dae2}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>0.163</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBButton">
  <objectName>reinit</objectName>
  <x>442</x>
  <y>291</y>
  <width>100</width>
  <height>30</height>
  <uuid>{6e993bfe-aed0-46cd-b35c-63c716ab06d3}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <type>value</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>Re calculate</text>
  <image>/</image>
  <eventLine>i1 0 10</eventLine>
  <latch>false</latch>
  <latched>false</latched>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>108</x>
  <y>15</y>
  <width>373</width>
  <height>27</height>
  <uuid>{40732665-f388-45c7-b781-c503c2809b71}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>2D Ray Tracing Convolution Reverb</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>16</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBKnob">
  <objectName>mix</objectName>
  <x>433</x>
  <y>97</y>
  <width>80</width>
  <height>80</height>
  <uuid>{b0e73fea-75cc-487e-a33e-2e80dac39561}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>1.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>394</x>
  <y>182</y>
  <width>80</width>
  <height>25</height>
  <uuid>{d3ff2620-24c5-422f-9b52-21b43438e07c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>Dry</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>474</x>
  <y>182</y>
  <width>80</width>
  <height>25</height>
  <uuid>{5ff041df-31b8-403e-b49f-8d4bd1f90c56}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>Wet</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>-11</x>
  <y>111</y>
  <width>80</width>
  <height>25</height>
  <uuid>{3d35f57c-9c17-4522-816d-8cc3993e12b3}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>Listener -</label>
  <alignment>center</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>noborder</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
