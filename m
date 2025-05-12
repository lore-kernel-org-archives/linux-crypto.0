Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432F5298CC1;
	Mon, 12 May 2025 19:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747078190; cv=none; b=uYTYUfy4pee4yh4hd/3VMFNviv4fTjBr2sbXlypnV2iXUdo3eJfG1eSz/z6spQOoXRjJtaG+qszFvC9n5Ieg51IsC92/Eo4rUXVJoxOQA3hin1y5hRCqc8P2BGk3Bc4nzg4yRLEM5Ugj01vM03xzBYd0qmPP6XuKlhLEmHChhYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747078190; c=relaxed/simple;
	bh=0sFBIF2ykXtcl0pQgru1CGwjmwrKN9g0PCzlEM3PZHg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m6rXdPxHUGschaECwgR2LkjGeqnXpwmZSfMb3Jp8XwHOroHrdyjq8+3MGrXIbyTpUzVB8HQyo/IjPkEOah5qJZ9ZVpTJaPZ29zvS3i5a/tQUxY7OErwjjzfM9gqx3ad47ZdIC2paDaWBbmTT1JsFY4JEv93BbBUeIJpfgozyrUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=Y9Ebcp9U; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="Y9Ebcp9U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1747078189; x=1778614189;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0sFBIF2ykXtcl0pQgru1CGwjmwrKN9g0PCzlEM3PZHg=;
  b=Y9Ebcp9UjLgGJZJYpCSoAoaS+EO2DbHxHsx2NH0yyS3zuF3pM2YrM/+u
   w9SEmUbk2YuWx9rrypIoMQZlqtC9hjFoQrf4dmXNlyWWxwgKQsEogA4iW
   OQ2d1V4vyeiZfOwvAYErohe+5pLCrvAo37R5mDuuR7YT70lSjEh0b/zTQ
   Q2CGoxCpoitJMkWNspIpO7G/EytiYm9pf3Hn8fgu+tXWiprt7XEISbihB
   M5Q5woAxQ4jzqKwHpx5NCByTbcqA4CIXJ8gJ05+toIN95ZHwZonQwP9Dq
   jOu4wj9q3QGkkIC2pF6wpd9NLYIfkGQaAYgCjxrGE962TeDDzjxcxlI9U
   w==;
X-CSE-ConnectionGUID: hYKpzzHaRPOvLPNNOvU8gw==
X-CSE-MsgGUID: PNaWPgFuQ2mg//QaTO6urQ==
X-IronPort-AV: E=Sophos;i="6.15,283,1739862000"; 
   d="scan'208";a="209006613"
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
Subject: [PATCH 7/9] ARM: dts: microchip: sama7d65: Add PWM support
Date: Mon, 12 May 2025 12:27:33 -0700
Message-ID: <fae166010f94a672e4f1906f5fd4394f4236da53.1747077616.git.Ryan.Wanner@microchip.com>
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

Add support for PWMs to the SAMA7D65 SoC.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
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

