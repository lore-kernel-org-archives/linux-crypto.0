Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F76A3B8BD8
	for <linux-crypto@vger.kernel.org>; Tue,  7 Apr 2026 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569921; cv=none; b=Iana+Al6M14nS0VWz+iQ6d74ycTd9pRlKjDFb5lEmwtpVRbHCr1AcNbBzmEVoCNE+UA54gvWaFRAdHlzqSIlYlmMjoX0sUdTPviNjPLifcCcHTxIMqlkrEK1F2QZ8cO+RLqwJvnqFPgad0TjXec5scOHuHLROo+qizY7f5oA4Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569921; c=relaxed/simple;
	bh=CteRO5i+StFpZ/Hbkxhr8vj7aUpLMovvcEdfVXjBI9A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MFpg3MQWkOYF8lZuSD2qkLALbDQ934O8iaD+2OGf1CUjtyIHTICWUSWg1j398wtQH83pw0ZdYM3Fp6F5hB99HleHpndeN8/EmrHDJpAgl86wAPo825nkIDKm3/nr7sZbKmPgXDe65lcGQxxishyWgWerbJXyGvAv/VIPvxujeZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Gpm6wg0J; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cNhp6N5M; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Gpm6wg0J";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cNhp6N5M"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 637D5QDM494121
	for <linux-crypto@vger.kernel.org>; Tue, 7 Apr 2026 13:51:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	H2OdwveVLuWKs4xR/AeCW7VX+1fWjnBXzZwDqkn4RY8=; b=Gpm6wg0J8tP2rOQi
	F5hDgsxHElF37sl9lXhAzdfldIqOnzfQa8Wvr3eyOukxbyBP73ZWdA9yuiQpX7S8
	kOp5eAJwp927Ye5ALyl/TUDrQtDaBwkzCHqqBCaw3pIzSOzYCOrOPBVFRCqq9EwT
	NsbH8bBwF3CLmFAgFMkSH6DM23EdiQGSbSVS0cGfXk/GIFMy6WTJx6lzLVT1QrOH
	ugJ70s8Oi67gPp3iUsPPWHbnn3d5vIAb6dnWVUnPkJq9OFD5AdVQWMNpWkS6/yp/
	lG1iV/J3/g1m1cuJRzWdQE578JERueUjBWhiqRHVL6OqofEHvSgrJj1BvS0hzx2t
	3js7nA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dcmr8txaf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 13:51:59 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50b802961ecso64678211cf.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 06:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775569918; x=1776174718; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H2OdwveVLuWKs4xR/AeCW7VX+1fWjnBXzZwDqkn4RY8=;
        b=cNhp6N5MxWvo/iOCI366bESaIhniM4Z0APXqKsooDq9YLaiuaBPzYGPzWuj+Jq8EKM
         INylf1pUnVXRqHhLggCmGmM55wsS5FK6BX0caj8NnePfrMQWhnqTylsSHPzpGgRovcLm
         wt/6+z2nzgveelcsswvB3HSsqmrET0bD0ritucfNCNi+kgwRgvAB3YuQrsLFIEEQzrrr
         zynhj25FTPPHssatOXBCpbpYwREu11sv0HIgiVIMVLPqd5jfxg4Ovm9/zv5eKcY+lVbf
         MzL6chUhJOjsUXH93lmDWO06rFdKk67B/72vccBf7F65Le7EGnhZooo6oTVbJzklZYS+
         TtAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775569918; x=1776174718;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H2OdwveVLuWKs4xR/AeCW7VX+1fWjnBXzZwDqkn4RY8=;
        b=tFvtnKIJacPmp9/hYmiUgo4Ne+ov8YbZVmia+e53AiDO+JAjftT7yFcrwd13OJx6mq
         ZQnMtRW23MEevw1lEidfdbIA9MJvmwKsoYmaa7TXXvCx6rXKc9YgyBmyRNQYH37X0R7d
         loONCSeWOwPyUhSpRKT3Z3fTxVkuZuGALOS8adJ+qE1gNM61GyIOVLksriPIV87lWK5a
         s+xUSu2A/zsECa/AD6kcN3MmYkS/a2lmVk/13glvkAdOI3y1KvUYBmVopwsQ6giB5lTm
         ywO5CjXK0bxCIp6qfB6u30BIC+ha6uNUcLaTauQhinlW76HGxssm4TwCLDaD1dLUx1Zj
         XywA==
X-Forwarded-Encrypted: i=1; AJvYcCVG/1OBumK6iP6i2d665CXICXQBHG5Gb9knKD2AbA3MA+g8LypD4vHcDylaSuoi8tnS76AP1WoIm22Mi+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYepkPLEYOfM2MHBwInr/QzvCyTRYBnofGJqSN2721LRtxAbJF
	e5zYE3wqx31Yni/ALKsiNGRD3s94hr8vbWdPgyvQGwJurN08fSgcjm70DCACPAkC7K3FQa66Kzo
	CY3k4CYd7SObsJOcHQOvZzt91JHufaCtfbyBMBoWi1RlFbb2+6xYU7nVOS6riwlZilIw=
X-Gm-Gg: AeBDievbcPGVpIEYgqbwc0WrGrfSW/2zYm+waEPoIZo7vhInJC6Kuu5oGmzam2GXDOB
	i7aTobTGzO9nPbPuRNEJh42qhJZc4MTVxEX+I1/if/wHJ7F6p6Q7iHMlGyMug6dVsTILfzGEN9T
	mM1BXROu5UFvwhejI7Fqx2XmfzAQDv6E+G9bBFmZ6VqRjhEg4NGlqiZETGSYixLRA2+bANKL3QF
	+qJxLwOR2tMcKiN4vLYt22ePnmbQ9jBXXL8XgbUEfUOWrsGi7mmUCxfE0fcXWnUEJMY3ggsD4ji
	gyJw/JKRPRxwCphjD13rX+RDEAsCksGIGGkkIKwGxfIbhpNWxh+FVLrQMllFRYHGL24fIM7k+Bq
	OrvY3xjDV7usqXZRC/xVQfpFb60GGVo0jMf9gFxNVVEkX
X-Received: by 2002:a05:622a:1990:b0:50d:998a:2d with SMTP id d75a77b69052e-50d998a09bfmr76447181cf.50.1775569918446;
        Tue, 07 Apr 2026 06:51:58 -0700 (PDT)
X-Received: by 2002:a05:622a:1990:b0:50d:998a:2d with SMTP id d75a77b69052e-50d998a09bfmr76446671cf.50.1775569917954;
        Tue, 07 Apr 2026 06:51:57 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.219.94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4d2971sm49788420f8f.22.2026.04.07.06.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 06:51:57 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Date: Tue, 07 Apr 2026 15:51:42 +0200
Subject: [PATCH 1/2] dt-bindings: crypto: qcom-qce: Add Qualcomm Eliza QCE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-crypto-qcom-eliza-v1-1-40f61a1454a2@oss.qualcomm.com>
References: <20260407-crypto-qcom-eliza-v1-0-40f61a1454a2@oss.qualcomm.com>
In-Reply-To: <20260407-crypto-qcom-eliza-v1-0-40f61a1454a2@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=795;
 i=krzysztof.kozlowski@oss.qualcomm.com; h=from:subject:message-id;
 bh=CteRO5i+StFpZ/Hbkxhr8vj7aUpLMovvcEdfVXjBI9A=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBp1Qv4uXLNfGZ9jichnIdi4AfX/zJ9xv08DvHek
 JHOYEzvi9aJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCadUL+AAKCRDBN2bmhouD
 1/EFD/wLHQteB6O28x3jC4oi28Wvoi9oeB7SyHR8+wf4vIXYIko2Pbs+cCVwT30saV6PmaDFrRP
 JQztRLJVl7UKHAExI6KNotQQjLXzw1M5gAqYvyUEJ7igZDN61BNP6IWjsLI9pc+TrzRdtrBTtQ2
 JcHFzv67kuLC1d32kHOCpiJDcrnYqpKXKT0ysRMeUzZwAY2uLVXmtMwQI6BSFZY6shROpb+AhGC
 xDqWTgvAwXfnduBBFO8SyAz3oSHbW+i5tq4DZgQB1rSh3i59q8neo96kidatDSNoYmSkKVkIlNX
 wrIywMEOrBl3XzbEpMtBE0um2VARfxwCfsGo/sWGwA8xXSL6K+RT32AZ6A004q8ht/4k0ut/nvb
 jSsotAAB+XJlcBsQJxIhUPsYEohbPI3gq2H/292ney43KUKRuJy47Ea+MOOpU1mIXoqYMkAUZ6w
 0KzhehlSpGwZcq3OrNCm+/ZXYlABw2HKaBeX9g0Ta4FHHJfQx1f9KwFk7BOTvkKZJo/3m20UNp1
 OlT94ikQ4j8qodtuCoeYJTxl15T0Io9qvrx23ygJkewOadFMWyS79ifdHK3BeQuk6VLTFjfXP2a
 OruExZ3V6smu4iaX/kvmaScsYtwYfYaEZdmqwcKz11QTSLAvKt4lW5831JHLZ6fL6kkQxHJDzmM
 lCvLV4sjMIzk6Jg==
X-Developer-Key: i=krzysztof.kozlowski@oss.qualcomm.com; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B
X-Proofpoint-GUID: tTXFi7pQXAkDkzuGfqLZAqDOxM_pohwe
X-Proofpoint-ORIG-GUID: tTXFi7pQXAkDkzuGfqLZAqDOxM_pohwe
X-Authority-Analysis: v=2.4 cv=c9abhx9l c=1 sm=1 tr=0 ts=69d50bff cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=gOEeR9iKwsj33Yj5oN/cWg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=wJ7VZ_Z-PFiF5o5xSc4A:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA3MDEyOCBTYWx0ZWRfX9CCtHdQYcKuo
 jz/0IswFK9K3lyocDDkZKsqmFSrGrPqp2JnqBhCb1yOIPYtByH1gsQT1/QbT8+7YZiiMM703GvT
 Am3F6/y+111An1fcm0YvS6LsZK/PR6SK8RIhHll8qwP6/H4m+rhFpsA0gI/tUSt7Upp/4ZfvXPH
 tB+7fiqnUcf+TtC3EUjpQfpEoD8cpMj5nKlkA2oRpRXX9iz1Jcol02VVRsqVczOKFL+T+EcY3Lc
 gfRdZpxW+iU3Gc5phABMZhxuwX1kjVJ+UBm0g3okOgmlFHLJVvZY+he6N2PUb/T65ErQNI5K5am
 sy4ajacmeoK39sO17UaiEkdsrUvBdVJD8TbzB1xdfmEuyNTvRHFBaFAiaEpb7QbD8Sf04FOUqlm
 B7yLQaGjxaAp2VtQymwlHlV/ZU4gbv5uoBG4bAMtazYZtyz23X2IyNEu7T83vrkWnjnJ45L6FbP
 iiLidFmqULvY2fY+oGA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-07_03,2026-04-07_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 adultscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604070128

Document the QCE crypto engine on Qualcomm Eliza SoC, fully compatible
with earlier generations.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 79d5be2548bc..8ca7b3257b39 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -45,6 +45,7 @@ properties:
 
       - items:
           - enum:
+              - qcom,eliza-qce
               - qcom,kaanapali-qce
               - qcom,qcs615-qce
               - qcom,qcs8300-qce

-- 
2.51.0

