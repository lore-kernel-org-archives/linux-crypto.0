From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 00/11] ARM: sun5i: cryptographic engine support
Date: Wed, 24 May 2017 21:06:41 +0200
Message-ID: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:50312 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937716AbdEXV1X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 17:27:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello all,

This series adds the cryptographic engine support to sun5i SoCs. This is
based on top of v4.12-rc1 and was tested on a CHIP. The series begins
with fixes and improvements. The series is available at:
https://github.com/atenart/linux v4.12-rc1/sun5i-crypto

The 8 first patches are reworks and cosmetic improvements.

Patch 9 moves the cipher part of the sun4i-ss driver from the ablkcipher
API to the newer skcipher API.

Patch 10 fixes the crypto framework selftests on the CHIP. It might fix
other users too.

Patch 11 adds a cryptographic engine node for sun5i SoCs.

Thanks,
Antoine

Antoine Tenart (11):
  crypto: sun4i-ss: group variable definitions in sun4i_hash()
  crypto: sun4i-ss: remove conditional checks against 0
  crypto: sun4i-ss: use lower/upper_32_bits helpers
  crypto: sun4i-ss: cannot use DMA is the request is 0 length
  crypto: sun4i-ss: do not dynamically set parts of the last buffer to 0
  crypto: sun4i-ss: simplify the pad length calculation
  crypto: sun4i-ss: simplify the appended bit assignment
  crypto: sun4i-ss: use GENMASK to generate masks
  crypto: sun4i-ss: move from ablkcipher to skcipher API
  crypto: sun4i-ss: fix large block size support
  ARM: sun5i: add a cryptographic engine node

 arch/arm/boot/dts/sun5i.dtsi              |   8 +
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 213 ++++++++++++++-------------
 drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 237 +++++++++++++++---------------
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c   | 138 ++++++++---------
 drivers/crypto/sunxi-ss/sun4i-ss.h        |  34 +++--
 5 files changed, 321 insertions(+), 309 deletions(-)

-- 
2.9.4
