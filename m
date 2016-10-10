From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.9
Date: Mon, 10 Oct 2016 11:34:56 +0800
Message-ID: <20161010033456.GA3236@gondor.apana.org.au>
References: <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160315072040.GA18381@gondor.apana.org.au>
 <20160516071608.GA1594@gondor.apana.org.au>
 <20160725105300.GA5894@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55101 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751710AbcJJDfz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2016 23:35:55 -0400
Content-Disposition: inline
In-Reply-To: <20160725105300.GA5894@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 4.9:

API:

* The crypto engine code now supports hashes.

Algorithms:

* Allow keys >= 2048 bits in FIPS mode for RSA.

Drivers:

* Memory overwrite fix for vmx ghash.
* Add support for building ARM sha1-neon in Thumb2 mode.
* Reenable ARM ghash-ce code by adding import/export.
* Reenable img-hash by adding import/export.
* Add support for multiple cores in omap-aes.
* Add little-endian support for sha1-powerpc.
* Add Cavium HWRNG driver for ThunderX SoC.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ananth Jasty (1):
      PCI: quirk fixup for cavium invalid sriov link value.

Ard Biesheuvel (3):
      crypto: arm/sha1-neon - add support for building in Thumb2 mode
      crypto: arm/ghash-ce - add missing async import/export
      crypto: arm/ghash - change internal cra_name to "__ghash"

Arnd Bergmann (1):
      crypto: mv_cesa - remove NO_IRQ reference

Arvind Yadav (2):
      hwrng: bcm2835 - handle of_iomap failures
      crypto: caam - Unmap region obtained by of_iomap

Baoyou Xie (2):
      crypto: caam - add missing header dependencies
      crypto: sun4i-ss - mark sun4i_hash() static

Catalin Vasile (2):
      crypto: caam - fix rfc3686(ctr(aes)) IV load
      crypto: caam - fix sg dump

Corentin LABBE (17):
      crypto: xts - fix a little typo
      crypto: sun4i-ss - fix a few signed warning
      crypto: sun4i-ss - unify update/final function
      crypto: sun4i-ss - clean unused ss
      crypto: sun4i-ss - fix spelling
      crypto: sun4i-ss - Always use sun4i_tfm_ctx for storing pointer to dev ss
      crypto: sun4i-ss - fix indentation of two crypto alg
      hwrng: amd - Fix style problem with blank line
      hwrng: amd - use the BIT macro
      hwrng: amd - Be consitent with the driver name
      hwrng: amd - Remove asm/io.h
      hwrng: amd - release_region must be called after hwrng_unregister
      hwrng: amd - Replace global variable with private struct
      hwrng: amd - Access hardware via ioread32/iowrite32
      hwrng: amd - Convert to new hwrng read() API
      crypto: engine - move crypto engine to its own header
      crypto: engine - permit to enqueue ashash_request

Daniel Thompson (1):
      hwrng: core - Improve description of the ->read() interface

Dave Gerlach (1):
      hwrng: omap - Only fail if pm_runtime_get_sync returns < 0

Eric Biggers (1):
      crypto: doc - fix documentation for bulk registration functions

Fabio Estevam (1):
      crypto: mxc-scc - check clk_prepare_enable() error

Gary R Hook (13):
      crypto: ccp - Fix non-conforming comment style
      crypto: ccp - Abstract PCI info for the CCP
      crypto: ccp - Shorten the fields of the action structure
      crypto: ccp - Refactoring: symbol cleanup
      crypto: ccp - Refactor the storage block allocation code
      crypto: ccp - Refactor code supporting the CCP's RNG
      crypto: ccp - Refactor code to enable checks for queue space.
      crypto: ccp - Let a v5 CCP provide the same function as v3
      crypto: ccp - Add support for the RNG in a version 5 CCP
      crypto: ccp - Enable DMA service on a v5 CCP
      crypto: ccp - Enable use of the additional CCP
      crypto: ccp - clean up data structure
      crypto: ccp - Make syslog errors human-readable

Giovanni Cabiddu (1):
      crypto: qat - fix leak on error path

Govindraj Raja (1):
      crypto: img-hash - Add suspend resume hooks for img hash

Herbert Xu (4):
      crypto: xor - Fix warning when XOR_SELECT_TEMPLATE is unset
      crypto: algif_hash - Handle NULL hashes correctly
      PCI: Fix cavium quirk compile failure with PCI_ATS off
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

James Hartley (2):
      crypto: img-hash - Add support for export and import
      crypto: img-hash - log a successful probe

Jan Stancek (1):
      crypto: testmgr - add guard to dst buffer for ahash_export

Lokesh Vutla (2):
      crypto: omap-aes - Add support for multiple cores
      crypto: omap-aes - Add fallback support

Maksim Lukoshkov (2):
      crypto: qat - fix constants table DMA
      crypto: qat - fix incorrect accelerator mask for C3X devices

Marcelo Cerri (4):
      crypto: ghash-generic - move common definitions to a new header file
      crypto: vmx - Fix memory corruption caused by p8_ghash
      crypto: sha1-powerpc - little-endian support
      crypto: vmx - Ensure ghash-generic is enabled

Markus Elfring (7):
      hwrng: pic32 - Delete unnecessary assignment for the field "owner"
      crypto: caam - Use kmalloc_array() in ahash_setkey()
      crypto: caam - Rename jump labels in ahash_setkey()
      crypto: caam - Rename a jump label in five functions
      crypto: caam - Return a value directly in caam_hash_cra_init()
      crypto: caam - Delete an unnecessary initialisation in seven functions
      crypto: caam - Move common error handling code in two functions

Martin Schwidefsky (1):
      crypto: xor - skip speed test if the xor function is selected automatically

Masahiro Yamada (1):
      crypto: squash lines for simple wrapper functions

Omer Khaliq (1):
      hwrng: cavium - Add Cavium HWRNG driver for ThunderX SoC.

Ondrej Mosnáček (1):
      crypto: gcm - Fix IV buffer size in crypto_gcm_setkey

PrasannaKumar Muralidharan (9):
      hwrng: omap3-rom - Remove obsoleted functions
      hwrng: Remove check for max less than 4 bytes
      hwrng: tx4939 - Use devm_hwrng_register instead of hwrng_register
      hwrng: pasemi - Migrate to managed API
      hwrng: pasemi - Use linux/io.h instead of asm/io.h
      hwrng: core - Allocate memory during module init
      hwrng: amd - Migrate to managed API
      hwrng: geode - Migrate to managed API
      hwrng: geode - Use linux/io.h instead of asm/io.h

Quentin Lambert (3):
      crypto: ixp4xx - Fix a "simple if" coding style warning
      crypto: ixp4xx - Add missing npe_c release in error branches
      crypto: ccp - add missing release in ccp_dmaengine_register

Romain Perier (3):
      crypto: marvell - Update transformation context for each dequeued req
      crypto: marvell - Don't overwrite default creq->state during initialization
      crypto: marvell - Don't hardcode block size in mv_cesa_ahash_cache_req

Russell King (12):
      crypto: caam - fix DMA API mapping leak
      crypto: caam - ensure descriptor buffers are cacheline aligned
      crypto: caam - incorporate job descriptor into struct ahash_edesc
      crypto: caam - mark the hardware descriptor as cache line aligned
      crypto: caam - replace sec4_sg pointer with array
      crypto: caam - ensure that we clean up after an error
      crypto: caam - check and use dma_map_sg() return code
      crypto: caam - add ahash_edesc_alloc() for descriptor allocation
      crypto: caam - move job descriptor initialisation to ahash_edesc_alloc()
      crypto: caam - add ahash_edesc_add_src()
      crypto: caam - get rid of tasklet
      crypto: caam - avoid kernel warnings on probe failure

Stephan Mueller (3):
      crypto: drbg - do not call drbg_instantiate in healt test
      crypto: rsa - allow keys >= 2048 bits in FIPS mode
      crypto: FIPS - allow tests to be disabled in FIPS mode

Sudip Mukherjee (1):
      crypto: rockchip - use devm_add_action_or_reset()

Tero Kristo (14):
      crypto: omap-sham - avoid executing tasklet where not needed
      crypto: omap-sham - fix software fallback handling
      crypto: omap-sham - fix SW fallback HMAC handling for omap2/omap3
      crypto: omap-aes - use runtime_pm autosuspend for clock handling
      crypto: omap-aes - fix crypto engine initialization order
      crypto: omap-des - fix crypto engine initialization order
      crypto: omap-sham - add context export/import stubs
      crypto: omap-sham - align algorithms on word offset
      crypto: omap-sham - rename sgl to sgl_tmp for deprecation
      crypto: omap-sham - add support functions for sg based data handling
      crypto: omap-sham - change the DMA threshold value to a define
      crypto: omap-sham - convert driver logic to use sgs for data xmit
      crypto: omap-sham - add support for export/import
      crypto: omap-sham - shrink the internal buffer size

Thomas Petazzoni (4):
      crypto: marvell - be explicit about destination in mv_cesa_dma_add_op()
      crypto: marvell - remove unused parameter in mv_cesa_ahash_dma_add_cache()
      crypto: marvell - turn mv_cesa_ahash_init() into a function returning void
      crypto: marvell - make mv_cesa_ahash_cache_req() return bool

Tudor Ambarus (1):
      crypto: caam - treat SGT address pointer as u64

Wei Yongjun (10):
      crypto: ccp - Fix non static symbol warning
      crypto: sun4i-ss - fix missing unlock on error in sun4i_hash()
      crypto: drbg - fix error return code
      hwrng: st - Fix missing clk_disable_unprepare() on error in st_rng_probe()
      crypto: omap-des - fix error return code in omap_des_probe()
      crypto: omap-aes - fix error return code in omap_aes_probe()
      crypto: ccp - use kmem_cache_zalloc instead of kmem_cache_alloc/memset
      hwrng: amd - Fix return value check in mod_init()
      hwrng: geode - fix return value check in mod_init()
      crypto: ccp - Fix return value check in ccp_dmaengine_register()

Will Thomas (4):
      crypto: img-hash - Fix null pointer exception
      crypto: img-hash - Fix hash request context
      crypto: img-hash - Reconfigure DMA Burst length
      crypto: img-hash - Fix set_reqsize call

Yanjiang Jin (1):
      crypto: testmgr - fix !x==y confusion

 Documentation/DocBook/crypto-API.tmpl            |   38 +-
 arch/arm/crypto/ghash-ce-glue.c                  |   26 +-
 arch/arm/crypto/sha1-armv7-neon.S                |    1 -
 arch/powerpc/crypto/sha1-powerpc-asm.S           |   13 +-
 crypto/algif_hash.c                              |   73 +-
 crypto/crct10dif_generic.c                       |    5 +-
 crypto/crypto_engine.c                           |  187 +++-
 crypto/drbg.c                                    |   31 +-
 crypto/gcm.c                                     |    2 +-
 crypto/ghash-generic.c                           |   13 +-
 crypto/mcryptd.c                                 |    7 +-
 crypto/rsa_helper.c                              |    4 +-
 crypto/testmgr.c                                 |   24 +-
 crypto/testmgr.h                                 |    4 +
 crypto/xor.c                                     |   41 +-
 crypto/xts.c                                     |    2 +-
 drivers/char/hw_random/Kconfig                   |   13 +
 drivers/char/hw_random/Makefile                  |    1 +
 drivers/char/hw_random/amd-rng.c                 |  140 +--
 drivers/char/hw_random/bcm2835-rng.c             |    5 +-
 drivers/char/hw_random/cavium-rng-vf.c           |   99 +++
 drivers/char/hw_random/cavium-rng.c              |   94 ++
 drivers/char/hw_random/core.c                    |   37 +-
 drivers/char/hw_random/geode-rng.c               |   58 +-
 drivers/char/hw_random/meson-rng.c               |    3 -
 drivers/char/hw_random/omap-rng.c                |    4 +-
 drivers/char/hw_random/omap3-rom-rng.c           |   10 +-
 drivers/char/hw_random/pasemi-rng.c              |   39 +-
 drivers/char/hw_random/pic32-rng.c               |    1 -
 drivers/char/hw_random/st-rng.c                  |    4 +-
 drivers/char/hw_random/tx4939-rng.c              |   11 +-
 drivers/crypto/Kconfig                           |    3 +
 drivers/crypto/caam/caamalg.c                    |  161 ++--
 drivers/crypto/caam/caamhash.c                   |  581 ++++++------
 drivers/crypto/caam/ctrl.c                       |    3 +
 drivers/crypto/caam/desc.h                       |    6 -
 drivers/crypto/caam/desc_constr.h                |   17 +
 drivers/crypto/caam/intern.h                     |    1 -
 drivers/crypto/caam/jr.c                         |   26 +-
 drivers/crypto/caam/regs.h                       |    8 +
 drivers/crypto/caam/sg_sw_sec4.h                 |    2 +-
 drivers/crypto/ccp/Makefile                      |    1 +
 drivers/crypto/ccp/ccp-crypto-sha.c              |   18 +-
 drivers/crypto/ccp/ccp-dev-v3.c                  |  182 ++--
 drivers/crypto/ccp/ccp-dev-v5.c                  | 1017 ++++++++++++++++++++++
 drivers/crypto/ccp/ccp-dev.c                     |  113 ++-
 drivers/crypto/ccp/ccp-dev.h                     |  312 +++++--
 drivers/crypto/ccp/ccp-dmaengine.c               |   11 +-
 drivers/crypto/ccp/ccp-ops.c                     |  576 ++++++------
 drivers/crypto/ccp/ccp-pci.c                     |   23 +-
 drivers/crypto/hifn_795x.c                       |   12 +-
 drivers/crypto/img-hash.c                        |  108 ++-
 drivers/crypto/ixp4xx_crypto.c                   |    9 +-
 drivers/crypto/marvell/cesa.c                    |    1 +
 drivers/crypto/marvell/hash.c                    |   44 +-
 drivers/crypto/marvell/tdma.c                    |    1 +
 drivers/crypto/mv_cesa.c                         |    7 +-
 drivers/crypto/mxc-scc.c                         |    4 +-
 drivers/crypto/omap-aes.c                        |  141 +--
 drivers/crypto/omap-des.c                        |   35 +-
 drivers/crypto/omap-sham.c                       |  568 +++++++-----
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h |    2 +-
 drivers/crypto/qat/qat_common/adf_admin.c        |   20 +-
 drivers/crypto/qat/qat_common/qat_uclo.c         |    8 +-
 drivers/crypto/rockchip/rk3288_crypto.c          |    6 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c        |    6 +-
 drivers/crypto/sunxi-ss/sun4i-ss-core.c          |   68 +-
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c          |  165 ++--
 drivers/crypto/sunxi-ss/sun4i-ss.h               |    2 +-
 drivers/crypto/vmx/Kconfig                       |    1 +
 drivers/crypto/vmx/ghash.c                       |   31 +-
 drivers/pci/quirks.c                             |   11 +
 include/crypto/algapi.h                          |   70 --
 include/crypto/engine.h                          |  107 +++
 include/crypto/ghash.h                           |   23 +
 include/linux/ccp.h                              |    3 -
 include/linux/hw_random.h                        |    4 +-
 77 files changed, 3853 insertions(+), 1655 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
