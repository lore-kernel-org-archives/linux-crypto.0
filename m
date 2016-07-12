From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 0/4] crypto: Key Derivation Function (SP800-108)
Date: Tue, 12 Jul 2016 11:06:28 +0200
Message-ID: <1517551.AxEWRg6eD0@positron.chronox.de>
References: <4161793.TTVXSVQtZL@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39026 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbcGLJJY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 05:09:24 -0400
In-Reply-To: <4161793.TTVXSVQtZL@positron.chronox.de>
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

 crypto/Kconfig       |   7 +
 crypto/Makefile      |   1 +
 crypto/kdf.c         | 514 +++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/rng.c         |  31 ++++
 crypto/testmgr.c     | 226 ++++++++++++++++++++++
 crypto/testmgr.h     | 110 +++++++++++
 include/crypto/rng.h |  39 ++++
 7 files changed, 928 insertions(+)
 create mode 100644 crypto/kdf.c

-- 
2.7.4
