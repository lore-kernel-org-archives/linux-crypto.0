Received: from mail-244122.protonmail.ch (mail-244122.protonmail.ch [109.224.244.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE433BA243
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 03:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773112392; cv=none; b=A/y7lpEzQG+d8JRSR8FJE0H1N85M9SBdpONGt2GzdF1E/qKZ0Yas435uFstOLMWVbug5Fo2MH/EQ9h+Du50qmgTvMGTbTwb/QlWv7ShDW1h6Q0hxKLw7F0GfJ76+fAf6dqNZYuy7SUgr0lgyEAB1v+J1SE7A+VxBMrlFtNjCf1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773112392; c=relaxed/simple;
	bh=9R4mzAkGVZjqkNwMRmQ5dTtBOqUrYpvHE9hkSl/bF/Q=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LQ2B+HETm1H5kTgBbPIVwjQLx/sodteoMmLFEibv1HQ3poaG3hDGVgbe+/HI3cS1bX423iftNY7y3oO/bTy/OaczznpTMedWM2fWeVrtl/nU0hut18JqLG4V3Dj9AJiMJHk0qYqnFaCRzcrsMh0Q1lTQ9noUx2aVUivptK9WjlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=Lk+oJM+j; arc=none smtp.client-ip=109.224.244.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="Lk+oJM+j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1773112384; x=1773371584;
	bh=mZiE53pGJGZnWdl5qaKL3RdihsPysxn+L55SWbAMxwo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Lk+oJM+jos592okj8kLv3o8QoXdn50cuLuVBo2Mwb2TmkvzBHUTfRsDyvlqPZu7o8
	 9ul7jRaRp2m8rMy+EOSM1J0WadVvXt8NJDLUJERd8OafPazp/YEBnX4szNpM6aDwyZ
	 CvPEUuVzcU9LXwlrLz9SYh1d6vlDF4d5/TAKMO8vYe/HklGJCLCn1+Y46F4w5/BQZW
	 O4dVbCOz/PN2GvdSxmbkwCq+foXUmNxeyjXC1PFaRxsYTQNQPnUbp3SqaJhRlTPJ3Y
	 GwbTWpkH5U5S/CjIxNmEFXQ+hd+aEW4tPNsA0SgYWtOF7EY5RUd0Iu3TxSOrNgu2cp
	 yxv9jbxHkhDFw==
Date: Tue, 10 Mar 2026 03:12:58 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>
From: Alexander Koskovich <akoskovich@pm.me>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Koskovich <akoskovich@pm.me>, Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH v3 2/2] arm64: dts: qcom: sm8250: Add inline crypto engine
Message-ID: <20260309-sm8250-ice-v3-2-418bf5c5c042@pm.me>
In-Reply-To: <20260309-sm8250-ice-v3-0-418bf5c5c042@pm.me>
References: <20260309-sm8250-ice-v3-0-418bf5c5c042@pm.me>
Feedback-ID: 37836894:user:proton
X-Pm-Message-ID: fda5794667f1377a0d573b45493d671670a83348
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Add the ICE found on sm8250 and link it to the UFS node.

qcom-ice 1d90000.crypto: Found QC Inline Crypto Engine (ICE) v3.1.81

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qco=
m/sm8250.dtsi
index c7dffa440074..b49007934278 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2513,6 +2513,8 @@ ufs_mem_hc: ufshc@1d84000 {
=20
 =09=09=09power-domains =3D <&gcc UFS_PHY_GDSC>;
=20
+=09=09=09qcom,ice =3D <&ice>;
+
 =09=09=09iommus =3D <&apps_smmu 0x0e0 0>, <&apps_smmu 0x4e0 0>;
=20
 =09=09=09clock-names =3D
@@ -2592,6 +2594,17 @@ ufs_mem_phy: phy@1d87000 {
 =09=09=09status =3D "disabled";
 =09=09};
=20
+=09=09ice: crypto@1d90000 {
+=09=09=09compatible =3D "qcom,sm8250-inline-crypto-engine",
+=09=09=09=09     "qcom,inline-crypto-engine";
+=09=09=09reg =3D <0 0x01d90000 0 0x8000>;
+=09=09=09clocks =3D <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+=09=09=09=09 <&gcc GCC_UFS_PHY_AHB_CLK>;
+=09=09=09clock-names =3D "ice_core_clk",
+=09=09=09=09      "iface_clk";
+=09=09=09power-domains =3D <&gcc UFS_PHY_GDSC>;
+=09=09};
+
 =09=09cryptobam: dma-controller@1dc4000 {
 =09=09=09compatible =3D "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 =09=09=09reg =3D <0 0x01dc4000 0 0x24000>;

--=20
2.53.0


