Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165EF3612EC
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 10:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773830032; cv=none; b=CGehc/gWohA6Sh4u+pCZSPw15Ovl/kbaMw7v1hhVqxRZlhM1t2cGnCiwqYaz6L7sBumAY2oQ658Uvy2OEKkrvuZBrx9ox5rf37BwQqvmCNki1WIAW1Cnh29l1OUVaDjuRd9ILGBBkfPCG1pOSK9tTAS9sStW0BN1u/qShnJpGyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773830032; c=relaxed/simple;
	bh=nrzA0Q0Pn4h2XNPHNWL6htCI40600vr76gMy0MZB15I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V6KInV4VtoNpgCazSxn0rrQMatvnwXmuXbdnVUoBu289SJmskjudPCk+cArtfWJ6IgBjsxMVaYzfTAya/2/c6LTko71j6134JEPG8xw+77MxNnwkbkF18febGlkPvoFFJhcAW4lVgom/TsnlJrIhtFav+KAc5KiUEeG4NaIBhsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=piPaVyre; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aimiD3UJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="piPaVyre";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aimiD3UJ"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62I76oCY2613396
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 10:33:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OkZs03EOkQ3sZ7bZ2/BT7q4+P0uDk/ykrOdFIVHGRVQ=; b=piPaVyrebycrV8GR
	SLWZjm3O1wJb3ZMSB0s5KVKTBlpjGPdG/tYNk5+i1wsZVYQwYQIaMZRZd6eUIJsf
	jkps7h8QYObugaMeYk9TzZSbgBMC9l5d2WN/P7Uz9D0r1R89EVZiEr4tP8edTsDG
	PDq/jH1aYRYM5CrxQpysi1rtxedmqyAknFlPMddPpT5+cAa28CLLC+i6gNChJFnM
	MXxJ+vIlFjMvKYebp52U5/PQbGiSJDV6+59oVEWm0pFWh8/hiMFqxqHWLQr9w79M
	rWQdOUmLMm0W+PGZV+VP7IlY6wDGmtWYzb9NlIav03F1JpUb+sbL7d6hPe4rRZQG
	jpgbmQ==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cyqcdrvp4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 10:33:50 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-82988b04c5cso22994924b3a.3
        for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 03:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773830029; x=1774434829; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OkZs03EOkQ3sZ7bZ2/BT7q4+P0uDk/ykrOdFIVHGRVQ=;
        b=aimiD3UJOvcN2YGlZo94xDFGaBDcK311pwJ2Q9lJ8vn8ZHtSDY4AOSktO0MpaeHbHN
         /PNrXE/IM8mwnc/2yUgfrDtbDe7os1X/gw9S0md7mtfwA6dcbbNA/FaQiLGKwrYL/K7V
         RHCRrDdm/OMoH0/vUtChg8rxQpiV2iWBKBJmX3gGVifn79oGv5YPwVcNMAJLEq50UCNx
         zUezw2vUwzk7GneHIPrTSPUmTb9tKOBwzWmUiJorqXI4JWL8xCPxzfDG08T2R+R1U9Vw
         x1//iaPcAIttJsvyTo9I+b1J0USl/jJ2RPqIXNS7W0nC1PxAuHOazpuiLxUd5NywLXXS
         MYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773830029; x=1774434829;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OkZs03EOkQ3sZ7bZ2/BT7q4+P0uDk/ykrOdFIVHGRVQ=;
        b=pnyeJveC1x5okOx38JMOs9SvhJf30UgGRfL3uJTPHYQAB2NI/9zv9hVmQ7ajpqk1+a
         Vn8mnlCs5q0FK/rgC+87FgvQMcev7YnYDacmC255VyZPIY3o2H4yirD8FHT284QjqnnT
         Yu0Je7kMusDZVhlTssw/LnqBSvnalfnKK+TfaoI5WQHFisd1YfiheWeL9GiY6bd1dV9B
         x8VfGPX3sjhI7IYWVYZSdvNdy1w/08JSw1ibaRAJy0jdpF8PQ4Y82iKF2eChTq7AaSeP
         LQb9rOPBSERgxZwROxF4RX6P94Lsmw4ivHG4Pe6MpKsG6slT3NgI0mPaaVIiumbRgfny
         Ybnw==
X-Forwarded-Encrypted: i=1; AJvYcCW2tEVMPwsjPQhHgRp2dtf9coU4z4Gvyfbullv5fHo6nE0zIcQ6G3xq8Q4QSgSkK7hR87yueJ9lg+iaw+M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAl640FbC5D+FWEuEKJkjFkLL8og2xIb6lvpUnLM2kw4j74Qo7
	FA3OrdGO0bhzVvJ73racIW2Chh3NrQJLli+nkkiIJ6qrMH6ujsDeVrfovL0VQAFAP2oDNQBq2Mq
	8xcTDUQONFoVV7yeSrdv2yebKM5pMbZFk911KJ9zIH7R0ab1rbRvuxtifhvZKhHc8YZ0=
X-Gm-Gg: ATEYQzz/64eJOlrFsX/j9zU6sHMbCBi2CTZCtQ3gHaWQ2zuUyyzdSb1w0JWK3rTwr+3
	SwQV4iNnt9zPUeF+CnqnXDrz/hQOpX4wJ93b9UcHLsSh+uJitcYYFW8LZnJM84G9Enfk+pcP/sH
	oFmSHiAcR8VEyX7LDkwFCi5C3FxxxbwCq8cghFIfG88V7QgNISn93R/+cxutwguPPBXm3OC1yKx
	3Rf5pJjiKdinr/QdGhmp06ewoQSUJppIq5EErLD1XMAzvba3F0hVJesc1dN5QS44K6YkIk6JA2A
	SZLI2LOekn5enNFJ3tE24iZ8g2nOL22s5ewB9HF7EHjBAuD8OuvyVK5GlRau5D62QhVPjTMEZVO
	2xZMxd19cQ2egZNPiT0Sx7od85XUcy5hqR+ZwpZ11XVJ9Bbe3JmM=
X-Received: by 2002:a05:6a00:990:b0:823:1c5f:1c43 with SMTP id d2e1a72fcca58-82a6ae51517mr2674223b3a.36.1773830029094;
        Wed, 18 Mar 2026 03:33:49 -0700 (PDT)
X-Received: by 2002:a05:6a00:990:b0:823:1c5f:1c43 with SMTP id d2e1a72fcca58-82a6ae51517mr2674196b3a.36.1773830028623;
        Wed, 18 Mar 2026 03:33:48 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a6b56df09sm2355266b3a.21.2026.03.18.03.33.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 03:33:48 -0700 (PDT)
Message-ID: <0ff641c7-4218-48c2-b93f-978a3915c5a5@oss.qualcomm.com>
Date: Wed, 18 Mar 2026 16:03:39 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/12] dt-bindings: crypto: qcom,ice: Require
 power-domain and iface clk
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
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
        Alexander Koskovich <akoskovich@pm.me>,
        Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
References: <20260317-qcom_ice_power_and_clk_vote-v3-0-53371dbabd6a@oss.qualcomm.com>
 <20260317-qcom_ice_power_and_clk_vote-v3-2-53371dbabd6a@oss.qualcomm.com>
 <20260318-precious-qualified-oryx-ef619f@quoll>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <20260318-precious-qualified-oryx-ef619f@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDA4OSBTYWx0ZWRfXyhzNi2MzkJLw
 /iNJ72i4HJhLwnvXFp2qI1hvGoDugK8U4M3JNHPJlRDmypBGa+2mQHIQgIJMy+Xi7rw2vtuwAcm
 cic2ol33NEFLI+f3M/FJ8r6qoRE07yuS5ZSRczudavghfkf8p+3PS3lweXjhZ2F+t+qg2cJHt26
 Sc2LUZPPKJedXtHdPGMRZkXfIII3cBiK3SVR/uSpeku/IYFMPq/O3Zd7CRlOAB+bnBkolwoqoFn
 ebIRnFJfdJcSaDzITDy4fa6Z++5MtBcRf3PvKYxCNBANwZUa4FFSXC9zn4L6t5StCiq3EU3EsmA
 jwyk1rcPMrMsfKGJC7V+QP/rAw5uMhInpjX0rp1ah9R1DqW/8EaD749XLINoZYLapoC9p3NCM5C
 V3UiWCAP9tOMIbr1vHl+yJC1bMhV1OO/wDpigQ7HhoB6ybw4RAMdBO14Yn2mDDRaNs0cae3zD59
 G6RvZmgVI4GPYQXfK/g==
X-Proofpoint-ORIG-GUID: 2v_VezlTPz0Ki7mYQqp6DJRp2FikpRSZ
X-Authority-Analysis: v=2.4 cv=H87WAuYi c=1 sm=1 tr=0 ts=69ba7f8e cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=RpU2Pg236iwgMI6ZwYcA:9 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: 2v_VezlTPz0Ki7mYQqp6DJRp2FikpRSZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-18_01,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603180089



On 3/18/2026 12:53 PM, Krzysztof Kozlowski wrote:
> On Tue, Mar 17, 2026 at 02:50:41PM +0530, Harshal Dev wrote:
>> Update the DT bindings for inline-crypto engine to require the power-domain
>> and iface clock for Eliza and Milos.
>>
> 
> NAK, pointless patch. It makes no sense on its own and it cannot be a
> fix for earlier issues, because as a fix standalone is simply WRONG.
> 
> Where did you emphasize this is the fix for current RC?

Ack, I will add explicit emphasis that this is a fix for the current RC in
the commit message after merging this patch into the previous one.

Regards,
Harshal

> 
> Best regards,
> Krzysztof
> 
> 

