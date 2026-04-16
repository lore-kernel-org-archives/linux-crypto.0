Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539E23C3C02
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776346819; cv=none; b=Kr5r7wVwPssOcLI94CV2NadcNNg0GP+XfCbJiMwX08qtIflcfWKOS7iDlbltyWduSNnwNwjNx2dcLBaGWWpdfF60e9yGFGKym/Xv2oQpqlbLA2eXr9KXQAKj+pqzX+YQ+KUciG8DEs5xwh4gg7egCgwhij/6fb2rpEUdc82uajU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776346819; c=relaxed/simple;
	bh=A+XtOyHxijOVbkkz8FigAt2vjQUd5yw/2pqqmX4eTw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rk+jZcwqM5Q5mgtW8uwJDTxk+fsmsQtGtxGq+rEvuEAbZwflfLYY8eL4mRxftC1r5NiYEAEnuVKiFn1n/OBSwgG5EQO5UnlZFlhUbebTRk2pdmE4s/kHWWytRpX7c6kgnZ2G2sgJuiND/Mnn2BkaL3p2qkv0rc3fzJjakVIw7zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=njTEvOJV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GmSz2MYh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="njTEvOJV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GmSz2MYh"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G8UcVU3089376
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rNdmWVIuP6sNJjEyEjeGF1LC7+n2Dc+tbUpHpHABd4I=; b=njTEvOJV4MFNi7xf
	W97s2r6f4E9bcwxTPETE4FIJW6GLBVNnjWgIwCPDUo2SH6Q2v8VfLBqUjJW3qLAo
	sDvJxz1CnNtEwa562TR6rIyFJT7dHkwvzf7/Cu60xVZp5meisVZpv4NbiodeKXWM
	aWO9lpyfL0wGmToaRC3Xz4AZdwmvqwy2KgfeOdI4aSuVJwVtgo9TFN0vpIC+DE6j
	5vDMiBj4WVpv9vccFmBZkPkskid9HCX+jxwtzzznbjXHFqpdbE35Kx9ZFHsI6sYj
	5ObtUjHz32RXNNhMSprN7pW0eKveM98e/UdK+IWUSwcYP7JCHUIEz+8K+N+9bzh7
	bRerOw==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djp6aaam1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:40:17 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8acb3741d12so11226866d6.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 06:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776346816; x=1776951616; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rNdmWVIuP6sNJjEyEjeGF1LC7+n2Dc+tbUpHpHABd4I=;
        b=GmSz2MYh59Vth9VIdlCSXKjMkaous/ZZcEeUuJFFucvhhM7jqbiwXIqbPcjvs3kJCi
         igHR1hWGrcgcGMGmabqrNBESiiocc63q+E9cxNqm4O/jkkulzDdCMI0sym7zrfZHYJQ6
         IGbCISGQCdjFu4IuO9iHp5Dy4GWq3BZZGe5b48lOJV+eg53X3UQ9fWOZd0v32Ab1IFFJ
         bGyhy0HBb9Pi3nU7uP2CHn8lX2mS/3nSKex/hBjvxFOBoR09+v92B8lmSLmzxgLGMJMh
         aVr7S92ki0qTR/CLLKcro92lTQ32Bi7oTGxLFAlCZoHzv75Zws4la5V9anmVuUODBwxC
         uzPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776346816; x=1776951616;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rNdmWVIuP6sNJjEyEjeGF1LC7+n2Dc+tbUpHpHABd4I=;
        b=I+XkjXsmEEWlyUugiZuhmAichrAJAyJHhLMPV9sp5/dmJk/TO03VgjVcdDeZNCAfzi
         f4vpyJa8YbWCpOS0IxLyfep+LHPPFP6cjMrCSW8/0jzCSlgLL80zBj7WQFqGbWHWQx/R
         om4jgjNwQQjD23ICJXllM46JmXaV4SyimF+TQVuGm4ddNl4uUefOuOWoL3Jz2/4M36Mc
         IjC+7mPUkWwJUkTI1PeqWGK7uZ92/9na1uwIP7/URnWlELzu1vg/LWNWW2Fyi6GHAmlH
         v0AGvAjhX304Hqqhxkpaj9TaTClfKXlWMRsbQLQMT7CrvezPtXwd0P1DXrl8GsVnBKHI
         lZ/Q==
X-Forwarded-Encrypted: i=1; AFNElJ+gNs/e9sxrVB9eO28+/bxPsMFrv1RQxM1Cqam044ViDV6u0T6F4X/sxbMhYFeGmBJewaC2XcOPaBU5QWM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYYABTO+nXoFYhg4bhUwElX5scZYY9VgFWLqgm4o3PosoACaQU
	73vGQOqFM+QrwzL6zNUoadF2VTsrlfF1u2AMW2TNlAYEj793YU9L2exPCUM8wMVFZLpW6vZjEy+
	PWUqLCEv3+BJQHLezIX9HI3OskYyQ33MVS8eQmGCBwxhyspd4QLVkHKg1gt7G/gdEe0g=
X-Gm-Gg: AeBDieuPob2kp5kM2qlZZbpOqZQIDFCOYPOWuPtPdQB8rQRylQMIHzCJHvclu+ZVSbK
	cFyQ+DYWBMB5fFRdAPVZSTGy1/rb3J8LZknj6aCb+aPB8zU/Fn/TqCrlG3xH/LhWhyZvFoxLcge
	qXZnmfzO4ZdHFcJXCCoxzYGiAz4qVosUQoOKtpiu7ozUE43oCugj7cYgkxZXbGnHT33bqNmdT9E
	W3kh7yPHgNMuVYi85vcjo+PRtbzUwiQVFYNsjK9GVPTJ82PLoteoNEUU+cIMneU1Ne9aFlYnLfh
	w1a2LkyEUQ33rbgi7Mg3nu3WJ401BfXZAqTMoT2SxakvQk5vQQuj2PfOsq+ydijvBjrSpMuyd2n
	BJNz7LT8ICkGn0radMJg0cxc++hFWczNiYf6XJ0YJJQlvmAvbSAtqQF2wadOJNIEL1dWJl6zIKR
	C5DusfDnoXoAbgKg==
X-Received: by 2002:a05:6214:2aa6:b0:89c:e371:2b42 with SMTP id 6a1803df08f44-8af53ca744bmr28131076d6.2.1776346816270;
        Thu, 16 Apr 2026 06:40:16 -0700 (PDT)
X-Received: by 2002:a05:6214:2aa6:b0:89c:e371:2b42 with SMTP id 6a1803df08f44-8af53ca744bmr28130446d6.2.1776346815750;
        Thu, 16 Apr 2026 06:40:15 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba17341a97fsm171539066b.13.2026.04.16.06.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 06:40:14 -0700 (PDT)
Message-ID: <653fc8bb-295f-4f1d-b9ac-a33e0d8a933b@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 15:40:12 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: glymur: Add crypto engine
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260416-glymur_crypto_enablement-v1-0-75e768c1417c@oss.qualcomm.com>
 <20260416-glymur_crypto_enablement-v1-2-75e768c1417c@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260416-glymur_crypto_enablement-v1-2-75e768c1417c@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: iyn_OFD4cNqTE43VYR4MZhrF5w_CPGNY
X-Authority-Analysis: v=2.4 cv=NuvhtcdJ c=1 sm=1 tr=0 ts=69e0e6c1 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=K0FbUi0B3_fz5qGjPmUA:9 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-GUID: iyn_OFD4cNqTE43VYR4MZhrF5w_CPGNY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDEzMSBTYWx0ZWRfX5q/RGd0fHoTm
 djtignet65PRD9Dfv3JebB7vBWraP5UTf3vcb+hI6yaGLFYc5MTzzCU+inpSl2O1wGWDkO0sbal
 lwqV0mA0rglPH5TN/nyr7WahOWew+/66Tfs1Q4AUi3A4GmXfpUjC15XUBfn6dCBKh3RRIkQLlTB
 yyf+YLc8fywcmHubItT3MOhSRu9C3jmsoIMKz0Wt5PBEGx1dHSDf77eNr5oiVB8Y+de6DcjHGIe
 MhSMyJlJ7lzXFaOiPi7rU/nkLDNA6WYlmF6HC2qWapH48jQJavqbEPtXZKlhuKqBxjMvDv6YUrP
 ziWhLnyryieM9BNW4w088HMNqnTzSTJHk2iN5UZz8jV+5/4YWuazjoTN/aAEgylcNmekPis8amN
 ToNv0pcD1xUbBdaJQjUwLGSTrRfqAfgQ0Rhg0/8ahxDyz6Bc/1SuJRf47sSLPkQPkMRPtDgI6ik
 o3xKgZcQfYz5Ui/L70A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160131

On 4/16/26 3:07 PM, Harshal Dev wrote:
> On Glymur, there is a crypto engine IP block similar to the ones found on
> SM8x50 platforms.
> 
> Describe the crypto engine and its BAM.
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/glymur.dtsi | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
> index f23cf81ddb77..e8c796f2c572 100644
> --- a/arch/arm64/boot/dts/qcom/glymur.dtsi
> +++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
> @@ -3675,6 +3675,32 @@ pcie3b_phy: phy@f10000 {
>  			status = "disabled";
>  		};
>  
> +		cryptobam: dma-controller@1dc4000 {
> +			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
> +			reg = <0x0 0x01dc4000 0x0 0x28000>;
> +			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
> +			#dma-cells = <1>;
> +			iommus = <&apps_smmu 0x480 0x0>,
> +				 <&apps_smmu 0x481 0x0>;

It seems like these aren't the right SIDs on this platform.. Have you
tested this patch on hw?

Konrad
