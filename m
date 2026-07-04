Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69075288BA
	for <linux-crypto@vger.kernel.org>; Sat,  4 Jul 2026 00:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783125864; cv=none; b=TNLjsxlb5KB6C9IN4kqkSu+fS7ufPdx7RS2DAbiHsOfgRzIpdPoWi/8O27CVrzvmOcac2KkgFJfL0q+fnv8x3DBCppwSQMkhIIfRMVkXy1kcObz3ZjOtBgkZ8+sH2DpfL+OBZQCVASFEjiXxg2/X9CT6KYT8c5d4c5vchmJaDzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783125864; c=relaxed/simple;
	bh=N7vEJ1clTit00fwCGUvWO2rua7WCCzdrl7Sy7uBSfow=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=txQB/lw8ERm71mQf7iHAvvDDOQL9+JXpYXoCuhAP51gBujRfiJwSb7OsMhOci7s/oNu8xc62m6CQ9vnE9p5u+qhIbmOcBVQ1gSx8HboCIdCXoq8Wvmr76LSAXZogQSunrrxnsIceZQ8dBm65LmVZO/FHUv36T9cQS5HqUaFWW0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Hu/T42Tf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A2Kv6xkE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Hu/T42Tf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A2Kv6xkE"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 663KPaNP1019673
	for <linux-crypto@vger.kernel.org>; Sat, 4 Jul 2026 00:44:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=kWLCWIdXV3P7AORzTQrp4L4mpwNnbz+F+wy
	RzganFkw=; b=Hu/T42Tf42mZKimFyHzzcnPbS6U0Rf3moHsb5fboOsUT+be6+RI
	qThvCiukiyCgpCBrUZIq6cyE/7fcIgQ1nnxQt5q+hY1ykRnwX5wd+POx9UcbVefl
	K40mV+pZ+zxp2AKhU9TZ3wMBuTZ5/QRLYwN0DciSuqq1XXFPD73gPH1WKvte8Ek/
	D5u/UlXzWyXmwBfaDyVfIX5cMMDmwOrXe25rLiKW26tDtOtayRx/r3MvWUkmKFfx
	M/P5yf6RxPIzq7aA4sAt7jbtPLm6l3c80vU9BtIg/0E3ZEYZRfXhEHBh3eoRjBaE
	ep5HsFo7/5eCMYPjf4NYa8vljRMrwFuxfDg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f6ckj264f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sat, 04 Jul 2026 00:44:19 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38127ae6b99so1393534a91.1
        for <linux-crypto@vger.kernel.org>; Fri, 03 Jul 2026 17:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783125858; x=1783730658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kWLCWIdXV3P7AORzTQrp4L4mpwNnbz+F+wyRzganFkw=;
        b=A2Kv6xkE3w9bjDFueYtfroj5+C4aVmEbhDhEmVwGU493gBaOZiwdF/2bRJTHuEmGn4
         Iuj/UQ6ONW/laz1npvXKXX0YwDaFUejjxFV7CsuRVRipUGVJ4C5UIEV4GJKl4FiJwXw1
         yrQkLNzcAmJpeKknSNT/xil2flI1qLDGyb1UXHQdKTsihqXSn8jmkRWiapteBC/X6WVs
         YS2+LKwF+eLcxHsRme9zCiPuEM8SQhKowDQyMTIYHBS0sXCr9jyjrN2vqseWScBrqtIX
         PkSoxYDPbmOXpxRvl3oUBaFzI0GgumiLAZ8Ow4k0Iqw6G2CLkeVw8mbLKBBpINWKEv4Y
         Jjeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783125858; x=1783730658;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kWLCWIdXV3P7AORzTQrp4L4mpwNnbz+F+wyRzganFkw=;
        b=EV2IK5pU61AsTljURsrsGCY0C78zXHjTp0anNaQR1MiAVCnoEREzpgZH3UhcA82pMR
         tIZGgiVSdmHcD9UtGEtKIJq8bLTG8HPpUCV3vnhah2KctSzmW9XVJA3hu7yoJpWxsDY2
         kPzHk7HrZgtAQPFNXbWJtvrVkse2MQwcU97KCNY8rqWTEuFWaDlSRoMYz03zMoEBc+rl
         4yPg6HHXbeFDmIi5BFynXPxek7XltgE/cqok9ZGpMvgVPjSy2Z2mOV3hUF7HPibERuJc
         HPQYG5LYj4fsCw19xSuOdwW1DjaGD/wi+1l6QQsGty/z8v//Xws+uWDrSG61v2UTlP7s
         FVOQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpfkyo0jsJLyOZ3PqPtum+F1Tw3jvLO+y0P3k/X6iNTwyfAPZJ1njnAfNgcHxNpF6tT2hJ8BCd++1v4Sa8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7kRLYaPBca7FiGMxTPKHvMxO9AHUJWB96YRGOhOWPT3Sl/oqE
	vQKdCV2PyO9orPfxDuUDjUJzAIPrVgnr9INR8aJx1t2KNgFCmGt/rLOZlpby7iz9MF9Bsmq0j2u
	kqdPMrlhAjhDiDB77XAKYt9feVjg1mY2UZq3GwNxO56W3b3cQWA1lO1yhjnXyFJ2L7Y4=
X-Gm-Gg: AfdE7cnUu9Q5pCjkuSd3wjEl7ENfufma1g0M4iWeFXdezKbSDHSd+mf9S/6UYSKtGKD
	61tQCt0wefcC8lRRhIbINNm/ArII4lhF0PPA50fXPwMi7N6eVtVb5HRJMPmkOnX7tUQBvtSPnOB
	CrI4X0/dLcPl4g4h9J8MFErdrHOgj5E1dKGahrtNp1tJzH0jxEbvHfzL9co2EQ/iSRU79n3OefF
	oy4qGWqkAvh30P9PvlYocdQJZ2NBnGJ2vDHQFoAdDAUkY6OdBZ4T3/l+sthZ4beJM38YT2NZlQ7
	6lfkQHVI5q03DPgzs6p6kEj8BnRSD/VLZgxtONtWiB0S/qhPZdNGuJbEQUfTbit9lgnJX9hl0T4
	AZKyrqtuEhFYlKs63gI9SdU2jaa1/XsNvSqxptgpVb+pt1ewA+98V6rbdqaaX6DIMCqnAw4w=
X-Received: by 2002:a17:90b:1e49:b0:369:7491:7b24 with SMTP id 98e67ed59e1d1-381120b2f0fmr7021887a91.6.1783125858193;
        Fri, 03 Jul 2026 17:44:18 -0700 (PDT)
X-Received: by 2002:a17:90b:1e49:b0:369:7491:7b24 with SMTP id 98e67ed59e1d1-381120b2f0fmr7021860a91.6.1783125857678;
        Fri, 03 Jul 2026 17:44:17 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f44fba9a4sm862777eec.10.2026.07.03.17.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 17:44:17 -0700 (PDT)
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shengchao.guo@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
Subject: [PATCH RESEND] dt-bindings: crypto: qcom,inline-crypto-engine: Document Nord ICE
Date: Sat,  4 Jul 2026 08:44:08 +0800
Message-ID: <20260704004408.2303468-1-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA0MDAwNCBTYWx0ZWRfXyftFTkBNZFMo
 Xu+f716fk3zgiZECCwzmgwx3D/MZVEa4Yd2Cmepwpf21VU9oAD4n4x8uBg54t6nSFCyDBVJNMpX
 M5iIzh86/v3c8H+1B+1Zx4K18nREay8=
X-Authority-Analysis: v=2.4 cv=E8v9Y6dl c=1 sm=1 tr=0 ts=6a485763 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=qu0NaVmkdm94GxaCK5wA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: Xz6lAJzNp_70PlvM1yEK66mXquHbLFmj
X-Proofpoint-GUID: Xz6lAJzNp_70PlvM1yEK66mXquHbLFmj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA0MDAwNCBTYWx0ZWRfX0ePCG4EpBCrn
 gup2RvK6mRgNZl77aPegZH2DnkfvDyWQCz4JqNThVCahoZlqZarnymJvjjUDNgKlmk9OmnkqiPZ
 THhEjOZn6kg/GWJfnUHE1Q4JoDcvRUe06KwodQFHWC/qVHTrdY9covM9rbGglnD/81TvDM3NXJX
 HElNwQZWGrPQQwnGAS8vx0PRapcg3/yXrNrksXktG7F4E2bOJNJ13TBLkxnFG4qQb/tiDTbb56S
 StpwyeatoGo2nj8mGvocS8Xfm/p39I7cggLQ/69IHXUpCGWyWkU7sGHXVE0xX59+WJynRxSfTcs
 vofJzcnMrNc9AhZsZwDgmRGtx3cykhyqDeYBW5xw6YD49ZIY1dD7SMvDVg6zsoH+Cq67S0No8Dn
 Gee0FifYkN/sYpbwAKqx7A/+xTIH/8Niac9L8AlOm503e2vKVWGGojj7S/jpnCisDPoBoOdvBH3
 fJ7Udd9WpjF2jpiqhvA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_04,2026-07-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607040004

Document Inline Crypto Engine (ICE) on Qualcomm Nord SoC.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
---
It was included in the Nord SA8797P DTS series [1] due to that
the prerequisite changes were picked up by Bjorn for 7.2. Resend it to
Herbert as the dependency is gone now with 7.2-rc1.

[1] https://lore.kernel.org/all/20260526051300.1669201-1-shengchao.guo@oss.qualcomm.com/

 .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml   | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index db895c50e2d2..d690eff2e86d 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -17,6 +17,7 @@ properties:
           - qcom,hawi-inline-crypto-engine
           - qcom,kaanapali-inline-crypto-engine
           - qcom,milos-inline-crypto-engine
+          - qcom,nord-inline-crypto-engine
           - qcom,qcs8300-inline-crypto-engine
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine
@@ -63,6 +64,7 @@ allOf:
             enum:
               - qcom,eliza-inline-crypto-engine
               - qcom,milos-inline-crypto-engine
+              - qcom,nord-inline-crypto-engine
 
     then:
       required:
-- 
2.43.0

