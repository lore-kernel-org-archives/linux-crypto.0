From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 00/20] crypto: restrict usage of helper ciphers
Date: Fri, 27 Mar 2015 23:49:13 +0100
Message-ID: <1746748.uPZFXamDiM@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
as well as the ciphers that are wrapped by cryptd and mcryptd
are marked as internal ciphers to prevent them from being called by
users.

The testing also includes the invocation of normal crypto operations
from user space via AF_ALG and libkcapi showing that all of them work
unaffected.

[1] http://comments.gmane.org/gmane.linux.kernel.cryptoapi/13705

Changes v2:
* Overhaul enforcement of the internal flag as suggested by Herbert:
  a cipher marked as internal can only be invoked if the caller
  instantiates it with the internal flag set in the type and mask
  field.
* The overhaul implies that cryptd and mcryptd instances are marked
  as internal if the underlying cipher is marked as internal.
* The overhaul implies that the testmgr must try to allocate a
  cipher again with the internal flag in case the first allocation
  failed with -ENOENT.
* Mark internal cipher in arch/x86/crypto/sha-mb/sha1_mb.c.

Stephan Mueller (20):
  crypto: prevent helper ciphers from being used
  crypto: testmgr to use CRYPTO_ALG_INTERNAL
  crypto: cryptd to process CRYPTO_ALG_INTERNAL
  crypto: /proc/crypto: identify internal ciphers
  crypto: mark AES-NI helper ciphers
  crypto: mark ghash clmulni helper ciphers
  crypto: mark GHASH ARMv8 vmull.p64 helper ciphers
  crypto: mark AES-NI Camellia helper ciphers
  crypto: mark CAST5 helper ciphers
  crypto: mark AVX Camellia helper ciphers
  crypto: mark CAST6 helper ciphers
  crypto: mark Serpent AVX2 helper ciphers
  crypto: mark Serpent AVX helper ciphers
  crypto: mark Serpent SSE2 helper ciphers
  crypto: mark Twofish AVX helper ciphers
  crypto: mark NEON bit sliced AES helper ciphers
  crypto: mark ARMv8 AES helper ciphers
  crypto: mark 64 bit ARMv8 AES helper ciphers
  crypto: mcryptd to process CRYPTO_ALG_INTERNAL
  crypto: mark Multi buffer SHA1 helper cipher

 arch/arm/crypto/aes-ce-glue.c              | 12 +++++---
 arch/arm/crypto/aesbs-glue.c               |  9 ++++--
 arch/arm/crypto/ghash-ce-glue.c            |  6 ++--
 arch/arm64/crypto/aes-glue.c               | 12 +++++---
 arch/x86/crypto/aesni-intel_glue.c         | 23 +++++++++-----
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 15 ++++++---
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 15 ++++++---
 arch/x86/crypto/cast5_avx_glue.c           |  9 ++++--
 arch/x86/crypto/cast6_avx_glue.c           | 15 ++++++---
 arch/x86/crypto/ghash-clmulni-intel_glue.c |  7 +++--
 arch/x86/crypto/serpent_avx2_glue.c        | 15 ++++++---
 arch/x86/crypto/serpent_avx_glue.c         | 15 ++++++---
 arch/x86/crypto/serpent_sse2_glue.c        | 15 ++++++---
 arch/x86/crypto/sha-mb/sha1_mb.c           |  7 +++--
 arch/x86/crypto/twofish_avx_glue.c         | 15 ++++++---
 crypto/ablk_helper.c                       |  3 +-
 crypto/api.c                               |  6 ++++
 crypto/cryptd.c                            | 49 +++++++++++++++++++++++++-----
 crypto/mcryptd.c                           | 25 +++++++++++++--
 crypto/proc.c                              |  3 ++
 crypto/testmgr.c                           | 22 ++++++++++++++
 include/linux/crypto.h                     |  6 ++++
 22 files changed, 230 insertions(+), 74 deletions(-)

-- 
2.1.0
