Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44106746E;
	Sat, 13 Jul 2024 00:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720831098; cv=none; b=hF7/jufUw/asMXCx39R016sPbXnFPey8wnRf4hJgRrHTD1FkcJ1xNpuzKPxvM0F8FgdxtLrRvwryiSafZusF1UqsReZFpXw5h+aYW1gu64EyUf6A5kK1Pr6+5gE1VcNOGn9cfVhjBPwXRWn70LZWkQo/SM+ETO1MVbZoPvy3LK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720831098; c=relaxed/simple;
	bh=4Gq5F+4TLOJHu4iY0ouW3Ff3R7izkcH1X9nC9PlgJEI=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KgW3mS8zTdgCfk5hR+9VFxP/4KAO9T909jM1gzK4v7Ys5E2YAXDrqMF4LD9GGLQRt2Zaxvw5e1muhAMhXkEcx+7Zwd0/ZPbM+LU/z90z4q/kGuCwdmVbY+an54M67Q+5IQkLYrCkUYJ6PHMc2k2W5Rg9t/Bj761t5toXQMRpEr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.97.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1sSQm5-000000005cq-1S8i;
	Sat, 13 Jul 2024 00:38:05 +0000
Date: Sat, 13 Jul 2024 01:38:01 +0100
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
	Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 3/3] arm64: dts: rockchip: add DT entry for RNG to RK356x
Message-ID: <26d651a891b8740fd3719f465b72dc7b8cb299dc.1720830725.git.daniel@makrotopia.org>
References: <cover.1720830725.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1720830725.git.daniel@makrotopia.org>

From: Aurelien Jarno <aurelien@aurel32.net>

Enable the just added Rockchip RNG driver for RK356x SoCs.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 4690be841a1c..78377e7d1d6d 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -1113,6 +1113,15 @@ sdhci: mmc@fe310000 {
 		status = "disabled";
 	};
 
+	rng: rng@fe388000 {
+		compatible = "rockchip,rk3568-rng";
+		reg = <0x0 0xfe388000 0x0 0x4000>;
+		clocks = <&cru CLK_TRNG_NS>, <&cru HCLK_TRNG_NS>;
+		clock-names = "core", "ahb";
+		resets = <&cru SRST_TRNG_NS>;
+		reset-names = "reset";
+	};
+
 	i2s0_8ch: i2s@fe400000 {
 		compatible = "rockchip,rk3568-i2s-tdm";
 		reg = <0x0 0xfe400000 0x0 0x1000>;
-- 
2.45.2
