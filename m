Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844303E274B
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774349329; cv=none; b=o2bSKkyOAxScd8kgqV9X1pLIax6TTo+sQDks3tivQsAS1hFuIK5bF8gGnYFnydG1Dr1Zu5rQeEgg7kKzwJlpv5dKRMulIRtT/yfVkZcgBeZOdx5oSz+BRYXW3RLL42qBAEx2blj7nCOIKQooiHS5YQxSbjOWrFV9xhJ4mtr1BEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774349329; c=relaxed/simple;
	bh=TIDLuJixDy7nE6oj0Vl00rtDfXrGu4PvCUbC5ZIRtOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jaLvdHrj+ZicpJaG9FE0sCfP9gSgYnsJljz96tpMsbrAxjmuXdNs/vUCGzPCabWCjp9fvFq8jzcQWtZ9UO0q/Ai8618tcY456NYGAhtdDh905re0CY6mqGUw63qpPy78uKS0Gz/mJwzuKuG9fGyPtdgNCOCWBE5pnK4ygbF+Gks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FuJiuQMW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Rn5iEzUy; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FuJiuQMW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Rn5iEzUy"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O9dpcw1762212
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:48:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GLVuENRko+ibijIwPTOuvDEu/CuRGqmpW5X9Mq+oXc4=; b=FuJiuQMWTeRoiC6d
	IPC9SZ16Yi2AWasuZzvvZERkFxUuG1oX25BZw91cqZ5dZVGDzHD+ChD1RnTYG+aU
	7jARArRqzAAoloXhdLNlPdtOUn0BYX3/BjfP1NyWou5AjSUWBTMh4GD4iL23/pvu
	+B9MdjL11IHsVx0q8lY9BFz6Lk8UOp1kL8wwRUvRtipzWh2djXky6sGdBIl9mwi6
	IG1SjKlPbga+eonl6o/93X+hpjC3yErkIYGlNcQ68LhHx2BW4XA5qZ85VGgj9PO+
	oKoBuSpYTLKxMkGr1kHXlaUpXMcONcwJo6JTnGnQv1oUZlwMvBWpz6Q5tm67KB40
	updIQQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d36f0c3r6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:48:46 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-358e425c261so6399209a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 03:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774349325; x=1774954125; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GLVuENRko+ibijIwPTOuvDEu/CuRGqmpW5X9Mq+oXc4=;
        b=Rn5iEzUyjotMu68IKTHdqbYXeEi61TeWPAb5XSctMrZJcmuY0j5Ge/TOT4F3wE0egw
         qcIqz/RNTdp6rLrdszKfRPYDNxDZjl7FJZ8C1lqmAVUJEJSxIawXrQuvGR+f8Ub/VAxN
         vtQ0HbDbPEFzau9BLJ45bsejdWy5YxwPMC4aYGGetH1WqbTqYCVLWU4OSq0Bfx1zwt1E
         /JrcePfoa2jiHGeR2nWWbDfPWO5NOx7xYIP97PYTW4jFo0r0PlH1Req81hrQw9Us+RRf
         iujcp5wnREiksO9lYkUHm4s/T/5xsMjunMZtpgPPme8cmVh5UWQc+/MyRyqOgxgJNPqc
         XDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774349325; x=1774954125;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GLVuENRko+ibijIwPTOuvDEu/CuRGqmpW5X9Mq+oXc4=;
        b=OS8WUqCU6i2ZtGTUxJko0l59QlbRYGxEFBiRy5B8ZxxaoW9cwQHpZ2xQD3wI1unm5I
         Y4/zkdPDROVu4SH7JrY/Lbz6u4V9xAsaIfLahtcVna/+xiNljNBlChg2d4TcKfoGzLT/
         hKED1xxlf5GZ5pldKlQeIeC9bmdaVPio+QQceYYOQoeLWZ61NyJp0iaSoN4/h/jqXjxv
         XFU/xQvT00azFSPUjLZVn52kD942k/etyfAOPun4UBFT/tOyIgRyHXCLStVeSNk0F8kd
         +6GDrIgEENR6Rmda2PNAkxcoxHCamvT3EQ4vb45rtoWF5WJHGkWZ3uaLLkXfaNAhMKFC
         qihg==
X-Forwarded-Encrypted: i=1; AJvYcCUMcwMTAz7JHD+gGeDSsr3GPOhU5CFFM2I6o23iAZVTB6US7l+bNPaW5YR5o/JJ/tcV/fS9yQ1A7KyNqw4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHKR6f6kEwY9Vy5CBdvXAbf+CjMKulGupNA1AfVNJ88IxmAM6u
	HaWi+Ihk6QKiH7z8oHKZEgOElbenBjy+kZyCq90enar18wYcJWOfXRkLNp31ejhc4AbT/GICrbg
	TVeH1yd2EqldI2zQuk9/bHV+OUOHADsp+yi8MilEwlfxFU4Xy1XQ0qab1Mi/XsNqXMPo=
X-Gm-Gg: ATEYQzwkyAFJ7pvE2lEGxrgHRi3CWp25JsUCI0YIllH9TIryVN9aD8f7HPdiXfBY9Do
	2mggDVzv0paRcltw8O5IRwR2izKCpHfu2kMPcDse8GTj6uSOnzfn6N8gnC2T7ycCxzeBgGUjGMY
	rOBzzypAQi8l59iPUgjcNrKl5za/Y4zunuHBWtOZu8OpxlKI5xOSLH3IH5fNlM2PjVNP1KsA5dD
	T27NxX0pi1E/bmFuWFJN40/OSsgM2Bvs1k7hTh/lq/aChozeDe4gSi8CAj1BqqX9+mJNTyTrB0B
	4ZWPNg3fwe8pfEJVT0chFvW7o929A8f7XHV3XwG0L1+sh9Rcq4uIBoJKP9gs2cvfbDVL48+nTG8
	DA5OWE0TLgy9KGsmxlw2CLTIVAscW/j2kSBRnJfW+Dp6E8QDsdl/H
X-Received: by 2002:a17:90b:4c4a:b0:35b:929f:7e8f with SMTP id 98e67ed59e1d1-35bd2bfdf2cmr14076714a91.13.1774349325263;
        Tue, 24 Mar 2026 03:48:45 -0700 (PDT)
X-Received: by 2002:a17:90b:4c4a:b0:35b:929f:7e8f with SMTP id 98e67ed59e1d1-35bd2bfdf2cmr14076682a91.13.1774349324733;
        Tue, 24 Mar 2026 03:48:44 -0700 (PDT)
Received: from [10.218.44.178] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083516b96sm180029935ad.7.2026.03.24.03.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 03:48:43 -0700 (PDT)
Message-ID: <1abe2b24-dcb4-40b0-a32e-94cf5cbcc7aa@oss.qualcomm.com>
Date: Tue, 24 Mar 2026 16:18:33 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/11] arm64: dts: qcom: sc7180: Add power-domain and
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
 <20260323-qcom_ice_power_and_clk_vote-v4-6-e36044bbdfe9@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-6-e36044bbdfe9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=b+q/I9Gx c=1 sm=1 tr=0 ts=69c26c0e cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=RcdfdvLsBkETvr5PKcUA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: M8PsquOe2QgBZJHeeuhw3kExed0_BW5m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA4NiBTYWx0ZWRfX3O3582iYwKNT
 l3/cppClYuFkfsS0oXm8K4ouhnadnCyXaUgJHpf8QEW12huMJ5NNWi1U11IzQsFZeFoUdNqoJzG
 KslLdYnSM7K+CBRjfBda5UYYJB+o0HTHWXN5m1rLdv8hj0cJHTyejTeNpehkR63lAw5ferq39Sj
 KjLBDz65Sefxos80dmHzZoeQCvpq/P+jzDlwGTELgxZDHvKqxAxImVpSTOrCd9AdVeI88y22HCS
 9MRe8CGtIie/6BrtgEsJSS8PJG4Fovs59k1QwC8IGLG2AufUk6LfclazIvhV4MjKQ43zWPeYe+j
 qPTNGZd8ToQlqXzUFuxvhewAZBPqf63JGldXNrjdUfj+3EwcxKn92+U7S3hp3DCqGe8W6sXOhHX
 izGxDP6TLTaf+k2LpRWbsqAQdIntCJqykpO0MSjoS9tdCkKas7WhFNW5F4ljQNowhK+v+6sxO5V
 LiY8GkpVK/I1GjG0xTw==
X-Proofpoint-GUID: M8PsquOe2QgBZJHeeuhw3kExed0_BW5m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603240086



On 3/23/2026 2:47 PM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the UFS_PHY_GDSC power domain is enabled. Specify both the
> UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sc7180.
> 
> Fixes: 858536d9dc946 ("arm64: dts: qcom: sc7180: Add UFS nodes")
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

