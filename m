From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 0/4] crypto: Key Derivation Function (SP800-108)
Date: Tue, 26 Jan 2016 07:19:17 +0100
Message-ID: <4445045.XP4c23S4mB@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42518 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396AbcAZGWE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 01:22:04 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

this patch set implements all three key derivation functions defined in
SP800-108.

The implementation is provided as a template for random number generators,
since a KDF can be considered a form of deterministic RNG where the key
material is used as a seed.

With the KDF implemented as a template, all types of keyed hashes can be
utilized, including HMAC and CMAC. The testmgr tests are derived from
publicly available test vectors from NIST.

The KDF are all tested with a complete round of CAVS testing on 32 and 64 bit.

The patch set introduces an extension to the kernel crypto API in the first
patch by adding a template handling for random number generators based on the
same logic as for keyed hashes.

Stephan Mueller (4):
  crypto: add template handling for RNGs
  crypto: kdf - add known answer tests
  crypto: kdf - SP800-108 Key Derivation Function
  crypto: kdf - enable compilation

 crypto/Kconfig       |   7 +
 crypto/Makefile      |   1 +
 crypto/kdf.c         | 514 +++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/rng.c         |  31 ++++
 crypto/testmgr.c     | 167 +++++++++++++++++
 crypto/testmgr.h     | 111 +++++++++++
 include/crypto/rng.h |  39 ++++
 7 files changed, 870 insertions(+)
 create mode 100644 crypto/kdf.c

-- 
2.5.0
