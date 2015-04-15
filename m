From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.1
Date: Wed, 15 Apr 2015 11:39:51 +0800
Message-ID: <20150415033951.GA1406@gondor.apana.org.au>
References: <20130223023331.GA11002@gondor.apana.org.au>
 <20130907035544.GA22658@gondor.apana.org.au>
 <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53546 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbbDODkA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Apr 2015 23:40:00 -0400
Content-Disposition: inline
In-Reply-To: <20150214094328.GA7457@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 4.1:

* Added user-space interface for AEAD.
* Added user-space interface for RNG (i.e., pseudo RNG).
* Prevent internal helper algos from being exposed to user-space.
* Merged common code from assembly/C SHA implementations .
* Added ARMv8 SHA1/256.
* Added ARMv8 AES.
* Added ARMv8 GHASH.
* Added ARM assmelber and NEON SHA256.
* Added MIPS OCTEON SHA1/256/512.
* Added MIPS img-hash SHA1/256 and MD5.
* Added Power 8 VMX AES/CBC/CTR/GHASH.
* Added PPC assembler AES, SHA1/256 and MD5.
* Added Broadcom IPROC RNG driver.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Aaro Koskinen (7):
      crypto: octeon - don't disable bottom half in octeon-md5
      crypto: octeon - always disable preemption when using crypto engine
      crypto: octeon - add instruction definitions for SHA1/256/512
      crypto: octeon - add SHA1 module
      crypto: octeon - add SHA256 module
      crypto: octeon - add SHA512 module
      crypto: octeon - enable OCTEON SHA1/256/512 module selection

Allan, Bruce W (10):
      crypto: qat - remove duplicate definition of Intel PCI vendor id
      crypto: qat - fix typo in string
      crypto: qat - make error and info log messages more descriptive
      crypto: qat - fix typo
      crypto: qat - fix checkpatch CHECK_SPACING issues
      crypto: qat - checkpatch PARENTHESIS_ALIGNMENT and LOGICAL_CONTINUATIONS
      crypto: qat - fix checkpatch CONCATENATED_STRING issues
      crypto: qat - fix checkpatch BIT_MACRO issues
      crypto: qat - fix checkpatch COMPARISON_TO_NULL issue
      crypto: qat - fix checkpatch CODE_INDENT issue

Ameen Ali (1):
      crypto: sha1-mb - Syntax error

Andre Wolokita (2):
      hwrng: omap - Change RNG_CONFIG_REG to RNG_CONTROL_REG when checking and disabling TRNG
      hwrng: omap - Change RNG_CONFIG_REG to RNG_CONTROL_REG in init

Ard Biesheuvel (23):
      crypto: arm - move ARM specific Kconfig definitions to a dedicated file
      crypto: arm - add support for SHA1 using ARMv8 Crypto Instructions
      crypto: arm - add support for SHA-224/256 using ARMv8 Crypto Extensions
      crypto: arm - AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions
      crypto: arm - add support for GHASH using ARMv8 Crypto Extensions
      crypto: arm/ghash - fix big-endian bug in ghash
      crypto: sha1 - implement base layer for SHA-1
      crypto: sha256 - implement base layer for SHA-256
      crypto: sha512 - implement base layer for SHA-512
      crypto: sha1-generic - move to generic glue implementation
      crypto: sha256-generic - move to generic glue implementation
      crypto: sha512-generic - move to generic glue implementation
      crypto: arm/sha1 - move SHA-1 ARM asm implementation to base layer
      crypto: arm/sha1_neon - move SHA-1 NEON implementation to base layer
      crypto: arm/sha1-ce - move SHA-1 ARMv8 implementation to base layer
      crypto: arm/sha256 - move SHA-224/256 ASM/NEON implementation to base layer
      crypto: arm/sha2-ce - move SHA-224/256 ARMv8 implementation to base layer
      crypto: arm64/sha1-ce - move SHA-1 ARMv8 implementation to base layer
      crypto: arm64/sha2-ce - move SHA-224/256 ARMv8 implementation to base layer
      crypto: x86/sha1_ssse3 - move SHA-1 SSSE3 implementation to base layer
      crypto: x86/sha256_ssse3 - move SHA-224/256 SSSE3 implementation to base layer
      crypto: x86/sha512_ssse3 - move SHA-384/512 SSSE3 implementation to base layer
      crypto: arm - workaround for building with old binutils

Arnd Bergmann (1):
      crypto: arm/sha256 - avoid sha256 code on ARMv7-M

Colin Ian King (1):
      crypto: atmel - fix typo in dev_err error message

Dan Carpenter (2):
      crypto: img-hash - fix some compile warnings
      crypto: img-hash - shift wrapping bug in img_hash_hw_init()

Dmitry Torokhov (12):
      hwrng: omap - remove incorrect __exit markups
      hwrng: octeon - remove incorrect __exit markups
      hwrng: pseries - remove incorrect __init/__exit markups
      crypto: qat - remove incorrect __exit markup
      crypto: amcc - remove incorrect __init/__exit markups
      hwrng: omap - remove #ifdefery around PM methods
      hwrng: add devm_* interfaces
      hwrng: bcm63xx - make use of devm_hwrng_register
      hwrng: exynos - make use of devm_hwrng_register
      hwrng: msm - make use of devm_hwrng_register
      hwrng: iproc-rng200 - do not use static structure
      hwrng: iproc-rng200 - make use of devm_hwrng_register

Feng Kan (1):
      hwrng: xgene - add ACPI support for APM X-Gene RNG unit

Florian Fainelli (4):
      hwrng: bcm63xx - drop bcm_{readl,writel} macros
      hwrng: bcm63xx - move register definitions to driver
      MIPS: BCM63xx: remove RSET_RNG register definitions
      hwrng: bcm63xx - use devm_* helpers

Geert Uytterhoeven (1):
      crypto: ux500 - Update error message for dmaengine_prep_slave_sg() API

Herbert Xu (6):
      linux-next: Tree for Mar 11 (powerpc build failure due to vmx crypto code)
      linux-next: build failure after merge of the crypto tree
      crypto: api - Fix races in crypto_unregister_instance
      crypto: api - Change crypto_unregister_instance argument type
      crypto: user - Fix crypto_alg_match race
      crypto: api - Move alg ref count init to crypto_check_alg

Horia Geant? (1):
      crypto: tcrypt - fix uninit sg entries in test_acipher_speed

James Hartley (3):
      crypto: img-hash - Add Imagination Technologies hw hash accelerator
      Documentation: crypto: Add DT binding info for the img hw hash accelerator
      crypto: img-hash - Fix Kconfig selections

Julia Lawall (1):
      crypto: don't export static symbol

Keith Packard (1):
      hwrng: core - allow perfect entropy from hardware devices

Kim Phillips (1):
      crypto: powerpc - move files to fix build error

Lad, Prabhakar (1):
      crypto: sha-mb - Fix big integer constant sparse warning

Leilei Zhao (9):
      crypto: atmel-aes - add new version
      crypto: atmel-sha - add new version
      crypto: atmel-sha - fix sg list management
      crypto: atmel-sha - initialize spinlock in probe
      crypto: atmel-sha - correct the max burst size
      crypto: atmel-tdes - initialize spinlock in probe
      crypto: atmel-aes - initialize spinlock in probe
      crypto: atmel-aes - sync the buf used in DMA or CPU
      crypto: atmel-aes - correct usage of dma_sync_* API

Leonidas S. Barbosa (2):
      crypto: vmx - Add support for VMS instructions by ASM
      crypto: vmx - Enabling VMX module for PPC64

Ludovic Desroches (1):
      crypto: atmel-sha - correct the way data are split

Marcelo H. Cerri (5):
      crypto: vmx - Adding VMX module for Power 8
      crypto: vmx - Adding AES routines for VMX module
      crypto: vmx - Adding CBC routines for VMX module
      crypto: vmx - Adding CTR routines for VMX module
      crypto: vmx - Adding GHASH routines for VMX module

Markus Stockhausen (16):
      crypto: ppc/sha256 - assembler
      crypto: ppc/sha256 - glue
      crypto: ppc/sha256 - kernel config
      crypto: powerpc/aes - register defines
      crypto: powerpc/aes - aes tables
      crypto: powerpc/aes - assembler core
      crypto: powerpc/aes - key handling
      crypto: powerpc/aes - ECB/CBC/CTR/XTS modes
      cyprot: powerpc/aes - glue code
      crypto: powerpc/aes - kernel config
      crypto: powerpc/sha1 - assembler
      crypto: powerpc/sha1 - glue
      crypto: powerpc/sha1 - kernel config
      crypto: powerpc/md5 - assembler
      crypto: powerpc/md5 - glue
      crypto: powerpc/md5 - kernel config

Martin Hicks (2):
      crypto: talitos - Simplify per-channel initialization
      crypto: talitos - Remove MD5_BLOCK_SIZE

Masanari Iida (1):
      crypto: serpent_sse2 - Fix a typo in Kconfig

Nicholas Mc Guire (4):
      crypto: mxs-dcp - fix type of ret for wait_for_completion_timeout
      crypto: sahara - fix type of ret for wait_for_completion_timeout
      crypto: sahara - pass on error condition
      crypto: sahara - drop unnecessary default assignment

Sami Tolvanen (1):
      crypto: arm/sha256 - Add optimized SHA-256/224

Scott Branden (2):
      hwrng: iproc-rng200 - Add device tree bindings
      hwrng: iproc-rng200 - Add Broadcom IPROC RNG driver

Steffen Trumtrar (2):
      crypto: sahara - use the backlog
      crypto: sahara - fix AES descriptor create

Stephan Mueller (31):
      crypto: doc - describe internal structure
      crypto: algif - add AEAD support
      crypto: algif - enable AEAD interface compilation
      crypto: drbg - use single block cipher API
      crypto: drbg - remove superflowous memsets
      crypto: rng - RNGs must return 0 in success case
      crypto: doc - AEAD / RNG AF_ALG interface
      MAINTAINERS: add crypto-API.tmpl
      crypto: testmgr - fix RNG return code enforcement
      crypto: algif_rng - zeroize buffer with random data
      crypto: api - prevent helper ciphers from being used
      crypto: testmgr - use CRYPTO_ALG_INTERNAL
      crypto: cryptd - process CRYPTO_ALG_INTERNAL
      crypto: proc - identify internal ciphers
      crypto: aesni - mark AES-NI helper ciphers
      crypto: clmulni - mark ghash clmulni helper ciphers
      crypto: ghash-ce - mark GHASH ARMv8 vmull.p64 helper ciphers
      crypto: camellia_aesni_avx2 - mark AES-NI Camellia helper ciphers
      crypto: cast5_avx - mark CAST5 helper ciphers
      crypto: camellia_aesni_avx - mark AVX Camellia helper ciphers
      crypto: cast6_avx - mark CAST6 helper ciphers
      crypto: serpent_avx2 - mark Serpent AVX2 helper ciphers
      crypto: serpent_avx - mark Serpent AVX helper ciphers
      crypto: serpent_sse2 - mark Serpent SSE2 helper ciphers
      crypto: twofish_avx - mark Twofish AVX helper ciphers
      crypto: aesbs - mark NEON bit sliced AES helper ciphers
      crypto: aes-ce - mark ARMv8 AES helper ciphers
      crypto: arm64/aes - mark 64 bit ARMv8 AES helper ciphers
      crypto: mcryptd - process CRYPTO_ALG_INTERNAL
      crypto: sha-mb - mark Multi buffer SHA1 helper cipher
      crypto: api - remove instance when test failed

Tadeusz Struk (3):
      crypto: aesni - make driver-gcm-aes-aesni helper a proper aead alg
      crypto: qat - print ring name in debug output
      crypto: qat - fix double release_firmware on error path

Tom Lendacky (5):
      crypto: ccp - Updates for checkpatch warnings/errors
      crypto: ccp - Update CCP build support
      crypto: ccp - Use dma_set_mask_and_coherent to set DMA mask
      crypto: ccp - Convert calls to their devm_ counterparts
      crypto: ccp - Add ACPI support

Vutla, Lokesh (3):
      crypto: omap-sham - Use pm_runtime_irq_safe()
      crypto: omap-aes - Fix support for unequal lengths
      crypto: omap-sham - Add the offset of sg page to vaddr

Yanjiang Jin (2):
      crypto: caam - fix uninitialized edesc->sec4_sg_bytes field
      hwrng: caam - fix rng_unmap_ctx's DMA_UNMAP size problem

mancha security (1):
      lib: memzero_explicit: use barrier instead of OPTIMIZER_HIDE_VAR

 Documentation/DocBook/crypto-API.tmpl              |  860 ++++++
 Documentation/crypto/crypto-API-userspace.txt      |  205 --
 .../devicetree/bindings/crypto/img-hash.txt        |   27 +
 .../bindings/hwrng/brcm,iproc-rng200.txt           |   12 +
 MAINTAINERS                                        |    1 +
 arch/arm/Kconfig                                   |    3 +
 arch/arm/crypto/Kconfig                            |  130 +
 arch/arm/crypto/Makefile                           |   27 +-
 arch/arm/crypto/aes-ce-core.S                      |  518 ++++
 arch/arm/crypto/aes-ce-glue.c                      |  524 ++++
 arch/arm/crypto/aesbs-glue.c                       |    9 +-
 arch/arm/crypto/ghash-ce-core.S                    |   94 +
 arch/arm/crypto/ghash-ce-glue.c                    |  320 +++
 arch/arm/crypto/sha1-ce-core.S                     |  125 +
 arch/arm/crypto/sha1-ce-glue.c                     |   96 +
 arch/arm/{include/asm => }/crypto/sha1.h           |    3 +
 arch/arm/crypto/sha1_glue.c                        |  112 +-
 arch/arm/crypto/sha1_neon_glue.c                   |  137 +-
 arch/arm/crypto/sha2-ce-core.S                     |  125 +
 arch/arm/crypto/sha2-ce-glue.c                     |  114 +
 arch/arm/crypto/sha256-armv4.pl                    |  716 +++++
 arch/arm/crypto/sha256-core.S_shipped              | 2808 ++++++++++++++++++++
 arch/arm/crypto/sha256_glue.c                      |  128 +
 arch/arm/crypto/sha256_glue.h                      |   14 +
 arch/arm/crypto/sha256_neon_glue.c                 |  101 +
 arch/arm64/crypto/aes-glue.c                       |   12 +-
 arch/arm64/crypto/sha1-ce-core.S                   |   33 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |  151 +-
 arch/arm64/crypto/sha2-ce-core.S                   |   29 +-
 arch/arm64/crypto/sha2-ce-glue.c                   |  227 +-
 arch/mips/cavium-octeon/crypto/Makefile            |    5 +-
 arch/mips/cavium-octeon/crypto/octeon-crypto.c     |    4 +-
 arch/mips/cavium-octeon/crypto/octeon-crypto.h     |   83 +-
 arch/mips/cavium-octeon/crypto/octeon-md5.c        |    8 -
 arch/mips/cavium-octeon/crypto/octeon-sha1.c       |  241 ++
 arch/mips/cavium-octeon/crypto/octeon-sha256.c     |  280 ++
 arch/mips/cavium-octeon/crypto/octeon-sha512.c     |  277 ++
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_regs.h  |   14 -
 arch/powerpc/crypto/Makefile                       |    8 +
 arch/powerpc/crypto/aes-spe-core.S                 |  351 +++
 arch/powerpc/crypto/aes-spe-glue.c                 |  512 ++++
 arch/powerpc/crypto/aes-spe-keys.S                 |  283 ++
 arch/powerpc/crypto/aes-spe-modes.S                |  630 +++++
 arch/powerpc/crypto/aes-spe-regs.h                 |   42 +
 arch/powerpc/crypto/aes-tab-4k.S                   |  331 +++
 arch/powerpc/crypto/md5-asm.S                      |  243 ++
 arch/powerpc/crypto/md5-glue.c                     |  165 ++
 arch/powerpc/crypto/sha1-spe-asm.S                 |  299 +++
 arch/powerpc/crypto/sha1-spe-glue.c                |  210 ++
 arch/powerpc/crypto/sha256-spe-asm.S               |  323 +++
 arch/powerpc/crypto/sha256-spe-glue.c              |  275 ++
 arch/x86/crypto/aesni-intel_glue.c                 |  187 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c         |   15 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c          |   15 +-
 arch/x86/crypto/cast5_avx_glue.c                   |    9 +-
 arch/x86/crypto/cast6_avx_glue.c                   |   15 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |    7 +-
 arch/x86/crypto/glue_helper.c                      |    1 -
 arch/x86/crypto/serpent_avx2_glue.c                |   15 +-
 arch/x86/crypto/serpent_avx_glue.c                 |   15 +-
 arch/x86/crypto/serpent_sse2_glue.c                |   15 +-
 arch/x86/crypto/sha-mb/sha1_mb.c                   |    9 +-
 arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c     |    2 +-
 arch/x86/crypto/sha1_ssse3_glue.c                  |  139 +-
 arch/x86/crypto/sha256-avx-asm.S                   |   10 +-
 arch/x86/crypto/sha256-avx2-asm.S                  |   10 +-
 arch/x86/crypto/sha256-ssse3-asm.S                 |   10 +-
 arch/x86/crypto/sha256_ssse3_glue.c                |  193 +-
 arch/x86/crypto/sha512-avx-asm.S                   |    6 +-
 arch/x86/crypto/sha512-avx2-asm.S                  |    6 +-
 arch/x86/crypto/sha512-ssse3-asm.S                 |    6 +-
 arch/x86/crypto/sha512_ssse3_glue.c                |  202 +-
 arch/x86/crypto/twofish_avx_glue.c                 |   15 +-
 crypto/Kconfig                                     |  142 +-
 crypto/Makefile                                    |    1 +
 crypto/ablk_helper.c                               |    3 +-
 crypto/algapi.c                                    |   42 +-
 crypto/algif_aead.c                                |  666 +++++
 crypto/algif_rng.c                                 |    2 +-
 crypto/ansi_cprng.c                                |    6 +-
 crypto/api.c                                       |   10 +
 crypto/cryptd.c                                    |   49 +-
 crypto/crypto_user.c                               |   39 +-
 crypto/drbg.c                                      |   64 +-
 crypto/mcryptd.c                                   |   25 +-
 crypto/proc.c                                      |    3 +
 crypto/sha1_generic.c                              |  102 +-
 crypto/sha256_generic.c                            |  133 +-
 crypto/sha512_generic.c                            |  123 +-
 crypto/tcrypt.c                                    |    4 +-
 crypto/testmgr.c                                   |   24 +-
 drivers/char/hw_random/Kconfig                     |   13 +
 drivers/char/hw_random/Makefile                    |    1 +
 drivers/char/hw_random/bcm63xx-rng.c               |  120 +-
 drivers/char/hw_random/core.c                      |   45 +-
 drivers/char/hw_random/exynos-rng.c                |   12 +-
 drivers/char/hw_random/iproc-rng200.c              |  239 ++
 drivers/char/hw_random/msm-rng.c                   |   11 +-
 drivers/char/hw_random/octeon-rng.c                |    4 +-
 drivers/char/hw_random/omap-rng.c                  |   23 +-
 drivers/char/hw_random/pseries-rng.c               |    4 +-
 drivers/char/hw_random/xgene-rng.c                 |   10 +
 drivers/crypto/Kconfig                             |   24 +-
 drivers/crypto/Makefile                            |    2 +
 drivers/crypto/amcc/crypto4xx_core.c               |    6 +-
 drivers/crypto/atmel-aes.c                         |   26 +-
 drivers/crypto/atmel-sha.c                         |   37 +-
 drivers/crypto/atmel-tdes.c                        |    3 +-
 drivers/crypto/caam/caamhash.c                     |    1 +
 drivers/crypto/caam/caamrng.c                      |    6 +-
 drivers/crypto/ccp/Makefile                        |    9 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c           |   12 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c            |    4 +-
 drivers/crypto/ccp/ccp-crypto-aes.c                |    3 +-
 drivers/crypto/ccp/ccp-crypto-main.c               |    5 +-
 drivers/crypto/ccp/ccp-crypto-sha.c                |   12 +-
 drivers/crypto/ccp/ccp-crypto.h                    |    3 -
 drivers/crypto/ccp/ccp-dev.c                       |    7 +-
 drivers/crypto/ccp/ccp-dev.h                       |   12 +-
 drivers/crypto/ccp/ccp-ops.c                       |   24 +-
 drivers/crypto/ccp/ccp-pci.c                       |   21 +-
 drivers/crypto/ccp/ccp-platform.c                  |  111 +-
 drivers/crypto/img-hash.c                          | 1029 +++++++
 drivers/crypto/mxs-dcp.c                           |    2 +-
 drivers/crypto/omap-aes.c                          |   14 +-
 drivers/crypto/omap-sham.c                         |    2 +
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    1 -
 drivers/crypto/qat/qat_common/adf_accel_engine.c   |   35 +-
 drivers/crypto/qat/qat_common/adf_aer.c            |   21 +-
 drivers/crypto/qat/qat_common/adf_cfg.c            |    5 +-
 drivers/crypto/qat/qat_common/adf_cfg_strings.h    |   10 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    2 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |   66 +-
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |    3 +-
 drivers/crypto/qat/qat_common/adf_init.c           |   88 +-
 drivers/crypto/qat/qat_common/adf_transport.c      |   31 +-
 .../crypto/qat/qat_common/adf_transport_debug.c    |    2 +
 drivers/crypto/qat/qat_common/icp_qat_hw.h         |    2 +-
 drivers/crypto/qat/qat_common/qat_crypto.c         |    9 +-
 drivers/crypto/qat/qat_common/qat_hal.c            |    6 +-
 drivers/crypto/qat/qat_dh895xcc/adf_admin.c        |    3 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    3 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    6 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |    4 +-
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |   15 +-
 drivers/crypto/sahara.c                            |   51 +-
 drivers/crypto/talitos.c                           |   17 +-
 drivers/crypto/ux500/hash/hash_core.c              |    2 +-
 drivers/crypto/vmx/Kconfig                         |    8 +
 drivers/crypto/vmx/Makefile                        |   19 +
 drivers/crypto/vmx/aes.c                           |  139 +
 drivers/crypto/vmx/aes_cbc.c                       |  184 ++
 drivers/crypto/vmx/aes_ctr.c                       |  167 ++
 drivers/crypto/vmx/aesp8-ppc.h                     |   20 +
 drivers/crypto/vmx/aesp8-ppc.pl                    | 1930 ++++++++++++++
 drivers/crypto/vmx/ghash.c                         |  214 ++
 drivers/crypto/vmx/ghashp8-ppc.pl                  |  228 ++
 drivers/crypto/vmx/ppc-xlate.pl                    |  207 ++
 drivers/crypto/vmx/vmx.c                           |   88 +
 include/crypto/algapi.h                            |    2 +-
 include/crypto/rng.h                               |    3 +-
 include/crypto/sha.h                               |   15 +-
 include/crypto/sha1_base.h                         |  106 +
 include/crypto/sha256_base.h                       |  128 +
 include/crypto/sha512_base.h                       |  131 +
 include/linux/crypto.h                             |    6 +
 include/linux/hw_random.h                          |    4 +
 lib/string.c                                       |    2 +-
 168 files changed, 18223 insertions(+), 2202 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
