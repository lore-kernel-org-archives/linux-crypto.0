Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DB72BDC03;
	Wed, 11 Jun 2025 19:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749671331; cv=none; b=oTl7VEBH4Bn3JlsbM3h7cIVrNyoEU1LCB94bAC23oEAvPbALjwI2eeXJev4JgR9yiNVSM3ahu9FYWLLnW4OB34wbopIEQ1vRB7Ete+upRSn+vezckVD4ielF8V9+VkoNDn+s30GcuLIds6498LDHd+KOD8nqVJZF9q6CXCyQJlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749671331; c=relaxed/simple;
	bh=kdYI7la2MXOPJsmLxcbhbf8rxm86McFG70dJ9GfeAHw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yzsf5lzPQ7LXGF6QYz1LP0ajqHHcrZfcdQR3UzAbL8r938NYG4r72cvdllS9t4SkRKm9t3HOeeUZn045QijGra9k1D5g4zdQd1dYmgkCSLLQMDnqc11i10ZoxNEucKkLAhiCqw5mHKp8ExXDGWVBGtcpJsU0ikkB3UmKrv+SX5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=RvBXxgYQ; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="RvBXxgYQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1749671329; x=1781207329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kdYI7la2MXOPJsmLxcbhbf8rxm86McFG70dJ9GfeAHw=;
  b=RvBXxgYQehVr+HKjv6iNXzPQjCiXRcAh/oDKKDaC+AQmbHvKyGyIp4NO
   El9tg942eV+JBSaZqiDbsAJqk9Zr1yMGInrKDCtn0G5vFMLAe6m90OfM1
   nx36UQJvgtuJPxJRaO+JMe6sJSzqOs3Xeh6caAW2gG3Hii6WpbePTG2dh
   3bLWk63YPt3rGcG1ppyHztNBKJ9Qw3NIthektKwIjrkNsxauncrNdln4z
   JJD5yMPH3qUaIuRVrGOEf5p82gGamJHRPY/MhqUj/fk76TwUj+44nSirG
   /9jWAgm/d7wrmAfv/kKTjAhp1qGdsv3TGQ2/2qqGaFwwvP0NdjOm0/eD3
   g==;
X-CSE-ConnectionGUID: Mlj04rVUS3aXDCaAEgxBzw==
X-CSE-MsgGUID: Sadl/DRsQzCUCCfuaf4XMQ==
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="210175093"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jun 2025 12:48:48 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 11 Jun 2025 12:48:17 -0700
Received: from ryan-Precision-3630-Tower.microchip.com (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.44 via Frontend Transport; Wed, 11 Jun 2025 12:48:17 -0700
From: <Ryan.Wanner@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh@kernel.org>,
	<krzk+dt@kernel.org>, <conor+dt@kernel.org>, <nicolas.ferre@microchip.com>,
	<alexandre.belloni@bootlin.com>, <claudiu.beznea@tuxon.dev>,
	<olivia@selenic.com>
CC: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Ryan
 Wanner" <Ryan.Wanner@microchip.com>
Subject: [PATCH v2 06/10] ARM: dts: microchip: sama7d65: Add crypto support
Date: Wed, 11 Jun 2025 12:47:30 -0700
Message-ID: <fc791949c97f368f32a710e64d8db4018e45e70f.1749666053.git.Ryan.Wanner@microchip.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1749666053.git.Ryan.Wanner@microchip.com>
References: <cover.1749666053.git.Ryan.Wanner@microchip.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ryan Wanner <Ryan.Wanner@microchip.com>

Add and enable SHA, AES, TDES, and TRNG for SAMA7D65 SoC.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
---
 arch/arm/boot/dts/microchip/sama7d65.dtsi | 39 +++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm/boot/dts/microchip/sama7d65.dtsi b/arch/arm/boot/dts/microchip/sama7d65.dtsi
index d08d773b1cc5..90cbea576d91 100644
--- a/arch/arm/boot/dts/microchip/sama7d65.dtsi
+++ b/arch/arm/boot/dts/microchip/sama7d65.dtsi
@@ -186,6 +186,45 @@ sdmmc1: mmc@e1208000 {
 			status = "disabled";
 		};
 
+		aes: crypto@e1600000 {
+			compatible = "microchip,sama7d65-aes", "atmel,at91sam9g46-aes";
+			reg = <0xe1600000 0x100>;
+			interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 26>;
+			clock-names = "aes_clk";
+			dmas = <&dma0 AT91_XDMAC_DT_PERID(1)>,
+			       <&dma0 AT91_XDMAC_DT_PERID(2)>;
+			dma-names = "tx", "rx";
+		};
+
+		sha: crypto@e1604000 {
+			compatible = "microchip,sama7d65-sha", "atmel,at91sam9g46-sha";
+			reg = <0xe1604000 0x100>;
+			interrupts = <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 78>;
+			clock-names = "sha_clk";
+			dmas = <&dma0 AT91_XDMAC_DT_PERID(48)>;
+			dma-names = "tx";
+		};
+
+		tdes: crypto@e1608000 {
+			compatible = "microchip,sama7d65-tdes", "atmel,at91sam9g46-tdes";
+			reg = <0xe1608000 0x100>;
+			interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 91>;
+			clock-names = "tdes_clk";
+			dmas = <&dma0 AT91_XDMAC_DT_PERID(54)>,
+			       <&dma0 AT91_XDMAC_DT_PERID(53)>;
+			dma-names = "tx", "rx";
+		};
+
+		trng: rng@e160c000 {
+			compatible = "microchip,sama7d65-trng", "microchip,sam9x60-trng";
+			reg = <0xe160c000 0x100>;
+			interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 92>;
+		};
+
 		dma0: dma-controller@e1610000 {
 			compatible = "microchip,sama7d65-dma", "microchip,sama7g5-dma";
 			reg = <0xe1610000 0x1000>;
-- 
2.43.0

