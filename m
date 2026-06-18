Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60673F482F
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jun 2026 12:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785254; cv=none; b=J4wh6eoMIhxOnUdCKiDiuIj+cRqktBEGhG0kFiLk7N18xeLAIXiO0M38E67XqgYu3ETyVgTMlm2EICIgIghBUy50Iqp377Wf31i1DmQDu2DE5m0f887tpFfF+gfyjHhqlUPrAPB9j1tkWe9Hms0TUySlaTyu0u2qeada3znPHTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785254; c=relaxed/simple;
	bh=GtplIB74PhHYyP/abkhb2MdhJVPsMdyuoG/lp950Tn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RxG7PJ0KNYsceLPgIWpgi2xBxeZFc0Ri9DFTnOtf0ievu80iB4617M4Nf3TXUUrN4oeFoYeYqFBn5w8hAy7MnGW1q/I0DL0NY6NGgovvdeaDl7SDgFvf6Zz4OLQB5iwIrJie3OiD4hU+cDq53vDIDEJFzRRa62b8aQowdk/cUeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RyGsABgU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WoT+dGSJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RyGsABgU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WoT+dGSJ"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65IAs1Kk1030415
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jun 2026 12:20:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WNC+MjdPQmYRBJXCHlLJ4FXMLy/ssZcMsCeR5gbt2lQ=; b=RyGsABgUW27Ipza2
	jzyUO7zjzepEd5wwzpJOkds+dUfMfx7iD73wPYnneAcZntBdqoxLZWmgHBxe1E83
	SDhbfDRmt+88clXpen/wvtV93tFYUDuV19LxCmjoh1dn5vEcJKUmspn6dKr1hoW/
	Fdm/1/CsdF+1KDoC1QezGisrBLetDc8VIG66elSfFStl0whIB0CtM3lel/fbBufs
	RsyBup8vktFHAv8MsMdsu5VxIiSAQSOtNUS6muxdW+c+EGBhhcDOUG2xMgwGEsTy
	rR0yfT+OKQxVWGpPbiiWgn2o1s1sCuHYo8AAk0iDAmMBuBh3DsRGGApN38EXtVaf
	1O5YeA==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ev0vm3bps-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jun 2026 12:20:51 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-7297b2a8689so15568137.2
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jun 2026 05:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781785251; x=1782390051; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WNC+MjdPQmYRBJXCHlLJ4FXMLy/ssZcMsCeR5gbt2lQ=;
        b=WoT+dGSJxaqVuRk23KIIJ64NOGm4OOnaCrEnP0enxOsm9dc64ssKwFCZ5O99lsZ7Fi
         uoieSuuvFaAaFZjX3nI53eDGKKpfFtF5zowXcfAhdmWZUhz3k3AOQZW36Asmm+iZ17Fg
         mBMBE4YiPhQNbcwtLnRYY7svjR0O1p+5oemZtuS/Hm/mcVIEKIsWE1lc2fujwO2z24gR
         4dL+JFzNB/vcYc8gT/P4luzGOYmZxcy9eGreddBWwreZFbvv/vmy4HS/7uH3XlXZhOwT
         BP/BVOUpe1ro8Mn4qdzBjALwupC5ynXBb7L/MgHRuF3UPRUkdKgdP/K0fQNzKao+BLIx
         +Q5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781785251; x=1782390051;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WNC+MjdPQmYRBJXCHlLJ4FXMLy/ssZcMsCeR5gbt2lQ=;
        b=piOIKrheWBuqxv59STfisVoivPnY7UeZxQCt6UvJ0aqx0RnbfYAcQnP8Uw7MqJU3w5
         lu+GyLWv0+uAoPKtLQWhEknSgJ6nXd8ljysQBjPj9eZvqZwGBjut9LHk9quCPHETynVU
         XosWcuV8n8GWcw8PfkDosFff6NEFstKEE0AWwTwWbKoJVZzqVb5L2yfwwwo1fCcp8r8l
         VD4DlzhZFD12zCQSnZSuBy/gXm6c5IFUjis58lZ/mcB9YHGifZ/aBub+8JbqaF2O/KBk
         PL6BoHSNdB43/5Ybils3C0iq9wIs60/iQR88/lWqMNNb6hyfzAa2G/I/QWfoHA6G23pq
         gRfg==
X-Forwarded-Encrypted: i=1; AFNElJ+JAZH3TLhY6z0adBjPd3aYMBFCvGUUlDqTn9BuOFuhNurS11Nj4QFSKrWZeCUsXhfqaEq2lZ/QXqqqhXc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfzZJhfUsKri+tKzOx+0i+QjNyqeaWT+gmGb6dQIkIFdQRwbch
	VT1ls1fRh8jbPNUyrYJA3zrUG68c+fDvA6wwVnjsGw7qtzjpM5KjXKgGuU6Rmxn7cOpuN5Ut86+
	dyWDFpLU8ZOgflxkMUJcChfX269BrDOv5eqJGNKX5Br5cjxBiWSsXXOs3wE5zdF2cL6o=
X-Gm-Gg: AfdE7cnOg7SP9J2x2Sx1MgyMh6U24hsdy/2OwglEX/9F+rvsczWqJzes/ngzG7ECs/N
	PfLaA+GjNnwJ9xKI4tkZGlz2K4bN3IhzwqbdKmeBpuzFORG+mr0dHoMEUTEWYEh4Nh1FNq+HqRC
	AHpjnD5v/JTTs0DPqd8o8SxlwSbGCmG9gQbSAmY29KzW7oAbDUMdqsaNx6NxZBk2CsTOP3wsUtJ
	9hpHhFB+3/l+nVXvt83brSMiSelG+1VVyUSoTsHIcY1HFtznWSKiwQo3JdHtNQzH2zaLEnfA8d8
	EMjG7/DcZkeNd0tXGDSOkB9GDXpw9IMcpGtohHH1n9Q6Lj9Iuq8tbcQmzav/Kp6Knn60hoP52KY
	NduDWZ28U8AoxyeK9BYQcCgWxTCMnPsLhzcY=
X-Received: by 2002:a05:6102:4bc9:b0:6c2:7d0d:e09f with SMTP id ada2fe7eead31-727c9ceb5bcmr670267137.1.1781785250898;
        Thu, 18 Jun 2026 05:20:50 -0700 (PDT)
X-Received: by 2002:a05:6102:4bc9:b0:6c2:7d0d:e09f with SMTP id ada2fe7eead31-727c9ceb5bcmr670248137.1.1781785250503;
        Thu, 18 Jun 2026 05:20:50 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-695b46f7f39sm1418286a12.27.2026.06.18.05.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 05:20:49 -0700 (PDT)
Message-ID: <b5287c07-24b1-4011-9805-529f6f51c22f@oss.qualcomm.com>
Date: Thu, 18 Jun 2026 14:20:46 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: glymur: add TRNG node
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
References: <20260424-glymur_trng_enablement-v2-0-0603cbe68440@oss.qualcomm.com>
 <20260424-glymur_trng_enablement-v2-2-0603cbe68440@oss.qualcomm.com>
 <814cff7c-fc03-42a0-93e6-852598943ac4@oss.qualcomm.com>
 <0debc1fb-f6ae-44c6-aa87-d5ef3e39b47d@oss.qualcomm.com>
 <b4794e93-0fd3-4559-9ecd-02d679bd06b5@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <b4794e93-0fd3-4559-9ecd-02d679bd06b5@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDExNCBTYWx0ZWRfX3orcmiNFqWpE
 RZ2WvPuH5m0qYjVAd6RInMWSvm9TOYt5W6C0d7+CqcDvP67e6Q31nJ6lumOSara9gJpdobQHBiK
 sxbXWtiHxzTNlCsPC0YdbqHOVqI47GiSE6mF9haT8D0BJpWLdMEaWpoarR2GtRftI64+FEpndHy
 7BPh5btsWCrccb0Xqm57NfYXy/n++lprCQiSjyYiaBEqmelRVDrWQGoeH6bgb4UwwtWD0MmUSD4
 /9wOW6b7rcya0mRL1dziKXmeMe0Y4TpeA0mlhy6KgO26LlMAGKLhPLW/JZ81cmVQeP4t7vNio40
 TvtdKU/ygzC5ai+YffU4saUTBG6aBW9Q1DJhmr/JygHNYZpLGmYKvcnLDu5tJ1/LonL6N5Y4U/T
 LHf05n5E70tYML74lnfTX/x/bkvZ0tpUR+kdvwadTRo5S97J3cTePk6DPaoF77DhSw9sfB5RV6P
 hf/YssPthjY5dtLqEPw==
X-Proofpoint-ORIG-GUID: OqNh9QTaOa724qOg7bGWDunTnDKUi4in
X-Authority-Analysis: v=2.4 cv=UrRT8ewB c=1 sm=1 tr=0 ts=6a33e2a3 cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=i0djx3qMVQoBlMXpResA:9 a=QEXdDO2ut3YA:10
 a=crWF4MFLhNY0qMRaF8an:22
X-Proofpoint-GUID: OqNh9QTaOa724qOg7bGWDunTnDKUi4in
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDExNCBTYWx0ZWRfX6bFnW4hBijeV
 2iH67ubm9onzKVwvK4gBLXjEWrTjZGy2zNaXgRY18SsQiKtVXp6+Psu7DsKm9pLlU8e9afX701/
 pPw6WfPimW7/juaJnv04tx6JzoyCP1k=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_01,2026-06-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606180114

On 6/18/26 1:58 PM, Harshal Dev wrote:
> Hi Bjorn,
> 
> On 6/9/2026 12:06 PM, Harshal Dev wrote:
>> Hello Bjorn,
>>
>> On 5/18/2026 2:06 PM, Harshal Dev wrote:
>>> Hi Bjorn,
>>>
>>> On 4/24/2026 2:05 PM, Harshal Dev wrote:
>>>> Glymur has a True Random Number Generator, add the node with the correct
>>>> compatible set.
>>>>
>>>> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>>>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>>>> ---
>>>>  arch/arm64/boot/dts/qcom/glymur.dtsi | 5 +++++
>>>>  1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
>>>> index f23cf81ddb77..64bbd5691229 100644
>>>> --- a/arch/arm64/boot/dts/qcom/glymur.dtsi
>>>> +++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
>>>> @@ -3675,6 +3675,11 @@ pcie3b_phy: phy@f10000 {
>>>>  			status = "disabled";
>>>>  		};
>>>>  
>>>> +		rng: rng@10c3000 {
>>>> +			compatible = "qcom,glymur-trng", "qcom,trng";
>>>> +			reg = <0x0 0x010c3000 0x0 0x1000>;
>>>> +		};
>>>> +
>>>>  		tcsr_mutex: hwlock@1f40000 {
>>>>  			compatible = "qcom,tcsr-mutex";
>>>>  			reg = <0x0 0x01f40000 0x0 0x20000>;
>>>>
>>>
>>> A gentle reminder to pick this patch for the 7.2 merge window.
>>>
>>
>> Another reminder to pick this patch up in-case you've missed it.
>>
> 
> Gentle reminder.

Bjorn and I were both out at the time, after we returned it was too
late to accept new patches.

Currently we're halfway through the merge window (where Torvalds
receives pull requests to create 7.2-rc1 out of), during which
contributions are not accepted. They will resume in ~1.5wk after
7.2-rc1 is tagged, targetting 7.3

Konrad
