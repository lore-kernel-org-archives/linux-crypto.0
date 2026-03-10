Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A33391E77
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773151948; cv=none; b=XEuhmbU7fDOKCCcstuZecQy/dm99SxQ5UkVjKZQJk5VspIXri+eCc545iITiSlN88/7Kp3ELvVk+iSXKgg60yYi/G/Tw6wVGWXdW9dknVmK+QPNlO8BP1wpLjN89U9ISPsA1VvxGEjkRnOcHp30neeV8x5PX5i+jxPmNSvhEq1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773151948; c=relaxed/simple;
	bh=2PX/oH5yfu8GCXF/56+289Sd+rY/wwgXPJOtAlblqg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AINxk1OMV4dLVMj8FToCQGAJb6/XcBSlfFVHTAOFq4g7McVfeG0UVJtsGwVOANFgf011o+TFgG9llCtHplwAcK7mRFWJr0PHPl4YLQEBbxexKhRGEGOrYBXU7Kgc7k5RgsQS9g5CiRHpb7quuy1LzvVbbGhtezY2Cv5O5Tt6nJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=o6+kh1Ie; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LoSi+c2K; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="o6+kh1Ie";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LoSi+c2K"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACaXmB3417135
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/mbyn5v6NwmEdG+6B8c99cOQW9zb8utuqxEPtdWgWeE=; b=o6+kh1IeXIKYzYbk
	VoonwtXepckW+lS4nuu5BwHJlnHejhovgzwOs8H8iTKd1lUj2uOTZ9yO6umltrPr
	v5Ow7QTcZPXW7PuWCRv2sQJ0MTwiOhQzPZA1J4WTJOlUA6DMmsFAHq/zdhJlCvc6
	A0rEaDHekdTZI1NSlVEUpKAnydiBJgeyha7fI5AYC32y0BGwSoiEgapWPDAW/5DV
	7PrqiPrNgYDi3iEXbbzWXlpPUUVrUXI28d08EsBM+FsH4SJJrvkO9Jlt//FhLsZZ
	tfybMKAI4Ahxg4ZhDs2ENHPv/PGHDUnSneRNsQHVCIiUzigpWd+kGdQboHwsLLpg
	ROp53Q==
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com [209.85.222.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctja28m8q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:12:25 +0000 (GMT)
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-94dd07e7d0eso1830753241.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 07:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773151945; x=1773756745; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/mbyn5v6NwmEdG+6B8c99cOQW9zb8utuqxEPtdWgWeE=;
        b=LoSi+c2KjLRaxSvh8L6OLxRetdJIQlP7Wm6Ry4MeNn42DXB6nughtvdFUNWyJYxqjc
         c6KJvgweeIk96HOVrNSivx92PBFcJBHZ6wQ2vPTp/hxQTiIHwTpWFBEGycXWQEw5yMcG
         s+0YE1DmvEg0AbOEmKmCkd7rU6TRAfJ4CbWRe/808L5l8qRk6sklZfOCkwZWHQ+B+V1J
         uu86qxrG4owynGJNDedN9mEuP+ogUDfTxgmDBX6vXGwHuF7XQr1zXGZVuS24qTbW1wR/
         sBw4vZPoVhd7bHx834HXs7FjaitLt7UB4MqOC/5qd6WI8mOXKdtRqtl62lnshBWfDbAS
         3ZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773151945; x=1773756745;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/mbyn5v6NwmEdG+6B8c99cOQW9zb8utuqxEPtdWgWeE=;
        b=w7NK3XW5sl1/UzE//tWsOfHNNFRLnedJV6XAPXTcMkCA/YaL42HboIuY5L15jiv9ue
         0wGtytAAbNPZ/x/GY394YMyRhKJnEARNeutqrjx4RNNq/2+Osoje6B2KdK/iC0GvXX6/
         /0RDPuZi2NuJl1nzjVkjoUEgsf/nbZcPiOuQW0FPCpQEY3ecev8V6xfEB4J8/DvY9Ojv
         VfQqvSqCEL34s0ET4AVZa/nyXir6uX/G6K53/eKF2L9JBvBCXRq5XumtcsZguofvnYj1
         qD1c4JnhA53nMp+CUaLa5lvDXMvGYkTuRCcj5UOYDFysZRAGyU7xmWHSiFP5MVJ4sxO7
         HJqg==
X-Forwarded-Encrypted: i=1; AJvYcCXvBtl9cGDmyrlt5aHuSs0legp0fwBl8VjXRRLxeTaP+7Gb7fiEHS6f1bIn9umIWOg5ekTNCiGXfMsbNOY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhieCrYsShvMfFWecJiQDZB/9B5oNlSPlRpTFJO/8ek5mHLDaM
	cFdOhcdIMahKf1OmBOsBCt/pgMNYDzZw0u289+2j5mSdPvs4m3rQKxEOp9oHv1RqSbJS2s06XMC
	SJvWXmetdIAsyb6TDqNZe2i50HuNjxxyVJxCOxWiGMZCAO0DKxAT4FHMTHDbNZip9iJI=
X-Gm-Gg: ATEYQzyoUtRuGh3adKDx5/glQM0/b6NIsER3jsWhrKXQJr+AunY5gTvFORNnxLOyCkw
	cPT0aAyvgI8A+MYzqKokRRBW0KxSh6mF8r7/YSqwliuqEj0JaxdrxLwWfoknOGUA0fGKppKvy4w
	aOWKh8LAwErXzZu4QUl4muvZieWVQjtd3XkF6WvBaeDZV+xTNKYFOXb5gf95P+QMOCLn+5Olq9F
	YwyTVmyaBf4H73pG8ijP4i3Y2oo+Pgy+hbqLIodH2a33I9eeRVHX/oz9AdtCGgFlrmRfrW/Z6ez
	YcWv1vSAcfYu8nWRUI9FK9D7wddGWM1sD0wkww6KzYJJHMK1ZPt8l1vCbrADmVE6kJmZhwPuF+d
	vNQhiNhxxc4CSd3cHzmeYAKGgp7n22CjkNWJQyGDM09md2/hF8jYwB/es06YJsFY8n+vX4N0jlX
	ShN4o=
X-Received: by 2002:a05:6102:d92:b0:5ff:c0e8:d89a with SMTP id ada2fe7eead31-5ffe5ba4013mr2497616137.0.1773151944937;
        Tue, 10 Mar 2026 07:12:24 -0700 (PDT)
X-Received: by 2002:a05:6102:d92:b0:5ff:c0e8:d89a with SMTP id ada2fe7eead31-5ffe5ba4013mr2497609137.0.1773151944415;
        Tue, 10 Mar 2026 07:12:24 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-662a07022ebsm1512263a12.3.2026.03.10.07.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 07:12:23 -0700 (PDT)
Message-ID: <7adf07ca-0ff6-476a-8975-8ecb1239a754@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 15:12:22 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/11] arm64: dts: qcom: lemans: Add power-domain and
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
 <20260310-qcom_ice_power_and_clk_vote-v2-3-b9c2a5471d9e@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-3-b9c2a5471d9e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=c9WmgB9l c=1 sm=1 tr=0 ts=69b026c9 cx=c_pps
 a=KB4UBwrhAZV1kjiGHFQexw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=z_dnvKGLtVwtNw_c-ccA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=o1xkdb1NAhiiM49bd1HK:22
X-Proofpoint-ORIG-GUID: v178U5g-ei0-odNlAO67wbubgICB_IDw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEyMyBTYWx0ZWRfX0AjKLTNNzkm8
 8rIjoVcwbeRJQYwzdZI2iUvHGB81SaIfIkaPEk8fS+dF1DRuRwvP4xEwRg/ch0oAPEQg4kQ7OwD
 4Fd2yipFYUfZFCGhUGUZXPzzSnrD/TXVfUsM1YBF0+OeJf2EFXEM+sgFPqexlNRY/cfyGcVa88Y
 8CWIbl6ZCLRc4C4WLF6sAlTT59S8XheTQm6QZgvoLPMNusGSxF4QqTRJwOsu0T11JKUXqx0lokB
 iB5OHtYKTCff2Yfh/SLZosCU+V3oe5UIgoMYCDqR0mwQ8qxefvlbCKepYwYVpL9iT0JSdjyJkgr
 L38aVK6QEYLpKJ/219NIyGwYyu3aJOQ3BLiI6LN2RWCPA8mpfTA13e9oQJLxp04itYJ0VKCETJo
 sIDpMFsmI8vxPXW84/nPva4EElsjkjGqktyNdH8xmEMIwJvStC1n9jYaKcWaecFi/Q+pUQ/qlDA
 FYoDAxAvAj2cWh9dwcg==
X-Proofpoint-GUID: v178U5g-ei0-odNlAO67wbubgICB_IDw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100123

On 3/10/26 9:06 AM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the UFS_PHY_GDSC power domain is enabled. Specify both the
> UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for lemans.
> 
> Fixes: 96272ba7103d4 ("arm64: dts: qcom: sa8775p: enable the inline crypto engine")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
