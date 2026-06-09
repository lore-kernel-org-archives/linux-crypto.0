Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1B53EFFBE
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jun 2026 09:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780996156; cv=none; b=rz8McKSY9T1vDkCk7dG94P+9HXlvVXYJqWgkuQL8I/7+O+btHWD2RK7wej0QjekswaZ86hI2rUXnaJKDwq496qi5uWGIOUQeP9Wb77xkcy9Pskjiu8orA9LOGTAyPQI4NbK81nL2iw9RNpJdzOq9agtVET2ZNwMi/otkSkGgLx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780996156; c=relaxed/simple;
	bh=7nycLbB5N/ANW+yrShxOF4HkSLHBeldWJv9RE6+5o6s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fyz7uOKsShJgGbiktB76kk/mHnEqejKuwPrKQVQhrBJ2Pt/t4TXLEku6LAYPAFXBwiqcOEFB+i9Bl/CBl4XfCwmq+5FS7nojqAb9AS1kcvDlWlWXaabQpxwZ77jTAX89/fktcaNFyOcLGXI0foXLwunIwkvzEhc4hKIhjexk7Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MIjSWwO7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A+JsuA9u; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MIjSWwO7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A+JsuA9u"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6597rfRs1568412
	for <linux-crypto@vger.kernel.org>; Tue, 9 Jun 2026 09:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+sjoZKS/O+bXIcNGVmUA+iLQ9nqB+G1aJChkyTGPl5U=; b=MIjSWwO7YL8EFDHi
	m5z3otatOHq+eJP16zDiQ4eEb+BM9On/cx0LkZjM/XOvgEPb6DX3J7+v6ZYx3OSX
	eHKGxQfhP/S2GgGJSRBtnloOpu7jD8gIiTDJHPYnP91hj6MRxWGuXt1vBzWXlpmM
	2xbW4oRKofad/TGaTNfJ/ayeii5OQIeRiPg3w3erq4KN82C0Xv4IQJflm8iFqnrk
	PMInjmJZnIhN9m/ah/Qf6dPB/GuOhP1l+SUdCsUh3E9frgN5JkvZMF+Mtj8gzinu
	tiGLEl5ufVNqjNjDi2e2dz5/oWSBPIv0lzj9a1l54x+VO9rAkDXlB1lgufCjsB9Z
	tKyOyQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4enxx46csc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 09:09:15 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-304e7fc90b1so5272810eec.1
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 02:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780996154; x=1781600954; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+sjoZKS/O+bXIcNGVmUA+iLQ9nqB+G1aJChkyTGPl5U=;
        b=A+JsuA9uyd6TQsFQBGaDZbl9fYOafeqqUwf6xQAHNqkmVusX34/fxgTqblMmGfOWC7
         DVFt/wNRkelEILUqi98TCetk3TGyccN/QMvfigIMfm6fSWhgM6/IQJfYLU7TNXNCbpk3
         6QSHDwWkstktaV1K4B8BmMLbtEYpW7m2qnRXQiPHOJZYyX2HLCFXHxSCUsxIoBrWHXN9
         KnVuz5PEe+Wyn9MbiQEvXqLt/uDQBgKL5f9mpEP4HQT91sRInp/h8vzu4mofQYfH28zJ
         V+2NhPFVFkAEWVqCFrklbwZMenxH/iWD7ApSQinJdmofOWWTDmgfxdQSP9FUkaeYsXG2
         AJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780996154; x=1781600954;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+sjoZKS/O+bXIcNGVmUA+iLQ9nqB+G1aJChkyTGPl5U=;
        b=h+KFfQAFV8OgZdgjAE3m4aR1FgkRB9qLVM3Rkl0gS+RHG+yECUluI2toAusp1K0oM8
         RgfAFNdRiUE7hVjQbZx6WdJk/WXdPdDxahQjCMv/0cHmuMPhcStV1+1Y2NCRdLUattot
         4tIrr6DWCFE+CIkP5NkuR05aWiEpsCzXaIyyzC7T+awW5hd/83tKWPcYwQEJ/B57JbEl
         LzQkX/eNo/g5njZ3MYZZnK8F7OxNNIsvqcMT7dAGG7OtSK7s4b8aUfe7aCVXpEFjNxPM
         /ScHoZoa8/2bhBFRqvmU5eFt/pyWQuD/5FYPiHxR/oqsxkH3YWLTshdRUhRFzHCinbYI
         xmIQ==
X-Forwarded-Encrypted: i=1; AFNElJ9iZEoKGbhq4uL8V4iY0tMTvtakrRr7c0U0iU9RxvXKW1yH8UAi0GC2TqK462HwcFybfACPb9QFIk9vKnI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5LrAJgciwparWUhRb4MpEgUP7w9LsYWPQCPHfV/vn9qh9dBBe
	4ALQds0Us8gjA9kPB0VAle7geW0tyDBR064etZr3pOspQYvRwe1Jh8vGQb7bB2webeMCTziCoVz
	+wyhUIo/HNRznF2NjgPDYZGtEAyfU39GeZcAIzZMJktiVprtv9nHY2c9EM+BEhxlk7x4=
X-Gm-Gg: Acq92OHuY+cEzd0MCUgNsBPh64wxzsPe87gp0G4UL21K/ELWDm30dyPjgSq64vHQo9A
	/OLQPcTEhtPhe117Z7m0FxKa7JYxngp8H3nx7oEM9ONMItS4vjCglEzSEZ6NeW/5PkkMhOpRuV9
	4cn3YWi+dvq2aEgmRGEZJKQUCwMRlqJ5AD9J7SmXLTVvwrU8rFEOBt5mXC8eiCIXVWJzoXfhnu+
	illpQC8PpVu3gZPI4zs+KpKI1toOqpojYVC86CpsM1vv0MkAAwJQkURc4BhRG8tsVxfU6cca0h5
	Ze9U3rLv+9xxs8tYgmRLQ1v0c4dkCwDnxtHjtYbN7jCOCG/C6Aph75D7aSNAiS3ZlbQkZVrKo/E
	nfFn7n96VqtkPYeJ56H5p775U1DGrCr8OGRurmoN0jEN9J6keky6TA6ewwR6EJK29whBLcjU6GM
	uHlLxjk5Q=
X-Received: by 2002:a05:7300:5b88:b0:304:9b48:53d8 with SMTP id 5a478bee46e88-3077b0689demr10301686eec.10.1780996154369;
        Tue, 09 Jun 2026 02:09:14 -0700 (PDT)
X-Received: by 2002:a05:7300:5b88:b0:304:9b48:53d8 with SMTP id 5a478bee46e88-3077b0689demr10301653eec.10.1780996153872;
        Tue, 09 Jun 2026 02:09:13 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074df102a1sm19356606eec.20.2026.06.09.02.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 02:09:12 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Date: Tue, 09 Jun 2026 02:08:57 -0700
Subject: [PATCH 2/2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Maili ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-maili-crypto-v1-2-0f577df56a61@oss.qualcomm.com>
References: <20260609-maili-crypto-v1-0-0f577df56a61@oss.qualcomm.com>
In-Reply-To: <20260609-maili-crypto-v1-0-0f577df56a61@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
        trilok.soni@oss.qualcomm.com, yijie.yang@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-3d134
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780996150; l=1073;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=7nycLbB5N/ANW+yrShxOF4HkSLHBeldWJv9RE6+5o6s=;
 b=Qyaa6xPHtPHijQ6yZkM8EQIl9+4tNBo5rCOLMOeRWhBqlpPMXcpqKT5KDARaIOHjuQp31rGbI
 w+E8ajPqWirBswLJwa5XPbteTLp7ru85UZlctwPderqzAqb/9xWAWmc
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Authority-Analysis: v=2.4 cv=cverVV4i c=1 sm=1 tr=0 ts=6a27d83b cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=NmGC_Fbkji3YBVCvtbwA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: c_80PoV5PzObhCLSVL914Qu3tZMxGsIK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDA4NCBTYWx0ZWRfX0ZFWBsf/1CWD
 G5pnXURyGM2akdFMOg990nPi9ja0LwplRUckJySfvuXf9K+UqIGPLDcqzqnIt9iAdR1Z5t9WDl8
 RW5lpbfuvFr2w/0QGNDokGzkDoTRMo5GHRur+w3C5QcZ1ciAATC2MNHLuSR6L8bmD5rWN8ycN8X
 dlcf4RyLVh9aNQXsiVY64QEkgqdoSVXSi/SCo07GUUT5FuTzSKqBUAXI8qvcbjchx7gEDE3Y3B7
 ITonDn9hYFePZtSgyGfN92lllIj+8tGBdy4FSdMV1hzCWM2lRmClijpo1o7YPJ/T5YfuWjQ6md5
 NPktbyIZajXjwLCtNlM8wyimEykAA7GkUuVAbXD+lFw+jyNhQQ8mF0j7ZF0TysNxMXdGUD24BJH
 vegofjZhiy5wrtEMBo08mQmPKlm2yQ==
X-Proofpoint-GUID: c_80PoV5PzObhCLSVL914Qu3tZMxGsIK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc=
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.22.0-2605210000 definitions=main-2606090084

The Inline Crypto Engine found on Maili SoC is compatible with the common
baseline IP 'qcom,inline-crypto-engine'. Hence, document the compatible as
such.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index db895c50e2d2..c9489f6b8081 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -16,6 +16,7 @@ properties:
           - qcom,eliza-inline-crypto-engine
           - qcom,hawi-inline-crypto-engine
           - qcom,kaanapali-inline-crypto-engine
+          - qcom,maili-inline-crypto-engine
           - qcom,milos-inline-crypto-engine
           - qcom,qcs8300-inline-crypto-engine
           - qcom,sa8775p-inline-crypto-engine

-- 
2.34.1

