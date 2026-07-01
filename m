Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E962D0C97
	for <linux-crypto@vger.kernel.org>; Wed,  1 Jul 2026 20:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782937051; cv=none; b=HB5JSO1CchCCM17RloHiD1ca3J0xXy+TMJpbeKqkEJ9QoUfmohFBimAOVSX3vNLnDitNh1qV6/rGd6hlPaASWigVozIu3/HR83Z6f2mFZsyodt629dznP9GvtV0ts6XZ+yHyExd9Aujspjy8rFBytVwU2EDVripm5eUd/RcX3Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782937051; c=relaxed/simple;
	bh=/kt2kc2jbmuzKZ4McYNdX0AxlRXrEDLuEDhXarOS6Z4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=jYx4lcsI2iOJWRuq4K81iAHhWdAY+MKx78EuFygA44jdSJ4OkDS5tVuLUENzD7Xvop9x7wD/0CVJM+Hfg8QEi/3FH45Rmt7rRvn3QzYwfGlRq7n0xKuSwf8ZOVFbY9HxcNGH5IPf5i4ke91yo7WzsuBianKzHROYHebiR37WCg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FK0/mAWg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GIGFXpkU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FK0/mAWg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GIGFXpkU"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 661Gmxup1627988
	for <linux-crypto@vger.kernel.org>; Wed, 1 Jul 2026 20:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Td6g8hWIX0u7vVaqxIzSNW
	VPp5ms54iIRYivzwTSa5E=; b=FK0/mAWgoxbLlxXZmSkFi49rmaMGa2IOel+VXV
	rllUlrSiUx+JUNdUl4c/eAGvJdj+eQDLOQtJXXyeyk8+mXTxSslNmvL3hZalQRV9
	DFeqcg+D+cbUPfWf0nTq7OjeYTkTnkyGA2zpVdY3ZAeLFV7vyW7Ny/EA768Xu6L1
	ZNlkVPWa9o+uED0h847l+NawAlnEhFE5MHFsMd6A2e3kyBnj0Z9vJnf357HQoLod
	MLFRBt0oian7szrUAiwkZlJne+E/g1TzENAY2j004VlGVh5SxEHuRYT/oBHvgHeJ
	NyVSmhgVM0MHqoHpuSTNHNVa9FIkUnVnFDwf6yDOtgHTAsHw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f563090rp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 01 Jul 2026 20:17:28 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-37fc0aaa94cso1029187a91.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Jul 2026 13:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782937048; x=1783541848; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Td6g8hWIX0u7vVaqxIzSNWVPp5ms54iIRYivzwTSa5E=;
        b=GIGFXpkUf4BpXyflKLsEdX8hJ40bfFG6pd71mTfwznOwzJVZzASWOrQjhwwrW4nTXK
         PFZA8NFuOpkUtq8vNA5TefJ+Ze3LyqorBLYqkqXBbHIoAdWQN1sVP7spKQa3sJ11bo3u
         vq24EdV4yjz6lupJ9TlP6zohTQdOZL2yZ3pxIJA2oT+w2NKbtIx3EdwTRxbr/2K6uyLP
         oxg9Sj6D6sdevFngBp45MqeTZPVT5lZe7NoU3sH8NM/JerEVznTpfS1vuFmtlWwrPvFU
         cctw+/SSshmcfY1TDac/zBZ5uqv5Xs6REDvVCpFP7yYVHfIat7BFbWX+lW9dYvFMAMFp
         LmMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782937048; x=1783541848;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Td6g8hWIX0u7vVaqxIzSNWVPp5ms54iIRYivzwTSa5E=;
        b=ksvl4mLjHSIyBNQEDVUuORQn2MfftecdTO2NIz+pQHXXb3pjjzxfangoqXkOfDqlii
         llwZZ3rNj0U3GKhswpfFLW0JV3A7j6w/iIcOKp+jNKZyqhjpZ26K4dL/nZ85MQVk9BPe
         86KaKTN9ybsHSHHuuF/3yRYX93BqaalIn0MTNC2nI0e8GdQpNCNdM2Mdprbb4vQ95oyK
         nyqFlLwb4xlLFzE3WPdgkw/QbSQQjqqeK9Le1cWxlJIhW/H8lADBYmzwac+bNewsZsOb
         YoqlLt+QqYxumY5W5ETnJSfiEF2YlSFvCX8xL1Bzys1geZGQLgEbz7I3rK9wgvf0B38B
         TG8w==
X-Forwarded-Encrypted: i=1; AHgh+RpBX4yasCbHy+wjpxLY/opd5gLgekze6nObBieoauEM9QI1kSscta10Qz5NXH1+JbIZiIS07Vb6ypY33n0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yws29C/JJQTWV6WL48XY6ysuJBuUTHEkWMnxqBCeNVXVA9LR8Cs
	4v//pr+Ukn4JSQiVhohJPjP8PyEWgaDcwoTH5q2thjD/uQsvbAEPKDnhBS3YTWkPWMzAoPQiIgs
	fJShCh6ljK7IJ2Ad716SNa1smGdQoM1IPlpUohqYTCIbSJCo+NrhZ1XF22hNzinPOJgw=
X-Gm-Gg: AfdE7cn1d8cc/D0rPRQseOB4bS15Q+VM52/VrjSEP4N/VKd5jckHPyTY2A3HWk+iLFy
	ZHZRXk/oxy2AMa7dyMFmooJDdRgekYGnXMy3u6OZY98U0iaVOg+4ywbTr1wxtBUG55WGUCNUbdn
	yZuvAZdElButkBX6Wo/ylb3Vt3pO4yn8285+sR1fCIMfH6074me7UwZe07o89R4wvR+qv2vGrA3
	N64qf3u8LMNlrN1b5KUCfiZyDfPVwuQ3AovTIog444sZwaaDr5oJdcw49rhOwXuEsDgH+RclBz3
	U6BLyGVMY+DmgB3o5owDvCi093X9N3n6siNl3JXmeoD3+Rhik8Ohy+5FpHeLl38iTTugBGx8nmI
	qOEfgKh8BdumMV4PJ4+lVGvm5ThaKb5bcGyF5KzfegGj0
X-Received: by 2002:a17:90a:d647:b0:369:a359:b181 with SMTP id 98e67ed59e1d1-380aa221bf1mr2879506a91.23.1782937048236;
        Wed, 01 Jul 2026 13:17:28 -0700 (PDT)
X-Received: by 2002:a17:90a:d647:b0:369:a359:b181 with SMTP id 98e67ed59e1d1-380aa221bf1mr2879454a91.23.1782937047700;
        Wed, 01 Jul 2026 13:17:27 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bc79231sm948685eec.31.2026.07.01.13.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 13:17:27 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: [PATCH v2 0/6] Shikra: Add DT support for ICE, RNG and QCE
Date: Thu, 02 Jul 2026 01:47:10 +0530
Message-Id: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMd1RWoC/3WPy27DIBBFf8ViXSIgvBxVVf+jiiwYxg1tHTtgW
 42i/Hux3V3TDdKgO+fMvZGMKWImh+pGEs4xx/5cBvFUETi58zvSGMpMBBOaGcaplzSf4mdyDaT
 rMPbNGstIWxF0UL5l0itS1oeEbfxe0W/Hbc6T/0AYF96SOMU89um6ume+5DaNEvwfx8wpo4wrC
 VADsICvfc67y+S+oO+6XXnI8b65El6m0mbcDiAd5uzWNofqebVoLn4tNIx01oWsvQavbPDSmD/
 kl+XkBxhR0wjYYNdBk6dh6FOh2ULjTmjkhhtv1WOad6XT8hPHQ1U7sHIvZdhrqQyo2lqmWxMsB
 r7XtbOegQKpSsP7D7NHPxy3AQAA
X-Change-ID: 20260701-b4-shikra_crypto_changse-f2d6d5bf04b5
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
X-Authority-Analysis: v=2.4 cv=JdiMa0KV c=1 sm=1 tr=0 ts=6a4575d8 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=bC-a23v3AAAA:8 a=FNyBlpCuAAAA:8
 a=J1Y8HTJGAAAA:8 a=psUvNacZHcIMRI98aYkA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22 a=FO4_E8m0qiDe52t0p3_H:22 a=RlW-AWeGUCXs_Nkyno-6:22
 a=y1Q9-5lHfBjTkpIzbSAN:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAxMDIxNiBTYWx0ZWRfX4UjglcDCAipd
 cCkMhdszgH6aB3d8liW5IiOX7DtUlSkcNvD4kuOmRB05l6XOTbr/0d6qp1/miOPvjBKjE/sA8sP
 6B5NDSEdUQR1siCACUkipNRHXGv9U+s=
X-Proofpoint-ORIG-GUID: 8l0qhH9Y3eK2dJUuQNGC8PQJ3gMJZXt6
X-Proofpoint-GUID: 8l0qhH9Y3eK2dJUuQNGC8PQJ3gMJZXt6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAxMDIxNiBTYWx0ZWRfXyna1xxzp95Mg
 vBfYUpxbBiUca7xp/0fc5bLwR+2epKiLki0rYRvV0q6/RQeVgnO6xWAGok8p2aVzIr16Ht4KqCt
 Pccm7cmbNM4cvTHgmuQMql+G2KO5UJoS1soHDCxZcr3Ngp5D0YFIO6iLwu2icxa3wYc6iB9iehx
 jv6XCUvAbD5tGKU0v7blykg2gi0fCPrtadve7Ge8Q7VbVLdHhr5S+o5+xVWnTmg9NWyFao6nduY
 p6hDrL8BRQve6NpCkgbam4NFGiLM9sR/jFsxtd43qSZdM6nJbZwEAX+sk75HRryOmUUp9/3nkR6
 uPpcktVk39qxBgQgDlzkCBnTjW28ywZdL+/hVnKlTap6AXc+s3srMA7w0BhTZq9jV5GsHEIbbY6
 jpx6EA8FeE+WztmdaMmitiX0XsUySTHNnupAxWyJxmV9C4CdUnDkMMMImRRWaQ8MRKHbuIiOs3k
 q2GQvCGNPpzu9x00Xkg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-01_04,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607010216

This patch series enables SDHC ICE, RNG and QCE support on Shikra,
aligned with how similar support is modeled on other Qualcomm platforms.

These DT and dt-bindings updates were previously posted as three
separate series. Based on review feedback, they are grouped here as one
crypto-focused series.

Previous threads:
QCE: https://lore.kernel.org/lkml/20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com/
RNG: https://lore.kernel.org/lkml/20260514-shikra_rng-v1-0-4ea721a1429a@oss.qualcomm.com/
ICE: https://lore.kernel.org/lkml/20260515-shikra_ice_ufs-v2-0-2724a54339db@oss.qualcomm.com/

Prerequisite series:
- https://lore.kernel.org/all/20260612-shikra-dt-v6-0-6b6cb58db477@oss.qualcomm.com/
- https://lore.kernel.org/lkml/20260629-ice_emmc_support-v8-0-1a26e1717b85@oss.qualcomm.com/,

Validation:
- ICE: driver probe at boot
- QCE: kcapi tests and driver probe
- RNG: validated using rngutils
- DT: validated shikra-cqs-evk.dtb with dt_binding_check and CHECK_DTBS=y

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
Changes in v2:
- Add fix in ice bindings to specify 2 clocks defauly for non-legacy Soc
  compatibles.
- Update commit messages.
- Link to v1: https://patch.msgid.link/20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com/

To: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>
To: Rob Herring <robh@kernel.org>
To: Krzysztof Kozlowski <krzk+dt@kernel.org>
To: Conor Dooley <conor+dt@kernel.org>
To: Bjorn Andersson <andersson@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>
To: Bartosz Golaszewski <brgl@kernel.org>
To: Konrad Dybcio <konradybcio@kernel.org>
To: Frank Li <Frank.Li@kernel.org>
To: Andy Gross <agross@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: dmaengine@vger.kernel.org

---
Kuldeep Singh (6):
      dt-bindings: crypto: qcom,inline-crypto-engine: Fix legacy/new SoC strictness split
      dt-bindings: crypto: qcom,inline-crypto-engine: Document Shikra ICE
      dt-bindings: crypto: qcom,prng: Document Shikra TRNG
      dt-bindings: crypto: qcom-qce: Document the Shikra crypto engine
      dt-bindings: dma: qcom,bam-dma: Increase iommus maxItems to seven
      arm64: dts: qcom: shikra: Add ICE, TRNG and QCE nodes

 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 24 +++++++---
 .../devicetree/bindings/crypto/qcom,prng.yaml      |  1 +
 .../devicetree/bindings/crypto/qcom-qce.yaml       |  1 +
 .../devicetree/bindings/dma/qcom,bam-dma.yaml      |  2 +-
 arch/arm64/boot/dts/qcom/shikra.dtsi               | 52 ++++++++++++++++++++++
 5 files changed, 73 insertions(+), 7 deletions(-)
---
base-commit: 9ac84344d36457c598806f7d8ed1369a8b0c5c45
change-id: 20260701-b4-shikra_crypto_changse-f2d6d5bf04b5
prerequisite-message-id: <20260612-shikra-dt-v6-0-6b6cb58db477@oss.qualcomm.com>
prerequisite-patch-id: 3a689e8dda5fd2755b689d94d095806b3f2e6eed
prerequisite-patch-id: ac83151a889855498d36288ddd36216d451340c8
prerequisite-patch-id: 2357cac636e019eaf14d6a493a1c72bca56fe405
prerequisite-patch-id: 2885f299e711582da312ca9d13983d296a3dd5dc
prerequisite-patch-id: 91af5f3c01e766a53ce8de69aa21847a2d6bbbf8
prerequisite-message-id: <20260629-ice_emmc_support-v8-0-1a26e1717b85@oss.qualcomm.com>
prerequisite-patch-id: 0118397958b85e4297b47d6553ba4bf5b84024bb
prerequisite-patch-id: b6724798e8b73fb2182d11bda2a7aaa58976c7ea
prerequisite-patch-id: 4101033ee8eb0bc79c8dbc4a6c636cd527bf3bd0

Best regards,
--  
Kuldeep Singh <kuldsing@qti.qualcomm.com>

