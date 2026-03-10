Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05C439BFE1
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773152005; cv=none; b=bkbof1L2SFuRxXIQheW9jlXg+F0jGwWxPCeQ8pItwjUjn+7a63A1Ajrw/8URkz4J0Dht8tFFZt2UvfiVXj8QK8n+PBE/F14m+7ihP2j7ztuW29RKgdOLNdFt2XsILP0l9sjqbswUA+g4Q9770m6o9v7uRg+caiG/2jkefVARFMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773152005; c=relaxed/simple;
	bh=O4BqC7xKtyuYLJXMiicZ8E39BCLJgP0YLen4ndYdMCQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iC9Hlj35WBZNPbgamAiAIC8FpBZ3nhIQ4PsZxoTMqttvM4dI3d2L8GDRoSLrs8Xi2/3btShaQHXjuMTPuPtE6nTZFJjiCxEp41gHNTEVIFOSpHtM6jp0NCnNhhtdgQCFYMQ2UT+twHIfvgKjBXuCS7L22UU0pyZyeP+1UUBPwZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JhG9zUjC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BdxYIKp2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JhG9zUjC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BdxYIKp2"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACab2d3772063
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xKOFavLkplwLvk/5s8iEokBvnWPtbQSEsRHzYQNaJiQ=; b=JhG9zUjC+85y0Htk
	zdPQPeXFJOFkIxdUcnJqvxrDMezIid60d2AU8tdkqKXgt1Md4tujhR1g7A1Shfus
	FXkkj2zNq7p6mDx5qFZmGuUGZW2sCAzcdkVlgCiZWYyMt5XTRgUPHAXR4wnlsK7Y
	Q0m6yTot1sB0StYURmP65utj4ifluAbLK3hnKLNOzQYhM00ZIk8b8T57n7IeBmcB
	nhkXzEyYubj4cm5w9r5AJphyr/G1kkrpUSXNpi7k9mAXdIc/Tij+RvBQqe+pAzWB
	zWl0YgxEia6viOQHFhg2jbPhZ59lmAPsko7OD+t+PWkb1fcFyF9bGn50POftkwkg
	BEBt7Q==
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctfcj1ea4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:22 +0000 (GMT)
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-5ffd797184eso798748137.3
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 07:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773152002; x=1773756802; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xKOFavLkplwLvk/5s8iEokBvnWPtbQSEsRHzYQNaJiQ=;
        b=BdxYIKp2AiHmaA8kf8emIk8wAQbIWxfTe5BLRXDoZ2fr1k/zqMNNHKBNyZakONL/Sc
         +x4b9Dw8AvDH1APCTwndXExPOwBM36ql5uMtZzlGb+dnYpoyuz81TvMlpp1EiIv/nFfv
         Pjs0lqFB2vzgoua7cYacflCqAvJKx20qFNT6g7bXWCdF4ZRGAy4wVbVIPNGG3wTCQZtj
         zT5CkPIrN4KLMOzJ2UJGd6HsLaULsNtTy5RhSMwVe5aIVqDlwzW17wBAsW8rAL30rOEa
         dc5YO+rNgVrU8axbjSZOq9UeoT7V2GjyXsGmeMqKr4gRFz5HLzR/nGai38Sn9T20V+2t
         4vUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773152002; x=1773756802;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xKOFavLkplwLvk/5s8iEokBvnWPtbQSEsRHzYQNaJiQ=;
        b=kqZNlOwqvH+FTUBnP753bK7nYIXAzz2NT0FofesNUyrlKN8RUe2N4JX8vuAyI+xO/d
         +RJug5ciEJQjd/WkM4o0mAgpnm1uB9xKQrJvEzXVevsFowS4AcKNSMcaVcOx3j2KMZer
         tXFE2vlCpInbixgU1X7SuWIF3YfMEHwFpK+28/hsbMVaCy5xGR/5B86nI6f1CQCaiDje
         EFfzwV1sonjOKGw6md3152RbQ9z/abgg2+3wKxBXk2i6Jjg8AMY/uJTjalWhFEdNE29g
         /hQc5JSpb86ZwIr6zRCB6I0iG0c8/85U+CBqtMaABIw9QX46CVwiSb0YYqk4DNUBEpmE
         pmxg==
X-Forwarded-Encrypted: i=1; AJvYcCVhfPl5BpBR6PqKvpnRs12PXd+Kl7daR6v4nN94PVXCivH/dp+4GYA24BfIJOWen6V3OIC25tqbjkeL6D4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyysuIgFk8mSvW7BV+7xS/BRWujwj8HmXa2RVDnBCLJozKLjpZa
	RnbXBs7OTGC4BfIHTeRjPPA0ppH9yf5bSHFeCWvPcCbXj3llF16qBM1/lB/2KXeOnsX60zpD2hS
	q0OYDTyQqoCRyq7BYjX5u+8j7gajcdcCxQbPtP/dIenSmzqx5fDS7YgWiRu+3hx2fO90=
X-Gm-Gg: ATEYQzzFsnkJJPgrU+nsak3kh3SIAcH9HNAi9AWa5OscntrpKFUObx8cXQW+FS7lvm4
	d/UL1Uxxc+cZDgXKIpxRzxmegLYhVZEIWwT3NtDPwbb7nQLYryucBJuRUZveFPj+jVLNBngcAWv
	tfL+uRNHfXqkKK1rcpV+bTbjHKo6y6VhA1M0OJVkFfNtDQK+qWBhU6yErgFAfeeh9f+VL5HlY1u
	p80lm/LeSp7uYbBGyiVlIwS7wOzEA3n1rxvUl/3WMqQYs+XOwB1K8nS3aB5ig0cPENl8+IVv3W5
	XGqk7EIfa5wWRpKfHSdKAdqSaEiQZTE230dYWZzvA4xzJ1sTpDNrEIoi/BytSbos4Ip8OO25fuI
	CoWLT+9lC9as1Sd+Z7umaoltYYttGsPHs1cWDdcW4QUrrvq3TBLLgBOhxTgvs9Hqcb36y6UuSeg
	4//gg=
X-Received: by 2002:a05:6102:c8d:b0:5ff:2cea:c17b with SMTP id ada2fe7eead31-5ffe61e85c4mr3065735137.7.1773152002052;
        Tue, 10 Mar 2026 07:13:22 -0700 (PDT)
X-Received: by 2002:a05:6102:c8d:b0:5ff:2cea:c17b with SMTP id ada2fe7eead31-5ffe61e85c4mr3065721137.7.1773152001529;
        Tue, 10 Mar 2026 07:13:21 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b942f15d51fsm493523966b.53.2026.03.10.07.13.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 07:13:20 -0700 (PDT)
Message-ID: <983e115a-dd90-404b-bb8f-71b28b33fab6@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 15:13:18 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/11] arm64: dts: qcom: sm8750: Add power-domain and
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
 <20260310-qcom_ice_power_and_clk_vote-v2-10-b9c2a5471d9e@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-10-b9c2a5471d9e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=H7fWAuYi c=1 sm=1 tr=0 ts=69b02702 cx=c_pps
 a=P2rfLEam3zuxRRdjJWA2cw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=z_dnvKGLtVwtNw_c-ccA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=ODZdjJIeia2B_SHc_B0f:22
X-Proofpoint-GUID: yaTPSgC1egwuBkiHw93mVYrze446OeXH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEyNCBTYWx0ZWRfX4Fp+mpWR3gEc
 AkiXd6j7ZfwOT83HW3oI16iMjSA5h0RmbLHnALmO7LJWa/CyFGcptxoalziolfWFBNuPugM4u6M
 pcBLxU+KhY1RaYNxYQ9nEGWcG4Ndz7fcychSMYBhGCq2VS/SWZOVnBLDee4Xfpx25lxX6mnAjdn
 RnvHaQylm6d1KfIyqd3SUj7aVtZ+hucM6QZeQAHpoL59D92xZnUvuymD+BnrndVVWp8RusbhzK1
 jQtoimTxsJdm04Szyz+wn1eD/XNVQ9owuqFwl1E4YnrBx/hxHnsMOxwozTCksI6Q5Uz/VcY60A1
 uCz7LN9fOA0p4tJTehoOT4Q3gQcK8Wy6LP1TYPSC2geS5/0qGZV8cELLo76IJZPwBthjQ6/4VWO
 V+VhGheePLvkNjNYenPxrRCGRLm1crJo9AXB+OiiV3BF3BFBgcIC+Q3hG9iO7XKk0xwCbmYFSHZ
 j/ve1iJEu9B9UiQAulA==
X-Proofpoint-ORIG-GUID: yaTPSgC1egwuBkiHw93mVYrze446OeXH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 phishscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100124

On 3/10/26 9:06 AM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
> GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
> sm8750.
> 
> Fixes: b1dac789c650a ("arm64: dts: qcom: sm8750: Add ICE nodes")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
