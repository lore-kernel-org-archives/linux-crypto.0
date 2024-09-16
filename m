Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FB722EE8;
	Mon, 16 Sep 2024 03:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726459161; cv=none; b=sUR7E+tbuV+XPC0DCYaYp15i/38dTMhJl4iMULv0zSgy88o6sii0NeLALfIMLU6Pmy/zYU26miLqPLnBXlw+cBODNovGscGzWaqlrPX71R8p2YFSn3U9h4VtCKZCG/zhvzb6Vo4kvcFqVpPKVtHjENSLU16S+cAsphYsAmdyc8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726459161; c=relaxed/simple;
	bh=2OyaGvVU3Pub34u28eG2KHx9j6G7C2BdEiE5jq9ze1I=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LgpYo43YF6lbZ/g0Z0CaVBnxXrNgBH5055MoPzbMo+B4TPF7Q3JrTLnfC0jEB5G67Gh0fzu2485ea/FfmxyMlP0hxvvcgn4uS0o5nTp15DKLpO1jhsR1qk5NMLCMEaN5Tou6CEX+ST0ReFngsY/qh+eVfmAM00cfaCffct9tkLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=n8qm+GFP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="n8qm+GFP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5PWBYmBvr9CNhw4VnZdhTH50a+Py2UJvnkmkJnFOlLA=; b=n8qm+GFPFLfb1BCfn5+/JwiKhn
	wtw7k12A01AXvEEVxkrgUjwGgirLg5FdP1UMsjlSVVFYZ2Rw6q6Uwvt6Tg0YDw9NeozzuVMi/ctkY
	g1bH4I+nQBcRDf6X5CxeVyd9uAMz2P4j6YrDxK788rxhK+KuVA9bash6jh30qJsTEIErUHvVcX6Ke
	VXc8SI2ZnfLbEeDgKUNgKOJSkwijzIbay/MieufsWN+6Pj1KEMqv7F1UkzHIS+yLwHdAfXT8E5qH8
	whqziPLhSdVT5CvvX87MZSsos3klSYJi/B+yr3qPmqEIxr/Ax55BF54fOTaYa1vD2vuDszo/vmLt9
	eXktCZZQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sq2jH-002j7P-2v;
	Mon, 16 Sep 2024 11:59:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Sep 2024 11:59:01 +0800
Date: Mon, 16 Sep 2024 11:59:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 6.12
Message-ID: <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
References: <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZpkdZopjF9/9/Njx@gondor.apana.org.au>

On Fri, Jul 19, 2024 at 01:49:26AM +1200, Herbert Xu wrote:

The following changes since commit 8400291e289ee6b2bf9779ff1c83a291501f017b:

  Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p1 

for you to fetch changes up to ce212d2afca47acd366a2e74c76fe82c31f785ab:

  crypto: n2 - Set err to EINVAL if snprintf fails for hmac (2024-09-13 18:26:53 +0800)

----------------------------------------------------------------
This update includes the following changes:

API:

- Make self-test asynchronous.

Algorithms:

- Remove MPI functions added for SM3.
- Add allocation error checks to remaining MPI functions (introduced for SM3).
- Set default Jitter RNG OSR to 3.

Drivers:

- Add hwrng driver for Rockchip RK3568 SoC.
- Allow disabling SR-IOV VFs through sysfs in qat.
- Fix device reset bugs in hisilicon.
- Fix authenc key parsing by using generic helper in octeontx*.

Others:

- Fix xor benchmarking on parisc.
----------------------------------------------------------------

Adam Guerin (1):
      crypto: qat - preserve ADF_GENERAL_SEC

Amit Shah (1):
      crypto: ccp - do not request interrupt on cmd completion when irqs disabled

Aurelien Jarno (2):
      dt-bindings: rng: Add Rockchip RK3568 TRNG
      hwrng: rockchip - add hwrng driver for Rockchip RK3568 SoC

Brian Masney (2):
      crypto: qcom-rng - fix support for ACPI-based systems
      crypto: qcom-rng - rename *_of_data to *_match_data

Chen Yufan (1):
      crypto: camm/qi - Use ERR_CAST() to return error-valued pointer

Chenghai Huang (2):
      crypto: hisilicon - add a lock for the qp send operation
      crypto: hisilicon/trng - modifying the order of header files

Chunhai Guo (2):
      crypto: atmel - use devm_clk_get_prepared() helpers
      crypto: img-hash - use devm_clk_get_enabled() helpers

Colin Ian King (2):
      crypto: hisilicon/sec - Remove trailing space after \n newline
      crypto: qat - Remove trailing space after \n newline

Dan Carpenter (7):
      crypto: iaa - Fix potential use after free bug
      crypto: spacc - Fix bounds checking on spacc->job[]
      crypto: spacc - Fix off by one in spacc_isenabled()
      crypto: spacc - Add a new line in spacc_open()
      crypto: spacc - Fix uninitialized variable in spacc_aead_process()
      crypto: spacc - Fix NULL vs IS_ERR() check in spacc_aead_fallback()
      crypto: spacc - Check for allocation failure in spacc_skcipher_fallback()

Eric Biggers (3):
      crypto: x86/aes-gcm - fix PREEMPT_RT issue in gcm_crypt()
      crypto: arm/aes-neonbs - go back to using aes-arm directly
      crypto: x86/aesni - update docs for aesni-intel module

Fangrui Song (1):
      crypto: x86/sha256 - Add parentheses around macros' single arguments

Francesco Dolcini (1):
      hwrng: cn10k - Enable by default CN10K driver if Thunder SoC is enabled

Frank Li (1):
      dt-bindings: crypto: fsl,sec-v4.0: add second register space for rtic

Gaosheng Cui (2):
      hwrng: bcm2835 - Add missing clk_disable_unprepare in bcm2835_rng_init
      hwrng: cctrng - Add missing clk_disable_unprepare in cctrng_resume

Guoqing Jiang (1):
      hwrng: mtk - Use devm_pm_runtime_enable

Gustavo A. R. Silva (2):
      crypto: qat - Use static_assert() to check struct sizes
      crypto: nx - Use static_assert() to check struct sizes

Helge Deller (1):
      crypto: xor - fix template benchmarking

Herbert Xu (19):
      Revert "crypto: arm64/poly1305 - move data to rodata section"
      crypto: caam/qi* - Use cpumask_var_t instead of cpumask_t
      Revert "lib/mpi: Introduce ec implementation to MPI library"
      Revert "lib/mpi: Extend the MPI library"
      crypto: lib/mpi - Add error checks to extension
      crypto: dh - Check mpi_rshift errors
      crypto: rsa - Check MPI allocation errors
      crypto: spacc - Use crypto_authenc_extractkeys
      crypto: octeontx - Fix authenc setkey
      crypto: octeontx2 - Fix authenc setkey
      crypto: api - Remove instance larval fulfilment
      crypto: api - Do not wait for tests during registration
      crypto: simd - Do not call crypto_alloc_tfm during registration
      Revert "crypto: spacc - Add SPAcc Skcipher support"
      crypto: api - Fix generic algorithm self-test races
      crypto: algboss - Pass instance creation error up
      crypto: testmgr - Hide ENOENT errors
      crypto: octeontx* - Select CRYPTO_AUTHENC
      crypto: n2 - Set err to EINVAL if snprintf fails for hmac

Huan Yang (1):
      hwrng: mxc-rnga - Use devm_clk_get_enabled() helpers

Jeff Johnson (1):
      crypto: ppc/curve25519 - add missing MODULE_DESCRIPTION() macro

Jia He (2):
      crypto: arm64/poly1305 - move data to rodata section
      crypto: arm64/poly1305 - move data to rodata section

Kamlesh Gurudasani (1):
      padata: Honor the caller's alignment in case of chunk_size 0

Kuan-Wei Chiu (3):
      crypto: octeontx - Remove custom swap function in favor of built-in sort swap
      crypto: octeontx2 - Remove custom swap functions in favor of built-in sort swap
      crypto: hisilicon/zip - Optimize performance by replacing rw_lock with spinlock

Liao Chen (1):
      crypto: keembay - fix module autoloading

Martin Kaiser (2):
      hwrng: rockchip - rst is used only during probe
      hwrng: rockchip - handle devm_pm_runtime_enable errors

Michal Witwicki (4):
      crypto: qat - disable IOV in adf_dev_stop()
      crypto: qat - fix recovery flow for VFs
      crypto: qat - ensure correct order in VF restarting handler
      crypto: qat - allow disabling SR-IOV VFs

Nikunj Kela (1):
      dt-bindings: crypto: qcom,prng: document support for SA8255p

Pavan Kumar Paluri (1):
      crypto: ccp - Properly unregister /dev/sev on sev PLATFORM_STATUS failure

Pavitrakumar M (8):
      crypto: spacc - Add SPAcc Skcipher support
      crypto: spacc - Enable SPAcc AUTODETECT
      crypto: spacc - Add SPAcc ahash support
      crypto: spacc - Add SPAcc aead support
      crypto: spacc - Add SPAcc Kconfig and Makefile
      crypto: spacc - Enable Driver compilation in crypto Kconfig and Makefile
      crypto: spacc - Fix counter width checks
      crypto: spacc - Fixed return to CRYPTO_OK

Riyan Dhiman (1):
      crypto: aegis128 - Fix indentation issue in crypto_aegis128_process_crypt()

Stephan Mueller (1):
      crypto: jitter - set default OSR to 3

Stephen Rothwell (1):
      crypto: spacc - Add ifndef around MIN

Svyatoslav Pankratov (1):
      crypto: qat - fix "Full Going True" macro definition

Thorsten Blum (2):
      crypto: chacha20poly1305 - Annotate struct chachapoly_ctx with __counted_by()
      crypto: jitter - Use min() to simplify jent_read_entropy()

Tom Lendacky (1):
      crypto: ccp - Add additional information about an SEV firmware upgrade

VanGiang Nguyen (1):
      padata: use integer wrap around to prevent deadlock on seq_nr overflow

WangYuli (1):
      crypto: mips/crc32 - Clean up useless assignment operations

Weili Qian (3):
      crypto: hisilicon/qm - reset device before enabling it
      crypto: hisilicon/hpre - mask cluster timeout error
      crypto: hisilicon/qm - inject error before stopping queue

Yang Shen (1):
      crypto: hisilicon - fix missed error branch

Yue Haibing (6):
      crypto: safexcel - Remove unused declaration safexcel_ring_first_rptr()
      crypto: sl3516 - Remove unused declaration sl3516_ce_enqueue()
      crypto: octeontx - Remove unused declaration otx_cpt_callback()
      crypto: ccp - Remove unused declaration sp_get_master()
      crypto: amlogic - Remove unused declaration meson_enqueue()
      crypto: crypto4xx - Remove unused declaration crypto4xx_free_ctx()

Zhu Jun (1):
      crypto: tools/ccp - Remove unused variable

 .../devicetree/bindings/crypto/fsl,sec-v4.0.yaml   |    5 +-
 .../devicetree/bindings/crypto/qcom,prng.yaml      |    1 +
 .../bindings/rng/rockchip,rk3568-rng.yaml          |   61 +
 MAINTAINERS                                        |    7 +
 arch/arm/crypto/Kconfig                            |   14 +-
 arch/arm/crypto/aes-ce-glue.c                      |    2 +-
 arch/arm/crypto/aes-cipher-glue.c                  |    5 +-
 arch/arm/crypto/aes-cipher.h                       |   13 +
 arch/arm/crypto/aes-neonbs-glue.c                  |  131 +-
 arch/arm64/crypto/poly1305-armv8.pl                |    6 +-
 arch/mips/crypto/crc32-mips.c                      |   64 +-
 arch/powerpc/crypto/curve25519-ppc64le-core.c      |    1 +
 arch/x86/crypto/Kconfig                            |    8 +-
 arch/x86/crypto/aesni-intel_glue.c                 |   61 +-
 arch/x86/crypto/sha256-avx2-asm.S                  |   16 +-
 crypto/Kconfig                                     |    2 +-
 crypto/aegis128-core.c                             |    5 +-
 crypto/algapi.c                                    |   71 +-
 crypto/algboss.c                                   |    4 +-
 crypto/api.c                                       |   75 +-
 crypto/chacha20poly1305.c                          |    2 +-
 crypto/dh.c                                        |    4 +-
 crypto/internal.h                                  |    3 +-
 crypto/jitterentropy.c                             |    6 +-
 crypto/rsa.c                                       |   19 +-
 crypto/simd.c                                      |   76 +-
 crypto/testmgr.c                                   |   23 +-
 crypto/xor.c                                       |   31 +-
 drivers/char/hw_random/Kconfig                     |   15 +
 drivers/char/hw_random/Makefile                    |    1 +
 drivers/char/hw_random/bcm2835-rng.c               |    4 +-
 drivers/char/hw_random/cctrng.c                    |    1 +
 drivers/char/hw_random/mtk-rng.c                   |    2 +-
 drivers/char/hw_random/mxc-rnga.c                  |   16 +-
 drivers/char/hw_random/rockchip-rng.c              |  228 +++
 drivers/crypto/amcc/crypto4xx_core.h               |    1 -
 drivers/crypto/amlogic/amlogic-gxl.h               |    2 -
 drivers/crypto/atmel-aes.c                         |   16 +-
 drivers/crypto/atmel-sha.c                         |   14 +-
 drivers/crypto/caam/caamalg_qi.c                   |    4 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   17 +-
 drivers/crypto/caam/qi.c                           |   31 +-
 drivers/crypto/ccp/sev-dev.c                       |   28 +-
 drivers/crypto/ccp/sp-dev.h                        |    1 -
 drivers/crypto/gemini/sl3516-ce.h                  |    2 -
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |    2 +
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   54 +-
 drivers/crypto/hisilicon/qm.c                      |  151 +-
 drivers/crypto/hisilicon/sec/sec_drv.c             |    2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |   16 +-
 drivers/crypto/hisilicon/sgl.c                     |   14 +-
 drivers/crypto/hisilicon/trng/trng.c               |    4 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c          |   17 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |   23 +-
 drivers/crypto/img-hash.c                          |   21 +-
 drivers/crypto/inside-secure/safexcel.h            |    1 -
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |    4 +-
 .../crypto/intel/keembay/keembay-ocs-hcu-core.c    |    1 +
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c       |    4 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c        |    4 +-
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c       |    4 +-
 drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c     |    4 +-
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c        |    4 +-
 drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c      |    4 +-
 drivers/crypto/intel/qat/qat_common/adf_aer.c      |    2 +-
 drivers/crypto/intel/qat/qat_common/adf_cfg.c      |   29 +
 drivers/crypto/intel/qat/qat_common/adf_cfg.h      |    2 +
 .../crypto/intel/qat/qat_common/adf_common_drv.h   |    2 +-
 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c  |    6 +-
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.h |    2 +-
 drivers/crypto/intel/qat/qat_common/adf_init.c     |   44 +-
 .../crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c  |    9 +-
 .../crypto/intel/qat/qat_common/adf_pfvf_vf_msg.c  |   14 +
 .../crypto/intel/qat/qat_common/adf_pfvf_vf_msg.h  |    1 +
 drivers/crypto/intel/qat/qat_common/adf_sriov.c    |  194 ++-
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c    |    4 +-
 drivers/crypto/intel/qat/qat_common/adf_vf_isr.c   |    4 +-
 drivers/crypto/intel/qat/qat_common/qat_bl.h       |    2 +
 drivers/crypto/intel/qat/qat_common/qat_uclo.c     |    2 +-
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c    |    4 +-
 drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c  |    4 +-
 drivers/crypto/marvell/Kconfig                     |    2 +
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c   |  277 ++--
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.h   |    1 -
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c |  266 ++--
 drivers/crypto/n2_core.c                           |    1 +
 drivers/crypto/nx/nx-842.h                         |    3 +
 drivers/crypto/qcom-rng.c                          |   24 +-
 include/crypto/internal/simd.h                     |   12 +-
 include/linux/mpi.h                                |  192 +--
 kernel/padata.c                                    |    6 +-
 lib/crypto/mpi/Makefile                            |    2 -
 lib/crypto/mpi/ec.c                                | 1507 --------------------
 lib/crypto/mpi/mpi-add.c                           |   89 +-
 lib/crypto/mpi/mpi-bit.c                           |  168 +--
 lib/crypto/mpi/mpi-cmp.c                           |   46 +-
 lib/crypto/mpi/mpi-div.c                           |   82 +-
 lib/crypto/mpi/mpi-internal.h                      |   21 +-
 lib/crypto/mpi/mpi-inv.c                           |  143 --
 lib/crypto/mpi/mpi-mod.c                           |  148 +-
 lib/crypto/mpi/mpi-mul.c                           |   29 +-
 lib/crypto/mpi/mpicoder.c                          |  336 -----
 lib/crypto/mpi/mpih-mul.c                          |   25 -
 lib/crypto/mpi/mpiutil.c                           |  184 +--
 tools/crypto/ccp/dbc.c                             |    1 -
 105 files changed, 1423 insertions(+), 3900 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
 create mode 100644 arch/arm/crypto/aes-cipher.h
 create mode 100644 drivers/char/hw_random/rockchip-rng.c
 delete mode 100644 lib/crypto/mpi/ec.c
 delete mode 100644 lib/crypto/mpi/mpi-inv.c

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
