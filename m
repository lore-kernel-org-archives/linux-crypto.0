Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807613845C2
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 06:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772519370; cv=none; b=RTyK70I5Oil2VTV+DbGjBtxA/5lDb9OPplQqvo9vrVza5x+JKEui92IBc6uD2b1WnWvYONLCsOxXVGdJcaVvhs/KuT+j2X15Q47eczh+oLCdwg0fJ0NLzc96xLXapp7m0hDF5tEYlP5TyG4aJaj0k1LOF+cvPSJe4hKR15g9Zms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772519370; c=relaxed/simple;
	bh=M+DA3WL2J5dzK2+kzlWiA53ciBp7qFFYfL8z6iZBCnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CkjFgfLB1hvDdnfoxxvfYQLQSPOsUKkLD321Vr58pSm59GsKH2CfOTnTzZNluAuuCzfyNEjb2yDzl5QahyRnqRjCFLiY4hoqa82YJYPjKOLFhsPQI8KsNtYaFXriXq89rqu3K3Qb6iUaleluNZYdkhClPejj2kquyk+GJJjTIBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HDAJr3ya; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=F0yNSGqc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HDAJr3ya";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="F0yNSGqc"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6231tKwB782876
	for <linux-crypto@vger.kernel.org>; Tue, 3 Mar 2026 06:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	z5545SDF4GNw5yu0jzFCabK+fHk2/1xgwStARtWxiLY=; b=HDAJr3ya8R7on1Ok
	NC83FdhrV7dqHEOgEL3quvCXA/buElbvR850ZUZ60Q5hrQ9h3MjoQsMd5wsq9tJT
	uO9AGUSo5mi9vBQe1dvxqJJxFy7/NlKWFafTEbs3p14rJL5u9c/hnVLB0lZpafwN
	rI1Z3x+brOurMl+O97VTJ+1f9yXAC5eKTTi+DrLnytT3lUrUxgF5if3mMap1KZys
	W4wKg/42ccVHX4R9X1ULVBE4L8FZfd6U8Gyc8o1fzr04/8OeV88VTjUlZ7yD+qz2
	wyqo2CUmDKuddXWaabYEqN/JovImG+mJZuVQsi9zXIPDO4J+NlpM5xDSqgQBdkcY
	W4Zauw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn7u03we9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2026 06:29:28 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ae49080364so17981235ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 22:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772519367; x=1773124167; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z5545SDF4GNw5yu0jzFCabK+fHk2/1xgwStARtWxiLY=;
        b=F0yNSGqc9cFU8CDsNEI6URrHXEV5FqQxIwJAdu1j7gGcdFdCotH+YcBNP9BROLtMrE
         HaazrjbajJB2a6TKF+5wOgaQanOAjlNj4lB6CAq2bxyb/EbElG9/vfUcU55x8Y3mxxZh
         qbLA7FEYx00R7yDgrcHMlGGqhOPihBIaVVAb9Kpw8bh13x3j2fZE9sHGGOZIQJ+G45om
         hsr7cM+kyYqgqWFaX5mcm3gIMUtyqN9tqLd6YPZbGBHvW2YCDPnbuevyrT2zcRMu6OG6
         LHRM7JyPqhbw+gbxDgS5n4fDRM9ciSWuJWrQyxZCkXnDCkw7hF8O6mGsy/QLgwuZufVt
         ealQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772519367; x=1773124167;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z5545SDF4GNw5yu0jzFCabK+fHk2/1xgwStARtWxiLY=;
        b=dM9hX4Ewyym+UtgDQ2jaoeLKY9V//2FI6scHGRaaxKrTKuAbXQmOLdktQIy6h2me+O
         EGvhIo0jNXCXO69Sc6IVeDGu9J6aQl4PWRw/YDDYlsBjhnAzl0P1vxZxJa79OlUXEyiB
         fS78N+0knwsA6zC7KwSSvnYgcj1bL1UnViqDIKBNkHW5bDdpBBZnHISQqoshaHhaocGc
         cfRL2OJmYR6N5JteiFf7JdI3XUMxAxMe+3i6bUFpzAbwQlmjnFaTOUlUPDvMge1p6Tjq
         V5PUR/UpmscrkFbtllwqPQu4kHLrR/godsZ9YmXiAjO4yEzb7FrbGDeqpJaT6qcnDKDE
         fXFA==
X-Forwarded-Encrypted: i=1; AJvYcCUxtWe4Au6p5/g1PdEHQk7KnuUEomStUTekG3XuHjlMMqrtNDfBrfO6WQinoc/hPx0G2ZFoIyFWs1kBOiE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPZXUn7/VzOT0+GH99FJiV8wzeLvE8WYh29uIuvUMXTUwBuulR
	EU7r6B6OlDTpN7WK4TIncR3eXfUdcYlYvZzM5ZYmFMsyKv0/ASzwJ//vdlryx49fYX2Ryxk8379
	DSbQmLCJCv9fJczhKxPa3d7Zn7xM+H0nY8qquwWVcVhN6q7cRXZLLZ3mH8S/JsjzUSfs=
X-Gm-Gg: ATEYQzwVcx4hOtPBjSIyrsg+rc77nIA4E9MjWs8aaG5qnL+cnDTwO5irVytT5phlNCq
	PhoGb9e3T9K46owWdvIAiIFxMNUtSP+WJGCetyKuEaZNax5LrRZuOo3d/gVUYRVUMYqYt12NUT0
	XChiagaKrl6+A5P49TIj/btYmXzaicBSVZoBMoNc3egxh8XsVdkVdLMnNgUESxyoanIryfeLJgR
	VWIIUD/k2B9PFtW4tCIYJWWlsrFAcdvjbxOXIAvpVT/pVNZ9iGqp/S0VywhgQ6azsCW726YBGYf
	OXZIe0vO/7CrxiR/+mCQlJiHb6xj42immPjfTiAkoAJGyth72n0WHmisy5iO7WFTzlPv94VwoSl
	JNvg1z13KBgOEXjzHcbr1U4rOtxK+wxuciFpTh1tG4l5WEqL8WHds6vek1YDegWjnHvdHcnKpqt
	t7UdXGhurocfXJ
X-Received: by 2002:a17:903:1786:b0:2a9:2ab2:e50d with SMTP id d9443c01a7336-2ae2e4e1e73mr135735315ad.51.1772519366980;
        Mon, 02 Mar 2026 22:29:26 -0800 (PST)
X-Received: by 2002:a17:903:1786:b0:2a9:2ab2:e50d with SMTP id d9443c01a7336-2ae2e4e1e73mr135735075ad.51.1772519366465;
        Mon, 02 Mar 2026 22:29:26 -0800 (PST)
Received: from ?IPV6:2401:4900:1c66:bc62:9072:7b6b:889e:887d? ([2401:4900:1c66:bc62:9072:7b6b:889e:887d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae54113d74sm44004045ad.74.2026.03.02.22.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 22:29:26 -0800 (PST)
Message-ID: <aceb0e36-ad68-4d50-aa3f-bd863b93c36f@oss.qualcomm.com>
Date: Tue, 3 Mar 2026 11:59:19 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] dt-bindings: crypto: qcom,ice: Require power-domain
 and iface clk
To: Bjorn Andersson <andersson@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org, Brian Masney <bmasney@redhat.com>,
        Neeraj Soni
 <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260123-qcom_ice_power_and_clk_vote-v1-1-e9059776f85c@qti.qualcomm.com>
 <14a71b33-4c10-41b0-a6cb-585a38e05f56@kernel.org>
 <06160c6c-a945-467a-be82-7b33c5285d0f@oss.qualcomm.com>
 <7216c86d-2b87-496c-9548-ccdcb3c98b6b@oss.qualcomm.com>
 <1f99db18-d76c-4b87-9e30-423eee7037e1@oss.qualcomm.com>
 <dd34525c-0a25-47ae-9061-c4c7ab708306@kernel.org>
 <2830a189-a5ce-45a0-92fe-7a01c3b012a7@oss.qualcomm.com>
 <6efcdf51-bdb1-4dfc-aa5e-8b7dc8c68cd3@kernel.org>
 <b217a08a-2755-4ef8-bf39-af1c3e628cf8@oss.qualcomm.com>
 <3cxejy2jplgqufj5fivi27ii3rrcrhzdyvmxd4ekp2ik3aqa6l@tiwyslt3ng5p>
 <vpgeduh5fwgvbx42dujbm7x3vacbmwjgjkcmhpgcsaa2ig4cm3@kk34eaqoh6ww>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <vpgeduh5fwgvbx42dujbm7x3vacbmwjgjkcmhpgcsaa2ig4cm3@kk34eaqoh6ww>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=GMMF0+NK c=1 sm=1 tr=0 ts=69a67fc8 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=VwQbUJbxAAAA:8
 a=9OQEGdjaUzrIYa7w_5MA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA0MiBTYWx0ZWRfX5mSvzr+3bCry
 gu+bX26pE1WSH1/8mxW5F1R+2W2fzT1pYPd13CfPxfZMBLF5gv8WL/4r5E9yE5hJEqcsIk/1i2z
 oeG4Qwj5IyflnE5/lrof3o9cdRxHGdASC4LJDRF4TDsoYNerNfehY5stZB6whLSFhPYHWouYqVi
 27fZSS9J6OgSB87oCAXZi2rMG5huVpxxPe05DgG8yz6necaVZcqwzWtTdLA9t00Hy1DtsvZ1zXz
 pG9cCKL9hCbWtSAOq7jgv7Rqsp0CESWHNKUiNEvJMqbUhw57UF0QBlMCBjlSDYlxWS7iDKIed0w
 Wy0HCmj06HdnlM7xank9ZmwGzZqeTbYRSy1zkB1ChALEoYo/9jxDaHCtUq/RHOY7zYE3bx0n5ml
 VD0u90CcaKyMaO5xucL0A0tZUPe25pgyCwFUsxYn/uH3GTs5/Y2Y4obvt+6TKg8LlMp0VnKpt3C
 tc9wByWZG2o4a8jIxlg==
X-Proofpoint-GUID: 4tg8IJ1Yq2dPXTpVLNNiIOsrOBS_pAQv
X-Proofpoint-ORIG-GUID: 4tg8IJ1Yq2dPXTpVLNNiIOsrOBS_pAQv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030042

Hi Bjorn and Manivannan,

On 2/20/2026 9:29 PM, Bjorn Andersson wrote:
> On Fri, Feb 20, 2026 at 08:01:59PM +0530, Manivannan Sadhasivam wrote:
>> On Mon, Feb 09, 2026 at 11:13:06AM +0530, Harshal Dev wrote:
>>> On 2/6/2026 4:20 PM, Krzysztof Kozlowski wrote:
>>>> On 06/02/2026 11:07, Harshal Dev wrote:
>>>>> On 2/5/2026 4:47 PM, Krzysztof Kozlowski wrote:
>>>>>> On 03/02/2026 10:26, Harshal Dev wrote:
>>>>>>> On 1/26/2026 3:59 PM, Konrad Dybcio wrote:
>>>>>>>> On 1/23/26 12:04 PM, Harshal Dev wrote:
>>>>>>>>> On 1/23/2026 2:27 PM, Krzysztof Kozlowski wrote:
>>>>>>>>>> On 23/01/2026 08:11, Harshal Dev wrote:
> [..]
>>>>>> My NAK for driver change stays. This is wrong approach - you cannot
>>>>>> break working DTS.
>>>>>>
>>>>>
>>>>> I agree that this patch in it's current form will break both the in-kernel and
>>>>> out of tree DTS written in accordance with the old binding. If this isn't acceptable
>>>>
>>>> What? You just said few lines above:
>>>> "it will still continue to work if:"
>>>>
>>>
>>> I hope I am clear now, 'it' referred to the in-tree ICE driver and not to this particular
>>> DT schema commit. :)
>>>  
>>>> So either this will continue to work or not. I don't understand this
>>>> thread and honestly do not have patience for it. I gave you already
>>>> reasoning what is wrong and why it is. Now it is just wasting my time.
>>>>
>>>
>>> Apologies again for the confusion. I totally agree, as replied previously too, that the
>>> updated DT binding breaks backward compatibility. Like I said, I will post another patch
>>> to preserve the correctness of existing in-tree and out-of-tree DTS.
>>>
>>
>> The ICE hardware cannot work without 'iface' clock and the power domain, which
>> are shared with the UFS PHY. One can argue that ICE is actually a part of the
>> peripherals like UFS/eMMC, but I don't have access to internal layout, so cannot
>> comment on that. I ran into this issue today when I tried to rmmod ice driver
>> together with ufs_qcom driver and got SError when reloading the module because
>> ice driver was trying to access unclocked/unpowered register.
>>
>> But you should mark the resources as 'required' in the binding and justify the
>> ABI break. No need to preserve backwards compatibility here as the binding was
>> wrong from day one.
>>
> 
> Marking it "required" in the binding, implies that it's fine for the
> driver to fail in its absence. If I understand correctly that will
> prevent UFS and eMMC from probing, unless you have a DTB from "the
> future".
> 
> Even if I merge the dt-binding change through the qcom-tree (together
> with the driver change) I will not guarantee that torvalds/master will
> remain bisectable - because dts changes and driver changes goes in
> different branches.
> 
> 
> As such, the pragmatic approach is to introduce the clock as optional
> and then once we're "certain" that the dts changes has propagated we
> can consider breaking the backwards compatibility.
> 

Apologies for the late response, I am partially on vacation since last week.

First of all, thank you for acknowledging that in order to fix the bug with
the driver we need to break the DT backward compatibility. Now the only issue
as Bjorn mentioned is preserving bisectability since the changes reach the
top from different trees.

I agree, I can send a version 2 of this patch where I keep the iface clock
and power-domain as optional, and also accommodate the same in the driver
sources to ensure that UFS/EMMC probe does not fail even if the dts changes have
not yet reached the top tree. Once all the changes are merged, I will send
another patch to update the DT bindings for clocks and power-domain to 'required'
with accompanying changes on the driver side.

And so, kernels from that version on-wards will not probe UFS/EMMC with older DTS
which do not specify the iface and/or the power-domain. In my opinion, a probe 
failure is a lot better than observing an un-clocked register access when the
DT bindings show the iface-clock and power-domain as optional.

I hope everyone is fine with this plan.

Regards,
Harshal

> Regards,
> Bjorn
> 
>>> The only point I am trying to highlight for everyone's awareness is that as per this bug
>>> report https://lore.kernel.org/all/ZZYTYsaNUuWQg3tR@x1/ the kernel fails to boot with the
>>> existing DTS when the above two conditions aren't satisfied.
>>>
>>
>> And you sent the fix after almost 2 years. Atleast I'm happy that you got around
>> to fix it.
>>
>> - Mani
>>
>> -- 
>> மணிவண்ணன் சதாசிவம்

