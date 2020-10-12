Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE272C433E7
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 03:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ECFF20781
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 03:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbgJLDdE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Oct 2020 23:33:04 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55552 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727169AbgJLDdE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Oct 2020 23:33:04 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kRoZt-0000J9-9T; Mon, 12 Oct 2020 14:32:50 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 12 Oct 2020 14:32:49 +1100
Date:   Mon, 12 Oct 2020 14:32:49 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 5.10
Message-ID: <20201012033249.GA25179@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200803044024.GA6429@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

API:

- Allow DRBG testing through user-space af_alg.
- Add tcrypt speed testing support for keyed hashes.
- Add type-safe init/exit hooks for ahash.

Algorithms:

- Mark arc4 as obsolete and pending for future removal.
- Mark anubis, khazad, sead and tea as obsolete.
- Improve boot-time xor benchmark.
- Add OSCCA SM2 asymmetric cipher algorithm and use it for integrity.

Drivers:

- Fixes and enhancement for XTS in caam.
- Add support for XIP8001B hwrng in xiphera-trng.
- Add RNG and hash support in sun8i-ce/sun8i-ss.
- Allow imx-rngc to be used by kernel entropy pool.
- Use crypto engine in omap-sham.
- Add support for Ingenic X1830 with ingenic.

The following changes since commit 9123e3a74ec7b934a4a099e98af6a61c2f80bbf5:

  Linux 5.9-rc1 (2020-08-16 13:04:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to 3093e7c16e12d729c325adb3c53dde7308cefbd8:

  X.509: Fix modular build of public_key_sm2 (2020-10-08 16:39:14 +1100)

----------------------------------------------------------------
Andrei Botila (10):
      crypto: caam/jr - add fallback for XTS with more than 8B IV
      crypto: caam/qi - add fallback for XTS with more than 8B IV
      crypto: caam/qi2 - add fallback for XTS with more than 8B IV
      crypto: caam/jr - add support for more XTS key lengths
      crypto: caam/qi - add support for more XTS key lengths
      crypto: caam/qi2 - add support for more XTS key lengths
      crypto: caam - add xts check for block length equal to zero
      crypto: caam/jr - add support for XTS with 16B IV
      crypto: caam/qi - add support for XTS with 16B IV
      crypto: caam/qi2 - add support for XTS with 16B IV

Andy Shevchenko (1):
      crypto: caam - use traditional error check pattern

Ard Biesheuvel (15):
      staging/rtl8192e: switch to RC4 library interface
      staging/rtl8192u: switch to RC4 library interface
      SUNRPC: remove RC4-HMAC-MD5 support from KerberosV
      crypto: n2 - remove ecb(arc4) support
      crypto: bcm-iproc - remove ecb(arc4) support
      net: wireless: drop bogus CRYPTO_xxx Kconfig selects
      crypto: arc4 - mark ecb(arc4) skcipher as obsolete
      crypto: Kconfig - mark unused ciphers as obsolete
      crypto: arm/sha256-neon - avoid ADRL pseudo instruction
      crypto: arm/sha512-neon - avoid ADRL pseudo instruction
      crypto: arm/aes-neonbs - avoid hacks to prevent Thumb2 mode switches
      crypto: arm/aes-neonbs - avoid loading reorder argument on encryption
      crypto: arm/aes-neonbs - use typed init/exit routines for XTS
      crypto: xor - defer load time benchmark to a later time
      crypto: xor - use ktime for template benchmarking

Atte Tommiska (3):
      dt-bindings: vendor-prefixes: Add Xiphera vendor prefix
      dt-bindings: rng: add bindings for Xiphera XIP8001B hwrng
      hwrng: xiphera-trng: add support for XIP8001B hwrng

Christophe JAILLET (2):
      crypto: hifn_795x - switch from 'pci_' to 'dma_' API
      crypto: ixp4xx - Fix the size used in a 'dma_free_coherent()' call

Colin Ian King (1):
      crypto: chelsio - fix minor indentation issue

Corentin Labbe (18):
      crypto: proc - Removing some useless only space lines
      crypto: sun8i-ss - Add SS_START define
      crypto: sun8i-ss - Add support for the PRNG
      crypto: sun8i-ss - support hash algorithms
      crypto: sun8i-ss - fix a trivial typo
      crypto: sun8i-ss - Add more comment on some structures
      crypto: sun8i-ss - better debug printing
      crypto: sun8i-ce - handle endianness of t_common_ctl
      crypto: sun8i-ce - move iv data to request context
      crypto: sun8i-ce - split into prepare/run/unprepare
      crypto: sun8i-ce - handle different error registers
      crypto: sun8i-ce - rename has_t_dlen_in_bytes to cipher_t_dlen_in_bytes
      crypto: sun8i-ce - support hash algorithms
      crypto: sun8i-ce - Add stat_bytes debugfs
      crypto: sun8i-ce - Add support for the PRNG
      crypto: sun8i-ce - Add support for the TRNG
      crypto: sun8i-ce - fix comparison of integer expressions of different signedness
      crypto: sun8i-ss - fix comparison of integer expressions of different signedness

Dan Carpenter (1):
      crypto: sa2ul - Fix pm_runtime_get_sync() error checking

Daniel Jordan (1):
      padata: add another maintainer and another list

Denis Efremov (5):
      crypto: inside-secure - use kfree_sensitive()
      crypto: amlogic - use kfree_sensitive()
      crypto: sun8i-ce - use kfree_sensitive()
      crypto: sun8i-ss - use kfree_sensitive()
      crypto: sun8i-ss - remove redundant memzero_explicit()

Dominik Przychodni (1):
      crypto: qat - check cipher length for aead AES-CBC-HMAC-SHA

Elena Petrova (1):
      crypto: af_alg - add extra parameters for DRBG interface

Fabio Estevam (1):
      crypto: arm/curve25519 - include <linux/scatterlist.h>

George Acosta (1):
      crypto: cavium/nitrox - add an error message to explain the failure of pci_request_mem_regions

Gilad Ben-Yossef (2):
      crypto: ccree - remove data unit size support
      crypto: ccree - remove bitlocker cipher

Giovanni Cabiddu (5):
      crypto: qat - include domain in top level debugfs path
      crypto: qat - replace device ids defines
      crypto: qat - use PCI_VDEVICE
      crypto: qat - fix function parameters descriptions
      crypto: qat - drop input parameter from adf_enable_aer()

Hao Fang (1):
      crypto: hisilicon/zip - fix the uncleared debug registers

Herbert Xu (32):
      crypto: algapi - Move crypto_yield into internal.h
      crypto: algapi - Remove skbuff.h inclusion
      crypto: algif_skcipher - EBUSY on aio should be an error
      crypto: algif_aead - Do not set MAY_BACKLOG on the async path
      crypto: marvell/cesa - Fix sparse warnings
      crypto: tcrypt - Add support for hash speed testing with keys
      crypto: stm32 - Add missing header inclusions
      crypto: ahash - Add init_tfm/exit_tfm
      crypto: ahash - Add ahash_alg_instance
      crypto: ahash - Remove AHASH_REQUEST_ON_STACK
      crypto: hifn_795x - Remove 64-bit build-time check
      crypto: mediatek - Fix endianness bugs and sparse warnings
      crypto: stm32 - Fix sparse warnings
      crypto: arm/poly1305 - Add prototype for poly1305_blocks_neon
      crypto: arm64/sha - Add declarations for assembly variables
      crypto: arm64/gcm - Fix endianness warnings
      crypto: powerpc/crc-vpmsum_test - Fix sparse endianness warning
      crypto: amlogic - Fix endianness marker
      crypto: arm/aes-neonbs - Use generic cbc encryption path
      crypto: cbc - Remove cbc.h
      crypto: ux500 - Fix sparse endianness warnings
      crypto: sa2ul - Select CRYPTO_AUTHENC
      crypto: sun4i-ss - Fix sparse endianness markers
      crypto: n2 - Fix sparse endianness warning
      crypto: inside-secure - Move priv pointer into safexcel_context
      crypto: inside-secure - Move ipad/opad into safexcel_context
      crypto: inside-secure - Reuse code in safexcel_hmac_alg_setkey
      crypto: lib/chacha20poly1305 - Set SG_MITER_ATOMIC unconditionally
      crypto: x86/poly1305 - Remove assignments with no effect
      lib/mpi: Fix unused variable warnings
      crypto: bcm - Verify GCM/CCM key length in setkey
      X.509: Fix modular build of public_key_sm2

Horia Geantă (1):
      crypto: caam - Move debugfs fops into standalone file

Hui Tang (1):
      crypto: hisilicon/qm - fix judgement of queue is full

Ira Weiny (2):
      crypto: ux500 - Fix kmap() bug
      crypto: hash - Remove unused async iterators

Jorge Ramirez-Ortiz (2):
      hwrng: optee - handle unlimited data rates
      hwrng: optee - fix wait use case

Julia Lawall (5):
      hwrng: stm32 - use semicolons rather than commas to separate statements
      hwrng: iproc-rng200 - use semicolons rather than commas to separate statements
      hwrng: mxc-rnga - use semicolons rather than commas to separate statements
      crypto: drivers - use semicolons rather than commas to separate statements
      crypto: atmel-tdes - use semicolons rather than commas to separate statements

Krzysztof Kozlowski (9):
      hwrng: cctrn - Simplify with dev_err_probe()
      crypto: sa2ul - Simplify with dev_err_probe()
      crypto: ccree - Simplify with dev_err_probe()
      crypto: s5p-sss - Add and fix kerneldoc
      crypto: s5p-sss - Pass error from clk_get and reduce verbosity on deferral
      crypto: caam - Fix kerneldoc
      crypto: caam - Simplify with dev_err_probe()
      crypto: stm32-hash - Simplify with dev_err_probe()
      crypto: sun8i - Simplify with dev_err_probe()

Liu Shixin (3):
      crypto: atmel-aes - convert to use be32_add_cpu()
      crypto: qat - convert to use DEFINE_SEQ_ATTRIBUTE macro
      crypto: cpt - simplify the return expression of cav_register_algs

Longfang Liu (5):
      crypto: hisilicon - update mininum queue
      crypto: hisilicon - update HPRE module parameter description
      crypto: hisilicon - update SEC module parameter description
      crypto: hisilicon - update ZIP module parameter description
      crypto: hisilicon - fixed memory allocation error

Madhuparna Bhowmik (1):
      crypto: picoxcell - Fix potential race condition bug

Marco Felsch (1):
      hwrng: imx-rngc - add quality to use it as kernel entropy pool

Meng Yu (3):
      crypto: hisilicon/hpre - remove useless code
      crypto: hisilicon/hpre - adjust some coding style
      crypto: hisilicon/hpre - fix a bug in dh algorithm

Nathan Chancellor (1):
      crypto: xor - Remove unused variable count in do_xor_speed

Nicolas Toromanoff (1):
      crypto: stm32/crc32 - Avoid lock if hardware is already used

Pascal van Leeuwen (2):
      crypto: inside-secure - Prevent missing of processing errors
      crypto: inside-secure - Add support for EIP197 with output classifier

Pavel Machek (1):
      crypto: ccp - fix error handling

Peter Ujfalusi (1):
      crypto: sa2ul - Fix DMA mapping API usage

Qinglang Miao (8):
      crypto: qat - remove unnecessary mutex_init()
      crypto: allwinner - Convert to DEFINE_SHOW_ATTRIBUTE
      crypto: amlogic - Convert to DEFINE_SHOW_ATTRIBUTE
      crypto: caam - Convert to DEFINE_SHOW_ATTRIBUTE
      crypto: cavium/zip - Convert to DEFINE_SHOW_ATTRIBUTE
      crypto: hisilicon/qm - Convert to DEFINE_SHOW_ATTRIBUTE
      crypto: marvell/octeontx - simplify the return expression of create_sysfs_eng_grps_info()
      crypto: mediatek - simplify the return expression of mtk_dfe_dse_reset()

Ram Muthiah (1):
      crypto: virtio - don't use 'default m'

Randy Dunlap (5):
      crypto: algif_aead - delete duplicated word
      crypto: crc32c_generic - delete and fix duplicated words
      crypto: crct10dif_generic - fix duplicated words
      crypto: engine - delete duplicated word
      crypto: tcrypt - delete duplicated words in messages

Shukun Tan (4):
      crypto: hisilicon/qm - clear used reference count when start qp
      crypto: hisilicon/qm - fix event queue depth to 2048
      crypto: hisilicon/qm - fix VF not available after PF FLR
      crypto: hisilicon/zip - modify debugfs interface parameters

Sihang Chen (2):
      crypto: hisilicon/qm - fix wrong release after using strsep
      crypto: hisilicon/zip - fix the uninitalized 'curr_qm_qp_num'

Tero Kristo (3):
      crypto: sa2ul - fix compiler warning produced by clang
      crypto: omap-sham - convert to use crypto engine
      crypto: omap-sham - fix digcnt register handling with export/import

Tianjia Zhang (12):
      crypto: mediatek - Fix wrong return value in mtk_desc_ring_alloc()
      crypto: sm3 - export crypto_sm3_final function
      lib/mpi: Extend the MPI library
      lib/mpi: Introduce ec implementation to MPI library
      crypto: sm2 - introduce OSCCA SM2 asymmetric cipher algorithm
      crypto: testmgr - support test with different ciphertext per encryption
      crypto: testmgr - Fix potential memory leak in test_akcipher_one()
      crypto: sm2 - add SM2 test vectors to testmgr
      X.509: support OSCCA certificate parse
      X.509: support OSCCA SM2-with-SM3 certificate verification
      integrity: Asymmetric digsig supports SM2-with-SM3 algorithm
      X.509: fix error return value on the failed path

Tom Rix (1):
      hwrng: intel - cleanup initialization

Tomer Maimon (1):
      hwrng: npcm - modify readl to readb

Uros Bizjak (3):
      crypto: x86/crc32c-intel - Use CRC32 mnemonic
      crypto: curve25519-x86_64 - Use XORL r32,32
      crypto: poly1305-x86_64 - Use XORL r32,32

Weili Qian (2):
      crypto: hisilicon/qm - fix the call trace when unbind device
      crypto: hisilicon/qm - remove the update of flags

Xiaoliang Pang (1):
      cypto: mediatek - fix leaks in mtk_desc_ring_alloc

Xu Wang (1):
      crypto: s5p-sss - remove redundant null check

Yang Shen (15):
      crypto: hisilicon/qm - fix print frequence in hisi_qp_send
      crypto: hisilicon/qm - fix no stop reason when use 'hisi_qm_stop'
      crypto: hisilicon/qm - register callback function to 'pci_driver.shutdown'
      crypto: hisilicon/qm - fix the process of register algorithms to crypto
      crypto: hisilicon/zip - remove some useless parameters
      crypto: hisilicon/zip - unify naming style for functions and macros
      crypto: hisilicon/zip - replace 'sprintf' with 'scnprintf'
      crypto: hisilicon/zip - use a enum parameter instead of some macros
      crypto: hisilicon/zip - add print for error branch
      crypto: hisilicon/zip - fix static check warning
      crypto: hisilicon/zip - move some private macros from 'zip.h' to 'zip_crypto.c'
      crypto: hisilicon/zip - supplement some comments
      crypto: hisilicon/zip - fix some coding styles
      crypto: hisilicon/qm - fix wrong return type of 'pci_get_drvdata'
      crypto: hisilicon/zip - fix the return value when device is busy

YueHaibing (1):
      crypto: sa2ul - Fix pointer-to-int-cast warning

Zhang Qilong (1):
      crypto: marvell/cesa - use devm_platform_ioremap_resource_byname

Zhou Wang (1):
      crypto: hisilicon/zip - fix zero length input in GZIP decompress

dinghao.liu@zju.edu.cn (1):
      crypto: ccree - fix runtime PM imbalance on error

周琰杰 (Zhou Yanjie) (2):
      dt-bindings: RNG: Add Ingenic TRNG bindings.
      hwrng: ingenic - Add hardware TRNG for Ingenic X1830

 Documentation/crypto/userspace-if.rst              |   20 +-
 .../devicetree/bindings/rng/ingenic,trng.yaml      |   43 +
 .../bindings/rng/xiphera,xip8001b-trng.yaml        |   33 +
 .../devicetree/bindings/vendor-prefixes.yaml       |    2 +
 MAINTAINERS                                        |    2 +
 arch/arm/crypto/aes-neonbs-core.S                  |   54 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |   58 +-
 arch/arm/crypto/curve25519-glue.c                  |    1 +
 arch/arm/crypto/poly1305-glue.c                    |    1 +
 arch/arm/crypto/sha256-armv4.pl                    |    4 +-
 arch/arm/crypto/sha256-core.S_shipped              |    4 +-
 arch/arm/crypto/sha512-armv4.pl                    |    4 +-
 arch/arm/crypto/sha512-core.S_shipped              |    4 +-
 arch/arm64/crypto/ghash-ce-glue.c                  |    4 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |    3 +
 arch/arm64/crypto/sha2-ce-glue.c                   |    3 +
 arch/powerpc/crypto/crc-vpmsum_test.c              |    6 +-
 arch/x86/crypto/blake2s-glue.c                     |    1 +
 arch/x86/crypto/chacha_glue.c                      |    1 +
 arch/x86/crypto/crc32c-intel_glue.c                |   18 +-
 arch/x86/crypto/curve25519-x86_64.c                |   69 +-
 arch/x86/crypto/nhpoly1305-avx2-glue.c             |    1 +
 arch/x86/crypto/nhpoly1305-sse2-glue.c             |    1 +
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl      |    8 +-
 arch/x86/crypto/poly1305_glue.c                    |    4 +-
 crypto/Kconfig                                     |   40 +
 crypto/Makefile                                    |    8 +
 crypto/af_alg.c                                    |   14 +-
 crypto/ahash.c                                     |   54 +-
 crypto/algif_aead.c                                |    9 +-
 crypto/algif_rng.c                                 |  175 ++-
 crypto/algif_skcipher.c                            |    2 +-
 crypto/arc4.c                                      |   11 +
 crypto/asymmetric_keys/public_key.c                |   63 +
 crypto/asymmetric_keys/x509_cert_parser.c          |   27 +-
 crypto/asymmetric_keys/x509_public_key.c           |    3 +
 crypto/cbc.c                                       |  144 +-
 crypto/crc32c_generic.c                            |    4 +-
 crypto/crct10dif_generic.c                         |    2 +-
 crypto/crypto_engine.c                             |    3 +-
 crypto/ecrdsa.c                                    |    1 +
 crypto/internal.h                                  |   16 +-
 crypto/jitterentropy-kcapi.c                       |    2 +-
 crypto/proc.c                                      |    4 +-
 crypto/rsa-pkcs1pad.c                              |    1 +
 crypto/sm2.c                                       |  481 +++++++
 crypto/sm2signature.asn1                           |    4 +
 crypto/sm3_generic.c                               |    7 +-
 crypto/tcrypt.c                                    |   18 +-
 crypto/tcrypt.h                                    |   29 -
 crypto/testmgr.c                                   |   25 +-
 crypto/testmgr.h                                   |   59 +
 crypto/xor.c                                       |   69 +-
 drivers/char/hw_random/Kconfig                     |   24 +
 drivers/char/hw_random/Makefile                    |    2 +
 drivers/char/hw_random/cctrng.c                    |    9 +-
 drivers/char/hw_random/imx-rngc.c                  |    1 +
 drivers/char/hw_random/ingenic-trng.c              |  161 +++
 drivers/char/hw_random/intel-rng.c                 |    2 +-
 drivers/char/hw_random/iproc-rng200.c              |    8 +-
 drivers/char/hw_random/mxc-rnga.c                  |    6 +-
 drivers/char/hw_random/npcm-rng.c                  |   14 +-
 drivers/char/hw_random/optee-rng.c                 |    6 +-
 drivers/char/hw_random/stm32-rng.c                 |    8 +-
 drivers/char/hw_random/xiphera-trng.c              |  150 ++
 drivers/crypto/Kconfig                             |    1 +
 drivers/crypto/allwinner/Kconfig                   |   43 +
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c  |   17 +-
 drivers/crypto/allwinner/sun8i-ce/Makefile         |    3 +
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |  131 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |  405 +++++-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c  |  413 ++++++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c  |  164 +++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c  |  127 ++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |  139 +-
 drivers/crypto/allwinner/sun8i-ss/Makefile         |    2 +
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |   16 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |  229 ++-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |  444 ++++++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c  |  173 +++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |   89 +-
 drivers/crypto/amcc/crypto4xx_alg.c                |    2 +-
 drivers/crypto/amcc/crypto4xx_core.h               |    1 +
 drivers/crypto/amlogic/amlogic-gxl-cipher.c        |   12 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c          |   16 +-
 drivers/crypto/atmel-aes.c                         |    2 +-
 drivers/crypto/atmel-tdes.c                        |    2 +-
 drivers/crypto/bcm/cipher.c                        |  111 +-
 drivers/crypto/bcm/cipher.h                        |    1 -
 drivers/crypto/bcm/spu.c                           |   23 +-
 drivers/crypto/bcm/spu.h                           |    1 -
 drivers/crypto/bcm/spu2.c                          |   12 +-
 drivers/crypto/bcm/spu2.h                          |    1 -
 drivers/crypto/caam/Kconfig                        |    3 +
 drivers/crypto/caam/Makefile                       |    2 +
 drivers/crypto/caam/caamalg.c                      |   94 +-
 drivers/crypto/caam/caamalg_desc.c                 |   28 +-
 drivers/crypto/caam/caamalg_qi.c                   |   94 +-
 drivers/crypto/caam/caamalg_qi2.c                  |  118 +-
 drivers/crypto/caam/caamalg_qi2.h                  |    2 +
 drivers/crypto/caam/ctrl.c                         |   88 +-
 drivers/crypto/caam/debugfs.c                      |   96 ++
 drivers/crypto/caam/debugfs.h                      |   26 +
 drivers/crypto/caam/dpseci-debugfs.c               |   23 +-
 drivers/crypto/caam/intern.h                       |   17 -
 drivers/crypto/caam/jr.c                           |   10 +-
 drivers/crypto/caam/qi.c                           |   20 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c             |    8 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c         |    1 +
 drivers/crypto/cavium/zip/zip_main.c               |   44 +-
 drivers/crypto/ccp/ccp-ops.c                       |    3 +-
 drivers/crypto/ccree/cc_cipher.c                   |  282 +---
 drivers/crypto/ccree/cc_crypto_ctx.h               |    1 -
 drivers/crypto/ccree/cc_driver.c                   |    7 +-
 drivers/crypto/ccree/cc_driver.h                   |    1 -
 drivers/crypto/ccree/cc_pm.c                       |    6 +-
 drivers/crypto/chelsio/chcr_core.c                 |    2 +-
 drivers/crypto/hifn_795x.c                         |   28 +-
 drivers/crypto/hisilicon/hpre/hpre.h               |    1 -
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |   59 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   33 +-
 drivers/crypto/hisilicon/qm.c                      |  237 ++-
 drivers/crypto/hisilicon/qm.h                      |   31 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |   51 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |   39 +-
 drivers/crypto/hisilicon/zip/zip.h                 |   15 -
 drivers/crypto/hisilicon/zip/zip_crypto.c          |  140 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |  195 +--
 drivers/crypto/img-hash.c                          |    1 +
 drivers/crypto/inside-secure/safexcel.c            |   44 +-
 drivers/crypto/inside-secure/safexcel.h            |   28 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |   90 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |  153 +-
 drivers/crypto/inside-secure/safexcel_ring.c       |    9 +-
 drivers/crypto/ixp4xx_crypto.c                     |    2 +-
 drivers/crypto/marvell/cesa/cesa.c                 |    4 +-
 drivers/crypto/marvell/cesa/cesa.h                 |   20 +-
 drivers/crypto/marvell/cesa/cipher.c               |    5 +-
 drivers/crypto/marvell/cesa/hash.c                 |   24 +-
 drivers/crypto/marvell/cesa/tdma.c                 |   16 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  |    8 +-
 drivers/crypto/mediatek/mtk-aes.c                  |   57 +-
 drivers/crypto/mediatek/mtk-platform.c             |   16 +-
 drivers/crypto/mediatek/mtk-sha.c                  |    2 +-
 drivers/crypto/n2_core.c                           |   60 +-
 drivers/crypto/omap-sham.c                         |  189 ++-
 drivers/crypto/padlock-aes.c                       |    1 +
 drivers/crypto/picoxcell_crypto.c                  |    9 +-
 drivers/crypto/qat/qat_c3xxx/adf_drv.c             |   19 +-
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c           |   17 +-
 drivers/crypto/qat/qat_c62x/adf_drv.c              |   19 +-
 drivers/crypto/qat/qat_c62xvf/adf_drv.c            |   17 +-
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    6 -
 drivers/crypto/qat/qat_common/adf_aer.c            |    6 +-
 drivers/crypto/qat/qat_common/adf_cfg.c            |   19 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    2 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |    2 -
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |    2 +-
 drivers/crypto/qat/qat_common/adf_sriov.c          |    6 +-
 .../crypto/qat/qat_common/adf_transport_debug.c    |   42 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |   10 +-
 drivers/crypto/qat/qat_common/qat_hal.c            |    7 +-
 drivers/crypto/qat/qat_common/qat_uclo.c           |    9 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |   19 +-
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |   17 +-
 drivers/crypto/qce/core.c                          |    1 +
 drivers/crypto/qce/sha.c                           |    1 +
 drivers/crypto/qce/skcipher.c                      |    1 +
 drivers/crypto/qcom-rng.c                          |    1 +
 drivers/crypto/rockchip/rk3288_crypto.c            |    1 +
 drivers/crypto/rockchip/rk3288_crypto.h            |    1 +
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |    1 +
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c   |    1 +
 drivers/crypto/s5p-sss.c                           |   28 +-
 drivers/crypto/sa2ul.c                             |  235 +--
 drivers/crypto/sahara.c                            |    2 +-
 drivers/crypto/stm32/Kconfig                       |    1 +
 drivers/crypto/stm32/stm32-crc32.c                 |   22 +-
 drivers/crypto/stm32/stm32-cryp.c                  |   47 +-
 drivers/crypto/stm32/stm32-hash.c                  |   16 +-
 drivers/crypto/talitos.c                           |    8 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |   28 +-
 drivers/crypto/ux500/hash/hash_core.c              |   31 +-
 drivers/crypto/virtio/Kconfig                      |    1 -
 drivers/crypto/xilinx/zynqmp-aes-gcm.c             |    1 +
 drivers/net/wireless/intel/ipw2x00/Kconfig         |    4 -
 drivers/net/wireless/intersil/hostap/Kconfig       |    4 -
 drivers/staging/rtl8192e/Kconfig                   |    4 +-
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c       |   70 +-
 drivers/staging/rtl8192e/rtllib_crypt_wep.c        |   72 +-
 drivers/staging/rtl8192u/Kconfig                   |    1 +
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      |   81 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c       |   64 +-
 include/crypto/algapi.h                            |    8 +-
 include/crypto/cbc.h                               |  141 --
 include/crypto/hash.h                              |   18 +-
 include/crypto/if_alg.h                            |    1 +
 include/crypto/internal/hash.h                     |   19 +-
 include/crypto/public_key.h                        |    3 +
 include/crypto/sm2.h                               |   25 +
 include/crypto/sm3.h                               |    2 +
 include/linux/mpi.h                                |  192 +++
 include/linux/oid_registry.h                       |    6 +
 include/linux/sunrpc/gss_krb5.h                    |   11 -
 include/linux/sunrpc/gss_krb5_enctypes.h           |    9 +-
 include/uapi/linux/if_alg.h                        |    1 +
 lib/crypto/chacha20poly1305.c                      |    4 +-
 lib/mpi/Makefile                                   |    6 +
 lib/mpi/ec.c                                       | 1509 ++++++++++++++++++++
 lib/mpi/mpi-add.c                                  |  155 ++
 lib/mpi/mpi-bit.c                                  |  251 ++++
 lib/mpi/mpi-cmp.c                                  |   46 +-
 lib/mpi/mpi-div.c                                  |  234 +++
 lib/mpi/mpi-internal.h                             |   53 +
 lib/mpi/mpi-inv.c                                  |  143 ++
 lib/mpi/mpi-mod.c                                  |  155 ++
 lib/mpi/mpi-mul.c                                  |   91 ++
 lib/mpi/mpicoder.c                                 |  336 +++++
 lib/mpi/mpih-div.c                                 |  294 ++++
 lib/mpi/mpih-mul.c                                 |   25 +
 lib/mpi/mpiutil.c                                  |  204 +++
 net/sunrpc/Kconfig                                 |    1 -
 net/sunrpc/auth_gss/gss_krb5_crypto.c              |  276 ----
 net/sunrpc/auth_gss/gss_krb5_mech.c                |   95 --
 net/sunrpc/auth_gss/gss_krb5_seal.c                |    1 -
 net/sunrpc/auth_gss/gss_krb5_seqnum.c              |   87 --
 net/sunrpc/auth_gss/gss_krb5_unseal.c              |    1 -
 net/sunrpc/auth_gss/gss_krb5_wrap.c                |   65 +-
 security/integrity/digsig_asymmetric.c             |   14 +-
 229 files changed, 9465 insertions(+), 3102 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/ingenic,trng.yaml
 create mode 100644 Documentation/devicetree/bindings/rng/xiphera,xip8001b-trng.yaml
 create mode 100644 crypto/sm2.c
 create mode 100644 crypto/sm2signature.asn1
 create mode 100644 drivers/char/hw_random/ingenic-trng.c
 create mode 100644 drivers/char/hw_random/xiphera-trng.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
 create mode 100644 drivers/crypto/caam/debugfs.c
 create mode 100644 drivers/crypto/caam/debugfs.h
 delete mode 100644 include/crypto/cbc.h
 create mode 100644 include/crypto/sm2.h
 create mode 100644 lib/mpi/ec.c
 create mode 100644 lib/mpi/mpi-add.c
 create mode 100644 lib/mpi/mpi-div.c
 create mode 100644 lib/mpi/mpi-inv.c
 create mode 100644 lib/mpi/mpi-mod.c
 create mode 100644 lib/mpi/mpi-mul.c

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
