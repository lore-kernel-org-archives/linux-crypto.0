Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8948F1DFF7;
	Wed, 11 Jun 2025 19:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749671317; cv=none; b=GqUA057C3eUQjy12rsUivFkMQGNV1Raa5DZQN4s1NUVxzrFFX0YFGYtYMDFF2iBW8HmaXUPwVnv3BdoFOSIH66IWDmdSH8mWqI34sMhumidvwn/IITPdyOb3bQgptyXKUa55oR9lpJtY5H50beALT3obhtCkF2uX1j18e2rdI30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749671317; c=relaxed/simple;
	bh=OLfd68qnuzctm3Q3lmoS0Sml2GYxSnlcolATqmbMYcs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YKli0kBDo4X5+xhhcF/5Vr0dmqL/kGed3FXoDKPWyk5eZwGipCIJbpC/1DzMi/9A9X75UXqzx/fakmp8eWN57FzOQc3L68GH9ynUL4wZ5bWySOmA1CP1iwaxm0LQj7YJuT8Ne6oJ6WOZmvbX1KTD98xoDLmF9/UwzWr+BBhVsL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=P04x198O; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="P04x198O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1749671312; x=1781207312;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OLfd68qnuzctm3Q3lmoS0Sml2GYxSnlcolATqmbMYcs=;
  b=P04x198OMLtMMQHhGuFzOfBiJlmb7tvaxjNzsnqHUqEDrfe/MjBp/l2y
   LAlwbcFbNi3BiUxJr4KxBwZeSP7q0qtOHS/vTWdVHpCAq9wVOH2IM88cY
   YUWfn3jeWG7xdEYKGDc9gMWYy+AmiNWr4Vwq8f1fluAiMpVaoOjx76Mwv
   nY8ULGBRcuN+4ZAyT24RWc+EoN466AX0xlZSUwHsqYjeZLi6/rwS87S/+
   xDMkvbWX5EQb1ByZHfYbRgIgemssyM0h9rk3jjN1JKWc7Adz52XyH05C2
   phAzAkqhnVMRYxltwBEB6zdxx0nhXx8BUJrfn4xTeUXs6oqfogbRqDyzp
   w==;
X-CSE-ConnectionGUID: VqjTqfGTSymHXSpb+r0c0A==
X-CSE-MsgGUID: Gwb8uRMNTNmg1Pwhb40oAw==
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="42226221"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jun 2025 12:48:25 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 11 Jun 2025 12:48:16 -0700
Received: from ryan-Precision-3630-Tower.microchip.com (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.44 via Frontend Transport; Wed, 11 Jun 2025 12:48:16 -0700
From: <Ryan.Wanner@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh@kernel.org>,
	<krzk+dt@kernel.org>, <conor+dt@kernel.org>, <nicolas.ferre@microchip.com>,
	<alexandre.belloni@bootlin.com>, <claudiu.beznea@tuxon.dev>,
	<olivia@selenic.com>
CC: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Ryan
 Wanner" <Ryan.Wanner@microchip.com>
Subject: [PATCH v2 00/10] SAMA7D65 Add support for Crypto, CAN and PWM
Date: Wed, 11 Jun 2025 12:47:24 -0700
Message-ID: <cover.1749666053.git.Ryan.Wanner@microchip.com>
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

Changes v1 -> v2:
- Clean up formatting issues in the device tree and DT bindings.
- Add a description of the capabilities for the cyrpto IPs for this SoC.

Ryan Wanner (10):
  dt-bindings: crypto: add sama7d65 in Atmel AES
  dt-bindings: crypto: add sama7d65 in Atmel SHA
  dt-bindings: crypto: add sama7d65 in Atmel TDES
  dt-bindings: rng: atmel,at91-trng: add sama7d65 TRNG
  crypto: atmel - add support for AES and SHA IPs available on sama7d65
    SoC
  ARM: dts: microchip: sama7d65: Add crypto support
  ARM: dts: microchip: sama7d65: Add PWM support
  ARM: dts: microchip: sama7d65: Add CAN bus support
  ARM: dts: microchip: sama7d65: Clean up extra space
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

