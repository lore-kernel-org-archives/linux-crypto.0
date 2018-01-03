From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 0/9] crypto: prevent unkeyed use of keyed algorithms
Date: Wed,  3 Jan 2018 11:16:21 -0800
Message-ID: <20180103191630.79917-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:32769 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbeACTSZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jan 2018 14:18:25 -0500
Received: by mail-io0-f196.google.com with SMTP id t63so3167555iod.0
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jan 2018 11:18:25 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

This series updates the crypto API to consistently prevent using keyed
algorithms without setting the key.  Currently this is prevented for
AF_ALG but not for other crypto API users, which is very problematic for
other places in the kernel where userspace can specify a hash algorithm
by name, e.g. KEYCTL_DH_COMPUTE as demonstrated by syzbot
(https://marc.info/?l=linux-crypto-vger&m=151395810921850).

This series fixes the bug for all users by adding a flag
CRYPTO_ALG_NEED_KEY to crypto_tfm.crt_flags.  This flag is set if needed
when the tfm is created, is cleared when the key is set, and is checked
when doing an operation that would require the key.

Patches 1-6 update the hash API, which is the primary fix.  I've marked
all those patches for stable, which is kind of a pain, but it seems the
alternative would be very messy -- we'd have to patch at least 5
different crypto API users (probably missing some), then revert those
patches upstream once we have the proper fix at the API level.

The last two patches also extend the fix to the skcipher and AEAD APIs,
primarily as a sanity check since users should be less likely to try to
use skciphers or AEADs without setting a key.

Eric Biggers (9):
  crypto: hash - introduce crypto_hash_alg_has_setkey()
  crypto: cryptd - pass through absence of ->setkey()
  crypto: mcryptd - pass through absence of ->setkey()
  crypto: poly1305 - remove ->setkey() method
  crypto: hash - annotate algorithms taking optional key
  crypto: hash - prevent using keyed hashes without setting key
  crypto: ghash - remove checks for key being set
  crypto: skcipher - prevent using skciphers without setting key
  crypto: aead - prevent using AEADs without setting key

 arch/arm/crypto/crc32-ce-glue.c                    |  2 +
 arch/arm64/crypto/crc32-ce-glue.c                  |  2 +
 arch/powerpc/crypto/crc32c-vpmsum_glue.c           |  1 +
 arch/s390/crypto/crc32-vx.c                        |  3 ++
 arch/sparc/crypto/crc32c_glue.c                    |  1 +
 arch/x86/crypto/crc32-pclmul_glue.c                |  1 +
 arch/x86/crypto/crc32c-intel_glue.c                |  1 +
 arch/x86/crypto/poly1305_glue.c                    |  1 -
 crypto/aead.c                                      | 13 ++++-
 crypto/ahash.c                                     | 33 ++++++++++--
 crypto/algif_aead.c                                | 11 ++--
 crypto/algif_hash.c                                | 52 ++++---------------
 crypto/algif_skcipher.c                            | 59 +++++-----------------
 crypto/crc32_generic.c                             |  1 +
 crypto/crc32c_generic.c                            |  1 +
 crypto/cryptd.c                                    | 10 ++--
 crypto/ghash-generic.c                             |  6 ---
 crypto/mcryptd.c                                   | 10 ++--
 crypto/poly1305_generic.c                          | 17 ++-----
 crypto/shash.c                                     | 25 +++++++--
 crypto/skcipher.c                                  | 30 +++++++++--
 drivers/crypto/bfin_crc.c                          |  3 +-
 drivers/crypto/stm32/stm32_crc32.c                 |  2 +
 .../lustre/lnet/libcfs/linux/linux-crypto-adler.c  |  1 +
 include/crypto/aead.h                              | 10 +++-
 include/crypto/hash.h                              | 34 +++++++++----
 include/crypto/internal/hash.h                     |  2 +
 include/crypto/poly1305.h                          |  2 -
 include/crypto/skcipher.h                          | 11 ++--
 include/linux/crypto.h                             |  8 +++
 30 files changed, 195 insertions(+), 158 deletions(-)

-- 
2.15.1.620.gb9897f4670-goog
