Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928212C3279;
	Wed, 11 Jun 2025 19:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749671334; cv=none; b=Co4v7fsYo/EhHOjeRhMUjeJYjbB/BTrapzWMlWenJPBhEvA1nbcjrLjTO0n+rxUSxAYs6spOjFdZ/jJ45y3Z475jMIqOfSLuB+7NBAM+Eb1ulmOUpbEh58ZmiKXr5c+mB3cdgjaAMFICaiGCj4kwaTNmYvZ5XS1U67Lwr/u4Uy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749671334; c=relaxed/simple;
	bh=aDdyZCDm5RtgTX/poDkJ6S5z8PkXxnmyIfnGWdKweUk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jT436D/3neUZP+J3SZDX2l7vlkK5g7lhqAh4ayYw9As2juBeRDJ6XQsfF9a9foCYlYe4GHDJU44MRe7C1q1gw/yieW7zrLIKt3LOcDjK719I0I12B5JTZGbj8ivq75erif58Dv3vAk8YhQCYFgkvnQP7bozrzPlTEC29YDtr3dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=CMk1MzrK; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="CMk1MzrK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1749671332; x=1781207332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aDdyZCDm5RtgTX/poDkJ6S5z8PkXxnmyIfnGWdKweUk=;
  b=CMk1MzrKUCUwiATUmskOr0S3phVO72XTSjkE+xlaljzqe4Ip/gxGm8xR
   G5gryjOL4jjmpMQtNkRinhNjJIyZpFYoH1B9gV/yOi4j2UV1ZpgAlPVF7
   TVloBFSEjdQkn80jqkQsMf+oUt1GNto33w3329CM4v0HYMJP7PGulCQds
   2KVYq18jQ4DtoV60PjMANCwXeolsm6lNKE1Lplm/rG0PHVvW7H1wVPBtC
   pqjPs9/hm6tR/p+oMZhOleLwh0HGu+RuWBHTFaUTJHsZXZVYk7X0vBSf2
   P6hbRokjfIJd6/3dLRVGIfARu+GZyuxYP3xdiytm3mWDXvnLCoq4nPqN0
   Q==;
X-CSE-ConnectionGUID: Mlj04rVUS3aXDCaAEgxBzw==
X-CSE-MsgGUID: 6Xo02CoxSyS+i1Yy/BDTYg==
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="210175099"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jun 2025 12:48:50 -0700
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
Subject: [PATCH v2 10/10] ARM: dts: microchip: sama7d65: Enable CAN bus
Date: Wed, 11 Jun 2025 12:47:34 -0700
Message-ID: <ab719861de53432bdf19593fa4eee40adf57aed9.1749666053.git.Ryan.Wanner@microchip.com>
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

Enable CAN bus for SAMA7D65 curiosity board.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
---
 .../dts/microchip/at91-sama7d65_curiosity.dts | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts b/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
index 759b963d987c..7eaf6ca233ec 100644
--- a/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
+++ b/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
@@ -40,6 +40,24 @@ reg_5v: regulator-5v {
 	};
 };
 
+&can1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_can1_default>;
+	status = "okay";
+};
+
+&can2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_can2_default>;
+	status = "okay";
+};
+
+&can3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_can3_default>;
+	status = "okay";
+};
+
 &dma0 {
 	status = "okay";
 };
@@ -277,6 +295,24 @@ &main_xtal {
 };
 
 &pioa {
+	pinctrl_can1_default: can1-default {
+		pinmux = <PIN_PD10__CANTX1>,
+			 <PIN_PD11__CANRX1>;
+		bias-disable;
+	};
+
+	pinctrl_can2_default: can2-default {
+		pinmux = <PIN_PD12__CANTX2>,
+			 <PIN_PD13__CANRX2>;
+		bias-disable;
+	};
+
+	pinctrl_can3_default: can3-default {
+		pinmux = <PIN_PD14__CANTX3>,
+			 <PIN_PD15__CANRX3>;
+		bias-disable;
+	};
+
 	pinctrl_gmac0_default: gmac0-default {
 		pinmux = <PIN_PA26__G0_TX0>,
 			 <PIN_PA27__G0_TX1>,
-- 
2.43.0

