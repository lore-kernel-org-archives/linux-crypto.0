Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD423A63EC
	for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 09:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776764338; cv=none; b=P6K2coG5OoIpb5/zjGXao1ZKwJFyLtbWuLJi7Q5Ws3P7qDKsPFiSUQFta/RCw1mlKjfVntQ1Bul8vJrqlyxIXm3+ZbGP+pSjh4DkTFVipegVMZ6Oa5YyqvVQ5SX72SazLRarCaVhzenSDPXYUEnTAuAnlHHALI0K7brw9LBwhU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776764338; c=relaxed/simple;
	bh=u8DbJynolgW2SvOQbI/uVBWstmdlEgoOwuda/rhYsak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H0DLGGsBTnfr/kKqxMEOYtwXOcaW2rQoiVh/6UTw9HA2GJ5Cm1S9RRikTYDMXunDchJBQ4I2j9omWbFNZzcjhsKBF9FtYOPjLaSkW0DOmuQemd1Z4nG594gVQNj/Fw6O8VHgk5kVQ3Ie8RdBcj6iXaxzCYrabchRm6GWRXIT944=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nUAcNvzE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Gr9wc/O4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nUAcNvzE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Gr9wc/O4"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63L74Cbn1538414
	for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 09:38:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kuKADIxglKVMIrQFwjDtiXbSvLedvlz6B84TW8OPMsc=; b=nUAcNvzEpKTjV782
	cEUuOOhtE2u5bJayd978sNcQNtB12tl0+IjyDHVZ9XxpYaBaD70/NHBc5xvo/nmt
	G8NaVwywC81Zhu+CE7U0WoJPhtz+RF+1hXYDgMh6eM24JP4P3FVXr0yR77PjDrH8
	DDihjoakKxpSfdBoVDfEzC6j4J5b2+0LJADkkJUNzPARjtimi807YDgCCs68K1fn
	kNyL2LiDEfSkWCss+j6Yor4PfJn3mMUPSf+BVw/7GczvhSnMXqQozCmKRDc2JZR9
	MvKJh0vHjxFgnjhvcC0hb3Nn+wnhZeFWaKnA2s1tfXQnYkKQpuz7JD7ozrZOoQMG
	nLO86Q==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dp4hagkcn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 09:38:55 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-82f9429f49cso4608847b3a.3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 02:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776764335; x=1777369135; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kuKADIxglKVMIrQFwjDtiXbSvLedvlz6B84TW8OPMsc=;
        b=Gr9wc/O4nOxGeSMuwBs8M4zTVfwN56jKYcY/gz3tY+SuBsYB2N0yJuTx7jYSjwtog5
         8lfMUnmyQr0ZJ0mPQyn7o2mRjFs+EJna3DcdnIXLlOG0w1J8eMSQxEmTURy8wzgIvXEU
         vqSonwn9Vj8IS2rh7Mu0hdt5rU1l/HBuZSir71DoiMqkkkWXk6KCCIfSPwA+HUMFCSE9
         TpW8P5LP/0tgILERJJWuEMrclQ+N81cqfD2QJq99loBdFux22lL78Wgbgo+xTdxM+Gk4
         pH+Z2geDK+Gsrtx8oMhp9WMmMDeVLF004OjBO1V6mb26ECy5vwvy6FHjKYgaBpMfqBXe
         3IAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776764335; x=1777369135;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kuKADIxglKVMIrQFwjDtiXbSvLedvlz6B84TW8OPMsc=;
        b=QDGNUMAHDDTkI8Z0nsYxXhSH68wfaaytWbnZqNn9CtElxCy//p/31+PwGUz8vZhtIA
         8J94vfdJ7e/2SBpvGmpr+Yndi0+LDLv0Imc9Xhnn9e3KjzdyW4ZzmgoHHkN27GQVH9iT
         7dobJZphNB0WR4srdWo/SdXlw5KtPR77CbLJ6fzl2hAIQTDjefIsa6z51wlS/VM+f2WG
         lPDxCu+ctdua+2IbXFMagt4Fn33rpnkFtPOozkvIya3dW3d0Vn47KBTPfGuKkeaw7eNC
         AsDD9fHnjzsSJSgGu1gR1FuE+hNPw/MiGKc/N0kC3T7rtZsDwgnTwhVVO2WoOzXHaCID
         iXyA==
X-Forwarded-Encrypted: i=1; AFNElJ8NnkyjNVOMmMh8WkeBxeaDniWTeNVJNYxUxUGOjyu56jp5AERlTtj9lsoieiH526uTtVYao3CAdgtvV5I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhFrVUkscfnHy7FHHNCP6Gb5ZBWrWaG6Qwz3KTlY7TytpdDXz9
	DT10+3T+EaeSiCiUJMDGDGIXyn59QufKlOMb+g+WMw0kjcQkoUnjhkNpkO4c0NkxKatFk1Oz5LR
	JkxOtEBLlrXaXInpNOieFhkjkzVQz5AAYg8uG441JYP8YtYcZw75NTbNfQjH5/dddMiA=
X-Gm-Gg: AeBDietj4signBMzpbFMSqENDns5rkzsWF3KTztfjQ0Sugi286bfqx6+rc+p+XVJaNf
	msDOBT+R35CcyYzYzeBoE8XnYUw+cZjUSrn14tOF3iM8b5yvhHu9xLpwcmcHGOTsy4Vxf5Doa7n
	cwh/BGairojq8CgTgZkRmY+EzLeJ3m55adjKnLnOfAP8ATNDi2RVnMY9GY7WY+ynkxjzax0eOAr
	M1ok6N/isKK60rr5TMuTAGRZt36GSewl+0y1B2X+9pEIZJsondHT4ysHY7wV92QVgH8Vk0CVNjk
	8tbmiH3COiiTQCbQQQb7EhRsxVjYMKvl+3sxFLf5cAAynKT05+8I/83zUG2cebyuLc7YBO5GgYG
	Gfv/97skFsoW5j2U2UWi/h67qKS9nd/66u3vifRd507eKp33JahSwDPhG81Kaqf8=
X-Received: by 2002:a05:6a00:e1a:b0:82f:2a78:6302 with SMTP id d2e1a72fcca58-82f8c9027b0mr19301345b3a.26.1776764334975;
        Tue, 21 Apr 2026 02:38:54 -0700 (PDT)
X-Received: by 2002:a05:6a00:e1a:b0:82f:2a78:6302 with SMTP id d2e1a72fcca58-82f8c9027b0mr19301319b3a.26.1776764334499;
        Tue, 21 Apr 2026 02:38:54 -0700 (PDT)
Received: from [10.218.21.127] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebcc9easm17161300b3a.39.2026.04.21.02.38.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 02:38:54 -0700 (PDT)
Message-ID: <e9068e98-1d6e-4cb8-8885-aa5831407b3a@oss.qualcomm.com>
Date: Tue, 21 Apr 2026 15:08:43 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/13] arm64: dts: qcom: eliza: Add power-domain and
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
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
 <20260416-qcom_ice_power_and_clk_vote-v5-13-5ccf5d7e2846@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260416-qcom_ice_power_and_clk_vote-v5-13-5ccf5d7e2846@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=bOQm5v+Z c=1 sm=1 tr=0 ts=69e745af cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=oL6z003X9diVxq0giesA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-GUID: QqbQWSs_HdKe19e7KQ_0VIA8W3eVsJYr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDA5NCBTYWx0ZWRfX74qG0VnX+jb8
 E8FD/GoN5oIn02SmzUexZrIqDh/OL4OyQNhrXn6UwbdXIWfFpjGSr1Zz8/cBS64w4DxDlUdR2pp
 FnXlqZ+rMeH+EJCad64uN5seRXp/MH5lwnSQHPbxjmJWDwLNcQ6nRETpzjnnTW5h2AppqO+Jd4i
 BrsxzFa/2PBrifpef7iX5TilkngqAhDBmuUgqJNC3IdcYth1uCVM5vluPxlJGmYucnJAMHEA+5n
 KxSFS1SQ3/LxxVrSBorwV0WdPbQW+Lu2Sej/Kcjx3bQsGYk3FbXse60k8MiPyaMz2ajFwQJPuZO
 oo5haflwb+LYEN883gbN3/KcKfBzcpMa+ljKFb5yJxbwEVat7YS0kTr9J2nFZDxIpt8ZIkQjMZo
 kknws4kga4Wv8L3SMb1q26NODu8/z5/w5a8IyakwpMpiJK+/c1sguqCAFNHAXfFOJFlWl/hjria
 Uonnl/rp9zPUOmNUHlQ==
X-Proofpoint-ORIG-GUID: QqbQWSs_HdKe19e7KQ_0VIA8W3eVsJYr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_02,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604210094

On 16-04-2026 17:29, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
> GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
> eliza.
> 
> Fixes: af20af39fc09b ("arm64: dts: qcom: Introduce Eliza Soc base dtsi")

On thing I noticed in entire patchseries,
https://docs.kernel.org/process/submitting-patches.html
"""
If your patch fixes a bug in a specific commit, e.g. you found an issue 
using git bisect, please use the ‘Fixes:’ tag with at least the first 12 
characters of the SHA-1 ID, and the one line summary. Do not split the 
tag across multiple lines, tags are exempt from the “wrap at 75 columns” 
rule in order to simplify parsing scripts. For example:

Fixes: 54a4f0239f2e ("KVM: MMU: make kvm_mmu_zap_page() return the 
number of pages it actually freed")
"""

Fixes tag need atleast 12 chars and I see other submissions specifying 
12 chars whereas this series specify 13 chars.
Not sure if there's some hard rule on this.

Other than that,
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

