From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 0/2] crypto: add a new driver for Marvell CESA
Date: Mon,  4 May 2015 14:26:59 +0200
Message-ID: <1430742426-21202-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <boris.brezillon@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:57680 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751714AbbEDM1O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2015 08:27:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This patch series adds a new driver supporting Marvell's CESA IP.
This driver addresses some limitations of the existing one.
>From a performance and CPU load point of view the most important
limitation in the existing driver is the lack of DMA support, thus
preventing us from chaining crypto operations.

I know we usually try to adapt existing drivers instead of replacing them
by new ones, but after trying to refactor the mv_cesa driver I realized it
would take longer than writing an new one from scratch.

Here are the main features brought by this new driver:
- support for armada SoCs (up to 38x) while keeping support for older ones
  (Orion and Kirkwood). Note that old DT bindings (those used on Orion and
  Kirkwood platforms) are supported, or IOTW, old DTs are compatible with
  this new driver.
- DMA mode to offload the CPU in case of intensive crypto usage
- new algorithms: SHA256, DES and 3DES

In addition to this driver comes a bunch of DT updates adding crypto device
nodes to several Marvell SoCs (those are only the tested ones, others might
be added later).

I'd like to thank Arnaud, who has carefully reviewed several iterations of
this driver, helped me improved my implementation, provided support for
several crypto algorithms, provided support for armada-370 and tested
the driver on different platforms, hence the SoB and dual MODULE_AUTHOR
in the driver code.

Sebastian, I haven't split "crypto: add new driver for Marvell CESA" as
you suggested, but if you (and others) really think it is worth the pain,
then I'll do so.

Best Regards,

Boris

Changes since v1:
- (suggested by Jason) kept the existing CESA driver and added a mechanism
  to prevent the new driver from probing devices handled my the existing
  one (Orion and Kirkwood platforms)
- (reported by Paul) addressed a few Kconfig and module definition issues
- (suggested by Andrew) added DT changes to the series

Arnaud Ebalard (2):
  ARM: marvell/dt: add crypto node to armada 370 SoC
  ARM: marvell/dt: add crypto node to kirkwood SoC

Boris Brezillon (5):
  crypto: mv_cesa: request registers memory region
  crypto: add new driver for Marvell CESA
  crypto: marvell/CESA: update DT bindings documentation
  ARM: marvell/dt: add crypto node to armada-xp SoC
  ARM: marvell/dt: add crypto node to armada-xp-gp board

 .../devicetree/bindings/crypto/marvell-cesa.txt    |   46 +
 arch/arm/boot/dts/armada-370.dtsi                  |   22 +
 arch/arm/boot/dts/armada-xp-gp.dts                 |    4 +-
 arch/arm/boot/dts/armada-xp.dtsi                   |   30 +
 arch/arm/boot/dts/kirkwood.dtsi                    |    2 +-
 drivers/crypto/Kconfig                             |   17 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/marvell/Makefile                    |    2 +
 drivers/crypto/marvell/cesa.c                      |  543 ++++++++
 drivers/crypto/marvell/cesa.h                      |  802 ++++++++++++
 drivers/crypto/marvell/cipher.c                    |  761 +++++++++++
 drivers/crypto/marvell/hash.c                      | 1349 ++++++++++++++++++++
 drivers/crypto/marvell/tdma.c                      |  223 ++++
 drivers/crypto/mv_cesa.c                           |   13 +-
 14 files changed, 3805 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/marvell-cesa.txt
 create mode 100644 drivers/crypto/marvell/Makefile
 create mode 100644 drivers/crypto/marvell/cesa.c
 create mode 100644 drivers/crypto/marvell/cesa.h
 create mode 100644 drivers/crypto/marvell/cipher.c
 create mode 100644 drivers/crypto/marvell/hash.c
 create mode 100644 drivers/crypto/marvell/tdma.c

-- 
1.9.1
