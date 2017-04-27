From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v4 0/3] arm64: marvell: add cryptographic engine support for 7k/8k
Date: Thu, 27 Apr 2017 15:24:56 +0200
Message-ID: <20170427132459.23159-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:39588 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034219AbdD0NZW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Apr 2017 09:25:22 -0400
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
I can rebase if needed. Patches adding device tree nodes and modifying
the arm64 defconfig have been applied to the mvebu tree already.

I'd like to thank Ofer Heifetz and Igal Liberman who helped me to do
this driver by adding functionalities, optimizing functions and testing
(a lot).

Thanks,
Antoine

Since v3:
  - Updated to use the skcipher API instead of the ablkcipher one.
  - Added explicit zeroing of the keys.
  - Fixed the DMA mask.
  - Removed a few remaining phys_addr_t.

Since v2:
  - Used sha*_zero_message_hash definitions instead of custom ones.
  - Used memzero_explicit() instead of memset() to avoid leaks.
  - Misc cosmetic updates.

Since v1:
  - Fixed two compilation issues reported by Kbuild.
  - Removed all dma_to_phys() calls and used the dma addresses instead.
  - Added a call to dma_set_mask_and_coherent() before calling any DMA
    API helper.
  - Removed some DMA free functions to avoid double-freeing.
  - Do not rely on sg_nents_for_len() to get the number of sg anymore.
  - Added a dedicated kmalloc'ed cache to use for dma_map_single().

Antoine Tenart (3):
  Documentation/bindings: Document the SafeXel cryptographic engine
    driver
  crypto: inside-secure: add SafeXcel EIP197 crypto engine driver
  MAINTAINERS: add a maintainer for the Inside Secure crypto driver

 .../bindings/crypto/inside-secure-safexcel.txt     |   27 +
 MAINTAINERS                                        |    6 +
 drivers/crypto/Kconfig                             |   17 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/inside-secure/Makefile              |    2 +
 drivers/crypto/inside-secure/safexcel.c            |  927 +++++++++++++++++
 drivers/crypto/inside-secure/safexcel.h            |  572 +++++++++++
 drivers/crypto/inside-secure/safexcel_cipher.c     |  556 +++++++++++
 drivers/crypto/inside-secure/safexcel_hash.c       | 1045 ++++++++++++++++++++
 drivers/crypto/inside-secure/safexcel_ring.c       |  157 +++
 10 files changed, 3310 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
 create mode 100644 drivers/crypto/inside-secure/Makefile
 create mode 100644 drivers/crypto/inside-secure/safexcel.c
 create mode 100644 drivers/crypto/inside-secure/safexcel.h
 create mode 100644 drivers/crypto/inside-secure/safexcel_cipher.c
 create mode 100644 drivers/crypto/inside-secure/safexcel_hash.c
 create mode 100644 drivers/crypto/inside-secure/safexcel_ring.c

-- 
2.11.0
