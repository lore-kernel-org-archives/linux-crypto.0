Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2062C432BE
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Aug 2021 08:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8209D60FF2
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Aug 2021 08:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhH3I3a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Aug 2021 04:29:30 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54554 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233890AbhH3I3a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Aug 2021 04:29:30 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mKcec-0002w0-O0; Mon, 30 Aug 2021 16:28:30 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mKceQ-00083N-Gp; Mon, 30 Aug 2021 16:28:18 +0800
Date:   Mon, 30 Aug 2021 16:28:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 5.15
Message-ID: <20210830082818.GA30921@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20201012033249.GA25179@gondor.apana.org.au>
 <20201214055515.GA14196@gondor.apana.org.au>
 <20210215024721.GA20593@gondor.apana.org.au>
 <20210426123200.kgbyk6ayey4l4lrw@gondor.apana.org.au>
 <20210628110050.GA12162@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628110050.GA12162@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

Algorithms:

- Add AES-NI/AVX/x86_64 implementation of SM4.

Drivers:

- Add Arm SMCCC TRNG based driver.

The following changes since commit 5261cdf457ce3635bf18d393a3c1991dcfaf9d02:

  crypto: drbg - select SHA512 (2021-07-16 15:49:31 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to 6ae51ffe5e768d9e25a7f4298e2e7a058472bcc3:

  crypto: sha512 - remove imaginary and mystifying clearing of variables (2021-08-27 16:30:19 +0800)

----------------------------------------------------------------
Ahsan Atta (1):
      crypto: qat - flush vf workqueue at driver removal

Andre Przywara (2):
      firmware: smccc: Register smccc_trng platform device
      hwrng: Add Arm SMCCC TRNG based driver

Ard Biesheuvel (1):
      crypto: x86/aes-ni - add missing error checks in XTS code

Ben Hutchings (2):
      crypto: omap - Avoid redundant copy when using truncated sg list
      crypto: omap - Fix inconsistent locking of device lists

Brijesh Singh (1):
      crypto: ccp - shutdown SEV firmware on kexec

Cai Huoqing (1):
      padata: Remove repeated verbose license text

Changbin Du (1):
      crypto: skcipher - in_irq() cleanup

Christophe JAILLET (3):
      crypto: qat - simplify code and axe the use of a deprecated API
      crypto: qat - disable AER if an error occurs in probe functions
      crypto: qat - fix a typo in a comment

Giovanni Cabiddu (8):
      crypto: qat - set DMA mask to 48 bits for Gen2
      crypto: qat - use proper type for vf_mask
      crypto: qat - do not ignore errors from enable_vf2pf_comms()
      crypto: qat - handle both source of interrupt in VF ISR
      crypto: qat - prevent spurious MSI interrupt in VF
      crypto: qat - move IO virtualization functions
      crypto: qat - do not export adf_iov_putmsg()
      crypto: qat - store vf.compatible flag

Hongbo Li (1):
      lib/mpi: use kcalloc in mpi_resize

Jason Wang (2):
      crypto: sun8i-ss - Use kfree_sensitive
      crypto: sun8i-ce - use kfree_sensitive to clear and free sensitive data

John Allen (1):
      crypto: ccp - Add support for new CCP/PSP device ID

Kai Ye (2):
      crypto: hisilicon/sec - fix the abnormal exiting process
      crypto: hisilicon/sec - modify the hardware endian configuration

Kanchana Velusamy (1):
      crypto: qat - protect interrupt mask CSRs with a spinlock

Lukas Bulwahn (2):
      crypto: rmd320 - remove rmd320 in Makefile
      crypto: sha512 - remove imaginary and mystifying clearing of variables

Marco Chiappero (10):
      crypto: qat - remove empty sriov_configure()
      crypto: qat - enable interrupts only after ISR allocation
      crypto: qat - prevent spurious MSI interrupt in PF
      crypto: qat - rename compatibility version definition
      crypto: qat - fix reuse of completion variable
      crypto: qat - move pf2vf interrupt [en|dis]able to adf_vf_isr.c
      crypto: qat - fix naming for init/shutdown VF to PF notifications
      crypto: qat - complete all the init steps before service notification
      crypto: qat - fix naming of PF/VF enable functions
      crypto: qat - remove the unnecessary get_vintmsk_offset()

Mian Yousaf Kaukab (1):
      crypto: ecc - handle unaligned input buffer in ecc_swap_digits

Randy Dunlap (4):
      crypto: arm/curve25519 - rename 'mod_init' & 'mod_exit' functions to be module-specific
      hwrng: rename 'mod_init' & 'mod_exit' functions to be module-specific
      crypto: lib - rename 'mod_init' & 'mod_exit' functions to be module-specific
      crypto: wp512 - correct a non-kernel-doc comment

Salah Triki (1):
      crypto: atmel-aes - use swap()

Sean Anderson (2):
      crypto: mxs-dcp - Check for DMA mapping errors
      crypto: mxs-dcp - Use sg_mapping_iter to copy data

Sebastian Andrzej Siewior (2):
      crypto: virtio - Replace deprecated CPU-hotplug functions.
      padata: Replace deprecated CPU-hotplug functions.

Shreyansh Chouhan (1):
      crypto: aesni - xts_crypt() return if walk.nbytes is 0

Svyatoslav Pankratov (1):
      crypto: qat - remove intermediate tasklet for vf2pf

Tianjia Zhang (9):
      crypto: sm4 - create SM4 library based on sm4 generic code
      crypto: arm64/sm4-ce - Make dependent on sm4 library instead of sm4-generic
      crypto: x86/sm4 - add AES-NI/AVX/x86_64 implementation
      crypto: tcrypt - add the asynchronous speed test for SM4
      crypto: tcrypt - Fix missing return value check
      crypto: testmgr - Add GCM/CCM mode test of SM4 algorithm
      crypto: tcrypt - add GCM/CCM mode test for SM4 algorithm
      crypto: x86/sm4 - export reusable AESNI/AVX functions
      crypto: x86/sm4 - add AES-NI/AVX2/x86_64 implementation

Tony Lindgren (6):
      crypto: omap-sham - clear dma flags only after omap_sham_update_dma_stop()
      crypto: omap-sham - initialize req only after omap_sham_hw_init()
      crypto: omap-sham - add missing pm_runtime_dontuse_autosuspend()
      crypto: omap-sham - drop old hw_init and unused FLAGS_INIT
      crypto: omap-sham - drop suspend and resume functions
      crypto: omap-sham - drop pm_runtime_irqsafe() usage

Tudor Ambarus (9):
      crypto: atmel-tdes - Clarify how tdes dev gets allocated to the tfm
      crypto: atmel-tdes - Handle error messages
      crypto: atmel-aes - Add blocksize constraint for ECB and CBC modes
      crypto: atmel-aes - Add XTS input length constraint
      crypto: atmel-aes - Add NIST 800-38A's zero length cryptlen constraint
      crypto: atmel-tdes - Add FIPS81's zero length cryptlen constraint
      crypto: atmel - Set OFB's blocksize to 1
      crypto: atmel-aes - Add fallback to XTS software implementation
      crypto: atmel-aes - Allocate aes dev at tfm init time

Weili Qian (8):
      crypto: hisilicon - enable zip device clock gating
      crypto: hisilicon - enable sec device clock gating
      crypto: hisilicon - enable hpre device clock gating
      crypto: hisilicon - using 'debugfs_create_file' instead of 'debugfs_create_regset32'
      crypto: hisilicon - add runtime PM ops
      crypto: hisilicon - support runtime PM for accelerator device
      crypto: hisilicon - change parameter passing of debugfs function
      crypto: hisilicon - check _PS0 and _PR0 method

Xiyu Yang (1):
      padata: Convert from atomic_t to refcount_t on parallel_data->refcnt

 arch/arm/crypto/curve25519-glue.c                  |   8 +-
 arch/arm64/crypto/Kconfig                          |   2 +-
 arch/arm64/crypto/sm4-ce-glue.c                    |  20 +-
 arch/x86/crypto/Makefile                           |   6 +
 arch/x86/crypto/aesni-intel_glue.c                 |   5 +
 arch/x86/crypto/sm4-aesni-avx-asm_64.S             | 589 +++++++++++++++++++++
 arch/x86/crypto/sm4-aesni-avx2-asm_64.S            | 497 +++++++++++++++++
 arch/x86/crypto/sm4-avx.h                          |  24 +
 arch/x86/crypto/sm4_aesni_avx2_glue.c              | 169 ++++++
 arch/x86/crypto/sm4_aesni_avx_glue.c               | 487 +++++++++++++++++
 crypto/Kconfig                                     |  44 ++
 crypto/Makefile                                    |   1 -
 crypto/ecc.h                                       |   5 +-
 crypto/sha512_generic.c                            |   3 -
 crypto/skcipher.c                                  |   2 +-
 crypto/sm4_generic.c                               | 180 +------
 crypto/tcrypt.c                                    | 100 +++-
 crypto/testmgr.c                                   |  29 +
 crypto/testmgr.h                                   | 148 ++++++
 crypto/wp512.c                                     |   2 +-
 drivers/char/hw_random/Kconfig                     |  14 +
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/amd-rng.c                   |   8 +-
 drivers/char/hw_random/arm_smccc_trng.c            | 123 +++++
 drivers/char/hw_random/geode-rng.c                 |   8 +-
 drivers/char/hw_random/intel-rng.c                 |   8 +-
 drivers/char/hw_random/via-rng.c                   |   8 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c  |   9 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c  |   3 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c  |   9 +-
 drivers/crypto/atmel-aes.c                         | 154 ++++--
 drivers/crypto/atmel-tdes.c                        |  66 +--
 drivers/crypto/ccp/sev-dev.c                       |  49 +-
 drivers/crypto/ccp/sp-pci.c                        |  19 +
 drivers/crypto/hisilicon/hpre/hpre_main.c          | 123 ++++-
 drivers/crypto/hisilicon/qm.c                      | 430 ++++++++++++---
 drivers/crypto/hisilicon/qm.h                      |   8 +
 drivers/crypto/hisilicon/sec2/sec.h                |   5 -
 drivers/crypto/hisilicon/sec2/sec_main.c           | 138 +++--
 drivers/crypto/hisilicon/zip/zip_main.c            |  83 ++-
 drivers/crypto/mxs-dcp.c                           |  81 +--
 drivers/crypto/omap-aes.c                          |   8 +-
 drivers/crypto/omap-crypto.c                       |   2 +-
 drivers/crypto/omap-des.c                          |   8 +-
 drivers/crypto/omap-sham.c                         |  68 +--
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c     |   8 +-
 drivers/crypto/qat/qat_4xxx/adf_drv.c              |  14 +-
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |  19 +-
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h   |   1 -
 drivers/crypto/qat/qat_c3xxx/adf_drv.c             |  21 +-
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c   |  14 +-
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h   |   1 -
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c           |  16 +-
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c     |  19 +-
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h     |   1 -
 drivers/crypto/qat/qat_c62x/adf_drv.c              |  21 +-
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c |  14 +-
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h |   1 -
 drivers/crypto/qat/qat_c62xvf/adf_drv.c            |  16 +-
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |   8 +-
 drivers/crypto/qat/qat_common/adf_aer.c            |   2 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |  21 +-
 drivers/crypto/qat/qat_common/adf_init.c           |  13 +-
 drivers/crypto/qat/qat_common/adf_isr.c            |  42 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |  78 +--
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h      |   2 +-
 drivers/crypto/qat/qat_common/adf_sriov.c          |   8 +-
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c      |  12 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |  64 ++-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |  19 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |   1 -
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |  21 +-
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |  14 +-
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h    |   1 -
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |  16 +-
 drivers/crypto/virtio/virtio_crypto_core.c         |   4 +-
 drivers/firmware/smccc/smccc.c                     |  17 +
 include/crypto/sm4.h                               |  25 +-
 include/linux/padata.h                             |   3 +-
 kernel/padata.c                                    |  35 +-
 lib/crypto/Kconfig                                 |   3 +
 lib/crypto/Makefile                                |   3 +
 lib/crypto/blake2s.c                               |   8 +-
 lib/crypto/chacha20poly1305.c                      |   8 +-
 lib/crypto/curve25519.c                            |   8 +-
 lib/crypto/sm4.c                                   | 176 ++++++
 lib/mpi/mpiutil.c                                  |   2 +-
 87 files changed, 3695 insertions(+), 839 deletions(-)
 create mode 100644 arch/x86/crypto/sm4-aesni-avx-asm_64.S
 create mode 100644 arch/x86/crypto/sm4-aesni-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/sm4-avx.h
 create mode 100644 arch/x86/crypto/sm4_aesni_avx2_glue.c
 create mode 100644 arch/x86/crypto/sm4_aesni_avx_glue.c
 create mode 100644 drivers/char/hw_random/arm_smccc_trng.c
 create mode 100644 lib/crypto/sm4.c

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
