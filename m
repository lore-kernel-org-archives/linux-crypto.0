Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482AD286D5D
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 17:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153582; cv=none; b=aEG7VjzRMemklDgHcH2G889u2+13YftKrjeB+9TQNsnYHmZyx5D5xyYux3CUlrhCvP/wZLHn1tfS4hLaZRe3OYZcIr31On+am7Ni56N0U0JPvx/6iW/DjvhIPkjQcA+JrkoXXZM0VjWAZCrqh1fFjxp23u35/A8bx+0/PaXc+gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153582; c=relaxed/simple;
	bh=gOQwJElKrLlL+KczaQjBEU0WOC+y5P4gVQMiGU5ncQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ca6T67DQbAiAe9Isqb9Y4eqggrGAymXxlKQRJQPU49DibfRai2WunQ+0m2yeluyZqfiMUd+Y61xiaMbLWriSdMmuNiFHxbu//5/+BH3fsB8NZoceObwMxDhJAiaDJ3y0Ccj6381Gy3hvbOH+rXUKa7RNJ3bYwrYJFGnmKIZwrUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EVWQCw0r; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EVWQCw0r"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59MAZMBD032407
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 17:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1ObhDx2qKilPXrpU/ecszP1sikcNLUfUe5WUKxrKas0=; b=EVWQCw0r6O7WujXl
	Q7FsvceaN/p+YMzjCUZ4WD3SMhwUnWNjLavMDJ3l1HEdHNImw46Lpo7YhZKWXwiK
	Lu82CGQH94Jqkjr7o/2FhaU6kNo2EoZHdxgW/bBNdHUaTlTX2U5Vpiodr5iYZs2q
	EXPAXYvoOek5eCLpZRicIbRByJEvSGhdCyUSfBT406E1TG/oQOGRH6wwiRiR874j
	5njdBEGx2LmXDej1Tw/mpNx8s9fA2px2uPk4uh5RiAe+B94TU8W2RxsxMJwdokkx
	JtAiH1W7GYHoi2W/g3qz4lPTdvoUHyTkb7o0ATLTSKQ0pIpKO1oIHBTizVYyiMGL
	0SjH8A==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49v42kdaht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 17:19:38 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4e8b86d977fso4847721cf.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 10:19:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761153577; x=1761758377;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ObhDx2qKilPXrpU/ecszP1sikcNLUfUe5WUKxrKas0=;
        b=OFh+Zv8HDtBN0UnXD/OnWT2YjpSPmtXyof1WMw6FYe7K43EHzpQS9TtDO3kMq06A3I
         tj3OaccPJt917aau6gDh7vlDwEfAgrjZJAH3MuSaLUeewd7ALGNpOPQXtRkXY1zDYxyC
         98kVqBKJoJyZqpVPPGSmdo6kNybcru0uDItcgDQj/1ht+5pRMQ/BX4GXmXSEm82He/+m
         hc1FV+fgZdtfcF8OFMzl7tWk280VpF+Voku34KerX7nAqwJlmxeIrmaZMLRcGWZPN2RX
         r8VXkAogTBGlGtr59s8QHbBNFAv3dkUdCQdPFiTyEkdOVpqfa6uwxkjWEX2Yq0tP/DLM
         zeAA==
X-Forwarded-Encrypted: i=1; AJvYcCWEni+dhYBwaIocbqBdHI7ow2kyKUV8waPGkaMwTGj6lsyuqrsHaMiV5XIN15hmfTbm9T5UZiiGHl6DEUA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjLJKI+NtAx2cWjITjd926qyqox+H9NO+5FROx5U9yMD1VeRBW
	cCkCqyt7fkuDf6B+giajFfidcInqDtLc2Bh+/GgDSnzmX9hS4Sv2/vD2AfbtO569VID9fpOS/4V
	FGl/84b7gGMnR+vjjdDNWrttJ7Y20yeqwDmArD6Yn2VKebKq9OCrxNLiklK8zqk/aBRk=
X-Gm-Gg: ASbGnctCPOCQjPxZHaqv2iwrekk5vK9l8rc0VwWnfvsrc7aZKZOXN6wmOXVtuEMLAlp
	YTcyGdSqX+05rqkmAnYt6Qu1ucRo3dGcalpsk/bOa4e5II5YUbRW28zW+wLuPIG9dbre3G3yU8B
	CImy6/v95MTWw8xP8oypgO1A/k1v4p372/ePeUh+ruxcpSQjeDVtvcy4RvGLncfL8ikTdp3zWid
	n0hIyFX4m4e6zJSX4sT/cNBU43Pau56kOkyRp1jD96kevyILdNBjml5rzzjro8vmHv1WLoIqpnq
	TmHbnUOIrATrk5YaRkHM2CpJfBAapOhwdh9mskohsnLUnPr2aXqS0vH+LmUr4MtMysOXgkgyBGj
	d51ukflIzGMhcrUcRFEDiBHx1n/5V58H6pjC+zswL0ZRxfbhcVGMNpK2Y
X-Received: by 2002:ac8:6210:0:b0:4e8:959e:440e with SMTP id d75a77b69052e-4e89d35aecfmr132575351cf.10.1761153577570;
        Wed, 22 Oct 2025 10:19:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1reHXf9fw3+r5fcINDoVpcwTbqNCUu/7wsWRAFjR33coa1mmho1pVdqG0TLpKriqCc6KFvQ==
X-Received: by 2002:ac8:6210:0:b0:4e8:959e:440e with SMTP id d75a77b69052e-4e89d35aecfmr132575051cf.10.1761153577093;
        Wed, 22 Oct 2025 10:19:37 -0700 (PDT)
Received: from [192.168.119.202] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65ebe4a5ecsm1389504466b.81.2025.10.22.10.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 10:19:36 -0700 (PDT)
Message-ID: <32702920-19d6-45dc-bf1e-8a90b1b8c9d3@oss.qualcomm.com>
Date: Wed, 22 Oct 2025 19:19:34 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] arm64: dts: qcom: qcs615: add ufs and emmc inline
 crypto engine nodes
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-0-2a34d8d03c72@oss.qualcomm.com>
 <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-4-2a34d8d03c72@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-4-2a34d8d03c72@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: _NjHdrf0j7kJP1IFGT61EKqzEHGMtTFI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAzMSBTYWx0ZWRfX9Occ1JhNH4sj
 +C0oL5nrHd/5gksPBAeEU8OBGEHdyF17VPgSF6sSVjD74DxuMWkKwv8hqzwKZ+YAHChj/GqNOmp
 yZofdKoOgbsRZcr8RKuuQm6+SXuw5FiC/hVBdiVeaueoi0ySi+hL6BENu5Bz7K/VuHyQvGmHYB1
 VSpM+nL2yPx74YzbpgaO5jNcS88HUE+wItpSRVCEA4xu0POYd+y6tBv9V0q+nqk8ga5Q9R9pI+o
 raVeyBp4lyxHRj3EfsqRj8fYOKiypJy2zc9URree9kgk4m710qiUqkgjqrhh/5kJu/HR+mphmVe
 gWrdfuOnpGfzenbrZDvOQ+4JTpBgjYSHJPI6dEGkElXwGYnj17B8hll5BoP0mQ3DTxEAYQGziz0
 ReR/h/v74NUDIfaSyXeTPVowXI2x8w==
X-Authority-Analysis: v=2.4 cv=QYNrf8bv c=1 sm=1 tr=0 ts=68f9122a cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=FCLlhkshBCn6XtExdV0A:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: _NjHdrf0j7kJP1IFGT61EKqzEHGMtTFI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_07,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180031

On 10/9/25 8:18 AM, Abhinaba Rakshit wrote:
> Add separate ICE nodes for eMMC and UFS for QCS615 platform.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---

The commit message lacks a problem statement

Konrad
