From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v5 0/4] crypto: Key Derivation Function (SP800-108)
Date: Tue, 09 Aug 2016 14:27:18 +0200
Message-ID: <2808589.gm6f519sFh@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34374 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbcHIM3G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 08:29:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

this patch set implements all three key derivation functions defined in
SP800-108.

The implementation is provided as a template for random number generators,
since a KDF can be considered a form of deterministic RNG where the key
material is used as a seed.

With the KDF implemented as a template, all types of keyed and
non-keyed hashes can be utilized, including HMAC and CMAC. The testmgr
tests are derived from publicly available test vectors from NIST.

The KDF are all tested with a complete round of CAVS testing on 32 and 64 bit.

The patch set introduces an extension to the kernel crypto API in the first
patch by adding a template handling for random number generators based on the
same logic as for keyed hashes.

Changes v5:
* move rng_instance and __crypto_rng_alg into rng.c

Changes v4:
* removal of the check that src and dst buffers are not the same from the KDF
  implementations as requested by Herbert
* implement and use new free API in the RNG instance handling as requested
  by Herbert
* move the instance handling code from include/crypto/rng.h to
  include/crypto/internal/rng.h

Changes v3:
* port testmgr patch to current cryptodev-2.6 tree
* add non-keyed KDF references to testmgr.c

Changes v2:
* port to 4.7-rc1

Stephan Mueller (4):
  crypto: add template handling for RNGs
  crypto: kdf - add known answer tests
  crypto: kdf - SP800-108 Key Derivation Function
  crypto: kdf - enable compilation

 crypto/Kconfig                |   7 +
 crypto/Makefile               |   1 +
 crypto/kdf.c                  | 508 ++++++++++++++++++++++++++++++++++++++++++
 crypto/rng.c                  |  44 ++++
 crypto/testmgr.c              | 226 +++++++++++++++++++
 crypto/testmgr.h              | 110 +++++++++
 include/crypto/internal/rng.h |  26 +++
 7 files changed, 922 insertions(+)
 create mode 100644 crypto/kdf.c

-- 
2.7.4
