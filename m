Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EE63F23DD
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 10:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768905680; cv=none; b=cZTVlsjQgbfpG4+VAc6U/mflI6KT8LZXRJuVjTqHpwPxq0V78f78vvnApViiBwWO/YJXx3o3Zh0tBZkZSLHZXuSI2Ag7v0xuRgQTOyk58j2v7mSROPOe7lBwXxk87tCRZhHhIokFQOHa1KjdxwtAGhEVW4LtEt/IPp1TmUqReAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768905680; c=relaxed/simple;
	bh=6zLovzyGH1PU5jlqZN0tFJ3tckCwLjz4OErAb71FPBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iAV9o+1drvoBtjVJGYUJ8IcEoY6ADHjoVhXm0K7pD8tgmXorH7LgVfv5ptD3wierX9y6tb5X2aSxc0/HoDCkaUVTE27mNxxTQyRtsi7UaptaoOmn6UcZSLZtEqIuSi6N2o6oMG1pUg85SGIcWUSH95DcqYe42jaYHTIyRReTI+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=W2K0ZKEh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=W7mIn5Pr; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="W2K0ZKEh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="W7mIn5Pr"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KA4W8L3805162
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 10:41:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6zLovzyGH1PU5jlqZN0tFJ3tckCwLjz4OErAb71FPBU=; b=W2K0ZKEhpz9+4mx4
	wxkmTzaEDcVKHzh32YMVo6xuApFjPZZ5jN2FpGX5xuPCinvgA6qFJ0yfIuudwlzz
	MIuiSlyeUhBHeYzzd6H2WTCI3i7UyA8TBilLIejW8119ARCQ2ljF/p9jkAwCBxqR
	dQrw/6X5mvxozhvfDOyGsdxAVGnpbKVK9DrDjoBwYTxdXG2rmB3GF7LUxUojezw3
	k5SfusppAMLcS5ByD9zB1nmJcsIwFBp0tbzr+38FqyiGGru01hvgVEGMCd7pHKhd
	bv2Ldd3pN6zqfpTCcmFj1WTKpbbOBbEh4+lTFPkIJf1AUx2DxzheIE/waHgrbDwy
	UI0SYw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bt1f89937-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 10:41:17 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c52de12a65so134812085a.2
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 02:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768905677; x=1769510477; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6zLovzyGH1PU5jlqZN0tFJ3tckCwLjz4OErAb71FPBU=;
        b=W7mIn5Pr2jwOydkPqiofamBNIez5U/9/2zQttDuMZU9cFY8Q8zNpQpb7tvIfDD2IDC
         AGDIP/7WTwaZEc/xLveelbEuNqOSGXg+rcrjAgIFONswVAbkCOqgCRqae53fuGW0hwH5
         RGkAWOWdyQ/J7BDN1yJ2IjN6yCtscgZaZxCWljkkAnEbdTJzyXxPpUKL2vPBDZJiGkYi
         nhKNgla9g/dzgp4SxrIHL5LYLxUNiVPUKpFoJ0EmNyyJi+eAoxN9aV5+3BZQKwtzhBa3
         3ic+Zp/NfO2WOzlbQi8wUmUU/CjlAuEe+oretjlDLw+mxWmbpywlA2sP21BegrBmLg2W
         +AnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768905677; x=1769510477;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6zLovzyGH1PU5jlqZN0tFJ3tckCwLjz4OErAb71FPBU=;
        b=g8sgDuQyO08Br7xkmI3QcVWWsxUN670WDq26eV0k/Jgyh2/vTmtepd64Qoyub2XQrS
         sEHZOmS8SkVEAIVLjtOtzf/yeSuHaQ5fOnWVZVM7z59akSflmntfKC8MV/sTjQHlE4oJ
         06wKp52crGFVKMkw/kvE/BFul8PlPMnq+EM/qqpkCxelycNN65FTQUEaU/tIlo8bCjnv
         MFSX+MkaQizWaXiH2ANNJecnbMUlDXOIeKojbDcHcQUA4uQ3s4i4u89npum0g0LfiNcg
         ahNSNMb8W5/1dxgwlOCXDmqP0nMeLRO1iR4ijzYX6F3EUJf4UnvMdux8Eu7LHNXCP0Gb
         ne4g==
X-Forwarded-Encrypted: i=1; AJvYcCVQbth9eKdvMic/ie0MkzJcOVLXrxsTgtPE4uT+bLwKPYvgn51dMEHk+pKCRg+lsV3gtWxBCp3HN5xr/7w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxfr0P6+diaZTFNCetuBmCipxKr899NH3xM3LenxGCTsIvgke/s
	W7Sui1eVEjiINPdJ+2KdkHMjFw/DBk/cJ61EhZrDNatcrXQ/KTjBAC7FrIv6GmQafOHO2y7jVr6
	sjj/y4xhHilsrkFD0s2LhqmqYJWBIDb+aa7ajmCIdYbnBq+avvJ9OxMLxdUPhqStYCvw=
X-Gm-Gg: AY/fxX6BgvFaV5J78uneUivZY1rWMjQhelKShXA/B5ajc4t8j1BzJZhZ0Jbg1fqqx4j
	JwxayJnYSg1/wTVVRjqq2AAokJClSNTsNwPtOESg9GuQcAdL0QTq9t/E7ycD3zlwBRZFabUBlsV
	WzAJJaJi9JqMVXGqBLZMFNfUwi2QnWb69jAAUgZ/b1ePtxGEEwX44m2Lim0jLsOoHsHmrV8t9Xe
	Pavc1C5oRR2cGdCXK3ck07eaFKfGiRt0xYnFWH4/iJpaw6t51pPwHnf0pvPpvOK42frmuy1acT5
	1mf4a3jnLOXWFg5F1MUidhOJq08keYavzgBAdc9lrt0jBkByeWz71HCJCXy4WFvA81Z4hbOF2ho
	UW5wVI3x7llehcb1Zk3fnxalys5ujVkTWMCil9PnfCIluEV+GiO4KIJOGEFzlJDln0T0=
X-Received: by 2002:a05:620a:690e:b0:8c0:c999:df5a with SMTP id af79cd13be357-8c6ca431652mr251221085a.6.1768905676978;
        Tue, 20 Jan 2026 02:41:16 -0800 (PST)
X-Received: by 2002:a05:620a:690e:b0:8c0:c999:df5a with SMTP id af79cd13be357-8c6ca431652mr251220385a.6.1768905676562;
        Tue, 20 Jan 2026 02:41:16 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8794f93c34sm1415725166b.0.2026.01.20.02.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 02:41:15 -0800 (PST)
Message-ID: <947f59dc-4eda-406c-a82d-6b16fbbc9077@oss.qualcomm.com>
Date: Tue, 20 Jan 2026 11:41:13 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] dt-bindings: crypto: qcom,prng: Add SM8450
To: Om Prakash Singh <quic_omprsing@quicinc.com>
Cc: andersson@kernel.org, conor+dt@kernel.org, davem@davemloft.net,
        devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, marijn.suijten@somainline.org,
        robh+dt@kernel.org, vkoul@kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
References: <20230811-topic-8450_prng-v1-1-01becceeb1ee@linaro.org>
 <20230818161720.3644424-1-quic_omprsing@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20230818161720.3644424-1-quic_omprsing@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDA4OSBTYWx0ZWRfX9uGrMnrzM92o
 VR3MCZBJMv8LGveJdKoMvdzQgwTaNIgL8c2jjfbKUY5TrTyZFWDiB17u80XGkUIS/DAX1GwIN/s
 Ef8fgLenzMB5yWsCd9Mt5oo7pnwmKTQDvxNcSlomkrlXp98UrXAvAZ+t/vEbI9fxbvNB9w9QLyE
 IPpg7b5lZB1DUkKDy+LVpDnR2YTnQgKAq/cX8YYfrw/Z5dcmuL+vpBCa9EPsP+y8OxOxvObc86f
 zJG8LakT7o8fbTPVfJBdwZ9a4c0eibuMGIcmehro1g3Opxu5YaNmN849Z8JYb0VaK6L0VFGQHcR
 GCaZvavF2jDATSniTvjuuGYeuD/Pw4lxzbx6CwoMVdSvvL2BrfdqSbIO9bWlIxq5ls6xWPtwbtD
 E1hZ/JrU8MS/0Fu5eLjR3CFrRGdT0/a9f565rtBwbP4Kue5mmBAUITKVWzvGr+QPGPmTQAcl2PG
 VlE3YwOumEyNWRRBGBg==
X-Proofpoint-GUID: xws2cjtrNMFHB8zBqh2BmULZoYqnv1WY
X-Proofpoint-ORIG-GUID: xws2cjtrNMFHB8zBqh2BmULZoYqnv1WY
X-Authority-Analysis: v=2.4 cv=LdQxKzfi c=1 sm=1 tr=0 ts=696f5bce cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=5B3EobkcHC48zLS9OroA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601200089

On 8/18/23 6:17 PM, Om Prakash Singh wrote:
> Instead of having SoC name "qcom,sm8450-prng-ee" we could use "qcom,rng-ee" as
> new IP core is not longer pseudo random number generator. so "prng" can be
> changed to "rng". Clock configuration is not needed on sm8550 as well. So it is
> better to use generic compatible string.

(updated the email addresses of various recipients)

Sorry for digging out this old thread, but I can't seem to find
supporting evidence for this, at least described in a in-your-face
way..

Can we determine whether the RNG generates pseudo-random numbers based
on a version number, or some other register? Would RNGv3.0 be a good
check?

I see that today we describe kodiak and talos marked as having a TRNG,
but they're much much older than 8450..

Konrad
