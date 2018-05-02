From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 00/10] crypto: inside-secure - AEAD support
Date: Wed,  2 May 2018 11:57:15 +0200
Message-ID: <20180502095725.31935-1-antoine.tenart@bootlin.com>
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

This series brings AEAD algorithms to the Inside Secure SafeXcel driver.
The first 7 commits rework the driver to allow the future AEAD addition,
and then 3 commits add AEAD functions and 3 algorithms.

This is based on top of v4.17-rc3.

Thanks!
Antoine

Antoine Tenart (10):
  crypto: aead - allow to allocate AEAD requests on the stack
  crypto: inside-secure - rework cipher functions for future AEAD
    support
  crypto: inside-secure - rework the alg type settings in the context
  crypto: inside-secure - make the context control size dynamic
  crypto: inside-secure - make the key and context size computation
    dynamic
  crypto: inside-secure - fix the hash then encrypt/decrypt types
  crypto: inside-secure - improve error reporting
  crypto: inside-secure - authenc(hmac(sha256),cbc(aes)) support
  crypto: inside-secure - authenc(hmac(sha224),cbc(aes)) support
  crypto: inside-secure - authenc(hmac(sha1),cbc(aes)) support

 drivers/crypto/Kconfig                        |   1 +
 drivers/crypto/inside-secure/safexcel.c       |  32 +
 drivers/crypto/inside-secure/safexcel.h       |  33 +-
 .../crypto/inside-secure/safexcel_cipher.c    | 642 ++++++++++++++----
 drivers/crypto/inside-secure/safexcel_hash.c  |  21 +-
 include/crypto/aead.h                         |   5 +
 6 files changed, 593 insertions(+), 141 deletions(-)

-- 
2.17.0
