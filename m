Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC9F2D8796
	for <linux-crypto@vger.kernel.org>; Tue, 18 Aug 2026 07:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038547; cv=none; b=NuM0qDv/utfvhTOHl8aNAattqmSDrs+4iymegIISkWFPQg85Rt0rm9r7+NWfacGlCB4kupjbq4GH7i4EZw2v/DegDPmDqUTzWLq/otjzRrj2SRwdImsX0ZU4jU1RXhcsZ9ZM8QFhKKZWiIJ2IsRtyxGWO6uQdZEg6cEH20/YmPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038547; c=relaxed/simple;
	bh=xIlVaHLdF9RILHy5U21P1YD5GxYGtq4fDOhJxfXZMIE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=OBRqB6pwUB1mp0U0JDmiZmdHISBWWBIeoeIkZQPRImHJfDViX/8cCKmIMJx1r7DFkCFfinr1bFytwh8zmjc6lAmDs2pJ4jqmr5oJwDyFr4wtMhpU00IeHdooQcf28W6PBLZuxk/Lf274T7WswtH684CuxzniJGUxYma4uPeva7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WdZ9hjpX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FALdGwN0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WdZ9hjpX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FALdGwN0"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67I7E57U589741
	for <linux-crypto@vger.kernel.org>; Tue, 18 Aug 2026 07:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BvXrpqcs5lPXIdDWiOCpyiClU4baliOXlhRFFuuFV64=; b=WdZ9hjpXR3ktUiM3
	UISeqzZQPLvXW9DsBHSpVjzcMn+cMZ8OdVVGp9MxIv6cBFZI4zlRFDGmDArFDRgO
	PiEMcyyh/Q71TbBAV8AZnidlxFBZewn4V3f639LNXzGaFDZUmCyik4IXaCEfn4Ml
	l+A+Ir6iOHRFKtBaONiyZcauXDLP7I8cTr/BGJrNAb39iZC9sX4QxpMT4bKeWEJT
	2JpyIGo2TCu18twd/8QjWXlsxC9ZVW4kEBFcMUnYhsTXWXMbGxfLt18PAQzPJ+71
	IlJLaDK/ctnNxASH4H/8t5VExT1ntoY3Sx18mqnAMUS4za+RwlPkHZJ60hZFkx2T
	+SAh0w==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4615k8ne-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 18 Aug 2026 07:35:45 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38dde0df80bso7580533a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Aug 2026 00:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787038545; x=1787643345; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BvXrpqcs5lPXIdDWiOCpyiClU4baliOXlhRFFuuFV64=;
        b=FALdGwN0ZuDHNbHoe5kFrk5KmOy2Adf/fu1L6UjWcdFYTCDUi5jEl1GM1gKQpBO2d/
         nwUjt5s8MqpK5qVhKjf8TJXE7+xkoA5XzJ5+wiXZW3lOy73fjFz0nN4Cg08fuSr88OHe
         6wu0+SZwe1nlRtt3rgb6tUo2o4b5RjRTXt6elA0i17S5b3NB77tqZ11QhZCdVUA4n9zZ
         lNisKXhFn6O0nWHyApYvGfC0q2MmC73ceW4t9B/lpYscXnUPyvMMbg1tRoRAy9YO/fhH
         U8lE89KWI3kbFAP+KZZ2cbUkckqj5Co2cTdX8+PhfRztlQmIdpplvt1MhLGf/ukjriwH
         M2Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787038545; x=1787643345;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BvXrpqcs5lPXIdDWiOCpyiClU4baliOXlhRFFuuFV64=;
        b=YzDmQzRu8T3xMYlGnIdsXJENxNBDryFbhdhbDUNt9RzMoUSYDAC3BW/NoMc1v7G6TD
         E0ljjQ96BShFQSJFklZCPTdB1vtp7PTJXkfPuZfRKIhu+GmbnW2ESiGRwPSdYU9jfA46
         Lo73ci6FhcmlktudZbboVzt1uFaJhPfj6tl5+3HE+zgnUuZNquemdFKUgdqGur4a3Eii
         0oknZBslyCsf2ZMX5BsdVotgKAoxGj6vcOxsVC3BQIMtqgraTLsotq2qii4vkyiiHHbu
         tw0ZJbQFF3aPLsEMP6cM4LrJx4DBg2cACJ6up6hgVjCh6OkgDp5iu1lAK+zaLHRFvFam
         Jp+w==
X-Forwarded-Encrypted: i=1; AHgh+Rp2wSMi+PAwalpVqS5WwkUph8HaVRgO+HdqHOqKorDZ/eVeDw3QjI1hw7Q+ZVxegufVU1F2kpvKXfmst38=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwCsiYGbrvZpgafMo6+DbCpuM7AwYtRf1nIi7NwQwxCa45ozWs
	2o6ue4HDnNk42zlVOCl5Q7rO2MFNsjXYd16lSmckcgfsMwhymzO2f4moZY3cVpS6I/LsBvfVNND
	6DBZ3s9IIPdjC3Vhd9oAsZnNUYXIesTkwyFx3X3z6eyu3rcHU39YfGTx/UCYR8sNLLPo=
X-Gm-Gg: AR+sD10y7apymEQvsoIeF4VopYDT8neQLUcjMAi1vf7/i9zE1e9GxuYqXVARwQKwnKK
	gPmIj6Ydqfp6Yq7yCWxvNQPGy0DQBG+FV4ZG4za2H1WXsJJCqkhpy7jZiZDe/E8OdBFkDxsWGcT
	LoF6kfiR5yDhN4w0VI3pqC/OsWsGKf/UZ2HnZqWkMdvhsAqceKnJ3LPwSCUAIQvi1OatyfEZUdC
	B6qHq06KwhdRTKX+tUfVGG5jHYGv61ly6K/Us2+bq4HdDNqGeomSCsTgEPzrsnScZRLFcjQxnIY
	gaE2cBAs8WhkEYdCpARqdAsIBzS6dMBTblbSLEB2X6qh4ZtTIUAsxWtRa10huBd/hCT0kyHfdrm
	zDRtpHfW4Yf4S8fLMx1OPVdIrMw1HqTT1H+0S+rUQv5e28ZNX9/gGbQ==
X-Received: by 2002:a17:90b:2802:b0:38e:9e9d:9209 with SMTP id 98e67ed59e1d1-3955aa42a2amr7910913a91.17.1787038544682;
        Tue, 18 Aug 2026 00:35:44 -0700 (PDT)
X-Received: by 2002:a17:90b:2802:b0:38e:9e9d:9209 with SMTP id 98e67ed59e1d1-3955aa42a2amr7910821a91.17.1787038544141;
        Tue, 18 Aug 2026 00:35:44 -0700 (PDT)
Received: from [10.110.9.3] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3954de0f48esm1673404a91.0.2026.08.18.00.35.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 00:35:43 -0700 (PDT)
Message-ID: <ed4c6700-57be-4975-9ff9-bb33098766a1@oss.qualcomm.com>
Date: Tue, 18 Aug 2026 15:35:38 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] soc: qcom: ice: Enable PM runtime for ICE driver
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
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
 <01578e6a-d10a-46df-bb32-fd45ecb365d7@oss.qualcomm.com>
 <f0b90edc-6584-4b30-a2d1-e72139983fdb@kernel.org>
 <60b775b0-5482-4b95-b37e-ba5764efc0cf@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <60b775b0-5482-4b95-b37e-ba5764efc0cf@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: xEX-yRTf5Y8nQnn_Go_SNi6dWewftLqn
X-Proofpoint-ORIG-GUID: xEX-yRTf5Y8nQnn_Go_SNi6dWewftLqn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDA1NSBTYWx0ZWRfX8xsQ+8lQbInS
 24ei3DhhAZ1okKdWzfpMIRVr6i4LNlZWAAYEsnMUmcKjcYxkv1FpmFudLQpIYf1cOt2PkmGl9AU
 Kt4Dpk+WGyr2k1AouXBfO7YWI+4YWBL8Z4UStgT1QFAoWUTq92sX97Qz5s56V4i6/GNuQy3lhid
 b43f7QvPSHaFK69gq6Dcvlm2H21xCo8+qo7fimo6ggwJeny0W2qmOVGR2PCKo8WMvK95Bx3D4Mc
 hEgrqaz8URw/WcNb5II+Hp9UTRXsPgOFiQSaVcYiAeksQVIYRMuaTqm23PCYqEzr/Of/op1jmli
 94IKfYw3JNXes4SFUi565ywKLp69FkQe4vrhgGbKSRmEk2uDcX8tSnDuy9YxF5ayi5YuhD9gfDq
 p8tGqzb8ZwyxB9ZOn3ry6GV+17Uk9YD5VbORKn7nsvS3CgChMOOK7xMtNkDEvKB/xf4Pnnip4DZ
 wUKeD4/wHwQIrAmmkWw==
X-Authority-Analysis: v=2.4 cv=Ruf16imK c=1 sm=1 tr=0 ts=6a840b51 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=zdAPh6cMWLyj7RvgIaUA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDA1NSBTYWx0ZWRfXxMUsWpo89R58
 rETkbCBjEHNOJqw++YApDRVhTJfg8WiU1sl48rzkCcTKT3WeG/K58rPl/cfy6iE51Aodg8goM13
 ZhcjR2PM9UThEoez06I5fBNrJ/eUaEg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608180055



On 8/18/2026 3:30 PM, Linlin Zhang wrote:
> 
> 
> On 5/15/2026 10:48 PM, Krzysztof Kozlowski wrote:
>> On 15/05/2026 16:22, Linlin Zhang wrote:
>>>
>>> Hi Krzysztof,
>>>
>>> Thanks for the review.
>>>
>>> For the SCMI-based platforms (e.g. sa8255p), the ICE resources such as
>>> clocks are not controlled directly by the ICE driver. Instead, they are
>>> managed by remote firmware and exposed to Linux via power domains. As a
>>> result, the ICE driver cannot use clk_prepare_enable() directly to
>>> control the hardware clock.
>>>
>>> The intention of moving the clock handling into runtime PM callbacks is
>>> to align the ICE driver with the power domain framework used on these
>>> platforms. When the ICE device is attached to a power domain, invoking
>>> pm_runtime_resume_and_get() will trigger the provider (remote firmware
>>> via SCMI) to power up the device, which in turn enables the underlying
>>> clock and other resources.
>>>
>>> This design follows the guidance where the runtime PM framework is
>>> used as the common mechanism to abstract both:
>>>   - direct clock control on non-SCMI platforms, and
>>>   - firmware-controlled resources via power domains on SCMI platforms.
>>>
>>> In both cases, the runtime PM callbacks are responsible for performing
>>> the actual resource enable/disable:
>>>   - for legacy platforms: clk_prepare_enable()/disable_unprepare()
>>>   - for SCMI platforms: power domain on/off handled by firmware
>>>
>>> So while it may look like an additional layer on legacy platforms, this
>>> approach provides a unified mechanism without requiring separate driver
>>> entry points or special handling in the upper layers (e.g. UFS driver).
>>>
>>> That said, I understand your concern that introducing runtime PM solely
>>> for clock gating can be seen as unnecessary overhead on existing
>>> platforms. I will revisit the implementation to ensure that:
>>>   - the runtime PM integration does not introduce regressions for legacy
>>>     platforms, and
>>>   - the design clearly justifies the common abstraction for both SCMI
>>>     and non-SCMI cases.
>>>
>>> In addition, I rewrite the commit message as the following to make the
>>> intention more clear.
>>>
>>>   On some platforms the ICE device is placed in a firmware-managed power
>>>   domain. In those cases the ICE core resources (including the clock) are
>>>   not directly controllable by Linux and are instead toggled by the power
>>>   domain provider (e.g. remote firmware via SCMI).
>>>
>>>   Wire the ICE device into runtime PM so that a single pm_runtime
>>>   transition is used to bring the ICE device up/down. When the device is
>>>   attached to a PM domain, pm_runtime_resume_and_get()/pm_runtime_put_sync()
>>>   will invoke the PM domain callbacks and let the provider manage the
>>>   resources. On platforms without a PM domain the runtime PM callbacks
>>>   continue to perform the existing clock enable/disable locally.
>>>
>>>   No functional change is intended for non-firmware-managed platforms; the
>>>   change provides a common control point that allows ICE to operate when
>>>   resources are owned by a PM domain provider.
>>>
>>
>>
>> Nothing here resolves the comments. Also, it's top posted. Honestly, I
>> won't be talking through you with LLM, so consider patch NAKed.
>>
>> Best regards,
>> Krzysztof
> 
> Sorry for the late due to personal matters. 
> 
> At that time, I reviewed your comments one by one and provided answers, then
> let AI polish the answer.
> 
> I'll add new replies after your comments point by point.
> 
> Thanks for the review.
> 

Alternatively, if you would prefer to review a revised patch series that
incorporates the changes we have already agreed upon for patches 0/3 and 1/3,
please let me know and I would be happy to prepare it.

Thanks

