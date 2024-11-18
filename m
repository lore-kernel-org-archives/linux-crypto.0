Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A810781E;
	Mon, 18 Nov 2024 03:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731899925; cv=none; b=JzB+AGRwldaqrPSsMLXT+dgoKre7WlfgRlT3N0a1JKiEWjfonhSA3gu35knBEa+kHJqxiW/C1iRQbtaRfXIv8z0ruBifaiYErzDTXhrfJyXy3v68X3UPZKDKngSlOwYd7y6pJPvI9sShIh+AY/oSEULKUt6pAb/JvOzrPbSrfLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731899925; c=relaxed/simple;
	bh=+oDdiGLv7v1ShvQ6esu5a/Twssk9FrwpKnpJJ9IDL68=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQEE2ArDSdrYO2pqdnR7yLz+8qZEMJ4bJ+RiqZKJKHFmK+AIQkQZGizYPOAK9yC8lGKrhcuGFY95vPBvt1KfObII6Ac8k5yQij87mmG9bqCX/cRNm/Cbjr2QQ4pks8A6sD/7mNRC0O4IUhAAWUrcITavXyD1k919g36W6JWRDVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pNDZ44Zl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pNDZ44Zl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2cYhstj3E4Yh6wZ1KvvwNT+1ms6NZEPF33DX6ZkbaeE=; b=pNDZ44ZlgSSBq2MUWHAeFkFq+u
	n3FDVjCs9mgQO8yfAgR4SSitQUaSK0o0Jt+NW/OKRzECjBIE8jLGJEPqE3M8figXcOk77JqtUCvdB
	/s0LgonjZ8i8/uimkEQbxixQtM1RIuUBDPzClqvUrIaUDtiXecZqcxsBurYGv5OkC8aN+DTa/ijr+
	T8eGmVveLq6AIEBYauhbt7/u9wy0ZZ7QqFdcPE6ekKhgHg4AT3akKpamYvrMpe6xSywbndctMycwz
	H3/z7O5n2un2z2Pepf7M50yeeMF1Lg5hfYPxpvd3tC+8KWXBZfO2opXJQRF0MevJBpvsUEKUbJYUQ
	hyA4YVmg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tCsHR-00HX4M-2p;
	Mon, 18 Nov 2024 11:18:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 18 Nov 2024 11:18:25 +0800
Date: Mon, 18 Nov 2024 11:18:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 6.13
Message-ID: <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
References: <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZuetBbpfq5X8BAwn@gondor.apana.org.au>

Hi Linus:

The following changes since commit 9852d85ec9d492ebef56dc5f229416c925758edc:

  Linux 6.12-rc1 (2024-09-29 15:06:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.13-p1 

for you to fetch changes up to 4223414efeae3a8efb4da1e9c9c52a1a44c1c5bf:

  crypto: marvell/cesa - fix uninit value for struct mv_cesa_op_ctx (2024-11-15 19:52:51 +0800)

----------------------------------------------------------------
This update includes the following changes:

API:

- Add sig driver API.
- Remove signing/verification from akcipher API.
- Move crypto_simd_disabled_for_test to lib/crypto.
- Add WARN_ON for return values from driver that indicates memory corruption.

Algorithms:

- Provide crc32-arch and crc32c-arch through Crypto API.
- Optimise crc32c code size on x86.
- Optimise crct10dif on arm/arm64.
- Optimise p10-aes-gcm on powerpc.
- Optimise aegis128 on x86.
- Output full sample from test interface in jitter RNG.
- Retry without padata when it fails in pcrypt.

Drivers:

- Add support for Airoha EN7581 TRNG.
- Add support for STM32MP25x platforms in stm32.
- Enable iproc-r200 RNG driver on BCMBCA.
- Add Broadcom BCM74110 RNG driver.
----------------------------------------------------------------

Ahsan Atta (1):
      crypto: qat - remove faulty arbiter config reset

Ard Biesheuvel (8):
      crypto: crc32 - Provide crc32-arch driver for accelerated library code
      crypto: crc32c - Provide crc32c-arch driver for accelerated library code
      crypto: arm64/crct10dif - Remove obsolete chunking logic
      crypto: arm64/crct10dif - Use faster 16x64 bit polynomial multiply
      crypto: arm64/crct10dif - Remove remaining 64x64 PMULL fallback code
      crypto: arm/crct10dif - Use existing mov_l macro instead of __adrl
      crypto: arm/crct10dif - Macroify PMULL asm code
      crypto: arm/crct10dif - Implement plain NEON variant

Cabiddu, Giovanni (1):
      crypto: qat - remove check after debugfs_create_dir()

Chen Ridong (2):
      crypto: caam - add error check to caam_rsa_set_priv_key_form
      crypto: bcm - add error check in the ahash_hmac_init function

Chenghai Huang (1):
      crypto: hisilicon/qm - fix the coding specifications issue

Christian Marangi (2):
      dt-bindings: rng: add support for Airoha EN7581 TRNG
      hwrng: airoha - add support for Airoha EN7581 TRNG

Christophe JAILLET (4):
      crypto: caam - Fix the pointer passed to caam_qi_shutdown()
      crypto: caam - Slightly simplify platform_device()
      crypto: qat - Constify struct pm_status_row
      crypto: cavium - Fix an error handling path in cpt_ucode_load_fw()

Colin Ian King (1):
      crypto: tegra - remove redundant error check on ret

Dan Carpenter (2):
      crypto: qat/qat_420xx - fix off by one in uof_get_name()
      crypto: qat/qat_4xxx - fix off by one in uof_get_name()

Danny Tsen (3):
      crypto: powerpc/p10-aes-gcm - Re-write AES/GCM stitched implementation
      crypto: powerpc/p10-aes-gcm - Register modules as SIMD
      crypto: powerpc/p10-aes-gcm - Add dependency on CRYPTO_SIMDand re-enable CRYPTO_AES_GCM_P10

Dr. David Alan Gilbert (3):
      crypto: qat - remove unused adf_devmgr_get_first
      crypto: x86/cast5 - Remove unused cast5_ctr_16way
      crypto: asymmetric_keys - Remove unused functions

Eric Biggers (14):
      crypto: x86/crc32c - simplify code for handling fewer than 200 bytes
      crypto: x86/crc32c - access 32-bit arguments as 32-bit
      crypto: x86/crc32c - eliminate jump table and excessive unrolling
      crypto: x86/aegis128 - access 32-bit arguments as 32-bit
      crypto: x86/aegis128 - remove no-op init and exit functions
      crypto: x86/aegis128 - eliminate some indirect calls
      crypto: x86/aegis128 - don't bother with special code for aligned data
      crypto: x86/aegis128 - optimize length block preparation using SSE4.1
      crypto: x86/aegis128 - improve assembly function prototypes
      crypto: x86/aegis128 - optimize partial block handling using SSE4.1
      crypto: x86/aegis128 - take advantage of block-aligned len
      crypto: x86/aegis128 - remove unneeded FRAME_BEGIN and FRAME_END
      crypto: x86/aegis128 - remove unneeded RETs
      crypto: api - move crypto_simd_disabled_for_test to lib

Everest K.C (1):
      crypto: cavium - Fix the if condition to exit loop after timeout

Fabio Estevam (1):
      dt-bindings: imx-rng: Allow passing only "fsl,imx31-rnga"

Gatien Chevallier (3):
      dt-bindings: rng: add st,stm32mp25-rng support
      hwrng: stm32 - implement support for STM32MP25x platforms
      hwrng: stm32 - update STM32MP15 RNG max clock frequency

Herbert Xu (3):
      hwrng: core - Add WARN_ON for buggy read return values
      crypto: lib/mpi - Export mpi_set_bit
      crypto: aesni - Move back to module_init

Joachim Vandersmissen (1):
      crypto: jitter - output full sample from test interface

Karol Przybylski (1):
      crypto: marvell/cesa - fix uninit value for struct mv_cesa_op_ctx

Li Huafei (1):
      crypto: inside-secure - Fix the return value of safexcel_xcbcmac_cra_init()

Linus Walleij (1):
      hwrng: iproc-r200 - enable on BCMBCA

Lukas Bulwahn (1):
      hwrng: amd - remove reference to removed PPC_MAPLE config

Lukas Wunner (23):
      crypto: ecdsa - Drop unused test vector elements
      crypto: sig - Introduce sig_alg backend
      crypto: ecdsa - Migrate to sig_alg backend
      crypto: ecrdsa - Migrate to sig_alg backend
      crypto: rsa-pkcs1pad - Deduplicate set_{pub,priv}_key callbacks
      crypto: rsassa-pkcs1 - Migrate to sig_alg backend
      crypto: rsassa-pkcs1 - Harden digest length verification
      crypto: rsassa-pkcs1 - Avoid copying hash prefix
      crypto: virtio - Drop sign/verify operations
      crypto: drivers - Drop sign/verify operations
      crypto: akcipher - Drop sign/verify operations
      crypto: sig - Move crypto_sig_*() API calls to include file
      ASN.1: Clean up include statements in public headers
      crypto: ecdsa - Avoid signed integer overflow on signature decoding
      crypto: ecdsa - Move X9.62 signature decoding into template
      crypto: sig - Rename crypto_sig_maxsize() to crypto_sig_keysize()
      crypto: ecdsa - Move X9.62 signature size calculation into template
      crypto: ecdsa - Support P1363 signature decoding
      crypto: ecrdsa - Fix signature size calculation
      crypto: doc - Fix akcipher title reference
      crypto: sig - Fix oops on KEYCTL_PKEY_QUERY for RSA keys
      crypto: ecdsa - Update Kconfig help text for NIST P521
      crypto: rsassa-pkcs1 - Reinstate support for legacy protocols

Markus Mayer (2):
      dt-bindings: rng: add binding for BCM74110 RNG
      hwrng: bcm74110 - Add Broadcom BCM74110 RNG driver

Michal Suchanek (1):
      crypto: aes-gcm-p10 - Use the correct bit to test for P10

Ovidiu Panait (2):
      crypto: tegra - remove unneeded crypto_engine_stop() call
      crypto: starfive - remove unneeded crypto_engine_stop() call

Qi Tao (1):
      crypto: hisilicon - support querying the capability register

Qianqiang Liu (1):
      crypto: lib/mpi - Fix an "Uninitialized scalar variable" issue

Rob Herring (Arm) (1):
      dt-bindings: rng: Add Marvell Armada RNG support

Rosen Penev (6):
      crypto: cesa - add COMPILE_TEST
      crypto: cesa - use enabled variants for clk_get
      crypto: cesa - remove irq_set_affinity_hint
      crypto: cesa - use devm_platform_get_and_ioremap_resource
      crypto: crypto4xx - avoid explicit resource
      crypto: crypto4xx - use devm in probe

Shen Lichuan (1):
      crypto: drivers - Correct multiple typos in comments

Tang Bin (1):
      crypto: amlogic - Remove redundant assignment and error messages

Thorsten Blum (1):
      crypto: drbg - Use str_true_false() and str_enabled_disabled() helpers

Tomas Paukrt (1):
      crypto: mxs-dcp - Fix AES-CBC with hardware-bound keys

Uwe Kleine-König (3):
      crypto: atmel - Drop explicit initialization of struct i2c_device_id::driver_data to 0
      crypto: drivers - Switch back to struct platform_driver::remove()
      hwrng: drivers - Switch back to struct platform_driver::remove()

Vishal Chourasia (2):
      crypto: nx - Rename devdata_mutex to devdata_spinlock
      crypto: nx - Fix invalid wait context during kexec reboot

Wang Hai (1):
      crypto: qat - Fix missing destroy_workqueue in adf_init_aer()

WangYuli (1):
      crypto: qat - Fix typo "accelaration"

Weili Qian (2):
      crypto: hisilicon/hpre - enable all clusters clock gating
      crypto: hisilicon/qm - disable same error report before resetting

Yi Yang (1):
      crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY

Yu Jiaoliang (1):
      crypto: ccree - Fix typo in comment

Yuvaraj Ranganathan (1):
      dt-bindings: crypto: qcom-qce: document the SA8775P crypto engine

Zanussi, Tom (2):
      crypto: iaa - Remove potential infinite loop in check_completion()
      MAINTAINERS: Make Kristen Accardi the IAA crypto driver maintainer

Zhu Jun (1):
      hwrng: histb - Fix the wrong format specifier

Zicheng Qu (1):
      padata: Clean up in padata_do_multithreaded()

 Documentation/ABI/testing/debugfs-hisi-hpre        |    7 +
 Documentation/ABI/testing/debugfs-hisi-sec         |    7 +
 Documentation/ABI/testing/debugfs-hisi-zip         |    7 +
 Documentation/crypto/api-akcipher.rst              |    4 +-
 Documentation/crypto/api-sig.rst                   |   15 +
 Documentation/crypto/api.rst                       |    1 +
 Documentation/crypto/architecture.rst              |    2 +
 .../devicetree/bindings/crypto/qcom-qce.yaml       |    1 +
 .../bindings/rng/airoha,en7581-trng.yaml           |   38 +
 .../devicetree/bindings/rng/brcm,bcm74110-rng.yaml |   35 +
 Documentation/devicetree/bindings/rng/imx-rng.yaml |    2 +-
 ..._rng.yaml => inside-secure,safexcel-eip76.yaml} |   17 +-
 .../devicetree/bindings/rng/st,stm32-rng.yaml      |   28 +-
 MAINTAINERS                                        |    2 +-
 arch/arm/crypto/crct10dif-ce-core.S                |  249 +-
 arch/arm/crypto/crct10dif-ce-glue.c                |   55 +-
 arch/arm64/crypto/crct10dif-ce-core.S              |  331 ++-
 arch/arm64/crypto/crct10dif-ce-glue.c              |   44 +-
 arch/powerpc/crypto/Kconfig                        |    2 +-
 arch/powerpc/crypto/aes-gcm-p10-glue.c             |  141 +-
 arch/powerpc/crypto/aes-gcm-p10.S                  | 2481 +++++++++-----------
 arch/x86/crypto/Kconfig                            |    4 +-
 arch/x86/crypto/aegis128-aesni-asm.S               |  516 ++--
 arch/x86/crypto/aegis128-aesni-glue.c              |  145 +-
 arch/x86/crypto/aesni-intel_glue.c                 |    2 +-
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S          |   76 -
 arch/x86/crypto/crc32c-intel_glue.c                |    2 +-
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S          |  348 +--
 crypto/Kconfig                                     |    7 +-
 crypto/Makefile                                    |    7 +-
 crypto/akcipher.c                                  |   64 +-
 crypto/algapi.c                                    |    6 -
 crypto/asymmetric_keys/public_key.c                |   58 +-
 crypto/asymmetric_keys/signature.c                 |   63 -
 crypto/crc32_generic.c                             |   94 +-
 crypto/crc32c_generic.c                            |   94 +-
 crypto/drbg.c                                      |    5 +-
 crypto/ecdsa-p1363.c                               |  159 ++
 crypto/ecdsa-x962.c                                |  237 ++
 crypto/ecdsa.c                                     |  209 +-
 crypto/ecrdsa.c                                    |   64 +-
 crypto/internal.h                                  |   19 -
 crypto/jitterentropy-testing.c                     |   31 +-
 crypto/jitterentropy.h                             |    4 +-
 crypto/pcrypt.c                                    |   12 +-
 crypto/rsa-pkcs1pad.c                              |  369 +--
 crypto/rsa.c                                       |   17 +-
 crypto/rsassa-pkcs1.c                              |  454 ++++
 crypto/sig.c                                       |  149 +-
 crypto/testmgr.c                                   |  332 ++-
 crypto/testmgr.h                                   | 1225 +++++++---
 drivers/char/hw_random/Kconfig                     |   30 +-
 drivers/char/hw_random/Makefile                    |    2 +
 drivers/char/hw_random/airoha-trng.c               |  243 ++
 drivers/char/hw_random/atmel-rng.c                 |    2 +-
 drivers/char/hw_random/bcm74110-rng.c              |  125 +
 drivers/char/hw_random/cctrng.c                    |    2 +-
 drivers/char/hw_random/core.c                      |   11 +-
 drivers/char/hw_random/exynos-trng.c               |    2 +-
 drivers/char/hw_random/histb-rng.c                 |    2 +-
 drivers/char/hw_random/ingenic-rng.c               |    2 +-
 drivers/char/hw_random/ks-sa-rng.c                 |    2 +-
 drivers/char/hw_random/mxc-rnga.c                  |    2 +-
 drivers/char/hw_random/n2-drv.c                    |    2 +-
 drivers/char/hw_random/npcm-rng.c                  |    2 +-
 drivers/char/hw_random/omap-rng.c                  |    2 +-
 drivers/char/hw_random/stm32-rng.c                 |   78 +-
 drivers/char/hw_random/timeriomem-rng.c            |    2 +-
 drivers/char/hw_random/xgene-rng.c                 |    2 +-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c  |    2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |    2 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |    2 +-
 drivers/crypto/amcc/crypto4xx_core.c               |   58 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c          |   10 +-
 drivers/crypto/aspeed/aspeed-acry.c                |    4 +-
 drivers/crypto/aspeed/aspeed-hace.c                |    2 +-
 drivers/crypto/atmel-aes.c                         |    2 +-
 drivers/crypto/atmel-ecc.c                         |    2 +-
 drivers/crypto/atmel-sha.c                         |    2 +-
 drivers/crypto/atmel-sha204a.c                     |    4 +-
 drivers/crypto/atmel-tdes.c                        |    4 +-
 drivers/crypto/axis/artpec6_crypto.c               |    2 +-
 drivers/crypto/bcm/cipher.c                        |    7 +-
 drivers/crypto/caam/caampkc.c                      |   11 +-
 drivers/crypto/caam/jr.c                           |    2 +-
 drivers/crypto/caam/qi.c                           |    7 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |    6 +-
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c       |    4 +-
 drivers/crypto/cavium/nitrox/nitrox_lib.c          |    2 +-
 drivers/crypto/ccp/sp-platform.c                   |    2 +-
 drivers/crypto/ccree/cc_aead.c                     |    4 +-
 drivers/crypto/ccree/cc_cipher.c                   |    2 +-
 drivers/crypto/ccree/cc_driver.c                   |    2 +-
 drivers/crypto/ccree/cc_hash.c                     |    2 +-
 drivers/crypto/chelsio/chcr_algo.c                 |    2 +-
 drivers/crypto/exynos-rng.c                        |    2 +-
 drivers/crypto/gemini/sl3516-ce-core.c             |    2 +-
 drivers/crypto/hisilicon/hpre/hpre.h               |   23 +
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |    2 -
 drivers/crypto/hisilicon/hpre/hpre_main.c          |  190 +-
 drivers/crypto/hisilicon/qm.c                      |  166 +-
 drivers/crypto/hisilicon/sec/sec_drv.c             |    2 +-
 drivers/crypto/hisilicon/sec2/sec.h                |   26 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |    8 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |  108 +-
 drivers/crypto/hisilicon/trng/trng.c               |    2 +-
 drivers/crypto/hisilicon/zip/zip.h                 |   18 +
 drivers/crypto/hisilicon/zip/zip_main.c            |  153 +-
 drivers/crypto/img-hash.c                          |    2 +-
 drivers/crypto/inside-secure/safexcel.c            |    2 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |    2 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |   10 +
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c        |    2 +-
 .../crypto/intel/keembay/keembay-ocs-aes-core.c    |    2 +-
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c     |    2 +-
 .../crypto/intel/keembay/keembay-ocs-hcu-core.c    |    2 +-
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |    2 +-
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   |    2 +-
 drivers/crypto/intel/qat/qat_common/adf_aer.c      |    5 +-
 .../crypto/intel/qat/qat_common/adf_common_drv.h   |    1 -
 drivers/crypto/intel/qat/qat_common/adf_dbgfs.c    |   13 +-
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c  |   10 -
 .../intel/qat/qat_common/adf_gen4_pm_debugfs.c     |   18 +-
 .../crypto/intel/qat/qat_common/adf_hw_arbiter.c   |    4 -
 drivers/crypto/intel/qat/qat_common/qat_hal.c      |    2 +-
 drivers/crypto/marvell/Kconfig                     |    2 +-
 drivers/crypto/marvell/cesa/cesa.c                 |   54 +-
 drivers/crypto/marvell/cesa/cipher.c               |   24 +-
 drivers/crypto/mxs-dcp.c                           |   22 +-
 drivers/crypto/n2_core.c                           |    4 +-
 drivers/crypto/nx/nx-common-pseries.c              |   37 +-
 drivers/crypto/omap-aes.c                          |    2 +-
 drivers/crypto/omap-des.c                          |    2 +-
 drivers/crypto/omap-sham.c                         |    2 +-
 drivers/crypto/qce/core.c                          |    2 +-
 drivers/crypto/qcom-rng.c                          |    2 +-
 drivers/crypto/rockchip/rk3288_crypto.c            |    2 +-
 drivers/crypto/s5p-sss.c                           |    2 +-
 drivers/crypto/sa2ul.c                             |    4 +-
 drivers/crypto/sahara.c                            |    2 +-
 drivers/crypto/starfive/jh7110-cryp.c              |    7 +-
 drivers/crypto/starfive/jh7110-rsa.c               |    2 -
 drivers/crypto/stm32/stm32-crc32.c                 |    2 +-
 drivers/crypto/stm32/stm32-cryp.c                  |    2 +-
 drivers/crypto/stm32/stm32-hash.c                  |    2 +-
 drivers/crypto/talitos.c                           |    2 +-
 drivers/crypto/tegra/tegra-se-aes.c                |    2 -
 drivers/crypto/tegra/tegra-se-main.c               |    4 +-
 .../crypto/virtio/virtio_crypto_akcipher_algs.c    |   65 +-
 drivers/crypto/xilinx/zynqmp-aes-gcm.c             |    2 +-
 drivers/crypto/xilinx/zynqmp-sha.c                 |    2 +-
 include/crypto/akcipher.h                          |   69 +-
 include/crypto/internal/akcipher.h                 |    4 +-
 include/crypto/internal/ecc.h                      |   14 +
 include/crypto/internal/rsa.h                      |   29 +
 include/crypto/internal/sig.h                      |   80 +
 include/crypto/public_key.h                        |    3 -
 include/crypto/sig.h                               |  152 +-
 include/linux/asn1_decoder.h                       |    1 +
 include/linux/asn1_encoder.h                       |    1 -
 include/linux/hisi_acc_qm.h                        |   56 +-
 include/linux/slab.h                               |    1 +
 include/uapi/linux/cryptouser.h                    |    5 +
 include/uapi/linux/virtio_crypto.h                 |    1 +
 kernel/padata.c                                    |    7 -
 lib/crc32.c                                        |    4 +
 lib/crypto/Makefile                                |    2 +
 lib/crypto/mpi/mpi-bit.c                           |    1 +
 lib/crypto/mpi/mpi-mul.c                           |    2 +-
 lib/crypto/simd.c                                  |   11 +
 security/integrity/ima/ima_main.c                  |    6 +-
 171 files changed, 6125 insertions(+), 4265 deletions(-)
 create mode 100644 Documentation/crypto/api-sig.rst
 create mode 100644 Documentation/devicetree/bindings/rng/airoha,en7581-trng.yaml
 create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm74110-rng.yaml
 rename Documentation/devicetree/bindings/rng/{omap_rng.yaml => inside-secure,safexcel-eip76.yaml} (79%)
 create mode 100644 crypto/ecdsa-p1363.c
 create mode 100644 crypto/ecdsa-x962.c
 create mode 100644 crypto/rsassa-pkcs1.c
 create mode 100644 drivers/char/hw_random/airoha-trng.c
 create mode 100644 drivers/char/hw_random/bcm74110-rng.c
 create mode 100644 lib/crypto/simd.c

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
