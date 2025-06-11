Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761E32BF3CC;
	Wed, 11 Jun 2025 19:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749671332; cv=none; b=ups1RZZjNV5Ny62HssTUQ2i1txr3CzOydmdYEDkvwQdTCfNbI2PuEzQhqkf0CNm/F/Y4pZMZL8FR0vonnu8Bvu3/rCd674AYkc+lkxMtZiKMVs87DEje3cORF6e79e61AmRrSydIu05n5sOwOn1dRKc911JcnTQ68sfLE1AzFHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749671332; c=relaxed/simple;
	bh=xLRwY8aONHUaKqsXAclFpBaTSGFNejQ7PpKVRUoZnnw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z+EdDwV0PNmSJ38lTYBTdj/kDfnMwjB1ZpbGDBO4IkoSA/XhQJvd9RPleUb6BwKA3cnPaLYjUl5KKdNcmk+FN/RIxDDlyDB0Mv6Nh1lEW63iTi6bz0bW5SRwNYHbnB9y6PmEQl00UMYKFx5TiUIlKpYjIBeo68lJH/+fpjfg80I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=pfDuf8XG; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="pfDuf8XG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1749671330; x=1781207330;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xLRwY8aONHUaKqsXAclFpBaTSGFNejQ7PpKVRUoZnnw=;
  b=pfDuf8XGN/WykWNNGsqRhw8+8Y+n2C0UV3jfm6W3MN1KJp1+Kb+8sTBV
   Qepbxu0j2d4t7VUSUzhv6+SlJbnfPjovCA1WPzhB3eN5ts5rU+VhrE5+F
   5GmcKK0sfCmEOGOP1SMdirK7+oSJh/prL0kX/F7sBEXPnxC/uVxKiB/o1
   fJGmWprNEtvoUGruiWkQwgfST1FERxFnvuWN9M4Tb0Vio2qyVMhOHkarZ
   KouiyVJRhbRJlk8v1yljSY9ytxq2Jceg00eiQCF5fWs5j97q+ppQ2a2Yy
   /Tsw5omeQjqjA87KNywMi1jhGQR8zrYJRRejUVSrhXO235wdxrPt0r7Sa
   g==;
X-CSE-ConnectionGUID: Mlj04rVUS3aXDCaAEgxBzw==
X-CSE-MsgGUID: UKxifKXEQ6CSQxuy3QPY1A==
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="210175095"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jun 2025 12:48:49 -0700
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
Subject: [PATCH v2 07/10] ARM: dts: microchip: sama7d65: Add PWM support
Date: Wed, 11 Jun 2025 12:47:31 -0700
Message-ID: <195c69a19be1ff14736db402e0f1ee64438b4b20.1749666053.git.Ryan.Wanner@microchip.com>
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

Add support for PWMs to the SAMA7D65 SoC.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
---
 arch/arm/boot/dts/microchip/sama7d65.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/microchip/sama7d65.dtsi b/arch/arm/boot/dts/microchip/sama7d65.dtsi
index 90cbea576d91..796909fa2368 100644
--- a/arch/arm/boot/dts/microchip/sama7d65.dtsi
+++ b/arch/arm/boot/dts/microchip/sama7d65.dtsi
@@ -293,6 +293,15 @@ pit64b1: timer@e1804000 {
 			clock-names = "pclk", "gclk";
 		};
 
+		pwm: pwm@e1818000 {
+			compatible = "microchip,sama7d65-pwm", "atmel,sama5d2-pwm";
+			reg = <0xe1818000 0x500>;
+			interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&pmc PMC_TYPE_PERIPHERAL 72>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
 		flx0: flexcom@e1820000 {
 			compatible = "microchip,sama7d65-flexcom", "atmel,sama5d2-flexcom";
 			reg = <0xe1820000 0x200>;
-- 
2.43.0

