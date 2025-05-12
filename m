Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE19B299A87;
	Mon, 12 May 2025 19:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747078192; cv=none; b=oewraJ3zVOzP9xaWnw8glNN+TX5z4jNA5XFE7nrHhpshyPWHtTh3dOW/SV3CVo5hpPRsODHrCmEw0cqr/uUOIkvHT28ass+7U2Wf2MCcStoKpoo5GvszckJtyR8bz1nXsgFcsKy1Ay1X2YCUuQSqtkzCOQkxgPwFGczNTX74NiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747078192; c=relaxed/simple;
	bh=7g4YU5RvMdO8nUKIAvi8SziBhELB9C+O6jh6PDYC3HM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MV3VgyNUJBvYOAs7preqPlFddTR42xUNlghVUm6TZMfnY57fR2R7t5rG5Y08XtdY/yKHarK+C5Obj05khOxFVZno1Bj4LrKTHcMlPmVoJCtnocrCuArTJrslusZR+gfgDZzCPBllo+X7rwK9h/aOcm5YzYvvhlDvdMfVx1z81mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=vytXWb+Y; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="vytXWb+Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1747078190; x=1778614190;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7g4YU5RvMdO8nUKIAvi8SziBhELB9C+O6jh6PDYC3HM=;
  b=vytXWb+YSpzqKHV3s4GbTa3GOQ0R8Ys9y9lnOOX8Ks+eGvCKz0rBFPyR
   yyGBMPXSZ4/Gt4sXwuscfFg330fmoby8nGHneT8sKkPCww6LTgUlXmyZ+
   OAdXCgmOgEr9FQceEjD8GdFIprmTW9y1RbJh9J0QllNsWLK5SNYP31+CR
   MBg/WxqRAaqk0JZzx0xHEDxXHLa0PMauVirjjrzdSiqCAPZGXrU8fj8Q9
   5vkAHRFadnsoJHf4zSxnLGNCvnH+j3Am/mIr2r0gbtGzB/+i5Bd+H99hP
   T+q/tngHduBOqPjWBhrjMW29CYnMm1JJqP7jUy06EeULzY0URZGgc2tdq
   g==;
X-CSE-ConnectionGUID: hYKpzzHaRPOvLPNNOvU8gw==
X-CSE-MsgGUID: pCEDP93tTVWVq4rPvoMskA==
X-IronPort-AV: E=Sophos;i="6.15,283,1739862000"; 
   d="scan'208";a="209006615"
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
Subject: [PATCH 9/9] ARM: dts: microchip: sama7d65: Enable CAN bus
Date: Mon, 12 May 2025 12:27:35 -0700
Message-ID: <0e34e0416c43f4de6d2cef5cea46087af4577a50.1747077616.git.Ryan.Wanner@microchip.com>
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

Enable CAN bus for SAMA7D65 curiosity board.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
---
 .../dts/microchip/at91-sama7d65_curiosity.dts | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts b/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
index 53a657cf4efb..34935179897e 100644
--- a/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
+++ b/arch/arm/boot/dts/microchip/at91-sama7d65_curiosity.dts
@@ -38,7 +38,24 @@ reg_5v: regulator-5v {
 		regulator-max-microvolt = <5000000>;
 		regulator-always-on;
 	};
+};
+
+&can1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_can1_default>;
+	status = "okay";
+};
 
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
 };
 
 &dma0 {
@@ -278,6 +295,24 @@ &main_xtal {
 };
 
 &pioa {
+	pinctrl_can1_default: can1-default {
+		pinmux = <PIN_PD10__CANTX1>,
+			<PIN_PD11__CANRX1>;
+		bias-disable;
+	};
+
+	pinctrl_can2_default: can2-default {
+		pinmux = <PIN_PD12__CANTX2>,
+			<PIN_PD13__CANRX2>;
+		bias-disable;
+	};
+
+	pinctrl_can3_default: can3-default {
+		pinmux = <PIN_PD14__CANTX3>,
+			<PIN_PD15__CANRX3>;
+		bias-disable;
+	};
+
 	pinctrl_gmac0_default: gmac0-default {
 		pinmux = <PIN_PA26__G0_TX0>,
 			 <PIN_PA27__G0_TX1>,
-- 
2.43.0

