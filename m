Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D102F745B
	for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 10:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769770007; cv=none; b=HKwodYb6jLaB0ldY2nCQeTwRD4kQ9m9rPaKOWJZuHtiqpX9VdSPhirqPVFPhCofOuz9MzB/kNkdtjH5nj1qhoQDLQbT2VH7fjloShVSiPRoUcnLsgjTQokhzD6xGqgIRW5vQLdDsjvjyd4lzCmd/m7ogR6j9/2torujku7wbsEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769770007; c=relaxed/simple;
	bh=41DxCDI9BLFfSiB8T28LzqLjk8IPwF3a9dLgM4flHpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ug96vlopA5AVO2KI23PoBaMhBC350aw8yLtsMC5CT1C71F4DwEIT2imKLYR47g4WejFBaT0iPc17IeYv0JRqXsQ690WNzHgFhkhBar/xDuwy5Esp2Gu+Y5UbdnoHCY15xWkO9xCKG0U50Ahn3qhDBHCzGMLUyIwP3uyT/CYP7hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Es+HWqlm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SRY8vSr3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Es+HWqlm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SRY8vSr3"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60U4tqgJ2295325
	for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 10:46:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eZsEGCm6nNqyjRWqQjZl0F8JQuVVl2PSAjQwQvNXoBI=; b=Es+HWqlm+VyDDgxj
	o2eD0d5F94Bev3NsX1ujj3HTp09Bp14zOFDc72zC5aP0QrvmBkVCVnWX+5Tmv7IA
	dZEUNIT8CS9C5mBUDQXy3bluifOlCf9iremn2J4eYplhVPdr4UcrslUePfphl+yM
	OLQfTD3rJV2dAtDGi1NCHXIz+M0mn/3dUzmJ7eEGgcxnUpUiypGeHTDKg/idbceD
	Z20yAqbb8J4+ZF5Dt3R/odEbmj0yC66C8oatnjJd6nGgF4D9daEUXnDSNmciPRoD
	BPhvl1V/vY0mauJI1b5SqDdj3qhwQ/FfAyFwNiYyonKEuYlHxTUWDlS/ymDWUVpO
	XF7NVQ==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c0p1x8ytr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 10:46:45 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8888ae5976aso2033146d6.2
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 02:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769770004; x=1770374804; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eZsEGCm6nNqyjRWqQjZl0F8JQuVVl2PSAjQwQvNXoBI=;
        b=SRY8vSr3KHXgOQLiEqHMBedsCDpbSsF05/m3yovDRTeT+5J0+gA/+UTCS10ugxmRCA
         QKAM9MGlA+fBVMVVgQH7GPvwo4rO3DkmUaXhk1HbAPD1xt+CBE0O6IoqXMBlVCMEKRbg
         uueU9pTg35UCnk91fyRmJuSEQV6ld/J8JwegHxUxQc4YILicBkv9b3zo953xmHXriWSS
         qK7r0WfNf9nDr08SD1Ch+J1crvjlTAvAvAFELfQk4nH3veVXJ5Q0LKUzD3ur8xr8dj5N
         pzTvHZeDHhg7r4cu+vFVDjISqIlBM9X9WLOJNB+ZTQJAdvmPo6cd2Ccl5HL7HVuSAOVW
         001w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769770004; x=1770374804;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eZsEGCm6nNqyjRWqQjZl0F8JQuVVl2PSAjQwQvNXoBI=;
        b=EXKsqG9VUleMqY64Z4wiQ7F1NFF7LH/1vVLhOOfrp9L1J5Y08JpqswQB8Gax2aF23T
         lY7/NOWQonynGybvtMr2V33veW3B6xbC/VlxHxv5rZ/iZWO6vBXH1EyXdTNVhnlQAAlk
         RPl/Iybatb4b2JvQy1IIdRCItvngCcYSa52OHQ2dWWBTXC6CJD6dChBhyeHdLCx5E52F
         TLoGnOQmjam/7xVBDBp6qORqeYa39FxqGY2DpOalx+w7Db7h7sX21YTXVONE9vaFdadS
         vWI8bi0cEG3jBMsmaa787YhA9PjMkyka20zdFtnGD2bVffsw7q3ih1mD48q4PP4p+yqj
         KJLg==
X-Forwarded-Encrypted: i=1; AJvYcCVewDlDRi/4jF1N/gn58jqmi4ehoyEqliCj5nWYUTo6C3c0xD1vNAzNhKt0tCY08PQlCA8AWiny+JePq08=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFy9koYF7jcYQaOmzapdsPPLDYV5ZJfdC7BAhiDHw2/XMVE2Xd
	5NS+6KNM0TagrBj/lF/nOVxdgXAGyca8Zdwq1g2GVynOdBD7S4gicAzI5gxUA8OtqnvC1t22cy2
	xwsve/G8+p8jXru7+f/nQ3+/gsc5b7wjtvFRE6p1fUOsxySYsR/3p9JZGMoBsIguXKeM=
X-Gm-Gg: AZuq6aKsZ63QAdW+4CpSrckT/wXZTUs7/FKHoO5MxKKJa7QAWiSHjLhjDT0iDPsxO7T
	aVqavikIF8DMzYDrVd6c6ccCVJzPwM1+LjdUkaxRufZWsiIUBX7TniZedc91TGifVZCuW11AZSM
	/QeVuFiXM6o6+7nQgJQ8iDz1OmnzgdGccoYsyT5xMstL7Dff+EpbLejRSdgaRKIyprWRm9j0M2V
	lS8km73MOiPJOtJvAOOu0sHUtlc8c3tYqOi6IcVAwLgrKzgJ7rmrZ3sa/HLgMKOZ32qeXhGReD2
	K+sEj14kRtwm3IK96wyrQsGpUT8pVv/QvTgNaez6TS+xl3Zb9ooI1jQ8PrIug8/Db2QOqVKTWmg
	C/WP+s5QkFhscAHrO4Xk8ApH3FsEO67NWN5oRiXrDkR5QGFXwjaPoyAiAOWCwTeMUodc=
X-Received: by 2002:a05:620a:31a4:b0:8c5:3892:a554 with SMTP id af79cd13be357-8c9eb257d0amr251629385a.3.1769770004480;
        Fri, 30 Jan 2026 02:46:44 -0800 (PST)
X-Received: by 2002:a05:620a:31a4:b0:8c5:3892:a554 with SMTP id af79cd13be357-8c9eb257d0amr251627685a.3.1769770004057;
        Fri, 30 Jan 2026 02:46:44 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbefc6685sm396249166b.17.2026.01.30.02.46.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jan 2026 02:46:43 -0800 (PST)
Message-ID: <646bee0a-8b10-4fa8-9d17-030876179c02@oss.qualcomm.com>
Date: Fri, 30 Jan 2026 11:46:39 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] soc: qcom: ice: Add explicit power-domain and clock
 voting calls for ICE
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
 <20260123-qcom_ice_power_and_clk_vote-v1-11-e9059776f85c@qti.qualcomm.com>
 <7da1727a-c1cd-466d-88fc-e140b2e7fe5d@kernel.org>
 <54bf72b6-6397-4655-9c30-680b1374400b@kernel.org>
 <82a6ba61-94a4-48bc-a012-d09152b32781@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <82a6ba61-94a4-48bc-a012-d09152b32781@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: LWGV9x7a5ypwaQmk7hQikNYE6eWDmXxO
X-Proofpoint-ORIG-GUID: LWGV9x7a5ypwaQmk7hQikNYE6eWDmXxO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDA4NyBTYWx0ZWRfX0xVQsFAiXGvY
 Gff5BmeIxnwTBMkoRwbk2Xi2Y6JbZGmDUbFdJ4qEzfRZsAjIulfoXff2WS5LBCFuv7EtWxpwi69
 +r/YgWkFadFA1u+AWFrEiR2qiyRpyWYZ1vJuWuqlWoNL1a/UvqAHoB4Avv/kh7W1318ymoHWwZe
 E3WU3R+ydU9G5zHoB9y4supraZF2y2VQLiVfg2LISngpo72xE66bWfuYhY/bdZ2afSJnmhBP5+A
 O9T66vPttQ/t0nNpSUEMayzBk4BgE7B0Gfyy7QNkFj6VVJxg2JL6gVNb88l/Bn4vbwH0YmZ3VoY
 /wFWvX1D9eXhdz3m+SO5diOxmC5hj7zBVvGGUR207sZCIa19hpVUgYw6uqXDSdruIxZDSMdD+IJ
 PpnZdSfu+9TEy5RdAtK58DbJM8qb0wynbycDYWOH3LBm1yfMZMJ//k4Omj+Srfi1MQqcF8rFI7i
 oNpHBOJ4FXlKt97I8JA==
X-Authority-Analysis: v=2.4 cv=G5cR0tk5 c=1 sm=1 tr=0 ts=697c8c15 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=CfqEwSn5MTdR7akHWEwA:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_01,2026-01-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 priorityscore=1501 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601300087

On 1/23/26 12:12 PM, Harshal Dev wrote:
> Hi Krzysztof,
> 
> On 1/23/2026 4:27 PM, Krzysztof Kozlowski wrote:
>> On 23/01/2026 09:58, Krzysztof Kozlowski wrote:
>>>>  
>>>>  	return 0;
>>>> @@ -584,6 +597,10 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>>>>  	if (IS_ERR(engine->core_clk))
>>>>  		return ERR_CAST(engine->core_clk);
>>>>  
>>>> +	engine->iface_clk = devm_clk_get_enabled(dev, "iface_clk");
>>>> +	if (IS_ERR(engine->iface_clk))
>>>> +		return ERR_CAST(engine->iface_clk);
>>>
>>> And here actual breakage of ALL in-tree and out-of-tree DTS.
>>>
>>> NAK.
>>>
>>> Please read internal guideline.
>>
>> Internal docs are pretty scattered and messy so I failed to find this
>> there, which is surprising because this was frequent feedback. Therefore
>> please update Kernel Upstreaming internal page with following:
>>
>> With few exceptions, it is not allowed to break the ABI, by making
>> bindings or driver changes, where the existing or out of tree DTS would
>> fail to boot. Updating in-tree DTS does not matter here, because DTS
>> goes via different branch, thus driver branch would be always broken.
>> This is explicitly documented in DT rules and explained also in
>> maintainer-soc profile.
>>
>> You need to either provide strong justification for ABI break or make
>> the changes backwards compatible.

If the ICE can not be powered on alone without this change (i.e. no UFS,
just ICE), then please spell it out explicitly, Harshal. That makes for a
valid reason to break the ABI.

Plus the fact that without an OPP table, the voltage requirements cannot
be guaranteed to be met

> 
> Ack and understood. Let me write this in a way that makes it backward
> compatible by using devm_clk_get_optional_enabled(). Like I explained, for
> Linux distros where CONFIG_SCSI_UFS_QCOM is override set to 'y'. This
> clock vote isn't really needed during probe.

This is really a side-effect that we shouldn't be depending on, or
even considering as a backup, since the UFS driver may change
independently and stop behaving this way one day

> In qcom_ice_suspend/resume(). I'll only prepare/un-prepare this clock
> if it was found during probe.

Clock APIs generally happily eat nullptrs

Konrad
