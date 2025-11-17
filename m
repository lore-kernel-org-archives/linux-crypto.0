Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503FD259CB9
	for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2025 12:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763382330; cv=none; b=B5vXDfwC48jraOeKioB9n9bfmXLUjMsxz3ueNshKg+wO1JcvUmmLjruL2LTR7/grx0tyFo85m3f97GNAtu2FYD7GTclQ8u8tkuGjUWAHHjmIm99SiJ1obc7ROXN4X+xAgCzjzINsvNsH92aPFsBh6xic9YAkhoL8jpc+InlD9A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763382330; c=relaxed/simple;
	bh=P+d8sacZyxf8sOydE5J52llTLlCPE6rJ4wlA6grSKz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WlXLTJoMPGUgV4u9IFT+U4S4LanZOUbtinukXw0Weex5u7OkuJBMX1Xly41sxPGgh7qyxwwrBzszMSlcecGNOrWn62KZ/xLJhI6Obl63prv41DGoxKw3k8WljCvxl2INYoujOVLvC+9ELbRH2I9u8LqwWAhZXgMXI1DOH/6Izmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bJjxcy1M; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=i5MmBRm2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bJjxcy1M";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="i5MmBRm2"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AHAqEsq3921595
	for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2025 12:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HcnBJ0YluvnOiX+mgFmMGToDm0+SVzO/dQb3CrYR4QA=; b=bJjxcy1MmyOMeQsg
	t/uCJd+U/GecRFpgR+/F5UBzl/VgWtDR3X8MIHetrGKZubUwx4N2nhPxpIak5LFm
	Izuu9rmZIBncbiKzJN2QSMJ3IwIvo4Yj59grMY03/T/+8CQdq24vwnG5yAKMh+rp
	IlWux5ZO/ht54qpIhPErOhVgAIJ4DmrLW5SpLGsLubpXOz+KS9BY02x7CLMAf6MN
	a+TJLa3NoTmzrWCrANLqqxRSYXDZSCc/Nq0ySZVPYtnrCrmInFju+P0IpT7D3KfQ
	KyXY1I8MnvZfLT6/tnuigPkHhXETIqBncih5AJAy7EyHO5oygBhSFafF3x8JonGq
	3NA7ew==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ag2ay88ge-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2025 12:25:28 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-88057e35c5bso12900456d6.3
        for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2025 04:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1763382327; x=1763987127; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HcnBJ0YluvnOiX+mgFmMGToDm0+SVzO/dQb3CrYR4QA=;
        b=i5MmBRm2STETC3m3I8wQ+CxfiloMoBuzdMUAyAQD/Jq1DvPwKH35lognF1c3rs8rp2
         zW8k8jYtwQoTwL+qWgDKjr5Ld0INlDjgV6nqzjzzat+P8DvfIFTXAbY6lJ7cI08ZvrMF
         o8Jg0f+pUnZify3ATE9t0n8l4Tq48pC23rX9YNnxchaxYVcUZDiSAYBsScPb3zHg+NEO
         zwte8wqYtHac+91XnrIoTkQ0YVQGDbQ5uWORoRlDqdF+esDFMLxP4dvSQXfq7nMnU5+0
         p0Atz7mbDzVvWpiyZUNuCezMjaevDRtSXUAc3Z8PO17+nAn6FkQACW5l3VkbH7lMmdwO
         G5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763382327; x=1763987127;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HcnBJ0YluvnOiX+mgFmMGToDm0+SVzO/dQb3CrYR4QA=;
        b=BPwdS38SBHRtdDFhoc7+10/FCfKWamhOmdUtdHeUt68UFxOGT+6K9RV6JSAXeh2O9N
         GS8FYkbgMAWcdLsNb2n5Fr9Y4hDQMJZjD265hnhgNg8HBdsj9TbaKDw58VwS9UBZe4UC
         Q025aPZmoLGlnwmOEGZQiAU6uvpzR+135XiQOoGbpDqh+uKZSRBcqSS1hZ1ES1dYJqh7
         FlOdK+l+aNZHsCmBL7G5Cv8Sb00n0VixIHFALCs/kewXBlfNO7VC2hX1LP3uADGVwUjZ
         n45LD7G0ZSJuqG+2txPdGN1xlUjTTV9NHJi7aB7kfoY4n4zirHe1asdbV1bJG4psxrNO
         NPsQ==
X-Gm-Message-State: AOJu0YziuT3O1C8uQqEBpSru57BQhnbKTHj0X4PYhaa9iUarocXbM4Vq
	TZPRq6+2wKcI71Y5Lp76OTDLezdsPGSC0Sea1t2/5ZrSw8p6WLkN4jsh63rkChjGR2pJWH42E8C
	XPBUwWTpjSZjoAmzPg21AzCehzIgzRj904f2Vk9p9mIMlAv0jlUHQrjmxDqgzAOHdztw=
X-Gm-Gg: ASbGnctYb/6On75xu1Npg+RJHHbGaCKWBQk/vgNSubszgtLEcJtzYxChyDBEyYsFvMw
	9/gfskow96gOHnNE4Zj1q+qW21r/Nujp6UEBw0f1gYyh3UlpSREpIIPo9JqIHLp4dfgmjCHkBrH
	eX0t6ZD9jo7rRw2AFNPvbfs8W8stVMJJoT9jH9hEpC/8//CFT5tND5RPv+mTQQXxyKawpv1CFTu
	rm239pM7OROruLNafFHZbpRAyrHkrBfn1RMlzZkIlTglW6Nr+QsuIioIqqSSTv5jhajTuABEz4f
	3ItxoNhjBjZJCo6DSi/I/SS65JioBHHDpqnyAR1/lPlm16djBRLDrtrGdVOqqiqiNIt7v6gWFLQ
	cOzWiTYw11gFawz14aZHEqv7M9wkrtJCt/+Png+1yqYbr2HQPKUSDheIN
X-Received: by 2002:a05:622a:1789:b0:4ee:1fbe:80dd with SMTP id d75a77b69052e-4ee1fbeada5mr30186181cf.5.1763382327439;
        Mon, 17 Nov 2025 04:25:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFfSNmU8uxLAx2+GBUaC/bFUZi8vJWAJobCJFphyvwWR5qcEz6mk2Tyl/ktuieNSquY5mhGw==
X-Received: by 2002:a05:622a:1789:b0:4ee:1fbe:80dd with SMTP id d75a77b69052e-4ee1fbeada5mr30185981cf.5.1763382326879;
        Mon, 17 Nov 2025 04:25:26 -0800 (PST)
Received: from [192.168.119.202] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a3f8e6dsm10158525a12.10.2025.11.17.04.25.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Nov 2025 04:25:25 -0800 (PST)
Message-ID: <121a5d34-e94f-4c29-9d58-4b730757760a@oss.qualcomm.com>
Date: Mon, 17 Nov 2025 13:25:23 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] crypto: qce - Add runtime PM and interconnect
 bandwidth scaling support
To: quic_utiwari@quicinc.com, herbert@gondor.apana.org.au,
        thara.gopinath@gmail.com, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_neersoni@quicinc.com,
        kernel test robot <lkp@intel.com>
References: <20251117062737.3946074-1-quic_utiwari@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251117062737.3946074-1-quic_utiwari@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=dL2rWeZb c=1 sm=1 tr=0 ts=691b1438 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=COk6AnOGAAAA:8
 a=f8mhDL4D-r229udWvQMA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: 7XcE7c6h7tiVGKWda-lgS81NPONn0BQ-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE3MDEwNSBTYWx0ZWRfX+83JokY1uBNU
 qDtg8fXmBnR5vBfKcq6yralyVWwHKqFefeMuM1xxEshLwI3jWZrWlttqQIA9g1eq2OX5v9PBOKi
 OKkjQH0KzjgRk9F2b7uAtAVJo92oPpzYHZTFZirfIYuO6ON7h1gWdmqVwvNa2nSMkV7zRJd5C3B
 F2It+rGnI4x+SbUZgzu6SpJuq7jXNELOepL06yrkeeDsrkK54QUq4isPZlfZ9WyrFzShs7M1A4D
 6bMj0QhbnIvLkJJRNkRr+oV8CMiGXs0NiLkhPFeVoQG4yFAllVSkJ+h6VKzN634zYbXidZmo06z
 xIqai2KrLwqTTTP6dYZD8FX4J8+DRlt072xJYDqjfPxIHsV6sBMr5z08edUTmqbHuzdHvB6gx2J
 /o7aCb93aQc2Uvw+PnMD9LkXRqpXlw==
X-Proofpoint-ORIG-GUID: 7XcE7c6h7tiVGKWda-lgS81NPONn0BQ-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 suspectscore=0 clxscore=1015 adultscore=0
 impostorscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511170105

On 11/17/25 7:27 AM, quic_utiwari@quicinc.com wrote:
> From: Udit Tiwari <quic_utiwari@quicinc.com>
> 
> The Qualcomm Crypto Engine (QCE) driver currently lacks support for
> runtime power management (PM) and interconnect bandwidth control.
> As a result, the hardware remains fully powered and clocks stay
> enabled even when the device is idle. Additionally, static
> interconnect bandwidth votes are held indefinitely, preventing the
> system from reclaiming unused bandwidth.
> 
> Address this by enabling runtime PM and dynamic interconnect
> bandwidth scaling to allow the system to suspend the device when idle
> and scale interconnect usage based on actual demand. Improve overall
> system efficiency by reducing power usage and optimizing interconnect
> resource allocation.
> 
> Make the following changes as part of this integration:
> 
> - Add support for pm_runtime APIs to manage device power state
>   transitions.
> - Implement runtime_suspend() and runtime_resume() callbacks to gate
>   clocks and vote for interconnect bandwidth only when needed.
> - Replace devm_clk_get_optional_enabled() with devm_pm_clk_create() +
>   pm_clk_add() and let the PM core manage device clocks during runtime
>   PM and system sleep.
> - Register dev_pm_ops with the platform driver to hook into the PM
>   framework.
> 
> Tested:
> 
> - Verify that ICC votes drop to zero after probe and upon request
>   completion.
> - Confirm that runtime PM usage count increments during active
>   requests and decrements afterward.
> - Observe that the device correctly enters the suspended state when
>   idle.
> 
> Signed-off-by: Udit Tiwari <quic_utiwari@quicinc.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202511160711.Q6ytYvlG-lkp@intel.com/
> ---
> Changes in v4:
> - Annotate runtime PM callbacks with __maybe_unused to silence W=1 warnings.
> - Add Reported-by and Closes tags for kernel test robot warning.

The tags are now saying

"The kernel test robot reported that the QCE driver does not have PM
operations and this patch fixes that."

Which doesn't have a reflection in reality..

[...]

> +/* PM clock helpers: register device clocks */

Missing \t

> +	ret = devm_pm_clk_create(dev);
> +	if (ret)
> +		return ret;
>  
> -	qce->iface = devm_clk_get_optional_enabled(qce->dev, "iface");
> -	if (IS_ERR(qce->iface))
> -		return PTR_ERR(qce->iface);
> +	ret = pm_clk_add(dev, "core");
> +	if (ret)
> +		return ret;
>  
> -	qce->bus = devm_clk_get_optional_enabled(qce->dev, "bus");
> -	if (IS_ERR(qce->bus))
> -		return PTR_ERR(qce->bus);
> +	ret = pm_clk_add(dev, "iface");
> +	if (ret)
> +		return ret;
>  
> -	qce->mem_path = devm_of_icc_get(qce->dev, "memory");
> +	ret = pm_clk_add(dev, "bus");
> +	if (ret)
> +		return ret;

Not all SoC have a pair of clocks. This is going to break those who don't

Konrad
