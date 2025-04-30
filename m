Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D2225A2AF;
	Wed, 30 Apr 2025 16:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746029876; cv=pass; b=A289xX1m4Q6S2xdt5u6mEj5oIUnJQ77+CkqNhvXZLc92hLw7fEe6i9Tr6joWklHjDULKF18pngQzW7RyVJSBfb5qlQy4kElBZkMeuw4pHx4H1x2ZRJ4MYHdFKzYonogkZ9dMFR+rBUifMC32WUxQerDEa3CzmHirDDRF9RzjgQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746029876; c=relaxed/simple;
	bh=3AgojCgwnHiJ/4UeMtAu1VEULwqiJr6pr7+DLktb6oM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sY/BlzWs3IkcSsH2vTBpFs6yY76gmZLdFJhqdnlDlwEQj8hpUg4Oscx7sebRJxjK6QHZqYA10rDDrXag2weeEGD6PwTI/V5X5YCgH1+V73Z4dZ/iys9l69ITWIJVvsGQ29JPJvgYD6Vfhao7yLsHtfxJqK2n4sYztffHzRd/Xko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=Z9TRme2w; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="Z9TRme2w"
ARC-Seal: i=1; a=rsa-sha256; t=1746029822; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=f+93AWjXW5VDIYoO0E8YkXtcP4BNlDbolM9nmkTGiVwL68mOHaRgl7DboLKuv8bcPK2Jcd0AhTUZdwV4/AlzQU0nIsNqhKQkkyzVd1mY+jqabGVhjRmAVPJjxdjoUMi6+b5Xl42lVoayoktTy6+RSqtvNevw5YTaBaynbP9Quh0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1746029822; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=PqaMC8w6qtB1n0xipg6hxZmuKd9Q6kyn2/VlH0Aqgtg=; 
	b=f4aEIU8IMcZFVD8SF9NY5xKGsw4lA1Q7usyi756Q5oMolxZS3oLCIEXM9e30A1AK3WlJu5Hm0fGEK+XXy9BIDVG4OuismmG50gxuQXC079FRnYC0IAfrrCaMYlEi6XxSVeFT8u5U95wHFGYy9oWu2xN7PvrGgpkd0R7z11oqU3c=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1746029822;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=PqaMC8w6qtB1n0xipg6hxZmuKd9Q6kyn2/VlH0Aqgtg=;
	b=Z9TRme2wLZNYuuNwMyq+DF6xQHWyn8Ly6bn2n+YAwblU1fFtJasEEs8LqT2GeuOb
	ST6jMaIKHJj2rzuzlNfMDRZE0xSG1xGpPEXvaXoGeBj27ksCPZ7k2GXLQ7f32UWjQ4Q
	kZKtbcPHXyURRbSLwCAsr24jyM3Vx5FPpiopDfXs=
Received: by mx.zohomail.com with SMTPS id 1746029821190216.44843874019614;
	Wed, 30 Apr 2025 09:17:01 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Wed, 30 Apr 2025 18:16:36 +0200
Subject: [PATCH 3/3] arm64: dts: rockchip: add RK3576 RNG node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250430-rk3576-hwrng-v1-3-480c15b5843e@collabora.com>
References: <20250430-rk3576-hwrng-v1-0-480c15b5843e@collabora.com>
In-Reply-To: <20250430-rk3576-hwrng-v1-0-480c15b5843e@collabora.com>
To: Daniel Golle <daniel@makrotopia.org>, 
 Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Jonas Karlman <jonas@kwiboo.se>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 kernel@collabora.com, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.2

The RK3576 has a hardware random number generator IP built into the SoC.

Add it to the SoC's .dtsi, now that there's a binding and driver for it.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 arch/arm64/boot/dts/rockchip/rk3576.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576.dtsi b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
index a6bfef82d50bc9b0203a04324d61e0f232b61a65..ce8bcab215c0e6b7786ab3baae6977072497ed2f 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
@@ -1527,6 +1527,14 @@ sfc0: spi@2a340000 {
 			status = "disabled";
 		};
 
+		rng: rng@2a410000 {
+			compatible = "rockchip,rk3576-rng";
+			reg = <0x0 0x2a410000 0x0 0x200>;
+			clocks = <&cru HCLK_TRNG_NS>;
+			interrupts = <GIC_SPI 181 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&cru SRST_H_TRNG_NS>;
+		};
+
 		otp: otp@2a580000 {
 			compatible = "rockchip,rk3576-otp";
 			reg = <0x0 0x2a580000 0x0 0x400>;

-- 
2.49.0

