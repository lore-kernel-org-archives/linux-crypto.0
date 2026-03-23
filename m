Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B47B386548
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257504; cv=none; b=oePp6y2/6m0k0Na1gueE8lkykDfZIeOAcfCt3JHyFLdMr3Ts7xgZJ+euWGjfkTkymw9G4/dhDKr3dEnmxwLY68b20qsDW9refcuIx+TGG7erOOnB/2y4OBwcgDy57SrhyLZjiIZ1XHSR68QWppyW1THrlxCZiiyo0zlvbwNbftU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257504; c=relaxed/simple;
	bh=ZkSKYFbNGjak0Dho+sw2XFyENeFl4F9edtmWT5qEn8I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UrtVc7/dca+sFRONpa/nUZ2KeYG87gvSoYEZaWBzFaAs1FduCRXh7urdycP29+5Lffov9RyfWd46zlFevNoHfWccd8qYm/h9o/M/j24NoKyoKId0Apd9waT2kUeo0lJLlqEnybCUCs1GXgW+On8eHK/Kan/Q01QOBYcr1dRE4cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AEj0+6TD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WJi+Zuc5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AEj0+6TD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WJi+Zuc5"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N7OwkT381067
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fBQnVcwBQGVsncjSxa74jLLcr1ZR+vADPj+TOnhgQ0E=; b=AEj0+6TDepAkektK
	gl929XK97X92Xj93AxV5AMxxWbZom6YkZdXiZWCBqykDIHXFpzxKVwJD0dHRCeFr
	XNHFOmWIF1RBeKruoQtt6fxkP9nGgZ5ETa4KCFPbdqhTzNtkNqI26Su9h7clpcDR
	Uas5LH7W3j/cHt5pxqF+8V1xYVoFBWuE+N5vQDovgI0GfQLTZ/44j2QkcjJa9+z4
	3evruiak/jJDHJWatURiQQzcgQxmjF0GyXhHYo7N3SPO4ZnmsBcr260Z+PdnyuJ5
	KPs1AAaBsBCkiQjAFMS8v/54J29lLzaFKNLvGebDOnIpNZhUjNbE5vL8WkSz8ykQ
	pJcyVA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d1h1e4t4a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:21 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-358e95e81aeso118385a91.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 02:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774257501; x=1774862301; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fBQnVcwBQGVsncjSxa74jLLcr1ZR+vADPj+TOnhgQ0E=;
        b=WJi+Zuc5J71l0KxZASwWcNcgY80c/7tsmd8SQHLeqAS0z5lO9nD0lwH+2LRfKgINSn
         LBa88ojq8IyGnGDrhCptUMBtg28vLxmkNUOWcdYhdTb9GxwhBbHk++7KVdAQu1ld+D8t
         Y67CH2iKGQ4YTzi5plLDz/lorhiX9xGThXirlm5xqYZfcBRnTdV4s/EJjeE5zCzVrp0F
         BsNeO637rTYjkU5vIsC6UfTWp/NzxUboLLLb2jVHkBYk7EG6vrsiDxRdz55CsR8QyD93
         wKcMATRHJd7G87m4KVtKH2G+F4GMXN6w+HqS8xN5sVG2QKDolfad+r30aZs6FJQgr6Bj
         RiWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257501; x=1774862301;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fBQnVcwBQGVsncjSxa74jLLcr1ZR+vADPj+TOnhgQ0E=;
        b=orfLt94PGF3FhUAlfvLai+LqjEkclygT+kybFm9VBXzSLzB6GCjOfupg11M5MBSrNN
         bBOIKLk9evAHWDsdViuEwd/idYthgW09FqybhiHf1tOnLjnJl8v1vA+Jj+J9GgP3YSsd
         08ovJLjjWGCpQFaQAU+mIeGFNxQefeq1zILxFWrvwdo8SwzpMUTB5q37D4MBNSUai0MF
         YlRAOCQA2Dszp1OlxBKVldIaz6Z79prLp+rgrtjQG8M2mJ55V68yGxIJ66bnYDR/M3/Y
         ZHPw63B/Tfy/z91jKT7hj637S50Vz8dwSPEn2+6OSzqaC7CDvQWMV0XOjJ+vpR9peQT2
         w0iA==
X-Forwarded-Encrypted: i=1; AJvYcCUjzHD/A4IzdN8/T2D7xsXEy7Ho9DGpBDucfGoNSTdZg5JNQp1Xd2ohNMCWUs8qpWfl75deVOR5GvXv79k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVKZGUNHN/Sl24gzNAOz2tv+JXDM6oaBIApxd2IAzkCI/ZFnO7
	9V5YQ+FMQcYrBSD3UFpY+flNjZ6TCXiYDzqvXYulG+isJ+SGMbNfCUyYuk93XHXTXbuQIYxXxBb
	q4zwKtHiIJEJPngXr+G+GyiP7lP2tsk61ueukHS/pDUf4RXlsooHZznkueXq0KLw9JWU=
X-Gm-Gg: ATEYQzzBoSXA/B0PdnxdRwNZ8cUpukPLMZrQnkNnZL0ktf/+p0gjTBcTTPgW7qduAJ0
	24+30OionK4UWPMyHA5MGPTxfPxVQyMr1mI3whI5yk56zPtbNadjMg4EzvQQQf4Nr3naoFyaxww
	f0hhRI/UpWedqibRW9XCNKcx802uQnLR4NWvEEAoPIGwHEIOBBmkWwU4IfWfHO1HN3CWkUqfRwH
	P6Lpu2r1pfaSKuRqznclYsPtXyCkJJdvmxMvRugmK52nvy+km1sAPxMNJoOsn5YsnnU/z1uuwhx
	2sN3GQicDtbScE2ygdGnchzmIj2Y1FsWuzHasqCjcq3I+7ArNpo3FtAR+fWCxrXnAPLQnpfZCrk
	rKDugukf6TP0BKdVejjAAbRkKI5wPA1EY0+XcfugXbRsCJfc=
X-Received: by 2002:a17:90b:4b04:b0:354:a284:3fff with SMTP id 98e67ed59e1d1-35bd2d187e4mr9885940a91.25.1774257500856;
        Mon, 23 Mar 2026 02:18:20 -0700 (PDT)
X-Received: by 2002:a17:90b:4b04:b0:354:a284:3fff with SMTP id 98e67ed59e1d1-35bd2d187e4mr9885892a91.25.1774257500337;
        Mon, 23 Mar 2026 02:18:20 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd358b5ecsm3923448a91.5.2026.03.23.02.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:18:19 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 14:47:54 +0530
Subject: [PATCH v4 01/11] dt-bindings: crypto: qcom,ice: Fix missing
 power-domain and iface clk
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-qcom_ice_power_and_clk_vote-v4-1-e36044bbdfe9@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774257482; l=2604;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=ZkSKYFbNGjak0Dho+sw2XFyENeFl4F9edtmWT5qEn8I=;
 b=3ogJNiFMZD+SsmLzmxVbrbnwcmwDDcXVV2MpBtJuZ7PqL4ZR4j9qyX8pHgxnnjUpQcLljmBG9
 kiHfJkPAbWTAAnYi0vsijUZYjfStyZ97yHZSTuEpLah8Egi4FW0Emrp
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: l3AnyvDGFaaQd-YNqBJyqb5mpV1GwZCW
X-Authority-Analysis: v=2.4 cv=epXSD4pX c=1 sm=1 tr=0 ts=69c1055d cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=nlf9mDh_Z9TmLa7YYksA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3MSBTYWx0ZWRfX3ERfUlWpQr30
 KDIbhHB94DCiVB2qgXZ60rXvQHpI2cALMNymp+ZIkMISWJbsWcoGGWks1RYe+/kb+gfxa0a5DUH
 C0OW4jtOvz4SH3hVJZlOBPP/v0EDks2ryhgkdqNKkKdz3bovduu7KFH5DL6iX5N/+zHtsft8siz
 Jtkm5XPL1tmH9B8v3bWqCSto5+CGKkkzC5yl14mxQxRL0K+09C52tC0DqZnROFx36+NvaHdwl3d
 gTigVKSRO40gzK+VZHtbvdnRe23fZt3Bax5qwqxxe+AJB0EL+L4b2o1ZGDs7Gtu0LLO/Ae5a+vP
 26Vvz6oxTiVQCdz1w0krbUbxpdAByAUoqujTIT00K8nyRLbtJMFSrARHlCqhvjmtqduD8vud4Yz
 FQfSp8H+vRQNH9uH7OxhMpvAFZwinRsKwAZxmXEyuDKkOYsjGpAGEZz3JX/PxHzeXXQ+abWqLjM
 x6IwkOo4CLaGW/SA44Q==
X-Proofpoint-GUID: l3AnyvDGFaaQd-YNqBJyqb5mpV1GwZCW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230071

The DT bindings for inline-crypto engine do not specify the UFS_PHY_GDSC
power-domain and iface clock. Without enabling the iface clock and the
associated power-domain the ICE hardware cannot function correctly and
leads to unclocked hardware accesses being observed during probe.

Fix the DT bindings for inline-crypto engine to require the UFS_PHY_GDSC
power-domain and iface clock for new devices (Eliza and Milos) introduced
in the current release (7.0) with yet-to-stabilize ABI, while preserving
backward compatibility for older devices.

Fixes: 618195a7ac3df ("dt-bindings: crypto: qcom,inline-crypto-engine: Document the Eliza ICE")
Fixes: 85faec1e85555 ("dt-bindings: crypto: qcom,inline-crypto-engine: document the Milos ICE")
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

