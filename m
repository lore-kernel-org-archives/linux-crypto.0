Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbeK3KKd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Nov 2018 05:10:33 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Martin Willi <martin@strongswan.org>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] crypto: x86_64 optimized XChaCha and NHPoly1305 (for Adiantum)
Date: Thu, 29 Nov 2018 15:02:11 -0800
Message-Id: <20181129230217.158038-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This series optimizes the Adiantum encryption mode for x86_64 by adding
SSE2 and AVX2 accelerated implementations of NHPoly1305, specifically
the NH part; and by modifying the existing x86_64 SSSE3/AVX2/AVX-512VL
ChaCha20 implementation to support XChaCha20 and XChaCha12.

This greatly improves Adiantum performance on x86_64.  

For example, encrypting 4096-byte messages (single-threaded) on a
Skylake-based processor (Intel Xeon, supports AVX-512VL and AVX2):

                           Before                After
                           --------              ---------
adiantum(xchacha12,aes)    348 MB/s              1458 MB/s
adiantum(xchacha20,aes)    265 MB/s              1240 MB/s

And on a Zen-based processor (Threadripper 1950X, supports AVX2):

                           Before                After
                           --------              ---------
adiantum(xchacha12,aes)    505 MB/s              1250 MB/s
adiantum(xchacha20,aes)    387 MB/s              989 MB/s

Decryption is almost exactly the same speed as encryption.

The biggest benefit comes from accelerating XChaCha.  Accelerating NH
gives a somewhat smaller, but still significant benefit.

Performance on 512-byte inputs is also improved, though that is much
slower in the first place.  When Adiantium is used with dm-crypt (or
cryptsetup), we recommend using a 4096-byte sector size.

For comparison, AES-256-XTS is 2699 MB/s on the Skylake CPU and
4140 MB/s on the Zen CPU.  However, AES has the benefit of direct AES-NI
hardware support whereas Adiantum is implemented entirely with
general-purpose instructions (scalar and SIMD).  Adiantum is also a
super-pseudorandom permutation over the entire sector, unlike XTS.

Note that XChaCha20 and XChaCha12 can be used for other purposes too.

Changed since v1:
  - Rebase on top of latest cryptodev with the AVX-512VL accelerated
    ChaCha20 from Martin Willi.

Eric Biggers (6):
  crypto: x86/nhpoly1305 - add SSE2 accelerated NHPoly1305
  crypto: x86/nhpoly1305 - add AVX2 accelerated NHPoly1305
  crypto: x86/chacha20 - limit the preemption-disabled section
  crypto: x86/chacha20 - add XChaCha20 support
  crypto: x86/chacha20 - refactor to allow varying number of rounds
  crypto: x86/chacha - add XChaCha12 support

 arch/x86/crypto/Makefile                      |  15 +-
 ...a20-avx2-x86_64.S => chacha-avx2-x86_64.S} |  33 +--
 ...12vl-x86_64.S => chacha-avx512vl-x86_64.S} |  35 +--
 ...0-ssse3-x86_64.S => chacha-ssse3-x86_64.S} |  99 ++++---
 arch/x86/crypto/chacha20_glue.c               | 208 -------------
 arch/x86/crypto/chacha_glue.c                 | 280 ++++++++++++++++++
 arch/x86/crypto/nh-avx2-x86_64.S              | 157 ++++++++++
 arch/x86/crypto/nh-sse2-x86_64.S              | 123 ++++++++
 arch/x86/crypto/nhpoly1305-avx2-glue.c        |  77 +++++
 arch/x86/crypto/nhpoly1305-sse2-glue.c        |  76 +++++
 crypto/Kconfig                                |  28 +-
 11 files changed, 839 insertions(+), 292 deletions(-)
 rename arch/x86/crypto/{chacha20-avx2-x86_64.S => chacha-avx2-x86_64.S} (97%)
 rename arch/x86/crypto/{chacha20-avx512vl-x86_64.S => chacha-avx512vl-x86_64.S} (97%)
 rename arch/x86/crypto/{chacha20-ssse3-x86_64.S => chacha-ssse3-x86_64.S} (93%)
 delete mode 100644 arch/x86/crypto/chacha20_glue.c
 create mode 100644 arch/x86/crypto/chacha_glue.c
 create mode 100644 arch/x86/crypto/nh-avx2-x86_64.S
 create mode 100644 arch/x86/crypto/nh-sse2-x86_64.S
 create mode 100644 arch/x86/crypto/nhpoly1305-avx2-glue.c
 create mode 100644 arch/x86/crypto/nhpoly1305-sse2-glue.c

-- 
2.20.0.rc0.387.gc7a69e6b6c-goog
