From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.11
Date: Sat, 4 Mar 2017 15:41:20 +0800
Message-ID: <20170304074119.GA3041@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161215160732.GA16580@gondor.apana.org.au>
 <20170111115646.GA8943@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111115646.GA8943@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes the following issues:

- vmalloc stack regression in CCM.
- Build problem in CRC32 on ARM.
- Memory leak in cavium.
- Missing Kconfig dependencies in atmel and mediatek.
- XTS Regression on some platforms (s390 and ppc).
- Memory overrun in CCM test vector.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ard Biesheuvel (3):
      crypto: ccm - move cbcmac input off the stack
      crypto: arm/crc32 - fix build error with outdated binutils
      crypto: arm/crc32 - add build time test for CRC instruction support

Colin Ian King (1):
      crypto: cavium - fix leak on curr if curr->head fails to be allocated

Geert Uytterhoeven (2):
      crypto: atmel - CRYPTO_DEV_ATMEL_TDES and CRYPTO_DEV_ATMEL_SHA should depend on HAS_DMA
      crypto: atmel - CRYPTO_DEV_MEDIATEK should depend on HAS_DMA

George Cherian (1):
      crypto: cavium - Fix couple of static checker errors

Herbert Xu (2):
      crypto: api - Add crypto_requires_off helper
      crypto: xts - Propagate NEED_FALLBACK bit

Laura Abbott (1):
      crypto: testmgr - Pad aes_ccm_enc_tv_template vector

Paulo Flabiano Smorigo (2):
      crypto: vmx - Use skcipher for cbc fallback
      crypto: vmx - Use skcipher for xts fallback

 arch/arm/crypto/Makefile                     |   12 ++++++-
 arch/arm/crypto/crc32-ce-core.S              |    2 +-
 crypto/ccm.c                                 |    5 +--
 crypto/testmgr.h                             |    2 +-
 crypto/xts.c                                 |   14 ++++----
 drivers/crypto/Kconfig                       |    3 ++
 drivers/crypto/cavium/cpt/cptvf_main.c       |    5 ++-
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c |    4 +--
 drivers/crypto/vmx/aes_cbc.c                 |   47 +++++++++++++-------------
 drivers/crypto/vmx/aes_xts.c                 |   32 +++++++++---------
 include/crypto/algapi.h                      |    7 +++-
 11 files changed, 79 insertions(+), 54 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
