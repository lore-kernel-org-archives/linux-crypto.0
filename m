Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C763B38A1
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340902; cv=none; b=KB3l9/AlQvLXQJf2p/nBkJorIj+ewLaClvv+VUbzAXpRR7I5vz7i4a++fjt9FAu6BwvqBajG302QYEjja7pc1tKqwhl5BH/msSMAORL9/LMiXLFHhBB649kVsXicRvxvEwjgPpNzjF9g3CEyXeBzYbDU1JMxmpHGqWd6U/9uS1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340902; c=relaxed/simple;
	bh=PQIwHe0X6J+SePUM39Gyz3yRIWQ9APF+TtzVUvY/U7k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Kn3QCooG0Bwm4CSVwoE/Ll97+CHawkMD1I/56o/6EaE/lUDQCfV6koVnMEsXqlSkRQMn0HqY8R6WxAGO96riogbO5f1/rjUL9uUqaxwjh5SwTy0B4MIglmbMgteFlabeSgY69Mbx5wLE3jW+r302oRVxtYYZcu2oDoZjxM5562s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jB9YQFM3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GQfVJBgX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jB9YQFM3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GQfVJBgX"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G8Y9xL1702344
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fueCHsyAjRh96KbAlZA+/8APHV0qXG68Cz2uoDsQdww=; b=jB9YQFM31h/Xptr9
	G7rg3Z1YhOmI0+BLx/JGgWZRfX07wDR8WjrxJHaeq6lh6uWQz24yCGZEajh/0S/1
	pwPB+TWD62ZwBOhrYXdv2SkM5413s7hlA3NmQsLbHtYc144Ohj+cqmLoSLHwvFp9
	4/AxJFnQw+K38T2rSvvh+ju7yEdUnr/61wPbxxspNq1bg12Pomd3qX3X3wkUdqLH
	bn1W+bkI+M2VBxEFiACNbKcCQCPJpsK/baOZ6SZC0lYF+qB1WrOgFNFMODej1vJl
	dUGX6wXZiBn0l+Iik30of0lsJUer/VLilYoVCIrIRxOL4mvM8qYwk3H2l4Akjf3s
	Wgm41A==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djdamkpg6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:39 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c76b6db8bb2so4712665a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 05:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776340899; x=1776945699; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fueCHsyAjRh96KbAlZA+/8APHV0qXG68Cz2uoDsQdww=;
        b=GQfVJBgXqiyUwdY8FcV8Q8aUH+e1i8sm5tUa17sk37cUqHwZmvZLMHz/CTb+484kns
         mIODt34YCPov7wjFwTusChliqMI7HL+CI1lIQSXgjvXpJsoR82JZIh2GS/SBhKnQNd7V
         eHwX8JcYxe0GL99X6ffS/J1mh/Pq84BMOrZfmfIDhsPJD6MZ3Qjn81lMmTL2WIos9cQj
         Pm6TEsnXbdSqSnMcJe0tvXaqu9ztBJEliv5d5VGwVUafTVBqzx0+RPmRWPXYHaxD3jm4
         erRDV+givhlKptaO/68IZC7nAtouRlrhwHkLlMgDEvrgUwTcX9Nu/Igela6bLqkoiiYG
         LDnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776340899; x=1776945699;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fueCHsyAjRh96KbAlZA+/8APHV0qXG68Cz2uoDsQdww=;
        b=Pw0RKHt7IPifAMOKq7OyDzYfHs/L8AHlyWTJ4i6YmsYcQnbdNGdWO5JGltz996uUv/
         CaSsbRoqRXd8v/ndrc8iOfJvD/UYWZUIGA95y9uPUdigLSnWsDDPI46UE4i7hrkT78mA
         Xxjlj3W0SQezMiBuTcwRUin2Gsldop+mTpczTjYSPRS7O3At3aUCopmsAM+FMTG7pgsL
         g7CWcjWAj+te+N7OtZiG9D5w403x4BMliC98+y4C5WKr/ZJKOEe8LwJ8bwlnEeQOcO8v
         A4DMqGGPbeOlxXPFPzs8Edc8I2kn+IW3uw2T6+Z2IkiPqt77JtaceUYgDu0/u/4qaFQe
         V8nA==
X-Forwarded-Encrypted: i=1; AFNElJ9fnYYzWecISpGoVapgtnKcDBmcQ4CJjelde8Gt6D+Y3C7dxtBaos0e8/7KP91nDi3tDgjes8s0qCDmhuk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEjo0h40i9WcANCmpwcSHOT6nv4U4C5bkpnHvulwRH5UO9PeZl
	CytNCWiTyCBjdvDZ4vwXVLnWYPQR7ZYdABzxl4YDnMo1wtYLPuY9/S5SC5+Wevq6DiQ8qAB74qf
	Z0hZRPZ8GnkFtru5tIcb/ZRzEb2D1ypBp/tYXPoDP+pSRMEVInMop0twxM9l65DN3W4k=
X-Gm-Gg: AeBDievHubCHmgN5Y6g58nwwp8g5csCssn57es5Hs5KGwCQ/U8o/PVq+JuAWcAc8fBc
	BJZvQm8A4nh2veyPMRngx4IL+KYJfsfxHg1uisLjW0r6aYC3x9eKwXN+5aIz19pEWxKWgp2vvpS
	QoZd84NwJKLttCx4cX0w99vG1sYGH3y+NjLgfViNKOK6UyEHkr1erCbnbCWfwOIyQ7kNBMkxoPV
	DptzEtXv8q33HvJOGV/7ef41BjhwxSBhkc+zFmHJUwrx3fawtXeXVMwe5NFOsYFP+sa9kfUlX3o
	D3riWNTq4BQNMSLutIaJlco1WVMojHFJxwxfKPjVKSZOPzW0U9xk4x6dZujWdPQ/ltzDY0w2Axq
	XREmYIdqEuyDv825V85Y9laPCdJY08RwowAv+IkGYK1DbBp4bMSRxnfUTfA==
X-Received: by 2002:a05:6a20:3954:b0:394:3001:8b59 with SMTP id adf61e73a8af0-39fe409d626mr28689707637.53.1776340898589;
        Thu, 16 Apr 2026 05:01:38 -0700 (PDT)
X-Received: by 2002:a05:6a20:3954:b0:394:3001:8b59 with SMTP id adf61e73a8af0-39fe409d626mr28689585637.53.1776340897666;
        Thu, 16 Apr 2026 05:01:37 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0f15sm6335937b3a.35.2026.04.16.05.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:01:35 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 17:29:29 +0530
Subject: [PATCH v5 12/13] arm64: dts: qcom: milos: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-qcom_ice_power_and_clk_vote-v5-12-5ccf5d7e2846@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776340775; l=1368;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=PQIwHe0X6J+SePUM39Gyz3yRIWQ9APF+TtzVUvY/U7k=;
 b=VPUV44pQZ3CT/160UiaEEW92uAButbGm/uxJDikFIH4/a170ga6m7ssBE3iekTp+GBUhM68EU
 kEjLblRtVbJC1VgMqw+sgli1h8jBGuqwmMnKo7kDZDwkjwlQQcIMlxl
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: xYOSATb8fu-nYhWl_nYk7MVhLa4h91m6
X-Authority-Analysis: v=2.4 cv=HMjz0Itv c=1 sm=1 tr=0 ts=69e0cfa3 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: xYOSATb8fu-nYhWl_nYk7MVhLa4h91m6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExNCBTYWx0ZWRfX3zuyQg0V6BUW
 WCbLa8cLTQadyOPWjuPcm5MKUnN6xo34JgrlbHxamXMHViJe63p4lSdVZVxpepIn+kNS26VYOVi
 xpgG7KQzbRogWOyVS/GVbf1jSp4aKuhJJOvoZ1wjxAQD0ha8+o7DbdnkCPTfZBBAFKfG3nwLQ1w
 aaHJ3MGosz3Ih/WDRqcEZ+jUV06hJDQ40bNpYnx+FgQfE2Aauax0k8hhfrHZuCTTOMD8O85C62p
 i7eJQtYQdVKgpGoj6ViNPw4xTkdxJsGs7d24iGjW22QQb5sVJ4Y8Hx/TWRmcQuoWfufI5fK3JcL
 gPwgmf/jkttbsQqaVBt63h/1yU6UWgRAsmt6Dxrq42STvE6W9qemBjIvB8BNmJLUVFJ9V4x+pvZ
 F0wiV5qjnRo4B7olR3Nm1hVrW7NvomiqXx9Uv0y3iwhwEbBRMch2wmNtNZoeK/pw04lKrjow4nF
 wb0XbuH5Jnx+xg9GMeg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160114

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for milos.

Fixes: 04bb37433330e ("arm64: dts: qcom: milos: Add UFS nodes")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/milos.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
index 4a64a98a434b..a6e463f3885d 100644
--- a/arch/arm64/boot/dts/qcom/milos.dtsi
+++ b/arch/arm64/boot/dts/qcom/milos.dtsi
@@ -1275,7 +1275,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		tcsr_mutex: hwlock@1f40000 {

-- 
2.34.1

