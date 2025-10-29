Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8C6328620
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 08:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761726343; cv=none; b=LfHCJcMi0mUP8UVtlFIQrayhfR8vspQiBEvpIJCyipSpkEbl6gR0Rt9ua370XzBTAoy3iOiy2eunkzKO5dRU/RlJ91lxHJ8QfUqERR7A7cYuHsIoDkXEb5mgnv/wO2hyBTewV9HuZUyDCckX6yr6PF7y3OLZHmyUVlqT+1dSPxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761726343; c=relaxed/simple;
	bh=W4lOSMg903GYA1zxTDxFQF9gnP+6sHQAZV34jmuGdKQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=B/TlhZs/tGrLjh3hrg4iVn4sHd2k785JcEr9o/YD+he1UvOr/abcR/Gd44Uyol96Yv/2AU8GJvmLay8f6a4VC7rvp/JIWFFzplO1JZN+Zi0J8Ga8FRinn64jANf7/e1xDZFuaiXPR6rVNYarFCvoZBeyLuG+IN/ZZQsMqdOlM4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lPKoLdqb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Qo5CILlv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lPKoLdqb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Qo5CILlv"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59T4uwt73676848
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 08:25:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	JK7SZJX+MikCqFjK/k66SySTPy7ACr2CTGcmwo3Ayjc=; b=lPKoLdqbDV+aWPRQ
	SgIfMylcGd99Cm+LcN6qZzqnGPiogq3AJ0UX+WebPKXB+jVr3bPbILf1lMDGn3Qs
	BafXexIsoFsLKd98SnrfAN23o+YKcXt2ug10jginxZHkiLaR+bymdt3wlzHGxC7k
	DPOF9ht7Qq7I9o5CcBEq/Ateuzg+s7G3Z2KsAWIaPdAAkqobstOdFxj4p4+Ff8mW
	g5sb9veM/xeKlei3iS0i29ydkLguAmuRPuJaoIaCQyF64+vxVA35hXoYnEoCvGhg
	gxj2Z+6rtrjOcBRdw74augF2ph9FJjiyqdtAeUeUI5bi+Txne4m2jRAkaPSgKmzh
	L83y6g==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4a34a1hrv5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 08:25:40 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7a26485fc5dso5404007b3a.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 01:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1761726339; x=1762331139; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JK7SZJX+MikCqFjK/k66SySTPy7ACr2CTGcmwo3Ayjc=;
        b=Qo5CILlvRlXMGzZKcKbCaigZbMwGepdAw0MWkcuNOUapjkzg+iR4hbApR5AP2fpID/
         vuxhqjjJGSOrOCHxHP2exU3VUcZz6aSEShj9gTDMSx5iz3S7rOyit33Klir5gi9Xw41v
         4oG+dveGasQoWvT9PtlmjTsYp+pnl53Fm0LZc6UzQk0Ia28k+NXtP+OG+DaGTIgJTQs0
         qFhvKKvNrMFPFV5utPJTyv/uk0iuZFlSQdqAFWMCj3RHesrMY+AkByv93mxjHdWCj2Xi
         fQBlqe6ra6ZBBX9JSMesK3TqyUX8Zs7w7aKx5MItIO7KHQUd9w9w6TMKijHU2YU8VBZ4
         oy9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761726339; x=1762331139;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JK7SZJX+MikCqFjK/k66SySTPy7ACr2CTGcmwo3Ayjc=;
        b=iqYZOBRVa60yj7WgWISnd89C47x+mUk9y8hbe/IWFVRp4dk961RP3aCloRh9UMqbf8
         VFMKuKTR82gbGXXO4I91VlQl24b01n0vGtRK0Lg9pH6WltQ+BSH6W3R5RYdxPuqxgIvz
         yA59l+lrcokwZfpJ3K1WFWO19Vx3kwZdry0WXfHGyQHiibz8eCnhqINxjK0HvyulpptH
         x14+Hjr9ku3BKkXKBgYyetH1lOyyxTtMDYa95/Vm4CuDTAmHmeLtoZw0wckk+NTBRh7x
         zd1qa9OefrdWE+Akzzgul5g+KejFrpG/jn2uqpoFLnlaXiv60yCKLEM70ec82f7j6qYJ
         7b9w==
X-Forwarded-Encrypted: i=1; AJvYcCXQB+BJ2bEOJ6WTZd9+LRo63lIhBbJEOeXTdKjnhGpmuayQ0gBXkHmomtduqRWQdbuXLLLEYwUClmaGRW4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+VYE2xBXAMghlK1Zg1rK0RL7V6fajGZMOEU7Bfm8yyI7xaLUn
	G2/xc4mGyF/jDiHBMa+EPz1/oEdC2XvjWAeO5NqDJlHT/0qF5oC1ptmJWYHzjV1ybhnkgV5WCFx
	ox9np2U3my0GAunxe1efv6dO+zoeYv5+RHIjfF1DJELAWcNjLpkD/MwlHilowmgFshUs=
X-Gm-Gg: ASbGncssNUWLbXXe8WDv4FoumEmy9N70L+kHMlO3orNunewSzRtOc5++hjWGwsZK308
	cjwNcRGhQNDukBeVEW8ZLEaejMRH1eAHkvQTTIFLSFcCd4o1w1+oP3+NvDQAdfs+jsmAqKFUtOV
	2FurkssfDqVObsn+UUIR0+yelzs5RwABhDEHjsFNV1k5tvIUuUqfMyu4gAsK3ffiGmJ1xzL1XBH
	oWnrPMDe5UDehsGLZF1YEno7EH2SJqAF/c/BHlKnley0hsUQOLiqW24hOIqVSt50Ncc9H1X51NH
	loEohs1y9rZQt5MX/YN0No2b7/uAKSVLY8vOLjZG3+zhgEhmEx1fA2hFNZfjQGAxmJUOEMpWjPg
	q3h7NIY82pQMF6HFUfIv7+8IbsdCSnc74siU9lQwc7lWaW+DEFg==
X-Received: by 2002:aa7:9064:0:b0:7a2:8111:780a with SMTP id d2e1a72fcca58-7a4e2df8cbbmr2363263b3a.2.1761726339215;
        Wed, 29 Oct 2025 01:25:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECihEvvzOVIGmNK8hPCjT06tnNOOFSohNpSB5zChwhoVvZea0PYfRvBk669noNoCuIzhObKQ==
X-Received: by 2002:aa7:9064:0:b0:7a2:8111:780a with SMTP id d2e1a72fcca58-7a4e2df8cbbmr2363231b3a.2.1761726338692;
        Wed, 29 Oct 2025 01:25:38 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414049a44sm14158850b3a.35.2025.10.29.01.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 01:25:38 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Date: Wed, 29 Oct 2025 01:25:30 -0700
Subject: [PATCH v2 2/3] dt-bindings: crypto: qcom-qce: Document the
 kaanapli crypto engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-knp-crypto-v2-2-b109a22da4f7@oss.qualcomm.com>
References: <20251029-knp-crypto-v2-0-b109a22da4f7@oss.qualcomm.com>
In-Reply-To: <20251029-knp-crypto-v2-0-b109a22da4f7@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
        trilok.soni@oss.qualcomm.com, yijie.yang@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761726334; l=869;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=j9YVsWbXcS2a6HwO/+foiEbEjltuK+bIiq6tBsLubm8=;
 b=2HSGd1hA7of3GezzUr/8YAJJWPY3Tf/fyJngsluCXpx7q1JgTexKLVDv6j/j3oOcPS23To/8F
 7ezLZWgDuA3AEj6HljjgqMpGjAmGPojU8GXzoEHOs4v5JgTNmztkqEn
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Authority-Analysis: v=2.4 cv=Nu/cssdJ c=1 sm=1 tr=0 ts=6901cf84 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8
 a=UTvf6Pk5Os8-KCCN1KUA:9 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: lPxM_qs-ITd6QGHoVKy12mRQ8nvBI9BQ
X-Proofpoint-ORIG-GUID: lPxM_qs-ITd6QGHoVKy12mRQ8nvBI9BQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDA2MSBTYWx0ZWRfXwyxeMgRYDA1g
 VtO2ozDpN3rKPUl4SInvD+ej+8XTT7Tr+VGPq0UbR333NTDXlLJK90hEYcgie2kUqZZ8uJQQaaJ
 YCLkmD5w4vnw6rnQrDSL20uUz8+GxMHX8Pu+be01bL5MkleWBg75vVckNbLo+hTR07MjzMHu+Ec
 rxLETG389zc7e8YBg8HjLzzFpjRn/3T0Xb/S27LVGlLj00o4jh8Zx+FpgbyubNF747oNYaTcA9K
 9vNgvwXCXEtBi1woehPs1rAvnMeX4e9SBRlVQKPdzZLEosxcuoENXrZwcMWovf+YZpIOqmwBSRA
 5TYmY4r7eaeU137BtEuzC3Ie8oNsJd6nKuISJpmmckvWeRaFpiKjxwp8+SVekSnlGFUV4uSqKNz
 RaObEB85UYlzS3n5WgwSqEiL0oED7g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-29_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 adultscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2510290061

From: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>

Document the crypto engine on the kaanapali platform.

Signed-off-by: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index e009cb712fb8..79d5be2548bc 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -45,6 +45,7 @@ properties:
 
       - items:
           - enum:
+              - qcom,kaanapali-qce
               - qcom,qcs615-qce
               - qcom,qcs8300-qce
               - qcom,sa8775p-qce

-- 
2.25.1

