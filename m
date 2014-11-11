From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 0/2] crypto: zeroization of buffers
Date: Tue, 11 Nov 2014 05:36:16 +0100
Message-ID: <1503070.D5VR9iy8Cm@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: 'Sandy Harris' <sandyinchina@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

as discussed, these patches use the memzero_explicit function that is
yet to be integrated into the cryptodev-2.6 tree.

Stephan Mueller (2):
  crypto: AF_ALG - zeroize message digest buffer
  crypto: AF_ALG - zeroize IV buffer

 crypto/algif_hash.c     | 2 ++
 crypto/algif_skcipher.c | 1 +
 2 files changed, 3 insertions(+)

-- 
2.1.0
