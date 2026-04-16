Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA7D3BED7A
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776344860; cv=none; b=O1OECRwMZzz/XBvCtxciPh/QhbuKuPW1S7GJGcaLQAmNST8mxiW4AkZ2sw/Ib70NCtV6ifde7HRntLrPcPf8AtbOywIzrgQxQ8nh9jti+UCD1esFV6FuX+6yvPjG4OGcrFS561JlpgWu2uu6pMYNawd82GkgTmcGvgPlJCD2KA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776344860; c=relaxed/simple;
	bh=USGFQFEcD+gM/P5SRp/QkgAxj/RMUfNX49cvi6cpEO8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Unk7/z9jrnqUmvcFky+xF8BeP04IJ6LSIDr8qe60xJ+8SOuLwG403PGh1ivRqXwMy7NoBP4srpnwntFyjzBESKMwtGyZ+QvGp0J++CSEtVRsECxHvZIx553vsB5L1RyL+HVOL2RJaUUqK2cYnal4dCxcQyOGizH4HS7t3+NztRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=T6l/I7Kx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=T/tRKPuh; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="T6l/I7Kx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="T/tRKPuh"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G8CXNT2576111
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:07:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mOZA+vF6va/I+AEeOlV4JLF6hxgg41sdBF1yn1WdweU=; b=T6l/I7KxbbjBD3+6
	zTISIER1ejwJfGUXtjwMW68sFZL7XQBklt7VHxyjr2/UdXUS6E7z0280QsWLcYHg
	kWr1F0h88sy3sjwN4f4/0WZT0EGPJ56ZluxsK5YW0E45r+3POczgBvQi4LQe3HiK
	05yPBB5JgXFCnHCUTSf8acCs9k3lWZ13JwINvsWHZkJxKhtENVQLxMKZGz0pA6vY
	vJoFgVB/q2Zl0IkzlFRno8Dz/K8XLj8fW3u4B5VRpqttVZyYkMqa6t9l9jqAhz3l
	f5VNvkcPB0YMsS2nKB6PG4fCgcku6NvD6eFgWX/+Ke46sVIN8ZFg6qz9X7NEJX1E
	7qbn1Q==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djv27h22a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:07:37 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82f85179263so81051b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 06:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776344856; x=1776949656; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mOZA+vF6va/I+AEeOlV4JLF6hxgg41sdBF1yn1WdweU=;
        b=T/tRKPuhWWGdMzbR2JFH4Imtjt8AHYZXc5Z1k4+4k4+t9eGxD1P+5bBijy9Irko4mN
         ZMDN4hINjIacG6hodBVKX9UAI1bBGZao/brH3c88YsskjFRl0gkuNrqMfEH5XjwdpIX0
         hUhILLM06ZTVGJJXy8+Mf7iZgfkaYMFeSFWulaVmbEpjwUG00+c24S5iHdTuKSHZJf/b
         LWkP6ZSOP5MUmpjMFGRfME5j0FcrKHEkTIawnpz2RCYtRdl4nGwoAZqUfWnyW+ShiD82
         lkLuhUXXTT8YdtOglUmFs0mTvtcJ+K7qWKnKUY5jAxMI1flBGlC9YwP3hlY6Aa09WrhY
         znnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776344856; x=1776949656;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mOZA+vF6va/I+AEeOlV4JLF6hxgg41sdBF1yn1WdweU=;
        b=XCWn7DS65Ilj/h8JSc5U4CqPbw0R4RkzWY4JnRQsgZrufxhHCr1zqkq97S/zWztS2K
         Gn1m2y/BYdAafbQVv7sELggEpFXUd/XXd2sJogwBlAw49RQQzcMVw9mh4W+Fig24+cpO
         Tpfjgb4sWRwpWB9OgKPo8gQ0paTXyaAD6jM6IXWv7K9D49c/MMkPaNnNhB7zToRnihxq
         5Qx1V0chqnstMzlIpctOYmcS8myKsuJnwkCr6qCZZ5ay7KEnH2UNhExfWYTVgkEJC+Rt
         G9dZTq/ufKa4y367960pTSPODWdnQ52Ipwed39IUbOUt3pES8HisZOPN2ZXMDu+ZdiLZ
         ZxCg==
X-Forwarded-Encrypted: i=1; AFNElJ/NffRcj03I4mZOdZMQpYEshzchE0Icjc3i9tsRLyTFzV9HCqS8nCIysBD9jjM7g6H1hihYrg0clHgrvQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMlV0nxZ2fAaFq7edsUvGj2kpRvOx3YDYOolIOrQFkbeTv6/az
	KOXze5jCEWj0IVrAsU7ZUFLPqe5CZrvZCaFXfm92W7qi2GUBT1gwJYWu1PckNm+ikt+oYtVhEGa
	JSNWoLy1vBr0RDq7NV762tW78U7KejqBjfOl2uuzwz5LOhzXo7zqSCAOr8GFlb3h4U6M=
X-Gm-Gg: AeBDieuD5O66bgHqdUzYu51zcpxDmwHlmfczYNRLpAKxpR9s8p/bJPMQpw1avbXXd1l
	axyPF3ZYhWcxc2IgbEKmpQiGMga8Awtz57/6CFI/ACG0ko3heX0/im7d0wN4dOtERCL5Cyv3ibx
	1gVeSoKASw4LF76Opd6TutiYQWmXcHOWccVRfCb/Dps9wEwsa5HTcvishclwHgbQB+1FUwtm15F
	tOME695tTSCN9bNdR9NTQ/ekRcNlVY805PWo9w6HMTZC+SAW+uNRxuMSfT3zZo5UDSJWe2I4WuB
	qByrgUc+Ki4nY2Kuxyt7dHcMpUTdKF1XhDCaN0W4WBnHwukSKmrlc5ssbR63UarwD7Ve8gztqQ2
	aDkbL32dF9j7aHqJRh6VN4Uvq1RRgooWerZ0pNsqsu/pJKGzgGJWs4vr9XA==
X-Received: by 2002:a05:6a00:12e6:b0:824:93df:6d86 with SMTP id d2e1a72fcca58-82f0c2f0ee0mr26109465b3a.50.1776344856212;
        Thu, 16 Apr 2026 06:07:36 -0700 (PDT)
X-Received: by 2002:a05:6a00:12e6:b0:824:93df:6d86 with SMTP id d2e1a72fcca58-82f0c2f0ee0mr26109419b3a.50.1776344855683;
        Thu, 16 Apr 2026 06:07:35 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f67449c3asm5383605b3a.53.2026.04.16.06.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 06:07:35 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 18:37:20 +0530
Subject: [PATCH 1/2] dt-bindings: crypto: qcom-qce: Document the Glymur
 crypto engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-glymur_crypto_enablement-v1-1-75e768c1417c@oss.qualcomm.com>
References: <20260416-glymur_crypto_enablement-v1-0-75e768c1417c@oss.qualcomm.com>
In-Reply-To: <20260416-glymur_crypto_enablement-v1-0-75e768c1417c@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776344844; l=729;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=USGFQFEcD+gM/P5SRp/QkgAxj/RMUfNX49cvi6cpEO8=;
 b=fJHQy+prvGjyHkO/FeFBFrx1rsdpxTFO3eWBG9sFWYDOZqVw3suXUQBeXBQBUy7kYT/Qp7UV+
 7l2aKMzjp3/A87xQtGtPVIQYu/8Eh1z+mYPVeKF3g8VN2iojaTPi2AH
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=PJQ/P/qC c=1 sm=1 tr=0 ts=69e0df19 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=VuEBvGUfxVmeJGK4P-sA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: kQEm0woV1fK2W7BfpK-kGU6Dz_ZwWvz7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDEyNSBTYWx0ZWRfX9s+i8GvIrh2g
 /VbXFA5F7NCzQJOzQv+QEJK2u+kUJvwe50+WYI2/rhS8tBJaFhT0kBrUztvRbJGb7b/A1wqmgpl
 el9id1Ia6tlyi95bu00/cXBumYABK7hJs35NWvRPWLRXhzQpvIUrYuiSFeX7TrPak/G547SS8Ki
 6EVEL8cBpSvm//AOUefE1ca4KdKj2rvEI4aMeGQ0c99fYbBkHF9S5M1/MHhApqtPSOi8KLSTKK3
 QDmPKrNyAvuccW4NucAkSLhzxD4CeJIZ2CSoOPFaa14RF0p9sA1HfJHdVFRE5n8bIde3M22GKBj
 +VfhZ38LZd3BdggxK4msVf+5znCCw+AXXP4hc9bH1qYJFLLWlulITyEr8rgnX80uQrASrDL2CrL
 3aQ0OUbo02rweBWXeUritjyJEUb4IMkCYvIJti/yipFKhVSxanKi3hkyngE9k9wrZOeC9odsFoa
 aUvxj87zF6r+XVLrllg==
X-Proofpoint-ORIG-GUID: kQEm0woV1fK2W7BfpK-kGU6Dz_ZwWvz7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604160125

Document the crypto engine on Glymur platform.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 79d5be2548bc..0b62271f8bfe 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -45,6 +45,7 @@ properties:
 
       - items:
           - enum:
+              - qcom,glymur-qce
               - qcom,kaanapali-qce
               - qcom,qcs615-qce
               - qcom,qcs8300-qce

-- 
2.34.1

