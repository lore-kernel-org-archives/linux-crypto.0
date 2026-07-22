Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46884746BA
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784712432; cv=none; b=XFFhUtqdOwp5yZEpeb9PK8mf+mo/AJ183yoO6Butun/lUgBEItYe6cn3/iw+UiBlPRAVFwxyxpOGqZwJcCEh/tWJcTWdw8Zd62qlvMHhR8twxbp/6FVaAzAxXc+yQrrcnGB5wchhzAYZo1TcPr2fe1t0usUsyDt2OWQrMJK4sqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784712432; c=relaxed/simple;
	bh=uW/Vj5fuJng1LvdLmMQs506xzm1+TVv9B57jQPoSfxg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=CgKmWBm/riLFDRt+1PVF7fSJeiFuCWb5mSUEcg0MzKO6sboYhDHqSP12ZZMcIk5FNtcRjZ/Iyt1Ev0wE7in3Eez7ZESnT5VAIKJCYuxqnnNpTOCKqlMC983xMzWwsfrTvms2TkOwJXaMoNATltvypFqZJY6EiCVEC/hGXhyirWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bkooD7Zq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bDMqjN8O; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bkooD7Zq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bDMqjN8O"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M8xavH269720
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:27:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=n0OFJwQjx85fwwK+gVcoig
	tUxSx5yPqwqgEn2qCbrtA=; b=bkooD7ZqL1qTUQtGyvlWyI0in4ekJagrO6CLyC
	ZR64B0fVD6Cx/UlzlCUxscxm/RoqeNzQEEk4rYVJ9TM8jXwWzvC7otyEwajgCRpH
	JVBOKy49kHrbpBziQnGl4QwIUjml0pCssuiO+ITjQCEmnTMkz7/nnKCOtQQd83aF
	9UYqMOfgTuFeWAeq2W592ePFAroUULM/rp7vrjHDQCUXOghOQFXdDWLew0N4e12z
	hMWWKvgF7euxSYqWHte+i1OjL1XAJQKKmIsYzyA1vWoBoN/smfxJhuCqD85/3VvA
	nkUb80MHKmo9GRdLlcUymrt4XSrsvDZ9+iJxoIKy46+MlDTQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fjd6ab8s8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:27:09 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb48f41343aso4391292a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 02:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784712428; x=1785317228; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=n0OFJwQjx85fwwK+gVcoigtUxSx5yPqwqgEn2qCbrtA=;
        b=bDMqjN8OFOzF83QMPCgSdYN3dc1i0RWZ40vv33yIJhYkMHA6BnOJpCGZA3TNipw5po
         fUXEl0XLnX2f+XDyo1MrH6+RlZ0bgF2dIYPOuKnSshALbbT3vt478yJYbFppVZLSWLlX
         xmgzorDyLvpuhJjE/SJw2lrQJhuloTrkq8RHrvx202Kkk+aBpu9QmhrwnvSJ72CB5EMJ
         c4MO+QfnqQf+9ZsvXtpvgCXf0MTIgILxoVIGBWaGmvSxu9jO2/hkIZMnyGbcbrNJVXVV
         HCxA5zEZgk5qFNeDooVK1MI2mv8pOOkRmCO6utGMAjLP94IzPaeio1ajjuCopbflvfSY
         DPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784712428; x=1785317228;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n0OFJwQjx85fwwK+gVcoigtUxSx5yPqwqgEn2qCbrtA=;
        b=O70VKtbgBpzZznaqCfzpWquO3n2loJI4h+Y+j6BSBvyg7j12w37VQgmMalf1oTuumQ
         LRkp5gOsDMXuncug7nMFbVFX6tsOjQB/9AzP6glyhEflO1o/tLV8Ff+aXyNO3UsRJZp0
         zmGX93J9p7fhOLwUR1d7e1rz8GWPUi8NG/nD8uw256L/zr6mL6Iln3KwNidDUh/840sE
         c1ZV44qnr7ICP1AykArsCCOxhZw1reh7KOgTMukAdpMrRZ9KaW9aEruI6wwMwfA2Bwjz
         89zbojC5+5A8AmOphWmX7JCENdttdA1EEjERQIxlh4/9Y5E16WU1VikdS+Zhk6AkaowW
         gtdw==
X-Forwarded-Encrypted: i=1; AHgh+RrhP7xYZFOZbDFgSBz2v7HnXaW1kb/PDAe81gyYveb/q43pRFAymfWvwvYfS4nw38sfDX7b75pkQNEcD7A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpNkjGwy30+E3hGfnOvlgVf56KuDoTGHL89yNSe8BlbsPcQjjk
	EJPNBvwhsCNk7X1pCPadG1p458oY6n1KXx2RluqVm/o7+tegA9oNhubRv6f0Riw1xwnrGZW+tUU
	pcOgTtrw6wny3+7qaAnDejXAXFPqGW+zVz0399rq0EBaVyFITTbAamCJHlYVTp3mLn20=
X-Gm-Gg: AR+sD12GZNq/i/9KiKTx5w6R2rbk97BzjACdl4VmlE+p6vjWufO2dHmSXdmd0t0usDS
	qlgkPEoiFtNRJjb5D6Fnik1qfbjfyapGIioFkGuZ+ZTLtDllpEWNpSfLMKuUIOTRkTrUr3nl1ow
	hb8x50qETVmVWEJiGlyWVyaz9JqZOpvJ0pbAM6ByNMqyEyVveSj5CSv4bqNvV3QJE1mRKMA1rv3
	oh9iLFAOoVKw2DxSE7VyTu10idXtng++bfkpuAlbYNdJRhT41L7t5rdk+gWmJhJjYnjigDmsUap
	5H2jRKJDc5pzKXIxojhcvGyi9WosNIQFPs/Mwr2j9LWVUP3pDENDikXILDzT62Tb5m5E1RQeKlH
	Nk6IGH99+yzPaoh62vcl1fkyEj8CD1m11Ts461tOT99wALMkKMgO8A00CeEtblEU7/hqL5IkJpA
	==
X-Received: by 2002:a05:6a20:c78e:b0:39c:4e62:b843 with SMTP id adf61e73a8af0-3c4292dfacamr3611008637.10.1784712428206;
        Wed, 22 Jul 2026 02:27:08 -0700 (PDT)
X-Received: by 2002:a05:6a20:c78e:b0:39c:4e62:b843 with SMTP id adf61e73a8af0-3c4292dfacamr3610985637.10.1784712427768;
        Wed, 22 Jul 2026 02:27:07 -0700 (PDT)
Received: from cse-cd04-lnx.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f18f08asm850677a12.21.2026.07.22.02.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 02:27:07 -0700 (PDT)
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Subject: [PATCH v2 0/2] Enable ICE for UFS on Hamoa IoT EVK
Date: Wed, 22 Jul 2026 17:26:27 +0800
Message-Id: <20260722-devtool-v2-0-d7e609ef7388@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMaMYGoC/0WP3YrCMBSEX6XkeiP5a2J75XssIic/3YZVo0kMK
 9J3N03BvTkww/CdmRdKLnqX0Ni9UHTFJx+uVbCvDpkZrj8Oe1s1YoRJoqjA1pUcwhn3ZOADIWB
 6Cqimb9FN/q+Rvo+bju7+qMC8mf+8im80QrEWOM3+N8LJxOcth1MLJYcnZqXt9USE7sci1g8aq
 m/C5eLz2ImBS8YHYcEqO0lpmBJmLxUwRattKDHAtN6jtcvsUw7x2UYW2spsDRj97CkUEwzWSc7
 BGC3oIaS0uz/gvL7c1YOOy7K8ASPSYY4xAQAA
X-Change-ID: 20260714-devtool-5093900ac51a
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>, kernel@quicinc.com
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA4OCBTYWx0ZWRfXwdgJ5mFwNHB4
 VkUldKgm/jYdyNuQhXfs53QkbMh8t1EXXAicVKwKSVAjBY6Lib6o+iquQn6AXIpMan0MZP3YK5f
 aIFy53ckxshY6bH0ZHjFEjebWCRnIgxFLebaB9a0wBUByFHe16TXClKXEi5CIGLrxySRTSxYZ0a
 MY+1DBYBAAYq7hEsvyU2keYUvqo5iBF+rSKXQMabINpqK3g9rewwZA9RheJNDv075Bo6dTEc6C0
 f8CLRaOci6G3kloXLwkOwmqeBfcfhO7GVsLbSacALfYrkelfBz+YGMYRTht2f/s5KRAusiFiOaX
 SJ5BoCn0H9XisrPBpO34npYtJy/ZBhwJ5fC46v57ycEkWBu0Oghb+s1UuGKRbBiWMK9bi2G/wSb
 wbi4s01RWiRi9lfcj92uBrRXZUkH38jY68y5ZFfV1OKa7X3x1wD82TfE/nCiZHd95x8nKh5kraP
 4OozLBAQbcJku/FXMig==
X-Proofpoint-GUID: jWSlssCl_HKCpmZvj0PTUbNDkQNYBTEI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA4OCBTYWx0ZWRfXypa+NBRFYyxS
 Ye4b9yqCxnBGWiOve+175mKbNiWQn/ZJmkltZ7/3mIBkbXZsZJNZH+B3t2QzOpC1CWL7X5K/10J
 AFvg0ESks1EC4vu5C6HKCaq1z1whm9w=
X-Authority-Analysis: v=2.4 cv=HvJG3UTS c=1 sm=1 tr=0 ts=6a608ced cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=M4l5zgTsi59Zh--6b5wA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: jWSlssCl_HKCpmZvj0PTUbNDkQNYBTEI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 impostorscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220088

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

Note: The allOf conditional block enforcement for power-domains and
clock-names is handled by the prerequisite series.

Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
---
Changes in v2:
- Improve commit messages for both patches.
- Link to v1: https://lore.kernel.org/r/20260721-devtool-v1-0-ade633accb41@oss.qualcomm.com

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

