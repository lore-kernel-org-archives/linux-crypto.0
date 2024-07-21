Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6AC10F7;
	Sun, 21 Jul 2024 00:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721522934; cv=none; b=qwnHhcIJPbCjl15bugunou7MRPpTil4IYeJQ1UvNa75pZfcnYZNL+GFNvFbIHrBu3atHEx6/DGRk0dLCAmhHLlHLuFhZJdMGmYqQL5g+f7bam/JhZP69LfT42BhW1GiD4OD+eAmNb/8+fnZSewfUZ9+rgR54YluUsiIRTUyD30w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721522934; c=relaxed/simple;
	bh=4Mvo0ROjF19vDgQPp9qejaMXrXTJrFTpTwZbQ76CxWI=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FDcSgVDv1yy94SN7Bz4BRc6KYKTBZ13dNrB9nC/1/5/f79njhpj1x0/UrBVZ2Zpxn3N/C386vM8cRmF2QlGVtmtNrZX3n8WOGitkHemBDheudJ4Gn5zFTugg4WN5NEtxgL5sif3Omu6tiY9PTSULIKz3O8JXn3ZBWLKjtMXCKqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.98)
	(envelope-from <daniel@makrotopia.org>)
	id 1sVKkk-000000007Qn-1Ouy;
	Sun, 21 Jul 2024 00:48:42 +0000
Date: Sun, 21 Jul 2024 01:48:38 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Martin Kaiser <martin@kaiser.cx>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 3/3] arm64: dts: rockchip: add DT entry for RNG to RK356x
Message-ID: <c28cb9ad04062b6da66d9cac8adefa0edc0046ea.1721522430.git.daniel@makrotopia.org>
References: <cover.1721522430.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1721522430.git.daniel@makrotopia.org>

From: Aurelien Jarno <aurelien@aurel32.net>

Enable the just added Rockchip RNG driver for RK356x SoCs.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 arch/arm64/boot/dts/rockchip/rk3568.dtsi |  7 +++++++
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 10 ++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
index f1be76a54ceb..b9c6b2dc87fa 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -257,6 +257,13 @@ power-domain@RK3568_PD_PIPE {
 	};
 };
 
+&rng {
+	rockchip,sample-count = <1000>;
+	quality = <900>;
+
+	status = "okay";
+};
+
 &usb_host0_xhci {
 	phys = <&usb2phy0_otg>, <&combphy0 PHY_TYPE_USB3>;
 	phy-names = "usb2-phy", "usb3-phy";
diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 4690be841a1c..d160a23fd495 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -1113,6 +1113,16 @@ sdhci: mmc@fe310000 {
 		status = "disabled";
 	};
 
+	rng: rng@fe388000 {
+		compatible = "rockchip,rk3568-rng";
+		reg = <0x0 0xfe388000 0x0 0x4000>;
+		clocks = <&cru CLK_TRNG_NS>, <&cru HCLK_TRNG_NS>;
+		clock-names = "core", "ahb";
+		resets = <&cru SRST_TRNG_NS>;
+		reset-names = "reset";
+		status = "disabled";
+	};
+
 	i2s0_8ch: i2s@fe400000 {
 		compatible = "rockchip,rk3568-i2s-tdm";
 		reg = <0x0 0xfe400000 0x0 0x1000>;
-- 
2.45.2
