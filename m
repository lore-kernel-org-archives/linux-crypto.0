Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4F236C9ED
	for <linux-crypto@vger.kernel.org>; Mon,  9 Mar 2026 21:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773093044; cv=none; b=aXvgiB3WYO8zzKl+GDYpewg5EO+GYfMy6feJT12dpeO987AMQ5W3a6Fs0zhF6kjixyAJUw3nGdf2qU7G68X1Q0qGtYhKwbwUFMEQgJNTFURO+gld6fao+mYzfs3kA3MPk6Mpg9GxUs8m6MxBHKcPbCv1s/4QmV9mwWDNpYGGkuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773093044; c=relaxed/simple;
	bh=BLwnTN/doYiYLxs22kfN13qTi3yC74+KoLLulJju9ds=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vl3emj4/IiK6zkdO7Y8VRzF9e6MRGtnvOGir/IMZ3o8ik7jUjE1wlDCLbRdzMNOc7f3H4qLTvvUBTUNz0ReL1LnpV+yC9dn1PrSCTutYA0x33MIR6Peo/1KXqeI7S2J+aJo3xf60V3gv4zn+1mcx1kiBmVCfcgfpgMorT7ujQ4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=W5AGlw8G; arc=none smtp.client-ip=109.224.244.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="W5AGlw8G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1773093038; x=1773352238;
	bh=MkcSEbNEv29g++i8rrpw/o3gQ1osp7RMsH/LfjL+u+0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=W5AGlw8GOGMExHKxvQJNHxCDG3fHftNNREzuspXorr97btTIz91KrskmmHIgm7T3f
	 VZx2FEHoFYqDH/B7Uw1ph3neErnKuJ9rK8sOXgF92v1FMhIu2V/fI8kBkgaxnpNACl
	 8JNYNBuck+U7jS8AbNtPfkwjt1SZ6J1SR6fm66IrLFa5Z0DdqFNBZkwHmuTaGQ8dh4
	 TSemmq3sNOwICgjTD1j/+R0OPWECZdRLdMim/2eZ/PZfIqdIOoBRaoFrUAXzI0VmZE
	 WdSS9G5hCaSUe7aB1ttik+yGa8LPAf0XYMsDEjaDFipTqfmELHu1L6n5YtL/0W2yfC
	 65Aw1Xf64XfGA==
Date: Mon, 09 Mar 2026 21:50:35 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>
From: Alexander Koskovich <akoskovich@pm.me>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Koskovich <akoskovich@pm.me>
Subject: [PATCH v2 2/2] arm64: dts: qcom: sm8250: Add inline crypto engine
Message-ID: <20260309-sm8250-ice-v2-2-0c8c46ccc814@pm.me>
In-Reply-To: <20260309-sm8250-ice-v2-0-0c8c46ccc814@pm.me>
References: <20260309-sm8250-ice-v2-0-0c8c46ccc814@pm.me>
Feedback-ID: 37836894:user:proton
X-Pm-Message-ID: 9418723da742b04029968d9c7aaf5a51e9c8dbdf
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


