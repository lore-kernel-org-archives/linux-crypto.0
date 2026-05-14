Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB923DFC8E
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 13:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778764607; cv=none; b=WBXAvoRlL4DGS66pddkNECE3fupGOrcMgbFV9nA0FmLgT4kBGcaGXKl475sVKZQ02qYF9uWvN/3/ea+AqgEz8VNl1mjcIheoj6l61p5CnM+rc3pd1XrKT6MbmtAbd3X7/IsgL5+KAwfgYLyb5b4z2Z4ioHQBLNg0at/wKUodW7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778764607; c=relaxed/simple;
	bh=6dOmXBHnW6tKHtNL7QoMr6t8ob0iBTXb0NJR/FL3v/k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sWN9Y99AP6NRoixuhcIntWHcnbo6FVnB6MKhaz8TW/UkYxbDxQ+eOu+XUcsMDxTbzB5RKFQglUTNzUpT3qplKUmptkzL9HwVOJWbPDb4UOVZ6XQEkK2WxHZUOZ+juHHlzmuWiSRbm63whLvGltq8Ms6zSPdQJJrxHfl7Btyjny0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VjAkdJfO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e6E4iOIZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VjAkdJfO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e6E4iOIZ"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64EBeTee889388
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 13:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xZBik4vQ6oskEkHVvAPfIRk0jhTzMgdfctoUOWCvyM4=; b=VjAkdJfO7YPLU2FN
	nFU9RIlUvBd37rwypzzACRGaZ+PUy0IGK5q1b/irX7Vdug5vcSLlE46f2xeLU8Wh
	b78lhEGr2B6VMMziJUA9bBjHVS7Uok6tG7l5SBS8zToPnCFgUAkwml0/VV61Diiz
	3fWfel9vChv7p/CmLxNAsg5MJg+dQ9ypPkgjIopVbLgvYFhDOQD0oiN68BUZahGZ
	d50jmw2BiOFS6SoOYtQ42fiqfZSoZsPsB/S8PoiSdEtJn6flbXmPC7Pw6DuuCa+u
	bDDZhjV13ixy5EyouA4MOgBfegAUOkP/qkfF31vVPSNKf+hRqaZ4OFP9bioLXt1/
	FnOBaQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e4vkjky8t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 13:16:45 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82f756ebd0dso5078965b3a.1
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 06:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778764605; x=1779369405; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xZBik4vQ6oskEkHVvAPfIRk0jhTzMgdfctoUOWCvyM4=;
        b=e6E4iOIZSwRuq1M8BBr7HYu5Z9DnXa8z8BVauRwlC8azRTRSjxJp/npZI+iHmZxuES
         40i8eXFIXvyHNlsymvYzRqmaGPoHF6R9KUBGloD3d2iPhC+DGqijrmf8MjUFxQaSXhJB
         MRxIxM04iMxPom2eYi+7HheTZMed92PXpL2dwZLcguDpGnOeixaNQwWPgczYelMdKA9J
         MvXGe5cHWsGQvvlju02BQxUMP/rSWUrzcDZS1aSZjfA27Xmdmq/JzJtFBj90ZcDCvKWi
         6vsU6jC0JNXZQsMAHYAbm5aDDKDEmBNMEuEeuytUGIESnkvjuJHEMvGMwWEXn71497ue
         GpqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778764605; x=1779369405;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xZBik4vQ6oskEkHVvAPfIRk0jhTzMgdfctoUOWCvyM4=;
        b=TpSH56SPTY2LVlcAVpz/07nA9/E3gJ6lvpra/zIuhPW5jFV62oXWmk0qSOU8JglY7b
         tJ4pusbBezWaGn3go7xKG0/WNROcs6P4psZ3VtQ2sOk6TWkXf4UI4zuO7YVX9RKTfax3
         Y2tkgPQVoeeyFXM4ltKaVGUShrd4Vo26DtLxvVhjh13wlwexX02nATzRw7EYfTjam8oN
         B8pzJkeGsbJQFEANfwSmKSSRHianYiAeUOO38Jp0iCh/S9Uq4kgLj7iIdUfuHuAwjkXm
         gYd7MncFAWLwm3kYZXE3T3NB1R9iyll5dBpVuKxjLXvF62KcxH5wyf7tGsIFQAoF6POW
         P9hQ==
X-Forwarded-Encrypted: i=1; AFNElJ/yNwnPYh0BK+SSqOeh+Eo6tuWrAk7h9OtLxJfhLksxhibkq7WoIYboYy12hj3sl9ZvnDdSkWDu0Mcr2J0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7XjBBFW+wf7zWjWhb4NRNXOWZtaWupxyv6MFkf3hMFT7snVqT
	X+tthL4wvI52/NB2lKfQj9bzTW0E8NnTvZ1xUTiuxKdHEFFMSpnMsMhzq9Es4zEj5EAGfST1TZ6
	yLNhsB+M0NMz17eQNUIeg6JomTd/AdMv6mv6lE73rWaNnQkJDHUEgKbYBnnVYpFlHhK0=
X-Gm-Gg: Acq92OEB66FuHu3XAyZCSf9Ck6NXfQsLUx8Gf/cjYirfemHEpL1CBcudP8zvIHLCfdQ
	ikVvzFbiK/TPZ6JkoEPK2erqjbNpKheMaeiK5+RCQfbijh5Luw3GROCzhTjHONxpgEzYRMgBvNs
	/GW0mLA1e2VLT9DqH05Qn1Oxxea/PJjSldrTtMR0+31nybUOrpk080cz1piP20ODpEYOP+q4X30
	JZfZDm3Xofp+E590Swjl+EmfpoOPepFOEs6MzrPzdgID7+ErYn7Iwp4P1bbzTbIRdODsaQEAhp8
	bJu5TahF9hMWY/rLLTJI/f1EK4CDmMNOGLe9gS3VlVU77d2bDJcDcID2BZmfPe7jA2TnTt/Ef1y
	/oje/u5yOx0tsvSBcCWeih1G7YMvAy1Rr+zxxb8BfBfUXuvs1OtkkQLwoYXQUKAWL2A==
X-Received: by 2002:a05:6a00:328f:b0:833:2398:cde2 with SMTP id d2e1a72fcca58-83f042f35b6mr8247225b3a.43.1778764604570;
        Thu, 14 May 2026 06:16:44 -0700 (PDT)
X-Received: by 2002:a05:6a00:328f:b0:833:2398:cde2 with SMTP id d2e1a72fcca58-83f042f35b6mr8247184b3a.43.1778764604068;
        Thu, 14 May 2026 06:16:44 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19c7f202sm2666656b3a.43.2026.05.14.06.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 06:16:43 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 14 May 2026 18:46:24 +0530
Subject: [PATCH 1/2] dt-bindings: crypto: qcom,prng: Document Shikra TRNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260514-shikra_rng-v1-1-4ea721a1429a@oss.qualcomm.com>
References: <20260514-shikra_rng-v1-0-4ea721a1429a@oss.qualcomm.com>
In-Reply-To: <20260514-shikra_rng-v1-0-4ea721a1429a@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-GUID: mR8_AxLAchEMyJ3c7rnVBICZNPyTxQgf
X-Proofpoint-ORIG-GUID: mR8_AxLAchEMyJ3c7rnVBICZNPyTxQgf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDEzMyBTYWx0ZWRfXzMu9SE1YexdS
 8zcE01ZiaijFLDbOeZmQT5YUaU/28Mz+0yJfflckscnR+L2wfAgX5GyKpQyODq6gwamwAtOtO47
 c0m4FXe9bgmuPK0VZP25/wr8g8JW1TlUfMckMrS8PtiAYxuoyYF2SsBC1JwEXELGX1g0MGBXoX4
 J2d1l9BVwYaiUnlTofvXNm3dKte4kI5szTHTB/it3AQYaCC2oEFMnihkJrUAni9PZLRCtRr15Um
 tbrDe74yZls7D0H+5+EqFXHvoOZBYWheDqoJrJdL62c8UUXy95w6vkC/Q2fx1yZeAnSBGyqlamv
 P93H9qAH1gTw9S+Dxg3iAvERiMAR7Lr04qR6ugMi5NA4kmzgVUosYB9O0Cruo3QmdxEjCZqLq6k
 sJTJWXVCq0fN/j1DqqBsyEDCZTSKkyAwb+v8OVL+aOf400cWxg9Ip1v4VyiNymCl/UnJc5oDpBd
 HKaIOkqtx9wB3vdDZpA==
X-Authority-Analysis: v=2.4 cv=PbDPQChd c=1 sm=1 tr=0 ts=6a05cb3d cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=mVMjwrqIa5QPTF8STQQA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_03,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605050000
 definitions=main-2605140133

Document shikra compatible for the True Random Number Generator.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index 498d6914135e..e2430280b2a3 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -28,6 +28,7 @@ properties:
               - qcom,sa8255p-trng
               - qcom,sa8775p-trng
               - qcom,sc7280-trng
+              - qcom,shikra-trng
               - qcom,sm8450-trng
               - qcom,sm8550-trng
               - qcom,sm8650-trng

-- 
2.34.1

