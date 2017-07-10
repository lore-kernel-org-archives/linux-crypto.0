From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/2] crypto/algapi - refactor crypto_xor() to avoid memcpy()s
Date: Mon, 10 Jul 2017 14:45:46 +0100
Message-ID: <20170710134548.20234-1-ard.biesheuvel@linaro.org>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
        ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

>From 2/2:

"""
There are quite a number of occurrences in the kernel of the pattern

    if (dst != src)
            memcpy(dst, src, walk.total % AES_BLOCK_SIZE);
    crypto_xor(dst, final, walk.total % AES_BLOCK_SIZE);

or

    crypto_xor(keystream, src, nbytes);
    memcpy(dst, keystream, nbytes);

where crypto_xor() is preceded or followed by a memcpy() invocation
that is only there because crypto_xor() uses its output parameter as
one of the inputs.
"""

Patch #1 is a preparatory patch, which is split off for ease of review.

Patch #2 updates all occurrences of crypto_xor() to use a separate
output argument.

Ard Biesheuvel (2):
  crypto/algapi - use separate dst and src operands for __crypto_xor()
  crypto/algapi - make crypto_xor() take separate dst and src arguments

 arch/arm/crypto/aes-ce-glue.c       |  4 +---
 arch/arm/crypto/aes-neonbs-glue.c   |  9 +++----
 arch/arm64/crypto/aes-glue.c        |  8 +++----
 arch/arm64/crypto/aes-neonbs-glue.c |  9 +++----
 arch/sparc/crypto/aes_glue.c        |  3 +--
 arch/x86/crypto/aesni-intel_glue.c  |  4 ++--
 arch/x86/crypto/blowfish_glue.c     |  3 +--
 arch/x86/crypto/cast5_avx_glue.c    |  3 +--
 arch/x86/crypto/des3_ede_glue.c     |  3 +--
 crypto/algapi.c                     | 25 ++++++++++++--------
 crypto/ccm.c                        |  2 +-
 crypto/chacha20_generic.c           |  4 ++--
 crypto/cmac.c                       |  8 +++----
 crypto/ctr.c                        |  7 +++---
 crypto/cts.c                        |  4 ++--
 crypto/gcm.c                        |  4 ++--
 crypto/ghash-generic.c              |  2 +-
 crypto/keywrap.c                    |  4 ++--
 crypto/pcbc.c                       | 20 +++++++---------
 crypto/salsa20_generic.c            |  4 ++--
 crypto/seqiv.c                      |  2 +-
 crypto/xcbc.c                       |  8 +++----
 drivers/crypto/vmx/aes_ctr.c        |  3 +--
 drivers/md/dm-crypt.c               | 19 +++++++--------
 include/crypto/algapi.h             | 12 ++++++----
 include/crypto/cbc.h                | 10 ++++----
 net/mac80211/fils_aead.c            |  6 ++---
 27 files changed, 89 insertions(+), 101 deletions(-)

-- 
2.9.3
