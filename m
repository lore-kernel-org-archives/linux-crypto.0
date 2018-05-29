From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 00/10] crypto: inside-secure - sha512/384 support
Date: Tue, 29 May 2018 14:13:42 +0200
Message-ID: <20180529121352.19490-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Herbert,

This series adds support for the SHA512 and SHA384 algorithms in the
Inside Secure SafeXcel driver. Variants of those two algorithms are also
added as well (hmac, and AEAD).

Before doing so a few patches rework the driver to prepare for the new
algorithms additions.

Thanks!
Antoine

Antoine Tenart (10):
  crypto: inside-secure - use the error handler for invalidation
    requests
  crypto: inside-secure - improve the counter computation
  crypto: sha512_generic - add a sha512 0-length pre-computed hash
  crypto: inside-secure - sha512 support
  crypto: inside-secure - hmac(sha512) support
  crypto: inside-secure - authenc(hmac(sha512),cbc(aes)) support
  crypto: sha512_generic - add a sha384 0-length pre-computed hash
  crypto: inside-secure - sha384 support
  crypto: inside-secure - hmac(sha384) support
  crypto: inside-secure - authenc(hmac(sha384),cbc(aes)) support

 crypto/sha512_generic.c                       |  22 +
 drivers/crypto/inside-secure/safexcel.c       |   6 +
 drivers/crypto/inside-secure/safexcel.h       |  23 +-
 .../crypto/inside-secure/safexcel_cipher.c    |  89 +++-
 drivers/crypto/inside-secure/safexcel_hash.c  | 381 ++++++++++++++++--
 include/crypto/sha.h                          |   4 +
 6 files changed, 469 insertions(+), 56 deletions(-)

-- 
2.17.0
