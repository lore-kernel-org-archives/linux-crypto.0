From: Martin Willi <martin@strongswan.org>
Subject: [PATCH 00/10] crypto: x86_64 - Add SSE/AVX2 ChaCha20/Poly1305 ciphers
Date: Tue,  7 Jul 2015 21:36:46 +0200
Message-ID: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Cc: x86@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:44655 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933245AbbGGThU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 15:37:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series adds both ChaCha20 and Poly1305 specific ciphers for
x86_64 using SSE2/SSSE3 and AVX2 instructions. The idea is to have a drop-in
replacement for AESNI/CLMUL-accelerated AES-GCM providing at least somewhat
comparable performance, refer to RFC7539 for details. It is based
on cryptodev.

The first patch adds some speed tests to tcrypt. The second patch exports
some functionality from chacha20-generic to use it as fallback. Patch 3
adds a single block SSSE3 driver for ChaCha20, while patch 4 and 5 extend it
by an optimized four block SSSE3 and an eight block AVX2 variant. Patch 6
adds an additional test vector for ChaCha20 to actually test the AVX2 eight
block variant processing 512-bytes at once.

Patch 7 exports some poly1305-generic functionality to use it as fallback.
Patch 8 introduces a single block SSE2 driver for Poly1305, while patch 9
and 10 add an optimized two block SSE2 and a four block AVX2 variant.

Overall speedup for the ChaCha20/Poly1305 AEAD for typical IPsec payloads
is ~50-150% with SSE2/SSSE3 and ~100-200% with AVX2, or even more for larger
payloads:

poly1305-generic:
testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-generic,poly1305-generic)) encryption
test 0 (288 bit key, 16 byte blocks): 902007 operations in 1 seconds (14432112 bytes)
test 1 (288 bit key, 64 byte blocks): 945302 operations in 1 seconds (60499328 bytes)
test 2 (288 bit key, 256 byte blocks): 559910 operations in 1 seconds (143336960 bytes)
test 3 (288 bit key, 512 byte blocks): 365334 operations in 1 seconds (187051008 bytes)
test 4 (288 bit key, 1024 byte blocks): 213663 operations in 1 seconds (218790912 bytes)
test 5 (288 bit key, 2048 byte blocks): 117263 operations in 1 seconds (240154624 bytes)
test 6 (288 bit key, 4096 byte blocks): 61915 operations in 1 seconds (253603840 bytes)
test 7 (288 bit key, 8192 byte blocks): 31662 operations in 1 seconds (259375104 bytes)

SSE2/SSSE3:
testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-simd,poly1305-simd)) encryption
test 0 (288 bit key, 16 byte blocks): 945909 operations in 1 seconds (15134544 bytes)
test 1 (288 bit key, 64 byte blocks): 945702 operations in 1 seconds (60524928 bytes)
test 2 (288 bit key, 256 byte blocks): 759759 operations in 1 seconds (194498304 bytes)
test 3 (288 bit key, 512 byte blocks): 609356 operations in 1 seconds (311990272 bytes)
test 4 (288 bit key, 1024 byte blocks): 445479 operations in 1 seconds (456170496 bytes)
test 5 (288 bit key, 2048 byte blocks): 289479 operations in 1 seconds (592852992 bytes)
test 6 (288 bit key, 4096 byte blocks): 170082 operations in 1 seconds (696655872 bytes)
test 7 (288 bit key, 8192 byte blocks): 91443 operations in 1 seconds (749101056 bytes)

AVX2:
testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-simd,poly1305-simd)) encryption
test 0 (288 bit key, 16 byte blocks): 896305 operations in 1 seconds (14340880 bytes)
test 1 (288 bit key, 64 byte blocks): 929638 operations in 1 seconds (59496832 bytes)
test 2 (288 bit key, 256 byte blocks): 750673 operations in 1 seconds (192172288 bytes)
test 3 (288 bit key, 512 byte blocks): 687636 operations in 1 seconds (352069632 bytes)
test 4 (288 bit key, 1024 byte blocks): 555209 operations in 1 seconds (568534016 bytes)
test 5 (288 bit key, 2048 byte blocks): 402049 operations in 1 seconds (823396352 bytes)
test 6 (288 bit key, 4096 byte blocks): 259861 operations in 1 seconds (1064390656 bytes)
test 7 (288 bit key, 8192 byte blocks): 147283 operations in 1 seconds (1206542336 bytes)

All benchmark results from a Core i5-4670T.

The ChaCha20/Poly1305 AEAD on Haswell with AVX2 has about half the raw
AESNI/CLMUL-accelerated AES-GCM (rfc4106-gcm-aesni) performance for typical
IPsec MTUs. On Ivy Bridge using SSE2/SSSE3 the numbers compared to AES-GCM
are very similar due to the less efficient CLMUL instructions.

Martin Willi (10):
  crypto: tcrypt - Add ChaCha20/Poly1305 speed tests
  crypto: chacha20 - Export common ChaCha20 helpers
  crypto: chacha20 - Add a SSSE3 SIMD variant for x86_64
  crypto: chacha20 - Add a four block SSSE3 variant for x86_64
  crypto: chacha20 - Add an eight block AVX2 variant for x86_64
  crypto: testmgr - Add a longer ChaCha20 test vector
  crypto: poly1305 - Export common Poly1305 helpers
  crypto: poly1305 - Add a SSE2 SIMD variant for x86_64
  crypto: poly1305 - Add a two block SSE2 variant for x86_64
  crypto: poly1305 - Add a four block AVX2 variant for x86_64

 arch/x86/crypto/Makefile                |   6 +
 arch/x86/crypto/chacha20-avx2-x86_64.S  | 443 ++++++++++++++++++++++
 arch/x86/crypto/chacha20-ssse3-x86_64.S | 625 ++++++++++++++++++++++++++++++++
 arch/x86/crypto/chacha20_glue.c         | 150 ++++++++
 arch/x86/crypto/poly1305-avx2-x86_64.S  | 386 ++++++++++++++++++++
 arch/x86/crypto/poly1305-sse2-x86_64.S  | 582 +++++++++++++++++++++++++++++
 arch/x86/crypto/poly1305_glue.c         | 207 +++++++++++
 crypto/Kconfig                          |  27 ++
 crypto/chacha20_generic.c               |  28 +-
 crypto/chacha20poly1305.c               |   7 +-
 crypto/poly1305_generic.c               |  73 ++--
 crypto/tcrypt.c                         |  15 +
 crypto/tcrypt.h                         |  20 +
 crypto/testmgr.h                        | 334 ++++++++++++++++-
 include/crypto/chacha20.h               |  25 ++
 include/crypto/poly1305.h               |  41 +++
 16 files changed, 2909 insertions(+), 60 deletions(-)
 create mode 100644 arch/x86/crypto/chacha20-avx2-x86_64.S
 create mode 100644 arch/x86/crypto/chacha20-ssse3-x86_64.S
 create mode 100644 arch/x86/crypto/chacha20_glue.c
 create mode 100644 arch/x86/crypto/poly1305-avx2-x86_64.S
 create mode 100644 arch/x86/crypto/poly1305-sse2-x86_64.S
 create mode 100644 arch/x86/crypto/poly1305_glue.c
 create mode 100644 include/crypto/chacha20.h
 create mode 100644 include/crypto/poly1305.h

--
1.9.1
