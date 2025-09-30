Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336E02F6181;
	Tue, 30 Sep 2025 09:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759225260; cv=none; b=R57ABdp33aHuYucNwv6nMQmiiFMkqzAiO0mQmoCnAfegAbQJL43mIoEqzr6K0xdHP9bESBeVqxo2dG7EJlk3W/cmf0v46KPkIqH1GFS2S9FJY7fl2GBGrYc0FBMyS1n/S9IRAG7mr+ZrewJFzW8jSHj0H/WgxAHjNpAAAfkh5N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759225260; c=relaxed/simple;
	bh=b7g7RSLzy7kFzm44PB9WdugyZqlBSDqpyCcGJOAYX3U=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ul8fr3UYxtSiS4IFdnWPNu9fELkbwB21E+PGwQOEXs+C5Ml3ew0OJI7lWWRi10C7Qy07h3gY3p/tafYTFNw92Brn6npVcQACtwZsjr9KoCstmCkINVMVKuNk4F3Ajhnah4CGPL1zjwfDEXkVfTWATk/xXOTHifGU71eljOclLxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EhPCB8dn; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EhPCB8dn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=MIME-Version:Message-ID:Subject:To:From:Date:cc:to:subject:
	message-id:date:from:in-reply-to:references:reply-to;
	bh=iVCaX1h7yN0LNDSuboANUoMrHK/lziH1ljvIM40VJyI=; b=EhPCB8dnYscgHzv3+0ENcOI2gO
	5hi/FOnoxYFpkQYKNAgEUQq1BdXrohWh2WVsSoznuKChk7JKAoNrfVcEHROIz1lo0fnAn5iJKjKNK
	aGcMGba7f+wfr1/cWMmkwpac2UsY8famfaFZ4EWlZWXT4BhlT8l5kPsf1vTksBE6AbtTrPhRdss3J
	xgz9SzhBh2FRSHytAYorSgv2n2dR/HVTLdQQK6ih0OxmY4cUCzqJHDA5OCUU87d7kH/QA+7eViczk
	WSZbnrwG6Zm4PwiK5+NwQRQqhuImsGZhBSPyGp7ctKMWUuJ1myBTFxg67K5AwwVfdMOQMMIj/tGnr
	WnPrMARA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v3Wql-009Pak-11;
	Tue, 30 Sep 2025 17:40:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 30 Sep 2025 17:40:47 +0800
Date: Tue, 30 Sep 2025 17:40:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 6.18
Message-ID: <aNuln6SQ_VIISMPi@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 8f5ae30d69d7543eee0d70083daf4de8fe15d585:

  Linux 6.17-rc1 (2025-08-10 19:41:16 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p1

for you to fetch changes up to 166c83f7789ed02dc1f25bc7bed4a1beb25343aa:

  dt-bindings: rng: hisi-rng: convert to DT schema (2025-09-28 11:54:48 +0800)

----------------------------------------------------------------
This update includes the following changes:

Drivers:

- Add ciphertext hiding support to ccp.
- Add hashjoin, gather and UDMA data move features to hisilicon.
- Add lz4 and lz77_only to hisilicon.
- Add xilinx hwrng driver.
- Add ti driver with ecb/cbc aes support.
- Add ring buffer idle and command queue telemetry for GEN6 in qat.

Others:

- Use rcu_dereference_all to stop false alarms in rhashtable.
- Fix CPU number wraparound in padata.
----------------------------------------------------------------

Arnd Bergmann (1):
      hwrng: nomadik - add ARM_AMBA dependency

Ashish Kalra (5):
      crypto: ccp - New bit-field definitions for SNP_PLATFORM_STATUS command
      crypto: ccp - Cache SEV platform status and platform state
      crypto: ccp - Add support for SNP_FEATURE_INFO command
      crypto: ccp - Introduce new API interface to indicate SEV-SNP Ciphertext hiding feature
      crypto: ccp - Add support to enable CipherTextHiding on SNP_INIT_EX

Bagas Sanjaya (1):
      crypto: doc - Add explicit title heading to API docs

Chenghai Huang (5):
      crypto: hisilicon/zip - remove unnecessary validation for high-performance mode configurations
      crypto: hisilicon - re-enable address prefetch after device resuming
      crypto: hisilicon/zip - enable literal length in stream mode compression
      crypto: hisilicon/zip - add lz4 and lz77_only to algorithm sysfs
      crypto: hisilicon/qm - set NULL to qm->debug.qm_diff_regs

Colin Ian King (1):
      crypto: stm32 - Fix spelling mistake "STMicrolectronics" -> "STMicroelectronics"

Dan Moulding (1):
      crypto: comp - Use same definition of context alloc and free ops

David Sterba (1):
      lib/lzo: add unlikely hints to overrun checks

Edward Adam Davis (1):
      crypto: jitter - Mark intermediary memory as clean

Eric Biggers (3):
      crypto: arm64/aes - use SHA-256 library instead of crypto_shash
      crypto: qat - Use library to prepare HMAC keys
      crypto: chelsio - Use library to prepare HMAC keys

Fan Wu (1):
      KEYS: X.509: Fix Basic Constraints CA flag parsing

Gaurav Jain (1):
      crypto: caam - double the entropy delay interval for retry

Harsh Jain (1):
      crypto: xilinx - Add TRNG driver for Versal

Herbert Xu (5):
      crypto: hash - Make HASH_MAX_DESCSIZE a bit more obvious
      crypto: hisilicon/sec2 - Fix false-positive warning of uninitialised qp_ctx
      crypto: ti - Enable compile testing for dthev2
      rhashtable: Use rcu_dereference_all and rcu_dereference_all_check
      crypto: qat - Return pointer directly in adf_ctl_alloc_resources

Kael D'Alcamo (1):
      dt-bindings: rng: hisi-rng: convert to DT schema

Liao Yuanhong (3):
      crypto: jh7110 - Remove the use of dev_err_probe()
      crypto: tegra - Remove the use of dev_err_probe()
      hwrng: cn10k - Remove the use of dev_err_probe()

Marco Crivellari (3):
      crypto: cryptd - WQ_PERCPU added to alloc_workqueue users
      padata: replace use of system_unbound_wq with system_dfl_wq
      padata: WQ_PERCPU added to alloc_workqueue users

Menglong Dong (1):
      rhashtable: Use __always_inline instead of inline

Michael Roth (1):
      crypto: ccp - Fix checks for SNP_VLEK_LOAD input buffer length

Mounika Botcha (1):
      dt-bindings: crypto: Add node for True Random Number Generator

Nishanth Menon (1):
      hwrng: ks-sa - fix division by zero in ks_sa_rng_init

Ovidiu Panait (9):
      crypto: sun8i-ce - remove channel timeout field
      crypto: sun8i-ce - remove boilerplate in sun8i_ce_hash_digest()
      crypto: sun8i-ce - remove unnecessary __maybe_unused annotations
      crypto: sun8i-ce - add a new function for dumping task descriptors
      crypto: sun8i-ce - move bounce_iv and backup_iv to request context
      crypto: sun8i-ce - fold sun8i_ce_cipher_run() into sun8i_ce_cipher_do_one()
      crypto: sun8i-ce - pass task descriptor to cipher prepare/unprepare
      crypto: sun8i-ce - save hash buffers and dma info to request context
      crytpo: sun8i-ce - factor out prepare/unprepare from sun8i_ce_hash_run()

Qianfeng Rong (6):
      crypto: ccp - Remove redundant __GFP_ZERO
      crypto: qat - use kcalloc() in qat_uclo_map_objs_from_mof()
      crypto: hisilicon - use kcalloc() instead of kzalloc()
      crypto: ccp - Use int type to store negative error codes
      crypto: hisilicon/sec - Use int type to store negative error codes
      crypto: tegra - Use int type to store negative error codes

Ryo Takakura (1):
      crypto: omap - convert from tasklet to BH workqueue

T Pratham (2):
      dt-bindings: crypto: Add binding for TI DTHE V2
      crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)

Thomas Fourier (4):
      crypto: keembay - Add missing check after sg_nents_for_len()
      crypto: rockchip - Fix dma_unmap_sg() nents value
      crypto: atmel - Fix dma_unmap_sg() direction
      crypto: aspeed - Fix dma_unmap_sg() direction

Thorsten Blum (3):
      crypto: octeontx2 - Call strscpy() with correct size argument
      crypto: qat - Replace kzalloc() + copy_from_user() with memdup_user()
      crypto: anubis - simplify return statement in anubis_mod_init

Vijay Sundar Selvamani (2):
      crypto: qat - add ring buffer idle telemetry counter for GEN6
      crypto: qat - add command queue telemetry counters for GEN6

Weili Qian (6):
      crypto: hisilicon - check the sva module status while enabling or disabling address prefetch
      crypto: hisilicon/qm - request reserved interrupt for virtual function
      crypto: hisilicon/qm - invalidate queues in use
      crypto: hisilicon/qm - mask axi error before memory init
      crypto: hisilicon - enable error reporting again
      crypto: hisilicon/qm - clear all VF configurations in the hardware

Xiao Liang (1):
      padata: Reset next CPU when reorder sequence wraps around

Xichao Zhao (1):
      hwrng: timeriomem - Use us_to_ktime() where appropriate

Yunseong Kim (2):
      crypto: ccp - Fix typo in psp_populate_hsti function name
      crypto: ccp - Fix incorrect payload size calculation in psp_poulate_hsti()

Zhang Enpei (1):
      crypto: caam - switch to use devm_kmemdup_array()

Zhushuai Yin (2):
      crypto: hisilicon/qm - check whether the input function and PF are on the same device
      crypto: hisilicon/zip - add hashjoin, gather, and UDMA data move features

 .../ABI/testing/debugfs-driver-qat_telemetry       |  27 ++
 Documentation/crypto/api-aead.rst                  |   3 +
 Documentation/crypto/api-akcipher.rst              |   3 +
 Documentation/crypto/api-digest.rst                |   3 +
 Documentation/crypto/api-kpp.rst                   |   3 +
 Documentation/crypto/api-rng.rst                   |   3 +
 Documentation/crypto/api-sig.rst                   |   3 +
 Documentation/crypto/api-skcipher.rst              |   3 +
 .../bindings/crypto/ti,am62l-dthev2.yaml           |  50 +++
 .../bindings/crypto/xlnx,versal-trng.yaml          |  35 ++
 Documentation/devicetree/bindings/rng/hisi-rng.txt |  12 -
 .../devicetree/bindings/rng/hisi-rng.yaml          |  32 ++
 MAINTAINERS                                        |  13 +
 arch/arm64/crypto/Kconfig                          |   1 +
 arch/arm64/crypto/aes-glue.c                       |  21 +-
 arch/s390/crypto/sha.h                             |   8 +-
 crypto/842.c                                       |   6 +-
 crypto/anubis.c                                    |   5 +-
 crypto/asymmetric_keys/x509_cert_parser.c          |  16 +-
 crypto/cryptd.c                                    |   3 +-
 crypto/jitterentropy-kcapi.c                       |   1 +
 crypto/lz4.c                                       |   6 +-
 crypto/lz4hc.c                                     |   6 +-
 crypto/lzo-rle.c                                   |   6 +-
 crypto/lzo.c                                       |   6 +-
 drivers/char/hw_random/Kconfig                     |   1 +
 drivers/char/hw_random/cn10k-rng.c                 |   2 +-
 drivers/char/hw_random/ks-sa-rng.c                 |   4 +
 drivers/char/hw_random/timeriomem-rng.c            |   2 +-
 drivers/crypto/Kconfig                             |  13 +
 drivers/crypto/Makefile                            |   1 +
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |  85 ++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |  35 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c  | 147 ++++----
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c  |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c  |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |  27 +-
 drivers/crypto/aspeed/aspeed-hace-crypto.c         |   2 +-
 drivers/crypto/atmel-tdes.c                        |   2 +-
 drivers/crypto/caam/ctrl.c                         |  10 +-
 drivers/crypto/ccp/hsti.c                          |   8 +-
 drivers/crypto/ccp/sev-dev.c                       | 131 ++++++-
 drivers/crypto/ccp/sev-dev.h                       |   6 +-
 drivers/crypto/chelsio/Kconfig                     |   6 +-
 drivers/crypto/chelsio/chcr_algo.c                 | 255 +++----------
 drivers/crypto/chelsio/chcr_crypto.h               |   1 -
 drivers/crypto/hisilicon/debugfs.c                 |   1 +
 drivers/crypto/hisilicon/hpre/hpre_main.c          | 199 +++++++---
 drivers/crypto/hisilicon/qm.c                      | 218 ++++++++---
 drivers/crypto/hisilicon/sec/sec_drv.c             |   3 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |   8 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           | 229 ++++++++----
 drivers/crypto/hisilicon/zip/dae_main.c            |  19 +-
 drivers/crypto/hisilicon/zip/zip_main.c            | 242 ++++++++----
 .../crypto/intel/keembay/keembay-ocs-hcu-core.c    |   5 +-
 drivers/crypto/intel/qat/Kconfig                   |   7 +-
 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c  |  40 +-
 drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c  | 112 ++++++
 .../crypto/intel/qat/qat_common/adf_telemetry.c    |  19 +
 .../crypto/intel/qat/qat_common/adf_telemetry.h    |   5 +
 .../crypto/intel/qat/qat_common/adf_tl_debugfs.c   |  52 +++
 .../crypto/intel/qat/qat_common/adf_tl_debugfs.h   |   5 +
 drivers/crypto/intel/qat/qat_common/qat_algs.c     | 195 +++-------
 drivers/crypto/intel/qat/qat_common/qat_uclo.c     |   2 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |   2 +-
 drivers/crypto/nx/nx-common-powernv.c              |   6 +-
 drivers/crypto/nx/nx-common-pseries.c              |   6 +-
 drivers/crypto/omap-aes.c                          |  15 +-
 drivers/crypto/omap-aes.h                          |   2 +-
 drivers/crypto/omap-des.c                          |  17 +-
 drivers/crypto/omap-sham.c                         |  15 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |   2 +-
 drivers/crypto/starfive/jh7110-aes.c               |  12 +-
 drivers/crypto/starfive/jh7110-hash.c              |   3 +-
 drivers/crypto/stm32/stm32-cryp.c                  |   2 +-
 drivers/crypto/tegra/tegra-se-hash.c               |   3 +-
 drivers/crypto/tegra/tegra-se-main.c               |   2 +-
 drivers/crypto/ti/Kconfig                          |  14 +
 drivers/crypto/ti/Makefile                         |   3 +
 drivers/crypto/ti/dthev2-aes.c                     | 411 +++++++++++++++++++++
 drivers/crypto/ti/dthev2-common.c                  | 217 +++++++++++
 drivers/crypto/ti/dthev2-common.h                  | 101 +++++
 drivers/crypto/xilinx/Makefile                     |   1 +
 drivers/crypto/xilinx/xilinx-trng.c                | 405 ++++++++++++++++++++
 include/crypto/hash.h                              |  16 +-
 include/crypto/internal/scompress.h                |  11 +-
 include/linux/hisi_acc_qm.h                        |  22 +-
 include/linux/psp-sev.h                            |  44 ++-
 include/linux/rcupdate.h                           |  26 ++
 include/linux/rhashtable.h                         |  56 +--
 include/uapi/linux/psp-sev.h                       |  10 +-
 include/uapi/misc/uacce/hisi_qm.h                  |   1 +
 kernel/padata.c                                    |  15 +-
 lib/lzo/lzo1x_compress.c                           |   2 +-
 lib/lzo/lzo1x_decompress_safe.c                    |   6 +-
 95 files changed, 2865 insertions(+), 959 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
 delete mode 100644 Documentation/devicetree/bindings/rng/hisi-rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/hisi-rng.yaml
 create mode 100644 drivers/crypto/ti/Kconfig
 create mode 100644 drivers/crypto/ti/Makefile
 create mode 100644 drivers/crypto/ti/dthev2-aes.c
 create mode 100644 drivers/crypto/ti/dthev2-common.c
 create mode 100644 drivers/crypto/ti/dthev2-common.h
 create mode 100644 drivers/crypto/xilinx/xilinx-trng.c

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
