Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D62283FC3
	for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2026 07:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770966602; cv=none; b=gn3CQlOJSdsJYkhMK3ebmLXpugqlOZjnobnPsCzu1eqZeRc45eXaSFvqnR3nzCmx6qdwnx2GLYmWQ/78okHM36jfA9EllZQ7fjHs7ve9DMHQ+FRDS6vAiC//Syj4Nnm+DKR9U3aWpsmy+6aIpXvxwGSJC9pyN3D4ZcSP/8d1bw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770966602; c=relaxed/simple;
	bh=YPjLcEY4rANgxIqPduKrQOQlDIe69vI+TN1NbWtesA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljxTWQl3Cqy+kTYWpLkuNN02hp7/MaFpxDvV5SUOJRl9qc2SxNS9CzYnaw47rVMzHjjx5/GfvrSyNVFxrJZFmiEUakIPfVW4qruKfnyx628T48Sgf7myB5jA0CrwXuwbT0wTT4VZ77vxxxiCbNTziZTxm0Gwq7Hotv4iwenv17E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HQ7QopFP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hQS8PdvR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HQ7QopFP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hQS8PdvR"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61D16i8A053292
	for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2026 07:09:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=ueBVrP/Dr00G/Np3iU43iq53
	p6C33zJvmbCUg30e9pU=; b=HQ7QopFPL/RpnoPwudVfqTytYZ0AKVkGtx/A8X6Q
	eAzQO6RUfjg3wV/x2yhH8z0FNP4zsbGJ1Xq9Fh02rywfcjJ4VE88y7tAZGy/R2De
	vMeP6MWrEAK+VOZaym2raJmZnfrrZIj2RUq7VovGlCotlFcrmS+YRORazApFv272
	vb/ArNsHH5409DZRY2Ajw6UH9c00MZrgza4Bqi+8w2d+JHGPrc+GVntQyWg48v8b
	ebQUvzQg0Wi52tg4vxAIohmo3kBLFkLC9vlBINRzg1cgJ158mxrVLxwDJte4VP03
	2AljHTqQED3QOjPXaGWDssLbzR4QnSS9LXKBP1Sa50/A9w==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c9jgbat4t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2026 07:09:58 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-124a95b6f61so4834244c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Feb 2026 23:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770966598; x=1771571398; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ueBVrP/Dr00G/Np3iU43iq53p6C33zJvmbCUg30e9pU=;
        b=hQS8PdvRydxjh2EjMtGIrZh5gra6/QxbbT9FryZYxgjs+rOrDWVdoLf84FLwA81d+j
         VuvnAXMuNI43ILnTX9cT60aWZ52pvckrqGSl5FYQAZdvjsfZmIbG+UYS5vHe1WIyFGGs
         0s0TJWOyI/A5vJOevsoI/fAyW4lHz5Wj/WTzWG7pW8WdDw6tpQLMBQIgnNFoR8U0y/+Z
         OfJT2qOQk1Xvp7ZAyMwe6+jhyl3Wvx8yxMFBFylDTg1DHJT/0iud+h0VJR8/YzI/XY70
         dVa9YFLTd8fJd2DV1yI5cjHM/ygcTguYbNw/kt1HiF+N4jjy2SR5svvzDKiXFluZqdLT
         w2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770966598; x=1771571398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ueBVrP/Dr00G/Np3iU43iq53p6C33zJvmbCUg30e9pU=;
        b=jqcVRymNnhxMJi6teeMMQPliBhO2HPndsL1b96xFgTw55iVhWBu+y5KoyUcFwvl66d
         ao8H3zSwHvNLtQP/b4GpFEL59Z3TIy1x+v+cHzutxf/1x/SGhwC0vb0bMRlJ+NGFldiR
         H0z/9Xm1r0wB6kZrHQMOA5eeMPMQtQCLxn7QkP/8wpVOBreTDTTNo6MwCyctJM6G847X
         uCJgcf46jfNat+PZHX/ZFO04teAXjccEpYQjKl0vfdoQoh0O2P5X5+zx09Aqyo7r07ss
         E5fIN7wrELaWHNOPVNThmY4bmTkW4TJqDejv9YdkNAPxRkb9DuXy3eoG/qUA6II/lstj
         8SNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCEAudLMSv0aiMAr7miQeKF9hiPgnM5zZu5+8e56lriS1NO/YlHfwEaE3hPq2ZHuTIVz4qL4bEeqOnwpw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBMsZe7rdkrve2gsAcXasO+gm3FHqToo9UGfiz0fiRMuaKszTd
	A62lFPCxeITTINJRYIwzWmrzbrnYOYOKfIW9ZRl0q/LMYv/isYt/yiXSTZScZaDBwm4jpcVuJQg
	OYb8lf3EmaZ1UEZMZMT8VvKDQIriVFYgqC+SolO+xR7/aG0NCor8TmtK6B0vktEA1fCDjjc0xoT
	0=
X-Gm-Gg: AZuq6aIX6Wlx0PGPvFjQmkCQRiC3EhqkXcr0y9oXVb9XRKTBSv/d8ZNFEbri9Py/vYK
	bIb9CdLN7ZhiI/vUtamzKVfp1b9D6uc/rARh0q8mbpWizBiA0rQWd3np6httB3Eo2cr4TNLBOpK
	n37KPAUA502LzGBuRACvN8z0s6xjOlyo1pBadVKuKQMgz0zQz2A3DZ41kLKnKCt+k58zsJ2BXrS
	JZDQOEcKMsBiLYMgEMsNqlg0omrHd2EClQ01KO0Y51oqGVsVQey+ApX6WxEoSBUF8QUe2Sk9AM2
	5Yw2phcS3EkQQj0jrY/1qlMu37X42m1tqahvhnDIL30ORXh/wdx5FSpe9O5WY4XUCKWaFqXVGSL
	uMb4YuMGaT8E/uoIq/4vboWlYM1d1DpWcKun2mWCYJGQkswlEaA61QZxkTVk=
X-Received: by 2002:a05:7022:4584:b0:124:11af:7b75 with SMTP id a92af1059eb24-1273ae81443mr361833c88.34.1770966597640;
        Thu, 12 Feb 2026 23:09:57 -0800 (PST)
X-Received: by 2002:a17:903:2282:b0:2aa:d350:fbf0 with SMTP id d9443c01a7336-2ab5054aa42mr12146895ad.26.1770966160833;
        Thu, 12 Feb 2026 23:02:40 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab2997a660sm74391245ad.64.2026.02.12.23.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 23:02:40 -0800 (PST)
Date: Fri, 13 Feb 2026 12:32:33 +0530
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
Message-ID: <aY7MidG/Kcrs83O9@hu-arakshit-hyd.qualcomm.com>
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
 <20260211-enable-ufs-ice-clock-scaling-v5-2-221c520a1f2e@oss.qualcomm.com>
 <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEzMDA1MyBTYWx0ZWRfX3gccy2X0ikle
 hJQJ4RI471cPwSlYJSo5hlMAtVPigWRFFvKMi/EqdNu/IthuW166Jsp6wQ8+53/uXDMOQ9e6UwF
 FAusp5yKVxD6s/pH/8zpXoNrMqdYJJHk7neZGU7dCYMVPxXCutAJJ7ejiY8ecwzpKNnmGMZWqiD
 DrFfjt8PhAjF7t+/hSUYm8XK7El3r5G0Wo3kSWTscVbilbYbG5J2mgwybFFOHcCRDOjBk109GSg
 H8rnh8KM9F8It749RgG4nrOV7pLsJUZgWVBELA/4K2VgVH8HlS7qUOCJ/CfJpN8ZZTQldI1aB1I
 ORJrtLzFZobQyzui8IYzk3VV60OabsUIxAIaBqpnH8lX3tBOXpdl2JCNiWTgj/W10shqn/DnwJN
 eQ1wfXnszQp1O63iviN86k1HunHqsUydBIsxMpV01qYFfT76kEKmhbUgMwlkYH8AHqp6ssQuSL0
 hRU5/h3XjYMj3XAHEOg==
X-Authority-Analysis: v=2.4 cv=ArzjHe9P c=1 sm=1 tr=0 ts=698ece46 cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=q3I9YNJuSRWBU34YNAkA:9 a=CjuIK1q_8ugA:10
 a=vBUdepa8ALXHeOFLBtFW:22
X-Proofpoint-ORIG-GUID: _ZHbguzQg_271E6zIN1J0XbWWM3LfiwM
X-Proofpoint-GUID: _ZHbguzQg_271E6zIN1J0XbWWM3LfiwM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-13_01,2026-02-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602130053

On Thu, Feb 12, 2026 at 12:30:00PM +0100, Konrad Dybcio wrote:
> On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
> > Register optional operation-points-v2 table for ICE device
> > and aquire its minimum and maximum frequency during ICE
> > device probe.
> > 
> > Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> > core clock based on the target frequency provided and if a valid
> > OPP-table is registered. Use flags (if provided) to decide on
> > the rounding of the clock freq against OPP-table. Incase no flags
> > are provided use default behaviour (CEIL incase of scale_up and FLOOR
> > incase of ~scale_up). Disable clock scaling if OPP-table is not
> > registered.
> > 
> > When an ICE-device specific OPP table is available, use the PM OPP
> > framework to manage frequency scaling and maintain proper power-domain
> > constraints.
> > 
> > Also, ensure to drop the votes in suspend to prevent power/thermal
> > retention. Subsequently restore the frequency in resume from
> > core_clk_freq which stores the last ICE core clock operating frequency.
> > 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> 
> [...]
> 
> > +/**
> > + * qcom_ice_scale_clk() - Scale ICE clock for DVFS-aware operations
> > + * @ice: ICE driver data
> > + * @target_freq: requested frequency in Hz
> > + * @scale_up: If @flags is 0, choose ceil (true) or floor (false)
> > + * @flags: Rounding policy (ICE_CLOCK_ROUND_*); overrides @scale_up
> > + *
> > + * Clamps @target_freq to the OPP range (min/max), selects an OPP per rounding
> > + * policy, then applies it via dev_pm_opp_set_rate() (including voltage/PD
> > + * changes).
> > + *
> > + * Return: 0 on success; -EOPNOTSUPP if no OPP table; or error from
> > + *         dev_pm_opp_set_rate()/OPP lookup.
> > + */
> > +int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
> > +		       bool scale_up, unsigned int flags)
> > +{
> > +	int ret;
> > +	unsigned long ice_freq = target_freq;
> > +	struct dev_pm_opp *opp;
> 
> Reverse-Christmas-tree ordering would be neat

Ack, will update.

> 
> > +
> > +	if (!ice->has_opp)
> > +		return -EOPNOTSUPP;
> > +
> > +	/* Clamp the freq to max if target_freq is beyond supported frequencies */
> > +	if (ice->max_freq && target_freq >= ice->max_freq) {
> > +		ice_freq = ice->max_freq;
> > +		goto scale_clock;
> > +	}
> > +
> > +	/* Clamp the freq to min if target_freq is below supported frequencies */
> > +	if (ice->min_freq && target_freq <= ice->min_freq) {
> > +		ice_freq = ice->min_freq;
> > +		goto scale_clock;
> > +	}
> 
> The OPP framework won't let you overclock the ICE if this is what these checks
> are about. Plus the clk framework will perform rounding for you too

Right, maybe I can just add a check for 0 freq just to ensure the export API is
not miss used.
Something shown below:

if (!target_freq)
    return -EINVAL;

However, my main concern was for the corner cases, where:
(target_freq > max && ROUND_CEIL)
and
(target_freq < min && ROUND_FLOOR)
In both the cases, the OPP APIs will fail and the clock remains unchanged.
Hence, I added the checks to make the API as generic/robust as possible.

Please let me know, your thoughts.

> > +
> > +	switch (flags) {
> 
> Are you going to use these flags? Currently they're dead code

I agree, currently they are not used.
However, since its an export API, I want to keep the rounding FLAGS
support as it a common to have rounding flags in clock scaling APIs,
and to support any future use-cases as well.

> > +	case ICE_CLOCK_ROUND_CEIL:
> > +		opp = dev_pm_opp_find_freq_ceil_indexed(ice->dev, &ice_freq, 0);
> 
You never use the index (hardcoded to 0)

Ack, will update.

> 
> > +		break;
> > +	case ICE_CLOCK_ROUND_FLOOR:
> > +		opp = dev_pm_opp_find_freq_floor_indexed(ice->dev, &ice_freq, 0);
> > +		break;
> > +	default:
> > +		if (scale_up)
> > +			opp = dev_pm_opp_find_freq_ceil_indexed(ice->dev, &ice_freq, 0);
> > +		else
> > +			opp = dev_pm_opp_find_freq_floor_indexed(ice->dev, &ice_freq, 0);
> 
> Is this distinction necessary?

Well not necessary. However, I wanted to have the scale_up option as well and make use of
it in the API. Hence, I thought of having this to be harmless.

> Konrad
