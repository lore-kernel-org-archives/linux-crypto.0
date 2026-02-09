Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FB815539A;
	Mon,  9 Feb 2026 08:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770624426; cv=none; b=ZCr6CUqDlUBNdQpSVARuztlMIK1t58lvvIHvpp5d/gdzjbNMnRvmLkot6v8QNkJddIXN0/9J4m835l1DGhNolvBq9dztbxSlgUbCwHcRIsB/1WB+eJQs51UbZvT1PQj10ch/p3lW8uufunSPZ5QUeF+RzS5bcPu+lCuruuN4rNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770624426; c=relaxed/simple;
	bh=EWSnQtQ9EF216uiAd1FRQ/qe6JQRcqPYeigeq1cW0fg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=h7pkS0K9UmYmTYV3ZMtIKADz+kieflihf3mr2cVStQv/9BwvCEsHedFz9LOb6LV6aqvHNCSlIzXCwQQN+KLfpZ/Pylf7XCnaqS2OjykPyQazB8InmuagEMFzzpJM1AqpP9V4nPX41EHaoXGyevQpS4MojDnbda//OK2NJ+jAM8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SMM1GPaS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SMM1GPaS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=WQl4ppjLzjywKuDh/Gh297nHD+anS5MPuQ0dqNu7ATg=; b=SMM1G
	PaS8l1b7JgbnRdSTW3UrHe+Afa4S5N3Mbxtl/d1L3MowICutZRyy/MBcOIZq5dp3SzLB15XXIJS5Q
	9zXx3ezxU7UbOdVoP5kYOOypSOBcIK7h0TGVTSfNWHDO7UHeEby22cOgzu/DKhJQk8anj9dwsHYCk
	VBS/Kp/HIdw+zvaSaLi5aED/AuPw5AXqei0pVoCNKllE37vuGOJNee7d+OM2BirrYi+gWb9cGp5+/
	PPbXI058bqHg15gfcTNEkEdhYNZL56zLmnXiYokX95NPAgkw/RBAyKPs1ql7DiWQHXKdywe8Bh4Ul
	0ClVmBVfZBeX5d9tA+sidrJDzqzrw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vpMIC-005b4h-00;
	Mon, 09 Feb 2026 16:06:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 09 Feb 2026 16:06:47 +0800
Date: Mon, 9 Feb 2026 16:06:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 7.0
Message-ID: <aYmVl48IIm7vtmfL@gondor.apana.org.au>
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

There is a merge conflict with the tip tree due to both touching
crypto/drbg.c.  However, the resolution should be trivial.

The following changes since commit b74fd80d7fe578898a76344064d2678ce1efda61:

  crypto: hisilicon/qm - fix incorrect judgment in qm_get_complete_eqe_num() (2025-12-19 14:47:46 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v7.0-p1

for you to fetch changes up to 0ce90934c0a6baac053029ad28566536ae50d604:

  crypto: img-hash - Use unregister_ahashes in img_{un}register_algs (2026-02-07 09:32:10 +0800)

----------------------------------------------------------------
This update includes the following changes:

API:

- Fix race condition in hwrng core by using RCU.

Algorithms:

- Allow authenc(sha224,rfc3686) in fips mode.
- Add test vectors for authenc(hmac(sha384),cbc(aes)).
- Add test vectors for authenc(hmac(sha224),cbc(aes)).
- Add test vectors for authenc(hmac(md5),cbc(des3_ede)).
- Add lz4 support in hisi_zip.
- Only allow clear key use during self-test in s390/{phmac,paes}.

Drivers:

- Set rng quality to 900 in airoha.
- Add gcm(aes) support for AMD/Xilinx Versal device.
- Allow tfms to share device in hisilicon/trng.
----------------------------------------------------------------

Aleksander Jan Bajkowski (7):
      crypto: inside-secure/eip93 - fix kernel panic in driver detach
      crypto: testmgr - allow authenc(sha224,rfc3686) variant in fips mode
      hwrng: airoha - set rng quality to 900
      crypto: inside-secure/eip93 - unregister only available algorithm
      crypto: testmgr - Add test vectors for authenc(hmac(sha384),cbc(aes))
      crypto: testmgr - Add test vectors for authenc(hmac(sha224),cbc(aes))
      crypto: testmgr - Add test vectors for authenc(hmac(md5),cbc(des3_ede))

Alexander Bendezu (1):
      crypto: blowfish - fix typo in comment

Bibo Mao (3):
      crypto: virtio - Add spinlock protection with virtqueue notification
      crypto: virtio - Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req
      crypto: virtio - Replace package id with numa node id

Can Peng (1):
      crypto: fips - annotate fips_enable() with __init to free init memory after boot

Chenghai Huang (11):
      crypto: hisilicon/zip - adjust the way to obtain the req in the callback function
      crypto: hisilicon/sec - move backlog management to qp and store sqe in qp for callback
      crypto: hisilicon/qm - enhance the configuration of req_type in queue attributes
      crypto: hisilicon/qm - centralize the sending locks of each module into qm
      crypto: hisilicon - consolidate qp creation and start in hisi_qm_alloc_qps_node
      crypto: hisilicon/qm - add reference counting to queues for tfm kernel reuse
      crypto: hisilicon/qm - optimize device selection priority based on queue ref count and NUMA distance
      crypto: hisilicon/zip - support fallback for zip
      crypto: hisilicon/sgl - fix inconsistent map/unmap direction issue
      crypto: hisilicon/zip - add lz4 algorithm for hisi_zip
      crypto: hisilicon/qm - move the barrier before writing to the mailbox register

Ella Ma (1):
      crypto: ccp - Fix a crash due to incorrect cleanup usage of kfree

Giovanni Cabiddu (3):
      crypto: qat - fix parameter order used in ICP_QAT_FW_COMN_FLAGS_BUILD
      crypto: qat - add bank state save and restore for qat_420xx
      crypto: qat - fix warning on adf_pfvf_pf_proto.c

Gustavo A. R. Silva (2):
      crypto: starfive - Avoid -Wflex-array-member-not-at-end warning
      crypto: sun8i-ss - Avoid -Wflex-array-member-not-at-end warning

Harald Freudenberger (4):
      crypto: skcipher - Add new helper function crypto_skcipher_tested
      s390/pkey: Support new xflag PKEY_XFLAG_NOCLEARKEY
      crypto: s390/phmac - Refuse clear key material by default
      crypto: s390/paes - Refuse clear key material by default

Harsh Jain (15):
      firmware: zynqmp: Move crypto API's to separate file
      crypto: xilinx - Remove union from zynqmp_aead_drv_ctx
      firmware: zynqmp: Add helper API to self discovery the device
      dt-bindings: crypto: Mark zynqmp-aes as Deprecated
      crypto: xilinx - Update probe to self discover the device
      crypto: xilinx - Return linux error code instead of firmware error code
      crypto: xilinx - Avoid Encrypt request to fallback for authsize < 16
      crypto: xilinx - Avoid submitting fallback requests to engine
      crypto: xilinx - Register H/W key support with paes
      crypto: xilinx - Replace zynqmp prefix with xilinx
      crypto: xilinx - Change coherent DMA to streaming DMA API
      firmware: xilinx: Add firmware API's to support aes-gcm in Versal device
      crypto: xilinx - Remove un-necessary typecast operation
      crypto: xilinx - Add gcm(aes) support for AMD/Xilinx Versal device
      crypto: xilinx - Fix inconsistant indentation

Harshal Dev (1):
      dt-bindings: crypto: qcom,prng: document x1e80100

Herbert Xu (1):
      crypto: ccp - Use NULL instead of plain 0

Jianpeng Chang (1):
      crypto: caam - fix netdev memory leak in dpaa2_caam_probe

Krzysztof Kozlowski (1):
      crypto: nx - Simplify with scoped for each OF child loop

Lianjie Wang (1):
      hwrng: core - use RCU and work_struct to fix race condition

Luca Weiss (1):
      dt-bindings: crypto: qcom,inline-crypto-engine: document the Milos ICE

Mario Limonciello (1):
      crypto: ccp - Add sysfs attribute for boot integrity

Qi Tao (1):
      crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware queue unavailable

Robert Marko (2):
      dt-bindings: crypto: atmel,at91sam9g46-aes: add microchip,lan9691-aes
      dt-bindings: crypto: atmel,at91sam9g46-sha: add microchip,lan9691-sha

Rouven Czerwinski (1):
      hwrng: optee - simplify OP-TEE context match

Sergey Shtylyov (3):
      crypto: drbg - kill useless variable in drbg_fips_continuous_test()
      crypto: drbg - make drbg_fips_continuous_test() return bool
      crypto: drbg - make drbg_get_random_bytes() return *void*

Thomas Fourier (2):
      crypto: cavium - fix dma_free_coherent() size
      crypto: octeontx - fix dma_free_coherent() size

Thomas Weißschuh (1):
      padata: Constify padata_sysfs_entry structs

Thorsten Blum (26):
      crypto: octeontx - Fix length check to avoid truncation in ucode_load_store
      crypto: iaa - Fix out-of-bounds index in find_empty_iaa_compression_mode
      crypto: iaa - Simplify init_iaa_device()
      crypto: iaa - Remove unreachable pr_debug from iaa_crypto_cleanup_module
      crypto: scompress - Remove forward declaration of crypto_scomp_show
      crypto: scompress - Use crypto_unregister_scomps in crypto_register_scomps
      crypto: algapi - Use crypto_unregister_algs in crypto_register_algs
      crypto: iaa - Replace sprintf with sysfs_emit in sysfs show functions
      crypto: octeontx2 - Use sysfs_emit in sysfs show functions
      crypto: khazad - simplify return statement in khazad_mod_init
      crypto: acomp - Use unregister_acomps in register_acomps
      crypto: ahash - Use unregister_ahashes in register_ahashes
      crypto: shash - Use unregister_shashes in register_shashes
      crypto: skcipher - Use unregister_skciphers in register_skciphers
      crypto: lskcipher - Use unregister_lskciphers in register_lskciphers
      crypto: engine - Use unregister_* in register_{aeads,ahashes,skciphers}
      crypto: simd - Simplify request size calculation in simd_aead_init
      crypto: api - remove unnecessary forward declarations
      crypto: ecc - Streamline alloc_point and remove {alloc,free}_digits_space
      crypto: omap - Use sysfs_emit in sysfs show functions
      crypto: stm32 - Remove unnecessary checks before calling memcpy
      crypto: stm32 - Replace min_t(size_t) with just min()
      crypto: atmel - Use unregister_{aeads,ahashes,skciphers}
      crypto: rng - Use unregister_rngs in register_rngs
      crypto: cesa - Simplify return statement in mv_cesa_dequeue_req_locked
      crypto: img-hash - Use unregister_ahashes in img_{un}register_algs

Tom Lendacky (1):
      crypto: ccp - Fix a case where SNP_SHUTDOWN is missed

Tycho Andersen (AMD) (1):
      crypto: ccp - narrow scope of snp_range_list

Weili Qian (5):
      crypto: hisilicon/hpre - support the hpre algorithm fallback
      crypto: hisilicon/trng - support tfms sharing the device
      crypto: hisilicon/qm - remove unnecessary code in qm_mb_write()
      crypto: hisilicon/qm - obtain the mailbox configuration at one time
      crypto: hisilicon/qm - increase wait time for mailbox

Zilin Guan (1):
      crypto: starfive - Fix memory leak in starfive_aes_aead_do_one_req()

lizhi (1):
      crypto: hisilicon/hpre: extend tag field to 64 bits for better performance

 Documentation/ABI/testing/sysfs-driver-ccp         |   15 +
 .../bindings/crypto/atmel,at91sam9g46-aes.yaml     |    1 +
 .../bindings/crypto/atmel,at91sam9g46-sha.yaml     |    1 +
 .../bindings/crypto/qcom,inline-crypto-engine.yaml |    1 +
 .../devicetree/bindings/crypto/qcom,prng.yaml      |    1 +
 .../bindings/crypto/xlnx,zynqmp-aes.yaml           |    2 +
 .../firmware/xilinx/xlnx,zynqmp-firmware.yaml      |    1 +
 arch/s390/crypto/paes_s390.c                       |   93 +-
 arch/s390/crypto/phmac_s390.c                      |   29 +-
 arch/s390/include/asm/pkey.h                       |    8 +-
 crypto/acompress.c                                 |   18 +-
 crypto/aead.c                                      |    5 +-
 crypto/ahash.c                                     |   17 +-
 crypto/akcipher.c                                  |    6 +-
 crypto/algapi.c                                    |   14 +-
 crypto/blowfish_common.c                           |    2 +-
 crypto/crypto_engine.c                             |   33 +-
 crypto/drbg.c                                      |   49 +-
 crypto/ecc.c                                       |   29 +-
 crypto/fips.c                                      |    2 +-
 crypto/khazad.c                                    |    5 +-
 crypto/kpp.c                                       |    6 +-
 crypto/lskcipher.c                                 |   12 +-
 crypto/rng.c                                       |   17 +-
 crypto/scompress.c                                 |   18 +-
 crypto/shash.c                                     |   17 +-
 crypto/simd.c                                      |    4 +-
 crypto/skcipher.c                                  |   17 +-
 crypto/testmgr.c                                   |   25 +
 crypto/testmgr.h                                   |  655 +++++++++++++
 drivers/char/hw_random/airoha-trng.c               |    1 +
 drivers/char/hw_random/core.c                      |  168 ++--
 drivers/char/hw_random/optee-rng.c                 |    5 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |    4 +-
 drivers/crypto/atmel-aes.c                         |   17 +-
 drivers/crypto/atmel-sha.c                         |   27 +-
 drivers/crypto/atmel-tdes.c                        |   25 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   27 +-
 drivers/crypto/caam/caamalg_qi2.h                  |    2 +
 drivers/crypto/cavium/cpt/cptvf_main.c             |    3 +-
 drivers/crypto/ccp/ccp-ops.c                       |    2 +-
 drivers/crypto/ccp/hsti.c                          |    3 +
 drivers/crypto/ccp/psp-dev.h                       |    2 +-
 drivers/crypto/ccp/sev-dev-tsm.c                   |    2 +-
 drivers/crypto/ccp/sev-dev.c                       |   59 +-
 drivers/crypto/hisilicon/Kconfig                   |    2 +
 drivers/crypto/hisilicon/hpre/hpre.h               |    5 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |  418 ++++----
 drivers/crypto/hisilicon/hpre/hpre_main.c          |    2 +-
 drivers/crypto/hisilicon/qm.c                      |  387 +++++---
 drivers/crypto/hisilicon/sec2/sec.h                |    7 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  163 ++--
 drivers/crypto/hisilicon/sec2/sec_main.c           |   21 +-
 drivers/crypto/hisilicon/sgl.c                     |    2 +-
 drivers/crypto/hisilicon/trng/trng.c               |  123 ++-
 drivers/crypto/hisilicon/zip/zip.h                 |    2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c          |  202 ++--
 drivers/crypto/hisilicon/zip/zip_main.c            |    4 +-
 drivers/crypto/img-hash.c                          |   21 +-
 drivers/crypto/inside-secure/eip93/eip93-main.c    |   94 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |   36 +-
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |    3 +
 .../intel/qat/qat_common/adf_pfvf_pf_proto.c       |   10 +
 .../crypto/intel/qat/qat_common/qat_asym_algs.c    |   12 +-
 drivers/crypto/marvell/cesa/cesa.c                 |    8 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  |    2 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c   |    3 +-
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |    5 +-
 drivers/crypto/nx/nx-common-powernv.c              |    7 +-
 drivers/crypto/omap-aes.c                          |    3 +-
 drivers/crypto/omap-sham.c                         |    5 +-
 drivers/crypto/starfive/jh7110-aes.c               |    9 +-
 drivers/crypto/starfive/jh7110-cryp.h              |    4 +-
 drivers/crypto/stm32/stm32-cryp.c                  |   29 +-
 drivers/crypto/stm32/stm32-hash.c                  |    6 +-
 drivers/crypto/virtio/virtio_crypto_common.h       |    2 +-
 drivers/crypto/virtio/virtio_crypto_core.c         |    5 +
 .../crypto/virtio/virtio_crypto_skcipher_algs.c    |    2 -
 drivers/crypto/xilinx/zynqmp-aes-gcm.c             | 1019 +++++++++++++++-----
 drivers/firmware/xilinx/Makefile                   |    2 +-
 drivers/firmware/xilinx/zynqmp-crypto.c            |  238 +++++
 drivers/firmware/xilinx/zynqmp.c                   |   49 -
 drivers/s390/crypto/pkey_cca.c                     |    5 +
 drivers/s390/crypto/pkey_ep11.c                    |    5 +
 drivers/s390/crypto/pkey_pckmo.c                   |   12 +-
 include/crypto/internal/skcipher.h                 |    7 +
 include/linux/firmware/xlnx-zynqmp-crypto.h        |  119 +++
 include/linux/firmware/xlnx-zynqmp.h               |   14 +-
 include/linux/hisi_acc_qm.h                        |   15 +-
 include/linux/hw_random.h                          |    2 +
 kernel/padata.c                                    |   22 +-
 91 files changed, 3250 insertions(+), 1313 deletions(-)
 create mode 100644 drivers/firmware/xilinx/zynqmp-crypto.c
 create mode 100644 include/linux/firmware/xlnx-zynqmp-crypto.h

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
