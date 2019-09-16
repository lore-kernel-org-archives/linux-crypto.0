Return-Path: <SRS0=68iz=XL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBBCC4CECC
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Sep 2019 08:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2C7D216F4
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Sep 2019 08:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfIPItQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Sep 2019 04:49:16 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33890 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfIPItQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Sep 2019 04:49:16 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i9mgx-0005HR-LD; Mon, 16 Sep 2019 18:49:04 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Sep 2019 18:49:01 +1000
Date:   Mon, 16 Sep 2019 18:49:01 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 5.4
Message-ID: <20190916084901.GA20338@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

API:

- Add the ability to abort a skcipher walk.

Algorithms:

- Fix XTS to actually do the stealing.
- Add library helpers for AES and DES for single-block users.
- Add library helpers for SHA256.
- Add new DES key verification helper.
- Add surrounding bits for ESSIV generator.
- Add accelerations for aegis128.
- Add test vectors for lzo-rle.

Drivers:

- Add i.MX8MQ support to caam.
- Add gcm/ccm/cfb/ofb aes support in inside-secure.
- Add ofb/cfb aes support in media-tek.
- Add HiSilicon ZIP accelerator support.

Others:

- Fix potential race condition in padata.
- Use unbound workqueues in padata.

Please note that there is a conflict with mainline due to the
sha256 library change.  There is also a conflit with the s390
tree due to changes in the s390 crypto code.  Finally there is
a conflict with arm-soc due to a DTS change.

The following changes since commit 5f9e832c137075045d15cd6899ab0505cfb2ca4b:

  Linus 5.3-rc1 (2019-07-21 14:05:38 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

for you to fetch changes up to 9575d1a5c0780ea26ff8dd29c94a32be32ce3c85:

  crypto: caam - Cast to long first before pointer conversion (2019-09-13 21:20:47 +1000)

----------------------------------------------------------------
Alexander Sverdlin (1):
      crypto: qat - Silence smp_processor_id() warning

Andrey Smirnov (20):
      crypto: caam - move DMA mask selection into a function
      crypto: caam - simplfy clock initialization
      crypto: caam - convert caam_jr_init() to use devres
      crypto: caam - request JR IRQ as the last step
      crytpo: caam - make use of iowrite64*_hi_lo in wr_reg64
      crypto: caam - use ioread64*_hi_lo in rd_reg64
      crypto: caam - drop 64-bit only wr/rd_reg64()
      crypto: caam - share definition for MAX_SDLEN
      crypto: caam - make CAAM_PTR_SZ dynamic
      crypto: caam - move cpu_to_caam_dma() selection to runtime
      crypto: caam - drop explicit usage of struct jr_outentry
      crypto: caam - don't hardcode inpentry size
      crypto: caam - select DMA address size at runtime
      crypto: caam - always select job ring via RSR on i.MX8MQ
      crypto: caam - add clock entry for i.MX8MQ
      crypto: caam - make sure clocks are enabled first
      crypto: caam - use devres to unmap JR's registers
      crypto: caam - check irq_of_parse_and_map for errors
      crypto: caam - dispose of IRQ mapping only after IRQ is freed
      arm64: dts: imx8mq: Add CAAM node

Anson Huang (2):
      hwrng: imx-rngc - use devm_platform_ioremap_resource() to simplify code
      hwrng: mxc-rnga - use devm_platform_ioremap_resource() to simplify code

Ard Biesheuvel (103):
      crypto: arm/aes-ce - cosmetic/whitespace cleanup
      crypto: aes - rename local routines to prevent future clashes
      crypto: aes/fixed-time - align key schedule with other implementations
      crypto: aes - create AES library based on the fixed time AES code
      crypto: x86/aes-ni - switch to generic for fallback and key routines
      crypto: x86/aes - drop scalar assembler implementations
      crypto: padlock/aes - switch to library version of key expansion routine
      crypto: cesa/aes - switch to library version of key expansion routine
      crypto: safexcel/aes - switch to library version of key expansion routine
      crypto: arm64/ghash - switch to AES library
      crypto: arm/aes-neonbs - switch to library version of key expansion routine
      crypto: arm64/aes-ccm - switch to AES library
      crypto: arm64/aes-neonbs - switch to library version of key expansion routine
      crypto: arm64/aes-ce - switch to library version of key expansion routine
      crypto: aes-generic - drop key expansion routine in favor of library version
      crypto: ctr - add helper for performing a CTR encryption walk
      crypto: aes - move sync ctr(aes) to AES library and generic helper
      crypto: arm64/aes-ce-cipher - use AES library as fallback
      crypto: arm/aes - use native endiannes for key schedule
      crypto: arm/aes-ce - provide a synchronous version of ctr(aes)
      crypto: arm/aes-neonbs - provide a synchronous version of ctr(aes)
      crypto: arm/ghash - provide a synchronous version
      bluetooth: switch to AES library
      crypto: amcc - switch to AES library for GCM key derivation
      crypto: ccp - move to AES library for CMAC key derivation
      crypto: chelsio - replace AES cipher calls with library calls
      crypto: aes-generic - unexport last-round AES tables
      crypto: lib/aes - export sbox and inverse sbox
      crypto: arm64/aes-neon - switch to shared AES Sboxes
      crypto: arm/aes-cipher - switch to shared AES inverse Sbox
      crypto: arm64/aes-cipher - switch to shared AES inverse Sbox
      crypto: arm/aes-scalar - unexport en/decryption routines
      crypto: morus - remove generic and x86 implementations
      crypto: aegis128l/aegis256 - remove x86 and generic implementations
      crypto: aegis128 - drop empty TFM init/exit routines
      crypto: aegis - avoid prerotated AES tables
      crypto: aegis128 - add support for SIMD acceleration
      crypto: aegis128 - provide a SIMD implementation based on NEON intrinsics
      crypto: tcrypt - add a speed test for AEGIS128
      crypto: s390/aes - fix name clash after AES library refactor
      asm-generic: make simd.h a mandatory include/asm header
      crypto: xts - add support for ciphertext stealing
      crypto: aegis128 - add support for SIMD acceleration
      crypto: aegis128 - provide a SIMD implementation based on NEON intrinsics
      crypto: arm64/aegis128 - implement plain NEON version
      crypto: des/3des_ede - add new helpers to verify keys
      crypto: s390/des - switch to new verification routines
      crypto: sparc/des - switch to new verification routines
      crypto: atmel/des - switch to new verification routines
      crypto: bcm/des - switch to new verification routines
      crypto: caam/des - switch to new verification routines
      crypto: cpt/des - switch to new verification routines
      crypto: nitrox/des - switch to new verification routines
      crypto: ccp/des - switch to new verification routines
      crypto: ccree/des - switch to new verification routines
      crypto: hifn/des - switch to new verification routines
      crypto: hisilicon/des - switch to new verification routines
      crypto: safexcel/des - switch to new verification routines
      crypto: ixp4xx/des - switch to new verification routines
      crypto: cesa/des - switch to new verification routines
      crypto: n2/des - switch to new verification routines
      crypto: omap/des - switch to new verification routines
      crypto: picoxcell/des - switch to new verification routines
      crypto: qce/des - switch to new verification routines
      crypto: rk3288/des - switch to new verification routines
      crypto: stm32/des - switch to new verification routines
      crypto: sun4i/des - switch to new verification routines
      crypto: talitos/des - switch to new verification routines
      crypto: ux500/des - switch to new verification routines
      crypto: 3des - move verification out of exported routine
      crypto: des - remove unused function
      crypto: des - split off DES library from generic DES cipher driver
      crypto: x86/des - switch to library interface
      crypto: des - remove now unused __des3_ede_setkey()
      fs: cifs: move from the crypto cipher API to the new DES library interface
      crypto: x86/xts - implement support for ciphertext stealing
      crypto: s390/xts-aes - invoke fallback for ciphertext stealing
      crypto: vmx/xts - use fallback for ciphertext stealing
      crypto: s390/aes - fix typo in XTS_BLOCK_SIZE identifier
      crypto: n2/des - fix build breakage after DES updates
      crypto: arm64/aegis128 - use explicit vector load for permute vectors
      crypto: essiv - add tests for essiv in cbc(aes)+sha256 mode
      crypto: arm64/aes-cts-cbc - factor out CBC en/decryption of a walk
      crypto: arm64/aes - implement accelerated ESSIV/CBC mode
      crypto: s5p - deal gracefully with bogus input sizes
      crypto: s5p - use correct block size of 1 for ctr(aes)
      crypto: ccp - invoke fallback for XTS ciphertext stealing
      crypto: arm/aes - fix round key prototypes
      crypto: arm/aes-ce - yield the SIMD unit between scatterwalk steps
      crypto: arm/aes-ce - switch to 4x interleave
      crypto: arm/aes-ce - replace tweak mask literal with composition
      crypto: arm/aes-neonbs - replace tweak mask literal with composition
      crypto: arm64/aes-neonbs - replace tweak mask literal with composition
      crypto: arm64/aes-neon - limit exposed routines if faster driver is enabled
      crypto: skcipher - add the ability to abort a skcipher walk
      crypto: arm64/aes-cts-cbc-ce - performance tweak
      crypto: arm64/aes-cts-cbc - move request context data to the stack
      crypto: arm64/aes - implement support for XTS ciphertext stealing
      crypto: arm64/aes-neonbs - implement ciphertext stealing for XTS
      crypto: arm/aes-ce - implement ciphertext stealing for XTS
      crypto: arm/aes-neonbs - implement ciphertext stealing for XTS
      crypto: arm/aes-ce - implement ciphertext stealing for CBC
      crypto: x86/aes-ni - use AES library instead of single-use AES cipher

Arnd Bergmann (3):
      crypto: ccp - Reduce maximum stack usage
      crypto: aegis - fix badly optimized clang output
      crypto: jitterentropy - build without sanitizer

Bjorn Helgaas (2):
      crypto: ccp - Include DMA declarations explicitly
      crypto: ccp - Remove unnecessary linux/pci.h include

Christophe JAILLET (1):
      crypto: picoxcell - Fix the name of the module in the description of CRYPTO_DEV_PICOXCELL

Chuhong Yuan (4):
      crypto: ccp - Replace dma_pool_alloc + memset with dma_pool_zalloc
      crypto: atmel-sha204a - Use device-managed registration API
      hwrng: drivers - Use device-managed registration API
      crypto: cryptd - Use refcount_t for refcount

Colin Ian King (1):
      crypto: ccree - fix spelling mistake "configration" -> "configuration"

Daniel Jordan (11):
      padata: purge get_cpu and reorder_via_wq from padata_do_serial
      padata: initialize pd->cpu with effective cpumask
      padata: allocate workqueue internally
      workqueue: unconfine alloc/apply/free_workqueue_attrs()
      workqueue: require CPU hotplug read exclusion for apply_workqueue_attrs
      padata: make padata_do_parallel find alternate callback CPU
      crypto: pcrypt - remove padata cpumask notifier
      padata, pcrypt: take CPU hotplug lock internally in padata_alloc_possible
      padata: use separate workqueues for parallel and serial work
      padata: unbind parallel jobs from specific CPUs
      padata: remove cpu_index from the parallel_queue

Daniel Mack (1):
      hwrng: timeriomem - relax check on memory resource size

Denis Efremov (1):
      MAINTAINERS: nx crypto: Fix typo in a filepath

Eric Biggers (1):
      crypto: ghash - add comment and improve help text

Fuqian Huang (1):
      crypto: drivers - Use kmemdup rather than duplicating its implementation

Gary R Hook (2):
      crypto: ccp - Log an error message when ccp-crypto fails to load
      crypto: ccp - Clean up and exit correctly on allocation failure

Gilad Ben-Yossef (6):
      crypto: ccree - drop legacy ivgen support
      crypto: ccree - account for TEE not ready to report
      crypto: fips - add FIPS test failure notification chain
      crypto: ccree - notify TEE on FIPS tests errors
      crypto: ccree - use the full crypt length value
      crypto: ccree - use std api sg_zero_buffer

Gustavo A. R. Silva (1):
      crypto: ux500/crypt - Mark expected switch fall-throughs

Hannah Pan (1):
      crypto: testmgr - add tests for lzo-rle

Hans de Goede (17):
      crypto: sha256 - Fix some coding style issues
      crypto: sha256_generic - Fix some coding style issues
      crypto: sha256 - Move lib/sha256.c to lib/crypto
      crypto: sha256 - Use get/put_unaligned_be32 to get input, memzero_explicit
      crypto: sha256 - Make lib/crypto/sha256.c suitable for generic use
      crypto: sha256 - Add sha224 support to sha256 library code
      crypto: sha256_generic - Switch to the generic lib/crypto/sha256.c lib code
      crypto: sha256 - Add missing MODULE_LICENSE() to lib/crypto/sha256.c
      crypto: arm - Rename functions to avoid conflict with crypto/sha256.h
      crypto: arm64 - Rename functions to avoid conflict with crypto/sha256.h
      crypto: s390 - Rename functions to avoid conflict with crypto/sha256.h
      crypto: x86 - Rename functions to avoid conflict with crypto/sha256.h
      crypto: ccree - Rename arrays to avoid conflict with crypto/sha256.h
      crypto: chelsio - Rename arrays to avoid conflict with crypto/sha256.h
      crypto: n2 - Rename arrays to avoid conflict with crypto/sha256.h
      crypto: sha256 - Merge crypto/sha256.h into crypto/sha.h
      crypto: sha256 - Remove sha256/224_init code duplication

Herbert Xu (9):
      crypto: Remove orphan tools/crypto directory
      padata: Replace delayed timer with immediate workqueue in padata_reorder
      Revert "crypto: aegis128 - add support for SIMD acceleration"
      asm-generic: Remove redundant arch-specific rules for simd.h
      crypto: hisilicon - Fix warning on printing %p with dma_addr_t
      crypto: talitos - Fix build warning in aead_des3_setkey
      crypto: skcipher - Unmap pages after an external error
      crypto: ux500 - Fix COMPILE_TEST warnings
      crypto: caam - Cast to long first before pointer conversion

Hook, Gary (5):
      crypto: ccp - Make CCP debugfs support optional
      crypto: ccp - Add a module parameter to specify a queue count
      crypto: ccp - module parameter to limit the number of enabled CCPs
      crypto: ccp - Add a module parameter to control registration for DMA
      crypto: ccp - Include the module name in system log messages

Horia Geantă (8):
      crypto: caam - defer probing until QMan is available
      crypto: caam - fix concurrency issue in givencrypt descriptor
      crypto: caam/qi - fix error handling in ERN handler
      crypto: caam - fix return code in completion callbacks
      crypto: caam - update IV only when crypto operation succeeds
      crypto: caam - keep both virtual and dma key addresses
      crypto: caam - fix MDHA key derivation for certain user key lengths
      crypto: caam/qi - execute library only on DPAA 1.x

Iuliana Prodan (15):
      crypto: ccree - check assoclen for rfc4543
      crypto: bcm - check assoclen for rfc4543/rfc4106
      crypto: gcm - helper functions for assoclen/authsize check
      crypto: aes - helper function to validate key length for AES algorithms
      crypto: caam - check key length
      crypto: caam - check authsize
      crypto: caam - check assoclen
      crypto: caam - check zero-length input
      crypto: caam - update rfc4106 sh desc to support zero length input
      crypto: caam - free resources in case caam_rng registration failed
      crypto: caam - execute module exit point only if necessary
      crypto: caam - unregister algorithm only if the registration succeeded
      crypto: caam - change return value in case CAAM has no MDHA
      crypto: gcm - restrict assoclen for rfc4543
      crypto: caam/qi - use print_hex_dump_debug function to print debug messages

Jonathan Neuschäfer (1):
      Documentation: crypto: crypto_engine: Fix Sphinx warning

Mao Wenan (1):
      crypto: hisilicon - select CRYPTO_LIB_DES while compiling SEC driver

Masahiro Yamada (3):
      crypto: add header include guards
      crypto: user - fix potential warnings in cryptouser.h
      hwrng: timeriomem - add include guard to timeriomem-rng.h

Nathan Chancellor (1):
      lib/mpi: Eliminate unused umul_ppmm definitions for MIPS

Nishka Dasgupta (1):
      crypto: nx - Add of_node_put() before return in 842

Ondrej Mosnacek (1):
      crypto: user - make NETLINK_CRYPTO work inside netns

Pascal van Leeuwen (36):
      crypto: inside-secure - keep ivsize for DES ECB modes at 0
      crypto: inside-secure - silently return -EINVAL for input error cases
      crypto: inside-secure - fix incorrect skcipher output IV
      crypto: inside-secure - fix scatter/gather list to descriptor conversion
      crypto: inside-secure - fix EINVAL error (buf overflow) for AEAD decrypt
      crypto: inside-secure: back out parts of earlier HMAC update workaround
      crypto: inside-secure - let HW deal with initial hash digest
      crypto: inside-secure - add support for arbitrary size hash/HMAC updates
      crypto: inside-secure - add support for 0 length HMAC messages
      crypto: inside-secure - add support for authenc(hmac(sha1),cbc(des3_ede))
      crypto: inside-secure - added support for rfc3686(ctr(aes))
      crypto: inside-secure - add support for authenc(hmac(sha*),rfc3686(ctr(aes))) suites
      crypto: inside-secure -reduce hash byte counters to 64 bits
      crypto: inside-secure - Use defines instead of some constants (cosmetic)
      crypto: inside-secure - Remove redundant DES ECB & CBC keysize check
      crypto: aead - Do not allow authsize=0 if auth. alg has digestsize>0
      crypto: inside-secure - make driver selectable for non-Marvell hardware
      crypto: inside-secure - Remove redundant algo to engine mapping code
      crypto: inside-secure - add support for PCI based FPGA development board
      crypto: inside-secure - add support for using the EIP197 without vendor firmware
      crypto: inside-secure - Move static cipher alg & mode settings to init
      crypto: inside-secure - Add support for the AES-XTS algorithm
      crypto: inside-secure - Only enable algorithms advertised by the hardware
      crypto: inside-secure - Made .cra_priority value a define
      crypto: inside-secure - Minor optimization recognizing CTR is always AES
      crypto: inside-secure - Minor code cleanup and optimizations
      crypto: inside-secure - Added support for basic AES-GCM
      crypto: inside-secure - Added AES-CFB support
      crypto: inside-secure - Added AES-OFB support
      crypto: inside-secure - Added support for basic AES-CCM
      crypto: inside-secure - Add EIP97/EIP197 and endianness detection
      crypto: inside-secure: Corrected configuration of EIP96_TOKEN_CTRL
      crypto: inside-secure - Enable extended algorithms on newer HW
      crypto: inside-secure - Base CD fetchcount on actual CD FIFO size
      crypto: inside-secure - Base RD fetchcount on actual RD FIFO size
      crypto: inside-secure - Probe transform record cache RAM sizes

Peter Zijlstra (1):
      crypto: engine - Reduce default RT priority

Phani Kiran Hemadri (3):
      crypto: cavium/nitrox - Add support for loading asymmetric crypto firmware
      crypto: cavium/nitrox - Allocate asymmetric crypto command queues
      crypto: cavium/nitrox - Configure asymmetric queue manager Hardware unit

Ryder Lee (4):
      crypto: mediatek - move mtk_aes_find_dev() to the right place
      crypto: mediatek - fix uninitialized value of gctx->textlen
      crypto: mediatek - only treat EBUSY as transient if backlog
      crypto: mediatek - add support to OFB/CFB mode

Sebastian Andrzej Siewior (1):
      crypto: ux500 - Use spinlock_t instead of struct spinlock

Stephen Boyd (4):
      crypto: drivers - Remove dev_err() usage after platform_get_irq()
      hwrng: core - Freeze khwrng thread during suspend
      random: Support freezable kthreads in add_hwgenerator_randomness()
      random: Use wait_event_freezable() in add_hwgenerator_randomness()

Stephen Rothwell (1):
      hwrng: n2-drv - fix typo

Thomas Gleixner (1):
      crypto: api - Remove redundant #ifdef in crypto_yield()

Uri Shir (1):
      crypto: ccree - enable CTS support in AES-XTS

Vakul Garg (2):
      crypto: caam/qi2 - Increase napi budget to process more caam responses
      crypto: caam/qi2 - Add printing dpseci fq stats using debugfs

Vic Wu (1):
      crypto: mediatek - fix incorrect crypto key setting

Wei Yongjun (1):
      crypto: cavium/zip - Add missing single_release()

YueHaibing (17):
      crypto: artpec6 - use devm_platform_ioremap_resource() to simplify code
      crypto: ccp - use devm_platform_ioremap_resource() to simplify code
      crypto: exynos - use devm_platform_ioremap_resource() to simplify code
      crypto: img-hash - use devm_platform_ioremap_resource() to simplify code
      crypto: inside-secure - use devm_platform_ioremap_resource() to simplify code
      crypto: mediatek - use devm_platform_ioremap_resource() to simplify code
      crypto: picoxcell - use devm_platform_ioremap_resource() to simplify code
      crypto: sunxi-ss - use devm_platform_ioremap_resource() to simplify code
      crypto: rockchip - use devm_platform_ioremap_resource() to simplify code
      crypto: stm32 - use devm_platform_ioremap_resource() to simplify code
      crypto: qce - use devm_platform_ioremap_resource() to simplify code
      crypto: qcom-rng - use devm_platform_ioremap_resource() to simplify code
      crypto: aes-generic - remove unused variable 'rco_tab'
      crypto: streebog - remove two unused variables
      crypto: aegis128 - Fix -Wunused-const-variable warning
      crypto: atmel - Fix -Wunused-const-variable warning
      crypto: nx - remove unused variables 'nx_driver_string' and 'nx_driver_version'

Zhou Wang (12):
      crypto: hisilicon - add queue management driver for HiSilicon QM module
      crypto: hisilicon - add hardware SGL support
      crypto: hisilicon - add HiSilicon ZIP accelerator support
      crypto: hisilicon - add SRIOV support for ZIP
      Documentation: Add debugfs doc for hisi_zip
      crypto: hisilicon - add debugfs for ZIP and QM
      MAINTAINERS: add maintainer for HiSilicon QM and ZIP controller driver
      crypto: hisilicon - fix kbuild warnings
      crypto: hisilicon - add dependency for CRYPTO_DEV_HISI_ZIP
      crypto: hisilicon - init curr_sgl_dma to fix compile warning
      crypto: hisilicon - add missing single_release
      crypto: hisilicon - fix error handle in hisi_zip_create_req_q

zhong jiang (2):
      crypto: arm64/aes - Use PTR_ERR_OR_ZERO rather than its implementation.
      crypto: marvell - Use kzfree rather than its implementation

 Documentation/ABI/testing/debugfs-hisi-zip         |   50 +
 Documentation/crypto/crypto_engine.rst             |    1 +
 .../devicetree/bindings/rng/timeriomem_rng.txt     |    2 +-
 Documentation/padata.txt                           |   12 +-
 MAINTAINERS                                        |   13 +-
 arch/arm/crypto/Kconfig                            |    2 +-
 arch/arm/crypto/aes-ce-core.S                      |  482 +-
 arch/arm/crypto/aes-ce-glue.c                      |  545 +-
 arch/arm/crypto/aes-cipher-core.S                  |   40 +-
 arch/arm/crypto/aes-cipher-glue.c                  |   11 +-
 arch/arm/crypto/aes-neonbs-core.S                  |   24 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |  160 +-
 arch/arm/crypto/ghash-ce-glue.c                    |   80 +-
 arch/arm/crypto/sha256_glue.c                      |    8 +-
 arch/arm/crypto/sha256_neon_glue.c                 |   24 +-
 arch/arm/include/asm/Kbuild                        |    1 -
 arch/arm64/boot/dts/freescale/imx8mq.dtsi          |   30 +
 arch/arm64/crypto/Kconfig                          |   10 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c                |   18 +-
 arch/arm64/crypto/aes-ce-glue.c                    |    7 +-
 arch/arm64/crypto/aes-ce.S                         |    3 +
 arch/arm64/crypto/aes-cipher-core.S                |   40 +-
 arch/arm64/crypto/aes-cipher-glue.c                |   11 +-
 arch/arm64/crypto/aes-ctr-fallback.h               |   50 -
 arch/arm64/crypto/aes-glue.c                       |  470 +-
 arch/arm64/crypto/aes-modes.S                      |  135 +-
 arch/arm64/crypto/aes-neon.S                       |   79 +-
 arch/arm64/crypto/aes-neonbs-core.S                |    9 +-
 arch/arm64/crypto/aes-neonbs-glue.c                |  140 +-
 arch/arm64/crypto/ghash-ce-glue.c                  |   30 +-
 arch/arm64/crypto/sha256-glue.c                    |   24 +-
 arch/powerpc/include/asm/Kbuild                    |    1 -
 arch/s390/crypto/aes_s390.c                        |   16 +-
 arch/s390/crypto/des_s390.c                        |   25 +-
 arch/s390/crypto/ghash_s390.c                      |    2 +-
 arch/s390/crypto/sha256_s390.c                     |    8 +-
 arch/s390/purgatory/Makefile                       |    4 +-
 arch/s390/purgatory/purgatory.c                    |    2 +-
 arch/sparc/crypto/aes_glue.c                       |    8 +-
 arch/sparc/crypto/des_glue.c                       |   37 +-
 arch/x86/crypto/Makefile                           |   21 -
 arch/x86/crypto/aegis128l-aesni-asm.S              |  823 ---
 arch/x86/crypto/aegis128l-aesni-glue.c             |  293 --
 arch/x86/crypto/aegis256-aesni-asm.S               |  700 ---
 arch/x86/crypto/aegis256-aesni-glue.c              |  293 --
 arch/x86/crypto/aes-i586-asm_32.S                  |  362 --
 arch/x86/crypto/aes-x86_64-asm_64.S                |  185 -
 arch/x86/crypto/aes_glue.c                         |   70 -
 arch/x86/crypto/aesni-intel_glue.c                 |   46 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c         |    4 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c          |    4 +-
 arch/x86/crypto/cast6_avx_glue.c                   |    4 +-
 arch/x86/crypto/des3_ede_glue.c                    |   38 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |    3 +-
 arch/x86/crypto/glue_helper.c                      |   67 +-
 arch/x86/crypto/morus1280-avx2-asm.S               |  619 ---
 arch/x86/crypto/morus1280-avx2-glue.c              |   62 -
 arch/x86/crypto/morus1280-sse2-asm.S               |  893 ----
 arch/x86/crypto/morus1280-sse2-glue.c              |   61 -
 arch/x86/crypto/morus1280_glue.c                   |  205 -
 arch/x86/crypto/morus640-sse2-asm.S                |  612 ---
 arch/x86/crypto/morus640-sse2-glue.c               |   61 -
 arch/x86/crypto/morus640_glue.c                    |  200 -
 arch/x86/crypto/serpent_avx2_glue.c                |    4 +-
 arch/x86/crypto/serpent_avx_glue.c                 |    4 +-
 arch/x86/crypto/sha256_ssse3_glue.c                |   12 +-
 arch/x86/crypto/twofish_avx_glue.c                 |    4 +-
 arch/x86/include/asm/crypto/aes.h                  |   12 -
 arch/x86/include/asm/crypto/glue_helper.h          |    2 +-
 arch/x86/purgatory/Makefile                        |    4 +-
 arch/x86/purgatory/purgatory.c                     |    2 +-
 crypto/Kconfig                                     |  164 +-
 crypto/Makefile                                    |   26 +-
 crypto/aead.c                                      |    3 +-
 crypto/aegis.h                                     |   39 +-
 crypto/{aegis128.c => aegis128-core.c}             |   74 +-
 crypto/aegis128-neon-inner.c                       |  212 +
 crypto/aegis128-neon.c                             |   49 +
 crypto/aegis128l.c                                 |  522 --
 crypto/aegis256.c                                  |  473 --
 crypto/aes_generic.c                               |  169 +-
 crypto/aes_ti.c                                    |  313 +-
 crypto/cryptd.c                                    |   44 +-
 crypto/crypto_engine.c                             |    2 +-
 crypto/crypto_user_base.c                          |   37 +-
 crypto/crypto_user_stat.c                          |    4 +-
 crypto/des_generic.c                               |  945 +---
 crypto/fips.c                                      |   11 +
 crypto/gcm.c                                       |   47 +-
 crypto/ghash-generic.c                             |   31 +-
 crypto/morus1280.c                                 |  542 --
 crypto/morus640.c                                  |  533 --
 crypto/pcrypt.c                                    |  167 +-
 crypto/sha256_generic.c                            |  224 +-
 crypto/skcipher.c                                  |   42 +-
 crypto/streebog_generic.c                          |   46 -
 crypto/tcrypt.c                                    |   16 +
 crypto/testmgr.c                                   |   52 +-
 crypto/testmgr.h                                   | 5284 ++++++--------------
 crypto/xts.c                                       |  152 +-
 drivers/char/hw_random/atmel-rng.c                 |    3 +-
 drivers/char/hw_random/cavium-rng-vf.c             |   11 +-
 drivers/char/hw_random/core.c                      |    5 +-
 drivers/char/hw_random/exynos-trng.c               |    3 +-
 drivers/char/hw_random/imx-rngc.c                  |    4 +-
 drivers/char/hw_random/mxc-rnga.c                  |    4 +-
 drivers/char/hw_random/n2-drv.c                    |    4 +-
 drivers/char/hw_random/nomadik-rng.c               |    3 +-
 drivers/char/hw_random/omap-rng.c                  |    3 +-
 drivers/char/hw_random/powernv-rng.c               |   10 +-
 drivers/char/hw_random/st-rng.c                    |    4 +-
 drivers/char/hw_random/timeriomem-rng.c            |    4 +-
 drivers/char/hw_random/xgene-rng.c                 |    4 +-
 drivers/char/random.c                              |    4 +-
 drivers/crypto/Kconfig                             |   56 +-
 drivers/crypto/amcc/crypto4xx_alg.c                |   24 +-
 drivers/crypto/atmel-aes.c                         |    1 -
 drivers/crypto/atmel-i2c.c                         |   12 +
 drivers/crypto/atmel-i2c.h                         |   12 -
 drivers/crypto/atmel-sha.c                         |    1 -
 drivers/crypto/atmel-sha204a.c                     |    3 +-
 drivers/crypto/atmel-tdes.c                        |   29 +-
 drivers/crypto/axis/artpec6_crypto.c               |    4 +-
 drivers/crypto/bcm/cipher.c                        |   92 +-
 drivers/crypto/caam/Kconfig                        |    4 +-
 drivers/crypto/caam/Makefile                       |    1 +
 drivers/crypto/caam/caamalg.c                      |  268 +-
 drivers/crypto/caam/caamalg_desc.c                 |   56 +-
 drivers/crypto/caam/caamalg_desc.h                 |    4 +-
 drivers/crypto/caam/caamalg_qi.c                   |  257 +-
 drivers/crypto/caam/caamalg_qi2.c                  |  325 +-
 drivers/crypto/caam/caamalg_qi2.h                  |   31 +-
 drivers/crypto/caam/caamhash.c                     |  116 +-
 drivers/crypto/caam/caamhash_desc.c                |    5 +-
 drivers/crypto/caam/caamhash_desc.h                |    2 +-
 drivers/crypto/caam/caampkc.c                      |   99 +-
 drivers/crypto/caam/caamrng.c                      |   19 +-
 drivers/crypto/caam/compat.h                       |    2 +-
 drivers/crypto/caam/ctrl.c                         |  255 +-
 drivers/crypto/caam/desc_constr.h                  |   81 +-
 drivers/crypto/caam/dpseci-debugfs.c               |   79 +
 drivers/crypto/caam/dpseci-debugfs.h               |   18 +
 drivers/crypto/caam/error.c                        |   64 +-
 drivers/crypto/caam/error.h                        |    2 +-
 drivers/crypto/caam/intern.h                       |   32 +-
 drivers/crypto/caam/jr.c                           |  124 +-
 drivers/crypto/caam/key_gen.c                      |   14 +-
 drivers/crypto/caam/pdb.h                          |   16 +-
 drivers/crypto/caam/pkc_desc.c                     |    8 +-
 drivers/crypto/caam/qi.c                           |   10 +-
 drivers/crypto/caam/qi.h                           |   26 -
 drivers/crypto/caam/regs.h                         |  141 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c             |   26 +-
 drivers/crypto/cavium/nitrox/Kconfig               |    2 +-
 drivers/crypto/cavium/nitrox/nitrox_csr.h          |  235 +-
 drivers/crypto/cavium/nitrox/nitrox_debugfs.c      |    3 +-
 drivers/crypto/cavium/nitrox/nitrox_dev.h          |    8 +-
 drivers/crypto/cavium/nitrox/nitrox_hal.c          |  158 +-
 drivers/crypto/cavium/nitrox/nitrox_hal.h          |    6 +-
 drivers/crypto/cavium/nitrox/nitrox_lib.c          |   66 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c         |  148 +-
 drivers/crypto/cavium/nitrox/nitrox_req.h          |   30 +
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c     |    4 +-
 drivers/crypto/cavium/nitrox/nitrox_sriov.c        |    3 +
 drivers/crypto/cavium/zip/zip_main.c               |    3 +
 drivers/crypto/ccp/Kconfig                         |    9 +
 drivers/crypto/ccp/Makefile                        |    4 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c           |   25 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c            |    3 -
 drivers/crypto/ccp/ccp-crypto-des3.c               |    7 +-
 drivers/crypto/ccp/ccp-crypto-main.c               |    4 +-
 drivers/crypto/ccp/ccp-crypto.h                    |    8 +-
 drivers/crypto/ccp/ccp-dev-v3.c                    |    3 +-
 drivers/crypto/ccp/ccp-dev-v5.c                    |   26 +-
 drivers/crypto/ccp/ccp-dev.c                       |   29 +-
 drivers/crypto/ccp/ccp-dev.h                       |    3 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |   13 +-
 drivers/crypto/ccp/ccp-ops.c                       |   56 +-
 drivers/crypto/ccp/psp-dev.h                       |    1 -
 drivers/crypto/ccp/sp-dev.h                        |    1 -
 drivers/crypto/ccp/sp-platform.c                   |    4 +-
 drivers/crypto/ccree/Makefile                      |    2 +-
 drivers/crypto/ccree/cc_aead.c                     |  129 +-
 drivers/crypto/ccree/cc_aead.h                     |    3 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |   21 -
 drivers/crypto/ccree/cc_buffer_mgr.h               |    2 -
 drivers/crypto/ccree/cc_cipher.c                   |   31 +-
 drivers/crypto/ccree/cc_driver.c                   |   18 +-
 drivers/crypto/ccree/cc_driver.h                   |   10 -
 drivers/crypto/ccree/cc_fips.c                     |   31 +-
 drivers/crypto/ccree/cc_hash.c                     |  153 +-
 drivers/crypto/ccree/cc_ivgen.c                    |  276 -
 drivers/crypto/ccree/cc_ivgen.h                    |   55 -
 drivers/crypto/ccree/cc_pm.c                       |    2 -
 drivers/crypto/ccree/cc_request_mgr.c              |   47 +-
 drivers/crypto/chelsio/Kconfig                     |    1 +
 drivers/crypto/chelsio/chcr_algo.c                 |   46 +-
 drivers/crypto/chelsio/chcr_algo.h                 |   20 +-
 drivers/crypto/chelsio/chcr_crypto.h               |    1 -
 drivers/crypto/chelsio/chcr_ipsec.c                |   19 +-
 drivers/crypto/chelsio/chtls/chtls_hw.c            |   20 +-
 drivers/crypto/exynos-rng.c                        |    4 +-
 drivers/crypto/hifn_795x.c                         |   32 +-
 drivers/crypto/hisilicon/Kconfig                   |   25 +
 drivers/crypto/hisilicon/Makefile                  |    3 +
 drivers/crypto/hisilicon/qm.c                      | 1913 +++++++
 drivers/crypto/hisilicon/qm.h                      |  215 +
 drivers/crypto/hisilicon/sec/sec_algs.c            |   18 +-
 drivers/crypto/hisilicon/sgl.c                     |  214 +
 drivers/crypto/hisilicon/sgl.h                     |   24 +
 drivers/crypto/hisilicon/zip/Makefile              |    2 +
 drivers/crypto/hisilicon/zip/zip.h                 |   71 +
 drivers/crypto/hisilicon/zip/zip_crypto.c          |  653 +++
 drivers/crypto/hisilicon/zip/zip_main.c            | 1013 ++++
 drivers/crypto/img-hash.c                          |    5 +-
 drivers/crypto/inside-secure/safexcel.c            | 1153 ++++-
 drivers/crypto/inside-secure/safexcel.h            |  226 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     | 1532 ++++--
 drivers/crypto/inside-secure/safexcel_hash.c       |  625 +--
 drivers/crypto/inside-secure/safexcel_ring.c       |   11 +-
 drivers/crypto/ixp4xx_crypto.c                     |   27 +-
 drivers/crypto/marvell/cipher.c                    |   27 +-
 drivers/crypto/marvell/hash.c                      |    3 +-
 drivers/crypto/mediatek/mtk-aes.c                  |  143 +-
 drivers/crypto/mediatek/mtk-platform.c             |    7 +-
 drivers/crypto/mediatek/mtk-sha.c                  |    4 +-
 drivers/crypto/mxs-dcp.c                           |    8 +-
 drivers/crypto/n2_core.c                           |   42 +-
 drivers/crypto/nx/nx-842-powernv.c                 |    1 +
 drivers/crypto/nx/nx.h                             |    3 -
 drivers/crypto/omap-aes.c                          |    1 -
 drivers/crypto/omap-des.c                          |   28 +-
 drivers/crypto/omap-sham.c                         |    1 -
 drivers/crypto/padlock-aes.c                       |   10 +-
 drivers/crypto/picoxcell_crypto.c                  |   29 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    2 +-
 drivers/crypto/qce/ablkcipher.c                    |   55 +-
 drivers/crypto/qce/core.c                          |    4 +-
 drivers/crypto/qcom-rng.c                          |    4 +-
 drivers/crypto/rockchip/rk3288_crypto.c            |    4 +-
 drivers/crypto/rockchip/rk3288_crypto.h            |    2 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |   21 +-
 drivers/crypto/s5p-sss.c                           |    7 +-
 drivers/crypto/sahara.c                            |    4 +-
 drivers/crypto/stm32/Kconfig                       |    2 +-
 drivers/crypto/stm32/stm32-crc32.c                 |    4 +-
 drivers/crypto/stm32/stm32-cryp.c                  |   38 +-
 drivers/crypto/stm32/stm32-hash.c                  |    4 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c          |   26 +-
 drivers/crypto/sunxi-ss/sun4i-ss-core.c            |    4 +-
 drivers/crypto/sunxi-ss/sun4i-ss.h                 |    2 +-
 drivers/crypto/talitos.c                           |   38 +-
 drivers/crypto/ux500/Kconfig                       |    2 +-
 drivers/crypto/ux500/cryp/cryp.c                   |    6 +
 drivers/crypto/ux500/cryp/cryp.h                   |    4 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |   39 +-
 drivers/crypto/ux500/hash/hash_alg.h               |    4 +-
 drivers/crypto/ux500/hash/hash_core.c              |   12 +-
 drivers/crypto/virtio/virtio_crypto_algs.c         |    4 +-
 drivers/crypto/vmx/aes_xts.c                       |    2 +-
 fs/cifs/Kconfig                                    |    2 +-
 fs/cifs/cifsfs.c                                   |    1 -
 fs/cifs/smbencrypt.c                               |   18 +-
 include/asm-generic/Kbuild                         |    2 +
 include/crypto/aes.h                               |   58 +-
 include/crypto/algapi.h                            |    2 -
 include/crypto/ctr.h                               |   50 +
 include/crypto/des.h                               |   77 +-
 include/crypto/gcm.h                               |   55 +
 include/crypto/ghash.h                             |    2 +-
 include/crypto/internal/cryptouser.h               |    7 +-
 include/crypto/internal/des.h                      |  152 +
 include/crypto/internal/skcipher.h                 |    5 +
 include/crypto/morus1280_glue.h                    |   97 -
 include/crypto/morus640_glue.h                     |   97 -
 include/crypto/morus_common.h                      |   18 -
 include/crypto/sha.h                               |   47 +
 include/crypto/sha1_base.h                         |    5 +
 include/crypto/sha256_base.h                       |   29 +-
 include/crypto/sha512_base.h                       |    5 +
 include/crypto/sm3_base.h                          |    5 +
 include/linux/fips.h                               |    7 +
 include/linux/padata.h                             |   29 +-
 include/linux/sha256.h                             |   28 -
 include/linux/timeriomem-rng.h                     |    5 +
 include/linux/workqueue.h                          |    4 +
 include/net/net_namespace.h                        |    3 +
 include/uapi/linux/cryptouser.h                    |    5 +
 kernel/padata.c                                    |  307 +-
 kernel/workqueue.c                                 |   25 +-
 lib/crypto/Makefile                                |    9 +
 lib/crypto/aes.c                                   |  356 ++
 lib/crypto/des.c                                   |  902 ++++
 lib/{ => crypto}/sha256.c                          |  150 +-
 lib/mpi/longlong.h                                 |   36 +-
 net/bluetooth/Kconfig                              |    3 +-
 net/bluetooth/smp.c                                |  103 +-
 tools/crypto/getstat.c                             |  294 --
 298 files changed, 15611 insertions(+), 18397 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-zip
 delete mode 100644 arch/arm64/crypto/aes-ctr-fallback.h
 delete mode 100644 arch/x86/crypto/aegis128l-aesni-asm.S
 delete mode 100644 arch/x86/crypto/aegis128l-aesni-glue.c
 delete mode 100644 arch/x86/crypto/aegis256-aesni-asm.S
 delete mode 100644 arch/x86/crypto/aegis256-aesni-glue.c
 delete mode 100644 arch/x86/crypto/aes-i586-asm_32.S
 delete mode 100644 arch/x86/crypto/aes-x86_64-asm_64.S
 delete mode 100644 arch/x86/crypto/morus1280-avx2-asm.S
 delete mode 100644 arch/x86/crypto/morus1280-avx2-glue.c
 delete mode 100644 arch/x86/crypto/morus1280-sse2-asm.S
 delete mode 100644 arch/x86/crypto/morus1280-sse2-glue.c
 delete mode 100644 arch/x86/crypto/morus1280_glue.c
 delete mode 100644 arch/x86/crypto/morus640-sse2-asm.S
 delete mode 100644 arch/x86/crypto/morus640-sse2-glue.c
 delete mode 100644 arch/x86/crypto/morus640_glue.c
 delete mode 100644 arch/x86/include/asm/crypto/aes.h
 rename crypto/{aegis128.c => aegis128-core.c} (87%)
 create mode 100644 crypto/aegis128-neon-inner.c
 create mode 100644 crypto/aegis128-neon.c
 delete mode 100644 crypto/aegis128l.c
 delete mode 100644 crypto/aegis256.c
 delete mode 100644 crypto/morus1280.c
 delete mode 100644 crypto/morus640.c
 create mode 100644 drivers/crypto/caam/dpseci-debugfs.c
 create mode 100644 drivers/crypto/caam/dpseci-debugfs.h
 delete mode 100644 drivers/crypto/ccree/cc_ivgen.c
 delete mode 100644 drivers/crypto/ccree/cc_ivgen.h
 create mode 100644 drivers/crypto/hisilicon/qm.c
 create mode 100644 drivers/crypto/hisilicon/qm.h
 create mode 100644 drivers/crypto/hisilicon/sgl.c
 create mode 100644 drivers/crypto/hisilicon/sgl.h
 create mode 100644 drivers/crypto/hisilicon/zip/Makefile
 create mode 100644 drivers/crypto/hisilicon/zip/zip.h
 create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.c
 create mode 100644 drivers/crypto/hisilicon/zip/zip_main.c
 create mode 100644 include/crypto/internal/des.h
 delete mode 100644 include/crypto/morus1280_glue.h
 delete mode 100644 include/crypto/morus640_glue.h
 delete mode 100644 include/crypto/morus_common.h
 delete mode 100644 include/linux/sha256.h
 create mode 100644 lib/crypto/aes.c
 create mode 100644 lib/crypto/des.c
 rename lib/{ => crypto}/sha256.c (66%)
 delete mode 100644 tools/crypto/getstat.c

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
