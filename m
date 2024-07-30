Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3211A6193;
	Tue, 30 Jul 2024 16:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355919; cv=none; b=oVBsimJsjBKqBOaQKa1lnyGBulwGlTSx95B8a3iSFSEbj5n+anGwESH/UYRd+I/DrvN/U42XTPvcOhhPwYuGzT1pHe53JtQe7z5WBUvLLxTNXYsqjA5ijRpKVQXEriLr6AGhYwt6Q2g7NpqlY06T2PGqki40dP4210oRgKzBUG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355919; c=relaxed/simple;
	bh=ZTRcB21gnrJRzjR9fYwahHH5hEJkFRw0l4npIRKjIqE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mdeQNIB60OpK1lGhESIo+C81if/pQSb7AfiA5L/XxFB9jd9OGkpI/fBSVfuZF2LnPkx6JUVcz3EwbEoZ4UAfwW+E74/arbinPq+KZgjLfOrnkEZg0ujTEtfywXzxwyiYV4D8R1m9Gn1jpYXtVZRBmCoLOrUQ2A5MZ8ExackVIP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.98)
	(envelope-from <daniel@makrotopia.org>)
	id 1sYpRz-000000002Mu-3HTJ;
	Tue, 30 Jul 2024 16:11:47 +0000
Date: Tue, 30 Jul 2024 17:11:44 +0100
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
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 3/3] arm64: dts: rockchip: add DT entry for RNG to RK356x
Message-ID: <d2beb15377dc8b580ca5557b1a4a6f50b74055aa.1722355365.git.daniel@makrotopia.org>
References: <cover.1722355365.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1722355365.git.daniel@makrotopia.org>

From: Aurelien Jarno <aurelien@aurel32.net>

Include the just added Rockchip RNG driver for RK356x SoCs and
enable it on RK3568.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 arch/arm64/boot/dts/rockchip/rk3568.dtsi |  4 ++++
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
index f1be76a54ceb0..2a6ca20e607fd 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -257,6 +257,10 @@ power-domain@RK3568_PD_PIPE {
 	};
 };
 
+&rng {
+	status = "okay";
+};
+
 &usb_host0_xhci {
 	phys = <&usb2phy0_otg>, <&combphy0 PHY_TYPE_USB3>;
 	phy-names = "usb2-phy", "usb3-phy";
diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 4690be841a1cd..d160a23fd4959 100644
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
