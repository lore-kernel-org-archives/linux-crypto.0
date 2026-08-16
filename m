Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6AD3CB574
	for <linux-crypto@vger.kernel.org>; Sun, 16 Aug 2026 19:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786909335; cv=none; b=s3LwKQJDHPYzwDdCkV7XfsuSRXwCBubuhFYhNCj9D/2GyBTVkenDvtYObMCyMIOBKW+OZ4GtA//8mZtYRi95liKcijNc1pX+G68Y/KTaw3VoiF4hkQzhfrMqwH2mgg2VgwTfXIVsa/v/EARQ9RPkM19SC6jtkdlWEz6dyiqUGFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786909335; c=relaxed/simple;
	bh=wVdUk0o7gnQOIfexBtZKXRGOa/Fc/zJYyyAIenHMGBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXKSqNTalx/xyEsD4tQ9WFOGOUzZ3DKyi1b5GDLi+WVWQguf1+7LSiGKwtE5dfspgsqVsHOe032d6vepbjcmpxaCvVaTir/06TIewyQ/nHRsKxR8hw+0XcP+T0zlkZRutvLqdsZBgheZ3fZNZTURmblL2+optVLniKZIw0m3VXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GnoCnHZU; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GnoCnHZU"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-495590dde14so33790855e9.0
        for <linux-crypto@vger.kernel.org>; Sun, 16 Aug 2026 12:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786909331; x=1787514131; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=saCtLctEFieimkjt5839av7kQUg1qO8hSvOYlxjvmVA=;
        b=GnoCnHZUwF97OkcGVovPFsK0YzptRRwKd7K+Fiugz2EdW9rXcyjEtyTbbBSUCmfwz1
         XT9qWaT9jV/S2PD1zaS0VQtijkJ3x7LVVvORwnJxut2vAQM6BQ1EqyVVOrkSKT44Ot/A
         Of/uziNSGUAahZtDSjAU/CR2tdglDLR4jkp4IwbBDP6+zkS+RghNXLeBQFuZQtlgj6gE
         iakuRhyuq//GDKwcZf6usXKffxLWaBje+HwScs0k+A8LyoTg0KAtAm84tS1wSv+M3Pta
         HIQD+KWODJ3A6nvRwODSO55tIaNK35bwXCFo+aW43ZwwiMb78+xUdlf6dcOmHSyoCHdN
         OLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786909331; x=1787514131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=saCtLctEFieimkjt5839av7kQUg1qO8hSvOYlxjvmVA=;
        b=lou3EaJrY0FZsNroe48X3YDL1rS5WLJqxnJT+gNoJyzI4uTqDcnDJEuYbb9iOBnz6d
         4dPORmAXq6QwkcJzETYqxYetlimxS84NGXx+a+Wl18yY4oVxAD8+rk1F0RHD5dg0KdG8
         UghPnOfD0DFIws7PX0lE6D9MCPYd059OErdIwCkpDJNBz2hLbSW7cUoxe5LioYeTkhd5
         5xroJwpjJMn3OurvMa+ebh5E9WatyqFe8QMSO4L1P2+FgMLWWG3M8oS0vHz7TwxcXmrs
         TJzAs0o3pYrDm9tmsFQ6o6BuSsaW2unSkg0tB+KulItPDZ2EmMBkuTYmvK8oBMOeIJKW
         3ysw==
X-Forwarded-Encrypted: i=1; AHgh+RrXtuiTg1BshDA1DFJgDkGreTy9aW0e/ivcclv8ym/DJ06BJ1Oi+E0KCxXiD3TzEG1yjobChMMLsRgxcEg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZFBg4GImLYLujSM30KS6UBLXMhieM7LpESfbh7hnVvg+fBymN
	sLRpR78pZHF/oV3R/Khro8R9FRZAg+mjYKVU+5B7sYGU/2jOq5HvjHfA
X-Gm-Gg: AR+sD11FdV5L6oeVZlcp8ui3OR+nasQeMpfnu2xwy4dEBhjBQhx7FYlaqhwio/u3/b/
	m2IyUIQkn/Pm2I4IKQo98IcuV8amLaDJh+7MRYV5zK51WaY27ufoczGSYTsThHhQlNviU9cGx0s
	X1+6g5tIzZDzS/EXJFD/uTM9wC0Lus/3lK3pg7AzF1LviE/xawI3Pt0nWgk5l7D9Z5LH0LNYBOz
	6x+yhepl9EqE0h4+kzzwrQGsp2fgDkkl4M7sEeKHdSj8IMlkwO8i2n8iXx1aR0EcXjs/BhVzzBK
	N0NqlBcWsICJh8PKrdIC3jOE3+VS896o081OaeqkJRXkBLiAIgy9BpC02j/xT0cpNeyDO9gBwYu
	c4P3lvQJSffl1Wac4NKzltY6k8XC2cZx5fAriszowazTLltlbpWnqYUOMOkMTKQY21pi8wsKPt1
	J30YFiPsp/4HSlGrh24ERvByPjyKtBkdiQMp/p4N9NHtws409qOnecBg==
X-Received: by 2002:a05:600c:4754:b0:499:7e2b:8e5 with SMTP id 5b1f17b1804b1-4999a2f9ec3mr21366645e9.5.1786909331392;
        Sun, 16 Aug 2026 12:42:11 -0700 (PDT)
Received: from olympus.. ([2a0a:ef40:f1b:d401:2e0:4cff:fe68:285])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996106c6esm100527875e9.5.2026.08.16.12.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 12:42:10 -0700 (PDT)
From: Dawid Olesinski <dawidro@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>
Cc: Diederik de Haas <diederik@cknow-tech.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Conor Dooley <conor+dt@kernel.org>,
	Corentin Labbe <clabbe@baylibre.com>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Dawid Olesinski <dawidro@gmail.com>
Subject: [PATCH v3 4/4] arm64: dts: rockchip: Add crypto node to rk3588-base
Date: Sun, 16 Aug 2026 20:39:47 +0100
Message-ID: <20260816194112.552100-5-dawidro@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260816194112.552100-1-dawidro@gmail.com>
References: <20260708175837.1718437-1-dawidro@gmail.com>
 <20260816194112.552100-1-dawidro@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the device tree node for the V2 cryptographic hardware accelerator
on RK3588.

On RK3588 the crypto IP sits inside the secure domain controlled by
SECURECRU, a register bank that is exclusively accessible to the
TrustZone firmware (TF-A). Linux must therefore obtain its clocks and
reset line through the ARM SCMI interface provided by the firmware
rather than mapping the CRU registers directly. Attempting direct MMIO
access to SECURECRU from the non-secure world triggers an asynchronous
bus fault.

The interrupt uses the four-cell GICv3 format as required by the RK3588
GIC node definition (the fourth cell is the CPU affinity/partition
specifier; 0 means no affinity constraint).

The node is disabled by default; board files that wish to use hardware
crypto offload must enable it.

Co-developed-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Dawid Olesinski <dawidro@gmail.com>
Tested-by: Diederik de Haas <diederik@cknow-tech.com>  # Quartz64-B,
NanoPi R5S, NanoPC-T6 LTS
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
index 4fb8888c281c..980c345a5de0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -2249,6 +2249,17 @@ sdhci: mmc@fe2e0000 {
 		status = "disabled";
 	};
 
+	crypto: crypto@fe370000 {
+		compatible = "rockchip,rk3588-crypto", "rockchip,rk3568-crypto";
+		reg = <0x0 0xfe370000 0x0 0x2000>;
+		interrupts = <GIC_SPI 209 IRQ_TYPE_LEVEL_HIGH 0>;
+		clocks = <&scmi_clk SCMI_CRYPTO_CORE>, <&scmi_clk SCMI_ACLK_SECURE_NS>,
+			 <&scmi_clk SCMI_HCLK_SECURE_NS>;
+		clock-names = "core", "aclk", "hclk";
+		resets = <&scmi_reset SCMI_SRST_CRYPTO_CORE>;
+		reset-names = "core";
+	};
+
 	rng@fe378000 {
 		compatible = "rockchip,rk3588-rng";
 		reg = <0x0 0xfe378000 0x0 0x200>;
-- 
2.47.3

