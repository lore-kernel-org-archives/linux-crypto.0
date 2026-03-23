Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5103E386548
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257496; cv=none; b=BYcLlMYuAlsgWwj1zIP70ir2Uu8jnFQInIIgCUk3c6ZZaqDIfT+aTJSsq4N+nklY10K3MePQ+afuwvupTyzfDDHXUAt33dAN2Vs8xBgrnDSQy5KaKuNW2Q3gaqJjQvlHIFFFQyTn7Kn2eMxYtZtUHHxU4I88A72tjco8yQDzQYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257496; c=relaxed/simple;
	bh=j1b7RhNBnu2rbSTsw83KASF1jOv8uCF3QwpS2ewKzKY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=b+/R120XlEEQODw7shlf935LyWXR0NBxWchrN4iK8Ytvo8frbfOkdFRZ6q8VpQy8a/6S8JGo/xIs3i+7jGQCmLPO7X8Hm0G2OfqLXI/walu1N1hJdVQXHmFg5qc7wUHh/CiauFj09nnGTNx96B8vwm4NoIdLq5XrZypXwvF8c5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pVH+x+sq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WbggKQA1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pVH+x+sq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WbggKQA1"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N7tBFh2291169
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=lDib2VtpKU9K5pUSRcSWBb
	qG1OT8YsLp8o99MeUF+ew=; b=pVH+x+sq3LRhJNg6KnAcPTH5JDgRIra0/nl3K+
	Q3Cu/wxr7J2XTuM3ztHCF4vG92JmzyM8D/t+Bx/7nQj0ILMzlEE59flW5kD4E56r
	BFrVkFB0GGP4Ylsj87wq5o7DFJOa1JFClu7vg9AO0f92JYKRr1xLIkTmqz7zQMxl
	VmgzvtkkHj0bKmRe/bHv1iJV2knePeGbcS9Da4YnyoysNGA40YNyBsQfcHCcyKdr
	BOXEEPX1gt3Ng7FEX3GRQKSTXzdUTwioqKfNldAuVq5EhzGTNyxLOei8AxNU0yXE
	VlmuPzLDAYZ26GXL9zC56s4Ja4MmbsCU3iSvpOWXhYQMzSzw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d31j7090a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:12 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso2975546a91.2
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 02:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774257492; x=1774862292; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lDib2VtpKU9K5pUSRcSWBbqG1OT8YsLp8o99MeUF+ew=;
        b=WbggKQA1bjdfKci+YAvC0gIzLebw9qZ6NGO+wtACi2D/ahi89U2aJRGO+/fRvhDgJC
         jRdNNj+kb+NV0G9L7mEqkdC5vr+Y8TPW1M9krHqyp7ucLnAKqH6vAXUvTdHihjzz0Efu
         w6yi7hUaYYkI9OI3oBJ9S3t0VJcacmXT20aefp8k/sL0v2OtqOFa/1Y9JUQDfGFZHfLC
         4a3n28RW/rchlcxcXnY8PqN+o2yqvi/4Pa6SUAPpx8JqTv46ad2bkgtuB5flNFZemZCJ
         tdZfvtnzndsAkpUG43AubgDU7HosNhBZjnV+9CAgJvfKKSgElkf8eQq2c7xehjdrGrn7
         foSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257492; x=1774862292;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lDib2VtpKU9K5pUSRcSWBbqG1OT8YsLp8o99MeUF+ew=;
        b=SldIiCVlqOklOd0yASc15AM7H6/A7KEid1sxhXPOgFtLoez8veng5GmVet35q21p7t
         1u8r8xFyQ9yqjG3bwwYIY3dRUnWUBhMGjnytl1PGFhVo0IBOZfKvWp47akpkDgLjExWX
         dtQcFac6/TfqPGDmUx1uvYcih0fjqbxl8PPZeNu8rANGl4MV1mprw0KOUnJcFl0mT+IY
         CkavHVZ5Pl8IEjJaiMCKqAVP4zh/8rCVT8+iOQw3wXBgrLot9OBwXyB7nFixvbMJXeAE
         g0TDExhN8SQ6OX6BPhuIygqNDvDYhz4omZvYNnBjsWisiKVVeJ4pRXdMiMQWUAhoT24K
         Liyg==
X-Forwarded-Encrypted: i=1; AJvYcCWnsoOEFZNW8Zbi3snAKq6RPN3u3NgRgYYFsu3+4PRrlAjQ2mIPeIhdJBUdTjCnj7SkfjW24M72Is8Xdhc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJZX6P1YA4K6pLlaDBoyRSL/KUwBR10hXqPZEu1kSgP4HOcKxH
	b7t4ION2cDe6/2O0s59GMIUyz2kFj3CChi1d8O+yaasCVfqv7P/x0fqEmjt4B4YK424MBc45dxh
	HZVL2Sd7L3XhQHhuWBxNO2FRqATQdm2HlSUcfup8Dd5pfHwCzM17aAQgvPWkyKyXgLUE=
X-Gm-Gg: ATEYQzzk+2a+EPHWZYqYL0+fArrfI5aOqiEGitrMqVfOJ+b+Qi8QIe17bhs9puWrjPJ
	oaXKBWd/RrtB2WVtKUKbY8q5jN2mbXOItx9S9/U9dR+79JZUuk6CfmGkhDRpmjkJ/NTfcmsJbsR
	UXAjppvYkG2otATpkHYggvD8AId+oK5VretzhEF5w8y3n+OoIYvLSOhijQpBhRKBYpD+BWquTuZ
	DR67hQE81i0//L2vcVvzw79N99bJUf0iHzqgKO5rXubROnEgpznOOw6ivyQ/iyKpkOLWZ687fEn
	qEdWC+JLgq7Sjj2jWTiCBZBOcA1riQV+WJZmgbYh3M6KkjO45ZTN/QRzPZNSjR1LS4k1tC4tkXr
	BxsGrOliDbogspYWhhRQHecck1+oiX0mowIkcA6OK90tFXnw=
X-Received: by 2002:a17:90a:c107:b0:35b:a30f:8bf1 with SMTP id 98e67ed59e1d1-35bd2b9e133mr9607309a91.6.1774257491755;
        Mon, 23 Mar 2026 02:18:11 -0700 (PDT)
X-Received: by 2002:a17:90a:c107:b0:35b:a30f:8bf1 with SMTP id 98e67ed59e1d1-35bd2b9e133mr9607265a91.6.1774257491193;
        Mon, 23 Mar 2026 02:18:11 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd358b5ecsm3923448a91.5.2026.03.23.02.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:18:10 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Subject: [PATCH v4 00/11] Add explicit clock vote and enable power-domain
 for QCOM-ICE
Date: Mon, 23 Mar 2026 14:47:53 +0530
Message-Id: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAEEFwWkC/33O3YrCMBAF4FeRXG8kP01ivPI9REKaTjWsNjapc
 Rfpu+8oLLsX0puBM3C+mQcpkCMUsl09SIYaS0wDhuZjRcLJD0egscNMBBOaccHoGNLFxQDumu6
 QnR86F86frqYJqNHWsKZXTGpPULhm6OPXS98fMJ9imVL+fh2r/Ln9deWiWzllFCxT1hjdb1TYj
 VNcjzd/xtJljYM8+Sr+SMmXX60CydYG4VVjeGdhl0p5Q8r/pFkmJZJKSuRa33bavyHnef4Blvh
 WIXMBAAA=
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
        Alexander Koskovich <akoskovich@pm.me>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774257482; l=5037;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=j1b7RhNBnu2rbSTsw83KASF1jOv8uCF3QwpS2ewKzKY=;
 b=OCsWGJQHNnceQEoCKbhHNeGbJKeiEpHk7CYI0R6bBU7+IMDGmgpmfd7n2zfq9MKymJeq1yiEm
 B2c82uPMNcGArsIxo3gwWBx+gsIzpCCqCNULKbHW4YA8MVH+lwKQd57
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=ArXjHe9P c=1 sm=1 tr=0 ts=69c10554 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-kUcK9qbmMDI6-bBbbUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: 5wvyLO30V2Qf7i32B55ihxX5ew_pnl5E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3MSBTYWx0ZWRfX9mSfjxPHB4Bb
 h0LpvYwsqKFQ47oioj1Ts1eI0I3t2PfY+o4TSRYvCJI9LILqU+2LbsKyB0TEB4lzNZzdk66DYS1
 jquObmcXJURFEdjoV99t5jKNHqwrLE1pBKGk54/0t3lIrf+1bjd6Sj2fslrjvBrGAUIBMiMCakY
 bg3RzC9BYA8H19iGci9WFXW9Qs2YUmKGfoX8nmtAIOgifdnIbwAaI3RIq82r7Mqrl5/SHGlO66B
 kjKEewSda9q0/s4z0k3+gn6T2N4zKgRdIG9sIp6CC38i95GhpN8HPAd6oGuLqay27zKuisCjCd8
 cGqky0deEkxUcEvJQ5WKSvSaXp81apDQiIUc4GvXdX4qpQINka0CfdWQKQ2/F3SCMcekFubnMyu
 gJMl7MWcJQ18GzyJNyD6+fXvX+tl6hF1QvDltjfw5StJTFQVITF7kvUXsC+Xbzyw0VddNLfIcpS
 coGho6s+GqWKSX5QIFg==
X-Proofpoint-GUID: 5wvyLO30V2Qf7i32B55ihxX5ew_pnl5E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230071

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
Harshal Dev (11):
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

 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 35 +++++++++++++++++++++-
 arch/arm64/boot/dts/qcom/kaanapali.dtsi            |  6 +++-
 arch/arm64/boot/dts/qcom/kodiak.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/lemans.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/monaco.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |  6 +++-
 arch/arm64/boot/dts/qcom/sm8750.dtsi               |  6 +++-
 drivers/soc/qcom/ice.c                             | 17 +++++++++--
 11 files changed, 94 insertions(+), 12 deletions(-)
---
base-commit: 95c541ddfb0815a0ea8477af778bb13bb075079a
change-id: 20260120-qcom_ice_power_and_clk_vote-769704f5036a

Best regards,
-- 
Harshal Dev <harshal.dev@oss.qualcomm.com>

