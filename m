Received: from mail-05.mail-europe.com (mail-05.mail-europe.com [85.9.206.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276961DE2AD;
	Sun,  8 Mar 2026 04:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.206.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772945366; cv=none; b=FDADNMC3yba5h94SuVAhM8CkCw1IE2ByGwTPkuBzjNEUkW/S3CNjI7AFATcksCoUtzHhb/h+k3zVKAYs8Aaiwo1lJUEpBRyZoMOskAsbjbJQKLds7Ba4RE+K0f/lDLblLhEr2m3+pjRxz/H8Q3eP13n7hwyYPQFnLyxxAFoiHvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772945366; c=relaxed/simple;
	bh=8WnFsfPFD5fbvOYn9KlfgheFOUjRaRNY4DFf8Ml4u9I=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cv0i1sT4DHQ+W7DPywVS8j+bxQW7dBb/C+USFvlaeV3J/CK2BrLX5xQRJSfW23Px1U0/ncyLb7DC6wEaPNizbd7yGaCRs9yFHCblKFbnBHYJQQX0tMMq0RhHmoZ842F6ua0o4ct61V9TNXkkcqboq+k3bTGJuQKluniKImBm2aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=JmtxhbXP; arc=none smtp.client-ip=85.9.206.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="JmtxhbXP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1772945349; x=1773204549;
	bh=xJYM5Xqc2HUuSnrE+9bwPQ3CpzITCkMo2ABcsTbZWUk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=JmtxhbXPS52RV+XAH9iWxcs/ctAF9UFVhNFmkDTfGki7nWZ8eHOzL/m+PHrIQp+A9
	 lYdYxYB6V6LvtkC/ZY818qOhr739MKis4MlNrsSFa2v0JClRbkAe+2ysDprIZtZsYK
	 FoPYftaqGvdzbEwVtbqsmcv7ffBdkGbfUGlPCSXxByJYTANfERILkG+LK2ey1uJIXe
	 v0q+FxXS3bf5oq29xfERONqrJh6jJCT8hDlHRncYODXK4RHHadsIgVyTRJ7f25iICi
	 8XU8d5YSna9DPIs/P/Ykd7xxIxmKXeyO4yGbttoSfM58u0KbuiXvEK3s4zsgxLjBom
	 j6lVZppI1JE2A==
Date: Sun, 08 Mar 2026 04:49:05 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>
From: Alexander Koskovich <AKoskovich@pm.me>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Koskovich <akoskovich@pm.me>
Subject: [PATCH 2/2] arm64: dts: qcom: sm8250: Add inline crypto engine
Message-ID: <20260307-sm8250-ice-v1-2-a0c987371c62@pm.me>
In-Reply-To: <20260307-sm8250-ice-v1-0-a0c987371c62@pm.me>
References: <20260307-sm8250-ice-v1-0-a0c987371c62@pm.me>
Feedback-ID: 37836894:user:proton
X-Pm-Message-ID: f81b93a106e3390ea71d675c1bb1909f246291f5
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
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qco=
m/sm8250.dtsi
index c7dffa440074..4e8a960acc5e 100644
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
@@ -2592,6 +2594,13 @@ ufs_mem_phy: phy@1d87000 {
 =09=09=09status =3D "disabled";
 =09=09};
=20
+=09=09ice: crypto@1d90000 {
+=09=09=09compatible =3D "qcom,sm8250-inline-crypto-engine",
+=09=09=09=09     "qcom,inline-crypto-engine";
+=09=09=09reg =3D <0 0x01d90000 0 0x8000>;
+=09=09=09clocks =3D <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+=09=09};
+
 =09=09cryptobam: dma-controller@1dc4000 {
 =09=09=09compatible =3D "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 =09=09=09reg =3D <0 0x01dc4000 0 0x24000>;

--=20
2.53.0


