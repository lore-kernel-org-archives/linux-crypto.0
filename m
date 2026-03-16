Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759451A9FB7
	for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 10:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773658744; cv=none; b=f8x77cGEtxEwIQZmcJl6FrtuVd3nBd0aLmHEAuhkyvjjqP2AYo+ccVIJNkkTuSmi+76zqNNJqXmJQ59F4Bsdo0cRCTIZ9/AbNgx+5WnHeMkYW8ereB4LqSFp/FRxkbX7HDTTrnOuQBDMDSqvseQSl35V9LhljlpF9u4xjZwpsq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773658744; c=relaxed/simple;
	bh=Cq9/tNNowWbWN+SRb965lUUGFrgBT94hxzirPv+7Vvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HNLxy9R6W8vT4cDXhAJ9/0DfLL1YLUF42spMSYiHWiw3dGnNTGhGc98QitDNkfdsnADA0+wlMcnfHRwYcYahCaOmiwUzOJUqxttG321hLBZEG3WI8HdH5+Ph6sXZRmV0G3MKDVL8Gj7COhgAWMHTl3NJicU/lBBt5RRgnu9DRWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=csT/I7l6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YwXUzeLd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="csT/I7l6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YwXUzeLd"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G64noc1724882
	for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 10:59:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	iEBCBWOuvOwrAKBTQB46BQsEOuACakW06XjRHsukSoY=; b=csT/I7l6DY6IUV3q
	9kyEw5cHwln3f6qck6kCB+5r5vmgKA3kfFEd2lGGkABfNAYvZdpigJnM3o7BJukE
	kSYKOoWC5pks/EwrYjYv4kC3iRGbGD73WRgJhgeNi5I1w8qJwcyxE7H0AezqNZhY
	KLplJnvnp/9ta9Wm3uRoxhgU7TbjEfVC1bxrE8bfaCmXHcfY5aFHb6peaz4BPv98
	h0a6ehSCaUeIkyFnFSTWYwwKJYF+Y6T54SRIwBzEAKpCMwuc8YuHMmNHUgEGMG4b
	QseUb+PJKvsC98b6+e/bqwht0XGsaku4UZKytNmDuBNKoHhj8ehutXIK8qKL4BbI
	jr040Q==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cw0udn7ya-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 10:59:02 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ae4b96c259so63727585ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 03:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773658742; x=1774263542; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iEBCBWOuvOwrAKBTQB46BQsEOuACakW06XjRHsukSoY=;
        b=YwXUzeLdRaBwiQ8ibYp6Rl98OTbkL0VcDRE2CFC5F1fOntQOnbyl7GscUdOKJwRiGV
         DHoA+mw5cD3s+wfY66I7nv5gUtsgXOJCRJIrHX2XAmAgQCVzrvZjcKmc5qwg0EpdXdT9
         ss/+v/lZMX4tPkNI0HVg23YwXDGUiU63MsTF6TFGMV7gue8SrP4Snim/pJhQLQ9Kzs9V
         l2zj/on7XoOd60FE6YS1l10Md7XoFDYsD96dSSs4lXelQ63UC8e9ekFStlhYRGtMqw49
         9GkI4p4bLWfD+5srbacsoh7oXgYrcAfADt/04c62lTo+vFD6thj/gCjI3Rs7adCqJO3U
         d19A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773658742; x=1774263542;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iEBCBWOuvOwrAKBTQB46BQsEOuACakW06XjRHsukSoY=;
        b=l+qk95Txmu2AEAjFaaqEeSlX5NyGlFDVLmpD73IB13eg22XHH5IvNx0WoLuhhz7nKs
         /hv7trGExXdFBh833b0hSdmyVMkzSz7BTPgpwrTVHUD465n4wmnzfoViCo/eVIRbFi68
         tsI+fgjCrNHMNS/MW6B7bUEGx3K51GqymPttJNZdPaQ9cyoDO26wzNuZxAY/hyhuvZsx
         MXsmWSzR6VTyEXJ2OXwcsVB8lbVmCNzhNe7gakQQMatH42bDG7BDw0VuQzhdsU3iF5ns
         Ag3eGOKGXpMcTTEjA84WqdOsmtZrTV29jitxxHaxxNJzaDn4pRtYdJn2dl9XseYWzX61
         z9mQ==
X-Forwarded-Encrypted: i=1; AJvYcCUK227vm5pB6c/lawH9LodWCqJM/GHHIEWcFwFfxxjg9vsObO6d9Pe/BpvxYamElOm2kVXyvxWo0ECWg7w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRCDYAySerbE39tpP6xTypGqHpEBbWxMrSgtIrp4L2G79DLxAC
	XCBZ2jaDoGOvP8x4gbv25qKGkknscF6M+R0wD5EImfHIqKxiT0YG3uHvwDbgR9IgMuwURvuWHXd
	00ehI44mTPSV8HqK1iX38I2nbNIMTSkrY4c/09SjBJGY86pSQc08lR/wuqvk5EbjKgP0=
X-Gm-Gg: ATEYQzxOQAxTav4kAayqcC65nzTnHy3mDBIzq9aczX29X/FJN6KW+u2EOxG7R+hzUGA
	R+wbaSn2Jgas/1EQNg9SVYIYAAefgCkuSaB6K7TmuY7ei38ZAwTJsxgUvbHmynBYjT6r8SdEJ+U
	fvVHX1W+q8+ILwgsVC0bgsXxjp3G8kU6j0W+9L3WegmKSiSE+lRsacJ6I/9pD8O8rWOKx6SCmaR
	U5eG/sZvFgG4N9iENCorcMtEUalgtXG1qnwLF5fQ7p2KzcRYqn+n4S2T2n3QARxVsnD90jmBVOF
	I2JpGKyvk0i+/q8t/6qDd2mK7LvUinMjmhBHcG9TJZAZ4SjD1k1HqpT7/QB1yiIHxyyA17MKFUX
	h6Bes67IwsVQxueUa09KPBNRnhlfx51tD4/nq8who8GLjr6IcSsQ=
X-Received: by 2002:a17:90b:3c81:b0:343:3898:e7c7 with SMTP id 98e67ed59e1d1-35a21fdb688mr9715898a91.12.1773658741995;
        Mon, 16 Mar 2026 03:59:01 -0700 (PDT)
X-Received: by 2002:a17:90b:3c81:b0:343:3898:e7c7 with SMTP id 98e67ed59e1d1-35a21fdb688mr9715875a91.12.1773658741505;
        Mon, 16 Mar 2026 03:59:01 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35b9230f2fasm5248548a91.9.2026.03.16.03.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 03:59:01 -0700 (PDT)
Message-ID: <fb8cb7ad-68ab-482a-b70b-5367240232fc@oss.qualcomm.com>
Date: Mon, 16 Mar 2026 16:28:52 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/11] soc: qcom: ice: Allow explicit votes on 'iface'
 clock for ICE
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org,
        Eric Biggers <ebiggers@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Yuvaraj Ranganathan <quic_yrangana@quicinc.com>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>
References: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
 <20260310-qcom_ice_power_and_clk_vote-v2-11-b9c2a5471d9e@oss.qualcomm.com>
 <3a80a27a-0586-41ea-957d-77fa3d023675@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <3a80a27a-0586-41ea-957d-77fa3d023675@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=BJ2+bVQG c=1 sm=1 tr=0 ts=69b7e276 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=7T9o6mVONip3bYQ_lJkA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: JQdhJ7ePGvmeWKpji9_nOTwqAeNm5dew
X-Proofpoint-ORIG-GUID: JQdhJ7ePGvmeWKpji9_nOTwqAeNm5dew
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDA4MiBTYWx0ZWRfX0PKP9cYQgKZi
 +o7E8FIufpgvusQi2PULZC2pyoVMi7ErhMeQe/TfYjDm0VDaORbtVOhEhfTqqI+okXSF3e/83QW
 f32yqVZLCfX9LaumCa3ndG9wGgbZ0rvZ4ibP7RHgR3gaqoBCtvr6weKP06Tde0JNzf6NBdH7CJr
 KHvFy4pEQ5gBAzoZtyuixQGhO3QC3e6DcpHAkB9RPfbRky9xhIO2Pyt81bKhs76jemwFw/D8hf+
 Pb2BuZQ/8wpyDi/o87FJR+DUk6E0ICuehXeGqiLSFS05gMcULZaGwQkNeWhcWqvELNx921Ou/Fd
 G1b1DfrqI466xm9n6FWpqE8c+8rnkTl5u+5w/FIiAblNOGVPAcSoc76wcXHb0+pWbSwvMdcnbix
 pBVgE3v5Vb552gZX8pVq4O/q58EZ/pheQIPlCPVG3Oy0b0m+7YddJAdI+R4YKxGFSBZx3bK3Vcv
 kqUpFKsVPI/ewxE/I/g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0
 bulkscore=0 impostorscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603160082

Hi Konrad,

On 3/13/2026 5:21 PM, Konrad Dybcio wrote:
> On 3/10/26 9:06 AM, Harshal Dev wrote:
>> Since Qualcomm inline-crypto engine (ICE) is now a dedicated driver
>> de-coupled from the QCOM UFS driver, it explicitly votes for its required
>> clocks during probe. For scenarios where the 'clk_ignore_unused' flag is
>> not passed on the kernel command line, to avoid potential unclocked ICE
>> hardware register access during probe the ICE driver should additionally
>> vote on the 'iface' clock.
>> Also update the suspend and resume callbacks to handle un-voting and voting
>> on the 'iface' clock.
>>
>> Fixes: 2afbf43a4aec6 ("soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver")
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---
>>  drivers/soc/qcom/ice.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
>> index b203bc685cad..e05dc7b274e0 100644
>> --- a/drivers/soc/qcom/ice.c
>> +++ b/drivers/soc/qcom/ice.c
>> @@ -108,6 +108,7 @@ struct qcom_ice {
>>  	void __iomem *base;
>>  
>>  	struct clk *core_clk;
>> +	struct clk *iface_clk;
>>  	bool use_hwkm;
>>  	bool hwkm_init_complete;
>>  	u8 hwkm_version;
>> @@ -316,6 +317,13 @@ int qcom_ice_resume(struct qcom_ice *ice)
>>  			err);
>>  		return err;
>>  	}
>> +
>> +	err = clk_prepare_enable(ice->iface_clk);
>> +	if (err) {
>> +		dev_err(dev, "failed to enable iface clock (%d)\n",
>> +			err);
> 
> dev_err(dev, "Failed to enable 'iface' clock: %d\n", err);
> 
> (this line is very short, no need to wrap, also some nitty touch-ups)
> 
> [...]
> 

Ack.

>> +	engine->iface_clk = devm_clk_get_optional_enabled(dev, "iface_clk");
> 
> Check for IS_ERR, _optional won't throw an error if it's absent,
> but will if there's anything more serious that's wrong
> 

Thank you for this insight, Ack.

Regards,
Harshal

> Konrad

