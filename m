From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 00/16] crypto: restrict usage of helper ciphers
Date: Thu, 19 Mar 2015 07:55:08 +0100
Message-ID: <21952258.n2qYaab1Is@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46745 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbbCSHLS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Mar 2015 03:11:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Based on the discussion in the thread [1], a flag is added to the
kernel crypto API to allow ciphers to be marked as internal.

The patch set is tested in FIPS and non-FIPS mode. In addition,
the enforcement that the helper cipher of __driver-gcm-aes-aesni
cannot be loaded, but the wrapper of rfc4106-gcm-aesni can be used
is tested to demonstrate that the patch works. The testing also shows
that of__driver-gcm-aes-aesni is subject to the testmgr self test an
can therefore be used in FIPS mode.

All cipher implementation whose definition has a cra_priority of 0
are marked as internal ciphers to prevent them from being called by
users.

The testing also includes the invocation of normal crypto operations
from user space via AF_ALG and libkcapi showing that all of them work
unaffected.

[1] http://comments.gmane.org/gmane.linux.kernel.cryptoapi/13705

Stephan Mueller (16):
  crypto: prevent helper ciphers from being used
  crypto: /proc/crypto: identify internal ciphers
  crypto: mark AES-NI helper ciphers
  crypto: mark AES-NI Camellia helper ciphers
  crypto: mark CAST5 helper ciphers
  crypto: mark AVX Camellia helper ciphers
  crypto: mark CAST6 helper ciphers
  crypto: mark ghash clmulni helper ciphers
  crypto: mark Serpent AVX2 helper ciphers
  crypto: mark Serpent AVX helper ciphers
  crypto: mark Serpent SSE2 helper ciphers
  crypto: mark Twofish AVX helper ciphers
  crypto: mark NEON bit sliced AES helper ciphers
  crypto: mark ARMv8 AES helper ciphers
  crypto: mark GHASH ARMv8 vmull.p64 helper ciphers
  crypto: mark 64 bit ARMv8 AES helper ciphers

 arch/arm/crypto/aes-ce-glue.c              | 12 ++++++++----
 arch/arm/crypto/aesbs-glue.c               |  9 ++++++---
 arch/arm/crypto/ghash-ce-glue.c            |  2 +-
 arch/arm64/crypto/aes-glue.c               | 12 ++++++++----
 arch/x86/crypto/aesni-intel_glue.c         | 19 ++++++++++++-------
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 15 ++++++++++-----
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 15 ++++++++++-----
 arch/x86/crypto/cast5_avx_glue.c           |  9 ++++++---
 arch/x86/crypto/cast6_avx_glue.c           | 15 ++++++++++-----
 arch/x86/crypto/ghash-clmulni-intel_glue.c |  3 ++-
 arch/x86/crypto/serpent_avx2_glue.c        | 15 ++++++++++-----
 arch/x86/crypto/serpent_avx_glue.c         | 15 ++++++++++-----
 arch/x86/crypto/serpent_sse2_glue.c        | 15 ++++++++++-----
 arch/x86/crypto/twofish_avx_glue.c         | 15 ++++++++++-----
 crypto/ablkcipher.c                        |  2 +-
 crypto/aead.c                              |  2 +-
 crypto/api.c                               | 21 ++++++++++++++++++++-
 crypto/internal.h                          |  2 ++
 crypto/proc.c                              |  3 +++
 include/linux/crypto.h                     |  6 ++++++
 20 files changed, 146 insertions(+), 61 deletions(-)

-- 
2.1.0
