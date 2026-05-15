Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6905044CAEC
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 11:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778844909; cv=none; b=HADIymZ5yfjkqdD0ocCV6dj2PI0DqDUHVtmM3z1xz1GGRlShvuaU4shVkqehRLgbpTb7QHApgQC5gHw+sVaTgTIkNd/CKVym2ofOYk/qHJgDAZm0njmHjn4zmK+21JCDUDV8MvpjCiqYaPCuoEapXglSwl1pkxeZUaS+nm0bWhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778844909; c=relaxed/simple;
	bh=T4RPsJkMOjmqToX2fSIVToaY5p+Zr9IfoSeYrjrwy0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rl3Kv/60k2X/mxyAqzjqufBTUj3Vp5hq/d2YVhllMtbNCgqCmXnBTwlWda+1DVsZ4Hv80lCGrYEVFBTtIHOy8cKxXu/x1JZd/TavBNHL1ZqGBrB4x3wAROxQyDE7hHIdGBExIEzeosOUDnRm2xUQK1fhG2Fy3TA64zGefw1+/jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EoOKpKHy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MnVxm2zp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EoOKpKHy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MnVxm2zp"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64FBFAZU4020769
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 11:35:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yf/PRgtxZLbnp0+s5IzrvGK7cZi2mh15dVgMB+bKXAw=; b=EoOKpKHyinnHxXmI
	GDj0IAmi4UNwW0CoUT0zzHchW4Ldux2rw0gSKs/4m6FM7DwvCGdNrlb7eaaITMv9
	EsrQHyJCxoc9omWKdNAgxgYAq2iIc1OKFRvlOfSUn+iXcyulmagfMkz4WdzFvceS
	xrpsvTOl+c8kpe4WyTquBCPVRL4txhMCVsujkSKrN5G5rkL4MJoZOHvOkrz+rxhD
	mco19r8IDVuKCsk7tA8iIH9VIXfHXZvNiI71UduHxMhH/TQYwUNX1KrITaennsUF
	lPnmO/BTc8ckeBxnpK292D/xSqZpz5Up7KJiXguc9M7IGKO0OZLWiE8jgSfugB0H
	n++pdg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1ru2nf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 11:35:07 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2bda35eab74so661726eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 04:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778844907; x=1779449707; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yf/PRgtxZLbnp0+s5IzrvGK7cZi2mh15dVgMB+bKXAw=;
        b=MnVxm2zpkttGF9UH72jpb5auhyKdgNCZIJ+z6TuvcQbmUG/3wuUUGHXx9T18cYg02o
         UGN+TpJFr0M7pS8DabqCYs+gzdOO9nCNTx+ryJCvSOpIKinzo3yGU5s3b9AEoJnFaNcM
         bYikYF8xFsvjMcEvQz/RekS0qx5xODFMtCvTD+aZJ/ny0sGRKD8RC6Yx7dkG3Kb5HLzV
         dhdOOLhXCcCdtPLtoATiFEtgZ6unZXztneFgzrvXmf963D70I1Bss2n8zJfk0K/pLE8f
         uUKOR6ezCGg9rsQtxsYAahqAp+mWstPawFiR59rVBgvKYwWtPy/3TEdCVqawZ04tPLEw
         R8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778844907; x=1779449707;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yf/PRgtxZLbnp0+s5IzrvGK7cZi2mh15dVgMB+bKXAw=;
        b=CFQwPm/MPbfjzFvI1JkqFFYc3fwKMqJbMAFL4xCmiFmNHuEqh3GRPZgoO4tVCB0BK2
         WWQFlvwoB+otXx0zDhMYyFpALxGfEwXyN26YsO9IBw7w3+dakAkLcBRGiFcCf6+95ejq
         ne8Usfi2OkJPDoi2k0WpFknbBaAxJJaViR4wyD9AGTKn4Is8bf2IEKfHyItg/kxTgQx9
         QuoWivXuJyrSvRDnoCNmlJBsShKEIs8n/m/rtNM7roQOnMnGmBMULJfJLiUW4I0fa2L8
         6QTLK1xvd5w3Rc4gnGHX/ZtyTgym70Sw9gM5mFKZi9YOev6P8JLIAKerrNZZAh6BN7bT
         vE5A==
X-Forwarded-Encrypted: i=1; AFNElJ93Nysd6WAExA/CodU/9YQPk8BBmnnSpTfb8X9iKEdk6hK3gTb1oq+tRkTwtsi//mq4RxCc+E1i2MRdWh0=@vger.kernel.org
X-Gm-Message-State: AOJu0YywOmrQiTBwMfotnUsX9JakYaQ1TbX9l2D06AWrg5qBvtcobD9W
	4CGHT+Mw2QV52BvaTa6du3IayHvclFo9Xh3pNcrCPp02be03u2CI5P2s6g9au0rmiqIHUrPtJHU
	AFAmd41RZm/YDe4kIBW/JsGBGH9/qcPm2qs7lCAXN7VBb7gLKcx4jWqZZqfEAHKeh8IA=
X-Gm-Gg: Acq92OFCkGZTQE7nQGk02OvUSRP8zKuSSW3OHwEyuQE/9Lv9rMzqqzVl5x2qV87qhY8
	1Cqy5Ogb1xMpKEBvP9qChEFj9DpG09ituDwJOYwRzUAKPNE77f+9YwJjnau2jG2RxCrGd2IBAaw
	DHJ8HQrJBtAN6lj+dJzqpvxAtUMCb25osTb+IVq6kjLibFGZMpKF8ndN7cwwwRlZVWbxuAKmbMA
	vb/wKap3rqmHo2grtLqBkK8FN6MgSnzzYUMw4bc5UHU2s7vHNvuTWctjJIJB7gYbyiHw8mFiXUU
	jPFzNhMnTZtrQsxwpsVVw3kUz2/3ibLIbagQwFvirtnT+pU/SzwO2KJB3yP1KFIVSwuVYT5rIUV
	D/6qNuna/1/hQs1UpbyqJekEMFxLmilJpPZqMQc/abNhBq0jSAVV2rNnVa1WQvoJVtTpGystthS
	KrJH64
X-Received: by 2002:a05:7301:400a:b0:2ea:ea7:480e with SMTP id 5a478bee46e88-303979815cbmr1450772eec.10.1778844906932;
        Fri, 15 May 2026 04:35:06 -0700 (PDT)
X-Received: by 2002:a05:7301:400a:b0:2ea:ea7:480e with SMTP id 5a478bee46e88-303979815cbmr1450757eec.10.1778844906404;
        Fri, 15 May 2026 04:35:06 -0700 (PDT)
Received: from [10.110.108.188] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30296dcc464sm6948503eec.14.2026.05.15.04.35.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 04:35:05 -0700 (PDT)
Message-ID: <05799dd6-e2db-4756-b532-2220874c6d64@oss.qualcomm.com>
Date: Fri, 15 May 2026 19:35:01 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] soc: qcom: ice: Enable firmware managed resource
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com>
 <20260514-provocative-golden-woodpecker-b3e494@quoll>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <20260514-provocative-golden-woodpecker-b3e494@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: VXCnUT1EPm5ZEUhShXyvx1xs1ddWj_ud
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDExNiBTYWx0ZWRfX8KWMgOJ0wCDf
 K9z/TeXvrhlxXLNF75rDQ3jby9aPARa2wMAjLAttqw/VXXGiIPF3kHV68zZkIeuTvcZaejOPlRo
 /tqcNejukGpCcwot9vzR58RnmqhEYGOxrp2ek8wpLLxaxc6LYkfdWsIRDNlvYAu+3rsKZrqvnRy
 zmnY2XC4tHDOnlqQi99gwrbKGt06BhtB8BplNtIOLPRlyjB34P2g8FxyezwyYZzt3I4HhI1jDnw
 3iGS1wLg4etNqVJwLMCK183BeElKcxVulC3+bWMqhAQppqX8+cXlPST4HvOZhtXcK9BkTwg5dkW
 bX7EUBkhkZjTV7Qm8B+LqRYCcwk54wnKKoyIvBnlN1fscIZTWRcwh92/QCTuPgeNZEQQP3ym8Ue
 gcU36zyFqkO2fb2HurwZSVo3mePhtufjOFP3YCxXC0OO5TMlqqZAJVdMme+3kMUNINmVDkPE7h0
 SoMcm6+AoLIiRS1iLpw==
X-Proofpoint-ORIG-GUID: VXCnUT1EPm5ZEUhShXyvx1xs1ddWj_ud
X-Authority-Analysis: v=2.4 cv=JPELdcKb c=1 sm=1 tr=0 ts=6a0704eb cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=LxNlghVGCEmHBxfPrBcA:9 a=QEXdDO2ut3YA:10
 a=s5zKW874KtQA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_02,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605150116



On 5/14/2026 8:52 PM, Krzysztof Kozlowski wrote:
> On Mon, May 11, 2026 at 08:37:47PM -0700, Linlin Zhang wrote:
>> From: linlzhan <linlzhan@qti.qualcomm.com>
>>
>> The Qualcomm automotive SA8255p SoC relies on firmware to configure
>> platform resources, including clocks, interconnects and TLMM (GPIOs).
>> These resources are controlled by the driver via SCMI power and
>> performance protocols.
>>
>> The SCMI power protocol is used to enable and disable platform
>> resources, including clocks, interconnect paths, and TLMM, by mapping
>> resource state transitions to the runtime PM framework?s
>> resume/suspend callbacks.
>>
>> In this design, the ICE driver acts as an SCMI client, with clocks and
>> power domains abstracted and controlled by the SCMI server in firmware.
>> This implementation depends on pm_runtime_resume_and_get() and
>> pm_runtime_put_sync(), which are available in the OPP tree?s
>> linux-next branch.
>>
>> v2:
>> -- rebase the patchset
>> -- update to/cc lists
>> -- Link to v1: https://lore.kernel.org/all/20260430032136.3058773-1-linlin.zhang@oss.qualcomm.com/
>>
>> -- To Linux Community
>>
>> v6:
>> - Protect calling clock API with fw_managed flag in ICE runtime OPS callbacks.
>> - Link to v5: http://shc-kerarch-hyd:8080/kernel_archive/20260324095703.1306437-1-linlin.zhang@oss.qualcomm.com/T/#t
> 
> Please do not include non-working links in public postings.

Thanks for your comment!

I'll remove them in next patch

> 
> Best regards,
> Krzysztof
> 

