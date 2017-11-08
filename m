From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 00/12] bcm63xx-rng conversion to bcm2835-rng
Date: Tue,  7 Nov 2017 16:44:37 -0800
Message-ID: <20171108004449.32730-1-f.fainelli@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM
        BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE...),
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-crypto@vger.k
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:49110 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754420AbdKHAo4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Nov 2017 19:44:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

As it usually happens when there is a fair amount of HW IP block re-use,
competing implementations show up. In that case the BCM2835 HWRNG driver and
the BCM63xx RNG driver have exactly the same register offsets and this is
indeed the same piece of HW.

This patch series first prepares the bcm2835-rng to be more future proof and
support newer platforms, and the last part brings in what is necessary to
migrate the bcm63xx-rng over to bcm2835-rng. Finally we delete bcm63xx-rng
completely.

The reason why BCM2835 RNG was kept over BCM63xx RNG is because the former
deals correctly with a warm up count and the number of words available in the
FIFO size.

Thanks!

Changes in v2:

- rework the logic about how we manage the optional clock
- use pdev->name for the rng.name member

Florian Fainelli (12):
  hwrng: bcm2835-rng: Obtain base register via resource
  hwrng: bcm2835-rng: Define a driver private context
  hwrng: bcm2835-rng: Move enabling to hwrng::init
  hwrng: bcm2835-rng: Implementation cleanup callback
  hwrng: bcm2835-rng: Use device managed helpers
  hwrng: bcm2835-rng: Rework interrupt masking
  hwrng: bcm2835-rng: Manage an optional clock
  hwrng: bcm2835-rng: Abstract I/O accessors
  hwrng: bcm2835-rng: Add Broadcom MIPS I/O accessors
  dt-bindings: rng: Incorporate brcm,bcm6368.txt binding
  hwrng: bcm2835-rng: Enable BCM2835 RNG to work on BCM63xx platforms
  hwrng: bcm63xx-rng: Remove since bcm2835-rng takes over

 .../devicetree/bindings/rng/brcm,bcm2835.txt       |  22 ++-
 .../devicetree/bindings/rng/brcm,bcm6368.txt       |  17 ---
 drivers/char/hw_random/Kconfig                     |  20 +--
 drivers/char/hw_random/Makefile                    |   1 -
 drivers/char/hw_random/bcm2835-rng.c               | 167 +++++++++++++++------
 drivers/char/hw_random/bcm63xx-rng.c               | 154 -------------------
 6 files changed, 140 insertions(+), 241 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm6368.txt
 delete mode 100644 drivers/char/hw_random/bcm63xx-rng.c

-- 
2.9.3
