From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH 00/12] crypto: caam - Add i.MX6 support to the Freescale CAAM driver
Date: Wed, 29 Jul 2015 20:58:17 -0700
Message-ID: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0134.outbound.protection.outlook.com ([157.56.110.134]:15552
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752273AbbG3D6g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jul 2015 23:58:36 -0400
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

These patches have been tested on the i.MX6 and regression tested
on QorIQ platforms. These patches include changes based on responses
to the original RFC.



 arch/arm/boot/dts/imx6qdl.dtsi            |  30 ++++-
 arch/arm/boot/dts/imx6sx.dtsi             |  29 +++++
 arch/arm/configs/imx_v6_v7_defconfig      |   3 +-
 drivers/clk/imx/clk-imx6q.c               |   3 +
 drivers/crypto/caam/Kconfig               |   2 +-
 drivers/crypto/caam/caamalg.c             |  20 +--
 drivers/crypto/caam/caamhash.c            |  29 +++--
 drivers/crypto/caam/caamrng.c             |   4 +
 drivers/crypto/caam/compat.h              |   1 +
 drivers/crypto/caam/ctrl.c                | 197 +++++++++++++++++++++++++++++-
 drivers/crypto/caam/desc.h                |  25 +++-
 drivers/crypto/caam/intern.h              |   5 +
 drivers/crypto/caam/jr.c                  |  18 +++
 drivers/crypto/caam/regs.h                |  23 ++++
 drivers/crypto/caam/sg_sw_sec4.h          |  25 ++--
 include/dt-bindings/clock/imx6qdl-clock.h |   5 +-
 16 files changed, 371 insertions(+), 48 deletions(-)

-- 
2.1.4
