Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6388345751;
	Tue, 18 Aug 2026 07:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038729; cv=none; b=BUyolk1BFO3ex8jZCnUcsLtSV+Wq9UJqF7JkE0h7VYIgRRSktkY/7AD1zR0DBlMANrsg5sEYRyiRzFZj2jW984OIdUwlsQaA+d2miPKn1/p5Yue6kCLLtGdMKYmQPDoOqPEtHdPWJUEbthJZYp0VPvfJ23YYg/SgQRCTXFDS6Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038729; c=relaxed/simple;
	bh=yi6NYNeY4m0PaJY8Ji94aAB88rf5H9SCeMghJM1Wkek=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jGPEZNhAY6QGO1Aa6kgPvWgZOJWM6e5hfg5s4x2kEj8KoOrSeElPsPUXK0xT62ew1XknVXdVzDP9sqxauDME8CfkkmzlvIxr0UG3+8goHYo63tdtS1Z0uuoGfCOsIcP+XEclFsbAna3mbBSTl7QB4Ysz+ktPTBzpaUx654/EHPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Ozt2S7nK; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Ozt2S7nK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=o/H75vVQX7TrSqYczUN+NlMNQ9+AZBJgyQa3ZfNCB7g=; b=Ozt2S
	7nK7UPgDZqw8p44EdQREv76jAI9KC9e0JWCQyyv78tQARc6wQL20CMdudNoBatGb2t/iHwNA5bUq7
	0K38cDQ4ZVmVIYcCen5bjRnftN1KxSCgwSvxTcm0qfbOKGsuUzln9C+p9DQES8JmmGS0h34S+El/Y
	9l+4iFvQld7hgzw09NLzIyVg/AJURJqlHFHlyZn2HIrRUFTIXQgFyMevuM+iNeNYb+5IGO/kINYtC
	/n4RH58dYzYBaEmgob7LMTsmV/LdSwaNRqNXGslHaBU8j+3ssWn27g8hVF6dfNCbu6MXFhRWIi3UR
	xrPW2LMVoKomUFG5X2cJUs+2bvYZQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wwEP2-00000005qAs-2PJD;
	Tue, 18 Aug 2026 15:38:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Aug 2026 17:38:32 +1000
Date: Tue, 18 Aug 2026 17:38:32 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 7.3
Message-ID: <aoQL-FPagOSHf8Ug@gondor.apana.org.au>
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

The following changes since commit 285d8204638cf8be0dc304dc40f0290ada701340:

  crypto: af_alg - Allow cbc(paes) (2026-07-30 17:44:21 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p1

for you to fetch changes up to 7537036a2e6fe96f8ed82034f755c54714a0e417:

  crypto: lskcipher - propagate errors from unaligned crypt (2026-08-15 11:28:36 +1000)

----------------------------------------------------------------
This update includes the following changes:

API:

- Add af_alg_restrict sysctl and white list.
- Fix potential suspend/resume races in hwrng.

Algorithms:

- Optimize vli additive operations using compiler builtins in ecc.

Drivers:

- Remove unsafe/deprecated algorithms from qce.
- Mark qce as BROKEN.
- Add runtime PM and interconnect bandwidth scaling support to qce.
- Remove crypto_rng from qcom, sun8i and caam.
- Fix SG list issues in iaa.
- Fix SEV init path bugs in ccp.

----------------------------------------------------------------
Ahsan Atta (1):
      crypto: qat - remove dead ADF_HEX code

Atish Patra (2):
      crypto: ccp - Fix possible deadlock in SEV init failure path
      crypto: ccp - Fix memory leak in SEV INIT_EX path

Bartosz Golaszewski (1):
      crypto: qce - Remove unsafe/deprecated algorithms

Can Peng (2):
      crypto: keembay - publish OF module alias for OCS AES/SM4
      hwrng: stm32 - Fix runtime PM cleanup on registration failure

Chenghai Huang (3):
      MAINTAINERS: update hisilicon zip driver maintainer
      crypto: hisilicon/sec2 - fix uninitialized type_supported in sec_create_qp_ctx
      crypto: hisilicon/sec2 - remove unused sec_ctx.hlf_q_num

David C.C.M. Gall (3):
      crypto: sa2ul - use crypto_memneq() to compare AEAD tag
      crypto: keembay - use crypto_memneq() to compare GCM AEAD tags
      crypto: keembay - use crypto_memneq() to compare CCM AEAD tags

Demi Marie Obenour (1):
      crypto: qce - Mark QCE as BROKEN

Eric Biggers (12):
      crypto: qcom-rng - Enable clock in hwrng case
      crypto: qcom-rng - Allow zero as a random number
      crypto: qcom-rng - Remove crypto_rng interface
      hwrng: qcom - Move qcom-rng.c into drivers/char/hw_random/
      crypto: sun8i-ce - Remove crypto_rng interface
      crypto: sun8i-ss - Remove crypto_rng interface
      crypto: caam - Remove crypto_rng interface
      crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1
      crypto: af_alg - Allow additional ciphers for cryptsetup
      crypto: af_alg - Make cbc(paes) privileged-only
      crypto: af_alg - Replace 'bool privileged' with flags
      crypto: af_alg - Stop after finding name in allowlist

Fabian Blatter (1):
      crypto: ecc - Optimize vli additive operations using compiler builtins

Giovanni Cabiddu (5):
      crypto: qat - cancel work on re-enable SR-IOV timeout
      crypto: qat - clear AES key schedule from stack
      crypto: iaa - fall back to software for multi-entry scatterlists
      crypto: iaa - avoid counting fallback decompression bytes
      crypto: iaa - use bounce buffer for multi-sg decompress input

Herbert Xu (2):
      rhashtable: Add workqueue/irq_work header inclusions
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

Jan Sebastian Götte (1):
      crypto: krb5 - use kfree_sensitive() for derived key buffers

Jingyi Wang (3):
      dt-bindings: crypto: qcom,prng: Document Maili TRNG
      dt-bindings: crypto: qcom,inline-crypto-engine: Document Maili ICE
      dt-bindings: crypto: qcom,ice: Fix missing power-domain and iface clk on Hawi

Karl Mehltretter (1):
      crypto: lskcipher - propagate errors from unaligned crypt

Kuldeep Singh (4):
      dt-bindings: crypto: qcom,inline-crypto-engine: Fix legacy/new SoC strictness split
      dt-bindings: crypto: qcom,inline-crypto-engine: Document Shikra ICE
      dt-bindings: crypto: qcom,prng: Document Shikra TRNG
      dt-bindings: crypto: qcom-qce: Document the Shikra crypto engine

Linmao Li (1):
      crypto: keembay - Initialize completion before requesting IRQ

Lothar Rubusch (1):
      crypto: atmel-sha204a - fix heap info leak on I2C transfer failure

Manos Pitsidianakis (1):
      hwrng: core - fix rng list on registration error

Manuel Ebner (1):
      crypto: doc - Remove extra parenthesis

Md Sadre Alam (1):
      crypto: qce - fix CCM AAD buffer underallocation

Miquel Raynal (Schneider Electric) (2):
      dt-bindings: rng: Rename the title of the EIP-76 file
      hwrng: omap - Enable on Renesas RZ/N1D

Myeonghun Pak (2):
      hwrng: omap - Fix probe error path cleanup
      crypto: keembay - Fix AEAD unregister count in error path

Narasimharao Vadlamudi (1):
      crypto: aspeed - Propagate platform_get_irq() errors

Pan Chuang (12):
      hwrng: drivers - Remove redundant dev_err()/dev_err_probe()
      crypto: allwinner - Remove redundant dev_err()
      crypto: amlogic - Remove redundant dev_err()
      crypto: aspeed - Remove redundant dev_err()
      crypto: drivers - Remove redundant dev_err()/dev_err_probe()
      crypto: ccree - Remove redundant dev_err()
      crypto: sl3516 - Remove redundant dev_err()
      crypto: safexcel - Remove redundant dev_err()
      crypto: keembay - Remove redundant dev_err()
      crypto: octeontx2 - Remove redundant dev_err()
      crypto: rockchip - Remove redundant dev_err()
      crypto: stm32 - Remove redundant dev_err()

Paul Louvel (1):
      crypto: ecdsa - Fix typo in function documentation

Pawel Zalewski (The Capable Hub) (1):
      hwrng: drivers - use named initializers for acpi_device_id

Pengpeng Hou (5):
      crypto: sa2ul - stop probe if context pool creation fails
      hwrng: xilinx-trng - propagate timeout before any data is read
      crypto: rk3288 - fail ahash requests on HASH idle timeout
      crypto: ixp4xx - add missing MODULE_DEVICE_TABLE()
      crypto: keembay - add missing MODULE_DEVICE_TABLE()

Pratik R. Sampat (1):
      crypto: ccp - Introduce SNP_VERIFY_MITIGATION command

Randy Dunlap (2):
      crypto: af_alg - clean up kernel-doc warnings
      crypto: ccp - don't abuse kernel-doc comment format

Rosen Penev (10):
      crypto: crypto4xx - move ioremapping up
      crypto: hisilicon/sec - use devm_platform_ioremap_resource in sec_map_io
      crypto: omap-aes - use devm_platform_get_and_ioremap_resource
      crypto: omap-sham - use devm_platform_get_and_ioremap_resource
      crypto: cesa - manage SRAM teardown with devm
      crypto: talitos - Use platform_get_irq() to retrieve interrupt
      crypto: cesa - clear cesa_dev on _remove
      crypto: amcc - fix racy teardown with devm_request_irq
      crypto: caam - simplify probe resource and IRQ handling
      crypto: eip93 - use struct_size() and flexible array for ring allocation

Sang-Heon Jeon (1):
      crypto: drivers - remove conditional return with no effect

Shawn Guo (1):
      dt-bindings: crypto: qcom,inline-crypto-engine: Document Nord ICE

Thomas Richard (TI) (1):
      hwrng: core - Stop/start hwrng_fillfn() kthread before/after suspend-resume

Thorsten Blum (30):
      crypto: use 2-arg strscpy where destination size is known
      crypto: cavium - use 2-arg strscpy where destination size is known
      crypto: ccp - use 2-arg strscpy where destination size is known
      crypto: hisilicon - use 2-arg strscpy where destination size is known
      crypto: qat - use 2-arg strscpy where destination size is known
      crypto: octeontx - use 2-arg strscpy where destination size is known
      hwrng: atmel - drop __maybe_unused from atmel_trng_pm_ops
      crypto: atmel-i2c - improve comment in atmel_i2c_init_ecdh_cmd
      crypto: atmel-ecc - clean up and improve ECDH comments
      crypto: atmel-tdes - use scatterlist length before DMA mapping
      crypto: atmel-ecc - drop unused curve id from atmel_ecdh_ctx
      crypto: atmel-ecc - reject hardware ECDH without a public key
      crypto: qce - drop unused scatterlist traversal in qce_ahash_update
      crypto: mxs-dcp - fix source scatterlist length access
      crypto: qat - use strscpy_pad to simplify adf_service_string_to_mask
      crypto: atmel-tdes - simplify fast path in crypt_start
      crypto: atmel-tdes - use __get_free_page in buff_init
      crypto: atmel-tdes - drop redundant return variable in crypt_pdc_stop
      crypto: atmel-tdes - drop redundant if check in crypt_dma_stop
      crypto: atmel-sha204a - clear RNG data from memory
      crypto: atmel-ecc - avoid stale fallback key after set_secret failure
      crypto: sl3516 - drop invalid sg_dma_len checks before DMA mapping
      crypto: powerpc/aes - use bool for encryption/decryption flag
      crypto: bcm - use memcpy_and_pad in ahash_hmac_setkey
      crypto: qce - drop redundant variable in qce_skcipher_done
      crypto: octeontx - simplify get_{eng,ucode}_type_str helpers
      crypto: atmel-ecc - simplify control flow in atmel_ecdh_set_secret
      crypto: atmel-ecc - drop redundant return variable
      crypto: qce - simplify devm_qce_register_algs
      crypto: qce - simplify qce_handle_request

Udit Tiwari (1):
      crypto: qce - Add runtime PM and interconnect bandwidth scaling support

Vinicius Costa Gomes (1):
      crypto: iaa - unmap dst before software fallback on decompress

Wenjia Zhang (1):
      dt-bindings: crypto: qcom,inline-crypto-engine: Add x1e80100 support

Yuho Choi (2):
      hwrng: ks-sa - Fix runtime PM cleanup on registration failure
      hwrng: imx-rngc - Disable clock on registration failure

Zhushuai Yin (1):
      crypto: hisilicon/sec2 - fix CCM algorithm long packet failure

 .../ABI/testing/sysfs-firmware-sev-vulnerabilities |  19 ++
 Documentation/admin-guide/sysctl/crypto.rst        |  36 +++
 Documentation/crypto/architecture.rst              |   2 +-
 Documentation/crypto/userspace-if.rst              |  13 +-
 .../bindings/crypto/qcom,inline-crypto-engine.yaml |  27 +-
 .../devicetree/bindings/crypto/qcom,prng.yaml      |   2 +
 .../devicetree/bindings/crypto/qcom-qce.yaml       |   1 +
 .../bindings/rng/inside-secure,safexcel-eip76.yaml |   2 +-
 MAINTAINERS                                        |   2 +-
 arch/arm/configs/multi_v7_defconfig                |   3 +-
 arch/arm/configs/qcom_defconfig                    |   2 +-
 arch/arm64/configs/defconfig                       |   3 +-
 arch/powerpc/crypto/aes_cbc.c                      |   6 +-
 crypto/af_alg.c                                    |  76 +++++-
 crypto/algif_aead.c                                |  11 +
 crypto/algif_hash.c                                |  24 ++
 crypto/algif_rng.c                                 |   9 +
 crypto/algif_skcipher.c                            |  23 ++
 crypto/api.c                                       |   2 +-
 crypto/crypto_user.c                               |   9 +-
 crypto/ecc.c                                       |  98 +++++---
 crypto/hctr2.c                                     |   3 +-
 crypto/krb5/krb5_api.c                             |   8 +-
 crypto/lrw.c                                       |   2 +-
 crypto/lskcipher.c                                 |   4 +-
 crypto/xts.c                                       |   3 +-
 drivers/char/hw_random/Kconfig                     |  13 +-
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/airoha-trng.c               |   4 +-
 drivers/char/hw_random/atmel-rng.c                 |   2 +-
 drivers/char/hw_random/cctrng.c                    |   2 +-
 drivers/char/hw_random/core.c                      | 105 ++++++--
 drivers/char/hw_random/hisi-trng-v2.c              |   2 +-
 drivers/char/hw_random/imx-rngc.c                  |   6 +-
 drivers/char/hw_random/jh7110-trng.c               |   3 +-
 drivers/char/hw_random/ks-sa-rng.c                 |   9 +-
 drivers/char/hw_random/omap-rng.c                  |  35 +--
 drivers/{crypto => char/hw_random}/qcom-rng.c      | 156 ++----------
 drivers/char/hw_random/stm32-rng.c                 |  10 +-
 drivers/char/hw_random/xgene-rng.c                 |   4 +-
 drivers/char/hw_random/xilinx-trng.c               |  32 ++-
 drivers/crypto/Kconfig                             |  18 +-
 drivers/crypto/Makefile                            |   1 -
 drivers/crypto/allwinner/Kconfig                   |  16 --
 drivers/crypto/allwinner/sun8i-ce/Makefile         |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |  67 +----
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c  | 159 ------------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |  29 ---
 drivers/crypto/allwinner/sun8i-ss/Makefile         |   1 -
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |  49 +---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c  | 177 --------------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |  23 --
 drivers/crypto/amcc/crypto4xx_core.c               |  34 +--
 drivers/crypto/amlogic/amlogic-gxl-core.c          |   4 +-
 drivers/crypto/aspeed/aspeed-acry.c                |   6 +-
 drivers/crypto/aspeed/aspeed-hace.c                |   6 +-
 drivers/crypto/atmel-aes.c                         |   4 +-
 drivers/crypto/atmel-ecc.c                         |  66 ++---
 drivers/crypto/atmel-i2c.c                         |   5 +-
 drivers/crypto/atmel-sha.c                         |   4 +-
 drivers/crypto/atmel-sha204a.c                     |  16 +-
 drivers/crypto/atmel-tdes.c                        |  70 +++---
 drivers/crypto/bcm/cipher.c                        |   4 +-
 drivers/crypto/caam/Kconfig                        |   9 -
 drivers/crypto/caam/Makefile                       |   1 -
 drivers/crypto/caam/caamprng.c                     | 241 ------------------
 drivers/crypto/caam/intern.h                       |  15 --
 drivers/crypto/caam/jr.c                           |  48 +---
 drivers/crypto/cavium/nitrox/nitrox_hal.c          |   3 +-
 drivers/crypto/ccp/ccp-crypto-sha.c                |   2 +-
 drivers/crypto/ccp/sev-dev.c                       | 196 ++++++++++++++-
 drivers/crypto/ccp/sev-dev.h                       |   3 +
 drivers/crypto/ccree/cc_driver.c                   |   4 +-
 drivers/crypto/gemini/sl3516-ce-cipher.c           |   8 -
 drivers/crypto/gemini/sl3516-ce-core.c             |   4 +-
 drivers/crypto/hisilicon/qm.c                      |   5 +-
 drivers/crypto/hisilicon/sec/sec_drv.c             |  19 +-
 drivers/crypto/hisilicon/sec2/sec.h                |   3 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  37 ++-
 drivers/crypto/img-hash.c                          |   4 +-
 drivers/crypto/inside-secure/eip93/eip93-main.c    |   6 +-
 drivers/crypto/inside-secure/eip93/eip93-main.h    |  22 +-
 drivers/crypto/inside-secure/safexcel.c            |   4 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         | 272 ++++++++++++++-------
 drivers/crypto/intel/iaa/iaa_crypto_stats.c        |   9 +
 drivers/crypto/intel/iaa/iaa_crypto_stats.h        |   2 +
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c        |   1 +
 .../crypto/intel/keembay/keembay-ocs-aes-core.c    |  16 +-
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c     |   5 +-
 .../crypto/intel/keembay/keembay-ocs-hcu-core.c    |   4 +-
 drivers/crypto/intel/keembay/ocs-aes.c             |   3 +-
 drivers/crypto/intel/qat/qat_common/adf_aer.c      |   2 +
 drivers/crypto/intel/qat/qat_common/adf_cfg.c      |  10 +-
 .../crypto/intel/qat/qat_common/adf_cfg_common.h   |   1 -
 .../crypto/intel/qat/qat_common/adf_cfg_services.c |  15 +-
 .../crypto/intel/qat/qat_common/adf_cfg_services.h |   2 +-
 .../crypto/intel/qat/qat_common/adf_gen2_config.c  |   8 +-
 .../crypto/intel/qat/qat_common/adf_mstate_mgr.c   |   3 +-
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c    |   2 +-
 .../intel/qat/qat_common/adf_transport_debug.c     |   3 +-
 drivers/crypto/intel/qat/qat_common/qat_algs.c     |   1 +
 .../crypto/intel/qat/qat_common/qat_compression.c  |   3 +-
 drivers/crypto/marvell/cesa/cesa.c                 |  55 ++---
 drivers/crypto/marvell/cesa/cesa.h                 |   2 +
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  |  28 +--
 .../marvell/octeontx2/otx2_cpt_mbox_common.c       |   7 +-
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |   5 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |   4 +-
 drivers/crypto/mxs-dcp.c                           |  10 +-
 drivers/crypto/omap-aes.c                          |  88 +------
 drivers/crypto/omap-des.c                          |   4 +-
 drivers/crypto/omap-sham.c                         | 109 ++-------
 drivers/crypto/qce/aead.c                          |  58 +----
 drivers/crypto/qce/common.c                        |  55 +----
 drivers/crypto/qce/common.h                        |  16 +-
 drivers/crypto/qce/core.c                          | 115 +++++++--
 drivers/crypto/qce/regs-v5.h                       |   4 -
 drivers/crypto/qce/sha.c                           |  61 +----
 drivers/crypto/qce/sha.h                           |   1 -
 drivers/crypto/qce/skcipher.c                      | 103 +-------
 drivers/crypto/rockchip/rk3288_crypto.c            |   4 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |   7 +-
 drivers/crypto/sa2ul.c                             |   9 +-
 drivers/crypto/sahara.c                            |   3 +-
 drivers/crypto/stm32/stm32-cryp.c                  |   4 +-
 drivers/crypto/stm32/stm32-hash.c                  |   4 +-
 drivers/crypto/talitos.c                           |  30 +--
 drivers/gpu/drm/ci/arm64.config                    |   2 +-
 include/crypto/aes.h                               |   2 +-
 include/crypto/if_alg.h                            |  42 +++-
 include/crypto/internal/ecc.h                      |   4 +-
 include/linux/psp-sev.h                            |  51 ++++
 include/linux/rhashtable.h                         |   1 -
 include/uapi/linux/psp-sfs.h                       |   4 +-
 lib/rhashtable.c                                   |   2 +
 135 files changed, 1405 insertions(+), 2019 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
 rename drivers/{crypto => char/hw_random}/qcom-rng.c (53%)
 delete mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
 delete mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
 delete mode 100644 drivers/crypto/caam/caamprng.c

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
