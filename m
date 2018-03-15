From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 00/12] crypto: inside-secure - hmac(sha256/sha224) support
Date: Thu, 15 Mar 2018 16:38:39 +0100
Message-ID: <20180315153851.9958-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

This series brings hmac(sha256) and hmac(sha224) support to the Inside
Secure cryptographic engine driver.

The first 10 patches are fixes and reworks needed for the hmac(sha256)
and hmac(224) support to land in. Then 2 patches adds the 2 new
algorithms.

This has been tested with boot tests, tcrypt and IPsec traffic. This
series is a preparation series for more algorithms support (so that
the series are smaller and easier to review).

Thanks,
Antoine

Antoine Tenart (11):
  crypto: inside-secure - move cache result dma mapping to request
  crypto: inside-secure - wait for the request to complete if in the
    backlog
  crypto: inside-secure - move the digest to the request context
  crypto: inside-secure - fix typo s/allways/always/ in a define
  crypto: inside-secure - fix a typo in a register name
  crypto: inside-secure - improve the send error path
  crypto: inside-secure - do not access buffers mapped to the device
  crypto: inside-secure - improve the skcipher token
  crypto: inside-secure - the context ipad/opad should use the state sz
  crypto: inside-secure - hmac(sha256) support
  crypto: inside-secure - hmac(sha224) support

Ofer Heifetz (1):
  crypto: inside-secure - move hash result dma mapping to request

 drivers/crypto/inside-secure/safexcel.c        |  27 +--
 drivers/crypto/inside-secure/safexcel.h        |  15 +-
 drivers/crypto/inside-secure/safexcel_cipher.c |   3 +-
 drivers/crypto/inside-secure/safexcel_hash.c   | 248 +++++++++++++++++++------
 4 files changed, 200 insertions(+), 93 deletions(-)

-- 
2.14.3
