Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B92037CD2C
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774349266; cv=none; b=Uo7BCrIIaUL6USp9TOU5wKblA5CM3EbV3LuNpzZIaQWjjipgdaPSuz3MVnR/PWOweNJYdDoXRuprwjKRzzrfEmmHOiFPX2pDuhrPscjd2GtwaKYO5S/vXJCc1tTOLZTpYgN/mKObJXAfOqTC2ray+5r2n7xeKjlnpLSmlD/jyeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774349266; c=relaxed/simple;
	bh=vm4vFae9KZ5peWjo+7ETJQKYic+heVZYLQ7TwB1BY34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W9Lum+vGM9N7WDkyJXp3h+Rb37Yf0Pf8WjTmMwC3zJEkfQpAh3DPoSGei4QFDR13CdlsnJPe91N2GDWL8Kz0V1mOXRaJI+wIcH2SfMzwOeY7Y4FqnlhQoPKHC5tiEgAZYa5l1auT/gtWaxUEsf2rJbu5r6vpkujB12ZvQU/yNmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hAfNLS4a; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jCfAgllE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hAfNLS4a";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jCfAgllE"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O8xgZE2322865
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:47:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ONXmRW2mp05oYjjVFdlwD8Q0MPE75jtjxRhE/bOb+IM=; b=hAfNLS4altDF8hya
	jqkl7yyUCNlgQmwtS6TTY46R4SqlwWUNcs+NR03AwfpJ3+iCwUD+mNoF5rAr+LRB
	pM6xTJJ2HgU7ReaCDOwk0zQXeItc6gsohTZBQOCEzD4tH1L48MEeMEJTmIncnVz+
	WwoHJZ9f8jbb3CTpYzWI2Qu/ab5cJY63MRcYd18QL8KRRDtnRmhLeqNVDqZ+up40
	ajw3ySK+wujFj2Raa2wuB5XdjgyK1LA+8WlIwOs8mt9/TZ9EqOP1lKvmpbttYh7L
	UpwcdD4NM5H+0EjMYFwXY3GT7iQHInRn7dxq3PeMLhS65LI4gQw5lwzsQ8fyG7bn
	WKHv4A==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d3qkere1d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:47:44 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b059511554so34142995ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 03:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774349263; x=1774954063; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ONXmRW2mp05oYjjVFdlwD8Q0MPE75jtjxRhE/bOb+IM=;
        b=jCfAgllE9+A+DH1Qv98HSkeHYYSwMlslH4Mi1c7sQTNVT1eG8q/kxuCdaXJSXbPcs7
         AgwqdKZ2Uo3bi17WzLnEv6+30riyyHnkkiMcwqLLsANb+V0HM1d4/gEciEfzaIYmkCZ+
         2PJthqj3jEuo/5bIOf9ixvv5Lot7RhOxU1ccnmHexOPvgk495WYwGNNpfB+/Zu9/v50M
         qyNFsO5goSr7z7L4tHcwsufCqEzreQi1LlDYwJT2b8xOpzMrK3ae0gqckIGuV2OvjC60
         LM0Fo1UAWPStgTGYeznPTWKLhCVwn4vEFCgw7BEBlNSi1VPfkMz3koqTutKJVJ7fQaTP
         OpVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774349263; x=1774954063;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ONXmRW2mp05oYjjVFdlwD8Q0MPE75jtjxRhE/bOb+IM=;
        b=eOvmfdG+wWCCXVM4XtlJWhLOfCnThnlFaJz43T8VuV2rnOe8ujWJ8RqeznoA13WUc/
         0yERyGZOgXk+QkK6eFLiVWUaAUiX/UXOjuAPmf9bfIhW9Nfzo02osPlByw2Z4ksFd1Ab
         6HQ+Y9BaY8eQlkQ7jr0CUTpdme7QhOX14KLPh5njZ93b97s4I9r4fOavb6a5UCcLVN/d
         xR457vK/+b8ii3QTR3Om7pO7PYsLYaYuKp92+f3o3dx4t1EnPe8J7FAPz/K3VNZqpH0e
         22idF0wfwzL1cBlC6PsuZEJGfrY13Xj7raCIlwUEcCNKHzuYkKv0TGDgBSnShkzDZU1F
         JIIA==
X-Forwarded-Encrypted: i=1; AJvYcCVfUS2rYzcMBRf5Ltkz+sYRMqn75NT5JZaHmTIxCefQpwwcfk0Hb4GKcQxdSV/LKNwTZ1mbOOyrvKZJZ/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlhBYwunj3tKZM2+hFfSeNJdXqlHzFrqE+w5e23LvenH6UhJ+U
	NCE0DK9uWk383UyBS7ZtMP/eCUhzEuu1zBUgoRM92Bv6O6ouo1VYRsUyjYJfB5uPi0Hplmlspqg
	3QPP3gPP6j5AOOFdOuEDVxZFcz4izt/TdcZH1m29a9n5xseybGB1A7N4m0+6TOjcTwCM=
X-Gm-Gg: ATEYQzyxw5TJO44yBcnwMK1/B3+tKjxZ+SbtpGneKbXWZtZNbyKlCR0F01tliQf+QtU
	o1pVY54exTIpG85ZSEOHqzGC81Kl2IMiFfXPEmY55FYSEKSV2jU8Gy1Ed96snjN/rXnn6q0zwNL
	Ap81gmeh3CUlrhevsmwnC3GMQXJ+kmiUjOU60PKmPzJ1U+FKWUolDBdWaBipGalM5piIa3tBPPh
	detqZnM1LXBVd7ex5ZZkw9XXPQEJKZZlrKBY9Z4lnUTtr7XgA7tBt67XFCalmh5JFRQBrT2vNqR
	hvZsVGDmbiH2M1G0o9xybVvMUfuIcjY8bfb0hCokHAv55797b6VbKl36m300URJmjOevXdLU6nD
	Qfy5rxilGpN1NAHnbwxajsykzGUbJVKaBfUqMXXleg7UgEKQXk5FY
X-Received: by 2002:a17:902:d512:b0:2ad:e521:28cd with SMTP id d9443c01a7336-2b0827a92cdmr151443755ad.36.1774349263481;
        Tue, 24 Mar 2026 03:47:43 -0700 (PDT)
X-Received: by 2002:a17:902:d512:b0:2ad:e521:28cd with SMTP id d9443c01a7336-2b0827a92cdmr151443455ad.36.1774349263045;
        Tue, 24 Mar 2026 03:47:43 -0700 (PDT)
Received: from [10.218.44.178] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08351675esm183655315ad.14.2026.03.24.03.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 03:47:42 -0700 (PDT)
Message-ID: <47d83a5b-78f6-4354-8543-440ea06b8ffd@oss.qualcomm.com>
Date: Tue, 24 Mar 2026 16:17:32 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/11] arm64: dts: qcom: sm8750: Add power-domain and
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
 <20260323-qcom_ice_power_and_clk_vote-v4-11-e36044bbdfe9@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-11-e36044bbdfe9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: _9EqG8wivDiN4f1lSPguiKbbN_p7p9-c
X-Proofpoint-ORIG-GUID: _9EqG8wivDiN4f1lSPguiKbbN_p7p9-c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA4NiBTYWx0ZWRfXymW/0B6qCWG3
 zMf/CbtScSd9qNr6ZgybGPbeIujM0fgS8I5zq7/OWXNLm1fPMnPlyZU5QAZ5q27BbhLe60/snO3
 MdcQ0PEaKwKvtDtf0JYs8/ZYe6z6RApzdXg8J7jAYKoNQDchF0M9MIpGuI1o2u5i40hMsD4KTIw
 /y5Y4BOJh/e+dNY4L18tUljPhucPvE9Op063sg08pHFxLpB4tIgU0pa6sOLhG/7lQyHd73/Dm1y
 NNLadkC3i1n1DODaby8Oiyrlg4kLSjsUp3/JNaJJi6MMhzXwGY1+kZZUlxrpruKPzmwvCOvSXk0
 qS4KIK1cPc31a1oLTeECNyHW193YjXhxGo4VjwBU3YfXWkQn2JpIsXGmHH3FyHxZvmT2NInVXL6
 D8985JZ5+tPRn1037WpzAbQos5C1bvmF57aarc72sit6ARIwlRPuVJpVPrflbYTYC301oqw174I
 vtqZdiFFvyEvNLGQVBw==
X-Authority-Analysis: v=2.4 cv=Veb6/Vp9 c=1 sm=1 tr=0 ts=69c26bd0 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=RcdfdvLsBkETvr5PKcUA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603240086



On 3/23/2026 2:48 PM, Harshal Dev wrote:
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
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>


-- 
Regards
Kuldeep

