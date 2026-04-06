Received: from mail-106121.protonmail.ch (mail-106121.protonmail.ch [79.135.106.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C692D6407
	for <linux-crypto@vger.kernel.org>; Mon,  6 Apr 2026 02:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775441431; cv=none; b=WOM09wqI4frVSCo7rqEcYyRgX9IxRuMWc0cE3oaCSWuN28A5yydmorpU9Tr5Y7Q3tMSYxAkHrzWwofhsMjykaoj8d7PJACALf0Pb46aRXIH3ZQC4rSIpjzvIaIGjKx+yUoUvlDh7lZNFGrQTLpKY9b5B4uzRm3vLQxXTnXwsj1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775441431; c=relaxed/simple;
	bh=vIdoUgfNlLEYVNJ5CNBnAjRXSJr/QWNIypqg1e47IhA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OQbtBqy/Imu1eALpj304RaRcoS62TknnS+dvx/j/Nnc+ceFod/T0g0dkvrU1i8gKGDDnJAV/nAbgK5M3d3w2o6nFfr+bLC5F5YehWz+24xsOO+4jCdKTUwmeGeg8qiaJCUEaS+YlHwu/9z6H55YRbslvDOtk8jqckKuLZsyI2K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=CJkBC7T3; arc=none smtp.client-ip=79.135.106.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="CJkBC7T3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1775441421; x=1775700621;
	bh=vIdoUgfNlLEYVNJ5CNBnAjRXSJr/QWNIypqg1e47IhA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=CJkBC7T39je16Wmct7uzMzVhCvWntAkMPGuEvdFSZR1H7iQwornFFa0isXyqI062/
	 FMqBU2Myig9bZZ70I9HvIpj1D/lTbNarelxz6zH+Tn6JPeX3QKi0uQC4NQ7HSyt1VO
	 B94HjguTHxmW1oRmqZAXY4E5jkK9Qw+wVAaMRFVANsR9ZDsWbcYfMiDZUENY2l9w/m
	 /InKal7XYvKOKd0V99VnMVGToYfWt3lS1Ddx94HGwN5ObXTNBGnyMn6c/A8wPm9ihE
	 ucKjJO6O1JSzStRPDdfXF6QyNdwxbsVg2Iofyt82OW3MhepoR666Rr4RVm0ENcQpCe
	 iMF4SfqBi61gg==
Date: Mon, 06 Apr 2026 02:10:15 +0000
To: Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>
From: Alexander Koskovich <akoskovich@pm.me>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Koskovich <akoskovich@pm.me>
Subject: [PATCH 2/2] arm64: dts: qcom: milos: Add QCrypto nodes
Message-ID: <20260405-milos-qce-v1-2-6996fb0b8a9c@pm.me>
In-Reply-To: <20260405-milos-qce-v1-0-6996fb0b8a9c@pm.me>
References: <20260405-milos-qce-v1-0-6996fb0b8a9c@pm.me>
Feedback-ID: 37836894:user:proton
X-Pm-Message-ID: 5a9262f7375b83d436fe2a99fba0e3dc0b8570a9
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Add the QCE and Crypto BAM DMA nodes.

Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
---
 arch/arm64/boot/dts/qcom/milos.dtsi | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom=
/milos.dtsi
index e1a51d43943f..61418657c4e9 100644
--- a/arch/arm64/boot/dts/qcom/milos.dtsi
+++ b/arch/arm64/boot/dts/qcom/milos.dtsi
@@ -1151,6 +1151,38 @@ aggre2_noc: interconnect@1700000 {
 =09=09=09qcom,bcm-voters =3D <&apps_bcm_voter>;
 =09=09};
=20
+=09=09cryptobam: dma-controller@1dc4000 {
+=09=09=09compatible =3D "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
+=09=09=09reg =3D <0x0 0x01dc4000 0x0 0x28000>;
+
+=09=09=09interrupts =3D <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH 0>;
+
+=09=09=09#dma-cells =3D <1>;
+
+=09=09=09iommus =3D <&apps_smmu 0x480 0>,
+=09=09=09=09 <&apps_smmu 0x481 0>;
+
+=09=09=09qcom,ee =3D <0>;
+=09=09=09qcom,num-ees =3D <4>;
+=09=09=09num-channels =3D <20>;
+=09=09=09qcom,controlled-remotely;
+=09=09};
+
+=09=09crypto: crypto@1dfa000 {
+=09=09=09compatible =3D "qcom,milos-qce", "qcom,sm8150-qce", "qcom,qce";
+=09=09=09reg =3D <0x0 0x01dfa000 0x0 0x6000>;
+
+=09=09=09interconnects =3D <&aggre2_noc MASTER_CRYPTO QCOM_ICC_TAG_ALWAYS
+=09=09=09=09=09 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;
+=09=09=09interconnect-names =3D "memory";
+
+=09=09=09dmas =3D <&cryptobam 4>, <&cryptobam 5>;
+=09=09=09dma-names =3D "rx", "tx";
+
+=09=09=09iommus =3D <&apps_smmu 0x480 0>,
+=09=09=09=09 <&apps_smmu 0x481 0>;
+=09=09};
+
 =09=09tcsr_mutex: hwlock@1f40000 {
 =09=09=09compatible =3D "qcom,tcsr-mutex";
 =09=09=09reg =3D <0x0 0x01f40000 0x0 0x20000>;

--=20
2.53.0


