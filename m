Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7459C3D6CC4
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 12:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368129; cv=none; b=FvBrmiupciJ+nw4oYVL27mduIxWdWUMgAH3wbaFhkEBXQElBP3Hq+LjI5m5FjfUKabGFwq9JvodRmvZAYVBmajsUAuiBO8EDEhd/3J3ke87430Yr6ljld77ZaEMsvKWme7p0c/vHE2w6optPwSLlfMGQCxCbT+eaC2LZi7hbPZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368129; c=relaxed/simple;
	bh=8LqULcbNlEaRfRxZtDdcZMoXysHCtF5izaRiuTJZZGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YztYBhyWmfE8TcGazrC8BvyPMHWsCuuwos/4SAqOHbKsyQy87FKUiiKZfyvgoYjLu3ocg0GCj+qlVFWeR1TD7q2AVZVx0hcEzZfMHYiL9hvVOgSnjcJ6EYjg2NkVwsBM1IcM8IC8T7SR5ujv/YMD8kn+2ivWSMOAJxi/aeuLNVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DPYQlLot; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Qf6drzuK; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DPYQlLot";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Qf6drzuK"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L99j3A3527290
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 12:55:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OQo6kYzQPwp7Eey7bUz8w7AceljcUrAzDN14KSaeFeE=; b=DPYQlLotn395xkfa
	6r90O2yzPh0BNMtjMi06lc5BZz2FVmXL7hqZvTiNE2ly0He/TK2JUhUSFiWCepKm
	a0Os+hNInTZjr9ZNpTUoqr5pSjoFbhZAffWCYrregi0KNl+120vvm8cTp5m+xtrZ
	pc5QYXJ+sNgTtjlxh1/Tpi02E4UszOzjPVYLkTMW46+Hoh0OmZI1Y++z30bdabVw
	rwShVImXc6UbuYvjQPGwfS23YVVvuRIBGn2cpcT3eUFuGBTCz0ysEaE6ML7v5k4I
	sN5eGxcdtDHJAd9Nk1XiqZOWfadfgIzLZnWA/Y84CtzqTkajxVEICT+IGNCjIJdZ
	ZYdglA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e9vhbhmv2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 12:55:26 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-91345d517bdso128317485a.3
        for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 05:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779368126; x=1779972926; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OQo6kYzQPwp7Eey7bUz8w7AceljcUrAzDN14KSaeFeE=;
        b=Qf6drzuK78h90iWXD9Sh5xeY37pcKiKUjggmMuu6K8p8UIyX2oV2cCzx5yisLQUnRi
         2mbhHv7JFYZEa4rpdwH04n6hCoYs+2GrGZHn/psaKtwBJUy98Qvdcwh+dfsMpuTETcSQ
         O8xCtMFmnJq6IoaZ7O+WqEYontLIiahhXNldUF6syfTu5yVyQmknLpyRQ8qiiJXQg1qo
         2wvnahb9CJyP4DMWfjRy4lDPlfs/IbnTWLoyvYiiOKsWMc+cSJmyf6Teo/uyTagLRMKh
         CpeDuC3yLMCXSDoE9nHCiu6ws9/mhyKdXZLHT40g8J/tZoKLEhzmRxI+ZRXVNbhxw3qN
         TiAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779368126; x=1779972926;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OQo6kYzQPwp7Eey7bUz8w7AceljcUrAzDN14KSaeFeE=;
        b=rS3tFabPs6WoDuGVZDrL0LRXAcyr/5VUFahcSYnnr0X7d0vipnI7q+gL9DtSepVm6g
         oDN2aqy24/gvJ9uk2zzWk6r4n1Zch4uZIzPykJ01HcR4NtP1u0gB2+MiciCZx06z1Evm
         pji1D2Rav/uIk02QvgkZwyIAuY3jmiwepUqMaVSTFZnYgStUm2bMtVZHg16Olz6SqfmL
         adWlqUeH0pfqmKmXikC+E/66eNlD09dPcjkKPSdPavhiNdqXJthXCai2YdKL5v0YbOK4
         jkBFoBNal6BmFhtHPFEu+KDxJDUcB9ermX8ts307tlmGhFXr2DnK+k8b0R6OFAj6nG/c
         b8hA==
X-Forwarded-Encrypted: i=1; AFNElJ9CG8c4ROb3K7wxcKZke2vvMjiA/tIh1US0zbUXvNh8O2yaxZtgQJS9w++Ap1VaXAQFAa6VwU4p5nWhpgY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGlf3NxjEKM+IFcpEGQB7a3NqT3+NxYXr/K+AOAstBV5E0Vc0v
	du45SghyY1GIeG2QumaLsnq6sBDyghd5uvaTMd/yoknsBuzi2f0wpi/zKMvB4Pye7UDKSRUak5A
	+uYuZvLkLVDQPBKQJYCUQz79FW19F3aelvVHXwTJ5r8ZciWMk0rfx9DY+TUM0V2AU2MI=
X-Gm-Gg: Acq92OEEmMPAFRlo+SOpmaZq3xn7VnNguYPZC/YKANYuHoHaCLNb4LVemy4dYZ0jmwS
	/mAXYelYkS6VH3G1uW0pcSqqN5p8aRsciwSUerqyQBrgStFzeN5+bsPDuJGX/2HA7jzpc5W3weS
	9mA6pVKCRTl5imVZzMeFwZdIMHplnvEBDOYKfKJNdKcDqVo1wdUnDMZrLKWVh2AxxudSDJkiL6L
	KxGKKclYCC2AL1POLAQmda+JSwyk6vLSVAKFskBSWDxZ0vxmO/Kp8n2yEhobXy0a7D6sRLFY5Mm
	1DMmOeD5Pw9U8svnatz7uJushuopNUGh63pdyMARC4ja3xU8ftjn7Qu3WfiF/Fe26IK5GZt/peZ
	auUlnB0BJ9RzohG5JzP7EENHTixphJcj2AHc0La3SKJ67NMHPnauqp3A3lV4JdAofa+1O1Ewj6j
	WJDHI=
X-Received: by 2002:a05:620a:198e:b0:8ee:f43a:bb63 with SMTP id af79cd13be357-914a28d6c97mr262357585a.0.1779368125655;
        Thu, 21 May 2026 05:55:25 -0700 (PDT)
X-Received: by 2002:a05:620a:198e:b0:8ee:f43a:bb63 with SMTP id af79cd13be357-914a28d6c97mr262351885a.0.1779368125055;
        Thu, 21 May 2026 05:55:25 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bdc8aef55b6sm42160366b.58.2026.05.21.05.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 05:55:24 -0700 (PDT)
Message-ID: <a3a02f29-33f6-43fe-8c94-584994657809@oss.qualcomm.com>
Date: Thu, 21 May 2026 14:55:22 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom,prng: Document Hawi TRNG
To: Manivannan Sadhasivam <mani@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
References: <20260521-hawi-crypto-v1-0-9176a3b51bc0@kernel.org>
 <20260521-hawi-crypto-v1-1-9176a3b51bc0@kernel.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260521-hawi-crypto-v1-1-9176a3b51bc0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDEyOSBTYWx0ZWRfX7nXMujGVHcsh
 PkNkRFs0f/iMWuEpBAg3ON5GHDah3Ctf8dA0O4BSro0FMFmc/CPcj3ph+nCmPCiJ/pEE2+Y8iNm
 60ey8WTHkvOWHm02kjuhc2AeNbLDPACbDmaqn8IfklsDcrqEyTVzLPXbRyfR0MtIgKBoxW9qh4i
 Iu4XFzasQS7lHpbYEJ+XcjGvyR9/8/UFoKzEjyAY2k6tKUIbLyoyMnrL5ardin9zAEPjWeZIPlD
 3FgEJfkV99HpbYdYNPKZ9f7dmigEp/ZKTlfFP9AYk0br34JmzgFcri5VH6Ndx5ugRFGyDVGKvc9
 7X5qXMIPsiHPc0u9leAf0oxNgrcax7XbH5D8pRJp3G6gUwwe6K1X13zWwHtGJUfPI4T5nLCw9t8
 GrzqXJgLMsYct9BS3o2bTq3LSR8qLQ5O9kjbmQO9KR+DClYZ3z7Ju9S4n0jQ6ElRmLpC0ejFj95
 aOveHzvte2118baeeag==
X-Authority-Analysis: v=2.4 cv=GYAnWwXL c=1 sm=1 tr=0 ts=6a0f00be cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=1K6-wu9-lYFVRRv0r6YA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: V6mQEeUiL8nvBfk8WLdjStO2bvMv3euq
X-Proofpoint-ORIG-GUID: V6mQEeUiL8nvBfk8WLdjStO2bvMv3euq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210129

On 5/21/26 2:36 PM, Manivannan Sadhasivam wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> Hawi SoC has the True Random Number Generator (TRNG) which is compatible
> with the baseline IP "qcom,trng". Hence, document the compatible as such.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
