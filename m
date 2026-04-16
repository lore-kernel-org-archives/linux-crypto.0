Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E533B38B0
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776342816; cv=none; b=GbRUgvVI6uoQqe4+KUXHMnO1vbVojbFSsfrieEKGbiWjyPJwy+jej29e+RydoBAMU0yZ2zyqQ3vtRlDHv9V2AM+SwHgdpnzNILbjwBatynArn8USNXJIyLXa/pv8MP8w8+YHOF0QDepDlxbC5QP62GN1PE2x6nuA2hpAX4UglBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776342816; c=relaxed/simple;
	bh=WPSs3cMf16X5/TvEN56VuiGb0TDRAm1CjS6Ltw/i7eE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L/Q5N/srAvDfuRW2lXJtcCQxU5lx2KaDLxvAkDCq/BYmTVx43VF/2BedNeq4ddNjTCkiwy6wqxMqUK25Kz+iQkAGKRBHxhzFL/5A+N4cY1IPbuIASPzXnn/gnaMad930AJ09yd2yRBF2Xu6dCMaHEFqdREHR98mfq7SrsOgG7vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dTZM4pfO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fnRJqnSX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dTZM4pfO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fnRJqnSX"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G8Uv4U3733589
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:33:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	csr7RGPlrUusrxVMW9J1fA3qg5w8Sk/3ed0IXgH2GWM=; b=dTZM4pfO4ImZIYX/
	R3pmtLNgaUyevEUnCZap5wtSktjVG20Y0iougVL0TjUdbuW2ZVXevKhr8UaBGN3h
	WGcK2pMakvVxPnzN3tZlwgteV9ZxZmY/yjTy3Q1UCumCoa4jvafQW1KXG3M6032h
	oVDjdMTLaMtMtQgQ9/noG59HhAgg5zUjCH2JMljZIxcg9HqI1sjMYevMZ8Q3wJ04
	vOpw4nzafgZYVhtToxcpxF8l6NeP6HLKtm61vdDBA2n/rjHDk0jEJxD3+6Jf2Jyb
	rJkxJkbWqEHLePzDm++azzzEyHVsJxJ9pKSPvuCnJiZkkDkZE/5ggj2enPtLcpp7
	x5F/1Q==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djcqwm0gr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:33:34 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50b32feb719so11107151cf.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 05:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776342814; x=1776947614; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=csr7RGPlrUusrxVMW9J1fA3qg5w8Sk/3ed0IXgH2GWM=;
        b=fnRJqnSX4xup+vZjZG/OgtSJARkfggcTZ70MpCXtcgoxmIMxsAn09eny6V8MsQoQ4E
         4YeYRBrbQd/9U7dN67T5N8lTQ9MRGTxFYIUeaxHq/gR5SWQQebPuE6nu1dXwd0WkICzz
         uLh0Atr9plNK05fQDXcgH4iRKQuEusN646flK3yZQHi1PWxePoRgupWfY/K9ggZJ+1eL
         QHhvkSzlqxSKu3scs7AMAJu8kTfh7smzslCvYA5ND9flL0pVKeKC78C731oa2gIo0TtI
         A1mFTZ4MeAnxy7XRLHc8aiXY7/Sfq5nWA3ShWhtz+L95aRgFLqKLMHLBW2Mfx57JNqNA
         dN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776342814; x=1776947614;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=csr7RGPlrUusrxVMW9J1fA3qg5w8Sk/3ed0IXgH2GWM=;
        b=ZdXg0aVL6HXGHNJOBNogyGDRJ6J21V9QUU8xWAl0P1jPZNOeovx0ArWvpxJ/fygogQ
         zxnCK/i+6MSbq4D0GENioMp8CrKfKUEjOuFaiynFYSGFySEun6kXIv8ozAoCwFWx+aI2
         +71wpuXq8FKqSi2lL0vYVsHcYuTkFScjNc6lTJlzoV6nkSw6l7pQ/lPabAZhJWyJJzbN
         Gts5k/B5m9cmDEcbYn5mbfF404hLB3XVQawT+hx26VwSwTvmqG6vQdAL+t84aNyw7XeR
         ZGB5Vx5ADsPNMP02uggVVP4H7yM4OyZshRKFlaYhfehP5ZnS1j7jz2FUWMbpZBRlidTN
         F3BQ==
X-Forwarded-Encrypted: i=1; AFNElJ882BxbBtuovbRS8gNUoinqiqqYbdaptQ6AU6nqRKGrghNm4l5uCDy81nRbk2qwA99FeUosL+LXczNTILI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxgNHVBmhQU0i7VfZButHK4QsVUaoU9IAEKNpFKJn3BYWxgg8U
	RyFKFj3WbzP1OLap2RsTihug6xzXuAAhI+iqhxflMzR6jBl1tC4A5o+atvpQAdFyM74ooQosODN
	5gIeWMEWpy4Tdk4XpKpkRi+xUt2CUxley7vMbi09vm5YKkVpnZGbzOLsm8CgLTFBhve8=
X-Gm-Gg: AeBDiet+KRzTQoHtDBkp3g781lH3eS2dzfePrjwFmFMVzNODg5WzmbtgV9jYKeNW9CX
	ZoE7B4k+kZjI6xdETlCWfRMtN9oeL6z5lO8/crRfmLi9s7xfDe2NTHxJZo4MnFti5+npgTwmHdb
	M5lPHcjyWZyhoUj6NPPHX2Q0LFoWVz7szzKJ57DX5yCVKzVDIev6gq1TvknVZX6/EvUhGnd+fca
	VNrnNxAsjWV5hGodrOyIXKDDYu23MeY7YMCJsUbkJRbKnv02iuiXIc5JGlREM5hE6zRmPP9Edpf
	lugD5WJpO51czdl/f37GsguRbQeaV1R1GHkCAQdgyQywgetPASYasTBQNmQaZzoqXzf/S8MiC+m
	7z/4ggfPlnmw+iv0JKqtYEizCSKqRC+/OFqnQSsjD9VNzLjPreGTO+WkzdikZmpqMaSGeVBXtnF
	Z0yslnyw/JzrcomQ==
X-Received: by 2002:a05:622a:1145:b0:50b:2875:5782 with SMTP id d75a77b69052e-50e2911356emr19909391cf.6.1776342813625;
        Thu, 16 Apr 2026 05:33:33 -0700 (PDT)
X-Received: by 2002:a05:622a:1145:b0:50b:2875:5782 with SMTP id d75a77b69052e-50e2911356emr19908881cf.6.1776342813209;
        Thu, 16 Apr 2026 05:33:33 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba24865492asm107031766b.24.2026.04.16.05.33.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 05:33:32 -0700 (PDT)
Message-ID: <28108ec6-2b06-4b63-8e41-fa75b7858acf@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 14:33:30 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: glymur: add TRNG node
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260416-glymur_trng_enablement-v1-0-60abcfd45403@oss.qualcomm.com>
 <20260416-glymur_trng_enablement-v1-2-60abcfd45403@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260416-glymur_trng_enablement-v1-2-60abcfd45403@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Fx4LwZjsR3yqUBpq1eXETDeOiX55t-yk
X-Proofpoint-GUID: Fx4LwZjsR3yqUBpq1eXETDeOiX55t-yk
X-Authority-Analysis: v=2.4 cv=XOIAjwhE c=1 sm=1 tr=0 ts=69e0d71e cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=GutRjl6PLZtdpyDJDqIA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExOSBTYWx0ZWRfX1DznzsOfoLxh
 AJQLc3axzRv4SX82T13MYnFhC3dU6PwGSXQ+LY9Zj/PbOws17WKZLgOwuoZALADwXknrD3+5d7x
 7npmxTQ2nDnqWZrPjo9UDTsTEXE6H7D0HwRtiFnyrYeMKn/yx4T1mCKGbzliJPowa1EwNUyE9St
 jtHAIdYGUKKaGh6B8U2bTIUpokzOs9+E2k+1b4dcsovzvB5GRHJD44TQvOG21vjBsXt/UAJLVOV
 6UIx/4YGc0yNhCyWEVt+/DWDGaUWwRQTLP9px9jNXbkGLdJW6clbBNkNFQgDwAozk2Fdh5Qs52V
 vXg8wJxABPJKyGtfi19K/xYMwwbUSaxEv9hIl0xjOP3N1KQG97D/62IK/SRb4cpyWxXxXLlLbm0
 8m6rMCOY3pkSKkDY5A5Gw0RATF1wu21dEEDwTsqCtODkTAi6QhlZocf7uyvtU2oow6mU8IZ2hxe
 f7Wnq2IsVyCrx09OF2w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160119

On 4/16/26 2:26 PM, Harshal Dev wrote:
> Glymur has a True Random Number Generator, add the node with the correct
> compatible set.
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/glymur.dtsi | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
> index f23cf81ddb77..c9d46ec82ccc 100644
> --- a/arch/arm64/boot/dts/qcom/glymur.dtsi
> +++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
> @@ -3675,6 +3675,11 @@ pcie3b_phy: phy@f10000 {
>  			status = "disabled";
>  		};
>  
> +		rng: rng@10c3000 {
> +			compatible = "qcom,glymur-trng", "qcom,trng";
> +			reg = <0x0 0x10c3000 0x0 0x1000>;

Please pad the address part to 8 hex digits with leading zeroes

with that:

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
