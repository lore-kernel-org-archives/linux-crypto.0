Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3C8351C12
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773130076; cv=none; b=fo0EiaSSRJdfrPgRwNFNTga5uT6o0LB459o50LdSY4siVhp5+ozKcy7J7Z1pKvfkcm/+jVV9Leh9uvoQRo8nfcpXG4bAmS3rXfKRBnViqBTzZUVwfmYK2IHwbH0H58QKaHeQaJuJmWn6ioL4kmD+uWpdQfB40R8I0qyE/T9A5X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773130076; c=relaxed/simple;
	bh=gYZaumYhSsIGJVNztvmwWowAICkPRsJuJxQKDEYgXm8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sxQWj5AyxJitu5bZn4hrdtKEm1XC0fUMVAIdrLOT+CQjxPrHr4ZR2Su+OldWphq0fywwVjQQ+b16EJX8WoIiiZ+4D2pQ+zSqI5nU0PtNPA+SEgOEtU/Tc9AKrNhXBnDAiVUzJaGWLNz+9/ibpgqbiaKufu9tKZEXDUTgqpt3Yjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=a1+pfJa7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=daYL7uCM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="a1+pfJa7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="daYL7uCM"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A2EUvl2020757
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FPDC9UVWCZT9cS8dyi8jxernVsW2wVYjaKvNbAETH9s=; b=a1+pfJa7UIaWJrd3
	3nfo9Xp3u2qUiXAqApWMBtMnj3unE+zz+rhIw1VqRUs9iz3TxfYRHpcLc8YPfpAm
	A++IRB5bAiXVup4s/BHODRwwQUWYdXtMPkZkblXcmrpM2sva1RVeUUrNGxlBpWBP
	nph5u2oPya2efTz/E5nh2xSi+xVJXorilmBzUIvwL44P18yVN2WqWzG+wNoFTkdP
	zTnDJWbaPSvU6mu3nrhR+jRmY+XqdhqWvGtDTGhMWH2AOSUzej176/5mS5sd+JlS
	CeobkrJtIs307xRrvSUIUOu9A1cDU+3sWYMJGysH3acV22CKpGiWm3IAjWteajeH
	nn9wYA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4csyhbu7te-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:54 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ae50463ba8so482437815ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 01:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773130073; x=1773734873; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FPDC9UVWCZT9cS8dyi8jxernVsW2wVYjaKvNbAETH9s=;
        b=daYL7uCM0OehyGB7p/nqj/0DCmXb/eb403FfCOOotWL50ZR+s0wqD8MnTcb1IkOeku
         cCPqNwv0tjClw5vj/mwDHsAI0Dfb0cz2oo9Shgq3wN/obbF+Nbnt8eZIOaMmbLtfMGQL
         fYISQ4/1UvpyNj7BYKt0lIrdGnl3M1IGOC2yr9BcHjkYEcWRhOiz/EMAaPLp9sPC1zu9
         w3E39R3rUrMCAmL0l7WgUiYgJ3NusRzqLxutjsckNXy4WCgMTccUnekiGXFOZ/2uaRI/
         OzlyQARa6ESD1ZfZSlbHL4DCdrYyFGYYoJswySA0uLHZOQtpW2yJmDY9DulH0HWoc//k
         Q5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773130073; x=1773734873;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FPDC9UVWCZT9cS8dyi8jxernVsW2wVYjaKvNbAETH9s=;
        b=rxyON3iN5MB1DNK6XZu/zuFCseoJFdCxUC6dRDlP22zIi2uQck+NIf5JKsydIIod0v
         Huhdvp6HQ8fdvXPaFGNnDRRSTKYqjQIq6MqCrSWXG4Ey9B2QLHGkDnXqqcq+RBimuVrQ
         BXhRgY6NhbXgF6fddrrFczZLx1pB4wXEvzgl0fUIc7uyHkRgZv4vB6D1zsNyHTfvAniw
         P6E0AG3+yj+6A95TrGxnXkDBS5g0QyBgU8roLIvTVwNl6CWKS/LkeJJMriBQF/uGfMns
         kAhS/Mh7JarQkdxm/IkapcohlTzfuhgeSOATRr4qw2Hmy1YY6nr4HyN95XcxxROBPt3t
         wO4g==
X-Forwarded-Encrypted: i=1; AJvYcCUyKHlEtUBkJZ6nhvH1YQB1RL5/eOi9GwFTpZwH2UHp8dShFc5fDvVlj1hGNpHp3IHcOQtSYTYuzJNLnvw=@vger.kernel.org
X-Gm-Message-State: AOJu0YweHiSftq1llQzR4Ysmqob+X7W9pHAwh5teL1RUUdNbxT9n8JHo
	c7v8RsRVWCWuwpJKecQ7lyoVYspzUAR65z5veU7BdJ6B3Th8IPSelPbA471ZPMUr7/hnZgWMjpd
	JQnAg+z6+at4suMGMmRlTze05jl3gpKR++UZ2VwrWSTOkok3jNJkelfbd+lMCMv0XQww=
X-Gm-Gg: ATEYQzxtpnfI6cpUshB67vO/ysI+52e/ahnPTdUsRUbqPmeNUZnJX+aq6b1W289qWeT
	khBaVE4yMLrNtOLp53MmOs4YIFF0K2uZ2rc+9H74i/O88oVIXaApA/aFOeQhAoHwcn14XmNhz6Q
	k5+zGkXJgDL7bkxDqLkYqoSf1zbjINPpZKW/ARDZ0jR8XUJ8aB8wDHFqrwCWHWJoxb7INutUmHU
	KPnYFHb76rh0yz1SEkP2wP1aPlBAKxUzFxxZqiRFWojJjcPNhYLqE8Cs/yy+pVIfk8wCD4COAsb
	DeHnDECQp9cqDQ7yO50shRo7fkp1P1h3/GutIzC+vgYSSKkAVKXovHR4i5I9Z0wBTEpBZOZ9HKa
	/Eb/R8zw2x5I3G0EsYLtm0tSALxpEKWPRF1QJZQl2QBUdbxs=
X-Received: by 2002:a05:6a20:2593:b0:394:5dc9:9758 with SMTP id adf61e73a8af0-39858fedfeemr14302463637.28.1773130073129;
        Tue, 10 Mar 2026 01:07:53 -0700 (PDT)
X-Received: by 2002:a05:6a20:2593:b0:394:5dc9:9758 with SMTP id adf61e73a8af0-39858fedfeemr14302435637.28.1773130072619;
        Tue, 10 Mar 2026 01:07:52 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e195c40sm11121969a12.31.2026.03.10.01.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 01:07:52 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 13:36:34 +0530
Subject: [PATCH v2 08/11] arm64: dts: qcom: sm8550: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom_ice_power_and_clk_vote-v2-8-b9c2a5471d9e@oss.qualcomm.com>
References: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
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
        Yuvaraj Ranganathan <quic_yrangana@quicinc.com>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773129997; l=1403;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=gYZaumYhSsIGJVNztvmwWowAICkPRsJuJxQKDEYgXm8=;
 b=r8k6uj5/kJCQ8zdV0eJV39dfQXzKWqmaLOeE70uG02ffT1By0BEWMp7wVTYwo5D4hTjJxUMbh
 RbmZVL9GRlUCnynr7bkvI3L0eychPRxgMN9MQu+o3Zyt8j87yYAtqs8
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=Rcmdyltv c=1 sm=1 tr=0 ts=69afd15a cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA2OCBTYWx0ZWRfX/DjZ9WoyRmqv
 L5Z8+lXrLNvTXZgJRiq6KdLouLIH3Sfem8bgp2Nx1/wXWRlK3q9VOAQYjrLxyititsahCTtgzM4
 GG0i/0WXfLf5CwJ89wJzMaP5r17zyfWCIgr++c7pCCp+IhnfehWDu6utvWCL/O9d+xOwZpmGC8q
 BuHkC901Gg/zYD1kV3kqAZSK3HnmRNy2RtFBLnTvmJos07NsjtFRhf7dehmb5ST74Cb9ycOmMKi
 lx5Bw2bGejxRAd69o/TJVFMKXgTrT1knG/6nLT3S/NqzUZoc6i0e4LxMSM3gnLRpyJZZGKOKsWj
 YmevIpEhqcW9OF7iRpCVbUEeVhVLA4R+qauxgUPnf3ZsEg3YVyARHzkaqdRGbEOb0ExR+hzeSeR
 B+sXCfJN7zihdU3xYiWIewnQ1E00ajk3Uh5nBU0y9VE43NFpXxudG1gU7uW6rBpViqmSYT4IHIp
 +55H3ocnpPgw+pbgZGw==
X-Proofpoint-GUID: eDA5-wECkf6VDJqiF0pIq4Ip0xI_zpVK
X-Proofpoint-ORIG-GUID: eDA5-wECkf6VDJqiF0pIq4Ip0xI_zpVK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100068

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8550.

Fixes: b8630c48b43fc ("arm64: dts: qcom: sm8550: Add the Inline Crypto Engine node")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index e3f93f4f412d..b6c8c76429ba 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2449,7 +2449,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		tcsr_mutex: hwlock@1f40000 {

-- 
2.34.1

