Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F373B2FF4
	for <linux-crypto@vger.kernel.org>; Wed,  8 Apr 2026 10:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775642719; cv=none; b=OIS8j6pOf71Meq6jo6rtFE31RACphN1Yfv2H8uD9O/tS93HnaiihZz1XlkNvSu42NWCf0N3TNrO28/+aaOdMdeyQbmZIGLbfzuhULG7N0JlXC9jdaneaWL15IjeziO90ILa0ZmhpaSDaM3ZV2NDnZjmMBcmu3YdCMnAgjPera8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775642719; c=relaxed/simple;
	bh=KaKYz3pNj1hGcCi7X+D72zEK2m8mNY9N43dNxg9MM8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AI3bVkmMo5jG/B1DUDP+f7NYsFO84fnMFeB7PAiC0QCxUZ0v/ggM5k7luEcmnYuHtzMrDCCGdHuMOORj+4gFxbVmnTqOBv/SX6y3C1aE30fTrD6GWA0IsBI8V1Ii11p8Dj6XPHnM2P3hrbRoManzJsL+zORu8SC6fMsYBsRfGgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fxOrdk9N; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GjOqpdss; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fxOrdk9N";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GjOqpdss"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6385UiPU263875
	for <linux-crypto@vger.kernel.org>; Wed, 8 Apr 2026 10:05:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	iLq37WPfEGP6RO1vipA4QOAdYaXzJ/quNzFvXtrwp1k=; b=fxOrdk9Ny0cJFTZX
	//sHaqK4VxOLIR/hr0UU5UBu0yLFrY4aA6iHQXSBxL2YbuG72GiqX6xDmew3dlM3
	n0fBuDj3HrnYpv8H8umlianSW/2ijrjx92TFx1Txfqzj3EZV94Y8icjtLAxE7+Kd
	s2z/lr/G9U/myFRRYz1ST/zvzdA5cyEdPm3pavbmy1mBdOuVN1kzrYgWqNwhvzyd
	ETD26Y3LM7WzDaPECq4+ipua4MXSkjskEinAv+kjz3DWSN/nRmVrJ+Q7cMltKBpd
	URXhulAxa3FSKaJkNUEa+O2HuGOE0sHM8I06vEGVwie7UiM49r8B1/bZOZiyDVl6
	P6xsfw==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dd7t22rjw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2026 10:05:10 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-89e9d327913so23911426d6.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2026 03:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775642710; x=1776247510; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iLq37WPfEGP6RO1vipA4QOAdYaXzJ/quNzFvXtrwp1k=;
        b=GjOqpdssnGFNIGHOKEWYr8HPpH6Kdgeze5cun2EEJkBexfq+o0EQamkO7baiSUFbeH
         pNgyg7/9XIxwbjfgD19iAgJ/VB+BjwdHVHHrGL3ubSGLb73PDmnMnCF+sJwhyJGmR25+
         bxNtyVfZwfHCCw/8c6ADdTOM8zwExD3lFXFbK7iDphrTpvIE+M5TaYKZaNTgE9UGVTZg
         vRTFOgALVVCvWffJy1YoTKtRNCzBmcg0QinjFnVcotFG4ieYJ9UUl6FIwN40Tp7f9JxB
         DsfuAxrnbByx1qcBjdp5b6M3RdfqrKfzclSBNRjiJNnizPLiCmKxW7ronXz1UppKi8jO
         xWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775642710; x=1776247510;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iLq37WPfEGP6RO1vipA4QOAdYaXzJ/quNzFvXtrwp1k=;
        b=I/raJOuBx+ThUcdyEuyEfdNpw+9JeiTTcDuq2q+uwwfT6oD014SYGY2fHPPOpnDw/M
         Er8sZHPrxH71UtluOvGYE1arWjqdLvnTl6wzKjkfWbTMtYzhWdHRUrcYOsxic5yrJ9ID
         QxJWKF3B/TwUCfChSF71j8cHmXjqz/y4cRwbJpCUF1pBYPub9MnnLT1fQjoAT3w17iv4
         yhISXcrBQY+xrGFfwtTD9D/cDJZbHkHQ2tUJO9V00J47Qzve2KSEYPYFmuDiFQGv2hMZ
         gv2ncK5vGGxg6wpSM8g6dYbLSv88JzJ7bR0H1v9kCkOiaNX5Zk9FSnRIcCb/twKHHss2
         8t0A==
X-Gm-Message-State: AOJu0YyoN1XGuihUDNJwKF2vIfH+Ks3rNWfJnEP21gJnrjEsrHeQrrs/
	9yKlseoRkQWMsLq4EWYXafZQqZ7qYUYFy4h2+aohdMmIY0jO6x8wFNqXE+NeUiDmemibtVqYAIr
	6NWaZUpAAMYjT4+8711Kxu1pCWz9OsxUecN1F9KhARZpUwWsh49pDI7bNZUCNyRm+a14=
X-Gm-Gg: AeBDiet8XJ8SyELyp+ypmNGWIRzvD8ez+HdmFBWCWZHH7IQu9vC9n/mLRta/X9ruHLO
	KvDPwCq9eY/25qf/tn0fv9mj1wYA6l6K10sPKdda2NTRlN+yz/v3/8Jh04uRvRbcDV+34+gp57y
	OTtyL5tfKdYuTShANJYTXTrslJqBEnZXuu4HWD5yeHYlYociBpb5bbK7SfYrV4W9vyuTeCyiKIm
	jnPbhiijoj+aRL1TeoouxwEm0QpPjQq5CastL/LOed8acJuulAyOAvcVbaroi3KvrXwKcmEEkNQ
	vxGfWhFBYEsX/wI5+fv9fpJdpCuIxONPoX3xYMxQtli06rkqapuHHVAKgI4zWEBmdvxuu9kmGF2
	eCvnY2tyHabmb9aVUui/lo18GlVJFgP6+qFJLv66RHwh+kvFgilzzlc9axBHu3m6QHqVDEXMk7f
	tTfSU=
X-Received: by 2002:a05:6214:da2:b0:8a4:c5:1b23 with SMTP id 6a1803df08f44-8a704f9ebafmr238113776d6.5.1775642709576;
        Wed, 08 Apr 2026 03:05:09 -0700 (PDT)
X-Received: by 2002:a05:6214:da2:b0:8a4:c5:1b23 with SMTP id 6a1803df08f44-8a704f9ebafmr238113386d6.5.1775642709106;
        Wed, 08 Apr 2026 03:05:09 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9d3a6a493dsm11087066b.62.2026.04.08.03.05.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 03:05:08 -0700 (PDT)
Message-ID: <b9b71f7a-ca8f-47ea-899e-61e1f431b246@oss.qualcomm.com>
Date: Wed, 8 Apr 2026 12:05:05 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: milos: Add QCrypto nodes
To: Alexander Koskovich <akoskovich@pm.me>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260405-milos-qce-v1-0-6996fb0b8a9c@pm.me>
 <20260405-milos-qce-v1-2-6996fb0b8a9c@pm.me>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260405-milos-qce-v1-2-6996fb0b8a9c@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=De0nbPtW c=1 sm=1 tr=0 ts=69d62856 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=TCpjqbDHjloqY1tG7BYA:9 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDA5MSBTYWx0ZWRfX+CEypzVFpzOw
 fzIz6OpgkOwFuMUI2a+kecP7q9/8fHoiSOxqBZPHnJbHpUK6BoJ1i47NNdnXPUzG3AKliwbCi/u
 WDDKpT+VvoOyLMPPO4ud6WPJkLN5rmVQN8NuhCmGo2R4hrcHvncMEEVoVtyGATZkjTELsD3TEJv
 bL2L/Lk17aKmG4nQ9XJNWZtxpHJZjneT47iI2KOu009ONA5LgLkURy/41KIJLBqf1azUO9Mbxfv
 LmjONgH0HKr+ZWTvElG4WLTDwG9ZcLntQxfNg0XisXeJV7A1FdOsK24qmdaHT3SF1F+GieJxzJQ
 ljBduMerxVbpbPtdKUnk+9FoJVf+OkrdFL8XDnIPKZVC0V8Y9Au+yUWC9ApTIxT2BUqfFGsQC9V
 aFI/cSs8QBou974B0yROCWj81D/PeBBTNIgs7LrzgJejFYr5jxFZisLDlUAeQTC5z90u62zvMRV
 E5SqZ133+zj36JgOdMQ==
X-Proofpoint-ORIG-GUID: XJ1CRrx5e7Cx5eh6A5F7qyc9zfyrojbB
X-Proofpoint-GUID: XJ1CRrx5e7Cx5eh6A5F7qyc9zfyrojbB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_03,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080091

On 4/6/26 4:10 AM, Alexander Koskovich wrote:
> Add the QCE and Crypto BAM DMA nodes.
> 
> Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
