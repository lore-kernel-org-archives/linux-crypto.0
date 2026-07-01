Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5701AA1F4
	for <linux-crypto@vger.kernel.org>; Wed,  1 Jul 2026 20:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782937057; cv=none; b=ST50P2tpoLXh0YLNQojc8QgA9w0GopOJ38SFAUXn/0yUFn7o0YV1rEorf7AswI3JXQo2Q7qaMn1gMeQmBeeI6tYhg9krTBeAKadY9NNu41UkNlvl3BOoH4Il3ZYerIZCivjjBscmYkt5QwCD9fD3hDO+x79332lZFujDI6jglhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782937057; c=relaxed/simple;
	bh=O7e+z5O3u9p4uqA/rqmuYxUbGbJniNI35Wn8W2asCMo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QhiBGLfn4aI5ZQEomlsWRjLGaJsLIqHtoqY1nx4xfW6hBV5ii9hSJ8DL6pdm8JvduX6GZLLRZOPjCLt0vSFFMxVIjRD09lbkR4SWGMd9+ydD6erYVMo0idz+qJtP/U1M/ICeaPYX0p7HuJ4wlCjtIZQqsYl9VxS6V0O3gpapUi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Y+pe1A9N; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OEcaiKM4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Y+pe1A9N";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OEcaiKM4"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 661GmW7A1730535
	for <linux-crypto@vger.kernel.org>; Wed, 1 Jul 2026 20:17:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	R7pDwUG0o43LTe/Dy+wxU5CdZ2Kvmmv68kgvFJA86g4=; b=Y+pe1A9NvQlS45WS
	Fg4S4EPaUbCjPetEh7nNIPOLgGfSOlqbvIGLOdlObLNeOTxIsrVFvlujRI3nDs/s
	N5V/csiqle80RLbhMeWt6NXEktGvL4n9GwG0Wn17t0RS6qLtWUGppyvSEykBaMPk
	lBRAebl6JdbbJ1OYmR6EDqZe1funFp+bcvltM3XQsJCfKOgeJPERo6FZpjVyokRu
	2D05yT7LZRn7mpaZMBw3FA1ONw3Cz5aWMWyRRTpxC5gnt4zUd0l2RueaNyKE+tZ6
	hDpwKv3Wu6czk1If9EVt0N2CDdINRB50ALc4njdxguN64JmnPpS2P1iTnsU/eQaT
	XPCGWg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f510ajfmc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 01 Jul 2026 20:17:35 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-37fccad2b01so1812411a91.2
        for <linux-crypto@vger.kernel.org>; Wed, 01 Jul 2026 13:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782937055; x=1783541855; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R7pDwUG0o43LTe/Dy+wxU5CdZ2Kvmmv68kgvFJA86g4=;
        b=OEcaiKM4CMAcPlLe+WkezpLA4DUaciQe7q09U5v/S5mMNVwDx7GKIM3lcxF9iPdLkX
         EqsTKVppKq+DHH418rr5nhIUe3OfKloNzkGR4oVPxvCFC+q1Gqjx16pL6r/bR8bCR/eY
         PpH3BYqaNbRuw4YllAYlwGRuQU2ionJ1kgR9+ohrIObWKi2BX9R5N+knEB9id8Qi/nEi
         LEdLhhOMfUrfcfvUKivB0O3JfjBJliCjZFanhe0gndDAkylTXcHkPGjXJ/r0bGU9ZnCx
         3e0pJ7Im6xl20+D2e9K7Imfm4TfAcySvZMvvtMd5GTJmDuJKzQleaOEzyOGy9ffxxkjv
         PC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782937055; x=1783541855;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R7pDwUG0o43LTe/Dy+wxU5CdZ2Kvmmv68kgvFJA86g4=;
        b=Q9LIpeyoTEEXM2qk4QaBLDt8rnzpFTWi6fHcnr0OlhN60GyHnuqydWqaQ5duYG+bil
         onMeFEeTTlBCGslWN1nZeBQJ+W5U2Fuu6ZDX6AG9ZEYttCGfWWzZZnKiZ4tzr9yAvb8D
         E7tpVVvt5fcmmViu1Px+BTqOhY13+VaEw4ily/kBPHEPe6FST1jZ+JwWkebQiVgX/ywE
         cqwS9laeuwz8ccEAClRXNBSc+n+jECJIJy85VVt7F3WmUX7ePGUDwr93JQC7YMWjk6q7
         O2xREF/Zg3KlfWpLg20JRCwlOLBY6j8w9Fghy6lLMDume6ydF0FysrN29J3dmuqCk97K
         DdoQ==
X-Forwarded-Encrypted: i=1; AHgh+RrUB2OQO94BkTIRgqxU/gGuknwi5mjYoSn5vxSHpqAq/XmvPAte8DNoJdrv/XWiT2VepQCABnnX3bmOYvo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCjuv8BisZJFRQh2SnFOWY4MpjAWADhDqWLhI1vIknk7bQjeLM
	4EYT1LduqY5VOkZizCJ6f6EBvF//BvB/r41BdZonTtRoiloZUyZhK+83L+yylN9uy0w9ncxuYmB
	/5k8LDmbYbLPezHru/uIM52rbD92daZSO+AUvTpGSgHcn49jMzJcnlGD5z0I1QgRtBB8=
X-Gm-Gg: AfdE7cl5hXJ9PSS1zI9rV1/imxNCiFKQqUd/0BFDWoUa1UVNN2F+3DpMYrObssiJXnj
	wAerqz4RFwtxGUThgTdfaapWpb6CLd8L9SeJzgx07flQNTvJTAQUlMduo67/AmWKD1O6X3gn9JC
	Ikm/Ihb2E4BKei0+/t6XyGHbnRjn3jWo9+Z7FlzZyL61g4DegwCL3vtsxAxdZ3PnKHu1EwZWE5q
	G84a25Rc/w4s/ygzMltJLUJT8lZbQM4dzZvoD7l42GWR3zXAkNxIYajKYU3uqIAVWA6jOSFr5wB
	oPU5Z0T9sOUmMwIzBfiB/t4txhfC9lrLm+qB6r1wk6XDVx+O2LKRsMIFfNzgw4CSTQkUlRWPMjO
	vLouN3dcI4jdcXs0jKGmMFpfMNTT+TvCFaqRN8NAmSic3
X-Received: by 2002:a17:90b:57e8:b0:37f:caeb:69df with SMTP id 98e67ed59e1d1-380ba94f8a0mr2661493a91.22.1782937054429;
        Wed, 01 Jul 2026 13:17:34 -0700 (PDT)
X-Received: by 2002:a17:90b:57e8:b0:37f:caeb:69df with SMTP id 98e67ed59e1d1-380ba94f8a0mr2661432a91.22.1782937053810;
        Wed, 01 Jul 2026 13:17:33 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bc79231sm948685eec.31.2026.07.01.13.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 13:17:33 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 02 Jul 2026 01:47:11 +0530
Subject: [PATCH v2 1/6] dt-bindings: crypto: qcom,inline-crypto-engine: Fix
 legacy/new SoC strictness split
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-b4-shikra_crypto_changse-v2-1-66173f2f28b3@qti.qualcomm.com>
References: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
In-Reply-To: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@kernel.org>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
X-Mailer: b4 0.15.2
X-Proofpoint-GUID: 6rSniNEmjEd9kUghItkE2a8iHCq_0gYX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAxMDIxNiBTYWx0ZWRfX/BgBD+PCsc1v
 okepQaMiC/Nklsbdjva9KFB/93+UzJUMMP67lk3iXG+7ejhQmSEcSDFYQO+UcMARvjntQRNT3at
 1F/3HewtXrfHWjNh324DT4vvvHQzCKvNnQf0lczIqLH/vD+IU2/VgXBbfsqD2QCcLAfxPXtemsa
 syX18bqC2s80Yc9laCD/XLjXTXMHRSmBEN8DyHLKbt2ZhMYPxbgno5tDbWfmvq58wYHT8XdC1q2
 mdamhBc6xquPeSMcwvUzyYLN2ieQ3iNdlHZ++D3PPw5eB+mxFrsPmHvN43WNerM/mSvwSaYYqDe
 i+BBz867tW1BUQIEtk5Q6wOZmTsvo4h/qtmr6sOtqZKsY/tf8CdOB97ae1U1a3lq/0+0mOCoVFT
 q7/ARmH/noEBbRy1/OPL8ARb0fmYK0+43rLQ0SHP+HJZJQUlUzIlSKYjELNwyi62NbYGRErLAml
 lnS+pXpq/rpt1n+WbWg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAxMDIxNiBTYWx0ZWRfX5F8J9MWSEu0Z
 66YD/XWcSu7ZQkwJLfv79rmyCMxHxGFzQHm149Y9cc2n5C3tkVuqF74LADEJI9iYYfV4PK3j0DE
 YvQlCNrb1+nKflPHxgRiJ3ou9Z/HJ+U=
X-Authority-Analysis: v=2.4 cv=JpXBas4C c=1 sm=1 tr=0 ts=6a4575df cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=F4we2z5FY3kt4yoF36sA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: 6rSniNEmjEd9kUghItkE2a8iHCq_0gYX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-01_04,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607010216

Couple of already merged SoCs describe ICE as single clock historically
which are recently updated with mandatory 2 clocks.

Keep only the known legacy compatibles flexible, and make strict
validation default(of power-domains and 2 clocks) for all other Soc
compatibles.

This ensures old DTs are valid while ensuring any new SoC (not in the
legacy allowlist) must follow latest requirements by default.

Fixes: e27264daac7d ("dt-bindings: crypto: qcom,ice: Fix missing power-domain and iface clk")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 23 ++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index db895c50e2d2..4f3689a24410 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -55,14 +55,25 @@ required:
 
 additionalProperties: false
 
+# Do not extend the list.
+# Legacy SoCs are allowed for single clock.
+# New SoCs must provide both clocks and power domains.
 allOf:
   - if:
-      properties:
-        compatible:
-          contains:
-            enum:
-              - qcom,eliza-inline-crypto-engine
-              - qcom,milos-inline-crypto-engine
+      not:
+        properties:
+          compatible:
+            contains:
+              enum:
+                - qcom,kaanapali-inline-crypto-engine
+                - qcom,qcs8300-inline-crypto-engine
+                - qcom,sa8775p-inline-crypto-engine
+                - qcom,sc7180-inline-crypto-engine
+                - qcom,sc7280-inline-crypto-engine
+                - qcom,sm8450-inline-crypto-engine
+                - qcom,sm8550-inline-crypto-engine
+                - qcom,sm8650-inline-crypto-engine
+                - qcom,sm8750-inline-crypto-engine
 
     then:
       required:

-- 
2.34.1

