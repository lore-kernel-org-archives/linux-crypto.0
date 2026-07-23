Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B351F4181
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 07:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791591; cv=none; b=tHX/4yNTVQf94AbLkzP5WzQQOS2Lxv4PhuuNAAjuA0M7Km+3KXWmdgeZV+tHd+u9jJmJ2vey1Js5US5zHBngJx7oZQQR4rFX9wSGBbxGWGIahDjulhHh3UNiIayau+JDlxjP9/QtdRMHeFtQ+ZXueqzjBj9FhLFzU51fOAnT8e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791591; c=relaxed/simple;
	bh=AGdZIVFbSq7k5LXJC/Zs3P1KBHxez5Pg3Oe8hxveMBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g7p/P0x8cVjMJMm7KP5Yc/r+kVZYo//np1bN0o3C6i3IzHJOErgE0szwR57CQ3b97zcLmybGqqV5n80aSK+8QBQVjv8vkILWbtodzUTBKwXB1aXCEr6K7z2/EzZIeGSjy4gFWL6Z2L9pT41i0pUbmzbIqge6c61yJtRUaIB1tSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Cg3IdgRP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VtwP2Gz2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Cg3IdgRP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VtwP2Gz2"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N7Bk5D2815556
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 07:26:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PuSg+iQ4+3D6K3PZRyvJbPKPj1JuRfwcDG2f9RKNGoI=; b=Cg3IdgRPrUqOwQIV
	uCsypdT5LA8bc++KOuhpLQQWd+Um8IM+wi5aoi65ouC4wNv/fPR3WbBzdIWcKttn
	9Ldprh0YQ4ZVkVolInxbn1eeqvHJ4mF60pWQOZSRHlZr0/bqlRaavmCcU+RAoCOU
	HScna51QztYU/e4/erLrmn21+qUKAN3ql7c5BOmv5tkMdiEMm9AOO/NlX9157DG7
	0XOvnx+3v4nNkTAwrkHXqGixfVRy8onK/cQBYKUAc6jVTlEfcNe06UCmwPFgMlmX
	yyqmhN43vaVKHftayhWzz9gA6oXU4bfkGWVwDitQq6TIxzcY7t8qrtLfDIbJkJZu
	XuJB8w==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fjxmgkxh6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 07:26:26 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-caf5fa127d4so748399a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 00:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784791586; x=1785396386; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PuSg+iQ4+3D6K3PZRyvJbPKPj1JuRfwcDG2f9RKNGoI=;
        b=VtwP2Gz2N4RgXOFWfsIQCYeR6uGSCLsihb7EejjKcNSziJyCQt1BeRgBfp7pVW+Wcb
         KLTaSQ7wzmypaS3hxjzpgkuwiPDjk8prmaaw7kGiwsou5JghDvR/sVM0DZRTDSOPzdKm
         rrU4WStpaCKidGTWgtl0I9UiiQmVALPs8r4pma/JyC4dB2tIL9/8j141Lm+zrF8j11n0
         N4G+Q1dH3zcWLxTI2tg/SNfO72tDEatv0jFw7tBlqT+KdAZ6JCO+e/8UMIjHAtXmkBAC
         wlDzVKziVxgst96e/n6sSzIu+2mlJ09LhPEX1/UAq2f2D418Wrg5LrnLJZlBlin7EGej
         wd+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784791586; x=1785396386;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PuSg+iQ4+3D6K3PZRyvJbPKPj1JuRfwcDG2f9RKNGoI=;
        b=nUVuYHOkPQlJU+ozuNwPowosdr4toTkLelWH+W4hSV4Gcc/1qpLelebB8hFq5bujz/
         zK3+h2aYq5SSoxerXTCweE9+eZi9/qKpx/fHyi3jKcONoXDqfd2Ynyz5el0b2KTYt7NA
         qXL2RQ1j2H0PTbIewQwL6AY/HsMg+ypUQywBBjTM/pdEhYC5+vk/HAL9F4QvKE0h2gis
         oki7DEyNtqupURxfSmcCW7NGlOM5CLrKw9UK4x3aFLwh2SsDsM2+WygzNwYsGb5fLyl1
         2/IFOZWBADnQ0d17VSY7VJQ/IEj+AtzrYDVND9p6njN7mEGPMJVZe801e1HGQoVkCJwp
         o5mA==
X-Forwarded-Encrypted: i=1; AHgh+RrYD/pQGy7+TWVkwd+mPSkkFxQbtDPCNwcQwTcZSEC3C0M+5e1MXp+yS3usI2vsh1059RKVeFDSun3stlM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX9xXV4e7HdoOFKDbR+znosDnSBFE2s2F1jzokwzaklzAUdDXR
	Fd7xjMwhjoRRxPHfddBjjfgg6UFJYs6hB9eYjYH8Vu1rhELh+T6J9lzQ5Q6bHJ4+U7UOdHliY5m
	QHS4bOv6hobWAWeRSgImnzE+bXVFCMDrlDdedwBOtDo8h1j+i2l8O3jkz02jvDYt1dV8=
X-Gm-Gg: AR+sD101rE81Ghc+agSRoNuuEqlRPc/Iw0X1+ORFyMjbZ85/3w1LJPoeCzTESPJ5yOr
	qENGPUsOCFn3lN1qroCwCSSWogmGQAcFAR32iZTM8b0VCmhHoQIV2KzQXNmmdkocxfDwo7USkLC
	V1i8/4+UHZ4OCQlaLVm52LiRRPu0CLaNOrK+CQlr9wfZO9XzGUTksPHKtOLj6zAfhwGJU+GxZ+p
	dThDrXei52f6t1+RP9/hFJPdxQUVS7eUT+bmsi4LyCo+nJ6DxoOjJEoQtplWyrwoHQQ6RYUctod
	Z/SUzfaYm7jj+DeRxhDmyz6atX+PHQTmvAeUw9pXEVV2s5aH7Rxkr2NOVp3Bo+D5wU/tmPpcaM4
	94XobaWvInk9eHOYP/LNV9NQkWmQ=
X-Received: by 2002:a05:6a00:854:b0:848:3119:941e with SMTP id d2e1a72fcca58-84e2c181931mr2456295b3a.47.1784791586262;
        Thu, 23 Jul 2026 00:26:26 -0700 (PDT)
X-Received: by 2002:a05:6a00:854:b0:848:3119:941e with SMTP id d2e1a72fcca58-84e2c181931mr2456264b3a.47.1784791585827;
        Thu, 23 Jul 2026 00:26:25 -0700 (PDT)
Received: from [10.92.203.75] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e172862f7sm2506313b3a.21.2026.07.23.00.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 00:26:25 -0700 (PDT)
Message-ID: <cd5fe7eb-aa9c-41a2-921b-52a88bc1bf3f@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 12:56:20 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: hamoa: Add ICE node for UFS
 inline encryption
To: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@quicinc.com
References: <20260722-devtool-v2-0-d7e609ef7388@oss.qualcomm.com>
 <20260722-devtool-v2-2-d7e609ef7388@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Organization: Qualcomm
In-Reply-To: <20260722-devtool-v2-2-d7e609ef7388@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=D+V37PRj c=1 sm=1 tr=0 ts=6a61c222 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=SooqmcQUKh5i17ny3PUA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-GUID: IETxRblQ1vVq40oGaXvNW-jUx14Xn78u
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA3MyBTYWx0ZWRfX42QDnpom9sYH
 pvU1nhVa5/jPLqGYnjcMliHAcyoR31bpmbLyz9zMhU7BiVrB1XooAGdjIJaJK8gHBAIMxQWbMzQ
 05uEQavwKQapWwxTvXLPhXl7DTzx9Ig=
X-Proofpoint-ORIG-GUID: IETxRblQ1vVq40oGaXvNW-jUx14Xn78u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA3MyBTYWx0ZWRfX4VmPfFefF0it
 GNzruHGpJk66GqlpVqxxbAK+NpcONkC2TUf2Wo4B+knUs1+vj9g9+9CC13mjMZheDf7fT7wwxGY
 HcHjdMPRgQqRVo7ESd8RJMkgOyYJAy8d0/hKe5WsGGcD8vGkWWBOWm+uW09WyN5cOi8pRkmwqgR
 oIT9ZZuGGaUnCLfHfjHRWL4RAsZcxCsJaDmhUNICvwuKyXejl0OD05IDq8xjvzlLDFn8xjfpZcF
 IsneNYSImSbMdTaQJ7432JictsU8ejgkavKpUxoOQQ31oQSJ4Z5TjcENsD5yVHCD/F/1lHn+gk2
 Vm7vyN33ED4XeFrzo4ulBiM3UhzrCtMLPNwLLjbtsGAK3ksd69HOPo60RrGT/GKPu7KmNmpqZPf
 trBy01n3w8TSfounal/YcycTwLt/y4jUawm6QFSjXw3oO2ey+LnI3rWvApPi1bilHbuKftGefGD
 EOdoPcSiPZ+Ynu20jsg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230073



On 22-07-2026 02:56 pm, Wenjia Zhang wrote:
> Add the Inline Crypto Engine (ICE) device node to describe the
> hardware-accelerated inline encryption for UFS storage on the
> Hamoa IoT EVK board (Qualcomm X1E80100 SoC).
> 
> Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/hamoa.dtsi | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Regards,
Harshal
