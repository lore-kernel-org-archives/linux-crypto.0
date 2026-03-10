Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29C838B13D
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773151938; cv=none; b=FpPOTza0NinTMwkiViT231rc4MvLV8ykRMLD+c3R4X+S5+84cEDIqwInRxp+9zXql/uNGsz9WAcPnzS16GU6+W6An5nqmvJymaBIURGEwrEk0fNiVSn8kQG8L0YI/8DPNcrkfCWVVGu1npTOAvKK4SA0VyRHtlXxol8n96QAN0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773151938; c=relaxed/simple;
	bh=Kqn7x/CgHOCtjliiIZrKXiQ3tj99UvGsyutJ0+E83QY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XzHL4TTvtZVjIdgi3/OqqktwPkkJNEwEKSeam+gIvlYRwoAQDrWU8UP931/AX26dvNZWofRdKhVdEgUiFeDs/W4MZbSDTnjvzNYxHaJXl6mHn9p/kIjrI01EQ1gyhkVdmGoVlhIa+KyUfRdHRLvYg5BFeWnsl8YNlByHYdlcbqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f5ERCElp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HrAf7AyY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f5ERCElp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HrAf7AyY"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACavkP964619
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UwQRs3OinF0T+HUdATBj4XocoJa8DTta75lo3fnEfCI=; b=f5ERCElpANUhx4Yx
	PNpi9nXyw+Qy0AihJpCBPJcv+bB3hDg2Sufx19UYSCKYQsUEAwxGzqAThbhLr4a7
	awor7kBqH7nZ05gse4MzdNIaTiZFjyfzfqYCAbM/f0hupJmDJgPuM//n8C8ZDx/6
	H1FkDOgHrZZWNhrALaMMIXsEp6qeh6yIA5W6TOCk/q0nugL1c4MOY3YEAawhLBLZ
	a/M2s2RK2dpLX/bDVNRONlEypHCLPLq2V4BvO+CeDDKva/d4hGXtrpdNdyVuKtpl
	SGrF3xIN+QUjdSVA5ZCGej0QkdCQAf2ifSDTN+AF3rx8F+B9hpsGfBT/bhBpbUMm
	C5NbtQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ct477khg5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:16 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8cd7604c6a8so229659985a.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 07:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773151936; x=1773756736; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UwQRs3OinF0T+HUdATBj4XocoJa8DTta75lo3fnEfCI=;
        b=HrAf7AyYh4i4mBdo2qyGIDx73MwjDnSqDr6iOaFU5m6x9eEWzrDcCgpoAySVbAtp5K
         w49qUYjiGT4AaVza5O03Qq2/KFbYa8bCQ2wyinw5+KdkQKf1XTEr9YdCWdSBVhiQ8VRG
         Pko+BcnvVe1EELM4K7EvbzVEXWZ5xaLV1oLjYNqfBMQxp15TSOvTEXVTeqcNJXcwBHgo
         o8n9j+I64FvPRALRwopJ2iLIyTxPJBEd0pBM1R6nMt6erRrw0ZndkYi6Jt+dNMb3LoRv
         K5j20kaJCNaPEMXAhePNiS2p41pUKhuiS15drbXvR8fHZZEk2z2bRGOLUlL1Iaqa37Bu
         wtUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773151936; x=1773756736;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UwQRs3OinF0T+HUdATBj4XocoJa8DTta75lo3fnEfCI=;
        b=pkljpYk3OxHXBcqXVwDVRHgFBOfO54dd9tGO5+8fkaYFlZ5POYl8UXPKJEuZJytBHN
         F7IgaaGGrdYjZmTiWEA+rUTWEpuh34r1yrn9n3hR0nyqgeF6zQcmrJ961xjntnPd0Wro
         vyXUN6ZGhNjuP6apSGxefQyhC49jo8RXwYeCJ9DcS1ym0zY/fEf1+fsh38ExKGPYmCyW
         /RbcQ3j6miD1BUJ6fLQ94ZMZDgttN5qFDiRVSYlQykd4Zz1ym3R/q54Pa9LSShh71idn
         vrrTTFN55+J4ApTRJ3P5R2NEdNkG48bTRDwqCKvLJDCDUzmfWV83sg8pNGY0iqmalarJ
         uTMg==
X-Forwarded-Encrypted: i=1; AJvYcCUUnFcp7bwSemRP3sJPkgXAlZn+bjBJBFyhoCU9XYNCavzsl0hlHOJgoiSbj7ijW62cxrByptxGQRnMGfI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPksXZW/KVYaL3H1ISnYPi1CSjwk2uA+lMS+I+hHEEtMIcIStt
	BRJe0QbOJhdIKcs5bIRMDHhcxzUIWspjAc5KUgFdxJf+TODoFJ0r04xZSOBAAF/aPUv6EzRVz3E
	Dc16hX789guL1c1N+IWQW8deDRDmKsU0fJQwa/GrV8I6wq0BsK8ft7ZblfJFbxRScwtg=
X-Gm-Gg: ATEYQzzJuuKoK38565qMHPFtxpK8nsyoKhQKm4VMM4KmvDaX06cRK0k45eLv7f6U6PX
	nRxv8hH44k5M1Y9DCYrjAxBYtqx1mZ72i0II3kuk+Gz0GfyETsJ1DCSakN0PmkjLsROzQBEsA9s
	OHoYSwyEVQMJ79pYfTSBARoSGESJWeTenzorzIuv6uWvnf429cxhTLznN2PLz8FTa4P9o3flwfd
	wnL0UjER+PSZZ6qoF+XtuBmcBGVsKipjalVqqtTNxcGMmPSQx0aiicDd2TWCVq00YIAcC/NHol5
	q5JMX4W4jmm7D0k0sJwZnTXK4k+oKza61p34VXah33ExHbR2zOfVtjD//MhRLwwQU7sucoHOjsK
	htZPYy5qops7FOoXWWh5QXtqd39a5WAKLL+5JhvfOwp5OPIcrVDP0LnAxHYZ8uegodEkZPjHAMa
	q5Y74=
X-Received: by 2002:a05:620a:4711:b0:8b9:fa81:5282 with SMTP id af79cd13be357-8cd6d374b89mr1582349885a.3.1773151935938;
        Tue, 10 Mar 2026 07:12:15 -0700 (PDT)
X-Received: by 2002:a05:620a:4711:b0:8b9:fa81:5282 with SMTP id af79cd13be357-8cd6d374b89mr1582346485a.3.1773151935466;
        Tue, 10 Mar 2026 07:12:15 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-662a07022ebsm1512263a12.3.2026.03.10.07.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 07:12:14 -0700 (PDT)
Message-ID: <4cb2dacf-801c-40db-b5d1-ee99d083fc90@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 15:12:10 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/11] arm64: dts: qcom: kaanapali: Add power-domain
 and iface clk for ice node
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org,
        Eric Biggers <ebiggers@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Yuvaraj Ranganathan <quic_yrangana@quicinc.com>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>
References: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
 <20260310-qcom_ice_power_and_clk_vote-v2-2-b9c2a5471d9e@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-2-b9c2a5471d9e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEyMyBTYWx0ZWRfX9UplX3pCs34I
 tK5fonb29BwyZEQoZiakgpAnWgVKV3LlIYJ0wDz8Oo4984urM3uidwTUKE3TiR5lIz3/VNzv+Kz
 McakK3aNmP5MrKwuW7qHDvkhBq0sry2sZm9/Gxeaf9j588x6MTCF7kdV1rDqq/3dbPmxDTuA08/
 7NUaP4cEZoiGfb/VftW4U0ehjtKyTI0rRQPsa4iploWHsruhmP39UMJeaQztZEOfhMEzSGD81qf
 vMBgTOJ2NPG2EyQ9NsYFxRzaCafzoNUaW5r+LfUEvQZsNr4hKu8OW7dGafXNIcWavojMc7QZVRV
 tz4D1LUi66IF3U+QDywc5W1YFwh9i19eK3eJQuS68wiExTpHy+HDG1oaZh6Rrxv/q0uM98ScQIa
 2xz/rruEnY+LFR6icJBR7wriBB+VY8I6sOrIpfTrLJ1OeZ4nqu+ZsVTz2SJts6YAmoOEFwqan0V
 ZcAbl7PhqeejXDBe+fg==
X-Proofpoint-GUID: -GlE4jjnT78yLwse9RrFmSZqxmwYyocd
X-Authority-Analysis: v=2.4 cv=KLxXzVFo c=1 sm=1 tr=0 ts=69b026c0 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=z_dnvKGLtVwtNw_c-ccA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: -GlE4jjnT78yLwse9RrFmSZqxmwYyocd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100123

On 3/10/26 9:06 AM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
> GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
> kaanapali.
> 
> Fixes: 2eeb5767d53f4 ("arm64: dts: qcom: Introduce Kaanapali SoC")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
