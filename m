From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v2 0/8] Add support for SafeXcel IP-76 to OMAP RNG
Date: Wed,  7 Sep 2016 17:57:35 +0200
Message-ID: <20160907155743.6403-1-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Romain Perier <romain.perier@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org
To: dsaxena@plexity.net, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:42854 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751304AbcIGP5u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 11:57:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The driver omap-rng has a lot of similarity with the IP block SafeXcel
IP-76. A lot of registers are the same and the way that the driver works
is very closed the description of the TRNG EIP76 in its datasheet.

This series refactorize the driver, add support for generating bigger
output random data and add a device variant for SafeXcel IP-76, found
in Armada 8K.

Romain Perier (8):
  dt-bindings: Add vendor prefix for INSIDE Secure
  dt-bindings: omap-rng: Document SafeXcel IP-76 device variant
  hwrng: omap - Switch to non-obsolete read API implementation
  hwrng: omap - Remove global definition of hwrng
  hwrng: omap - Add support for 128-bit output of data
  hwrng: omap - Don't prefix the probe message with OMAP
  hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K
  arm64: dts: marvell: add TRNG description for Armada 8K CP

 Documentation/devicetree/bindings/rng/omap_rng.txt |  14 +-
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 .../boot/dts/marvell/armada-cp110-master.dtsi      |   8 ++
 .../arm64/boot/dts/marvell/armada-cp110-slave.dtsi |   8 ++
 drivers/char/hw_random/Kconfig                     |   2 +-
 drivers/char/hw_random/omap-rng.c                  | 160 +++++++++++++++------
 6 files changed, 147 insertions(+), 46 deletions(-)

-- 

Changes in v2:
 - Removed the patch introducing device resources managed API for registration

2.9.3
