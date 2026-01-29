Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C553876B5
	for <linux-crypto@vger.kernel.org>; Thu, 29 Jan 2026 12:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769689082; cv=none; b=ryb+oGhMzMSQuxoB7FREtlZmGnXChXOR12bkqp/WafjtO4dDU4DTCFrZVFuauruYO99beoCdr3sVCc8CHKzy4Qm1qb61v/CHRTnhxMBFH3VIo752am4gPKlRPCpJ7yp7aKTUjojAVp+eVyXc3OWY7UWzw6GP1QOsoAKFBErpHXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769689082; c=relaxed/simple;
	bh=7G2vAEHNegfOtPP4Ox8PcGDR2+nERnG0SVVl7JqceYQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RiESGxA4pwIFQgOEKQGjOF9VvBrp6DhSyIXeQ84NtDQPC82fu6KFK2lyrGzLnsOj97XwG9CKRXhyVOKTChndD31rM0ZJJKFYF3JIGaBpQzZHWP8UpRoCojOpqnmtAEexII8ZFEA4mVOtP8Ty8DBsnavo4O02aJRnpJ6zXs6kzIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LsTVVIj1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZXFyN9qJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LsTVVIj1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZXFyN9qJ"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60TAN8D42034129
	for <linux-crypto@vger.kernel.org>; Thu, 29 Jan 2026 12:17:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FcrwN2wnlNsCPb8qZU41GPI4nI5ZkjV4GQKGB3maAUU=; b=LsTVVIj1PPZjodkk
	FzATDHzgchsILT5pTnWw+S3WwzG++XE4y01Jn9CugZTGE66vc3qYVXQnDpr6JIxJ
	5N1BkRcLeDQWje7A78/HUZDVLBYLWH0DeG05FmqWylhhMivXQPyUnW//tWlXmi1w
	jzHhv6UEhEBblfmAIO2Pxx/Ku1c+VJjmJcfCUjIMATgQSEjE4QViRVUsdEw1KGma
	Dkf5wbTwXiAdbvwfY9rytvPrF/uN9ThvBTeKhboNR9FT+tTidJ4mlTdNda82dvzY
	UtDQIgoqFx7PCTZEnAAwWfgaYUXKkx32Nd0JqHG9UlSh2g1J5KG/9V0Mj0BEPqXS
	ksbGBQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4byna7kj8p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 29 Jan 2026 12:17:57 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8b2fdf3a190so14983485a.0
        for <linux-crypto@vger.kernel.org>; Thu, 29 Jan 2026 04:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769689077; x=1770293877; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FcrwN2wnlNsCPb8qZU41GPI4nI5ZkjV4GQKGB3maAUU=;
        b=ZXFyN9qJ3GY2MUcQfhGYxP1CAAWB4eW3Jhho8DfRSHklzxiQLsdgUQhH3Ls/pN4o39
         JfphziZGOk8TEFsG7wTWC+GZc4qQ3bf/spGxTQXjuxLnHfeUhOeY/M8Vzj8qV6OjP20U
         I1wOo6yOpbx0OZLFcb3+UZFoR4VMZd6ochJ/9kzGEkFWnJgmlr80uLWh2MVZnfX65oBw
         0p+sNzGWvxK0XjFOj6pCWg1pvuUnkTdvCLswePlvmulM8cHdtR4ORw/Fvy8hzCyOtx/h
         m42ANmGcawhoq0ljPwoRp8Z18nTGr72ZYGgHWgg3IcH16nzGUFu7XPT2RsT9GJljxUMn
         borw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769689077; x=1770293877;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FcrwN2wnlNsCPb8qZU41GPI4nI5ZkjV4GQKGB3maAUU=;
        b=kniqJOjoDB41mkzyOJ4bNIR0QwAvhs5m/mV6earnGWZhEdMnpG8QS5G0+PIo8m1iMS
         11+ID/jZukceF302EKpSWiA2t0uzLJRVmRldeZTljGAGtwgSLJO6AB2U6SzwI/zriZhJ
         SDheDy5gRDMy0669JiZ58weEfhHU0Ja3gHgD4/aPPxSwheXpNXRrh8O3djinA5rZwB9d
         e/sFuiU0zBEgXvr8HWs1wRh2EnZPRCz8chlumbpwgwpyuCobNGz8cro0TRCUjXSRP11/
         Mi+j6Mwo/dgARyjUQA5r5NFgRusvufKER4KwiaTh+RRHM9PEsYj24Hj+ZiutkCipoD6s
         LDaw==
X-Forwarded-Encrypted: i=1; AJvYcCVohC1DCqdwz7RrQ4UTDMbTM2lrgFS0NPSxcpQIQ/bqJQ0LZG1F9MeYiNLrtUgbFuhVQr216v+Y1oTOzPM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3HcjVyQQEAnWA2/T4j72BNTPK7F7yxd/OllYnRnTDg5j1r4qV
	yLQGiAN4E09+mhyiOWDc83hB5Dh7ceaAPia5EsxsGx04ySVKrLlA44ErWUtCQKrfyAZ2qzblYP8
	UnX8zxT9EUQm1mwM600i2AGjqirEKbd5V/PgKooMJXS4rnDwh4sZnnFvi2XLAv+gOykM=
X-Gm-Gg: AZuq6aJCZsAfRVET1bAsFNj7VlymKC2DDj0V7dHN7o1tEVkgkAFXvc5hbtJ1Yalz+Zd
	a7IzCRm/au1fFAG0qqW0UskUyJZOpuMDTvV84s3dNnYZQAeez/erC8/jvDrVc+icuGa4WC4Gut8
	sQcmbJWRL7MzKdxDVutq0I1rdB6EmTOx79LEgwQiaf7LstvMSALeDzonVE/at+v54FGL4EXEdKF
	jE3B0nIfOoWRtjzzVT9TdgW6tFW8ZvMFiJg4ntwqdcaRDXmbGD2HGI2RRYIZ7VrO8b6jyrTKQpA
	nSZuSACCznbsOxwxA3YhwjQ0MgiLOYVvpuTGfYk6mEMQoWoTJsbS+bA0TLRHoyRjxdk0b7aJk/A
	9rqeOsCq8JYD8SJ/4Oe3FRoNTWUCAu+RnGHQH/4PApEfFeCaK/Oy91mMCU7CNZaq0VeA=
X-Received: by 2002:a05:620a:bc5:b0:7e6:9e2b:6140 with SMTP id af79cd13be357-8c71ade7be3mr352929385a.8.1769689076964;
        Thu, 29 Jan 2026 04:17:56 -0800 (PST)
X-Received: by 2002:a05:620a:bc5:b0:7e6:9e2b:6140 with SMTP id af79cd13be357-8c71ade7be3mr352926785a.8.1769689076547;
        Thu, 29 Jan 2026 04:17:56 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b46abea5sm2831410a12.31.2026.01.29.04.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 04:17:55 -0800 (PST)
Message-ID: <7b219a50-6971-4a0c-a465-418f8abd5556@oss.qualcomm.com>
Date: Thu, 29 Jan 2026 13:17:51 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] Enable ICE clock scaling
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: -LsSULv-LVduUVzNfW4X8SctB-yeV27D
X-Authority-Analysis: v=2.4 cv=J72nLQnS c=1 sm=1 tr=0 ts=697b4ff5 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=4MEm5NcWsPKhGJVxAVQA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: -LsSULv-LVduUVzNfW4X8SctB-yeV27D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA4MyBTYWx0ZWRfX6G5VVD0t8Avm
 kRbxnA0AIn2XDhkhheU9gBYNNOcoTt7snTTE1pdmrSd55v+jjxzOvutUyf9xJpvg3FogLZsWSn8
 ZeSJ4PKUseX/+oFuGapVbwT/k4m4aXDD745omOsng+elVCNetAqPLoDgEu6N2BCPLc6zMAuIvpM
 7d5wppDnYzAACaNdFjdK5ikfKU5vls0Dqk6mPIx58K3U1OJa61IJ9fJvlh589a1o8OKJnESoebE
 VcN47ar9rKjhk+77wQI6TOLZwnM4pWiIC4fEqa28LKAaP0MFkcWC0xfiykK/cWHG5+yaAvUTivG
 FCtwZ9+yhcFzXsgxRrSovNnqyj/n5AhVMk8oGMPcQBCT7HwY5v1mjhbfHoZtmwYZMhgowej6rRx
 Is4HoGL895gIOIL89k771xh1O6b3uPwUNx4YcUw0+0IRn7y3bpA1Ur/8af4VVzjmamo1cMsxNZd
 RDw8wojTAJwYkN7iShg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601290083

On 1/28/26 9:46 AM, Abhinaba Rakshit wrote:
> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
> using the OPP framework. During ICE device probe, the driver now attempts to
> parse an optional OPP table from the ICE-specific device tree node to
> determine minimum and maximum supported frequencies for DVFS-aware operations.
> API qcom_ice_scale_clk is exposed by ICE driver and is invoked by UFS host
> controller driver in response to clock scaling requests, ensuring coordination
> between ICE and host controller.
> 
> For MMC controllers that do not support clock scaling, the ICE clock frequency
> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
> consistent operation.

You skipped that bit, so I had to do a little digging..

This paragraph sounds scary on the surface, as leaving a TURBO vote hanging
would absolutely wreck the power/thermal profile of a running device,
however sdhci-msm's autosuspend functions quiesce the ICE by calling
qcom_ice_suspend()

I think you're missing a dev_pm_opp_set(dev, NULL) or so in that function
and a mirrored restore in _resume

Konrad

