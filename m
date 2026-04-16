Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BA42571C7
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340834; cv=none; b=e6IQlzI7IVyL853JlJU3xnlUTbeFSE/g+MDDXkOWdD941/1cRZVLtIRD6OcETldiQDV9/5QbwXcM5iyykN4yepCw69TEl4e5orPl/w6yxdyzuwUPxKpSimztEJcP33KZLM8VRqSJb7sgB9NPqBQTzHPdJ5DTI2JFA+/XHT4bvjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340834; c=relaxed/simple;
	bh=Hlr/X1jpHVRbaIJRwUKkEuQoVBfs2TtNCkWyFOX+H0k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tXeh7vcZVCMvZM7aLqw3RbVDiH1K4vj9Ql7YFaYzZAdPJP0ekpgVmhS+4J1Wxg92TjB1uwQI8CSRxPYtlOgJlRr12Tq/hLzGuTDj8DftUgfpLxjM4o5cPe03OBKlR4WZvbfnypfyJl+suFvB4Nov8xzXAy4qkqTf7pjP9EXamF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XIiuIxU4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ElnSdgxE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XIiuIxU4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ElnSdgxE"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G8WZKR3089340
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	75vHHvRKh5QqiO/9HH7clEC0d88m2FYIfhh7wjkOHaA=; b=XIiuIxU47t7m/G2e
	kcnb5/TgVtstAGoQvzeFt51q1g4YjBGqEh/23T6wZJq6gydUbQQxXSTxEUC0ih/B
	9OJ5Z2wuL6RxjB0zw0Vd7qMTiWn3yLdH38gGmhVj1XEHeZRwERTkFWDV6X3j64aE
	I7urs//UNJsbCtVfnvC3ab/4WFNKSF3J+0GFmFYT/d8eoOJt8H4lRBnEZnGwuwxe
	RbIQbE1zGNt7ez5AYgTEqFlypbNZGGq6YsWDeEbZgyVpFymbSvvfBQHtnntvTqaO
	dXw1+9C7jdKVL3DHLgzFhFpGU2XG0SI9vwZrwKtKI597oitN+NvkWebfl7k8PDPn
	0tVHrg==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djp6aa0h1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:32 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-82f5f48458eso1303437b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 05:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776340831; x=1776945631; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=75vHHvRKh5QqiO/9HH7clEC0d88m2FYIfhh7wjkOHaA=;
        b=ElnSdgxEMZ9jsrDvwJv97cKr6AQD4g9x2QZYszKPgKqfyuwYipXxolcBC6xOFmXUQ2
         KkCOXOQWnZhoJDXa0++c6Rc9hdsOztTR1foTJrEVJmM9yfI40blwnr7zQH3alQ4+pEqy
         AIWM2RkP+GBGqMKhF4UJkr3chqGvK5sm6Z8KUBZCakv4uzpGRyg/A6Y/ILbyMajcLnxb
         afYr6SyC3EPr4odvexB9nO9hceFY6lGf7fMTC5PxUjLvYyqMeq0UsvOCGHaBqCaEjcy6
         NeZZyKfjfp4xwX+6yT2vAFm6KZzheWqkhPSpKCZPAvpO1+d9YLREuV4xYsCI4fSNGcgY
         eAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776340831; x=1776945631;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=75vHHvRKh5QqiO/9HH7clEC0d88m2FYIfhh7wjkOHaA=;
        b=M35h0gSZJV4k+BcfYofCnKoa55Z6l+/gNHzOQSvbvBgXPtGR23pZ5iogJtJJewzBc9
         F0ZFpCYjP3XqfUzg98mnzYbk3GTd4vlxRwRlALWu8x17RuyvGNcwFdtSVi/3OTPrvGZ8
         Kz3SRARtikxAwVn+45rytoxbg3i79vnTHp2IZGYI2fP3e++Hn/mAm5ZAMzlCHpbcxXBP
         aYBn/h0r0lUCGh/xRFf6G9LYgLyCeQXQFCG5OeOd1LhrbEaXh/OaFgFYvoZDB6a6x647
         nV439W5GO2MB+bqzAaRcBx0cQRHWDr1hVLYUUSD4UzU50ThCZuNwldqyfOJphgIn2qfO
         r+Aw==
X-Forwarded-Encrypted: i=1; AFNElJ/gYVcKrE8Vs6wv+Uej60HGHRIWtVpL9fHZLP+6jCM0I2eVfiegX/sqwDQBtsL0bhtW6+q1JOZwB+4rX6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKywP4HdxDr7Upkp5KRIDIEaRpRtS1yZR2rS5mH8h6djYHzFb6
	JC1QfZZ9hGZY2VqCfiETGif7giSjputp6PxI1Ylm9TTlcOWvgFW8jTFPb5oQ4PUpzPidq2EJgXO
	X38w+0J3aRmcvaPrRVLS+MBq5xa6aI76zuQ0CApUvH01yKClG6KNQye2Z39+6l4CA7Io=
X-Gm-Gg: AeBDietCy0e1zRDQzc4odwjrH9DtHHbNXWnMC9ZvpmgAGAj2wgzTJMErsBXMnYxJqiU
	Zf0ogBJw+3ADemEshKr2mkCkIwmLo/ycqRVsvm2ZTQw8zSO6RsoH1J/IAnpScstclqzDQ/QW4iC
	93PZ8biAhg4yKYjhA0gMHT8IvqSleDFw0+XPQ6T0DBBJCmAdzQ++jL21NjQHooDbTyP2Y/rrVNr
	r8OeFZNeM80j5eVAescpssy/Wul9YhVVX1a3bFsd9n60/G+basXl6ICb1cAyRO7wJHvBXl6JtjA
	AuJhQfM0UVh2MOgrSczslRpAZauDf1V9NItZbZfCQPWqcHF5FYGbLMym8y6KvnGUu10oPC1QCyX
	f1fi8Hqi+pMuOBjM21gILjT7Li9wZfUVQ5WdrFlM3yb7Gi7Z50BIea0cBzw==
X-Received: by 2002:a05:6a00:b80c:b0:82f:111:7e60 with SMTP id d2e1a72fcca58-82f0c323e1bmr26983965b3a.37.1776340831394;
        Thu, 16 Apr 2026 05:00:31 -0700 (PDT)
X-Received: by 2002:a05:6a00:b80c:b0:82f:111:7e60 with SMTP id d2e1a72fcca58-82f0c323e1bmr26983909b3a.37.1776340830676;
        Thu, 16 Apr 2026 05:00:30 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0f15sm6335937b3a.35.2026.04.16.05.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:00:30 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 17:29:22 +0530
Subject: [PATCH v5 05/13] arm64: dts: qcom: monaco: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-qcom_ice_power_and_clk_vote-v5-5-5ccf5d7e2846@oss.qualcomm.com>
References: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
In-Reply-To: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
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
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776340775; l=1577;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=Hlr/X1jpHVRbaIJRwUKkEuQoVBfs2TtNCkWyFOX+H0k=;
 b=zFyeQLK3DLVgiR5gu6pCRZC5+dp/ErhpmDvpqGo6E2IkbAquIt88z96g7d+DygajjIS6u7RVK
 WGCJQzkPlupDsQ7PGqZW3SnMujqYl+TqRcantn2qo77qaZV6FzUhVO1
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: T5AbctBcEl2pXuMSc113qqcCdiM0Kj08
X-Authority-Analysis: v=2.4 cv=NuvhtcdJ c=1 sm=1 tr=0 ts=69e0cf60 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-GUID: T5AbctBcEl2pXuMSc113qqcCdiM0Kj08
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExNCBTYWx0ZWRfX636cyXw5cU1c
 fcHmsDqKDPrVV7xPKdiXMmDb81gYdUhirpSrInQ9Ws1ZZllPc/sV/KQ5J9d9f/Rmy0MfNLVD1mZ
 o0D9az0W1Ya4tOMJ5SgMG+zo5n2AsFstuVOyu/4aax5F4UT1RC+K5zhVRiIVQ490a+25s/+rj6N
 mWk5YGYtvU/EI7BDOd8tjIFMEUVAD0hdP1OClsGL05/8tjbmER43BQFLCVKOzyWJPcSvMl2BqGD
 AXjSRsZ9e4RZvRB6swyt3iIg6Wa2HVbUoyBW/IOtNClu5fYK4m0wM4bdlx/hF6+kUkpVwA7QwDk
 F1OECrxl5uKqdaUvMlqWfzOiFxs0kPtTVb/d85tAYE6w8U3jxCcem/Gj63/VPDI2uQzcbuPFPL7
 kbuBZO29L5hEk8VyfS8EbUhzJEW2qB26mAAx1bv1Qxe5Hka/O/KG9YZvEtGi24nL+YwBr4OU/W+
 IBmicWcUnRM+qn4QPAw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160114

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
monaco.

Fixes: cc9d29aad876d ("arm64: dts: qcom: qcs8300: enable the inline crypto engine")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/monaco.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
index 7b1d57460f1e..fa13210fc539 100644
--- a/arch/arm64/boot/dts/qcom/monaco.dtsi
+++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
@@ -2737,7 +2737,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,qcs8300-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		crypto: crypto@1dfa000 {

-- 
2.34.1

