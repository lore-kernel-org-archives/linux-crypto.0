Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1D337B413
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 07:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777274450; cv=none; b=H5MhrQ2GVa4l38HRBYcPfxSFTmPpbLGtpjMwJgOulmaDG07LX1kFpojb0pYu5gnl3IfOgLJXk7hS2jAkArhKUGGpelsZIR0u1wvpbFLr7Xhs3IHtZkHVZd4egOVOXxrmD11vvQ9ENQkN97KMfhVt/igAMTCEjcsaFme3x82Q7ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777274450; c=relaxed/simple;
	bh=o9f762Gf9TU4Xcf3RUmv4xe1w+G1LPDPNbt+IgF6tjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uGFrAzwiALB2eptpP9rLlKz1YJzRlSw0Bb6zitUtmiTzRO95IRP5oF4cnxGxp5C/vCrX/o3Pd4I5yB5IMcNMll73bOQWLi5dSHkie97yd2rcxHhLjsUeZ8BkYaX+6g9aW70YwYsJHiM/6jy5vFLkBIl6hySOetOFNT5bRkDqmi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KIMErKLP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OyW2NfiY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KIMErKLP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OyW2NfiY"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63R2WmhN484726
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 07:20:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7PmnkfFyBl7ajnSl177EBYWpYk1Eo9oHSOysxEGNHNM=; b=KIMErKLPlETn3HjY
	tQNcunp5B8oH67/o/f6xIg/G0QtRFQCrR5oyZ3PL5CFl+rTr0D2tLnMLC16sMPGB
	TcrdJufvPgRux5+3PqPGblfGIY9yXhqVvpUTcqO/UkK1/5KGd4gBUZWxY92V8cVj
	G0lSN4MNK5jRDNkHekrNFvfpt3bdMMUZDgNCpz2cnJ3v7L3r9aQrbM2YXYDyAodP
	efIfc/YutxSBHG9x49MFtCTCGtZCdhhiioMvnPBpaFG8ZuX98H/lUJCgrqepcu3t
	Q1m/ran42opvHcDWAiR/y3V9J0xeDgfB6nDugHQL6gcouk0DdZ34uOjkgb9zhxnz
	M+LLeA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4drnqtcy0j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 07:20:47 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b24af7ca99so135123125ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 00:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777274446; x=1777879246; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7PmnkfFyBl7ajnSl177EBYWpYk1Eo9oHSOysxEGNHNM=;
        b=OyW2NfiYPNKpY9nYPKXpfkmaaRwj1DAZSqfmXlkSo5MwpLvbPJIHCBb54DFkCeMkWp
         4Po57h6UKsufMHsyMKcW+0oBuU/6zV+Vxn7eTH9TJywnP1OU8tEgbwVYULkGKavsn0cp
         uL+nllcWiHhHEuiH3CQlJ9m8SrYj+d+GTj0GUnENf9HvmKwGdin/q5OQtHuCpe22yc38
         egubWOiM5GVAdm1c7frp6RThaQZNR7nblj1Hu+nvwRSJNFat9gZcVTnVKBytWWeE6mvN
         07Ct6rwUtwuyrmp1rxdC5E8K5jua16a71AwD0GU8P5K+BDVU51rxiwqjLIs090SU5X0Y
         M55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777274446; x=1777879246;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7PmnkfFyBl7ajnSl177EBYWpYk1Eo9oHSOysxEGNHNM=;
        b=i39KZp9I8bBLkXzSu7frmv+ilzeodGXM5KEgiTBv3LJ1c91Tcu4MQnhnj55zPMSHmu
         mZO5J7wcO4gBL8ON6sAj1/TqY58BWWz06sswSsnvkN/SB7qi1NSD9YX4Yglsg/MB7fEM
         L+tuCb+b/OMOBlbNfVdhkNLxU6wjtOZlZdQKTgCyvWZDsjHj58LcxjQBIACf3hVTNQIi
         +ncGi4IfxKGcXDJZzQOZli/WqoC8nbBUNNu4mcX0wqMtOrm8v44ORycVL6iQlTh/DGDm
         GHS3iIP+Bu6JoRgvAWE2D9T+u9N+t+AIR57359A/oABZC6tGGA2NUEyYywPSnFWgfOni
         UJxg==
X-Forwarded-Encrypted: i=1; AFNElJ+eOFMkf7g8Naqqxnbn6yPCbgNTmKqVRBxnaUJC/ATtACmtAZIHFGEtNc1ZDVrDQjxZX+Vk6wY5jFE4T60=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGxG1kdjdQrPK+sfVVHHHOV2yBjULKpu5Eiz41RuLHRO1mLd13
	NTuz33zSYOYZQeO9h8DQLXB6T+NOu0bC7h0FNt5bqvFy+pR6ByzezKHPcvb5BvaP+KEFlrVn9bA
	TJNk1847qhEvTgJTs80K9zF7WG47map5g5qQKjICZ7n71UpVQidwOWlOKqnhZpqulvw4=
X-Gm-Gg: AeBDieuwoSRO/Aaa3CGJjnU6uihMOBLqHigxf4ekwEiq2Lf3jvIexi1F3wN7KnwACtA
	080zo7w5Eh6T8uM4ZRvUEoYLCS4BZPzcSE/iAaJ6P3lY10c3Re7zjpqvcB0Q/zujnfwdXlPwqlB
	o6OSvaCH8J6oT4l5NeR0SRA0msfeBGZ07y5n1tTUx5eFek+RKt0C+ju3Kx0dfe+dF1bcsjS/5bu
	0+OV2YOdRHxarHK4GFzExDknO7LmcdB/MqWd89NSirm6tHNDJOXgmjC+sqeAGTBA00vJFO5ICUQ
	mYaFyXLih/PRokLQZ2258I/EL9oIfkl2p6EEl5kbPugJ6HOQS2RF2Rtr+ca+aCePtM/IwUvW4vC
	ZdZmzyDKnLPpOU7Nsxh5QOcyMXtIkqOkmdlhXaFHHa5j79vVSLryrKdzZcWXg0Q==
X-Received: by 2002:a17:903:8c6:b0:2b0:c45a:bc2 with SMTP id d9443c01a7336-2b5f9eddc7emr446294615ad.16.1777274446566;
        Mon, 27 Apr 2026 00:20:46 -0700 (PDT)
X-Received: by 2002:a17:903:8c6:b0:2b0:c45a:bc2 with SMTP id d9443c01a7336-2b5f9eddc7emr446294365ad.16.1777274446032;
        Mon, 27 Apr 2026 00:20:46 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab3ac1fsm315877045ad.70.2026.04.27.00.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 00:20:45 -0700 (PDT)
Message-ID: <f3e83bc2-36ef-4628-af1f-d9465eca72e3@oss.qualcomm.com>
Date: Mon, 27 Apr 2026 12:50:40 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Nord ICE
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260427010527.230473-1-shengchao.guo@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <20260427010527.230473-1-shengchao.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=J42aKgnS c=1 sm=1 tr=0 ts=69ef0e4f cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=JrGBsv4J1yBW9PuSV2wA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: HKi8-9cPEmNr_FhWrZNb8gMVJkco38Te
X-Proofpoint-GUID: HKi8-9cPEmNr_FhWrZNb8gMVJkco38Te
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDA3NyBTYWx0ZWRfX+1VaYOwSKM4c
 rdqEUe9161yJD5UnvNW/q+fwYzGPRI4s+jORCU/nnLIPCB/zOg4YQcv6hW0FDnungr76LMQEfbh
 slh+PDrJVm6moy39/XZfbnyQZMBPQgSj8k4SCs5cWl3dmWrowhy/6N2cXHt/s4U0bTB0hiTDMxr
 b6l5hfEmSTTLuMcvJwxRPnrH8kV3MVBjp2wjShxojDR/BXtlcyYY+uxrLSvwuERGocURe+K5dqk
 k9MTG/AUaVtw2UaQ9J2l47TSMg+Yx51QOO/AYRdwL/noQlLaphho/VR/8FqDFFZKcrD20tTGaI0
 e74P9W7luHgRXgWK5NeZp4si/IsR6GxzUMjo0ybqSu3ubnJhfc050RU66eHFFUQMM6OonbPt+G2
 lPcmltkvPZ+129xTMMM5XRaegFOsoVFA6nVb5V9Lrj2FlCEQbDm2e8PVetdvIl+cgy5caloWZs4
 mG2c5+PKxNUpSI+ZTmg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270077

Hi Shawn,

On 4/27/2026 6:35 AM, Shawn Guo wrote:
> Document Inline Crypto Engine (ICE) on Qualcomm Nord SoC which is
> compatible with 'qcom,inline-crypto-engine'.
> 
> Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
> ---
> Changes in v2:
>  - Improve commit log to make the compatibility explicit
>  - Link to v1: https://lore.kernel.org/all/20260420073301.1250197-1-shengchao.guo@oss.qualcomm.com/
> 
>  .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml    | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index 876bf90ed96e..9251db2b8fcd 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -16,6 +16,7 @@ properties:
>            - qcom,eliza-inline-crypto-engine
>            - qcom,kaanapali-inline-crypto-engine
>            - qcom,milos-inline-crypto-engine
> +          - qcom,nord-inline-crypto-engine

Wanted to bring your attention to this patch we are hoping to send for 7.1 fixes window
which mandates the iface clock and power-domain for ICE (from Eliza/Milos onwards) to avoid issues
seen when these properties are missing:
https://lore.kernel.org/all/20260416-qcom_ice_power_and_clk_vote-v5-1-5ccf5d7e2846@oss.qualcomm.com/

While I won't ask you to adjust your patch immediately, if our patch is merged, would request you to
update this binding to comply with the newly introduced ones such that the iface clock and power-domain
are made mandatory for Nord as well.

Regards,
Harshal

