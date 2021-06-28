Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB59C2B9F4
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jun 2021 11:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B745361C6A
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jun 2021 11:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhF1LDX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Jun 2021 07:03:23 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51022 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232617AbhF1LDW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Jun 2021 07:03:22 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lxp0X-0007dg-Ny; Mon, 28 Jun 2021 19:00:53 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lxp0V-0003CA-1V; Mon, 28 Jun 2021 19:00:51 +0800
Date:   Mon, 28 Jun 2021 19:00:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 5.14
Message-ID: <20210628110050.GA12162@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20201012033249.GA25179@gondor.apana.org.au>
 <20201214055515.GA14196@gondor.apana.org.au>
 <20210215024721.GA20593@gondor.apana.org.au>
 <20210426123200.kgbyk6ayey4l4lrw@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210426123200.kgbyk6ayey4l4lrw@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

Algorithms:

- Fix rmmod crash with x86/curve25519.
- Add ECDH NIST P384.
- Generate assembly files at build-time with perl scripts on arm.
- Switch to HMAC SHA512 DRBG as default DRBG.

Drivers:

- Add sl3516 crypto engine.
- Add ECDH NIST P384 support in hisilicon/hpre.
- Add {ofb,cfb,ctr} over {aes,sm4} in hisilicon/sec.
- Add {ccm,gcm} over {aes,sm4} in hisilicon/sec.
- Enable omap hwrng driver for TI K3 family.
- Add support for AEAD algorithms in qce.

Please note that there is a merge conflict with cavium/nitrox,
the fix is to simply use the version from the crypto tree.

The following changes since commit 6efb943b8616ec53a5e444193dccf1af9ad627b5:

  Linux 5.13-rc1 (2021-05-09 14:17:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

for you to fetch changes up to 9f38b678ffc4e2ccf167a1131c0403dc4f5e1bb7:

  crypto: sl3516 - depends on HAS_IOMEM (2021-06-24 14:57:28 +0800)

----------------------------------------------------------------
Ard Biesheuvel (2):
      crypto: tcrypt - enable tests for xxhash and blake2
      crypto: shash - avoid comparing pointers to exported functions under CFI

Arnd Bergmann (1):
      crypto: ixp4xx - convert to platform driver

Baokun Li (1):
      crypto: ccp - Use list_move_tail instead of list_del/list_add_tail in ccp-dmaengine.c

Bixuan Cui (1):
      crypto: nx - add missing MODULE_DEVICE_TABLE

Christophe JAILLET (3):
      crypto: cpt - Use 'hlist_for_each_entry' to simplify code
      crypto: ccp - Fix a resource leak in an error handling path
      crypto: cavium/nitrox - Fix an error rhandling path in 'nitrox_probe()'

Colin Ian King (2):
      hwrng: amd - remove redundant initialization of variable err
      crypto: hisilicon/sec - Fix spelling mistake "fallbcak" -> "fallback"

Corentin Labbe (15):
      crypto: ixp4xx - dma_unmap the correct address
      crypto: ixp4xx - update IV after requests
      crypto: ixp4xx - fallback when having more than one SG
      crypto: ixp4xx - convert unsigned to unsigned int
      crypto: ixp4xx - convert all printk to dev_xxx
      crypto: ixp4xx - whitespace fixes
      crypto: ixp4xx - Do not initialize static to NULL
      crypto: ixp4xx - remove brackets from single statement
      crypto: ixp4xx - Correct functions alignment
      MAINTAINERS: add ixp4xx_crypto to the right arch list
      MAINTAINERS: add myself as maintainer of ixp4xx_crypto
      dt-bindings: crypto: Add documentation for sl3516-ce
      crypto: sl3516 - Add sl3516 crypto engine
      MAINTAINERS: add gemini crypto sl3516-ce
      crypto: sl3516 - depends on HAS_IOMEM

Hangbin Liu (1):
      crypto: x86/curve25519 - fix cpu feature checking logic in mod_exit

Herbert Xu (4):
      crypto: sa2ul - Remove unused auth_len variable
      crypto: api - Move crypto attr definitions out of crypto.h
      crypto: nx - Fix RCU warning in nx842_OF_upd_status
      crypto: nx - Fix numerous sparse byte-order warnings

Hongbo Li (1):
      crypto: sm2 - fix a memory leak in sm2

Horia Geantă (1):
      MAINTAINERS: update caam crypto driver maintainers list

Hui Tang (20):
      crypto: testmgr - fix initialization of 'secret_size'
      crypto: ecdh - extend 'cra_driver_name' with curve name
      crypto: hisilicon/hpre - extend 'cra_driver_name' with curve name
      crypto: hisilicon/hpre - fix unmapping invalid dma address
      crypto: hisilicon/hpre - the macro 'HPRE_ADDR' expands
      crypto: hisilicon/hpre - init a structure member each line
      crypto: hisilicon/hpre - replace macro with inline function
      crypto: hisilicon/hpre - remove the macro of 'HPRE_DEV'
      crypto: hisilicon/hpre - delete rudundant initialization
      crypto: hisilicon/hpre - use 'GENMASK' to generate mask value
      crypto: hisilicon/hpre - delete rudundant macro definition
      crypto: hisilicon/hpre - add 'default' for switch statement
      crypto: khazad,wp512 - remove leading spaces before tabs
      crypto: ecdh - fix ecdh-nist-p192's entry in testmgr
      crypto: ecdh - fix 'ecdh_init'
      crypto: ecdh - register NIST P384 tfm
      crypto: ecdh - add test suite for NIST P384
      crypto: hisilicon/hpre - fix ecdh self test issue
      crypto: hisilicon/hpre - add check before gx modulo p
      crypto: hisilicon/hpre - register ecdh NIST P384

Jack Xu (5):
      crypto: qat - return error when failing to map FW
      crypto: qat - check MMP size before writing to the SRAM
      crypto: qat - report an error if MMP file size is too large
      crypto: qat - check return code of qat_hal_rd_rel_reg()
      crypto: qat - remove unused macro in FW loader

Jiapeng Chong (1):
      crypto: qce - Fix inconsistent indenting

Joerg Roedel (1):
      crypto: ccp - Annotate SEV Firmware file names

Juerg Haefliger (1):
      hwrng: Kconfig - Remove leading spaces

Kai Ye (19):
      crypto: hisilicon/qm - add dfx log if not use hardware crypto algs
      crypto: hisilicon/qm - fix the process of VF's list adding
      crypto: hisilicon/sec - add new type of SQE
      crypto: hisilicon/sec - driver adapt to new SQE
      crypto: hisilicon/sec - add new skcipher mode for SEC
      crypto: hisilicon/sec - add fallback tfm supporting for XTS mode
      crypto: hisilicon/sec - fixup 3des minimum key size declaration
      crypto: hisilicon/sec - add new algorithm mode for AEAD
      crypto: hisilicon/sec - add fallback tfm supporting for aeads
      crypto: hisilicon/sec - add hardware integrity check value process
      crypto: hisilicon/sec - modify the SEC request structure
      crypto: hisilicon/qm - supports writing QoS int the host
      crypto: hisilicon/qm - add the "alg_qos" file node
      crypto: hisilicon/qm - merges the work initialization process into a single function
      crypto: hisilicon/qm - add pf ping single vf function
      crypto: hisilicon/qm - supports to inquiry each function's QoS
      crypto: hisilicon/sec - adds the max shaper type rate
      crypto: hisilicon/hpre - adds the max shaper type rate
      crypto: hisilicon/zip - adds the max shaper type rate

Kees Cook (1):
      crypto: nx - Fix memcpy() over-reading in nonce

Lee Jones (3):
      crypto: cavium: Fix a bunch of kernel-doc related issues
      crypto: nx: nx-aes-gcm: Kernel-doc formatting should not be used for headers
      crypto: ccp: ccp-dev: Fix a little doc-rot

Linus Walleij (2):
      crypto: ixp4xx - Add DT bindings
      crypto: ixp4xx - Add device tree support

Liu Shixin (1):
      crypto: api - remove CRYPTOA_U32 and related functions

Longfang Liu (1):
      crypto: hisilicon/qm - support address prefetching

Masahiro Yamada (4):
      crypto: arm - generate *.S by Perl at build time instead of shipping them
      crypto: arm - use a pattern rule for generating *.S files
      crypto: arm64 - generate *.S by Perl at build time instead of shipping them
      crypto: arm64 - use a pattern rule for generating *.S files

Shaokun Zhang (2):
      hwrng: core - remove redundant initialization of variable err
      crypto: nx - Fix typo in comment

Srujana Challa (4):
      crypto: octeontx2 - Add mailbox support for CN10K
      crypto: octeontx2 - add support to map LMTST region for CN10K
      crypto: octeontx2 - add support for CPT operations on CN10K
      crypto: octeontx2 - enable and handle ME interrupts

Stephan Müller (1):
      crypto: DRBG - switch to HMAC SHA512 DRBG as default DRBG

Suman Anna (6):
      hwrng: omap - Enable driver for TI K3 family
      crypto: sa2ul - Fix leaks on failure paths with sa_dma_init()
      crypto: sa2ul - Fix pm_runtime enable in sa_ul_probe()
      crypto: sa2ul - Use of_device_get_match_data() helper
      crypto: sa2ul - Use devm_platform_ioremap_resource()
      crypto: sa2ul - Remove child devices in remove

Thara Gopinath (9):
      crypto: qce - Add MAC failed error checking
      crypto: qce - Make result dump optional
      crypto: qce - Add mode for rfc4309
      crypto: qce - Add support for AEAD algorithms
      crypto: qce - Clean up qce_auth_cfg
      crypto: qce - Add support for AEAD algorithms
      crypto: qce - Schedule fallback aead algorithm
      crypto: qce: skcipher: Fix incorrect sg count for dma transfers
      MAINTAINERS: Add maintainer for Qualcomm crypto drivers

Tian Tao (3):
      hwrng: exynos - Use pm_runtime_resume_and_get() to replace open coding
      hwrng: omap - Use pm_runtime_resume_and_get() to replace open coding
      hwrng: ks-sa - Use pm_runtime_resume_and_get() to replace open coding

Tom Rix (1):
      crypto: marvell/cesa - change FPGA indirect article to an

Tong Tiangen (1):
      crypto: nitrox - fix unchecked variable in nitrox_register_interrupts

Wei Yongjun (2):
      crypto: qce - Fix some error handling path
      crypto: qce - fix error return code in qce_skcipher_async_req_handle()

Weili Qian (9):
      crypto: hisilicon/qm - initialize the device before doing tasks
      crypto: hisilicon/qm - modify 'QM_RESETTING' clearing error
      crypto: hisilicon/qm - adjust order of device error configuration
      crypto: hisilicon/qm - enable to close master ooo when NFE occurs
      crypto: hisilicon/qm - add MSI detection steps on Kunpeng930
      crypto: hisilicon/qm - adjust reset interface
      crypto: hisilicon/qm - enable PF and VFs communication
      crypto: hisilicon/qm - add callback to support communication
      crypto: hisilicon/qm - update reset flow

Wenkai Lin (1):
      crypto: hisilicon/qm - implement for querying hardware tasks status.

Wu Bo (1):
      crypto: af_alg - use DIV_ROUND_UP helper macro for calculations

Yang Li (2):
      crypto: cavium/nitrox - Remove redundant initialization of 'sg'
      crypto: cavium/nitrox - Fix kernel-doc

YueHaibing (2):
      hwrng: core - Use DEVICE_ATTR_<RW|RO> macro
      crypto: sl3516 - Fix build warning without CONFIG_PM

Zhang Qilong (2):
      crypto: omap-des - using pm_runtime_resume_and_get instead of pm_runtime_get_sync
      crypto: omap-sham - Fix PM reference leak in omap sham ops

Zhen Lei (2):
      crypto: ux500 - Fix error return code in hash_hw_final()
      crypto: header - Fix spelling errors

Zou Wei (1):
      crypto: hisilicon - switch to memdup_user_nul()

kernel test robot (1):
      crypto: sl3516 - fix duplicated inclusion

Łukasz Stelmach (1):
      hwrng: exynos - Fix runtime PM imbalance on error

 .../bindings/crypto/cortina,sl3516-crypto.yaml     |   50 +
 .../bindings/crypto/intel,ixp4xx-crypto.yaml       |   47 +
 .../intel,ixp4xx-network-processing-engine.yaml    |   22 +-
 MAINTAINERS                                        |   23 +-
 arch/arm/crypto/Makefile                           |   10 +-
 arch/arm/crypto/poly1305-core.S_shipped            | 1158 --------
 arch/arm/crypto/sha256-core.S_shipped              | 2816 --------------------
 arch/arm/crypto/sha512-core.S_shipped              | 1869 -------------
 arch/arm/mach-ixp4xx/common.c                      |   26 +
 arch/arm64/crypto/Makefile                         |   10 +-
 arch/arm64/crypto/poly1305-core.S_shipped          |  835 ------
 arch/arm64/crypto/sha256-core.S_shipped            | 2069 --------------
 arch/arm64/crypto/sha512-core.S_shipped            | 1093 --------
 arch/x86/crypto/curve25519-x86_64.c                |    2 +-
 crypto/af_alg.c                                    |    2 +-
 crypto/algapi.c                                    |   18 -
 crypto/algboss.c                                   |   31 +-
 crypto/drbg.c                                      |   12 +-
 crypto/ecdh.c                                      |   49 +-
 crypto/internal.h                                  |   12 +
 crypto/khazad.c                                    |    2 +-
 crypto/shash.c                                     |   18 +-
 crypto/sm2.c                                       |   24 +-
 crypto/tcrypt.c                                    |   36 +
 crypto/testmgr.c                                   |   10 +-
 crypto/testmgr.h                                   |   71 +-
 crypto/wp512.c                                     |   40 +-
 drivers/char/hw_random/Kconfig                     |   10 +-
 drivers/char/hw_random/amd-rng.c                   |    2 +-
 drivers/char/hw_random/core.c                      |   38 +-
 drivers/char/hw_random/exynos-trng.c               |    7 +-
 drivers/char/hw_random/ks-sa-rng.c                 |    3 +-
 drivers/char/hw_random/omap-rng.c                  |    6 +-
 drivers/crypto/Kconfig                             |   41 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/cavium/cpt/cptpf_main.c             |    2 +-
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c       |   10 +-
 drivers/crypto/cavium/nitrox/nitrox_isr.c          |    4 +
 drivers/crypto/cavium/nitrox/nitrox_main.c         |   22 +-
 drivers/crypto/cavium/nitrox/nitrox_mbx.c          |    4 +-
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c       |   16 +-
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c     |    2 +-
 drivers/crypto/ccp/ccp-dev.c                       |    2 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |    3 +-
 drivers/crypto/ccp/sev-dev.c                       |    4 +
 drivers/crypto/ccp/sp-pci.c                        |    6 +-
 drivers/crypto/gemini/Makefile                     |    2 +
 drivers/crypto/gemini/sl3516-ce-cipher.c           |  387 +++
 drivers/crypto/gemini/sl3516-ce-core.c             |  535 ++++
 drivers/crypto/gemini/sl3516-ce-rng.c              |   61 +
 drivers/crypto/gemini/sl3516-ce.h                  |  347 +++
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |  185 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |  256 +-
 drivers/crypto/hisilicon/qm.c                      | 2181 +++++++++++----
 drivers/crypto/hisilicon/qm.h                      |   17 +
 drivers/crypto/hisilicon/sec2/sec.h                |   23 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         | 1036 ++++++-
 drivers/crypto/hisilicon/sec2/sec_crypto.h         |  193 ++
 drivers/crypto/hisilicon/sec2/sec_main.c           |  100 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |   99 +-
 drivers/crypto/ixp4xx_crypto.c                     |  413 +--
 drivers/crypto/marvell/cesa/cesa.h                 |    2 +-
 drivers/crypto/marvell/octeontx2/Makefile          |   13 +-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c       |   93 +
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h       |   36 +
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h |   23 +
 .../crypto/marvell/octeontx2/otx2_cpt_hw_types.h   |   16 +-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c      |    9 +-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h      |   10 +
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h      |    1 +
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |  160 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |   32 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.h    |    8 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf.h      |    3 +
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c |   49 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c |   43 +
 .../crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c   |   17 +-
 drivers/crypto/nx/nx-842-pseries.c                 |   31 +-
 drivers/crypto/nx/nx-aes-cbc.c                     |    2 +-
 drivers/crypto/nx/nx-aes-ccm.c                     |    4 +-
 drivers/crypto/nx/nx-aes-ctr.c                     |    4 +-
 drivers/crypto/nx/nx-aes-ecb.c                     |    2 +-
 drivers/crypto/nx/nx-aes-gcm.c                     |    2 +-
 drivers/crypto/nx/nx-common-powernv.c              |    4 +-
 drivers/crypto/nx/nx-sha256.c                      |   19 +-
 drivers/crypto/nx/nx-sha512.c                      |   19 +-
 drivers/crypto/nx/nx_csbcpb.h                      |    4 +-
 drivers/crypto/omap-des.c                          |    9 +-
 drivers/crypto/omap-sham.c                         |    4 +-
 .../qat/qat_common/icp_qat_fw_loader_handle.h      |    2 +-
 drivers/crypto/qat/qat_common/qat_hal.c            |   14 +-
 drivers/crypto/qat/qat_common/qat_uclo.c           |   12 +-
 drivers/crypto/qce/Makefile                        |    1 +
 drivers/crypto/qce/aead.c                          |  847 ++++++
 drivers/crypto/qce/aead.h                          |   56 +
 drivers/crypto/qce/common.c                        |  196 +-
 drivers/crypto/qce/common.h                        |    9 +-
 drivers/crypto/qce/core.c                          |    4 +
 drivers/crypto/qce/skcipher.c                      |   19 +-
 drivers/crypto/sa2ul.c                             |   50 +-
 drivers/crypto/ux500/hash/hash_core.c              |    1 +
 drivers/soc/ixp4xx/ixp4xx-npe.c                    |    7 +
 include/crypto/aead.h                              |    2 +-
 include/crypto/algapi.h                            |   10 +-
 include/crypto/engine.h                            |    2 +-
 include/crypto/hash.h                              |    2 +-
 include/crypto/internal/hash.h                     |    8 +-
 include/linux/crypto.h                             |   26 -
 108 files changed, 7084 insertions(+), 11176 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/cortina,sl3516-crypto.yaml
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
 delete mode 100644 arch/arm/crypto/poly1305-core.S_shipped
 delete mode 100644 arch/arm/crypto/sha256-core.S_shipped
 delete mode 100644 arch/arm/crypto/sha512-core.S_shipped
 delete mode 100644 arch/arm64/crypto/poly1305-core.S_shipped
 delete mode 100644 arch/arm64/crypto/sha256-core.S_shipped
 delete mode 100644 arch/arm64/crypto/sha512-core.S_shipped
 create mode 100644 drivers/crypto/gemini/Makefile
 create mode 100644 drivers/crypto/gemini/sl3516-ce-cipher.c
 create mode 100644 drivers/crypto/gemini/sl3516-ce-core.c
 create mode 100644 drivers/crypto/gemini/sl3516-ce-rng.c
 create mode 100644 drivers/crypto/gemini/sl3516-ce.h
 create mode 100644 drivers/crypto/marvell/octeontx2/cn10k_cpt.c
 create mode 100644 drivers/crypto/marvell/octeontx2/cn10k_cpt.h
 create mode 100644 drivers/crypto/qce/aead.c
 create mode 100644 drivers/crypto/qce/aead.h

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
