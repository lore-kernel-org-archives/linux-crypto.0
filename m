Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC43A32824E
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764331755; cv=none; b=lLZXk0P94UwqRnhMBcBSYYqbWSP9LM/p6YqVDsKlOv/HliLFbqEY8RB+9hGGgHtcmNTwDFZdON/J0pK6Aoefa2Mv4q+D5lx9xgSaQF8dibzZ+hxrjXsCF7qzUn0jcVNEJ2Jy1F/jY5XZcj4xlAFbL9F1R66xEWPi7Fo3i8yYLgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764331755; c=relaxed/simple;
	bh=X1HS5RlkUvR5Mf8gx702VBsaC1MZAXNBdmskBGMUR0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jBtlg4mefDiw6Ans99D+TdCDbhWotlu9QDd2Pj09BWm5ahJUmRsqBkW/sPErG4k7A2ddiSi+12MrLWgvMUx29aKWzlN3DgvHpxvnFJwOnCKVu+XDEVmKKAiTEhpJbCkp6LOgCIp5xioPctUiTMPIzG72w0kvMdD5VLIkx/Y882M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Oj0wD+NB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jLF3w0MW; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Oj0wD+NB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jLF3w0MW"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AS8PYr13797569
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:09:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oKr4XY9THa4Qu8ZVXHA8oIuhhADCzAa7liI6QcgD5Bg=; b=Oj0wD+NBsJfLG7kS
	rgz8ucAmAqBVj2irLdvWim0gmgDBwSzu++UOBfdAZrRouzbL8fUOHV0GG5xa8y/Z
	gQsnNdNIwV+dcUIk76tnVDcvpraFjGZoqEvgToT8Je9V89991MX+JGQw3W7RyOcJ
	m0VPn7sTll5B7FiJSBSIQl377H8qS0bOA53KYClZ3XYS7pjUtmquEKxvxDlDr6J6
	WZVWBjZv2vubGY1UXbp+yyBck2AFMb5xMEnYqgfXKm6BK18aY7S80DGKn/2S/BhI
	o946jj8nhZWdkmXvY79m2awy8O6/6YjqO9UM68mQDnz0Lxk7ZWIfl2A5MOzOM7vP
	9ZdvZw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4apnudb2gq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:09:09 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4ed83a05863so6285001cf.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 04:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1764331748; x=1764936548; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oKr4XY9THa4Qu8ZVXHA8oIuhhADCzAa7liI6QcgD5Bg=;
        b=jLF3w0MWbHvlWDBdqDykKz7S1ISDvBFHTb+cmJBzYupim+i+rksGI5g+sPqMwrAJle
         hhyTLH5tOIZhIkkiDrxOQeb6aAgONRxHtMrVGa5DfylSC15/J7bi8cTXSKxzdqIeFxx3
         rsoUFCV2wRhVVO26C+fDpviw/NXTsJ1yovOPQ34iZI/EM+iYlmEzp91B5WvwlpWhpqFO
         MlHTQL7u/D8fhhHwfyJMKAGdGULB0dicKTDPbQ2BU9QArOJRboV3T/xpwGFjDKMuUUy1
         UQrLbRacdQKD1fEgKsKrqjg2gkzsBEFs9Qs3KQpncRogrZW83rpD4Yyi3HkR4Xu7T/Op
         zTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764331748; x=1764936548;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oKr4XY9THa4Qu8ZVXHA8oIuhhADCzAa7liI6QcgD5Bg=;
        b=qDvSgPFMDYQjOA0RmGVMQtlGYHw8H/71LdlMhsh5k1jYUcttxEV86JjbypcpGY5x8M
         eIJ+gtFogwkCTaGWw+Pm79bXS3Dch11QudXA6mNDJ93PYz6AiSci5n/NF9tg19JmUWnZ
         hlH6NbOgYZHHfEF7kmuH93/lNI/3XqjyPmosQfkpu161EvG1SARHuX2znmis6WOxcUAV
         RbyvSDHQQE7EjbhCcJE1hB9DSCTzi/aQqnQ2Dp6J0EIRbyEyySfG9HzwIp0oFuy/iXYl
         VeTxjF3Bn6qq95gj/znJH6IxLIv8y2+KUUj6UKcSfO/51upTNAIv+r6Rgi9Vhwglmwql
         t7XA==
X-Forwarded-Encrypted: i=1; AJvYcCWzqwl8sb80+jGwvfAu7sv5LP3W4rGIXmETA9t+w00FupmzLZps6BKB0zKFoV7/korb2DPZkinQqcNl/nU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqwMMOAf8iraP8v922zTn+cD0xAFEbdWNCTrs48dHZpCvgrTkP
	K0deleA3eqBGpYXVvw5UBhPCmS+wtmeIKNd96Z9Uke1IJUj5zOr1P2IYy0dFbjSn9h74wQzM+EU
	uuyQgTxtQLzTD0xRXFt6APXgBTazCx33xga/FvJ9QAcWR+mP/Qq9R1cw0Neb5xevmgPk=
X-Gm-Gg: ASbGnctdvDEoUCSRA+Sm+S6QxPUBq73bRMPbreGY9x+NMpoga5BEJ4GC1akTn8sgbce
	gTCZslXwO4nIB/NafwTqAoFck1LYO9fZZBNSkbnsM+3uULzskvSMHWm/fNpDqFKzjB7CVBn71aX
	0OmSTv7ImgrRu5vmbuN+pLGCBGtFp4p3EWpL20BO4scSBbbJ901tUcDSz021qIlnuscEwkM0Ebx
	lc+nwknzMLd58ZFI/ZDfRBZLgu/AJQ+9mWK/bXY1N9vB7X+ReTgdEkYVAZUHsHmzmW/iO2krfOz
	PIPUj3/blQuDaAfN8jeyWTD/eT7W+HqXvzqndH3c7ptLslaFzQGopOD7E2Fse2zeYo9mkXZ8drp
	tZAK6qunnUvUVF/CUyV2RXCmEIwY/J35tVmgl+TOgzSbjNzdzetuMyoki29DAOVwg8D0=
X-Received: by 2002:a05:622a:1108:b0:4ed:a574:64cb with SMTP id d75a77b69052e-4ee58850982mr276238851cf.3.1764331748326;
        Fri, 28 Nov 2025 04:09:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHAlY7BCtEp8q1QrNP4N2hl0KDcfWriM03Y+3OtjNiiPI9HSZHAnlbAIOL1EnnUjZgYWinnMQ==
X-Received: by 2002:a05:622a:1108:b0:4ed:a574:64cb with SMTP id d75a77b69052e-4ee58850982mr276238361cf.3.1764331747902;
        Fri, 28 Nov 2025 04:09:07 -0800 (PST)
Received: from [192.168.119.202] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f5162d49sm421867666b.14.2025.11.28.04.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Nov 2025 04:09:07 -0800 (PST)
Message-ID: <ad0ce240-ad84-47b5-b890-03a02efd8c08@oss.qualcomm.com>
Date: Fri, 28 Nov 2025 13:09:04 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/11] crypto: qce - Remove unused ignore_buf
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
 <20251128-qcom-qce-cmd-descr-v9-5-9a5f72b89722@linaro.org>
 <b1d8234a-6d29-49f6-bfc7-bdc738895d79@oss.qualcomm.com>
 <CAMRc=Mc0Mh5CjS0C+Ss-AG1qQ2YPOr=kkWc+Bbk5CLgPoPVrqA@mail.gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <CAMRc=Mc0Mh5CjS0C+Ss-AG1qQ2YPOr=kkWc+Bbk5CLgPoPVrqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: EA1pZzZQCdWg9KA52DW41UvaRFLyXuDv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI4MDA4OCBTYWx0ZWRfX6UgNThaBKeZK
 oTXDBrf0idmIPSlldzhKYZWV08OOId1YY5ix77olb8Sv2kso1RbB0CpDEj+DleWNlzgvi6iXD8e
 J0m6MygVlgPKE3gPkqknVjKac/3a7qLZHDfnSmd1FF2f2heEPrjzlRpbNlK2/wU0TEYdzTevo18
 oidNjTa34H+vkx35PPFaO41KjgrnNS4+bt7UZfc6eVE2pP7GaFTsOhidbWFs7eckMsa9tsVN/ld
 E5ZZUOsE+oBV1FXpSvXt4IAC4+zvcfgwBN9y1ayYTI6XlOJ4+Xr6AtsLuqvA/nOz2iRaHnbyn2J
 wfEv/y3qnmf4e1dc9cMfmKuWVpZfY15TTB2Ec8ibtZDd+8A72gPS+1zHsr5cumXMK/sa2sbCo5u
 oYT8cx8tSIuTKuEhrrio9rSZVSG8Tg==
X-Proofpoint-ORIG-GUID: EA1pZzZQCdWg9KA52DW41UvaRFLyXuDv
X-Authority-Analysis: v=2.4 cv=MKNtWcZl c=1 sm=1 tr=0 ts=692990e5 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jrMBgjXTAAAA:20 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8
 a=ENz42x8E23rwaKT2S0YA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=cvBusfyB2V15izCimMoJ:22 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_03,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511280088

On 11/28/25 1:05 PM, Bartosz Golaszewski wrote:
> On Fri, Nov 28, 2025 at 1:02 PM Konrad Dybcio
> <konrad.dybcio@oss.qualcomm.com> wrote:
>>
>> On 11/28/25 12:44 PM, Bartosz Golaszewski wrote:
>>> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>>>
>>> It's unclear what the purpose of this field is. It has been here since
>>> the initial commit but without any explanation. The driver works fine
>>> without it. We still keep allocating more space in the result buffer, we
>>> just don't need to store its address. While at it: move the
>>> QCE_IGNORE_BUF_SZ definition into dma.c as it's not used outside of this
>>> compilation unit.
>>
>> It's apparently used downstream, at a glance to work around some oddities
>>
>> https://github.com/cupid-development/android_kernel_xiaomi_sm8450/blob/lineage-22.2/drivers/crypto/msm/qce50.c
>>
> 
> Thanks. This driver is very far from upstream. :)
> 
> I think it's still safe to remove it.

Seems so!

Konrad
