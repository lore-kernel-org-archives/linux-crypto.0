Received: from mail-244121.protonmail.ch (mail-244121.protonmail.ch [109.224.244.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DFE3B9604;
	Tue, 10 Mar 2026 03:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773112381; cv=none; b=SYK8yhwshMu1fRo8O3qKS6DjNUDRWqr3fv1wAyrOtl/YqHm7Ivy4UXqz+blGbD6bSytr9iQSnzSW/HptoWOTedbKa76xIZZXuR+HfCKf+QeDceWGKOHGQQTxaC+Sgkdh8zrL/VoxI3XdtLwDw0PPhKj2ntjwb/3i2lmPY+rPKIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773112381; c=relaxed/simple;
	bh=4Pcwl7hBVZRQFEdmkgECGuTcQC2YUm6xHOqdXHCNP5E=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=MEtNmJkzgto6NAbCcD71y/h1L71peqJrxf2juQF51x3VgSXbbA4M5YTYSAJTc5jUce7RAz/Y3wbQUKmyeGLKHf1EhaySudvNlg6497ar8Nz/8g693JNk4VbUb3D2WNrTv33mnr6rs3TitdKoa7Ty0pKP1dEdgpWzglqbLrJIZ44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=NclQKV2l; arc=none smtp.client-ip=109.224.244.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="NclQKV2l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1773112372; x=1773371572;
	bh=/u5N+xQIPg6xybChiK81z7cTH6sS76jS6i91RFXSNFY=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=NclQKV2lMhrr+R9dTwp71fCk6vh/Qx/oUJh/51PhW3XJV7/PmK6am/tBwqONIRuFI
	 G89B6Evj1Hx2jj4ovYuadt+F0608cxHiZeHLWjSNQK432aOhHe1FhC1dh5ATlXDKgI
	 o/JThViDLbFB7nyyR3tvd3Ql0uPYO2REMGnlklf0XFOK3guroTJQtcpUJaQ9YoRBST
	 FnT3nl9fsAEia0/z/02qq3R4yQvOlVBTAnTrIZcFUztLXFV2vtDCHyS4idSse9xvUO
	 /lb0IKPJb7uJGfelBvShC5XbdQE5Xs64DH0JJaQxyxG/mCQNCdWpdmb02n71J6Yrj0
	 kNioE+ifoC5MA==
Date: Tue, 10 Mar 2026 03:12:49 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>
From: Alexander Koskovich <akoskovich@pm.me>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Koskovich <akoskovich@pm.me>, Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH v3 0/2] Enable inline crypto engine on SM8250
Message-ID: <20260309-sm8250-ice-v3-0-418bf5c5c042@pm.me>
Feedback-ID: 37836894:user:proton
X-Pm-Message-ID: 512a86e260c2e6ad0b27e52816c96e5fee9d553b
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Add the ICE found on SM8250 to DTS and link it to the UFS node,
and document the compatible used for the inline crypto engine.

This series depends on WIP changes that requires power-domains and
iface clk to be specified [1].

[1]: https://lore.kernel.org/linux-arm-msm/20260123-qcom_ice_power_and_clk_=
vote-v1-0-e9059776f85c@qti.qualcomm.com

Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
---
Changes in v3:
- Add missed Reviewed-by from Dmitry
- Link to v2: https://lore.kernel.org/r/20260309-sm8250-ice-v2-0-0c8c46ccc8=
14@pm.me

Changes in v2:
- Fixed From/SoB mismatch
- Added iface clk & UFSPHY GDSC (adds dependency on in review changes)
- Link to v1: https://lore.kernel.org/r/20260307-sm8250-ice-v1-0-a0c987371c=
62@pm.me

---
Alexander Koskovich (2):
      dt-bindings: crypto: ice: Document sm8250 inline crypto engine
      arm64: dts: qcom: sm8250: Add inline crypto engine

 .../bindings/crypto/qcom,inline-crypto-engine.yaml          |  1 +
 arch/arm64/boot/dts/qcom/sm8250.dtsi                        | 13 +++++++++=
++++
 2 files changed, 14 insertions(+)
---
base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
change-id: 20260307-sm8250-ice-800e656d7321

Best regards,
--=20
Alexander Koskovich <akoskovich@pm.me>


