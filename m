Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D1539E191
	for <linux-crypto@vger.kernel.org>; Mon,  9 Mar 2026 11:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773055696; cv=none; b=Mb4ktwOw1RP60iEvNSaRmIJgpgPr23eR2hmZP654Qf7h7/EVSh8fSg66niizWu3y/Z2jSDPgyINp22wm6GSg6/NFTVIzDMC5uQHkN8Z5OQTPUFGlLhqe5YI4vL3CwgmWyaOQhX5eJut7nSbwygXuhgbswmPNjaHPCE8uIPMi/FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773055696; c=relaxed/simple;
	bh=ffzYuk87oLdr01kXxXdni7PcHeH6mS+mEtrAYUC6uWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s97NZPofQYHkw8TRX3L5F14WSrFlPQZaSZG7IHX6KnXEIoDOLCYHf06f6Vv1Bk8lunKTdRF5KrJOgTRwKwlIUFmlLbCCkeFL6lsvU/PNlyqy5asuNfVFrmm+vOHp3ihK1mkuosLxbqpEwe3XBAE76r9r7mOs95x0dRURtarjuBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AbfkQJKr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OUWRo1oS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AbfkQJKr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OUWRo1oS"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629AQaJY1588151
	for <linux-crypto@vger.kernel.org>; Mon, 9 Mar 2026 11:28:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	RKVphyoaPLZOPMgBSVtGNnozi0+Qf+TQcqaRjh09CKQ=; b=AbfkQJKrD60/hXiy
	iBdRITAzulzNO40wAcQbkyD+zVYbeCDUnLq7b4l7T0wxngpia41K/mZ+pB+ROVp9
	NPR26HO28da1A5zVNFIUy6t9aCnQ9PlwqTxRm5JABapmsnP36ihSsZ1GpkN7Ylps
	GlQVhi946qg40dXalRPE0+y7GS23hcSZ9guASgT620Vqa0NZ1nEmbuNuBFleyFI6
	niI8rDIUdzXkkIsQ4hBRN93qEfXK1HngSAEPMpXXOsmL/twesHJaenLgRLd4zJ51
	xmH0LNtTWj140Qb3iiZZ+BdzVPR5qgW0vTTf5OwzwB87b4+9Rr3Zk69S+flAt0Z/
	T/VbvA==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4csqcy9a4x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 09 Mar 2026 11:28:13 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-89a04e9d4faso39326746d6.1
        for <linux-crypto@vger.kernel.org>; Mon, 09 Mar 2026 04:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773055692; x=1773660492; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RKVphyoaPLZOPMgBSVtGNnozi0+Qf+TQcqaRjh09CKQ=;
        b=OUWRo1oSXKdaLlZAJXzleoQs97GtjMZzPf3PeOUxWlqXfSW4NtOJ2EMIWWBgek5dzL
         pCXaEpT8LlaVZfN9QsjC9n0nLlT8KkVl5m47vSYt4XkA58qHs06zkGKp7cVyA9UFeQfe
         WNa39UZsPdTc9EKkXFrrP48JSgsIxHHzWVWTZbAZLSTxP27w0JQp1zTgbkvc7JhVh47m
         AY4kDZKFWj/gtSQhlDLVVtLNnnqiQ8ypOlXVBo/U9f+HzCmTQkGsZEjkzfQYD69txotf
         QUI8LSvChsTCMuyjmJC17XY5om6YlvyLHks2tBk92R4SS2ZSWUQCZuSpgVrxFdPvZlUc
         ieXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773055692; x=1773660492;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RKVphyoaPLZOPMgBSVtGNnozi0+Qf+TQcqaRjh09CKQ=;
        b=Tu0x8xw/V8H0/0RABT8nMWe/JEskxnkDWctepbTwiO2+bHxXqj6y9mZMSA8pLuPfRb
         gL1ZLS7lUaGv8UvmJ45DBqAuEbY8IT/IZNwWzBdzDJBQKCCxnnkDbh7OguC6wI7U2/8J
         PiMUkqtu/lcotJbH233aBrvggqiEgmJ+L7K/indn11gFfGMfVo3XJHwRx+fsseI7Pv7W
         CZlXTAASp8eK5s8Xa/ZfsmZ0z30nm6MFrRm6R4w2PDnIxh+2I4cV5bP9LEnBFTSgWvwm
         l/4EACORGQBeFvA4XjaJCCmKnfxiit53/URIboD+QwMmZinAGnrJ2Et4vS5k8n8R5vMZ
         gsMg==
X-Forwarded-Encrypted: i=1; AJvYcCWO+kMpnhh2QomzKEG/SmwjwrnZhFPo3fqOjN3bADRJo0rcZdFBrwzUlii0mdMfACsPEHNBsFfhFkkYfks=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjRcxP+a4m4J56SjftWpcff6RmF4v6vEjq7zIEoatEke1julHW
	2oC6AOL6lPjudthZL3eGvOdntQCjwPYzxbJXj7JXZO3cvwx/i7Ye3c2BCWqdKoaKj0CIxpu7JWB
	XyYxeiTHHjU//uJNJaMLsIvTi/GJr3aEAoB/wYYSDrU1gGhmg9zm5Y7Xb9E0tLVpHXXI=
X-Gm-Gg: ATEYQzwYQvJlCi4GYpO6p86HklW+4gvlSUjW+AsbSeVsfcAKuHWIShPudchzUKNC1re
	alt5Sc/G/8Qjl+8VR4P09mC8OslUWKZo5oLVQUMO2tm/XIFS54MKdx+//HDla8qf/FfLQHFRuiY
	lEfrhp898vY77CyKrdKBD6MRYaRME1hM/NDf4ufc/wTbNkj9dLaY/WQhFRikw9AuLGewkA4VkTs
	DJ82MEakX2or2RT8VAYnBbPA0qX8juXIQL6FdXdewfCG4FE5PoSoTVEuWJU9CkxtASMt799qu1e
	MHSHUeJyQuE65wrO4xD633y4DXxueNw50YR0EQULYLZdpID10+Pm5ypWz8qAZJDoVULpDkdcP2O
	CkRmzjSZjpuljA0OHQmJOZd3YoqoQhxLbj+eH2ldzd4A14gd+STU/4bsS3E3hB0ANsEYlBz9RNg
	eteR4=
X-Received: by 2002:a05:6214:6104:b0:89a:4f20:cb28 with SMTP id 6a1803df08f44-89a4f20d1aamr22563796d6.3.1773055692149;
        Mon, 09 Mar 2026 04:28:12 -0700 (PDT)
X-Received: by 2002:a05:6214:6104:b0:89a:4f20:cb28 with SMTP id 6a1803df08f44-89a4f20d1aamr22563416d6.3.1773055691636;
        Mon, 09 Mar 2026 04:28:11 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b942ef4827esm354122166b.2.2026.03.09.04.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 04:28:10 -0700 (PDT)
Message-ID: <1728fd8c-148e-4d0d-a041-85a64cf03770@oss.qualcomm.com>
Date: Mon, 9 Mar 2026 12:28:08 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: sm8250: Add inline crypto engine
To: Alexander Koskovich <AKoskovich@pm.me>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260307-sm8250-ice-v1-0-a0c987371c62@pm.me>
 <20260307-sm8250-ice-v1-2-a0c987371c62@pm.me>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260307-sm8250-ice-v1-2-a0c987371c62@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDEwNSBTYWx0ZWRfX2gwqxHIXpefH
 +7zo3cx7RU4eXTM1wCQmbm0WozR7tY6DmUfc1Cs8wRtnJsq8aRQDvCc0S9SHWfVNDiCZVE4tXH3
 p0KCs+xHKKaXNxqfxRgqOMnwkBJT9+0qNw7M3IEfsd1BDoNnRyosAKwlqS1cTWmp370gIXHJGJe
 EuGYV/lRj4OqlE3uXe68WU7Onn/2n1G7vxDb1ODijBHTFPdp5zaN+IUCqrqQ1cuNwBF2adzCmOe
 cqhE5HJPkQlAPBYRpFq8w5H40gIGhSrqiaahCBQcqBJqyUo1kwiIYIS4DgYxUE7BHqsSE1VoT7B
 tBESBbh9IHuBvU2iN5a9CREZnfC6rDnEWL+SRzi86jUYdxkOsW6DXH1WFtYS45ZBQ7PbIT5xxEY
 vZ886kdO4Z6WTryVIBVAVSKqhnn0UIpu8L4n5k6VSXG+QJKytDTziBkbbcavJawKANy2XJsBJZO
 /JiNIShwq5JGZc36WeQ==
X-Authority-Analysis: v=2.4 cv=QJtlhwLL c=1 sm=1 tr=0 ts=69aeaecd cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=P904AwLpek5QnlVglQ4A:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-ORIG-GUID: YuO7CRV9RLgz8a8Oy8As5zn1JL8w4VAw
X-Proofpoint-GUID: YuO7CRV9RLgz8a8Oy8As5zn1JL8w4VAw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_03,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603090105

On 3/8/26 5:49 AM, Alexander Koskovich wrote:
> Add the ICE found on sm8250 and link it to the UFS node.
> 
> qcom-ice 1d90000.crypto: Found QC Inline Crypto Engine (ICE) v3.1.81
> 
> Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
> ---
>  arch/arm64/boot/dts/qcom/sm8250.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
> index c7dffa440074..4e8a960acc5e 100644
> --- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
> @@ -2513,6 +2513,8 @@ ufs_mem_hc: ufshc@1d84000 {
>  
>  			power-domains = <&gcc UFS_PHY_GDSC>;
>  
> +			qcom,ice = <&ice>;
> +
>  			iommus = <&apps_smmu 0x0e0 0>, <&apps_smmu 0x4e0 0>;
>  
>  			clock-names =
> @@ -2592,6 +2594,13 @@ ufs_mem_phy: phy@1d87000 {
>  			status = "disabled";
>  		};
>  
> +		ice: crypto@1d90000 {
> +			compatible = "qcom,sm8250-inline-crypto-engine",
> +				     "qcom,inline-crypto-engine";
> +			reg = <0 0x01d90000 0 0x8000>;

This part is OK

> +			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;

But here, please add the ifaceclock and the UFSPHY GDSC, as per

https://lore.kernel.org/linux-arm-msm/20260123-qcom_ice_power_and_clk_vote-v1-1-e9059776f85c@qti.qualcomm.com/#t

I'm not sure about the merging timeline for that, but it exposed
that we need some more resources for the ICE to be actually
accessible

Konrad
