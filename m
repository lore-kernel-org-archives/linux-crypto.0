Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F99F23F417;
	Mon, 12 May 2025 19:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747078185; cv=none; b=ArN/bifVGNKTRoWpM6w+/7jOsf5d9sGNn8sURTcSZlBpNrDkTsUK2uRCmwvTTcttNauZm4NsWMBqRwySxLdxgtyPhBNzBT293v2sWWDobiUN6IrnEmhLEH8U5D9JRMruaGAN9w1xxhtGP+XsYSaWz/MW5v+8lzExvBeY3hhMnwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747078185; c=relaxed/simple;
	bh=Sdl1gDmVvVhvI5vO5ld0fmlqgs4/bpMSz4SEZl51ot0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OZZ12Ult+6Tb5c9m0UIxgcmhMm4Rrx03mVGykt+YfDj0Uky0OTA14biKHF28ipHbxxCf4VQA61R9DlNzXg1abHtdyTQ4/HnDo8ja7E87vnUtRMvQEJJa1GSVTQZtuEv0EVKg0NjOJoT1bWYPcV4pT/oo3oc4sLJWq+LUOZmSQ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=KGltEkjz; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="KGltEkjz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1747078184; x=1778614184;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Sdl1gDmVvVhvI5vO5ld0fmlqgs4/bpMSz4SEZl51ot0=;
  b=KGltEkjzvM7iWn+lHQbk2YEm5wla86lXfIhLaxClwSUDXeyq9+U8xTrm
   0slsRfFEbPPN+zX6n9miNG3tc52ZTVx8sJQOux9Sr7Ymz9pGbCn2cE4si
   Ty3yyRczDMIRnA5U4pBQeDH7bIaLz3P/sfIk5tN7DO65EgevzRRyKSErV
   t4/fhbj9vQqESF/Yhj0loB1vPL6sPl2NU/jsQN578HvQjZV7n4FkK/WMr
   Q44VNbBEEvleK31TbqHh85lP5S+7r08s/rcwEh/Rq0iq2oPIDIG+xQ+vp
   FoVG4OJ49FlHVcZ2LQ6E5bWHMmjCTWMPzdeYt6k6Zy8Ut3gAjZxhyJP5l
   g==;
X-CSE-ConnectionGUID: hYKpzzHaRPOvLPNNOvU8gw==
X-CSE-MsgGUID: dl60q0MJRZCfEkOp56V1ig==
X-IronPort-AV: E=Sophos;i="6.15,283,1739862000"; 
   d="scan'208";a="209006606"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 May 2025 12:29:36 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 12 May 2025 12:28:56 -0700
Received: from ryan-Precision-3630-Tower.microchip.com (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.44 via Frontend Transport; Mon, 12 May 2025 12:28:56 -0700
From: <Ryan.Wanner@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh@kernel.org>,
	<krzk+dt@kernel.org>, <conor+dt@kernel.org>, <nicolas.ferre@microchip.com>,
	<alexandre.belloni@bootlin.com>, <claudiu.beznea@tuxon.dev>,
	<olivia@selenic.com>
CC: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Ryan
 Wanner" <Ryan.Wanner@microchip.com>
Subject: [PATCH 0/9] SAMA7D65 Add support for Crypto, CAN and PWM
Date: Mon, 12 May 2025 12:27:26 -0700
Message-ID: <cover.1747077616.git.Ryan.Wanner@microchip.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ryan Wanner <Ryan.Wanner@microchip.com>

This set adds support for the SAMA7D65 SoC crypto subsystem and enabling
them in the device tree. This set also adds PWM to the device tree, and
adds and enables the CAN bus system for the SAMA7D65 SoC.

Ryan Wanner (9):
  dt-bindings: crypto: add sama7d65 in Atmel AES
  dt-bindings: crypto: add sama7d65 in Atmel SHA
  dt-bindings: crypto: add sama7d65 in Atmel TDES
  dt-bindings: rng: atmel,at91-trng: add sama7d65 TRNG
  crypto: atmel - add support for AES and SHA IPs available on sama7d65
    SoC
  ARM: dts: microchip: sama7d65: Add crypto support
  ARM: dts: microchip: sama7d65: Add PWM support
  ARM: dts: microchip: sama7d65: Add CAN bus support
  ARM: dts: microchip: sama7d65: Enable CAN bus

 .../crypto/atmel,at91sam9g46-aes.yaml         |   4 +-
 .../crypto/atmel,at91sam9g46-sha.yaml         |   4 +-
 .../crypto/atmel,at91sam9g46-tdes.yaml        |   4 +-
 .../bindings/rng/atmel,at91-trng.yaml         |   1 +
 .../dts/microchip/at91-sama7d65_curiosity.dts |  35 +++++
 arch/arm/boot/dts/microchip/sama7d65.dtsi     | 128 ++++++++++++++++++
 drivers/crypto/atmel-aes.c                    |   1 +
 drivers/crypto/atmel-sha.c                    |   1 +
 8 files changed, 175 insertions(+), 3 deletions(-)

-- 
2.43.0

