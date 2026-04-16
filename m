Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AE8351C0C
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340912; cv=none; b=Z18Q5ZWFtFVCrKSgxeNsenZExcLeZ28h/sM5vvjll5aIB1Orqcs6qDkESwDC/N+79EeiFe8wT48U0Ji4lT7akF+GxQNsYeZhJgrgXRwZmPj+SQ5yT4Y/FMUjCp7D0vFocd4iPNf45Bx2HWNEmdw4xMTBLcHueY+poqpBLWtT8HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340912; c=relaxed/simple;
	bh=VX5sSr67MU3/CpnlojQxc1yhq5+mYZkwNEH+oRw8f8I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RINDM9Y7aeuspdTFaEhSNOswldPnWrZU0KsPimN2WZH3ouENuoLCrkDG0ILeGzwaVWIFjVLg27hYjvZhrJhPkYSnld9Dq+umE1UixzHTfF73n1vN7h8BCJy+7AG4JtVbaZO72Q5T3pzCxvxYNwCDJw6879bYVGyVDXIGlaXnsqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TlSDBoIw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=h0TSbkb/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TlSDBoIw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="h0TSbkb/"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G9NGA21554426
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GJ1T7dVN6bkDufKjyOSICvcs5KgSIPrr4Xb0nXCC/yQ=; b=TlSDBoIwKB/GqkZY
	jZLHurAn9G/osFtmtPUsRisXUB2Loo3YOHUya0j0awCXyS3APayJQNaQWzR7iDt3
	k96sTxKcDXnkDzKflGCg/4AaW1HVUGdezFA1I6wIV220zzpVVXwb3iTXH2JTJGuf
	p7LFOwd6d5sXZj8pjGDZf0WS65hbWwcX5mmRomnD12BJYjyTVDrcnTR91iyvyEgQ
	KnlkvnM5iFJGe1Wq8Q6TwEwc9HS9tA+zssQ0xBVTZx6HxpvVIq8sDj1APpDF0xg4
	htEfKBANs6Hc/3+ISTyuOZThZBXaaavT29r5saiKc4dmTSA5yhLmSgYN6RyaWMw6
	AOt6rQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djrsn9j42-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:49 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c70ea91bfe1so4627763a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 05:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776340909; x=1776945709; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GJ1T7dVN6bkDufKjyOSICvcs5KgSIPrr4Xb0nXCC/yQ=;
        b=h0TSbkb/7GfAT+5yAI9ABhgLEqoj72iWZS7Vf8S2xWS6sDBHpy/9f7SYcIfQqWmPmt
         gpjFu+2XPj/VculvW19iGqkMuS+Rv/pRZInys4o3sB+IbjCoF2g8l8Si5BH7lNJ5Xe8z
         efK6Tewhrib1bjrKKaBk41WVoXeWvWZ5wEbO6tTLq6UqCFlGrjDKKnSYwVSh54HwZZ9e
         AHYEAxawujM7vQdagaC8WqTP574g9lR8gozNBqChiHn495/k7kDVJH14ZafhZzuW25fY
         8ekHDUPzlzyZIgnQTJj5oMRifFWHy4aDVggjdoYt305KMwje/i/FK9VaqAfXGrY0tHri
         rJqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776340909; x=1776945709;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GJ1T7dVN6bkDufKjyOSICvcs5KgSIPrr4Xb0nXCC/yQ=;
        b=W/Nvc+HswhwW4m9k4X9lnOlmouDgpJvZvTeu5SH25SV6y6/S1mIKgR4I/ncu4KFefW
         1T3kCvCrgIplMFT3OyScRi4qAM9Gb5lVXKiak3Q+FkYMKh5HjEolPNyv8WJgLlZCDds1
         RYJSc4gGw6ZMI4gugoUXRe2zzcqYJN9u5nVBJ202FAsFv0cjkxzfRHz3rm1fwOEGhR9q
         rsBU5pv1ocNlosiLbYkHCPknGXnDUnk3079kSAiJitsSiPq/qZHqMZuLJTjzuRI8JCmj
         P+a8/UfmPPXadgAwd18kp1YuaFhy/7rp5bNM/CM/R8wiDuzuF1wmSzUMjSLJF7RNkfgK
         4SDQ==
X-Forwarded-Encrypted: i=1; AFNElJ9M14N2akQswRO9XAYgdet3pacKUjKnMQ9TdxlQcg1ffvlQaDSmbiQ8xSr2XS0bfSbJRXYFMofCa7/2jes=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7j29RLhUiTz/xDXZc2b2cR2W+4GkkQGt+/6sQgOHt2TcB5DYG
	0H83Kc9L4yDn1CCwpPLRmT/3Wu9+JV8orjU14zas9KwucG8J885LnZymOi1+OsQKFqIHtW2pVpw
	LwU8pIBz23fgS3cRs2F/ghG8AQgQV7la0t8BWqVVA/VBrgcDUxW033uIqtsVhSJb/DvE=
X-Gm-Gg: AeBDieuCDqEhhrngf9dcOL7gjB339js7wQWh3W32PiZqGIgm/F3oqDsZpmANeFuermz
	KMIgC/feWVukaIgrYcN35eF+oBjh6Z2XruYML3ZcxkLDu7il+pl/Pn5cQgu3xwv0ToopEC3QV95
	YwSrjqORDc19wruY6qK3zjQl3cxNV/HfaMVTbeoFMvYv6w+YAzscYz/0Icr5+wyx5LA4qPxEIc2
	zWh+Zt1xLmcBqd71sIpQ1L0FsGbpFZnecyE42ErBdDrzzz/+9CFPmqpVdezW1u2+ic7821wcvug
	S+o8DQpxJw4MEIAVyizZt1AyvmeV6L+v5YVjCO6hbORSMga2A67M2bPJ4xRG+4Csa8Y1OmGKLGD
	BsJWBYUq6UrK6AC1MsPLYK7RVlNU+VYMpVFMWGVyXl+ho9O2hv2V0xRvvkA==
X-Received: by 2002:a05:6a00:886:b0:82f:592f:2ed7 with SMTP id d2e1a72fcca58-82f592f35f5mr10651271b3a.45.1776340908820;
        Thu, 16 Apr 2026 05:01:48 -0700 (PDT)
X-Received: by 2002:a05:6a00:886:b0:82f:592f:2ed7 with SMTP id d2e1a72fcca58-82f592f35f5mr10651206b3a.45.1776340908214;
        Thu, 16 Apr 2026 05:01:48 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0f15sm6335937b3a.35.2026.04.16.05.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:01:46 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 17:29:30 +0530
Subject: [PATCH v5 13/13] arm64: dts: qcom: eliza: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-qcom_ice_power_and_clk_vote-v5-13-5ccf5d7e2846@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776340775; l=1388;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=VX5sSr67MU3/CpnlojQxc1yhq5+mYZkwNEH+oRw8f8I=;
 b=M1qOa1hwZmKz1mi5IFUm46eqntN0RI7xEMv6TyeT4H3YLNyB4ZYvMjT+ilSsGkwud7FusKpU2
 haes6YfXDd9ACWrx4HGp4PkPp8JlraGY9WdBlte2btIV0x6Tx17VuPa
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: IfnQtwm-d3VRZovC2Iwg4u_yEcw-e-S6
X-Proofpoint-GUID: IfnQtwm-d3VRZovC2Iwg4u_yEcw-e-S6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExNCBTYWx0ZWRfX1OBCr+iTGUgn
 UtLfNY4I9iz2sdQYcnGLTSwoDeywRRqxQ0Q+Kydg89osOXTZpAvRRki13lZArMlJtK5+OffM3UU
 3VrwFSDnJZoyv3BG1+d+wGTr0nEjH1JQjRYBH6NLLNvDGv1g2wNQirLsug77X1kEEvVCdto/4Qn
 dRipUQu6OksSOEzB48L2Kqw0r+VLZLLwBeNJvqFT6KHuvb85epiEZ7H/u9JvbYrwij6hMUf56WA
 dbVW0tbslNikayxuSvjs4YgYZdoHUCrBCGS7uUturzPapsxl4CUwoq+maR/gpE2gw0LE8V6Ins0
 E8k0svceLc9hI4i6gDDo5QBmAb8LDuBUtA/nG5toxMz7dkSXizeCDxmL7aFxLepZiC1jHLnfdQD
 p1Xdu7+yTxEbxr6pWCbdqdi2y3YBVVAATgwIRfnr5O54UEV9vgMmBr8tEQessmZvOV8K2d8N8Qt
 RgLqaT8fGhEVTSVL0PA==
X-Authority-Analysis: v=2.4 cv=EojiaycA c=1 sm=1 tr=0 ts=69e0cfad cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 phishscore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604160114

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
eliza.

Fixes: af20af39fc09b ("arm64: dts: qcom: Introduce Eliza Soc base dtsi")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/eliza.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/eliza.dtsi b/arch/arm64/boot/dts/qcom/eliza.dtsi
index 4a7a0ac40ce6..7e97361a5dc5 100644
--- a/arch/arm64/boot/dts/qcom/eliza.dtsi
+++ b/arch/arm64/boot/dts/qcom/eliza.dtsi
@@ -843,7 +843,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		tcsr_mutex: hwlock@1f40000 {

-- 
2.34.1

