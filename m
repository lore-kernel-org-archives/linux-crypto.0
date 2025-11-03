Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8944F309DA0
	for <linux-crypto@vger.kernel.org>; Mon,  3 Nov 2025 12:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762172069; cv=none; b=bsUgznJNjp/0NsR9Uru0BpSzvNVFoCCiGKZLNxBcrOaXKUqt8AOHP3e0ghW1m6TSGT3uWBEvnIP7UVwLdcb6S98/mSXg8dsJHLDakMuTHPdotJGETI5SYZnXroGtJBKJLehDuWXtUubonSMmIOFByO9dKqCU1rrtgZEqqCV6ghc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762172069; c=relaxed/simple;
	bh=JTYZcKugNZOA0vYR2o3dVvUjZjHQpyWvNa4nAUsB1/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RrXScD0FcV95Wq7GBQ3rBLPcSq83BB/e/dvrNMgaF1t2jmRmlI8CSvtiGpg8ozcQzYr7NRYCvc5lVwykCyFxmeSMM1dBU0ze7aihAF2sbCjRHq2oXWRO32WxWnsg71f/saze3jvBO6dlb/8EsSTqunfm00jLXIhJp2TgozHFFMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OUzK5wEF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UNAx7P27; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OUzK5wEF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UNAx7P27"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5A36BqCi2269079
	for <linux-crypto@vger.kernel.org>; Mon, 3 Nov 2025 12:14:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6PPtwZvy+gqvwwYYjdp01cD8qHwlSUjev3sm8V5A7n8=; b=OUzK5wEFC9V0CHDj
	GQ43SzIWe1qeGLVQY1cULEJLKVNG0kDOlmmNJ18aN7Jh1VKQFeWE0iBawNDgzRUx
	5OH8EQEKRP+LE3BFKvwnlUHHXB2ySN/OQblyq4oUHHCOrU7PNDJunlAWBN+YGOoY
	jJM/nEhg3WZEhd0dQkaEYj+rZVD9oy1tWqIsnTJI/x3K3UYTo47za0JAPamLkPeW
	+vcz12BHIqe+vyrzAxRPtvBk6XJaxKJM9ESxX/G/QMfT3EPrJ7YPCAvEwGYSg590
	KnC8hHSzVjq4OhpvUHLsC9tB8X9pXAIffG+/kXv7oWZPQXyseiwP6bWfYRWerTg/
	kdkz2w==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4a6pwah1yr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 03 Nov 2025 12:14:25 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-89ea549dca5so218124985a.3
        for <linux-crypto@vger.kernel.org>; Mon, 03 Nov 2025 04:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1762172064; x=1762776864; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6PPtwZvy+gqvwwYYjdp01cD8qHwlSUjev3sm8V5A7n8=;
        b=UNAx7P27BAiYPYoUMw1t1o//wNODLItHFD3I3YJ1N+I16WRTusSztY8NG6+WgTT01a
         5VXDffrNTz9IDmZiUipzBRBTMapqZXnCkGXq1aQW7KrqyfkhKQIoCwPf5Zkx5m2Qs8BH
         G5sN4+W9ok9UyDoPX4wktKIMJMjHpH3FPe0UdvDNqNTY12fCKzzbuFEzlY0hdwc5DgwX
         aOl9VYPaFkXvTGmWMvSM8T+ZSHIL9kfInFwiDWashP+KljOBAp7qBZ2K2LQMNNSSI708
         bhpDJS+8JqitBgf2EvlKbL5L2dvX7Zcfoh3+BCI5RmWI1EPfpGfb46kmdxJYuOncqOxe
         FnTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762172064; x=1762776864;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6PPtwZvy+gqvwwYYjdp01cD8qHwlSUjev3sm8V5A7n8=;
        b=uKevyHrptNYyFbSlnLiJFOLizPHE26fZooWlDltyni0kzumsUy3/QbcD/Wmjusd3Tx
         1dd43IrFKrXLVGgZy182hr24O8OYVGy8m+nTMxZol2T5R+U+9eaIde5Cb6cJhVqUb3BI
         ozVeHGYP4WXeLmeaiS5/WqQJHg07mFnfY5sS6ohmRutj9uQAgzh2XyF1XoaSdzzFhvI7
         k4aHLON5halTz7DmVvNroqNkabkH4elCnKt3LAainlWkr9wmKCRnyQ1SP7v3w0hxUfS7
         FelYCUoV9J60nBEjC5lRKCMkNJO73CmYzYuG31sNJst2egS9bEQQQCU8WE0HBsVT6mQu
         6XIA==
X-Forwarded-Encrypted: i=1; AJvYcCVwB8oHj8OuaK6TxV09Mm1o7f9l6f/osVoZo0Bse91luYvdvpgf2cyz4glGQS8ntIg2TdHv0cGOHWXzo+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwyqyoB3K5+IgwEH+h8oGMogTBBtk5OaYgq6tQsTk6yRNw8koj
	iBk+i2RnyDOQcxpxFEqbOSSBe2pYWIGyTGvxKKrPePT/2JY0udqiuNyONqoPMyZ2vdiKgTFFsi8
	NDYLocdVgAECkSr3kG9LG8Bvci3uTzF5NUYMRUYBzLDdIIEpGOYVNEdPgVmPhBnjh2YQ=
X-Gm-Gg: ASbGncsdcX3b8NrdB2OGtT2AJ67t7kONmlpXCAoxgnUYELADen/px3Pm3HMbnMAVPOs
	RiclEMYHypDO2jHKJ6QgbVdp1Exb+emLWqaajCjUA7v7tY7nstXBtpNTeQVptQWnHL585J8fXG/
	aI+M8iiXQriiWbBq22GZYWa3I6q9Fk/sfUTKN0wwxrzcJTfDx2dRjQnVpEmT5KV3CPpUuSgs+sp
	6R+KE5G+Fe980/I3mvPUDDSN8GgAK0g6ooEqLwOsvZI6lGlTbcsDZkEUZrqGhNv6SMQM562dAuB
	mNDRPHx1h60timwI/7EC3NksZ1VqCd4ohN6PZiAWQNuSeBrnSePrLGg7WK3hAC3SwI5sfC7WGOr
	9/Xnv23O9RGU4omF+3WPsye3kpG1LhKQ50Jsa6k30PRssvl8dvcGFmNM0
X-Received: by 2002:a05:622a:14c:b0:4ec:f7e4:8a0e with SMTP id d75a77b69052e-4ed30f84d8bmr115448001cf.9.1762172064493;
        Mon, 03 Nov 2025 04:14:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFojfDNx4zUtTBFnI84zhhJWl5ScbUrZr2SjZmrkUFo9wwBQljbRwY0JohB1/KDEp4gMP6DxQ==
X-Received: by 2002:a05:622a:14c:b0:4ec:f7e4:8a0e with SMTP id d75a77b69052e-4ed30f84d8bmr115447551cf.9.1762172063877;
        Mon, 03 Nov 2025 04:14:23 -0800 (PST)
Received: from [192.168.119.202] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5941f5bc248sm2843451e87.91.2025.11.03.04.14.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 04:14:23 -0800 (PST)
Message-ID: <c93afd94-9d94-42fb-a312-df6e26bb2bc8@oss.qualcomm.com>
Date: Mon, 3 Nov 2025 13:14:18 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] Various dt-bindings for Milos and The Fairphone
 (Gen. 6) addition
To: Luca Weiss <luca.weiss@fairphone.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20250905-sm7635-fp6-initial-v3-0-0117c2eff1b7@fairphone.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250905-sm7635-fp6-initial-v3-0-0117c2eff1b7@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=OrdCCi/t c=1 sm=1 tr=0 ts=69089ca1 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=6H0WHjuAAAAA:8 a=PtzdWR5wS_Xl21Jse7IA:9
 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-ORIG-GUID: NtV79r3r3Dvq3_4qyIt_82lUS5QiWQQu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDExMSBTYWx0ZWRfX3TQ2I2o9lbHW
 1qTOFrufen6FNCU+oM4nGdOnZYxc7iJMIkVV4rtmpGDGjuZcgzCduArY6SMEit8UhdFtJzIjFoe
 xvVwdMM6mLzO0U97Nherso4BybVov3eUqe8yeOmg2KNtI6tCNb5whoPtPO6ogDkEXHlzhtzvKA6
 iB8xEWKpprDZlp5gBWx7YOksq4wLpWM8LYN2NS909ae/UC1rsGeYC0spQ4xwKygHOvbn0Ldtwv6
 +7iFDVHY9nKWA+uNWmvWgesUmhprQHo85Wx0yq0X+S5t3m5JmLlzrUJxbHiwl4uXCcqw+m2dhL0
 FY3TB2WYVjK/IbCU9YhiOuCgDjQW6UGXfb23XGNjPu0TYtXlyUz/MohRi+03CpfRBEz7NwS/tH6
 8zhwoPYkuBEkxA1/K1/gw4eOgK60kA==
X-Proofpoint-GUID: NtV79r3r3Dvq3_4qyIt_82lUS5QiWQQu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_01,2025-11-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2511030111

On 9/5/25 12:40 PM, Luca Weiss wrote:
> Document various bits of the Milos SoC in the dt-bindings, which don't
> really need any other changes.
> 
> Then we can add the dtsi for the Milos SoC and finally add a dts for
> the newly announced The Fairphone (Gen. 6) smartphone.
> 
> Dependencies:
> * The dt-bindings should not have any dependencies on any other patches.
> * The qcom dts bits depend on most other Milos patchsets I have sent in
>   conjuction with this one. The exact ones are specified in the b4 deps.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---

FWIW this looks good.. where are we with regards to the dependencies?

Are we waiting for anything else than the PMIV0104 (as part of glymur/
kaanapali)?

Konrad
