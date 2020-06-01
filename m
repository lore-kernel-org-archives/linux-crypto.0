Return-Path: <SRS0=veUY=7O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F060CC433DF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 02:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF12220772
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 02:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgFACps (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 May 2020 22:45:48 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52092 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbgFACps (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 May 2020 22:45:48 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jfaSD-0006WK-Sp; Mon, 01 Jun 2020 12:45:35 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 01 Jun 2020 12:45:33 +1000
Date:   Mon, 1 Jun 2020 12:45:33 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 5.8
Message-ID: <20200601024533.GA18937@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20191125034536.wlgw25gpgn7y7vni@gondor.apana.org.au>
 <20200128050326.x3cfjz3rj7ep6xr2@gondor.apana.org.au>
 <20200401042720.GA12178@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200401042720.GA12178@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

API:

- Introduce crypto_shash_tfm_digest() and use it wherever possible.
- Fix use-after-free and race in crypto_spawn_alg.
- Add support for parallel and batch requests to crypto_engine.

Algorithms:

- Update jitter RNG for SP800-90B compliance.
- Always use jitter RNG as seed in drbg.

Drivers:

- Add Arm CryptoCell driver cctrng.
- Add support for SEV-ES to the PSP driver in ccp.

The following changes since commit 55b3209acbb01cb02b1ee6b1afe80d83b1aab36d:

  crypto: caam - fix the address of the last entry of S/G (2020-04-16 16:48:56 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to 58ca0060ec4e51208d2eee12198fc55fd9e4feb3:

  crypto: hisilicon - fix driver compatibility issue with different versions of devices (2020-05-28 17:27:52 +1000)

----------------------------------------------------------------
Andy Shevchenko (1):
      hwrng: optee - Use UUID API for exporting the UUID

Arnd Bergmann (3):
      crypto: ccp -- don't "select" CONFIG_DMADEVICES
      crypto - Avoid free() namespace collision
      crypto: blake2b - Fix clang optimization for ARMv7-M

Barry Song (1):
      crypto: acomp - search acomp with scomp backend in crypto_has_acomp

Christophe JAILLET (2):
      crypto: marvell/octeontx - Add missing '\n' in log messages
      crypto: cavium/nitrox - Fix a typo in a comment

Colin Ian King (2):
      crypto: chelsio - remove redundant assignment to variable error
      crypto: algif_rng - remove redundant assignment to variable err

Corentin Labbe (2):
      crypto: ctr - no longer needs CRYPTO_SEQIV
      crypto: drbg - should select CTR

Daniel Jordan (1):
      padata: add separate cpuhp node for CPUHP_PADATA_DEAD

Eric Biggers (29):
      crypto: algapi - Avoid spurious modprobe on LOADED
      crypto: lib/sha256 - return void
      crypto: hash - introduce crypto_shash_tfm_digest()
      crypto: arm64/aes-glue - use crypto_shash_tfm_digest()
      crypto: essiv - use crypto_shash_tfm_digest()
      crypto: artpec6 - use crypto_shash_tfm_digest()
      crypto: ccp - use crypto_shash_tfm_digest()
      crypto: ccree - use crypto_shash_tfm_digest()
      crypto: hisilicon/sec2 - use crypto_shash_tfm_digest()
      crypto: mediatek - use crypto_shash_tfm_digest()
      crypto: n2 - use crypto_shash_tfm_digest()
      crypto: omap-sham - use crypto_shash_tfm_digest()
      crypto: s5p-sss - use crypto_shash_tfm_digest()
      nfc: s3fwrn5: use crypto_shash_tfm_digest()
      fscrypt: use crypto_shash_tfm_digest()
      ecryptfs: use crypto_shash_tfm_digest()
      nfsd: use crypto_shash_tfm_digest()
      ubifs: use crypto_shash_tfm_digest()
      Bluetooth: use crypto_shash_tfm_digest()
      sctp: use crypto_shash_tfm_digest()
      KEYS: encrypted: use crypto_shash_tfm_digest()
      ASoC: cros_ec_codec: use crypto_shash_tfm_digest()
      mptcp: use SHA256_BLOCK_SIZE, not SHA_MESSAGE_BYTES
      crypto: powerpc/sha1 - remove unused temporary workspace
      crypto: powerpc/sha1 - prefix the "sha1_" functions
      crypto: s390/sha1 - prefix the "sha1_" functions
      crypto: lib/sha1 - rename "sha" to "sha1"
      crypto: lib/sha1 - remove unnecessary includes of linux/cryptohash.h
      crypto: lib/sha1 - fold linux/cryptohash.h into crypto/sha.h

Etienne Carriere (2):
      crypto: stm32/hash - defer probe for reset controller
      crypto: stm32/hash - defer probe for dma device

Hadar Gat (7):
      dt-bindings: add device tree binding for Arm CryptoCell trng engine
      hwrng: cctrng - introduce Arm CryptoCell driver
      MAINTAINERS: add HG as cctrng maintainer
      hwrng: cctrng - add missing include to linux/fips.h
      hwrng: cctrng - Add dependency on OF
      hwrng: cctrng - change default to n
      hwrng: cctrng - update help description

Hao Fang (1):
      crypto: hisilicon - add vfs_num module parameter for hpre/sec

Herbert Xu (4):
      crypto: api - Fix use-after-free and race in crypto_spawn_alg
      hwrng: cctrng - Add dependency on HAS_IOMEM
      hwrng: cctrng - Remove unnecessary FIPS ifdef
      Revert "ASoC: cros_ec_codec: use crypto_shash_tfm_digest()"

Hui Tang (2):
      crypto: hisilicon/hpre - add controller reset support for HPRE
      crypto: hisilicon/hpre - add debugfs for Hisilicon HPRE

Iuliana Prodan (4):
      crypto: algapi - create function to add request in front of queue
      crypto: engine - support for parallel requests based on retry mechanism
      crypto: engine - support for batch requests
      crypto: engine - do not requeue in case of fatal error

Kai Ye (1):
      crypto: hisilicon/sec2 - add debugfs for Hisilicon SEC

Lionel Debieve (1):
      crypto: stm32/hash - don't print error on probe deferral

Longfang Liu (6):
      crypto: hisilicon/sec2 - modify the SEC probe process
      crypto: hisilicon/hpre - modify the HPRE probe process
      crypto: hisilicon/zip - modify the ZIP probe process
      crypto: hisilicon/qm - add debugfs for QM
      crypto: hisilicon/qm - add debugfs to the QM state machine
      crypto: hisilicon/zip - add debugfs for Hisilicon ZIP

Mark Brown (1):
      crypto: arm64 - Consistently enable extension

Markus Elfring (3):
      hwrng: omap - Delete an error message in of_get_omap_rng_device_details()
      hwrng: xgene - Delete an error message in xgene_rng_probe()
      crypto: sun8i-ss - Delete an error message in sun8i_ss_probe()

Nathan Chancellor (1):
      lib/mpi: Fix 64-bit MIPS build with Clang

Nicolas Toromanoff (5):
      crypto: stm32/crc32 - fix ext4 chksum BUG_ON()
      crypto: stm32/crc32 - fix run-time self test issue.
      crypto: stm32/crc32 - fix multi-instance
      crypto: stm32/crc32 - don't sleep in runtime pm
      crypto: stm32/crc32 - protect from concurrent accesses

Rikard Falkeborn (4):
      crypto: ccree - constify struct debugfs_reg32
      crypto: hisilicon/hpre - constify struct debugfs_reg32
      crypto: hisilicon/zip - constify struct debugfs_reg32
      crypto: hisilicon/sec2 - constify sec_dfx_regs

Shukun Tan (12):
      crypto: hisilicon - put vfs_num into struct hisi_qm
      crypto: hisilicon - unify SR-IOV related codes into QM
      crypto: hisilicon/qm - add controller reset interface
      crypto: hisilicon/zip - add controller reset support for zip
      crypto: hisilicon/qm - fix build failure with ACPI off
      crypto: hisilicon - refactor module parameter pf_q_num related code
      crypto: hisilicon - add FLR support
      crypto: hisilicon - remove use_dma_api related codes
      crypto: hisilicon - remove codes of directly report device errors through MSI
      crypto: hisilicon - add device error report through abnormal irq
      crypto: hisilicon/qm - add DebugFS for xQC and xQE dump
      crypto: hisilicon/qm - change debugfs file name from qm_regs to regs

Stephan Müller (2):
      crypto: jitter - SP800-90B compliance
      crypto: drbg - always seeded with SP800-90B compliant noise source

Stephen Rothwell (1):
      crypto: hisilicon/qm - add more ACPI dependencies

Tang Bin (5):
      crypto: amlogic - Delete duplicate dev_err in meson_crypto_probe()
      crypto: bcm - Delete redundant variable definition
      crypto: bcm - Remove the unnecessary cast for PTR_ERR().
      crypto: bcm - Fix unused assignment
      crypto: bcm - Use the defined variable to clean code

Tom Lendacky (1):
      crypto: ccp - Add support for SEV-ES to the PSP driver

Wei Yongjun (1):
      crypto: drbg - fix error return code in drbg_alloc_state()

Weili Qian (3):
      crypto: hisilicon - unify initial value assignment into QM
      crypto: hisilicon - QM memory management optimization
      crypto: hisilicon - fix driver compatibility issue with different versions of devices

Yang Shen (2):
      crypto: hisilicon/sec2 - add controller reset support for SEC2
      crypto: hisilicon/qm - stop qp by judging sq and cq tail

Zhou Wang (2):
      crypto: hisilicon/qm - add state machine for QM
      crypto: hisilicon/zip - Use temporary sqe when doing work

Zou Wei (2):
      crypto: hisilicon/qm - Make qm_controller_reset() static
      hwrng: cctrng - Make some symbols static

 Documentation/ABI/testing/debugfs-hisi-hpre           |   89 +++-
 Documentation/ABI/testing/debugfs-hisi-sec            |   94 +++-
 Documentation/ABI/testing/debugfs-hisi-zip            |   70 ++-
 Documentation/devicetree/bindings/rng/arm-cctrng.yaml |   54 +++
 Documentation/security/siphash.rst                    |    2 +-
 MAINTAINERS                                           |    9 +
 arch/arm/crypto/sha1_glue.c                           |    1 -
 arch/arm/crypto/sha1_neon_glue.c                      |    1 -
 arch/arm/crypto/sha256_glue.c                         |    1 -
 arch/arm/crypto/sha256_neon_glue.c                    |    1 -
 arch/arm/kernel/armksyms.c                            |    1 -
 arch/arm64/crypto/aes-glue.c                          |    4 +-
 arch/arm64/crypto/crct10dif-ce-core.S                 |    2 +-
 arch/arm64/crypto/sha256-glue.c                       |    1 -
 arch/arm64/crypto/sha512-glue.c                       |    1 -
 arch/microblaze/kernel/microblaze_ksyms.c             |    1 -
 arch/mips/cavium-octeon/crypto/octeon-md5.c           |    1 -
 arch/powerpc/crypto/md5-glue.c                        |    1 -
 arch/powerpc/crypto/sha1-spe-glue.c                   |    1 -
 arch/powerpc/crypto/sha1.c                            |   33 +-
 arch/powerpc/crypto/sha256-spe-glue.c                 |    1 -
 arch/s390/crypto/sha1_s390.c                          |   12 +-
 arch/sparc/crypto/md5_glue.c                          |    1 -
 arch/sparc/crypto/sha1_glue.c                         |    1 -
 arch/sparc/crypto/sha256_glue.c                       |    1 -
 arch/sparc/crypto/sha512_glue.c                       |    1 -
 arch/unicore32/kernel/ksyms.c                         |    1 -
 arch/x86/crypto/sha1_ssse3_glue.c                     |    1 -
 arch/x86/crypto/sha256_ssse3_glue.c                   |    1 -
 arch/x86/crypto/sha512_ssse3_glue.c                   |    1 -
 crypto/Kconfig                                        |    3 +-
 crypto/algapi.c                                       |   32 +-
 crypto/algif_rng.c                                    |    2 +-
 crypto/api.c                                          |    3 +-
 crypto/blake2b_generic.c                              |    4 +-
 crypto/crypto_engine.c                                |  168 +++++--
 crypto/drbg.c                                         |   30 +-
 crypto/essiv.c                                        |    4 +-
 crypto/internal.h                                     |    1 +
 crypto/jitterentropy-kcapi.c                          |   27 ++
 crypto/jitterentropy.c                                |  417 +++++++++++++----
 crypto/lrw.c                                          |    6 +-
 crypto/sha1_generic.c                                 |    5 +-
 crypto/sha256_generic.c                               |   14 +-
 crypto/shash.c                                        |   16 +
 crypto/xts.c                                          |    6 +-
 drivers/char/hw_random/Kconfig                        |   13 +
 drivers/char/hw_random/Makefile                       |    1 +
 drivers/char/hw_random/cctrng.c                       |  735 ++++++++++++++++++++++++++++++
 drivers/char/hw_random/cctrng.h                       |   72 +++
 drivers/char/hw_random/omap-rng.c                     |    5 +-
 drivers/char/hw_random/optee-rng.c                    |    2 +-
 drivers/char/hw_random/xgene-rng.c                    |    4 +-
 drivers/char/random.c                                 |    8 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c     |    4 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c             |    4 +-
 drivers/crypto/atmel-sha.c                            |    1 -
 drivers/crypto/axis/artpec6_crypto.c                  |   10 +-
 drivers/crypto/bcm/cipher.c                           |   27 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c            |    2 +-
 drivers/crypto/ccp/Kconfig                            |    3 +-
 drivers/crypto/ccp/ccp-crypto-sha.c                   |    9 +-
 drivers/crypto/ccp/sev-dev.c                          |   43 ++
 drivers/crypto/ccree/cc_cipher.c                      |    9 +-
 drivers/crypto/ccree/cc_debugfs.c                     |    4 +-
 drivers/crypto/chelsio/chcr_algo.c                    |    3 +-
 drivers/crypto/chelsio/chcr_ipsec.c                   |    1 -
 drivers/crypto/hisilicon/Kconfig                      |    4 +
 drivers/crypto/hisilicon/hpre/hpre.h                  |   18 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c           |   99 +++-
 drivers/crypto/hisilicon/hpre/hpre_main.c             |  355 +++++++--------
 drivers/crypto/hisilicon/qm.c                         | 3769 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------
 drivers/crypto/hisilicon/qm.h                         |  120 ++++-
 drivers/crypto/hisilicon/sec2/sec.h                   |    5 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c            |   20 +-
 drivers/crypto/hisilicon/sec2/sec_main.c              |  379 ++++++---------
 drivers/crypto/hisilicon/zip/zip.h                    |    8 +
 drivers/crypto/hisilicon/zip/zip_crypto.c             |   20 +-
 drivers/crypto/hisilicon/zip/zip_main.c               |  362 +++++++--------
 drivers/crypto/marvell/octeontx/otx_cptpf_main.c      |    4 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_mbox.c      |   12 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c     |   95 ++--
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c      |    6 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c      |   12 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c    |   10 +-
 drivers/crypto/mediatek/mtk-sha.c                     |    7 +-
 drivers/crypto/n2_core.c                              |    7 +-
 drivers/crypto/omap-sham.c                            |   21 +-
 drivers/crypto/s5p-sss.c                              |   39 +-
 drivers/crypto/stm32/stm32-crc32.c                    |  230 +++++++---
 drivers/crypto/stm32/stm32-hash.c                     |   38 +-
 drivers/nfc/s3fwrn5/firmware.c                        |   10 +-
 fs/crypto/fname.c                                     |    7 +-
 fs/crypto/hkdf.c                                      |    6 +-
 fs/ecryptfs/crypto.c                                  |   17 +-
 fs/f2fs/hash.c                                        |    1 -
 fs/nfsd/nfs4recover.c                                 |   26 +-
 fs/ubifs/auth.c                                       |   20 +-
 fs/ubifs/master.c                                     |    9 +-
 fs/ubifs/replay.c                                     |   14 +-
 include/crypto/acompress.h                            |    2 +-
 include/crypto/algapi.h                               |    2 +
 include/crypto/drbg.h                                 |    6 +-
 include/crypto/engine.h                               |   15 +-
 include/crypto/hash.h                                 |   19 +
 include/crypto/sha.h                                  |   28 +-
 include/crypto/sha256_base.h                          |    6 +-
 include/linux/cryptohash.h                            |   14 -
 include/linux/filter.h                                |    4 +-
 include/linux/padata.h                                |    6 +-
 include/linux/psp-sev.h                               |    2 +
 include/net/tcp.h                                     |    1 -
 include/uapi/linux/psp-sev.h                          |    2 +
 kernel/bpf/core.c                                     |   18 +-
 kernel/padata.c                                       |   14 +-
 lib/crypto/chacha.c                                   |    1 -
 lib/crypto/sha256.c                                   |   20 +-
 lib/mpi/longlong.h                                    |    2 +-
 lib/sha1.c                                            |   24 +-
 net/bluetooth/smp.c                                   |    6 +-
 net/core/secure_seq.c                                 |    1 -
 net/ipv6/addrconf.c                                   |   10 +-
 net/ipv6/seg6_hmac.c                                  |    1 -
 net/mptcp/crypto.c                                    |    4 +-
 net/sctp/auth.c                                       |   10 +-
 net/sctp/sm_make_chunk.c                              |   23 +-
 security/keys/encrypted-keys/encrypted.c              |   18 +-
 127 files changed, 5634 insertions(+), 2462 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/arm-cctrng.yaml
 create mode 100644 drivers/char/hw_random/cctrng.c
 create mode 100644 drivers/char/hw_random/cctrng.h
 delete mode 100644 include/linux/cryptohash.h

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
