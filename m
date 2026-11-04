Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793779281;
	b=ouMUWuXfDTHaPRwCio1HuobaNzuygbRG8BH0HIPSO1fGPTo88RzL417YqT4iPnd5CfFI
	 dRVkTXBrXugK9yicHeEPUIFrHkfuD7YKRyyECwogtxzj0mRjIr/Vq0/mIeL3FY89WaJqL
	 09eK529cgV/eUNvjgRKbdWqKbET1+BEdi9mgpc9OabAFT5nriXABK+fllw8Cfmnuo2rFa
	 WPkquMPP5fMZkb/cqWn7Ctbx7xwnW2UkC0IJl+2Fl052Avuum/NiTWl9nDC0c+7mzVYIq
	 wOV48l0LP8wF9NEgQe7ukF1dwsWp5ZHcBM7C9FBglLn5Aeqj40w+hDheXmsukQdIiHw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793779281;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+fWCJpxvs/WHtsgs/r3petCvfOvEf8z0Ly2akQxeGoU=;
	b=pKPl/qJGjayGt/52LcBJ5p/q048h41mbmgDmLNibi9Z5VIqZXneM5DoiN+dUveW5C/DP
	 4rx9TNvpDfdPekA3udW15Z1w6DCudPdLcA06ywIvZx0ShmxyH/vkGS6NIgO93TKZuho7C
	 DDAdPvV8i4luOKSYYajkoS3m66pt4CEnw0tIe4mBuvvjM2VoowRFai845G/HktPzs4jOl
	 ENDU8H1EjcHPrd0D7SCR4uB7SkFZC/yZPvS8hYfspognlinBSgINMyMgy1u85ULwuzH+r
	 E2RJ2o6Tj6u1oMKGQJlMjVAEgxDQBsrT+UKb7wzZhNPz53V0NlbEeKIgDChw+V+Xzlg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cehvPCnB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B39606A31B;
	Wed,  4 Nov 2026 08:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cehvPCnB
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793779280;
	b=KDth9qpz1MPseDqhU1Zvc/f8m7i8+K+D1giEj7RSeThEbDSvl81oNzXQ8a0FKBC2xzuo
	 2VrFZNrx6xT1faJf9uolO6PSOiUpd+9BD8btYH95q5B9ovrzUwgba5omTkEKMbmr53/6z
	 2n0IL3K4WZGc5JxxMHQ1MSb/aN3J61w9lFbajOgCdpKmmGsWdytRP8ALKn1K2531865+5
	 t8XJaSQntBUgWpQK3RWLulnoh7ltX4UsdMbV1bjDJ0GkKACHLqoKi7vq9KQ1jLtWyECMd
	 JlXwPcTmDMA3Qigw1Nq2kxfrrdIyVblIciiOIHIW2gR8m7BvDHoGQV7o02T8OfT5TEQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793779280;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+fWCJpxvs/WHtsgs/r3petCvfOvEf8z0Ly2akQxeGoU=;
	b=jb2wOvVgIimyhnbACq9RYR5wy30SwAambvglgxNT9t2sOdEszD6OzgGlpjmezpNvuqvd
	 /PkG+VYM3zM9TXq3syac6cxGrkUjs4A3uChfJvzsbD3toFD+EXZSBO6YO529HyXz1gnMs
	 KO8c7RBpIvbpEE6vTJYS1/9A+ybRJUJAmPcr8A3RqqjxSChmk/sBvqVDXI2qdIWobx05R
	 Xa+9lBsmy0ZbCE+e3+RlE6upSmMkrRG7DWgLhiuwxJI7A4xsD7Ely1UmFXDVVmYhUK4Re
	 hfKSAN2z2UWaaQTw9IKf8y03rULR/fjaZxWoQrW/xA8XDcg3TubaYNEty3ZyAWvDzSw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BEA7B1F000C1;
	Wed,  4 Nov 2026 08:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793779280;
	bh=+fWCJpxvs/WHtsgs/r3petCvfOvEf8z0Ly2akQxeGoU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=cehvPCnBS+31tzZTIOJCj/VBTWG+hfTBmQ9wLUitaXLi6FmzBh/gtoMNB4ocSc3pN
	 1zMP+JTWX6k8Vfx/A/HPOPCeOCb+JmmJD90c9V5YhSRDeYQ6NFelNdH1i+gtp4rKpK
	 H6D89+Yko5t5PW3Tt2RowL2U8Gs4CMlNB9UqGrTwte+cEdvrMvkUOjkIaI+l+XH0Iy
	 Rc6YxHJtjmPqlHpJJ1abtw1b4B8BibbPWi6ds+dv5BXlw+sX2X19gLZ8Rj0uzlYoCd
	 fZF26vSqMQVEq38oVyzhc8Mmv0mc3n85aN803f829p8m6skktIfel0l5N194wBIw9K
	 IGafwhERLGy0A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3E5E346D49;
	Wed,  4 Nov 2026 08:01:19 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Date: Wed, 04 Nov 2026 08:00:37 +0000
Subject: [PATCH 2/2] arm64: dts: qcom: sm8150: Use standalone ICE node for
 UFS
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261104-sm8150-ice-rfc-v1-2-5737b6c2ecc0@andrewgigena.dev>
References: <20261104-sm8150-ice-rfc-v1-0-5737b6c2ecc0@andrewgigena.dev>
In-Reply-To: <20261104-sm8150-ice-rfc-v1-0-5737b6c2ecc0@andrewgigena.dev>
To: Abel Vesa <abelvesa@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Andrew Gigena <mail@andrewgigena.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793779278; l=2613;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=WlKNWLgTKrbe/21NLFWi4EX5Ly7RQNJI7RvyIEWjaMI=;
 b=AL9276BBDMvbLP7AtBvt6MPGEFqZZqMRVI+tXlXqM6O0sGsHEVGXzrMcUTHdkHBDiqBL0orJz
 IrN6FeBMfSuCJw3C68KyulK8lY4y98fiQgeCum7tjiuUVl10o+stAGu
X-Developer-Key: i=mail@andrewgigena.dev; a=ed25519;
 pk=OMhlYIBaOEC8g4mJ4JCKy7kbg+lrwRxuujieZF8Ne6U=
X-Endpoint-Received: by B4 Relay for mail@andrewgigena.dev/20261104 with
 auth_id=1402
X-Original-From: Andrew Gigena <mail@andrewgigena.dev>
Reply-To: mail@andrewgigena.dev
Content-Transfer-Encoding: 7bit

From: Andrew Gigena <mail@andrewgigena.dev>

Convert SM8150 UFS to use a standalone ICE node.

Move the ICE register region and clock from the UFS controller node
into a dedicated ICE node. Reference the new node from the UFS
controller using the qcom,ice property.

This brings the SM8150 device tree in line with the standalone ICE
representation used on newer Qualcomm platforms.

Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
Tested-by: Andrew Gigena <mail@andrewgigena.dev>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 293fcbacff34..b3d6f3d92395 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -2071,9 +2071,7 @@ pcie1_phy: phy@1c0e000 {
 		ufs_mem_hc: ufshc@1d84000 {
 			compatible = "qcom,sm8150-ufshc", "qcom,ufshc",
 				     "jedec,ufs-2.0";
-			reg = <0 0x01d84000 0 0x2500>,
-			      <0 0x01d90000 0 0x8000>;
-			reg-names = "std", "ice";
+			reg = <0 0x01d84000 0 0x2500>;
 			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&ufs_mem_phy>;
 			phy-names = "ufsphy";
@@ -2092,8 +2090,7 @@ ufs_mem_hc: ufshc@1d84000 {
 				"ref_clk",
 				"tx_lane0_sync_clk",
 				"rx_lane0_sync_clk",
-				"rx_lane1_sync_clk",
-				"ice_core_clk";
+				"rx_lane1_sync_clk";
 			clocks =
 				<&gcc GCC_UFS_PHY_AXI_CLK>,
 				<&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
@@ -2102,8 +2099,7 @@ ufs_mem_hc: ufshc@1d84000 {
 				<&rpmhcc RPMH_CXO_CLK>,
 				<&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
-				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>,
-				<&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
 			freq-table-hz =
 				<37500000 300000000>,
 				<0 0>,
@@ -2112,8 +2108,8 @@ ufs_mem_hc: ufshc@1d84000 {
 				<0 0>,
 				<0 0>,
 				<0 0>,
-				<0 0>,
-				<0 300000000>;
+				<0 0>;
+			qcom,ice = <&ice>;
 
 			status = "disabled";
 		};
@@ -2139,6 +2135,17 @@ ufs_mem_phy: phy@1d87000 {
 			status = "disabled";
 		};
 
+		ice: crypto@1d90000 {
+			compatible = "qcom,sm8150-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0 0x01d90000 0 0x8000>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
+		};
+
 		cryptobam: dma-controller@1dc4000 {
 			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			reg = <0 0x01dc4000 0 0x24000>;

-- 
2.56.0


