Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC81298CAD;
	Mon, 12 May 2025 19:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747078189; cv=none; b=NJT+hHyIdwZaViU0UU+6D5vAnQaO7GU/nhoB6hql6558Yx+hLDwdut/xghDMUqLdNa2X2Q87Jzb2KiYAZ0eIW8mwHgjeQ5d5Ulzvgke7F1av/uUFadXq5TpVc2EP0zvcchYDX46VP+2aI9OvtD9AOkJE3s761QWWq4jryigpPak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747078189; c=relaxed/simple;
	bh=aWO0d59mD3euTgxppOwxO3iX5dY796oeQrvPcyg7cxU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HypU17m9vwVRAD+PgsgoQ0p1fzkGG0+53sKUbQIe43SWmmf2e7e5yxIpppIRc9mA38lQw2/sEmCi4z6d0j9JvAl1MjugsSvkuDLSyH1ohXGCps8tGEkmDD/eQXDUFPVTKIaiLCABeVdpLd/L5YrTCfPkqL1zexLJrN02LDSDOI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=AEkT5vvy; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="AEkT5vvy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1747078188; x=1778614188;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aWO0d59mD3euTgxppOwxO3iX5dY796oeQrvPcyg7cxU=;
  b=AEkT5vvym4pOAIsZNUyhHlNpe8PLxcxDhuUJvoU6sIYuie8GUrfxPveO
   7EDjUbu946i0mKl2lNsiNKnRVVfUE0/PgK4tS43ik6HohzhFhKCAaetdu
   sv1wcyMxlD7SLEgab7Xvfda1Ho0afInByhw8mgnaMoX4qCBfBUdelxw9Q
   Uo67T59g3qogAwn4mMinLQ3s+j/B0UEL6wCg7uwbLwacUMI9lnJgeMQlj
   LLe9NB7z9UhSf0Rz6+yI8dyY8TKqQcDkP4OMotJrY2bHMvChKW7f8FioD
   rh5O5chlUsJGDNQ8xFdMwZSishU7B2og+XA6sCuqqjj6zHEZZ+Xufn3hr
   Q==;
X-CSE-ConnectionGUID: hYKpzzHaRPOvLPNNOvU8gw==
X-CSE-MsgGUID: PNse3QQVQAq4h4ArfCshoA==
X-IronPort-AV: E=Sophos;i="6.15,283,1739862000"; 
   d="scan'208";a="209006612"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 May 2025 12:29:37 -0700
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
Subject: [PATCH 6/9] ARM: dts: microchip: sama7d65: Add crypto support
Date: Mon, 12 May 2025 12:27:32 -0700
Message-ID: <5d045fc3be18fcd6644f14b9568f1f8d7c8d75a1.1747077616.git.Ryan.Wanner@microchip.com>
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

Add and enable SHA, AES, TDES, and TRNG for SAMA7D65 SoC.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
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

