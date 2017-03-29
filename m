From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 0/7] arm64: marvell: add cryptographic engine support for 7k/8k
Date: Wed, 29 Mar 2017 14:44:25 +0200
Message-ID: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36269 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932147AbdC2Moo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Mar 2017 08:44:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

This series adds support for the Inside Secure SafeXcel EIP197
cryptographic engine which can be found on Marvell Armada 7k and 8k
boards. A new cryptographic engine driver is added, as well as the
relevant device tree definition for the Armada 7040 DB and 8040 DB
boards.

This driver needs two firmwares to work correctly. These firmware are
usually used for more advanced operations than the ones supported (as of
now), but we still need them to pass the data to the internal
cryptographic engine.

This series was tested in various ways on both the Armada 7040 DB and
the Armada 8040 DB: using the crypto framework self tests, using tcrypt
and while performing various transfers with iperf on top of IPsec.

This series is based on top of v4.11-rc1, and is available on a branch
(which also contains the PPv2 support for 7k/8k, to ease the process of
testing IPsec): https://github.com/atenart/linux  v4.11-rc1/7k8k-crypto
I can rebase if needed.

Thanks,
Antoine


Antoine Tenart (7):
  Documentation/bindings: Document the SafeXel cryptographic engine
    driver
  crypto: inside-secure: add SafeXcel EIP197 crypto engine driver
  MAINTAINERS: add a maintainer for the Inside Secure crypto driver
  arm64: marvell: dts: add crypto engine description for 7k/8k
  arm64: marvell: dts: enable the crypto engine on the Armada 7040 DB
  arm64: marvell: dts: enable the crypto engine on the Armada 8040 DB
  arm64: defconfig: enable the Safexcel crypto engine as a module

 .../bindings/crypto/inside-secure-safexcel.txt     |   27 +
 MAINTAINERS                                        |    6 +
 arch/arm64/boot/dts/marvell/armada-7040-db.dts     |    4 +
 arch/arm64/boot/dts/marvell/armada-8040-db.dts     |    4 +
 .../boot/dts/marvell/armada-cp110-master.dtsi      |   15 +
 .../arm64/boot/dts/marvell/armada-cp110-slave.dtsi |   15 +
 arch/arm64/configs/defconfig                       |    1 +
 drivers/crypto/Kconfig                             |   17 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/inside-secure/Makefile              |    2 +
 drivers/crypto/inside-secure/safexcel.c            |  939 ++++++++++++++++++
 drivers/crypto/inside-secure/safexcel.h            |  581 +++++++++++
 drivers/crypto/inside-secure/safexcel_cipher.c     |  544 ++++++++++
 drivers/crypto/inside-secure/safexcel_hash.c       | 1045 ++++++++++++++++++++
 drivers/crypto/inside-secure/safexcel_ring.c       |  173 ++++
 15 files changed, 3374 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
 create mode 100644 drivers/crypto/inside-secure/Makefile
 create mode 100644 drivers/crypto/inside-secure/safexcel.c
 create mode 100644 drivers/crypto/inside-secure/safexcel.h
 create mode 100644 drivers/crypto/inside-secure/safexcel_cipher.c
 create mode 100644 drivers/crypto/inside-secure/safexcel_hash.c
 create mode 100644 drivers/crypto/inside-secure/safexcel_ring.c

-- 
2.11.0
