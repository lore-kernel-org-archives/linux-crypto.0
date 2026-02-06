Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493233A0B32
	for <linux-crypto@vger.kernel.org>; Fri,  6 Feb 2026 12:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770380078; cv=none; b=b6gYFx3IcMNWBDXydLGSdj6+9qirXyr32N4eDOMFr8FAKIXcttwkBFMNiMtDXjXcpFo1Cqr5RgUK25W0WzxbU+qAH3hblo5DvYDyk8yghI0WPypwnhgNLpg7cz5XXsPwFloD0krNrduyZBQ8uKQI/HEYpp9cU4GHr7v0QXinIJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770380078; c=relaxed/simple;
	bh=hXOHsOfXD5mihICS650SxJSJmR9bv1G2AOVi/7XXQao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iEX4XZLa46I+oaXJiMzXLFM/HmT2U+OJColGiyzhwGjn23mTAOz/byUUDbT9nY0BAtHaog9OFlhF6i6jzkxTqc0KLQqsLLmwJNLvOwmqZEU8zuAdfqiQvZSG0pbIPIbQY3rUZ58TSNqvsIYb5j/Ztdx7tNXi33X2zsewZQsXwv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XNSCitHk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WHKy/zJc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XNSCitHk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WHKy/zJc"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6169QX1L2228219
	for <linux-crypto@vger.kernel.org>; Fri, 6 Feb 2026 12:14:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nT6FRmnp0Jch+N2M4b/OnTDlejboaGGpjvhRTjZezn0=; b=XNSCitHkatb8Glw5
	93KTK4J2Y5PXTy2rrw1uAHzn641Wpl/Aj5UveMCfi+6wf9Mw3VKLY/zu+z2nmZbd
	Jl4af+5JoEpecqqPdnEhRYK4VVbMTQUOVvuiDBszCrd8x0CvEj8iY+T0O+ocPjM3
	dDh2kXnHLL4K69lT3OOqSTujaIAenh+l8GkgzbQzzcrBzu6w/NiG+DabkuabCpF7
	UNyQzR887QL93oUNiM9sV2SHoyz5L4CQul9/K6vqrnTV9Kt5o0u1b48x7g67OQDQ
	pjaZt1ePr8SxaCMHmQM0cgfS6BUXy6n0VnFdtASAuGeMKq3lINIPc5SFbuLx42rd
	R/il9A==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c5dnygfqa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 06 Feb 2026 12:14:37 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8c6d6b0f193so41851085a.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Feb 2026 04:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770380076; x=1770984876; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nT6FRmnp0Jch+N2M4b/OnTDlejboaGGpjvhRTjZezn0=;
        b=WHKy/zJcqv/NVV26SNi1d4U1QXYb3dgybsq71Ih9M0Gh509Bvrw1K7DDS6oW3Zd03p
         ZGSgJaBBduNHvRZkK7nVay9Lsxg1tMDuD35n79rg1EUZP6WHVETI6KF5YSQvGPTN/F/N
         QgqeFaX83ijr857yQOcMUR7vj+S8bxEnQ8suaLB22+R46X1lJENRXAf+jvUjmH8FYrwa
         bRpQBAaw9NDnhVKw/CCpe8+PLEIm8339QR5yq3R1C6ZcHRnb7nXUv3ccdMyQvcdXNKr7
         GRfiEeZHodXJxfS18FxuZuhkU4uX4aQyQplh59gtc/uJL8eg4kuuZaPS3UcyFE5rsJvc
         BNWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770380076; x=1770984876;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nT6FRmnp0Jch+N2M4b/OnTDlejboaGGpjvhRTjZezn0=;
        b=iRWa9pdowRzmyQ6g3bmUBjDdE5YettAxSrD+/H/UPlzOsa23fsxm+dYRIYKScT08v4
         Y5TPReWgBkTSCqQ3IuxP6ziN7+0eKg2+xaTkk78pjaOt/mzz24+q34hJrfNcXoP3SYI7
         6HSF3cCSCezXV7VOL1lOEjaSwgf7X/b4h/mdZbEiaPJ1oeMab5JMOjhZmT1jA/QhvpA5
         sXUSjIwDLRP9hrZyjI22MZdh+dGplCIAjoFsSvn2YwCqDKjau70ixdEOhcQUQ7PEFrzT
         dnnpBZNT8X61WuvBwpD/Lcp97ja8vPi3ubPpigjqhBZ6zcWPw0XPZ0OCc1J7FPkGI7DH
         txLA==
X-Forwarded-Encrypted: i=1; AJvYcCVtcuYcN9FlKZZ1C3oJLibJDAEebzJEFQV3VhegurR+/yljugq0zLRMn/A0Wh0e/2R0nt470J+CuN50atA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhoQ+B3sJLesGiKGCU+lVlP2njYzxEexPjcJkdmc2PxbHS3e2h
	fHsaSZjbjGHSAELgSjq8lkPAypFQ1zmW1mNnQju8IniVLJGXDfq2Y/3kXLk+R763JRYsDHwZFAw
	rwE/IGfuUc/sRfjpMvm02UKkWi1wRDIZBZ+XQ0fAksv1UCUksPXD3QEyWAVrLq1NXLOE=
X-Gm-Gg: AZuq6aJxofsCvg8wYLLujEACWJ5sUE1T7VWbxKBBCdNNo5AbwtJ3SgfT4m8Nfo1Hwek
	pYq2oUshFejoi9VIBsjhe0+FOCWGPAqORPcrvq4C0pklf0PMm5+0ebJz0cCQq8+Mf7xgZ5L2UTG
	5E3L6qO2+u6t9MGaDiufnXer5aCyHXEKF0ovxQJtUkTivyhodFeY2yZtaoPht3ra6gwHn/MZaSZ
	kPYUJlDaiVPxRq6rc4eBD2WCGxDz8LYlQPXTb7V4/iZOhpF15lPTW/IAHCzMgk0ukMKtUELq3Ca
	SxiRXPZ89g3tTQKOXCb1KxvChCWlSdRXXhB07qDEV14+1lG86XPswB7Vot/1c7tj4VUmIf2aSev
	KtMxYlilu2rIFt4Y96BzRUI9NJCno+oGz3D7tP8sp5KPCbENsF0Fz+Wivsid6dyLLlOg=
X-Received: by 2002:a05:620a:3185:b0:8c9:eee0:dba6 with SMTP id af79cd13be357-8caf0e3369dmr227595585a.7.1770380076503;
        Fri, 06 Feb 2026 04:14:36 -0800 (PST)
X-Received: by 2002:a05:620a:3185:b0:8c9:eee0:dba6 with SMTP id af79cd13be357-8caf0e3369dmr227570485a.7.1770380071701;
        Fri, 06 Feb 2026 04:14:31 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8edacf1532sm76010066b.55.2026.02.06.04.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Feb 2026 04:14:31 -0800 (PST)
Message-ID: <32e65de3-5466-4a91-b7d7-9c0ab9531ef3@oss.qualcomm.com>
Date: Fri, 6 Feb 2026 13:14:28 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] Enable ICE clock scaling
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com>
 <aYBF3Geeuq2qHmYg@hu-arakshit-hyd.qualcomm.com>
 <cac8e14e-63e4-462a-a505-cd64e81b2d1d@oss.qualcomm.com>
 <aYXYmnFiFbZnVRqX@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <aYXYmnFiFbZnVRqX@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 3-2sTBDBOu0oWfb4stBp9EnfNgA2Z9XH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA4NSBTYWx0ZWRfXzvfAibjRgA4e
 +Te6wIZLcywDiOuVb8a+5bSrT1Fnnt8lpO9+UHWjENmd6z2lhVTVwU1juqw4EIo6/lHU4Ev2Sw7
 9jQLzdTWhqQpIs70hHfAZYHaMuvzPP5FpkdGuaq/9h3tCr0gE/W3ReUccRcOOQxYS7s4uL5eOge
 2KHVNvDflTCdHA4MSowaXH5Nl6mnR0paSrmzRKyXV3A5sJLi+2QZeLtf1GgDfsuGb5SILXfj1rt
 xfqrG/X8mqvA6baPplhs07fZK5/rjdLbhfNcHJszOBC58D+ymBw4XK+HXxDwkOG9IYvd0sQukBb
 dDNHLZxGD+mpFa4RQuTgrs3eIW71uNoktsIhk19NS34aaFEDbw9amiFLv3p+P/RTdxeK1OZjqu3
 3xeyWSdhX/4eUVoQ4bDj3ztAbk3HeAlQ+aPfyw9c0rQmHYjLTHUXYTDqX9L5W9BOJZz8Bkm9KL9
 ppegyOFZP+hksMt0Zgg==
X-Authority-Analysis: v=2.4 cv=C73kCAP+ c=1 sm=1 tr=0 ts=6985db2d cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=WEYNnfNoJtBL0Lpg3fAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: 3-2sTBDBOu0oWfb4stBp9EnfNgA2Z9XH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_03,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 malwarescore=0 clxscore=1011 impostorscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602060085

On 2/6/26 1:03 PM, Abhinaba Rakshit wrote:
> On Mon, Feb 02, 2026 at 04:01:38PM +0100, Konrad Dybcio wrote:
>> On 2/2/26 7:36 AM, Abhinaba Rakshit wrote:
>>> On Thu, Jan 29, 2026 at 01:17:51PM +0100, Konrad Dybcio wrote:
>>>> On 1/28/26 9:46 AM, Abhinaba Rakshit wrote:
>>>>> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
>>>>> using the OPP framework. During ICE device probe, the driver now attempts to
>>>>> parse an optional OPP table from the ICE-specific device tree node to
>>>>> determine minimum and maximum supported frequencies for DVFS-aware operations.
>>>>> API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
>>>>> controller driver in response to clock scaling requests, ensuring coordination
>>>>> between ICE and host controller.
>>>>>
>>>>> For MMC controllers that do not support clock scaling, the ICE clock frequency
>>>>> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
>>>>> consistent operation.
>>>>
>>>> You skipped that bit, so I had to do a little digging..
>>>>
>>>> This paragraph sounds scary on the surface, as leaving a TURBO vote hanging
>>>> would absolutely wreck the power/thermal profile of a running device,
>>>> however sdhci-msm's autosuspend functions quiesce the ICE by calling
>>>> qcom_ice_suspend()
>>>>
>>>> I think you're missing a dev_pm_opp_set(dev, NULL) or so in that function
>>>> and a mirrored restore in _resume
>>>
>>> Thanks for pointing this out, its an important piece which is missed.
>>> We can use dev_pm_opp_set_rate(dev, 0/min_freq) in _suspend and restore the
>>
>> FWIW
>>
>> dev_pm_opp_set_rate(0) will drop the rpmh vote altogether and NOT
>> disable the clock or change its rate
>>
>> dev_pm_opp_set_rate(min_freq) will *lower* the rpmh vote and DO
>> set_rate (the clock is also left on)
>>
>> Konrad
>>
> 
> Thanks for the info.
> I guess, dev_pm_opp_set_rate(dev, 0) seems more ideal as this is
> API is for full quiesce mode and the clocks are anyway gated in
> the suspend call (clk_disable_unprepare).

Yeah, please make sure to call dev_pm_opp_set_rate(0) *after* you
disable the clock though, to make sure we don't brownout

Konrad
