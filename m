Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792561799;
	b=Aq45IgwyiC5VznqLtJ9Exy5Ns2mjmlkgpdx7PR2Y4ckBE37o2MCxHGRl0reQP9a1Haz6
	 KhjW6kA83Tz6ZKWKUrfc+TNjTqPxH6HXS3Nc8Ivm35bi8y9E/mmTwkjuv5ESVpyVWrgCx
	 PAEVQTxv05ZLDR2eWD2I+C2U2EB34GSts/aQTAZqD+tHSNFnhiHhUu8DpJUEDgyOja1qW
	 KraSAWNwECAs1O0VPe2WCGOhZY4d2LG1T5kCk3B6H+XFIdE5FKivG62/7gTqZA4M3IHA/
	 4dqyph2Ct15Lq7YDjFlyyiYkcf4W+72ouS/5ie4I00Q2dbKSEnNv8KiHuHx19rqNLSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792561799;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=DVD8d4W+YFzudkPLzaR7+6xOk4Zd0pVxOH27B8rVB1Q=;
	b=XnzORxyINKdu0uX45nsUB3aOpgTvOynNVttW84QTlcgfUvdAag+0KQBKNWpS+rycM7lV
	 GBHgJGd0zXmK4lVVABKQIyI0IPlxJQUBiPhYq44g9viKrQRJMzxVPAiWbTvwcZhF4ayLc
	 bH7G9DlAQTmiOz9D4gisfDEnAnb0RXqwkA9+6QSZ3NA8kjo0aJCeHVfeBMTWiK0S5H5oC
	 tQBtp6RbxBJGr4Plyf27AryjKSHSBI2fiVeFhvCG0pvpi32frW3bTukO86w7VcJckWPv5
	 iNUxPd4mOeVh9Ea2y4bMcSReAdZ1R+s+MAg6RHyltWcYo01CFNKijWg1Be7E5fJrjtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SUPXRecU;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=gp2eiVGg;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD45606A31E
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 05:49:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBD45606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SUPXRecU;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=gp2eiVGg
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5jBUl3711760
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 05:49:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=DVD8d4W+YFzudkPLzaR7+6
	xOk4Zd0pVxOH27B8rVB1Q=; b=SUPXRecUCl4EaIO8e30o/xA+RFO9NZeneH/2Bt
	xSt73f2V97jHbY18bdCaFaanptJsXznqY4/Q346Ibckr3IdKAkJLC0GR5tgXjwMS
	YPzFbz/Fo0dDVZk0fqt3b8uXtAtLQXvDc6nQDN3DG6I0+NcWGQ+0Yp9EBnj95+XO
	6sTjRmUCOFJUpphTRmjREHQ037MX6TqrRwJAuqacBY+DZo/Po5KNyvMYCT9uBJU5
	2ynWlqJAnOgcRfhJbhCgyxl1NObES00W4E/vXCaax7NgzXV7UrBbPPaTQeS98MmK
	dvNneblNBOHmIWwc7PQzgOithcBbB+w0DYPVh99S8VccUiAA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hed9v27eg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 05:49:57 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36637676140so624611eec.0
        for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 22:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792561796; x=1793166596; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DVD8d4W+YFzudkPLzaR7+6xOk4Zd0pVxOH27B8rVB1Q=;
        b=gp2eiVGgvt7qRny3mf/5+w1sMA0+5qQno7fYMnGBf+ruh/OVb7wn+fL2yG9eKeXulh
         58BHUQl3jiZrgGqIaBFXztABM02ginvFURAG7B11mVmUSKktid2zFQtkZ8J7XL6d++eC
         sJbZlQgWKz2A693hsvMQsYb4GShePq2wEDgD+6+jpErzLLIiCh+dfzT2XpBZKPcL98cK
         OibVgAqOMNbOdp4Q9zYkAAH+v4+F+1Xu/U3Y5+z8akFQu0Vq9dQPajHXiKqrQ7Tc8OI9
         BjgLASxXrXhdiE0gdROgFDqbruj/0KCc3WtAoJrz6DvtOKw4F2nuP/rH2QdhZ5tF/H6v
         glSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792561796; x=1793166596;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=DVD8d4W+YFzudkPLzaR7+6xOk4Zd0pVxOH27B8rVB1Q=;
        b=VtMcM0EklsM4sj5eYLhd2u0XppQm09NVf5y6Lyyy2BrMtKN55tNCx74Sqmdam8UBVm
         UqLSnSTuuQrx5B0l11Ae1Cn7G1qOfd2gyxzlRB4/1Jg0f/xZjc77bdSYXEaNndW6xcsy
         hWGU3HjBqaex4vG11P19RaXnelteo7zg3KaxcLKMfhgQIs98y4ozl62af7/AEWNIf/nS
         skT8hRgQaaaPeSMp4jZhbZ/0pxbEXacylRzRs5fmXyIZH/vnMRZ+uiuUJMdztyon3zxG
         M+UhkCYkVbL1yy1Wa1sxLYq6McRpXEcg/12RMAPfh6Ju7UfmyrEY4qtGwLu3L7dYKnKy
         QiEQ==
X-Forwarded-Encrypted: i=1; AKwUvBwZ5PaxXBxib0wzBQg741492Hllr9LzoVKg4Lvh5sZYzjAekkqbjv8Gxi6VKRmUbZhAbPWP/jJA+xqr3BM=@vger.kernel.org
X-Gm-Message-State: AFq9FYIP6MizGqYp3Hx+Dl0VCQvLXkW+RPB2zcm7nuaXryJjWvUO2a5+
	t/TRcrIX3ccLSQnvFAvWVKIWOJ6fSiyOKHdJ0bV/fQDXs6nA1T/1XGOSus/9MPE8QfJOKBVbMnO
	dIqJMviBb1XTRSkr+wyhcVAszECLXx04WX/xC3GF8CusaLnWIDnw8TdM9dv62zNgdUP8=
X-Gm-Gg: AYBFou0LkEima3QwFKiVuknnCMxZ8KxPXZtDKt2lLaWXS6wihy24c5QlgHhqHMHAhQ7
	t7GywYp8ANiO1h0d3AeKmuWhdcqS1pviuZcbtiWEPhE2kYvwujHjCV60AwGIPNDo6i/aE1hx5IZ
	5A/e6671bSwsI7XmOOp3u8spoH5NI4OvZ85OsmYA9JoKjYwBKeCpgPaP1AM0qLqyKHfhDcZWu3p
	SQlo6Lgn/OHkFcPQmUZifYbXUvCuTf5eXntFoAwb4TtBiTvNvNCi/cVhCupmzMBJosqo3KEPbku
	54poy90wFObLWIMuYMBwwTLo2MOltIs6lgsm0iRzO0dbVlOpEzchOO4PoT29AQbLPOhtAO0mdUk
	zLUc3WIcqoqUu9L9Fkz+vX9HWzYErF39m0/8BG74TyRrQWg5KuPdOclNGoFs4sDuOHtea1fUS0a
	gnByyOazpwzWQOTVWQ269/TtvRu7AOYA==
X-Received: by 2002:a05:701b:4284:10b0:165:55e2:2d69 with SMTP id a92af1059eb24-190a7380f2cmr1440614c88.46.1792561796396;
        Tue, 20 Oct 2026 22:49:56 -0700 (PDT)
X-Received: by 2002:a05:701b:4284:10b0:165:55e2:2d69 with SMTP id a92af1059eb24-190a7380f2cmr1440593c88.46.1792561795812;
        Tue, 20 Oct 2026 22:49:55 -0700 (PDT)
Received: from hu-varada-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903b3d0530sm3656464c88.11.2026.10.20.22.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 22:49:55 -0700 (PDT)
From: Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 11:19:44 +0530
Subject: [PATCH v2] dt-bindings: crypto: qcom,inline-crypto-engine: Add
 IPQ5210, IPQ5424 and IPQ9650
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-ice-v2-1-3dfa8f343ceb@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAHdS2GoC/1WOMQ6DMAxFr4I8NygOiAJT71ExBDDFUiElCYgKc
 fcGmLpYepb/89/AkWVyUEYbWFrYsRkDqFsETa/HFwluA4OSKkOJmeCGBGGb1zqRaZpkEC4/ljp
 eT8uzutjSNAeZv5ZQa0eiMcPAvoxGWr24hErCEejZeWO/Z4sFz8TfwwUFilQWeY3FXXUJPoxz8
 TTr9+GMw4Bq3/cfEASndM4AAAA=
X-Change-ID: 20261016-ice-e1d8ba304436
To: Abel Vesa <abelvesa@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAyMiBTYWx0ZWRfX+e1szzz2ARzq
 CZ4HhtPjyppLujN9hqqgXVfBBqWts+35CQ9I8hTSsxBrbxleUNqPVN5X+SzbhTe/DlAeETM0SuR
 dVergODjHMLVaykvLXxDQDBCS9sMAHk=
X-Proofpoint-ORIG-GUID: uz42Iao06HR-_S07JMv-98de8YqOaFd2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAyMiBTYWx0ZWRfX3UI8TOHBSCfT
 t3flu0vooDxA5Yw7/KXtEArHHxDoaIZxC+Rg+2Q6iTAOM79ySnNP9xqJOnLC7NOniwKwi9p8aI3
 Dc+w7N6XLfCHWGqO4dO9LDbL1JlcSuuEQm/OXx8JzVWFJ3EbyVv7kKKHkGbNAIcnvFhJuztzsMq
 h+lH2WLmPy6MeVXYt9G/huNKIXwF/DgebkyNs5WP1Ww+Cu67eCSsxk5Zgyd0YI2sSc9f3AL8GLk
 2FmuiUrHcNEmcjRiMTaVkc196P3ZPCIU0vpLoULEizgV0NnwJ+iMzbprN9pyRF2IIPQDvXzllH5
 h9bkHZ4mQ8g63HCq+ABUbQeFTXLAyQwju00h9NZS4SC7adTLOltUVSl424f4fFge1EtYZx89Ysk
 5xvgRICf+N5L2p76WxL7Nn1xZ9h07PyOwKJVo+n/GXNYkOFMCmtZhi6Ai6W4FDPsRMr00b1YIJM
 j7ZFab5MERixLApPCDA==
X-Authority-Analysis: v=2.4 cv=I6zw19gg c=1 sm=1 tr=0 ts=6ad85285 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Xq4CliCqeop8EqABAtsA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: uz42Iao06HR-_S07JMv-98de8YqOaFd2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210022

Document the Inline Crypto Engine compatibles for the Qualcomm IPQ5210,
IPQ5424 and IPQ9650 SoCs.

Separate the power-domains requirement from the two-clock requirement.
IPQ5210/IPQ5424/IPQ9650 require two clocks but intentionally do not require
power-domains because they have no RPM.

Preserve the existing requirements for other platforms.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
---
Changes in v2:
- Fix sort order in the !power-domains block
- Pick R-b Krzysztof
- Link to v1: https://lore.kernel.org/r/20261016-ice-v1-1-4098b1972f31@oss.qualcomm.com
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 27 +++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 23bf98c2b9fa..b98c4c6b77f0 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -15,6 +15,9 @@ properties:
       - enum:
           - qcom,eliza-inline-crypto-engine
           - qcom,hawi-inline-crypto-engine
+          - qcom,ipq5210-inline-crypto-engine
+          - qcom,ipq5424-inline-crypto-engine
+          - qcom,ipq9650-inline-crypto-engine
           - qcom,kaanapali-inline-crypto-engine
           - qcom,maili-inline-crypto-engine
           - qcom,milos-inline-crypto-engine
@@ -81,7 +84,6 @@ allOf:
 
     then:
       required:
-        - power-domains
         - clock-names
       properties:
         clocks:
@@ -89,6 +91,29 @@ allOf:
         clock-names:
           minItems: 2
 
+  - if:
+      not:
+        properties:
+          compatible:
+            contains:
+              enum:
+                - qcom,ipq5210-inline-crypto-engine
+                - qcom,ipq5424-inline-crypto-engine
+                - qcom,ipq9650-inline-crypto-engine
+                - qcom,kaanapali-inline-crypto-engine
+                - qcom,qcs8300-inline-crypto-engine
+                - qcom,sa8775p-inline-crypto-engine
+                - qcom,sc7180-inline-crypto-engine
+                - qcom,sc7280-inline-crypto-engine
+                - qcom,sm8450-inline-crypto-engine
+                - qcom,sm8550-inline-crypto-engine
+                - qcom,sm8650-inline-crypto-engine
+                - qcom,sm8750-inline-crypto-engine
+
+    then:
+      required:
+        - power-domains
+
 examples:
   - |
     #include <dt-bindings/clock/qcom,sm8550-gcc.h>

---
base-commit: aff5f30d65bddca7e5eb635119057688e6c04135
change-id: 20261016-ice-e1d8ba304436

Best regards,
-- 
Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>

