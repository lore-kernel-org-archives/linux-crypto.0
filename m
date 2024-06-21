Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4C959168;
	Fri, 21 Jun 2024 01:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718933146; cv=none; b=EXUjo2Ir/kk2iC/+w62OcaP9rE3VFGqUaYKv9ZoQqpPYgyhTWGsOvuGanUjzvAEIJ0RlwL8CH4dsTmO6hMqUJ8nZ7EwjCvFWEjcq2w81v2swzTNgeHkCSegKimwJ+dGY3Y6iDOxAGwDk3Uw+UHyLEf7PnFxBZL7Ce2fwh2mXPFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718933146; c=relaxed/simple;
	bh=ZFltDS7YSwafHR0wKjFiJQxNk4bq14Kvuvr2Xv3jiM8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJb339cgpzhK+jIzZWhiOR1dIRs3mbdwoIYiZOwlPkOZ3k95WpjXN0Q2mb5u4xIxuATeJo+bGfk99D7dhXHlr0eBzdUfw1XOZfAdbzNPycaSkS4OmZCqJbEXsjccVhrDYNPiDeeN2z46RV65SNS9RsdiA0erpMN05VXXqWP7lGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.97.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1sKT1x-000000004el-3zVQ;
	Fri, 21 Jun 2024 01:25:34 +0000
Date: Fri, 21 Jun 2024 02:25:30 +0100
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
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Anand Moon <linux.amoon@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] arm64: dts: rockchip: add DT entry for RNG to RK356x
Message-ID: <bd08c142ce6b32cd98014c875c7ccf3657c63f23.1718921174.git.daniel@makrotopia.org>
References: <cover.1718921174.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1718921174.git.daniel@makrotopia.org>

From: Aurelien Jarno <aurelien@aurel32.net>

Enable the just added Rockchip RNG driver for RK356x SoCs.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index d8543b5557ee..57c8103500ea 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -1855,6 +1855,15 @@ usb2phy1_otg: otg-port {
 		};
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
 	pinctrl: pinctrl {
 		compatible = "rockchip,rk3568-pinctrl";
 		rockchip,grf = <&grf>;
-- 
2.45.2
