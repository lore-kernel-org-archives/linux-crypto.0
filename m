From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.7
Date: Mon, 16 May 2016 15:16:08 +0800
Message-ID: <20160516071608.GA1594@gondor.apana.org.au>
References: <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160315072040.GA18381@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54034 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbcEPHQ1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 May 2016 03:16:27 -0400
Content-Disposition: inline
In-Reply-To: <20160315072040.GA18381@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 4.7:

API:

* Crypto self tests can now be disabled at boot/run time.
* Add async support to algif_aead.

Algorithms:

* A large number of fixes to MPI from Nicolai Stange.
* Performance improvement for HMAC DRBG.

Drivers:

* Use generic crypto engine in omap-des.
* Merge ppc4xx-rng and crypto4xx drivers.
* Fix lockups in sun4i-ss driver by disabling IRQs.
* Add DMA engine support to ccp.
* Reenable talitos hash algorithms.
* Add support for Hisilicon SoC RNG.
* Add basic crypto driver for the MXC SCC.

Others:

* Do not allocate crypto hash tfm in NORECLAIM context in ecryptfs.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

Ahsan Atta (1):
      crypto: qat - Remove redundant nrbg rings

Amitoj Kaur Chawla (1):
      crypto: n2 - Remove return statement from void function

Baolin Wang (1):
      crypto: omap-des - Integrate with the crypto engine framework

Catalin Vasile (1):
      crypto: caam - fix caam_jr_alloc() ret code

Christian Lamparter (1):
      crypto4xx: integrate ppc4xx-rng into crypto4xx

Colin Ian King (1):
      PKCS#7: fix missing break on OID_sha224 case

Corentin LABBE (1):
      crypto: sun4i-ss - Replace spinlock_bh by spin_lock_irq{save|restore}

Dan Carpenter (3):
      crypto: marvell/cesa - remove unneeded condition
      crypto: mxc-scc - signedness bugs in mxc_scc_ablkcipher_req_init()
      crypto: mxc-scc - fix unwinding in mxc_scc_crypto_register()

Eric Biggers (1):
      crypto: doc - document correct return value for request allocation

Gary R Hook (2):
      crypto: ccp - Register the CCP as a DMA resource
      crypto: ccp - Ensure all dependencies are specified

Herbert Xu (3):
      eCryptfs: Do not allocate hash tfm in NORECLAIM context
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

Horia Geant? (1):
      crypto: talitos - fix ahash algorithms registration

Julia Lawall (2):
      crypto: marvell/cesa - Use dma_pool_zalloc
      crypto: ccp - constify ccp_actions structure

Kefeng Wang (2):
      dt/bindings: Add bindings for hisilicon random number generator
      hwrng: hisi - Add support for Hisilicon SoC RNG

Krzysztof Kozlowski (14):
      hwrng: exynos - Runtime suspend device after init
      hwrng: exynos - Fix unbalanced PM runtime put on timeout error path
      hwrng: exynos - Disable runtime PM on probe failure
      hwrng: exynos - Disable runtime PM on driver unbind
      hwrng: exynos - Enable COMPILE_TEST
      crypto: s5p-sss - Enable COMPILE_TEST
      crypto: s5p-sss - Minor coding cleanups
      crypto: s5p-sss - Handle unaligned buffers
      crypto: s5p-sss - Sort the headers to improve readability
      hwrng: exynos - Fix misspelled Samsung address
      crypto: s5p-sss - Fix use after free of copied input buffer in error path
      crypto: s5p-sss - Remove useless hash interrupt handler
      crypto: s5p-sss - Use common BIT macro
      crypto: s5p-sss - Fix missed interrupts when working with 8 kB blocks

Marek Szyprowski (1):
      crypto: s5p-sss - fix incorrect usage of scatterlists api

Michal Hocko (1):
      crypto: lzo - get rid of superfluous __GFP_REPEAT

Mike Galbraith (1):
      crypto: ccp - Fix RT breaking #include <linux/rwlock_types.h>

Nicolai Stange (14):
      lib/mpi: mpi_write_sgl(): fix skipping of leading zero limbs
      lib/mpi: mpi_write_sgl(): fix style issue with lzero decrement
      lib/mpi: mpi_write_sgl(): purge redundant pointer arithmetic
      lib/mpi: mpi_write_sgl(): fix out-of-bounds stack access
      lib/mpi: mpi_write_sgl(): replace open coded endian conversion
      lib/mpi: mpi_read_buffer(): optimize skipping of leading zero limbs
      lib/mpi: mpi_read_buffer(): replace open coded endian conversion
      lib/mpi: mpi_read_buffer(): fix buffer overflow
      lib/mpi: mpi_read_raw_from_sgl(): replace len argument by nbytes
      lib/mpi: mpi_read_raw_from_sgl(): don't include leading zero SGEs in nbytes
      lib/mpi: mpi_read_raw_from_sgl(): purge redundant clearing of nbits
      lib/mpi: mpi_read_raw_from_sgl(): fix nbits calculation
      lib/mpi: mpi_read_raw_from_sgl(): sanitize meaning of indices
      lib/mpi: mpi_read_raw_from_sgl(): fix out-of-bounds buffer access

Paulo Flabiano Smorigo (1):
      crypto: vmx - comply with ABIs that specify vrsave as reserved.

Peter Meerwald (1):
      crypto: omap-des - Improve wording for CRYPTO_DEV_OMAP_DES in Kconfig

Peter Ujfalusi (3):
      crypto: omap-aes - Use dma_request_chan() for requesting DMA channel
      crypto: omap-des - Use dma_request_chan() for requesting DMA channel
      crypto: omap-sham - Use dma_request_chan() for requesting DMA channel

Richard W.M. Jones (1):
      crypto: testmgr - Add a flag allowing the self-tests to be disabled at runtime.

Romain Perier (1):
      crypto: marvell/cesa - Improving code readability

Steffen Trumtrar (3):
      Documentation: devicetree: add Freescale SCC bindings
      ARM: i.MX25: add scc module to dtsi
      crypto: mxc-scc - add basic driver for the MXC SCC

Stephan Mueller (1):
      crypto: drbg - set HMAC key only when altered

Tadeusz Struk (12):
      crypto: af_alg - add async support to algif_aead
      crypto: qat - make sure const_tab is 1024 bytes aligned
      crypto: qat - explicitly stop all VFs first
      crypto: qat - changed adf_dev_stop to void
      crypto: qat - adf_dev_stop should not be called in atomic context
      crypto: qat - move vf2pf_init and vf2pf_exit to common
      crypto: qat - check if PF is running
      crypto: qat - interrupts need to be enabled when VFs are disabled
      crypto: qat - fix section mismatch warning
      crypto: qat - Fix typo in comments
      crypto: qat - make adf_vf_isr.c dependant on IOV config
      crypto: qat - change the adf_ctl_stop_devices to void

Tom Lendacky (1):
      MAINTAINERS: Add a new maintainer for the CCP driver

Tudor Ambarus (3):
      crypto: qat - avoid memory corruption or undefined behaviour
      crypto: qat - fix address leaking of RSA public exponent
      lib: asn1_decoder - add MODULE_LICENSE("GPL")

 Documentation/DocBook/crypto-API.tmpl              |    6 +-
 .../devicetree/bindings/crypto/fsl-imx-scc.txt     |   21 +
 .../devicetree/bindings/crypto/samsung-sss.txt     |    6 +-
 Documentation/devicetree/bindings/rng/hisi-rng.txt |   12 +
 Documentation/kernel-parameters.txt                |    3 +
 MAINTAINERS                                        |    1 +
 arch/arm/boot/dts/imx25.dtsi                       |    9 +
 crypto/algif_aead.c                                |  268 ++++++-
 crypto/asymmetric_keys/pkcs7_parser.c              |    1 +
 crypto/drbg.c                                      |   39 +-
 crypto/lzo.c                                       |    2 +-
 crypto/testmgr.c                                   |    9 +
 drivers/char/hw_random/Kconfig                     |   29 +-
 drivers/char/hw_random/Makefile                    |    2 +-
 drivers/char/hw_random/exynos-rng.c                |   33 +-
 drivers/char/hw_random/hisi-rng.c                  |  126 ++++
 drivers/char/hw_random/ppc4xx-rng.c                |  147 ----
 drivers/crypto/Kconfig                             |   27 +-
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/amcc/Makefile                       |    1 +
 drivers/crypto/amcc/crypto4xx_core.c               |    7 +-
 drivers/crypto/amcc/crypto4xx_core.h               |    4 +
 drivers/crypto/amcc/crypto4xx_reg_def.h            |    1 +
 drivers/crypto/amcc/crypto4xx_trng.c               |  131 ++++
 drivers/crypto/amcc/crypto4xx_trng.h               |   34 +
 drivers/crypto/caam/jr.c                           |    2 +-
 drivers/crypto/ccp/Kconfig                         |    2 +
 drivers/crypto/ccp/Makefile                        |    6 +-
 drivers/crypto/ccp/ccp-dev-v3.c                    |   13 +-
 drivers/crypto/ccp/ccp-dev.c                       |    2 +-
 drivers/crypto/ccp/ccp-dev.h                       |   49 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |  727 +++++++++++++++++++
 drivers/crypto/ccp/ccp-ops.c                       |   69 +-
 drivers/crypto/marvell/cesa.c                      |   10 +-
 drivers/crypto/marvell/hash.c                      |    3 +-
 drivers/crypto/marvell/tdma.c                      |    5 +-
 drivers/crypto/mxc-scc.c                           |  765 ++++++++++++++++++++
 drivers/crypto/n2_core.c                           |    2 +-
 drivers/crypto/omap-aes.c                          |   62 +-
 drivers/crypto/omap-des.c                          |  165 ++---
 drivers/crypto/omap-sham.c                         |   25 +-
 drivers/crypto/qat/qat_c3xxx/adf_drv.c             |    4 +-
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c   |   23 -
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c           |    6 +-
 drivers/crypto/qat/qat_c62x/adf_drv.c              |    4 +-
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c |   23 -
 drivers/crypto/qat/qat_c62xvf/adf_drv.c            |    6 +-
 drivers/crypto/qat/qat_common/Makefile             |    4 +-
 drivers/crypto/qat/qat_common/adf_admin.c          |    2 +-
 drivers/crypto/qat/qat_common/adf_cfg_strings.h    |    2 -
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   28 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |   40 +-
 drivers/crypto/qat/qat_common/adf_init.c           |   15 +-
 drivers/crypto/qat/qat_common/adf_isr.c            |    4 +-
 drivers/crypto/qat/qat_common/adf_sriov.c          |    8 +-
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c      |   92 +++
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |   61 +-
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |    4 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |    4 +-
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |   23 -
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |    6 +-
 drivers/crypto/s5p-sss.c                           |  368 ++++++----
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c          |   10 +-
 drivers/crypto/talitos.c                           |   64 ++
 drivers/crypto/vmx/ppc-xlate.pl                    |   20 +
 fs/ecryptfs/crypto.c                               |   32 +-
 fs/ecryptfs/ecryptfs_kernel.h                      |    3 +-
 fs/ecryptfs/inode.c                                |    7 +-
 fs/ecryptfs/super.c                                |    5 +-
 include/crypto/aead.h                              |    3 +-
 include/crypto/hash.h                              |    3 +-
 include/crypto/skcipher.h                          |    3 +-
 include/linux/ccp.h                                |   36 +-
 include/linux/crypto.h                             |    3 +-
 lib/asn1_decoder.c                                 |    3 +
 lib/mpi/mpicoder.c                                 |  122 ++--
 76 files changed, 3091 insertions(+), 777 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
