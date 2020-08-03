Return-Path: <SRS0=sEgb=BN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE224C433E1
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 04:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 980A820719
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 04:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgHCEkm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Aug 2020 00:40:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50970 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgHCEkl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Aug 2020 00:40:41 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k2SGu-0005Nc-7y; Mon, 03 Aug 2020 14:40:25 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 03 Aug 2020 14:40:24 +1000
Date:   Mon, 3 Aug 2020 14:40:24 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 5.9
Message-ID: <20200803044024.GA6429@gondor.apana.org.au>
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

- Add support for allocating transforms on a specific NUMA Node.
- Introduce the flag CRYPTO_ALG_ALLOCATES_MEMORY for storage users.

Algorithms:

- Drop PMULL based ghash on arm64.
- Fixes for building with clang on x86.
- Add sha256 helper that does the digest in one go.
- Add SP800-56A rev 3 validation checks to dh.

Drivers:

- Permit users to specify NUMA node in hisilicon/zip.
- Add support for i.MX6 in imx-rngc.
- Add sa2ul crypto driver.
- Add BA431 hwrng driver.
- Add Ingenic JZ4780 and X1000 hwrng driver.
- Spread IRQ affinity in inside-secure and marvell/cesa.

There may be a conflict with the tip tree because of the removal
of arch/x86/include/asm/inst.h.  This file was previously only used
by the Crypto API and just as we stopped using it the tip tree
started using it.  So taking the version from the tip tree should
do the trick.

There is also a conflit witht the jc_docs tree due to unrelated
changes to the same file.  The resolution should be straightforward.

The following changes since commit e04ec0de61c1eb9693179093e83ab8ca68a30d08:

  padata: upgrade smp_mb__after_atomic to smp_mb in padata_do_serial (2020-06-18 17:09:54 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to 3cbfe80737c18ac6e635421ab676716a393d3074:

  crypto: sa2ul - Fix inconsistent IS_ERR and PTR_ERR (2020-07-31 18:25:29 +1000)

----------------------------------------------------------------
Alexander A. Klimov (2):
      hwrng: ks-sa - Replace HTTP links with HTTPS ones
      crypto: Replace HTTP links with HTTPS ones

Andrei Botila (1):
      crypto: caam/qi2 - add support for dpseci_reset()

Andrey Smirnov (1):
      crypto: caam - add clock info for VFxxx SoCs

Ard Biesheuvel (20):
      crypto: arm64/ghash - drop PMULL based shash
      crypto: arm64/gcm - disentangle ghash and gcm setkey() routines
      crypto: arm64/gcm - use variably sized key struct
      crypto: arm64/gcm - use inline helper to suppress indirect calls
      crypto: arm/ghash - use variably sized key struct
      crypto: amlogic-gxl - default to build as module
      crypto: amlogic-gxl - permit async skcipher as fallback
      crypto: omap-aes - permit asynchronous skcipher as fallback
      crypto: sun4i - permit asynchronous skcipher as fallback
      crypto: sun8i-ce - permit asynchronous skcipher as fallback
      crypto: sun8i-ss - permit asynchronous skcipher as fallback
      crypto: ccp - permit asynchronous skcipher as fallback
      crypto: chelsio - permit asynchronous skcipher as fallback
      crypto: mxs-dcp - permit asynchronous skcipher as fallback
      crypto: picoxcell - permit asynchronous skcipher as fallback
      crypto: qce - permit asynchronous skcipher as fallback
      crypto: sahara - permit asynchronous skcipher as fallback
      crypto: mediatek - use AES library for GCM key derivation
      crypto: x86/chacha-sse3 - use unaligned loads for state array
      crypto: xts - Replace memcpy() invocation with simple assignment

Arnd Bergmann (1):
      crypto: x86/crc32c - fix building with clang ias

Barry Song (2):
      crypto: api - permit users to specify numa node of acomp hardware
      crypto: hisilicon/zip - permit users to specify NUMA node

Christophe JAILLET (2):
      crypto: chelsio - Avoid some code duplication
      crypto: chelsio - Fix some pr_xxx messages

Colin Ian King (4):
      crypto: caam/qi2 - remove redundant assignment to ret
      crypto: ccp - remove redundant assignment to variable ret
      crypto: img-hash - remove redundant initialization of variable err
      hwrng: core - remove redundant initialization of variable ret

Dan Carpenter (1):
      crypto: hisilicon - allow smaller reads in debugfs

Dan Douglass (1):
      crypto: caam/jr - remove incorrect reference to caam_jr_register()

Daniel Jordan (6):
      padata: remove start function
      padata: remove stop function
      padata: inline single call of pd_setup_cpumasks()
      padata: remove effective cpumasks from the instance
      padata: fold padata_alloc_possible() into padata_alloc()
      padata: remove padata_parallel_queue

Dinghao Liu (1):
      crypto: sun8i-ce - Fix runtime PM imbalance in sun8i_ce_cipher_init

Eric Biggers (14):
      crc-t10dif: use fallback in initial state
      crc-t10dif: clean up some more things
      crypto: sparc - rename sha256 to sha256_alg
      crypto: lib/sha256 - add sha256() function
      efi: use sha256() instead of open coding
      mptcp: use sha256() instead of open coding
      ASoC: cros_ec_codec: use sha256() instead of open coding
      crypto: geniv - remove unneeded arguments from aead_geniv_alloc()
      crypto: seqiv - remove seqiv_create()
      crypto: algapi - use common mechanism for inheriting flags
      crypto: algapi - add NEED_FALLBACK to INHERITED_FLAGS
      crypto: algapi - introduce the flag CRYPTO_ALG_ALLOCATES_MEMORY
      crypto: xts - prefix function and struct names with "xts"
      crypto: lrw - prefix function and struct names with "lrw"

Fenghua Yu (1):
      crypto: hisilicon/qm - Change type of pasid to u32

Franck LENORMAND (1):
      crypto: caam - remove deadcode on 32-bit platforms

Geert Uytterhoeven (1):
      hwrng: ba431 - HW_RANDOM_BA431 should not default to y

Gilad Ben-Yossef (3):
      crypto: ccree - fix resource leak on error path
      crypto: ccree - adapt ccree essiv support to kcapi
      crypto: ccree - remove unused field

Giovanni Cabiddu (6):
      crypto: qat - convert to SPDX License Identifiers
      crypto: qat - remove packed attribute in etr structs
      crypto: qat - allow xts requests not multiple of block
      crypto: qat - validate xts key
      crypto: qat - remove unused field in skcipher ctx
      crypto: qat - fallback for xts with 192 bit keys

Gustavo A. R. Silva (1):
      crypto: sa2ul - Fix inconsistent IS_ERR and PTR_ERR

Herbert Xu (25):
      crypto: algif_aead - Only wake up when ctx->more is zero
      crc-t10dif: Fix potential crypto notify dead-lock
      crypto: caam - Fix argument type in handle_imx6_err005766
      crypto: octeontx - Fix sparse warnings
      crypto: omap-des - Fix sparse/compiler warnings
      crypto: omap-sham - Fix sparse/compiler warnings
      crypto: api - Prune inclusions in crypto.h
      crypto: cpt - Fix sparse warnings
      Merge branch 'ux500'
      hwrng: npcm - Fix W=1 unused variable warning
      hwrng: omap - Fix W=1 unused variable warning
      hwrng: hisi - Fix W=1 unused variable warning
      hwrng: bcm2835 - Fix W=1 unused variable warning
      hwrng: st - Fix W=1 unused variable warning
      hwrng: pic32 - Fix W=1 unused variable warning
      hwrng: octeon - Fix sparse warnings
      hwrng: ba431 - Add dependency on HAS_IOMEM
      crypto: af_alg - Fix regression on empty requests
      crypto: ccp - Fix sparse warnings
      crypto: caam - Remove broken arc4 support
      hwrng: ba431 - Include kernel.h
      crypto: lib/chacha20poly1305 - Add missing function declaration
      crypto: ccp - Silence strncpy warning
      crypto: omap-aes - Fix sparse and compiler warnings
      crypto: x86/curve25519 - Remove unused carry variables

Horia Geantă (8):
      crypto: caam/qi2 - fix return code in ahash_finup_no_ctx()
      dt-bindings: rng: add RNGB compatibles for i.MX6 SoCs
      hwrng: imx-rngc - enable driver for i.MX6
      crypto: caam/qi2 - fix error reporting for caam_hash_alloc
      crypto: caam/qi2 - create ahash shared descriptors only once
      crypto: caam - silence .setkey in case of bad key length
      crypto: caam - add more RNG hw error codes
      crypto: caam/qi2 - add module alias

Hui Tang (2):
      crypto: hisilicon/hpre - HPRE_OVERTIME_THRHLD can be written by debugfs
      crypto: hisilicon/hpre - disable FLR triggered by hardware

Jian Cai (1):
      crypto: aesni - add compatibility with IAS

John Allen (1):
      crypto: ccp - Fix use of merged scatterlists

Kai Ye (2):
      crypto: hisilicon/sec2 - clear SEC debug regs
      crypto:hisilicon/sec2 - update busy processing logic

Keerthy (4):
      dt-bindings: crypto: Add TI SA2UL crypto accelerator documentation
      crypto: sa2ul - Add crypto driver
      crypto: sa2ul - add sha1/sha256/sha512 support
      crypto: sa2ul - Add AEAD algorithm support

Lee Jones (1):
      crypto: ux500/hash - Add namespacing to hash_init()

Longfang Liu (4):
      crypto: hisilicon - update SEC driver module parameter
      crypto: hisilicon/sec2 - update SEC initialization and reset
      crypto: hisilicon/sec2 - update debugfs interface parameters
      crypto: hisilicon/sec2 - fix some coding styles

Marcelo Henrique Cerri (1):
      lib/mpi: Add mpi_sub_ui()

Meng Yu (4):
      crypto: hisilicon/hpre - Init the value of current_q of debugfs
      crypto: hisilicon/hpre - Modify the Macro definition and format
      crypto: hisilicon/hpre - Add a switch in sriov_configure
      crypto: hisilicon/hpre - update debugfs interface parameters

Mikulas Patocka (3):
      crypto: cpt - don't sleep of CRYPTO_TFM_REQ_MAY_SLEEP was not specified
      crypto: hisilicon - don't sleep of CRYPTO_TFM_REQ_MAY_SLEEP was not specified
      crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY

Olivier Sobrie (2):
      dt-bindings: rng: document Silex Insight BA431 hwrng
      hwrng: ba431 - add support for BA431 hwrng

Randy Dunlap (3):
      crypto: hash - drop duplicated word in a comment
      crypto: skcipher - drop duplicated word in kernel-doc
      crypto: testmgr - delete duplicated words

Rikard Falkeborn (4):
      hwrng: bcm2835 - Constify bcm2835_rng_devtype[]
      hwrng: nomadik - Constify nmk_rng_ids[]
      hwrng: virtio - Constify id_table[]
      crypto: virtio - constify features[] and id_table[]

Sedat Dilek (1):
      crypto: aesni - Fix build with LLVM_IAS=1

Sivaprakash Murugesan (3):
      crypto: qce - support zero length test vectors
      crypto: qce - re-initialize context on import
      crypto: qce/sha - Do not modify scatterlist passed along with request

Stephan Müller (4):
      crypto: ecdh - check validity of Z before export
      crypto: dh - check validity of Z before export
      crypto: dh - SP800-56A rev 3 local public key validation
      crypto: ecc - SP800-56A rev 3 local public key validation

Sven Auhagen (2):
      crypto: inside-secure - irq balance
      crypto: marvell/cesa - irq balance

Tero Kristo (1):
      crypto: sa2ul - add device links to child devices

Tom Lendacky (1):
      crypto: ccp - Update CCP driver maintainer information

Tom Rix (1):
      crypto: qat - fix double free in qat_uclo_create_batch_init_list

Uros Bizjak (2):
      crypto: x86 - Remove include/asm/inst.h
      crypto: x86 - Put back integer parts of include/asm/inst.h

Vaibhav Gupta (1):
      crypto: ccp - use generic power management

Wojciech Ziemba (5):
      crypto: qat - replace user types with kernel u types
      crypto: qat - replace user types with kernel ABI __u types
      crypto: qat - update fw init admin msg
      crypto: qat - send admin messages to set of AEs
      crypto: qat - update timeout logic in put admin msg

Zhangfei Gao (1):
      crypto: hisilicon - fix strncpy warning with strscpy

周琰杰 (Zhou Yanjie) (2):
      dt-bindings: RNG: Add Ingenic RNG bindings.
      crypto: ingenic - Add hardware RNG for Ingenic JZ4780 and X1000

 Documentation/core-api/padata.rst                                  |   18 +-
 Documentation/crypto/api-intro.txt                                 |    2 +-
 Documentation/crypto/userspace-if.rst                              |    4 +-
 Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml             |   76 +++++
 Documentation/devicetree/bindings/rng/imx-rng.txt                  |    3 +
 Documentation/devicetree/bindings/rng/ingenic,rng.yaml             |   36 +++
 Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml |   36 +++
 MAINTAINERS                                                        |    9 +
 arch/arm/crypto/crc32-ce-core.S                                    |    2 +-
 arch/arm/crypto/ghash-ce-glue.c                                    |   51 ++-
 arch/arm/crypto/sha1-armv4-large.S                                 |    2 +-
 arch/arm/crypto/sha256-armv4.pl                                    |    2 +-
 arch/arm/crypto/sha256-core.S_shipped                              |    2 +-
 arch/arm/crypto/sha512-armv4.pl                                    |    4 +-
 arch/arm/crypto/sha512-core.S_shipped                              |    4 +-
 arch/arm64/crypto/ghash-ce-glue.c                                  |  257 ++++++---------
 arch/sparc/crypto/sha256_glue.c                                    |   14 +-
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S                            |   15 +-
 arch/x86/crypto/aesni-intel_asm.S                                  |  739 +++++++++++++++++++++---------------------
 arch/x86/crypto/aesni-intel_avx-x86_64.S                           |    1 -
 arch/x86/crypto/chacha-ssse3-x86_64.S                              |   16 +-
 arch/x86/crypto/chacha_glue.c                                      |   17 +-
 arch/x86/crypto/crc32-pclmul_asm.S                                 |   47 ++-
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S                          |    7 +-
 arch/x86/crypto/curve25519-x86_64.c                                |    6 +-
 arch/x86/crypto/ghash-clmulni-intel_asm.S                          |   17 +-
 arch/x86/include/asm/inst.h                                        |  163 ----------
 crypto/Kconfig                                                     |   46 +--
 crypto/acompress.c                                                 |    8 +
 crypto/adiantum.c                                                  |   14 +-
 crypto/af_alg.c                                                    |   11 +-
 crypto/algapi.c                                                    |   21 +-
 crypto/algif_aead.c                                                |    4 +-
 crypto/algif_skcipher.c                                            |    4 +-
 crypto/api.c                                                       |   24 +-
 crypto/authenc.c                                                   |   14 +-
 crypto/authencesn.c                                                |   14 +-
 crypto/blake2b_generic.c                                           |    2 +-
 crypto/camellia_generic.c                                          |    2 +-
 crypto/ccm.c                                                       |   33 +-
 crypto/chacha20poly1305.c                                          |   14 +-
 crypto/cmac.c                                                      |    5 +-
 crypto/cryptd.c                                                    |   59 ++--
 crypto/ctr.c                                                       |   17 +-
 crypto/cts.c                                                       |   13 +-
 crypto/dh.c                                                        |   38 +++
 crypto/ecc.c                                                       |   44 ++-
 crypto/ecc.h                                                       |   14 +
 crypto/echainiv.c                                                  |    2 +-
 crypto/essiv.c                                                     |   11 +-
 crypto/gcm.c                                                       |   40 +--
 crypto/geniv.c                                                     |   19 +-
 crypto/hmac.c                                                      |    5 +-
 crypto/internal.h                                                  |   23 +-
 crypto/jitterentropy.c                                             |    4 +-
 crypto/lrw.c                                                       |  134 ++++----
 crypto/pcrypt.c                                                    |   31 +-
 crypto/rsa-pkcs1pad.c                                              |   13 +-
 crypto/salsa20_generic.c                                           |    4 +-
 crypto/seqiv.c                                                     |   18 +-
 crypto/sha3_generic.c                                              |    2 +-
 crypto/simd.c                                                      |    6 +-
 crypto/skcipher.c                                                  |   13 +-
 crypto/testmgr.h                                                   |   10 +-
 crypto/vmac.c                                                      |    5 +-
 crypto/xcbc.c                                                      |    5 +-
 crypto/xts.c                                                       |  154 +++++----
 drivers/char/hw_random/Kconfig                                     |   27 +-
 drivers/char/hw_random/Makefile                                    |    2 +
 drivers/char/hw_random/ba431-rng.c                                 |  235 ++++++++++++++
 drivers/char/hw_random/bcm2835-rng.c                               |    5 +-
 drivers/char/hw_random/core.c                                      |    2 +-
 drivers/char/hw_random/hisi-rng.c                                  |    2 +-
 drivers/char/hw_random/ingenic-rng.c                               |  154 +++++++++
 drivers/char/hw_random/ks-sa-rng.c                                 |    2 +-
 drivers/char/hw_random/nomadik-rng.c                               |    2 +-
 drivers/char/hw_random/npcm-rng.c                                  |    2 +-
 drivers/char/hw_random/octeon-rng.c                                |    6 +-
 drivers/char/hw_random/omap-rng.c                                  |   11 +-
 drivers/char/hw_random/pic32-rng.c                                 |    2 +-
 drivers/char/hw_random/st-rng.c                                    |    3 +-
 drivers/char/hw_random/virtio-rng.c                                |    2 +-
 drivers/crypto/Kconfig                                             |   19 +-
 drivers/crypto/Makefile                                            |    1 +
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c                |   46 +--
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h                       |    3 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c                |   42 +--
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c                  |   12 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h                       |    8 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c                |   39 +--
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c                  |   12 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h                       |   26 +-
 drivers/crypto/amlogic/Kconfig                                     |    2 +-
 drivers/crypto/amlogic/amlogic-gxl-cipher.c                        |   27 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c                          |    6 +-
 drivers/crypto/amlogic/amlogic-gxl.h                               |    3 +-
 drivers/crypto/axis/artpec6_crypto.c                               |   20 +-
 drivers/crypto/bcm/cipher.c                                        |   72 +++--
 drivers/crypto/caam/caamalg.c                                      |   37 +--
 drivers/crypto/caam/caamalg_qi.c                                   |    8 +-
 drivers/crypto/caam/caamalg_qi2.c                                  |   42 ++-
 drivers/crypto/caam/caamhash.c                                     |    2 +-
 drivers/crypto/caam/compat.h                                       |    1 -
 drivers/crypto/caam/ctrl.c                                         |   12 +-
 drivers/crypto/caam/dpseci.c                                       |   18 ++
 drivers/crypto/caam/dpseci.h                                       |    2 +
 drivers/crypto/caam/dpseci_cmd.h                                   |    1 +
 drivers/crypto/caam/error.c                                        |    3 +
 drivers/crypto/caam/jr.c                                           |    3 +-
 drivers/crypto/caam/regs.h                                         |   11 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c                             |   28 +-
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c                       |   24 +-
 drivers/crypto/cavium/cpt/request_manager.h                        |   26 +-
 drivers/crypto/cavium/nitrox/nitrox_aead.c                         |    4 +-
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c                     |   16 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c                           |    1 +
 drivers/crypto/ccp/ccp-crypto-aes-galois.c                         |    1 +
 drivers/crypto/ccp/ccp-crypto-aes-xts.c                            |   34 +-
 drivers/crypto/ccp/ccp-crypto-aes.c                                |    2 +
 drivers/crypto/ccp/ccp-crypto-des3.c                               |    1 +
 drivers/crypto/ccp/ccp-crypto-sha.c                                |    4 +-
 drivers/crypto/ccp/ccp-crypto.h                                    |    4 +-
 drivers/crypto/ccp/ccp-dev-v5.c                                    |    8 +-
 drivers/crypto/ccp/ccp-dev.c                                       |    4 +-
 drivers/crypto/ccp/ccp-dev.h                                       |   13 +-
 drivers/crypto/ccp/ccp-ops.c                                       |   43 ++-
 drivers/crypto/ccp/sp-dev.c                                        |    6 +-
 drivers/crypto/ccp/sp-dev.h                                        |    6 +-
 drivers/crypto/ccp/sp-pci.c                                        |   17 +-
 drivers/crypto/ccp/sp-platform.c                                   |    2 +-
 drivers/crypto/ccree/cc_cipher.c                                   |  149 ++++++---
 drivers/crypto/chelsio/chcr_algo.c                                 |   87 +++--
 drivers/crypto/chelsio/chcr_crypto.h                               |    3 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c                          |  111 ++++---
 drivers/crypto/hisilicon/qm.c                                      |   43 +--
 drivers/crypto/hisilicon/qm.h                                      |    1 +
 drivers/crypto/hisilicon/sec/sec_algs.c                            |   58 ++--
 drivers/crypto/hisilicon/sec2/sec.h                                |    4 +
 drivers/crypto/hisilicon/sec2/sec_crypto.c                         |   95 ++++--
 drivers/crypto/hisilicon/sec2/sec_main.c                           |  132 ++++----
 drivers/crypto/hisilicon/zip/zip.h                                 |    2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c                          |    6 +-
 drivers/crypto/hisilicon/zip/zip_main.c                            |    5 +-
 drivers/crypto/img-hash.c                                          |    2 +-
 drivers/crypto/inside-secure/safexcel.c                            |   13 +-
 drivers/crypto/inside-secure/safexcel.h                            |    3 +
 drivers/crypto/inside-secure/safexcel_cipher.c                     |   47 +++
 drivers/crypto/inside-secure/safexcel_hash.c                       |   18 ++
 drivers/crypto/ixp4xx_crypto.c                                     |    6 +-
 drivers/crypto/marvell/cesa/cesa.c                                 |   11 +-
 drivers/crypto/marvell/cesa/cesa.h                                 |    1 +
 drivers/crypto/marvell/cesa/cipher.c                               |   18 +-
 drivers/crypto/marvell/cesa/hash.c                                 |    6 +
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c                  |    8 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h                  |    2 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c                   |   51 ++-
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.h                   |    6 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c                 |    9 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h                 |   24 +-
 drivers/crypto/mediatek/mtk-aes.c                                  |   63 +---
 drivers/crypto/mxs-dcp.c                                           |   33 +-
 drivers/crypto/n2_core.c                                           |    3 +-
 drivers/crypto/omap-aes.c                                          |   41 ++-
 drivers/crypto/omap-aes.h                                          |    3 +-
 drivers/crypto/omap-des.c                                          |    6 +-
 drivers/crypto/omap-sham.c                                         |   18 +-
 drivers/crypto/picoxcell_crypto.c                                  |   55 ++--
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c                   |   48 +--
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h                   |   48 +--
 drivers/crypto/qat/qat_c3xxx/adf_drv.c                             |   48 +--
 drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c               |   48 +--
 drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h               |   48 +--
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c                           |   48 +--
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c                     |   48 +--
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h                     |   48 +--
 drivers/crypto/qat/qat_c62x/adf_drv.c                              |   48 +--
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c                 |   48 +--
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h                 |   48 +--
 drivers/crypto/qat/qat_c62xvf/adf_drv.c                            |   48 +--
 drivers/crypto/qat/qat_common/adf_accel_devices.h                  |  102 ++----
 drivers/crypto/qat/qat_common/adf_accel_engine.c                   |   52 +--
 drivers/crypto/qat/qat_common/adf_admin.c                          |  144 ++++-----
 drivers/crypto/qat/qat_common/adf_aer.c                            |   50 +--
 drivers/crypto/qat/qat_common/adf_cfg.c                            |   48 +--
 drivers/crypto/qat/qat_common/adf_cfg.h                            |   48 +--
 drivers/crypto/qat/qat_common/adf_cfg_common.h                     |   72 +----
 drivers/crypto/qat/qat_common/adf_cfg_strings.h                    |   48 +--
 drivers/crypto/qat/qat_common/adf_cfg_user.h                       |   58 +---
 drivers/crypto/qat/qat_common/adf_common_drv.h                     |   60 +---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c                        |   52 +--
 drivers/crypto/qat/qat_common/adf_dev_mgr.c                        |   56 +---
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c                     |   48 +--
 drivers/crypto/qat/qat_common/adf_init.c                           |   48 +--
 drivers/crypto/qat/qat_common/adf_isr.c                            |   48 +--
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c                      |   49 +--
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h                      |   48 +--
 drivers/crypto/qat/qat_common/adf_sriov.c                          |   48 +--
 drivers/crypto/qat/qat_common/adf_transport.c                      |  110 ++-----
 drivers/crypto/qat/qat_common/adf_transport.h                      |   52 +--
 drivers/crypto/qat/qat_common/adf_transport_access_macros.h        |   54 +---
 drivers/crypto/qat/qat_common/adf_transport_debug.c                |   48 +--
 drivers/crypto/qat/qat_common/adf_transport_internal.h             |   75 +----
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c                      |   48 +--
 drivers/crypto/qat/qat_common/adf_vf_isr.c                         |   48 +--
 drivers/crypto/qat/qat_common/icp_qat_fw.h                         |  106 ++----
 drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h              |  145 ++++-----
 drivers/crypto/qat/qat_common/icp_qat_fw_la.h                      |  206 +++++-------
 drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h           |   48 +--
 drivers/crypto/qat/qat_common/icp_qat_fw_pke.h                     |  100 ++----
 drivers/crypto/qat/qat_common/icp_qat_hal.h                        |   48 +--
 drivers/crypto/qat/qat_common/icp_qat_hw.h                         |   64 +---
 drivers/crypto/qat/qat_common/icp_qat_uclo.h                       |   54 +---
 drivers/crypto/qat/qat_common/qat_algs.c                           |  211 +++++++-----
 drivers/crypto/qat/qat_common/qat_asym_algs.c                      |   61 +---
 drivers/crypto/qat/qat_common/qat_crypto.c                         |   48 +--
 drivers/crypto/qat/qat_common/qat_crypto.h                         |   48 +--
 drivers/crypto/qat/qat_common/qat_hal.c                            |   88 ++---
 drivers/crypto/qat/qat_common/qat_uclo.c                           |   77 ++---
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c             |   74 +----
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h             |   48 +--
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c                          |   48 +--
 drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c         |   48 +--
 drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h         |   48 +--
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c                        |   48 +--
 drivers/crypto/qce/cipher.h                                        |    3 +-
 drivers/crypto/qce/common.h                                        |    2 +
 drivers/crypto/qce/sha.c                                           |   36 ++-
 drivers/crypto/qce/skcipher.c                                      |   43 +--
 drivers/crypto/sa2ul.c                                             | 2420 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/sa2ul.h                                             |  403 +++++++++++++++++++++++
 drivers/crypto/sahara.c                                            |   96 +++---
 drivers/crypto/talitos.c                                           |  117 ++++---
 drivers/crypto/ux500/hash/hash_core.c                              |   18 +-
 drivers/crypto/virtio/virtio_crypto_algs.c                         |    3 +-
 drivers/crypto/virtio/virtio_crypto_core.c                         |    4 +-
 drivers/crypto/xilinx/zynqmp-aes-gcm.c                             |    1 +
 drivers/firmware/efi/embedded-firmware.c                           |    9 +-
 include/crypto/acompress.h                                         |   18 ++
 include/crypto/algapi.h                                            |   25 +-
 include/crypto/chacha.h                                            |    4 -
 include/crypto/chacha20poly1305.h                                  |    2 +
 include/crypto/hash.h                                              |    2 +-
 include/crypto/if_alg.h                                            |    4 +-
 include/crypto/internal/geniv.h                                    |    2 +-
 include/crypto/sha.h                                               |    1 +
 include/crypto/skcipher.h                                          |    2 +-
 include/linux/crypto.h                                             |   41 ++-
 include/linux/mpi.h                                                |    3 +
 include/linux/padata.h                                             |   21 +-
 kernel/padata.c                                                    |  177 +++-------
 lib/crc-t10dif.c                                                   |   75 +++--
 lib/crypto/chacha20poly1305.c                                      |    2 -
 lib/crypto/sha256.c                                                |   10 +
 lib/mpi/Makefile                                                   |    1 +
 lib/mpi/mpi-sub-ui.c                                               |   78 +++++
 net/mptcp/crypto.c                                                 |   15 +-
 sound/soc/codecs/cros_ec_codec.c                                   |   27 +-
 257 files changed, 6648 insertions(+), 5497 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
 create mode 100644 Documentation/devicetree/bindings/rng/ingenic,rng.yaml
 create mode 100644 Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml
 create mode 100644 drivers/char/hw_random/ba431-rng.c
 create mode 100644 drivers/char/hw_random/ingenic-rng.c
 create mode 100644 drivers/crypto/sa2ul.c
 create mode 100644 drivers/crypto/sa2ul.h
 create mode 100644 lib/mpi/mpi-sub-ui.c

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
