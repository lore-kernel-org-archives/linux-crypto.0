Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453DD2BEFFF
	for <linux-crypto@vger.kernel.org>; Mon,  6 Apr 2026 09:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775468720; cv=none; b=X7kD9XSFrPV7yalrn+Mie2nD3JLSwpC7HORBT31J8Iu1XkG9LNx+Yse4NIvGrOu4BIYr605FQL9MaeSpm3tFywxS75eI8/Fw7xsOGtRU5sK5mrhZ0UUX23vHzhSuMHDxkV6LHLc09YtwoVL6HIkGMoVHSS1jvpAum8X4OoPh52o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775468720; c=relaxed/simple;
	bh=1u78RXdjFRE8TxNL8SpX8vkad/jIF0dr3dj7UAs72lI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=qo3gXiJNt12zq6Y/f5KS3TU5N3Mv9yn27bN2kZzetXKe2+eK73XJQh2xMTrtcruvKs9fHgSoUBBaC5mAMf+OglgJYtL6fqsMG5GJZxy98qVKxSkFFvdmh0S4pK2wyY6N/PjAwbFedhaZrlSYGK8CNn9ZKV9QZ8vT+caBjrqD3zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ILMPjt6k; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=g4KnSMWs; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ILMPjt6k";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="g4KnSMWs"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6366oJ3w4094879
	for <linux-crypto@vger.kernel.org>; Mon, 6 Apr 2026 09:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ylqmm6Fk9xqXkNcpz9CG1tMWJO34U6XEQoYsL6L/otA=; b=ILMPjt6ku9lgo8LZ
	bU7jtxwq1myBY8TMvO90CnxH5vm2eh7a8sh0LlegI6tZXEbIeREkPz5QiSOtpl4P
	FNWLEripT6vXBCg+0jku0xOtHAZFhs0QnTWGU84Y5gbbPOT6GRDNjo50GQf8I35V
	JGm9YHB5+byY3TGd1bua4w63WfYHalLzBm2yx3HGfAMZxzQ/PaBtRFV8u+e7GTXT
	oZEfrKgxVuq1hEsCSjdtYrdGzn35dQukoqCHUKpW31J23UBU5+cF2qlXEzhyhwS8
	fhC2LKwE9BkCjR7OxhzGbdbWzrE/ZFQi5MZQ2n9LIohsxDDpL/5uriYccEYcpd4N
	R897ww==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dasyfmqwv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Apr 2026 09:45:18 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35d9e67f6dcso8633770a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Apr 2026 02:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775468717; x=1776073517; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ylqmm6Fk9xqXkNcpz9CG1tMWJO34U6XEQoYsL6L/otA=;
        b=g4KnSMWsfxz3fjHT3XPF6pHZf47U2IsuTwDNKyKxek279i721QP2zZFecH6YsDtqae
         mpQF9dzBODz6lEQ2bYHdhpnNNCt3VuOMfkZ3WBAYs/ssQ3FR+kQfTfk9aE0TBLGgS9cZ
         c9HE6KmOKBplvU9wS1F7nxDZUiSEI5gDSSkTIEi4ty/Q/3zP8wgwbmvKwkEwPzH6KN+N
         KeKnzQSi0N6C8e7Hi6JHb5lEEORZOSF2LYWXOmHTjyCO+kUTVMoBdQ88ITM3T7fkVj7Y
         RKvHuhaU11EwP8blP5oNiFCemOEbschGKq0OMI+68l3a8dmhiSFk9gxM1XbyYSWQtd/+
         EW+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775468717; x=1776073517;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ylqmm6Fk9xqXkNcpz9CG1tMWJO34U6XEQoYsL6L/otA=;
        b=G+Oyf7NHubaLnwMvLPxcMFsOjQddrJk/SIkAodVPUgV2ipIED02qFywM8FBRtkq2ZO
         f642h2kxMXB4rW4pY52e2VSodkPMK+qyQm8bp96G32FObAYyrfUJmQNHBZMip/dK+CgP
         MzFMvWhj6utAML18nRJo1H6f6UZaTb49SvB4plF2zi8zKI7yWlHtDeEdNIs8VaF09HJi
         Kdu1gh+/PMYWNDdkgE6Cshe+UYykrHYvqZGjgS+isAtyElLTBcak7W+Nd+lY9KNeJH4a
         vAuTvwC+s4KDClF9BZR5M/ichq9nkMGKSWpscBAhKsHj3BJM2CSibB8VhOxRgQ65bqd1
         E8Uw==
X-Forwarded-Encrypted: i=1; AJvYcCXG3SFhgkwh1UmY/XDQQEyP1hDukD0rV5byFmJQflwjGqFcl+BzBQFh6Mgdd3xjcnxYhx/ZF3RtqSsWa/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaOAPEK8o0Pfe4TQrTldySNuwiIo6mqidB60idRVJyyctpeR2w
	sdNm84b++95LJ0gWq61RvbjWK6y9eJr5tmlyCkZSqpi3uAg6xQAyvmWKYigJ5RKvXTj/OOlrpcw
	ZPg7qomgCGg366aoHieXQf4BePvs2O7Ad0m8Q5pZv/Qo8QGXJHPrsiw28ITklJ7GUw4M=
X-Gm-Gg: AeBDietecpeAA+SSdBt8I/uTqGnvSlSZDmyOOSzvCvHTQmhSvyCMDMxQ734QXGrusXs
	NkawN+42DUfMwT4AmHT7YH4vWeKJeF3ROnciCFL6BOuC581CGlHSHqRsCak29k0yofytZ9u06iM
	z4mn7TgXYDt+hJnxne05qfDo/mm6FvpVIhTFDvHjGQ8998/0w6tYWPHy6SZQE7ZabYdJiZo6cD7
	Ni5ZxNwD+F5jCdBPM/oKb7pFcm8SHLpgv0toG9WpHaIkhhqAs+ObU9cDFz9awDv4zUy9qyxwWYm
	gbhfC+qDAh1Y67rWnDChwt2WHKx+6utD7M9gIa9EWyn2+dgs/gR3fr368bKAxTAiOgDtxeIMZFO
	TTf2tvYARF0Vc13w4LMdQKaIQ6e783gOpwzQplOcchUwrzrvExvc=
X-Received: by 2002:a17:90b:5583:b0:35c:d98:d684 with SMTP id 98e67ed59e1d1-35de67da865mr10630642a91.6.1775468717088;
        Mon, 06 Apr 2026 02:45:17 -0700 (PDT)
X-Received: by 2002:a17:90b:5583:b0:35c:d98:d684 with SMTP id 98e67ed59e1d1-35de67da865mr10630586a91.6.1775468716497;
        Mon, 06 Apr 2026 02:45:16 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm5017017a91.2.2026.04.06.02.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2026 02:45:15 -0700 (PDT)
Message-ID: <6f91f084-44e8-40e8-af8f-f42502a82a31@oss.qualcomm.com>
Date: Mon, 6 Apr 2026 15:15:06 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/11] dt-bindings: crypto: qcom,ice: Fix missing
 power-domain and iface clk
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>,
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
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>,
        Alexander Koskovich <akoskovich@pm.me>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
 <20260323-qcom_ice_power_and_clk_vote-v4-1-e36044bbdfe9@oss.qualcomm.com>
 <30327e35-6d32-4aac-a55d-134ed5271603@kernel.org>
 <5d4e0b57-e5f6-4c2f-918b-7a23e50ea6ad@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <5d4e0b57-e5f6-4c2f-918b-7a23e50ea6ad@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5NCBTYWx0ZWRfX2u77mycUXM5s
 9f1TuVrmf5KQ5H5kkjuAEwxTmy1gVmiui0dUike/+5JefYLfdublE+QIPYfdAxq9rCjvEf4ookU
 YqFUdK9o4jRHny0HpZZuu+fpB8fRiEUjjoafIxSpajFDUgZGqw5RvoqINIDg/3YaZYc5+XfXrbt
 I1uKZANdPZU3OLSaxNqLxAI/0mQIUWHB9Ig/FG6B6FPWyMqs0GIpjRAQ0Voab48Oew/fnv8S3Hc
 OvUkPC9W/1TOM55EUD3p5gwi57z4fiKT6LKBTBc4LkyWDIA3zoM4aW82LcVmT1J9qHDiO8b814a
 NlrVDElpMt02O7DfRVsbxtcOaICLHALcmqTN37HV9smyph19MF9ZorciaL6weBadCT1PukHmBLm
 2yQI8tqcdWNcaYOgrIh2XgCbCadPhdRSP7l2CokeqsLlSJi6HTuDvfkCNs+B916x8SoeQbNc8LI
 1ANLiMDho4cy4SGM/sQ==
X-Authority-Analysis: v=2.4 cv=U5qfzOru c=1 sm=1 tr=0 ts=69d380ae cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=GOUycqkJADGgNADFIAoA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: Pw21QODBcyF7E0_hXr7YmwpUdZGjB7bk
X-Proofpoint-GUID: Pw21QODBcyF7E0_hXr7YmwpUdZGjB7bk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060094



On 4/6/2026 2:50 PM, Harshal Dev wrote:
> 
> 
> On 4/6/2026 2:07 PM, Krzysztof Kozlowski wrote:
>> On 23/03/2026 10:17, Harshal Dev wrote:
>>> The DT bindings for inline-crypto engine do not specify the UFS_PHY_GDSC
>>> power-domain and iface clock. Without enabling the iface clock and the
>>> associated power-domain the ICE hardware cannot function correctly and
>>> leads to unclocked hardware accesses being observed during probe.
>>>
>>> Fix the DT bindings for inline-crypto engine to require the UFS_PHY_GDSC
>>> power-domain and iface clock for new devices (Eliza and Milos) introduced
>>> in the current release (7.0) with yet-to-stabilize ABI, while preserving
>>> backward compatibility for older devices.
>>>
>>> Fixes: 618195a7ac3df ("dt-bindings: crypto: qcom,inline-crypto-engine: Document the Eliza ICE")
>>> Fixes: 85faec1e85555 ("dt-bindings: crypto: qcom,inline-crypto-engine: document the Milos ICE")
>>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>>> ---
>>>  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 35 +++++++++++++++++++++-
>>>  1 file changed, 34 insertions(+), 1 deletion(-)
>>
>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>>
> 
> Thank you for the review Krzysztof. I believe since we are targeting current RC fix, I need
> to send a patch for adding the clock and power-domain for Milos and Eliza DT as well to
> conform to the binding since both changes defining the ICE node for them are already picked
> up by Bjorn:
> https://lore.kernel.org/all/177432155637.28714.2511351512032518031.b4-ty@kernel.org/
> https://lore.kernel.org/all/whoikp5tdu34gujfjqpopbhywzj6dvcxebywtwufip6jxdwp2s@oepb2y36a2hw/
> 
> Is it fine if I spin a v5 of this patch adding the DT changes for Eliza and Milos? I don't
> think sending a separate patch series for updating these two DT makes sense given the RC
> will close shortly.
> 
> I'll send a v5 today itself, hopefully Abel and Luca can review.

Whoops, I can see that Eliza and Milos support is planned for 7.1. I mistakenly thought
their support is already merged for 7.0. Apologies. This commit can be picked up for
7.0 RC to fix the binding. I'll send a separate patch which fixes the Eliza and Milos
DT sources targeting 7.1 RC.

Regards,
Harshal

> 
> Regards,
> Harshal
> 
>> Best regards,
>> Krzysztof
> 

