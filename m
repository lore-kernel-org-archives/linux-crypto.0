Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77E128F5;
	Mon,  1 Dec 2025 10:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764584199; cv=none; b=jRL+ja4spAteG5GDYDzzGc6mYPKLNUOduyDjMQ0br90RyyJiKhip8XFllZuxtbnCHAAN4zHZrXqNUNOavIazOVqQQAoSwL8nL++bdz444ehD4uUAxk8GdmuaLvB5zOWJ8XjGTQenZDeB2OGwwurM8+fC9gXnVaM/5tZJjSUtLbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764584199; c=relaxed/simple;
	bh=ym5O4vs3mIZONJWFDYfrqUMtb2wccjKFQ9GXWvCl3Uc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LXGeu0XGL7EC9e/cUm6BzwIZnB/lIZRoq0BhW7ItS+PB+Cr9Rw42NhYSXkdrk8JTpGYrru0gT5laMLBCi1LYJg0ETxnwyU11e0ySEMt0jNKUChJ7rW60PYuF6tV5vvMG2hl7Efy7VdQTt3P1AhLr49yIPGxOS8hTmPaIlfACxjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cPqePVYe; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cPqePVYe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=NiTft28qzxGX1QOGSM8soqTvs10q6YaqGGJb9hDzLhk=; b=cPqeP
	VYeddeqTLpsDQdUwqrb339zIYFX1on04f0HUhK2wSf+Ojh0s/+ZCSPsCjQu13DnqPnd1ReRMoctS3
	aXxU+iRfaPyTPpvBRXlAGa/OmcxvAQID7fzq6dJ/LCt1yHFNKb4+sEE7cgZwaBqwwpK8TS/FGxUwe
	5XlO5RnSGC0oaBrHSMq29Xm+0f02JshJtLF8merjz5dVJOhoxMF1abJ6156q7b1SxiwDRjkycgQWi
	oC5IBHdaoiic8ogaeK3yMDkA2AWy1AMNCWNX1Ckv1UUft33UPcY7n2KqRe9qO0KO9IP5D80MzDh3X
	/eq3J6/7fo163iapDDyBY1f0RnexA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vQ0x8-007BGT-2r;
	Mon, 01 Dec 2025 18:16:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 01 Dec 2025 18:16:18 +0800
Date: Mon, 1 Dec 2025 18:16:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 6.19
Message-ID: <aS1q8uJfxD8lTuLH@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.19-p1

for you to fetch changes up to 48bc9da3c97c15f1ea24934bcb3b736acd30163d:

  crypto: zstd - fix double-free in per-CPU stream cleanup (2025-12-01 18:05:07 +0800)

----------------------------------------------------------------
This update includes the following changes:

API:

- Rewrite memcpy_sglist from scratch.
- Add on-stack AEAD request allocation.
- Fix partial block processing in ahash.

Algorithms:

- Remove ansi_cprng.
- Remove tcrypt tests for poly1305.
- Fix EINPROGRESS processing in authenc.
- Fix double-free in zstd.

Drivers:

- Use drbg ctr helper when reseeding xilinx-trng.
- Add support for PCI device 0x115A to ccp.
- Add support of paes in caam.
- Add support for aes-xts in dthev2.

Others:

- Use likely in rhashtable lookup.
- Fix lockdep false-positive in padata by removing a helper.
----------------------------------------------------------------

Ally Heev (1):
      crypto: asymmetric_keys - fix uninitialized pointers with free attribute

Bjorn Andersson (1):
      crypto: qce - Provide dev_err_probe() status on DMA failure

David Laight (4):
      crypto: aesni - ctr_crypt() use min() instead of min_t()
      hwrng: core - use min3() instead of nested min_t()
      crypto: ccp - use min() instead of min_t()
      crypto: lib/mpi - use min() instead of min_t()

Eric Biggers (4):
      crypto: ansi_cprng - Remove unused ansi_cprng algorithm
      crypto: tcrypt - Remove unused poly1305 support
      crypto: scatterwalk - Fix memcpy_sglist() to always succeed
      Revert "crypto: scatterwalk - Move skcipher walk and use it for memcpy_sglist"

Gaurav Kashyap (4):
      dt-bindings: crypto: qcom,inline-crypto-engine: Document the kaanapali ICE
      dt-bindings: crypto: qcom,prng: Document kaanapali RNG
      dt-bindings: crypto: qcom-qce: Document the kaanapli crypto engine
      crypto: qce - fix version check

Giovanni Cabiddu (1):
      crypto: zstd - fix double-free in per-CPU stream cleanup

Gopi Krishna Menon (1):
      docs: trusted-encrypted: fix htmldocs build error

Guangshuo Li (1):
      crypto: caam - Add check for kcalloc() in test_len()

Gustavo A. R. Silva (1):
      KEYS: Avoid -Wflex-array-member-not-at-end warning

Haotian Zhang (2):
      crypto: starfive - Correctly handle return of sg_nents_for_len
      crypto: ccree - Correctly handle return of sg_nents_for_len

Harsh Jain (4):
      crypto: drbg - Export CTR DRBG DF functions
      crypto: drbg - Replace AES cipher calls with library calls
      crypto: xilinx-trng - Add CTR_DRBG DF processing of seed
      crypto: xilinx - Use %pe to print PTR_ERR

Herbert Xu (6):
      crypto: authenc - Correctly pass EINPROGRESS back up to the caller
      crypto: sun8i-ss - Move j init earlier in sun8i_ss_hash_run
      KEYS: trusted: Pass argument by pointer in dump_options
      crypto: drbg - Delete unused ctx from struct sdesc
      crypto: ahash - Fix crypto_ahash_import with partial block data
      crypto: ahash - Zero positive err value in ahash_update_finish

Jonathan McDowell (1):
      hwrng: core - Allow runtime disabling of the HW RNG

Kael D'Alcamo (1):
      dt-bindings: rng: microchip,pic32-rng: convert to DT schema

Kanchana P Sridhar (1):
      crypto: iaa - Request to add Kanchana P Sridhar to Maintainers.

Karina Yankevich (2):
      crypto: drbg - make drbg_{ctr_bcc,kcapi_sym}() return *void*
      crypto: rockchip - drop redundant crypto_skcipher_ivsize() calls

Krzysztof Kozlowski (6):
      hwrng: bcm2835 - Move MODULE_DEVICE_TABLE() to table definition
      hwrng: bcm2835 - Simplify with of_device_get_match_data()
      crypto: artpec6 - Simplify with of_device_get_match_data()
      crypto: ccp - Constify 'dev_vdata' member
      crypto: ccp - Simplify with of_device_get_match_data()
      crypto: cesa - Simplify with of_device_get_match_data()

Marco Crivellari (3):
      crypto: atmel-i2c - add WQ_PERCPU to alloc_workqueue users
      crypto: cavium/nitrox - add WQ_PERCPU to alloc_workqueue users
      crypto: qat - add WQ_PERCPU to alloc_workqueue users

Mario Limonciello (AMD) (1):
      crypto: ccp - Add support for PCI device 0x115A

Meenakshi Aggarwal (3):
      docs: trusted-encrypted: trusted-keys as protected keys
      KEYS: trusted: caam based protected key
      crypto: caam - Add support of paes algorithm

Menglong Dong (1):
      rhashtable: use likely for rhashtable lookup

Rob Herring (Arm) (1):
      dt-bindings: crypto: amd,ccp-seattle-v1a: Allow 'iommus' property

Shivani Agarwal (1):
      crypto: af_alg - zero initialize memory allocated via sock_kmalloc

T Pratham (3):
      crypto: aead - Fix reqsize handling
      crypto: aead - Add support for on-stack AEAD req allocation
      crypto: ti - Add support for AES-XTS in DTHEv2 driver

Tetsuo Handa (1):
      padata: remove __padata_list_init()

Thorsten Blum (10):
      crypto: fips - replace simple_strtol with kstrtoint to improve fips_enable
      crypto: hifn_795x - replace simple_strtoul with kstrtouint
      crypto: asymmetric_keys - prevent overflow in asymmetric_key_generate_id
      keys: Annotate struct asymmetric_key_id with __counted_by
      crypto: qat - use simple_strtoull to improve qat_uclo_parse_num
      crypto: deflate - Use struct_size to improve deflate_alloc_stream
      crypto: octeontx2 - Replace deprecated strcpy in cpt_ucode_load_fw
      crypto: zstd - Annotate struct zstd_ctx with __counted_by
      crypto: zstd - Remove unnecessary size_t cast
      crypto: testmgr - Add missing DES weak and semi-weak key tests

Zilin Guan (1):
      crypto: iaa - Fix incorrect return value in save_iaa_wq()

nieweiqiang (5):
      crypto: hisilicon/qm - restore original qos values
      crypto: hisilicon/qm - add the save operation of eqe and aeqe
      crypto: hisilicon/qm - add concurrency protection for variable err_threshold
      crypto: hisilicon/sgl - remove unnecessary checks for curr_hw_sgl error
      crypto: hisilicon/qm - add missing default in switch in qm_vft_data_cfg

 Documentation/crypto/userspace-if.rst              |   7 +-
 .../bindings/crypto/amd,ccp-seattle-v1a.yaml       |   3 +
 .../bindings/crypto/qcom,inline-crypto-engine.yaml |   1 +
 .../devicetree/bindings/crypto/qcom,prng.yaml      |   1 +
 .../devicetree/bindings/crypto/qcom-qce.yaml       |   1 +
 .../bindings/rng/microchip,pic32-rng.txt           |  17 -
 .../bindings/rng/microchip,pic32-rng.yaml          |  40 ++
 Documentation/security/keys/trusted-encrypted.rst  |  88 +++-
 MAINTAINERS                                        |   2 +-
 arch/arm/configs/axm55xx_defconfig                 |   1 -
 arch/arm/configs/clps711x_defconfig                |   1 -
 arch/arm/configs/dove_defconfig                    |   1 -
 arch/arm/configs/ep93xx_defconfig                  |   1 -
 arch/arm/configs/jornada720_defconfig              |   1 -
 arch/arm/configs/keystone_defconfig                |   1 -
 arch/arm/configs/lpc32xx_defconfig                 |   1 -
 arch/arm/configs/mmp2_defconfig                    |   1 -
 arch/arm/configs/mv78xx0_defconfig                 |   1 -
 arch/arm/configs/omap1_defconfig                   |   1 -
 arch/arm/configs/orion5x_defconfig                 |   1 -
 arch/arm/configs/pxa168_defconfig                  |   1 -
 arch/arm/configs/pxa3xx_defconfig                  |   1 -
 arch/arm/configs/pxa910_defconfig                  |   1 -
 arch/arm/configs/spitz_defconfig                   |   1 -
 arch/arm64/configs/defconfig                       |   1 -
 arch/hexagon/configs/comet_defconfig               |   1 -
 arch/m68k/configs/amcore_defconfig                 |   1 -
 arch/m68k/configs/amiga_defconfig                  |   1 -
 arch/m68k/configs/apollo_defconfig                 |   1 -
 arch/m68k/configs/atari_defconfig                  |   1 -
 arch/m68k/configs/bvme6000_defconfig               |   1 -
 arch/m68k/configs/hp300_defconfig                  |   1 -
 arch/m68k/configs/mac_defconfig                    |   1 -
 arch/m68k/configs/multi_defconfig                  |   1 -
 arch/m68k/configs/mvme147_defconfig                |   1 -
 arch/m68k/configs/mvme16x_defconfig                |   1 -
 arch/m68k/configs/q40_defconfig                    |   1 -
 arch/m68k/configs/stmark2_defconfig                |   1 -
 arch/m68k/configs/sun3_defconfig                   |   1 -
 arch/m68k/configs/sun3x_defconfig                  |   1 -
 arch/mips/configs/decstation_64_defconfig          |   1 -
 arch/mips/configs/decstation_defconfig             |   1 -
 arch/mips/configs/decstation_r4k_defconfig         |   1 -
 arch/s390/configs/debug_defconfig                  |   1 -
 arch/s390/configs/defconfig                        |   1 -
 arch/sh/configs/ap325rxa_defconfig                 |   1 -
 arch/sh/configs/apsh4a3a_defconfig                 |   1 -
 arch/sh/configs/apsh4ad0a_defconfig                |   1 -
 arch/sh/configs/dreamcast_defconfig                |   1 -
 arch/sh/configs/ecovec24_defconfig                 |   1 -
 arch/sh/configs/edosk7760_defconfig                |   1 -
 arch/sh/configs/espt_defconfig                     |   1 -
 arch/sh/configs/hp6xx_defconfig                    |   1 -
 arch/sh/configs/landisk_defconfig                  |   1 -
 arch/sh/configs/lboxre2_defconfig                  |   1 -
 arch/sh/configs/migor_defconfig                    |   1 -
 arch/sh/configs/r7780mp_defconfig                  |   1 -
 arch/sh/configs/r7785rp_defconfig                  |   1 -
 arch/sh/configs/rts7751r2d1_defconfig              |   1 -
 arch/sh/configs/rts7751r2dplus_defconfig           |   1 -
 arch/sh/configs/sdk7780_defconfig                  |   1 -
 arch/sh/configs/sdk7786_defconfig                  |   1 -
 arch/sh/configs/se7206_defconfig                   |   1 -
 arch/sh/configs/se7343_defconfig                   |   1 -
 arch/sh/configs/se7705_defconfig                   |   1 -
 arch/sh/configs/se7712_defconfig                   |   1 -
 arch/sh/configs/se7721_defconfig                   |   1 -
 arch/sh/configs/se7722_defconfig                   |   1 -
 arch/sh/configs/se7724_defconfig                   |   1 -
 arch/sh/configs/se7750_defconfig                   |   1 -
 arch/sh/configs/se7751_defconfig                   |   1 -
 arch/sh/configs/se7780_defconfig                   |   1 -
 arch/sh/configs/sh03_defconfig                     |   1 -
 arch/sh/configs/sh2007_defconfig                   |   1 -
 arch/sh/configs/sh7710voipgw_defconfig             |   1 -
 arch/sh/configs/sh7757lcr_defconfig                |   1 -
 arch/sh/configs/sh7763rdp_defconfig                |   1 -
 arch/sh/configs/sh7785lcr_32bit_defconfig          |   1 -
 arch/sh/configs/sh7785lcr_defconfig                |   1 -
 arch/sh/configs/shmin_defconfig                    |   1 -
 arch/sh/configs/shx3_defconfig                     |   1 -
 arch/sh/configs/titan_defconfig                    |   1 -
 arch/sh/configs/ul2_defconfig                      |   1 -
 arch/sh/configs/urquell_defconfig                  |   1 -
 arch/sparc/configs/sparc32_defconfig               |   1 -
 arch/sparc/configs/sparc64_defconfig               |   1 -
 arch/x86/crypto/aesni-intel_glue.c                 |   3 +-
 arch/xtensa/configs/audio_kc705_defconfig          |   1 -
 arch/xtensa/configs/generic_kc705_defconfig        |   1 -
 arch/xtensa/configs/iss_defconfig                  |   1 -
 arch/xtensa/configs/nommu_kc705_defconfig          |   1 -
 arch/xtensa/configs/smp_lx200_defconfig            |   1 -
 arch/xtensa/configs/virt_defconfig                 |   1 -
 arch/xtensa/configs/xip_kc705_defconfig            |   1 -
 crypto/Kconfig                                     |  21 +-
 crypto/Makefile                                    |   3 +-
 crypto/aead.c                                      |  20 +
 crypto/af_alg.c                                    |   5 +-
 crypto/ahash.c                                     |  18 +-
 crypto/algif_hash.c                                |   3 +-
 crypto/algif_rng.c                                 |   3 +-
 crypto/ansi_cprng.c                                | 474 ---------------------
 crypto/asymmetric_keys/asymmetric_type.c           |  12 +-
 crypto/asymmetric_keys/restrict.c                  |   7 +-
 crypto/asymmetric_keys/x509_cert_parser.c          |   2 +-
 crypto/asymmetric_keys/x509_public_key.c           |   2 +-
 crypto/authenc.c                                   |  75 ++--
 crypto/deflate.c                                   |   3 +-
 crypto/df_sp80090a.c                               | 232 ++++++++++
 crypto/drbg.c                                      | 266 +-----------
 crypto/fips.c                                      |   5 +-
 crypto/scatterwalk.c                               | 343 ++++-----------
 crypto/skcipher.c                                  | 261 +++++++++++-
 crypto/tcrypt.c                                    |   8 -
 crypto/tcrypt.h                                    |  18 -
 crypto/testmgr.c                                   |  97 -----
 crypto/testmgr.h                                   | 226 +++++-----
 crypto/zstd.c                                      |  17 +-
 drivers/char/hw_random/bcm2835-rng.c               |  11 +-
 drivers/char/hw_random/core.c                      |  11 +-
 drivers/crypto/Kconfig                             |   1 +
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |   2 +-
 drivers/crypto/atmel-i2c.c                         |   2 +-
 drivers/crypto/axis/artpec6_crypto.c               |   9 +-
 drivers/crypto/caam/blob_gen.c                     |  86 +++-
 drivers/crypto/caam/caamalg.c                      | 128 +++++-
 drivers/crypto/caam/caamalg_desc.c                 |  87 +++-
 drivers/crypto/caam/caamalg_desc.h                 |  13 +-
 drivers/crypto/caam/caamrng.c                      |   4 +-
 drivers/crypto/caam/desc.h                         |   9 +-
 drivers/crypto/caam/desc_constr.h                  |   8 +-
 drivers/crypto/cavium/nitrox/nitrox_mbx.c          |   2 +-
 drivers/crypto/ccp/ccp-dev.c                       |   2 +-
 drivers/crypto/ccp/sp-dev.h                        |   2 +-
 drivers/crypto/ccp/sp-pci.c                        |  19 +
 drivers/crypto/ccp/sp-platform.c                   |  17 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |   6 +-
 drivers/crypto/hifn_795x.c                         |   7 +-
 drivers/crypto/hisilicon/qm.c                      |  55 ++-
 drivers/crypto/hisilicon/sgl.c                     |   5 -
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |   2 +-
 drivers/crypto/intel/qat/qat_common/adf_aer.c      |   4 +-
 drivers/crypto/intel/qat/qat_common/adf_isr.c      |   3 +-
 drivers/crypto/intel/qat/qat_common/adf_sriov.c    |   3 +-
 drivers/crypto/intel/qat/qat_common/adf_vf_isr.c   |   3 +-
 drivers/crypto/intel/qat/qat_common/qat_uclo.c     |  18 +-
 drivers/crypto/marvell/cesa/cesa.c                 |   7 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |   5 +-
 drivers/crypto/qce/core.c                          |   3 +-
 drivers/crypto/qce/dma.c                           |   6 +-
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c   |   3 +-
 drivers/crypto/starfive/jh7110-hash.c              |   6 +-
 drivers/crypto/ti/Kconfig                          |   1 +
 drivers/crypto/ti/dthev2-aes.c                     | 139 +++++-
 drivers/crypto/ti/dthev2-common.h                  |  10 +-
 drivers/crypto/xilinx/xilinx-trng.c                |  39 +-
 include/crypto/aead.h                              |  87 ++++
 include/crypto/algapi.h                            |  12 +
 include/crypto/df_sp80090a.h                       |  28 ++
 include/crypto/drbg.h                              |  25 +-
 include/crypto/internal/drbg.h                     |  54 +++
 include/crypto/internal/skcipher.h                 |  48 ++-
 include/crypto/rng.h                               |  11 +-
 include/crypto/scatterwalk.h                       | 117 ++---
 include/keys/asymmetric-type.h                     |   2 +-
 include/linux/rhashtable.h                         |  70 ++-
 include/soc/fsl/caam-blob.h                        |  26 ++
 kernel/padata.c                                    |  12 +-
 lib/crypto/mpi/mpicoder.c                          |   2 +-
 security/keys/trusted-keys/trusted_caam.c          | 108 +++++
 170 files changed, 2027 insertions(+), 1681 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/microchip,pic32-rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/microchip,pic32-rng.yaml
 delete mode 100644 crypto/ansi_cprng.c
 create mode 100644 crypto/df_sp80090a.c
 create mode 100644 include/crypto/df_sp80090a.h
 create mode 100644 include/crypto/internal/drbg.h

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
