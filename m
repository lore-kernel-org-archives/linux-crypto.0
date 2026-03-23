Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A59386564
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257530; cv=none; b=tATwgIZ+pm/Gj5pRGNPZyBgpr28fU/qQfkUhDZwOpFeuITMbB/41OmOAqsfeIiK9Nch96nl8DX+JQ0ZvbNFQPsYI5S+Zunt0ffqWPpWmDa0pSqAa9kPQhrnmK/NpsmymIAu4Hu9KqiYxBZOmurGkfooU5Rz6bZU3nXehgzNkwOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257530; c=relaxed/simple;
	bh=Zc7nt/v6+4Q7rzRTQIetV9Sk5jCVdJFZJuVL1p8pYhc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OINU/K6A+exRaqLAo0BLZN/8kyffCBZYWSehlY2i9tnlcAWbqQMJMnVFVy3US/fB/6EL5i9OJVzxuB3dfDq1TObFlIBVXHfZjmZF+f7s2pjc9kU2xt6XFH1yRBmgHhqsd+U93i+ypZWTSIzAgolT/3ztGpNL9hTjRuD35h2HRgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VMU0dnsw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bCvlVxQR; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VMU0dnsw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bCvlVxQR"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N7tEZu2291321
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3wUQtjDfxAgI9iPYpnIrhTEYGD2QmgwM9MarVNUOQ8Q=; b=VMU0dnswjZspbU7G
	/N4n/8wEWPRLXnehHZj/Gb2UwtWyXVZUbEk40MJlVFFGQRUNUc90vRx2+jKoRCWX
	U2QrnSvq5QTHMFqH/nhB2/gi5tW5mVK5SyC/5Heu9Y1tGNg8ASvZtl5wWgK1cHqi
	TaCFH3chltEO53gALyiFKCgFpSNIk1GsqN66xQ0xvlE2ya8CLda+iL+zIl6a5Lyp
	Ip5JSLT6+nla/Z4kn0UkRtmYvGeCWcRRagpIDQdwXqmjhMF5OYavpC2h1Q0JQ1Do
	rdawgG7M0uJo1V4TC+VRxJbqPtcS76Hm/bj+BcgzLpymkpf8IogNH7o3RKsi8tOm
	unnxcw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d31j7093n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:48 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35b991171deso2321154a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 02:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774257528; x=1774862328; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3wUQtjDfxAgI9iPYpnIrhTEYGD2QmgwM9MarVNUOQ8Q=;
        b=bCvlVxQRZfSgH0Fd64Jk0PEDqTile4T7ORvbBwijTvlIDiN/Nf+xQ4GuxJTHLyUIo2
         ALVYISc1DScsmmBedPx/sLEyOWUtutt5663Yc/kuLVFLA8AOeYWzmeqUzc2vGz7Hmfcx
         JNzohNpEiF4Cu7gn7EA170QKUNt3qMPmJ71S5X5a8Uh/GtBrqNQUawXkHdCeirKSaL1Z
         pgXcl+VJ0mJZfmqbo5K+MXXo83pdNViks9cxndWyPavXvXU8VLOoxi41NSPWSvkcyvUT
         K6hNhb4BL+jueeR7JyzrFB3a6Z9SMTKnNWgF1SA4Vob1xGtiC9mDN32tr5ND+JhcOP9v
         h3Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257528; x=1774862328;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3wUQtjDfxAgI9iPYpnIrhTEYGD2QmgwM9MarVNUOQ8Q=;
        b=CNS0qMIbco6nLfKv/3dcwULZ7EnC9KBxFkaFFTnYaviVs0uGO5amA7ymfSemV5PgiH
         TmXrGUIZhcC2xwXJsiZFSoNEdinjg1L02a8QjjWIzAIZ6LSBnALzU2aJStjbJTtoA1X7
         usMExLJJGKsB4nQuBO9vrZ0T2i66bRQvJJQRuWrIWQy5sVJJV55sPtjrboIJlmbbE8NK
         is6YeFNiiXLfaNJDdDSdmz6kJ9PdrkoGNVnUErGYuyvJlDEj71hylodascqwP/9Xvfkh
         X0xfIcNJlhnQe/jDS7KY4xLHF1EtrwhbR3Q4Yvj2nem0tmsLfhpc4EKrhN3wgAYcG5na
         OunQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdgyXG50+TJfnEpNxu1W2/wxN06lkxuUqB2B1ymBHHf/TbvEYNiw6DpTHHpuThC7W96xTouFJpSRiEHGI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzij45Nxhe7sQ/h0gCsa9AuWFWJT1b1em42Pm1mGXIZxOrYnMDx
	lJhdZOY+ceyqvmtw808aC+hbAqwbkaCptmGJU6k1yE+CipqZE2WGhv1y525+PIilzF9kh11l2Wi
	pwGhYQRHbYznuEHhfC+xIM8zBj6WrN0tzaYyPND54Oa7GstGftexP36H8GBtU0MHqlo8=
X-Gm-Gg: ATEYQzwo2+OAFEOIVy/wGhtAzrEVEc4UYR1WBzLaRLaqYHSDX1EoHRPe4S9HgzKwi+L
	0LbEMAXhLvzT8w++FJ5iM4szML0BdyE02Z6F4lRP19oDDfKzyM2HA+ZNMQnqNcW1A7UeVv9UCdF
	u43HRJlcN10G7osOBx+UX0MhnKBCpzNzv9dHQslXkvt/c5RTMtJjyGwr70bM4Zet1LIXrfYvZs/
	+Ml4CvBsXJuQtYGeb04HECZ+97A9BxbRBYifsTU8AVCr8i7x23fVtSypFJS+ZzvSR5FnvrpL0Yw
	VKz/mivK+oFp4VPxBxNjQQtjeqfkcgAn54YOoYQLTaubxVT7flDV1/75/h4BJlZkNWJniydly5S
	aL8HB40vZ4IEzGjB5umvz52rJj4Gp/yrm2t16UkVSuO+PNbo=
X-Received: by 2002:a17:90b:35c3:b0:35b:9c97:3d18 with SMTP id 98e67ed59e1d1-35bd2be82e6mr9113826a91.12.1774257528043;
        Mon, 23 Mar 2026 02:18:48 -0700 (PDT)
X-Received: by 2002:a17:90b:35c3:b0:35b:9c97:3d18 with SMTP id 98e67ed59e1d1-35bd2be82e6mr9113810a91.12.1774257527549;
        Mon, 23 Mar 2026 02:18:47 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd358b5ecsm3923448a91.5.2026.03.23.02.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:18:47 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 14:47:57 +0530
Subject: [PATCH v4 04/11] arm64: dts: qcom: lemans: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-qcom_ice_power_and_clk_vote-v4-4-e36044bbdfe9@oss.qualcomm.com>
References: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
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
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774257482; l=1514;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=Zc7nt/v6+4Q7rzRTQIetV9Sk5jCVdJFZJuVL1p8pYhc=;
 b=5hNvbZtfnL7IY/SldlqnstGyVUDFeLL5lhoy3GKb5l/0fva5UllvYuBDBtmI9nUtOTPRNsOwm
 eGzu2cehjSpB50a8Y0VWiojkQl4MKmwojr5gWF46wGvi0lVKZMlCMzx
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=ArXjHe9P c=1 sm=1 tr=0 ts=69c10578 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: NuCHY5pydewqWf8izvLXYzFj5kjNlDx8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3MSBTYWx0ZWRfXzRuGwSFsBhmZ
 ZjQSv29c1TBfFAlzp+cY5IN1qbH5AmMtDEpU4Oe7OZzfWAcWrwxiX35B51knAx7zZI7H29SFJGd
 0XXDfE1UiAuJucK5JrPBnDL/Jee9LWpIPb7AJM6PEzGx9AC4l+g4yeppi4oN2/3x6mDZ6B6WguU
 4sMZQRXkU8hftw30O21Ok//OpnKnnHEHXOvKMnCO7v5RZEsjAvsJJHiS0RHvVfFYCJ2G7pqsagQ
 k/5GlTvAN2q1NWi30QP04K7eszj2p8vVnA8mLFmOm+G/sfpeXxJJhvziiHsWkeXm62c7pMJPGoD
 iSWymks1gsRoiCgISa+qdiOWVA1GaI0U087/uInxfH+Xbi1EZxfgcffxIBTnTKd1gZRCgIOtuRl
 N0hPaSfe6z/eclynHPIId3FleL2YQyJQY5gGtxm320EruD8EYqPfD8V2EeZuOuoFXSdptVDRs/Q
 Ffxur70pUg2In/jpxWQ==
X-Proofpoint-GUID: NuCHY5pydewqWf8izvLXYzFj5kjNlDx8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230071

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for lemans.

Fixes: 96272ba7103d4 ("arm64: dts: qcom: sa8775p: enable the inline crypto engine")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
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

