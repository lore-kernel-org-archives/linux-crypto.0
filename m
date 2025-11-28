Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECF5327783
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764331401; cv=none; b=q3n1i566YihOhxGpHJT/FOcZxVY8cfkXC3WnrbrRwhlt5kB0VVfc5QIi1qU/Dx+9kSL09NZuJQ3WRstAlfAYXcTw5Prmffx12Y1BoQzM/SA37oS+jCwniZ9RuvewSoYEgFwYkb6cwF4oQ4U+kBWhR+5zKqphUEktl7zW7FKiUhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764331401; c=relaxed/simple;
	bh=gI9TZ0qesYpRchQnmCsWfJle0T2gVsum9dhWtazzYhc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JCQK3hdJFmXnjapwO9Fj/T+sqXwdxEkutaYDHwNl/CJ/exQb5xfT2O+axspGTLqRO55zdxzk21mowDMjOyxsM1/3k0JlpHu+sn0Lr+nir5Lt97m1F5+IGJxXTr8OJJyolr31iI0BEgU/YnasDgVUt1YJyVwy1qTBhrj/G+GrYFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dXsj2XWp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GwJlR3aK; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dXsj2XWp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GwJlR3aK"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AS8NuUM3123322
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:03:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	g1rbYwToiy6vrEo3cBORYpLqQ5be7RIQVsuKG8oVUHA=; b=dXsj2XWpXgQOXeLa
	aAqQVWaY21Pn6MvDMbQE4/PLTC0WNqOghHZGX48heSclJ/JiBVu6QEVk6txrBAz6
	ub6qEg8B5JCIBqAuO1mmavE7DUl8xT5gPk252snPtL/8eSOP8kAXOdVH5qVsr63B
	NmgGMH8vRxNuiFw1IfkypQRVkcAgaVqREEXWj4TnY6y9lKPW37iXRBxPhi0HJ+7I
	JHXl/cAKQfmkdO9L+Q4+4QHit7oQ9ROkATSAv8/95s/NeWxUFuDqBDjo4fP+pSyO
	hgbl1Z+vpQ/EKzEYQ/bUGECnHlrGmg3gRyk6GTlVlEC2jONoWRBTsT0S3Q89d7a3
	T7vzwQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4aq58uh4ay-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:03:16 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ede0bd2154so5245671cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 04:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1764331395; x=1764936195; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g1rbYwToiy6vrEo3cBORYpLqQ5be7RIQVsuKG8oVUHA=;
        b=GwJlR3aKT/6ajh9GXicIegiVJJ3ZmwfzVl1JQkvYvKZUnkFCNDeVsI7glDevZ/uV5G
         9tm2mYo5hjQydFACPsv62klJg5BQGh0bzViJSv2O6tzcuVVGgBxUxwQmOtZRldo83luy
         wjCAwRQnWvI6JJftv8ivFBN+HOXLNz0DyG85BoJ9wuGoN2P9psDBQR/WeSR6cw0ykfuB
         0IIjUpNzXyiY6NTEBTsX2oROYvMsU4BMh6Kb70uW5UZqQf362UrTDIQzQCH8bJAJvk3M
         ze/3QquFEn70Qe1/g+XYfF3HIeXSeFd37i7GMh92rGURTI3VKTCFwgsaRneeTjZhb0wc
         Qwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764331395; x=1764936195;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g1rbYwToiy6vrEo3cBORYpLqQ5be7RIQVsuKG8oVUHA=;
        b=WCJn8dIQ0yJ9P14Gz93awpdZ+uV7klC0EYCMqEuajGUSBuulzYiUuqsT5UKqTQJzLG
         nouZslinFXfkd4vlKQ+j2uYWFca10N8lWhx1uR3H+6Yz1SdG9f85qn+d7NV2lPqp4pm5
         392VwotNNx3Eq+28Ai0+Nr6GNyYAuffQmP3aZV/o4/Hk0k4583AZh4Sd5qC6eE1x/BMb
         By5hqLXvyOdvWsjRWBbTet15OrHi3ZV1YpmbBjj6W2zWVzEQtZFUhhqq11m47/Zw5ZIp
         u2eMmoAj7db5NUfaMw9Rk8+E62cKFpzqVkJZgi2fiEC7+eb3pk802iKPF+1HrQWJzurC
         aITg==
X-Forwarded-Encrypted: i=1; AJvYcCXP3Ryg7mVCRw0k5/DtHAFq0UtZQ8rft205zPdp9cpbqeOjeADmdWRR3WHfFuz89f2lYPz0ZgijJMUNtOA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLu+bnIaien5ZgUh/BBhqpI89AxSdNDjp/S2sTeZr6tiiXNM1L
	c9QnyfEWkvVU7PgrHedi1XyqIUbqS6ZDl5HRpylCEslu6fzar/4gUb+MUUs1S/vrg697ylzcY0d
	PodJJWr+ALrWoIb+2E1Kk/gZOsvHYOOSda8p5o4zLx3QZ4+aryjTVuvBfxEoYWRCJDlk=
X-Gm-Gg: ASbGncuc5Lmugy5i/mOoX6CaXymk6U/ZA2DhvYjMuTdf2ouapAOqM0Lw9KDaPBOq8Cb
	Umm5j0OGtJhQtxtwOHlPq/d9DtWwQDauBr9CocqB2YYQVCOCNc6PJFJQJUa852FHBpLS+W32w14
	NLM6z6EvsThESE55+moIAowtMAxIS55A8EPDosn+5S6WBvWE/HVa2CZWDXJT7GfbdyeQNOT0tHj
	tONTBxBvQ/FU/dP4TFgH4Shl8Lc0KTepJdpoxZ+6wzvgMwl292ACXq4tEjGU6E7lkP9e3IgLapb
	fMPQ91XGB1Yr1wsQDIUDW9eXj9fdj6SD9O3+GVZSj9RMt0JCSzPCcD+fLjFbQ72caGH8qC4nvTG
	yO7ao1MShQlW6otJ/uXO8bC6JOcjKeJGx/97xutR57RSxQfsD05Kc22tX0Xt26eGt5jM=
X-Received: by 2002:a05:622a:c3:b0:4ee:2580:9bc5 with SMTP id d75a77b69052e-4ee5883ae04mr293260301cf.2.1764331395426;
        Fri, 28 Nov 2025 04:03:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHpz0IsBfLxHZyIJ3r4cJaVCTuzbtrQbveyDFdAcyfDdx1RZCSL9CU2KkChwNM2o3JuZNqE+g==
X-Received: by 2002:a05:622a:c3:b0:4ee:2580:9bc5 with SMTP id d75a77b69052e-4ee5883ae04mr293259601cf.2.1764331394940;
        Fri, 28 Nov 2025 04:03:14 -0800 (PST)
Received: from [192.168.119.202] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64751035c24sm4149349a12.22.2025.11.28.04.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Nov 2025 04:03:14 -0800 (PST)
Message-ID: <22a4ede2-2d9c-4067-b908-a95d3390573d@oss.qualcomm.com>
Date: Fri, 28 Nov 2025 13:03:11 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/11] crypto: qce - Use existing devres APIs in
 devm_qce_dma_request()
To: Bartosz Golaszewski <brgl@bgdev.pl>, Vinod Koul <vkoul@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org>
 <20251128-qcom-qce-cmd-descr-v9-7-9a5f72b89722@linaro.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251128-qcom-qce-cmd-descr-v9-7-9a5f72b89722@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: JPFbHSfP4s59_t2T6fjv7YqootCzmMab
X-Authority-Analysis: v=2.4 cv=UKvQ3Sfy c=1 sm=1 tr=0 ts=69298f84 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8
 a=wXQIig4NBtMv4ZYXLh4A:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI4MDA4OCBTYWx0ZWRfXyAdT/LCPjSTe
 IT7LhCYJgcDS5DH4Blk2VOe/OK6/5gVOX9/fIEJnybDNdb8ngs/nZoAFq3Vvu3IkvX2OUA4DKtE
 rK4dAND/wQ/1zjUATckhoFBxi8bM/Zy0n+BIqMuzj45L424RaOSQHYjlt8QK5kjltv61VVl6oJk
 woM8AHH7HT4t7tcxQ+HhF4+5OOZMKjMwswvLrckLT3rIFvMZ6xJJyNPUWMnWle6ROt0PJNPBcn2
 QCehfqwBEta2/8xoMhQgqt15OIKOCOnfrLrxSPX3g2lih0F57zJxuYW0EViz3KIGnK6EDrKfdMs
 YQPcakT3QTCr9jNvlJWrRnkVKTm6ZyLxXXBHySlrT7o8s4PhuFxJQcRCcMJQMaSqCd9Pt7JYRX0
 NdMFYzLU1zZlghV4ugcwND1uB0mt3Q==
X-Proofpoint-ORIG-GUID: JPFbHSfP4s59_t2T6fjv7YqootCzmMab
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_03,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511280088

On 11/28/25 12:44 PM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Switch to devm_kmalloc() and devm_dma_alloc_chan() in
> devm_qce_dma_request(). This allows us to drop two labels and shrink the
> function.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
