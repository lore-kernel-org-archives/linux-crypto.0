Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2FA20C46B;
	Thu, 23 Jan 2025 11:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737630654; cv=none; b=kGSMkLVJoNADyJMWP6ghinq/hB4KqSy41sFLfEXX2+/Hp7ykICvtHZ4YsqxvlmMRXi4W/ZnXiNke5xfYSjUC/Z6Y7NcWI2xEFWvbcKRJDiiEk91MmBAKoADBLkiHClPFYMImRAEe4XrjMXDS+prALh/kkZEzoLqHWUI5+QOXdrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737630654; c=relaxed/simple;
	bh=XwRFVOVRIb0VP1BrYBO65bIJlxocSlTpWE5Du5Wwj00=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T5vXjIR2PRJGPnz9HEJq9CTsz2zij/zIHj4h0zik7BnQ/Mlxr4U8W3rPdKzpAB/pfsJ+X/w2n7GHHmrHAsl0JxEZb6pM5aVw+N8/1VlYdkod3iDnrzxsQpV1/n7j1Hs8Z8tYhIWBOSKhPx7ekX8ZZQY1jjP5k1DqGGQ71i+U7bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YXKU+N5l; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YXKU+N5l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XGYChLnBSkxyFQo7Te/GxkH/5f4hGWTvOAK9OYHdx7c=; b=YXKU+N5llliQl+4FyXkJZpV6s5
	509D5zc8rY0TgnrMs0AVozn295SLCy74EvwTSNDq0/GwIt+uJipozSWKQvFTuh2NwMRm50139nL1J
	GqZFw4tDuEwmJJLyj3T3ms9tO88g2o4ACTRn2yOHXIWZrKMPhLRIz/JBAdimziXQNYHLs2a6t7zNz
	nGGaz/96DBj095KL3n0YxMogMjsaOzwQWdABpoR/W6Zfj7YAFnELs1TbAfi3Swcn5J9Qv9D387n+a
	0Qd0elzv7APLy8KMuxuuD059+HCyUhu31bjBTQp8jFwuoCRtGb39DJHOBXDisX1WZPgfutQtiLPrp
	l0OjfsPQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tautd-00BnTZ-1T;
	Thu, 23 Jan 2025 19:10:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Jan 2025 19:10:34 +0800
Date: Thu, 23 Jan 2025 19:10:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 6.14
Message-ID: <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
References: <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>

Hi Linus:

The following changes since commit cd26cd65476711e2c69e0a049c0eeef4b743f5ac:

  crypto: hisilicon/debugfs - fix the struct pointer incorrectly offset problem (2024-12-10 13:40:25 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.14-p1 

for you to fetch changes up to 9d4f8e54cef2c42e23ef258833dbd06a1eaff89b:

  rhashtable: Fix rhashtable_try_insert test (2025-01-19 12:44:28 +0800)

----------------------------------------------------------------
This update includes the following changes:

API:

- Remove physical address skcipher walking.
- Fix boot-up self-test race.

Algorithms:

- Optimisations for x86/aes-gcm.
- Optimisations for x86/aes-xts.
- Remove VMAC.
- Remove keywrap.

Drivers:

- Remove n2.

Others:

- Fixes for padata UAF.
- Fix potential rhashtable deadlock by moving schedule_work outside lock.
----------------------------------------------------------------

Bartosz Golaszewski (9):
      crypto: qce - fix goto jump in error path
      crypto: qce - unregister previously registered algos in error path
      crypto: qce - remove unneeded call to icc_set_bw() in error path
      crypto: qce - shrink code with devres clk helpers
      crypto: qce - convert qce_dma_request() to use devres
      crypto: qce - make qce_register_algs() a managed interface
      crypto: qce - use __free() for a buffer that's always freed
      crypto: qce - convert tasklet to workqueue
      crypto: qce - switch to using a mutex

Breno Leitao (1):
      rhashtable: Fix potential deadlock by moving schedule_work outside lock

Chen Ridong (4):
      crypto: tegra - do not transfer req when tegra init fails
      padata: add pd get/put refcnt helper
      padata: fix UAF in padata_reorder
      padata: avoid UAF for reorder_work

Dr. David Alan Gilbert (2):
      crypto: lib/gf128mul - Remove some bbe deadcode
      crypto: asymmetric_keys - Remove unused key_being_used_for[]

Eric Biggers (32):
      crypto: qce - fix priority to be less than ARMv8 CE
      crypto: n2 - remove Niagara2 SPU driver
      crypto: skcipher - remove support for physical address walks
      crypto: anubis - stop using cra_alignmask
      crypto: aria - stop using cra_alignmask
      crypto: tea - stop using cra_alignmask
      crypto: khazad - stop using cra_alignmask
      crypto: seed - stop using cra_alignmask
      crypto: x86 - remove assignments of 0 to cra_alignmask
      crypto: aegis - remove assignments of 0 to cra_alignmask
      crypto: keywrap - remove assignment of 0 to cra_alignmask
      crypto: x86/aes-gcm - code size optimization
      crypto: x86/aes-gcm - tune better for AMD CPUs
      crypto: x86/aes-xts - use .irp when useful
      crypto: x86/aes-xts - make the register aliases per-function
      crypto: x86/aes-xts - improve some comments
      crypto: x86/aes-xts - change len parameter to int
      crypto: x86/aes-xts - more code size optimizations
      crypto: x86/aes-xts - additional optimizations
      crypto: vmac - remove unused VMAC algorithm
      crypto: keywrap - remove unused keywrap algorithm
      crypto: ahash - make hash walk functions private to ahash.c
      crypto: powerpc/p10-aes-gcm - simplify handling of linear associated data
      crypto: omap - switch from scatter_walk to plain offset
      crypto: skcipher - document skcipher_walk_done() and rename some vars
      crypto: skcipher - remove unnecessary page alignment of bounce buffer
      crypto: skcipher - remove redundant clamping to page size
      crypto: skcipher - remove redundant check for SKCIPHER_WALK_SLOW
      crypto: skcipher - fold skcipher_walk_skcipher() into skcipher_walk_virt()
      crypto: skcipher - clean up initialization of skcipher_walk::flags
      crypto: skcipher - optimize initializing skcipher_walk fields
      crypto: skcipher - call cond_resched() directly

Gaurav Jain (1):
      crypto: caam - use JobR's space to access page 0 regs

Gaurav Kashyap (3):
      dt-bindings: crypto: qcom-qce: Document the SM8750 crypto engine
      dt-bindings: crypto: qcom,prng: Document SM8750 RNG
      dt-bindings: crypto: qcom,inline-crypto-engine: Document the SM8750 ICE

Herbert Xu (6):
      crypto: api - Fix boot-up self-test race
      crypto: api - Call crypto_schedule_test outside of mutex
      MAINTAINERS: Move rhashtable over to linux-crypto
      crypto: sig - Set maskset to CRYPTO_ALG_TYPE_MASK
      crypto: lib/aesgcm - Reduce stack usage in libaesgcm_init
      rhashtable: Fix rhashtable_try_insert test

Joe Hattori (1):
      crypto: ixp4xx - fix OF node reference leaks in init_ixp_crypto()

Kanchana P Sridhar (1):
      crypto: iaa - Fix IAA disabling that occurs when sync_mode is set to 'async'

Krzysztof Kozlowski (1):
      crypto: bcm - Drop unused setting of local 'ptr' variable

Mario Limonciello (1):
      crypto: ccp - Use scoped guard for mutex

Md Sadre Alam (1):
      dt-bindings: crypto: qcom,prng: document ipq9574, ipq5424 and ipq5322

Nathan Chancellor (1):
      crypto: qce - revert "use __free() for a buffer that's always freed"

Thomas Weiﬂschuh (1):
      padata: fix sysfs store callback check

Thorsten Blum (2):
      crypto: fips - Use str_enabled_disabled() helper in fips_enable()
      crypto: proc - Use str_yes_no() and str_no_yes() helpers

Weili Qian (2):
      crypto: hisilicon/zip - add data aggregation feature
      crypto: hisilicon/zip - support new error report

Wenkai Lin (2):
      crypto: hisilicon/sec2 - fix for aead icv error
      crypto: hisilicon/sec2 - fix for aead invalid authsize

Yang Shen (1):
      crypto: hisilicon/qm - support new function communication

Yuvaraj Ranganathan (3):
      dt-bindings: crypto: qcom,prng: document QCS8300
      dt-bindings: crypto: ice: document the qcs8300 inline crypto engine
      dt-bindings: crypto: qcom-qce: document the QCS8300 crypto engine

 .../bindings/crypto/qcom,inline-crypto-engine.yaml |    2 +
 .../devicetree/bindings/crypto/qcom,prng.yaml      |    5 +
 .../devicetree/bindings/crypto/qcom-qce.yaml       |    2 +
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst |    9 +-
 MAINTAINERS                                        |    2 +-
 arch/arm/configs/pxa_defconfig                     |    1 -
 arch/loongarch/configs/loongson3_defconfig         |    1 -
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
 arch/mips/configs/bigsur_defconfig                 |    1 -
 arch/mips/configs/decstation_64_defconfig          |    2 -
 arch/mips/configs/decstation_defconfig             |    2 -
 arch/mips/configs/decstation_r4k_defconfig         |    2 -
 arch/mips/configs/ip27_defconfig                   |    1 -
 arch/mips/configs/ip30_defconfig                   |    1 -
 arch/powerpc/crypto/aes-gcm-p10-glue.c             |    9 +-
 arch/s390/configs/debug_defconfig                  |    2 -
 arch/s390/configs/defconfig                        |    2 -
 arch/x86/crypto/aegis128-aesni-glue.c              |    1 -
 arch/x86/crypto/aes-gcm-avx10-x86_64.S             |  119 +-
 arch/x86/crypto/aes-xts-avx-x86_64.S               |  329 +--
 arch/x86/crypto/aesni-intel_glue.c                 |   10 +-
 arch/x86/crypto/blowfish_glue.c                    |    1 -
 arch/x86/crypto/camellia_glue.c                    |    1 -
 arch/x86/crypto/des3_ede_glue.c                    |    1 -
 arch/x86/crypto/twofish_glue.c                     |    1 -
 crypto/Kconfig                                     |   18 -
 crypto/Makefile                                    |    2 -
 crypto/aegis128-core.c                             |    2 -
 crypto/ahash.c                                     |  158 +-
 crypto/algapi.c                                    |   31 +-
 crypto/anubis.c                                    |   14 +-
 crypto/aria_generic.c                              |   37 +-
 crypto/asymmetric_keys/asymmetric_type.c           |   10 -
 crypto/fips.c                                      |    4 +-
 crypto/keywrap.c                                   |  320 ---
 crypto/khazad.c                                    |   17 +-
 crypto/proc.c                                      |    9 +-
 crypto/seed.c                                      |   48 +-
 crypto/sig.c                                       |    4 +-
 crypto/skcipher.c                                  |  367 +---
 crypto/tcrypt.c                                    |    4 -
 crypto/tea.c                                       |   83 +-
 crypto/testmgr.c                                   |   26 +-
 crypto/testmgr.h                                   |  192 --
 crypto/vmac.c                                      |  696 -------
 drivers/crypto/Kconfig                             |   17 -
 drivers/crypto/Makefile                            |    2 -
 drivers/crypto/bcm/spu.c                           |    7 +-
 drivers/crypto/caam/blob_gen.c                     |    3 +-
 drivers/crypto/ccp/dbc.c                           |   53 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   13 +-
 drivers/crypto/hisilicon/qm.c                      |  291 ++-
 drivers/crypto/hisilicon/sec2/sec.h                |    3 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  157 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.h         |   11 -
 drivers/crypto/hisilicon/sec2/sec_main.c           |   13 +-
 drivers/crypto/hisilicon/zip/Makefile              |    2 +-
 drivers/crypto/hisilicon/zip/dae_main.c            |  262 +++
 drivers/crypto/hisilicon/zip/zip.h                 |    8 +
 drivers/crypto/hisilicon/zip/zip_main.c            |   52 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |    2 +-
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c        |    3 +
 drivers/crypto/n2_asm.S                            |   96 -
 drivers/crypto/n2_core.c                           | 2168 --------------------
 drivers/crypto/n2_core.h                           |  232 ---
 drivers/crypto/omap-aes.c                          |   34 +-
 drivers/crypto/omap-aes.h                          |    6 +-
 drivers/crypto/omap-des.c                          |   40 +-
 drivers/crypto/qce/aead.c                          |    2 +-
 drivers/crypto/qce/core.c                          |  131 +-
 drivers/crypto/qce/core.h                          |    9 +-
 drivers/crypto/qce/dma.c                           |   22 +-
 drivers/crypto/qce/dma.h                           |    3 +-
 drivers/crypto/qce/sha.c                           |    2 +-
 drivers/crypto/qce/skcipher.c                      |    2 +-
 drivers/crypto/tegra/tegra-se-aes.c                |    7 +-
 drivers/crypto/tegra/tegra-se-hash.c               |    7 +-
 include/crypto/gf128mul.h                          |    6 +-
 include/crypto/internal/hash.h                     |   23 -
 include/crypto/internal/skcipher.h                 |   14 +-
 include/linux/hisi_acc_qm.h                        |    8 +
 include/linux/verification.h                       |    2 -
 kernel/padata.c                                    |   45 +-
 lib/crypto/aesgcm.c                                |    2 +-
 lib/crypto/gf128mul.c                              |   75 -
 lib/rhashtable.c                                   |   12 +-
 97 files changed, 1359 insertions(+), 5061 deletions(-)
 delete mode 100644 crypto/keywrap.c
 delete mode 100644 crypto/vmac.c
 create mode 100644 drivers/crypto/hisilicon/zip/dae_main.c
 delete mode 100644 drivers/crypto/n2_asm.S
 delete mode 100644 drivers/crypto/n2_core.c
 delete mode 100644 drivers/crypto/n2_core.h

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
