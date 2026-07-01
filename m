Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC7E29D27A
	for <linux-crypto@vger.kernel.org>; Wed,  1 Jul 2026 20:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782937072; cv=none; b=OeCCJUdyPTK05fsUzxHGQWMmCTHECsRjWUNYsiiCqDmtGi9FEKKZg7M4hKbQMTHNN3pXrTkNsxw2tqH9+EjzWN7e1MAuNmmkcWWVp4+r2tFRePCcP9bO1p/jYRDIkh/XERl9stw9up1l5o++ciiGuPRyARLZ8F2/kTGwkqb45t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782937072; c=relaxed/simple;
	bh=zf9TlqOfwwZdx3G54bR3USVrp7P0p8U3F44gkqVs+os=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XIAB/Ho/D4SDhx5xajecrygknB3jADFUxw/fIjnyJ2YzvEmoTOtSpo9bjxSijdI+h4ZL5WnqrtsVBnvHB3gIETHEEoKzQqVBHbS+w80TssDgpVE+8ifiJUD6O7U438BgvSXvJdKTfw4W5eSpBRV7BqFTbgsXw1FpfivfXWCHhIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=j6+844DD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=i+dqpjBB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="j6+844DD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="i+dqpjBB"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 661GmXLZ1710559
	for <linux-crypto@vger.kernel.org>; Wed, 1 Jul 2026 20:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	23PIaOdJZ743PPYrTOtoYq3vqxgjoVKfYD54+HI5AOc=; b=j6+844DD9xOyM6hM
	14DQgkXl48GEnL9B+hQ74161SOVZIxgdVgFPcU/ZVIbbGyxSvpBffCkiIIR6cx3K
	5KVLgkh0vMl3DOC0O6PtUQ+HMGa6hFpUZUmnDePuK4wIIlCTXra7NlQh2BcFgyQg
	yz3bS/IMb5gacvzVp79zjdYA5BFX/wATr7DU9IPP5UwnIkuvMPkZmiFpdl4pDA+Q
	HBJEIOMNIZCzECTdfGqk3BpIogUZzLwciCpV1KECYSg46r+dmPe05p59fdrZyejQ
	QF/CA7Rjo45RqLbAe0ZpX9NbUvwLwDo+uAsCcnn9u2CKJ3J/bCvm+VgQg86vdMJU
	uw4+VQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f56gprw5w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 01 Jul 2026 20:17:50 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-37e16f658abso845452a91.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Jul 2026 13:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782937070; x=1783541870; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=23PIaOdJZ743PPYrTOtoYq3vqxgjoVKfYD54+HI5AOc=;
        b=i+dqpjBBCgIeeaSkn8HPi4jwxSqVmzBKwSiAEL2RW8Y8WZwPajEcBxcRBikAcKrrTQ
         PqQWZRw6R0+QpGbFuKnfIq/Lj6Ty0VPJjL6TSK6bGeEsHy5ufcoQwYcnBVqBr+s8SYci
         c6xsEoNlie1JdcC/wN746wcKSJHNamERxSInxpbVPap8jKaMYgDAxrfOSfo6l6ckPNTz
         P698ZCopWG4DzHIAhYy6Isf5iJkwx9TCPHBNW+2zR+JPKpgcSXJYZjcSIklIg10HegNo
         Fhfr8J4VzsymvLh8RdD4OoqUbL89eFQtG2rqvXVvZuOJzaxn9PjoqdW6eDgkjo+BoXTG
         HeWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782937070; x=1783541870;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=23PIaOdJZ743PPYrTOtoYq3vqxgjoVKfYD54+HI5AOc=;
        b=NeBzVkpKmMp4Aemt59DfzIAn1orpwOQbM91JrZtCavzgArY9vyLDjC+3mRh5fl/8R2
         kN3CJfCSDZQgLK4+NGA9659VHlBcPsXMtyPscV4Bn9wNtfTo2vodv1bipsvaqAWCEtKL
         iogagN78ilVpnjkq5L/G2woDoItKkhg+h9s/KLNtEo+v0x/JJh71ibBRQjM0AAvYtZN4
         8s1YxICRJUy3uWI+jLMERdXKxacLrwSGHdJ2udzWY9schcDWdoZktBQRldjXw4CjnhdW
         0Bc1l7go/Gb0975abGgSTKlLIpRcp8eXMlf+ZJ1iuIdIFM8d2mu0dMV+RyaAua+VIG1b
         VRyw==
X-Forwarded-Encrypted: i=1; AHgh+RrIKC+90Esz+bf8syHh/rPjECu1yH93xY3jufZRq6aeuvUOxJ1ySJ/C9L29jZWlMztXKqBg1zxnxhZ6p2c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhVN6l5viL5GAttdiTilayQr/6sWN+q6LEFBTmwfl55NQbu8UE
	eF/UkZiLVgL/WjGkTZAvaYOzq0J19mms47DOXXs0ljTYPgdRuvWnitvHLZfNb3mYfQ9BCmttkpX
	9l5i62a6lgvK8jQ6v+9t5fXS3FXEOxqRKa989SDU0mcti16VSRe2tD+Cq0WsiCa3D/wM=
X-Gm-Gg: AfdE7cmJp20gkU+s6lXGsSI067sldPyRSkqoQshS+ob7EfGuqIna4T/xPotRBSldmgv
	7biIvyAXQsbYOs3nBiLj8p9DdZzAMZT+mz380qfz7Ejlso9EASkGLdIOjPt+8y6ZSZrcfZsN2YV
	LCw+qLyNLyNzty9h6Vx8tnRV9Ar9xnMv3O0IzNLYoZdif1Z1qyzkExIdrd3ZvZTxFsIktHh6DPP
	lwDuuR1gzcUAQRVr5HhjYLFNXAl/nOn5Ntz3PhdFBNmj/CdVQ+Ti1J3up4dqYVmBdxRPKSkwXS+
	lHlQlhcyztlLUeFqDKEeU7Qm4GfUzLEYAEODx0gHHQ8coT1hceDJuasTExC1fXFclCANBaJhkqu
	YWAXmg6bYolqdmtWeJhlazFWKrmRdgWb2Q9+qE0Y3kMW1
X-Received: by 2002:a17:90b:3e50:b0:37f:9ce1:7359 with SMTP id 98e67ed59e1d1-380ba91d27emr1912889a91.26.1782937070212;
        Wed, 01 Jul 2026 13:17:50 -0700 (PDT)
X-Received: by 2002:a17:90b:3e50:b0:37f:9ce1:7359 with SMTP id 98e67ed59e1d1-380ba91d27emr1912861a91.26.1782937069703;
        Wed, 01 Jul 2026 13:17:49 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bc79231sm948685eec.31.2026.07.01.13.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 13:17:45 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 02 Jul 2026 01:47:13 +0530
Subject: [PATCH v2 3/6] dt-bindings: crypto: qcom,prng: Document Shikra
 TRNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-b4-shikra_crypto_changse-v2-3-66173f2f28b3@qti.qualcomm.com>
References: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
In-Reply-To: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAxMDIxNyBTYWx0ZWRfX7Zc8kuZM82lZ
 DEURVoFf1r9AsRgEEdUv5asWYX1+5ik+75fCke7DQ0GO/w7dSZljnV0R6XEay1p7oXQRZRlGNVi
 TwozsmkEPwOOdZW+LRXNN+iiOD+/1Ac=
X-Proofpoint-GUID: Q5MPT3yEENWwvlJxad2GOrpPbxJTOoU8
X-Proofpoint-ORIG-GUID: Q5MPT3yEENWwvlJxad2GOrpPbxJTOoU8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAxMDIxNyBTYWx0ZWRfX4JFF63VmgbAk
 tLmyHPp7n/hlpFCc7s1o11sbFPzmao6F4RmCpHVddNMDVsvhgDZwa3UvA1tZuO3g2H3vjo/FdZP
 8HUb+XlN8mxhRksjfgOrjv6PSFcZEB8f98uHDyUVHQpXCaoz/7SD91+KX3YMdWqy6jXc1Mf2KTb
 OWKsRo6Zjs1R4XezLb0CcReVB+q1SoQFd45icwcoqw0cppx+Lk3FKoYGeJtJzcFPvB975goX8PD
 JFfzWZ8SKbwma7NceChWl0knYy/AJZEgCWvPFvCZnKJIPBOOrBgA5bLpmesW81I8/XyWptIwBWS
 /Gf7IpSJi9Ucc+pQmto1hqIUp9FFqnME9UpbNU+e240+/SgoIjnbMAqU4Tdm72oLzsOtCC17rDB
 ASqcd+wzOaScMXzAeEivJyEY9QG2zqNtjFkwGHiPn+MDyuv0+gJLZLp4wMj0VEkOJ4h49HKz3tM
 u4MewO59+nOgTNzUn5Q==
X-Authority-Analysis: v=2.4 cv=K9oS2SWI c=1 sm=1 tr=0 ts=6a4575ee cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=mVMjwrqIa5QPTF8STQQA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-01_04,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 adultscore=0 impostorscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607010217

Document shikra compatible for the True Random Number Generator.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index dc270c8aedf3..5de52d7a745c 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -30,6 +30,7 @@ properties:
               - qcom,sa8255p-trng
               - qcom,sa8775p-trng
               - qcom,sc7280-trng
+              - qcom,shikra-trng
               - qcom,sm8450-trng
               - qcom,sm8550-trng
               - qcom,sm8650-trng

-- 
2.34.1

