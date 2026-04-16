Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD493B4E84
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 11:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340800; cv=none; b=pXJw5CW/K2ZZ11bk5BdAIoFqSzY8Kgf7A6fWUjVmIjmrlJIwHACdDxasxX/557yryGL12+zPd9n9QoB+Pn9EUb+AqZ8c92LH1eo7ebP9VB/7dS1FtiS/HlAyiYhSyqM4LxsMnHE6YBJYAnuNLT5j1cUlTJiWXyMh73gHiaZzZHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340800; c=relaxed/simple;
	bh=QhcT7I7/aMxwjiRWv+lMSZ9O1nf1QgKhkc5pxVQ9Aic=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rqud8pO7J4qHs9ysHKuKF+SWgcylcVr3TnrOEhspkYJslcQHdH/WK588fIjT2bXzKyBKnUWAp0XCam+k+G8tfQRRGzd9Woo5C6XtxY2o+VmAa4HxIRI9xozuWoJqJCIqyjvhqrSFbh618Yuuc1OXuAm+CKptOUQd/zU/ARSnBwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XI3jzBu2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TYWVNDtR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XI3jzBu2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TYWVNDtR"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G8XUdr1702416
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 11:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EHpvbENcsLtgvr2XEbf0CXHSig5EkRvJvVRMbKysza0=; b=XI3jzBu2q+89hWn2
	du21tHY8EWhr4GTFPD/rSiV/f8y8pMwMQDvpcX/R+HZ1QYoCLWsWU1x2HCT4Xc78
	VHrlUwTcQZflGeHOZ7vhkYASfig29q1DM7j4OyPaOGoanQLgCMYEpmcEeJhpeO3t
	9Zr1t6GxHrfwDNhLDTpokQh48qRUCEvJYNe5a/PCvLInoK+kEIzKoInHwbm30bwj
	VtAZV4lFyl7MjTOMeZTOGrI6XfLVkIyyZSLsXIm6Fum6C6PfmDN5XhRESHu1SGYp
	P3UwbLD5MiU6OArmTVlRJWYUW5FhF59lx+KqaSfCSAN8Lcc8M/J3S9GEE2AWkZJe
	Gqy2Mg==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djdamkp8c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 11:59:55 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-82f71437218so810505b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 04:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776340795; x=1776945595; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EHpvbENcsLtgvr2XEbf0CXHSig5EkRvJvVRMbKysza0=;
        b=TYWVNDtRzlaznz4V8RoqWOMpbC7/dgQcbyzMp7a1gDVCwcM2QM74hW0p8FjOADzrWX
         MELeqKNA+MXJ22iglpyqULCdfdTuoP3s7ctTkKO1DfSniWyG8eu6t30oeiOIJQqZ5DYo
         fYPJdALg/R/pkQBkAhpHc8AhglvsP1p+qveNzXq89KyazWteC3kp2CjvYk+HlTsobirt
         a59mdt2DNAydy3rgQaVdClcbB/Lm2XOSlf0xj61pcU92otYCufbjreS3SqscxfKACOxk
         6rGvfaQFmKaXWxYV4iLDqMKJflGOo80PHjmPKtvE4Nnt+vLAE+E7tYLI9ozR2oA6a22u
         YhWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776340795; x=1776945595;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EHpvbENcsLtgvr2XEbf0CXHSig5EkRvJvVRMbKysza0=;
        b=fnfIlrLhQyr8UY2j/mh5k5razdQ5jN4CJGHYVDwavQJV+UMPip12nThnZQ8Dps4oej
         GQpuRpzLuKPRbmauQCrxFxWUAZG7nIMwd5QzHBefkNuelwuyhOBs81wst+pDHccz7mn4
         XkTXhn6ZMO5tuS6/QQbGUgErfSUMC/k2Tw0SobO4tbncSJ9KYlvEPWPlfEIFvT59n1CM
         4hKPuFoqTORWEy6yhS3MdfHp0Xrr2J83Xcb+cYttx1CWWjk1civQweXFs4a92o2n2JDg
         1fLAp+yfV5kYWsDsxEghW0rgb2ZqV7eUNi42ev1+9DZG5xuisPb1+3tagwbyygeRgcgs
         mqBg==
X-Forwarded-Encrypted: i=1; AFNElJ+ZaVbvcDx+p0Lt7xpA4Xcp68apTQbGGeU+1YC3Uwy9udcEmYpR1RKrIv3pZ7rfz+295Wxzgyw6ff8+FsU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK7PD8I69HFQTEC7ieLmyaNtzey9AAf0CdHpCQ2um6IK5A/qI+
	M1IgJrp+U1Dfl3Mj7+bfDnrAXfSxpHlGxbz9yDZJeWwsobkS8HJmAllTwDfj/w76bPOXXpXjr+o
	0vq5FE2HMmlP6zgpYEsvIu56k9jPGBK3Lr+4hKYImcIHeRrTrcHe9NQGdAUY8qTAhS1o=
X-Gm-Gg: AeBDieuizHT6WJa28JTdXnyWpzJl3OYNEjPJ3z8aWxROP1nHErVdwOaL6NQwEzW2kFf
	SaQLFHOHVbbgCrLBIKFwekeopWiNgsqi8+tb+rzxjgXkoKec7DpL7a66WP/NblfhC5izIN4cNbl
	uFfdAeipN6t0/phpvjGpPGtt1Uh6jCSfcHDXrOi/+2FWHbdJLZCc5LAok8rHfpHKTx9MyEswkSp
	T1vy+s0FzXU7MHJLYjz5Ux9sX+sSAzxabFoJv2Rpyz7m09CF70HQm8Wmq7h8vdMuOPdF5iTztow
	901QVQp/nBLOvSQclzG9QN92m508jQQJBJulOX5eyh267T6MbNGu0yb99U8xI8LhHvEVO/W0MB7
	gP05q2x+M3ROD6BjiIC6dxfLAyWTKOdQuptuPETQUlFt+9F+fgWa9kXLq8A==
X-Received: by 2002:a05:6a00:4601:b0:82c:212a:8023 with SMTP id d2e1a72fcca58-82f0c12fe20mr25366145b3a.11.1776340794515;
        Thu, 16 Apr 2026 04:59:54 -0700 (PDT)
X-Received: by 2002:a05:6a00:4601:b0:82c:212a:8023 with SMTP id d2e1a72fcca58-82f0c12fe20mr25366111b3a.11.1776340793904;
        Thu, 16 Apr 2026 04:59:53 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0f15sm6335937b3a.35.2026.04.16.04.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 04:59:53 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 17:29:18 +0530
Subject: [PATCH v5 01/13] dt-bindings: crypto: qcom,ice: Fix missing
 power-domain and iface clk
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-qcom_ice_power_and_clk_vote-v5-1-5ccf5d7e2846@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776340775; l=2738;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=QhcT7I7/aMxwjiRWv+lMSZ9O1nf1QgKhkc5pxVQ9Aic=;
 b=8WzfBJpvJinzib77N/gNAbcdq+bEhlbv3p4u0qPurYA2X0X4j/xA+ShU0KRMJ3dQbjWIb2Of6
 872NP3H6/gZBorI42sR5SNkpiXqtnQtO5K9jW+tWcUVv5XQK/waTlSr
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: _E31l4gCUx8qBPOTRGtJkGRccmPe4FCo
X-Authority-Analysis: v=2.4 cv=HMjz0Itv c=1 sm=1 tr=0 ts=69e0cf3b cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=nlf9mDh_Z9TmLa7YYksA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-GUID: _E31l4gCUx8qBPOTRGtJkGRccmPe4FCo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExMyBTYWx0ZWRfX2D7S0x1I1GDQ
 0EyJjijut73+zEYokzhmpXzkzwDNnEsJjPHzIOZjbR+qkZ1u5rMEalPKvbATjuPmrmppctKBp92
 4h6fF3kwdy7wLLi8C7kTInLNh3h8mx0QGZMS4C7m+ZnVvG327yY3U2VrjHexfb6QXYJOllPUcO3
 7Ut6ejf6ymATeFmcZVOjelkAHzEdA8aOapVHI1KycG3Ptews2fOMa5KS0Vs7ugRQdG2skY4U020
 wT+yXg/pmTfmT2PYVC5XUuw89ksN23+WYwy0UoXkEtddMrUSRXYFMqeJzYVvbKKtjft9bkZtRU/
 ABVKRCWIixo7vp9PYOhlxabJCfnHQt9AxUDicQFmaJLLkAsk6I68IoE7mczwrGv7lRKok3FbMAQ
 s3LmBFJVCOrAgs1JKUxXqJWySFDMP8mGsMHMjBbWrwbU54BDYPf8SK5kqqI5SCMREPfj2u4+7/c
 hpNqZBLiive5obdhWiA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160113

The DT bindings for inline-crypto engine do not specify the UFS_PHY_GDSC
power-domain and iface clock. Without enabling the iface clock and the
associated power-domain the ICE hardware cannot function correctly and
leads to unclocked hardware accesses being observed during probe.

Fix the DT bindings for inline-crypto engine to require the UFS_PHY_GDSC
power-domain and iface clock for new devices (Eliza and Milos) introduced
in the current release (7.1) with yet-to-stabilize ABI, while preserving
backward compatibility for older devices.

Fixes: 618195a7ac3df ("dt-bindings: crypto: qcom,inline-crypto-engine: Document the Eliza ICE")
Fixes: 85faec1e85555 ("dt-bindings: crypto: qcom,inline-crypto-engine: document the Milos ICE")
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 35 +++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 876bf90ed96e..ccb6b8dd8e11 100644
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
@@ -44,6 +54,25 @@ required:
 
 additionalProperties: false
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,eliza-inline-crypto-engine
+              - qcom,milos-inline-crypto-engine
+
+    then:
+      required:
+        - power-domains
+        - clock-names
+      properties:
+        clocks:
+          minItems: 2
+        clock-names:
+          minItems: 2
+
 examples:
   - |
     #include <dt-bindings/clock/qcom,sm8550-gcc.h>
@@ -52,7 +81,11 @@ examples:
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

