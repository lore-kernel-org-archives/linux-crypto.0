Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78366C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Apr 2021 12:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3058A60233
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Apr 2021 12:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhDZMc6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Apr 2021 08:32:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49538 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231983AbhDZMc6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Apr 2021 08:32:58 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.89 #2 (Debian))
        id 1lb0PD-0007mD-HC; Mon, 26 Apr 2021 20:32:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lb0PA-0000hq-EW; Mon, 26 Apr 2021 20:32:00 +0800
Date:   Mon, 26 Apr 2021 20:32:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 5.13
Message-ID: <20210426123200.kgbyk6ayey4l4lrw@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20201012033249.GA25179@gondor.apana.org.au>
 <20201214055515.GA14196@gondor.apana.org.au>
 <20210215024721.GA20593@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210215024721.GA20593@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

API:

- crypto_destroy_tfm now ignores errors as well as NULL pointers.

Algorithms:

- Add explicit curve IDs in ECDH algorithm names.
- Add NIST P384 curve parameters.
- Add ECDSA.

Drivers:

- Add support for Green Sardine in ccp.
- Add ecdh/curve25519 to hisilicon/hpre.
- Add support for AM64 in sa2ul.

The following changes since commit a38fd8748464831584a19438cbb3082b5a2dab15:

  Linux 5.12-rc2 (2021-03-05 17:33:41 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to e3a606f2c544b231f6079c8c5fea451e772e1139:

  fsverity: relax build time dependency on CRYPTO_SHA256 (2021-04-22 17:31:32 +1000)

----------------------------------------------------------------
Aditya Srivastava (4):
      crypto: vmx - fix incorrect kernel-doc comment syntax in files
      crypto: amcc - fix incorrect kernel-doc comment syntax in files
      crypto: ux500 - fix incorrect kernel-doc comment syntax
      crypto: nx - fix incorrect kernel-doc comment syntax in files

Ard Biesheuvel (6):
      crypto: api - check for ERR pointers in crypto_destroy_tfm()
      crypto: arm/aes-scalar - switch to common rev_l/mov_l macros
      crypto: arm/chacha-scalar - switch to common rev_l macro
      crypto: arm64/aes-ce - deal with oversight in new CTR carry code
      fscrypt: relax Kconfig dependencies for crypto API algorithms
      fsverity: relax build time dependency on CRYPTO_SHA256

Arnd Bergmann (1):
      crypto: poly1305 - fix poly1305_core_setkey() declaration

Ayush Sawal (1):
      crypto: chelsio - Read rxchannel-id from firmware

Bhaskar Chowdhury (2):
      crypto: qat - fix spelling mistake: "messge" -> "message"
      crypto: inside-secure - Minor typo fix in the file safexcel.c

Christophe JAILLET (1):
      crypto: crc32-generic - Use SPDX-License-Identifier

Colin Ian King (3):
      crypto: sun8i-ss - Fix memory leak of object d when dma_iv fails to map
      crypto: sun8i-ss - Fix memory leak of pad
      crypto: sa2ul - Fix memory leak of rxd

Corentin Labbe (2):
      crypto: sun8i-ss - fix result memory leak on error path
      crypto: allwinner - add missing CRYPTO_ prefix

Devaraj Rangasamy (1):
      ccp: ccp - add support for Green Sardine

Eric Biggers (5):
      crypto: arm/blake2b - drop unnecessary return statement
      crypto: arm/blake2s - fix for big endian
      crypto: rng - fix crypto_rng_reset() refcounting when !CRYPTO_STATS
      random: initialize ChaCha20 constants with correct endianness
      random: remove dead code left over from blocking pool

Giovanni Cabiddu (1):
      crypto: qat - fix error path in adf_isr_resource_alloc()

Guobin Huang (2):
      crypto: geode - use DEFINE_SPINLOCK() for spinlock
      crypto: ixp4xx - use DEFINE_SPINLOCK() for spinlock

Hao Fang (1):
      crypto: hisilicon - use the correct HiSilicon copyright

Herbert Xu (3):
      crypto: serpent - Fix sparse byte order warnings
      crypto: aegis128 - Move simd prototypes into aegis.h
      Merge branch 'ecc'

Hui Tang (14):
      crypto: qat - fix unmap invalid dma address
      crypto: qat - fix use of 'dma_map_single'
      crypto: hisilicon/hpre - delete wrap of 'CONFIG_CRYPTO_DH'
      crypto: hisilicon/hpre - optimise 'hpre_algs_register' error path
      crypto: hisilicon - fix the check on dma address
      crypto: hisilicon/hpre - fix "hpre_ctx_init" resource leak
      crypto: hisilicon/hpre - fix Kconfig
      crypto: hisilicon/hpre - fix PASID setting on kunpeng 920
      crypto: hisilicon/hpre - fix a typo and delete redundant blank line
      crypto: hisilicon/hpre - delete redundant '\n'
      crypto: hisilicon/hpre - delete the rudundant space after return
      crypto: hisilicon/hpre - use the correct variable type
      crypto: hisilicon/hpre - add debug log
      crypto: hisilicon/hpre - delete redundant log and return in advance

Jia-Ju Bai (1):
      crypto: sun8i-ce - fix error return code in sun8i_ce_prng_generate()

Jiapeng Chong (2):
      crypto: ccp - A value assigned to a variable is never used
      crypto: chelsio - remove unused function

Kai Ye (11):
      crypto: testmgr - delete some redundant code
      crypto: rockchip - delete unneeded variable initialization
      crypto: hisilicon/sec - fixup checking the 3DES weak key
      crypto: hisilicon/qm - delete redundant code
      crypto: atmel - use the correct print format
      crypto: hisilicon/sec - use the correct print format
      crypto: hisilicon/sgl - add a comment for block size initialization
      crypto: hisilicon/sgl - delete unneeded variable initialization
      crypto: hisilicon/sgl - add some dfx logs
      crypto: hisilicon/sgl - fix the soft sg map to hardware sg
      crypto: hisilicon/sgl - fix the sg buf unmap

Krzysztof Kozlowski (4):
      crypto: s5p-sss - initialize APB clock after the AXI bus clock for SlimSSS
      crypto: s5p-sss - simplify getting of_device_id match data
      crypto: s5p-sss - remove unneeded local variable initialization
      crypto: s5p-sss - consistently use local 'dev' variable in probe()

Lee Jones (10):
      crypto: hisilicon/sec - Supply missing description for 'sec_queue_empty()'s 'queue' param
      crypto: bcm - Fix a whole host of kernel-doc misdemeanours
      crypto: chelsio - Fix some kernel-doc issues
      crypto: ux500/hash - Fix worthy kernel-doc headers and remove others
      crypto: keembay - Fix incorrectly named functions/structs
      crypto: atmel-ecc - Struct headers need to start with keyword 'struct'
      crypto: caam - Provide the name of the function and provide missing descriptions
      crypto: vmx - Source headers are not good kernel-doc candidates
      crypto: nx - Repair some kernel-doc problems
      crypto: nitrox - Demote non-compliant kernel-doc headers

Longfang Liu (5):
      crypto: hisilicon/sec - fixes a printing error
      crypto: hisilicon/sec - fixes some coding style
      crypto: hisilicon/sec - fixes some driver coding style
      crypto: hisilicon/sec - Fixes AES algorithm mode parameter problem
      crypto: hisilicon/sec - Fix a module parameter error

Lv Yunlong (1):
      crypto: qat - Fix a double free in adf_create_ring

Meng Yu (10):
      crypto: hisilicon/hpre - add version adapt to new algorithms
      crypto: hisilicon/hpre - add algorithm type
      crypto: ecdh - move curve_id of ECDH from the key to algorithm name
      crypto: ecc - expose ecc curves
      crypto: hisilicon/hpre - add 'ECDH' algorithm
      crypto: ecc - add curve25519 params and expose them
      crypto: hisilicon/hpre - add 'CURVE25519' algorithm
      crypto: ecc - Correct an error in the comments
      crypto: hisilicon/hpre - Add processing of src_data in 'CURVE25519'
      crypto: ecc - delete a useless function declaration

Milan Djurovic (3):
      crypto: jitterentropy - Put constants on the right side of the expression
      crypto: keywrap - Remove else after break statement
      crypto: fcrypt - Remove 'do while(0)' loop for single statement macro

Nathan Chancellor (1):
      crypto: arm/curve25519 - Move '.fpu' after '.arch'

Peter Ujfalusi (3):
      dt-bindings: crypto: ti,sa2ul: Add new compatible for AM64
      crypto: sa2ul - Support for per channel coherency
      crypto: sa2ul - Add support for AM64

Philipp Zabel (1):
      crypto: sun4i-ss - simplify optional reset handling

Randy Dunlap (2):
      crypto: doc - fix kernel-doc notation in chacha.c and af_alg.c
      crypto: camellia - drop duplicate "depends on CRYPTO"

Rijo Thomas (2):
      crypto: ccp - reduce tee command status polling interval from 5ms to 1ms
      crypto: ccp - fix command queuing to TEE ring buffer

Ruiqi Gong (1):
      crypto: hisilicon/hpre - fix a typo in hpre_crypto.c

Saulo Alessandre (4):
      crypto: ecc - Add NIST P384 curve parameters
      crypto: ecc - Add math to support fast NIST P384
      crypto: ecdsa - Register NIST P384 and extend test suite
      x509: Add OID for NIST P384 and extend parser for it

Shixin Liu (7):
      crypto: sun4i-ss - Fix PM reference leak when pm_runtime_get_sync() fails
      crypto: sun8i-ss - Fix PM reference leak when pm_runtime_get_sync() fails
      crypto: sun8i-ce - Fix PM reference leak in sun8i_ce_probe()
      crypto: stm32/hash - Fix PM reference leak on stm32-hash.c
      crypto: stm32/cryp - Fix PM reference leak on stm32-cryp.c
      crypto: sa2ul - Fix PM reference leak in sa_ul_probe()
      crypto: omap-aes - Fix PM reference leak on omap-aes.c

Srujana Challa (1):
      crypto: octeontx2 - add support for OcteonTX2 98xx CPT block.

Stefan Berger (5):
      oid_registry: Add OIDs for ECDSA with SHA224/256/384/512
      crypto: ecdsa - Add support for ECDSA signature verification
      x509: Detect sm2 keys by their parameters OID
      x509: Add support for parsing x509 certs with ECDSA keys
      ima: Support EC keys for signature verification

Tang Bin (1):
      crypto: amlogic - Fix unnecessary check in meson_crypto_probe()

Tang Yizhou (1):
      crypto: ccp - Use DEFINE_SPINLOCK() for spinlock

Thara Gopinath (11):
      crypto: qce - Restore/save ahash state with custom struct in export/import
      crypto: qce - Hold back a block of data to be transferred as part of final
      crypto: qce - Return unsupported if key1 and key 2 are same for AES XTS algorithm
      crypto: qce - Return unsupported if any three keys are same for DES3 algorithms
      crypto: qce - Return error for zero length messages
      crypto: qce - Return error for non-blocksize data(ECB/CBC algorithms)
      crypto: qce - Set ivsize to 0 for ecb(aes)
      crypto: qce - Improve the conditions for requesting AES fallback cipher
      crypto: qce - Set data unit size to message length for AES XTS transformation
      crypto: qce - Remover src_tbl from qce_cipher_reqctx
      crypto: qce - Remove totallen and offset in qce_start

Tian Tao (13):
      hwrng: ba431 - Use device-managed registration
      hwrng: xiphera-trng - use devm_platform_ioremap_resource() to simplify
      hwrng: bcm2835 - remove redundant null check
      hwrng: omap - Fix included header from 'asm'
      hwrng: cctrng - Use device-managed registration API
      hwrng: pic32 - Use device-managed registration API
      crypto: cavium - remove unused including <linux/version.h>
      hwrng: cctrng - use devm_platform_ioremap_resource() to simplify
      hwrng: ba431 - use devm_platform_ioremap_resource() to simplify
      hwrng: intel - Fix included header from 'asm
      hwrng: omap - Use of_device_get_match_data() helper
      crypto: cavium/zip - remove unused including <linux/version.h>
      crypto: ccp - Make ccp_dev_suspend and ccp_dev_resume void functions

Tom Lendacky (1):
      crypto: ccp - Don't initialize SEV support without the SEV feature

Tong Zhang (2):
      crypto: qat - don't release uninitialized resources
      crypto: qat - ADF_STATUS_PF_RUNNING should be set after adf_dev_init

Vinay Kumar Yadav (1):
      crypto: chelsio/chcr - Remove useless MODULE_VERSION

Wan Jiabing (1):
      crypto: ux500/cryp - Remove duplicate argument

Wang Qing (1):
      hwrng: cctrng - delete redundant printing of return value

Wei Yongjun (2):
      crypto: keembay-ocs-hcu - Fix error return code in kmb_ocs_hcu_probe()
      crypto: keembay-ocs-aes - Fix error return code in kmb_ocs_aes_probe()

Weili Qian (10):
      crypto: hisilicon/qm - set the total number of queues
      crypto: hisilicon/qm - move 'CURRENT_QM' code to qm.c
      crypto: hisilicon/qm - set the number of queues for function
      crypto: hisilicon/qm - add queue isolation support for Kunpeng930
      crypto: hisilicon/qm - add stop queue by hardware
      crypto: hisilicon/trng - add version to adapt new algorithm
      crypto: hisilicon - dynamic configuration 'err_info'
      crypto: hisilicon - support new error types for ZIP
      crypto: hisilicon - add new error type for SEC
      crypto: hisilicon - enable new error types for QM

Wojciech Ziemba (1):
      crypto: qat - enable detection of accelerators hang

Xiang Chen (4):
      crypto: amlogic - Fix the parameter of dma_unmap_sg()
      crypto: cavium - Fix the parameter of dma_unmap_sg()
      crypto: ux500 - Fix the parameter of dma_unmap_sg()
      crypto: allwinner - Fix the parameter of dma_unmap_sg()

Yang Li (2):
      crypto: powepc/sha1 - remove unneeded semicolon
      crypto: nx - add missing call to of_node_put()

Yang Shen (4):
      crypto: hisilicon/zip - adjust functions location
      crypto: hisilicon/zip - add comments for 'hisi_zip_sqe'
      crypto: hisilicon/zip - initialize operations about 'sqe' in 'acomp_alg.init'
      crypto: hisilicon/zip - support new 'sqe' type in Kunpeng930

YueHaibing (5):
      crypto: atmel-tdes - Remove redundant dev_err call in atmel_tdes_probe()
      crypto: img-hash - Remove redundant dev_err call in img_hash_probe()
      crypto: ux500 - Remove redundant dev_err calls
      crypto: keembay - Remove redundant dev_err calls
      crypto: ccree - Remove redundant dev_err call in init_cc_resources()

Zihao Tang (1):
      hwrng: core - convert sysfs sprintf/snprintf family to sysfs_emit

Álvaro Fernández Rojas (3):
      dt-bindings: rng: bcm2835: add clock constraints
      dt-bindings: rng: bcm2835: document reset support
      hwrng: bcm2835 - add reset support

 .../devicetree/bindings/crypto/ti,sa2ul.yaml       |  24 +-
 .../devicetree/bindings/rng/brcm,bcm2835.yaml      |  21 +
 arch/arm/crypto/aes-cipher-core.S                  |  42 +-
 arch/arm/crypto/blake2b-neon-glue.c                |   4 +-
 arch/arm/crypto/blake2s-core.S                     |  21 +
 arch/arm/crypto/chacha-scalar-core.S               |  43 +-
 arch/arm/crypto/curve25519-core.S                  |   2 +-
 arch/arm/crypto/poly1305-glue.c                    |   2 +-
 arch/arm64/crypto/aes-modes.S                      |   1 +
 arch/arm64/crypto/poly1305-glue.c                  |   2 +-
 arch/mips/crypto/poly1305-glue.c                   |   2 +-
 arch/powerpc/crypto/sha1-spe-glue.c                |   2 +-
 arch/x86/crypto/poly1305_glue.c                    |   6 +-
 crypto/Kconfig                                     |  15 +-
 crypto/Makefile                                    |   6 +
 crypto/aegis.h                                     |  19 +
 crypto/aegis128-core.c                             |  15 -
 crypto/aegis128-neon.c                             |  10 +-
 crypto/af_alg.c                                    |  94 ++-
 crypto/api.c                                       |   2 +-
 crypto/asymmetric_keys/public_key.c                |   4 +-
 crypto/asymmetric_keys/x509_cert_parser.c          |  49 +-
 crypto/asymmetric_keys/x509_public_key.c           |   4 +-
 crypto/crc32_generic.c                             |  24 +-
 crypto/ecc.c                                       | 291 +++++--
 crypto/ecc.h                                       |  49 +-
 crypto/ecc_curve_defs.h                            |  49 ++
 crypto/ecdh.c                                      |  72 +-
 crypto/ecdh_helper.c                               |   4 +-
 crypto/ecdsa.c                                     | 376 +++++++++
 crypto/ecdsasignature.asn1                         |   4 +
 crypto/fcrypt.c                                    |   5 +-
 crypto/jitterentropy.c                             |   8 +-
 crypto/keywrap.c                                   |   4 +-
 crypto/rng.c                                       |  10 +-
 crypto/serpent_generic.c                           |  39 +-
 crypto/testmgr.c                                   |  42 +-
 crypto/testmgr.h                                   | 458 +++++++++-
 drivers/char/hw_random/ba431-rng.c                 |  16 +-
 drivers/char/hw_random/bcm2835-rng.c               |  27 +-
 drivers/char/hw_random/cctrng.c                    |  20 +-
 drivers/char/hw_random/core.c                      |   2 +-
 drivers/char/hw_random/intel-rng.c                 |   2 +-
 drivers/char/hw_random/omap-rng.c                  |  14 +-
 drivers/char/hw_random/pic32-rng.c                 |   3 +-
 drivers/char/hw_random/xiphera-trng.c              |   4 +-
 drivers/char/random.c                              |  21 +-
 drivers/crypto/allwinner/Kconfig                   |  14 +-
 .../crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c    |   2 +-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c  |  23 +-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c  |   2 +-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c  |   2 +-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   9 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |   2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c  |   3 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c  |   1 +
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |  11 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |   2 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |  12 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c  |   4 +-
 drivers/crypto/amcc/crypto4xx_alg.c                |  12 +-
 drivers/crypto/amcc/crypto4xx_core.c               |  18 +-
 drivers/crypto/amcc/crypto4xx_core.h               |   4 +-
 drivers/crypto/amcc/crypto4xx_reg_def.h            |   8 +-
 drivers/crypto/amcc/crypto4xx_sa.h                 |  18 +-
 drivers/crypto/amcc/crypto4xx_trng.h               |   2 +-
 drivers/crypto/amlogic/amlogic-gxl-cipher.c        |   6 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c          |   3 -
 drivers/crypto/atmel-ecc.c                         |  30 +-
 drivers/crypto/atmel-i2c.c                         |   2 +-
 drivers/crypto/atmel-sha.c                         |   4 +-
 drivers/crypto/atmel-tdes.c                        |   1 -
 drivers/crypto/bcm/cipher.c                        |   7 +-
 drivers/crypto/bcm/spu.c                           |  16 +-
 drivers/crypto/bcm/spu2.c                          |  43 +-
 drivers/crypto/bcm/util.c                          |   4 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   3 +
 drivers/crypto/caam/caampkc.c                      |   3 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |   1 -
 drivers/crypto/cavium/nitrox/nitrox_isr.c          |   4 +-
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c       |   9 +-
 drivers/crypto/cavium/zip/common.h                 |   1 -
 drivers/crypto/ccp/ccp-crypto-main.c               |   3 +-
 drivers/crypto/ccp/ccp-dev.c                       |  12 +-
 drivers/crypto/ccp/ccp-ops.c                       |   1 -
 drivers/crypto/ccp/sev-dev.c                       |   6 +
 drivers/crypto/ccp/sp-dev.c                        |  12 +-
 drivers/crypto/ccp/sp-dev.h                        |  15 +-
 drivers/crypto/ccp/sp-pci.c                        |   1 +
 drivers/crypto/ccp/tee-dev.c                       |  57 +-
 drivers/crypto/ccp/tee-dev.h                       |  20 +-
 drivers/crypto/ccree/cc_driver.c                   |   4 +-
 drivers/crypto/chelsio/chcr_algo.c                 |  32 +-
 drivers/crypto/chelsio/chcr_core.c                 |   5 +-
 drivers/crypto/chelsio/chcr_core.h                 |   1 -
 drivers/crypto/geode-aes.c                         |   4 +-
 drivers/crypto/hisilicon/Kconfig                   |   2 +
 drivers/crypto/hisilicon/hpre/hpre.h               |  18 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        | 921 ++++++++++++++++++++-
 drivers/crypto/hisilicon/hpre/hpre_main.c          | 158 ++--
 drivers/crypto/hisilicon/qm.c                      | 396 +++++++--
 drivers/crypto/hisilicon/qm.h                      |  29 +-
 drivers/crypto/hisilicon/sec/sec_algs.c            |   2 +-
 drivers/crypto/hisilicon/sec/sec_drv.c             |  13 +-
 drivers/crypto/hisilicon/sec/sec_drv.h             |   2 +-
 drivers/crypto/hisilicon/sec2/sec.h                |  10 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         | 137 +--
 drivers/crypto/hisilicon/sec2/sec_crypto.h         |   6 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           | 267 +++---
 drivers/crypto/hisilicon/sgl.c                     |  37 +-
 drivers/crypto/hisilicon/trng/trng.c               |  13 +-
 drivers/crypto/hisilicon/zip/zip.h                 |  50 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c          | 710 +++++++++-------
 drivers/crypto/hisilicon/zip/zip_main.c            |  99 +--
 drivers/crypto/img-hash.c                          |   3 -
 drivers/crypto/inside-secure/safexcel.c            |   2 +-
 drivers/crypto/ixp4xx_crypto.c                     |   7 +-
 drivers/crypto/keembay/keembay-ocs-aes-core.c      |   8 +-
 drivers/crypto/keembay/keembay-ocs-hcu-core.c      |   8 +-
 drivers/crypto/keembay/ocs-hcu.c                   |   8 +-
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h |  10 +-
 .../marvell/octeontx2/otx2_cpt_mbox_common.c       |  14 +-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c      |   8 +-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h      |   1 +
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h      |   1 +
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |  33 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    | 144 +++-
 drivers/crypto/nx/nx-aes-cbc.c                     |   2 +-
 drivers/crypto/nx/nx-aes-ccm.c                     |   2 +-
 drivers/crypto/nx/nx-aes-ctr.c                     |   2 +-
 drivers/crypto/nx/nx-aes-ecb.c                     |   2 +-
 drivers/crypto/nx/nx-aes-gcm.c                     |   2 +-
 drivers/crypto/nx/nx-aes-xcbc.c                    |   2 +-
 drivers/crypto/nx/nx-common-powernv.c              |   4 +-
 drivers/crypto/nx/nx-sha256.c                      |   2 +-
 drivers/crypto/nx/nx-sha512.c                      |   2 +-
 drivers/crypto/nx/nx.c                             |   5 +-
 drivers/crypto/nx/nx_debugfs.c                     |   2 +-
 drivers/crypto/omap-aes.c                          |   7 +-
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c     |   1 +
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |   1 +
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c           |   4 +-
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c     |   1 +
 drivers/crypto/qat/qat_c62xvf/adf_drv.c            |   4 +-
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |   1 +
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.c   |  25 +
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.h   |  13 +
 drivers/crypto/qat/qat_common/adf_gen4_hw_data.c   |  40 +
 drivers/crypto/qat/qat_common/adf_gen4_hw_data.h   |  14 +-
 drivers/crypto/qat/qat_common/adf_init.c           |   4 +
 drivers/crypto/qat/qat_common/adf_isr.c            |  29 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |   2 +-
 drivers/crypto/qat/qat_common/adf_transport.c      |   1 +
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c      |   4 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |  17 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |  32 +-
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |   4 +-
 drivers/crypto/qce/cipher.h                        |   1 -
 drivers/crypto/qce/common.c                        |  25 +-
 drivers/crypto/qce/common.h                        |   3 +-
 drivers/crypto/qce/sha.c                           | 143 ++--
 drivers/crypto/qce/skcipher.c                      |  69 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |   2 +-
 drivers/crypto/s5p-sss.c                           |  17 +-
 drivers/crypto/sa2ul.c                             | 143 +++-
 drivers/crypto/sa2ul.h                             |   4 +
 drivers/crypto/stm32/stm32-cryp.c                  |   4 +-
 drivers/crypto/stm32/stm32-hash.c                  |   8 +-
 drivers/crypto/ux500/cryp/cryp.c                   |   5 +-
 drivers/crypto/ux500/cryp/cryp.h                   |   2 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |  10 +-
 drivers/crypto/ux500/cryp/cryp_irq.c               |   2 +-
 drivers/crypto/ux500/cryp/cryp_irq.h               |   4 +-
 drivers/crypto/ux500/cryp/cryp_irqp.h              |   4 +-
 drivers/crypto/ux500/cryp/cryp_p.h                 |  15 +-
 drivers/crypto/ux500/hash/hash_core.c              |  18 +-
 drivers/crypto/vmx/aes.c                           |   2 +-
 drivers/crypto/vmx/aes_cbc.c                       |   2 +-
 drivers/crypto/vmx/aes_ctr.c                       |   2 +-
 drivers/crypto/vmx/aes_xts.c                       |   2 +-
 drivers/crypto/vmx/ghash.c                         |   2 +-
 drivers/crypto/vmx/vmx.c                           |   2 +-
 fs/crypto/Kconfig                                  |  30 +-
 fs/verity/Kconfig                                  |   8 +-
 include/crypto/acompress.h                         |   2 +
 include/crypto/aead.h                              |   2 +
 include/crypto/akcipher.h                          |   2 +
 include/crypto/chacha.h                            |   9 +-
 include/crypto/ecc_curve.h                         |  60 ++
 include/crypto/ecdh.h                              |   3 +-
 include/crypto/hash.h                              |   4 +
 include/crypto/internal/poly1305.h                 |   3 +-
 include/crypto/kpp.h                               |   2 +
 include/crypto/poly1305.h                          |   6 +-
 include/crypto/rng.h                               |   2 +
 include/crypto/skcipher.h                          |   2 +
 include/keys/asymmetric-type.h                     |   6 +
 include/linux/oid_registry.h                       |  10 +-
 include/trace/events/random.h                      |  83 --
 include/uapi/misc/uacce/hisi_qm.h                  |   1 +
 lib/crypto/chacha.c                                |   4 +-
 lib/crypto/poly1305-donna32.c                      |   3 +-
 lib/crypto/poly1305-donna64.c                      |   3 +-
 lib/crypto/poly1305.c                              |   3 +-
 lib/oid_registry.c                                 |  24 +
 net/bluetooth/ecdh_helper.c                        |   2 -
 net/bluetooth/selftest.c                           |   2 +-
 net/bluetooth/smp.c                                |   6 +-
 security/integrity/digsig_asymmetric.c             |  30 +-
 209 files changed, 4558 insertions(+), 1986 deletions(-)
 create mode 100644 crypto/ecdsa.c
 create mode 100644 crypto/ecdsasignature.asn1
 create mode 100644 include/crypto/ecc_curve.h

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
