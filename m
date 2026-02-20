Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFACA331A56
	for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2026 07:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771572829; cv=none; b=rMwPiTZnvyCT6dFhM6/xN8D0qmjWsttTInNWy7PLwKOAyRYVJyeWtm24lWQY4loAlRDlrL0T43c+crA4108ndsTXhJbTyGKJsyjIRBTOaoMnsIiNXxDu+q6gCLsFalIw7ZjSnYgfHHl8hsYy90EhTFz8W3hqcn4Sb9kA5yqHfbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771572829; c=relaxed/simple;
	bh=xsvf9jYLQBHdxJveFh1wo9nT6UQDkdrlu1DELW+03LI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T+iUwxkyKMw4ZT0dXEgLa4tDw27dAWDaP15HHqgMZC/gQM9hTpwKcFAHbE1Q2iEFUKz6rVjYBS1AhfSUjIVCzAlZlLYa5eR9SNztARsRIvbVZKF7zyfgZgCGkZJArlpYhxqGausVIDPSzP0ueL2uvWpEWaNhZNfSjHoL/LOprhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Q34j58us; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gPuTGfjm; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Q34j58us";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gPuTGfjm"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61K5S75e3337614
	for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2026 07:33:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=4qV3RCnNtuJMys8ptmXIK3yq
	TjaBi+kJiADEiO/bAwU=; b=Q34j58us3ZFKvTyOKKsR7HHKlHXgTMmIqP+OhCfB
	hfH4FlNralDhDbpYMp8UhQZz4mpDTw7V7fK5MGyDemoX0bPl1PvA7LYumGR/eVCz
	NU7hfCMa01ea+rlqkeYXjbHDI/jcbJd+6v3BjTU+W2lbT2KXZmyQ3QsII5ww6seF
	kV9i/8LiOEFosAZTwAEWeuVC9RRQuE0VCI/i+cxk1XZzwc8j7vn+ahkof8AEiktn
	xg+Et7tB7JcQ3Im54bAgyMzDV5yxGDWPj9anwwv75aOdIEXzTuzFKPf2Ks2xU7Xa
	y5pNYAVmiD/tsLtOlLyVPAOp1wE5DmAZ8BZsMpO03STH3Q==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cedp6gv30-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2026 07:33:46 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c5291b89733so1400768a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 23:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771572826; x=1772177626; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4qV3RCnNtuJMys8ptmXIK3yqTjaBi+kJiADEiO/bAwU=;
        b=gPuTGfjmThFGFJ7vDA/nldhNkVLjQaKBT5RfUBxuqjNqsC+T7HL0DvLi+niqb3P/vd
         Jpetz9KvTcMMtpbLm+poF4R4soFyZqyV/scYb8V3PgczPhQ3v2XWCFadnYCoiwmecR/O
         44c44P1/drLOG2D8GBVdE/E5bpQ7VKLGe+zLzsefSLHoB9dhvq18wU8Cyc0tkN8lx3GS
         ddMH6l+rghliHTXnSsadODh366uns0wieugqhLnwUsBJKb7DPHp3uhWIXaBKpC/yXqse
         M0JZdUgwSjaXDri3LhiWwR9lv2w5ft8YZoRVTbdLiT1YblpFNsvEifNbSn0z4IojC/d/
         veNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771572826; x=1772177626;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4qV3RCnNtuJMys8ptmXIK3yqTjaBi+kJiADEiO/bAwU=;
        b=IgLhM7alILLgY7IJ7zaEikEG9uDnwdHQpe41KM3jc503jAbL1Ly5d1yElvc+WSyWle
         kAbDwcMM/OCLzXswvV77aQ9lUCuVrxk0tqMufbn+rZuMzxyvHfp4iXanA+mpjnREU9dJ
         4IbnQjJnS7AKogveGV8TP2fUtUhaU8G6FXnSE3RV8XEEcYEyej5KyqXVw8CkEJSeytYC
         hUA1S7rmF4/KZXyqvzE5Y5GZmN8VtYojsOaZ77oIcqRNqehCe7G7qKexxepxBzj2PWMH
         +hnfbYm3xyFRp6Z/Bfp7qc35Rg1xdG77MwXnasHXYpcvVWHpL0qu+hoPMcpO/6RDswfc
         oDKA==
X-Forwarded-Encrypted: i=1; AJvYcCUQwUjKxvrIXEZXRvQZYGXfqyJl92+fMFpzk4SjskevtKWROv7vUg439GaLdedqtHms/dI0WWLZJRb3MFc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5wf86mlzX5rMiZ5jovpG6LuZgD7TZvWDqGnHPW0wiZlf0xLYr
	X3bjQ/CWFoSnLH5DGBd1cNireev63pzToML5XBFWIRXUjggYgwF0OSFhJAxR4VGNGDkTYDMCf2w
	z8/gDW/wEi1Fm6WHmcL9BbXt9ScrruC8ughGEb27LwBAk8lxkfLRFDlumbeE6C+Vaa9M=
X-Gm-Gg: AZuq6aKFFjB8gdtP5yfEhUYFzCr8yyt+raFxRuXpkV7AdYcVoAP49pKagiNqvK8s7L0
	FdoWRoDO9r4rm9cheqpXkfSEW1ps8I+xPE88ujqklZ3mxtuDFgCTG+I3I7f9fCwLqJvB8psbtEK
	SduiX18NS7qakemwoLqSVZdFT/dRXCJRbXrmsxG2GSseB9toHr3tEt00gr+vUI7L8ITQBY5VxA6
	4bk2/YkwxTubwKQSlbpO7SnD+TpsM/F9JAVLa+t5QLKzi25RXgLS9rrvQikGqy/gBJctYECh2pc
	lDnZuJhZJuYrolTRgLNXEiOBqjvLe1rNx0lQnsxvDq0kpeemBLQzi5d3/Q6e9n37vAO/u0em/LK
	cRPJTSc1ZyQxKW//jnpjYn0LYDSJBxCjP4AKAErUWtipB4HEhQszfZkBGmno=
X-Received: by 2002:a17:90b:1b41:b0:341:134:a962 with SMTP id 98e67ed59e1d1-358891ca0f2mr5846329a91.28.1771572826222;
        Thu, 19 Feb 2026 23:33:46 -0800 (PST)
X-Received: by 2002:a17:90b:1b41:b0:341:134:a962 with SMTP id 98e67ed59e1d1-358891ca0f2mr5846304a91.28.1771572825705;
        Thu, 19 Feb 2026 23:33:45 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6e532f2ba0sm17096468a12.25.2026.02.19.23.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 23:33:45 -0800 (PST)
Date: Fri, 20 Feb 2026 13:03:38 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aZgOUv+QweA7vE1W@hu-arakshit-hyd.qualcomm.com>
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
 <20260211-enable-ufs-ice-clock-scaling-v5-2-221c520a1f2e@oss.qualcomm.com>
 <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
 <aY7MidG/Kcrs83O9@hu-arakshit-hyd.qualcomm.com>
 <3ecb8d08-64cb-4fe1-bebd-1532dc5a86af@oss.qualcomm.com>
 <aZYMwyEQD9RPQnjs@hu-arakshit-hyd.qualcomm.com>
 <6d2c99c4-3fe0-4e79-94e8-98b752158bd6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d2c99c4-3fe0-4e79-94e8-98b752158bd6@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDA2NCBTYWx0ZWRfX6eMFgqu5Er0e
 bSVQxlFi4NQ51zZAasvg0neBh/SSMHtOoYuUdboWGPjv0AUkQ+IEXpuYt9JWH5PJPTVKYftkyLD
 BLLJHsSPiWaioVRCdTN1VUJLqoiwydM/u7o7cFske5YGy1476CDq+v1XX2i4EYy5+UC2QcV0Btd
 bHnsKR6mcqfK12C734h/is0StnAsHlCoZLtBJd75iTijA5pa6+AfictafIdrtWPEIPUQXwr2wd0
 w2rjo/ziLRvAUPyrPxLgXBPvSOc7eBY4CRRgI+cNOAFOORTHNS6o+NWE1c3C4U3+Jw4HlPGASkl
 PoJeESuJE2Kfcn+GpBCl6JVVvpV4kSDSvuXJ/++jMEdXz3054YAkxVTe3yVkkBG1igFRA2TWMmi
 1t/lxZ0nobS9aTcmx9m6avs/P56y9wskFVIng6Pirfzh9G5uSWL/0Jp++vQOBFkfDx61SkS4dTO
 0JGJNp8oJTX9sCr1/Fw==
X-Proofpoint-ORIG-GUID: WjEsyBVQUqOWQ9VvjfvRLbnLuyhbNOdf
X-Authority-Analysis: v=2.4 cv=Vuouwu2n c=1 sm=1 tr=0 ts=69980e5a cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=BdqzZBkdcrjdDIVejFcA:9 a=CjuIK1q_8ugA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: WjEsyBVQUqOWQ9VvjfvRLbnLuyhbNOdf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_06,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602200064

On Thu, Feb 19, 2026 at 03:20:31PM +0100, Konrad Dybcio wrote:
> On 2/18/26 8:02 PM, Abhinaba Rakshit wrote:
> > On Mon, Feb 16, 2026 at 01:18:57PM +0100, Konrad Dybcio wrote:
> >> On 2/13/26 8:02 AM, Abhinaba Rakshit wrote:
> >>> On Thu, Feb 12, 2026 at 12:30:00PM +0100, Konrad Dybcio wrote:
> >>>> On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
> >>>>> Register optional operation-points-v2 table for ICE device
> >>>>> and aquire its minimum and maximum frequency during ICE
> >>>>> device probe.
> 
> [...]
> 
> >>> However, my main concern was for the corner cases, where:
> >>> (target_freq > max && ROUND_CEIL)
> >>> and
> >>> (target_freq < min && ROUND_FLOOR)
> >>> In both the cases, the OPP APIs will fail and the clock remains unchanged.
> >>
> >> I would argue that's expected behavior, if the requested rate can not
> >> be achieved, the "set_rate"-like function should fail
> >>
> >>> Hence, I added the checks to make the API as generic/robust as possible.
> >>
> >> AFAICT we generally set storage_ctrl_rate == ice_clk_rate with some slight
> >> play, but the latter never goes above the FMAX of the former
> >>
> >> For the second case, I'm not sure it's valid. For "find lowest rate" I would
> >> expect find_freq_*ceil*(rate=0). For other cases of scale-down I would expect
> >> that we want to keep the clock at >= (or ideally == )storage_ctrl_clk anyway
> >> so I'm not sure _floor() is useful
> > 
> > Clear, I guess, the idea is to ensure ice-clk <= storage-clk in case of scale_up
> > and ice-clk >= storage-clk in case of scale_down.
> 
> I don't quite understand the first case (ice <= storage for scale_up), could you
> please elaborate?

Here I basically mean to say is that, as you mentioned "we generally set
storage_ctrl_rate == ice_clk_rate, but latter never goes above the FMAX of the former".
I guess, the ideal way to handle this is to ensure using _floor when we want to scale_up.
This ensures the ice_clk does not vote for more that what storage_ctrl is running on.

Also, this avoids the corner case, where target_freq provided is higher that the supporter
rates (descriped in ICE OPP-table) for ICE, using _ceil makes no sense.

Abhinaba Rakshit
