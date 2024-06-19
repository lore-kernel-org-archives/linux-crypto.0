Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D7115252C
	for <linux-crypto@vger.kernel.org>; Wed, 19 Jun 2024 18:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718821085; cv=none; b=F70L+SyH95T1y7zct3KFOAp/O8O67nSUthqY2kPBhqdydEG+iarJLMUh3Kui5OC2yFqT6uwPLVJdp0c7X5XaLwXQBpCymRIiCtG0iPQsxvOSH+eGlFUM5Vp1Z3+N2dm30ub+gziXhcogMVpZ2S4kQGPSxmSET4XTN0wQNoQp4/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718821085; c=relaxed/simple;
	bh=BMsEnaJeqRgypiQRsvcEy+etmijnHQyGI+cG12HwEz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dxcdl4t25QAqk4OE2WjLsF9lFU904Zs/vO9DhRLlrnmpanLgRKZ2Lf/vesDxQzA4kBeK2x2qRn+X5xZwvvA+s2lW2JFz7cTQcd66e8JF9Q+KxV6OC4VFyzVldiaaiBQMUwdbRWbyOwUNt6La4XI8X5S+AYz5Ixh75CycCW22+fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=FYlQOxon; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="FYlQOxon"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45JAuixe024363;
	Wed, 19 Jun 2024 18:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5eYe8VUZI/Gg2v+i4M3/B0rLim5Cf4VZmsZkZAO5Yjo=; b=FYlQOxonXmoNnsbs
	l9aHqNZjiVSBYvQnEyTpnwbovxuNYVHpVW3LvTIYd5/hDZFKVlQuAKlff5/9usJH
	eyHplB+rISGD8LvftNYJKU5hmVjyr8HXlGR0+ceql+ANMT+esweg9a3LVumh7eOT
	bvouPyCwWwVZ5IP3ynInG7U4zIvgI7ZX0s7I8Vq5qx2jkYQUQ996d0QA3ychVtS6
	e00y/knr39IlJIylKJ2gf5ZHccf1hQzNkSUgKEyxjrQoxCzGm0wDdHkKugd9HRbz
	wJt9iiuXcnW4pbwajx4fOnF/hfebGifXXdUvhuMp81S9jb5cS+5PHeoqYfP6irDC
	7irj+g==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yux1510vg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 18:17:41 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45JIHeca011538
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 18:17:40 GMT
Received: from [10.81.24.74] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 19 Jun
 2024 11:17:39 -0700
Message-ID: <704905a5-fcbb-4263-b6f2-c85d65ceef00@quicinc.com>
Date: Wed, 19 Jun 2024 11:17:39 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/7] Add SPAcc Skcipher support
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
        <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
CC: <Ruud.Derwig@synopsys.com>, <manjunath.hadli@vayavyalabs.com>,
        <bhoomikak@vayavyalabs.com>, shwetar <shwetar@vayavyalabs.com>
References: <20240618042750.485720-1-pavitrakumarm@vayavyalabs.com>
 <20240618042750.485720-2-pavitrakumarm@vayavyalabs.com>
Content-Language: en-US
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20240618042750.485720-2-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: awnik2yH0r1Nf-heyajxz9Z9RajCm6UB
X-Proofpoint-ORIG-GUID: awnik2yH0r1Nf-heyajxz9Z9RajCm6UB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-19_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1011
 mlxlogscore=761 mlxscore=0 phishscore=0 impostorscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406190138

On 6/17/24 21:27, Pavitrakumar M wrote:
> Signed-off-by: shwetar <shwetar@vayavyalabs.com>
> Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> ---
>   drivers/crypto/dwc-spacc/spacc_core.c      | 1241 ++++++++++++++++++++
>   drivers/crypto/dwc-spacc/spacc_core.h      |  826 +++++++++++++
>   drivers/crypto/dwc-spacc/spacc_device.c    |  339 ++++++
>   drivers/crypto/dwc-spacc/spacc_device.h    |  236 ++++
>   drivers/crypto/dwc-spacc/spacc_hal.c       |  367 ++++++
>   drivers/crypto/dwc-spacc/spacc_hal.h       |  113 ++
>   drivers/crypto/dwc-spacc/spacc_interrupt.c |  316 +++++
>   drivers/crypto/dwc-spacc/spacc_manager.c   |  650 ++++++++++
>   drivers/crypto/dwc-spacc/spacc_skcipher.c  |  715 +++++++++++
>   9 files changed, 4803 insertions(+)
>   create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
>   create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
>   create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
>   create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
>   create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
>   create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
>   create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
>   create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
>   create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c
> 
...

> +module_platform_driver(spacc_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Synopsys, Inc.");

Missing MODULE_DESCRIPTION()
This will cause a warning with make W=1


