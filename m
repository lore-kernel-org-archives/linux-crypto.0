Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EF13644C6
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778854975; cv=none; b=UaSwUQnBZWKQTdAv2ykaY23uuBpkBV/A/piELW26/bd/TboHBwXNIuW36IctFQ000tFt97o6uPIhC19zUjgNi5+Pjgu6N9yNdp8GKiTTWh/uPZdZwC/iFo0chamcGb1rPCB5howcXTxHJ+njvBWFx6POQ6tlityYJ4mL0cILtl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778854975; c=relaxed/simple;
	bh=vg7rsFdmrkTWiZNtp5qMnR7zjL7mLG8s1Cu9e/+xksg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PMgAIPCEYP2PUlw/ndtUUfQ7DxMxw+tMFBekZxddsy7aub2RfLKukMqAchx0mBiHiWbP4VpEQCGU9h+8aWR8OsmwhlkdKBHGa94v2Fim6cGG67aB5++pcATNVopQZl5A90WVoiwOl0QFHoqdH912jneq5AjOuxCv+NuZhqn9F5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=g+HNLWx7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IJU6NbYg; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="g+HNLWx7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IJU6NbYg"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64FBkKkW3197820
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:22:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lwgI4gCOFcfcSUDdRJPuf785r1N8oM5gm37xd7VD4IU=; b=g+HNLWx7lFuEr2lr
	i2DRUJKq2O5DpXHZkJ6ciinfLWRpDGCRe8YzfUjc9VF8Ln5EPlpXo16OcVHbAAfH
	KjR/iXDEVPVK2VY7s/QYODuMwJocXFS5bEEpZQvtibNCGFwKiGS7jgqgJdsRFUtw
	FBy6P1zRCW3Q3zG+Pz/qSvsTaUI60YFJ3qpUQWk8KfJZvwaMlowmNQVVc+ACszrd
	1B/bOdCR7dfns/JoBjaf/Q4Gkz5zLS0067f3qzqTA/cqFCHQVxkMrH755O1VH5gT
	LSe3eS2BGA+//s0hSHlpKTIO07CI1rcW9VlGZxn52CFCzu7knCRyz0+2B/NGIzNH
	PQI0iQ==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1qbky2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:22:52 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2ef37c3f773so10700634eec.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 07:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778854971; x=1779459771; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lwgI4gCOFcfcSUDdRJPuf785r1N8oM5gm37xd7VD4IU=;
        b=IJU6NbYgFtNoKWiQO8l5QsGVAiDuAFMFNXqnzMItjysQg+0vdK5QM9E4jiHqjmXf/H
         lRwj13xQxfMfVUCEggJ/rslcCpVw3wgrQezO4/pgaOxfePy+5P9829C6hM5Se8a+Zcpr
         iW7ZGKM73Jz5gGwEE3y3U99z5GYyxxNjoKxorKZ3xZIkBZnlj6rDv8oEC5rHMFaGcm5I
         kmchnuXgOGhOTlUZKAFjpZ9WEDiw4jQ2dYArw2ay2d5SRh/eiltZeuXaWfdAI6ViZcyD
         ylN62iWbUQk27xGH9mG950pNl1V9De84sITefOgxA3oFQBUMMgwMzXym1jbhm3hJ4u1d
         M7RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778854971; x=1779459771;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lwgI4gCOFcfcSUDdRJPuf785r1N8oM5gm37xd7VD4IU=;
        b=dsPVcsRbd1TGtpD6LzDh6JYlCXkaGB9aGa4edAh4Yxh6Y9keDf6d2Q9dggvYNc3cZI
         zGyQ7wYg55aOrfOiyqT5b1mznujkGs4VjL4mxxxDAbyEYSx4y984zjQX+LJ/PT4gnTa4
         l385q2EzIDjjJ01ycIOtDhJiTXCeR1N23Wjeznwf3UnrLm5go7swjlUakhDs4TUsuJfp
         1mYkrFPl29yEyuShCFcwzwTK8lP8siuDNb8ONtiDmxf4bOInQifspe/nDEj63mU8FuY4
         yf4bTnxVy4cpodu6GGe7pzRGxSB4S/iJdZtXsCJ+DnbcB53MxWeNU9wy37onGVij2qKd
         mbCA==
X-Forwarded-Encrypted: i=1; AFNElJ86j6/b86+hw+dZufVmfQVud5glMOB1ZAU2A82SN6UMV5gniiem5DeOm9T3K5D1eu6Qk580ah1m55InTD0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yznc76XgU7MOz6Hj6Np4xQrwuLmxDrXW8SaMwaBMnIbjtuS1P+Y
	UqB1gFk3qkEFLAWJvIdfGFpvPulcwl+qJKj2YVRsAfb73eAV6h1xW/RayZRDPN4JMKrR+6p1xvV
	YDgvzi9UraZdJWcgfyM6Ceqr+YUOE8IuRFn+WoNDbYLszuJI4gtrLxeZfhNilgJ+9RQo=
X-Gm-Gg: Acq92OHZ3GEeeRyzKcVEK7oudtfNF++42/Gv7vLjmPh8qZ/pKQ3Fopyffr9ruML9zYF
	HV00YTMjBUcpi1KCKV84uhCB+CJEo2CBto1Zs8AT+XiO12WbQsFHa2T34UvrsZ14cwi13/IPg5N
	Rc4lt8khBdCVz9CfaQYvz8BWHUNwBplJrlfUplZc11LU8hHXf5bplQbbus0zuJhGdNuaVTqrF0U
	BdUruMPR5o3p24LLYDqq+aLwwHUFzx/LySVfALN7yJMKLBfwM60gWcXmn2x4xp/7hepjNEmeqoL
	kKbDdpuQyf0xCX/y805v0YTJaf7AUzRYS/Rvw0bHl5sEwqJjh16iVG0dMLvGQdy+ZiFRJd+OZ8f
	j2wHiB+EbCZU+FNvow/TeRhaVbK5ABwiatY9IX7ByofKJA/7WroQgaR7XhhkAT2g95N3SXBidps
	rlWzkm
X-Received: by 2002:a05:7301:2f85:b0:2ea:cd38:f921 with SMTP id 5a478bee46e88-3039869ffffmr2132112eec.26.1778854971051;
        Fri, 15 May 2026 07:22:51 -0700 (PDT)
X-Received: by 2002:a05:7301:2f85:b0:2ea:cd38:f921 with SMTP id 5a478bee46e88-3039869ffffmr2132069eec.26.1778854970441;
        Fri, 15 May 2026 07:22:50 -0700 (PDT)
Received: from [10.110.108.188] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30294500a97sm7956995eec.9.2026.05.15.07.22.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 07:22:50 -0700 (PDT)
Message-ID: <01578e6a-d10a-46df-bb32-fd45ecb365d7@oss.qualcomm.com>
Date: Fri, 15 May 2026 22:22:45 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] soc: qcom: ice: Enable PM runtime for ICE driver
To: Krzysztof Kozlowski <krzk@kernel.org>, Rob Herring <robh@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        bjorn.andersson@oss.qualcomm.com
References: <20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com>
 <20260512033750.3393050-3-linlin.zhang@oss.qualcomm.com>
 <b07a3634-a7a6-4f28-994b-fc900be26879@kernel.org>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <b07a3634-a7a6-4f28-994b-fc900be26879@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: JskQcXQseZdCtlGNYvZj1ahfQZSE9KVJ
X-Authority-Analysis: v=2.4 cv=GulyPE1C c=1 sm=1 tr=0 ts=6a072c3c cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=LBsR1RIUYHBeOwdxVikA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDE0NiBTYWx0ZWRfXxZ7qLfD0IpGX
 IYM8BfgUD51cI8FPp2qE/ENiBze7tfmb8wk2wY8KGkiRP2wZCiKKDvCuy1NJ9RYLoIW32oikqR+
 ZK8yOsRwnBea5V7/nZjGN9sAHAUefHqOqWtEoRmslZvGZNKVtEzv5C3ao+qmpTd8OQ6p9xljRiN
 dBbX+GcNWvDeKr4MSdAOzE0lSUeVAdsgBT2j+psflhJPqEEXn4H80Da/X9sMa26iqcT536wB3ZN
 ayVgkbyAoZ7d0+akcaaYE3FRpvDcAc964zeA3tdpu0BD/6Lk8/2sZYChKFZIuXbiE1/uIWWDNxE
 PEukrKCCm567eUoBWkQbvXpz8MTOx1q+y4KPwxo090tLQxvmz6sCqHhGocX8gT32zjvQXNMmtKr
 RAd9xpcBGHtAiJHvLciSXAdUB3OHTVkI6TcTrC8AeZ5+2v63kn3HmeXrtOhrxd4OlJvlq41PHrg
 T/d/eFQ+cOxgvRElfmQ==
X-Proofpoint-ORIG-GUID: JskQcXQseZdCtlGNYvZj1ahfQZSE9KVJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_03,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 clxscore=1015 impostorscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605150146


Hi Krzysztof,

Thanks for the review.

For the SCMI-based platforms (e.g. sa8255p), the ICE resources such as
clocks are not controlled directly by the ICE driver. Instead, they are
managed by remote firmware and exposed to Linux via power domains. As a
result, the ICE driver cannot use clk_prepare_enable() directly to
control the hardware clock.

The intention of moving the clock handling into runtime PM callbacks is
to align the ICE driver with the power domain framework used on these
platforms. When the ICE device is attached to a power domain, invoking
pm_runtime_resume_and_get() will trigger the provider (remote firmware
via SCMI) to power up the device, which in turn enables the underlying
clock and other resources.

This design follows the guidance where the runtime PM framework is
used as the common mechanism to abstract both:
  - direct clock control on non-SCMI platforms, and
  - firmware-controlled resources via power domains on SCMI platforms.

In both cases, the runtime PM callbacks are responsible for performing
the actual resource enable/disable:
  - for legacy platforms: clk_prepare_enable()/disable_unprepare()
  - for SCMI platforms: power domain on/off handled by firmware

So while it may look like an additional layer on legacy platforms, this
approach provides a unified mechanism without requiring separate driver
entry points or special handling in the upper layers (e.g. UFS driver).

That said, I understand your concern that introducing runtime PM solely
for clock gating can be seen as unnecessary overhead on existing
platforms. I will revisit the implementation to ensure that:
  - the runtime PM integration does not introduce regressions for legacy
    platforms, and
  - the design clearly justifies the common abstraction for both SCMI
    and non-SCMI cases.

In addition, I rewrite the commit message as the following to make the
intention more clear.

  On some platforms the ICE device is placed in a firmware-managed power
  domain. In those cases the ICE core resources (including the clock) are
  not directly controllable by Linux and are instead toggled by the power
  domain provider (e.g. remote firmware via SCMI).

  Wire the ICE device into runtime PM so that a single pm_runtime
  transition is used to bring the ICE device up/down. When the device is
  attached to a PM domain, pm_runtime_resume_and_get()/pm_runtime_put_sync()
  will invoke the PM domain callbacks and let the provider manage the
  resources. On platforms without a PM domain the runtime PM callbacks
  continue to perform the existing clock enable/disable locally.

  No functional change is intended for non-firmware-managed platforms; the
  change provides a common control point that allows ICE to operate when
  resources are owned by a PM domain provider.

Thanks again for the feedback. I would appreciate your further review
and comments.

Best regards,
Linlin

On 5/14/2026 10:06 PM, Krzysztof Kozlowski wrote:
> On 12/05/2026 05:37, Linlin Zhang wrote:
>> The QCOM ICE driver manages the ICE core clock through direct calls to
>> clk_prepare_enable() and clk_disable_unprepare(), which limits integration
> 
> No, it does not limit any integration.
> 
>> with platforms that rely on firmware-managed resources or platform-specific
>> power management mechanisms.
> 
> Nope. It's perfectly correct way of managing clocks. Adding runtime PM
> ONLY to toggle clocks is absolute killer, pointless overhead without
> benefits.
> 
>>
>> Replace direct clock management with runtime PM support by moving clock
>> enable and disable into runtime PM callbacks. Use
>> pm_runtime_resume_and_get() and pm_runtime_put_sync() in qcom_ice_resume()
>> and qcom_ice_suspend() to drive power state transitions, and enable runtime
>> PM in qcom_ice_probe().
>>
>> Reviewed-by: Neeraj Soni <neeraj.soni@oss.qualcomm.com>
>> Reviewed-by: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
>> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
>> ---
>>  drivers/soc/qcom/ice.c | 58 ++++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 53 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
>> index b203bc685cad..6f9d679b530c 100644
>> --- a/drivers/soc/qcom/ice.c
>> +++ b/drivers/soc/qcom/ice.c
>> @@ -16,6 +16,7 @@
>>  #include <linux/of.h>
>>  #include <linux/of_platform.h>
>>  #include <linux/platform_device.h>
>> +#include <linux/pm_runtime.h>
>>  
>>  #include <linux/firmware/qcom/qcom_scm.h>
>>  
>> @@ -310,8 +311,8 @@ int qcom_ice_resume(struct qcom_ice *ice)
>>  	struct device *dev = ice->dev;
>>  	int err;
>>  
>> -	err = clk_prepare_enable(ice->core_clk);
>> -	if (err) {
>> +	err = pm_runtime_resume_and_get(dev);
>> +	if (err < 0) {
>>  		dev_err(dev, "failed to enable core clock (%d)\n",
>>  			err);
>>  		return err;
>> @@ -323,7 +324,7 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
>>  
>>  int qcom_ice_suspend(struct qcom_ice *ice)
>>  {
>> -	clk_disable_unprepare(ice->core_clk);
>> +	pm_runtime_put_sync(ice->dev);
>>  	ice->hwkm_init_complete = false;
>>  
>>  	return 0;
> 
> 
> This is pretty pointless change. At least by quick glance. You changed
> nothing here for PM, except adding indirection layer and more locks.
> Clocks will be gated the same way, no energy savings. But on the other
> hand introducing runtime PM subsystem is huge bunch of code with its own
> locks, completely unnecessary here.
> 
> This itself is poor choice and has NEGATIVE impact on all existing
> platforms without any benefit.
> 
> I am surprised you went through SIX internal reviews, collected two
> internal review tags and no one suggested that using runtime PM ONLY to
> toggle clocks is pretty pointless and undesired.> 
> Best regards,
> Krzysztof

