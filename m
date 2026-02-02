Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C21036A01C
	for <linux-crypto@vger.kernel.org>; Mon,  2 Feb 2026 15:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770044513; cv=none; b=M0GIpLTv/HD+0G3m9MfzrCfmjahGycn+vkteaSlhzRLfQ38eXBWXxH+rm7/pLFyp1LVplkew+kCoZ1cRLRpjR2ZvnnZGeMw5BsdN1s3Rwz93VEZoKHx0K/BjHT5EwPLVZKQJRVpj7+2D59fgM2FrTlADGFtE1eRXBOEobak0bGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770044513; c=relaxed/simple;
	bh=JcxIl+U6XrrYzwzysRKriC7B7jJmpe/ag7DnsCLo6KY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=onlbbbt2TPimUlwpc0OyziYwp0kcK5pjRA2YlOGBO7d2hl7CkUq0U1xK+phVFLllNtrYR+K8kXs1kp9ds2yZgSetvMbZi4ca9ajKFRES37B/Xwrhx3AeWaAguykavFQHISH4/yzNoHqBl0sjFQq+Al5Xxv0G7btPqS3sLM8GiyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GtaZJJNF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RznY4r02; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GtaZJJNF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RznY4r02"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 612B0MH22899912
	for <linux-crypto@vger.kernel.org>; Mon, 2 Feb 2026 15:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	b7LkWBSg9k/hqZXrb855SBQlwZa3bPE252WnYqjGZpc=; b=GtaZJJNFInkB0nDH
	54tU49dyHv+VRHJZVBVJMVqJVvxuHoy1ovO4QvYQfZfGdsGfExvWo28Un/bDUCk5
	VKxVX2OW1YQnzWUG9zpQkzbVrouNacirwHDWVQItC3VXh46cmsOlYkcgvPKDkcut
	5fjMcnaME0scGguzeWG3lvQdQsudjNlzePnArMMwXC4ux0kXQKS5WPZoF2S64/iT
	fk/2FcJZ6/Y6ZQZiUqttHbdeyQeXljEK2HBkEPtbjVxMLv4Qg5uGQEOeBJ4a93Vz
	pSsuSXAlg6LQYi4O8n+B1BwjGjUKv/X8dxuXJfgZwprHwaJ7P23ycrkSogrria07
	h6XDMA==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c2tp0rn1j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Feb 2026 15:01:49 +0000 (GMT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7cfdf8a0722so1287747a34.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Feb 2026 07:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770044509; x=1770649309; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b7LkWBSg9k/hqZXrb855SBQlwZa3bPE252WnYqjGZpc=;
        b=RznY4r02+TAfH9MvS8iRQsXjY4qC6RMV8A+d9ueJAfo1SSOWdF8TArs0EtyCvU4Ywc
         RKLEnfc+nWPM30a/p9wYC95VeVoOB68xc4xixtpmac6GySnszd374Zo88w1gTU33T0Qf
         EWjoShk4MZA+zyqMqeAW+CY06Nwab+OCyuNhJ13f4iqgF9ZLMYN52pGl9R+CGV7iAogQ
         PuT/ZfcQrzYhl5sg/v/xtwfBWMiv5dOX9LpdrB0CwECUR0dMHlHFBZxVt0PKnysO9M7j
         WIgAQZ8E7XhdYKGeDZ95sDTPLMMmJ3YIkbipeXw6urgMohIm0BoH7byr9jtWttv3S760
         BWog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770044509; x=1770649309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b7LkWBSg9k/hqZXrb855SBQlwZa3bPE252WnYqjGZpc=;
        b=Lo1kKUqmrG3OBW/yj33NXc9n1Kz2OFdNylkZFuklmvcuAaCWaipT3hQ0o8yd3NZKVx
         A5uRhZ8p3/RXNYHbvx/bbOIs/8MtutbTcKdp9sAFpyV7cgIQthdJelZIgPNliERLPcBh
         qP/O8tHFoHLL9yDYr//v/ySgFpauu1bHfQR4of2+iVJ8CztINFwDgGoEdpXiodyuX1+T
         l8mkx4KC/JklZVGl/25nTqfuNxKwMSSLYiDYkFZ5FJu8xXGFFnMtc6hfTapmOX1VFS1B
         3zpfVMttXxrVXoGlMsJCDcnrTKdu9GoNePK1Kw7dvDOxFTuSkRdIJxV4AYkpT0/xsyqF
         YWTg==
X-Forwarded-Encrypted: i=1; AJvYcCWHCHVsqztJMUkMXkiBm2DInXBIenGYWsrhAZehrY0V2zFiwZfijJC8W3NwauzTGWSINE2q5+dksgA38W4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNB4rcCZX+Mjz6ocf1x2NQHIKR+/HNJgTgQ3+RHWn2egP1I+wc
	CSrdqFaDzWLXTFmg31vQ4wZHZjTIMIYSo5U/EG5chSGryiK/MNWcsUvw7TIB0a1IPWWLBlLAsEM
	zeCClyzuk4rqcfepgRiQ4th/nkT/OoSEmGUprvdU7V8e/+kFsXKlxDHPMi6xLZU8PHx4=
X-Gm-Gg: AZuq6aL8ddf2AZBpWuVJaLwks+bB+LXJAeeLEqxH2W8KP8vGnpiytozzkqagbLDd/4N
	EZe/u/CgF6Fcivhe987eO119FXuAEUJcui9MSGxAdeKVteCvQOlaiQSEWqq3BVKDJQKEH4G0HIp
	BO4wbfvDJ4DDe6+7sGhRPX8ydGudlsARI3klE4SPBggb6Nu4E3dtNVkOdBRdDoTdaiBHcYVNjI7
	K42neWCKpZAcHtaTxxtnmoF22I41VRvwSOaQuS148rrlfFe9J9qs6Sotr7+o6DHwWOisLW0y4IR
	QfASRbyDz8HmcVuNmuhTxvKBmtaue9GIQ/WHp+btrHu5YRuFVwbkRY1jNjLRS/UYnu+iwgCQIK8
	NLNKTOVIxuCkme0Mx6ioULjiOHh9pb3NkkajHXhIgVJF737jcGj5teUEtlIn6Ze0hn00=
X-Received: by 2002:a05:6830:4124:b0:7cf:e23f:5ae3 with SMTP id 46e09a7af769-7d1a525f7acmr4859565a34.1.1770044503722;
        Mon, 02 Feb 2026 07:01:43 -0800 (PST)
X-Received: by 2002:a05:6830:4124:b0:7cf:e23f:5ae3 with SMTP id 46e09a7af769-7d1a525f7acmr4859515a34.1.1770044502743;
        Mon, 02 Feb 2026 07:01:42 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbf2ecc73sm897795866b.62.2026.02.02.07.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 07:01:41 -0800 (PST)
Message-ID: <cac8e14e-63e4-462a-a505-cd64e81b2d1d@oss.qualcomm.com>
Date: Mon, 2 Feb 2026 16:01:38 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] Enable ICE clock scaling
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com>
 <aYBF3Geeuq2qHmYg@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <aYBF3Geeuq2qHmYg@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: FMRkJHA593qFxVTLTDraxIh4rOWvOioR
X-Authority-Analysis: v=2.4 cv=VJ/QXtPX c=1 sm=1 tr=0 ts=6980bc5d cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=fQ1HhNXxD7se1t-yopsA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=Z1Yy7GAxqfX1iEi80vsk:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDExOCBTYWx0ZWRfX6zrGgU6Pw0Hd
 strq/Cog/eOQ1S7vyA03Ii7NNuXeJU8UQWy1YMsrZiTayVNm011pgEpE2MZg24Bv0k2ebaa7M8o
 kOklC73UKdXw7ISJhqh3nOxcMpaJd/cKAN4YfERaiax+JqDgL/U/2VS+6EfsHyGUfBPqr4ag82T
 atWXMRvZEvSJDg+JPXJ+Llh56wt1qANAeQfKAQeuxNfIY90bAnMZI1CknrCZwWd5qExc3uEyotI
 oioAC1dYpG719OiEGKVzwRdMopNbb2Rvb+G+pViuc0Vnm9JWa7pgBHNBM1/S8dpX3CS0b57gMUj
 qa1sJqhelkNuuz83XtqgQKcB1gzuNIJ4yWhO59otHsoLDHZj5WMhLkfktB1N+rg316m1jz/Qio7
 Eea2F1aSIzqaAAMvE9ltjG/ZLMirISKlKFb6b54zFD/W4ZLl6i/Zzxl5rixBTmoA+EzO3T+TVPL
 7AgmpEndZpsp1kUrAHg==
X-Proofpoint-GUID: FMRkJHA593qFxVTLTDraxIh4rOWvOioR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_04,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602020118

On 2/2/26 7:36 AM, Abhinaba Rakshit wrote:
> On Thu, Jan 29, 2026 at 01:17:51PM +0100, Konrad Dybcio wrote:
>> On 1/28/26 9:46 AM, Abhinaba Rakshit wrote:
>>> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
>>> using the OPP framework. During ICE device probe, the driver now attempts to
>>> parse an optional OPP table from the ICE-specific device tree node to
>>> determine minimum and maximum supported frequencies for DVFS-aware operations.
>>> API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
>>> controller driver in response to clock scaling requests, ensuring coordination
>>> between ICE and host controller.
>>>
>>> For MMC controllers that do not support clock scaling, the ICE clock frequency
>>> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
>>> consistent operation.
>>
>> You skipped that bit, so I had to do a little digging..
>>
>> This paragraph sounds scary on the surface, as leaving a TURBO vote hanging
>> would absolutely wreck the power/thermal profile of a running device,
>> however sdhci-msm's autosuspend functions quiesce the ICE by calling
>> qcom_ice_suspend()
>>
>> I think you're missing a dev_pm_opp_set(dev, NULL) or so in that function
>> and a mirrored restore in _resume
> 
> Thanks for pointing this out, its an important piece which is missed.
> We can use dev_pm_opp_set_rate(dev, 0/min_freq) in _suspend and restore the

FWIW

dev_pm_opp_set_rate(0) will drop the rpmh vote altogether and NOT
disable the clock or change its rate

dev_pm_opp_set_rate(min_freq) will *lower* the rpmh vote and DO
set_rate (the clock is also left on)

Konrad

> suspended frequency in the _resume. Something similar which is used by sdhci-msm.
