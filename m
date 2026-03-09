Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564A136C0D5;
	Mon,  9 Mar 2026 21:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773093040; cv=none; b=ajl9PlQJkPOag38bmqHu+tyGd9FmLrAa/UgcjoBjEO9i6fRUdKVYO8r+vw1/TQjbqU0m/c60LrnoTCSxeDwVRkJFC4u32smCA4I2oLNv7qnlUpXyx7fbOe+IJBJuuHAb1xhnkDwTojtkAhW0anLIJe3jhNPsYURG6TRcHFsXeIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773093040; c=relaxed/simple;
	bh=/PvnvArxdj/IZDWSjGxdN7IjU/0ZdpHZ67CgFqkwIZg=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ZncolzFVj4yBUTc0jfW7Al3WfDKJVa0SPV4Ai2UmXGeHNECSBeVEbnAF2ZjPq6Wv85k9/QzxgQnaX/o8O5VxDlVDID7ZPU3hIPDRN+wFclH3CCmzkiebdZlZxbK9sQ7XRRDtkQABv2vVAILyDy00MAFZ0PMjA/vftf8mqTg53Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=KG0Rh4lO; arc=none smtp.client-ip=109.224.244.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="KG0Rh4lO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1773093030; x=1773352230;
	bh=sC3YaKirmpx4zG2EfuSbaQrF9WS6VTqoT/LIwSDtjJE=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=KG0Rh4lOvhw6hi8AaqSwdnaUMTfke94/VFpJBT0FHd/2WlMh1bXXlYK3idJd+4Ncn
	 w4ftSUnyF6u8NhosFlLrlpyMJeGnr232ahtxLfAcpAY647zDHnV4mpVBlpKawfOb1x
	 LNx1ZSRJdW3tabHA2nfRAgg6JZUG3JViPcBfF51Ge2nkhaxFrGHlM3kp6cZuSxFe0X
	 gB4y0+YKO/qdKAEE5Ypopd79YegYJXW07epbmdnvxO15GMoKnXAYgKZbitfgmcepFp
	 wTXE88f8vskkfSSR0zZmE+hMJSvmlJ7xSp3oaKSC4y/5Dn5iRr5AbfyCXMx94cOx9C
	 8EnoH78X0uujw==
Date: Mon, 09 Mar 2026 21:50:27 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>
From: Alexander Koskovich <akoskovich@pm.me>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Koskovich <akoskovich@pm.me>
Subject: [PATCH v2 0/2] Enable inline crypto engine on SM8250
Message-ID: <20260309-sm8250-ice-v2-0-0c8c46ccc814@pm.me>
Feedback-ID: 37836894:user:proton
X-Pm-Message-ID: 909d1e1f47a65f093de1f7952c466447117056b5
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


