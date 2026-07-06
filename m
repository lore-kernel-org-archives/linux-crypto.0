Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716D241DEE2
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 11:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783337534; cv=none; b=PhWiBxcdDCqQ3XJbX77idL/DGvdIxa/h5vyUlRr81t/sD1z5Xar3SHGKw2c4VPN/fkwDKaOAxK+QTS74AlzHySJIdcik6D2h6KJY2yMdrljz+DKYL77A6OF+gw6wYPsq4rJR+rIkQ9q7Yc3OiJOWKZdAeZnYartGXAohuy9h194=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783337534; c=relaxed/simple;
	bh=BDlrAUN+dv5+3Nw0wSTNRFS1ZjZcXmnx3mZxq8ZQoV8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HHS6zIV9+L7da8A7qGECVxCeo7yIRtL5Eb4GW0jKTvo6Z6WITiATuiuS+xWk17MclfNOv/K7HQssOSb7bcqUvHzc1JAhbYfWBgXwdilly4YL7JLLe19AJGu4M/hF/jzyvmHVWJSELyqP6WRKNMapd3j6/cEyradhzwyFEPulBRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Bo2G3XOd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e9zzsY5a; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Bo2G3XOd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e9zzsY5a"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666AxDCP395293
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 11:32:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bs/O1MjHi9/C1TWYd/oU2riKYYdfbWdhGH5f0Eox9B0=; b=Bo2G3XOd3wvd1+vn
	o1OXbYwH7u5LOrb9J7Z9FLcCWONijS3X1b2nk4BB3zTuiz3XLdO2LpPSqwGZF4Ec
	kyqUCGMftOkvnMr/zRmO3HMBoyb0C+OIF8/WVZFiR+KlXCkrLotRvGNDShUrMs+c
	n9pW7XdV/i65tzJP1QYwyMHKqmssA5esjAWTTVDXO2vgpoSspxOmB4l7qzwjKhnY
	ScEvT7GUDOk1NEaoiZPJoMLn1hQdbJuQv66m33ntmi7evTcdoeO2o7Qw4R5cnVKH
	551Q8LZxt3opdZ6g4dEoHlGoqhR6wKLDQIO0GgRG7tRDQR+OzjcsS2HRK3uSDuba
	GKLohw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f89qpgfcx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 11:32:12 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-847b8d76e3dso4953815b3a.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 04:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783337531; x=1783942331; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bs/O1MjHi9/C1TWYd/oU2riKYYdfbWdhGH5f0Eox9B0=;
        b=e9zzsY5aScRe9inXpHG3vc3ua5FfVUMs0apkdGHpZwrgn2g9gpjuOEYbLTSjvxXlp2
         DCZs2OgbQaIsgG3FKHGuFX6njYVyo5cTnwuEx3NKelvSFf2lVukZMSLN4/BAO3OLunrV
         Q+vxOB/cqsXDlXQwKlTxAjF+y5wd5KSMLirL/Ocgx5SqNQ5n838XUh4wvtQWvW15uQfq
         Tz6m68jdtr4JhC0K2Yp1a6BdKpX+uk5XStCrXZ/L+mhe/QdZX3fv70QQw16HCBYZ/5T+
         FJMPTCoeqYOBcnFe3joZ7V7Q6MLrRk6pkGPg3L9ORCKzNspR6PRqkQD9Ln/MQWA1NrJH
         gQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783337531; x=1783942331;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bs/O1MjHi9/C1TWYd/oU2riKYYdfbWdhGH5f0Eox9B0=;
        b=OrX1FjYSmPrgw1n2922iItzn0VR9f5kLz0h78VbBcluFvhPi2uTMuQCRV++iqAAtLR
         saSktQkfwEmXfjERyHsXfWuJVYRcineGMa0d+huSygdAAbarDrLP6jzk9Foj1g+NzJ/U
         O+vpIUwqD/6JRA4TL93CYLol0KiI3UVHxv11awOzCUVMMkDlbwk5EA5eSRA11Y88ULoS
         muQGnDA72lrN+37folTmK3PiTdstGnXxuCmCgz+Z+SdSQnoBYWDbPh35L9OdjRHN5nfl
         eeyZzXWldqES9CpSYHEkzRi02U72O3Kwa/x6CTfKuPrE+IPZLzRExMnvP/yJB3wgI1dU
         nqSg==
X-Forwarded-Encrypted: i=1; AHgh+RotalaUIrNiBAbZnMDaS9y8C1fmdODMxR9PLikuff5ToA1N8MigsMJ9nbV6GS0Gl3gSh4OArMCGDlnW4zM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOOpWTKxmgNXBBl7e84twg/+r2a+99Up3wyQYedaCqKzLDFNOC
	L+Em1KcPF3tZXAVk5EduyYomVsw77GL2L9JAWV9SEEMLYTKN+jQLXX0VW/N1iz44+HCI9VaeXvj
	S4nUpIaZ7cCzR77wToasvwyyhov/JEvRfYGPUJZmtKptgQIox5Y4newvwn361NTkWsSs=
X-Gm-Gg: AfdE7ckM5K/XEfborybV0AHtMEem2K7HjDI73H3MOqWK3YZErYETRmFgmjhxK3cP3H+
	T+3Dcy5Jiq2rqUKZ1K/1bq+QrTNnCXU2qis+dwr99Xxn8C7Thc8eVXy9cDPfveoehEW2/l6LJKX
	+8gq0sH5niL9gzYqDnC7HvihuK3LDRU0jEOBBBB0EMTZ5r3B81tx4xazFwGYpgrHds6j1D6HMX+
	9kcYhAXzhNPzHblOSn9tWfmLK+KjthBRNWehLgAfzsdgZhHW9r8E5jK+GKWqtJqXkHj3b8uLOzU
	wZZ48EZ0aCqNwVP3HPE9WZ8TYVIUA/u8OSOrBhk6vR2MZc9+erHYbq81RlsJcNDkG1Uu1sCmp82
	Ua3jq4YY27xrPKPk3KMnhya4RKpsicnF+EYyK+9qOfrz4
X-Received: by 2002:a05:6a00:2381:b0:845:dffa:3740 with SMTP id d2e1a72fcca58-84826d1260bmr129663b3a.4.1783337531450;
        Mon, 06 Jul 2026 04:32:11 -0700 (PDT)
X-Received: by 2002:a05:6a00:2381:b0:845:dffa:3740 with SMTP id d2e1a72fcca58-84826d1260bmr129633b3a.4.1783337530993;
        Mon, 06 Jul 2026 04:32:10 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6dbdc8dsm3576621b3a.55.2026.07.06.04.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 04:32:10 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Mon, 06 Jul 2026 17:01:29 +0530
Subject: [PATCH v3 1/6] dt-bindings: crypto: qcom,inline-crypto-engine: Fix
 legacy/new SoC strictness split
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-b4-shikra_crypto_changse-v3-1-23b4c2054227@oss.qualcomm.com>
References: <20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com>
In-Reply-To: <20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=c6qbhx9l c=1 sm=1 tr=0 ts=6a4b923c cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=LJhxytyqajTry7azkiQA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-ORIG-GUID: LRGil5pvBxKsxFf7xlTczoD8lMatg7CA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfX3CCMRbkwZ7ft
 3o5yaQkcNJ1Gdfrdzo5YyQy2eB/Qp60an1q/uBsrhpByRtoGGP27238pHnk2TvT1vzPZvKbZX7F
 Oa6jW4FtTXLOcwtHSTGvFBzUEV6IjGHHDeP6C0O4O7ZQBrcX9hC4JESfuQxzPPOv64/LbVr5xpK
 vvcxAvtgwBKQd/vaM1tkwKuiewpz7jGJyHu6Kze6ejB1LtFoCX2WPdjsEZgj5leAY0ocJ8MAtld
 hC7bwewu6bEQCSeVi6WynpW/cG+vzgXkghGanqQPh9ZaX90yT5T6HTIAV6+S+agfyHRR07sWds9
 vDAqV3a6SUkxc3k+Nma74dXclN7LHAb3j84TiwVUItbN5lRlRY5oT+ma/FDhmTWCCIZrN2u3fnW
 DyC1/SxnwsUxfQBiUEIXJduYxGbpRf6T2sUk18y/ifgM8cfm87YYwd8Inn9Mz/2EDBhIZxxsD1+
 BVLqeofuMYujZgr/ypg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfX0d+tsF6wBHNY
 /7CiGGp3dXxc30Q6OER+tvkSnNEdfLa7XnB/98OXl/AHTzoOJj0nMF+YQsUGOCRB2crmV/ZDoY8
 hkfcweIPq7TQjyaaxQL8o3XhDS1rogE=
X-Proofpoint-GUID: LRGil5pvBxKsxFf7xlTczoD8lMatg7CA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607060116

Couple of already merged SoCs(like sc7280, sm8750, kaanapali etc.)
describe ICE as single clock historically which are recently updated
with mandatory 2 clocks.

Keep only the known legacy compatibles flexible, and make strict
validation default(of power-domains and 2 clocks) for all other Soc
compatibles.

This ensures old DTs are valid while ensuring any new SoC (like hawi,
milos, eliza) must follow latest requirements by default.

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

