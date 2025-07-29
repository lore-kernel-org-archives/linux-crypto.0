Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBAD28C00D;
	Tue, 29 Jul 2025 11:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753787286; cv=none; b=sKZKz+f4gcoLWtrFYivrLq39dOyDbRwIhYJ1zIS6aacKY9eOie6XZLsiTXmZkxNKLImU5qpRuhn2pJOlzNfE3NvtUHrDr1WAnaQrxwFLb4mOkNOtSccnu6DGo6VlYaHGH0qZN8OusedxS3BD0EFF6ywf44iptuBb9DD6dDvPHa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753787286; c=relaxed/simple;
	bh=g6900Pmfgq+dODznFR/u4jTKkD6bQtRxrjUM4ARyuf8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nosTqvTVzFjuimevcIg7Fw1KXPu1iCgMSt3TCOPyhkVfy81NmMKYM91y0FC+QQ/+8FuCKMpmpudJgj/BhqWYiiqkhD3So9VBSw/qaPppQU+eyGJTKDD/zPPVJTBiRqk+sYHdad+NFsDzQ5Xy16JShAGpj/drZSuR+74VHBKOhzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TejPBfbU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TejPBfbU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EEDTtgBAu4uQ0oEVv4GxyYVrjL1O2VQyxhvLvK81yeU=; b=TejPBfbUXoFe+HD7AIs4i5JvZk
	hOoO/4E20VRWRU7hxPRI9D5G1JwMRwCEjbwep3R+oE4nofNGLsaj002N9A7nByA6SpClpn4BVmmMn
	eISWEWRZwbgdccINN74RQ1ogxIpTmNtj4rNysGDBaMdbwZjZQBupoBzqXKJOH+ThCP60x2U86y057
	vpRXxZdzOFAmPDJO3wZ6DbC6cCFfayJrY1rCq/x362v7hHo4MOUoWrc5RVSQojLZSmd30o00RFQXq
	SGqwpfrPI6lAfkJ0kx/7LVniFEZT5+Jt/XdI/LRk0wpMDjHsbmjJ1NQ1PKuRahTsqBZWlCzJunaUq
	egW0Jpaw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ughw2-00AUYx-2s;
	Tue, 29 Jul 2025 19:07:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 29 Jul 2025 19:07:51 +0800
Date: Tue, 29 Jul 2025 19:07:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 6.17
Message-ID: <aIirh_7k4SWzE-bF@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Linus:

The following changes since commit 40a98e702b528c631094f2e524d309faf33dc774:

  crypto: hkdf - move to late_initcall (2025-06-11 10:59:45 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.17-p1

for you to fetch changes up to bf24d64268544379d9a9b5b8efc2bb03967703b3:

  crypto: keembay - Use min() to simplify ocs_create_linked_list_from_sg() (2025-07-27 22:41:45 +1000)

----------------------------------------------------------------
This update includes the following changes:

API:

- Allow hash drivers without fallbacks (e.g., hardware key).

Algorithms:

- Add hmac hardware key support (phmac) on s390.
- Re-enable sha384 in FIPS mode.
- Disable sha1 in FIPS mode.
- Convert zstd to acomp.

Drivers:

- Lower priority of qat skcipher and aead.
- Convert aspeed to partial block API.
- Add iMX8QXP support in caam.
- Add rate limiting support for GEN6 devices in qat.
- Enable telemetry for GEN6 devices in qat.
- Implement full backlog mode for hisilicon/sec2.
----------------------------------------------------------------

Ahsan Atta (1):
      crypto: qat - allow enabling VFs in the absence of IOMMU

Alexey Kardashevskiy (1):
      crypto: ccp - Fix locking on alloc failure handling

Amit Singh Tomar (2):
      crypto: octeontx2 - Rework how engine group number is obtained
      crypto: octeontx2 - get engine group number for asymmetric engine

Arnd Bergmann (2):
      crypto: arm/aes-neonbs - work around gcc-15 warning
      crypto: ccp - reduce stack usage in ccp_run_aes_gcm_cmd

Ashish Kalra (2):
      crypto: ccp - Fix dereferencing uninitialized error pointer
      crypto: ccp - Fix SNP panic notifier unregistration

Bairavi Alagappan (1):
      crypto: qat - disable ZUC-256 capability for QAT GEN5

Bharat Bhushan (4):
      crypto: octeontx2 - add timeout for load_fvc completion poll
      crypto: octeontx2 - Fix address alignment issue on ucode loading
      crypto: octeontx2 - Fix address alignment on CN10K A0/A1 and OcteonTX2
      crypto: octeontx2 - Fix address alignment on CN10KB and CN10KA-B0

ChengZhenghan (1):
      crypto: x86 - Fix build warnings about export.h

Dr. David Alan Gilbert (1):
      crypto: virtio - Remove unused virtcrypto functions

Eric Biggers (4):
      crypto: x86/aegis - Fix sleeping when disallowed on PREEMPT_RT
      crypto: x86/aegis - Add missing error checks
      crypto: acomp - Fix CFI failure due to type punning
      crypto: krb5 - Fix memory leak in krb5_test_one_prf()

George Abraham P (2):
      crypto: qat - relocate power management debugfs helper APIs
      crypto: qat - enable power management debugfs for GEN6 devices

Giovanni Cabiddu (6):
      crypto: qat - lower priority for skcipher and aead algorithms
      crypto: qat - flush misc workqueue during device shutdown
      crypto: qat - fix DMA direction for compression on GEN2 devices
      crypto: qat - fix seq_file position update in adf_ring_next()
      crypto: qat - refactor ring-related debug functions
      crypto: qat - make adf_dev_autoreset() static

Harald Freudenberger (5):
      crypto: ahash - make hash walk functions from ahash.c public
      crypto: s390 - New s390 specific protected key hash phmac
      crypto: ahash - Add crypto_ahash_tested() helper function
      crypto: s390 - Add selftest support for phmac
      crypto: testmgr - Enable phmac selftest

Herbert Xu (21):
      crypto: ahash - Add support for drivers with no fallback
      crypto: aspeed/hash - Remove purely software hmac implementation
      crypto: aspeed/hash - Reorganise struct aspeed_sham_reqctx
      crypto: aspeed/hash - Use init_tfm instead of cra_init
      crypto: aspeed/hash - Provide rctx->buffer as argument to fill padding
      crypto: aspeed/hash - Move sham_final call into sham_update
      crypto: aspeed/hash - Move final padding into dma_prepare
      crypto: aspeed/hash - Remove sha_iv
      crypto: aspeed/hash - Use API partial block handling
      crypto: aspeed/hash - Add fallback
      crypto: aspeed/hash - Iterate on large hashes in dma_prepare
      crypto: aspeed/hash - Fix potential overflow in dma_prepare_sg
      crypto: marvell/cesa - Remove unnecessary state setting on final
      crypto: marvell/cesa - Fix engine load inaccuracy
      crypto: s390/hmac - Fix counter in export state
      crypto: s390/sha3 - Use cpu byte-order when exporting
      padata: Fix pd UAF once and for all
      padata: Remove comment for reorder_work
      crypto: ahash - Stop legacy tfms from using the set_virt fallback path
      crypto: aspeed - Fix hash fallback path typo
      Merge tag 'local-lock-for-net' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into head

Holger Dengler (1):
      s390/crypto: Add protected key hmac subfunctions for KMAC

Jeff Barnes (1):
      crypto: testmgr - Restore sha384 and hmac_sha384 drbgs in FIPS mode

John Ernberg (3):
      crypto: caam - Prevent crash on suspend with iMX8QM / iMX8ULP
      crypto: caam - Support iMX8QXP and variants thereof
      dt-bindings: crypto: fsl,sec-v4.0: Add power domains for iMX8QM and iMX8QXP

Lukas Bulwahn (1):
      crypto: caam - avoid option aliasing with the CONFIG_CAAM_QI build option

Mario Limonciello (1):
      crypto: ccp - Add missing bootloader info reg for pspv6

Markus Theil (1):
      crypto: jitter - fix intermediary handling

Małgorzata Mielnik (2):
      crypto: qat - relocate bank state helper functions
      crypto: qat - add live migration enablers for GEN6 devices

Mengbiao Xiong (1):
      crypto: ccp - Fix crash when rebind ccp device for ccp.ko

Ovidiu Panait (6):
      crypto: sun8i-ce - fix nents passed to dma_unmap_sg()
      crypto: sun8i-ce - remove ivlen field of sun8i_cipher_req_ctx
      crypto: sun8i-ce - use helpers to get hash block and digest sizes
      hwrng: mtk - handle devm_pm_runtime_enable errors
      crypto: engine - remove request batching support
      crypto: engine - remove {prepare,unprepare}_crypt_hardware callbacks

Rob Herring (Arm) (2):
      dt-bindings: crypto: Convert ti,omap2-aes to DT schema
      dt-bindings: crypto: Convert ti,omap4-des to DT schema

Ruben Wauters (1):
      crypto: jitter - replace ARRAY_SIZE definition with header include

Ryan Wanner (5):
      dt-bindings: crypto: add sama7d65 in Atmel AES
      dt-bindings: crypto: add sama7d65 in Atmel SHA
      dt-bindings: crypto: add sama7d65 in Atmel TDES
      dt-bindings: rng: atmel,at91-trng: add sama7d65 TRNG
      crypto: atmel - add support for AES and SHA IPs available on sama7d65 SoC

Sakari Ailus (2):
      hwrng: drivers - Remove redundant pm_runtime_mark_last_busy() calls
      crypto: drivers - Remove redundant pm_runtime_mark_last_busy() calls

Sebastian Andrzej Siewior (2):
      local_lock: Move this_cpu_ptr() notation from internal to main header
      crypto: cryptd - Use nested-BH locking for cryptd_cpu_queue

Suman Kumar Chakraborty (19):
      crypto: qat - use unmanaged allocation for dc_data
      crypto: qat - add support for decompression service to GEN6 devices
      Documentation: qat: update sysfs-driver-qat for GEN6 devices
      crypto: zstd - convert to acomp
      crypto: qat - remove duplicate masking for GEN6 devices
      crypto: qat - restore ASYM service support for GEN6 devices
      crypto: zstd - fix duplicate check warning
      crypto: qat - use pr_fmt() in adf_gen4_hw_data.c
      crypto: qat - replace CHECK_STAT macro with static inline function
      crypto: qat - relocate and rename bank state structure definition
      crypto: qat - fix virtual channel configuration for GEN6 devices
      crypto: qat - validate service in rate limiting sysfs api
      crypto: qat - add decompression service for rate limiting
      crypto: qat - consolidate service enums
      crypto: qat - relocate service related functions
      crypto: qat - add adf_rl_get_num_svc_aes() in rate limiting
      crypto: qat - add get_svc_slice_cnt() in device data structure
      crypto: qat - add compression slice count for rate limiting
      crypto: qat - enable rate limiting feature for GEN6 devices

Svyatoslav Pankratov (1):
      crypto: qat - fix state restore for banks with exceptions

Thomas Fourier (3):
      crypto: inside-secure - Fix `dma_unmap_sg()` nents value
      crypto: keembay - Fix dma_unmap_sg() nents value
      crypto: img-hash - Fix dma_unmap_sg() nents value

Thomas Weißschuh (1):
      crypto: ccree - Don't use %pK through printk

Thorsten Blum (2):
      crypto: zstd - replace zero-length array with flexible array member
      crypto: keembay - Use min() to simplify ocs_create_linked_list_from_sg()

Vegard Nossum (1):
      crypto: testmgr - desupport SHA-1 for FIPS 140

Vijay Sundar Selvamani (3):
      crypto: qat - add decompression service to telemetry
      crypto: qat - enable telemetry for GEN6 devices
      Documentation: qat: update debugfs-driver-qat_telemetry for GEN6 devices

Wenkai Lin (1):
      crypto: hisilicon/sec2 - implement full backlog mode for sec

Yury Norov (1):
      padata: use cpumask_nth()

Yury Norov [NVIDIA] (2):
      crypto: pcrypt - Optimize pcrypt_aead_init_tfm()
      crypto: caam - Fix opencoded cpumask_next_wrap() in caam_drv_ctx_init()

Zenghui Yu (1):
      crypto: hisilicon - Use fine grained DMA mapping direction

Zhiqi Song (1):
      crypto: hisilicon/hpre - fix dma unmap sequence

 Documentation/ABI/testing/debugfs-driver-qat       |    2 +-
 .../ABI/testing/debugfs-driver-qat_telemetry       |   10 +-
 Documentation/ABI/testing/sysfs-driver-qat         |   50 +-
 Documentation/ABI/testing/sysfs-driver-qat_rl      |   14 +-
 Documentation/crypto/crypto_engine.rst             |    6 -
 .../bindings/crypto/atmel,at91sam9g46-aes.yaml     |    4 +-
 .../bindings/crypto/atmel,at91sam9g46-sha.yaml     |    4 +-
 .../bindings/crypto/atmel,at91sam9g46-tdes.yaml    |    4 +-
 .../devicetree/bindings/crypto/fsl,sec-v4.0.yaml   |   41 +-
 .../devicetree/bindings/crypto/omap-aes.txt        |   31 -
 .../devicetree/bindings/crypto/omap-des.txt        |   30 -
 .../devicetree/bindings/crypto/ti,omap2-aes.yaml   |   58 ++
 .../devicetree/bindings/crypto/ti,omap4-des.yaml   |   65 ++
 .../devicetree/bindings/rng/atmel,at91-trng.yaml   |    1 +
 arch/arm/crypto/aes-neonbs-glue.c                  |    2 +-
 arch/s390/configs/debug_defconfig                  |    1 +
 arch/s390/configs/defconfig                        |    1 +
 arch/s390/crypto/Makefile                          |    1 +
 arch/s390/crypto/hmac_s390.c                       |   12 +-
 arch/s390/crypto/paes_s390.c                       |    2 +-
 arch/s390/crypto/phmac_s390.c                      | 1048 ++++++++++++++++++++
 arch/s390/crypto/sha.h                             |    3 +
 arch/s390/crypto/sha3_256_s390.c                   |   22 +-
 arch/s390/crypto/sha3_512_s390.c                   |   23 +-
 arch/s390/include/asm/cpacf.h                      |    4 +
 arch/x86/crypto/aegis128-aesni-glue.c              |   40 +-
 arch/x86/crypto/aria_aesni_avx2_glue.c             |    1 +
 arch/x86/crypto/aria_aesni_avx_glue.c              |    1 +
 arch/x86/crypto/camellia_aesni_avx_glue.c          |    1 +
 arch/x86/crypto/camellia_glue.c                    |    1 +
 arch/x86/crypto/curve25519-x86_64.c                |    1 +
 arch/x86/crypto/serpent_avx_glue.c                 |    1 +
 arch/x86/crypto/sm4_aesni_avx_glue.c               |    1 +
 arch/x86/crypto/twofish_glue.c                     |    1 +
 arch/x86/crypto/twofish_glue_3way.c                |    1 +
 crypto/ahash.c                                     |   39 +-
 crypto/cryptd.c                                    |    6 +
 crypto/crypto_engine.c                             |   55 +-
 crypto/deflate.c                                   |    7 +-
 crypto/jitterentropy-kcapi.c                       |    9 +-
 crypto/jitterentropy.c                             |    2 +-
 crypto/krb5/selftest.c                             |    1 +
 crypto/pcrypt.c                                    |    7 +-
 crypto/testmgr.c                                   |   39 +-
 crypto/zstd.c                                      |  390 +++++---
 drivers/char/hw_random/atmel-rng.c                 |    1 -
 drivers/char/hw_random/cctrng.c                    |    1 -
 drivers/char/hw_random/mtk-rng.c                   |    5 +-
 drivers/char/hw_random/npcm-rng.c                  |    1 -
 drivers/char/hw_random/omap3-rom-rng.c             |    1 -
 drivers/char/hw_random/rockchip-rng.c              |    3 -
 drivers/char/hw_random/stm32-rng.c                 |    1 -
 drivers/crypto/Kconfig                             |   13 +
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   15 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c  |    6 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |    2 -
 drivers/crypto/aspeed/aspeed-hace-hash.c           |  802 ++++-----------
 drivers/crypto/aspeed/aspeed-hace.h                |   28 +-
 drivers/crypto/atmel-aes.c                         |    1 +
 drivers/crypto/atmel-sha.c                         |    1 +
 drivers/crypto/caam/Makefile                       |    4 -
 drivers/crypto/caam/ctrl.c                         |   13 +-
 drivers/crypto/caam/debugfs.c                      |    2 +-
 drivers/crypto/caam/debugfs.h                      |    2 +-
 drivers/crypto/caam/intern.h                       |    5 +-
 drivers/crypto/caam/jr.c                           |    3 +-
 drivers/crypto/caam/qi.c                           |    5 +-
 drivers/crypto/ccp/ccp-debugfs.c                   |    3 +
 drivers/crypto/ccp/ccp-ops.c                       |  163 +--
 drivers/crypto/ccp/sev-dev.c                       |   26 +-
 drivers/crypto/ccp/sp-pci.c                        |    1 +
 drivers/crypto/ccree/cc_buffer_mgr.c               |   54 +-
 drivers/crypto/ccree/cc_cipher.c                   |    4 +-
 drivers/crypto/ccree/cc_hash.c                     |   30 +-
 drivers/crypto/ccree/cc_pm.c                       |    1 -
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |    8 +-
 drivers/crypto/hisilicon/qm.c                      |    1 -
 drivers/crypto/hisilicon/sec2/sec.h                |   63 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  595 +++++++----
 drivers/crypto/hisilicon/sgl.c                     |   15 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c          |   13 +-
 drivers/crypto/img-hash.c                          |    2 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |    8 +-
 .../crypto/intel/keembay/keembay-ocs-hcu-core.c    |    8 +-
 drivers/crypto/intel/keembay/ocs-aes.c             |    4 +-
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |   18 +-
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   |   14 +-
 .../crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c   |  129 ++-
 .../crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h   |   22 +-
 drivers/crypto/intel/qat/qat_common/Makefile       |    4 +
 .../intel/qat/qat_common/adf_accel_devices.h       |   40 +-
 drivers/crypto/intel/qat/qat_common/adf_aer.c      |    2 +-
 .../crypto/intel/qat/qat_common/adf_bank_state.c   |  238 +++++
 .../crypto/intel/qat/qat_common/adf_bank_state.h   |   49 +
 .../crypto/intel/qat/qat_common/adf_cfg_common.h   |    1 +
 .../crypto/intel/qat/qat_common/adf_cfg_services.c |   45 +-
 .../crypto/intel/qat/qat_common/adf_cfg_services.h |   13 +-
 .../crypto/intel/qat/qat_common/adf_cfg_strings.h  |    1 +
 .../crypto/intel/qat/qat_common/adf_common_drv.h   |    2 +-
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.c |  229 +----
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.h |   10 +-
 .../intel/qat/qat_common/adf_gen4_pm_debugfs.c     |  105 +-
 .../crypto/intel/qat/qat_common/adf_gen4_vf_mig.c  |    7 +-
 drivers/crypto/intel/qat/qat_common/adf_gen6_pm.h  |   24 +
 .../intel/qat/qat_common/adf_gen6_pm_dbgfs.c       |  124 +++
 .../crypto/intel/qat/qat_common/adf_gen6_shared.c  |    7 +
 .../crypto/intel/qat/qat_common/adf_gen6_shared.h  |    2 +
 drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c  |  146 +++
 drivers/crypto/intel/qat/qat_common/adf_gen6_tl.h  |  198 ++++
 drivers/crypto/intel/qat/qat_common/adf_init.c     |    1 +
 drivers/crypto/intel/qat/qat_common/adf_isr.c      |    5 +
 .../intel/qat/qat_common/adf_pm_dbgfs_utils.c      |   52 +
 .../intel/qat/qat_common/adf_pm_dbgfs_utils.h      |   36 +
 drivers/crypto/intel/qat/qat_common/adf_rl.c       |   86 +-
 drivers/crypto/intel/qat/qat_common/adf_rl.h       |   11 +-
 drivers/crypto/intel/qat/qat_common/adf_rl_admin.c |    1 +
 drivers/crypto/intel/qat/qat_common/adf_sriov.c    |    1 -
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c    |    2 +
 drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c |   21 +-
 .../crypto/intel/qat/qat_common/adf_tl_debugfs.c   |    3 +
 .../intel/qat/qat_common/adf_transport_debug.c     |   21 +-
 drivers/crypto/intel/qat/qat_common/qat_algs.c     |   12 +-
 drivers/crypto/intel/qat/qat_common/qat_bl.c       |    6 +-
 .../crypto/intel/qat/qat_common/qat_compression.c  |    8 +-
 drivers/crypto/marvell/cesa/cipher.c               |    4 +-
 drivers/crypto/marvell/cesa/hash.c                 |   10 +-
 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h |  128 ++-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h      |    3 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |   51 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c |    6 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c |   28 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c |    7 +-
 .../crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c   |   14 +-
 drivers/crypto/omap-aes-gcm.c                      |    1 -
 drivers/crypto/omap-aes.c                          |    1 -
 drivers/crypto/omap-des.c                          |    1 -
 drivers/crypto/omap-sham.c                         |    1 -
 drivers/crypto/stm32/stm32-cryp.c                  |    1 -
 drivers/crypto/stm32/stm32-hash.c                  |    1 -
 drivers/crypto/virtio/virtio_crypto_common.h       |    2 -
 drivers/crypto/virtio/virtio_crypto_core.c         |    2 +-
 drivers/crypto/virtio/virtio_crypto_mgr.c          |   36 -
 include/crypto/engine.h                            |    1 -
 include/crypto/internal/acompress.h                |    5 +-
 include/crypto/internal/engine.h                   |   15 -
 include/crypto/internal/hash.h                     |   36 +
 include/linux/crypto.h                             |    3 +
 include/linux/hisi_acc_qm.h                        |    4 +-
 include/linux/local_lock.h                         |   20 +-
 include/linux/local_lock_internal.h                |   30 +-
 include/linux/padata.h                             |    4 -
 kernel/padata.c                                    |  154 +--
 152 files changed, 4133 insertions(+), 2089 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/omap-aes.txt
 delete mode 100644 Documentation/devicetree/bindings/crypto/omap-des.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,omap2-aes.yaml
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,omap4-des.yaml
 create mode 100644 arch/s390/crypto/phmac_s390.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_bank_state.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_bank_state.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_pm_dbgfs.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_tl.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.h

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
