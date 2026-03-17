Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8DF355F47
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739310; cv=none; b=Wikp7VpqiceATo9W5zlcvG/7rrL+dDa9HjRqwyyBAe+mSyVyRS2iupfB64j/TyjxZecHSFc9mCuY7uA3Q89ro8OQPD0vmzWtOYYGYMXc5gHtnOuDwO7rCfS1RkZFq0JxA02DwfYClkbl6qo8E0NItnWZpVPwzUWMenPWjWXkvPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739310; c=relaxed/simple;
	bh=W0ePF7DSyLM6ErnudVAGXiEpWPL8oXrFoEf3HGluwoQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ggzw9r1DU3kBj0NNOyyMSitWQ464di11WmgZ4NO7pWwwz9ZvcnYheI1Q/vMkSjV7dFEAgLRfMcXcDxhRNJCJsL/Gk2V7F9vMC59ehEsATVJ0xPzsxx+73KhfVEDKMU/774g4k+Ri0kZEo9pZXmBCflEqbff7h4AsulmJHsWs91s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pPgtEMjV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EULmuLAy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pPgtEMjV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EULmuLAy"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H2rDhK3124546
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:21:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	iPmd0rGBaUjGHe4gcz3hRnnXTBejiTovEjj6NmcJC8o=; b=pPgtEMjV96R2QJF+
	Mp2JnoKy3zbxErqIsGV1hlz/ZbZpQ/leKgeab/i+pQXoK0u2a7rTfV5d+24R7Qb+
	menIRNxLyiJvRllHbcQbPLfitUi/QbhUePoHqgRXtypHu2RtOh05FbPNCjYXuQMY
	gPD1FPfERvXYWW/tV7vLLPGMAK6T9O8KMReQ9z/vXmqJWUVbLk8nwgMoK7RIN2t5
	z6UvaJrXseWsUUL55LHiM1uGls29mu4fdi0ToX4DRAiapPeTJ/QElhYA+Pnxp3bK
	s+FPr1jr5R9kfVmOTWZ3U3KHlST2vILlVJM9R6Rat9PA0RKlK4bO9K6BuNGg/Knl
	JQUTkw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxfsmmfb4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:21:49 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3568090851aso47650356a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 02:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773739308; x=1774344108; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iPmd0rGBaUjGHe4gcz3hRnnXTBejiTovEjj6NmcJC8o=;
        b=EULmuLAyIfwptrNqPJ4fctLl0pzV386Gg+kW9Jl+fvpcZvJpmqD4+i2HX87fUx+vxS
         kKGnJlW/WaPyizDA6WI7ddA3QxjwXd0RK8WffsZkSXrzI2ZGA7NTP0s0WGlQxjFD2oDm
         d4vYPkGqKcrxi8plQvui5oIzELSpY5pkXNuSNsJQP1TCSRiMbqAUkkZbwbzJLBN8sLhR
         4TTrIfY0taw/kbOdxmQ5CdiHcJT6XWyH7LziTOPPN22MFxxnVIuFm+TbAaU+zLSsG1bX
         uUgrlllEZD9Bzr2RvXCkFKUffvfL/r71a232CxodzvG8hulF1TsfiFvkVJ/B85B5cRZT
         KdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773739308; x=1774344108;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iPmd0rGBaUjGHe4gcz3hRnnXTBejiTovEjj6NmcJC8o=;
        b=l/gN+9cyDvzTcZ90mryWEtDcfN6wAQvp9bTZ1XPa6U6E1XgEeSVAImF7hgSm8RAMpF
         Mkq7Yd6+yBKEGNidIGPa/nfIzFcFcWF/6OCc7itTQt2ndzLCqsDKhUu19i9ygCSg6N8z
         wK68tKF+D1ilI+JKxdOPaewGhK/8tJ1rbPGpDoK378/4NrnqGwT9IwdrXpn2lcdvZvlD
         nMCA6QtpuHjNtxzYQ0k2hkZha9s1dUc6cEZnQ9//aOAShlCTBUHI66zPj4awbvnw+tLz
         we1XrYEBwVWBsNTHx6e2Kj7BiGhTSY6zxgBu/j71r/NpvkucvGUGM7daK2kVCj0wbqjN
         9uug==
X-Forwarded-Encrypted: i=1; AJvYcCXs37M3MmUGU6k730H2gYRJjC9D9/Zto+a5Ma79hgIVT6tL+RMygRUNt9bmD3m85VtUuaFUCkXcq0yu9/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHSrtpsEqwWbrX1fD+FX85WDhOyW0Ibv0OTvCeJiTtuoGbVYYt
	IPBIrPdSnLJW7j6+dqiO2Z27LRKBvvjXWHN27DJrDXgd422QncgcY+sPhEVeJrTYpjS1upgpjH3
	LjhlkC8USdJaUIS9MTvY0GQvir8L11Bzsdp9dH/LBVyIkkCEWfs21FIx3wWClURSVQktGfotktG
	c=
X-Gm-Gg: ATEYQzxYWPJiG2E3ovR2MwloKfbcoBQFpgd3pt8i+jiLzLU/OCmHliEMAA5P6aCrSyz
	LDpZ1IbCx+GZt7rdHBdhiM+ruxOgU77YGwDwZRh3h2vvH80GCaKJUTfDRNrJuISkacZGQmIy0xi
	ZjlGca7vfotTzQQwS+1f75rd80seN3W/zz2mKQ4scurjcvXyh3N9kkeCzTj0Ac8/MvAafuMLE34
	9+Xr3x9F7VF4CgdxiQ5YKWnRyH/MBG99PiYE4xtdr5NNIL+sQiE4gZpjMjVX6h6YEpfFk2T6IL0
	2M1Lb8lboTfy0WWLvOTqjrkhQtCYDuNAUAFTBGJdRcIcsUogZfmRxw7re3vNoIo4hQZ79YpyA2V
	XQEMsPIOyG3JPAs1Wo3Z89ziYreuRI9UzPW7vklNE8iB3DFI=
X-Received: by 2002:a17:90b:384f:b0:35b:a44f:b82 with SMTP id 98e67ed59e1d1-35ba44f0e61mr5134685a91.11.1773739308344;
        Tue, 17 Mar 2026 02:21:48 -0700 (PDT)
X-Received: by 2002:a17:90b:384f:b0:35b:a44f:b82 with SMTP id 98e67ed59e1d1-35ba44f0e61mr5134632a91.11.1773739307784;
        Tue, 17 Mar 2026 02:21:47 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35badbcdaa6sm2331968a91.15.2026.03.17.02.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 02:21:47 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 14:50:43 +0530
Subject: [PATCH v3 04/12] arm64: dts: qcom: lemans: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom_ice_power_and_clk_vote-v3-4-53371dbabd6a@oss.qualcomm.com>
References: <20260317-qcom_ice_power_and_clk_vote-v3-0-53371dbabd6a@oss.qualcomm.com>
In-Reply-To: <20260317-qcom_ice_power_and_clk_vote-v3-0-53371dbabd6a@oss.qualcomm.com>
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
        Alexander Koskovich <akoskovich@pm.me>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773739265; l=1453;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=W0ePF7DSyLM6ErnudVAGXiEpWPL8oXrFoEf3HGluwoQ=;
 b=Ke72qXA5huMugw/wMSL3AKWhmc0biYEYdBMY3hvTw6Ds863BWT1nbEIa5Pr2+oc132VZ7/FmF
 J4BBE7XQ23VB15DpKfAziVH/e0fJs5XRPXdKraQet59QxS0JRKMFy+G
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA4MiBTYWx0ZWRfX1bsg8/zOh/MU
 SP1vvzq2KvM3l8TkG/zj//s1zSMu1+huNKDbgk6bk3iJ00pZZ8r2xXw6X6TZVT9yblK/9d57ACF
 FIkvE+ZnnOc2tjn28cadNmqRMIVLpzkEjJ37rF+jUGsdOq7qgiNsl1f9Ya8HU4xOOTLtXJTVm/j
 S7mbc67rhyWKXz3K0vBKSVtlMDuIH0Ng1R5H3ubV9icf+kwxBQRn8chhUiwt+ufGo1saO9V1hCT
 l7tyTzAfQt1giOBjf26hjffFujXDMqCYVXyWUmO95cY9gpdqRmxLrxwQNK1UeJCieQ1oEYUi4KQ
 JnVaVM+GfAqrfLPxGs4bTDmp267OQTDwNcfysQ4ExKzX0UKylHR+Zr+VEdj0eE8mvYzx1DZ5T9p
 10V9a6//tbKZcmBJrIH2MvvSf2/wjblFDNIAy3hM4KcLfWwMLGBRqsiwZ2ni4hhHifYEAGbaFcO
 gGmDgoVVbcJOA67FrYA==
X-Proofpoint-GUID: 6UmVbGM39QzGYZHeezwXQQCRjoxJujTA
X-Authority-Analysis: v=2.4 cv=V/hwEOni c=1 sm=1 tr=0 ts=69b91d2d cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: 6UmVbGM39QzGYZHeezwXQQCRjoxJujTA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170082

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for lemans.

Fixes: 96272ba7103d4 ("arm64: dts: qcom: sa8775p: enable the inline crypto engine")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/lemans.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans.dtsi b/arch/arm64/boot/dts/qcom/lemans.dtsi
index 67b2c7e819ad..cdfa42293022 100644
--- a/arch/arm64/boot/dts/qcom/lemans.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
@@ -2758,7 +2758,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,sa8775p-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

