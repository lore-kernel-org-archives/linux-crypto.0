From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH v2 00/14] crypto: caam - Add i.MX6 support to the Freescale CAAM driver
Date: Wed, 5 Aug 2015 11:28:34 -0700
Message-ID: <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
	<robh+dt@kernel.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0146.outbound.protection.outlook.com ([65.55.169.146]:23808
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752803AbbHES2x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 14:28:53 -0400
In-Reply-To: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series adds i.MX6 support to the Freescale CAAM driver.

Modifications include:

- explicit cache coherency support in the driver
- register I/O primitive support
- scatter/gather entry modifications
- clocking support
- i.MX6 device tree support for CAAM
- DMA fixes
- algorithm registration based on hardware capabilities

These patches have been tested on the i.MX6 and regression tested
on QorIQ platforms.

Changes in v2:
  - Clocking support:
    - Minimized architecture differences
    - Balanced clk_get and clk_put calls
    - Removed display of clock values
    - Renamed clock definitions to explicitly show "CLK"
    - Removed unnecessary "caam_" prefixes to clock-names property in DTS files
    - Added clocks and clock-names property descriptions to SEC 4.0
      device tree bindings document
  - Added check of hardware capabilities before algorithm registration
  - Modified patches based on AEAD changes in caamalg.c

 .../devicetree/bindings/crypto/fsl-sec4.txt        | 17 ++++
 arch/arm/boot/dts/imx6qdl.dtsi                     | 29 ++++++-
 arch/arm/boot/dts/imx6sx.dtsi                      | 28 +++++++
 arch/arm/configs/imx_v6_v7_defconfig               |  3 +-
 drivers/clk/imx/clk-imx6q.c                        |  3 +
 drivers/crypto/caam/Kconfig                        |  2 +-
 drivers/crypto/caam/caamalg.c                      | 80 +++++++++++++++---
 drivers/crypto/caam/caamhash.c                     | 67 +++++++++------
 drivers/crypto/caam/caamrng.c                      | 10 ++-
 drivers/crypto/caam/compat.h                       |  1 +
 drivers/crypto/caam/ctrl.c                         | 94 +++++++++++++++++++++-
 drivers/crypto/caam/desc.h                         | 25 +++++-
 drivers/crypto/caam/intern.h                       |  5 ++
 drivers/crypto/caam/jr.c                           | 18 +++++
 drivers/crypto/caam/regs.h                         | 39 ++++++++-
 drivers/crypto/caam/sg_sw_sec4.h                   | 25 ++++--
 include/dt-bindings/clock/imx6qdl-clock.h          |  5 +-
 17 files changed, 389 insertions(+), 62 deletions(-)

-- 
2.1.4
