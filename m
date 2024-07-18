Received: from norbury.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E991713EFF3;
	Thu, 18 Jul 2024 13:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721310583; cv=none; b=Wz+9nuigAVj5srW/FBS1/t4lA0d5aVGGWhALsOD9ynfZvQnL+O/DXE4T9k3H47EzBOtYoi3D6e1qWanDk0+bRFTsEu7fHVJj4fyx+meUQuvQhTpCZXbJUV1o0aQUmTly64U5+cFq+jq0JV5LLyRRYvJ1sABXVjg6FKecommVMn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721310583; c=relaxed/simple;
	bh=J9KCo5f8uen/bxXMvzz73npaRCUfWsQFO8n+RVBqGEQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YtuoVH6+xHefoOTTe8xIAfCaIQYjiIGBCiUmFlqGi0UBdOuAEZRrnt1TE3eWBOEqV6P6GiemuS1N/MQj/iUi9mElj1zHPehQEtki7Nv0cwgu6JOIIBY61arWWKsGG7xba4uRTIN4T/z2oxUxJ5jzMJZRVqlBtEV9GCTpDe3477M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sURVR-003Wte-1C;
	Thu, 18 Jul 2024 23:49:14 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Jul 2024 01:49:26 +1200
Date: Fri, 19 Jul 2024 01:49:26 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 6.11
Message-ID: <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
References: <Yzv0wXi4Uu2WND37@gondor.apana.org.au>
 <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZkGN64ulwzPVvn6-@gondor.apana.org.au>

Hi Linus:

The following changes since commit 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0:

  Linux 6.10-rc1 (2024-05-26 15:20:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.11-p1 

for you to fetch changes up to df1e9791998a92fe9f1e7d3f031b34daaad39e2f:

  hwrng: core - remove (un)register_miscdev() (2024-07-13 11:50:28 +1200)

----------------------------------------------------------------
This update includes the following changes:

API:

- Test setkey in no-SIMD context.
- Add skcipher speed test for user-specified algorithm.

Algorithms:

- Add x25519 support on ppc64le.
- Add VAES and AVX512 / AVX10 optimized AES-GCM on x86.
- Remove sm2 algorithm.

Drivers:

- Add Allwinner H616 support to sun8i-ce.
- Use DMA in stm32.
- Add Exynos850 hwrng support to exynos.
----------------------------------------------------------------

Andre Przywara (3):
      dt-bindings: crypto: sun8i-ce: Add compatible for H616
      crypto: sun8i-ce - wrap accesses to descriptor address fields
      crypto: sun8i-ce - add Allwinner H616 support

Andy Shevchenko (1):
      hwrng: core - Remove list.h from the hw_random.h

Ard Biesheuvel (1):
      crypto: arm/crc32 - add kCFI annotations to asm routines

Chenghai Huang (2):
      crypto: hisilicon/qm - adjust the internal processing sequence of the vf enable and disable
      crypto: hisilicon/zip - optimize the address offset of the reg query function

Christophe JAILLET (1):
      crypto: tegra - Remove an incorrect iommu_fwspec_free() call in tegra_se_remove()

Damian Muszynski (1):
      Documentation: qat: fix auto_reset attribute details

Dan Carpenter (1):
      crypto: lib/mpi - delete unnecessary condition

Danny Tsen (3):
      crypto: ppc/curve25519 - Low-level primitives for ppc64le
      crypto: ppc/curve25519 - Core functions for ppc64le
      crypto: ppc/curve25519 - Update Kconfig and Makefile for ppc64le

David Gstir (1):
      crypto: mxs-dcp - Ensure payload is zero when using key slot

Deming Wang (1):
      crypto: qat - Fix typo

Dr. David Alan Gilbert (4):
      crypto: axis - Remove unused struct 'dbgfs_u32'
      crypto: ccree - Remove unused struct 'tdes_keys'
      crypto: hifn_795x - Remove unused hifn_*_command structs
      crypto: n2 - Remove unused struct 'n2_skcipher_request_context'

Eric Biggers (4):
      crypto: testmgr - test setkey in no-SIMD context
      crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM
      crypto: x86/aes-gcm - rewrite the AES-NI optimized AES-GCM
      crypto: testmgr - generate power-of-2 lengths more often

Francesco Dolcini (1):
      hwrng: Kconfig - Do not enable by default CN10K driver

Greg Kroah-Hartman (1):
      crypto: qat - make adf_ctl_class constant

Harald Freudenberger (1):
      hwrng: core - Fix wrong quality calculation at hw rng registration

Hareshx Sankar Raj (1):
      crypto: qat - fix unintentional re-enabling of error interrupts

Herbert Xu (2):
      crypto: api - Disable boot-test-finished if algapi is a module
      crypto: sm2 - Remove sm2 algorithm

Ilpo Järvinen (1):
      hwrng: amd - Convert PCIBIOS_* return codes to errnos

Jarkko Sakkinen (1):
      crypto: ecdsa - Fix the public key format description

Jeff Johnson (13):
      crypto: Add missing MODULE_DESCRIPTION() macros
      crypto: lib - add missing MODULE_DESCRIPTION() macros
      crypto: x86 - add missing MODULE_DESCRIPTION() macros
      crypto: atmel-sha204a - add missing MODULE_DESCRIPTION() macro
      crypto: keembay - add missing MODULE_DESCRIPTION() macro
      crypto: sa2ul - add missing MODULE_DESCRIPTION() macro
      crypto: xilinx - add missing MODULE_DESCRIPTION() macro
      hwrng: omap - add missing MODULE_DESCRIPTION() macro
      crypto: arm64 - add missing MODULE_DESCRIPTION() macros
      hwrng: drivers - add missing Arm & Cavium MODULE_DESCRIPTION() macros
      crypto: arm/poly1305 - add missing MODULE_DESCRIPTION() macro
      crypto: arm - add missing MODULE_DESCRIPTION() macros
      crypto: lib - add missing MODULE_DESCRIPTION() macros

Jia Jie Ho (2):
      crypto: starfive - Align rsa input data to 32-bit
      crypto: starfive - Fix nent assignment in rsa dec

Jiapeng Chong (2):
      crypto: lib/mpi - Use swap() in mpi_ec_mul_point()
      crypto: lib/mpi - Use swap() in mpi_powm()

Jiwei Sun (1):
      crypto: qat - initialize user_input.lock for rate_limiting

Kim Phillips (1):
      crypto: ccp - Fix null pointer dereference in __sev_snp_shutdown_locked

Kyle Meyer (1):
      crypto: deflate - Add aliases to deflate

Lothar Rubusch (1):
      crypto: atmel-sha204a - fix negated return value

Marek Vasut (3):
      hwrng: stm32 - use pm_runtime_resume_and_get()
      hwrng: stm32 - cache device pointer in struct stm32_rng_private
      hwrng: stm32 - use sizeof(*priv) instead of sizeof(struct stm32_rng_private)

Mario Limonciello (5):
      crypto: ccp - Represent capabilities register as a union
      crypto: ccp - Move security attributes to their own file
      crypto: ccp - align psp_platform_access_msg
      crypto: ccp - Add support for getting security attributes on some older systems
      crypto: ccp - Move message about TSME being enabled later in init

Mark Brown (1):
      crypto: arm64/crc10dif - Raise priority of NEON crct10dif implementation

Masahiro Yamada (1):
      hwrng: core - remove (un)register_miscdev()

Maxime Méré (4):
      crypto: stm32/cryp - use dma when possible
      crypto: stm32/cryp - increase priority
      crypto: stm32/cryp - add CRYPTO_ALG_KERN_DRIVER_ONLY flag
      crypto: stm32/cryp - call finalize with bh disabled

Neil Armstrong (1):
      dt-bindings: rng: meson: add optional power-domains

Nivas Varadharajan Mugunthakumar (1):
      crypto: qat - extend scope of lock in adf_cfg_add_key_value_param()

Sam Protsenko (6):
      dt-bindings: rng: Add Exynos850 support to exynos-trng
      hwrng: exynos - Improve coding style
      hwrng: exynos - Use devm_clk_get_enabled() to get the clock
      hwrng: exynos - Implement bus clock control
      hwrng: exynos - Add SMC based TRNG operation
      hwrng: exynos - Enable Exynos850 support

Sergey Portnoy (1):
      crypto: tcrypt - add skcipher speed for given alg

Stefan Berger (4):
      crypto: ecdsa - Use ecc_digits_from_bytes to create hash digits array
      crypto: ecdsa - Use ecc_digits_from_bytes to convert signature
      crypto: ecc - Add comment to ecc_digits_from_bytes about input byte array
      crypto: ecc - Fix off-by-one missing to clear most significant digit

Tony Luck (2):
      crypto: x86/twofish - Switch to new Intel CPU model defines
      crypto: x86/poly1305 - Switch to new Intel CPU model defines

 Documentation/ABI/testing/sysfs-driver-qat         |    4 +-
 .../bindings/crypto/allwinner,sun8i-ce.yaml        |    2 +
 .../devicetree/bindings/rng/amlogic,meson-rng.yaml |    3 +
 .../bindings/rng/samsung,exynos5250-trng.yaml      |   40 +-
 MAINTAINERS                                        |    6 +
 arch/arm/crypto/aes-neonbs-glue.c                  |    1 +
 arch/arm/crypto/crc32-ce-core.S                    |   17 +-
 arch/arm/crypto/crc32-ce-glue.c                    |    1 +
 arch/arm/crypto/crct10dif-ce-glue.c                |    1 +
 arch/arm/crypto/curve25519-glue.c                  |    1 +
 arch/arm/crypto/poly1305-glue.c                    |    1 +
 arch/arm64/crypto/aes-neonbs-glue.c                |    1 +
 arch/arm64/crypto/crct10dif-ce-glue.c              |    3 +-
 arch/arm64/crypto/poly1305-glue.c                  |    1 +
 arch/powerpc/crypto/Kconfig                        |   11 +
 arch/powerpc/crypto/Makefile                       |    2 +
 arch/powerpc/crypto/curve25519-ppc64le-core.c      |  299 +++
 arch/powerpc/crypto/curve25519-ppc64le_asm.S       |  671 +++++
 arch/x86/crypto/Kconfig                            |    1 +
 arch/x86/crypto/Makefile                           |    8 +-
 arch/x86/crypto/aes-gcm-aesni-x86_64.S             | 1128 ++++++++
 arch/x86/crypto/aes-gcm-avx10-x86_64.S             | 1222 +++++++++
 arch/x86/crypto/aesni-intel_asm.S                  | 1503 +----------
 arch/x86/crypto/aesni-intel_avx-x86_64.S           | 2804 --------------------
 arch/x86/crypto/aesni-intel_glue.c                 | 1269 +++++----
 arch/x86/crypto/crc32-pclmul_glue.c                |    1 +
 arch/x86/crypto/curve25519-x86_64.c                |    1 +
 arch/x86/crypto/poly1305_glue.c                    |    4 +-
 arch/x86/crypto/twofish_glue_3way.c                |    9 +-
 crypto/Kconfig                                     |   18 -
 crypto/Makefile                                    |    8 -
 crypto/af_alg.c                                    |    1 +
 crypto/algapi.c                                    |    3 +
 crypto/algif_hash.c                                |    1 +
 crypto/algif_skcipher.c                            |    1 +
 crypto/api.c                                       |    4 +-
 crypto/asymmetric_keys/pkcs7_parser.c              |    4 -
 crypto/asymmetric_keys/public_key.c                |    7 -
 crypto/asymmetric_keys/x509_cert_parser.c          |   16 -
 crypto/asymmetric_keys/x509_public_key.c           |   17 +-
 crypto/cast_common.c                               |    1 +
 crypto/curve25519-generic.c                        |    1 +
 crypto/deflate.c                                   |    1 +
 crypto/ecc.c                                       |    3 +-
 crypto/ecdsa.c                                     |   34 +-
 crypto/internal.h                                  |    7 +-
 crypto/simd.c                                      |    1 +
 crypto/sm2.c                                       |  498 ----
 crypto/sm2signature.asn1                           |    4 -
 crypto/tcrypt.c                                    |    9 +
 crypto/testmgr.c                                   |   51 +-
 crypto/testmgr.h                                   |   59 -
 crypto/xor.c                                       |    1 +
 drivers/char/hw_random/Kconfig                     |    1 -
 drivers/char/hw_random/amd-rng.c                   |    4 +-
 drivers/char/hw_random/arm_smccc_trng.c            |    1 +
 drivers/char/hw_random/cavium-rng-vf.c             |    1 +
 drivers/char/hw_random/cavium-rng.c                |    1 +
 drivers/char/hw_random/core.c                      |   18 +-
 drivers/char/hw_random/exynos-trng.c               |  217 +-
 drivers/char/hw_random/omap-rng.c                  |    1 +
 drivers/char/hw_random/omap3-rom-rng.c             |    1 +
 drivers/char/hw_random/stm32-rng.c                 |   35 +-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |    8 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |   28 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c  |    6 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c  |    6 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c  |    2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |   15 +
 drivers/crypto/atmel-sha204a.c                     |    3 +-
 drivers/crypto/axis/artpec6_crypto.c               |    7 -
 drivers/crypto/ccp/Makefile                        |    3 +-
 drivers/crypto/ccp/dbc.c                           |    2 +-
 drivers/crypto/ccp/hsti.c                          |  138 +
 drivers/crypto/ccp/hsti.h                          |   17 +
 drivers/crypto/ccp/psp-dev.c                       |   23 +-
 drivers/crypto/ccp/psp-dev.h                       |   46 +-
 drivers/crypto/ccp/sev-dev.c                       |    8 +-
 drivers/crypto/ccp/sp-dev.h                        |    2 +-
 drivers/crypto/ccp/sp-pci.c                        |   67 +-
 drivers/crypto/ccree/cc_cipher.c                   |    6 -
 drivers/crypto/hifn_795x.c                         |   17 -
 drivers/crypto/hisilicon/qm.c                      |   11 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |   48 +-
 drivers/crypto/intel/keembay/ocs-hcu.c             |    1 +
 drivers/crypto/intel/qat/qat_common/adf_cfg.c      |    6 +-
 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c  |   21 +-
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c  |    2 +-
 .../crypto/intel/qat/qat_common/adf_gen2_pfvf.c    |    4 +-
 drivers/crypto/intel/qat/qat_common/adf_rl.c       |    1 +
 .../intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c  |    8 +-
 drivers/crypto/mxs-dcp.c                           |    3 +-
 drivers/crypto/n2_core.c                           |    4 -
 drivers/crypto/sa2ul.c                             |    1 +
 drivers/crypto/starfive/jh7110-cryp.h              |    4 +-
 drivers/crypto/starfive/jh7110-rsa.c               |   15 +-
 drivers/crypto/stm32/stm32-cryp.c                  |  719 ++++-
 drivers/crypto/tegra/tegra-se-main.c               |    1 -
 drivers/crypto/xilinx/zynqmp-aes-gcm.c             |    1 +
 include/crypto/internal/ecc.h                      |    3 +
 include/crypto/sm2.h                               |   28 -
 include/linux/hw_random.h                          |    3 +-
 include/linux/psp-platform-access.h                |    5 +-
 lib/crypto/arc4.c                                  |    1 +
 lib/crypto/des.c                                   |    1 +
 lib/crypto/libchacha.c                             |    1 +
 lib/crypto/mpi/ec.c                                |    6 +-
 lib/crypto/mpi/mpi-bit.c                           |   10 +-
 lib/crypto/mpi/mpi-pow.c                           |    9 +-
 lib/crypto/poly1305.c                              |    1 +
 lib/crypto/sha1.c                                  |    1 +
 lib/crypto/sha256.c                                |    1 +
 lib/crypto/utils.c                                 |    1 +
 security/integrity/digsig_asymmetric.c             |    3 +-
 114 files changed, 5480 insertions(+), 5893 deletions(-)
 create mode 100644 arch/powerpc/crypto/curve25519-ppc64le-core.c
 create mode 100644 arch/powerpc/crypto/curve25519-ppc64le_asm.S
 create mode 100644 arch/x86/crypto/aes-gcm-aesni-x86_64.S
 create mode 100644 arch/x86/crypto/aes-gcm-avx10-x86_64.S
 delete mode 100644 arch/x86/crypto/aesni-intel_avx-x86_64.S
 delete mode 100644 crypto/sm2.c
 delete mode 100644 crypto/sm2signature.asn1
 create mode 100644 drivers/crypto/ccp/hsti.c
 create mode 100644 drivers/crypto/ccp/hsti.h
 delete mode 100644 include/crypto/sm2.h

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
