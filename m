Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC88145FE7;
	Mon, 13 May 2024 03:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715572218; cv=none; b=XEne2vazAR6coq5FuvNYZWCA1vcBvxMN064CLDzBdM0w4MaFYKrIP9/QnoyFvFYk7Jc8KffAt6O5siM2VRv3bdQvvuteLvYQ3KwokRdCWeriw6Ijuee02fohmYwb7C/FT5MsVIeFZI31tu04xJqclZpZ0tJUqz36rUSfLFJodlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715572218; c=relaxed/simple;
	bh=YQsXCOsVVBa8qOy+/hFqzFoGl9riWQ6K5Zfnn8qGWqY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g1ura/FRQ3LQLW9omkc/b4CN5dM6axQ5sKxPW2OFqu93RI/FZMsmjmKeqfeMJnbrwYyqA/wN+z94cb1b4LpV7Nci9ZbKNj5rTvjkaOgfKGxETIkjX11a2ORoUZjDq2S8cbEg2VCTamt/Q3y3qyntqtDFzQyBhFfKBcdD5biEnFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s6MhO-00EQVN-1v;
	Mon, 13 May 2024 11:50:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 May 2024 11:50:03 +0800
Date: Mon, 13 May 2024 11:50:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 6.10
Message-ID: <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
References: <Yui+kNeY+Qg4fKVl@gondor.apana.org.au>
 <Yzv0wXi4Uu2WND37@gondor.apana.org.au>
 <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>

Hi Linus:

The following changes since commit 174fdc93a241af54772ae3e745ec719e9f6cebfc:

  Merge tag 'v6.9-p2' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 (2024-03-25 10:48:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.10-p1 

for you to fetch changes up to 13909a0c88972c5ef5d13f44d1a8bf065a31bdf4:

  crypto: atmel-sha204a - provide the otp content (2024-05-10 17:15:25 +0800)

----------------------------------------------------------------
This update includes the following changes:

API:

- Remove crypto stats interface.

Algorithms:

- Add faster AES-XTS on modern x86_64 CPUs.
- Forbid curves with order less than 224 bits in ecc (FIPS 186-5).
- Add ECDSA NIST P521.

Drivers:

- Expose otp zone in atmel.
- Add dh fallback for primes > 4K in qat.
- Add interface for live migration in qat.
- Use dma for aes requests in starfive.
- Add full DMA support for stm32mpx in stm32.
- Add Tegra Security Engine driver.

Others:

- Introduce scope-based x509_certificate allocation.
----------------------------------------------------------------

Adam Guerin (2):
      crypto: qat - improve error message in adf_get_arbiter_mapping()
      crypto: qat - improve error logging to be consistent across features

Akhil R (3):
      dt-bindings: crypto: Add Tegra Security Engine
      gpu: host1x: Add Tegra SE to SID table
      crypto: tegra - Add Tegra Security Engine driver

Aleksandr Mishin (1):
      crypto: bcm - Fix pointer arithmetic

Animesh Agarwal (1):
      dt-bindings: crypto: ti,omap-sham: Convert to dtschema

Ard Biesheuvel (1):
      crypto: arm64/aes-ce - Simplify round key load sequence

Arnd Bergmann (1):
      crypto: ccp - drop platform ifdef checks

Chang S. Bae (2):
      crypto: x86/aesni - Rearrange AES key size check
      crypto: x86/aesni - Update aesni_set_key() to return void

Chen Ni (1):
      crypto: octeontx2 - add missing check for dma_map_single

Chenghai Huang (10):
      crypto: hisilicon/sec - Add the condition for configuring the sriov function
      crypto: hisilicon/debugfs - Fix debugfs uninit process issue
      crypto: hisilicon/sgl - Delete redundant parameter verification
      crypto: hisilicon/debugfs - Fix the processing logic issue in the debugfs creation
      crypto: hisilicon/qm - Add the default processing branch
      crypto: hisilicon - Adjust debugfs creation and release order
      crypto: hisilicon/sec - Fix memory leak for sec resource release
      crypto: hisilicon/debugfs - Resolve the problem of applying for redundant space in sq dump
      crypto: hisilicon/qm - Add the err memory release process to qm uninit
      crypto: hisilicon/debugfs - mask the unnecessary info from the dump

Colin Ian King (1):
      crypto: qat - Fix spelling mistake "Invalide" -> "Invalid"

Damian Muszynski (1):
      crypto: qat - implement dh fallback for primes > 4K

Dan Carpenter (1):
      crypto: tegra - Fix some error codes

Eric Biggers (24):
      crypto: remove CONFIG_CRYPTO_STATS
      x86: add kconfig symbols for assembler VAES and VPCLMULQDQ support
      crypto: x86/aes-xts - add AES-XTS assembly macro for modern CPUs
      crypto: x86/aes-xts - wire up AESNI + AVX implementation
      crypto: x86/aes-xts - wire up VAES + AVX2 implementation
      crypto: x86/aes-xts - wire up VAES + AVX10/256 implementation
      crypto: x86/aes-xts - wire up VAES + AVX10/512 implementation
      crypto: x86/nh-avx2 - add missing vzeroupper
      crypto: x86/sha256-avx2 - add missing vzeroupper
      crypto: x86/sha512-avx2 - add missing vzeroupper
      crypto: x86/aes-xts - make non-AVX implementation use new glue code
      crypto: x86/aes-xts - access round keys using single-byte offsets
      crypto: x86/sha256-ni - convert to use rounds macros
      crypto: x86/sha256-ni - rename some register aliases
      crypto: x86/sha256-ni - optimize code size
      crypto: x86/sha256-ni - simplify do_4rounds
      crypto: x86/aes-xts - handle CTS encryption more efficiently
      crypto: x86/aesni-xts - deduplicate aesni_xts_enc() and aesni_xts_dec()
      crypto: x86/aes-xts - handle AES-128 and AES-192 more efficiently
      crypto: x86/aes-xts - eliminate a few more instructions
      crypto: x86/aes-xts - optimize size of instructions operating on lengths
      crypto: x86/aes-xts - simplify loop in xts_crypt_slowpath()
      crypto: x86/aes-gcm - delete unused GCM assembly code
      crypto: x86/aes-gcm - simplify GCM hash subkey derivation

Geert Uytterhoeven (1):
      dt-bindings: crypto: starfive: Restore sort order

Giovanni Cabiddu (3):
      crypto: qat - adf_get_etr_base() helper
      crypto: qat - relocate CSR access code
      crypto: qat - specify firmware files for 402xx

Gustavo A. R. Silva (2):
      crypto: nx - Avoid -Wflex-array-member-not-at-end warning
      crypto: qat - Avoid -Wflex-array-member-not-at-end warnings

Hailey Mothershead (1):
      crypto: aead,cipher - zeroize key buffer after use

Herbert Xu (1):
      padata: Disable BH when taking works lock on MT path

Jerry Snitselaar (1):
      crypto: iaa - Fix some errors in IAA documentation

Jia Jie Ho (8):
      dt-bindings: crypto: starfive: Add jh8100 support
      crypto: starfive - Update hash dma usage
      crypto: starfive - Skip unneeded key free
      crypto: starfive - Use dma for aes requests
      crypto: starfive - Skip dma setup for zeroed message
      crypto: starfive - Skip unneeded fallback allocation
      crypto: starfive - Do not free stack buffer
      crypto: starfive - Use fallback for unaligned dma access

Joachim Vandersmissen (2):
      crypto: ecc - update ecc_gen_privkey for FIPS 186-5
      crypto: ecdh - explicitly zeroize private_key

Joel Granados (1):
      crypto: fips - Remove the now superfluous sentinel element from ctl_table array

Li Zhijian (1):
      hwrng: core - Convert sprintf/snprintf to sysfs_emit

Lothar Rubusch (4):
      crypto: atmel-i2c - add missing arg description
      crypto: atmel-i2c - rename read function
      crypto: atmel-sha204a - add reading from otp zone
      crypto: atmel-sha204a - provide the otp content

Luca Weiss (1):
      dt-bindings: crypto: ice: Document sc7280 inline crypto engine

Lucas Segarra Fernandez (1):
      crypto: qat - validate slices count returned by FW

Lukas Wunner (1):
      X.509: Introduce scope-based x509_certificate allocation

Marek Vasut (3):
      hwrng: stm32 - use logical OR in conditional
      hwrng: stm32 - put IP into RPM suspend on failure
      hwrng: stm32 - repair clock handling

Maxime Méré (1):
      crypto: stm32/hash - add full DMA support for stm32mpx

Pankaj Gupta (2):
      crypto: caam - init-clk based on caam-page0-access
      crypto: caam - i.MX8ULP donot have CAAM page0 access

Roman Smirnov (2):
      crypto: ecc - remove checks in crypto_ecdh_shared_secret() and ecc_make_pub_key()
      crypto: algboss - remove NULL check in cryptomgr_schedule_probe()

Siming Wan (3):
      crypto: qat - rename get_sla_arr_of_type()
      crypto: qat - expand CSR operations for QAT GEN4 devices
      crypto: qat - add bank save and restore flows

Stefan Berger (16):
      crypto: ecdsa - Fix module auto-load on add-key
      crypto: ecc - Use ECC_CURVE_NIST_P192/256/384_DIGITS where possible
      crypto: ecdsa - Convert byte arrays with key coordinates to digits
      crypto: ecdsa - Adjust tests on length of key parameters
      crypto: ecdsa - Extend res.x mod n calculation for NIST P521
      crypto: ecc - Add nbits field to ecc_curve structure
      crypto: ecc - Implement vli_mmod_fast_521 for NIST p521
      crypto: ecc - Add special case for NIST P521 in ecc_point_mult
      crypto: ecc - Add NIST P521 curve parameters
      crypto: ecdsa - Replace ndigits with nbits where precision is needed
      crypto: ecdsa - Rename keylen to bufsize where necessary
      crypto: ecdsa - Register NIST P521 and extend test suite
      crypto: asymmetric_keys - Adjust signature size calculation for NIST P521
      crypto: x509 - Add OID for NIST P521 and extend parser for it
      crypto: ecdh - Pass private key in proper byte order to check valid key
      crypto: ecdh - Initialize ctx->private_key in proper byte order

Thorsten Blum (4):
      crypto: jitter - Use kvfree_sensitive() to fix Coccinelle warning
      crypto: jitter - Remove duplicate word in comment
      crypto: jitter - Replace http with https
      crypto: iaa - Use kmemdup() instead of kzalloc() and memcpy()

Tom Zanussi (5):
      crypto: iaa - fix decomp_bytes_in stats
      crypto: iaa - Remove comp/decomp delay statistics
      crypto: iaa - Add global_stats file and remove individual stat files
      crypto: iaa - Change iaa statistics to atomic64_t
      crypto: iaa - Use cpumask_weight() when rebalancing

Uwe Kleine-König (2):
      hwrng: mxc-rnga - Drop usage of platform_driver_probe()
      crypto: tegra - Convert to platform remove callback returning void

Vitaly Chikunov (1):
      crypto: ecrdsa - Fix module auto-load on add_key

Wenkai Lin (1):
      crypto: hisilicon/sec2 - fix for register offset

Wolfram Sang (2):
      crypto: api - use 'time_left' variable with wait_for_completion_killable_timeout()
      crypto: sahara - use 'time_left' variable with wait_for_completion_timeout()

Xin Zeng (4):
      crypto: qat - relocate and rename 4xxx PF2VM definitions
      crypto: qat - move PFVF compat checker to a function
      crypto: qat - add interface for live migration
      crypto: qat - implement interface for live migration

 .../bindings/crypto/nvidia,tegra234-se-aes.yaml    |   52 +
 .../bindings/crypto/nvidia,tegra234-se-hash.yaml   |   52 +
 .../devicetree/bindings/crypto/omap-sham.txt       |   28 -
 .../bindings/crypto/qcom,inline-crypto-engine.yaml |    1 +
 .../bindings/crypto/starfive,jh7110-crypto.yaml    |   30 +-
 .../devicetree/bindings/crypto/ti,omap-sham.yaml   |   56 +
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst |   96 +-
 MAINTAINERS                                        |    5 +
 arch/arm64/crypto/aes-ce.S                         |   34 +-
 arch/arm64/crypto/aes-neon.S                       |   20 +-
 arch/s390/configs/debug_defconfig                  |    1 -
 arch/s390/configs/defconfig                        |    1 -
 arch/x86/Kconfig.assembler                         |   10 +
 arch/x86/crypto/Makefile                           |    3 +-
 arch/x86/crypto/aes-xts-avx-x86_64.S               |  845 +++++++++
 arch/x86/crypto/aesni-intel_asm.S                  |  469 +----
 arch/x86/crypto/aesni-intel_glue.c                 |  420 +++--
 arch/x86/crypto/nh-avx2-x86_64.S                   |    1 +
 arch/x86/crypto/sha256-avx2-asm.S                  |    1 +
 arch/x86/crypto/sha256_ni_asm.S                    |  251 +--
 arch/x86/crypto/sha512-avx2-asm.S                  |    1 +
 crypto/Kconfig                                     |   20 -
 crypto/Makefile                                    |    2 -
 crypto/acompress.c                                 |   33 -
 crypto/aead.c                                      |   87 +-
 crypto/ahash.c                                     |   63 +-
 crypto/akcipher.c                                  |   31 -
 crypto/algboss.c                                   |    3 -
 crypto/api.c                                       |    8 +-
 crypto/asymmetric_keys/public_key.c                |   14 +-
 crypto/asymmetric_keys/x509_cert_parser.c          |   46 +-
 crypto/asymmetric_keys/x509_parser.h               |    3 +
 crypto/asymmetric_keys/x509_public_key.c           |   31 +-
 crypto/cipher.c                                    |    3 +-
 crypto/compress.h                                  |    3 -
 crypto/{crypto_user_base.c => crypto_user.c}       |   10 +-
 crypto/crypto_user_stat.c                          |  176 --
 crypto/ecc.c                                       |  100 +-
 crypto/ecc_curve_defs.h                            |   49 +
 crypto/ecdh.c                                      |   11 +-
 crypto/ecdsa.c                                     |   66 +-
 crypto/ecrdsa.c                                    |    1 +
 crypto/ecrdsa_defs.h                               |    5 +
 crypto/fips.c                                      |    1 -
 crypto/hash.h                                      |   30 -
 crypto/jitterentropy-kcapi.c                       |    3 +-
 crypto/jitterentropy.c                             |    4 +-
 crypto/kpp.c                                       |   30 -
 crypto/lskcipher.c                                 |   73 +-
 crypto/rng.c                                       |   44 +-
 crypto/scompress.c                                 |    3 -
 crypto/shash.c                                     |   75 +-
 crypto/sig.c                                       |   13 -
 crypto/skcipher.c                                  |   86 +-
 crypto/skcipher.h                                  |   10 -
 crypto/testmgr.c                                   |    7 +
 crypto/testmgr.h                                   |  146 ++
 drivers/char/hw_random/core.c                      |    2 +-
 drivers/char/hw_random/mxc-rnga.c                  |    9 +-
 drivers/char/hw_random/stm32-rng.c                 |   18 +-
 drivers/crypto/Kconfig                             |    8 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/atmel-i2c.c                         |   30 +-
 drivers/crypto/atmel-i2c.h                         |    8 +-
 drivers/crypto/atmel-sha204a.c                     |   68 +
 drivers/crypto/bcm/spu2.c                          |    2 +-
 drivers/crypto/caam/ctrl.c                         |   19 +-
 drivers/crypto/ccp/sp-platform.c                   |   14 +-
 drivers/crypto/hisilicon/debugfs.c                 |   65 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   23 +-
 drivers/crypto/hisilicon/qm.c                      |    8 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |    4 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |   32 +-
 drivers/crypto/hisilicon/sgl.c                     |    5 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |   24 +-
 drivers/crypto/intel/iaa/iaa_crypto.h              |   16 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |   23 +-
 drivers/crypto/intel/iaa/iaa_crypto_stats.c        |  183 +-
 drivers/crypto/intel/iaa/iaa_crypto_stats.h        |    8 -
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |    5 +-
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   |    7 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c        |    2 +
 .../crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c |    1 +
 .../intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c    |    1 +
 .../crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c   |    1 +
 .../intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c      |    1 +
 drivers/crypto/intel/qat/qat_common/Makefile       |    6 +-
 .../intel/qat/qat_common/adf_accel_devices.h       |   88 +
 .../crypto/intel/qat/qat_common/adf_common_drv.h   |   10 +
 .../intel/qat/qat_common/adf_gen2_hw_csr_data.c    |  101 +
 .../intel/qat/qat_common/adf_gen2_hw_csr_data.h    |   86 +
 .../crypto/intel/qat/qat_common/adf_gen2_hw_data.c |   97 -
 .../crypto/intel/qat/qat_common/adf_gen2_hw_data.h |   76 -
 .../intel/qat/qat_common/adf_gen4_hw_csr_data.c    |  231 +++
 .../intel/qat/qat_common/adf_gen4_hw_csr_data.h    |  188 ++
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.c |  380 +++-
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.h |  127 +-
 .../crypto/intel/qat/qat_common/adf_gen4_pfvf.c    |    8 +-
 drivers/crypto/intel/qat/qat_common/adf_gen4_tl.c  |    1 +
 .../crypto/intel/qat/qat_common/adf_gen4_vf_mig.c  | 1010 ++++++++++
 .../crypto/intel/qat/qat_common/adf_gen4_vf_mig.h  |   10 +
 .../crypto/intel/qat/qat_common/adf_mstate_mgr.c   |  318 ++++
 .../crypto/intel/qat/qat_common/adf_mstate_mgr.h   |   89 +
 .../intel/qat/qat_common/adf_pfvf_pf_proto.c       |    8 +-
 .../crypto/intel/qat/qat_common/adf_pfvf_utils.h   |   11 +
 drivers/crypto/intel/qat/qat_common/adf_rl.c       |   12 +-
 drivers/crypto/intel/qat/qat_common/adf_rl.h       |    2 +
 drivers/crypto/intel/qat/qat_common/adf_sriov.c    |    7 +-
 .../crypto/intel/qat/qat_common/adf_telemetry.c    |   21 +
 .../crypto/intel/qat/qat_common/adf_telemetry.h    |    1 +
 .../crypto/intel/qat/qat_common/adf_transport.c    |    4 +-
 .../crypto/intel/qat/qat_common/qat_asym_algs.c    |   66 +-
 drivers/crypto/intel/qat/qat_common/qat_bl.c       |    6 +-
 drivers/crypto/intel/qat/qat_common/qat_bl.h       |   11 +-
 drivers/crypto/intel/qat/qat_common/qat_mig_dev.c  |  130 ++
 .../intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c  |    1 +
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |    1 +
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c       |    4 +
 drivers/crypto/nx/nx-842.c                         |    6 +-
 drivers/crypto/nx/nx-842.h                         |   10 +-
 drivers/crypto/sahara.c                            |   16 +-
 drivers/crypto/starfive/Kconfig                    |    4 +
 drivers/crypto/starfive/jh7110-aes.c               |  603 ++++--
 drivers/crypto/starfive/jh7110-cryp.c              |   43 -
 drivers/crypto/starfive/jh7110-cryp.h              |   10 +-
 drivers/crypto/starfive/jh7110-hash.c              |  285 ++-
 drivers/crypto/starfive/jh7110-rsa.c               |   14 +-
 drivers/crypto/stm32/stm32-hash.c                  |  570 ++++--
 drivers/crypto/tegra/Makefile                      |    9 +
 drivers/crypto/tegra/tegra-se-aes.c                | 1933 ++++++++++++++++++++
 drivers/crypto/tegra/tegra-se-hash.c               | 1060 +++++++++++
 drivers/crypto/tegra/tegra-se-key.c                |  156 ++
 drivers/crypto/tegra/tegra-se-main.c               |  437 +++++
 drivers/crypto/tegra/tegra-se.h                    |  560 ++++++
 drivers/gpu/host1x/dev.c                           |   24 +
 include/crypto/acompress.h                         |   73 +-
 include/crypto/aead.h                              |   21 -
 include/crypto/akcipher.h                          |   78 +-
 include/crypto/algapi.h                            |    3 -
 include/crypto/ecc_curve.h                         |    2 +
 include/crypto/ecdh.h                              |    1 +
 include/crypto/hash.h                              |   22 -
 include/crypto/internal/acompress.h                |    1 -
 include/crypto/internal/cryptouser.h               |   16 -
 include/crypto/internal/ecc.h                      |   27 +-
 include/crypto/internal/scompress.h                |    1 -
 include/crypto/kpp.h                               |   58 +-
 include/crypto/rng.h                               |   51 +-
 include/crypto/skcipher.h                          |   25 -
 include/linux/compiler.h                           |    2 +
 include/linux/oid_registry.h                       |    1 +
 include/linux/qat/qat_mig_dev.h                    |   31 +
 include/uapi/linux/cryptouser.h                    |   30 +-
 kernel/padata.c                                    |    8 +-
 154 files changed, 10335 insertions(+), 3222 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/nvidia,tegra234-se-aes.yaml
 create mode 100644 Documentation/devicetree/bindings/crypto/nvidia,tegra234-se-hash.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/omap-sham.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml
 create mode 100644 arch/x86/crypto/aes-xts-avx-x86_64.S
 rename crypto/{crypto_user_base.c => crypto_user.c} (98%)
 delete mode 100644 crypto/crypto_user_stat.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen2_hw_csr_data.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_csr_data.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/qat_mig_dev.c
 create mode 100644 drivers/crypto/tegra/Makefile
 create mode 100644 drivers/crypto/tegra/tegra-se-aes.c
 create mode 100644 drivers/crypto/tegra/tegra-se-hash.c
 create mode 100644 drivers/crypto/tegra/tegra-se-key.c
 create mode 100644 drivers/crypto/tegra/tegra-se-main.c
 create mode 100644 drivers/crypto/tegra/tegra-se.h
 delete mode 100644 include/crypto/internal/cryptouser.h
 create mode 100644 include/linux/qat/qat_mig_dev.h

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
