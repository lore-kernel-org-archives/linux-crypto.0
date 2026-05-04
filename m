Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBF43D810C
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 13:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777899622; cv=none; b=HzkuUv/VrvCdOAJt3SfNTRywffDpZC/m+/ZXIXppM84rM9TBck43c1pbDPPiGTiEglHNoy6gYe2vs6IcwP3aMInWMNNV/uj+qoO9NGmWPu6djUFXvE0/IdUuqDSBOtArUXjM6Ljpj0SBrBMNvyyj9pLO/RSPSaDq2eXVDss7G3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777899622; c=relaxed/simple;
	bh=3ETyxOrqtGoTUmGsxQw9Wv2E14Hi53hSdIXoy1rbroM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tTdjt/yOORCSvawE0EGLoTZcO5Gu5uSCpq4qkztb8AjUw3qsTBZpHgQ5uqQo03FguuOjn9IWwXUXfXiSG5bvtylbWidRwXyeFtCezPa7pEfazYTY/f5veJ5vmX5AhhOK0cRPPf/ONqyEq2mYcuDMlwFAunJ2efV7A27ykyPGkvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FxchUURy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GLG+rFD9; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FxchUURy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GLG+rFD9"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 644B4ITV749360
	for <linux-crypto@vger.kernel.org>; Mon, 4 May 2026 13:00:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	N0ab2drka40CxOU2j1vUZeZOnQB5f+4t6MU8W+kStWE=; b=FxchUURyYHt8yiqm
	HK1RTFu8cMHotutbAx55xZzcb8OU/kOQXGLOvyUsJDotwu8OOjCx4U3TP1aLIoBg
	CjVk+63cQ0rGU3+Eot0UrJU5D2018rbkIVfZC3xWJAg3LF3dg0j9ByhnUaxLS34F
	dUQw075JtM9S9zYEy74K6MiN7lPtGg8XamzsBkBSGaoRJZu+7E3syaH8+sPZ1tjY
	nibOHM3oW2NuLUpyp6Px7WsiwdtHg8r14auRwC2MAXZlHalsP8mOrYWdml6TZZSa
	+TK0d25L6Sv9XRoUWfQvMA3UP9KOp0J0xo3NR5322rqrM6fJwquFvKJmWZ5jyLAw
	rs9/rA==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dxscf0f6c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 04 May 2026 13:00:19 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-62f375d49f8so39253137.2
        for <linux-crypto@vger.kernel.org>; Mon, 04 May 2026 06:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777899619; x=1778504419; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N0ab2drka40CxOU2j1vUZeZOnQB5f+4t6MU8W+kStWE=;
        b=GLG+rFD9om0+/JBf3IPFlb4//8mCOo5pHhrn8OBoF5GWexTpVUAhRxYRIWdfn/RhVL
         1591JFxzRkqix91Rkr1t4mxw1exiQC31LLTn1wU5EUxoguOvzNkAYRm1/4NershqxTk2
         sPUwcqq5W4OH1dpLub9xUYSbnDJwqbzGV7fNnOI2w419GlKTRgIKGGW2TQF8NhfNUSMj
         D7lW6+cHJ/QAeLQSLzyMuNWF38cIvQrdBqKKVEx+85Cz5AogkmhD8EFOFg6nqwk7t2ea
         UqPVPLujjGQavtgABjvFjr2iy5VXEx1uzbC0ie3RYkEehR3uZ/VPFaB6roodDmcZkVkM
         smxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777899619; x=1778504419;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N0ab2drka40CxOU2j1vUZeZOnQB5f+4t6MU8W+kStWE=;
        b=YoKh8ZggOc301pFYm+UOLAa6ivOtmqL9hlpN8/gPYfruhWlDRZof/tkGlNdpatXXRn
         no7nZbn95BrEqvJWAoeaiZLsblL/SJbVhGH6pJcSgNHQODgMzbl4T8gFPwVQb7vrPOLj
         9ono7MgoftmigDlztW2T2c0H7swp6tRzw26qMPPfERD3tqf/diUJgqVzhh5uX9c1j0Vi
         dA3Ge4jmCjZ7wMF8LUDuLotT9HKsSh037qU1mkZVCNT4fc/U9jP9vQXwkjL1zNGxM7mt
         pZ5GlbnBqRPIOT7zRm9K0ClVgb+ZCXLY/829sv7tArEqycKmKTINIYOgo83oK76KQi/N
         NswQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Q3y1D7gf1nKGWmENlUgsq/5TG5nJHdj3zBh183txBRNgbuxObWLTqu8cg0bYBO5FPIAMFN2xScFJcqUA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLhFw3kGBNt81J1D3r5Ta9SZJsHqaT2YE8iCNFLzDsrRS/Rl2Q
	OhF+rmNTDrwwp5dEG9xRqOqAQEeFCA2hyiR+Jb7VEuafLuhWMk93CXsBy6hd5B4GypKY7jv5XZE
	lL0U4vdbAKxUO7IhfD+iD0+g4q5TFdyYsWHNxU/VZhaqsUtDIXmwMhiLm49b+JgB40Hs=
X-Gm-Gg: AeBDieuW4eHlULm0FARzYWdapLn+EFUDdbInoo09rsp+KbDO/Q0/xNZBuL7CCzLwBuk
	e1y20s77OOlfml0SGFOWCNgvK3XJYxVXnysZ0ielYWOyiAeNcYDr5xE9FAyJQSf+xqIprHGwggn
	Zv9x/kDQqT4dF8O7HJLfIG7A6BQkvwdwwTA5LF1bOEQzfaV0mTFfVUl7Q+hJ+AHBe31E41vR9Hq
	Uxi1m7RBM27VOzNPUVqZ4KbxTicA8EyaAun1p1G4W1g7uvIqnMmHxmnk+foN6P1ki2FkH/wCgik
	qwZF1SvXnQ8MREzobArlQHRTRo4i2+27VTlJVcSo6DhSn0Osw0dRZE6QwoFtodgNKImlS2CDx20
	AlYZeNW8rFLwxZcOtMax8VeSk+cZqZ3IiZb/skHLhyWrcd4tUFGzAZspYzCfklGZ3yrlaqEmDIk
	mNqC/CExG/x8e/+A==
X-Received: by 2002:ac5:c9ac:0:b0:575:2300:9f54 with SMTP id 71dfb90a1353d-5752300a733mr673836e0c.1.1777899619232;
        Mon, 04 May 2026 06:00:19 -0700 (PDT)
X-Received: by 2002:ac5:c9ac:0:b0:575:2300:9f54 with SMTP id 71dfb90a1353d-5752300a733mr673828e0c.1.1777899618781;
        Mon, 04 May 2026 06:00:18 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bbe6d66c90dsm401289466b.43.2026.05.04.06.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 06:00:17 -0700 (PDT)
Message-ID: <ae6dc340-0432-465b-8527-24cdfea5043e@oss.qualcomm.com>
Date: Mon, 4 May 2026 15:00:12 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/13] arm64: dts: qcom: milos: Add power-domain and
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
        Alexander Koskovich <akoskovich@pm.me>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
 <20260416-qcom_ice_power_and_clk_vote-v5-12-5ccf5d7e2846@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260416-qcom_ice_power_and_clk_vote-v5-12-5ccf5d7e2846@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=BcvoFLt2 c=1 sm=1 tr=0 ts=69f89863 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=RcdfdvLsBkETvr5PKcUA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=gYDTvv6II1OnSo0itH1n:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDEzNyBTYWx0ZWRfX5KtRmwxIM8b/
 cbkqKchwBC7Y/rNSr9JO/FXHmQw2OU+5XUZhISE0339dRpOOPStoz2IOUPFuc9LdeQ+Q0L8vNee
 i0r1dBWIBw6My9fhEGKr76ojkDHFJVLIJv95NekmA6mGQM/LbeHqtPRnCdRfIm+zhtIjL49LeF+
 d5sLW7uXsE9YMY06Hd06XYt01ne25RNvkRK/Xadea12/d4rx+uwDOJ+BcNjnFrZ06Y5eIhSinIY
 BgJZwtxrqvUtFrVOcLf/tr/C7AtKMw9fXUYSBVAl633KgceKS/Jj5Xc8eIx/WM86rjnhGusFzD0
 8hNn2x6o27cHylCO8ZI4xLx10n4DZ8f+bCv9ozGbHALU+FVrhMWea+dbk9j2SzTkX9iSskYCJFl
 0dRYgS8x9PN5v4EK2anTQ19DT+6tlKI5eHVrwm58jUjcaACaCwZfr7Aq3KW8W/wPj9x5H3joinP
 wCpGAMWqZ4YYcxyYPcg==
X-Proofpoint-ORIG-GUID: QmwPTW3qyNHYsbyglbGsz5_Jg594ZQFv
X-Proofpoint-GUID: QmwPTW3qyNHYsbyglbGsz5_Jg594ZQFv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_04,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605040137

On 4/16/26 1:59 PM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the UFS_PHY_GDSC power domain is enabled. Specify both the
> UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for milos.
> 
> Fixes: 04bb37433330e ("arm64: dts: qcom: milos: Add UFS nodes")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
