Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBE82F744A
	for <linux-crypto@vger.kernel.org>; Fri,  6 Feb 2026 12:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770379427; cv=none; b=oTP0yTxt7QDBj8EW2g0St2fr1lVFCQJ5OE5MZJRAsDDNCNHhcq0Io685/owXpRSYR+xH0mBLChF46TnCw5qErqL+UtKC9gBqIDTGEd/5n7hdBVnFL7zLiApkreyC8EkxVSQwX7ScQ/ZIIQettdvlrxgS83NoltGTLiTtVXKQtqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770379427; c=relaxed/simple;
	bh=uy8KSJl1E4N7YPO0LpxK5qPqXXBNu7tHP4Vg5Bk3lZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iX5xj6cK9I5iKJ+WPPA2clNlBiwmrKiEUjVXPKg9JPYstKVdAvSgABlpcypor+9hKh74R5T9EvzHAgFeatmuUJEbBRSlao8lp2m1Q65o3VvFbBwPvRSHvk0pNsqw3iaGLelDBmpxNgKORmIE0MI9F/Z/uYDRoJWHGc/qL/iqjoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PXMR+MJE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hzjJ4lv3; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PXMR+MJE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hzjJ4lv3"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 616B2mdW2938801
	for <linux-crypto@vger.kernel.org>; Fri, 6 Feb 2026 12:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	D7T/znkIGcIBDaQtDiqCYQV9+wOLqdbwc+EurdTvLiI=; b=PXMR+MJEslhETkVY
	MCMDVLvFyILaRh7tUetTxZ1avmPppThdRXrnzIv4eR4QpWJ4qPm406rCNr/yqZVn
	JZaIJvbDel4i5scGM7hbwIoZjPzdvp05lu2+fOuxhIezU9SM/HdOG7u8GxBr1n4i
	lAaX6u7WY0lSBMNtQqegg1eL2YFzc0B9fE08f9wpuGcJ1Q/3dIbxycXQDoYfy4FJ
	Nn5qclHYayIGdoDNZNK03ICt361Xx1Sr4P6bLF+h/mUVPfKlMRQkHVdqOjLBIeQD
	sr3jLAjcK7bYaYB0Dx4/Q5nFl8y18MXVoazLVUT2M8ZFFvRSi3ms5j+AACWI8Hu8
	jynHiw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c5f35r4rf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 06 Feb 2026 12:03:47 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b630753cc38so4140043a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Feb 2026 04:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770379426; x=1770984226; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D7T/znkIGcIBDaQtDiqCYQV9+wOLqdbwc+EurdTvLiI=;
        b=hzjJ4lv3xpv/7OreRoHOONs49TP6jCarw6gXfZYN0SERy2KakzPUrbKtdAE4XmrfYg
         JXyKSDIn4aF895miPo5yyyAuNvDhX3D/q7cs9yRPe5i/0gY/+ycOwpSWuUnLawNkkpSs
         XbRrl/qrY6siKlWYpNgUKxbxul+RQUbKOmZOXsbYGaxQfIKokPbQ4yAwRw9M61tlPuMg
         gn5s6b5vIhIDzcuW6Z5PK/YXc3RTlZhQYOefumwV38Ghj0h9DBNpOTnGf4T9zTGh4YnN
         JCTNY3fyOKpLgT4gPU1jRkwZ4WrsQ6tppyOIEXhyNsRRlrPrU7SLclq1rnqRHb7EbO49
         MdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770379426; x=1770984226;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D7T/znkIGcIBDaQtDiqCYQV9+wOLqdbwc+EurdTvLiI=;
        b=uTrUYz9tR+Xh2HgqgpPTejOnbyNDyHYJANGRM2GOGE6rf2qWXL3XVqqCvNFIJ9mWRx
         vZUUG9+6BatnDYrsZq9A0ZMSvRONVYCZqUzV6gaFG6yLOwjqNmPOawJtJEPg5TpjtY/q
         9Q3AAE6OTV0IdOcYujDxVjcFfxx8NlG4IH7hMpic6JJOkoTvSvr7fXZECwkWtqJ1f2O9
         rsQuATZYsgfHSEJxy0uwHj+JmrQ5KWKRaB9yNQ05x1Rz1rbs0vihmA4Q6WWXFAIW8WTk
         yknyeZS8cqbcMqLdBbCigdAlXHVjDwbqQNWevbNdcEwJQoZWzLv6zwuFJDhvzxpX33nw
         QEFg==
X-Forwarded-Encrypted: i=1; AJvYcCUqn9DAt5PPd3iyneuhwlQ5Bd0uS08TLSu/ZVjHoKD1JBQRJVmkz2OZrhxaXJnDXqf2W6Pyl3y0xqoF8BU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNuxeBUL4D1IADarredigX/FB82xZnkGtM6Yhvp2VjfKCeVWCi
	DtSATn/OowiO52xjSKGbJnTGGX7pr7nE5Ww2pcQd8ACIR0CWiD0A6nuzziFYF2jRBxXSYqkmsBR
	GJ7G25c1UnhhftsGbPt04mlUrK2Yl436jdOx/rtTTzEft/TKh6CVz+RE+mDpXSmJ92vc=
X-Gm-Gg: AZuq6aJxG9FrbP9CqslpY17LgWvPt6uloxBWO7uvggggICmqR6dCFHnXk3LST3X2wvA
	dNmj6R3zrdKlVQLygXaDdu1uidgQ3rNnUZy4wswuzRlDUe0yqtC81ox1QTudBJqkzRkQMVZR16J
	YF1iAjzqgMhCkbmrz/UF70fyGMlvEzpKa3Ac66r9qR4AdFVDYWNQ/RmixXNMkTpgzLp/Ue40Bbv
	8dzoUs9cpwMlDMo4S0TODnaNk0NmLkD2GvUu1kL4F1CfjEYDPFh06vZHbaI43e7sQJF3JZI67Ny
	l1/xr4sVZE49k/or5kX1ImPsyeXM78BPU0JGhNLNHBQXF1whdLDjrCGA83jL/oWPCJv57TkyKEC
	HXm8Y3DOF74f4Hi2ux2CklNWQGCftO/U7EkWaSuB1wbf/U/Y=
X-Received: by 2002:a05:6a21:150c:b0:392:e583:b766 with SMTP id adf61e73a8af0-393ad339ac9mr2560251637.42.1770379426368;
        Fri, 06 Feb 2026 04:03:46 -0800 (PST)
X-Received: by 2002:a05:6a21:150c:b0:392:e583:b766 with SMTP id adf61e73a8af0-393ad339ac9mr2560231637.42.1770379425888;
        Fri, 06 Feb 2026 04:03:45 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6dcb4fbcbdsm2262924a12.4.2026.02.06.04.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 04:03:45 -0800 (PST)
Date: Fri, 6 Feb 2026 17:33:38 +0530
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
Subject: Re: [PATCH v4 0/4] Enable ICE clock scaling
Message-ID: <aYXYmnFiFbZnVRqX@hu-arakshit-hyd.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com>
 <aYBF3Geeuq2qHmYg@hu-arakshit-hyd.qualcomm.com>
 <cac8e14e-63e4-462a-a505-cd64e81b2d1d@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cac8e14e-63e4-462a-a505-cd64e81b2d1d@oss.qualcomm.com>
X-Proofpoint-GUID: Kf3ACiLsXTdnI5rM3yJvE-HR7x3cDmTN
X-Proofpoint-ORIG-GUID: Kf3ACiLsXTdnI5rM3yJvE-HR7x3cDmTN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA4NCBTYWx0ZWRfX8NixhdRJSZhq
 XDc/cRdakfuOHmvmmXER0EVZI9/foelNGarRLQ9jsZ/YYFceuEpBMY6WZrQouKzAc4PfirGdy+L
 kRz1FyJ81FOCRGufZ4PoPBOzXORv4ui1+RT9j293h91Dh6GdppWGh23mYoCc+HaHRSzdQ0fOILx
 O08c1uoNq1+RugJUJA/+G9HXYp5wt0dgjPcucx2HPfjWFNwFXFBJ7RHSoKXLV4uR7L5sieKZpf3
 /ZIMuU/JlKraPvOoQC0mi92jVyDU6TQ1VIQ0nZ1Zp2SGdxb5o8x3kBroTjtGD6D4ZsWIlRjF/hH
 TW7zk9z8xregl/+H/oGBX4us74wZnJeJJnypofMe7AgQpvbR8gomohZM3VdR5kng8Yo8Yx8LfTG
 J2FId74JK9h8qc1TIwGiXvrg8MzwLqujqFM4AHG2/0J4AsPhlPQUmwjoUqSSV9E9k7bLhMnWQ9F
 A9Tjv1kmbT+Lz8A5sPg==
X-Authority-Analysis: v=2.4 cv=ApnjHe9P c=1 sm=1 tr=0 ts=6985d8a3 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=LeY25DUbnqDghkOhmf8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_03,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602060084

On Mon, Feb 02, 2026 at 04:01:38PM +0100, Konrad Dybcio wrote:
> On 2/2/26 7:36 AM, Abhinaba Rakshit wrote:
> > On Thu, Jan 29, 2026 at 01:17:51PM +0100, Konrad Dybcio wrote:
> >> On 1/28/26 9:46 AM, Abhinaba Rakshit wrote:
> >>> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
> >>> using the OPP framework. During ICE device probe, the driver now attempts to
> >>> parse an optional OPP table from the ICE-specific device tree node to
> >>> determine minimum and maximum supported frequencies for DVFS-aware operations.
> >>> API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
> >>> controller driver in response to clock scaling requests, ensuring coordination
> >>> between ICE and host controller.
> >>>
> >>> For MMC controllers that do not support clock scaling, the ICE clock frequency
> >>> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
> >>> consistent operation.
> >>
> >> You skipped that bit, so I had to do a little digging..
> >>
> >> This paragraph sounds scary on the surface, as leaving a TURBO vote hanging
> >> would absolutely wreck the power/thermal profile of a running device,
> >> however sdhci-msm's autosuspend functions quiesce the ICE by calling
> >> qcom_ice_suspend()
> >>
> >> I think you're missing a dev_pm_opp_set(dev, NULL) or so in that function
> >> and a mirrored restore in _resume
> > 
> > Thanks for pointing this out, its an important piece which is missed.
> > We can use dev_pm_opp_set_rate(dev, 0/min_freq) in _suspend and restore the
> 
> FWIW
> 
> dev_pm_opp_set_rate(0) will drop the rpmh vote altogether and NOT
> disable the clock or change its rate
> 
> dev_pm_opp_set_rate(min_freq) will *lower* the rpmh vote and DO
> set_rate (the clock is also left on)
> 
> Konrad
>

Thanks for the info.
I guess, dev_pm_opp_set_rate(dev, 0) seems more ideal as this is
API is for full quiesce mode and the clocks are anyway gated in
the suspend call (clk_disable_unprepare).
 
Abhinaba Rakshit
