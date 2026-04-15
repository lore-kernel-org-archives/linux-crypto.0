Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E1D199931;
	Wed, 15 Apr 2026 01:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776217865; cv=none; b=JGg4WLPEixgaNWhvtWWSsfvHsPHaEHkeUWcNdp+wpN2AW/S2wgzR5kfv5CC2hqcllWeqGF6Oia4s8y19FBXjdVNEU6r1NjiYSGb1/qfp7Waqudvvf8W3C7RmmbDD3Uwn9LoSYfzMPBZwYbBku0qcNlFoRuBZ3TZ52A20ooytMD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776217865; c=relaxed/simple;
	bh=LisGJrgFnIw1G03zfYKd8xoKEfs9HU3qPagv9vTk5qA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fUSEkLdH5T9/ovyJuIc9bvxbL/rEMKV8Mpu6tapsuOIp2uBPkdqT32yrlY9K9y0CiZcM1U+ls/rLkw8Q+9IXQBQ/Yp3D45jygmqgNP0JJxCHAN3z1nRW4ZuQFJ5NUNxwwWXuUnm2AUD1R7g3tYNfz97zzvHZmbllAJl1tz41pvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=LaI0hopd; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="LaI0hopd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=0UdXLkQDaNj4OR8YWBFRDx3kbJLW6NA/AKCsNZBSTmc=; b=LaI0h
	opdFYJEnmAL60VxrWgdwUghFp2bbyP+uJETlVR9GF6XLEl7uHcWgUT4C6X5NL9RG74x9BQBSizSPi
	yniS8DR61MHZQaM2+d+VBJvsT2oOLjFuNLNu+danttt4ZxvFW09+d+QzNt2NUFJSYg6WtnYjPY0ws
	0ZsRsqD5In0AHhthrcFNQNfB40ROpl4dmf311nGVDpbY01quDvluNO5JA0pjJT1mrgqL3ADlTlgM9
	RDMt8L3gq04npHiMBetGT8wrpx0YhkeLlvqHr20GhuueWpOJjQhHLl1XenQ+H0VeMpsOhV0MxeIoV
	NktiDWHqYnehwOMq06cj1eF/Cr74Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wCozT-006AQs-1g;
	Wed, 15 Apr 2026 09:50:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 15 Apr 2026 09:50:46 +0800
Date: Wed, 15 Apr 2026 09:50:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 7.1
Message-ID: <ad7u9gGDjLBaFt1_@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit d240b079a37e90af03fd7dfec94930eb6c83936e:

  crypto: atmel-sha204a - Fix OOM ->tfm_count leak (2026-02-28 12:53:25 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p1

for you to fetch changes up to 8879a3c110cb8ca5a69c937643f226697aa551d9:

  crypto: af_alg - use sock_kmemdup in alg_setkey_by_key_serial (2026-04-12 16:47:10 +0800)

----------------------------------------------------------------
This update includes the following changes:

API:

- Replace crypto_get_default_rng with crypto_stdrng_get_bytes.
- Remove simd skcipher support.
- Allow algorithm types to be disabled when CRYPTO_SELFTESTS is off.

Algorithms:

- Remove CPU-based des/3des acceleration.
- Add test vectors for authenc(hmac(md5),cbc(aes)).
- Add test vectors for authenc(hmac(md5),cbc(des)).
- Add test vectors for authenc(hmac(md5),rfc3686(ctr(aes))).
- Add test vectors for authenc(hmac(sha1),rfc3686(ctr(aes))).
- Add test vectors for authenc(hmac(sha224),rfc3686(ctr(aes))).
- Add test vectors for authenc(hmac(sha256),rfc3686(ctr(aes))).
- Add test vectors for authenc(hmac(sha384),rfc3686(ctr(aes))).
- Add test vectors for authenc(hmac(sha512),rfc3686(ctr(aes))).
- Replace spin lock with mutex in jitterentropy.

Drivers:

- Add authenc algorithms to safexcel.
- Add support for zstd in qat.
- Add wireless mode support for QAT GEN6.
- Add anti-rollback support for QAT GEN6.
- Add support for ctr(aes), gcm(aes), and ccm(aes) in dthev2.
----------------------------------------------------------------

Abel Vesa (1):
      dt-bindings: crypto: qcom,inline-crypto-engine: Document the Eliza ICE

Abhinaba Rakshit (1):
      dt-bindings: crypto: ice: add operating-points-v2 property for QCOM ICE

Ahsan Atta (2):
      crypto: qat - disable 4xxx AE cluster when lead engine is fused off
      crypto: qat - disable 420xx AE cluster when lead engine is fused off

Aleksander Jan Bajkowski (15):
      crypto: safexcel - Group authenc ciphersuites
      crypto: safexcel - Add support for authenc(hmac(md5),*) suites
      crypto: tesmgr - allow authenc(hmac(sha224/sha384),cbc(aes)) in fips mode
      crypto: testmgr - Add test vectors for authenc(hmac(md5),cbc(des))
      crypto: inside-secure/eip93 - fix register definition
      dt-bindings: crypto: inside-secure,safexcel: add compatible for MT7981
      crypto: testmgr - Add test vectors for authenc(hmac(sha1),rfc3686(ctr(aes)))
      crypto: testmgr - Add test vectors for authenc(hmac(sha224),rfc3686(ctr(aes)))
      crypto: testmgr - Add test vectors for authenc(hmac(sha256),rfc3686(ctr(aes)))
      crypto: testmgr - Add test vectors for authenc(hmac(sha384),rfc3686(ctr(aes)))
      crypto: testmgr - Add test vectors for authenc(hmac(sha512),rfc3686(ctr(aes)))
      crypto: inside-secure/eip93 - register hash before authenc algorithms
      crypto: testmgr - Add test vectors for authenc(hmac(md5),rfc3686(ctr(aes)))
      crypto: inside-secure/eip93 - make it selectable for ECONET
      crypto: testmgr - Add test vectors for authenc(hmac(md5),cbc(aes))

Alexander Dahl (1):
      crypto: docs/userspace-if - Fix outdated links

Atharv Dubey (1):
      crypto: qat - replace scnprintf() with sysfs_emit()

Chenghai Huang (4):
      crypto: hisilicon/qm - add const qualifier to info_name in struct qm_cmd_dump_item
      crypto: hisilicon/qm - remove else after return
      crypto: hisilicon/qm - drop redundant variable initialization
      crypto: hisilicon - remove unused and non-public APIs for qm and sec

Chuyi Zhou (1):
      padata: Remove cpu online check from cpu add and removal

Daniel Jordan (1):
      padata: Put CPU offline callback in ONLINE section to allow failure

Daniele Alessandrelli (1):
      MAINTAINERS: Remove Daniele Alessandrelli as Keem Bay maintainer

Dave Hansen (1):
      MAINTAINERS: Remove bouncing maintaner for IAA driver

Eric Biggers (18):
      MAINTAINERS: remove outdated entry for crypto/rng.c
      crypto: simd - Remove unused skcipher support
      crypto: cryptd - Remove unused functions
      crypto: rng - Add crypto_stdrng_get_bytes()
      crypto: dh - Use crypto_stdrng_get_bytes()
      crypto: ecc - Use crypto_stdrng_get_bytes()
      crypto: geniv - Use crypto_stdrng_get_bytes()
      crypto: hisilicon/hpre - Use crypto_stdrng_get_bytes()
      crypto: intel/keembay-ocs-ecc - Use crypto_stdrng_get_bytes()
      net: tipc: Use crypto_stdrng_get_bytes()
      crypto: rng - Unexport "default RNG" symbols
      crypto: rng - Make crypto_stdrng_get_bytes() use normal RNG in non-FIPS mode
      crypto: fips - Depend on CRYPTO_DRBG=y
      crypto: rng - Don't pull in DRBG when CRYPTO_FIPS=n
      crypto: s390 - Remove des and des3_ede code
      crypto: sparc - Remove des and des3_ede code
      crypto: x86 - Remove des and des3_ede code
      crypto: cryptomgr - Select algorithm types only when CRYPTO_SELFTESTS

George Abraham P (1):
      crypto: qat - add wireless mode support for QAT GEN6

Giovanni Cabiddu (7):
      crypto: qat - use acomp_tfm_ctx()
      crypto: qat - fix compression instance leak
      crypto: qat - fix type mismatch in RAS sysfs show functions
      crypto: iaa - fix per-node CPU counter reset in rebalance_wq_table()
      crypto: qat - use swab32 macro
      crypto: qat - add support for zstd
      crypto: qat - fix IRQ cleanup on 6xxx probe failure

Gustavo A. R. Silva (1):
      crypto: nx - Fix packed layout in struct nx842_crypto_header

Haixin Xu (1):
      crypto: jitterentropy - replace long-held spinlock with mutex

Haoxiang Li (1):
      crypto: ccree - fix a memory leak in cc_mac_digest()

Herbert Xu (2):
      crypto: tegra - Disable softirqs before finalizing request
      crypto: geniv - Remove unused spinlock from struct aead_geniv_ctx

Kit Dallege (1):
      crypto: add missing kernel-doc for anonymous union members

Mieczyslaw Nalewaj (2):
      crypto: inside-secure/eip93 - correct ecb(des-eip93) typo
      crypto: inside-secure/eip93 - add missing address terminator character

Mykyta Yatsenko (1):
      rhashtable: consolidate hash computation in rht_key_get_hash()

Pat Somaru (1):
      crypto: virtio - Convert from tasklet to BH workqueue

Paul Louvel (3):
      crypto: aspeed - Use memcpy_from_sglist() in aspeed_ahash_dma_prepare()
      crypto: talitos - fix SEC1 32k ahash request limitation
      crypto: talitos - rename first/last to first_desc/last_desc

Randy Dunlap (4):
      crypto: acomp - repair kernel-doc warnings
      crypto: des - fix all kernel-doc warnings
      crypto: ecc - correct kernel-doc format
      hwrng: core - avoid kernel-doc warnings

Robert Marko (1):
      dt-bindings: rng: atmel,at91-trng: add microchip,lan9691-trng

Saeed Mirzamohammadi (2):
      crypto: tcrypt - clamp num_mb to avoid divide-by-zero
      crypto: tcrypt - stop ahash speed tests when setkey fails

Suman Kumar Chakraborty (3):
      crypto: qat - fix indentation of macros in qat_hal.c
      crypto: qat - fix firmware loading failure for GEN6 devices
      crypto: qat - add anti-rollback support for GEN6 devices

Sun Chaobo (1):
      crypto: Fix several spelling mistakes in comments

T Pratham (3):
      crypto: ti - Add support for AES-CTR in DTHEv2 driver
      crypto: ti - Add support for AES-GCM in DTHEv2 driver
      crypto: ti - Add support for AES-CCM in DTHEv2 driver

Thomas Fourier (1):
      crypto: hisilicon - Fix dma_unmap_single() direction

Thorsten Blum (39):
      crypto: octeontx - Replace scnprintf with strscpy in print_ucode_info
      crypto: caam - Replace snprintf with strscpy in caam_hash_alloc
      crypto: atmel-sha204a - Fix error codes in OTP reads
      crypto: atmel-sha204a - Fix OTP sysfs read and error handling
      crypto: atmel-sha204a - Fix uninitialized data access on OTP read error
      crypto: atmel-ecc - Release client on allocation failure
      crypto: vmx - Remove disabled build directive
      crypto: qce - Replace snprintf("%s") with strscpy
      crypto: atmel-i2c - Replace hard-coded bus clock rate with constant
      crypto: qat - Drop redundant local variables
      crypto: qce - Remove return variable and unused assignments
      crypto: atmel-sha204a - Drop redundant I2C_FUNC_I2C check
      crypto: atmel-tdes - fix DMA sync direction
      crypto: atmel - use list_first_entry_or_null to simplify find_dev
      crypto: artpec6 - use memcpy_and_pad to simplify prepare_hash
      crypto: atmel-aes - Fix 3-page memory leak in atmel_aes_buff_cleanup
      crypto: atmel-aes - guard unregister on error in atmel_aes_register_algs
      crypto: nx - fix bounce buffer leaks in nx842_crypto_{alloc,free}_ctx
      crypto: nx - fix context leak in nx842_crypto_free_ctx
      crypto: atmel-sha204a - Fix potential UAF and memory leak in remove path
      crypto: s5p-sss - use unregister_{ahashes,skciphers} in probe/remove
      crypto: marvell/cesa - use memcpy_and_pad in mv_cesa_ahash_export
      crypto: nx - annotate struct nx842_crypto_header with __counted_by
      printk: add print_hex_dump_devel()
      crypto: caam - guard HMAC key hex dumps in hash_digest_key
      crypto: stm32 - use list_first_entry_or_null to simplify hash_find_dev
      crypto: stm32 - use list_first_entry_or_null to simplify cryp_find_dev
      crypto: qce - use memcpy_and_pad in qce_aead_setkey
      crypto: hifn_795x - Replace snprintf("%s") with strscpy
      crypto: ccp - Replace snprintf("%s") with strscpy
      crypto: kconfig - fix typos in atmel-ecc and atmel-sha204a help
      crypto: img-hash - use list_first_entry_or_null to simplify digest
      crypto: img-hash - drop redundant return variable
      crypto: qce - simplify qce_xts_swapiv()
      crypto: atmel-ecc - add Thorsten Blum as maintainer
      crypto: atmel-sha204a - add Thorsten Blum as maintainer
      crypto: omap - convert reqctx buffer to fixed-size array
      crypto: vmx - remove CRYPTO_DEV_VMX from Kconfig
      crypto: af_alg - use sock_kmemdup in alg_setkey_by_key_serial

Tycho Andersen (AMD) (2):
      crypto: ccp - simplify sev_update_firmware()
      include/psp-sev.h: fix structure member in comment

Wenkai Lin (1):
      crypto: hisilicon/sec2 - prevent req used-after-free for sec

Wesley Atwell (2):
      crypto: simd - reject compat registrations without __ prefixes
      crypto: krb5enc - fix sleepable flag handling in encrypt dispatch

Zhushuai Yin (1):
      crypto: hisilicon - fix the format string type error

Zongyu Wu (1):
      crypto: hisilicon - add device load query functionality to debugfs

 Documentation/ABI/testing/debugfs-hisi-hpre        |    7 +
 Documentation/ABI/testing/debugfs-hisi-sec         |    7 +
 Documentation/ABI/testing/debugfs-hisi-zip         |    7 +
 Documentation/ABI/testing/sysfs-driver-qat_svn     |  114 ++
 Documentation/crypto/userspace-if.rst              |    4 +-
 .../bindings/crypto/inside-secure,safexcel.yaml    |    5 +-
 .../bindings/crypto/qcom,inline-crypto-engine.yaml |   27 +
 .../devicetree/bindings/rng/atmel,at91-trng.yaml   |    1 +
 MAINTAINERS                                        |   24 +-
 arch/s390/configs/debug_defconfig                  |    1 -
 arch/s390/configs/defconfig                        |    1 -
 arch/s390/crypto/Kconfig                           |   16 -
 arch/s390/crypto/Makefile                          |    1 -
 arch/s390/crypto/des_s390.c                        |  502 ------
 arch/sparc/crypto/Kconfig                          |   14 -
 arch/sparc/crypto/Makefile                         |    2 -
 arch/sparc/crypto/des_asm.S                        |  419 -----
 arch/sparc/crypto/des_glue.c                       |  482 ------
 arch/x86/crypto/Kconfig                            |   14 -
 arch/x86/crypto/Makefile                           |    3 -
 arch/x86/crypto/des3_ede-asm_64.S                  |  831 ---------
 arch/x86/crypto/des3_ede_glue.c                    |  391 -----
 crypto/Kconfig                                     |   36 +-
 crypto/af_alg.c                                    |    4 +-
 crypto/cryptd.c                                    |  112 +-
 crypto/dh.c                                        |    8 +-
 crypto/drbg.c                                      |    2 +-
 crypto/ecc.c                                       |   11 +-
 crypto/geniv.c                                     |   10 +-
 crypto/jitterentropy-kcapi.c                       |   14 +-
 crypto/krb5enc.c                                   |    5 +-
 crypto/lrw.c                                       |    2 +-
 crypto/rng.c                                       |   23 +-
 crypto/simd.c                                      |  239 +--
 crypto/tcrypt.c                                    |   17 +-
 crypto/tea.c                                       |    2 +-
 crypto/testmgr.c                                   |   53 +-
 crypto/testmgr.h                                   | 1764 ++++++++++++++++++++
 crypto/xts.c                                       |    2 +-
 drivers/crypto/Kconfig                             |   13 +-
 drivers/crypto/Makefile                            |    1 -
 drivers/crypto/allwinner/Kconfig                   |    2 +
 drivers/crypto/aspeed/aspeed-hace-hash.c           |    3 +-
 drivers/crypto/atmel-aes.c                         |    8 +-
 drivers/crypto/atmel-ecc.c                         |    1 +
 drivers/crypto/atmel-i2c.c                         |    6 +-
 drivers/crypto/atmel-sha.c                         |   17 +-
 drivers/crypto/atmel-sha204a.c                     |   41 +-
 drivers/crypto/atmel-tdes.c                        |    8 +-
 drivers/crypto/axis/artpec6_crypto.c               |    9 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   17 +-
 drivers/crypto/caam/caamhash.c                     |   16 +-
 drivers/crypto/ccp/ccp-crypto-aes-galois.c         |    6 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c            |    6 +-
 drivers/crypto/ccp/ccp-crypto-aes.c                |    5 +-
 drivers/crypto/ccp/ccp-crypto-des3.c               |    5 +-
 drivers/crypto/ccp/ccp-crypto-rsa.c                |    6 +-
 drivers/crypto/ccp/ccp-crypto-sha.c                |    5 +-
 drivers/crypto/ccp/sev-dev.c                       |   27 +-
 drivers/crypto/ccree/cc_hash.c                     |    1 +
 drivers/crypto/hifn_795x.c                         |    6 +-
 drivers/crypto/hisilicon/debugfs.c                 |   76 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |   12 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   18 +
 drivers/crypto/hisilicon/qm.c                      |   16 +-
 drivers/crypto/hisilicon/sec/sec_algs.c            |    2 +-
 drivers/crypto/hisilicon/sec2/sec.h                |    2 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |    2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |   13 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |   19 +
 drivers/crypto/img-hash.c                          |   24 +-
 drivers/crypto/inside-secure/eip93/Kconfig         |    2 +-
 drivers/crypto/inside-secure/eip93/eip93-aead.c    |    2 +-
 drivers/crypto/inside-secure/eip93/eip93-aead.h    |    2 +-
 drivers/crypto/inside-secure/eip93/eip93-aes.h     |    2 +-
 drivers/crypto/inside-secure/eip93/eip93-cipher.c  |    4 +-
 drivers/crypto/inside-secure/eip93/eip93-cipher.h  |    2 +-
 drivers/crypto/inside-secure/eip93/eip93-common.c  |    2 +-
 drivers/crypto/inside-secure/eip93/eip93-common.h  |    2 +-
 drivers/crypto/inside-secure/eip93/eip93-des.h     |    2 +-
 drivers/crypto/inside-secure/eip93/eip93-hash.c    |    2 +-
 drivers/crypto/inside-secure/eip93/eip93-hash.h    |    2 +-
 drivers/crypto/inside-secure/eip93/eip93-main.c    |   18 +-
 drivers/crypto/inside-secure/eip93/eip93-main.h    |    2 +-
 drivers/crypto/inside-secure/eip93/eip93-regs.h    |    4 +-
 drivers/crypto/inside-secure/safexcel.c            |    8 +-
 drivers/crypto/inside-secure/safexcel.h            |    8 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |  149 ++
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |    2 +-
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c     |   17 +-
 drivers/crypto/intel/qat/Kconfig                   |    2 +
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |   21 +-
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   |   15 +-
 .../crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c   |  130 +-
 .../crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h   |   20 +
 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c        |   37 +-
 drivers/crypto/intel/qat/qat_common/Makefile       |    3 +
 .../intel/qat/qat_common/adf_accel_devices.h       |    8 +
 .../crypto/intel/qat/qat_common/adf_accel_engine.c |    7 +
 drivers/crypto/intel/qat/qat_common/adf_admin.c    |   70 +
 drivers/crypto/intel/qat/qat_common/adf_admin.h    |    2 +
 drivers/crypto/intel/qat/qat_common/adf_anti_rb.c  |   66 +
 drivers/crypto/intel/qat/qat_common/adf_anti_rb.h  |   37 +
 .../crypto/intel/qat/qat_common/adf_common_drv.h   |    6 +-
 .../crypto/intel/qat/qat_common/adf_fw_config.h    |    1 +
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.c |   18 +-
 .../crypto/intel/qat/qat_common/adf_gen6_shared.c  |    6 -
 .../crypto/intel/qat/qat_common/adf_gen6_shared.h  |    1 -
 drivers/crypto/intel/qat/qat_common/adf_init.c     |    9 +-
 .../intel/qat/qat_common/adf_sysfs_anti_rb.c       |  133 ++
 .../intel/qat/qat_common/adf_sysfs_anti_rb.h       |   11 +
 .../intel/qat/qat_common/adf_sysfs_ras_counters.c  |   12 +-
 drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c |   10 +-
 drivers/crypto/intel/qat/qat_common/icp_qat_fw.h   |    7 +
 .../crypto/intel/qat/qat_common/icp_qat_fw_comp.h  |    2 +
 .../intel/qat/qat_common/icp_qat_fw_init_admin.h   |   15 +-
 .../qat/qat_common/icp_qat_fw_loader_handle.h      |    1 +
 drivers/crypto/intel/qat/qat_common/icp_qat_hw.h   |    6 +-
 .../intel/qat/qat_common/icp_qat_hw_20_comp.h      |   10 +-
 .../crypto/intel/qat/qat_common/qat_comp_algs.c    |  540 +++++-
 drivers/crypto/intel/qat/qat_common/qat_comp_req.h |    9 +
 .../intel/qat/qat_common/qat_comp_zstd_utils.c     |  165 ++
 .../intel/qat/qat_common/qat_comp_zstd_utils.h     |   13 +
 .../crypto/intel/qat/qat_common/qat_compression.c  |   23 +-
 drivers/crypto/intel/qat/qat_common/qat_hal.c      |   27 +-
 drivers/crypto/intel/qat/qat_common/qat_uclo.c     |   25 +-
 drivers/crypto/marvell/cesa/hash.c                 |    3 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  |    8 +-
 drivers/crypto/nx/nx-842.c                         |   10 +-
 drivers/crypto/nx/nx-842.h                         |    6 +-
 drivers/crypto/omap-sham.c                         |   21 +-
 drivers/crypto/qce/aead.c                          |   22 +-
 drivers/crypto/qce/common.c                        |   12 +-
 drivers/crypto/qce/sha.c                           |    6 +-
 drivers/crypto/qce/skcipher.c                      |    6 +-
 drivers/crypto/s5p-sss.c                           |   27 +-
 drivers/crypto/stm32/stm32-cryp.c                  |   16 +-
 drivers/crypto/stm32/stm32-hash.c                  |   16 +-
 drivers/crypto/talitos.c                           |  340 ++--
 drivers/crypto/tegra/tegra-se-aes.c                |    9 +
 drivers/crypto/tegra/tegra-se-hash.c               |    3 +
 drivers/crypto/ti/Kconfig                          |    4 +
 drivers/crypto/ti/dthev2-aes.c                     |  899 +++++++++-
 drivers/crypto/ti/dthev2-common.c                  |   19 +
 drivers/crypto/ti/dthev2-common.h                  |   27 +-
 drivers/crypto/virtio/virtio_crypto_common.h       |    3 +-
 drivers/crypto/virtio/virtio_crypto_core.c         |   11 +-
 include/crypto/acompress.h                         |    5 +-
 include/crypto/cryptd.h                            |   33 -
 include/crypto/des.h                               |    8 +-
 include/crypto/internal/acompress.h                |    1 +
 include/crypto/internal/ecc.h                      |   22 +-
 include/crypto/internal/geniv.h                    |    2 -
 include/crypto/internal/scompress.h                |    1 +
 include/crypto/internal/simd.h                     |   19 -
 include/crypto/rng.h                               |   25 +-
 include/crypto/skcipher.h                          |    1 +
 include/linux/cpuhotplug.h                         |    1 -
 include/linux/hisi_acc_qm.h                        |   14 +-
 include/linux/hw_random.h                          |    2 +-
 include/linux/padata.h                             |    8 +-
 include/linux/printk.h                             |   13 +
 include/linux/rhashtable.h                         |   13 +-
 include/uapi/linux/psp-sev.h                       |    2 +-
 kernel/padata.c                                    |  130 +-
 net/tipc/crypto.c                                  |   13 +-
 166 files changed, 5209 insertions(+), 3842 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-qat_svn
 delete mode 100644 arch/s390/crypto/des_s390.c
 delete mode 100644 arch/sparc/crypto/des_asm.S
 delete mode 100644 arch/sparc/crypto/des_glue.c
 delete mode 100644 arch/x86/crypto/des3_ede-asm_64.S
 delete mode 100644 arch/x86/crypto/des3_ede_glue.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_anti_rb.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_anti_rb.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_anti_rb.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_anti_rb.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.h

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
