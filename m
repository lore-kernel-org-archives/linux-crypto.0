Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5313BC696;
	Mon, 19 Oct 2026 06:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792391040; cv=none; b=Fh7ciOifN2Gyay85k8ptIeyqRHOe9y9820j9masneBjMN4vAaKcVCs+UEzu8VUh5WRzl8vn6XPro5ESuK1MdynMxWAlg8A9zUY4TWabqVw1fDIJFOLtlHbOoGyElAYD74g/06VHw8RgFsrsUyy2QzwAHwsGCebYciDnGzeD1Gs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792391040; c=relaxed/simple;
	bh=9XrnQKPZSPqB7eXHg/kwk/B+gxPSkOhwLy9TY25GiUo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BDSA05TaSCn+G/Hgx2/MwaWolmdROYtfJconB8NK2NEQ/tVdahzUlVJzYmtoUUdJN04CZZXVKrb6Z0fB+v0qbwuYQCK86/pLduO+TaNERU3gelCDY7WYVS5JrapKaCxQkKzBKl24vEd6B+Q3gIsa4Zpt34fgysH/SlHnL167POY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NrGU+Hbi; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NrGU+Hbi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=yz08XnZ7oNF/TvIAmzM/+7u5UPPYYurXZoeRgzOXDGY=; b=NrGU+
	HbiXuvYlyNDPZNv1xJEx29l7VRXa+Rjrn7l9B5vtjATf098HohdSV1zpo2j2F6BYF1p8ZepNi9NUm
	vcT9ZmcRT0I38/HA6EILuSVRYIcvvoE4AQMNaXyyb/nlRpM6IsHEVh/4ZD8cunXA1i4vMehkmKrYg
	MLwB4xCeqTglbvBk690sg/KcTCoBzrAZXmj0F0cXj+nIh2G4sq/6zGKSlgYcQQWgODZnJjjqFLs+j
	U2sIp7cAIhlUEYa7cu1fSXugbTeavHRrFWqPOU53KX5In+O+KwQnqHGQm+PZjsfw1elioSfm09NJl
	seR6zXWMvX+L2YMuHvfLYWNpyLi7A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xIgmj-00000005Flb-2Wbg;
	Mon, 19 Oct 2026 14:23:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 Oct 2026 14:23:49 +0800
Date: Mon, 19 Oct 2026 14:23:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 7.4
Message-ID: <atW3dd8TntKt9hj4@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Linus:

The following changes since commit 60892a384aa1e65d0e703e1c513417bdf0c80777:

  crypto: x86/aria - add missing vzeroupper in AVX-512 code (2026-09-04 18:45:51 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.4-p1

for you to fetch changes up to 178aff4cf425b3fc51ff09c571fa1bfbc1eb8ea4:

  crypto: atmel-tdes - consolidate error paths in atmel_tdes_dma_init() (2026-10-16 20:24:33 +0800)

----------------------------------------------------------------
This update includes the following changes:

API:

- Fix algif_skcipher source SG overrun.
- Allow hmac(sha512) for non-root users.

Algorithms:

- Add wrapper for zeroing AES key context.
- Avoid redundant stream initialisations in zstd.

Drivers:

- Remove hisilicon/sec.
- Handle digest-only authenc requests in atmel.
- Handle zero-length skcipher requests in mxs-dcp.
- Lower the default priority of caam/qi2.

Others:

- Optimise key comparison in rhashtable lookup that uses constant parameters.
----------------------------------------------------------------

Abel Vesa (1):
      MAINTAINERS: Add Qualcomm Inline Crypto Engine entry

Ahsan Atta (8):
      crypto: qat - avoid OOB read when stripping RSA leading zeros
      crypto: qat - release instance on DH fallback allocation failure
      crypto: qat - fix active_devs leak on crypto alg registration failure
      crypto: qat - hold cfg->lock when accessing config sections
      crypto: qat - avoid redundant config list walks when adding a key
      crypto: qat - remove unused get_num_accels()
      crypto: qat - initialise state_lock on every path in adf_devmgr_add_dev()
      crypto: qat - fix use of destroyed vf2pf_lock on VF restart

Aldo Ariel Panzardo (1):
      crypto: nx - validate 'ignore' before subtracting in decompress

Aleksander Jan Bajkowski (1):
      crypto: eip93 - fix ssl mac bit field definition

Bill Wendling (2):
      crypto: hisilicon/qm - annotate cap_tables with __counted_by_ptr
      crypto: hisilicon/qm - add __counted_by_ptr to dfx_diff_registers

Chenghai Huang (1):
      crypto: hisilicon/sec - remove SEC crypto block cipher accelerator

Daehyeon Ko (1):
      crypto: algif_skcipher - rewind rounded output bytes

Dave Hansen (1):
      crypto: keembay - Remove bouncing maintainer

David C.C.M. Gall (3):
      crypto: octeontx2 - use crypto_memneq() to check HMAC for cipher_null authenc
      crypto: octeontx - use crypto_memneq() to check HMAC
      crypto: ccree - use crypto_memneq() to compare AEAD tag

Eric Biggers (2):
      crypto: sa2ul - Fix HMAC key preparation
      crypto: sa2ul - Remove unused fields

Fabrice Derepas (2):
      crypto: asymmetric_keys - fix OOB read in pefile_parse_binary
      crypto: asymmetric_keys - add KUnit tests for the PE parser

George Abraham P (1):
      crypto: qat - force an edge when re-enabling all VF2PF interrupts

Guangshuo Li (2):
      crypto: omap-des - fix crypto engine cleanup
      crypto: omap-sham - fix crypto engine cleanup

Hemanth Selam (2):
      crypto: drivers - fix typos in comments
      padata: fix typo "dependend" in comment

Herbert Xu (3):
      rhashtable: Use separate lockdep keys for each lock
      crypto: api - Fix DUP_FIRST crash on unregister
      crypto: tcrypt - Avoid reading req->base after submission

Jean-Michel Hautbois (1):
      hwrng: imx-rngc - Use optional clock

Jiale Yao (2):
      crypto: ccp - kill v3 IRQ tasklet during teardown
      crypto: ccp - kill v5 IRQ tasklet during teardown

Jiawen Liu (1):
      crypto: starfive - handle clock enable failures

Justin M. Forbes (1):
      crypto: algif_hash - Allow hmac(sha512) for unpriviledged users

Jérémy Jean (5):
      crypto: rsassa-pkcs1 - reject undersized keys when signing
      crypto: rsassa-pkcs1 - reject undersized keys when verifying
      crypto: asymmetric_keys/x509 - copy X.509 TBS for data signature algorithms
      crypto: asymmetric_keys/pkcs7 - Check all signers before waiving authattrs rejection
      crypto: ecc - Handle exceptional points in Shamir multiplication

Karl Mehltretter (10):
      crypto: atmel-tdes - zero-initialize device state
      crypto: atmel-aes - fix AADLENR for standalone GHASH
      lib/842: reject output overflows from index and short data
      lib/842: require a complete history block for repeat templates
      lib/842: add KUnit tests for the decompressor
      crypto: lskcipher - preserve state across unaligned chunks
      crypto: atmel-tdes - sync output bounce buffer before DMA
      lib/842: depend on the decompressor for KUnit tests
      crypto: qat - zero the VF migration state buffer on save
      crypto: atmel - handle authenc requests without plaintext

Li Youhong (1):
      hwrng: imx-rngc - check clk_prepare_enable() return value

Linmao Li (1):
      crypto: mxs-dcp - handle zero-length skcipher requests

Mohamad Raizudeen (3):
      crypto: amlogic - Fix DMA memory leak in cipher error path
      crypto: amlogic - Use devm APIs for clock management
      crypto: amlogic - Fix IRQ handler return value and fallthrough logic

Muhammad Bilal (1):
      crypto: ccp - fix SFS ioctl race against device teardown

NeilBrown (1):
      rhashtable: use private lockdep class for all locks.

Nitesh Venkatesh (2):
      crypto: qat - allow KPT disable when service is not asym
      Documentation: qat: clarify KPT enable device-state requirement

Pawel Zalewski (The Capable Hub) (1):
      crypto: ccp - use named initializers for acpi_device_id

Pengpeng Hou (2):
      hwrng: starfive - propagate clock and reset errors
      crypto: starfive - propagate clock and reset errors

Randy Dunlap (2):
      crypto: ccp - repair all kernel-doc comments
      crypto: ccp - Clean up kernel-doc warnings in psp-sev.h

Rosen Penev (7):
      crypto: crypto4xx - get irq and ioremap resource first
      crypto: s5p-sss - pass s5p_aes_dev to irq handler
      crypto: rockchip - pass crypto_info to irq handler
      crypto: crypto4xx - pass core_dev to request_irq
      crypto: talitos - pass talitos_private to irq handlers
      crypto: crypto4xx - use int for ppc4xx_trng_probe()
      crypto: talitos - init tasklets before requesting IRQs

Runyu Xiao (1):
      crypto: ccp - Initialize DBC ioctl mutex before registering device

Ruoyu Wang (1):
      hwrng: cctrng - Fix runtime PM usage counter leak

Sahil Malhotra (1):
      MAINTAINERS: update caam crypto driver maintainers list

Slavin Liu (1):
      crypto: atmel-sha - reject initialization without a device

Suman Kumar Chakraborty (1):
      crypto: qat - fix error source for QAT GEN6 transmit interface faults

Thomas Huth (11):
      crypto: Provide a wrapper function for zeroizing crypto_aes_ctx
      crypto: aspeed - clear the crypto_aes_ctx when done
      crypto: padlock-aes - clear the crypto_aes_ctx when done
      crypto: sa2ul - clear the crypto_aes_ctx when done
      crypto: arm/aes-neonbs - clear the crypto_aes_ctx when done
      crypto: arm64/aes-neonbs - clear the crypto_aes_ctx when done
      crypto: qat - zeroize crypto_aes_ctx with __cleanup(aes_zeroize_ctx)
      crypto: safexcel - Simplify the check for a valid AES key
      crypto: safexcel - zeroize crypto_aes_ctx with __cleanup(aes_zeroize_ctx)
      crypto: eip93 - Simplify the check for a valid AES key
      crypto: inside-secure - Zeroize temporary arrays on stack with sensitive data

Thorsten Blum (36):
      crypto: qce - simplify control flow in register functions
      dt-bindings: trivial-devices: add atmel,atecc608a
      crypto: atmel-ecc - add support for atecc608a
      crypto: atmel-ecc - simplify atmel_ecdh_compute_shared_secret
      crypto: atmel-tdes - simplify DMA buffer initialization
      crypto: zynqmp-sha - fix NULL pointer dereference in init_tfm
      crypto: xilinx - use kfree_sensitive() in cleanup paths
      crypto: xilinx - clear AES key buffer before freeing it
      crypto: powerpc/vmx - clean up includes, metadata, and p8_init()
      crypto: atmel-tdes - consolidate transfer setup
      crypto: cast5 - use memcpy_and_pad() in cast5_setkey()
      crypto: cast6 - use memcpy_and_pad() in __cast6_setkey()
      crypto: ixp4xx - use memcpy_and_pad() in register_chain_var()
      crypto: octeontx - use memcpy_and_pad() in aead_hmac_init()
      crypto: octeontx2 - use memcpy_and_pad() in aead_hmac_init()
      hwrng: intel - return -ENOMEM when kmalloc_obj() fails
      hwrng: intel - declare warning string as const
      hwrng: amd - report partial reads in non-blocking mode
      hwrng: ba431 - fix reported byte count
      hwrng: core - reject unknown RNG names
      hwrng: virtio - use min() in copy_data()
      hwrng: virtio - use snprintf() in probe_common()
      hwrng: intel - return -ENOMEM when ioremap() fails
      hwrng: atmel - use HZ_PER_MHZ in atmel_trng_init()
      hwrng: cctrng - drop redundant initializations
      hwrng: stm32 - use swap() in stm32_rng_probe()
      hwrng: stm32 - reuse clock rate in stm32_rng_clock_freq_restrain()
      hwrng: amd - simplify control flow in amd_rng_mod_init()
      hwrng: stm32 - drop redundant initializations
      hwrng: stm32 - use devm_platform_ioremap_resource() in stm32_rng_probe()
      hwrng: intel - simplify intel_rng_mod_init()
      hwrng: cctrng - simplify cctrng_probe()
      hwrng: amd - use PMBASE_OFFSET consistently
      crypto: atmel-tdes - use separate DMA scatterlists
      crypto: atmel-tdes - reuse fast in atmel_tdes_crypt_start()
      crypto: atmel-tdes - consolidate error paths in atmel_tdes_dma_init()

Triet Hoang (1):
      hwrng: omap - Convert to DEFINE_SIMPLE_DEV_PM_OPS()

Usama Arif (3):
      crypto: zstd - Avoid redundant cstream initialization
      crypto: zstd - Avoid redundant dstream initialization
      rhashtable: specialize default comparison for constant parameters

Vincent Jardin (3):
      crypto: caam/qi2 - reset the DPSECI at probe only when enabled
      crypto: caam/qi,qi2 - set plain_keylen for skcipher descriptors
      crypto: caam/qi2 - lower the algorithm priority

Weili Qian (7):
      crypto: hisilicon/hpre - fix pointer dereference before length check
      crypto: hisilicon/hpre - remove dma_free_coherent on NULL req->dst in ECDH
      crypto: hisilicon/hpre - return -EOVERFLOW for small ECDH output buffer
      crypto: hisilicon/hpre - fix ECDH destination DMA mapping
      crypto: hisilicon/hpre - fix GFP flags for dma_alloc_coherent
      crypto: hisilicon/hpre - extract clusters num into inline function
      crypto: hisilicon/hpre - remove unused macros and struct fields

Weiming Shi (1):
      asymmetric_keys: reject trust keys without IDs

Wolfram Sang (1):
      MAINTAINERS: delete entry for John Allen

ZhaoJinming (1):
      crypto: caam - fix double-free in caam_rsa_set_priv_key_form()

bui duc phuc (4):
      crypto: sun8i-ss - Use pm_runtime_resume_and_get()
      crypto: ccree - Use pm_runtime_resume_and_get()
      crypto: sl3516 - Use pm_runtime_resume_and_get()
      hwrng: omap3-rom - Use pm_runtime_resume_and_get()

lizhi (1):
      crypto: hisilicon/zip - enable auto clock gating for DAE

 Documentation/ABI/testing/sysfs-driver-qat_kpt     |    3 +-
 .../bindings/crypto/hisilicon,hip06-sec.yaml       |  134 --
 .../devicetree/bindings/trivial-devices.yaml       |    2 +
 MAINTAINERS                                        |   14 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |    2 +-
 arch/arm64/boot/dts/hisilicon/hip07.dtsi           |  280 -----
 arch/arm64/crypto/aes-neonbs-glue.c                |    2 +-
 arch/powerpc/crypto/vmx.c                          |   14 +-
 crypto/algapi.c                                    |   23 +-
 crypto/algif_hash.c                                |    2 +-
 crypto/algif_skcipher.c                            |    8 +-
 crypto/asymmetric_keys/Kconfig                     |   12 +
 crypto/asymmetric_keys/Makefile                    |    2 +
 crypto/asymmetric_keys/pkcs7_parser.c              |    6 +
 crypto/asymmetric_keys/restrict.c                  |    8 +-
 crypto/asymmetric_keys/verify_pefile.c             |    5 +
 crypto/asymmetric_keys/verify_pefile_test.c        |  100 ++
 crypto/asymmetric_keys/x509_public_key.c           |    6 +-
 crypto/cast5_generic.c                             |    4 +-
 crypto/cast6_generic.c                             |    3 +-
 crypto/ecc.c                                       |   33 +-
 crypto/lskcipher.c                                 |    6 +-
 crypto/rsassa-pkcs1.c                              |    4 +-
 crypto/tcrypt.c                                    |  182 +--
 crypto/testmgr.c                                   |   11 +-
 crypto/testmgr.h                                   |  327 ++++-
 crypto/zstd.c                                      |   40 +-
 drivers/char/hw_random/amd-rng.c                   |   29 +-
 drivers/char/hw_random/atmel-rng.c                 |   11 +-
 drivers/char/hw_random/ba431-rng.c                 |    2 +-
 drivers/char/hw_random/cctrng.c                    |   27 +-
 drivers/char/hw_random/core.c                      |    1 +
 drivers/char/hw_random/imx-rngc.c                  |   10 +-
 drivers/char/hw_random/intel-rng.c                 |   34 +-
 drivers/char/hw_random/jh7110-trng.c               |   39 +-
 drivers/char/hw_random/omap-rng.c                  |    8 +-
 drivers/char/hw_random/omap3-rom-rng.c             |    7 +-
 drivers/char/hw_random/stm32-rng.c                 |   22 +-
 drivers/char/hw_random/virtio-rng.c                |    6 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |    3 +-
 drivers/crypto/amcc/crypto4xx_core.c               |   35 +-
 drivers/crypto/amcc/crypto4xx_trng.c               |   15 +-
 drivers/crypto/amcc/crypto4xx_trng.h               |    6 +-
 drivers/crypto/amlogic/amlogic-gxl-cipher.c        |   25 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c          |   48 +-
 drivers/crypto/aspeed/aspeed-hace-crypto.c         |    3 +-
 drivers/crypto/atmel-aes.c                         |    4 +-
 drivers/crypto/atmel-ecc.c                         |   12 +-
 drivers/crypto/atmel-sha.c                         |   21 +-
 drivers/crypto/atmel-tdes.c                        |  114 +-
 drivers/crypto/caam/caamalg_qi.c                   |    2 +
 drivers/crypto/caam/caamalg_qi2.c                  |   19 +-
 drivers/crypto/caam/caampkc.c                      |    6 +
 drivers/crypto/cavium/cpt/cptpf_main.c             |   12 +-
 drivers/crypto/cavium/cpt/cptvf_main.c             |    4 +-
 drivers/crypto/cavium/cpt/cptvf_mbox.c             |    4 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c         |    2 +-
 drivers/crypto/ccp/ccp-dev-v3.c                    |    4 +
 drivers/crypto/ccp/ccp-dev-v5.c                    |    4 +
 drivers/crypto/ccp/ccp-dev.c                       |    2 +-
 drivers/crypto/ccp/dbc.c                           |    4 +-
 drivers/crypto/ccp/sfs.c                           |    9 +-
 drivers/crypto/ccp/sp-platform.c                   |    4 +-
 drivers/crypto/ccree/cc_aead.c                     |    4 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |    4 +-
 drivers/crypto/ccree/cc_pm.c                       |    8 +-
 drivers/crypto/chelsio/chcr_algo.c                 |    2 +-
 drivers/crypto/gemini/sl3516-ce-cipher.c           |    3 +-
 drivers/crypto/gemini/sl3516-ce-rng.c              |    6 +-
 drivers/crypto/hisilicon/Kconfig                   |   14 -
 drivers/crypto/hisilicon/Makefile                  |    1 -
 drivers/crypto/hisilicon/hpre/hpre.h               |    1 -
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |   28 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   49 +-
 drivers/crypto/hisilicon/qm.c                      |    2 +-
 drivers/crypto/hisilicon/sec/Makefile              |    3 -
 drivers/crypto/hisilicon/sec/sec_algs.c            | 1122 -----------------
 drivers/crypto/hisilicon/sec/sec_drv.c             | 1307 --------------------
 drivers/crypto/hisilicon/sec/sec_drv.h             |  428 -------
 drivers/crypto/hisilicon/sec2/sec_main.c           |    2 +-
 drivers/crypto/hisilicon/zip/dae_main.c            |   23 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |    2 +-
 drivers/crypto/inside-secure/eip93/eip93-aead.c    |    3 +-
 drivers/crypto/inside-secure/eip93/eip93-regs.h    |    2 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |   16 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |    6 +-
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c        |    3 +-
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |    1 -
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   |    1 -
 .../crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c   |    6 -
 .../crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c |    1 -
 .../intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c    |    6 -
 .../crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c   |    1 -
 .../intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c      |    6 -
 .../intel/qat/qat_common/adf_accel_devices.h       |    1 -
 drivers/crypto/intel/qat/qat_common/adf_cfg.c      |   84 +-
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c  |   10 +-
 .../crypto/intel/qat/qat_common/adf_gen2_hw_data.c |    9 -
 .../crypto/intel/qat/qat_common/adf_gen2_hw_data.h |    1 -
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.c |    6 -
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.h |    1 -
 .../crypto/intel/qat/qat_common/adf_gen4_vf_mig.c  |    5 +
 drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c |   20 +-
 drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h |   24 +-
 drivers/crypto/intel/qat/qat_common/adf_init.c     |   24 +-
 drivers/crypto/intel/qat/qat_common/adf_isr.c      |   15 +-
 .../crypto/intel/qat/qat_common/adf_sysfs_kpt.c    |   24 +-
 drivers/crypto/intel/qat/qat_common/adf_vf_isr.c   |    2 -
 drivers/crypto/intel/qat/qat_common/qat_algs.c     |   18 +-
 .../crypto/intel/qat/qat_common/qat_asym_algs.c    |   38 +-
 .../intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c  |    1 -
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |    6 -
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c   |   10 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_mbox.c   |    4 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c |   10 +-
 drivers/crypto/mxs-dcp.c                           |    3 +
 drivers/crypto/nx/nx-842.c                         |    2 +
 drivers/crypto/omap-des.c                          |    2 +
 drivers/crypto/omap-sham.c                         |    5 +-
 drivers/crypto/padlock-aes.c                       |   22 +-
 drivers/crypto/qce/aead.c                          |   11 +-
 drivers/crypto/qce/sha.c                           |    9 +-
 drivers/crypto/qce/skcipher.c                      |    9 +-
 drivers/crypto/rockchip/rk3288_crypto.c            |    4 +-
 drivers/crypto/s5p-sss.c                           |    7 +-
 drivers/crypto/sa2ul.c                             |  130 +-
 drivers/crypto/sa2ul.h                             |    3 -
 drivers/crypto/starfive/jh7110-cryp.c              |   20 +-
 drivers/crypto/talitos.c                           |   75 +-
 drivers/crypto/xilinx/zynqmp-aes-gcm.c             |   14 +-
 drivers/crypto/xilinx/zynqmp-sha.c                 |    2 +-
 include/crypto/aes.h                               |   13 +
 include/linux/ccp.h                                |   58 +-
 include/linux/hisi_acc_qm.h                        |    6 +-
 include/linux/psp-sev.h                            |   86 +-
 include/linux/rhashtable-types.h                   |   74 +-
 include/linux/rhashtable.h                         |   39 +-
 include/uapi/linux/psp-sev.h                       |   26 +-
 kernel/padata.c                                    |    2 +-
 lib/842/842_decompress.c                           |    7 +-
 lib/Kconfig.debug                                  |   15 +
 lib/rhashtable.c                                   |   75 +-
 lib/tests/842_decompress_kunit.c                   |  144 +++
 lib/tests/Makefile                                 |    1 +
 144 files changed, 1758 insertions(+), 4271 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
 create mode 100644 crypto/asymmetric_keys/verify_pefile_test.c
 delete mode 100644 drivers/crypto/hisilicon/sec/Makefile
 delete mode 100644 drivers/crypto/hisilicon/sec/sec_algs.c
 delete mode 100644 drivers/crypto/hisilicon/sec/sec_drv.c
 delete mode 100644 drivers/crypto/hisilicon/sec/sec_drv.h
 create mode 100644 lib/tests/842_decompress_kunit.c

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
