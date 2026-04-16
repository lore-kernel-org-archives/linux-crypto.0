Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D385C3A6F18
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 11:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340790; cv=none; b=DOgS1dMl6A3AKJ94vJywcRcir9Em/SeFjb3B5N/dt2swOmu73gzuuHCTfK1E/NcnweKFepyzDQvyGrT1ToGaqnc7ZwVpZ+ELrTvzZZQD+MobSe7mLE3gq6hHZmQeh4OtRZvSTdjMNOHPz89w+zttCbWBEVmUUMdn0WYTh6s2tBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340790; c=relaxed/simple;
	bh=v11NCYPaDN56BgcyKqjsEpSZu1P3Ee+qDrc5qmUaYWs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=aipWrkolRIa1gIW74X95eYhRcK/otZOOl/0lRe4uzlneLm+Qs7dB/woNWG3joEqEuAxk3spYFdvYNenn+U1EvLvu6Han9wFmj2/W1JAovf6GwRuvYkcl7pURvRtDZ2YuO2R9S0UnN+bPWcYbNKteU8YCmDcASorCOkiXS7ALSHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=luGT1QXD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LsnOljFf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="luGT1QXD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LsnOljFf"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G6oi7f218900
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 11:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=7zpJuwQzHln1baFeIiicZG
	NaNPPbR0ZSkYUOUbfIQik=; b=luGT1QXDM/OQQRaBEwKGU0QJGb9O35XZx7pASd
	kFdTbpLt/UCfOOVfuRQW+4KwRlRxzacd+rpqCKH5/HcmPxjQ9OE7pqiAbnYHwPkt
	2uhB1k+hfLUw1ZnpCqhwM6UxsMnoBOOZpRwnVgavgmHfw5QEzaeuET/3AD5vNgnC
	4Q+CRQU1TBRWgaw74dY+ZXb2/0/GBciy+FOG6RAlGWtJ7b9x2dr3KsHdgj9z2z26
	5ljdPH/jJM0F92/KDGCSEVF4Y3V2fSquvnmpbC+BuEYdhn1pRRSyYztcBaRW9gix
	jzO+gWQIyWgeee9VQWaHCrp3SPzHtb2jdkdGZyD+T7ljurXQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djtuyh344-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 11:59:46 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-82c89d4ce16so5486769b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 04:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776340786; x=1776945586; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7zpJuwQzHln1baFeIiicZGNaNPPbR0ZSkYUOUbfIQik=;
        b=LsnOljFfjnXKir//FsWTfcGiuYQjdAS7FW2wy3ra8FCC3FAJT9KA/5rWiZZE13WzIi
         9hrOFoWUbkj8O4StRzTGNEJxFGxhcVMeNVKbmJ38h9Yw3sU5Rft7aeIHMqP65ao7PmKa
         wizde/1DH+I0P9UyvdEUS9I4uvTRL32jm7wZ11kLH5nUKLe8YXULLJcppSs8+/pw1wL1
         D8ZDG2hPqdVErqKN0Lzg97ok4PstIoPT+Fc0HIXqDBO5T3ilSOWbw7L4RItimJhTJAGl
         Fd4ewVIBLYTxL9pWWLP1CTAUjEKaqtEJcjOorV52RMBt66bt1XjqngErxodiX33mOtZq
         WcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776340786; x=1776945586;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7zpJuwQzHln1baFeIiicZGNaNPPbR0ZSkYUOUbfIQik=;
        b=E6aMq4op7dL/lNS1sDL467Vl8kw/m18TRpYRWUFarnNH1XGckk8nhgag9BFLeXqIkp
         uJvPzjlJDTZWhlExOEND5IA3e75LmeWFXxTNWrkHLYEEBQzxu+pOgdYbCh4elXhmSLwH
         lzD10lfakI86pfEMveQSHdAeW3zppxcgk1JDYP/oC8zytUwTw7dp7odzFpqG+hO3YHpw
         J/M9h+/wkk/UhVwVj2mpjyw0/Se7AF6Xi1BFj8v2KGhVK/miQ/nHkzqRtgw6Tz0W5c+p
         Orr9KfQotAlLo789Wa2+dZbqkfECoUqBKEMoMUw9iFxDw9femNz7yyIzQAgzz2Y9sMBm
         xwjw==
X-Forwarded-Encrypted: i=1; AFNElJ+p+kkTr6eDiTwEbW9RATA44i6px6xnu3YZebI0KgCINGMfBkAR2x3lRrFyS/Xw3WPpH1lPMQ3nM5wpSss=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYf7I6AOopJU75r1Irc2AsEF5a6qBsG/FIexKBsMtqlbZ6khss
	G3RFnngcsbYRUAueDZAHKB6QUCkJU6k6FGyuNuCDQwO/p5fdFrQccXLeXd82PZSARsVvrd4LNnI
	WJPEPXjlgRBjXvp93t4AS3WfMq3y0gct36U/ppr9bUAZpqLmWxdVQhtInFEov10xuDyU=
X-Gm-Gg: AeBDievzhIOoPAHap5ZdRA7vvY3EXPaipjmBflNfIHQ8xoVPIbeXgjCPFnQ6h7Uxb1L
	6jHo/ZSy0n3Kmu9ICVNLXSalf9MPw5k1sQe3owP310jJYe9wkBglni6ySv0oyI7Kd1pjiLrDmGT
	nqP8xoGtiTAEBdwCo+x59XBwfmorqYhcsGsRvdp1xb/c9gwrgSIxBUoWhRZcL5peIBlPh/AZGUz
	G4L1XXH4RjhCYm8tn7WSC4tO6vU8hLahvWqYrmuBVAi8mn5UX71xmRMxzRbN3hfpjvfzBGf6DYG
	9a4ALMWJp12L1/ks8+cnF/u/xthu8zdhgEXR2rjYO03W4iWURqaf0hNJRmN/eGH56+CfBIT4xY/
	VPIyx0gZiPq2tfcWwvBM2mOCdq9y33xeeX7nBGevjE2QfhY9JUb2YvBPfgw==
X-Received: by 2002:a05:6a00:3c8a:b0:82f:5576:2853 with SMTP id d2e1a72fcca58-82f55762a9cmr11937985b3a.30.1776340785524;
        Thu, 16 Apr 2026 04:59:45 -0700 (PDT)
X-Received: by 2002:a05:6a00:3c8a:b0:82f:5576:2853 with SMTP id d2e1a72fcca58-82f55762a9cmr11937922b3a.30.1776340784746;
        Thu, 16 Apr 2026 04:59:44 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0f15sm6335937b3a.35.2026.04.16.04.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 04:59:44 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Subject: [PATCH v5 00/13] Add explicit clock vote and enable power-domain
 for QCOM-ICE
Date: Thu, 16 Apr 2026 17:29:17 +0530
Message-Id: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIABXP4GkC/4XPzW7DIAwH8FepOI+Kb8ZOfY+pQgScFa0NDaRsU
 5V3H6k0rYcuu1j6W/LP9hUVyBEKetlcUYYaS0xDC/Jpg/zBDW+AY2gZMcIUoYzg0aeTjR7sOX1
 Atm4I1h/fbU0TYK2MJqKXhCuHmnDO0MfPm/66b/kQy5Ty121ZpUv3x+WrbqWYYDBEGq1V/yz9b
 pzidry4Yxs6bVtBC1/ZL8np+qmVNbIznjkpNA0GdqmUByS/J/U6yRspOW9c57qg3B+kuCP/e1w
 sj3NFhOi60IN5QM7z/A35XBM+xgEAAA==
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
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>,
        Alexander Koskovich <akoskovich@pm.me>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776340775; l=5845;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=v11NCYPaDN56BgcyKqjsEpSZu1P3Ee+qDrc5qmUaYWs=;
 b=levF1/sW9Pu+fsUkrwnw70AaDxds1D3dtZTX1N8wn+to9QfdJzzp50h8ZURyTammnxjLC8r+o
 JEnN4v5NJIvBhIolAofZTcnZs+yq0oPDtyHt2lhKAsjegKPzTc8XXw/
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExMyBTYWx0ZWRfX126bFr8mTj9J
 Pzku+rcYlOg0JWQ+HVoddud2YXqmOiyUMMLnsuPqUYye0gvpLXsK2+0Nm5bwGiVvmYID9eT6Q/A
 BOo1egpXbkc3SxltLZ8vmiMnbTN6jP3Oc7Jj2gptwRC76U/UJJxJ39TcxIyh6AkG0+FR0aLWmK+
 DqtCqtS/v6iwHL6/FILPxm5GWeJK8y+6bzTlizSYslLIbEOstfFvpeI8up5c+25WCXssG2okCog
 /DWPTVwMbUWnNYsb4vqaRgAF4HiBro+bn+0WnfhLkczKi3dtalvy+MlZiySQ5n24E/mERSxWPfE
 jxtAG/iN1x28CLiU7yZLWL4BkdyuvZt6lcFMXlA9UhYfgjA6tnt8oizetwjk0NgJkngyj8i+FIR
 eHWYwGsC4O0TqVl7m0JfBWKWVBlwvPXoNxGhcFz64cMSZu6dApe768YeLONSE4llHZZSlhc83pT
 g2/pupW+8iGTpnG43CA==
X-Proofpoint-ORIG-GUID: VprNFMhQ6rjXB5Ih21QAz5FVk92YKjir
X-Authority-Analysis: v=2.4 cv=Ipgutr/g c=1 sm=1 tr=0 ts=69e0cf32 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=OBV5qb9UG6WrozU1ayQA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-GUID: VprNFMhQ6rjXB5Ih21QAz5FVk92YKjir
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604160113

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
Changes in v5:
- Rebased onto linux-next tag next-20260415
- Added patches 12 and 13 to this series to ensure newly added eliza and milos
  DTS in v7.1 comply to the DT-binding introduced in this patch series.
- Fixed commit message of patch 1 to indicate eliza and milos DT support was
  added in kernel v7.1.
- Collected Reviewed-by and Tested-by tags from Kuldeep, Konrad, Krzysztof and
  Manivannan.  
- Link to v4: https://lore.kernel.org/r/20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com

Changes in v4:
- Squashed commits 1 and 2 from v3 to form a single consolidated patch with
  an updated and more concise commit message that explains why the DT binding
  needs to be fixed and why the fix is necessary for this release cycle.
- Re-order the ICE driver source code patches to be positioned before the DTS
  patches.
- Collected Reviewed-by tags from Konrad for DTS patches which were missed in
  v3.
- Link to v3: https://lore.kernel.org/r/20260317-qcom_ice_power_and_clk_vote-v3-0-53371dbabd6a@oss.qualcomm.com

Changes in v3:
- Dropped "_clk" suffix from clock names in DT binding and sources and ensure
  ICE driver looks for these updated clock names.
- Updated commit message of DT binding change (Patch 1) to explicitly state
  that the change is preserving backward compatibility.
- Introduced new DT binding commit to ensure eliza and milos require the iface
  clock and power-domain.
- Check for IS_ERR() on devm_clk_get_optional_enabled(dev, "iface") return
  value.
- Minor beautification of dev_err() prints as suggested by Konrad.
- Rebased onto latest linux-next tag next-20260316.
- Link to v2: https://lore.kernel.org/r/20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com

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
Harshal Dev (13):
      dt-bindings: crypto: qcom,ice: Fix missing power-domain and iface clk
      soc: qcom: ice: Allow explicit votes on 'iface' clock for ICE
      arm64: dts: qcom: kaanapali: Add power-domain and iface clk for ice node
      arm64: dts: qcom: lemans: Add power-domain and iface clk for ice node
      arm64: dts: qcom: monaco: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sc7180: Add power-domain and iface clk for ice node
      arm64: dts: qcom: kodiak: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sm8450: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sm8550: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sm8650: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sm8750: Add power-domain and iface clk for ice node
      arm64: dts: qcom: milos: Add power-domain and iface clk for ice node
      arm64: dts: qcom: eliza: Add power-domain and iface clk for ice node

 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 35 +++++++++++++++++++++-
 arch/arm64/boot/dts/qcom/eliza.dtsi                |  6 +++-
 arch/arm64/boot/dts/qcom/kaanapali.dtsi            |  6 +++-
 arch/arm64/boot/dts/qcom/kodiak.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/lemans.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/milos.dtsi                |  6 +++-
 arch/arm64/boot/dts/qcom/monaco.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/sm8750.dtsi               |  6 +++-
 drivers/soc/qcom/ice.c                             | 17 +++++++++--
 13 files changed, 104 insertions(+), 14 deletions(-)
---
base-commit: 936c21068d7ade00325e40d82bfd2f3f29d9f659
change-id: 20260120-qcom_ice_power_and_clk_vote-769704f5036a

Best regards,
-- 
Harshal Dev <harshal.dev@oss.qualcomm.com>

