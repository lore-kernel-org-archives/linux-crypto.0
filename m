Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E76E39FCA7
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739337; cv=none; b=tG5GaTmqVAT6IXyMKxv6CDt3VqH2gJQVEbzJdhMQFYdhcBwEIDPHBky+n4bXTYsg+n2I92z4Ceb43KpNQNFkSqHEXBeu170iMOjKThbpZ8zKtcPuwSibInoHtVBOIVgppALip1HMrYRWZxstrVK2lawdbxRMo7nadoP8rMJHETI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739337; c=relaxed/simple;
	bh=zUfKGirFr7TG0U6cUb0RW8kjlwT7PUFFAQGpnGGIbZg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OGzsdCvEfKMQwdKbOo7uApXHj8f8y+MODA6yxOYbt1Q9sR7XhGWVmTCewv9YQuw6IJtklqTPwbVHICCNp+zmidtVzJ0ili7WDyssDpg2gFVz/wrYaFSrz4vd9BvaWj9DM8S4KBf0j9oY+WyGmwLALzJFwXGlRNbHS1As9jGeSBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=U63Og3Gl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EjQDyWQl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="U63Og3Gl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EjQDyWQl"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H7RQbw2906089
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/6lBKgDxYlBHzWej2pbhNBWHqhnNs9qiOdlqR4udlsM=; b=U63Og3Gl0khFP3dr
	/U6PVywHZet3B4xhgI1Ao1G3qDME3QfMlO2d2CwukPR/CP1AOh2ySdNT0DObpBpp
	FG1C0w8QBFGRX56Nc3yY6+yt+nDJu0b4Mo5LFj7RCVvF0x03IDsbHgz1jhsPr7f5
	t0kAGMxsppGUQmfKDc7lGkVGIg9KbLtS3sga0Hw2DVSvsi8DACMzDFvs2p4v5HaD
	sT2CVaxn/D/cdkoEvsAdOOO3dre3WZPIoS4S6HHuEH/jeoUMoB+cKofILnG5ly1T
	JuSvkI5WNa8XRGx+DT/Da6rr31DjEebdnqSurvLuC923TVw6ZCYkwP7mQbZPfMlK
	CzT+ug==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cy2jxgebm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:14 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-35b9333cbfbso12273414a91.2
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 02:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773739334; x=1774344134; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/6lBKgDxYlBHzWej2pbhNBWHqhnNs9qiOdlqR4udlsM=;
        b=EjQDyWQl7ISxME+dS46slOhY3McPNNXx9Azd7N2ZsxSk4c/+jVOX/CmCuI7vpiwxKU
         2pHyz2kCEbIRMQU9EjdYGkt7jM78TZDO3rkxDSLDJEPfwlS5kk/PTk+aiwfpfUS/bgxY
         HLNV/fo5jnlPmCXsJgPxImpntWpmwNCrtuuAOsO4FJcyWfDpJPw/8vtsI8eTdbfpAfKT
         uxQVP58uamCcXi6UW76lIKj5lbTx7mLOKaonvKYbJqDAcDelyj3ivqhfaokJjzRuU/el
         dyOI+gKyXFd1bXYChPKBNL0U8d/tWPAWHVWV/ahCmHZPcUVrHmQMIfZ7DuQ0nhscd6Ip
         m4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773739334; x=1774344134;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/6lBKgDxYlBHzWej2pbhNBWHqhnNs9qiOdlqR4udlsM=;
        b=P8/zl80EoN6kGjsNYrHKsvOudg4qwXTp2398NjF4spiuBFVwiQFVRXgqbB+q5UVI4D
         iPYeTCYMXNdA3y6PyDfcJ+USwI6PixyxWg+2sWYaqmLytpVFo8xhsCPmf+C24z0kQo81
         gknHMY+eJPsMbi8eADGUYZvXK4kwZ0Z0uLOcF/3m6S6wH3flAZCVXljzGINQKBvXwKc1
         rg6XPtfLButIDJAJ7mykgswtgxX3fXhW78VwF+2gzRQYsWZBOvOLtpN8N0zJi6n1t+xo
         5baloPH6RHV8mpcVQ8qx2z+BvBukrKGyogVPVm5sUI481NGoLehUMBAWTfeWrak4PLdI
         8pcg==
X-Forwarded-Encrypted: i=1; AJvYcCUkR4o2y4MQqdSNDaV/plpzC9sumZ7N3D4/+w83raPxYrEZWou+iEHVjaPV6Wh6OwJwir6p+7kVDM05YaY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+fplqDoczgzngyIz3/JbV9LC/CTf3CdnOCeZ4Yb/sFc9a782T
	Z/RwKRTqtv5c7X/XomU2+5u7SPVoq9zdLAJkfAPlnQhAUUDpJK8w9ZLrsQUCKtRcFhx0cTVsZZs
	e1EnLrvvWLepnmG01NUH0PQv2CGJh4Gho0Do6Gpit0VYfY2XRWEkkm1AQ/qfMVH9EYug=
X-Gm-Gg: ATEYQzyIb3JaN/JgfNybWHrNvScPcTBcI95i7aPptpCQYLIy6DCgn6LAJkKCQ+c1eiF
	Vtcw0P9OvKJR4c0wMg43X6Gyn61AU05pbsRcmQaztnnrXkoRYja7XvkqSXBk/LWF2eAnXLtARZx
	CekuZd4HRG8MO6zeiQF2+eAcSIPFA50FIPKQ1h0VTAaesl6Hg+Y+IM84sD2U55K/GVv1ejVpLAR
	vE9L2c9fQ42C/EDVOo8DHnv/AsCca8Fhu++B3ngPcPNbMN8EzzfaEGCzHqqW22d5xII/XK7xck0
	763nptaRNDRCeKnTiBwy3el+wDxonZkiKeODMOw/RZv5thdi/iX6Gpt/RFry0crQ+BUJ2Yv1Prv
	GTMkQcbv49hhht9RC5rhhuraHAHTsgWZNfTUk+/WfTYQ3VMA=
X-Received: by 2002:a17:90b:2885:b0:35b:9b77:d7c with SMTP id 98e67ed59e1d1-35b9b771ab8mr6839254a91.14.1773739333721;
        Tue, 17 Mar 2026 02:22:13 -0700 (PDT)
X-Received: by 2002:a17:90b:2885:b0:35b:9b77:d7c with SMTP id 98e67ed59e1d1-35b9b771ab8mr6839236a91.14.1773739333291;
        Tue, 17 Mar 2026 02:22:13 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35badbcdaa6sm2331968a91.15.2026.03.17.02.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 02:22:12 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 14:50:46 +0530
Subject: [PATCH v3 07/12] arm64: dts: qcom: kodiak: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom_ice_power_and_clk_vote-v3-7-53371dbabd6a@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773739265; l=1452;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=zUfKGirFr7TG0U6cUb0RW8kjlwT7PUFFAQGpnGGIbZg=;
 b=a4Xrxp7svox3j68gZ8iMgDE0wafE/EN/A4Y4REKcjmI9XTvfAAYBSDZavKD5clFCNbBZR2tjF
 UC4/2a5keA6D5ArDP6r217QHRLfk3EG14Pa2bldvz30ZyTVCDpLNL1Z
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: LPlJED68IC1bD-g-CADvRxE0xwlCsXNl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA4MiBTYWx0ZWRfXxJq1A34IM8FI
 niI1pqCSi5y9ti3wjc9SE2l98ohIpwuhy5ibNmKOYcz1t6FQQlxBYUz7mF8Lp50uTv1JcYzXH4R
 GhTRbwIM9GPj9sxKxSTuS56EIIjahJOjQpMyLbPZo8/jAzylgLeM5JE1rehdzinCteRcNthwFD5
 x1fv84px1m7DqFVQZ6c/SMsyu+u9MdRSJ+aKNNTG+qqYaoqpTf/Vks7C/tX1bqtdBjtd5UUs57q
 Q69NZ+6OuoqrPCS9WgW1chyDOhmzAUo4l+HzlgIJi85YjINA8Gyh1evfD/XZH4RTPRmR+CicKFJ
 yLO0xlqTPcp2W+DrIsnzI2IiHPkKRhV4CSD/TS8weoEJPE6c97tl8DcO+iT5stqkG4VD/49G/Gc
 NiKesPLnzI85bk/27DU9EPrrxgQc2O4VhdWhgndk+WvIlnbNtTFssO4xKMbUCPL8L9QzYok4D5o
 mDBVxg/YeQK98PH+wTQ==
X-Authority-Analysis: v=2.4 cv=c4imgB9l c=1 sm=1 tr=0 ts=69b91d46 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: LPlJED68IC1bD-g-CADvRxE0xwlCsXNl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170082

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
index 149954a3eb7c..9765bf361db4 100644
--- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
+++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
@@ -2579,7 +2579,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,sc7280-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x8000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

