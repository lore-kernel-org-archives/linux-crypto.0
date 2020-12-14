Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE28C4361B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 05:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5344D229EF
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 05:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgLNF4L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 00:56:11 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:46016 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388711AbgLNF4K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 00:56:10 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kogpI-0007on-4F; Mon, 14 Dec 2020 16:55:17 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 14 Dec 2020 16:55:16 +1100
Date:   Mon, 14 Dec 2020 16:55:16 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 5.11
Message-ID: <20201214055515.GA14196@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20201012033249.GA25179@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201012033249.GA25179@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

API:

- Add speed testing on 1420-byte blocks for networking.

Algorithms:

- Improve performance of chacha on ARM for network packets.
- Improve performance of aegis128 on ARM for network packets.

Drivers:

- Add support for Keem Bay OCS AES/SM4.
- Add support for QAT 4xxx devices.
- Enable crypto-engine retry mechanism in caam.
- Enable support for crypto engine on sdm845 in qce.
- Add HiSilicon PRNG driver support.

Please note that there is a merge conflict in the MAINTAINERS
file with the drm tree due to the Keem Bay driver.

The following changes since commit 3650b228f83adda7e5ee532e2b90429c03f7b9ec:

  Linux 5.10-rc1 (2020-10-25 15:14:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 linus 

for you to fetch changes up to 93cebeb1c21a65b92636aaa278a32fbc0415ec67:

  crypto: qat - add capability detection logic in qat_4xxx (2020-12-11 21:54:16 +1100)

----------------------------------------------------------------
Adam Guerin (2):
      crypto: qat - remove cast for mailbox CSR
      crypto: qat - replace pci with PCI in comments

Ahsan Atta (1):
      crypto: qat - num_rings_per_bank is device dependent

Ard Biesheuvel (14):
      crypto: arm64/poly1305-neon - reorder PAC authentication with SP update
      crypto: arm/chacha-neon - optimize for non-block size multiples
      crypto: arm64/chacha - simplify tail block handling
      crypto: arm64/gcm - move authentication tag check to SIMD domain
      crypto: aegis128 - wipe plaintext and tag if decryption fails
      crypto: aegis128/neon - optimize tail block handling
      crypto: aegis128/neon - move final tag check to SIMD domain
      crypto: aegis128 - expose SIMD code path as separate driver
      crypto: tcrypt - don't initialize at subsys_initcall time
      crypto: tcrypt - permit tcrypt.ko to be builtin
      crypto: tcrypt - include 1420 byte blocks in aead and skcipher benchmarks
      crypto: ecdh - avoid unaligned accesses in ecdh_set_secret()
      crypto: arm/aes-ce - work around Cortex-A57/A72 silion errata
      crypto: aegis128 - avoid spurious references crypto_aegis128_update_simd

Arnd Bergmann (1):
      crypto: atmel-i2c - select CONFIG_BITREVERSE

Arvind Sankar (6):
      crypto: lib/sha256 - Use memzero_explicit() for clearing state
      crypto: hash - Use memzero_explicit() for clearing state
      crypto: lib/sha256 - Don't clear temporary variables
      crypto: lib/sha256 - Clear W[] in sha256_update() instead of sha256_transform()
      crypto: lib/sha256 - Unroll SHA256 loop 8 times intead of 64
      crypto: lib/sha256 - Unroll LOAD and BLEND loops

Christophe JAILLET (3):
      crypto: cavium/zip - Use dma_set_mask_and_coherent to simplify code
      crypto: marvell/octeontx - Use dma_set_mask_and_coherent to simplify code
      crypto: cavium - Use dma_set_mask_and_coherent to simplify code

Christophe Leroy (2):
      crypto: talitos - Endianess in current_desc_hdr()
      crypto: talitos - Fix return type of current_desc_hdr()

Colin Ian King (2):
      crypto: inside-secure - Fix sizeof() mismatch
      crypto: kconfig - fix a couple of spelling mistakes

Corentin Labbe (1):
      crypto: sun8i-ce - fix two error path's memory leak

Daniele Alessandrelli (1):
      dt-bindings: Add Keem Bay OCS AES bindings

Eric Biggers (8):
      crypto: x86/aes - remove unused file aes_glue.c
      crypto: aead - add crypto_aead_driver_name()
      crypto: testmgr - always print the actual hash driver name
      crypto: testmgr - always print the actual AEAD driver name
      crypto: testmgr - always print the actual skcipher driver name
      crypto: testmgr - WARN on test failure
      crypto: af_alg - avoid undefined behavior accessing salg_name
      crypto: sha - split sha.h into sha1.h and sha2.h

Gilad Ben-Yossef (1):
      crypto: ccree - rework cache parameters handling

Giovanni Cabiddu (33):
      crypto: qat - remove unused function
      crypto: qat - mask device capabilities with soft straps
      crypto: qat - fix configuration of iov threads
      crypto: qat - split transport CSR access logic
      crypto: qat - relocate GEN2 CSR access code
      crypto: qat - abstract admin interface
      crypto: qat - add packed to init admin structures
      crypto: qat - rename ME in AE
      crypto: qat - change admin sequence
      crypto: qat - use admin mask to send fw constants
      crypto: qat - update constants table
      crypto: qat - remove writes into WQCFG
      crypto: qat - remove unused macros in arbiter module
      crypto: qat - abstract arbiter access
      crypto: qat - register crypto instances based on capability
      crypto: qat - enable ring after pair is programmed
      crypto: qat - abstract build ring base
      crypto: qat - replace constant masks with GENMASK
      crypto: qat - use BIT_ULL() - 1 pattern for masks
      crypto: qat - abstract writes to arbiter enable
      crypto: qat - remove hardcoded bank irq clear flag mask
      crypto: qat - call functions in adf_sriov if available
      crypto: qat - remove unnecessary void* casts
      crypto: qat - change return value in adf_cfg_add_key_value_param()
      crypto: qat - change return value in adf_cfg_key_val_get()
      crypto: qat - refactor qat_crypto_create_instances()
      crypto: qat - refactor qat_crypto_dev_config()
      crypto: qat - allow for instances in different banks
      crypto: qat - extend ae_mask
      crypto: qat - support for mof format in fw loader
      crypto: qat - target fw images to specific AEs
      crypto: qat - add hook to initialize vector routing table
      crypto: qat - add qat_4xxx driver

Gustavo A. R. Silva (1):
      crypto: ccree - Fix fall-through warnings for Clang

Herbert Xu (10):
      lib/mpi: Remove unused scalar_copied
      crypto: sa2ul - Reduce stack usage
      crypto: cavium/nitrox - Fix sparse warnings
      crypto: lib/curve25519 - Move selftest prototype into header file
      crypto: mips/octeon - Fix sparse endianness warnings
      crypto: powerpc/sha256-spe - Fix sparse endianness warning
      crypto: sparc - Fix sparse endianness warnings
      crypto: lib/blake2s - Move selftest prototype into header file
      hwrng: ks-sa - Add dependency on IOMEM and OF
      crypto: cpt - Fix sparse warnings in cptpf

Horia Geantă (3):
      crypto: arm/aes-neonbs - fix usage of cbc(aes) fallback
      crypto: caam - fix printing on xts fallback allocation error path
      crypto: caam/qi - simplify error path for context allocation

Iuliana Prodan (1):
      crypto: caam - enable crypto-engine retry mechanism

Jack Xu (31):
      crypto: qat - fix status check in qat_hal_put_rel_rd_xfer()
      crypto: qat - fix CSR access
      crypto: qat - fix error message
      crypto: qat - remove unnecessary parenthesis
      crypto: qat - introduce additional parenthesis
      crypto: qat - rename qat_uclo_del_uof_obj()
      crypto: qat - add support for relative FW ucode loading
      crypto: qat - change type for ctx_mask
      crypto: qat - change micro word data mask
      crypto: qat - refactor AE start
      crypto: qat - remove global CSRs helpers
      crypto: qat - move defines to header files
      crypto: qat - refactor qat_uclo_set_ae_mode()
      crypto: qat - refactor long expressions
      crypto: qat - introduce chip info structure
      crypto: qat - replace check based on DID
      crypto: qat - add next neighbor to chip_info
      crypto: qat - add support for lm2 and lm3
      crypto: qat - add local memory size to chip info
      crypto: qat - add reset CSR and mask to chip info
      crypto: qat - add clock enable CSR to chip info
      crypto: qat - add wake up event to chip info
      crypto: qat - add misc control CSR to chip info
      crypto: qat - add check for null pointer
      crypto: qat - use ae_mask
      crypto: qat - add CSS3K support
      crypto: qat - add FCU CSRs to chip info
      crypto: qat - allow to target specific AEs
      crypto: qat - add support for shared ustore
      crypto: qat - add support for broadcasting mode
      crypto: qat - add gen4 firmware loader

Jason A. Donenfeld (1):
      crypto: Kconfig - CRYPTO_MANAGER_EXTRA_TESTS requires the manager

Kai Ye (1):
      crypto: hisilicon/sec2 - Fix aead authentication setting key error

Longfang Liu (2):
      crypto: hisilicon - delete unused structure member variables
      crypto: hisilicon - fixes some coding style

Marco Chiappero (5):
      crypto: qat - update IV in software
      crypto: qat - add support for capability detection
      crypto: qat - add AES-CTR support for QAT GEN4 devices
      crypto: qat - add AES-XTS support for QAT GEN4 devices
      crypto: qat - add capability detection logic in qat_4xxx

Mike Healy (1):
      crypto: keembay - Add support for Keem Bay OCS AES/SM4

Nathan Chancellor (1):
      crypto: crypto4xx - Replace bitwise OR with logical OR in crypto4xx_build_pd

Nigel Christian (1):
      hwrng: imx-rngc - irq already prints an error

Shiju Jose (1):
      crypto: hisilicon - Fix doc warnings in sgl.c and qm.c

Thara Gopinath (2):
      crypto: qce - Enable support for crypto engine on sdm845
      crypto: qce - Fix SHA result buffer corruption issues

Tianjia Zhang (1):
      crypto: sm2 - remove unnecessary reset operations

Tom Rix (4):
      crypto: atmel-sha - remove unneeded break
      crypto: cavium/nitrox - remove unneeded semicolon
      crypto: qat - remove unneeded semicolon
      crypto: seed - remove trailing semicolon in macro definition

Uros Bizjak (3):
      crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg
      crypto: x86/sha512 - Use TEST %reg,%reg instead of CMP $0,%reg
      crypto: x86/poly1305 - Use TEST %reg,%reg instead of CMP $0,%reg

Weili Qian (12):
      crypto: hisilicon/qm - numbers are replaced by macros
      crypto: hisilicon/qm - modify the return type of function
      crypto: hisilicon/qm - modify the return type of debugfs interface
      crypto: hisilicon/qm - modify return type of 'qm_set_sqctype'
      crypto: hisilicon/qm - replace 'sprintf' with 'scnprintf'
      crypto: hisilicon/qm - split 'qm_qp_ctx_cfg' into smaller pieces
      crypto: hisilicon/qm - split 'qm_eq_ctx_cfg' into smaller pieces
      crypto: hisilicon/qm - split 'hisi_qm_init' into smaller pieces
      hwrng: hisi - remove HiSilicon TRNG driver
      crypto: hisilicon/trng - add HiSilicon TRNG driver support
      crypto: hisilicon/trng - add support for PRNG
      MAINTAINERS: Move HiSilicon TRNG V2 driver

Yang Shen (1):
      crypto: hisilicon/zip - add a work_queue for zip irq

Yejune Deng (1):
      crypto: hisilicon/trng - replace atomic_add_return()

Zhang Qilong (2):
      crypto: omap-aes - fix the reference count leak of omap device
      crypto: omap-aes - Fix PM disable depth imbalance in omap_aes_probe

kernel test robot (1):
      crypto: qat - fix excluded_middle.cocci warnings

 .../bindings/crypto/intel,keembay-ocs-aes.yaml     |   45 +
 MAINTAINERS                                        |   12 +-
 arch/arm/crypto/aes-ce-core.S                      |   32 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |    8 +-
 arch/arm/crypto/chacha-glue.c                      |   34 +-
 arch/arm/crypto/chacha-neon-core.S                 |   97 +-
 arch/arm/crypto/sha1-ce-glue.c                     |    2 +-
 arch/arm/crypto/sha1.h                             |    2 +-
 arch/arm/crypto/sha1_glue.c                        |    2 +-
 arch/arm/crypto/sha1_neon_glue.c                   |    2 +-
 arch/arm/crypto/sha2-ce-glue.c                     |    2 +-
 arch/arm/crypto/sha256_glue.c                      |    2 +-
 arch/arm/crypto/sha256_neon_glue.c                 |    2 +-
 arch/arm/crypto/sha512-glue.c                      |    2 +-
 arch/arm/crypto/sha512-neon-glue.c                 |    2 +-
 arch/arm64/configs/defconfig                       |    1 +
 arch/arm64/crypto/aes-glue.c                       |    2 +-
 arch/arm64/crypto/chacha-neon-core.S               |  193 +--
 arch/arm64/crypto/ghash-ce-core.S                  |   15 +
 arch/arm64/crypto/ghash-ce-glue.c                  |   48 +-
 arch/arm64/crypto/poly1305-armv8.pl                |    2 +-
 arch/arm64/crypto/poly1305-core.S_shipped          |    2 +-
 arch/arm64/crypto/poly1305-glue.c                  |    2 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |    2 +-
 arch/arm64/crypto/sha2-ce-glue.c                   |    2 +-
 arch/arm64/crypto/sha256-glue.c                    |    2 +-
 arch/arm64/crypto/sha3-ce-glue.c                   |    2 +-
 arch/arm64/crypto/sha512-ce-glue.c                 |    2 +-
 arch/arm64/crypto/sha512-glue.c                    |    2 +-
 arch/mips/cavium-octeon/crypto/octeon-crypto.h     |    2 +-
 arch/mips/cavium-octeon/crypto/octeon-md5.c        |   14 +-
 arch/mips/cavium-octeon/crypto/octeon-sha1.c       |    2 +-
 arch/mips/cavium-octeon/crypto/octeon-sha256.c     |    2 +-
 arch/mips/cavium-octeon/crypto/octeon-sha512.c     |    2 +-
 arch/powerpc/crypto/sha1-spe-glue.c                |    2 +-
 arch/powerpc/crypto/sha1.c                         |    2 +-
 arch/powerpc/crypto/sha256-spe-glue.c              |    4 +-
 arch/s390/crypto/sha.h                             |    3 +-
 arch/s390/crypto/sha1_s390.c                       |    2 +-
 arch/s390/crypto/sha256_s390.c                     |    2 +-
 arch/s390/crypto/sha3_256_s390.c                   |    1 -
 arch/s390/crypto/sha3_512_s390.c                   |    1 -
 arch/s390/crypto/sha512_s390.c                     |    2 +-
 arch/s390/purgatory/purgatory.c                    |    2 +-
 arch/sparc/crypto/crc32c_glue.c                    |    2 +-
 arch/sparc/crypto/md5_glue.c                       |    9 +-
 arch/sparc/crypto/sha1_glue.c                      |    2 +-
 arch/sparc/crypto/sha256_glue.c                    |    2 +-
 arch/sparc/crypto/sha512_glue.c                    |    2 +-
 arch/x86/crypto/aes_glue.c                         |    1 -
 arch/x86/crypto/aesni-intel_asm.S                  |   20 +-
 arch/x86/crypto/aesni-intel_avx-x86_64.S           |   20 +-
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl      |    2 +-
 arch/x86/crypto/poly1305_glue.c                    |    2 +-
 arch/x86/crypto/sha1_ssse3_glue.c                  |    2 +-
 arch/x86/crypto/sha256_ssse3_glue.c                |    2 +-
 arch/x86/crypto/sha512-avx-asm.S                   |    2 +-
 arch/x86/crypto/sha512-ssse3-asm.S                 |    2 +-
 arch/x86/crypto/sha512_ssse3_glue.c                |    2 +-
 arch/x86/purgatory/purgatory.c                     |    2 +-
 crypto/Kconfig                                     |    4 +-
 crypto/aegis128-core.c                             |  245 ++-
 crypto/aegis128-neon-inner.c                       |  122 +-
 crypto/aegis128-neon.c                             |   21 +-
 crypto/af_alg.c                                    |   10 +-
 crypto/asymmetric_keys/asym_tpm.c                  |    2 +-
 crypto/ecdh.c                                      |    9 +-
 crypto/seed.c                                      |    2 +-
 crypto/sha1_generic.c                              |    2 +-
 crypto/sha256_generic.c                            |    2 +-
 crypto/sha512_generic.c                            |    2 +-
 crypto/sm2.c                                       |   75 +-
 crypto/tcrypt.c                                    |   83 +-
 crypto/testmgr.c                                   |  141 +-
 drivers/char/hw_random/Kconfig                     |   14 +-
 drivers/char/hw_random/Makefile                    |    1 -
 drivers/char/hw_random/hisi-trng-v2.c              |   99 --
 drivers/char/hw_random/imx-rngc.c                  |    4 +-
 drivers/char/random.c                              |    2 +-
 drivers/crypto/Kconfig                             |    5 +-
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/allwinner/Kconfig                   |    2 +-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h       |    2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c  |   23 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |    3 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |    3 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |    3 +-
 drivers/crypto/amcc/crypto4xx_alg.c                |    2 +-
 drivers/crypto/amcc/crypto4xx_core.c               |    4 +-
 drivers/crypto/atmel-authenc.h                     |    3 +-
 drivers/crypto/atmel-sha.c                         |    4 +-
 drivers/crypto/axis/artpec6_crypto.c               |    3 +-
 drivers/crypto/bcm/cipher.c                        |    3 +-
 drivers/crypto/bcm/cipher.h                        |    3 +-
 drivers/crypto/bcm/spu.h                           |    3 +-
 drivers/crypto/caam/caamalg.c                      |    4 +-
 drivers/crypto/caam/caamalg_qi.c                   |   12 +-
 drivers/crypto/caam/caamalg_qi2.c                  |    3 +-
 drivers/crypto/caam/compat.h                       |    3 +-
 drivers/crypto/caam/intern.h                       |    8 +
 drivers/crypto/caam/jr.c                           |    4 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |   16 +-
 drivers/crypto/cavium/cpt/cptvf_main.c             |   10 +-
 drivers/crypto/cavium/nitrox/nitrox_aead.c         |   11 +-
 drivers/crypto/cavium/nitrox/nitrox_debugfs.c      |    1 +
 drivers/crypto/cavium/nitrox/nitrox_hal.c          |    1 +
 drivers/crypto/cavium/nitrox/nitrox_isr.c          |    1 +
 drivers/crypto/cavium/nitrox/nitrox_isr.h          |    9 +
 drivers/crypto/cavium/nitrox/nitrox_main.c         |   13 -
 drivers/crypto/cavium/nitrox/nitrox_mbx.c          |    3 +-
 drivers/crypto/cavium/nitrox/nitrox_req.h          |    4 +
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c       |    7 +-
 drivers/crypto/cavium/zip/zip_main.c               |   10 +-
 drivers/crypto/ccp/ccp-crypto-sha.c                |    3 +-
 drivers/crypto/ccp/ccp-crypto.h                    |    3 +-
 drivers/crypto/ccree/cc_cipher.c                   |    3 +
 drivers/crypto/ccree/cc_driver.c                   |   75 +-
 drivers/crypto/ccree/cc_driver.h                   |    9 +-
 drivers/crypto/ccree/cc_pm.c                       |    2 +-
 drivers/crypto/chelsio/chcr_algo.c                 |    3 +-
 drivers/crypto/hisilicon/Kconfig                   |    8 +
 drivers/crypto/hisilicon/Makefile                  |    1 +
 drivers/crypto/hisilicon/hpre/hpre_main.c          |    4 +-
 drivers/crypto/hisilicon/qm.c                      |  220 ++-
 drivers/crypto/hisilicon/qm.h                      |    2 +-
 drivers/crypto/hisilicon/sec2/sec.h                |    2 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |   25 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |   34 +-
 drivers/crypto/hisilicon/sgl.c                     |    2 -
 drivers/crypto/hisilicon/trng/Makefile             |    2 +
 drivers/crypto/hisilicon/trng/trng.c               |  334 ++++
 drivers/crypto/hisilicon/zip/zip_main.c            |   30 +-
 drivers/crypto/img-hash.c                          |    3 +-
 drivers/crypto/inside-secure/safexcel.c            |    2 +-
 drivers/crypto/inside-secure/safexcel.h            |    3 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |    3 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |    3 +-
 drivers/crypto/ixp4xx_crypto.c                     |    2 +-
 drivers/crypto/keembay/Kconfig                     |   39 +
 drivers/crypto/keembay/Makefile                    |    5 +
 drivers/crypto/keembay/keembay-ocs-aes-core.c      | 1713 ++++++++++++++++++++
 drivers/crypto/keembay/ocs-aes.c                   | 1489 +++++++++++++++++
 drivers/crypto/keembay/ocs-aes.h                   |  129 ++
 drivers/crypto/marvell/cesa/hash.c                 |    3 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_main.c   |   10 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c   |    3 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c   |   10 +-
 drivers/crypto/mediatek/mtk-sha.c                  |    3 +-
 drivers/crypto/mxs-dcp.c                           |    3 +-
 drivers/crypto/n2_core.c                           |    3 +-
 drivers/crypto/nx/nx-sha256.c                      |    2 +-
 drivers/crypto/nx/nx-sha512.c                      |    2 +-
 drivers/crypto/nx/nx.c                             |    2 +-
 drivers/crypto/omap-aes.c                          |    4 +-
 drivers/crypto/omap-sham.c                         |    3 +-
 drivers/crypto/padlock-sha.c                       |    3 +-
 drivers/crypto/picoxcell_crypto.c                  |    3 +-
 drivers/crypto/qat/Kconfig                         |   11 +
 drivers/crypto/qat/Makefile                        |    1 +
 drivers/crypto/qat/qat_4xxx/Makefile               |    4 +
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c     |  242 +++
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h     |   86 +
 drivers/crypto/qat/qat_4xxx/adf_drv.c              |  323 ++++
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |   49 +-
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h   |    5 +
 drivers/crypto/qat/qat_c3xxx/adf_drv.c             |   11 +-
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c   |    7 +-
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c           |    4 +-
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c     |   49 +-
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h     |    5 +
 drivers/crypto/qat/qat_c62x/adf_drv.c              |   11 +-
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c |    7 +-
 drivers/crypto/qat/qat_c62xvf/adf_drv.c            |    4 +-
 drivers/crypto/qat/qat_common/Makefile             |    2 +
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |   65 +-
 drivers/crypto/qat/qat_common/adf_accel_engine.c   |   69 +-
 drivers/crypto/qat/qat_common/adf_admin.c          |   77 +-
 drivers/crypto/qat/qat_common/adf_cfg.c            |    4 +-
 drivers/crypto/qat/qat_common/adf_cfg_common.h     |    3 +-
 drivers/crypto/qat/qat_common/adf_cfg_strings.h    |    3 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   19 +-
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |   11 +-
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.c   |  181 +++
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.h   |  123 ++
 drivers/crypto/qat/qat_common/adf_gen4_hw_data.c   |  101 ++
 drivers/crypto/qat/qat_common/adf_gen4_hw_data.h   |   99 ++
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c     |   94 +-
 drivers/crypto/qat/qat_common/adf_isr.c            |    7 +-
 drivers/crypto/qat/qat_common/adf_sriov.c          |   78 +-
 drivers/crypto/qat/qat_common/adf_transport.c      |  130 +-
 .../qat/qat_common/adf_transport_access_macros.h   |   67 -
 .../crypto/qat/qat_common/adf_transport_debug.c    |   32 +-
 .../crypto/qat/qat_common/adf_transport_internal.h |    2 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |    5 +-
 .../crypto/qat/qat_common/icp_qat_fw_init_admin.h  |    6 +-
 drivers/crypto/qat/qat_common/icp_qat_fw_la.h      |    7 +
 .../qat/qat_common/icp_qat_fw_loader_handle.h      |   26 +-
 drivers/crypto/qat/qat_common/icp_qat_hal.h        |   63 +-
 drivers/crypto/qat/qat_common/icp_qat_hw.h         |   40 +-
 drivers/crypto/qat/qat_common/icp_qat_uclo.h       |  132 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |  248 ++-
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |   13 +-
 drivers/crypto/qat/qat_common/qat_crypto.c         |  162 +-
 drivers/crypto/qat/qat_common/qat_crypto.h         |   26 +-
 drivers/crypto/qat/qat_common/qat_hal.c            |  421 +++--
 drivers/crypto/qat/qat_common/qat_uclo.c           |  737 +++++++--
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |   60 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    5 +
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |    9 +-
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |    7 +-
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |    4 +-
 drivers/crypto/qce/common.c                        |    3 +-
 drivers/crypto/qce/core.c                          |   18 +-
 drivers/crypto/qce/sha.c                           |    2 +-
 drivers/crypto/qce/sha.h                           |    3 +-
 drivers/crypto/rockchip/rk3288_crypto.h            |    3 +-
 drivers/crypto/s5p-sss.c                           |    3 +-
 drivers/crypto/sa2ul.c                             |  121 +-
 drivers/crypto/sa2ul.h                             |    7 +-
 drivers/crypto/sahara.c                            |    3 +-
 drivers/crypto/stm32/stm32-hash.c                  |    3 +-
 drivers/crypto/talitos.c                           |   13 +-
 drivers/crypto/ux500/hash/hash_core.c              |    3 +-
 drivers/firmware/efi/embedded-firmware.c           |    2 +-
 .../chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c    |    3 +-
 .../ethernet/chelsio/inline_crypto/chtls/chtls.h   |    3 +-
 drivers/nfc/s3fwrn5/firmware.c                     |    2 +-
 drivers/tee/tee_core.c                             |    2 +-
 fs/crypto/fname.c                                  |    2 +-
 fs/crypto/hkdf.c                                   |    2 +-
 fs/ubifs/auth.c                                    |    1 -
 fs/verity/fsverity_private.h                       |    2 +-
 include/crypto/aead.h                              |    5 +
 include/crypto/curve25519.h                        |    2 +
 include/crypto/hash_info.h                         |    3 +-
 include/crypto/internal/blake2s.h                  |    2 +
 include/crypto/sha1.h                              |   46 +
 include/crypto/sha1_base.h                         |    5 +-
 include/crypto/{sha.h => sha2.h}                   |   41 +-
 include/crypto/sha256_base.h                       |    5 +-
 include/crypto/sha512_base.h                       |    5 +-
 include/crypto/sm3_base.h                          |    3 +-
 include/linux/ccp.h                                |    3 +-
 include/linux/filter.h                             |    2 +-
 include/linux/purgatory.h                          |    2 +-
 include/uapi/linux/if_alg.h                        |   16 +
 kernel/crash_core.c                                |    2 +-
 kernel/kexec_core.c                                |    1 -
 kernel/kexec_file.c                                |    2 +-
 lib/crypto/blake2s-selftest.c                      |    2 +-
 lib/crypto/blake2s.c                               |    2 -
 lib/crypto/curve25519.c                            |    2 -
 lib/crypto/sha256.c                                |  214 +--
 lib/digsig.c                                       |    2 +-
 lib/mpi/ec.c                                       |    3 -
 lib/sha1.c                                         |    2 +-
 net/ipv6/seg6_hmac.c                               |    1 -
 net/mptcp/crypto.c                                 |    2 +-
 net/mptcp/options.c                                |    2 +-
 net/mptcp/subflow.c                                |    2 +-
 security/integrity/integrity.h                     |    2 +-
 security/keys/encrypted-keys/encrypted.c           |    2 +-
 security/keys/trusted-keys/trusted_tpm1.c          |    2 +-
 sound/soc/codecs/cros_ec_codec.c                   |    2 +-
 264 files changed, 8427 insertions(+), 1992 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-aes.yaml
 delete mode 100644 arch/x86/crypto/aes_glue.c
 delete mode 100644 drivers/char/hw_random/hisi-trng-v2.c
 create mode 100644 drivers/crypto/hisilicon/trng/Makefile
 create mode 100644 drivers/crypto/hisilicon/trng/trng.c
 create mode 100644 drivers/crypto/keembay/Kconfig
 create mode 100644 drivers/crypto/keembay/Makefile
 create mode 100644 drivers/crypto/keembay/keembay-ocs-aes-core.c
 create mode 100644 drivers/crypto/keembay/ocs-aes.c
 create mode 100644 drivers/crypto/keembay/ocs-aes.h
 create mode 100644 drivers/crypto/qat/qat_4xxx/Makefile
 create mode 100644 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
 create mode 100644 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
 create mode 100644 drivers/crypto/qat/qat_4xxx/adf_drv.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_hw_data.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
 create mode 100644 include/crypto/sha1.h
 rename include/crypto/{sha.h => sha2.h} (77%)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
