Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FB5C433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Feb 2021 02:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF0F364D8F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Feb 2021 02:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhBOCsZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Feb 2021 21:48:25 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:46706 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhBOCsT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Feb 2021 21:48:19 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lBTuz-0000hn-J9; Mon, 15 Feb 2021 13:47:22 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 15 Feb 2021 13:47:21 +1100
Date:   Mon, 15 Feb 2021 13:47:21 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 5.12
Message-ID: <20210215024721.GA20593@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20201012033249.GA25179@gondor.apana.org.au>
 <20201214055515.GA14196@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214055515.GA14196@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

API:

- Restrict crypto_cipher to internal API users only.

Algorithms:

- Add x86 aesni acceleration for cts.
- Improve x86 aesni acceleration for xts.
- Remove x86 acceleration of some uncommon algorithms.
- Remove RIPE-MD, Tiger and Salsa20.
- Remove tnepres.
- Add ARM acceleration for BLAKE2s and BLAKE2b.

Drivers:

- Add Keem Bay OCS HCU driver.
- Add Marvell OcteonTX2 CPT PF driver.
- Remove PicoXcell driver.
- Remove mediatek driver.

The following changes since commit 0aa171e9b267ce7c52d3a3df7bc9c1fc0203dec5:

  crypto: ecdh - avoid buffer overflow in ecdh_set_secret() (2021-01-03 08:35:35 +1100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to 0de9dc80625b0ca1cb9730c5ed1c5a8cab538369:

  hwrng: timeriomem - Use device-managed registration API (2021-02-10 17:56:01 +1100)

----------------------------------------------------------------
Adam Guerin (3):
      crypto: qat - fix potential spectre issue
      crypto: qat - change format string and cast ring size
      crypto: qat - reduce size of mapped region

Ard Biesheuvel (60):
      crypto: aesni - implement support for cts(cbc(aes))
      crypto: tcrypt - avoid signed overflow in byte count
      chcr_ktls: use AES library for single use cipher
      crypto: remove cipher routines from public crypto API
      crypto: arm64/aes-ce - really hide slower algos when faster ones are enabled
      crypto: arm64/aes-ctr - improve tail handling
      crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
      crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper
      crypto: aesni - prevent misaligned buffers on the stack
      crypto: aesni - drop unused asm prototypes
      crypto: aesni - clean up mapping of associated data
      crypto: aesni - refactor scatterlist processing
      crypto: aesni - replace function pointers with static branches
      crypto: x86/camellia - switch to XTS template
      crypto: x86/cast6 - switch to XTS template
      crypto: x86/serpent- switch to XTS template
      crypto: x86/twofish - switch to XTS template
      crypto: x86/glue-helper - drop XTS helper routines
      crypto: x86/camellia - drop CTR mode implementation
      crypto: x86/serpent - drop CTR mode implementation
      crypto: x86/cast5 - drop CTR mode implementation
      crypto: x86/cast6 - drop CTR mode implementation
      crypto: x86/twofish - drop CTR mode implementation
      crypto: x86/glue-helper - drop CTR helper routines
      crypto: x86/des - drop CTR mode implementation
      crypto: x86/blowfish - drop CTR mode implementation
      crypto: x86 - add some helper macros for ECB and CBC modes
      crypto: x86/camellia - drop dependency on glue helper
      crypto: x86/serpent - drop dependency on glue helper
      crypto: x86/cast5 - drop dependency on glue helper
      crypto: x86/cast6 - drop dependency on glue helper
      crypto: x86/twofish - drop dependency on glue helper
      crypto: x86 - remove glue helper module
      crypto: x86 - use local headers for x86 specific shared declarations
      crypto - shash: reduce minimum alignment of shash_desc structure
      crypto: arm64/sha - add missing module aliases
      crypto: aesni - replace CTR function pointer with static call
      crypto: aesni - release FPU during skcipher walk API calls
      crypto: rmd128 - remove RIPE-MD 128 hash algorithm
      crypto: rmd256 - remove RIPE-MD 256 hash algorithm
      crypto: rmd320 - remove RIPE-MD 320 hash algorithm
      crypto: tgr192 - remove Tiger 128/160/192 hash algorithms
      crypto: salsa20 - remove Salsa20 stream cipher algorithm
      arm64: assembler: add cond_yield macro
      crypto: michael_mic - fix broken misalignment handling
      crypto: serpent - get rid of obsolete tnepres variant
      crypto: serpent - use unaligned accessors instead of alignmask
      crypto: blowfish - use unaligned accessors instead of alignmask
      crypto: camellia - use unaligned accessors instead of alignmask
      crypto: cast5 - use unaligned accessors instead of alignmask
      crypto: cast6 - use unaligned accessors instead of alignmask
      crypto: fcrypt - drop unneeded alignmask
      crypto: twofish - use unaligned accessors instead of alignmask
      crypto: arm64/sha1-ce - simplify NEON yield
      crypto: arm64/sha2-ce - simplify NEON yield
      crypto: arm64/sha3-ce - simplify NEON yield
      crypto: arm64/sha512-ce - simplify NEON yield
      crypto: arm64/aes-neonbs - remove NEON yield calls
      crypto: arm64/aes-ce-mac - simplify NEON yield
      crypto: arm64/crc-t10dif - move NEON yield to C code

Arnd Bergmann (1):
      crypto: octeontx2 - fix -Wpointer-bool-conversion warning

Bhaskar Chowdhury (2):
      crypto: marvell/cesa - Fix a spelling s/fautly/faultly/ in comment
      crypto: xor - Fix typo of optimization

Christophe JAILLET (1):
      hwrng: ingenic - Fix a resource leak in an error handling path

Christophe Leroy (2):
      crypto: talitos - Work around SEC6 ERRATA (AES-CTR mode data size error)
      crypto: talitos - Fix ctr(aes) on SEC1

Corentin Labbe (8):
      crypto: sun4i-ss - linearize buffers content must be kept
      crypto: sun4i-ss - checking sg length is not sufficient
      crypto: sun4i-ss - IV register does not work on A10 and A13
      crypto: sun4i-ss - handle BigEndian for cipher
      crypto: sun4i-ss - initialize need_fallback
      crypto: sun4i-ss - fix kmap usage
      crypto: sun4i-ss - enabled stats via debugfs
      crypto: sun4i-ss - add SPDX header and remove blank lines

Dan Carpenter (2):
      crypto: keembay-ocs-hcu - Fix a WARN() message
      crypto: octeontx2 - fix signedness bug in cptvf_register_interrupts()

Daniele Alessandrelli (6):
      crypto: keembay-ocs-hcu - Add HMAC support
      crypto: keembay-ocs-hcu - Add optional support for sha224
      MAINTAINERS: Add maintainers for Keem Bay OCS HCU driver
      crypto: keembay-ocs-hcu - Add dependency on HAS_IOMEM and ARCH_KEEMBAY
      crypto: ecdh_helper - Ensure 'len >= secret.len' in decode_key()
      crypto: keembay-ocs-aes - Fix 'q' assignment during CCM B0 generation

Declan Murphy (2):
      dt-bindings: crypto: Add Keem Bay OCS HCU bindings
      crypto: keembay - Add Keem Bay OCS HCU driver

Eric Biggers (14):
      crypto: blake2s - define shash_alg structs using macros
      crypto: x86/blake2s - define shash_alg structs using macros
      crypto: blake2s - remove unneeded includes
      crypto: blake2s - move update and final logic to internal/blake2s.h
      crypto: blake2s - share the "shash" API boilerplate code
      crypto: blake2s - optimize blake2s initialization
      crypto: blake2s - add comment for blake2s_state fields
      crypto: blake2s - adjust include guard naming
      crypto: blake2s - include <linux/bug.h> instead of <asm/bug.h>
      crypto: arm/blake2s - add ARM scalar optimized BLAKE2s
      wireguard: Kconfig: select CRYPTO_BLAKE2S_ARM
      crypto: blake2b - sync with blake2s implementation
      crypto: blake2b - update file comment
      crypto: arm/blake2b - add NEON-accelerated BLAKE2b

Fabio Estevam (1):
      crypto: sahara - Remove unused .id_table support

Florian Fainelli (1):
      crypto: crypto4xx - Avoid linking failure with HW_RANDOM=m

Geert Uytterhoeven (1):
      crypto: marvell - CRYPTO_DEV_OCTEONTX2_CPT should depend on ARCH_THUNDER2

Herbert Xu (6):
      crypto: vmx - Move extern declarations into header file
      crypto: stm32 - Fix last sparse warning in stm32_cryp_check_ctr_counter
      crypto: bcm - Fix sparse warnings
      crypto: marvell/cesa - Fix use of sg_pcopy on iomem pointer
      crypto: octeontx2 - Add dependency on NET_VENDOR_MARVELL
      Merge git://git.kernel.org/.../arm64/linux for-next/crypto

Hui Tang (6):
      crypto: hisilicon/hpre - delete ECC 1bit error reported threshold
      crypto: hisilicon/hpre - add two RAS correctable errors processing
      crypto: hisilicon/hpre - add ecc algorithm inqury for uacce device
      crypto: hisilicon/hpre - adapt the number of clusters
      crypto: hisilicon/hpre - tiny fix
      crypto: hisilicon/hpre - enable Elliptic curve cryptography

Jan Henrik Weinstock (1):
      hwrng: timeriomem - Fix cooldown period calculation

Jason A. Donenfeld (1):
      crypto: lib/chacha20poly1305 - define empty module exit function

Jiapeng Chong (1):
      crypto: caam - Replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE

Jiri Olsa (1):
      crypto: bcm - Rename struct device_private to bcm_device_private

Kai Ye (4):
      crypto: hisilicon/qm - SVA bugfixed on Kunpeng920
      crypto: hisilicon - add ZIP device using mode parameter
      crypto: hisilicon/hpre - register HPRE device to uacce
      crypto: hisilicon/sec - register SEC device to uacce

Krzysztof Kozlowski (1):
      MAINTAINERS: crypto: s5p-sss: drop Kamil Konieczny

Marco Chiappero (1):
      crypto: qat - replace CRYPTO_AES with CRYPTO_LIB_AES in Kconfig

Matthias Brugger (2):
      hwrng: iproc-rng200 - Fix disable of the block.
      hwrng: iproc-rng200 - Move enable/disable in separate function

Ovidiu Panait (1):
      crypto: keembay - use 64-bit arithmetic for computing bit_len

Rob Herring (1):
      crypto: picoxcell - Remove PicoXcell driver

Sihang Chen (1):
      crypto: hisilicon/qm - update irqflag

Srujana Challa (9):
      crypto: marvell - add Marvell OcteonTX2 CPT PF driver
      crypto: octeontx2 - add mailbox communication with AF
      crypto: octeontx2 - enable SR-IOV and mailbox communication with VF
      crypto: octeontx2 - load microcode and create engine groups
      crypto: octeontx2 - add LF framework
      crypto: octeontx2 - add support to get engine capabilities
      crypto: octeontx2 - add virtual function driver support
      crypto: octeontx2 - add support to process the crypto request
      crypto: octeontx2 - register with linux crypto framework

Tian Tao (4):
      crypto: ccree - remove unused including <linux/version.h>
      crypto: inside-secure - fix platform_get_irq.cocci warnings
      hwrng: optee - Use device-managed registration API
      hwrng: timeriomem - Use device-managed registration API

Vic Wu (1):
      crypto: mediatek - remove obsolete driver

Weili Qian (7):
      crypto: hisilicon/qm - fix use of 'dma_map_single'
      crypto: hisilicon - PASID fixed on Kunpeng 930
      crypto: hisilicon/qm - removing driver after reset
      crypto: hisilicon/qm - fix request missing error
      crypto: hisilicon/qm - fix the value of 'QM_SQC_VFT_BASE_MASK_V2'
      crypto: hisilicon/qm - do not reset hardware when CE happens
      crypto: hisilicon/qm - fix printing format issue

Wojciech Ziemba (1):
      crypto: qat - configure arbiter mapping based on engines enabled

Xu Wang (1):
      crypto: cpt - remove casting dma_alloc_coherent

Yang Li (1):
      crypto: powerpc/sha256 - remove unneeded semicolon

dingsenjie (1):
      crypto: ccree - fix spelling typo of allocated

 .mailmap                                           |    1 -
 .../admin-guide/device-mapper/dm-integrity.rst     |    4 +-
 Documentation/crypto/api-skcipher.rst              |    4 +-
 .../bindings/crypto/intel,keembay-ocs-hcu.yaml     |   46 +
 .../bindings/crypto/samsung-slimsss.yaml           |    1 -
 .../devicetree/bindings/crypto/samsung-sss.yaml    |    1 -
 MAINTAINERS                                        |   12 +-
 arch/arm/crypto/Kconfig                            |   19 +
 arch/arm/crypto/Makefile                           |    4 +
 arch/arm/crypto/aes-neonbs-glue.c                  |    3 +
 arch/arm/crypto/blake2b-neon-core.S                |  347 ++++
 arch/arm/crypto/blake2b-neon-glue.c                |  105 ++
 arch/arm/crypto/blake2s-core.S                     |  285 +++
 arch/arm/crypto/blake2s-glue.c                     |   78 +
 arch/arm64/crypto/aes-glue.c                       |   71 +-
 arch/arm64/crypto/aes-modes.S                      |  217 ++-
 arch/arm64/crypto/aes-neonbs-core.S                |    8 +-
 arch/arm64/crypto/crct10dif-ce-core.S              |   43 +-
 arch/arm64/crypto/crct10dif-ce-glue.c              |   30 +-
 arch/arm64/crypto/sha1-ce-core.S                   |   47 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |   23 +-
 arch/arm64/crypto/sha2-ce-core.S                   |   38 +-
 arch/arm64/crypto/sha2-ce-glue.c                   |   24 +-
 arch/arm64/crypto/sha3-ce-core.S                   |   81 +-
 arch/arm64/crypto/sha3-ce-glue.c                   |   18 +-
 arch/arm64/crypto/sha512-ce-core.S                 |   29 +-
 arch/arm64/crypto/sha512-ce-glue.c                 |   55 +-
 arch/arm64/include/asm/assembler.h                 |   16 +
 arch/powerpc/crypto/sha256-spe-glue.c              |    2 +-
 arch/s390/crypto/aes_s390.c                        |    2 +
 arch/x86/crypto/Makefile                           |    2 -
 arch/x86/crypto/aesni-intel_asm.S                  |  482 +++++-
 arch/x86/crypto/aesni-intel_glue.c                 |  753 ++++----
 arch/x86/crypto/blake2s-glue.c                     |  150 +-
 arch/x86/crypto/blowfish_glue.c                    |  107 --
 arch/x86/crypto/camellia-aesni-avx-asm_64.S        |  298 ----
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S       |  351 ----
 arch/x86/{include/asm => }/crypto/camellia.h       |   24 -
 arch/x86/crypto/camellia_aesni_avx2_glue.c         |  198 +--
 arch/x86/crypto/camellia_aesni_avx_glue.c          |  216 +--
 arch/x86/crypto/camellia_glue.c                    |  145 +-
 arch/x86/crypto/cast5_avx_glue.c                   |  287 +---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S          |   84 -
 arch/x86/crypto/cast6_avx_glue.c                   |  207 +--
 arch/x86/crypto/des3_ede_glue.c                    |  104 --
 arch/x86/crypto/ecb_cbc_helpers.h                  |   76 +
 arch/x86/crypto/glue_helper-asm-avx.S              |  104 --
 arch/x86/crypto/glue_helper-asm-avx2.S             |  136 --
 arch/x86/crypto/glue_helper.c                      |  381 -----
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S        |   68 -
 arch/x86/crypto/serpent-avx.h                      |   21 +
 arch/x86/crypto/serpent-avx2-asm_64.S              |   87 -
 arch/x86/{include/asm => }/crypto/serpent-sse2.h   |    0
 arch/x86/crypto/serpent_avx2_glue.c                |  185 +-
 arch/x86/crypto/serpent_avx_glue.c                 |  215 +--
 arch/x86/crypto/serpent_sse2_glue.c                |  150 +-
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S        |   80 -
 arch/x86/{include/asm => }/crypto/twofish.h        |    4 -
 arch/x86/crypto/twofish_avx_glue.c                 |  211 +--
 arch/x86/crypto/twofish_glue_3way.c                |  160 +-
 arch/x86/include/asm/crypto/glue_helper.h          |  118 --
 arch/x86/include/asm/crypto/serpent-avx.h          |   42 -
 crypto/Kconfig                                     |   96 +-
 crypto/Makefile                                    |    4 -
 crypto/adiantum.c                                  |    2 +
 crypto/ansi_cprng.c                                |    2 +
 crypto/blake2b_generic.c                           |  249 +--
 crypto/blake2s_generic.c                           |  158 +-
 crypto/blowfish_generic.c                          |   23 +-
 crypto/camellia_generic.c                          |   45 +-
 crypto/cast5_generic.c                             |   23 +-
 crypto/cast6_generic.c                             |   39 +-
 crypto/cbc.c                                       |    1 +
 crypto/ccm.c                                       |    2 +
 crypto/cfb.c                                       |    2 +
 crypto/cipher.c                                    |    7 +-
 crypto/cmac.c                                      |    2 +
 crypto/ctr.c                                       |    2 +
 crypto/drbg.c                                      |    2 +
 crypto/ecb.c                                       |    1 +
 crypto/ecdh_helper.c                               |    3 +
 crypto/essiv.c                                     |    2 +
 crypto/fcrypt.c                                    |    1 -
 crypto/keywrap.c                                   |    2 +
 crypto/michael_mic.c                               |   31 +-
 crypto/ofb.c                                       |    2 +
 crypto/pcbc.c                                      |    2 +
 crypto/ripemd.h                                    |   14 -
 crypto/rmd128.c                                    |  323 ----
 crypto/rmd256.c                                    |  342 ----
 crypto/rmd320.c                                    |  391 -----
 crypto/salsa20_generic.c                           |  212 ---
 crypto/serpent_generic.c                           |  126 +-
 crypto/skcipher.c                                  |    8 +-
 crypto/tcrypt.c                                    |  113 +-
 crypto/testmgr.c                                   |   57 +-
 crypto/testmgr.h                                   | 1632 ------------------
 crypto/tgr192.c                                    |  682 --------
 crypto/twofish_generic.c                           |   11 +-
 crypto/vmac.c                                      |    2 +
 crypto/xcbc.c                                      |    2 +
 crypto/xor.c                                       |    2 +-
 crypto/xts.c                                       |    2 +
 drivers/char/hw_random/ingenic-trng.c              |    6 +-
 drivers/char/hw_random/iproc-rng200.c              |   38 +-
 drivers/char/hw_random/optee-rng.c                 |    3 +-
 drivers/char/hw_random/timeriomem-rng.c            |    5 +-
 drivers/crypto/Kconfig                             |   35 +-
 drivers/crypto/Makefile                            |    2 -
 drivers/crypto/allwinner/Kconfig                   |    9 +
 .../crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c    |  196 ++-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c  |   52 +
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c  |    6 +
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c  |    6 +
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h       |    8 +
 drivers/crypto/bcm/cipher.c                        |    6 +-
 drivers/crypto/bcm/cipher.h                        |    4 +-
 drivers/crypto/bcm/spu.c                           |   20 +-
 drivers/crypto/bcm/spu2.c                          |    6 +-
 drivers/crypto/bcm/spu2.h                          |    8 +-
 drivers/crypto/bcm/spum.h                          |   22 +-
 drivers/crypto/bcm/util.c                          |    4 +-
 drivers/crypto/bcm/util.h                          |   26 +-
 drivers/crypto/caam/debugfs.c                      |    4 +-
 drivers/crypto/cavium/cpt/cptvf_main.c             |    8 +-
 drivers/crypto/ccree/cc_cipher.c                   |    2 +-
 drivers/crypto/ccree/cc_driver.h                   |    1 -
 drivers/crypto/geode-aes.c                         |    2 +
 drivers/crypto/hisilicon/hpre/hpre.h               |    8 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |  169 +-
 drivers/crypto/hisilicon/qm.c                      |  193 ++-
 drivers/crypto/hisilicon/qm.h                      |   33 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |   42 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |   23 +-
 drivers/crypto/inside-secure/safexcel.c            |    6 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |    1 +
 drivers/crypto/keembay/Kconfig                     |   31 +
 drivers/crypto/keembay/Makefile                    |    3 +
 drivers/crypto/keembay/keembay-ocs-hcu-core.c      | 1264 ++++++++++++++
 drivers/crypto/keembay/ocs-aes.c                   |   10 +-
 drivers/crypto/keembay/ocs-hcu.c                   |  840 +++++++++
 drivers/crypto/keembay/ocs-hcu.h                   |  106 ++
 drivers/crypto/marvell/Kconfig                     |   15 +
 drivers/crypto/marvell/Makefile                    |    1 +
 drivers/crypto/marvell/cesa/cesa.c                 |   10 +-
 drivers/crypto/marvell/cesa/cesa.h                 |   31 +-
 drivers/crypto/marvell/cesa/cipher.c               |   34 +-
 drivers/crypto/marvell/cesa/hash.c                 |   59 +-
 drivers/crypto/marvell/cesa/tdma.c                 |   52 +-
 drivers/crypto/marvell/octeontx2/Makefile          |   10 +
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h |  137 ++
 .../crypto/marvell/octeontx2/otx2_cpt_hw_types.h   |  464 +++++
 .../marvell/octeontx2/otx2_cpt_mbox_common.c       |  202 +++
 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h |  197 +++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c      |  428 +++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h      |  353 ++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h      |   61 +
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |  713 ++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c |  356 ++++
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    | 1415 +++++++++++++++
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.h    |  162 ++
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h      |   29 +
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 1758 +++++++++++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h |  178 ++
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c |  410 +++++
 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c |  167 ++
 .../crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c   |  541 ++++++
 drivers/crypto/mediatek/Makefile                   |    3 -
 drivers/crypto/mediatek/mtk-aes.c                  | 1271 --------------
 drivers/crypto/mediatek/mtk-platform.c             |  586 -------
 drivers/crypto/mediatek/mtk-platform.h             |  231 ---
 drivers/crypto/mediatek/mtk-regs.h                 |  190 --
 drivers/crypto/mediatek/mtk-sha.c                  | 1353 ---------------
 drivers/crypto/picoxcell_crypto.c                  | 1807 --------------------
 drivers/crypto/picoxcell_crypto_regs.h             |  115 --
 drivers/crypto/qat/Kconfig                         |    2 +-
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c     |   14 +-
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |   17 +-
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c     |   27 +-
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    3 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |    1 +
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c     |    8 +-
 drivers/crypto/qat/qat_common/adf_transport.c      |    2 +
 .../crypto/qat/qat_common/adf_transport_debug.c    |    4 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |    1 +
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |   12 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |   28 +-
 drivers/crypto/sahara.c                            |    7 -
 drivers/crypto/stm32/stm32-cryp.c                  |    2 +-
 drivers/crypto/talitos.c                           |   50 +-
 drivers/crypto/talitos.h                           |    1 +
 drivers/crypto/vmx/aes.c                           |    1 +
 drivers/crypto/vmx/aesp8-ppc.h                     |    6 +
 drivers/crypto/vmx/vmx.c                           |    7 +-
 drivers/net/Kconfig                                |    1 +
 drivers/net/ethernet/chelsio/inline_crypto/Kconfig |    1 +
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |   19 +-
 include/crypto/algapi.h                            |   39 -
 include/crypto/blake2b.h                           |   67 +
 include/crypto/blake2s.h                           |   63 +-
 include/crypto/hash.h                              |    8 +-
 include/crypto/internal/blake2b.h                  |  115 ++
 include/crypto/internal/blake2s.h                  |  109 +-
 include/crypto/internal/cipher.h                   |  218 +++
 include/crypto/internal/skcipher.h                 |    2 +-
 include/linux/crypto.h                             |  172 +-
 lib/crypto/blake2s.c                               |   48 +-
 lib/crypto/chacha20poly1305.c                      |    5 +
 208 files changed, 13977 insertions(+), 15312 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
 create mode 100644 arch/arm/crypto/blake2b-neon-core.S
 create mode 100644 arch/arm/crypto/blake2b-neon-glue.c
 create mode 100644 arch/arm/crypto/blake2s-core.S
 create mode 100644 arch/arm/crypto/blake2s-glue.c
 rename arch/x86/{include/asm => }/crypto/camellia.h (69%)
 create mode 100644 arch/x86/crypto/ecb_cbc_helpers.h
 delete mode 100644 arch/x86/crypto/glue_helper.c
 create mode 100644 arch/x86/crypto/serpent-avx.h
 rename arch/x86/{include/asm => }/crypto/serpent-sse2.h (100%)
 rename arch/x86/{include/asm => }/crypto/twofish.h (80%)
 delete mode 100644 arch/x86/include/asm/crypto/glue_helper.h
 delete mode 100644 arch/x86/include/asm/crypto/serpent-avx.h
 delete mode 100644 crypto/rmd128.c
 delete mode 100644 crypto/rmd256.c
 delete mode 100644 crypto/rmd320.c
 delete mode 100644 crypto/salsa20_generic.c
 delete mode 100644 crypto/tgr192.c
 create mode 100644 drivers/crypto/keembay/keembay-ocs-hcu-core.c
 create mode 100644 drivers/crypto/keembay/ocs-hcu.c
 create mode 100644 drivers/crypto/keembay/ocs-hcu.h
 create mode 100644 drivers/crypto/marvell/octeontx2/Makefile
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
 delete mode 100644 drivers/crypto/mediatek/Makefile
 delete mode 100644 drivers/crypto/mediatek/mtk-aes.c
 delete mode 100644 drivers/crypto/mediatek/mtk-platform.c
 delete mode 100644 drivers/crypto/mediatek/mtk-platform.h
 delete mode 100644 drivers/crypto/mediatek/mtk-regs.h
 delete mode 100644 drivers/crypto/mediatek/mtk-sha.c
 delete mode 100644 drivers/crypto/picoxcell_crypto.c
 delete mode 100644 drivers/crypto/picoxcell_crypto_regs.h
 create mode 100644 include/crypto/blake2b.h
 create mode 100644 include/crypto/internal/blake2b.h
 create mode 100644 include/crypto/internal/cipher.h

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
