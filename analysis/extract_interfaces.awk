#!/bin/awk
{
	if (/StationName=/) {
		t=0;
		split($NF, c, " ");
		split(c[2], c1, "_");
		x=c1[1];
		y=c1[2];
		xarr[x]=x;
		yarr[y]=y;
	}
	if (/^0500/ && $2 ~ /[0-9]/) {
		t=t+1;
		tarr[t]=sprintf("%04d-%02d-%02dT%02d:%02d", substr($2,7,4), substr($2,4,2), substr($2,1,2), substr($2,12,2), substr($2,15,2))
	}
	if (/^0501/ && $2 ~ /[0-9]/) {
		for(i=3; i<=NF; i++) {
			z[i-3]=($i/100.)
		}
	}
	if (/^0502/ && $2 ~ /[0-9]/) {
		for (i=NF; i>=3; i--) {
			rho[i]=$i
		}
	}
	if (/^0506/ && $2 ~ /[0-9]/) {
		idx=sprintf("%d,%d,%d", t, x, y);
		zT[idx]=z[NF-2];
		zM[idx]=z[NF-2];
		zF[idx]=-9999;
		zFt[idx]=-9999;
		zB[idx]=-9999;
		hf[idx]=0;
		hs[idx]=0;
		hi[idx]=0;
		snow=1;
		flood=1;
		for (i=NF; i>=3; i--) {
			dz=(z[i-2]-z[i-3]);
			if ($i>=0 && rho[i]>=0) {
				if (snow==1 && (rho[i]<700-(($i/100)*1000) || (i>=4 && rho[i-1]<700-(($(i-1)/100)*1000)) || (i>=5 && rho[i-2]<700-(($(i-2)/100)*1000)))) {
					zM[idx]=z[i-3];
					hs[idx]+=dz
				} else {
					snow=0;
					if ($i>fthlwc && rho[i]>900 && i>7 && flood==1) {
						if (zFt[idx]==-9999) {
							zFt[idx]=z[i-2]};
							zF[idx]=z[i-3];
							hf[idx]+=dz
					}
					zB[idx]=z[i-3];
					hi[idx]+=dz
				}
			}
		}
	}
} END {
	for(ti=1; ti<=t; ti++) { #for (t in tarr) {
		min_zT=0; max_zT=0; sum_zT=0; sum_zT2=0;
		min_zM=0; max_zM=0; sum_zM=0; sum_zM2=0;
		min_zFt=0; max_zFt=0; sum_zFt=0; sum_zFt2=0;
		min_zF=0; max_zF=0; sum_zF=0; sum_zF2=0; sum_zFM=0;
		min_zB=0; max_zB=0; sum_zB=0; sum_zB2=0;
		min_hs=0; max_hs=0; sum_hs=0; sum_hs2=0;
		min_hf=0; max_hf=0; sum_hf=0; sum_hf2=0;
		min_hi=0; max_hi=0; sum_hi=0; sum_hi2=0;
		nT=0; nM=0; nF=0; nF5=0; nF10=0; nB=0; n=0;
		for(i in xarr) {
			for(j in yarr) {
				idx=sprintf("%d,%d,%d", ti, i, j);
				if(idx in zT) {
					sum_zT+=((zT[idx]!=-9999)?(zT[idx]):(0));
					sum_zT2+=((zT[idx]!=-9999)?(zT[idx]*zT[idx]):(0));
					min_zT=((zT[idx]<min_zT || nT==0) && zT[idx]!=-9999)?(zT[idx]):(min_zT);
					max_zT=((zT[idx]>max_zT || nT==0) && zT[idx]!=-9999)?(zT[idx]):(max_zT);
					sum_zM+=((zM[idx]!=-9999)?(zM[idx]):(0));
					sum_zM2+=((zM[idx]!=-9999)?(zM[idx]*zM[idx]):(0));
					min_zM=((zM[idx]<min_zM || nM==0) && zM[idx]!=-9999)?(zM[idx]):(min_zM);
					max_zM=((zM[idx]>max_zM || nM==0) && zM[idx]!=0)?(zM[idx]):(max_zM);
					sum_zFt+=((zFt[idx]!=-9999)?(zFt[idx]):(0));
					sum_zFt2+=((zFt[idx]!=-9999)?(zFt[idx]*zFt[idx]):(0));
					min_zFt=((zFt[idx]<min_zFt || nF==0) && zFt[idx]!=-9999)?(zFt[idx]):(min_zFt);
					max_zFt=((zFt[idx]>max_zFt || nF==0) && zFt[idx]!=-9999)?(zFt[idx]):(max_zFt);
					sum_zF+=((zF[idx]!=-9999)?(zF[idx]):(0));
					sum_zFM+=((zF[idx]!=-9999)?(zM[idx]):(0));
					sum_zF2+=((zF[idx]!=-9999)?(zF[idx]*zF[idx]):(0));
					min_zF=((zF[idx]<min_zF || nF==0) && zF[idx]!=-9999)?(zF[idx]):(min_zF);
					max_zF=((zF[idx]>max_zF || nF==0) && zF[idx]!=-9999)?(zF[idx]):(max_zF);
					sum_zB+=((zB[idx]!=-9999)?(zB[idx]):(0));
					sum_zB2+=((zB[idx]!=-9999)?(zB[idx]*zB[idx]):(0));
					min_zB=((zB[idx]<min_zB || nB==0) && zB[idx]!=-9999)?(zB[idx]):(min_zB);
					max_zB=((zB[idx]>max_zB || nB==0) && zB[idx]!=-9999)?(zB[idx]):(max_zB);
					sum_hs+=hs[idx];
					sum_hs2+=hs[idx]*hs[idx];
					min_hs=(hs[idx]<min_hs || n==0)?(hs[idx]):(min_hs);
					max_hs=(hs[idx]>max_hs || n==0)?(hs[idx]):(max_hs);
					sum_hf+=hf[idx];
					sum_hf2+=hf[idx]*hf[idx];
					min_hf=(hf[idx]<min_hf || n==0)?(hf[idx]):(min_hf);
					max_hf=(hf[idx]>max_hf || n==0)?(hf[idx]):(max_hf);
					sum_hi+=hi[idx];
					sum_hi2+=hi[idx]*hi[idx];
					min_hi=(hi[idx]<min_hi || n==0)?(hi[idx]):(min_hi);
					max_hi=(hi[idx]>max_hi || n==0)?(hi[idx]):(max_hi);
					nT=nT+((zT[idx]!=-9999)?(1):(0));
					nM=nM+((zM[idx]!=-9999)?(1):(0));
					nF=nF+((zF[idx]!=-9999)?(1):(0));
					nF5=nF5+((hf[idx]>=0.05)?(1):(0));
					nF10=nF10+((hf[idx]>=0.10)?(1):(0));
					nB=nB+((zB[idx]!=-9999)?(1):(0));
					n++;
				}
			}
		}
		print ti, 															# 1
			tarr[ti], 														# 2
			(nT>0)?(sum_zT/nT):(-9999), 									# 3
			(nT>0)?(sqrt((sum_zT2 - (sum_zT*sum_zT)/nT)/nT)):(-9999), 		# 4
			min_zT, 														# 5
			max_zT, 														# 6
			(nM>0)?(sum_zM/nM):(-9999), 									# 7
			(nM>0)?(sqrt((sum_zM2 - (sum_zM*sum_zM)/nM)/nM)):(-9999), 		# 8
			min_zM, 														# 9
			max_zM, 														#10
			(nF>0)?(sum_zFt/nF):(-9999),									#11
			(nF>0)?(sqrt((sum_zFt2 - (sum_zFt*sum_zFt)/nF)/nF)):(-9999), 	#12
			min_zFt, 														#13
			max_zFt, 														#14
			(nF>0)?(sum_zF/nF):(-9999), 									#15
			(nF>0)?(sqrt((sum_zF2 - (sum_zF*sum_zF)/nF)/nF)):(-9999), 		#16
			min_zF, 														#17
			max_zF, 														#18
			(nF>0)?(sum_zFM/nF):(-9999), 									#19
			(nB>0)?(sum_zB/nB):(-9999), 									#20
			(nB>0)?(sqrt((sum_zB2 - (sum_zB*sum_zB)/nB)/nB)):(-9999), 		#21
			min_zB, 														#22
			max_zB, 														#23
			sum_hs/n, 														#24
			sqrt((sum_hs2 - (sum_hs*sum_hs)/n)/n), 							#25
			min_hs, 														#26
			max_hs, 														#27
			sum_hf/nF, 														#28
			sqrt((sum_hf2 - (sum_hf*sum_hf)/nF)/nF), 						#29
			min_hf, 														#30
			max_hf, 														#31
			sum_hi/n, 														#32
			sqrt((sum_hi2 - (sum_hi*sum_hi)/n)/n), 							#33
			min_hi, 														#34
			max_hi, 														#35
			nT, 															#36
			nM, 															#37
			nF, 															#38
			nF5, 															#39
			nF10, 															#40
			nB, 															#41
			n
	}
}
