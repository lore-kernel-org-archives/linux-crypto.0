Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8D1C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 03:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A09260FD9
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 03:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbhKBDyp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 23:54:45 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56454 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhKBDyo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 23:54:44 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mhkqD-0004oI-DS; Tue, 02 Nov 2021 11:52:05 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mhkqA-00065U-0k; Tue, 02 Nov 2021 11:52:02 +0800
Date:   Tue, 2 Nov 2021 11:52:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 5.16
Message-ID: <20211102035201.GA23331@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20201012033249.GA25179@gondor.apana.org.au>
 <20201214055515.GA14196@gondor.apana.org.au>
 <20210215024721.GA20593@gondor.apana.org.au>
 <20210426123200.kgbyk6ayey4l4lrw@gondor.apana.org.au>
 <20210628110050.GA12162@gondor.apana.org.au>
 <20210830082818.GA30921@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210830082818.GA30921@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

API:

- Delay boot-up self-test for built-in algorithms.

Algorithms:

- Remove fallback path on arm64 as SIMD now runs with softirq off.

Drivers:

- Add Keem Bay OCS ECC Driver.

The following changes since commit 6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f:

  Linux 5.15-rc1 (2021-09-12 16:28:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to 39ef08517082a424b5b65c3dbaa6c0fa9d3303b9:

  crypto: testmgr - fix wrong key length for pkcs1pad (2021-10-29 21:04:04 +0800)

----------------------------------------------------------------
Ard Biesheuvel (7):
      crypto: arm64/gcm-aes-ce - remove non-SIMD fallback path
      crypto: arm64/aes-neonbs - stop using SIMD helper for skciphers
      crypto: arm64/aes-ce - stop using SIMD helper for skciphers
      crypto: arm64/aes-ccm - yield NEON when processing auth-only data
      crypto: arm64/aes-ccm - remove non-SIMD fallback path
      crypto: arm64/aes-ccm - reduce NEON begin/end calls for common case
      crypto: arm64/aes-ccm - avoid by-ref argument for ce_aes_ccm_auth_data

Arnd Bergmann (2):
      crypto: ecc - fix CRYPTO_DEFAULT_RNG dependency
      crypto: ccree - avoid out-of-range warnings from clang

Cai Huoqing (3):
      hwrng: Kconfig - Add helper dependency on COMPILE_TEST
      hwrng: ixp4xx - Make use of the helper function devm_platform_ioremap_resource()
      crypto: ccp - Make use of the helper macro kthread_run()

Colin Ian King (2):
      crypto: img-hash - remove need for error return variable ret
      crypto: hisilicon/zip - Fix spelling mistake "COMSUMED" -> "CONSUMED"

Daniel Jordan (1):
      crypto: pcrypt - Delay write to padata->info

Daniele Alessandrelli (2):
      crypto: ecc - Move ecc.h to include/crypto/internal
      crypto: ecc - Export additional helper functions

Giovanni Cabiddu (5):
      crypto: qat - remove unneeded packed attribute
      crypto: qat - power up 4xxx device
      crypto: qat - detect PFVF collision after ACK
      crypto: qat - disregard spurious PFVF interrupts
      crypto: qat - use hweight for bit counting

Herbert Xu (4):
      crypto: hisilicon - Fix sscanf format signedness
      crypto: api - Fix built-in testing dependency failures
      crypto: api - Export crypto_boot_test_finished
      crypto: api - Do not create test larvals if manager is disabled

Horia Geantă (1):
      crypto: tcrypt - fix skcipher multi-buffer tests for 1420B blocks

Kai Ye (3):
      crypto: hisilicon/qm - fix the uacce mmap failed
      crypto: hisilicon/qm - support the userspace task resetting
      crypto: hisilicon/qm - modify the uacce mode check

Krzysztof Kozlowski (1):
      crypto: marvell/cesa - drop unneeded MODULE_ALIAS

Lei He (1):
      crypto: testmgr - fix wrong key length for pkcs1pad

Maksim Lukoshkov (1):
      crypto: qat - free irqs only if allocated

Marco Chiappero (9):
      crypto: qat - remove unnecessary collision prevention step in PFVF
      crypto: qat - fix handling of VF to PF interrupts
      crypto: qat - remove duplicated logic across GEN2 drivers
      crypto: qat - make pfvf send message direction agnostic
      crypto: qat - move pfvf collision detection values
      crypto: qat - rename pfvf collision constants
      crypto: qat - add VF and PF wrappers to common send function
      crypto: qat - extract send and wait from adf_vf2pf_request_version()
      crypto: qat - share adf_enable_pf2vf_comms() from adf_pf2vf_msg.c

Markus Schneider-Pargmann (1):
      hwrng: mtk - Force runtime pm ops for sleep ops

Michael Walle (1):
      crypto: caam - disable pkc for non-E SoCs

Nathan Chancellor (1):
      crypto: sm4 - Do not change section of ck and sbox

Ovidiu Panait (1):
      crypto: octeontx2 - set assoclen in aead_do_fallback()

Peter Gonda (1):
      crypto: ccp - Fix whitespace in sev_cmd_buffer_len()

Prabhjot Khurana (3):
      crypto: engine - Add KPP Support to Crypto Engine
      dt-bindings: crypto: Add Keem Bay ECC bindings
      crypto: keembay-ocs-ecc - Add Keem Bay OCS ECC Driver

Qing Wang (1):
      hwrng: s390 - replace snprintf in show functions with sysfs_emit

Randy Dunlap (1):
      crypto: jitter - drop kernel-doc notation

Sebastian Andrzej Siewior (1):
      crypto: testmgr - Only disable migration in crypto_disable_simd_for_test()

Shreyansh Chouhan (1):
      crypto: aesni - check walk.nbytes instead of err

Tang Bin (2):
      crypto: s5p-sss - Add error handling in s5p_aes_probe()
      crypto: sa2ul - Use the defined variable to clean code

Tim Gardner (1):
      crypto: drbg - Fix unused value warning in drbg_healthcheck_sanity()

Uwe Kleine-König (1):
      hwrng: meson - Improve error handling for core clock

Wojciech Ziemba (3):
      crypto: qat - replace deprecated MSI API
      crypto: qat - remove unmatched CPU affinity to cluster IRQ
      crypto: qat - free irq in case of failure

 Documentation/crypto/crypto_engine.rst             |    4 +
 .../bindings/crypto/intel,keembay-ocs-ecc.yaml     |   47 +
 MAINTAINERS                                        |   11 +
 arch/arm64/crypto/Kconfig                          |    6 -
 arch/arm64/crypto/aes-ce-ccm-core.S                |   24 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c                |  203 ++--
 arch/arm64/crypto/aes-glue.c                       |  102 +-
 arch/arm64/crypto/aes-neonbs-glue.c                |  122 +--
 arch/arm64/crypto/ghash-ce-glue.c                  |  209 +---
 arch/x86/crypto/aesni-intel_glue.c                 |    2 +-
 crypto/Kconfig                                     |    2 +-
 crypto/algapi.c                                    |  123 ++-
 crypto/api.c                                       |   50 +-
 crypto/crypto_engine.c                             |   26 +
 crypto/drbg.c                                      |    2 +-
 crypto/ecc.c                                       |   14 +-
 crypto/ecdh.c                                      |    2 +-
 crypto/ecdsa.c                                     |    2 +-
 crypto/ecrdsa.c                                    |    2 +-
 crypto/ecrdsa_defs.h                               |    2 +-
 crypto/internal.h                                  |   10 +
 crypto/jitterentropy.c                             |   24 +-
 crypto/pcrypt.c                                    |   12 +-
 crypto/tcrypt.c                                    |    5 +-
 crypto/testmgr.c                                   |    4 +-
 crypto/testmgr.h                                   |    2 +-
 drivers/char/hw_random/Kconfig                     |   12 +-
 drivers/char/hw_random/ixp4xx-rng.c                |    4 +-
 drivers/char/hw_random/meson-rng.c                 |    5 +-
 drivers/char/hw_random/mtk-rng.c                   |    9 +-
 drivers/char/hw_random/s390-trng.c                 |    4 +-
 drivers/crypto/caam/caampkc.c                      |   19 +-
 drivers/crypto/caam/regs.h                         |    3 +
 drivers/crypto/ccp/ccp-dev-v3.c                    |    5 +-
 drivers/crypto/ccp/ccp-dev-v5.c                    |    5 +-
 drivers/crypto/ccp/sev-dev.c                       |    2 +-
 drivers/crypto/ccree/cc_driver.c                   |    3 +-
 drivers/crypto/hisilicon/qm.c                      |   74 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |    2 +-
 drivers/crypto/img-hash.c                          |    7 +-
 drivers/crypto/keembay/Kconfig                     |   19 +
 drivers/crypto/keembay/Makefile                    |    2 +
 drivers/crypto/keembay/keembay-ocs-ecc.c           | 1017 ++++++++++++++++++++
 drivers/crypto/marvell/cesa/cesa.c                 |    1 -
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c |    1 +
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c     |   35 +-
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h     |   10 +
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |   89 +-
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h   |   13 +-
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c     |   87 +-
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h     |   12 -
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |   29 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    9 +-
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.c   |   98 ++
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.h   |   27 +
 drivers/crypto/qat/qat_common/adf_init.c           |    5 +
 drivers/crypto/qat/qat_common/adf_isr.c            |  190 ++--
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |  238 +++--
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h      |    9 -
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c      |    4 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |   30 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |  123 +--
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |   14 +-
 drivers/crypto/s5p-sss.c                           |    2 +
 drivers/crypto/sa2ul.c                             |   13 +-
 include/crypto/engine.h                            |    5 +
 {crypto => include/crypto/internal}/ecc.h          |   36 +
 lib/crypto/sm4.c                                   |    4 +-
 68 files changed, 2130 insertions(+), 1158 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml
 create mode 100644 drivers/crypto/keembay/keembay-ocs-ecc.c
 rename {crypto => include/crypto/internal}/ecc.h (90%)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
