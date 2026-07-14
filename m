Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBFB363C40
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023550; cv=none; b=jP3p5n+/L9KrBAR84D9Wsv/G6EWSS6L5Lg8HKYE88CMYlPGA4qcSycEpclR0wHd8c8q9yQaXFzQUAIBIPEeGhrRwzRcM+rS3s6twWpX9uuwhKt8S8wyi+CQiic0XpeePp9utlvnldkEXa0V1RP+dUoc+dFjGyYSnj3EXxJCHWhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023550; c=relaxed/simple;
	bh=VKWRSEFUbemWfQG+OXGIX5arda6LIeITz85CHr5HnEY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ECGUc2+EXpCViBPsm9KHnEnEztxtCRtJsr5Ef3pwpnjzTaORRGdEviW7QT8m5kRVKdAw413v0jwnnMVcYNq5zvijf6ST9+owwjMkcR9+HfAUTCM9xLGBr73N9omf3sKgYQgo/Sb86t1speFsn956CyE9ftye5HKSYuCiuIpNt+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=M4VEri9m; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ktB5fgaD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="M4VEri9m";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ktB5fgaD"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6SO903718214
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:05:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/iCogDAWof12E6CRfCJqjcAH+F9g7nURKIMRduQn1mM=; b=M4VEri9mclUfV1ab
	MPWwrPTR4GQYzHwIVFo3HirhSJOiQqTDCzmQS8gGR/EmsqNVitu0UoVnXkVinkWV
	+in4NEPJFxe7XM1xdYD2+jxCHeVy+6vXw+ZKjrGlKKHc+C//sPFR2hQB54PWU7qg
	/yQP6Qo/p3rgglEH0t/RiuUcGCSQvXPSIHzfHqCUqLGFV2CFHgecAYmlihqWJT7b
	t6zvsviyVeQdYekGOIeDSSwCe2cHvOVPTzt7bkZklRe5KaArY0PuYOLwn6uMLv/q
	GvQB+nkRr+w4Ulpdgc/MSTgYniZyjJueUGH5eDSgjvfKqmHvSCeBWV9YviYXmSOt
	6QI9QQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fd7gvjdjr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:05:47 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cc73f47bdcso72575425ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 03:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784023547; x=1784628347; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/iCogDAWof12E6CRfCJqjcAH+F9g7nURKIMRduQn1mM=;
        b=ktB5fgaDim9DAa6gmweNmoyn2NfRFKQ3vFD3KfvpF9uBYR6LXS5k3Q+U9IcWOIgTt3
         KXnbw+3LCMaWc0Q+jdcivTfudmjLwVDADMa4fLmZ8Ey81yXua+UiVyFwrCEWdN/Pdi6m
         gyaIjUoICgT9fwd3KYkgaPje1K5lIPK1n/Tu0jy17qEMD+2/XckgJU6kuV72Xlc84jDY
         eke2zgkiYjVBCA0TIr8P0EO6mylz3iyqhO8itwfoDhiPCbk4Zu0eWvwO83/KUh0cXQMQ
         HsnsEu8F6yqSmlSFpfopWX8gZD4xHYEYy6hAuK+Y+O/kl5AormhWFQji7MF4V4mcN5Jr
         2+Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784023547; x=1784628347;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/iCogDAWof12E6CRfCJqjcAH+F9g7nURKIMRduQn1mM=;
        b=Z6XPLKvD2R5/GimaHvclWAPxAHHZ0I0VoRQ8cKdnEWvkNhny8rZMLJuWS0XwREHy6s
         5BbQ9DZZ9axRG2DJiKFMiSryCrLiDxcRscIWQt9Q9188c4KQmgEZJgzCe3lby+7MHfr2
         tEVdXd4knQAJwIseObS+11j7Jb6e7Cwu8xLAXVgNbvFVSL6Uu65sSmeZi10V22cc4YGV
         4ZGZPDce3o8cWksdMqqQx+lvlItVhsAffV9j0E28hPG/gu7td6w9MCe4DyZ1sWcp046j
         NFXPMILJqVa2M2RqCocknqu5aw/9GnFy7decJPM2IhE8xtAcVDumTXXk90lgkMmhCySn
         No5g==
X-Forwarded-Encrypted: i=1; AHgh+Rq7Smm2YWaqZTpgB7jQq8IMnZ8eXJia4xF2CbTeU+jL3jpT95/OP1uUQXZCrVKnKfTIAroepbGzcRXAzXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDrBY6EYtbotEeL9XTIfgTMKgyKzVSJsn/TXOrNxmqDTHPRgNz
	89IGpOl0t3dcjvs8O/O859ULsAeCVjI39tUcMXDwd7N/Ngz/K2ORQt6kTEMvgbZqvmTL6NC2yYm
	GKXvhzNwqTivdYkMbFWMTxmaSxKIiAXQiSiLhye4wEXEzaT4uIsfS/tnj/r1bgxgPNJ0=
X-Gm-Gg: AfdE7cklC1jHjRbNXUuSoHGdmLEpoDpSlDpOMDnKd0S6QDilgCqNdZBg6hfBPCpiZ29
	KNSNVI5ca9ly32bzGnKIzjp1g2JS5dqyurjZjT28/jkg3jLF57lgvoKI6EjUNGyz/ktjT9IXqBT
	gS8HorbgoDoGKofUv40xNixMOQ4YyX2X5XZCp0lgL07VMAQFW5P5UYgRLR4Khr/3evyKZjScCFa
	8zNbs9vbb2nMjnqm8MO+p4BtSuKonBxGnDTQUGR86gsXwublmOScsWb1eICQm5ZuDJTrCbIcgYl
	fUyY/8fV94gZhGS/LEHizsvsv0QNnySoLdmNGHvk0bsasiZ1cuba0cscSput+xyjOCkj5tDP9Y6
	EyVBJ6/bo7maMtkyKsj8CD95UIsE4UR2KnUjf8ZE1cFUO
X-Received: by 2002:a17:903:3d0d:b0:2ca:d151:383a with SMTP id d9443c01a7336-2cef13647e3mr20409765ad.20.1784023546708;
        Tue, 14 Jul 2026 03:05:46 -0700 (PDT)
X-Received: by 2002:a17:903:3d0d:b0:2ca:d151:383a with SMTP id d9443c01a7336-2cef13647e3mr20409225ad.20.1784023546058;
        Tue, 14 Jul 2026 03:05:46 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bf737bsm112653485ad.19.2026.07.14.03.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 03:05:45 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Tue, 14 Jul 2026 15:35:12 +0530
Subject: [PATCH v4 1/6] dt-bindings: crypto: qcom,inline-crypto-engine: Fix
 legacy/new SoC strictness split
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-b4-shikra_crypto_changse-v4-1-06a4ea97c209@oss.qualcomm.com>
References: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
In-Reply-To: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwNSBTYWx0ZWRfXzsNXqoQjpBni
 mnD79ttsIs6qnu9rTVp2pqyG+ICoh6dUeU2VHrgMCB0cLjILik7Wg8iYz+/0/jR4lhQmuQ2fWD6
 KJuwSJ61k9PqegHXV1/MrBtQPeV9l71TcEDZ/m8XU6xqtKfiraeSltbCWaBUAoz1A+tr9GxpV0o
 GaUHZ9yrNJzvQDrKiJmcxuQKHKTO1xyXAVaOPLBvDL8dHGgN7vfjVQojYfnHIpkAtk35kMq1Rdk
 klmp1kH2yMr+bS+UcFjWG9Tl+MopkGmyPHfWVcY199snxXtGPcJGRlFbGS8Q/lzTlrDRjrWDTSc
 I6goa8xs2ipOfzKS7Vb5G/wqw8FUW4eUns83DfSP8GxcomTJyoTGqyYbCTCHnrXxuVgqAWb7kdL
 ztv7T+kJebgNl5tp/4VsXZ5jwQdpmGEKcT9S+F9v0bC0TjGQLWxSxZ00JkENJ2+xFnrvWEXm34B
 IRWscAGtLTpKreYKdDA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwNSBTYWx0ZWRfX8JADB+4vUMxR
 dfUVByeRgkh8hNJKU6i/bzMrRL9s6lOCBjAHXYu+SyefNuD+N136n6o5S7b4/D2Mw2LXyRy0y5h
 +HUBVuZPbHwXcQuNYsfF9Gkk5uAkmjw=
X-Proofpoint-GUID: dPLiVH6bSLj7dwnhNcT0QeLT3sVQn1lK
X-Proofpoint-ORIG-GUID: dPLiVH6bSLj7dwnhNcT0QeLT3sVQn1lK
X-Authority-Analysis: v=2.4 cv=NYjWEWD4 c=1 sm=1 tr=0 ts=6a5609fb cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=F4we2z5FY3kt4yoF36sA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607140105

Couple of already merged SoCs(like sc7280, sm8750, kaanapali etc.)
describe ICE as single clock historically which are recently updated
with mandatory 2 clocks.

Keep only the known legacy compatibles flexible, and make strict
validation default(of power-domains and 2 clocks) for all other Soc
compatibles.

This ensures old DTs are valid while ensuring any new SoC (like hawi,
milos, eliza, nord, maili or any upcoming ones) must follow latest
requirements by default.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 26 ++++++++++++++--------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 7be14e99be28..cce21aae6499 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -57,17 +57,25 @@ required:
 
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
-              - qcom,hawi-inline-crypto-engine
-              - qcom,maili-inline-crypto-engine
-              - qcom,milos-inline-crypto-engine
-              - qcom,nord-inline-crypto-engine
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

