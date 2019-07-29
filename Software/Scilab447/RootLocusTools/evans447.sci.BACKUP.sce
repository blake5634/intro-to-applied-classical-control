// (modified to remove caption box and find better plot ranges
//    Blake Hannaford, Nov 2013)
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - INRIA - Serge STEER
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function evans447(n,d,kmax)
// Seuil maxi et mini (relatifs) de discretisation en espace
// Copyright INRIA

  smax=0.002;  smin=smax/3;
  nptmax=20000 //nbre maxi de pt de discretisation en k

  //Check calling sequence

  [lhs,rhs]=argn(0)

  if rhs <= 0 then   // demonstration
    n=real(poly([0.1-%i 0.1+%i,-10],"s"));
    d=real(poly([-1 -2 -%i %i],"s"));
    evans(n,d,80);
    return
  end

  select typeof(n)
  case "polynomial"  then
    if rhs==2 then kmax=0,end
  case "rational" then
    if rhs==2 then kmax=d,else kmax=0,end
    [n,d]=n(2:3)
  case "state-space" then
    if rhs==2 then kmax=d,else kmax=0,end
    n=ss2tf(n);
    [n,d]=n(2:3);n=clean(n);d=clean(d);
  else
    error(msprintf(_("%s: Wrong type for input argument #%d: A linear dynamical system or a polynomial expected.\n"),"evans",1));
  end
  if prod(size(n))<>1 then
    error(msprintf(_("%s: Wrong value for input argument #%d: Single input, single output system expected.\n"),"evans",1));
  end
  if degree(n)==0&degree(d)==0 then
    error(msprintf(_("%s: The given system has no poles and no zeros.\n"),"evans"));
  end

  if kmax<=0 then
    nm=min([degree(n),degree(d)])
    fact=norm(coeff(d),2)/norm(coeff(n),2)
    kmax=round(500*fact),
  end
  //
  //Compute the discretization for "k" and the associated roots
  nroots=roots(n);  // don't call them zeros (reserved word for scilab func.)
  poles=roots(d);   // formerly french:  "racines"
  
  // BH for better autoscale set the size scale constant "nrm"
  if nroots==[] then
//    nrm=max([norm(poles,1),norm(roots(d+kmax*n),1)])
    nrm= 2.0* max([norm(poles,1)])
  else
//    nrm=max([norm(poles,1),norm(nroots,1),norm(roots(d+kmax*n),1)])
    nrm= 2.0* max([norm(poles,1),norm(nroots,1)])
  end
  md=degree(d)
 
  disp(n)
  disp(d)
  printf("BH:  Nrm = %8.2f\n", nrm)
  //
  ord=1:md;kk=0;nr=1;k=0;pas=0.99;fin="no";
  klim=gsort(krac2(rlist(n,d,"c")),"g","i") // k value for crossing imag axis
  ilim=1
 // pause
  // smarter beginning point:
//  k = kmax/nptmax;
//  pas = kmax/nptmax;
  
  jbh = 0;  dist = 0.0;
  while fin=="no" then
    jbh = jbh + 1;
    
    // BH: debugging
//    printf("evans447: %d  k: %f, pas: %f, dist: %f\n",jbh,k,pas,dist);
    
    k=k+pas
    r=roots(d+k*n);r=r(ord)
    dist=max(abs(poles(:,nr)-r))/nrm
    //
    point=%f

    if dist < smax then //pas correct
      if k-pas<klim(ilim) & k>klim(ilim) then, // did we cross imag axis?
        k=klim(ilim);
        r=roots(d+k*n);r=r(ord)
        end
      if k>klim(ilim) then 
        ilim=min(ilim+1,size(klim,"*"));  // if we crossed, get next crossing
        end
      point=%t
    else //Too big step or incorrect root order
         // look for a root order that minimize the distance
         ix=1:md
         ord1=[] // ordered list of roots for matching closest
         for ky=1:md
           yy=r(ky)
           mn=10*dist*nrm // initialize to "big" value
           for kx=1:md
             if ix(kx)>0 then
               if  abs(yy-poles(kx,nr)) < mn then
                 mn=abs(yy-poles(kx,nr)) // found new best match
                 kmn=kx
               end
             end
           end
           ix(kmn)=0
           ord1=[ord1 kmn]
         end
         r(ord1)=r
         dist=max(abs(poles(:,nr)-r))/nrm // hopefully now roots are matched
         if dist < smax then  // dist = amount RL has moved
           point=%t,
           ord(ord1)=ord
         else // RL has moved too far
           k=k-pas,pas=pas/1.5      //  reduce step size, pas.
         end
    end
    if dist<smin then
      //KToo small step
      pas=2*pas;
    end
    if point then
      poles=[poles,r];kk=[kk,k];nr=nr+1
      if k>kmax then fin="kmax",end
      if nr>nptmax then fin="nptmax",end
    end
  end
  //draw the axis
  x1 =[nroots;matrix(poles,md*nr,1)];
  xmin=min(real(x1));xmax=max(real(x1))
  ymin=min(imag(x1));ymax=max(imag(x1))
  dx=abs(xmax-xmin)*0.05
  dy=abs(ymax-ymin)*0.05
  if dx<1d-10, dx=0.01,end
  if dy<1d-10, dy=0.01,end
  legs=[],lstyle=[];lhandle=[]
  
  // BH: mods for better ranges
  printf("BH: Modified Plotting Ranges\n")
  xmin = 0.0-nrm;
  ymin = -nrm;
  xmax = nrm;
  ymax = nrm;
  
  rect=[xmin-dx;ymin-dy;xmax+dx;ymax+dy];
  
  f=gcf();
  immediate_drawing= f.immediate_drawing;
  f.immediate_drawing = "off";
  a=gca();
  if a.children==[]
    a.data_bounds=[rect(1) rect(2);rect(3) rect(4)];
    a.axes_visible="on";
    a.title.text=_("EE447 Evans root locus");
    a.x_label.text=_("Real axis");
    a.y_label.text=_("Imaginary axis");
    axes.clip_state = "clipgrf";
  else //enlarge the boundaries
    a.data_bounds=[min(a.data_bounds(1,:),[rect(1) rect(2)]);
                   max(a.data_bounds(2,:),[rect(3) rect(4)])];

  end
  if nroots<>[] then
    xpoly(real(nroots),imag(nroots))
    e=gce();e.line_mode="off";e.mark_mode="on";
    e.mark_size_unit="point";e.mark_size=7;e.mark_style=5;
    legs=[legs; _("open loop zeroes")] 
    lhandle=[lhandle; e];
  end
  if poles<>[] then
    xpoly(real(poles(:,1)),imag(poles(:,1)))
    e=gce();e.line_mode="off";e.mark_mode="on";
    e.mark_size_unit="point";e.mark_size=7;e.mark_style=2;
    legs=[legs;_("open loop poles")] 
    lhandle=[lhandle; e];
  end
  dx=max(abs(xmax-xmin),abs(ymax-ymin));
  //plot the zeros locations


  //computes and draw the asymptotic lines
  m=degree(n);q=md-m
  if q>0 then
    la=0:q-1;
    so=(sum(poles(:,1))-sum(nroots))/q
    i1=real(so);i2=imag(so);
    if prod(size(la))<>1 then
      ang1=%pi/q*(ones(la)+2*la)
      x1=dx*cos(ang1),y1=dx*sin(ang1)
    else
      x1=0,y1=0,
    end
    if md==2,
      if coeff(d,md)<0 then
        x1=0*ones(2),y1=0*ones(2)
      end,
    end;
    if max(k)>0 then
      xpoly(i1,i2);
      e=gce();
      e.line_style=2  // try to make dashed line
      legs=[legs;_("asymptotic directions")] 
      lhandle=[lhandle; e];
      a.clip_state = "clipgrf";
      for i=1:q
          xsegs([i1,x1(i)+i1],[i2,y1(i)+i2])
          e=gce();
          e.line_style=2  // try to make dashed line
          end
      //      a.clip_state = "off";
    end
  end;

  [n1,n2]=size(poles);

  // assign the colors for each root locus
  cmap=f.color_map;cols=1:size(cmap,1);
  if a.background==-2 then
    cols(and(cmap==1,2))=[]; //remove white
  elseif a.background==-1 then
    cols(and(cmap==0,2))=[]; //remove black
  else
    cols(a.background)=[];
  end
  cols=cols(modulo(0:n1-1,size(cols,"*"))+1);

  //draw the root locus
  xpolys(real(poles)',imag(poles)',cols)
  //set info for datatips
  E=gce();

//  commented by BH: these lines broken
// for k=1:size(E.children,"*")
//   datatipInitStruct(E.children(k),"formatfunction","formatEvansTip","K",kk)
// end
  
 for k=1:size(E.children,"*")
     E.children(k).display_function = "formatEvansTip";
     E.children(k).display_function_data = kk;
 end
// BH: uncomment these two lines to get back the (annoying) captions box!
//  c=captions(lhandle,legs($:-1:1),"in_upper_right")
//  c.background=a.background;

  f.immediate_drawing = immediate_drawing;

  if fin=="nptmax" then
    warning(msprintf(gettext("%s: Curve truncated to the first %d discretization points.\n"),"evans",nptmax))
  end

endfunction
function str=formatEvansTip(curve)
    //this function is called by the datatip mechanism to format the tip
    //string for the evans root loci curves
    ud = curve.parent.display_function_data;
    pt = curve.data(1:2);
    [d,ptp,i,c]=orthProj(curve.parent.data, pt);
    K=ud(i)+(ud(i+1)-ud(i))*c;
    str=msprintf("r: %.4g %+.4g i\nK: %.4g", pt,K);
endfunction
//
//function str=formatEvansTip(curve,pt,index)
////this function is called by the datatip mechanism to format the tip
////string for the evans root loci curves
//  ud=datatipGetStruct(curve);
//  if index<>[] then
//    K=ud.K(index)
//  else //interpolated
//    [d,ptp,i,c]=orth_proj(curve.data,pt)
//    K=ud.K(i)+(ud.K(i+1)-ud.K(i))*c
//  end
//  str=msprintf("r: %.4g %+.4g i\nK: %.4g", pt,K);
//endfunction
//
