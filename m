Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847E13D669B
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773130061; cv=none; b=dvZka0LTEriP+wKNT9Wz/SqbnlsH7lLWtvPOT1WJqTaYkEbcrD958N1VUHv7hazwlxJfuoyUxGKj+sLqoERgi4M4rkWKc33yIGdNDQV59aWV7EiNvIG9fUIZE7/+7L8iyg7+mUgLhb/3j+7YBySjKRgVB/VrHMdncjnmNPToq54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773130061; c=relaxed/simple;
	bh=/WRo6DTYnhZj2QRCpHK+TJkXMcLRJ6f4fUiA76JshP4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Tu96ULgRMjUmvnEa8BD17ka5MQT9TgCUO0QWjt5XdEXMP0BRzoPubQpWzv1Xxs+iIhg/7G7Ea1kthJG8Dff6X1QgEpir/wAujUhW7yztEn47dJ6zcliN6lkKjAhV6+4F4KXbWiZ20/iGFlfEzdFe/8k4a3axg/X4Pwqw1s8f2OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Gt9FqRRU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UB3d11qU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Gt9FqRRU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UB3d11qU"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A2EDxR3754538
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SEd+HHr4h6KqnF7zSg6nnkeThUZF8EBgI0BFcLMtQI8=; b=Gt9FqRRUUkcXWWGE
	hazFXpAC+p+clXZbRUQWjQumkcmEyyM+okrU81Xq8gpDNkwSO0tlnPjfE3Ws3HkS
	MCecCQAfuFzEdwc4AIH6Lf0RFxs8B1z0RUerHrrdrvQmD9N7VShXx3IEb3Xvtb85
	rs2y0h2qBKsLMT6Ccz7igaf89nOyEC2aVxzzHKZvkQ1mHFnv0ISaWkRRK/fqeb48
	WeyEJCMKWzmTm37VBbLMdFwrMGTb3IWtRwGu6MPCLQAYcGmdrjb7ZWctvaGs4w2H
	pdDn3WGbhSS7XHoDpyyfd6gw1BiWTvLdyBMlgM6O1rnwxMFtut/G2vgM2aEknfq1
	X1xbpw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ct477j53v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:37 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso10777183a91.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 01:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773130056; x=1773734856; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SEd+HHr4h6KqnF7zSg6nnkeThUZF8EBgI0BFcLMtQI8=;
        b=UB3d11qUZiF8xKwRaTKb864RW4YtLtXnCeb5EokzbK3hDB/X+Nkk9OvwApiFvHwAOB
         Ae/i2Y3E8c1wpXegpdLDEZIsssdtwqRbMivumnKPKSL+C5IbkY3GB7sEKJWG3nEfOH65
         6Qy34Qaats9iJc1iG5vR8BtpaSPmoT3to4giore0rJKxp7Br+gMfdXtM20xEIJe8t6a2
         FW5p4HKhBMYBAl/CGSePiPIzY95YV58KFv2XECQQW29z7aOv8e1NnnEGY8Gcv2eiWYqJ
         wclID3sK1fPfi074868Q399KmnMEvaBGyAaquwIIIJaSqBINQsIoyzsxxOD0WfVntPkq
         XbMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773130056; x=1773734856;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SEd+HHr4h6KqnF7zSg6nnkeThUZF8EBgI0BFcLMtQI8=;
        b=W1Ooxsz1HwSntFW9uYeGzBnQ+anhDmDnKAgdQmN2LgldcIBWyz1OGRtTTYMNCiwauL
         P/o3Ceu7rsaVNN+o3tY5/xTias2WsPR42BFcQp6W0ZNJsWH4Yjs3rhbpZ095UKnqh21G
         e78PxAIqKkDMBdV328sI6Qw2TkZ+aT+G72CZUTi41bm9xYNbaVEZ4fEFJ7Q3Mk9nHnhc
         MlpQZF+rtl1fwx87d1ubYv+wGC44GctJsvd0istWYbGzb/B90F9nbGFUSYK+X2bnnB3d
         L+Vcq7/DpN0Ni6FIkm5fOLYZA5aJYTmMh4x/MJlugTipNi11cBMIPi7QbzvOiiSuTj9Q
         gQng==
X-Forwarded-Encrypted: i=1; AJvYcCU9hsAOAuyz5ClvAyL/LFw9sikH3l3kLbwzkYnWKZEORUFaE9PwKr5qLma4b3MKJc0oOHG12MSHB+ivJZo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzapTsPYXCh9lkxDXQoZNogxdAU+52VitWVIjuOs4v1vtmasfvh
	hooXblc7tvmrWAW5mfzc4U14gFlnV+55m7BF2KUz5taco3tKDHRlpEc4YY5dzqeftKXgcNfit/T
	5Qy4kdX0aoqMjK4CQ60Mgjd3A8GpVBXnjwatM1tEjx+jIXmK9QGmjHnlMDGYtmltqD1k=
X-Gm-Gg: ATEYQzwCGF/LYgBc9HaBl8q14BpZsp9NvFLeF8PKftvBj8qsuriCcIDro2nWcqIc2fg
	wtrfDsFQOl/OCVh1nUc5qhgVOKLYILzLjtUqWLK5JjgBUFnAOkb1NGIG0dVjfpnmusovmDGqB/L
	qtDZGLFlCVsiQXi5BklDLOf9TEIKlQ+vpAqu5U3f99DNHuVP65Jks8PHm35T5RWnhVHAcJxQO0V
	EnYUEpd88ffTEBhZya07KHRWz7O/ZinU88V9rY8FJoTP1UFdHxeK6JI6VXoQQvDDAuFK+ChzycL
	XdTdQWgKx5xrdbsJ62IN9njFLap/9YSpQ7NQSkYtHESc3lnQtfTl198Iw7lo7mirRpOKlo9nZri
	p7GGzB5gMpPFyG3rglPxb7QOImy8SfrLEFThkAglKBZQLQqg=
X-Received: by 2002:a17:90b:4c50:b0:340:be44:dd0b with SMTP id 98e67ed59e1d1-359be3b9d00mr12413543a91.34.1773130056485;
        Tue, 10 Mar 2026 01:07:36 -0700 (PDT)
X-Received: by 2002:a17:90b:4c50:b0:340:be44:dd0b with SMTP id 98e67ed59e1d1-359be3b9d00mr12413522a91.34.1773130055963;
        Tue, 10 Mar 2026 01:07:35 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e195c40sm11121969a12.31.2026.03.10.01.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 01:07:35 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 13:36:32 +0530
Subject: [PATCH v2 06/11] arm64: dts: qcom: kodiak: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom_ice_power_and_clk_vote-v2-6-b9c2a5471d9e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773129997; l=1464;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=/WRo6DTYnhZj2QRCpHK+TJkXMcLRJ6f4fUiA76JshP4=;
 b=e8NOCiLqM8hZd0MIqtImw+zFS7P9C96NDIDVyGZ3C/Z9SIlAr+GERZwd6+IkySZen3sV0sAM3
 V922DYl4WEfDjia3c9tP4bNbhIlfHUi/zOmOkMD11BD0GGtDhsnk2Jg
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA2OCBTYWx0ZWRfX1jQggat0MaCK
 Pj0Xefuo6oLHDb4VmovDddgx0MImiO3EPlftsbjOcNsi6GYMxiVAsD+HEKz5e+obZvazc3WvSZk
 1lc50cesic+bINWxvvA5mb8bXNQwFPuAx2Hitt9Dq6OqWOR7V0sORgB7IqqdlfebxusUaFuRDsx
 eP3ukKDQRA0OK/0Zf11PYshUxu3tIw6mLFO29EyZ+DN51OgkcYwTQU06P/sSJxgtQxEIGMbnUno
 +BjOexw3GF0OjK4Np1ApUwpuZ5DqOVcv97aUCAyDNyEH0/rqzL31fLNgxiylSwEGQO7fDdUM7y3
 XIebD6mCjzVdDUjjJl0zZeZe50PXC7NNypE9iGduEHbmmcVpvUMtnyDWzXdb+vGdhLy784Axy1o
 b55DFWLNUjKkX0j7WlO/39/J1X7UY13hVXxnm9VyGBYV6XXGCadimZPXKsuTTKtnhppBzCmfEdI
 mMGX0jZsnESoGU/1YNw==
X-Proofpoint-GUID: 75_ivrZAoEZunTXbd7SKVHU1FOX39zqJ
X-Authority-Analysis: v=2.4 cv=KLxXzVFo c=1 sm=1 tr=0 ts=69afd149 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: 75_ivrZAoEZunTXbd7SKVHU1FOX39zqJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100068

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
kodiak.

Fixes: dfd5ee7b34bb7 ("arm64: dts: qcom: sc7280: Add inline crypto engine")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/kodiak.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
index f478c5e1d2d5..8f2bda7af74c 100644
--- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
+++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
@@ -2574,7 +2574,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,sc7280-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x8000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

