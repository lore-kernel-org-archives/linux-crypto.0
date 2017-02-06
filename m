From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.10
Date: Mon, 6 Feb 2017 17:25:13 +0800
Message-ID: <20170206092513.GA9650@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161215160732.GA16580@gondor.apana.org.au>
 <20170111115646.GA8943@gondor.apana.org.au>
 <20170201090415.GA32141@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170201090415.GA32141@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes the following issues:

- Use after free in algif_aead.
- Modular aesni regression when pcbc is modular but absent.
- Bug causing IO page faults in ccp.
- Double list add in ccp.
- Null pointer dereference in qat (two patches).
- Panic in chcr.
- Null pointer dereference in chcr.
- Out-of-bound access in chcr.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Gary R Hook (2):
      crypto: ccp - Fix DMA operations when IOMMU is enabled
      crypto: ccp - Fix double add when creating new DMA command

Giovanni Cabiddu (2):
      crypto: qat - fix bar discovery for c62x
      crypto: qat - zero esram only for DH85x devices

Harsh Jain (4):
      crypto: chcr - Fix panic on dma_unmap_sg
      crypto: chcr - Check device is allocated before use
      crypto: algif_aead - Fix kernel panic on list_del
      crypto: chcr - Fix key length for RFC4106

Herbert Xu (1):
      crypto: aesni - Fix failure when pcbc module is absent

 arch/x86/crypto/aesni-intel_glue.c                |    8 ++--
 crypto/algif_aead.c                               |    2 +-
 drivers/crypto/ccp/ccp-dev-v5.c                   |    2 +-
 drivers/crypto/ccp/ccp-dev.h                      |    1 +
 drivers/crypto/ccp/ccp-dmaengine.c                |    6 ++-
 drivers/crypto/chelsio/chcr_algo.c                |   53 +++++++++++----------
 drivers/crypto/chelsio/chcr_core.c                |   18 ++++---
 drivers/crypto/chelsio/chcr_crypto.h              |    3 ++
 drivers/crypto/qat/qat_c62x/adf_drv.c             |    2 +-
 drivers/crypto/qat/qat_common/adf_accel_devices.h |    1 +
 drivers/crypto/qat/qat_common/qat_hal.c           |    4 +-
 11 files changed, 55 insertions(+), 45 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
