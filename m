Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB5F40BCB5
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 09:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784625808; cv=none; b=ebQRW3B53W01x66swMBUjVq93/yUFxICqVvRCGnpsgEsnr12PO0hHS0s7rV9taCvvyHOXW43VK6vHPl+ecyv1UvfBphYaaE82M2c5QfhG9MErS5GpMC7QXGjO1ZsQzr5g38s2Ac76mSBeM/u1gIf3+2C9hbG1vURgtyXN3vrMwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784625808; c=relaxed/simple;
	bh=Yt+NMrf61Vi8iFpn84HTy1sddcBDi/iPEb5YrSmYWiI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=p7zHiryGo7m6YH+7tJmgmPWVomSXVQe0BCLx8ndsaMLoQS+hJqAmdwxe3DD0FKS/NFKXxNWrA2UN6cC91ahlaAIZcMQm1DfiTgI+CC/FySshe2mO3HWz4boQ3eK4yyRK4WGn13QrMfqdcajs9kj6asenQkCbiijdY2g65apl784=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=W9USd1sc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CeiBQRiD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="W9USd1sc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CeiBQRiD"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66L6FqD74107084
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 09:23:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=FkYchCVKwIcZJig5+v/8W9
	v47TfaXHUlnS0aoR6aXK8=; b=W9USd1scg6xvdVYSvtF5DH78yVQZuBbb9N4JpD
	4nhNhxuaJDJ779OhUfg+IzobzHbhl2xPlEMGEqlJpcdgcvs8rUYrPfgQ7PKDUNFi
	OOnmvVWaNklUfBkHQjHJi3haehAb8XMAeF0SvMJViPnRD2Oanwi5OggZCyKNwEos
	+Hk7JZq5HSwkz4Sq6SIZasNqD8N/ypGxlkuS05D8euLKw78IrgkvW5Gon4jjnSRQ
	kIDkFx6I2lv9CTvnhrCAcOAq7CUt4EBjffI9XmLG8+KOw62nioftCKpRTf8hAhhc
	cx1BIrFdVVPg/NMhGkNUB/4HC5kfrWB41kiszOt6K/3PjvdQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fhvqnafk5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 09:23:25 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-388cfc4848dso14052956a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 02:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784625805; x=1785230605; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FkYchCVKwIcZJig5+v/8W9v47TfaXHUlnS0aoR6aXK8=;
        b=CeiBQRiDL5HNjYxP10pHZlVYg+KZrSJ0hJOqAMNmFs+vrPeriSqfnPtQlVfrWrkUCb
         9JcRhQha6Kt7873U+z2d/XsxjnoyOH/eNjcLO/uHK5AMEcyBtqObWDOenZsO/zq9Xfxv
         KDnJsDF42WUXfwLCWdZIvsIiPqsJcebFqBk6qELHdueXVAyQcm/O8zc+bnvmb3AhQ3ad
         Q2Yzg0VAxPpJU2cH1K1bjao4pnyVcoIwfGmHGpS/FISTWP9jYieLqQ4kYkuNuQjSuEOI
         xE9aRWHDJrfSJQ8tp2H6tlMfjyhZgQ1cgpc/73TYDq0g9E93z+7pMGQox2003BOIO6NQ
         m5XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784625805; x=1785230605;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FkYchCVKwIcZJig5+v/8W9v47TfaXHUlnS0aoR6aXK8=;
        b=RuYet/r3fuYZn3RIbIJWyrNh0bb1nN2WwJeb1hpjbXgGV/wu+nmN701Md5qy9yR79R
         VXJyfX9Upax9a/yKBf+9/s9kzEcBfRyGz2w4sBEhYAxu8yXyRTuLzC6Q0vLFcWNvnV6e
         WoFzkO6oM/jm6GMfQLR1uzb5YPjcNLajOcL65z/asFCu7IfxCj+OcTMOYbDtUuuIKnrZ
         TWWnfQT5j7mW9W0dyUTFnsjmAkg27geeXXSI6VNmW4pD7d0wTxyF1504zjTIvKeYuIex
         4vB8anpTJkPrT9I9F4qxvIzSSMXEPRd/v/3FqVORlZWaCEVxbqzhDL+fG3IWtY62Et/O
         TRIg==
X-Forwarded-Encrypted: i=1; AHgh+RpVY6UBA1Aqn4hiWTuOPyphYHAKFMqodt8KvoDsDJXOY8P3qU5cCtmJyFSypK1q9Qw/EBUw9qMkguWFpKg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5BD0ad+jdtv7zL+ARBzEx31SrEUyFtiFZFwZPHMKwBd3fIWf6
	U0O1PlOu9ZrEBSbNBENUW11Vycn7V6fpYbd6dILzoxj8KnfkOVy7RvJ2/bdancANBqUVSFd9FQz
	vDZf+ZWL0BC52xy2nc+SeALtDq2O8Nm8/pWDpFfWKcrWyAh1bxPVUpl1JwW+yTfaSmrY=
X-Gm-Gg: AR+sD10dK7MRgRbfOw8f63ECbTPqai9x4c3B78WbXfGD+frm2XOKagTvxrHYJqFIIxM
	ObuO4LBy5Yf+MUWSXgmBKHRqF0fowJFNKQX1PKDVfFs0z1Rx8lSf/mhLzfGXAOnm5wqsA9EPNnd
	+mn6hYemDCboNL0tfbFX+RAOEigwf7WLjdbrPSfO61YEZY01MXYV5TptN/D8984eRy27EF7ETVz
	+nFo5PBRiftdnRtO9fdkiShurk0QSJezJ/t5m2JryJl/BHZIfWXNaRLmQzQ8ywOQMlIWh6D85wT
	qJdty7SoaPFxCClH8P+XHdbn7XiGMvjAywZ79oqrp7tyORoSiCg3TvKHrKLsmY6UJ1Xa6MPTweE
	CSW9vmJvyW23yqcvHL0mTxX61El1Ywaxqi2bhTyRG59Kf34ganP0pyllJ0rA5bF4fHolx+nce4g
	==
X-Received: by 2002:a17:90a:dfc4:b0:388:1927:fb1d with SMTP id 98e67ed59e1d1-38e4b41120dmr18953435a91.12.1784625805169;
        Tue, 21 Jul 2026 02:23:25 -0700 (PDT)
X-Received: by 2002:a17:90a:dfc4:b0:388:1927:fb1d with SMTP id 98e67ed59e1d1-38e4b41120dmr18953395a91.12.1784625804684;
        Tue, 21 Jul 2026 02:23:24 -0700 (PDT)
Received: from cse-cd04-lnx.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e4801e0f3sm2308661a91.2.2026.07.21.02.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 02:23:23 -0700 (PDT)
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Subject: [PATCH 0/2] Enable ICE for UFS on Hamoa IoT EVK
Date: Tue, 21 Jul 2026 17:22:32 +0800
Message-Id: <20260721-devtool-v1-0-ade633accb41@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAF06X2oC/0WNSw6DIAAFr0JYlwQQQb1KYwzfSlrFAjVtjHcv1
 UWXM3mZt8Fko7cJdmCD0a4++TAXIBcA9Sjnm0XeFIYUU44FYcjYNYfwQDVuqxZjqWsiYVkv0Tr
 /PkrX/uRon68SzKf89zpw1jBBiqE0+nuUg46fJYfhGCWLHDXc1MphpupuZb8HJYvXYZp87gBrK
 06rlhlphHGcayqYbriQVJCiNcFaUqUa2O/7Fwdz1T3lAAAA
X-Change-ID: 20260714-devtool-5093900ac51a
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: kernel@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDA5NyBTYWx0ZWRfX1m9f1a3G6WPd
 FHsPAssbtuiZUDAugbL8LdgIRPHywa4LNn7MQ9OeMLUT6Hie3kVCVC41OBIhzByDVfRnvUhPefD
 E3nOkQW0GuWghzYrq5FvMTWPEQTqMOp7X1jw6qyTM1jRqhGamBlkq19zTJgFBmFfimEt/R8yyYW
 8DrRm5OYCAG0wR4NekAmvSLqr3bPAWLTOjgjymq5Odqx3xNIXCUeEM9fgkGMX0xX0U1UT0agxyf
 KVZbH0M//yPTwPcrlN+J9E0V9E1kN4sA6mUTD8onHBGO0bzD++y+Frzd30aGaWfJfxqRTRMkPXw
 aRUbm7txYjd53qQHRt2x4b7rHixO2cN4iF/KtDOkPU8yrfwqYKQ9teDztbIIDF6iLHZ3ZtOO6i2
 vBm9wiyP7OJGBgX3BktL/0c9xnFTeLJreZuFN2tvHrnD6Wrf16jzlq+acs5p3w5KVfVEI3TtyiW
 J9wwnyWGainXslqrCWw==
X-Proofpoint-ORIG-GUID: iF1aPv1fvkatHMIjb1SddfapRHNNGnEd
X-Proofpoint-GUID: iF1aPv1fvkatHMIjb1SddfapRHNNGnEd
X-Authority-Analysis: v=2.4 cv=M5F97Sws c=1 sm=1 tr=0 ts=6a5f3a8d cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=M4l5zgTsi59Zh--6b5wA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDA5NyBTYWx0ZWRfXx6lRgOQ2pH/Q
 GhN88CKyw7s9iDcSS+PFW3vk7+IS3+Z+ojq13BjakuXnV4VfHmIM9KLooK5ch+Ax4LC1GtZDPGh
 jw5CkSdzSfzrOH8kNDa+qpDeYuMoUmM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_06,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210097

This series enables the Inline Crypto Engine (ICE) hardware for UFS
storage on the Qualcomm X1E80100 (Hamoa IoT EVK) platform.

The ICE hardware provides AES-256-XTS inline encryption/decryption for
UFS storage, offloading cryptographic operations from the CPU. The
hardware version on this platform is ICE v4.0.1 with HWKM v2 support.

Validation:
- Probe successfully
- Standard key work well

Patch 1 adds the new compatible string to the DT binding documentation.
Patch 2 adds the ICE device node to the Hamoa DTSI.

Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
---
Wenjia Zhang (2):
      dt-bindings: crypto: qcom,inline-crypto-engine: Add x1e80100 support
      arm64: dts: qcom: hamoa: Add ICE node for UFS inline encryption

 .../bindings/crypto/qcom,inline-crypto-engine.yaml          |  1 +
 arch/arm64/boot/dts/qcom/hamoa.dtsi                         | 13 +++++++++++++
 2 files changed, 14 insertions(+)
---
base-commit: 49362394dad7df66c274c867a271394c10ca2bb8
change-id: 20260714-devtool-5093900ac51a
prerequisite-change-id: 20260701-b4-shikra_crypto_changse-f2d6d5bf04b5:v4
prerequisite-patch-id: d5bc84db11dfa16371755109d32bafa6325a7706
prerequisite-patch-id: f653bca04deb0f4fe7d51b3064644c8e6b0d9c99
prerequisite-patch-id: 615f80abf57c155bbc190c1a70fe615a783755cf
prerequisite-patch-id: 59d8102674ce98be1a0e9b4d7939ffd8a7289ab1
prerequisite-patch-id: 691ec3b8a386d2c5b991a4311236f7f06adfc5b1
prerequisite-patch-id: 5b949e801e9bf4b5593a1f7cb8f02709eb3e869a

Best regards,
-- 
Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>

