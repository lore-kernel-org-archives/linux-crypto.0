Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727545AbfAJUSW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 15:18:22 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 00/11] crypto: misc fixes/cleanups
Date: Thu, 10 Jan 2019 12:17:51 -0800
Message-Id: <20190110201802.82442-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some more miscellaneous crypto fixes and cleanups:

- Patch 1-6: fix sparse warnings in 6 files.
- Patch 7: fix unaligned memory access in tgr192.
- Patch 8-11: a few other cleanups.

Eric Biggers (11):
  crypto: gcm - use correct endianness type in gcm_hash_len()
  crypto: rsa-pkcs1pad - include <crypto/internal/rsa.h>
  crypto: streebog - use correct endianness type
  crypto: testmgr - handle endianness correctly in alg_test_crc32c()
  crypto: user - forward declare crypto_nlsk
  crypto: x86/aesni-gcm - make 'struct aesni_gcm_tfm_s' static const
  crypto: tgr192 - fix unaligned memory access
  crypto: stat - remove unused mutex
  crypto: af_alg - make some functions static
  crypto: af_alg - use list_for_each_entry() in af_alg_count_tsgl()
  crypto: af_alg - remove redundant initializations of sk_family

 arch/x86/crypto/aesni-intel_glue.c   | 34 +++++++++++-----------------
 crypto/af_alg.c                      | 33 ++++++++++-----------------
 crypto/crypto_user_stat.c            |  4 ----
 crypto/gcm.c                         |  2 +-
 crypto/rsa-pkcs1pad.c                |  1 +
 crypto/streebog_generic.c            |  2 +-
 crypto/testmgr.c                     | 10 ++++----
 crypto/tgr192.c                      |  6 ++---
 include/crypto/if_alg.h              |  7 ------
 include/crypto/internal/cryptouser.h |  2 ++
 include/crypto/streebog.h            |  2 +-
 11 files changed, 39 insertions(+), 64 deletions(-)

-- 
2.20.1.97.g81188d93c3-goog
