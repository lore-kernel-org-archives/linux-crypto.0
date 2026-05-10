Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE767175A7C
	for <linux-crypto@vger.kernel.org>; Sun, 10 May 2026 02:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778379509; cv=none; b=ka64JN/bci+XBdZoc2T+fIS6tQdSCYGefFrwvrnhWe6pWo4vpGCiFCkGrUDK12laihueLuX5FC9JEr7zOa/haktszllrTenj31FbVnLcnMiIanyh3e5RpAhq9jyybzYofBj5d7yj10Y5niyy0BCiM+10W+fN6yWnV5wi99PRJnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778379509; c=relaxed/simple;
	bh=/V7DicQaZr6wCX6VuoEC1W2T0ZF12u5EWIfNyRIj0C8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=prrBze0uGxcvJCMX+Lz6Z1194Swco8/jCNImgXoGiyIx6rze6rWBgqXO2v0MeuLDkzQWcvBHeeq+SPxBdwui3qHUvpRkVv8udiF3rgGJ7UE0VLzS/lAvLAN1uhQRw14gmK4UgSikmW2IWxdBYCYc82kseo2NZ4oek2TIjpae90I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bOhaBbLn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MIQuA5Ty; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bOhaBbLn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MIQuA5Ty"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64A1ZOC51016979
	for <linux-crypto@vger.kernel.org>; Sun, 10 May 2026 02:18:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=NW4bdPppQ8oWlykcUk/k6r/XF/JERaCkDWt
	baw0Jne4=; b=bOhaBbLn5ilCXS6zp8NeZ5hyq12qUhYUl0S+iDGYpVVM65pD8TJ
	LJoHb+2x7s5jLVGJ8HoEFm+vpeOm2hxnVLWOKEurk+GOBZfhPCrr/C+HCY+NXDOZ
	XCEGnovlJTc+a8sRvurWJS7buN2gkEIqgjgVVwnvhu0BX1MxJufsoEv9l4H5dxfn
	cw+7OnqbUiukNW3zf4W9wEfzQyp9RcYeyN6VcpOTNEkLU9uRaoTuQoB82TAx+pO7
	XhfaYbzU/7V3gxJOPNlPHTIJgGJ/tzj5/PpaLrh8L+ZjKFiwUwbrb9xN7dcHCJfK
	uaGVnhg4eaA5UDLQiVUJ1wgFUCYIZbWa5VA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e1t9q2e23-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 10 May 2026 02:18:26 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2cc75e79b97so3024042eec.1
        for <linux-crypto@vger.kernel.org>; Sat, 09 May 2026 19:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778379506; x=1778984306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NW4bdPppQ8oWlykcUk/k6r/XF/JERaCkDWtbaw0Jne4=;
        b=MIQuA5TyeSxYwGr6P3IeAMym4pIL9CMFQAacYwZXT+6mpfs2ssa8gs9lZS+3cTZgAe
         NFgIK+pzbJ6NCtm0C2D2tlj/GSWwhtbh0zXpABSgAVulrS5og8L9T6g4gXVqVS2LkO/U
         j9bO1Qlt4nD8+7k9yZukKL3g6gOBMdgwXE83Kw4gFtLu4313CswYDKeESzy9r+s2UhPX
         3B2DXxFaf4ci1ztKi7vzG7Dv9vELWcHC7rCgGv4jhIw5ik4DBVlctjW7Blpvq5rsxWek
         DG/SKgM69lAeIq+r1YyFWw2++Ac+hL3HT2TYqgzcExqbxBCvQ3FcxmrtjV2nDey7MJyy
         DJwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778379506; x=1778984306;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NW4bdPppQ8oWlykcUk/k6r/XF/JERaCkDWtbaw0Jne4=;
        b=eOoHCd3JcVUf8/vbZdRbv7S8GMD3mSTMv68JKOTpxojT1kNj4ibr8lI7Ts2o8mXrYb
         vHGoAtk1PW+5CZVyzXxol5ySyeoBVSJCWxDSJ78wXrhe8CADDIFmEst5F8JJubjx6gZF
         U1awwt7UkVatJ2nnojO1NeUrDI28eVfFCi0dHa19cpjTJrW+AZbpB0zltBqmcrz5PnFy
         S8DPfhKb+gqZJwPgZNNw0K7D97GIoFXgBllU5CVaI8NkvictHELHndWuGsCbPN9aP7Pm
         NZKs7teKlpKoGzoFHwd1JfFPE8si+gc2NidrV8jo3Z69jALQFr0hTNsZjd4oXH3UyIY8
         lXig==
X-Forwarded-Encrypted: i=1; AFNElJ/YpPdp9Mq88ayzKlR7ZSJuoZWtC2GjCgQxSa/vcWHtDkHhOLKPk/Eo9MmElwysX1PZn9vG0YLmZjfentw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzpsb/o3V3GtQZP47134SFDsGVzweJI6nn78PobxydtqUwGjOwk
	pffh/e8sS/pHMD/XBJd/2SDIWZjk6D72BZ9HjiEqZ7xiqK4azjiKtQLUlt1DvhBYxSQXmUz5Oqn
	q6UGTPznL2BqMszI+msuOzJ2kdx36q4F/nJon/KOvbzNCYCVQQNQIyhqZAAeszvqRoWc=
X-Gm-Gg: Acq92OFHDIRiZdc2X/SHy4cekOhRltkzRDPyV4SdZl6XyQ6X+qVslYBjnbnF51yUOAc
	JKaSt8cubXazkIAsA4EcKgqH8tuzcN8o86zWutleVKWTP0fknDihYaoiPTGcFa1PzWkUWi230Nh
	UqddHUHFm8Q5Z8JlR6WS2nnoe8xC4IAJ/Rg1S1Uni6jIdFc8N4FO1YPDEQDdAYAKrs9mpkektUc
	WzyGiLUh30J3yHcywK6sLYvy4sI6lpugTCKlAnPif4qChRbGs+GBz5+8Xfyk30k2pfStiDZLbNY
	3KyS1AmrBCx5nquGakRemscX9Jv8He7OS3YWbjM7hcV+JRgFzFZ8ZKDwR+L3aATKEWnd7dy60dd
	uyjp6BJJrwz3aHg/3mblpVtgijC5o+nw/JZAvSPPPWQYDO1dxAkHWeq1zGp3MU1E7fsBPqD3bia
	jy691cYg==
X-Received: by 2002:a05:693c:2c14:b0:2dd:6937:79c8 with SMTP id 5a478bee46e88-2f54ad730a3mr9259970eec.5.1778379505646;
        Sat, 09 May 2026 19:18:25 -0700 (PDT)
X-Received: by 2002:a05:693c:2c14:b0:2dd:6937:79c8 with SMTP id 5a478bee46e88-2f54ad730a3mr9259959eec.5.1778379505174;
        Sat, 09 May 2026 19:18:25 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f8862d429asm8333538eec.12.2026.05.09.19.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 19:18:24 -0700 (PDT)
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shengchao.guo@oss.qualcomm.com>
Subject: [PATCH v3] dt-bindings: crypto: qcom,prng: Document TRNG on Nord SoC
Date: Sun, 10 May 2026 10:18:09 +0800
Message-ID: <20260510021809.1130114-1-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: n-Rq3bcaEuRQ7RbqDQqcSPNRLYUwVJ0a
X-Proofpoint-ORIG-GUID: n-Rq3bcaEuRQ7RbqDQqcSPNRLYUwVJ0a
X-Authority-Analysis: v=2.4 cv=J7yaKgnS c=1 sm=1 tr=0 ts=69ffeaf2 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=WCKKRaTC9nc9FdfpmMsA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEwMDAyMSBTYWx0ZWRfXyzi8dPEWhxsT
 DkbSVfP7SZ97iVrlzOaUK7uCD21TLtmZSXKLIhCJyurgimlN5F2bI0fhNxZHb3w/z38K2mgnvmH
 pE0WmZgy7wLJ1jM6UQnOBDRP6Vim9POSDC1ZJcbCZoNntEkoj+4fNQhDXfTNxE0ghYbzhBW4hhl
 XO9SadfCS6NNNKEMthIo7gsIWphgq3Fpf4678J7u/pnpC69PxLd6WekWDW+/4o5ow6iaOOAn7XE
 csAQ0PdARdTHPdxZ/UWn2P2gdvAUIn6RnbdSO6TjetQ8lCNJtaj+Zo/4J07jN96rHkr04oT0PQG
 2bj5RwQJ28kG2VGxx2r/ayjh3y0w6/5DrctJY6zI54fD1xIPnh/xsjn2XJMOXVtrUbT/Tt/t1nk
 PfGuR83Zs/aza8+qRPbjzS6NgRaWDdLtgeWJq7X5KMZBQeL47uxT1nnexMYgbBzxPOIgKjMdGGL
 HPzXcHZu0AGTlB/RzjQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-10_01,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605100021

From: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>

Document True Random Number Generator on Qualcomm Nord SoC.

Signed-off-by: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
---
Changes in v3:
 - Improve commit log to drop "compatible with qcom,trng" part
 - Link to v2 (TRNG): https://lore.kernel.org/all/20260427012308.231350-1-shengchao.guo@oss.qualcomm.com/

Changes in v2:
 - Improve commit log to make the compatibility explicit
 - Add missing SoB
 - Link to v1: https://lore.kernel.org/all/20260420025732.1240525-1-shengchao.guo@oss.qualcomm.com/

 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index 41402599e9ab..1362a8b748a7 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -22,6 +22,7 @@ properties:
               - qcom,ipq9574-trng
               - qcom,kaanapali-trng
               - qcom,milos-trng
+              - qcom,nord-trng
               - qcom,qcs615-trng
               - qcom,qcs8300-trng
               - qcom,sa8255p-trng
-- 
2.43.0

