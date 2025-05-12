Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11227299931;
	Mon, 12 May 2025 19:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747078191; cv=none; b=Alckt9e8dXr6bAeT2rnJbAvGhYdJMDNprK3wwZwSrss0czjGQiKDESko14/zZODSN66bhYiqV89rJeS4fKDECkh1SqF5RZdfYSuopQfd5s9mo/vk/dvm/ENGR1U76416Szm0it5bTEpQXnITuS12M1UdL/gJ7ncWGIM5QRwSsYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747078191; c=relaxed/simple;
	bh=YtwlXJOdp02r4WrFCnC4/Gfz2ncr79DHWxCt0DsELGg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y3mJd64x2xR8f5P/sUlRR4EYWf44/qziSmwHKuQYaHtosGV6qo1YGvMGZsVLzq88KF34XGDqJlo/WsVy5Mq/i6wBlIj68cjYpEY+QLkcly4Ey3WQABHghfqlEdD6Iupo2JrBxyvtcxbxX76h1p4rrcZjMIXSeaK69JtOnkFGC3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=KhOE6LBf; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="KhOE6LBf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1747078190; x=1778614190;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YtwlXJOdp02r4WrFCnC4/Gfz2ncr79DHWxCt0DsELGg=;
  b=KhOE6LBfFjrcMoygDsfiNpIMd5Bs88r0Co6fYTYHJd735hi4Dyv7Niaj
   8VgUX7CU/PzvUMnOhqdLLQwSlB0p6khnmi2gCGBSwmuMVXVf4hnTVRfiV
   UvkeanS0cutVYiJCaOnbYyus1aFZO42BwpoIj675rnFZLcykVhUG3X8hH
   vKnFWeGQWIL65Mxwg/NSX8xfWQ+hPKaREjmVVPUgdvPCGPVes3bwiQXAU
   ATmDVV0ZHgIVT8RNpgFgRWR5wBd4C7BmBcXJOxUY0VMDUx/N1dJiq3gyP
   VJuOi9mfpMdohJ4FeA/HJPVEupHs8npBVP/9DfwFOhIe7xAI9APQl44Hh
   Q==;
X-CSE-ConnectionGUID: hYKpzzHaRPOvLPNNOvU8gw==
X-CSE-MsgGUID: Jhtxy2cESSuOatJLEl5tcg==
X-IronPort-AV: E=Sophos;i="6.15,283,1739862000"; 
   d="scan'208";a="209006614"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 May 2025 12:29:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 12 May 2025 12:28:57 -0700
Received: from ryan-Precision-3630-Tower.microchip.com (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.44 via Frontend Transport; Mon, 12 May 2025 12:28:57 -0700
From: <Ryan.Wanner@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh@kernel.org>,
	<krzk+dt@kernel.org>, <conor+dt@kernel.org>, <nicolas.ferre@microchip.com>,
	<alexandre.belloni@bootlin.com>, <claudiu.beznea@tuxon.dev>,
	<olivia@selenic.com>
CC: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Ryan
 Wanner" <Ryan.Wanner@microchip.com>
Subject: [PATCH 8/9] ARM: dts: microchip: sama7d65: Add CAN bus support
Date: Mon, 12 May 2025 12:27:34 -0700
Message-ID: <445c4c72243f1ba85e3681ba026cfefaf6036890.1747077616.git.Ryan.Wanner@microchip.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1747077616.git.Ryan.Wanner@microchip.com>
References: <cover.1747077616.git.Ryan.Wanner@microchip.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ryan Wanner <Ryan.Wanner@microchip.com>

Add support for CAN bus to the SAMA7D65 SoC.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
---
 arch/arm/boot/dts/microchip/sama7d65.dtsi | 80 +++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/arch/arm/boot/dts/microchip/sama7d65.dtsi b/arch/arm/boot/dts/microchip/sama7d65.dtsi
index 796909fa2368..a62d2ef9fcab 100644
--- a/arch/arm/boot/dts/microchip/sama7d65.dtsi
+++ b/arch/arm/boot/dts/microchip/sama7d65.dtsi
@@ -163,6 +163,86 @@ chipid@e0020000 {
 			reg = <0xe0020000 0x8>;
 		};
 
+		can0: can@e0828000 {
+			compatible = "bosch,m_can";
+			reg = <0xe0828000 0x200>, <0x100000 0x7800>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 58>, <&pmc PMC_TYPE_GCK 58>;
+			clock-names = "hclk", "cclk";
+			assigned-clocks = <&pmc PMC_TYPE_GCK 58>;
+			assigned-clock-rates = <40000000>;
+			assigned-clock-parents = <&pmc PMC_TYPE_CORE PMC_UTMI>;
+			bosch,mram-cfg = <0x3400 0 0 64 0 0 32 32>;
+			status = "disabled";
+		};
+
+		can1: can@e082c000 {
+			compatible = "bosch,m_can";
+			reg = <0xe082c000 0x200>, <0x100000 0xbc00>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 59>, <&pmc PMC_TYPE_GCK 59>;
+			clock-names = "hclk", "cclk";
+			assigned-clocks = <&pmc PMC_TYPE_GCK 59>;
+			assigned-clock-rates = <40000000>;
+			assigned-clock-parents = <&pmc PMC_TYPE_CORE PMC_UTMI>;
+			bosch,mram-cfg = <0x7800 0 0 64 0 0 32 32>;
+			status = "disabled";
+		};
+
+		can2: can@e0830000 {
+			compatible = "bosch,m_can";
+			reg = <0xe0830000 0x200>, <0x100000 0x10000>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 60 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 60>, <&pmc PMC_TYPE_GCK 60>;
+			clock-names = "hclk", "cclk";
+			assigned-clocks = <&pmc PMC_TYPE_GCK 60>;
+			assigned-clock-rates = <40000000>;
+			assigned-clock-parents = <&pmc PMC_TYPE_CORE PMC_UTMI>;
+			bosch,mram-cfg = <0xbc00 0 0 64 0 0 32 32>;
+			status = "disabled";
+		};
+
+		can3: can@e0834000 {
+			compatible = "bosch,m_can";
+			reg = <0xe0834000 0x200>, <0x110000 0x4400>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 61>, <&pmc PMC_TYPE_GCK 61>;
+			clock-names = "hclk", "cclk";
+			assigned-clocks = <&pmc PMC_TYPE_GCK 61>;
+			assigned-clock-rates = <40000000>;
+			assigned-clock-parents = <&pmc PMC_TYPE_CORE PMC_UTMI>;
+			bosch,mram-cfg = <0x0 0 0 64 0 0 32 32>;
+			status = "disabled";
+		};
+
+		can4: can@e0838000 {
+			compatible = "bosch,m_can";
+			reg = <0xe0838000 0x200>, <0x110000 0x8800>;
+			reg-names = "m_can", "message_ram";
+			interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "int0", "int1";
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 62>, <&pmc PMC_TYPE_GCK 62>;
+			clock-names = "hclk", "cclk";
+			assigned-clocks = <&pmc PMC_TYPE_GCK 62>;
+			assigned-clock-rates = <40000000>;
+			assigned-clock-parents = <&pmc PMC_TYPE_CORE PMC_UTMI>;
+			bosch,mram-cfg = <0x4400 0 0 64 0 0 32 32>;
+			status = "disabled";
+		};
+
 		dma2: dma-controller@e1200000 {
 			compatible = "microchip,sama7d65-dma", "microchip,sama7g5-dma";
 			reg = <0xe1200000 0x1000>;
-- 
2.43.0

