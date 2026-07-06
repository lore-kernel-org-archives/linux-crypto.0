Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB5641737A
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 11:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783337528; cv=none; b=MNKu5M1ufb2ARKHEBFnz5mx1AJGhy6zJSOFOZeGosE1buUpoEuD1af82I/hk2dU+fUXCq/gv6dfylmGFciylJ5hvOO47k6qHzSUey31MwoQibG4ELd8fkGlrMa6tGow+RwkIhW5zEoHpFsiRcIN48L4CLBBzZDUKsYY4HJON5/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783337528; c=relaxed/simple;
	bh=wsN4Qj8nyQ40xLi0czEZnpsh/82ufhgYUDoGmikiwFU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=j+1h/lf42+lcQJ6xqKhWiApN2vgQmHdrfXALf/ebHe3qkHMUKn8VIQh/ytkN4xUdd6X+I9sVrde/DBRa181f+ltqtDiwCbW+7px3MmnwywYKbePTLVsfYsYUfXM+rLugCcxxUZ0d6n/iSu0r5mYF7OvfjpN39HJouT0YOD+jyjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Tbek1Em0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DP+9AxC7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Tbek1Em0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DP+9AxC7"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666Ax9bZ391056
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 11:32:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=E7Q/PsRxa+vqndhp+ONNBD
	gCCG74mkgHXpn3JzjDtP4=; b=Tbek1Em0iDoveqt4PIN//nwZwCzG9x9tf45bR8
	7S6fGZRNwr4irn7E51jjoFmI3ew4rAib5eIETnV0ddNwIutLjGuSM2z6C/4MRN3H
	p89q+j3Wp/eJmIDj4jQ7cAAmEnMXUP1EG/w7k5cH/OKrMEqBoy+fn+qDyBDebiUL
	xu/IvVi0N65DUpgXE8kur58+T4tvLbY38agvgC1kJeqL76C5uaP5UqSrX0xVFXel
	TLldE4XuugJIOZ8N1rOMZG8EpaFgGwM+/LwS7OccPgQ3ZsGmUXgzWNxMhRSE6cVa
	FrYzoU6eKgqxw1LzpaUd6xKOIeHZsi8anLpAJkGCybZ5S+jg==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f89kgrgdm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 11:32:05 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c9fe4c5eb39so1695745a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 04:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783337525; x=1783942325; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E7Q/PsRxa+vqndhp+ONNBDgCCG74mkgHXpn3JzjDtP4=;
        b=DP+9AxC78zBe3nn/B3hB38fnNNP3FwLrXh/6Yh13JTqjwwlmI1clAKWNyV00PbdU85
         9177LmyogORdEG3jhPTlYk2OV9QFV6sqUvMPbyyatEDYL1iqlqzpDzM4GSNv7ZModItb
         bBgREXG+7HXZejX9ZMsWfNnfoyvJWk/n9RQgHwk0oFa/M44SvSo/WzPb3/hmydEx9w1K
         ugbDBV5EcyHy4gyXev+QvXJGI5kFX+TxVh6/imiiLaP8qlua3qH2VeZjcSF8Ledh8Abe
         tCANGkcs7TqRbxtBpPcx3rvMfs7Xjq9Avz5d178I9vfBvHsD+HgbBmye+X0nG+CNUb9R
         a0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783337525; x=1783942325;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E7Q/PsRxa+vqndhp+ONNBDgCCG74mkgHXpn3JzjDtP4=;
        b=diWcd2ffkrQSuHsuZt60bmDQJ2ZO5TlPVIVVpPSfTTGOaukSAEF0aYxahAnhh4VxEw
         nLmwRyMLVo1b6sYWK5PeNeaRi5FIFke4/IWqqZXWHiN4opu1csqETO+cBKI+PH73Hf/s
         qZuvgzcvcc3QWsVApcxw0dyJblGPibr7ggtZF2DmniHpMLKMX6PCQQQKP0bOWHAbRBvV
         BruZrtb/kvP4oL1K1clc2lrbv5xg40XQBdG0KR+/LGlFreWY8OY3CTwPPV9pcmkENzJW
         lpFXRUh6/R3Nw58Lt5G4gAqWgGNDKhV6lppbqMRx1OT/SrrxVgKQoUndP2OL7UjYI8F2
         1PPw==
X-Forwarded-Encrypted: i=1; AHgh+RqZX299YbyMwgz30CaRgIW0ho3MggnYqwdztHdRGfLW8RMTgpQFZiCijr3bLdkOIIetEbcks02qjhq2oZ0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5krCN4KuLx5KsLVxuL+v4LIhUcHSHRcpbvxEXlxo2qkFx5Fb/
	FOYdF4ciKqm+vN33GKLMDlSK4RXVeoYboFH02MwhYlDhMns0Tjw9gmXtw7/XsNIEOf6ETZ93Gkb
	Pp8NH/LCbYlyhFXVAzAEIt4ZGkAPVi0z5jQCQn2LQMzqKXpIJBskNyWTWSUGIThEte/I=
X-Gm-Gg: AfdE7ckgTzSGtnSwZXo6SBzZ2Lru4C693fA8+6Pq9VgT/PCRN9SCD7nktNQZdcsQIFY
	JJm+jLvXD5iMOlHNIAl4L6f8iW0oNYyLFZ/XmeFtKCzHDQbfomrFzwGv+XJb5FnPIcV4r3i4tPd
	o14nIGOMV/Md4WvPYeulUG1DM4Yk5tjKNwpv+S/K0NB0azH7fJWxKLZy5tJCuckV/1U4tiKvYDc
	03tE+Xd15FSkU785JFNVpVJd61KMMoTf33zY8ZlFqpFhb6hJXY2SoZ0jg5Qo6SaoByOWvKRhmW+
	witMQpC6B2idncXnmxhP5mqvcJG8Tl/yYVbTSpX2CTbJJQLR+Sf3iyM7FAC97Sl+ZZYdgmNCUIg
	bpcp+471Q6KjL05dVy5BLHdJvx6GoxHAPjw7KO+7QdYJD
X-Received: by 2002:a05:6a00:929a:b0:845:eb88:3d86 with SMTP id d2e1a72fcca58-84826e54b7dmr83350b3a.48.1783337525085;
        Mon, 06 Jul 2026 04:32:05 -0700 (PDT)
X-Received: by 2002:a05:6a00:929a:b0:845:eb88:3d86 with SMTP id d2e1a72fcca58-84826e54b7dmr83320b3a.48.1783337524574;
        Mon, 06 Jul 2026 04:32:04 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6dbdc8dsm3576621b3a.55.2026.07.06.04.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 04:32:03 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: [PATCH v3 0/6] Shikra: Add DT support for ICE, RNG and QCE
Date: Mon, 06 Jul 2026 17:01:28 +0530
Message-Id: <20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABGSS2oC/3WQ72rDIBTFXyX4eRY1/ksZo+8xRtCrWd2WJlUTV
 krffSYZDLbui3Dk3N+5515R8jH4hPbVFUU/hxSGUxH1Q4XgaE6vHgdXNGKESaIIxZbjdAzv0bQ
 QL2Me2tWWPO6Yk07YjnArUBkfo+/C54p+ftl0muybh7zwFscxpDzEy5o908W3xQhG/8mYKSaYU
 MEBGgDi/GFIaXeezAcMfb8rD1qiZvYDU4T9v/PMCk9KquqOdUzb+nDO4Rfvtu0e/Xkq18lbIdT
 7lMx6nX31uAZJyr5TsMt4lgvZSrBCO8uV+rPp03KCOxjW4AC+9X0PbZrGcYiFpguNGiY9VVRZL
 e7TrCmdlp+Q91VjQPOac1dLLhSIRmsiO+W0d7SWjdGWgAAuSsPbF7p5RyMHAgAA
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
        dmaengine@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-GUID: epKdxOR-6EqWm0hHnqSjVcm8SG_3MGMd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfX7xViVM/X0oEU
 3pxVLDX7dCxps8G/JHLpL/OPhn66tdeuYD3C/d7spbOQkATAYCr9jUn294RKH0Oy3ZROG6XI3yU
 QfRaagqig1DahHlyu1wh3Q5QuZZpk3122RjhC6hqALq4HtfDlyay+fmw0GIzeUOjkn2+jj5f77x
 63a4zjDh+aQqNRtjaaTrIhV/J72T43bl6/OyxYY/cTvE5LLB+5iiUsXsFGMdCFZx78vFKc1UI3h
 jdDJES2yB1ZP76AJDWtCjs7DQlDfQG1/OsppAMt7lwxVwVSvTSwY61hDkHpYbTcdv/ZzK3G2OtL
 Tzu5zLwYWa/1HV7ufgRwR7t9+TY1CZnr/zXJxLHghDBdJw6fwjON7+GvkmVxtGmL3WB65vJ5pi2
 B1JJB6/3vwCNNd9bwJ2ksYJOCQi8Ya59iDR7fiQR0DqGgBh4RmFWNNXfQxvuj5yl8W1gcnPOqN7
 m5bfntst2YSSfRBeSXg==
X-Proofpoint-ORIG-GUID: epKdxOR-6EqWm0hHnqSjVcm8SG_3MGMd
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfX56MFwz5PRtXR
 S5jppDNS1NpLtuGSLjleyGvPoWpPEayuuIkwqCFbeZ+yBu9EOyiLFpZwRUN1hAE+vSdz4onmfKS
 0ztUXsD3MD73VjvN8ywQSJNgfMkB0AM=
X-Authority-Analysis: v=2.4 cv=c6Sbhx9l c=1 sm=1 tr=0 ts=6a4b9235 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=bC-a23v3AAAA:8 a=FNyBlpCuAAAA:8
 a=J1Y8HTJGAAAA:8 a=psUvNacZHcIMRI98aYkA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22 a=FO4_E8m0qiDe52t0p3_H:22 a=RlW-AWeGUCXs_Nkyno-6:22
 a=y1Q9-5lHfBjTkpIzbSAN:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607060116

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
- https://lore.kernel.org/lkml/20260629-ice_emmc_support-v8-0-1a26e1717b85@oss.qualcomm.com/

Validation:
- ICE: driver probe at boot
- QCE: kcapi tests and driver probe
- RNG: validated using rngutils
- DT: validated shikra-cqs-evk.dtb with dt_binding_check and CHECK_DTBS=y

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
Changes in v3:
- Fix commit messages.
- Collect Ack and Reviewed-by tags.
- Link to v2: https://patch.msgid.link/20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com

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
      dt-bindings: dma: qcom,bam-dma: Increase iommus maxItems to 7
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
Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

