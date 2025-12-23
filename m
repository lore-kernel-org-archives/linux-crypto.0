Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894FF2EC0B5
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 04:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766465321; cv=none; b=W1GJ+yuEoyt2py4vRsdlGm+4o9OiwHBsqQj9wdDEh9zb7FanU5CuBs5Y99yXIF08ha5bPL+rgrWHZ1RY+qwY6uldyUiAo26NpoDl2FMBUUrdYdZdp3vKcTJdHL3wI/8thy0N9453TXPlP32BB0w4EtbHN40evmzpfYRfOkh34Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766465321; c=relaxed/simple;
	bh=U4kz/WI7ex0zTWa7x13E4KzWLO7BwMKRODDSPUERHGk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=quZ60Nu+AcVIlhy7HOJOdnB6uq+mcaixGpZx23d7CBd2zIms8BjKbCOsqZFmXhzQtdJradKiPRLeH6KoQuMitwLfCgAmmYJT+dQmPdD7O2PsD928hgA/kkNE6ASpnQx2pK6sy+nUMUns596zoMIPdcytu46X19gAmp4iQrr2QiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LROCrcvE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=APKdlv9y; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LROCrcvE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="APKdlv9y"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN36arJ1894837
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 04:48:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YUtvOLgI8VADR2HWEqnoHpAakK7NMYMNB6v4bks4w4s=; b=LROCrcvEO5VYVGWD
	g+8k5tD//9PqZC2E4mEVBNJLNrbq5R0Es5mnJf2KPfqyaP/LviW7VJHEIbwWd6dY
	YH5oQdoUfTEfLrZNPIS213ibxbj9FFN5pnb2L1XBj7VvZ1/ArURkRU0Ku4G/B3ZG
	OCJ+M1gieNOwFb6dHv3b5n3LadPixZOj5nOhSqg1wFhB4MHaWrpqPkQcvlzk4ivD
	PDEm+lm79GBDxiPk9TS5SQLI0e/gXGQhbbU5QhRSADB5tVtVoNU/oACHeIjYkSv2
	BbbSxDofrK1YrBRTYlYnGarEuS81m74hJGGttsyUeutwhkkvl34xzJnR1J+RLpwk
	ygMqiQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b74tajhrw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 04:48:38 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-29f29ae883bso66933525ad.3
        for <linux-crypto@vger.kernel.org>; Mon, 22 Dec 2025 20:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766465317; x=1767070117; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YUtvOLgI8VADR2HWEqnoHpAakK7NMYMNB6v4bks4w4s=;
        b=APKdlv9yCzNGKjGxaSQapvWchRfgkttEiujfazCh5UT0WKbUAKxsmJSsNHJOWFcV35
         ov+nvsfT3SxwwrHSQXW7yfA58Pv507K6pGeDPPY3sRxUSfjUdTjV23aM2+UqMaiW1hN8
         HqHP13zfWgA9iFQVClAgKuGPwzWlNyKH21EYOjWnA8mXYSVv77AMz87vcsF+ej06Yyv0
         3zcrG51CYeF8DtHupiXOnSjE4bCmu+j6jLUK9wF0ZPbq/kdrm4Xw5yRyTzNMlb9hNglA
         +LI6AX/bchC/oENF2+LqjBUg//mi7N6i5zgMv9s+Ym0/TXnqxmAW4M2qF9Afz3PIisb5
         zRig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766465317; x=1767070117;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YUtvOLgI8VADR2HWEqnoHpAakK7NMYMNB6v4bks4w4s=;
        b=Cqw1rQtxKggKfgZrZWUOALMCnoUVwTrlrW+yuah5SLb7Uui9H0lcxf1OVhc24W4X83
         q+Nm8rhQBQIpTo7gh389D7qgAZV3+jh8tYN6FNUohjrfkKCU7RVQyCeTtprRKybEMT4L
         kLjNCMl+YP1WuLCCTzVuI0fkV2bzSDEdBhOa8n9nSLk6jm6uhXegUoSQceP/PulfY3xq
         QLbN7lhVR1OIIifTAS0JCjy2xty6++aYHsR7ZNWh+yAzaT5WdJacAtScv7s/0htEl7RV
         sUL1GaA9jTiBFzEVBBqeo/9R3pS30++ye9ohMbWO+5r1E+DksKxp7JMeHsstp0le1fqS
         7vPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVshu+pNEiydUJZf8tjPJqC1FmpeUxBghiOpwwtiSRgumncRSY3jRDzBCafFQptnvJj2F5riHMlDIV8pKQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaaN0cjVmYrYOH4dq0/iGbxuit05SVVFsscjQkvmw+5jU6uPGg
	/kcU1G1QTqMr59imIsN1g2951X5mCGDoGM68QJ7fnTgt93T8ATkE0bmDJHLDdXPGMTBUtVPc9om
	Xs4N8DFPA6yWMHSQ63toehCB7rmkQgEBHy7uqpVDmcWPczif4lnTN1YzdtmEL+sq3S14=
X-Gm-Gg: AY/fxX5yGXX+UDxRGfX79QE2GgI0a9D/+Hr8QnsyPSny4GimFjBNS7pi5XKnX0DhOY7
	WI3PNU1bDNenTc2+wwdFz1Ty5ds0WsU5k5od6CW4TefpHwqhjOfcLl9x/ayhBSqbXOkVCl8H6Dg
	PvJH6TKcjj3yfmWLbC/a8pJB5gLCwc+38iD+6OERtoieJ6wZi0vb77y3sc5o96qPgN96Z3V+fkb
	y0WeinSS++Y5LXMbor7+xtgm1AmDe0HCRd0hoI2Sm+iu/TjGUvnOmz/opqgEn+OIaP99bnDE+jP
	E4Y9/l0FPLWu6aUO9AlhO4+9c6yOte2STVbthl6u45+Xo0l/EfB1Hck63zoLQNJYAwND7vIrJyy
	+Cga3tRDjFxfbXUKa6HE1vcHEZON7Q5VWZus=
X-Received: by 2002:a17:902:c94f:b0:29e:9387:f2b0 with SMTP id d9443c01a7336-2a2f2830fe5mr133218055ad.39.1766465317329;
        Mon, 22 Dec 2025 20:48:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVN9kuwMed0f8FNMLreINap0En5aXmVnVdLd+nilxG5HS7NLNW+IoiyeWanK8Zhir+tMyqHQ==
X-Received: by 2002:a17:902:c94f:b0:29e:9387:f2b0 with SMTP id d9443c01a7336-2a2f2830fe5mr133217805ad.39.1766465316867;
        Mon, 22 Dec 2025 20:48:36 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c8d10esm111316245ad.42.2025.12.22.20.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 20:48:36 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 23 Dec 2025 10:18:15 +0530
Subject: [PATCH v4 1/2] dt-bindings: crypto: qcom,prng: document x1e80100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251223-trng_dt_binding_x1e80100-v4-1-5bfe781f9c7b@oss.qualcomm.com>
References: <20251223-trng_dt_binding_x1e80100-v4-0-5bfe781f9c7b@oss.qualcomm.com>
In-Reply-To: <20251223-trng_dt_binding_x1e80100-v4-0-5bfe781f9c7b@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766465308; l=832;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=U4kz/WI7ex0zTWa7x13E4KzWLO7BwMKRODDSPUERHGk=;
 b=3PjJp7uIY8LDmIc+gkpqgUELY8d6T2lLNLhZ3mShzzOnVE1VFJUbQRGS1nSQxYOYfL4ZbXPdZ
 mF+b1uyrvI3CAa65DfWrvH5roIEE//bbbc8TNYBh4Jx0us7/ZnLa/fD
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=DPiCIiNb c=1 sm=1 tr=0 ts=694a1f26 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=-yDIlTExAMyGpBI_tPkA:9
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: lBv3_mFTm9oStW_vICzCe1OwbQq3VnZT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzOCBTYWx0ZWRfX0sqzfN2yYLt+
 vF0DasSpa40hH1G8U2apmYHxB/7zR6akkM76evDY25sCwA/oDt7alROdeNy6iOlH8axNUiCdKNt
 H7Pu3mzhSxOGvBEQ6H7rO6bGRVb5oIRUFN2MnzD788v7dTk61F0MuZUeHbzKkKQm2RijhQLhVvZ
 MnrHN9bB9gG09epOEwUxQBnqGvab5TX7UalAxZf7tzTDkrtjhOBQ1oEO/Mg4lsBRzwNWXwpv9io
 pLvXjsSi6dHiiUwHYbNDJ2WP4a97n9UqkuxHTYZdLjMqbKWU/pSy40r4GXV4p09jkdv8v0TJGpY
 yJLKnyvNx497jClkTjnFditWmi0jRug7dM/mVcy5jeG7+BCpjjiv0D03pKiCbPl++FONuPyekHI
 OARck4qXB1V+4iM8czVDJ0EwsfpvVhdMvuzTFx/FkCaRXOjsOjtKa0rzGjFmu4RPumsiMJjhtph
 LMDlKzIhdT2kzKyvrIA==
X-Proofpoint-ORIG-GUID: lBv3_mFTm9oStW_vICzCe1OwbQq3VnZT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0 bulkscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512230038

Document x1e80100 compatible for the True Random Number Generator.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index 597441d94cf1..ef8831ff2273 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -30,6 +30,7 @@ properties:
               - qcom,sm8550-trng
               - qcom,sm8650-trng
               - qcom,sm8750-trng
+              - qcom,x1e80100-trng
           - const: qcom,trng
 
   reg:

-- 
2.34.1

