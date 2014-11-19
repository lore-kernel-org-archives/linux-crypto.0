From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH RESEND 0/4] ARM: at91: remove at91sam9g45/9m10 legacy board support
Date: Wed, 19 Nov 2014 17:07:54 +0100
Message-ID: <1416413278-10197-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Andrew Victor <linux@maxim.org.za>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:39877 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932380AbaKSQID (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2014 11:08:03 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This series adds DT support for the TRNG (True Random Generator) block and
adds missing trng nodes to dtsi files.

Best Regards,

Boris


Boris Brezillon (4):
  hwrng: atmel: use clk_prepapre_enable/_disable_unprepare
  hwrng: atmel: add DT support
  hwrng: atmel: Add TRNG DT binding doc
  ARM: at91/dt: add trng node

 Documentation/devicetree/bindings/hwrng/atmel-trng.txt | 16 ++++++++++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi                     |  7 +++++++
 drivers/char/hw_random/Kconfig                         |  2 +-
 drivers/char/hw_random/atmel-rng.c                     | 15 +++++++++++----
 4 files changed, 35 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwrng/atmel-trng.txt

-- 
1.9.1
