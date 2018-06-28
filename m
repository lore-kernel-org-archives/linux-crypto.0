From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 0/5] crypto: inside-secure - support more algorithms
Date: Thu, 28 Jun 2018 17:21:52 +0200
Message-ID: <20180628152157.23769-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi all,

This series adds support for more algorithms in the Inside Secure
SafeXcel cryptographic engine driver. Those new algorithms are:
- MD5 (and its hmac).
- DES (ECB and CBC).
- 3DES (ECB and CBC).

The last patch was made on top of the algorithm additions, to enhance
the driver's performances.

This series should be applied on top of another one:
https://lkml.org/lkml/2018/6/28/516

Thanks!
Antoine

Ofer Heifetz (5):
  crypto: inside-secure - md5 support
  crypto: inside-secure - hmac(md5) support
  crypto: inside-secure - ecb(des) and cbc(des) support
  crypto: inside-secure - ecb(des3_ede) and cbc(des3_ede) support
  crypto: inside-secure - remove request list to improve performance

 drivers/crypto/Kconfig                        |   2 +
 drivers/crypto/inside-secure/safexcel.c       | 100 ++---
 drivers/crypto/inside-secure/safexcel.h       |  41 +-
 .../crypto/inside-secure/safexcel_cipher.c    | 369 ++++++++++++++----
 drivers/crypto/inside-secure/safexcel_hash.c  | 157 ++++++--
 drivers/crypto/inside-secure/safexcel_ring.c  |  48 ++-
 6 files changed, 553 insertions(+), 164 deletions(-)

-- 
2.17.1
