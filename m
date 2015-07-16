From: Martin Willi <martin@strongswan.org>
Subject: [PATCH v2 00/10] crypto: x86_64 - Add SSE/AVX2 ChaCha20/Poly1305 ciphers
Date: Thu, 16 Jul 2015 19:13:58 +0200
Message-ID: <1437066848-18048-1-git-send-email-martin@strongswan.org>
Cc: x86@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:45590 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbbGPROX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jul 2015 13:14:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series adds both ChaCha20 and Poly1305 specific ciphers for
x86_64 using SSE2/SSSE3 and AVX2 instructions. The idea is to have a drop-in
replacement for AESNI/CLMUL-accelerated AES-GCM providing at least somewhat
comparable performance, refer to RFC7539 for details. It is based on cryptodev,
including the ChaCha20/Poly1305 AEAD interface conversion patch.

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

generic:
testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-generic,poly1305-generic)) encryption
test 0 (288 bit key, 16 byte blocks): 10456041 operations in 10 seconds (167296656 bytes)
test 1 (288 bit key, 64 byte blocks): 9999411 operations in 10 seconds (639962304 bytes)
test 2 (288 bit key, 256 byte blocks): 5793012 operations in 10 seconds (1483011072 bytes)
test 3 (288 bit key, 512 byte blocks): 3743676 operations in 10 seconds (1916762112 bytes)
test 4 (288 bit key, 1024 byte blocks): 2190023 operations in 10 seconds (2242583552 bytes)
test 5 (288 bit key, 2048 byte blocks): 1195864 operations in 10 seconds (2449129472 bytes)
test 6 (288 bit key, 4096 byte blocks): 627625 operations in 10 seconds (2570752000 bytes)
test 7 (288 bit key, 8192 byte blocks): 319844 operations in 10 seconds (2620162048 bytes)

SSE2/SSSE3:
testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-simd,poly1305-simd)) encryption
test 0 (288 bit key, 16 byte blocks): 10077910 operations in 10 seconds (161246560 bytes)
test 1 (288 bit key, 64 byte blocks): 9990400 operations in 10 seconds (639385600 bytes)
test 2 (288 bit key, 256 byte blocks): 7953774 operations in 10 seconds (2036166144 bytes)
test 3 (288 bit key, 512 byte blocks): 6351059 operations in 10 seconds (3251742208 bytes)
test 4 (288 bit key, 1024 byte blocks): 4593059 operations in 10 seconds (4703292416 bytes)
test 5 (288 bit key, 2048 byte blocks): 2956300 operations in 10 seconds (6054502400 bytes)
test 6 (288 bit key, 4096 byte blocks): 1724958 operations in 10 seconds (7065427968 bytes)
test 7 (288 bit key, 8192 byte blocks): 925156 operations in 10 seconds (7578877952 bytes)

AVX2:
testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-simd,poly1305-simd)) encryption
test 0 (288 bit key, 16 byte blocks): 10006774 operations in 10 seconds (160108384 bytes)
test 1 (288 bit key, 64 byte blocks): 9896498 operations in 10 seconds (633375872 bytes)
test 2 (288 bit key, 256 byte blocks): 7922198 operations in 10 seconds (2028082688 bytes)
test 3 (288 bit key, 512 byte blocks): 7261666 operations in 10 seconds (3717972992 bytes)
test 4 (288 bit key, 1024 byte blocks): 5835006 operations in 10 seconds (5975046144 bytes)
test 5 (288 bit key, 2048 byte blocks): 4172937 operations in 10 seconds (8546174976 bytes)
test 6 (288 bit key, 4096 byte blocks): 2670484 operations in 10 seconds (10938302464 bytes)
test 7 (288 bit key, 8192 byte blocks): 1504684 operations in 10 seconds (12326371328 bytes)

All benchmark results from a Core i5-4670T.

The ChaCha20/Poly1305 AEAD on Haswell with AVX2 has about half the raw
AESNI/CLMUL-accelerated AES-GCM (rfc4106-gcm-aesni) performance for typical
IPsec MTUs. On Ivy Bridge using SSE2/SSSE3 the numbers compared to AES-GCM
are very similar due to the less efficient CLMUL instructions.

Changes in v2:
- No code changes
- Use sec=10 for more reliable benchmark results

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
