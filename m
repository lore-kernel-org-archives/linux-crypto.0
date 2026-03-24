Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8269837F72A
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774348444; cv=none; b=UohetP7h0KdteCVSozzEMD9WVBAbWIZzsSvSLhgfHuGrvnG851K/7vTOzlV5IykHBkYPjJCkcnrwgmSUWm7jmpb3UY1SrB4LZPIH0eRNn9kjdOFsMLi797/etqe72/DSmCs4oKwqBZYXvLBti5FvCkOGNpQcCO46SL8VqyadpKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774348444; c=relaxed/simple;
	bh=0XW7qq/cYCeR9OCvHLhwCJaTaNC5jevWMmJPP9v5ty8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T2il3RCdTYd9mBYLW2pCjFf7YREYQf7dbXOhCdiFpQO5/FIDm90h9f+uRSfXuNKSVE2SUD4XChOME4ENKz8Auzs8N0fGAvDwLZb6iy2bSQwPCMCiOgwO7mlalmMqDqsBnSETi2lUVdcgfIawO/zWUZ22ZxmtcIDLmMzRnzGP4Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Pe6ghYhQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AR0v01Va; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Pe6ghYhQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AR0v01Va"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O9Vvfg890467
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:34:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GUHL7c2p6O7qQg+zZiT8+TPwPHsQTYr0YGPYhMhdOb0=; b=Pe6ghYhQNzOwwkOS
	8Gps9Fz/tTbU8hgNy77E931fsS+tBNOCA3Acu/yKP7wELYlCVBJ4PsRei9fqQpMV
	t73oEnnZInzoySAhis0ZsPyYjp1NUC6GCPVLam6MDg4WjvQ36F7AD6FjQ0Vn5UE5
	Klzung+YGfqF7gmuU/XE4wXiBiViM1UbHRTBVPN1QmhqMkByd+IQ9e5j3/gNnMEw
	jqZH2MKTn1w6XGNq99VW2skJGYy0Qlj3BEAAEr0xmCYLqQWnpklS1UA4ZCvaOriN
	mG6P8XivfGTXAaDfmcgtuOuqNPGBX/JTSZQ/gdQGZqklZUozBlJhMd3KYnlzMb7G
	m+TEwQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d3k1x9d3f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:34:01 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c70dd30025fso17682244a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 03:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774348440; x=1774953240; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GUHL7c2p6O7qQg+zZiT8+TPwPHsQTYr0YGPYhMhdOb0=;
        b=AR0v01VaAegcbc/+SG/xqOjkAZMKc6lgUwoM0sVlP9GZBXO6uLR7jnUvRsEEGWBNqf
         iE0Vsbj+fFzSSvGRti8bkTwXuM52Ry1sx30aEODGLliNriaaEw/RLd5Kz1GSGAlfGhBs
         XgswrYZLBg5sXFgK7VbCZw13D1J1V8ij8brM2xP/Elyk8nqM+nSnZ3FedC0uNx7toqs+
         ul9H/IqoXXS4uKMrtHbTC2nCHNSF7DOSGbGD//ifkZIxyeEIbvlIKMAV0XiG/QWLcbBI
         sNj+Lk6rcJT+/BemPvJiPytVP8Cotjt/2AamaBjEu7OTdKUP0OE9yPJQTwJAUyp1oLeU
         aCwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774348440; x=1774953240;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GUHL7c2p6O7qQg+zZiT8+TPwPHsQTYr0YGPYhMhdOb0=;
        b=UXUHZdLZVA5q4i9jpHqrV34++BXPdoFa62f77ufmSMODofuSCRIWAzDKfkvIUn+WH8
         5UIx2V6sWlX7bkaGe2YCavt952Zt06/Zba0UVsAf4gj7qwPi7aVNdkQpHfU9NQXIeO2z
         oMFk0OLMIYHTghTLILTlvQxrX1+imUF2qH01bxPkmD2Kz7M9AE1Qb76/c1RASHEsOoTk
         oERf4t4zk9h05ffZPVdonqACGBcr1p4Lo4jzsBllRj/BjIXMiR4b88LlwfLCuvVUkjuS
         mdY1BcTrqkH92GTgJF4Tzbla4XBCW4CqDg5ygAegXHEacy4JuBOkmNqDpRn6P1XdhO1W
         xcaw==
X-Forwarded-Encrypted: i=1; AJvYcCWrf9mfdOHvPb98YNK9H6iDloh/LbDa4VdOeSKJXFEdFhTVhi/d8NIF/8CSYqo25eiM8Mnq4YzFeNKL3sg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF3GgqESEvbozSS0vQoWHzXidiNpuPwxmdg3WitlnKxyCny3//
	g40S5zYjGgdh4zOGv5x9im7tKFlzCcHkSjj9w2TsodpA98PAqTxmocUVNlv8YBip+2Wfr4fImSM
	lVcb95rp76+OpWw9v2tACGZ678VHo6mGnDBRFyY56wOGl2nd6k8PhOvm8TwNdD9sieEM=
X-Gm-Gg: ATEYQzy5VpLAETzu70189vtCiqmWDV302F66Se2A+ev4AIFAicwngdpe2YvRFzuZL1e
	f3gvjcvuGww9s49g+YdZkLiFxYW2lhVW/kts8r9VtaMTwin308C/2eft7bjhZa0tuyGNHfurV6j
	6h/DpsRq/SXHcUNZzI1Xt9/kcvebgVNz/Dm1kggW///OnTRrGwzgTr1ZAgpptKPCDOEP4rRFqU8
	El5UR2T4EYHq+P1NPVyb9PpSrBydeuWdCWTayD+9NuvFGzWt1e9Y3Dr1dc5IMu4f7+wWW7/Fpc+
	LlPIKT6gx51gRw1nrTmISgZPTUEudqa4ARvjtM0iVAizQofhJnLmcXSjZgscfRSYx42YkrCWhqC
	ZEzNI+9k+Dv4yPHccwS04mcGs18J1Z2nb+IxCbWroYHRJEBk6KGYy
X-Received: by 2002:a05:6a00:139e:b0:829:9382:50ba with SMTP id d2e1a72fcca58-82a8c3b3bc0mr14523361b3a.60.1774348440330;
        Tue, 24 Mar 2026 03:34:00 -0700 (PDT)
X-Received: by 2002:a05:6a00:139e:b0:829:9382:50ba with SMTP id d2e1a72fcca58-82a8c3b3bc0mr14523307b3a.60.1774348439776;
        Tue, 24 Mar 2026 03:33:59 -0700 (PDT)
Received: from [10.218.44.178] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bbebb2sm13264445b3a.14.2026.03.24.03.33.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 03:33:58 -0700 (PDT)
Message-ID: <9c8dfa88-f820-438e-8418-4919e1175edd@oss.qualcomm.com>
Date: Tue, 24 Mar 2026 16:03:49 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/11] arm64: dts: qcom: lemans: Add power-domain and
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
 <20260323-qcom_ice_power_and_clk_vote-v4-4-e36044bbdfe9@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-4-e36044bbdfe9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA4NCBTYWx0ZWRfXxO6KssbHhPhc
 3Rx8RzFyRjGFDb4WdMciqsbFY4VAOoo0/R/VJXUFnnJlGzRYcjS+uT7/fhjIFsJHxz2OYQp+hbC
 St/2i7gtZV1LdX72eFjgFA2vUkGu0+l81RQQVrJoSwC8WhnB5DK1n7uwRuzP7PU7BaRKZ5bIyPl
 HE5xSz1Oci8u3X0Z14AmOZAIfIhUYyH65et69VAyvrqI6wt5WSnvozT0IEXieXTtycBsUUIQtut
 n2mJG9Otig9rMfRghVYsb1v9PHvr2uCQi/6l7BMf0N32z/AMbqnsPHB3DNT1MYI66+ioxHWSsrG
 re9OUI60TyU0os/O1fNqzi79TP5gtasfgZwAuul/BgWYQOCOr1ygsDAfweT0YUvJ0woqQdnfteL
 DAKjbLw5mJBK1Liit86nLRe6XiXSEnUmx+Yg5oHs7tIwXb1qMKku06NH1k4jnqlq7hIaRroltSt
 OLp53VxdD6WvZNNPp/w==
X-Proofpoint-ORIG-GUID: 8VLdRHi0R6GEMrpxM-deXgnk4NGKyMvW
X-Authority-Analysis: v=2.4 cv=O880fR9W c=1 sm=1 tr=0 ts=69c26899 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=RcdfdvLsBkETvr5PKcUA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: 8VLdRHi0R6GEMrpxM-deXgnk4NGKyMvW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603240084



On 3/23/2026 2:47 PM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the UFS_PHY_GDSC power domain is enabled. Specify both the
> UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for lemans.
> 
> Fixes: 96272ba7103d4 ("arm64: dts: qcom: sa8775p: enable the inline crypto engine")
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

