Return-Path: <SRS0=/HXT=5R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04908C2D0F3
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 04:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD48C20842
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 04:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgDAE1u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Apr 2020 00:27:50 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36826 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgDAE1t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Apr 2020 00:27:49 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jJUyH-0006di-6G; Wed, 01 Apr 2020 15:27:22 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 01 Apr 2020 15:27:21 +1100
Date:   Wed, 1 Apr 2020 15:27:21 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 5.7
Message-ID: <20200401042720.GA12178@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20191125034536.wlgw25gpgn7y7vni@gondor.apana.org.au>
 <20200128050326.x3cfjz3rj7ep6xr2@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200128050326.x3cfjz3rj7ep6xr2@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

API:

- Fix out-of-sync IVs in self-test for IPsec AEAD algorithms.

Algorithms:

- Use formally verified implementation of x86/curve25519.

Drivers:

- Enhance hwrng support in caam.
- Use crypto_engine for skcipher/aead/rsa/hash in caam.
- Add Xilinx AES driver.
- Add uacce driver.
- Register zip engine to uacce in hisilicon.
- Add support for OCTEON TX CPT engine in marvell.

The following changes since commit bb6d3fb354c5ee8d6bde2d576eb7220ea09862b9:

  Linux 5.6-rc1 (2020-02-09 16:08:48 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to fcb90d51c375d09a034993cda262b68499e233a4:

  crypto: af_alg - bool type cosmetics (2020-03-30 11:50:50 +1100)

----------------------------------------------------------------
Al Viro (1):
      crypto: chelsio - Endianess bug in create_authenc_wr

Andrei Botila (2):
      crypto: caam - update xts sector size for large input length
      bus: fsl-mc: add api to retrieve mc version

Andrey Smirnov (8):
      crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
      crypto: caam - use struct hwrng's .init for initialization
      crypto: caam - drop global context pointer and init_done
      crypto: caam - simplify RNG implementation
      crypto: caam - check if RNG job failed
      crypto: caam - invalidate entropy register during RNG initialization
      crypto: caam - enable prediction resistance in HRWNG
      crypto: caam - limit single JD RNG output to maximum of 16 bytes

Ayush Sawal (5):
      crypto: chelsio - This fixes the libkcapi's cbc(aes) aio fail test cases
      crypto: chelsio - This fixes the kernel panic which occurs during a libkcapi test
      MAINTAINERS: Update maintainers for chelsio crypto drivers
      crypto: chelsio - Recalculate iv only if it is needed
      crypto: chelsio - Use multiple txq/rxq per tfm to process the requests

Chen Zhou (1):
      crypto: allwinner - remove redundant platform_get_irq error message

Colin Ian King (1):
      crypto: hisilicon - remove redundant assignment of pointer ctx

Connor Kuehl (1):
      crypto: ccp - use file mode for sev ioctl permissions

Corentin Labbe (3):
      crypto: arm64/sha-ce - implement export/import
      crypto: sun8i-ss - fix description of stat_fb
      crypto: sun8i-ce - fix description of stat_fb

Dan Carpenter (1):
      crypto: rng - Fix a refcounting bug in crypto_rng_reset()

Daniel Jordan (1):
      padata: fix uninitialized return value in padata_replace()

Devulapally Shiva Krishna (2):
      crypto: chelsio - Print the chcr driver information while module load.
      crypto: chelsio - un-register crypto algorithms

Eneas U de Queiroz (4):
      crypto: qce - use cryptlen when adding extra sgl
      crypto: qce - use AES fallback for small requests
      crypto: qce - handle AES-XTS cases that qce fails
      crypto: qce - fix wrong config symbol reference

Eric Biggers (15):
      crypto: authencesn - fix weird comma-terminated line
      crypto: ccm - simplify error handling in crypto_rfc4309_create()
      crypto: cryptd - simplify error handling in cryptd_create_*()
      crypto: ctr - simplify error handling in crypto_rfc3686_create()
      crypto: cts - simplify error handling in crypto_cts_create()
      crypto: gcm - simplify error handling in crypto_rfc4106_create()
      crypto: gcm - simplify error handling in crypto_rfc4543_create()
      crypto: geniv - simply error handling in aead_geniv_alloc()
      crypto: lrw - simplify error handling in create()
      crypto: pcrypt - simplify error handling in pcrypt_create_aead()
      crypto: rsa-pkcs1pad - simplify error handling in pkcs1pad_create()
      crypto: xts - simplify error handling in ->create()
      crypto: testmgr - use consistent IV copies for AEADs that need it
      crypto: testmgr - do comparison tests before inauthentic input tests
      crypto: aead - improve documentation for scatterlist layout

Geert Uytterhoeven (35):
      debugfs: regset32: Add Runtime PM support
      crypto: ccree - fix debugfs register access while suspended
      crypto: ccree - fix retry handling in cc_send_sync_request()
      crypto: ccree - remove unneeded casts
      crypto: ccree - swap SHA384 and SHA512 larval hashes at build time
      crypto: ccree - drop duplicated error message on SRAM exhaustion
      crypto: ccree - remove empty cc_sram_mgr_fini()
      crypto: ccree - clean up clock handling
      crypto: ccree - make mlli_params.mlli_virt_addr void *
      crypto: ccree - use existing helpers to split 64-bit addresses
      crypto: ccree - defer larval_digest_addr init until needed
      crypto: ccree - remove bogus paragraph about freeing SRAM
      crypto: ccree - use u32 for SRAM addresses
      crypto: ccree - simplify Runtime PM handling
      crypto: ccree - use of_device_get_match_data()
      crypto: ccree - remove cc_pm_is_dev_suspended() wrapper
      crypto: ccree - make cc_pm_{suspend,resume}() static
      crypto: ccree - remove struct cc_sram_ctx
      crypto: ccree - remove struct cc_debugfs_ctx
      crypto: ccree - remove struct buff_mgr_handle
      crypto: ccree - remove struct cc_cipher_handle
      crypto: ccree - extract cc_init_copy_sram()
      crypto: ccree - remove bogus kerneldoc markers
      crypto: ccree - improve kerneldoc in cc_hw_queue_defs.h
      crypto: ccree - improve kerneldoc in cc_buffer_mgr.c
      crypto: ccree - improve kerneldoc in cc_hash.[ch]
      crypto: ccree - improve kerneldoc in cc_request_mgr.[ch]
      crypto: ccree - improve kerneldoc in cc_sram_mgr.[ch]
      crypto: ccree - spelling s/Crytpcell/Cryptocell/
      crypto: ccree - grammar s/not room/no room/
      crypto: ccree - use existing dev helper in init_cc_resources()
      crypto: ccree - use devm_k[mz]alloc() for AEAD data
      crypto: ccree - use devm_k[mz]alloc() for cipher data
      crypto: ccree - use devm_kzalloc() for hash data
      crypto: qat - spelling s/Decrytp/Decrypt/

Gilad Ben-Yossef (9):
      crypto: ccree - protect against empty or NULL scatterlists
      crypto: ccree - only try to map auth tag if needed
      crypto: ccree - fix some reported cipher block sizes
      crypto: ccree - fix AEAD blocksize registration
      crypto: ccree - dec auth tag size from cryptlen map
      crypto: ccree - remove ancient TODO remarks
      crypto: ccree - only check condition if needed
      crypto: ccree - use crypto_ipsec_check_assoclen()
      crypto: ccree - refactor AEAD IV in AAD handling

Gustavo A. R. Silva (3):
      crypto: img-hash - Replace zero-length array with flexible-array member
      crypto: s5p-sss - Replace zero-length array with flexible-array member
      crypto: Replace zero-length array with flexible-array member

Hadar Gat (2):
      crypto: ccree - update register handling macros
      crypto: ccree - remove pointless comment

Herbert Xu (1):
      hwrng: omap3-rom - Include linux/io.h for virt_to_phys

Hongbo Yao (1):
      crypto: hisilicon - qm depends on UACCE

Horia Geantă (2):
      crypto: tcrypt - fix printed skcipher [a]sync mode
      crypto: caam/qi2 - fix chacha20 data size error

Hui Tang (1):
      crypto: hisilicon/hpre - Optimize finding hpre device process

Iuliana Prodan (9):
      crypto: caam - refactor skcipher/aead/gcm/chachapoly {en,de}crypt functions
      crypto: caam - refactor ahash_done callbacks
      crypto: caam - refactor ahash_edesc_alloc
      crypto: caam - refactor RSA private key _done callbacks
      crypto: caam - change return code in caam_jr_enqueue function
      crypto: caam - support crypto_engine framework for SKCIPHER algorithms
      crypto: caam - add crypto_engine support for AEAD algorithms
      crypto: caam - add crypto_engine support for RSA algorithms
      crypto: caam - add crypto_engine support for HASH algorithms

Jason A. Donenfeld (3):
      crypto: x86/curve25519 - replace with formally verified implementation
      crypto: x86/curve25519 - leave r12 as spare register
      crypto: arm[64]/poly1305 - add artifact to .gitignore files

Jianhui Zhao (1):
      crypto: atmel-i2c - Fix wakeup fail

John Allen (2):
      crypto: ccp - Cleanup misc_dev on sev_exit()
      crypto: ccp - Cleanup sp_dev_master in psp_dev_destroy()

Kai Ye (1):
      crypto: hisilicon/sec2 - Add new create qp process

Kalyani Akula (3):
      firmware: xilinx: Add ZynqMP aes API for AES functionality
      dt-bindings: crypto: Add bindings for ZynqMP AES-GCM driver
      crypto: xilinx - Add Xilinx AES driver

Kenneth Lee (2):
      uacce: Add documents for uacce
      uacce: add uacce driver

Longfang Liu (3):
      crypto: hisilicon/sec2 - Add iommu status check
      crypto: hisilicon/sec2 - Update IV and MAC operation
      crypto: hisilicon/sec2 - Add pbuffer mode for SEC driver

Lothar Rubusch (1):
      crypto: af_alg - bool type cosmetics

Martin Kaiser (5):
      hwrng: imx-rngc - fix an error path
      hwrng: imx-rngc - use automatic seeding
      hwrng: imx-rngc - (trivial) simplify error prints
      hwrng: imx-rngc - check the rng type
      hwrng: imx-rngc - simplify interrupt mask/unmask

Matteo Croce (1):
      crypto: arm64/poly1305 - ignore build files

Randy Dunlap (1):
      hwrng: ks-sa - move TI Keystone driver into the config menu structure

Rosioru Dragos (1):
      crypto: mxs-dcp - fix scatterlist linearization for hash

Shukun Tan (6):
      crypto: hisilicon - Unify hardware error init/uninit into QM
      crypto: hisilicon - Configure zip RAS error type
      crypto: hisilicon - Unify error detect process into qm
      crypto: hisilicon - Fix duplicate print when qm occur multiple errors
      crypto: hisilicon - Use one workqueue per qm instead of per qp
      crypto: hisilicon/zip - Use hisi_qm_alloc_qps_node() when init ctx

SrujanaChalla (4):
      crypto: marvell - create common Kconfig and Makefile for Marvell
      crypto: marvell - add support for OCTEON TX CPT engine
      crypto: marvell - add the Virtual Function driver for CPT
      crypto: marvell - enable OcteonTX cpt options for build

Stefan Agner (1):
      crypto: arm/ghash-ce - define fpu before fpu registers are referenced

Stephen Kitt (1):
      crypto: chelsio - remove extra allocation for chtls_dev

Takashi Iwai (1):
      crypto: bcm - Use scnprintf() for avoiding potential buffer overflow

Tianjia Zhang (2):
      crypto: proc - simplify the c_show function
      crypto: qat - simplify the qat_crypto function

Torsten Duwe (1):
      crypto: arm/neon - memzero_explicit aes-cbc key

Uwe Kleine-König (1):
      hwrng: imx-rngc - improve dependencies

Valentin Ciocoi Radulescu (1):
      crypto: caam/qi - optimize frame queue cleanup

Vinay Kumar Yadav (2):
      crypto: chelsio/chtls - Fixed tls stats
      crypto: chelsio/chtls - Fixed boolinit.cocci warning

Weili Qian (1):
      crypto: hisilicon/qm - Put device finding logic into QM

Ye Kai (1):
      crypto: hisilicon/sec2 - Add workqueue for SEC driver.

YueHaibing (4):
      crypto: ccree - remove set but not used variable 'du_size'
      crypto: md5 - remove unused macros
      crypto: chelsio - remove set but not used variable 'adap'
      crypto: ccree - remove duplicated include from cc_aead.c

Zhangfei Gao (4):
      crypto: hisilicon - Remove module_param uacce_mode
      crypto: hisilicon - register zip engine to uacce
      MAINTAINERS: add maintainers for uacce
      uacce: unmap remaining mmapping from user space

 Documentation/ABI/testing/sysfs-driver-uacce       |   39 +
 .../bindings/crypto/xlnx,zynqmp-aes.yaml           |   37 +
 Documentation/misc-devices/uacce.rst               |  176 +
 MAINTAINERS                                        |   17 +-
 arch/arm/crypto/.gitignore                         |    1 +
 arch/arm/crypto/aes-neonbs-glue.c                  |    1 +
 arch/arm/crypto/ghash-ce-core.S                    |    5 +-
 arch/arm64/crypto/.gitignore                       |    1 +
 arch/arm64/crypto/aes-neonbs-glue.c                |    1 +
 arch/arm64/crypto/sha1-ce-glue.c                   |   20 +
 arch/arm64/crypto/sha2-ce-glue.c                   |   23 +
 arch/x86/crypto/curve25519-x86_64.c                | 3546 +++++++-------------
 crypto/af_alg.c                                    |   10 +-
 crypto/algif_hash.c                                |    6 +-
 crypto/authencesn.c                                |    2 +-
 crypto/ccm.c                                       |   29 +-
 crypto/cryptd.c                                    |   37 +-
 crypto/ctr.c                                       |   29 +-
 crypto/cts.c                                       |   27 +-
 crypto/gcm.c                                       |   66 +-
 crypto/geniv.c                                     |   17 +-
 crypto/lrw.c                                       |   28 +-
 crypto/md5.c                                       |    3 -
 crypto/pcrypt.c                                    |   33 +-
 crypto/proc.c                                      |    2 +-
 crypto/rng.c                                       |    8 +-
 crypto/rsa-pkcs1pad.c                              |   59 +-
 crypto/tcrypt.c                                    |    4 +-
 crypto/testmgr.c                                   |   28 +-
 crypto/xts.c                                       |   28 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   33 +-
 drivers/char/hw_random/Kconfig                     |   17 +-
 drivers/char/hw_random/imx-rngc.c                  |   85 +-
 drivers/char/hw_random/omap3-rom-rng.c             |    1 +
 drivers/crypto/Kconfig                             |   50 +-
 drivers/crypto/Makefile                            |    3 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |    4 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |    2 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |    2 +-
 drivers/crypto/atmel-i2c.c                         |    3 +-
 drivers/crypto/bcm/util.c                          |   40 +-
 drivers/crypto/caam/Kconfig                        |    2 +
 drivers/crypto/caam/caamalg.c                      |  415 +--
 drivers/crypto/caam/caamalg_desc.c                 |   30 +-
 drivers/crypto/caam/caamalg_qi.c                   |    4 +-
 drivers/crypto/caam/caamalg_qi2.h                  |    6 +-
 drivers/crypto/caam/caamhash.c                     |  340 +-
 drivers/crypto/caam/caampkc.c                      |  185 +-
 drivers/crypto/caam/caampkc.h                      |   10 +
 drivers/crypto/caam/caamrng.c                      |  405 +--
 drivers/crypto/caam/ctrl.c                         |   88 +-
 drivers/crypto/caam/desc.h                         |    2 +
 drivers/crypto/caam/intern.h                       |    9 +-
 drivers/crypto/caam/jr.c                           |   49 +-
 drivers/crypto/caam/key_gen.c                      |    2 +-
 drivers/crypto/caam/qi.c                           |   60 +-
 drivers/crypto/caam/qi.h                           |    4 +-
 drivers/crypto/caam/regs.h                         |    7 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c         |    2 +-
 drivers/crypto/ccp/psp-dev.c                       |    3 +
 drivers/crypto/ccp/sev-dev.c                       |   39 +-
 drivers/crypto/ccp/sp-dev.h                        |    1 +
 drivers/crypto/ccp/sp-pci.c                        |    9 +
 drivers/crypto/ccree/cc_aead.c                     |  176 +-
 drivers/crypto/ccree/cc_aead.h                     |    3 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |  229 +-
 drivers/crypto/ccree/cc_buffer_mgr.h               |    5 +-
 drivers/crypto/ccree/cc_cipher.c                   |   78 +-
 drivers/crypto/ccree/cc_debugfs.c                  |   29 +-
 drivers/crypto/ccree/cc_driver.c                   |  127 +-
 drivers/crypto/ccree/cc_driver.h                   |   18 +-
 drivers/crypto/ccree/cc_hash.c                     |  228 +-
 drivers/crypto/ccree/cc_hash.h                     |   31 +-
 drivers/crypto/ccree/cc_hw_queue_defs.h            |  332 +-
 drivers/crypto/ccree/cc_pm.c                       |   60 +-
 drivers/crypto/ccree/cc_pm.h                       |   21 -
 drivers/crypto/ccree/cc_request_mgr.c              |   48 +-
 drivers/crypto/ccree/cc_request_mgr.h              |   19 +-
 drivers/crypto/ccree/cc_sram_mgr.c                 |   78 +-
 drivers/crypto/ccree/cc_sram_mgr.h                 |   45 +-
 drivers/crypto/chelsio/chcr_algo.c                 |  358 +-
 drivers/crypto/chelsio/chcr_core.c                 |    3 +
 drivers/crypto/chelsio/chcr_core.h                 |    6 +-
 drivers/crypto/chelsio/chcr_crypto.h               |   16 +-
 drivers/crypto/chelsio/chtls/chtls_io.c            |    7 +-
 drivers/crypto/chelsio/chtls/chtls_main.c          |   10 +-
 drivers/crypto/hisilicon/Kconfig                   |    2 +
 drivers/crypto/hisilicon/hpre/hpre.h               |    3 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |   20 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |  160 +-
 drivers/crypto/hisilicon/qm.c                      |  619 +++-
 drivers/crypto/hisilicon/qm.h                      |   72 +-
 drivers/crypto/hisilicon/sec2/sec.h                |   12 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  260 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |  294 +-
 drivers/crypto/hisilicon/zip/zip.h                 |    2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c          |   54 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |  324 +-
 drivers/crypto/img-hash.c                          |    2 +-
 drivers/crypto/marvell/Kconfig                     |   37 +
 drivers/crypto/marvell/Makefile                    |    7 +-
 drivers/crypto/marvell/cesa/Makefile               |    3 +
 drivers/crypto/marvell/{ => cesa}/cesa.c           |    0
 drivers/crypto/marvell/{ => cesa}/cesa.h           |    5 +-
 drivers/crypto/marvell/{ => cesa}/cipher.c         |   15 +-
 drivers/crypto/marvell/{ => cesa}/hash.c           |   38 +-
 drivers/crypto/marvell/{ => cesa}/tdma.c           |   10 +-
 drivers/crypto/marvell/octeontx/Makefile           |    6 +
 drivers/crypto/marvell/octeontx/otx_cpt_common.h   |   51 +
 drivers/crypto/marvell/octeontx/otx_cpt_hw_types.h |  824 +++++
 drivers/crypto/marvell/octeontx/otx_cptpf.h        |   34 +
 drivers/crypto/marvell/octeontx/otx_cptpf_main.c   |  307 ++
 drivers/crypto/marvell/octeontx/otx_cptpf_mbox.c   |  253 ++
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  | 1686 ++++++++++
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h  |  180 +
 drivers/crypto/marvell/octeontx/otx_cptvf.h        |  104 +
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c   | 1744 ++++++++++
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.h   |  188 ++
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c   |  985 ++++++
 drivers/crypto/marvell/octeontx/otx_cptvf_mbox.c   |  247 ++
 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c |  612 ++++
 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h |  227 ++
 drivers/crypto/mediatek/mtk-sha.c                  |    2 +-
 drivers/crypto/mxs-dcp.c                           |   58 +-
 drivers/crypto/nx/nx.h                             |    2 +-
 drivers/crypto/omap-sham.c                         |    4 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |    2 +-
 drivers/crypto/qat/qat_common/qat_crypto.c         |    3 +-
 drivers/crypto/qce/common.c                        |    2 -
 drivers/crypto/qce/common.h                        |    3 +
 drivers/crypto/qce/dma.c                           |   11 +-
 drivers/crypto/qce/dma.h                           |    2 +-
 drivers/crypto/qce/skcipher.c                      |   30 +-
 drivers/crypto/s5p-sss.c                           |    2 +-
 drivers/crypto/xilinx/Makefile                     |    2 +
 drivers/crypto/xilinx/zynqmp-aes-gcm.c             |  457 +++
 drivers/firmware/xilinx/zynqmp.c                   |   25 +
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/uacce/Kconfig                         |   13 +
 drivers/misc/uacce/Makefile                        |    2 +
 drivers/misc/uacce/uacce.c                         |  633 ++++
 fs/debugfs/file.c                                  |    8 +
 include/crypto/aead.h                              |   48 +-
 include/crypto/if_alg.h                            |    2 +-
 include/linux/debugfs.h                            |    1 +
 include/linux/firmware/xlnx-zynqmp.h               |    2 +
 include/linux/fsl/mc.h                             |   16 +
 include/linux/uacce.h                              |  163 +
 include/uapi/misc/uacce/hisi_qm.h                  |   23 +
 include/uapi/misc/uacce/uacce.h                    |   38 +
 kernel/padata.c                                    |    9 +-
 152 files changed, 13777 insertions(+), 5297 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-uacce
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
 create mode 100644 Documentation/misc-devices/uacce.rst
 create mode 100644 drivers/crypto/marvell/Kconfig
 create mode 100644 drivers/crypto/marvell/cesa/Makefile
 rename drivers/crypto/marvell/{ => cesa}/cesa.c (100%)
 rename drivers/crypto/marvell/{ => cesa}/cesa.h (99%)
 rename drivers/crypto/marvell/{ => cesa}/cipher.c (98%)
 rename drivers/crypto/marvell/{ => cesa}/hash.c (98%)
 rename drivers/crypto/marvell/{ => cesa}/tdma.c (97%)
 create mode 100644 drivers/crypto/marvell/octeontx/Makefile
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cpt_common.h
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cpt_hw_types.h
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf.h
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf.h
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_algs.h
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_main.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_mbox.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
 create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h
 create mode 100644 drivers/crypto/xilinx/Makefile
 create mode 100644 drivers/crypto/xilinx/zynqmp-aes-gcm.c
 create mode 100644 drivers/misc/uacce/Kconfig
 create mode 100644 drivers/misc/uacce/Makefile
 create mode 100644 drivers/misc/uacce/uacce.c
 create mode 100644 include/linux/uacce.h
 create mode 100644 include/uapi/misc/uacce/hisi_qm.h
 create mode 100644 include/uapi/misc/uacce/uacce.h

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
