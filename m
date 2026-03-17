Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7C135AC29
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739285; cv=none; b=t7RsKVz4UgcD8kmQ8nfVMMNbPsz2YmXToegEfdTdfE6Kv+2IooydxRl7hNUNsF0xQl3ylCitlloOvYSdopQSiqsC2y+QhslT31LiGUtulR1wDJiKyhOv9g8G1EpqV7KnFUIoQiw2Phr28aVxWhlVQ5ale4ij6BHmf2lb7/QhatY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739285; c=relaxed/simple;
	bh=ZoTYC4gGpP+T/L/xPYhrBgESTmeIr5ilNZ2zTsHOxS8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kzIzKybQenTedavGh4H0PzE3xDktb52Qrt/3oB4/pVLHY0SdNpDyFZ8hSCLKF1p7L/eAoS/+RDl4aqV1p0WkwtR5rPmaSvwbD4wph3zUjPbMZL3zCASKoFA7n0RgXgPgApCiZVAzTSl+DkbBoI2oUM0aguc0Rb6E+A6n4MEraNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kJXE11x8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=U4QIdo2Q; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kJXE11x8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="U4QIdo2Q"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H7RDla2905943
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	K+r4d0K1NIBE1np9DcmCa86bjp9Sk+dZVE7N8ud5Txg=; b=kJXE11x8HS21ZnSq
	GcJt9Ycvh7QcZKkVOqdI5xeIXEjAok+SOBPIXw1iTkH2uiKYVkYMQQBm8bCW7n9o
	XRxYoktdYHGERXH3COcayc5U+XNd/asjNG0xP6pr7IqyJZ/xckPZLZeePrtc9CHP
	ZZnykm5WBSsazsEwv7GIoemyhk54viDPK7eUeNN7lmRK8osicGXA97HI59JHpDoj
	0r58RH2HqHyoSPXnsdG6sbeUNBk9dRvY9bAVOpcp/onUsi+oJkr2dVL8IGGJcQ2O
	AGFoDXaNjcIfedAe+QkGWTUVA4T/YVDz7M+244k7tknZxQc1GU7DY9xYShLznlWX
	Z33Y1A==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cy2jxge8j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:21:23 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso6314989a91.2
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 02:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773739283; x=1774344083; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K+r4d0K1NIBE1np9DcmCa86bjp9Sk+dZVE7N8ud5Txg=;
        b=U4QIdo2Q3IxR5q49FWRiDIFLRDfKH0OL2OL9kxgR+9BkuclLo3KJW+2EI4qEnAxq93
         Sb7xNnd/FPo9wT3uqBDam96yPNlPtLfTAxa8G1LcpNB7n+I+qdA/JIxZFjE5d11etKCG
         qRNetBO+amPa+YZoi7W9TE+1n0Wf7UazewHrLsaE1/zlRZ1htrI2IkPTifOdY3mgRjQo
         QCRWXFZTHUQfhLjy6D5M2oD2ubBBGzvMIWl2flyBKiBEJBxljLrWI4Gdz6xeXGl/hO4s
         tAOk80zgmDU5XTr8pzzpCPymQ2kd/uV3Qjui1QakxfLQSFSWyJsFVARBJUZZ89Injbyu
         XcXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773739283; x=1774344083;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K+r4d0K1NIBE1np9DcmCa86bjp9Sk+dZVE7N8ud5Txg=;
        b=GFiF2aBCiW41qB8PdO0gRJA641fKrUmnZUMZDlXB2BNrQ3Oxc5KFL4xrFIoQEdiqq7
         bkD+pxx/RtMbCCHWZdo9S9Eq/IEK+ryMZcWjsi8MUfA4q+LGjAfH0xO0OmOg4fGYQQYN
         iUwYvI7K0EJMngwQD9VFNnpxzTsLPtK6EzZ+lhIT0NdlHi4CGClOHg3iKHP1t4vBEnxT
         uC3zcBTQLE7SPl2H2z4fBcq49Ahe6fw61P7fq5T7cxuA+hDlwHoitvJD+VOlIINns+CM
         CIRg/of7XpTq683KW+Ky+FoRWgFIkR14bpFqKX3F6OO0iAy2GWcJ58NY4VO9/Srd7Vmz
         KRjg==
X-Forwarded-Encrypted: i=1; AJvYcCVr0phOZCpNJ3JZepMzqf0BN1X/TqiuatpU8tYCMsj1Iuqb5V+LpKpNioECRdWewRBoZcPxNw3Lxg6KMDE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVGTWJEnKxBB6F6qzSk493kd0UsLUn6nW72jRf8v6OSM8PPsMr
	gMQCDacGodl6J2sBiNQf2GJPJIcIJm9aUtHVDUbCEMiQGdusHHC1IX8dKy6aoIrEejMlEtKHipz
	9oXxX0WMz02xHu2CKIqQXKkwGH4diIYQ5Mk9c3/F+C+nuNlja0E5u1Ao7GkIfLOeqRDI=
X-Gm-Gg: ATEYQzxKcBDXPRADV+XUPM1fiK1Z+8Q785X8oDfgwDlxAl5GMx8dK01DWf0sDtVUmMW
	A8Zp9U7ZbIA6QeJmBztFrnAn23rXZyT4IyIt8bgK+DqEgEq/TNL+/dRC5DQhUNLmZxTtkbDsU11
	rxzcNNw7ZgU3oPAc8u8CuVmEDWExJ5m9aC8J5X6s+PGLHfEVgx7mU7P3xSPk91DUohXVfofHP7s
	wHHMtPJttVlLvUjV3FeB3gLWiyfgUhh7KCjC7PPCwu6HSaiouvicyxuOa0xfPlkMLTdTwfQsnDt
	YAErxK1qtFhjlgPGYP0sLDgobYMxmF7fKcYAd/Jx1QH2+OMfu4ds+qQ/pCE7KrpyaJSTH/zIpQy
	ijbnlylGzTRBXh9jCfBOrH/igQeNrtW/iW0f+lGX578S0fLU=
X-Received: by 2002:a17:90b:1e45:b0:359:f2e1:5906 with SMTP id 98e67ed59e1d1-35a21e3958emr13589215a91.4.1773739282721;
        Tue, 17 Mar 2026 02:21:22 -0700 (PDT)
X-Received: by 2002:a17:90b:1e45:b0:359:f2e1:5906 with SMTP id 98e67ed59e1d1-35a21e3958emr13589177a91.4.1773739282112;
        Tue, 17 Mar 2026 02:21:22 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35badbcdaa6sm2331968a91.15.2026.03.17.02.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 02:21:21 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 14:50:40 +0530
Subject: [PATCH v3 01/12] dt-bindings: crypto: qcom,ice: Allow power-domain
 and iface clk
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom_ice_power_and_clk_vote-v3-1-53371dbabd6a@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773739265; l=2159;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=ZoTYC4gGpP+T/L/xPYhrBgESTmeIr5ilNZ2zTsHOxS8=;
 b=xdpCR4Jhrp26F+SmeMPtKGA42JLxPzSPWxmOzvipMHoX/IOupgWCUogAki83Kb1VVPRYaF4vL
 Y7H79xL/1wDADi6Vc/bFD3hABg7ETbG+F9YoksoPWeh22EMjoBKLzrJ
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: 6FaNkrnj0IXihVX_M6QmRwJKA_3AuiIN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA4MiBTYWx0ZWRfX7jI3Zb9CACMa
 2OLL1rtyjV4AtTXqmj7ht+Q0vQRmgd1DRWzNlQSioxo195xGAVF84wy6VIqJDKUblek3SR2vgqb
 qlg7JSx3z1WnWJP9uaWeD3ulYAfTd7/zpdlmRJ2y19qCArpUZLUuuMg8l2GiPj5buvx5zfX4Fjl
 78iUqh6uar7rLAjafRqHeHXzid9yxhZqCEn/Riv1xQYPMnRAbcNsCVBVeVDgq1MFUbl0SK9n0Y8
 Hky7FE0soXmO+mLjhOP8a6Cn4sxBZlyPZ5krLAi7GP2VB1BN7t2kTRT+UYR8Yzb/430MC/2dvOX
 OANI0XBN3zL5e3yqqSqWvyb/sOrBy3WYL/LqGWaBYEQPw52+uujlRebD3QV6uTNFbVh0HxhTkX7
 b758IDd9IG2LJ9bDS+3/0pMeGc+0IL0XGWPxwCjiHbsd18gfJhCIcd094HEXwxiXc3pa6o2ujQg
 NjcqyHEdYifBihnCw8g==
X-Authority-Analysis: v=2.4 cv=c4imgB9l c=1 sm=1 tr=0 ts=69b91d13 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=FLtWHdY9P_O1C5dx__cA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: 6FaNkrnj0IXihVX_M6QmRwJKA_3AuiIN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170082

Update the inline-crypto engine DT binding in a backward compatible manner
to allow specifying up to two clocks along with their names and associated
power-domain.

When the 'clk_ignore_unused' flag is not passed on the kernel command line
occasional unclocked ICE hardware register access are observed when the
kernel disables the unused 'iface' clock before ICE can probe. On the other
hand, when the 'pd_ignore_unused' flag is not passed on the command line,
clock 'stuck' issues are observed if the power-domain required by ICE
hardware is unused and thus disabled before ICE probe could happen.

To avoid these scenarios, the 'iface' clock and the associated power-domain
should be specified in the ICE device tree node and enabled by ICE.

Fixes: f6ff91a47ac57 ("dt-bindings: crypto: Add Qualcomm Inline Crypto Engine")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml       | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 876bf90ed96e..99c541e7fa8c 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -30,6 +30,16 @@ properties:
     maxItems: 1
 
   clocks:
+    minItems: 1
+    maxItems: 2
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: core
+      - const: iface
+
+  power-domains:
     maxItems: 1
 
   operating-points-v2: true
@@ -52,7 +62,11 @@ examples:
       compatible = "qcom,sm8550-inline-crypto-engine",
                    "qcom,inline-crypto-engine";
       reg = <0x01d88000 0x8000>;
-      clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+      clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+               <&gcc GCC_UFS_PHY_AHB_CLK>;
+      clock-names = "core",
+                    "iface";
+      power-domains = <&gcc UFS_PHY_GDSC>;
 
       operating-points-v2 = <&ice_opp_table>;
 

-- 
2.34.1

