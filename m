Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D173B2EBBB4
	for <linux-crypto@vger.kernel.org>; Sat,  6 Dec 2025 11:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765021498; cv=none; b=u//OyK832FcggUrLN2eQi2OGS5313++QDsjEaocnNJGuzlks2hnGVeHORtvddoSL2lgjfMTF96g3c6qu2WbLXq1g8szLeFV811PnLpX/ma+FOxVDJJFeJ0T1/WWiwU7dIILXDn+2n358M05JV4NLZ2zHJSQHuHDhVuKf3ZvEcCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765021498; c=relaxed/simple;
	bh=9OMHApkzIG49dRkSfAQFME71Alpd2HcvfbAgDoWtiRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kc+jnf4mBaz1DlAtcfGDZINhmV9Aindstyt9hLHfLqcOAcpIMKIRFIL4e9xY+rY3B32sHfiID4l3wFU2/pPSyUNzdirBT0in/OfPaVJTHDJblKlKcRXvnM6TJFCk+YEzUst0zyA14g+gBJgF62wcy+HhOQG87cUJcxW33rVtcPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=a6v7ADCx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jUjRfuzX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="a6v7ADCx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jUjRfuzX"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B6BXQfE3533561
	for <linux-crypto@vger.kernel.org>; Sat, 6 Dec 2025 11:44:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=P5rGsK5QqxRVUAaqI0WDgQNV
	059B7nGmE4iibyNRAgk=; b=a6v7ADCxCPPsj8T+Y2YMBbv3SpWdUkU1H+f6fQYZ
	I65AUc3Sn3rMINRu/92pE+GRVVUq5o8zM/VfWIzkhnLvvc7UkWow3AXFW6W2q3P5
	8Kc20rDPydU0MILPD6AiXW0wrN5c8+HocQiRkGCFWKi6ugw2lLUNGDp1rmCSwp44
	c0iOkcXtNxubTRgGcK/sCsldvacdBTL9m+oZUpKojKKtQ3o/3FdZoG0YwxXrVmnp
	iy5kO2YylDqeOxGAccRVJSazxz3k5emGprtGNLq+ObH4/DR4Fykb4pHDzYnnbF6Q
	v4RVWpNvmUS5/j7P3Zza22qKm1gVnoIy1u4jxObyBZH9Dw==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4avcjv8nh2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sat, 06 Dec 2025 11:44:55 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-88234e4a694so52578776d6.3
        for <linux-crypto@vger.kernel.org>; Sat, 06 Dec 2025 03:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765021495; x=1765626295; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P5rGsK5QqxRVUAaqI0WDgQNV059B7nGmE4iibyNRAgk=;
        b=jUjRfuzXEKvrYeQOrIkTuWp+Cht0eUpPf3F7T12qriPO8NA19p8QTifM3EOkA7VgM/
         nOW9RgszC/c2TYNeY71XuBFIUIcO0M7Z7HnSL59i4PkZVivXzvyH3S/9wUR52thCGVDL
         Ad8mjRlkoBTMqHkL755/q5ayGDsOMH68mSDpNJOAdiEf2g/jQ7bcO+xx1TUNs55CbEAH
         jYINExaBwgUCP/odhlw8Ht5Uh10Nqv+If2uBxgSH5bsDNftAG9PAJN45kM/0wiz8PR8t
         oZjHOVtYn8wPZ3DTsK0ddAitJBSqxgN4krBorb4BDLSCX5OwO5p08rODblbih3IBxX8p
         jzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765021495; x=1765626295;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P5rGsK5QqxRVUAaqI0WDgQNV059B7nGmE4iibyNRAgk=;
        b=fqdi4VGfJAYGySw+KoH4dIDUU1fs7om7rpAzE/2InT4AWaVTmfGQByDR2otGO//4R7
         vMBcKOP/Ujd34/sC+mbmo2Hebz7iFgf/ZCDqi0ii2VoX2Ek4p5857VQ3MT7qIK9LUPCT
         USQoW0aE/vhDqyJiVbudWgvc3owoX1BNQ/ytGWg7JEWEttaM4Lr1FQ01WaSXkUN1YRIM
         +2lMny6ZOzkaZqcjhKgXGZYKGrsfzl+G0rXys5ygBzDcAFzlYvI36QEqtEqO2UTyVRLF
         L2xILl6gSB521LS/qKXTmyGQ8xqLYNmmTROARpfxGscoAYHl97MZstrWWQWz+FaCotN1
         QVbw==
X-Forwarded-Encrypted: i=1; AJvYcCW4JsyIomgAdP7HCkRR4194JEnx9F8Fia6d33d2pe2LBevr0bcjcBRqxtzbvss3fJDdxS2Pnso9aOwKnVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YykwtcIoHM7zAU2SDzzP/BMRSACxqRypKTO4mo1ePU2eeSxq8im
	mGSp9tA0Ku6vWy+sFgQIk02SKsd4SEmtcBsrQbL7K1ck/pqljaCproTO4YqUQNxHDNx22K5v9DJ
	nomqTY4lpBZoNVMi+NIUufzCN2M188mQnv7C99HjJsx3XP30gs69AjmPcTxhfdl/2OrU=
X-Gm-Gg: ASbGncve6dycZLmC+dHFKBYn+vEvevett6O0up3fgYYZhT3IkQzqkHhOFlu4SzEc4BQ
	/uFgyWZgm5FAUzBZLNin/W2xqSauK7Y/pgkaASwchb5TyKz0jhV5sKxTiHG0LHjLficbUNKAG7T
	knd4YWERlmxFlgSwMv4SGPQM7QbK+abwIxlBr2bkJMhiIp9zkEblRwsVNzKLKJh8Q9pXq+ApGUJ
	E9XD04s+yE9jaX74eivDY58lq6pM+vqkFnMaqRN42X0eo2PtRHXUMMN5ladECJs5ww981TRIXbz
	A3/ufbkfrTV8DoNeI20He0A5uVekA1SyLRRzlD7QrfDKtGUex4qWv5aHqy3GQ8K/zuuX+h+kE5W
	uZrSpy9SdUZKX7cwTtZhdp+bQ/6mAHxQJvrOd7En60Fc+PGgOzk7FByFhWgv1BZTfVDSzGWuZlH
	oxlFatZwhVD8I6cKRnGTjGMcI=
X-Received: by 2002:ad4:4eab:0:b0:887:438f:c40a with SMTP id 6a1803df08f44-8883dc28d50mr36658446d6.32.1765021495083;
        Sat, 06 Dec 2025 03:44:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpxcMtM6xcqRYA7JSNpznEFhk4xBjRDm3jrSMoUpDSyNOJHg1uxxVfLvEP5+cD8A6FmTiQSg==
X-Received: by 2002:ad4:4eab:0:b0:887:438f:c40a with SMTP id 6a1803df08f44-8883dc28d50mr36658066d6.32.1765021494668;
        Sat, 06 Dec 2025 03:44:54 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-597d7c2e2a8sm2380406e87.90.2025.12.06.03.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 03:44:53 -0800 (PST)
Date: Sat, 6 Dec 2025 13:44:51 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>, dmaengine@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v9 03/11] dmaengine: qcom: bam_dma: implement support for
 BAM locking
Message-ID: <d7dvcakczg5rugn2jnpx7kaqsbqhgpicbbzmtxdviha2qdnm6p@n52lxjzomu3v>
References: <20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org>
 <20251128-qcom-qce-cmd-descr-v9-3-9a5f72b89722@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128-qcom-qce-cmd-descr-v9-3-9a5f72b89722@linaro.org>
X-Authority-Analysis: v=2.4 cv=Dccaa/tW c=1 sm=1 tr=0 ts=69341737 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=u0ZkndI9OmTMsI82GJsA:9 a=CjuIK1q_8ugA:10
 a=OIgjcC2v60KrkQgK7BGD:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA2MDA5NCBTYWx0ZWRfXyQenfBhEoQNB
 h/WeZhnN7TNvGXO/vTQyjHoM4gM4D5J5ZRUbKrL6uJSPy/imwnI4tyEkhr1a2FBSe4bzaEXx38c
 blPEylLcB1MQUOMKCsbaogE9Au9EfxeTAmJG7ZMhCjn6RQBQtoI1vrwJVGWpUbwq0TrW2lY9Cco
 geITOvEh7ehpB4OuMw+xOUk0OnkNgvgxz57QZRtXBKGnSCmIgiDyFL9WWGptC/PNY1xT93UGL6j
 CjtQ+GrngX1+/ip9zekiocGPOnWv3UknhMoVNVKUnKqka1f94JzCIwcqT/EeaeGE7tyTBabyJpa
 7MU/kojlZheJiHQkGmQSFNP3nGtLKd82h05KLULqvyTnp0b6RvkE27g2Bf7PbFKv1HmZh0w/pGG
 K5ztCrUSXOZWsBPFibyEc66hUEtymg==
X-Proofpoint-ORIG-GUID: Jr5n31PHpY9z2X00sDVxxxp2U_3LZhEo
X-Proofpoint-GUID: Jr5n31PHpY9z2X00sDVxxxp2U_3LZhEo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512060094

On Fri, Nov 28, 2025 at 12:44:01PM +0100, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Use metadata operations in DMA descriptors to allow BAM users to pass
> additional information to the engine. To that end: define a new
> structure - struct bam_desc_metadata - as a medium and define two new
> commands: for locking and unlocking the BAM respectively. Handle the
> locking in the .attach() callback.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  drivers/dma/qcom/bam_dma.c       | 59 +++++++++++++++++++++++++++++++++++++++-
>  include/linux/dma/qcom_bam_dma.h | 12 ++++++++
>  2 files changed, 70 insertions(+), 1 deletion(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
