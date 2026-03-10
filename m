Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA976364050
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773130008; cv=none; b=pZSYX1IsAVN3ORFgqi7oXYW0EepxZt9C5t6/TtnOXaSc3ktaUq7VY5msFnTUEE3nq4KXAeJMD4zEO5VfW7yeGp6b82SI+ROom5O1yZJOhcUfN48apJ8ppyBNWFHFoLRrnIn4ofsv0kdMSKoKCtCPbaj/eBwtsG8D99cjQ8aJ6aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773130008; c=relaxed/simple;
	bh=znuNKLO3y4Wqzl8E3xgPlJfCPI2s6M2M47CqfMQBpJQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=bghY6lzOjQ9eytRQS2M9l9ghZc3zWd0IDU6FIVWnmSxk9BSWvlFnbOeIuyUKT1PTzd3DlG5o4Y90GLRRiIvLlu8dkS83gqRRgaekkQUnCpDSw+jYLy26EZDE2PkWEjn6NUEHjTsrv03L++Pe/LW07qX+Rq9DIhI4f0121PzmGJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PxFfG+xC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=anhF4fmE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PxFfG+xC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="anhF4fmE"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A2EQiD2460646
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:06:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=oJgKz/c+fGi6e9tLbQFA2+
	z2rvGKv1CqSIdctAOGMwo=; b=PxFfG+xCUy5IkbRyYxKa987uIGMzCP2qmcetec
	NyUDYLh7oderGEBPmZ4shgSWn/Wiu5EqFizMy2CgWAR2EeohodBnyNsUv4otfaOA
	qfQQ5Cm2jch8RNhLrFg3nZWK0itRCYrf7i4QHfEqTVInn+115jGduTlHtVPtR3vW
	u7OYcTF6axhXfnljMBa7syxrbrBK6PodOi9UyL7sVpHwlsbhRAHYk2WSX58KLQZn
	ClIl1qtPSEbErhslP+NGUXFToMelzniC1k2ioLzOPFD0MSTWbPldDRsoq11DsCjA
	ePW7YZNOLtqUa5qJs+WeDlm3MlsRI1qCNbe8iLO0T5yf+qBQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4csyv1b88b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:06:46 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c7385a1476aso3478650a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 01:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773130006; x=1773734806; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oJgKz/c+fGi6e9tLbQFA2+z2rvGKv1CqSIdctAOGMwo=;
        b=anhF4fmERGmRthoDwe4Pe9Be9liQfvnTiQo2MEEuhHxNR/odjiW2yUvTVR3BJaG8WX
         Y10WgJj2eK55P2RrOOlTHdLcVXb1wwp6wzkItjBWT8+5jrLm+nf05Qe5FqVG5A+JQnv9
         3SztZaOqhFHbP9SE7lCAklfiN13JsoE2oU/Bt3YilLm/WcZ4teMC2ntFWs/RBjSpQFzX
         2K6xXdI6gC2otPS6P5LA8xhhpeDkPEEXZEtI2z2L4OwCOVSB+dCAlrFWsxbRSQ8yWXyu
         ZXSRxhT4q+S4rkiqJ5tyG+3kGLmVOHVOmiprVRda0fftAVZb8guzSNpQRwZsa8sIeALr
         gC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773130006; x=1773734806;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJgKz/c+fGi6e9tLbQFA2+z2rvGKv1CqSIdctAOGMwo=;
        b=brG8nQkLnG2ollANhzs3ecHwZa5tMaeEoTOjkpsXYok53ijqN6ZMYOaWmYQdSaY7MP
         TMmDTnEdUm0jeIhbmQt1hJJCaV7YA1ZIvztIh4/nS/6lKG+FuRa3YNYrfEVPRNxnCqaE
         JF/fEgwUfierXu/V/OR/pGPvGcNCUqbrhVUuwx7JRATIQDiC/RFNSsmpCE3X5iP1QMH8
         mW4B2Vt0zBnLoU6po5AlLQtU5kMGXFeI2oIgiUF2eHBq0543El2z50qXkdaUE6peRXqo
         dKKUXa86JQCblqP1p/1zcvotfK31nXeq96IroOsOagfZqTzTBusrsLuaG6zO8ouJhOlP
         tzNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwHvca1xCTrpJYFecWvN2nLB4xv9Xau5f6s9+Ycqa9jyKK1z/NmOxtyEGNN9QUm1WeYSv4yp+b5Atb/yo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8oc+/HZ9gNbRZaP9RZu7p/BdEsRHezku8HNxxOV9oVb7ipCmZ
	9qH3uznqBlK3uCgUR+ks2pCAXewFWusW9IY3ZAcTSrc054/owydk8YK7uU4HwvpVd2/mw8hGBGV
	uODrkku7erpBYy21todeGD/1TrpSHyF7h603QklL1CLDk49qqa2Q9lziRSdJTvHsxIJU=
X-Gm-Gg: ATEYQzyavAZFP7U09LC6burnEMPWNXfXhE8X8iMrUsCJyv4F6AZlfC9p10CU/zaGVOI
	KnhLSiDoVBvOkfkYM46MCnjLMRXJa+X2IMs8xZVhyzCKQgzL8uHGBUbxXRzwVmGwEMkw20Qm2Tf
	nyIKK8uq6GtPXaB29XCn17/QUSxylplOqGWWVbzZItmYkzea1eWCT0uSdidqahW2XGLZVLGsGUn
	AVlYECY2c6ODqXGq7tmlTmtFBpxmfgp8TJpIfIpq1wxdvBgJpZz4diKXfe4kSKIfsAfBM2xXNrY
	pLrYz5RAjxdR6xoX5kudDXrlahkJmKiO4rdpLQdvA3Jgr66qgtsHCsGkGTnP6HgidlNofG201LG
	kcyH1OW1TCnlGKp7a9oZe8aBgjRE3aEfelzEVI3RhPSGHzIE=
X-Received: by 2002:a05:6a21:9089:b0:398:8a92:78a5 with SMTP id adf61e73a8af0-3988a928090mr7058409637.28.1773130006119;
        Tue, 10 Mar 2026 01:06:46 -0700 (PDT)
X-Received: by 2002:a05:6a21:9089:b0:398:8a92:78a5 with SMTP id adf61e73a8af0-3988a928090mr7058355637.28.1773130005582;
        Tue, 10 Mar 2026 01:06:45 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e195c40sm11121969a12.31.2026.03.10.01.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 01:06:45 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Subject: [PATCH v2 00/11] Add explicit clock vote and enable power-domain
 for QCOM-ICE
Date: Tue, 10 Mar 2026 13:36:26 +0530
Message-Id: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAALRr2kC/32NQQ6CMBREr0K6tqQUacWV9zCkacpHfoQWWqwaw
 t2tJG7dTPImmTcrCeARAjlnK/EQMaCzCfghI6bX9gYU28SEMy5YwRmdjRsVGlCTe4JX2rbKDHc
 V3QJUilqyY1exUmiSDJOHDl+7/dok7jEszr/3s1h825+3/OuNBWUUalbVUoruVJnLvGA+P/SQR
 mOegjTbtn0AKh5DJc0AAAA=
X-Change-ID: 20260120-qcom_ice_power_and_clk_vote-769704f5036a
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org,
        Eric Biggers <ebiggers@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Yuvaraj Ranganathan <quic_yrangana@quicinc.com>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773129997; l=3862;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=znuNKLO3y4Wqzl8E3xgPlJfCPI2s6M2M47CqfMQBpJQ=;
 b=keSLETTky6TJfKmnsR2NnND3UhV0YVvXWnz65lfcs1IaBs5Du+EZbyuUKpGNqbewqZ7SGVT5X
 1xG7CF0BxLOBSfYuxhuE9PMmLJAxhxEwWEohRlTm7DARWwsyUKFAEhO
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: mgEmrnXZUb_YlODWGZ4F9vU-UK7ccoR6
X-Proofpoint-ORIG-GUID: mgEmrnXZUb_YlODWGZ4F9vU-UK7ccoR6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA2NyBTYWx0ZWRfXw6tMIMM463mp
 XWIz4KS63DYF3e/RC91VR9SWDsLfWW4hucqSVG3BDXxX/5tCWicMk3PNW6Wyo0iG+umXObsC7by
 WIraxTIKlDJhapq6/0zeycGPlnnpaNdPjyYy7PPE2ugoXX6kfix63HqEa8OzKyqUDLDnRqSXDyO
 heWVBU4s3lP0qdry/Cka1RmE6jTdUn4SBE1ZM57mnXEbxqlokKprz9x36UylJJ+JbtVhpoqToRn
 9Dkzvx8gQkJeBMJhlJSKYGKH5yQWXeIJnYDYuyhlPgK1Mlv8fMBkcn9GEiY9grux94W0Ms8Lfi6
 bAWqWY5/CANuL//9nI9V8fCYAOWvzpneLHSxDqwMBZif/eUw/Nu0Ln+44rMkL068w11n29/yrHs
 3mH3tIiMG21RgmuhuBuWmqaqDFTXZ3k3R2R3pmho88xqK3qixhls1agUyrLcQrl0DZtYeKRgrAM
 rLPlzX9+PKC/oIJuung==
X-Authority-Analysis: v=2.4 cv=Cuays34D c=1 sm=1 tr=0 ts=69afd116 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=g2SMA5Qby75y8d18gdwA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 spamscore=0 adultscore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100067

When the kernel is booted without the 'clk_ignore_unused' and
'pd_ignore_unused' command‑line flags, votes for unused clocks and power
domains are dropped by the kernel post late_init and deferred probe
timeout. Depending on the relative timing between the ICE probe and the
kernel disabling the unused clocks and power domains occasional unclocked
register accesses or 'stuck' clocks are observed during QCOM‑ICE probe.
When the 'iface' clock is not voted on, unclocked register access would
be observed. On the other hand, if the associated power-domain for ICE
is not enabled, a 'stuck' clock is observed.

This patch series resolves both of these problems by adding explicit
power‑domain enablement and 'iface' clock‑vote handling to the QCOM‑ICE
driver.

The clock 'stuck' issue was first reported on Qualcomm RideSX4 (sa8775p)
platform: https://lore.kernel.org/all/ZZYTYsaNUuWQg3tR@x1/

Issue with unclocked ICE register access is easily reproducible on
on Qualcomm RB3Gen2 (kodiak) platform when 'clk_ignore_unused' is
not passed on the kernel command-line.

This patch series has been validated on: SM8650-MTP, RB3Gen2 and
Lemans-EVK.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
Changes in v2:
- Updated the DT bindings and ICE driver source to ensure no ABI breaks are
  made in this patch series. A follow-up patch series will mark the clocks
  and power-domain as required to preserve bisectability.
- Added list of allowed clock-names to the DT-binding.
- Added Fixes tag to mark the original regressions and ensure back-porting
  for stable trees.
- Updated the commit messages to explicitly mention the problem of
  potential unclocked register access and stuck clocks during probe.
- Dropped explicit calls to pm_runtime_* APIs from ICE probe, suspend and
  resume.
- Link to v1: https://lore.kernel.org/r/20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com

---
Harshal Dev (11):
      dt-bindings: crypto: qcom,ice: Allow power-domain and iface clk
      arm64: dts: qcom: kaanapali: Add power-domain and iface clk for ice node
      arm64: dts: qcom: lemans: Add power-domain and iface clk for ice node
      arm64: dts: qcom: monaco: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sc7180: Add power-domain and iface clk for ice node
      arm64: dts: qcom: kodiak: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sm8450: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sm8550: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sm8650: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sm8750: Add power-domain and iface clk for ice node
      soc: qcom: ice: Allow explicit votes on 'iface' clock for ICE

 .../bindings/crypto/qcom,inline-crypto-engine.yaml       | 16 +++++++++++++++-
 arch/arm64/boot/dts/qcom/kaanapali.dtsi                  |  6 +++++-
 arch/arm64/boot/dts/qcom/kodiak.dtsi                     |  6 +++++-
 arch/arm64/boot/dts/qcom/lemans.dtsi                     |  6 +++++-
 arch/arm64/boot/dts/qcom/monaco.dtsi                     |  6 +++++-
 arch/arm64/boot/dts/qcom/sc7180.dtsi                     |  6 +++++-
 arch/arm64/boot/dts/qcom/sm8450.dtsi                     |  6 +++++-
 arch/arm64/boot/dts/qcom/sm8550.dtsi                     |  6 +++++-
 arch/arm64/boot/dts/qcom/sm8650.dtsi                     |  6 +++++-
 arch/arm64/boot/dts/qcom/sm8750.dtsi                     |  6 +++++-
 drivers/soc/qcom/ice.c                                   | 11 +++++++++++
 11 files changed, 71 insertions(+), 10 deletions(-)
---
base-commit: 0f853ca2a798ead9d24d39cad99b0966815c582a
change-id: 20260120-qcom_ice_power_and_clk_vote-769704f5036a

Best regards,
-- 
Harshal Dev <harshal.dev@oss.qualcomm.com>

