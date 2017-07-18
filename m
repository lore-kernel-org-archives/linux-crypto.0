From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/2] crypto/algapi - refactor crypto_xor() to avoid memcpy()s
Date: Tue, 18 Jul 2017 10:19:10 +0100
Message-ID: <20170718091912.14104-1-ard.biesheuvel@linaro.org>
Cc: ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org
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

Patch #2 updates all occurrences of crypto_xor() involving a memcpy() to
use a new API function crypto_xor_cpy() which combines the two operations.

v2: - keep existing crypto_xor() as-is, and add crypto_xor_cpy() for the
      cases where a redundant memcpy() can be eliminated.

Ard Biesheuvel (2):
  crypto/algapi - use separate dst and src operands for __crypto_xor()
  crypto/algapi - make crypto_xor() take separate dst and src arguments

 arch/arm/crypto/aes-ce-glue.c       |  4 +---
 arch/arm/crypto/aes-neonbs-glue.c   |  5 ++--
 arch/arm64/crypto/aes-glue.c        |  4 +---
 arch/arm64/crypto/aes-neonbs-glue.c |  5 ++--
 arch/sparc/crypto/aes_glue.c        |  3 +--
 arch/x86/crypto/aesni-intel_glue.c  |  4 ++--
 arch/x86/crypto/blowfish_glue.c     |  3 +--
 arch/x86/crypto/cast5_avx_glue.c    |  3 +--
 arch/x86/crypto/des3_ede_glue.c     |  3 +--
 crypto/algapi.c                     | 25 ++++++++++++--------
 crypto/ctr.c                        |  3 +--
 crypto/pcbc.c                       | 12 ++++------
 drivers/crypto/vmx/aes_ctr.c        |  3 +--
 drivers/md/dm-crypt.c               | 11 ++++-----
 include/crypto/algapi.h             | 23 ++++++++++++++++--
 15 files changed, 59 insertions(+), 52 deletions(-)

-- 
2.9.3
