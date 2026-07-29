Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395EC2BE7AB
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 14:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785334617; cv=none; b=d0h4cr2CXl1RPDoJOek8xkukLx2Dg6fZd4LRGBD+syrzV8/rCkE3aUjtZStdKAyMf/eTLTCb1f370iyQUgHS/amtlyy1fyyhYjVY3oBJeiBFotHV2/EQlhZ0T2XsYIxMJItGJUDpfo9LkVzAG77NhAFhYpWE9o62j8FAwzACMi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785334617; c=relaxed/simple;
	bh=TCo+7EZlpnAIIC2RubbPgCZJQQ5uajJDR6V2OqJzx9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ub29X+IaMyVYqmWg7fT7VbeC7jAMbdPTPBBOd7Gt8tTAh0f/7w0PhcYgElDGLx2L2/G0nFlyVCr6WHER/yB7+PadCgFkL73/x3pjqpkPYE3keljUBLB+/VZokiQ5ORAwMMLJNbw1fkVHm7PdFNDA+VjOeW/Km8jcJXRe/TddMo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FiGVIdc1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gc1zKDDZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FiGVIdc1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gc1zKDDZ"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TD82vI1800088
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 14:16:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rXVLhUTKhp0UB29cVlcqaoslIEpKghsTFjk1gXUO0lg=; b=FiGVIdc1wnrTOoRh
	wxjvlrMi4kVRQmW7NCV2TKR9VplRcVBcE3ey+MBnULmFWAF85ThsZjYFZbO6Dcr4
	0SXM+roainGSLUguOsDIedwwwJs5Irm1Jxlr5i9hcbYIGRsUwgxQahC4p9N2u1Ih
	g16TrYb8koMxX4LLGECnnXQl3BK0hFtVBKcQ/S8lWZjyyGphDhDYj4PxnUBCK2aX
	FLGxZLyBb4T2x/iMOx0ohp+XALzQfrcmzjTDoN5XQ12aN6abg3eAZwSCdiulMe4d
	OdPh9tav7yCkCmMCNm93zHaJADf4V10tEsA0/7gnrVSZf+4QPybZIRTbS0LjrW1V
	tLz2eA==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqhgy8fyp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 14:16:54 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e6027a5761so526581a34.3
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 07:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785334613; x=1785939413; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rXVLhUTKhp0UB29cVlcqaoslIEpKghsTFjk1gXUO0lg=;
        b=gc1zKDDZ8K8TrlOh9t5Ix7KG26H5rm//8kmhIn40big4e+cQB/N54jTg+VwM+mpYYY
         vCLSUnBGjM8lxHYdoWrqEtp+YWgI/OE+TQcPIv7LIOQ1r+GvOZR1wk4BUYB7y1GpQvZf
         dIfZwEjDzCgxERil279s90vtiMHoq02U8eWUFvpPCL3ztM9zjwdpaQEoQcFzYpM8Cf+1
         u5UDmCEEvnAEBSWg4wBc4NTW6tnFT2IjYTWD6OFtcxgQBC7p8el5J951f6yOy40S4YQ3
         vEm4wMIqmggYXqq5CFweA9VJeLCcKfTXHwb7YZFSZcmnyL0wVDYtAgikdBzLI3XjXAl8
         NlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785334613; x=1785939413;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rXVLhUTKhp0UB29cVlcqaoslIEpKghsTFjk1gXUO0lg=;
        b=QaymoIzWOc5gCZyimg4uxrNsBdDCLAM10nfGmQBsps6ISYf2MfiR2z1iEfc6RdtrkH
         A8Exfi7MvKGVO/seRbG+PP+Pu/qmNKWa3GxJBXEcxVIDv0vT54N6twxyn+SomeK2rroo
         o01NwrsyiKegvTimuVHvkRqIUgJimUEDL+Abi4BShvi2VkwKGuN5FneqMg6w0ucLXVOR
         UXZkE1wv4cW0Ywm8QpLc87R7h7amKTcO+HpemtP7IX6zICQrLcFtR4npP/+Tl9kOlO+1
         D337rLYwn8Ds/2SZynU6NtkZTQUFSkQZ4hJvCN5B2RpEENGqiR4pz4UxcSRQMUCsQq3W
         zfdg==
X-Forwarded-Encrypted: i=1; AHgh+Rr8sGkA7hKbpdKuH5lFuXBShGbvJ49Zyg3h28VBrdvPy6qzWwNV2fTVG+0svaYnzvon+rJGFt7vE4t0uOw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg8/gkMUC2pAZ/XO5KzeHvSg16FjBZuu/s/nu27/jb1rq/xpyP
	Zo/aEZ6WoYBm8OZ5ITYEc6i+ADuquGfqNb1jXfuPZjXEoHcFQZ0GihjwDJ4L4BsfHLXphxcI9Fl
	DbSs2wiXgwApCwzrJX5QbevfxEoqFa52sKOighED0dstBGMCTW9y8O8zW712zdDqkbYo=
X-Gm-Gg: AR+sD13VlgD+82eo6fslXtGtxRRX96dcHLNiOrCu2pI0UQ7dpzXUyXjXmWIVMWQVpfw
	sG467Ye/5wBB/NISaZzHlx6wMGEzqWUeMYfLNwu3Bi24SBN3cNJZdGzetDAqM8KSszfd2KCNQs/
	iGhexsVHPs8MyHNcXRMFNI4kEHg+Cc/ZGkatcziLSD7465sVEm0QJIUgnUvDRA1KHxVP9d2jv9p
	1Hh3V/W55WHEtGJdufnJNqO4k37hullpajzJ41tTfaaqyve2Rw1kaqGH4RmaSK6Cl2m1IKQhLkU
	3pMIJqWLvvbYsQ28WmyQg9WzWpsL8Q9B7hN2YTOnfuExT9T4HMZmXrhSk3us6WhTjxFu/tcSd7A
	KCSoluUZ1Xq/rv1kS7NC+gkGN
X-Received: by 2002:a05:6830:3814:b0:7dc:d6b1:48b7 with SMTP id 46e09a7af769-7efff0855ffmr3035924a34.1.1785334613427;
        Wed, 29 Jul 2026 07:16:53 -0700 (PDT)
X-Received: by 2002:a05:6830:3814:b0:7dc:d6b1:48b7 with SMTP id 46e09a7af769-7efff0855ffmr3035854a34.1.1785334612957;
        Wed, 29 Jul 2026 07:16:52 -0700 (PDT)
Received: from [192.168.120.193] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2d76aa130sm435235e87.27.2026.07.29.07.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 07:16:51 -0700 (PDT)
Message-ID: <d7ef81ac-423b-4033-9e73-bb6926eb072f@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 16:16:48 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] arm64: dts: qcom: shikra: Add ICE, TRNG and QCE
 nodes
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
        Konrad Dybcio
 <konradybcio@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
References: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
 <20260714-b4-shikra_crypto_changse-v4-6-06a4ea97c209@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260714-b4-shikra_crypto_changse-v4-6-06a4ea97c209@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: HZ9QcAAFM-pL5rXstOg58mfONDTaLpgJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDExNiBTYWx0ZWRfXwyKPgig2ZPQV
 p0Bbzw70sH7aMGLz3/4zH2eundWoHbZdzR0AalwRI9mrOTxL3cT8WnA2N2ygD/46YIAvCo74wMs
 K+xnmGkx3frfH0UBHO6PPe2JeQAHLvCo8gF9oe6H/qHwEw97IN+aeUoFNNJ2ABrVUmPVPyop8UO
 31AS9RJrd+W5SEgU3aA4U9N9KZciv+uazU0cTn5+QXyTfsKMUEg3DfeidRBxklljEaZvQ8btUkb
 qkkLUer/sgJ4vSCkUSOf7BcpG8rq580BL7W+MdCwaBcFi6k8Z4wlIaMv4s5fPy7leCvq5ej1SuB
 1YZ+m8HJI4sft07vUuhHVNFw/H1RiJrlt33MBrjD+WLZS1Cb9FA4FAwfOOaRBMZFLQCW9SS4B/l
 UduOQdMWrbrAYKAtpVC+FoJTpZfSpuHhOJzbj+YbeJh4TLiwlfCNsCwzjUeWIt2kC8eCub38l+h
 FeLAVjHX8blXDDGL4hA==
X-Proofpoint-ORIG-GUID: HZ9QcAAFM-pL5rXstOg58mfONDTaLpgJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDExNiBTYWx0ZWRfXxIO8aS33TgdM
 1qumVlnN7asjgCwKnM/IjYz3SUnZgE230cL7Kr3GSHkiuNfDwk9tyDhSVAOxG4l8LT9HKYuzPf3
 QAX0cgLPqaPba6YI000zTjWNrHIjmBs=
X-Authority-Analysis: v=2.4 cv=VZHH+lp9 c=1 sm=1 tr=0 ts=6a6a0b56 cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=MtsRB-tFAxrkV9Z_vvIA:9 a=QEXdDO2ut3YA:10
 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_05,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290116

On 7/14/26 12:05 PM, Kuldeep Singh wrote:
> Add device tree nodes describing the crypto hardware blocks present
> on the Qualcomm Shikra platform:
> 
> - BAM DMA controller used by the Qualcomm crypto engine
> - QCE (crypto) engine with DMA support
> - TRNG hardware random number generator
> - Inline crypto engine (ICE)
> 
> Also connect the SDHC controller to ICE via "qcom,ice" property to
> support inline encryption.
> 
> On Shikra, different BAM pipe pairs (for example 0x84/0x94 and
> 0x86/0x96) may still resolve to the same resulting SID due SMMU-side
> optimization. They are still distinct pipe pairs and therefore require
> separate DT IOMMU entries.
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
