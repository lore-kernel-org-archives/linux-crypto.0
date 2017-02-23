From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.11
Date: Thu, 23 Feb 2017 20:51:42 +0800
Message-ID: <20170223125141.GA17400@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41995 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751099AbdBWMye (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2017 07:54:34 -0500
Content-Disposition: inline
In-Reply-To: <20161213132414.GA7898@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

Here is the crypto update for 4.11:

API:

- Try to catch hash output overrun in testmgr.
- Introduce walksize attribute for batched walking.
- Make crypto_xor() and crypto_inc() alignment agnostic.

Algorithms:

- Add time-invariant AES algorithm.
- Add standalone CBCMAC algorithm.

Drivers:

- Add NEON acclerated chacha20 on ARM/ARM64.
- Expose AES-CTR as synchronous skcipher on ARM64.
- Add scalar AES implementation on ARM64.
- Improve scalar AES implementation on ARM.
- Improve NEON AES implementation on ARM/ARM64.
- Merge CRC32 and PMULL instruction based drivers on ARM64.
- Add NEON acclerated CBCMAC/CMAC/XCBC AES on ARM64.
- Add IPsec AUTHENC implementation in atmel.
- Add Support for Octeon-tx CPT Engine.
- Add Broadcom SPU driver.
- Add MediaTek driver.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ahsan Atta (2):
      crypto: qat - fix indentation
      crypto: qat - fix comments describing adf_disable_sriov()

Andrew Lutomirski (1):
      crypto: testmgr - Allocate only the required output size for hash tests

Ard Biesheuvel (33):
      crypto: arm64/chacha20 - implement NEON version based on SSE3 code
      crypto: arm/chacha20 - implement NEON version based on SSE3 code
      crypto: chacha20 - convert generic and x86 versions to skcipher
      crypto: skcipher - introduce walksize attribute for SIMD algos
      crypto: arm64/aes-blk - expose AES-CTR as synchronous cipher as well
      crypto: arm64/aes - add scalar implementation
      crypto: arm/aes - replace scalar AES cipher
      crypto: arm64/aes - reimplement bit-sliced ARM/NEON implementation for arm64
      crypto: arm/aes - replace bit-sliced OpenSSL NEON code
      crypto: testmgr - use calculated count for number of test vectors
      crypto: arm/aes - avoid reserved 'tt' mnemonic in asm code
      crypto: arm64/aes-blk - honour iv_out requirement in CBC and CTR modes
      crypto: arm/aes-neonbs - fix issue with v2.22 and older assembler
      crypto: arm/aes-ce - remove cra_alignmask
      crypto: arm/chacha20 - remove cra_alignmask
      crypto: arm64/aes-ce-ccm - remove cra_alignmask
      crypto: arm64/aes-blk - remove cra_alignmask
      crypto: arm64/chacha20 - remove cra_alignmask
      crypto: arm64/aes - avoid literals for cross-module symbol references
      crypto: arm64/aes - performance tweak
      crypto: arm64/aes-neon-blk - tweak performance for low end cores
      crypto: arm64/aes - replace scalar fallback with plain NEON fallback
      crypto: arm64/aes - don't use IV buffer to return final keystream block
      crypto: arm/aes - don't use IV buffer to return final keystream block
      crypto: arm64/crc32 - merge CRC32 and PMULL instruction based drivers
      crypto: aes-generic - drop alignment requirement
      crypto: aes - add generic time invariant AES cipher
      crypto: testmgr - add test cases for cbcmac(aes)
      crypto: ccm - switch to separate cbcmac driver
      crypto: arm64/aes - add NEON/Crypto Extensions CBCMAC/CMAC/XCBC driver
      crypto: algapi - make crypto_xor() and crypto_inc() alignment agnostic
      crypto: ccm - honour alignmask of subordinate MAC cipher
      crypto: ccm - drop unnecessary minimum 32-bit alignment

Arnd Bergmann (6):
      crypto: mediatek - remove ARM dependencies
      crypto: mediatek - fix format string for 64-bit builds
      crypto: improve gcc optimization flags for serpent and wp512
      crypto: atmel - refine Kconfig dependencies
      crypto: atmel - fix 64-bit build warnings
      crypto: cavium - fix Kconfig dependencies

Christoph Hellwig (3):
      crypto: cavium - remove dead MSI-X related define
      crypto: cavium - switch to pci_alloc_irq_vectors
      crypto: cavium - switch to pci_alloc_irq_vectors

Colin Ian King (1):
      crypto: mediatek - don't return garbage err on successful return

Corentin LABBE (9):
      crypto: drivers - bring back alphabetical order of Makefile
      hwrng: core - do not use multiple blank lines
      hwrng: core - rewrite better comparison to NULL
      hwrng: core - Rewrite the header
      hwrng: core - Replace asm/uaccess.h by linux/uaccess.h
      hwrng: core - Move hwrng miscdev minor number to include/linux/miscdevice.h
      hwrng: core - remove unused PFX macro
      crypto: bfin_crc - Fix format printing warning
      crypto: bfin_crc - Remove unneeded linux/miscdevice.h include

Cyrille Pitchen (14):
      crypto: atmel-sha - create function to get an Atmel SHA device
      crypto: atmel-sha - update request queue management to make it more generic
      crypto: atmel-sha - make atmel_sha_done_task more generic
      crypto: atmel-sha - redefine SHA_FLAGS_SHA* flags to match SHA_MR_ALGO_SHA*
      crypto: atmel-sha - add atmel_sha_wait_for_data_ready()
      crypto: atmel-sha - add SHA_MR_MODE_IDATAR0
      crypto: atmel-sha - add atmel_sha_cpu_start()
      crypto: atmel-sha - add simple DMA transfers
      crypto: atmel-sha - add support to hmac(shaX)
      crypto: atmel-aes - fix atmel_aes_handle_queue()
      crypto: atmel-authenc - add support to authenc(hmac(shaX), Y(aes)) modes
      crypto: atmel-sha - add verbose debug facilities to print hw register names
      crypto: atmel-sha - fix missing "return" instructions
      crypto: atmel-sha - fix error management in atmel_sha_start()

David Daney (1):
      hwrng: cavium - Use per device name to allow for multiple devices.

Denys Vlasenko (2):
      crypto: x86/crc32c - fix %progbits -> @progbits
      crypto: x86 - make constants readonly, allow linker to merge them

Eric Biggers (1):
      crypto: testmgr - use kmemdup instead of kmalloc+memcpy

Gary R Hook (6):
      crypto: ccp - Fix DMA operations when IOMMU is enabled
      crypto: ccp - Fix double add when creating new DMA command
      crypto: ccp - Set the AES size field for all modes
      crypto: ccp - Change mode for detailed CCP init messages
      crypto: ccp - Update the command queue on errors
      crypto: ccp - Simplify some buffer management routines

George Cherian (4):
      crypto: cavium - Add Support for Octeon-tx CPT Engine
      crypto: cavium - Add the Virtual Function driver for CPT
      crypto: cavium - Enable CPT options crypto for build
      crypto: cavium - cpt_bind_vq_to_grp could return an error code

Gideon Israel Dsouza (1):
      crypto: Replaced gcc specific attributes with macros from compiler.h

Gilad Ben-Yossef (1):
      crypto: doc - fix typo

Giovanni Cabiddu (3):
      crypto: qat - replace hardcoded BIT(0) in vf_isr
      crypto: qat - fix bar discovery for c62x
      crypto: qat - zero esram only for DH85x devices

Gonglei \(Arei\) (2):
      crypto: virtio - support crypto engine framework
      crypto: virtio - adjust priority of algorithm

Harsh Jain (11):
      crypto: chcr - Fix panic on dma_unmap_sg
      crypto: chcr - Check device is allocated before use
      crypto: algif_aead - Fix kernel panic on list_del
      crypto: chcr - Fix key length for RFC4106
      crypto: chcr - Change flow IDs
      crypto: chcr - fix itnull.cocci warnings
      crypto: chcr - Use cipher instead of Block Cipher in gcm setkey
      crypto: chcr - Change cra_flags for cipher algos
      crypto: chcr - Change algo priority
      crypto: chcr - Fix wrong typecasting
      crypto: chcr - Fix Smatch Complaint

Herbert Xu (7):
      Revert "crypto: arm64/ARM: NEON accelerated ChaCha20"
      crypto: aesni - Fix failure when built-in with modular pcbc
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux
      crypto: x86/chacha20 - Manually align stack buffer
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

Horia Geantă (11):
      crypto: caam - don't include unneeded headers
      crypto: caam - check return code of dma_set_mask_and_coherent()
      crypto: caam - fix HW S/G in ablkcipher_giv_edesc_alloc()
      crypto: caam - check sg_count() return value
      crypto: caam - replace sg_count() with sg_nents_for_len()
      crypto: caam - use dma_map_sg() return code
      crypto: caam - don't dma_map key for hash algorithms
      crypto: caam - fix DMA API leaks for multiple setkey() calls
      crypto: caam - fix error path for ctx_dma mapping failure
      crypto: caam - abstract ahash request double buffering
      crypto: caam - fix state buffer DMA (un)mapping

Ilya Lesokhin (1):
      crypto: aesni-intel - RFC4106 can zero copy when !PageHighMem

Javier Martinez Canillas (3):
      crypto: picoxcell - Allow driver to build COMPILE_TEST is enabled
      crypto: picoxcell - Remove platform device ID table
      crypto: picoxcell - Remove spacc_is_compatible() wrapper function

Jiri Slaby (1):
      crypto: algif_hash - avoid zero-sized array

Laura Abbott (1):
      crypto: testmgr - Use heap buffer for acomp test input

Li Zhong (1):
      crypto: vmx - disable preemption to enable vsx in aes_ctr.c

Milan Broz (1):
      crypto: xts - Add ECB dependency

Nicolas Iooss (1):
      crypto: img-hash - use dma_data_direction when calling dma_map_sg

Pablo Marcos Oltra (1):
      crypto: qat - modify format of dev top level debugfs entries

Rabin Vincent (2):
      crypto: tcrypt - Add debug prints
      crypto: doc - Fix hash export state information

Rob Rice (3):
      crypto: brcm - DT documentation for Broadcom SPU hardware
      crypto: brcm - Add Broadcom SPU driver
      crypto: brcm - Avoid double free in ahash_finup()

Russell King (1):
      hwrng: omap - update Kconfig help description

Ryder Lee (10):
      crypto: mediatek - Add crypto driver support for some MediaTek chips
      crypto: mediatek - add DT bindings documentation
      crypto: mediatek - move HW control data to transformation context
      crypto: mediatek - fix incorrect data transfer result
      crypto: mediatek - make crypto request queue management more generic
      crypto: mediatek - rework crypto request completion
      crypto: mediatek - regroup functions by usage
      crypto: mediatek - fix typo and indentation
      crypto: mediatek - add support to CTR mode
      crypto: mediatek - add support to GCM mode

Salvatore Benedetto (1):
      crypto: api - Clear CRYPTO_ALG_DEAD bit before registering an alg

Shannon Nelson (4):
      hwrng: n2 - limit error spewage when self-test fails
      hwrng: n2 - add device data descriptions
      hwrng: n2 - support new hardware register layout
      hwrng: n2 - update version info

Tim Chen (1):
      crypto: sha512-mb - Protect sha512 mb ctx mgr access

Tudor Ambarus (1):
      crypto: caam - fix JR IO mapping if one fails

Wei Yongjun (1):
      crypto: mediatek - make symbol of_crypto_id static

Xin Zeng (2):
      crypto: qat - increase number of supported devices

 Documentation/crypto/api-digest.rst                |    2 +-
 Documentation/crypto/api-skcipher.rst              |    2 +-
 .../devicetree/bindings/crypto/brcm,spu-crypto.txt |   22 +
 .../devicetree/bindings/crypto/mediatek-crypto.txt |   27 +
 MAINTAINERS                                        |    7 +
 arch/arm/crypto/Kconfig                            |   27 +-
 arch/arm/crypto/Makefile                           |   11 +-
 arch/arm/crypto/aes-armv4.S                        | 1089 -----
 arch/arm/crypto/aes-ce-core.S                      |   84 +-
 arch/arm/crypto/aes-ce-glue.c                      |   15 +-
 arch/arm/crypto/aes-cipher-core.S                  |  179 +
 arch/arm/crypto/aes-cipher-glue.c                  |   74 +
 arch/arm/crypto/aes-neonbs-core.S                  | 1023 ++++
 arch/arm/crypto/aes-neonbs-glue.c                  |  406 ++
 arch/arm/crypto/aes_glue.c                         |   98 -
 arch/arm/crypto/aes_glue.h                         |   19 -
 arch/arm/crypto/aesbs-core.S_shipped               | 2548 ----------
 arch/arm/crypto/aesbs-glue.c                       |  367 --
 arch/arm/crypto/bsaes-armv7.pl                     | 2471 ----------
 arch/arm/crypto/chacha20-neon-core.S               |  523 +++
 arch/arm/crypto/chacha20-neon-glue.c               |  127 +
 arch/arm64/configs/defconfig                       |    1 -
 arch/arm64/crypto/Kconfig                          |   24 +-
 arch/arm64/crypto/Makefile                         |   13 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c                |    1 -
 arch/arm64/crypto/aes-cipher-core.S                |  110 +
 arch/arm64/crypto/aes-cipher-glue.c                |   69 +
 arch/arm64/crypto/aes-glue.c                       |  281 +-
 arch/arm64/crypto/aes-modes.S                      |   37 +-
 arch/arm64/crypto/aes-neon.S                       |  235 +-
 arch/arm64/crypto/aes-neonbs-core.S                |  972 ++++
 arch/arm64/crypto/aes-neonbs-glue.c                |  439 ++
 arch/arm64/crypto/chacha20-neon-core.S             |  450 ++
 arch/arm64/crypto/chacha20-neon-glue.c             |  126 +
 arch/arm64/crypto/crc32-arm64.c                    |  290 --
 arch/arm64/crypto/crc32-ce-glue.c                  |   49 +-
 arch/x86/crypto/aesni-intel_asm.S                  |   37 +-
 arch/x86/crypto/aesni-intel_avx-x86_64.S           |   32 +-
 arch/x86/crypto/aesni-intel_glue.c                 |   12 +-
 arch/x86/crypto/camellia-aesni-avx-asm_64.S        |    5 +-
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S       |   12 +-
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S          |   14 +-
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S          |   12 +-
 arch/x86/crypto/chacha20-avx2-x86_64.S             |    9 +-
 arch/x86/crypto/chacha20-ssse3-x86_64.S            |    7 +-
 arch/x86/crypto/chacha20_glue.c                    |   70 +-
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S          |    2 +-
 arch/x86/crypto/crct10dif-pcl-asm_64.S             |   14 +-
 arch/x86/crypto/des3_ede-asm_64.S                  |    2 +-
 arch/x86/crypto/ghash-clmulni-intel_asm.S          |    3 +-
 arch/x86/crypto/poly1305-avx2-x86_64.S             |    6 +-
 arch/x86/crypto/poly1305-sse2-x86_64.S             |    6 +-
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S        |    5 +-
 arch/x86/crypto/serpent-avx2-asm_64.S              |    9 +-
 arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S   |    6 +-
 arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S  |    3 +-
 arch/x86/crypto/sha1-mb/sha1_x8_avx2.S             |   15 +-
 arch/x86/crypto/sha1_ni_asm.S                      |    8 +-
 arch/x86/crypto/sha256-avx-asm.S                   |    9 +-
 arch/x86/crypto/sha256-avx2-asm.S                  |    9 +-
 .../crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S    |    6 +-
 .../crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S   |    3 +-
 arch/x86/crypto/sha256-mb/sha256_x8_avx2.S         |    7 +-
 arch/x86/crypto/sha256-ssse3-asm.S                 |    8 +-
 arch/x86/crypto/sha256_ni_asm.S                    |    4 +-
 arch/x86/crypto/sha512-avx-asm.S                   |    9 +-
 arch/x86/crypto/sha512-avx2-asm.S                  |   10 +-
 arch/x86/crypto/sha512-mb/sha512_mb.c              |   64 +-
 .../crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S    |   10 +-
 .../crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S   |    4 +-
 arch/x86/crypto/sha512-mb/sha512_x4_avx2.S         |    4 +-
 arch/x86/crypto/sha512-ssse3-asm.S                 |    9 +-
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S        |    6 +-
 crypto/Kconfig                                     |   19 +
 crypto/Makefile                                    |    3 +
 crypto/ablkcipher.c                                |    5 +-
 crypto/acompress.c                                 |    3 +-
 crypto/aead.c                                      |    3 +-
 crypto/aes_generic.c                               |   64 +-
 crypto/aes_ti.c                                    |  375 ++
 crypto/ahash.c                                     |    3 +-
 crypto/akcipher.c                                  |    3 +-
 crypto/algapi.c                                    |   68 +-
 crypto/algif_hash.c                                |    2 +-
 crypto/blkcipher.c                                 |    7 +-
 crypto/cbc.c                                       |    3 -
 crypto/ccm.c                                       |  386 +-
 crypto/chacha20_generic.c                          |   73 +-
 crypto/cmac.c                                      |    3 +-
 crypto/ctr.c                                       |    2 +-
 crypto/cts.c                                       |    8 +-
 crypto/kpp.c                                       |    3 +-
 crypto/pcbc.c                                      |    6 +-
 crypto/rng.c                                       |    3 +-
 crypto/scompress.c                                 |    3 +-
 crypto/seqiv.c                                     |    2 -
 crypto/shash.c                                     |    9 +-
 crypto/skcipher.c                                  |   23 +-
 crypto/tcrypt.c                                    |    6 +
 crypto/testmgr.c                                   | 1055 +----
 crypto/testmgr.h                                   |  330 +-
 drivers/char/hw_random/Kconfig                     |    4 +-
 drivers/char/hw_random/cavium-rng-vf.c             |    6 +-
 drivers/char/hw_random/core.c                      |   64 +-
 drivers/char/hw_random/n2-drv.c                    |  204 +-
 drivers/char/hw_random/n2rng.h                     |   51 +-
 drivers/crypto/Kconfig                             |   53 +-
 drivers/crypto/Makefile                            |   17 +-
 drivers/crypto/atmel-aes-regs.h                    |   16 +
 drivers/crypto/atmel-aes.c                         |  455 +-
 drivers/crypto/atmel-authenc.h                     |   64 +
 drivers/crypto/atmel-sha-regs.h                    |   20 +
 drivers/crypto/atmel-sha.c                         | 1481 +++++-
 drivers/crypto/atmel-tdes.c                        |   14 +-
 drivers/crypto/bcm/Makefile                        |   15 +
 drivers/crypto/bcm/cipher.c                        | 4963 ++++++++++++++++++++
 drivers/crypto/bcm/cipher.h                        |  483 ++
 drivers/crypto/bcm/spu.c                           | 1251 +++++
 drivers/crypto/bcm/spu.h                           |  287 ++
 drivers/crypto/bcm/spu2.c                          | 1401 ++++++
 drivers/crypto/bcm/spu2.h                          |  228 +
 drivers/crypto/bcm/spum.h                          |  174 +
 drivers/crypto/bcm/util.c                          |  581 +++
 drivers/crypto/bcm/util.h                          |  116 +
 drivers/crypto/bfin_crc.c                          |    6 +-
 drivers/crypto/bfin_crc.h                          |    1 -
 drivers/crypto/caam/caamalg.c                      |  589 +--
 drivers/crypto/caam/caamhash.c                     |  268 +-
 drivers/crypto/caam/ctrl.c                         |   33 +-
 drivers/crypto/caam/error.c                        |    2 -
 drivers/crypto/caam/jr.c                           |   19 +-
 drivers/crypto/caam/sg_sw_sec4.h                   |   11 -
 drivers/crypto/cavium/cpt/Kconfig                  |   17 +
 drivers/crypto/cavium/cpt/Makefile                 |    3 +
 drivers/crypto/cavium/cpt/cpt_common.h             |  156 +
 drivers/crypto/cavium/cpt/cpt_hw_types.h           |  658 +++
 drivers/crypto/cavium/cpt/cptpf.h                  |   64 +
 drivers/crypto/cavium/cpt/cptpf_main.c             |  670 +++
 drivers/crypto/cavium/cpt/cptpf_mbox.c             |  163 +
 drivers/crypto/cavium/cpt/cptvf.h                  |  132 +
 drivers/crypto/cavium/cpt/cptvf_algs.c             |  444 ++
 drivers/crypto/cavium/cpt/cptvf_algs.h             |  113 +
 drivers/crypto/cavium/cpt/cptvf_main.c             |  863 ++++
 drivers/crypto/cavium/cpt/cptvf_mbox.c             |  211 +
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c       |  593 +++
 drivers/crypto/cavium/cpt/request_manager.h        |  147 +
 drivers/crypto/ccp/ccp-dev-v5.c                    |   15 +-
 drivers/crypto/ccp/ccp-dev.h                       |    1 +
 drivers/crypto/ccp/ccp-ops.c                       |  150 +-
 drivers/crypto/chelsio/chcr_algo.c                 |   49 +-
 drivers/crypto/chelsio/chcr_algo.h                 |    9 +-
 drivers/crypto/chelsio/chcr_core.c                 |   11 +-
 drivers/crypto/chelsio/chcr_core.h                 |    1 +
 drivers/crypto/chelsio/chcr_crypto.h               |    2 +-
 drivers/crypto/img-hash.c                          |    4 +-
 drivers/crypto/mediatek/Makefile                   |    2 +
 drivers/crypto/mediatek/mtk-aes.c                  | 1299 +++++
 drivers/crypto/mediatek/mtk-platform.c             |  604 +++
 drivers/crypto/mediatek/mtk-platform.h             |  231 +
 drivers/crypto/mediatek/mtk-regs.h                 |  194 +
 drivers/crypto/mediatek/mtk-sha.c                  | 1435 ++++++
 drivers/crypto/picoxcell_crypto.c                  |   28 +-
 drivers/crypto/qat/qat_c3xxx/adf_drv.c             |    2 +-
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c           |    2 +-
 drivers/crypto/qat/qat_c62x/adf_drv.c              |    2 +-
 drivers/crypto/qat/qat_c62xvf/adf_drv.c            |    2 +-
 drivers/crypto/qat/qat_common/adf_cfg_common.h     |    1 +
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    4 +-
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |    2 +-
 drivers/crypto/qat/qat_common/adf_init.c           |   28 +-
 drivers/crypto/qat/qat_common/adf_sriov.c          |    4 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |    4 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |    2 +-
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |    2 +-
 drivers/crypto/virtio/Kconfig                      |    1 +
 drivers/crypto/virtio/virtio_crypto_algs.c         |   54 +-
 drivers/crypto/virtio/virtio_crypto_common.h       |   16 +
 drivers/crypto/virtio/virtio_crypto_core.c         |   74 +-
 drivers/crypto/vmx/aes_ctr.c                       |    6 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      |    8 +
 include/crypto/algapi.h                            |   20 +-
 include/crypto/chacha20.h                          |    6 +-
 include/crypto/hash.h                              |   18 +-
 include/crypto/internal/skcipher.h                 |    2 +-
 include/crypto/skcipher.h                          |   34 +
 include/linux/compiler-gcc.h                       |    1 +
 include/linux/miscdevice.h                         |    1 +
 187 files changed, 26983 insertions(+), 9598 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
