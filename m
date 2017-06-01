From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v3 00/13] ARM: sun5i: cryptographic engine support
Date: Thu,  1 Jun 2017 21:38:52 +0200
Message-ID: <20170601193905.28829-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:46620 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdFATjl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2017 15:39:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This series adds the cryptographic engine support to sun5i SoCs. This is
based on top of v4.12-rc1 and was tested on a CHIP. The series begins
with fixes and improvements. The series is available at:
https://github.com/atenart/linux v4.12-rc1/sun5i-crypto

The 8 first patches are reworks and cosmetic improvements.

Patch 9 moves the cipher part of the sun4i-ss driver from the ablkcipher
API to the newer skcipher API.

Patch 10 adds the CRYPTO_ALG_KERN_DRIVER_ONLY flag for ciphers exposed
by the sun4i-ss driver.

Patch 11 fixes the crypto framework selftests on the CHIP. It might fix
other users too.

Patch 12 adds a cryptographic engine node for sun5i SoCs.

Patch 13 unify sunXi crypto nodes by adding SoC specific compatibles.

Thanks,
Antoine

Since v2:
  - Added Corentin's Acked-by and Tested-by to all sun4i-ss patches.
  - Added SoC specific compatibles for sunXi crypto nodes

Since v1:
  - Fixed a typo.
  - Made the CRYPTO_ALG_KERN_DRIVER_ONLY flag addition in a dedicated
    patch.

Antoine Tenart (13):
  crypto: sun4i-ss: group variable definitions in sun4i_hash()
  crypto: sun4i-ss: remove conditional checks against 0
  crypto: sun4i-ss: use lower/upper_32_bits helpers
  crypto: sun4i-ss: cannot use DMA is the request is 0 length
  crypto: sun4i-ss: do not dynamically set parts of the last buffer to 0
  crypto: sun4i-ss: simplify the pad length calculation
  crypto: sun4i-ss: simplify the appended bit assignment
  crypto: sun4i-ss: use GENMASK to generate masks
  crypto: sun4i-ss: move from ablkcipher to skcipher API
  crypto: sun4i-ss: add the CRYPTO_ALG_KERN_DRIVER_ONLY flag
  crypto: sun4i-ss: fix large block size support
  ARM: sun5i: add a cryptographic engine node
  ARM: dts: sunxi: add SoC specific compatibles for the crypto nodes

 arch/arm/boot/dts/sun5i.dtsi              |   9 ++
 arch/arm/boot/dts/sun6i-a31.dtsi          |   3 +-
 arch/arm/boot/dts/sun7i-a20.dtsi          |   3 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 213 ++++++++++++++-------------
 drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 237 +++++++++++++++---------------
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c   | 138 ++++++++---------
 drivers/crypto/sunxi-ss/sun4i-ss.h        |  34 +++--
 7 files changed, 326 insertions(+), 311 deletions(-)

-- 
2.9.4
