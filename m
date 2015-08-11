From: Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 0/3] ARM: sun6i: Support Security System crypto engine
Date: Tue, 11 Aug 2015 13:32:54 +0800
Message-ID: <1439271177-26523-1-git-send-email-wens@csie.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi everyone,

This series enables support for the crypto engine found in sun6i, or
Allwinner A31/A31s SoCs. The crypto engine is the same hardware as on
earlier sun4i/sun7i (A10/A20), with the only difference being the reset
control is separated out of the clock gate control.

The same hardware is also available on the A33, but not the A23. Support
for this requires additions to the clock driver, and will be submitted
separately once things are clear on how to proceed. I already have a
proof of concept working.


Patch 1 adds an optional reset control property to the sunxi-ss binding.

Patch 2 adds optional reset control support to the sunxi-ss driver.

Patch 3 enables the crypto engine on sun6i, by adding the module clock and
device node.


Regards
ChenYu


Chen-Yu Tsai (3):
  crypto: sunxi-ss: Document optional reset control bindings
  crypto: sunxi-ss: Add optional reset control support
  ARM: dts: sun6i: Add security system crypto engine clock and device
    nodes

 .../devicetree/bindings/crypto/sun4i-ss.txt        |  4 ++++
 arch/arm/boot/dts/sun6i-a31.dtsi                   | 18 ++++++++++++++++++
 drivers/crypto/sunxi-ss/sun4i-ss-core.c            | 22 ++++++++++++++++++++++
 drivers/crypto/sunxi-ss/sun4i-ss.h                 |  2 ++
 4 files changed, 46 insertions(+)

-- 
2.5.0
