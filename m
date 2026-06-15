Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5744321B9F6;
	Mon, 15 Jun 2026 03:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781494638; cv=none; b=HssSwjEEOQHBzxrcKA+ejxtuetQdJGRteH54vaaTKtlU9ND9HEc31CzDXIeich666HY6DnudbYF0NHDYm6aNPcJDTQaBN8FnbpvVgJMd8TnF0/6kpuP4yx3epqCPNmv+4D3sI8DwUVVJMA1312R1SsVe8LaizIeIBpvObtY6lME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781494638; c=relaxed/simple;
	bh=5d6sTO6K9jKFJEc4a3qr3Yc8VqbY/Ucn8ZePwH/Pm+E=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LqBanreGNsMHi+zKu6XYd5k9KruLJ5VPOBptfDQP+kkBrcgjcQipydfKIv7tUhl9O4zinQrY+/o/7s1FyljAE/Z6LeS1PitbivKsjoGqbjl5FCqIrTIPAayYbBAA9nlWUdYwWKSNzTdYjeuLQJcrrlC3QfN1SXWGjDCTpZVRzv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Z8VBsAgG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Z8VBsAgG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=QMSJqySUadDVyNGI+yM2VPDXx+axMfmMjDs5h5tsXX8=; b=Z8VBs
	AgGuzeFQsSn6q+o7uxsqkTBblOdKjOwQedZGaDDqKO6bTDPIl+m2fmJU/O7m1f5ug5lyQAcHdutFg
	PWgMThxKgkl2xcZOY+WSg0HjESY5zTOnGWB+lFi7DNd84hiIEHxEUWSuGVB/wVve9jvdJFw22mPH9
	UfksEYfcWGO4v+z3uvh+zhBSHeAxVkNMJ16KFf/xFoZL769Yp3ZG1BDvJXZ+7Yh9BiJo8snlvri9E
	M8GykJ46OcFISGFZXLbjaQfLBcsvvdSvhbvj231E04MFm6J2uG/oT+dL7FaL4rbQsOhqPZwPUy0ss
	n7abe6DnxkLERVcdHX3ZVMploCkmQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wYy8D-00000005Ru8-1zWs;
	Mon, 15 Jun 2026 11:37:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 15 Jun 2026 11:37:01 +0800
Date: Mon, 15 Jun 2026 11:37:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 7.2
Message-ID: <ai9zXTKk9fhCZoKd@gondor.apana.org.au>
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

The following changes since commit d1fa83ecac31093a550534a79a33bc7f4ba8fc10:

  rhashtable: Add bucket_table_free_atomic() helper (2026-05-05 16:12:07 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.2-p1

for you to fetch changes up to 6ea0ce3a19f9c37a014099e2b0a46b27fa164564:

  crypto: tegra - fix refcount leak in tegra_se_host1x_submit() (2026-06-12 09:56:45 +0800)

----------------------------------------------------------------
This update includes the following changes:

API:

- Drop support for off-CPU cryptography in af_alg.
- Document that af_alg is *always* slower.
- Document the deprecation of af_alg.
- Remove zero-copy support from skcipher and aead in af_alg.
- Cap AEAD AD length to 0x80000000 in af_alg.
- Free default RNG on module exit.

Algorithms:

- Fix vli multiplication carry overflow in ecc.
- Drop unused cipher_null crypto_alg.
- Remove unused variants of drbg.
- Use lib/crypto in drbg.
- Use memcpy_from/to_sglist in authencesn.
- Allow authenc(hmac(sha{256,384}),cts(cbc(aes))) in FIPS mode.
- Disallow RSA PKCS#1 SHA-1 sig algs in FIPS mode.
- Filter out async aead implementations at alloc in krb5.
- Fix non-parallel fallback by rstoring callback in pcrypt.
- Validate poly1305 template argument in chacha20poly1305.

Drivers:

- Add sysfs PCI reset support to qat.
- Add KPT support for GEN6 devices to qat.
- Remove unused character device and ioctls from qat.
- Add support for hw access via SMCC to mtk.
- Remove prng support from crypto4xx.
- Remove prng support from hisi-trng.
- Remove prng support from sun4i-ss.
- Remove prng support from xilinx-trng.
- Remove loongson-rng.
- Remove exynos-rng.

Others:

- Remove support for AIO on sockets.
----------------------------------------------------------------

Abdun Nihaal (1):
      crypto: safexcel - Fix potential memory leak in safexcel_pci_probe()

Ahsan Atta (9):
      crypto: qat - keep VFs enabled during reset
      crypto: qat - notify fatal error before AER reset preparation
      crypto: qat - centralize bus master enable
      crypto: qat - skip restart for down devices
      crypto: qat - factor out AER reset helpers
      crypto: qat - handle sysfs-triggered reset callbacks
      crypto: qat - fix restarting state leak on allocation failure
      crypto: qat - protect service table iterations with service_lock
      crypto: qat - use pci logging variants for PCI-specific messages

Aleksander Jan Bajkowski (4):
      crypto: safexcel - Remove repeated plus
      crypto: eip93 - fix reset ring register definition
      crypto: inside-secure/eip93 - Drop superfluous blank line
      crypto: inside-secure/eip93 - Add check for devm_request_threaded_irq

Alexander Koskovich (1):
      dt-bindings: crypto: qcom-qce: Document the Milos crypto engine

Alexey Kardashevskiy (1):
      crypto: ccp/tsm - Enable the root port after the endpoint

Anastasia Tishchenko (1):
      crypto: ecc - Fix carry overflow in vli multiplication

Ard Biesheuvel (1):
      crypto: crypto_null - Drop unused cipher_null crypto_alg

Arnd Bergmann (1):
      crypto: sun8i-ss - avoid hash and rng references

Bartosz Golaszewski (2):
      dt-bindings: crypto: qcom-qce: document the Nord crypto engine
      MAINTAINERS: make myself the maintainer of the Qualcomm QCE driver

Costa Shulyupin (1):
      include: Remove unused crypto-ux500.h

Damian Muszynski (1):
      crypto: qat - fix heartbeat error injection

Daniel Golle (3):
      dt-bindings: rng: mtk-rng: fix style problems in example
      dt-bindings: rng: mtk-rng: add SMC-based TRNG variants
      hwrng: mtk - add support for hw access via SMCC

Dawei Feng (1):
      crypto: amlogic - avoid double cleanup in meson_crypto_probe()

Deepti Jaggi (1):
      dt-bindings: crypto: qcom,prng: Document TRNG on Nord SoC

Demi Marie Obenour (3):
      net: Remove support for AIO on sockets
      crypto: af_alg - Drop support for off-CPU cryptography
      crypto: af_alg - Document that it is *always* slower

Eric Biggers (53):
      crypto: drbg - Fix returning success on failure in CTR_DRBG
      crypto: drbg - Fix misaligned writes in CTR_DRBG and HASH_DRBG
      crypto: drbg - Fix ineffective sanity check
      crypto: drbg - Fix drbg_max_addtl() on 64-bit kernels
      crypto: drbg - Fix the fips_enabled priority boost
      crypto: drbg - Remove always-enabled symbol CRYPTO_DRBG_HMAC
      crypto: drbg - Remove broken commented-out code
      crypto: drbg - Remove unhelpful helper functions
      crypto: drbg - Remove obsolete FIPS 140-2 continuous test
      crypto: drbg - Fold include/crypto/drbg.h into crypto/drbg.c
      crypto: drbg - Remove import of crypto_cipher functions
      crypto: drbg - Remove support for CTR_DRBG
      crypto: drbg - Remove support for HASH_DRBG
      crypto: drbg - Flatten the DRBG menu
      crypto: testmgr - Add test for drbg_pr_hmac_sha512
      crypto: testmgr - Update test for drbg_nopr_hmac_sha512
      crypto: drbg - Remove support for HMAC-SHA256 and HMAC-SHA384
      crypto: drbg - Simplify algorithm registration
      crypto: drbg - De-virtualize drbg_state_ops
      crypto: drbg - Move fixed values into constants
      crypto: drbg - Embed V and C into struct drbg_state
      crypto: drbg - Use HMAC-SHA512 library API
      crypto: drbg - Remove drbg_core
      crypto: drbg - Install separate seed functions for pr and nopr
      crypto: drbg - Move module aliases to end of file
      crypto: drbg - Consolidate "instantiate" logic and remove drbg_state::C
      crypto: drbg - Eliminate use of 'drbg_string' and lists
      crypto: drbg - Simplify drbg_generate_long() and fold into caller
      crypto: drbg - Put rng_alg methods in logical order
      crypto: drbg - Fold drbg_instantiate() into drbg_kcapi_seed()
      crypto: drbg - Separate "reseed" case in drbg_kcapi_seed()
      crypto: drbg - Fold drbg_prepare_hrng() into drbg_kcapi_seed()
      crypto: drbg - Simplify "uninstantiate" logic
      crypto: drbg - Include get_random_bytes() output in additional input
      crypto: drbg - Change DRBG_MAX_REQUESTS to 4096
      crypto: drbg - Remove redundant reseeding based on random.c state
      crypto: drbg - Clean up generation code
      crypto: drbg - Clean up loop in drbg_hmac_update()
      crypto: af_alg - Document the deprecation of AF_ALG
      crypto: af_alg - Remove zero-copy support from skcipher and aead
      crypto: drbg - Rename MAX_ADDTL => MAX_ADDTL_BYTES
      crypto: drbg - Remove support for "prediction resistance"
      crypto: loongson - Select CRYPTO_RNG
      crypto: crypto4xx - Remove insecure and unused rng_alg
      crypto: loongson - Remove broken and unused loongson-rng
      crypto: hisi-trng - Remove crypto_rng interface
      hwrng: hisi-trng - Move hisi-trng into drivers/char/hw_random/
      crypto: exynos-rng - Remove exynos-rng driver
      crypto: xilinx-trng - Remove crypto_rng interface
      crypto: xilinx-trng - Fix return value of xtrng_hwrng_trng_read()
      crypto: xilinx-trng - Replace crypto_drbg_ctr_df() with HMAC-SHA512
      hwrng: xilinx - Move xilinx-rng into drivers/char/hw_random/
      crypto: sun4i-ss - Remove insecure and unused rng_alg

Ethan Nelson-Moore (2):
      LoongArch: Remove unused arch/loongarch/crypto directory
      MIPS: Remove unused arch/mips/crypto directory

Felix Gu (2):
      crypto: marvell/octeontx - fix DMA cleanup using wrong loop index
      crypto: cavium/cpt - fix DMA cleanup using wrong loop index

Fiona Trahe (1):
      Documentation: qat_rl: make rate limiting wording clearer

Giovanni Cabiddu (5):
      crypto: qat - remove unused character device and IOCTLs
      crypto: qat - rename adf_ctl_drv.c to adf_module.c
      crypto: qat - remove MODULE_VERSION
      crypto: qat - fix VF2PF work teardown race in adf_disable_sriov()
      crypto: qat - validate RSA CRT component lengths

Harshal Dev (2):
      dt-bindings: crypto: qcom-qce: Document the Glymur crypto engine
      dt-bindings: crypto: qcom,prng: Document Glymur TRNG

Herbert Xu (5):
      crypto: authencesn - Use memcpy_from/to_sglist
      crypto: af_alg - Cap AEAD AD length to 0x80000000
      crypto: tegra - Fix dma_free_coherent size error
      crypto: tegra - Return ENOMEM when input buffer allocation fails for ccm
      crypto: rng - Free default RNG on module exit

Ilya Dryomov (1):
      crypto: testmgr - allow authenc(hmac(sha{256,384}),cts(cbc(aes))) in FIPS mode

Jeff Barnes (1):
      crypto: testmgr - disallow RSA PKCS#1 SHA-1 sig algs in FIPS mode

Julian Braha (1):
      keys: cleanup dead code in Kconfig for FIPS_SIGNATURE_SELFTEST

Junyuan Wang (1):
      crypto: qat - add KPT support for GEN6 devices

Krzysztof Kozlowski (2):
      dt-bindings: crypto: qcom-qce: Add Qualcomm Eliza QCE
      crypto: drivers - Move MODULE_DEVICE_TABLE next to the table itself

Lothar Rubusch (1):
      crypto: atmel-sha204a - fix blocking and non-blocking rng logic

Lukas Wunner (2):
      crypto: ecc - Unbreak the build on arm with CONFIG_KASAN_STACK=y
      X.509: Fix validation of ASN.1 certificate header

Manivannan Sadhasivam (2):
      dt-bindings: crypto: qcom,prng: Document Hawi TRNG
      dt-bindings: crypto: qcom,inline-crypto-engine: Document Hawi ICE

Michael Bommarito (1):
      crypto: krb5 - filter out async aead implementations at alloc

Mikko Perttunen (1):
      crypto: tegra - Don't touch bo refcount in host1x bo pin/unpin

Paul Louvel (11):
      crypto: talitos - use dma_sync_single_for_cpu() before reading descriptor header
      crypto: talitos - add chaining of arbitrary number of descriptor for the SEC1
      crypto: talitos - move dma unmapping code in flush_channel() into a standalone dma_unmap_request() function
      crypto: talitos - move dma mapping code in talitos_submit() into a standalone dma_map_request() function
      crypto: talitos - move code in current_desc_hdr() into a standalone function
      crypto: talitos/hash - prepare SEC1 descriptor chaining, remove additional descriptor
      crypto: talitos/hash - use descriptor chaining for SEC1 instead of workqueue
      crypto: talitos/hash - drop workqueue mechanism for SEC1
      crypto: talitos/hash - rename first_desc/last_desc to first_request/last_request
      crypto: talitos/hash - remove useless wrapper
      crypto: talitos/hash - fix SEC2 64k - 1 ahash request limitation

Rosen Penev (4):
      crypto: cesa - allocate engines with main struct
      crypto: talitos - allocate channels with main struct
      crypto: talitos - use devm_platform_ioremap_resource()
      crypto: amcc - convert irq_of_parse_and_map to platform_get_irq

Ruijie Li (1):
      crypto: pcrypt - restore callback for non-parallel fallback

Ruoyu Wang (1):
      crypto: ixp4xx - fix buffer chain unwind on allocation failure

Sam James (1):
      crypto: nx - fix nx_crypto_ctx_exit argument

Sean Christopherson (1):
      crypto: ccp - Treat zero-length cert chain as query for blob lengths

Stepan Ionichev (1):
      crypto: ccp/sev-dev-tsm - bail out early when pdev->bus is NULL

Thorsten Blum (37):
      crypto: atmel-ecc - add support for atecc608b
      dt-bindings: trivial-devices: add atmel,atecc608b
      crypto: caam - use print_hex_dump_devel to guard key hex dumps
      crypto: caam - use print_hex_dump_devel to guard key hex dumps
      crypto: omap - add omap_aes_unregister_algs helper
      crypto: omap - add omap_des_unregister_algs helper
      crypto: omap - add omap_sham_unregister_algs helper
      crypto: starfive - use list_first_entry_or_null to simplify cryp_find_dev
      crypto: atmel-sha204a - drop hwrng quality reduction for ATSHA204A
      crypto: ecrdsa - fix unknown OID check in ecrdsa_param_curve
      crypto: jitterentropy - drop redundant delta check in jent_entropy_init
      crypto: jitterentropy - fix URL
      hwrng: core - drop unnecessary forward declarations
      hwrng: core - use bool for wait parameter in rng_get_data
      hwrng: core - use MAX to simplify RNG_BUFFER_SIZE
      hwrng: core - use sysfs_emit_at in rng_available_show
      crypto: artpec6 - refactor crypto_setup_out_descr for readability
      crypto: ccree - replace snprintf("%s") with strscpy
      crypto: atmel-ecc - replace min_t with min
      crypto: api - use designated initializers for report structs
      crypto: atmel-sha204a - drop __maybe_unused and of_match_ptr
      crypto: atmel-ecc - drop CONFIG_OF guard and of_match_ptr
      crypto: cesa - use max to simplify mv_cesa_probe
      crypto: atmel - use min3 to simplify atmel_sha_append_sg
      crypto: riscv/aes - replace min_t with min in riscv64_aes_ctr_crypt
      crypto: atmel-i2c - drop redundant void * callback cast in enqueue
      crypto: drivers - remove of_match_ptr from OF match tables
      crypto: atmel-sha - use memcpy_and_pad to simplify hmac_setup
      crypto: omap-des - add COMPILE_TEST and fix CONFIG_OF=n build
      crypto: omap-des - drop of_match_ptr from OF match table
      crypto: atmel-sha204a - remove sysfs group before hwrng
      crypto: atmel-sha204a - fail on hwrng registration error in probe path
      crypto: ecrdsa - remove empty sig_alg exit callback
      crypto: octeontx - use strscpy_pad in ucode_load_store
      crypto: powerpc/aes - use min in ppc_{ecb,cbc,ctr,xts}_crypt
      crypto: qat - simplify adf_service_mask_to_string helper
      crypto: atmel-ecc - drop dead code in atmel_ecdh_max_size

Tycho Andersen (AMD) (8):
      crypto: ccp - Reverse the cleanup order in psp_dev_destroy()
      crypto: ccp - Fix snp_filter_reserved_mem_regions() off-by-one
      crypto: ccp - Check for page allocation failure correctly in TIO
      crypto: ccp - Initialize data during __sev_snp_init_locked()
      crypto: ccp - Do not initialize SNP for SEV ioctls
      crypto: ccp - Do not initialize SNP for ioctl(SNP_COMMIT)
      crypto: ccp - Do not initialize SNP for ioctl(SNP_VLEK_LOAD)
      crypto: ccp - Do not initialize SNP for ioctl(SNP_CONFIG)

Uwe Kleine-König (The Capable Hub) (6):
      hwrng: drivers - Drop unused assignment to pci driver_data
      crypto: ccp - Define pci_device_ids using named initializers
      crypto: drivers - Drop explicit assigment of 0 in pci_device_id array
      crypto: atmel-sha204a - Drop of_device_id data
      crypto: atmel-sha204a - Use named initializers for struct i2c_device_id
      crypto: atmel-ecc - Use named initializers for struct i2c_device_id

Weili Qian (2):
      crypto: hisilicon/qm - disable error report before flr
      crypto: hisilicon - mask all error type when removing driver

Weiming Shi (1):
      crypto: asymmetric_keys - fix OOB read in pefile_digest_pe_contents

Wentao Liang (2):
      hwrng: jh7110 - fix refcount leak in starfive_trng_read()
      crypto: tegra - fix refcount leak in tegra_se_host1x_submit()

Xiaonan Zhao (1):
      crypto: chacha20poly1305 - validate poly1305 template argument

Zhushuai Yin (3):
      crypto: hisilicon/qm - allow VF devices to query hardware isolation status
      crypto: hisilicon/qm - place the interrupt status interface after the PM usage counter
      crypto: hisilicon/qm - support function-level error reset

Zongyu Wu (1):
      crypto: hisilicon/qm - support doorbell enable control

lizhi (1):
      crypto: hisilicon/sec2 - lower priority for hisilicon crypto implementations

 Documentation/ABI/testing/sysfs-driver-qat_kpt     |   97 ++
 Documentation/ABI/testing/sysfs-driver-qat_rl      |    2 +-
 Documentation/crypto/api-samples.rst               |    2 +-
 Documentation/crypto/userspace-if.rst              |  127 +-
 .../bindings/crypto/qcom,inline-crypto-engine.yaml |    1 +
 .../devicetree/bindings/crypto/qcom,prng.yaml      |    3 +
 .../devicetree/bindings/crypto/qcom-qce.yaml       |    4 +
 Documentation/devicetree/bindings/rng/mtk-rng.yaml |   43 +-
 .../devicetree/bindings/trivial-devices.yaml       |    4 +-
 Documentation/userspace-api/ioctl/ioctl-number.rst |    1 -
 MAINTAINERS                                        |   17 +-
 arch/arm/configs/exynos_defconfig                  |    1 -
 arch/arm/configs/multi_v7_defconfig                |    1 -
 arch/arm/configs/sunxi_defconfig                   |    1 -
 arch/arm64/configs/defconfig                       |    4 +-
 arch/loongarch/Makefile                            |    2 -
 arch/loongarch/configs/loongson32_defconfig        |    1 -
 arch/loongarch/configs/loongson64_defconfig        |    1 -
 arch/loongarch/crypto/Kconfig                      |    5 -
 arch/loongarch/crypto/Makefile                     |    4 -
 arch/m68k/configs/amiga_defconfig                  |    2 -
 arch/m68k/configs/apollo_defconfig                 |    2 -
 arch/m68k/configs/atari_defconfig                  |    2 -
 arch/m68k/configs/bvme6000_defconfig               |    2 -
 arch/m68k/configs/hp300_defconfig                  |    2 -
 arch/m68k/configs/mac_defconfig                    |    2 -
 arch/m68k/configs/multi_defconfig                  |    2 -
 arch/m68k/configs/mvme147_defconfig                |    2 -
 arch/m68k/configs/mvme16x_defconfig                |    2 -
 arch/m68k/configs/q40_defconfig                    |    2 -
 arch/m68k/configs/sun3_defconfig                   |    2 -
 arch/m68k/configs/sun3x_defconfig                  |    2 -
 arch/mips/Makefile                                 |    2 -
 arch/mips/configs/decstation_64_defconfig          |    2 -
 arch/mips/configs/decstation_defconfig             |    2 -
 arch/mips/configs/decstation_r4k_defconfig         |    2 -
 arch/mips/crypto/.gitignore                        |    2 -
 arch/mips/crypto/Kconfig                           |    5 -
 arch/mips/crypto/Makefile                          |    5 -
 arch/powerpc/crypto/aes-spe-glue.c                 |    9 +-
 arch/riscv/crypto/aes-riscv64-glue.c               |    4 +-
 crypto/Kconfig                                     |  120 +-
 crypto/Makefile                                    |    7 +-
 crypto/acompress.c                                 |    8 +-
 crypto/aead.c                                      |   10 +-
 crypto/af_alg.c                                    |  106 +-
 crypto/ahash.c                                     |    8 +-
 crypto/akcipher.c                                  |    8 +-
 crypto/algif_aead.c                                |   51 +-
 crypto/algif_hash.c                                |    4 +-
 crypto/algif_rng.c                                 |    4 +-
 crypto/algif_skcipher.c                            |   66 +-
 crypto/asymmetric_keys/Kconfig                     |    1 -
 crypto/asymmetric_keys/verify_pefile.c             |    2 +
 crypto/asymmetric_keys/x509_loader.c               |    2 +-
 crypto/authencesn.c                                |   33 +-
 crypto/chacha20poly1305.c                          |   11 +-
 crypto/crypto_null.c                               |   35 +-
 crypto/crypto_user.c                               |   14 +-
 crypto/df_sp80090a.c                               |  222 ---
 crypto/drbg.c                                      | 1819 +++-----------------
 crypto/ecc.c                                       |   31 +-
 crypto/ecrdsa.c                                    |    7 +-
 crypto/jitterentropy.c                             |    6 +-
 crypto/kpp.c                                       |    8 +-
 crypto/krb5/krb5_api.c                             |    2 +-
 crypto/lskcipher.c                                 |   10 +-
 crypto/pcrypt.c                                    |    4 +
 crypto/rng.c                                       |   19 +-
 crypto/scompress.c                                 |    8 +-
 crypto/shash.c                                     |    8 +-
 crypto/sig.c                                       |    6 +-
 crypto/skcipher.c                                  |   10 +-
 crypto/testmgr.c                                   |  162 +-
 crypto/testmgr.h                                   | 1080 +++---------
 drivers/char/hw_random/Kconfig                     |   21 +
 drivers/char/hw_random/Makefile                    |    2 +
 drivers/char/hw_random/amd-rng.c                   |    6 +-
 drivers/char/hw_random/cavium-rng.c                |    4 +-
 drivers/char/hw_random/core.c                      |   30 +-
 drivers/char/hw_random/geode-rng.c                 |    4 +-
 drivers/char/hw_random/hisi-trng-v2.c              |   98 ++
 drivers/char/hw_random/jh7110-trng.c               |   13 +-
 drivers/char/hw_random/mtk-rng.c                   |  125 +-
 .../xilinx => char/hw_random}/xilinx-trng.c        |  135 +-
 drivers/crypto/Kconfig                             |   37 +-
 drivers/crypto/Makefile                            |    2 -
 drivers/crypto/allwinner/Kconfig                   |   10 -
 drivers/crypto/allwinner/sun4i-ss/Makefile         |    1 -
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c  |   36 -
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c  |   69 -
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h       |   20 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |   12 +
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |   12 +
 drivers/crypto/amcc/crypto4xx_core.c               |   94 +-
 drivers/crypto/amcc/crypto4xx_core.h               |    6 +-
 drivers/crypto/amcc/crypto4xx_reg_def.h            |   11 -
 drivers/crypto/amlogic/amlogic-gxl-core.c          |    2 +-
 drivers/crypto/atmel-ecc.c                         |   29 +-
 drivers/crypto/atmel-i2c.c                         |    2 +-
 drivers/crypto/atmel-sha.c                         |   11 +-
 drivers/crypto/atmel-sha204a.c                     |   50 +-
 drivers/crypto/axis/artpec6_crypto.c               |   21 +-
 drivers/crypto/bcm/cipher.c                        |    6 +-
 drivers/crypto/caam/caamalg.c                      |   12 +-
 drivers/crypto/caam/caamalg_qi.c                   |   12 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   12 +-
 drivers/crypto/caam/caamhash.c                     |    4 +-
 drivers/crypto/caam/key_gen.c                      |    4 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |    2 +-
 drivers/crypto/cavium/cpt/cptvf_main.c             |    6 +-
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c       |    4 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c         |    4 +-
 drivers/crypto/ccp/psp-dev.c                       |   12 +-
 drivers/crypto/ccp/sev-dev-tsm.c                   |   23 +-
 drivers/crypto/ccp/sev-dev.c                       |   96 +-
 drivers/crypto/ccp/sp-pci.c                        |   28 +-
 drivers/crypto/ccree/cc_aead.c                     |    9 +-
 drivers/crypto/ccree/cc_cipher.c                   |    7 +-
 drivers/crypto/ccree/cc_hash.c                     |   13 +-
 drivers/crypto/exynos-rng.c                        |  399 -----
 drivers/crypto/hisilicon/Kconfig                   |    8 -
 drivers/crypto/hisilicon/Makefile                  |    1 -
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   19 +-
 drivers/crypto/hisilicon/qm.c                      |  334 +++-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |    2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |   13 +-
 drivers/crypto/hisilicon/trng/Makefile             |    2 -
 drivers/crypto/hisilicon/trng/trng.c               |  390 -----
 drivers/crypto/hisilicon/zip/zip_main.c            |   20 +-
 drivers/crypto/inside-secure/eip93/eip93-main.c    |    3 +-
 drivers/crypto/inside-secure/eip93/eip93-regs.h    |    2 +-
 drivers/crypto/inside-secure/safexcel.c            |    4 +-
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c        |   25 +-
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c       |   11 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c        |   11 +-
 .../crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c   |   21 +-
 .../crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h   |    9 +
 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c        |    8 +-
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c       |    6 +-
 drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c     |    4 +-
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c        |    6 +-
 drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c      |    4 +-
 drivers/crypto/intel/qat/qat_common/Makefile       |    4 +-
 .../intel/qat/qat_common/adf_accel_devices.h       |    4 +
 drivers/crypto/intel/qat/qat_common/adf_admin.c    |   39 +
 drivers/crypto/intel/qat/qat_common/adf_admin.h    |    2 +
 drivers/crypto/intel/qat/qat_common/adf_aer.c      |  122 +-
 drivers/crypto/intel/qat/qat_common/adf_cfg.c      |   10 -
 drivers/crypto/intel/qat/qat_common/adf_cfg.h      |    1 -
 .../crypto/intel/qat/qat_common/adf_cfg_common.h   |   32 -
 .../crypto/intel/qat/qat_common/adf_cfg_services.c |    7 +-
 drivers/crypto/intel/qat/qat_common/adf_cfg_user.h |   38 -
 .../crypto/intel/qat/qat_common/adf_common_drv.h   |   14 +-
 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c  |  466 -----
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c  |   70 -
 .../intel/qat/qat_common/adf_heartbeat_inject.c    |    6 +-
 .../crypto/intel/qat/qat_common/adf_hw_arbiter.c   |   25 -
 drivers/crypto/intel/qat/qat_common/adf_init.c     |   26 +
 drivers/crypto/intel/qat/qat_common/adf_isr.c      |   39 +
 drivers/crypto/intel/qat/qat_common/adf_kpt.c      |   56 +
 drivers/crypto/intel/qat/qat_common/adf_kpt.h      |   29 +
 drivers/crypto/intel/qat/qat_common/adf_module.c   |   63 +
 drivers/crypto/intel/qat/qat_common/adf_sriov.c    |   34 +-
 .../crypto/intel/qat/qat_common/adf_sysfs_kpt.c    |  296 ++++
 .../crypto/intel/qat/qat_common/adf_sysfs_kpt.h    |   10 +
 .../intel/qat/qat_common/icp_qat_fw_init_admin.h   |    8 +
 drivers/crypto/intel/qat/qat_common/icp_qat_hw.h   |    3 +-
 .../crypto/intel/qat/qat_common/qat_asym_algs.c    |   10 +-
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c    |    6 +-
 drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c  |    4 +-
 drivers/crypto/loongson/Kconfig                    |    5 -
 drivers/crypto/loongson/Makefile                   |    1 -
 drivers/crypto/loongson/loongson-rng.c             |  209 ---
 drivers/crypto/marvell/cesa/cesa.c                 |   16 +-
 drivers/crypto/marvell/cesa/cesa.h                 |   42 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_main.c   |    2 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  |    5 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c   |    6 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c |    4 +-
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |    2 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c |    8 +-
 drivers/crypto/nx/nx.c                             |    6 +-
 drivers/crypto/nx/nx.h                             |    2 +-
 drivers/crypto/omap-aes.c                          |   43 +-
 drivers/crypto/omap-des.c                          |   32 +-
 drivers/crypto/omap-sham.c                         |   27 +-
 drivers/crypto/qcom-rng.c                          |    2 +-
 drivers/crypto/starfive/jh7110-cryp.c              |   17 +-
 drivers/crypto/talitos.c                           |  592 ++++---
 drivers/crypto/talitos.h                           |   17 +-
 drivers/crypto/tegra/tegra-se-aes.c                |   33 +-
 drivers/crypto/tegra/tegra-se-main.c               |    5 +-
 drivers/crypto/xilinx/Makefile                     |    1 -
 include/crypto/df_sp80090a.h                       |   28 -
 include/crypto/drbg.h                              |  263 ---
 include/crypto/if_alg.h                            |   19 +-
 include/crypto/internal/drbg.h                     |   54 -
 include/linux/hisi_acc_qm.h                        |   15 +-
 include/linux/platform_data/crypto-ux500.h         |   22 -
 include/linux/socket.h                             |    1 -
 io_uring/net.c                                     |    1 -
 net/compat.c                                       |    1 -
 net/socket.c                                       |    7 +-
 tools/perf/trace/beauty/include/linux/socket.h     |    1 -
 tools/testing/crypto/chacha20-s390/test-cipher.c   |    1 -
 206 files changed, 2971 insertions(+), 6632 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-qat_kpt
 delete mode 100644 arch/loongarch/crypto/Kconfig
 delete mode 100644 arch/loongarch/crypto/Makefile
 delete mode 100644 arch/mips/crypto/.gitignore
 delete mode 100644 arch/mips/crypto/Kconfig
 delete mode 100644 arch/mips/crypto/Makefile
 delete mode 100644 crypto/df_sp80090a.c
 create mode 100644 drivers/char/hw_random/hisi-trng-v2.c
 rename drivers/{crypto/xilinx => char/hw_random}/xilinx-trng.c (75%)
 delete mode 100644 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
 delete mode 100644 drivers/crypto/exynos-rng.c
 delete mode 100644 drivers/crypto/hisilicon/trng/Makefile
 delete mode 100644 drivers/crypto/hisilicon/trng/trng.c
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_cfg_user.h
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_kpt.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_kpt.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_module.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.h
 delete mode 100644 drivers/crypto/loongson/Kconfig
 delete mode 100644 drivers/crypto/loongson/Makefile
 delete mode 100644 drivers/crypto/loongson/loongson-rng.c
 delete mode 100644 include/crypto/df_sp80090a.h
 delete mode 100644 include/crypto/drbg.h
 delete mode 100644 include/crypto/internal/drbg.h
 delete mode 100644 include/linux/platform_data/crypto-ux500.h

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
