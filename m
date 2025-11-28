Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F046F32AACE
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764334646; cv=none; b=LyMGnEH/vc+KA0BCc1EhkfFDJPfCG01xZXQ5lhlBj9MhG3LkrlhpuJp7TviWXwj82TPBTZzrFfcpcTVsAVUrNYj/XIdUQM8wwT0d59OV2W6CjYaRTxgmShEalQCh4ZzPnrGL1Jywf+G+xUStYllYqQYKcyTgllPkYQMAQIEWkYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764334646; c=relaxed/simple;
	bh=Phg6H+8nPm5k0Q558yIc97aSgJoiWcWIP+LnfjeaZ+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mVhQmaS0GLoAp0tBTXFd6aj1RYkaYlYu4EcAn7K/Xzly93uZ3lNcdQfYHNXmzN7ZenW2f9R6GiHzWLD2owp0IgnCeNL3ufFrmZZU8WfHRq/OXMFOgw90PCoCY2GZLByADmJkwN96fN4HrEtwQ9YzxJ1XUhG0LwR7SYHpVaj3nY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lk/Wrfxj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JgWp7+CQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lk/Wrfxj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JgWp7+CQ"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AS8Nw5Q4191783
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:57:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	T4+S1KsCR+oTu8smc9oP0UxTPmQjSIc96c8vpuCaAbo=; b=lk/WrfxjzDy5T8LV
	+Pz4WMjA0eeMW2573oRzz4R2Dxggzi5ipotdOi+Z6DfUzMAOlURK3D2obZTqAsPy
	xfxrmwOsL2tK/PXd/iGqw9ED1QbtX8tYu9uxaQn7TWkQ7Uypa8A5Az+DeJOMfM4D
	VKhcFCim3pQB5c1LDR1/Z3pXqT20GaAZtHjrD+f6XOhXZuFC2o/Q5iWDgx48BCi7
	BmABnK07rjDZv5kLK34v3tWUtkZLSnJwLAeIHULokd53Kyox2TkJnMWeUp9zqI84
	W2ScLTPeOdsuQraiut1iXppI8B9rhhEBhBZ5aULFRvEKMArMDwv5yJIEDBwnVzm4
	jQXUuw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4aq58fh7fa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:57:22 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ed6a906c52so3494031cf.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 04:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1764334642; x=1764939442; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T4+S1KsCR+oTu8smc9oP0UxTPmQjSIc96c8vpuCaAbo=;
        b=JgWp7+CQuQi9510LBSSqAXaVqVCALIkRAuwopHTwMQYQ7RrXiq6MDA6SQsDaAhUsZ/
         lq47uEMkQFHvJU28EGmZgc9QPKyx+90zVcoRH7zh3Wd93AgMpcWI/tYkYP45mKw2Hr80
         0/qCZIiX+86RlHDEvVJolzuQ8vN/qw5mTir7OkovmHfVWm6EL897sejKgEc3fd1K4I71
         w3nmIMdmsdpwpsocw6lxq+G1loOR0gC8oYzkCrY5kI9DLQQUj9B/jg23mtYLCJuy10eY
         0D4NWrGGnydN2h+ez5KnQ8BbgpnojuOE45lY6KAZl3S+dTdqd07xInjvy28zJxkOTP6K
         IDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764334642; x=1764939442;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T4+S1KsCR+oTu8smc9oP0UxTPmQjSIc96c8vpuCaAbo=;
        b=rlnx2ocSFCrMMBHb0QegUrAwLMiZ2fGiwPAjWpmbjOQ5Ixe1h7us4m/rL2gJeuDCHY
         hPsO5kX1xkaKAzF8lCR/5wxZ+HnoYhZElw7AjsnsZIopJaclTH+i28naamje73fp2Xoa
         KZKtc97AseQcweUijvkGjrbAGuge+KH1KkKspvKa0mV7eAeR70YmR+R9qzsdzl64Lcnw
         vyG/7Ht5R0UxAaO5GOA3n2D/EFBjuc6J+qdX/lu4gkoKWtDTkCtRUW1dS7+0ryFtui+o
         UKSssYmJpjHPDPvE5ODBmkij6MXF02miXcQLAWdZL3/pmeRp9BMi5afRUcLE7hRa/NCT
         9iZw==
X-Forwarded-Encrypted: i=1; AJvYcCWtQfsfFCdZZkdcFM+NckgtSmT+9jGHsAyy7+MT0jTLo97xC91+TFGTnmSdLI6L1GGCBV4AO95MZbslPeA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKsMOif8SGnpEsbImaJTZ6RL57kgwICGHzjJM424XD6yQm02XU
	ghS3MZlIG7ex/anwYk/mcyj9wtBo9f4O64iP44smRKGcSkaez1zh2fauSDezTHZCN6CcoBcDTf2
	1ludoo9WUFT65sdhVcWyQWDA/Ehfz7t6MIAhN9+gK5pgENzusuUnaf08snVYblWuzykg=
X-Gm-Gg: ASbGncsHLSZ9U9Z7Lml3dH50bYnvjpyh8tMX6mLRJ7rohMmNUPLpsqN1wjLT8Im98kG
	+IFvq3q065GpVNNF6VdK+z5kTUR8iDcxhp9ZgH/OqU2gfVCzNoBvvhj/NNKbmHc1hkKX4mnWJcv
	Sg1r+GgM8aNYMo1aXZtqvGW83RVI4MxGy6Lf6BdkGE68fFx3vPXrbRFVqBOWsK/9Or5sV2yWIpK
	H1q9/KVQ4F+7bP5ZleNTJvNEMit0En9HBkXBRZnj+AtV/KjLKslO7tGXc70l59ecsVs0p2B46IJ
	cW87KywkBaBDJmYjVp/5f19/pSPzpwlf+VFpaa2h20TXN2WKyskkHJ96tmU6BK/vGadWzHG3lXX
	vD+FG4wu/LC63PTU1gjzRf/PEyOKZ9rh1ettZYJvsOvu44LyLay7/TbS91xsYVK/AvNo=
X-Received: by 2002:a05:622a:211:b0:4ee:1588:6186 with SMTP id d75a77b69052e-4ee5b7badc4mr265850271cf.11.1764334642328;
        Fri, 28 Nov 2025 04:57:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFDeoOKipkkD6z6uDYBWbGsDCociwucSXrzeeVHv4vzgh2zwyR3EFUyJx41RNOHudMy5Znk+Q==
X-Received: by 2002:a05:622a:211:b0:4ee:1588:6186 with SMTP id d75a77b69052e-4ee5b7badc4mr265850031cf.11.1764334641913;
        Fri, 28 Nov 2025 04:57:21 -0800 (PST)
Received: from [192.168.119.202] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647510615c0sm4352008a12.30.2025.11.28.04.57.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Nov 2025 04:57:21 -0800 (PST)
Message-ID: <183b845c-5fd0-44b9-8133-9741acc94cd3@oss.qualcomm.com>
Date: Fri, 28 Nov 2025 13:57:18 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 11/11] crypto: qce - Switch to using BAM DMA for crypto
 I/O
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov
 <lumag@kernel.org>, dmaengine@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org>
 <20251128-qcom-qce-cmd-descr-v9-11-9a5f72b89722@linaro.org>
 <afde1841-f809-4eb2-a024-6965539fcb94@oss.qualcomm.com>
 <CAMRc=Mefy=6XDzA2bqe6g_AZS3bbdNEKoq4Z9hV8VwSq5mYBSw@mail.gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <CAMRc=Mefy=6XDzA2bqe6g_AZS3bbdNEKoq4Z9hV8VwSq5mYBSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: yuBHgsknL6K54RGDiqBLASOfq5_9NgVY
X-Proofpoint-ORIG-GUID: yuBHgsknL6K54RGDiqBLASOfq5_9NgVY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI4MDA5NCBTYWx0ZWRfX3YlUAj2O/fCN
 rwdq4GOfTSTtatJuL47ykrikcjn4MWy82ED8U+zZj1ZuGBG5Y6lgr/5YywfFQmLK7IpVDF/IPkN
 gEKJ5H7sa6DB05y3AG7o5EekwlD1JPWgKv6nckm/uxpAjJuKtqxzYjZzgcrOiUdhNJXXZ/K3rW0
 QAzhSnAXtN0Pj1FMWUdXnSLDGswU8UOLSjCAAZ/e6Kv0/TB+vJPlnobD1qowUG+AEbsyWYV+bC2
 DWeQHZ/F/7yAT8f4hzCx0fSBBTx4MRXP1wrjVXL/R+EyHTO68eA/8/vwWATKiVv+6Z8s41GAhLE
 Rqoc9lk7VPwJOOg6If0GaWbEw3dFulI6qZwx8+xAN+sWcv0mn4HYBO8YsWCuWtqFmMoFd4bQvWu
 6hESg3kWFqyeopxMPZTbum9c5VH7uQ==
X-Authority-Analysis: v=2.4 cv=E6DAZKdl c=1 sm=1 tr=0 ts=69299c32 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8
 a=LOu_IrZLGVboqkKOeDoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_03,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511280094

On 11/28/25 1:11 PM, Bartosz Golaszewski wrote:
> On Fri, Nov 28, 2025 at 1:08 PM Konrad Dybcio
> <konrad.dybcio@oss.qualcomm.com> wrote:
>>
>> On 11/28/25 12:44 PM, Bartosz Golaszewski wrote:
>>> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>>>
>>> With everything else in place, we can now switch to actually using the
>>> BAM DMA for register I/O with DMA engine locking.
>>>
>>> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>>> ---
>>
>> [...]
>>
>>> @@ -25,7 +26,7 @@ static inline u32 qce_read(struct qce_device *qce, u32 offset)
>>>
>>>  static inline void qce_write(struct qce_device *qce, u32 offset, u32 val)
>>>  {
>>> -     writel(val, qce->base + offset);
>>> +     qce_write_dma(qce, offset, val);
>>>  }
>>
>> qce_write() seems no longer useful now
>>
> 
> I prefer to leave it like this if there are no strong objections. It
> reduces the size of the final patch and also - if for any reason in
> the future - we need to go back to supporting both DMA and CPU, we
> could handle it here.

alright

Konrad
