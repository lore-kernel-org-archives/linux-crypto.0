Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD1A3D3488
	for <linux-crypto@vger.kernel.org>; Fri,  6 Feb 2026 13:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770384162; cv=none; b=MYplhhmnP7TlHrJoOBX81fwt8tN2GDe56X2kmfIYBxbYp2ZlRLxOu3mdfEVgH1QwM4ndAZ6f2Ptf5VIUK3FEBvqhQs1geQSR0+Obb6kxvzTaVTmWk7M0xm+eZmFW40+XIv2yJ4e2vkXobwRq++0hIf+5wN6B47TD48PxStBIcPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770384162; c=relaxed/simple;
	bh=ilT/E977HzfMfImT0754avNv49Vz/Hq1ePSPioS9hcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0mvZjCjsA69xasqCmrzfNXIVRdSAG/5uKKNkYZtj714H77Q7jNmsVahXjqhKyezqNlcIXQkQMdz6oSVUn3iqpxV1KIKd+brsDpXovF2twZtNQorBoV1IzxXzpfB8zIh0aAQfnYAr0KtIlvBuMMzaRibfkWw9AH/Fh8FkVBq2yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PpzXYYF8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=C6jJmH4f; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PpzXYYF8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="C6jJmH4f"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 616B4Xka3764807
	for <linux-crypto@vger.kernel.org>; Fri, 6 Feb 2026 13:22:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3VwgMedd8yB2ZhuRAgPLlFfRSeW0mFjQv1ZUAldmExI=; b=PpzXYYF8KtFUDGji
	OXb2hBQJB7+6JQtuaHQH+/hKZjgT2SHJFO0dA3wj1mkG3WwHnMD7U1Ne3Oh5YyZf
	8+G3nezx3kYhTPAwYs7JDJQCZd6O1HGD4G0Qsm9bCe9JzdtyVNqmYedB4ncDsA/T
	2+F4GkjAAKt+Msekf+uUwZsCEn4AbHYNerlFd6h/Zyy3df+9ORCyu1Ns/TJ1SAoV
	kkcW8hLY5q5lNm0FmAH9ASbwxmANpeRWbEfetvdkaxIxBZgh9XF/vAh5XLfQEbn0
	667CunZVhdWOyHiYfHJ+7DE/+OskPp+WeRJAtkEO3HHh0Y20D9zfZh80QB9i++JQ
	Nv3LIg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c5f3wgccs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 06 Feb 2026 13:22:40 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35449510446so1783208a91.0
        for <linux-crypto@vger.kernel.org>; Fri, 06 Feb 2026 05:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770384159; x=1770988959; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3VwgMedd8yB2ZhuRAgPLlFfRSeW0mFjQv1ZUAldmExI=;
        b=C6jJmH4fsheHOJW7Lx1gl8aSZzV6LV9CGt8Vtjb7ZjH3QqjBHvD0ES9B3wNksv6bkJ
         b7jC4QGsMeiX+1erKJK7BhynXCEg1r6KO1Mv4hae4N7S/jXwoETeCTFPtVdF3mVPFDJ2
         ihWNyXi9hZGL9JOgrPh4gLpKwip93KgPEJ1Fw6ua21FZPjMcEDMjAXSGx/+Ag8L7Nn4x
         tndV+Yv+4xrqF91wCAyrFjapI+yhKKdjHL6GshZWZ9wTU5s8+LqWRHxOMt0YkqVKzoWM
         Bh6eBe/dWb89uerG1Os3lZKinK3x73A+6sBgL9mWkqJrUxOzkrHIio6nlfc0ygrpfiFJ
         w27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770384159; x=1770988959;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3VwgMedd8yB2ZhuRAgPLlFfRSeW0mFjQv1ZUAldmExI=;
        b=rkdlLYbROUI2fiodKDFV/Q5eZk3ESwtBhLjoK5x9xetdoWZGvPXA9WVXbEIVLUmmOJ
         3+3JA6bYxwNpD9XUE0gnUZrV3rRV+tTuKRjq07pX7QDEpk3LQ9AdHHis4YG9U9BpXPBs
         zgp2vI7sct3gljAilNJ6+pN3cmkJmz2MjHAO84gDtA5H1lGw9KwBQy7qFPgBgxGxD3CV
         YhKlNkZDMOvtVDkB+gNh+5DGHXyhJ2HAIJekvvGUGjwVBo8d4kTMFv+LdTl8/+d/2psI
         0elZbOWDAin7pN8V+Z8PwoxuFzHZHBIs+gXlemxP8jOsH/OooZoAFUTeEJqrpRgX0d56
         UffA==
X-Forwarded-Encrypted: i=1; AJvYcCWbVKxB6niQ9+sRTNn6dYL+lz5lVInBiAp66T2rz5b4n8q5i7B/F1r/2hFjc5WiaT6G/1Nq8+6p8w4UQlY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbYvW8fTW0H+4qEcEInx1imaBXqAGosUwhSu+bCC/i5vPTkihM
	yv8kpkzBXzn8zNZzO+mUAP9beK38dC8fi4WPnLcwxo+J0q+RB5yGFkBhPZ7m492QNUKYlb4RaQE
	CPqtXypuR3xlUNIOXBq1GObaQBmXG5SA1PUlect++bYaZyEnqOVtMeS61yf5fhEONMI14/FdS/N
	s=
X-Gm-Gg: AZuq6aK8cF9E10rYxX6NW+aGzp0tR5Ror8g0VkAzCZndSngnD5egm9u3jvJFT+vkm06
	226sBBotby2IopkAVBiBFveTF/MD7OWcg0/C18EYHMT+kEspfQpVF/HdCkELymibud/JeZ4uHjx
	mQdxZnJAa+/TWbx3vpRlMh/gjhRzRIoPvp6S+RFZvb4lDB4mbWHHKLX1PEAhFBIzWB5WmZLmlzx
	GQgFw47EXV19BCLg4EB8lfcm1JmCIbTtksmSu604Fp1AU5pBIaKvvptyoZKR5WdVfVGXOoDCGCW
	cED48K7jtRyj+dyvuVdsr/Oicl0lJHW9BF9OQH0ljPBEu5pEnWCld/TfFLeZg8pb3JjUycNvhhr
	0GGbZXp+BONaetShHTraMcFSQ0UHnMYoOxdwj//XguY5C3ME=
X-Received: by 2002:a17:90b:1d0b:b0:354:a8bd:e441 with SMTP id 98e67ed59e1d1-354b3e6f6c4mr2335894a91.35.1770384159371;
        Fri, 06 Feb 2026 05:22:39 -0800 (PST)
X-Received: by 2002:a17:90b:1d0b:b0:354:a8bd:e441 with SMTP id 98e67ed59e1d1-354b3e6f6c4mr2335869a91.35.1770384158881;
        Fri, 06 Feb 2026 05:22:38 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-354b21f9178sm2804210a91.11.2026.02.06.05.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 05:22:38 -0800 (PST)
Date: Fri, 6 Feb 2026 18:52:31 +0530
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
Message-ID: <aYXrF31eYsnAee2Z@hu-arakshit-hyd.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com>
 <aYBF3Geeuq2qHmYg@hu-arakshit-hyd.qualcomm.com>
 <cac8e14e-63e4-462a-a505-cd64e81b2d1d@oss.qualcomm.com>
 <aYXYmnFiFbZnVRqX@hu-arakshit-hyd.qualcomm.com>
 <32e65de3-5466-4a91-b7d7-9c0ab9531ef3@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32e65de3-5466-4a91-b7d7-9c0ab9531ef3@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA5NSBTYWx0ZWRfXxmkg5dQKbY0s
 1PWy5p0pLLfvePWM8UP7fEjkRnnD+YqMAy9NFPXE4mGu2RjgiIu+9iW7DgtMq38SvMgf6Rji450
 5NQNqK74SgFbqWNBZz/B6wF6M1iapPgjujYTSwFR/Pk5Jkb/VHyjbPg6jzBo4hU0M/gJ8YDry/S
 6AZ7xxm90EYdNuMprLyG5T+atLvdd85S+lSLeuaDz4trydTXqnvnor+SBSmDRYIrL1QS3clvEfu
 fqU9X1SVm4aPYlA+HX9Pe3lDHWzZzLJFldK5mI7Kp8Vk+bZTXSDYKvTre6dAvW6dTMm7lD20E4e
 cBaqzWHZleJY4TZ5CoyVzwbolh94jVxyQNUR0LzYmQsPHwnMpnDuJU2yWVmRHkBjGj+zhSEAA3S
 Li+U8gcOmGGJ5A6rv9yrIAeQFOJv/Gt9BmY56kqhALh7X45R7PwbGe7tvhMhZjwydkHe+5nhjV1
 oC+9KvBL/OEeHAbWcdg==
X-Proofpoint-ORIG-GUID: skXhkpMXQA0wHqS9sia_w8jRIRYtwUhe
X-Authority-Analysis: v=2.4 cv=NajrFmD4 c=1 sm=1 tr=0 ts=6985eb20 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=p-Dtmn_q0YB1zajlIU8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: skXhkpMXQA0wHqS9sia_w8jRIRYtwUhe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_04,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602060095

On Fri, Feb 06, 2026 at 01:14:28PM +0100, Konrad Dybcio wrote:
> On 2/6/26 1:03 PM, Abhinaba Rakshit wrote:
> > On Mon, Feb 02, 2026 at 04:01:38PM +0100, Konrad Dybcio wrote:
> >> On 2/2/26 7:36 AM, Abhinaba Rakshit wrote:
> >>> On Thu, Jan 29, 2026 at 01:17:51PM +0100, Konrad Dybcio wrote:
> >>>> On 1/28/26 9:46 AM, Abhinaba Rakshit wrote:
> >>>>> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
> >>>>> using the OPP framework. During ICE device probe, the driver now attempts to
> >>>>> parse an optional OPP table from the ICE-specific device tree node to
> >>>>> determine minimum and maximum supported frequencies for DVFS-aware operations.
> >>>>> API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
> >>>>> controller driver in response to clock scaling requests, ensuring coordination
> >>>>> between ICE and host controller.
> >>>>>
> >>>>> For MMC controllers that do not support clock scaling, the ICE clock frequency
> >>>>> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
> >>>>> consistent operation.
> >>>>
> >>>> You skipped that bit, so I had to do a little digging..
> >>>>
> >>>> This paragraph sounds scary on the surface, as leaving a TURBO vote hanging
> >>>> would absolutely wreck the power/thermal profile of a running device,
> >>>> however sdhci-msm's autosuspend functions quiesce the ICE by calling
> >>>> qcom_ice_suspend()
> >>>>
> >>>> I think you're missing a dev_pm_opp_set(dev, NULL) or so in that function
> >>>> and a mirrored restore in _resume
> >>>
> >>> Thanks for pointing this out, its an important piece which is missed.
> >>> We can use dev_pm_opp_set_rate(dev, 0/min_freq) in _suspend and restore the
> >>
> >> FWIW
> >>
> >> dev_pm_opp_set_rate(0) will drop the rpmh vote altogether and NOT
> >> disable the clock or change its rate
> >>
> >> dev_pm_opp_set_rate(min_freq) will *lower* the rpmh vote and DO
> >> set_rate (the clock is also left on)
> >>
> >> Konrad
> >>
> > 
> > Thanks for the info.
> > I guess, dev_pm_opp_set_rate(dev, 0) seems more ideal as this is
> > API is for full quiesce mode and the clocks are anyway gated in
> > the suspend call (clk_disable_unprepare).
> 
> Yeah, please make sure to call dev_pm_opp_set_rate(0) *after* you
> disable the clock though, to make sure we don't brownout

Sure, that makes sense.

Abhinaba Rakshit
