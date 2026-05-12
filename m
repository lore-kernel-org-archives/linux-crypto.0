Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D55D37E2EA
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 08:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778573073; cv=none; b=UidnW495WTM+6+ZzN0o6o1ulPcXjWDnd5nn2Jde5VNevOTH1LmUT5mNN0tSWFsWickYIWamjJzFx9kHPetGpE80dyL+M1lJUZCu3Cdf0H8yHepb5uPFk8rqDLJobB2lEoonbN3pGkPzAP6KMl9BO/hJR/5kM+dgjBy0WeEelW0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778573073; c=relaxed/simple;
	bh=3WGE47pfdoo4k/MjKdinj+dl7ukeJ81TgpzUVZwpxeg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iww5+yORemhqg/OwKYjgSThhT3i79+CyNNqJpB5AYWwjh389ZWUSwR0pOFLAOBtRgiK1UdjdtpWUJD7DqCE434s4p3SvkyTy+PkI5xsfxhpBvZgi5yPJWK6+fu2/PABQY6xXhszRwVplVRSfpYXBUhNkZ6eoGgAw/AtidWprF3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MmG5eYJL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DnpkfqJT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MmG5eYJL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DnpkfqJT"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64C6sP3N207474
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 08:04:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1O1Bep8eC2VqYFRAY485Q++gy9Sfmn6rwYeFrN2t960=; b=MmG5eYJLTmexLQrc
	uEcWOt3CGOzCsW+asqWxA4YMLHSqebCBcXXzLFMYmQHDNu3LAunc31gEu2sC89Yc
	QiYxsNqRtYg6Xtx3ef5of+A67hUrFe3iihrXNLCt4Ub/EBL6br9N6XdwL1TyZN/v
	z84YWHV4ZGDXl7EULC4XT5voKsPtDzRQmHelg9l15AqHkg8bBTht/d+114+jZ+tv
	UIywnfj7mf6AqOOs62xSKq+/m1RjpOAS3E3J7p+DvNhwWfQN4PTmhD+CLvbkp1jy
	2pthqUpItJ7kAC/0m/8y9MMcl6RBTBNlJmBIRNpj6OkuRvfrpM9nNkh65t8Zo0pt
	ccTYig==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e3nv0t65b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 08:04:30 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2bc7f9b2213so22653775ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 01:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778573069; x=1779177869; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1O1Bep8eC2VqYFRAY485Q++gy9Sfmn6rwYeFrN2t960=;
        b=DnpkfqJTeu9RwUCij+/D4Wbsq2Ig4FlVb+r25KaHyyrqtjCjy7YxUf+oB1tPQl2ZC0
         7AWGIybvabMfKU2MFCTGjgayXJix+kpNvHf0c1GssCVIrP/t+UfQW3tcs+8OVyTzLAwp
         kF3CnCn13t1+Ghb0F7YPw/MCSU05gHkMWS0TaUTLPqJ75U66XvhDEvfonmh+QCDUxAbI
         qpJuhp5oU+ypEO1IIcSEwMMk90qxFVHdSdkJ/Xk0LE+vtLXRnACw4vx/GXpIROzSc6wX
         MFUMmhXmbAU9aUf40hHu4SUO6I7NCeyoRY0wWZYBefqeEuTTaqUBvZgmA6XmxUShApXC
         8qIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778573069; x=1779177869;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1O1Bep8eC2VqYFRAY485Q++gy9Sfmn6rwYeFrN2t960=;
        b=TZqGt3Slc8EGaLYaJLTPG7YRE6hwN6ZZs1Z9Nvh3xcbwq4fJPg7Un0VP6T95djBy3h
         HJFRwTq5Nck78tYmHfE0AMsAJm9Y7K8KXJuwpnXFw8uhELPTwlVdImCVMU0rvNOsgp+e
         L1ohUQeU5iUbLniAkbmRj4h0H5ZFSKyYR020oLVeX/uXV6HsM7+Pa7IcShe3gHl+HI3a
         k6Ae8oLvlnCr5SBNBzrSbdw8OXvnSsyD12PY1Qf0p9FAAwNG3oNBri2tbay6snba2mU+
         2HTTtfCToW05AsNM+EzrKLvvQtNfmREH30/97pqAuVQreZFaGq7wsXo8KcrIosPl+ukY
         TnNQ==
X-Forwarded-Encrypted: i=1; AFNElJ9j+fGhAjnbVcGwP3B8toj0e2ivqEeMBHbkwYGviqjKxdOPwW96J4KLThaQDXuBhWiUO2/Dc0gD3fx5YH0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWL+vDV65VO95qQYN2J9r+3N7iADGgaKpAOtZ/mBentUY7tb08
	J/L5bClirBx8gZElztM11NoZpWTsu3EUMzdw95G4KwIziBdeiYqlQxLZrI44fFTNVyfbCPh4bv7
	91ErvR7gAJsyLY2Wz5kd6H1aRaoK3x2dabxBI0FU2wC2ciImchJyuvegOgjlSNitgcIk=
X-Gm-Gg: Acq92OFaO1iJNPO53IZUkayt34YlXITVg2O5osf4bOC9+dKxScPqkgNVX2/4CjwF+QH
	fotgQxAcOyKg+QqKSbwZIhtV/tXkbtT6jGFeHmli5Mo47htxocI95RnFck3ZSBLTwNw94JTgtOu
	CBXavB5NNltpuF/Dicnu6Rz6w/5Es6jHpGUCzwRNlaafF1buac1aKS9VriNjm7M7c1CmPIVeIrC
	w9/aOpalgcm0pbwGXWtgYCM4Aq5wjN58a2Dsj+YaBqLqTyQQD4Vu+VOAA65juZEUtcfLZhW4R80
	n7N3wWh/iWyRq8vPvBzFSYjbeFo9ZjQP4lyPzlQem5lg6ZwyJ7zI6W2j/o+OhFPNnaKAZ6g3o0v
	LydDC37jYsPsdVznTWo8zb4dffj8gOZ6R42sg3/lVHcwkavu+wkZrLzrIVVP/4ilV7FRSTfP+4W
	p/bt6HIlVjFR3txy5P
X-Received: by 2002:a17:903:284:b0:2ba:6ca2:be0 with SMTP id d9443c01a7336-2baf0cf3149mr192525445ad.4.1778573069355;
        Tue, 12 May 2026 01:04:29 -0700 (PDT)
X-Received: by 2002:a17:903:284:b0:2ba:6ca2:be0 with SMTP id d9443c01a7336-2baf0cf3149mr192525035ad.4.1778573068888;
        Tue, 12 May 2026 01:04:28 -0700 (PDT)
Received: from [10.133.33.42] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d271b7sm125431085ad.14.2026.05.12.01.04.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 01:04:28 -0700 (PDT)
Message-ID: <83c260b9-dd7f-4c28-ab83-91853afa08a0@oss.qualcomm.com>
Date: Tue, 12 May 2026 16:04:21 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: glymur: Add crypto engine and
 BAM
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
References: <20260505-glymur_crypto_enablement-v2-0-bf115aeb1459@oss.qualcomm.com>
 <20260505-glymur_crypto_enablement-v2-2-bf115aeb1459@oss.qualcomm.com>
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
In-Reply-To: <20260505-glymur_crypto_enablement-v2-2-bf115aeb1459@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=PN0/P/qC c=1 sm=1 tr=0 ts=6a02df0e cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=QMFbHPruP1MRKEW6HfkA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: 38yJmRLfu825NXINQdhktyutDJmLKLYt
X-Proofpoint-ORIG-GUID: 38yJmRLfu825NXINQdhktyutDJmLKLYt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDA3OSBTYWx0ZWRfXyhpatqDt4FJU
 Xx373xNOyZtxz+YyP6D15nm52sxJqBuqbr5N9sRhmoyW/jpvlJ5vujSsJ69lS6xUUKZkA/WBQZc
 9Uu/ulV52i7uRfwWjJ/64kLQFLB+pCmJhVwDEaFmajyRqFhxp/D7y0CGqF6EYWe8eqmD4yj/9be
 rgdT+h4iwyp6HlA/n0D/bJEXgdxzk393Wx9aMVJoz8zewGQ0cEo2eYCfMD+oMzDPvq3uT2bMgwV
 7e7UkX2RcixbS32lcuo1TB56mPuqEiZ3aJy9HHDP+056BNYk3cuk2IS5+OthJo5Bn4ePhzdkZpp
 Jo+kY3DpBCjCrza8/Xxs3TsDZsTWp100L/kk6eyBZq67xqdpsk52wvrOaJF33tIjVdeZi+N8t5L
 IpUeoTzSUT6akRx70+d3ZBNcUggD4ppa2NpRFbJdtV7fVAVHk2dMkS3ArxzyTZfZc+PA9ZFAxXU
 YX/MS10hn+dB3KqMj3w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 clxscore=1011 spamscore=0
 impostorscore=0 phishscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605120079


On 5/5/2026 3:40 PM, Harshal Dev wrote:
> On almost all Qualcomm platforms, including Glymur, there is a Crypto
> engine IP block to which the CPU can off-load cryptographic computations
> for achieving acceleration.
> The engine is also DMA capable due to the presence of an associated Bus
> Access Manager (BAM) module.
>
> Describe the Crypto engine and its BAM.
>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>   arch/arm64/boot/dts/qcom/glymur.dtsi | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
> index f23cf81ddb77..349da9966d52 100644
> --- a/arch/arm64/boot/dts/qcom/glymur.dtsi
> +++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
> @@ -3675,6 +3675,32 @@ pcie3b_phy: phy@f10000 {
>   			status = "disabled";
>   		};
>   
> +		cryptobam: dma-controller@1dc4000 {
> +			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
> +			reg = <0x0 0x01dc4000 0x0 0x28000>;
> +			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
> +			#dma-cells = <1>;
> +			iommus = <&apps_smmu 0x80 0x0>,
> +				 <&apps_smmu 0x81 0x0>;
> +			qcom,ee = <0>;
> +			qcom,controlled-remotely;
> +			num-channels = <20>;
> +			qcom,num-ees = <4>;
> +		};
> +
> +		crypto: crypto@1dfa000 {
> +			compatible = "qcom,glymur-qce", "qcom,sm8150-qce", "qcom,qce";
> +			reg = <0x0 0x01dfa000 0x0 0x6000>;
> +			dmas = <&cryptobam 4>, <&cryptobam 5>;
> +			dma-names = "rx",
> +				    "tx";
> +			iommus = <&apps_smmu 0x80 0x0>,
> +				 <&apps_smmu 0x81 0x0>;
> +			interconnects = <&aggre1_noc MASTER_CRYPTO QCOM_ICC_TAG_ALWAYS
> +					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;
> +			interconnect-names = "memory";
> +		};
> +
>   		tcsr_mutex: hwlock@1f40000 {
>   			compatible = "qcom,tcsr-mutex";
>   			reg = <0x0 0x01f40000 0x0 0x20000>;

Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com> # on Glymur-crd 
device

root@qcom-armv8a:~# bash /usr/libexec/libkcapi/kcapi-convenience.sh
[PASSED: 64-bit - 7.0.0-next-20260415-00003-g5de0c764975a-dirty] 
Convenience message digest operation
===================================================================
Number of failures: 0
root@qcom-armv8a:~#

Regards,

Wenjia

