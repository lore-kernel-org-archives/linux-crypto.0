From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.3
Date: Mon, 31 Aug 2015 21:56:55 +0800
Message-ID: <20150831135655.GA2694@gondor.apana.org.au>
References: <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53756 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbbHaN5Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 31 Aug 2015 09:57:16 -0400
Content-Disposition: inline
In-Reply-To: <20150622084457.GA7806@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 4.3:

API:

* The AEAD interface transition is now complete.
* Add top-level skcipher interface.

Drivers:

* x86-64 acceleration for chacha20/poly1305.
* Add sunxi-ss Allwinner Security System crypto accelerator.
* Add RSA algorithm to qat driver.
* Add SRIOV support to qat driver.
* Add LS1021A support to caam.
* Add i.MX6 support to caam.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Aaron Sierra (2):
      crypto: talitos - Remove zero_entry static initializer
      crypto: talitos - Prevent panic in probe error path

Ahsan Atta (1):
      crypto: qat - Fix typo othewise->otherwise

Alex Porosanu (1):
      crypto: caam - fix ERA property reading

Baruch Siach (1):
      crypto: arm - ignore generated SHA2 assembly files

Brian Norris (1):
      crypto: doc - make URL into hyperlink

Bruce Allan (4):
      crypto: qat - remove redundant struct elem
      crypto: qat - fix bug in ADF_RING_SIZE_BYTES_MIN macro
      crypto: qat - remove unused define
      crypto: qat - remove unnecessary list iteration

Chen-Yu Tsai (3):
      crypto: sunxi-ss - Document optional reset control bindings
      crypto: sunxi-ss - Add optional reset control support
      ARM: dts: sun6i: Add security system crypto engine clock and device nodes

Colin Ian King (1):
      crypto: img-hash - fix spelling mistake in dev_err error message

Dan Streetman (11):
      crypto: nx - remove __init/__exit from VIO functions
      crypto: nx - remove pSeries NX 'status' field
      crypto: nx - move kzalloc() out of spinlock
      crypto: nx - don't register pSeries driver if ENODEV
      crypto: nx - use common code for both NX decompress success cases
      crypto: nx - merge nx-compress and nx-compress-crypto
      crypto: nx - rename nx-842-crypto.c to nx-842.c
      crypto: nx - make platform drivers directly register with crypto
      crypto: nx - don't err if compressed output > input
      crypto: nx - use be32_to_cpu for __be32 field in debug msg
      MAINTAINERS: change 842 NX owner email address

Fabio Estevam (6):
      crypto: caam - Fix error handling in caam_rng_init()
      crypto: caam - Remove unneeded 'ret' variable
      crypto: amcc - Do a NULL check for pointer
      crypto: caam - Fix the error handling in caam_probe
      crypto: caam - Propagate the real error code in caam_probe
      crypto: caam - Use the preferred style for memory allocations

Herbert Xu (56):
      crypto: cryptd - Fix AEAD request context corruption
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
      crypto: api - Remove unused __crypto_dequeue_request
      crypto: aead - Add aead_queue interface
      crypto: nx/842 - Fix context corruption
      crypto: api - Add instance free function to crypto_type
      crypto: aead - Add type-safe function for freeing instances
      crypto: pcrypt - Propagate new AEAD implementation flag
      crypto: cryptd - Propagate new AEAD implementation flag
      crypto: echainiv - Fix encryption convention
      crypto: seqiv - Replace seqniv with seqiv
      crypto: aead - Propagate new AEAD implementation flag for IV generators
      crypto: testmgr - Disable rfc4106 test and convert test vectors
      crypto: tcrypt - Add support for new IV convention
      crypto: aesni - Use new IV convention
      crypto: gcm - Use new IV convention
      crypto: nx - Use new IV convention
      crypto: caam - Use new IV convention
      crypto: testmgr - Reenable rfc4106 test
      crypto: testmgr - Disable rfc4309 test and convert test vectors
      crypto: ccm - Convert to new AEAD interface
      crypto: aes-ce-ccm - Convert to new AEAD interface
      crypto: nx - Convert ccm to new AEAD interface
      crypto: testmgr - Reenable rfc4309 test
      crypto: chacha20poly1305 - Convert to new AEAD interface
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
      crypto: testmgr - Disable authenc test and convert test vectors
      crypto: authenc - Convert to new AEAD interface
      crypto: caam - Convert authenc to new AEAD interface
      crypto: ixp4xx - Convert to new AEAD interface
      crypto: picoxcell - Convert to new AEAD interface
      crypto: qat - Convert to new AEAD interface
      crypto: talitos - Convert to new AEAD interface
      crypto: testmgr - Reenable authenc tests
      crypto: authenc - Add Kconfig dependency on CRYPTO_NULL
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
      crypto: authencesn - Convert to new AEAD interface
      crypto: algboss - Remove reference to nivaead
      crypto: user - Remove crypto_lookup_aead call
      ipsec: Replace seqniv with seqiv
      crypto: seqiv - Remove seqniv
      crypto: seqiv - Remove AEAD compatibility code
      crypto: echainiv - Remove AEAD compatibility code
      crypto: aead - Add type-safe geniv init/exit helpers
      crypto: seqiv - Use generic geniv init/exit helpers
      crypto: echainiv - Use generic geniv init/exit helpers
      crypto: cryptd - Remove reference to crypto_aead_crt
      crypto: qat - Remove reference to crypto_aead_crt
      crypto: aead - Remove old AEAD interfaces
      crypto: aead - Remove CRYPTO_ALG_AEAD_NEW flag
      crypto: null - Use NULL2 in Makefile
      crypto: nx - Add forward declaration for struct crypto_aead
      crypto: null - Add missing Kconfig tristate for NULL2
      crypto: skcipher - Add top-level skcipher interface
      crypto: testmgr - Use new skcipher interface
      crypto: hash - Add AHASH_REQUEST_ON_STACK

Horia Geant? (5):
      crypto: caam - fix snooping for write transactions
      crypto: caam - fix RNG init descriptor ret. code checking
      crypto: caam - fix rfc4106 encap shared descriptor
      crypto: caam - add support for LS1021A
      crypto: caam - fix writing to JQCR_MS when using service interface

Kees Cook (1):
      crypto: jitterentropy - use safe format string parameters

Krzysztof Kozlowski (1):
      crypto: marvell/cesa - Drop owner assignment from platform_driver

LABBE Corentin (6):
      crypto: testmgr - add a chunking test for cbc(aes)
      ARM: sun4i: dt: Add Security System to A10 SoC DTS
      ARM: sun7i: dt: Add Security System to A20 SoC DTS
      ARM: sun4i: dt: Add DT bindings documentation for SUN4I Security System
      crypto: sunxi-ss - Add Allwinner Security System crypto accelerator
      MAINTAINERS: Add myself as maintainer of Allwinner Security System

Lars Persson (1):
      crypto: algif_aead - fix for multiple operations on AF_ALG sockets

Leonidas Da Silva Barbosa (7):
      powerpc: Uncomment and make enable_kernel_vsx() routine available
      crypto: vmx - Adding enable_kernel_vsx() to access VSX instructions
      Update NX crypto driver maintainers and adding VMX maintainers
      crypto: nx - Removing CTR mode from NX driver
      crypto: vmx - Fixing AES-CTR counter bug
      crypto: vmx - Fixing GHASH Key issue on little endian
      crypto: vmx - Fixing opcode issue

Martin Willi (10):
      crypto: tcrypt - Add ChaCha20/Poly1305 speed tests
      crypto: chacha20 - Export common ChaCha20 helpers
      crypto: chacha20 - Add a SSSE3 SIMD variant for x86_64
      crypto: chacha20 - Add a four block SSSE3 variant for x86_64
      crypto: chacha20 - Add an eight block AVX2 variant for x86_64
      crypto: testmgr - Add a longer ChaCha20 test vector
      crypto: poly1305 - Export common Poly1305 helpers
      crypto: poly1305 - Add a SSE2 SIMD variant for x86_64
      crypto: poly1305 - Add a two block SSE2 variant for x86_64
      crypto: poly1305 - Add a four block AVX2 variant for x86_64

Nishanth Aravamudan (4):
      crypto: nx - nx842_OF_upd_status should return ENODEV if device is not 'okay'
      crypto: nx - rename nx842_{init, exit} to nx842_pseries_{init, exit}
      crypto: nx - do not emit extra output if status is disabled
      crypto: nx - reduce chattiness of platform drivers

Paulo Flabiano Smorigo (1):
      Fix email address mistypo for NX/VMX crypto driver maintainers

Pingchao Yang (1):
      crypto: qat - add support for MMP FW

Stephan Mueller (2):
      crypto: doc - AEAD API conversion
      crypto: cmac - allow usage in FIPS mode

Steve Cornelius (1):
      crypto: caam - Enable MXC devices to select CAAM driver in Kconfig

Tadeusz Struk (17):
      crypto: qat - add MMP FW support to accel engine
      crypto: qat - Add support for RSA algorithm
      crypto: rsa - limit supported key lengths
      crypto: rsa - fix invalid check for keylen in fips mode
      crypto: qat - fix invalid check for RSA keylen in fips mode
      crypto: qat - Don't attempt to register algorithm multiple times
      crypto: qat - Move adf admin and adf hw arbitrer to common code
      crypto: qat - Add support for SRIOV
      crypto: qat - Add qat dh895xcc VF driver
      crypto: qat - Add FW const table
      PCI: Add quirk for Intel DH895xCC VF PCI config erratum
      crypto: qat - Fix adf_isr_resource_free name clash
      crypto: qat - Fix unmet direct dependencies for QAT_DH895xCCVF
      crypto: qat - Don't move data inside output buffer
      crypto: qat - silence a static checker warning
      MPI: Fix mpi_read_buffer
      crypto: qat - enable legacy VFs

Tom Lendacky (1):
      crypto: ccp - Provide support to autoload CCP driver

Tudor Ambarus (1):
      crypto: caam - fix warning in APPEND_MATH_IMM_u64

Vaishali Thakkar (1):
      crypto: sahara - Use dmam_alloc_coherent

Victoria Milhoan (13):
      crypto: caam - Add cache coherency support
      crypto: caam - Add setbits32/clrbits32/clrsetbits primitives for ARM compatibility
      crypto: caam - Enable and disable clocks on Freescale i.MX platforms
      crypto: caam - Modify Freescale CAAM driver Scatter Gather entry definition
      crypto: caam - Change kmalloc to kzalloc to avoid residual data
      crypto: caam - Correct DMA unmap size in ahash_update_ctx()
      crypto: caam - Use local sg pointers to walk the scatterlist
      crypto: caam - Added clocks and clock-names properties to SEC4.0 device tree binding
      ARM: clk-imx6q: Add CAAM clock support
      ARM: dts: mx6qdl: Add CAAM device node
      ARM: dts: mx6sx: Add CAAM device node
      crypto: caam - Detect hardware features during algorithm registration
      ARM: imx_v6_v7_defconfig: Select CAAM

Vutla, Lokesh (5):
      crypto: omap-aes - Fix CTR mode
      crypto: omap-aes - Increase priority of hw accelerator
      crypto: omap-aes - Fix configuring of AES mode
      crypto: omap-aes - Use BIT() macro
      crypto: tcrypt - Fix AEAD speed tests

Wu Fengguang (1):
      crypto: qat - fix simple_return.cocci warnings

 Documentation/DocBook/crypto-API.tmpl              |    8 +-
 .../devicetree/bindings/crypto/fsl-sec4.txt        |   17 +
 .../devicetree/bindings/crypto/sun4i-ss.txt        |   23 +
 MAINTAINERS                                        |   24 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |   29 +-
 arch/arm/boot/dts/imx6sx.dtsi                      |   27 +
 arch/arm/boot/dts/sun4i-a10.dtsi                   |    8 +
 arch/arm/boot/dts/sun6i-a31.dtsi                   |   18 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |    8 +
 arch/arm/configs/imx_v6_v7_defconfig               |    3 +-
 arch/arm/crypto/.gitignore                         |    2 +
 arch/arm64/crypto/aes-ce-ccm-glue.c                |   68 +-
 arch/powerpc/include/asm/switch_to.h               |    1 +
 arch/powerpc/kernel/process.c                      |    3 -
 arch/x86/crypto/Makefile                           |    6 +
 arch/x86/crypto/aesni-intel_glue.c                 |   53 +-
 arch/x86/crypto/chacha20-avx2-x86_64.S             |  443 +++
 arch/x86/crypto/chacha20-ssse3-x86_64.S            |  625 +++++
 arch/x86/crypto/chacha20_glue.c                    |  150 +
 arch/x86/crypto/poly1305-avx2-x86_64.S             |  386 +++
 arch/x86/crypto/poly1305-sse2-x86_64.S             |  582 ++++
 arch/x86/crypto/poly1305_glue.c                    |  207 ++
 crypto/Kconfig                                     |   40 +-
 crypto/Makefile                                    |    3 +-
 crypto/aead.c                                      |  635 +----
 crypto/algapi.c                                    |   25 +-
 crypto/algboss.c                                   |   12 +-
 crypto/algif_aead.c                                |    4 +-
 crypto/authenc.c                                   |  580 ++--
 crypto/authencesn.c                                |  716 ++---
 crypto/ccm.c                                       |  380 +--
 crypto/chacha20_generic.c                          |   28 +-
 crypto/chacha20poly1305.c                          |  216 +-
 crypto/cryptd.c                                    |   23 +-
 crypto/crypto_user.c                               |   32 -
 crypto/echainiv.c                                  |   86 +-
 crypto/gcm.c                                       |  102 +-
 crypto/jitterentropy-kcapi.c                       |    2 +-
 crypto/pcrypt.c                                    |    7 +
 crypto/poly1305_generic.c                          |   73 +-
 crypto/rsa.c                                       |   26 +-
 crypto/rsa_helper.c                                |    4 +-
 crypto/seqiv.c                                     |  445 +--
 crypto/skcipher.c                                  |  245 ++
 crypto/tcrypt.c                                    |   82 +-
 crypto/tcrypt.h                                    |   20 +
 crypto/testmgr.c                                   |   63 +-
 crypto/testmgr.h                                   | 2948 +++++++++++++++-----
 drivers/clk/imx/clk-imx6q.c                        |    3 +
 drivers/crypto/Kconfig                             |   17 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/amcc/crypto4xx_core.c               |    2 +-
 drivers/crypto/caam/Kconfig                        |   10 +-
 drivers/crypto/caam/caamalg.c                      | 2877 ++++++++++---------
 drivers/crypto/caam/caamhash.c                     |   69 +-
 drivers/crypto/caam/caamrng.c                      |   26 +-
 drivers/crypto/caam/compat.h                       |    1 +
 drivers/crypto/caam/ctrl.c                         |  154 +-
 drivers/crypto/caam/desc.h                         |   23 +-
 drivers/crypto/caam/desc_constr.h                  |    2 +-
 drivers/crypto/caam/intern.h                       |    5 +
 drivers/crypto/caam/jr.c                           |   30 +-
 drivers/crypto/caam/regs.h                         |   64 +-
 drivers/crypto/caam/sg_sw_sec4.h                   |   25 +-
 drivers/crypto/ccp/ccp-platform.c                  |    2 +
 drivers/crypto/img-hash.c                          |    2 +-
 drivers/crypto/ixp4xx_crypto.c                     |  312 ++-
 drivers/crypto/marvell/cesa.c                      |    1 -
 drivers/crypto/nx/Kconfig                          |   17 +-
 drivers/crypto/nx/Makefile                         |    8 +-
 drivers/crypto/nx/nx-842-crypto.c                  |  580 ----
 drivers/crypto/nx/nx-842-platform.c                |   84 -
 drivers/crypto/nx/nx-842-powernv.c                 |   42 +-
 drivers/crypto/nx/nx-842-pseries.c                 |  139 +-
 drivers/crypto/nx/nx-842.c                         |  554 +++-
 drivers/crypto/nx/nx-842.h                         |   65 +-
 drivers/crypto/nx/nx-aes-ccm.c                     |  151 +-
 drivers/crypto/nx/nx-aes-ctr.c                     |   21 -
 drivers/crypto/nx/nx-aes-gcm.c                     |   64 +-
 drivers/crypto/nx/nx.c                             |   30 +-
 drivers/crypto/nx/nx.h                             |    9 +-
 drivers/crypto/omap-aes.c                          |   86 +-
 drivers/crypto/picoxcell_crypto.c                  |  677 ++---
 drivers/crypto/qat/Kconfig                         |   15 +
 drivers/crypto/qat/Makefile                        |    1 +
 drivers/crypto/qat/qat_common/.gitignore           |    1 +
 drivers/crypto/qat/qat_common/Makefile             |    8 +
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |   46 +-
 drivers/crypto/qat/qat_common/adf_accel_engine.c   |   42 +-
 drivers/crypto/qat/qat_common/adf_admin.c          |  290 ++
 drivers/crypto/qat/qat_common/adf_aer.c            |    5 +-
 drivers/crypto/qat/qat_common/adf_cfg.c            |    9 +-
 drivers/crypto/qat/qat_common/adf_cfg_common.h     |    3 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   53 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |    6 +-
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |  286 +-
 .../{qat_dh895xcc => qat_common}/adf_hw_arbiter.c  |   37 +-
 drivers/crypto/qat/qat_common/adf_init.c           |  104 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |  438 +++
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h      |  146 +
 drivers/crypto/qat/qat_common/adf_sriov.c          |  309 ++
 drivers/crypto/qat/qat_common/adf_transport.c      |   13 +-
 .../qat/qat_common/adf_transport_access_macros.h   |    5 +-
 drivers/crypto/qat/qat_common/icp_qat_fw.h         |    2 +
 drivers/crypto/qat/qat_common/icp_qat_fw_pke.h     |  112 +
 drivers/crypto/qat/qat_common/qat_algs.c           |  338 +--
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |  652 +++++
 drivers/crypto/qat/qat_common/qat_crypto.c         |   26 +-
 drivers/crypto/qat/qat_common/qat_crypto.h         |    2 -
 drivers/crypto/qat/qat_common/qat_hal.c            |   14 +-
 drivers/crypto/qat/qat_common/qat_rsakey.asn1      |    5 +
 drivers/crypto/qat/qat_common/qat_uclo.c           |   27 +-
 drivers/crypto/qat/qat_dh895xcc/Makefile           |    5 +-
 drivers/crypto/qat/qat_dh895xcc/adf_admin.c        |  145 -
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |   38 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |   12 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |   97 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.h          |    9 -
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |  139 +-
 drivers/crypto/qat/qat_dh895xccvf/Makefile         |    5 +
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |  172 ++
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h    |   68 +
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |  393 +++
 .../qat_admin.c => qat_dh895xccvf/adf_drv.h}       |   70 +-
 drivers/crypto/qat/qat_dh895xccvf/adf_isr.c        |  258 ++
 drivers/crypto/sahara.c                            |   46 +-
 drivers/crypto/sunxi-ss/Makefile                   |    2 +
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c          |  542 ++++
 drivers/crypto/sunxi-ss/sun4i-ss-core.c            |  425 +++
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c            |  492 ++++
 drivers/crypto/sunxi-ss/sun4i-ss.h                 |  201 ++
 drivers/crypto/talitos.c                           |  618 ++--
 drivers/crypto/talitos.h                           |    8 +-
 drivers/crypto/vmx/aes.c                           |    3 +
 drivers/crypto/vmx/aes_cbc.c                       |    3 +
 drivers/crypto/vmx/aes_ctr.c                       |   11 +-
 drivers/crypto/vmx/aesp8-ppc.pl                    |   34 +-
 drivers/crypto/vmx/ghash.c                         |    4 +
 drivers/crypto/vmx/ghashp8-ppc.pl                  |    6 +
 drivers/crypto/vmx/ppc-xlate.pl                    |    1 +
 drivers/pci/quirks.c                               |   85 +
 include/crypto/aead.h                              |  172 +-
 include/crypto/algapi.h                            |    3 +-
 include/crypto/chacha20.h                          |   25 +
 include/crypto/hash.h                              |    5 +
 include/crypto/internal/aead.h                     |   72 +-
 include/crypto/internal/geniv.h                    |    9 +
 include/crypto/internal/skcipher.h                 |   15 +
 include/crypto/poly1305.h                          |   41 +
 include/crypto/skcipher.h                          |  391 ++-
 include/dt-bindings/clock/imx6qdl-clock.h          |    5 +-
 include/linux/crypto.h                             |   54 +-
 lib/mpi/mpicoder.c                                 |   38 +-
 net/xfrm/xfrm_algo.c                               |   14 +-
 154 files changed, 15834 insertions(+), 7538 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
