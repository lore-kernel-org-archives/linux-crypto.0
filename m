Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C943E3C5E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774348744; cv=none; b=hX32PqSvckWLysjbBBNJdexepd6YWna5DpCEyIaG7MG6eI9of6IboU3vatU+c0C43HgF+2Hg2mVNHbfnb8J9d5I21uNzV+RbKtDyPiO7YlOWsqW+604gF6NTw4hKyadul7z0dzuhgNurZGi8bU7qGaCinuO8lRbaUQ/OGv0iXjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774348744; c=relaxed/simple;
	bh=ji4Q4buCdBt/nwjhvDAVS5p5y2cqvZ0ye4owGzsxLNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oj0I0vV709i5DCwtVVQE2mSrO2Fg175TKBMkzthHMlL2eWR72qYFxr+dZ1oFYc0DYhc3+gzYOewsV294wNlLsbKpbu/tIKCV+R+p57Q43MAyDV6brADwLdn/77cw0fuVZzMvgUfvJchtkBLZD0Eq58+jQ6gFVWsmy/wWtAYI1vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=R2cu2WVj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=X+j5YDmI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="R2cu2WVj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="X+j5YDmI"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O6XhdV409241
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:39:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2Pmh8hicjiF4UT4+vCZbMqrok0SPFJ1WtADq/O2gJng=; b=R2cu2WVjlP+Du0Nt
	ros+fY+qR8U+RzBh48yb0XWOgahE5pIcU/cs3QuM6dLyVTyVCrsIXe2Z/ytj9utO
	m/NIfyJS1e1W+DgUFxUPAEC4NH1K9nuQgZiAkNdMjYkPoNZMeJ6VdfXx9e56JWfC
	HiFsMQmYdA1HGwmGP+5lAZHbxy0zx0bZoUFHYckNnZmkvqrhfsNAVs4tdAnjExMo
	j0ltUtb5ljiwmFV2+XRliThNOC7hNMmC3SUeHg3L4w6CewB6jhqHsJcRG6mwFzGU
	6y5rPmaXGzw99D28IWEoxLYFXwQhxTeAf881z1qBdnnLAuamlAHIf4mh6G3Nm1vT
	uUawZQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d3nexrvvc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:38:59 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c7651644975so778613a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 03:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774348739; x=1774953539; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Pmh8hicjiF4UT4+vCZbMqrok0SPFJ1WtADq/O2gJng=;
        b=X+j5YDmIvKQrxxOu8zwNG8BZOpMa7GhKbI02n+mpMFScNCjuP/Y2NQb/zPPblkpQli
         yE2RC2BWX0+OCwKtCHy2gQXpO0aicKHP+UyqI2G1LwLK5ET2JRpLS1p+XBtVqdQsBIMo
         DR4VC3Hssds8b4rqJEEIOoGhht3ZL8lGnCMX6BHCDLSAeTTkDOFUcfclGL5SxKuvA9tH
         17p2tvhzU6hEM57hje+26OuUAUyGLwYvJVyVeBRhR2u9GHFnHp8HgnWlEyod13TRLa7G
         pUj7X5ZcKNLqh4DgmiLMboPCKceCYguiNigkZLJwUywjASNNtABbM1es+p//4PE6X8xQ
         SWjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774348739; x=1774953539;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Pmh8hicjiF4UT4+vCZbMqrok0SPFJ1WtADq/O2gJng=;
        b=OGM5ITWXc7Q/fs0EI1KFOnEQgwettYaUSwxkAgjo+g0iq5HfiqR2bGpHTNlFi2fJbb
         QKB7n0901ws52wpdaRoLgkJ3qrcRHOAcd3kY643CR2AdSvY+IHdcB8lzJdwPvQjMyw+r
         cgEEAhUyFUUs5pPdQeubDSuGuHCg0EHizB8iasuRTdvf+1s8qTu1p7UH2oiAnTnTxkQ0
         nAsQkU3Vh8ocVVs8oAN4xoT1DFEObpEXAc1yJq0n59HWfRvsdbsj3Rfikw300abwVr/i
         PQRiBS610OOuhq5J1y5Wq5a2SFqj3/aODqqL4NmORH1HA5EcV8+nDrxWluPFRuGhnzxF
         1ZSQ==
X-Forwarded-Encrypted: i=1; AJvYcCURaVVCXrfYHZBaLa5m5dzYdx0kuqSKi6WVH6KsjegyZlQOAcj9PTit5b6yktRIOm+PZpGC5HHq84GHQqc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBMqoVjSHZ5Ct8mjyUIkL3ae03YY5e7Qv+n7dphpTa7YW9z2wk
	35WAyMZLgQQ/EKbekA1LRTkJ3m13Li2oHT9Apj/F7eRG+m7sd7A1bRLHWDAN7JQUQblyqqE2YDB
	gdiX4a7JWhXqgriwyccxp4qf7A3pCYS93KcQ821Ehi9UyaQkKSBJKPV8+N3L0/2mnwc0=
X-Gm-Gg: ATEYQzzW7eXlY4CdjfjnJ4C95Cc6CO2N3WEP9O1i2h2esVtXy4VejRs8KTo5rcF7Cv9
	HVFzgkhgW0FUJqlQ66epPiwEfd+QI8cT9eg13W/ECs8P/LWgm8PMkGVv4wO/RaklhEQzvepUf1s
	KW4WpYpH7UVJrR2eJGQ9Vs8NlMqQQDaXVObTiDnRozpjp7eW3m9ooJkaqV1KjQgpLr4o5xUKd5O
	Nq6hqfWRmEuw/nekfCoTenTswqt4MBCpsha5CrQHUvXjndTLmYApAN3Von0ivQA/glvHaZ1OaMF
	FOHK/yEzQ6JB5RjflfxhZeYXNTPrSlhxAoMFKtTKa1ACLzqW93SffClI3jC3ATC47ycZmaEz2v1
	0835rNDZfR+MIUMeeqvsd9t/gMT+efE/TNd0nKdxDFsq3MiCrQs8p
X-Received: by 2002:a05:6a00:1789:b0:81d:dd3a:b8f5 with SMTP id d2e1a72fcca58-82a8c35dcc8mr13802702b3a.38.1774348738948;
        Tue, 24 Mar 2026 03:38:58 -0700 (PDT)
X-Received: by 2002:a05:6a00:1789:b0:81d:dd3a:b8f5 with SMTP id d2e1a72fcca58-82a8c35dcc8mr13802670b3a.38.1774348738405;
        Tue, 24 Mar 2026 03:38:58 -0700 (PDT)
Received: from [10.218.44.178] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b040da3easm11603694b3a.41.2026.03.24.03.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 03:38:57 -0700 (PDT)
Message-ID: <e949be15-5d9e-4f17-a970-f8906dcc5744@oss.qualcomm.com>
Date: Tue, 24 Mar 2026 16:08:48 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/11] arm64: dts: qcom: sm8450: Add power-domain and
 iface clk for ice node
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
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>,
        Alexander Koskovich <akoskovich@pm.me>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
 <20260323-qcom_ice_power_and_clk_vote-v4-8-e36044bbdfe9@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-8-e36044bbdfe9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA4NCBTYWx0ZWRfX8TjxrE5EjAHA
 Qv4T/jyh2w5pSF7tGwM2Jq+/LsosQ71IU0/Qz4Ujhn2dZy6i/rFLm6nEZaLomVWQtTBmfwEeXIc
 tvlmAfrKE+rrAvck6yrS4whQ7oorv7M7Vc+CUaw+Exj9x+XurEdk2UMW4sRxBqixcjYwxvtiWY/
 hqzyyWwLda5v4Przo5K54e5rmT+kh5MoOPctbe53Fov1OyBKrE8ULKO+ow/S+MO/ewmY4lk+3+U
 NzMAoveak+So6x6JkE4tezEHm4ep4swmlzMsKYaNBnDOVwEjnRIxENCEKpyYwc7IkSSkxvTIdGN
 vvSk2TVvSNhGDypCrsqgpoZIdrCDM/bmQudDvQhE9U9vaWeWw0eM9QEGMStX6HdrHmq/qtb951i
 XU2He5RmZskZcO8XISCDHRszZ9ABOzo/U5XTh+57PWMy+WBehrGXOhzOT9G8/Y9jLKpYcgKTEZ9
 AR7gSX33MAf2VPmSlew==
X-Proofpoint-GUID: h0d_Eb-PwO8QINTiThh566ymGeKiXRVp
X-Proofpoint-ORIG-GUID: h0d_Eb-PwO8QINTiThh566ymGeKiXRVp
X-Authority-Analysis: v=2.4 cv=Bd/VE7t2 c=1 sm=1 tr=0 ts=69c269c3 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=RcdfdvLsBkETvr5PKcUA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603240084



On 3/23/2026 2:48 PM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the UFS_PHY_GDSC power domain is enabled. Specify both the
> UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8450.
> 
> Fixes: 86b0aef435851 ("arm64: dts: qcom: sm8450: Use standalone ICE node for UFS")
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

