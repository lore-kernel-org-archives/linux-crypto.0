Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DF3175A79
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 13:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369488; cv=none; b=Hnj1DBYoIrgESV9IyjhosSFZfkFCLq8iN89JUpqJegYpYYoOXTvgYFNbnF1FKhVA5roqLdINdra2zkT9NpZkmZbgZRhAYEVB/bgNMeveX6TjeS5IVpi4LCEQOUs4EQ/R7BfxLQ0dAkalrCA8BOKYDjqEUJxgqV1Kp1QojC1IbJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369488; c=relaxed/simple;
	bh=CXMPeU2b4u3KDwV+Fif8DPMBH5t/Q1IwFXg+RkJ1uCk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=tM19ecSuOtMNhkPeyada+GwimoOu7JOS+RuymWSVoYgAFzdMfJiJjHgvYUq0Jp2l3K5ErtL8LPIV3dcDsXvi7jmwCz70q2BFLcrrIdXOeoe5tJOqT9yOR/G1Ss8h2j5uJmakXWQQ2drIIttah729ug1OFzW4TwfCG9D6K68hkLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LKu5zN1F; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MZRNevK0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LKu5zN1F";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MZRNevK0"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64LAXrXJ818826
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 13:18:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=L8fZGa6Xq+LlaWCk3IUJJU
	Ra8z19KN5KTwoJE6k81ds=; b=LKu5zN1F2lAVDYG2PTysD0goayaWobN3g4akGg
	Zq+47VEvXrLBPBvSqGnt54DZ+FTKODb7mAoKMVo8ZyfZdtwT6iX5CK8DdiloGRKn
	Q58mFGNIKxHDP2kTUvbKvQx4R33RxEpuxCjhBoZ02PnNGSaI/b9Jq7mBgjIV1Hbl
	IZkvAxq2n0WYpPMEtl92W4AK1s6QYv96GHvD2DKoWhem7rz53gbiLbNQMouyFJtc
	xRbdCYt/wNzDuc9AgSyzuJlShZn0B3/o3DzA7usIS7NaKkUVXns95Aw5cxYP91tO
	LYEw8x/0Yc7s0bsAZLqC9gB232HfcA4zZgfTlv8ZY+jUuCeA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ea0dkgjns-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 13:18:06 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-837cc5bc6deso3798019b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 06:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779369486; x=1779974286; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L8fZGa6Xq+LlaWCk3IUJJURa8z19KN5KTwoJE6k81ds=;
        b=MZRNevK0Ay07tFI7GOjH7hDUrzqkZrMlG5WdzSNxJdfg/dJNXNR9OwOCovaTLc4Uy9
         FsOdfqeT6HrC7oY6PgL28OFKloBj2acVvaA7hS0wZ6nYZO+nWk8YUCcgx4N+A26506xy
         7uwgQJdK3YuWymwLzGnjqlPJZYwU7MIqk/WvjuA7hzCy+lfR38RarNzT/JH/wF+bfBUk
         Nqel0vMxmEANokDjKciXrjjbcXTZyJKrJpAcOIM+BGlSHmbhnd19jb3GhMJQktNf/Vse
         yT1Vj3zqT/e7E5+z2qwECM6BU7z8BM3iYViSifxxmntuoUa7r/aPKtQl4Ida/7N+HY1K
         xTQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779369486; x=1779974286;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L8fZGa6Xq+LlaWCk3IUJJURa8z19KN5KTwoJE6k81ds=;
        b=TLGmEpKsO2Og1hkM76zaQPIsN15ZNgeHNQhco9viIOnyvo0ZRxygshABrwKw+2Dk83
         TanH/TWV66Fn6Y4EcFDtCyQcylawpA7JOZ7+rJ6C4SWQq2sGiCXnbgSURmJEcwoJsJ/9
         32uku21N5InwcRvrJGbG/HRn/WCS7a2ULID7YpXOL6aL7sPTkUPguiFi50tFSRpPB9gc
         IJaxWca1aqSWpw8OVSbkqtJ1clmDDFQxxH1STBNv4+sNkVF+VxbwL4Oj56nd0Jyir3sM
         A41lpNZfHzwTJS7iu0o1vhvO3PAZTrWe3Qfw1NLRkPgWiDqtxUp96GcZO4tbSDRYegha
         A+Qw==
X-Forwarded-Encrypted: i=1; AFNElJ8dIbSenc2xLSuQQ08Nhgd1dmFYmnC6HMeOGnfy5LYl3lRX7JLLpnG67WKyNDr0TVXQ1NzrTotvQlxC4/0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1pxcCPu74lXzFvgnOBOIaJX5wGuOL2sU+0+9CIwkurc03xxOz
	KnQ7CoFdveGWwuAl4+G5NxdpqC8DcIOBRrNdwjvuHy2tvhOYafER2ODN1wwyoIzuPGbsGOOrYjs
	fZbpAgzAnuKjPm8yW2Bipn381RArf0UTvOm3b3AL4i5uEZL8jndMnk87aF5vOuWGI1/M=
X-Gm-Gg: Acq92OEfh1NPpMI4hCHtYy5rdoVLltE5m4JTh/cO3iwEw3UpBrUi07x9/iBQ98Pwu5y
	Q2mOgflsjruQtG9HS99OM/ERQWnahVpG29HV/qyil+ok6Lxu5ohlM/0jZgLs04ZC8HSDdndmeY3
	dQCwgJNyTiopFVIB+5UXAH3Wb3lF6hj0ib/vmtWYFrSGX7DGZoI5vkL6uZXSvNTTof3PD+WpWXt
	XYsfoAarUwvMrfBES0SzZ3Dxh8raGLZOFs8uk+38bRjPTfwfxObDXk8pfa3XRm7G5oKm1BmddwZ
	NGDy3RZLCpUG+LypUNj6cNCI6VZBwzQ/J1kQW9uo9TedINKgiCLlAL21UAuRdMtqMvGw+2rzoTG
	I/R09Dsrzr+7OP2ucGHyk4h5T8IsQoG1lEq9zxvFlU099Tv5K+4HpFp0=
X-Received: by 2002:a05:6a00:a229:b0:83e:c76c:d720 with SMTP id d2e1a72fcca58-8414ae01396mr2913123b3a.30.1779369485956;
        Thu, 21 May 2026 06:18:05 -0700 (PDT)
X-Received: by 2002:a05:6a00:a229:b0:83e:c76c:d720 with SMTP id d2e1a72fcca58-8414ae01396mr2913090b3a.30.1779369485411;
        Thu, 21 May 2026 06:18:05 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84154e22f1esm1687731b3a.47.2026.05.21.06.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:18:04 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: [PATCH 0/5] Shikra: Add DT support for ice, rng and qce
Date: Thu, 21 May 2026 18:47:07 +0530
Message-Id: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANQFD2oC/0WN7Q6CIBhGb8W9v2MDUlBvxTWH8JbU/AjQ1Zz3H
 mqtn892nnMW8OgseiiTBRzO1tuhj4OdEtCt6m9IrIkbOOWCZpwR39qHU7V27zEM9c54JFQXUmg
 mpTg3EL+jw6t97d7qcmw/NXfUYZN9CYfPKQbDgf17ZXLU2K9GTCBGZqaQaZaKVJQzh83aqJjWQ
 9fZXStyaZTIC0q1gXX9AHgtk67cAAAA
X-Change-ID: 20260521-shikra_crypto_changse-0c976c17763b
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Andy Gross <agross@kernel.org>
Cc: Harshal Dev <harshal.dev@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDEzMyBTYWx0ZWRfXwy4Xr9pRZbZ7
 9+anr7BYIvr1k5ymil/9VKjs5U/NL9NDM3eXvdY2gyrS1wtMbCOnk1t78gt0c7LheOuCOTqBtb1
 G/2JneNt58a3XuHMK5ontJIbc4kb9SMVsnjqozYWEo9j3ZDFehiEGLQDMjC2KgoPzdvUYNK9FB2
 /JnMit9GO1Ua33+rOnHMu3n7mrd1CZR8+HhIU6LuKOhBhxPT+YhHFMUwOGMwPMM8e2Ut181O0sf
 krEynti81aTVb+6IEMlCgvwhu7gCmxWga8T7+VfCqC5BWnKSriRK6bQ34O54LpnblL4Hj60hQyM
 vwrQ7cVIzVuhAtEkGwS18ufrq6jrh3fE4tN6dcUyBHioCdGskD90DO87skY9S/4Lh7valvEvhuo
 sjnJdy5i0Ixkzd4UXQ/XpcCVnhBouq6m1ErIKKWoBHM0T3ivefULaPRY9JCwCxJRKXoBO97kndi
 3DY4yzDaDlPwb5BnU+A==
X-Authority-Analysis: v=2.4 cv=aueCzyZV c=1 sm=1 tr=0 ts=6a0f060e cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=dtPyI5Z5uvIguI3gzx8A:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: VRJSSCT4VEFRkv3AX5pXYupJ7QZXFA7d
X-Proofpoint-ORIG-GUID: VRJSSCT4VEFRkv3AX5pXYupJ7QZXFA7d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605210133

This patchseries attempt to enable sdhc-ice, rng and qce on shikra
platform similar to other platforms.

Previously, the 3 dt-bindigs/DT changes were sent as individual series
and with feedback received, clubbed them together as all belong to same
crypto subsystem.

Here's link to old patchsets.
QCE: https://lore.kernel.org/lkml/20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com/
RNG: https://lore.kernel.org/lkml/20260514-shikra_rng-v1-0-4ea721a1429a@oss.qualcomm.com/
ICE: https://lore.kernel.org/lkml/20260515-shikra_ice_ufs-v2-0-2724a54339db@oss.qualcomm.com/

The patchseries require below as prerequisite:
https://lore.kernel.org/all/20260512-shikra-dt-v1-0-716438330dd0@oss.qualcomm.com/

Validations:
- Ice: driver probe on bootup.
- Qce: kcapi test alongwith driver probe
- Rng: validated with rngutils package.
- Validate shikra-cqs-evk.dtb with dt_bindings_check and CHECK_DTBS=y
  with all yamls.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
Kuldeep Singh (5):
      dt-bindings: crypto: qcom,inline-crypto-engine: Document Shikra ICE
      dt-bindings: crypto: qcom,prng: Document Shikra TRNG
      dt-bindings: crypto: qcom-qce: Document the Shikra crypto engine
      dt-bindings: dma: qcom,bam-dma: Increase iommus maxItems to seven
      arm64: dts: qcom: shikra: Add ICE, TRNG and QCE nodes

 .../bindings/crypto/qcom,inline-crypto-engine.yaml |  1 +
 .../devicetree/bindings/crypto/qcom,prng.yaml      |  1 +
 .../devicetree/bindings/crypto/qcom-qce.yaml       |  1 +
 .../devicetree/bindings/dma/qcom,bam-dma.yaml      |  2 +-
 arch/arm64/boot/dts/qcom/shikra.dtsi               | 52 ++++++++++++++++++++++
 5 files changed, 56 insertions(+), 1 deletion(-)
---
base-commit: bbf247cdb7ea162afb0c9548e2cd1354abb6462f
change-id: 20260521-shikra_crypto_changse-0c976c17763b
prerequisite-change-id: 20260511-shikra-dt-d75d97454646:v2
prerequisite-patch-id: e6edea1ef76fc1f3a9ad944684bee330c9ad7e59
prerequisite-patch-id: acae1549863061f0fdd7221f0a924b0892f15acf
prerequisite-patch-id: d145c1bd01622f50c69e5c1f13dee469ee4d1fe4
prerequisite-patch-id: 1b0da59c3859cba8c5f4f1e6bf08429988134c46
prerequisite-patch-id: fac2b512a679e1507debab6fc279b292fe4048cd

Best regards,
--  
Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

