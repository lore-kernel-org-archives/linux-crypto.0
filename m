Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE223A6B8E
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 06:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782715526; cv=none; b=UureFafTy4pnToxXzsCpech/7tMT4TXAxziGW7QsIw4NemeL9MkpTXAm9cpv2CXZRNhC+p20o+Fds+VQWlR74YrVpNQKhEaaKC1xgfNFb03ZPvC7NwL8bW9ybDJ0jlaXCidIxxUJMV0el6KAbXGKwDEZjIHMdK8VF2J/l3YjVFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782715526; c=relaxed/simple;
	bh=dn0QrbOG/qJL5Pj+WWw2i/sCV3opwAw6wsixL8ZNvMM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=t/HrX+mREUI1r1Vuk7aEONFnPaS4x+bMZTBxfff7VevjZ0bRWJPZjPIp+sMQNrI0BjMubg2mkZrW0RQjUc6TSfy56vsR9yKqmfxHcdAwhNQEIS+dc7/modccOB+Jf0Uce++kPWKh4LNYYTr2ARQvU2NE+DL8X4NK5wi9SXRDrvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WLCimOUw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IaHsF8vj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WLCimOUw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IaHsF8vj"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T4NTUp1777389
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 06:45:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wg0phjeYuJAzt0H6//vmnVHPlLlmV584ynLqAFL10Mk=; b=WLCimOUwL2rA/sji
	/B7YjjllcgGb6v+5LZI3fYJlq3FppLz8K40aed+TwqMxR0aiIR4mk2gUqhQCNZQV
	AkBGd0AlOaRh/20o6yCk3vzfPOickXnjV84/oDED8BGgs1yxRrPCRG+jcUveU2ZU
	4RksXFM7s5kZAIw6Me35cwdBcsQwCrRg75HHRCeIQKPsybygzp+XHI+0Qq8Awyw/
	l2oFepcC9EbE7u26de1qWOCZxagu3bbwmJd1xEt3aAUkefT2E1j5VbwEfLdVocBC
	VJX4lQjSLioT+rs/Hz8ubG2+s809TAJTBxCbhudkmGVzxVM1dTtzmHTHA+n8ZVYS
	SkysjA==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f26x8n4vk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 06:45:22 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30e773699d6so1678436eec.0
        for <linux-crypto@vger.kernel.org>; Sun, 28 Jun 2026 23:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782715522; x=1783320322; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wg0phjeYuJAzt0H6//vmnVHPlLlmV584ynLqAFL10Mk=;
        b=IaHsF8vjyQ8elUCeVEb/MrCB5RBGqFfr4WB1CqrKBNnt9EkfvEZ9slCw+FpKpveMa+
         dDDYJrKD6VsxDu7hMPuzRWdbyTUr/WGGr7F2lYAlD5T+xz0HejTy7wUK8IpY543De1qV
         JVhiZHuClt4xyCymGZVgDhr1ZQsdHZt2hT4Xn8VLE8WOucZ/16xFbxR4JbSKGlPQW08U
         TV6UI8W2sN7SnTp3FMfQPz5UY8xWhan3VRXtQprE0VnJrxu0zjqriLZ/ReadQ1ALHxIh
         dg6U9xd3cByYMMZZIDzd/6d94Lg5o073780YaRyWSoCPLcP/U50FX2tN/ksblJ/gE/lH
         ZAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782715522; x=1783320322;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wg0phjeYuJAzt0H6//vmnVHPlLlmV584ynLqAFL10Mk=;
        b=g161uMfJGyLGmHWZSxykuhWQRyEP5lECoA4M1xylUlRx/M+0jzdV1yLXpIZ4ibYw/T
         5rLMC0S4uttLzdk4XSSIlp23tQ4h2yLlwjx01MhwadmSH9qM6RLe5WmM6TKmU9buNweo
         ciOkO/PMCP0iabf3WVSTsOebUxwZF81kHtwuswjC2LsTKCcxetbFltfY7rs1kGOc0TQe
         L/7X4gY6SFE7yrOxIhXgRPFOrCLubRihDBmiXSO9GxGTdot9nKKveiRx08XlLJlEA3wY
         htQW2ntOqo2/b97FgwC1JSs/Q3ojkytaP7EL4lYDm8beZ2EDLr98u1TH7Wzug5j7FOtL
         TA7A==
X-Forwarded-Encrypted: i=1; AHgh+RpLmV3HGb9EZ/jk/mtw7wgl4En28qdFigZFgXuYqjmX2Zc8c48lP3kz7Xw90RQzeBBeno5AAO932tb3PmM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh1Vg8YX3DkwQXXHI2bB41+P4hymjo8vkCl5jHaNiOFlpl6KvE
	fdy7qw6ukfkJoGFqlbW43kI2+Ne64VPQvPd7LK71jC1dvOHYPBNalyKNzB1KHe5v+25hMSxk6o5
	zNxs2GvH2fxzGgdDb3T0d0GP+n2K8fgOjMYJ0L9q041ZgLlY0q1dl1/54H0UPg9pTD/w=
X-Gm-Gg: AfdE7ckJnlsMWOxdSmOcZpL26SzRs5/80ZRkFkptaQhL2eEKXGedlpcQcv2aEWSi4qA
	Erk6BFVRjmqqwf1vwFCgy9vGkoyeUZWd79CkyWc+jnaPfIMVUZkvKxE2C0p+W7vnBSJEuNn3Noq
	zglnE+UcjxCXv2mcIosDzotC8wQVNRaEhE3iN1bDe4SJ5wyEHfj1eRNcYkaUDxml5iyo8LO5soy
	3HMx1useoPEcKJTujgIx1jKIQDPoBKD4QcqBM+ylX8WeA8ZhxogrNEIcBwoIsrX4zphLl2BqpfD
	VbW9gdjd2AjvzTB9KO1G41vnvM774GRs3BIr78WWae2sUWEv3P5I8LtepCzE0d/ZFr67s0PKDlX
	G1C1vlW8Siig5kd00UmCD7E0o/y9kBAdxIT2hvwk7ftpKu1BKOGaXPqUlNi3CuA==
X-Received: by 2002:a05:7300:ad24:b0:30e:cb91:659d with SMTP id 5a478bee46e88-30ecb916ac9mr1650423eec.22.1782715521587;
        Sun, 28 Jun 2026 23:45:21 -0700 (PDT)
X-Received: by 2002:a05:7300:ad24:b0:30e:cb91:659d with SMTP id 5a478bee46e88-30ecb916ac9mr1650400eec.22.1782715521105;
        Sun, 28 Jun 2026 23:45:21 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c52d669sm43580424eec.11.2026.06.28.23.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 23:45:20 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Date: Sun, 28 Jun 2026 23:44:35 -0700
Subject: [PATCH v2 1/3] dt-bindings: crypto: qcom,prng: Document Maili TRNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260628-maili-crypto-v2-1-f8ce760f71d6@oss.qualcomm.com>
References: <20260628-maili-crypto-v2-0-f8ce760f71d6@oss.qualcomm.com>
In-Reply-To: <20260628-maili-crypto-v2-0-f8ce760f71d6@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
        trilok.soni@oss.qualcomm.com, yijie.yang@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-3d134
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782715519; l=972;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=dn0QrbOG/qJL5Pj+WWw2i/sCV3opwAw6wsixL8ZNvMM=;
 b=BIK2h/4rF4ldwJ5ch+79v1P6T02xj813rGfQ5I36mSWZTK25sO8VzdvhDTOz+83jb3XwEHABZ
 h1h1nAx4JXPCVjUxGz07RJ3YYH6fZnzi13nVeo0ipay28uGnsNgaK0P
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA1NSBTYWx0ZWRfX8BGFGridR7gW
 NIJalQleuxPLExvgCT1eP0iy0V3wvo0wFPDq/VigoTXYmPFwWtc/2vuvWFnKIQxdw6dEAEjMNQd
 22emcENnBAL9Xxmn9Bo14/SRFJpBTEs=
X-Authority-Analysis: v=2.4 cv=D+N37PRj c=1 sm=1 tr=0 ts=6a421482 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=FNAlisUgfRrBHgIoG2YA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-GUID: 7QXmVKMBXaEkp7ZxP9ePZ_JwiRtSzStW
X-Proofpoint-ORIG-GUID: 7QXmVKMBXaEkp7ZxP9ePZ_JwiRtSzStW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA1NSBTYWx0ZWRfX3vrI6V2buhT4
 mruUw5fFZed9MPNWN5AayWRX0lkheYZJWuBLdsXso9R93ZrOaV+mH8V4VIYsi83ZEL7xLGqif5j
 Of1VeT8qBZj0geapekBDRHgVN15GUHiECv7VXedlLra1xW6gpFU8QyKzQjdU2P+hP+LhjVrsPM5
 Xuu5qUVR1x8bOw3xNvHneeb8VjuHDCzo3yKSExKkR01ZF0/UwCaxZfilfdSKrP+YkON47mBfH4k
 6AFq5ogm+UHpeAXdT2/+7xs/iHvFtOUxX0PtQh4sZhRTVaCJEkZeeWY/Dh8hhhmQvLB7wzIa1cl
 wUX9ZOanLIv+5Mt2aiud0haiG4v1fFKO8m0TkR2xpeYYMtHZ4kdNWO5MXAhGRBcoRd3m/6esP3h
 iDY+Mnkpnz6dQyzUfomL0NXoea2nJCZ5f1+tMhE6zsZkapWS1EZ0wHeJ4u8/bxpnu+bSRdqGBlO
 JcW/eHhWp6t3ciT1GCg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290055

Maili SoC has the True Random Number Generator (TRNG) which is compatible
with the baseline IP "qcom,trng". Hence, document the compatible as such.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index dc270c8aedf3..6116289ec413 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -23,6 +23,7 @@ properties:
               - qcom,ipq5424-trng
               - qcom,ipq9574-trng
               - qcom,kaanapali-trng
+              - qcom,maili-trng
               - qcom,milos-trng
               - qcom,nord-trng
               - qcom,qcs615-trng

-- 
2.34.1

