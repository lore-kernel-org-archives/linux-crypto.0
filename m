From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.17
Date: Wed, 4 Apr 2018 23:27:52 +0800
Message-ID: <20180404152752.GA11822@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170904101225.GA12613@gondor.apana.org.au>
 <20171113074346.GA20245@gondor.apana.org.au>
 <20180129145012.GA12805@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180129145012.GA12805@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

Here is the crypto update for 4.17:

API:

- Add AEAD support to crypto engine.
- Allow batch registration in simd.

Algorithms:

- Add CFB mode.
- Add speck block cipher.
- Add sm4 block cipher.
- Add new test case for crct10dif.
- Improve scheduling latency on ARM.
- Add scatter/gather support to gcm in aesni.
- Convert x86 crypto algorithms to skcihper.

Drivers:

- Add hmac(sha224/sha256) support in inside-secure.
- Add aes gcm/ccm support in stm32.
- Add stm32mp1 support in stm32.
- Add ccree driver from staging tree.
- Add gcm support over QI in caam.
- Add ks-sa hwrng driver.

Please note that there will be a conflict with the net tree due
updates to the same header file in the chelsio driver.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Andy Shevchenko (1):
      crypto: Deduplicate le32_to_cpu_array() and cpu_to_le32_array()

Antoine Tenart (20):
      MAINTAINERS: update the Inside Secure maintainer email
      crypto: inside-secure - do not overwrite the threshold value
      crypto: inside-secure - fix the extra cache computation
      crypto: inside-secure - fix the cache_len computation
      crypto: inside-secure - do not process request if no command was issued
      crypto: inside-secure - fix the invalidation step during cra_exit
      crypto: inside-secure - keep the requests push/pop synced
      crypto: inside-secure - unmap the result in the hash send error path
      crypto: atmel-aes - fix the keys zeroing on errors
      crypto: inside-secure - move cache result dma mapping to request
      crypto: inside-secure - wait for the request to complete if in the backlog
      crypto: inside-secure - move the digest to the request context
      crypto: inside-secure - fix typo s/allways/always/ in a define
      crypto: inside-secure - fix a typo in a register name
      crypto: inside-secure - improve the send error path
      crypto: inside-secure - do not access buffers mapped to the device
      crypto: inside-secure - improve the skcipher token
      crypto: inside-secure - the context ipad/opad should use the state sz
      crypto: inside-secure - hmac(sha256) support
      crypto: inside-secure - hmac(sha224) support

Ard Biesheuvel (9):
      crypto: testmgr - add a new test case for CRC-T10DIF
      crypto: arm64/aes-ce-ccm - move kernel mode neon en/disable into loop
      crypto: arm64/aes-blk - move kernel mode neon en/disable into loop
      crypto: arm64/aes-bs - move kernel mode neon en/disable into loop
      crypto: arm64/chacha20 - move kernel mode neon en/disable into loop
      crypto: arm64/aes-blk - remove configurable interleave
      crypto: arm64/aes-blk - add 4 way interleave to CBC encrypt path
      crypto: arm64/aes-blk - add 4 way interleave to CBC-MAC encrypt path
      crypto: arm64/sha256-neon - play nice with CONFIG_PREEMPT kernels

Arnd Bergmann (1):
      crypto: bfin_crc - remove blackfin CRC driver

Atul Gupta (1):
      crypto: chelsio - no csum offload for ipsec path

Brijesh Singh (3):
      crypto: ccp - add check to get PSP master only when PSP is detected
      crypto: ccp - Fix sparse, use plain integer as NULL pointer
      include: psp-sev: Capitalize invalid length enum

Colin Ian King (4):
      crypto: chelsio - Make function aead_ccm_validate_input static
      crypto: ccp - Make function ccp_get_dma_chan_attr static
      crypto: qat - Make several functions static
      hwrng: cavium - make two functions static

Conor McLoughlin (1):
      crypto: testmgr - Fix incorrect values in PKCS#1 test vector

Corentin LABBE (6):
      crypto: doc - document crypto engine API
      crypto: engine - Permit to enqueue all async requests
      crypto: omap - convert to new crypto engine API
      crypto: virtio - convert to new crypto engine API
      crypto: stm32-hash - convert to the new crypto engine API
      crypto: stm32-cryp - convert to the new crypto engine API

Dave Watson (14):
      crypto: aesni - Merge INITIAL_BLOCKS_ENC/DEC
      crypto: aesni - Macro-ify func save/restore
      crypto: aesni - Add GCM_INIT macro
      crypto: aesni - Add GCM_COMPLETE macro
      crypto: aesni - Merge encode and decode to GCM_ENC_DEC macro
      crypto: aesni - Introduce gcm_context_data
      crypto: aesni - Split AAD hash calculation to separate macro
      crypto: aesni - Fill in new context data structures
      crypto: aesni - Move ghash_mul to GCM_COMPLETE
      crypto: aesni - Move HashKey computation from stack to gcm_context
      crypto: aesni - Introduce partial block macro
      crypto: aesni - Add fast path for > 16 byte update
      crypto: aesni - Introduce scatter/gather asm function stubs
      crypto: aesni - Update aesni-intel_glue to use scatter/gather

Eric Biggers (40):
      crypto: mcryptd - remove pointless wrapper functions
      crypto: sha1-mb - remove HASH_FIRST flag
      crypto: sha256-mb - remove HASH_FIRST flag
      crypto: sha512-mb - remove HASH_FIRST flag
      crypto: speck - add support for the Speck block cipher
      crypto: speck - export common helpers
      crypto: arm/speck - add NEON-accelerated implementation of Speck-XTS
      crypto: speck - add test vectors for Speck128-XTS
      crypto: speck - add test vectors for Speck64-XTS
      crypto: simd - allow registering multiple algorithms at once
      crypto: x86/glue_helper - add skcipher_walk functions
      crypto: x86/serpent-sse2 - remove LRW algorithm
      crypto: x86/serpent-sse2 - remove XTS algorithm
      crypto: x86/serpent-sse2 - convert to skcipher interface
      crypto: x86/serpent-avx2 - remove LRW algorithm
      crypto: x86/serpent-avx - remove LRW algorithm
      crypto: x86/serpent-avx,avx2 - convert to skcipher interface
      crypto: x86/twofish-3way - remove LRW algorithm
      crypto: x86/twofish-3way - remove XTS algorithm
      crypto: x86/twofish-3way - convert to skcipher interface
      crypto: x86/twofish-avx - remove LRW algorithm
      crypto: x86/twofish-avx - convert to skcipher interface
      crypto: x86/cast5-avx - fix ECB encryption when long sg follows short one
      crypto: x86/cast5-avx - convert to skcipher interface
      crypto: x86/cast6-avx - remove LRW algorithm
      crypto: x86/cast6-avx - convert to skcipher interface
      crypto: x86/blowfish: convert to skcipher interface
      crypto: x86/des3_ede - convert to skcipher interface
      crypto: x86/camellia-aesni-avx - remove LRW algorithm
      crypto: x86/camellia-aesni-avx2 - remove LRW algorithm
      crypto: x86/camellia - remove LRW algorithm
      crypto: x86/camellia - remove XTS algorithm
      crypto: x86/camellia - convert to skcipher interface
      crypto: x86/camellia-aesni-avx, avx2 - convert to skcipher interface
      crypto: xts - remove xts_crypt()
      crypto: lrw - remove lrw_crypt()
      crypto: x86/glue_helper - remove blkcipher_walk functions
      crypto: x86/glue_helper - rename glue_skwalk_fpu_begin()
      crypto: ablk_helper - remove ablk_helper
      crypto: arm64/speck - add NEON-accelerated implementation of Speck-XTS

Fabien DESSENNE (2):
      crypto: stm32/cryp - add aes gcm / ccm support
      crypto: stm32/cryp - add stm32mp1 support

Fengguang Wu (1):
      crypto: ccree - fix memdup.cocci warnings

Gary R Hook (3):
      crypto: ccp - Fill the result buffer only on digest, finup, and final ops
      crypto: ccp - Validate buffer lengths for copy operations
      crypto: doc - Document remaining members in struct crypto_alg

Gilad Ben-Yossef (14):
      staging: ccree: rename staging ver and mark as broken
      crypto: ccree - introduce CryptoCell driver
      crypto: ccree - add skcipher support
      crypto: ccree - add ahash support
      crypto: ccree - add AEAD support
      crypto: ccree - add FIPS support
      MAINTAINERS: update ccree entry
      crypto: ccree - remove unused definitions
      dt-bindings: Add DT bindings for ccree 710 and 630p
      crypto: ccree - add support for older HW revs
      crypto: ccree - replace memset+kfree with kzfree
      crypto: sm4 - introduce SM4 symmetric cipher algorithm
      crypto: testmgr - introduce SM4 tests
      crypto: ccree - remove unused enums

Gregory CLEMENT (5):
      hwrng: omap - Remove useless test before clk_disable_unprepare
      hwrng: omap - Fix clock resource by adding a register clock
      crypto: inside-secure - fix clock management
      crypto: inside-secure - improve clock initialization
      crypto: inside-secure - fix clock resource by adding a register clock

Harsh Jain (6):
      crypto: chelsio - Use kernel round function to align lengths
      crypto: chelsio - Fix src buffer dma length
      crypto: chelsio - Update IV before sending request to HW
      crypto: chelsio - Fix iv passed in fallback path for rfc3686
      crypto: chelsio -Split Hash requests for large scatter gather list
      crypto: chelsio - Remove declaration of static function from header

Herbert Xu (5):
      crypto: api - Remove unused crypto_type lookup function
      crypto: api - Make crypto_alg_lookup static
      crypto: api - Keep failed instances alive
      crypto: lrw - Free rctx->ext with kzfree
      crypto: ahash - Fix early termination in hash walk

Horia Geantă (4):
      crypto: caam/qi - return -EBADMSG for ICV check failure
      crypto: caam - prepare for gcm(aes) support over QI interface
      crypto: caam/qi - add GCM support
      crypto: doc - clarify hash callbacks state machine

James Bottomley (2):
      crypto: cfb - add support for Cipher FeedBack mode
      crypto: ecdh - fix to allow multi segment scatterlists

Jia-Ju Bai (3):
      crypto: rsa-pkcs1pad - Replace GFP_ATOMIC with GFP_KERNEL in pkcs1pad_encrypt_sign_complete
      crypto: user - Replace GFP_ATOMIC with GFP_KERNEL in crypto_report
      crypto: cavium - Replace mdelay with msleep in cpt_device_init

Jinbum Park (1):
      crypto: arm/aes-cipher - move S-box to .rodata section

Kamil Konieczny (6):
      crypto: mxs-dcp - Add empty hash export and import
      crypto: n2 - Add empty hash export and import
      crypto: ux500/hash - Add empty export and import
      crypto: bfin_crc - Add empty hash export and import
      crypto: hash - Require export/import in ahash
      crypto: hash - Prevent use of req->result in ahash update

Kees Cook (1):
      crypto: ecc - Remove stack VLA usage

Krzysztof Kozlowski (4):
      crypto: omap-sham - Remove useless check for non-null request
      crypto: omap-sham - Fix misleading indentation
      crypto: s5p-sss - Remove useless check for non-null request
      crypto: s5p-sss - Constify pointed data (arguments and local variables)

LEROY Christophe (3):
      crypto: talitos - don't persistently map req_ctx->hw_context and req_ctx->buf
      crypto: talitos - do not perform unnecessary dma synchronisation
      crypto: talitos - fix IPsec cipher in length

Leonard Crestez (1):
      crypto: arm,arm64 - Fix random regeneration of S_shipped

Lionel Debieve (3):
      crypto: stm32/hash - avoid error if maxburst not defined
      crypto: stm32/hash - fix performance issues
      crypto: stm32/hash - rework padding length

Maciej S. Szmigiero (1):
      crypto: ccp - return an actual key size from RSA max_size callback

Markus Elfring (12):
      crypto: ux500 - Delete an error message for a failed memory allocation in ux500_cryp_probe()
      crypto: ux500 - Adjust two condition checks in ux500_cryp_probe()
      crypto: ux500 - Adjust an error message in ux500_cryp_probe()
      crypto: ux500 - Delete two unnecessary variable initialisations in ux500_cryp_probe()
      crypto: sahara - Delete an error message for a failed memory allocation in sahara_probe()
      crypto: sahara - Improve a size determination in sahara_probe()
      crypto: nx-842 - Delete an error message for a failed memory allocation in nx842_pseries_init()
      crypto: bfin_crc - Delete an error message for a failed memory allocation in bfin_crypto_crc_probe()
      crypto: bcm - Delete an error message for a failed memory allocation in do_shash()
      crypto: atmel - Delete error messages for a failed memory allocation in six functions
      crypto: ccp - Use memdup_user() rather than duplicating its implementation
      crypto: talitos - Delete an error message for a failed memory allocation in talitos_edesc_alloc()

Ofer Heifetz (1):
      crypto: inside-secure - move hash result dma mapping to request

Peter Robinson (1):
      crypto: sunxi-ss - Add MODULE_ALIAS to sun4i-ss

Peter Wu (1):
      crypto: virtio - remove dependency on CRYPTO_AUTHENC

Robin Murphy (1):
      crypto: marvell/cesa - Clean up redundant #include

Rui Miguel Silva (2):
      crypto: caam - Fix null dereference at error path
      crypto: caam - do not use mem and emi_slow clock for imx7x

Sebastian Andrzej Siewior (1):
      crypto: ccp - don't disable interrupts while setting up debugfs

Stefan Agner (1):
      crypto: brcm - explicitly cast cipher to hash type

Stefan Wahren (1):
      hwrng: bcm2835 - Handle deferred clock properly

Tero Kristo (6):
      crypto: omap-sham - Verify page zone of scatterlists before starting DMA
      crypto: omap-crypto - Verify page zone scatterlists before starting DMA
      crypto: omap-sham - make fallback size configurable
      crypto: omap-sham - make queue length configurable
      crypto: omap-aes - make fallback size configurable
      crypto: omap-aes - make queue length configurable

Tim Chen (1):
      x86/crypto: Designate maintainer for SHA-1/256/512

Tudor-Dan Ambarus (7):
      crypto: caam - don't leak pointers to authenc keys
      crypto: caam/qi - don't leak pointers to authenc keys
      crypto: chelsio - don't leak pointers to authenc keys
      crypto: ixp4xx - don't leak pointers to authenc keys
      crypto: picoxcell - don't leak pointers to authenc keys
      crypto: qat - don't leak pointers to authenc keys
      crypto: talitos - don't leak pointers to authenc keys

Vitaly Andrianov (2):
      dt-bindings: rng: add bindings doc for Keystone SA HWRNG driver
      hwrng: ks-sa - add hw_random driver

Vladimir Zapolskiy (2):
      dt-bindings: rng: Document Freescale i.MX21 and i.MX31 RNGA compatibles
      hwrng: mxc-rnga - add driver support on boards with device tree

Wu Fengguang (1):
      crypto: x86/des3_ede - des3_ede_skciphers[] can be static

lionel.debieve@st.com (5):
      hwrng: stm32 - add reset during probe
      dt-bindings: rng: add reset node for stm32
      hwrng: stm32 - allow disable clock error detection
      dt-bindings: rng: add clock detection error for stm32
      hwrng: stm32 - rework read timeout calculation

weiyongjun \(A\) (2):
      hwrng: imx-rngc - make symbol imx_rngc_pm_ops static
      crypto: inside-secure - fix missing unlock on error in safexcel_ahash_send_req()

 Documentation/crypto/crypto_engine.rst             |   48 +
 Documentation/crypto/devel-algos.rst               |    8 +
 .../devicetree/bindings/crypto/arm-cryptocell.txt  |    3 +-
 .../bindings/crypto/inside-secure-safexcel.txt     |    6 +-
 .../bindings/rng/{imx-rngc.txt => imx-rng.txt}     |   11 +-
 .../devicetree/bindings/rng/ks-sa-rng.txt          |   21 +
 Documentation/devicetree/bindings/rng/omap_rng.txt |    7 +-
 .../devicetree/bindings/rng/st,stm32-rng.txt       |    4 +
 MAINTAINERS                                        |   15 +-
 arch/arm/crypto/Kconfig                            |    6 +
 arch/arm/crypto/Makefile                           |    4 +
 arch/arm/crypto/aes-cipher-core.S                  |   19 +-
 arch/arm/crypto/speck-neon-core.S                  |  432 ++
 arch/arm/crypto/speck-neon-glue.c                  |  288 ++
 arch/arm64/crypto/Kconfig                          |    6 +
 arch/arm64/crypto/Makefile                         |    8 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c                |   47 +-
 arch/arm64/crypto/aes-glue.c                       |   95 +-
 arch/arm64/crypto/aes-modes.S                      |  355 +-
 arch/arm64/crypto/aes-neonbs-glue.c                |   48 +-
 arch/arm64/crypto/chacha20-neon-glue.c             |   12 +-
 arch/arm64/crypto/sha256-glue.c                    |   36 +-
 arch/arm64/crypto/speck-neon-core.S                |  352 ++
 arch/arm64/crypto/speck-neon-glue.c                |  282 ++
 arch/x86/crypto/aesni-intel_asm.S                  | 1414 +++---
 arch/x86/crypto/aesni-intel_glue.c                 |  230 +-
 arch/x86/crypto/blowfish_glue.c                    |  230 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c         |  491 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c          |  495 +-
 arch/x86/crypto/camellia_glue.c                    |  356 +-
 arch/x86/crypto/cast5_avx_glue.c                   |  352 +-
 arch/x86/crypto/cast6_avx_glue.c                   |  489 +-
 arch/x86/crypto/des3_ede_glue.c                    |  238 +-
 arch/x86/crypto/glue_helper.c                      |  391 +-
 arch/x86/crypto/serpent_avx2_glue.c                |  478 +-
 arch/x86/crypto/serpent_avx_glue.c                 |  518 +--
 arch/x86/crypto/serpent_sse2_glue.c                |  519 +--
 arch/x86/crypto/sha1-mb/sha1_mb.c                  |   28 +-
 arch/x86/crypto/sha1-mb/sha1_mb_ctx.h              |    8 +-
 arch/x86/crypto/sha256-mb/sha256_mb.c              |   27 +-
 arch/x86/crypto/sha256-mb/sha256_mb_ctx.h          |    8 +-
 arch/x86/crypto/sha512-mb/sha512_mb.c              |   30 +-
 arch/x86/crypto/sha512-mb/sha512_mb_ctx.h          |    8 +-
 arch/x86/crypto/twofish_avx_glue.c                 |  493 +-
 arch/x86/crypto/twofish_glue_3way.c                |  339 +-
 arch/x86/include/asm/crypto/camellia.h             |   16 +-
 arch/x86/include/asm/crypto/glue_helper.h          |   75 +-
 arch/x86/include/asm/crypto/serpent-avx.h          |   17 +-
 arch/x86/include/asm/crypto/twofish.h              |   19 -
 crypto/Kconfig                                     |  129 +-
 crypto/Makefile                                    |    4 +-
 crypto/ablk_helper.c                               |  150 -
 crypto/ahash.c                                     |   25 +-
 crypto/algapi.c                                    |    8 -
 crypto/api.c                                       |   34 +-
 crypto/cfb.c                                       |  353 ++
 crypto/crypto_engine.c                             |  301 +-
 crypto/crypto_user.c                               |    2 +-
 crypto/ecc.c                                       |   23 +-
 crypto/ecdh.c                                      |   23 +-
 crypto/internal.h                                  |    1 -
 crypto/lrw.c                                       |  154 +-
 crypto/mcryptd.c                                   |   34 +-
 crypto/md4.c                                       |   17 -
 crypto/md5.c                                       |   17 -
 crypto/rsa-pkcs1pad.c                              |    2 +-
 crypto/simd.c                                      |   50 +
 crypto/sm4_generic.c                               |  244 +
 crypto/speck.c                                     |  307 ++
 crypto/tcrypt.c                                    |    3 +
 crypto/testmgr.c                                   |   45 +
 crypto/testmgr.h                                   | 4766 ++++++++++++++------
 crypto/xts.c                                       |   72 -
 drivers/char/hw_random/Kconfig                     |    7 +
 drivers/char/hw_random/Makefile                    |    1 +
 drivers/char/hw_random/bcm2835-rng.c               |    2 +
 drivers/char/hw_random/cavium-rng-vf.c             |    2 +-
 drivers/char/hw_random/cavium-rng.c                |    2 +-
 drivers/char/hw_random/imx-rngc.c                  |    2 +-
 drivers/char/hw_random/ks-sa-rng.c                 |  257 ++
 drivers/char/hw_random/mxc-rnga.c                  |   23 +-
 drivers/char/hw_random/omap-rng.c                  |   22 +-
 drivers/char/hw_random/stm32-rng.c                 |   44 +-
 drivers/crypto/Kconfig                             |   34 +-
 drivers/crypto/Makefile                            |    2 +-
 drivers/crypto/atmel-aes.c                         |    8 +-
 drivers/crypto/atmel-sha.c                         |    9 +-
 drivers/crypto/atmel-tdes.c                        |    9 +-
 drivers/crypto/bcm/cipher.c                        |    4 +-
 drivers/crypto/bcm/util.c                          |    1 -
 drivers/crypto/bfin_crc.c                          |  743 ---
 drivers/crypto/bfin_crc.h                          |  124 -
 drivers/crypto/caam/caamalg.c                      |   21 +-
 drivers/crypto/caam/caamalg_desc.c                 |  165 +-
 drivers/crypto/caam/caamalg_desc.h                 |   24 +-
 drivers/crypto/caam/caamalg_qi.c                   |  388 +-
 drivers/crypto/caam/ctrl.c                         |   42 +-
 drivers/crypto/caam/qi.c                           |   11 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |    2 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c           |    2 +-
 drivers/crypto/ccp/ccp-crypto-rsa.c                |    7 +-
 drivers/crypto/ccp/ccp-crypto-sha.c                |    2 +-
 drivers/crypto/ccp/ccp-debugfs.c                   |    7 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |    2 +-
 drivers/crypto/ccp/ccp-ops.c                       |  108 +-
 drivers/crypto/ccp/psp-dev.c                       |   23 +-
 drivers/crypto/ccp/sp-dev.c                        |    6 +-
 drivers/crypto/ccree/Makefile                      |    7 +
 drivers/crypto/ccree/cc_aead.c                     | 2718 +++++++++++
 drivers/crypto/ccree/cc_aead.h                     |  109 +
 drivers/crypto/ccree/cc_buffer_mgr.c               | 1651 +++++++
 drivers/crypto/ccree/cc_buffer_mgr.h               |   71 +
 drivers/crypto/ccree/cc_cipher.c                   | 1150 +++++
 drivers/crypto/ccree/cc_cipher.h                   |   59 +
 drivers/crypto/ccree/cc_crypto_ctx.h               |  133 +
 drivers/crypto/ccree/cc_debugfs.c                  |  101 +
 drivers/crypto/ccree/cc_debugfs.h                  |   32 +
 drivers/crypto/ccree/cc_driver.c                   |  518 +++
 drivers/crypto/ccree/cc_driver.h                   |  208 +
 drivers/crypto/ccree/cc_fips.c                     |  120 +
 drivers/crypto/ccree/cc_fips.h                     |   36 +
 drivers/crypto/ccree/cc_hash.c                     | 2296 ++++++++++
 drivers/crypto/ccree/cc_hash.h                     |  109 +
 drivers/crypto/ccree/cc_host_regs.h                |  145 +
 drivers/crypto/ccree/cc_hw_queue_defs.h            |  576 +++
 drivers/crypto/ccree/cc_ivgen.c                    |  279 ++
 drivers/crypto/ccree/cc_ivgen.h                    |   55 +
 drivers/crypto/ccree/cc_kernel_regs.h              |  168 +
 drivers/crypto/ccree/cc_lli_defs.h                 |   59 +
 drivers/crypto/ccree/cc_pm.c                       |  122 +
 drivers/crypto/ccree/cc_pm.h                       |   56 +
 drivers/crypto/ccree/cc_request_mgr.c              |  711 +++
 drivers/crypto/ccree/cc_request_mgr.h              |   51 +
 drivers/crypto/ccree/cc_sram_mgr.c                 |  120 +
 drivers/crypto/ccree/cc_sram_mgr.h                 |   65 +
 drivers/crypto/chelsio/chcr_algo.c                 |  577 ++-
 drivers/crypto/chelsio/chcr_algo.h                 |   11 +-
 drivers/crypto/chelsio/chcr_core.h                 |    6 +-
 drivers/crypto/chelsio/chcr_crypto.h               |   31 +-
 drivers/crypto/chelsio/chcr_ipsec.c                |    5 +-
 drivers/crypto/inside-secure/safexcel.c            |  114 +-
 drivers/crypto/inside-secure/safexcel.h            |   22 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |    5 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |  258 +-
 drivers/crypto/ixp4xx_crypto.c                     |    2 +
 drivers/crypto/marvell/cesa.c                      |    1 -
 drivers/crypto/mxs-dcp.c                           |   14 +
 drivers/crypto/n2_core.c                           |   12 +
 drivers/crypto/nx/nx-842-pseries.c                 |    5 +-
 drivers/crypto/omap-aes.c                          |  112 +-
 drivers/crypto/omap-aes.h                          |    3 +
 drivers/crypto/omap-crypto.c                       |    4 +
 drivers/crypto/omap-des.c                          |   24 +-
 drivers/crypto/omap-sham.c                         |  106 +-
 drivers/crypto/picoxcell_crypto.c                  |    2 +
 drivers/crypto/qat/qat_common/qat_algs.c           |    3 +
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |    9 +-
 drivers/crypto/s5p-sss.c                           |   34 +-
 drivers/crypto/sahara.c                            |    6 +-
 drivers/crypto/stm32/stm32-cryp.c                  |  964 +++-
 drivers/crypto/stm32/stm32-hash.c                  |   41 +-
 drivers/crypto/sunxi-ss/sun4i-ss-core.c            |    1 +
 drivers/crypto/talitos.c                           |  218 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |   14 +-
 drivers/crypto/ux500/hash/hash_core.c              |   18 +
 drivers/crypto/virtio/Kconfig                      |    1 -
 drivers/crypto/virtio/virtio_crypto_algs.c         |   16 +-
 drivers/crypto/virtio/virtio_crypto_common.h       |    4 +-
 drivers/crypto/virtio/virtio_crypto_core.c         |    3 -
 drivers/staging/ccree/Kconfig                      |    4 +-
 drivers/staging/ccree/Makefile                     |    2 +-
 include/crypto/ablk_helper.h                       |   32 -
 include/crypto/algapi.h                            |    1 -
 include/crypto/engine.h                            |   68 +-
 include/crypto/hash.h                              |   11 +-
 include/crypto/internal/hash.h                     |    5 -
 include/crypto/internal/simd.h                     |    7 +
 include/crypto/lrw.h                               |   44 -
 include/crypto/sm4.h                               |   28 +
 include/crypto/speck.h                             |   62 +
 include/crypto/xts.h                               |   17 -
 include/linux/byteorder/generic.h                  |   17 +
 include/linux/crypto.h                             |    8 +
 include/uapi/linux/psp-sev.h                       |    2 +-
 184 files changed, 23716 insertions(+), 9215 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
