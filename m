From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 00/14] crypto: inside-secure - EIP197d support
Date: Thu, 28 Jun 2018 17:15:30 +0200
Message-ID: <20180628151544.22134-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, oferh@marvell.com,
        igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        gregory.clement@bootlin.com, andrew@lunn.ch, jason@lakedaemon.net,
        sebastian.hesselbarth@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi all,

This series introduces the EIP197d engine support to the Inside Secure
SafeXcel cryptographic engine driver.

In order to support this new engine, the driver has to be reworked in
some ways:
- The firmwares are specific to a given version of an EIP engine: they
  must be stored in a version specific folder.
- The compatibles have to be reworked, to denote the exact version of
  the engine being used. Note that we kept the backward compatibility.
- Not all algorithms are supported by all versions of the EIP engine.

Some improvements were also made to the driver, to fully embrace the
capabilities of this new EIP197d engine, and to improve the existing
support.

Please note the DT patches (13/14 and 14/14) should go through the mvebu
tree.

Thanks!
Antoine

Antoine Tenart (9):
  crypto: inside-secure - move the firmware to a better location
  crypto: inside-secure - use precise compatibles
  Documentation/bindings: crypto: inside-secure: update the compatibles
  crypto: inside-secure - filter out the algorithms by engine
  crypto: inside-secure - add an invalidation flag
  crypto: inside-secure - eip197d support
  Documentation/bindings: crypto: inside-secure: eip197d support
  arm64: dts: marvell: armada-cp110: update the crypto engine compatible
  arm64: dts: marvell: armada-37xx: update the crypto engine compatible

Ofer Heifetz (5):
  crypto: inside-secure - dynamic ring configuration allocation
  crypto: inside-secure - add multiple processing engine support
  crypto: inside-secure - adjust the TRC configuration for EIP197D
  crypto: inside-secure - reset CDR and RDR rings on module removal
  crypto: inside-secure - set tx_max_cmd_queue to 32

 .../crypto/inside-secure-safexcel.txt         |  15 +-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi  |   2 +-
 arch/arm64/boot/dts/marvell/armada-cp110.dtsi |   2 +-
 drivers/crypto/inside-secure/safexcel.c       | 363 ++++++++++++------
 drivers/crypto/inside-secure/safexcel.h       | 136 ++++---
 .../crypto/inside-secure/safexcel_cipher.c    |  23 +-
 drivers/crypto/inside-secure/safexcel_hash.c  |  18 +-
 drivers/crypto/inside-secure/safexcel_ring.c  |  10 +-
 8 files changed, 370 insertions(+), 199 deletions(-)

-- 
2.17.1
