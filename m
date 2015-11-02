From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.4
Date: Mon, 2 Nov 2015 16:04:27 +0800
Message-ID: <20151102080427.GA8465@gondor.apana.org.au>
References: <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49463 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbbKBIEi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Nov 2015 03:04:38 -0500
Content-Disposition: inline
In-Reply-To: <20150831135655.GA2694@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 4.4:

API:

* Add support for cipher output IVs in testmgr.
* Add missing crypto_ahash_blocksize helper.
* Mark authenc and des ciphers as not allowed under FIPS.

Algorithms:

* Add CRC support to 842 compression.
* Add keywrap algorithm.
* A number of changes to the akcipher interface:
  + Separate functions for setting public/private keys.
  + Use SG lists.

Drivers:

* Add Intel SHA Extension optimised SHA1 and SHA256.
* Use dma_map_sg instead of custom functions in crypto drivers.
* Add support for STM32 RNG.
* Add support for ST RNG.
* Add Device Tree support to exynos RNG driver.
* Add support for mxs-dcp crypto device on MX6SL.
* Add xts(aes) support to caam.
* Add ctr(aes) and xts(aes) support to qat.
* A large set of fixes from Russell King for the marvell/cesa driver.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Alexander Kuleshov (1):
      crypto: jitterentropy - remove unnecessary information from a comment

Arnd Bergmann (1):
      crypto: mxs-dcp - mxs-dcp is an stmp device

Boris BREZILLON (1):
      crypto: testmgr - test IV value after a cipher operation

Boris Brezillon (1):
      crypto: marvell/cesa - fix memory leak

Catalin Vasile (1):
      crypto: caam - add support for acipher xts(aes)

Daniel Thompson (5):
      dt-bindings: Document the STM32 HW RNG bindings
      hwrng: stm32 - add support for STM32 HW RNG
      ARM: dts: stm32f429: Adopt STM32 RNG driver
      hwrng: stm32 - Fix build with CONFIG_PM
      hwrng: exynos - Fix unbalanced PM runtime get/puts

David Howells (1):
      crypto: akcipher - Don't #include crypto/public_key.h as the contents aren't used

Fabio Estevam (6):
      crypto: mxs-dcp - Allow MXS_DCP to be used on MX6SL
      hwrng: mxc-rnga - Remove unneeded goto label
      hwrng: mxc-rnga - Remove uneeded initialization
      hwrng: mxc-rnga - Remove unnecessary dev_info message
      hwrng: mxc-rnga - Use the preferred format for kzalloc
      crypto: caam - Remove unused JUMP_TYPE_MASK definition

Geliang Tang (1):
      crypto: skcipher - blkcipher and ablkcipher should it be static

Haren Myneni (1):
      crypto: 842 - Add CRC and validation support

Herbert Xu (1):
      crypto: ahash - Add crypto_ahash_blocksize

Horia Geant? (1):
      crypto: tcrypt - avoid mapping from module image addresses

John Griffin (1):
      crypto: qat - don't check for iommu

John Haxby (1):
      crypto: testmgr - Disable fips-allowed for authenc() and des() ciphers

Krzysztof Kozlowski (4):
      dt-bindings: rng: Describe Exynos4 PRNG bindings
      hwrng: exynos - Add timeout for waiting on init done
      hwrng: exynos - Fix missing configuration after suspend to RAM
      hwrng: exynos - Add Device Tree support

LABBE Corentin (14):
      crypto: bfin_crc - replace sg_count by sg_nents
      crypto: amcc - replace get_sg_count by sg_nents_for_len
      crypto: sahara - replace sahara_sg_length with sg_nents_for_len
      crypto: talitos - dma_map_sg can handle chained SG
      crypto: caam - dma_map_sg can handle chained SG
      crypto: sahara - dma_map_sg can handle chained SG
      crypto: qce - dma_map_sg can handle chained SG
      crypto: atmel - Check for clk_prepare_enable() return value
      crypto: atmel - use devm_xxx() managed function
      crypto: ux500 - Use devm_xxx() managed function
      crypto: s390/sha - replace raw value by their coresponding define
      crypto: sahara - set array of const as const
      crypto: n2 - set array of const as const
      lib/mpi: clean unused SHA1_DIGEST_LENGTH

Lee Jones (10):
      hwrng: doc - Fix device node name reference /dev/hw_random => /dev/hwrng
      hwrng: Kconfig - Fix device node name reference /dev/hw_random => /dev/hwrng
      hwrng: core - Simplify RNG switching from sysfs
      hwrng: st - Provide DT bindings for ST's Random Number Generator
      hwrng: st - Add support for ST's HW Random Number Generator
      ARM: STi: STiH407: Enable the 2 HW Random Number Generators for STiH4{07, 10}
      MAINTAINERS: Add ST's Random Number Generator to the ST entry
      hwrng: st: dt: Fix trivial typo in node address
      hwrng: st - Use real-world device timings for timeout
      hwrng: st - Improve FIFO size/depth description

Luis de Bethencourt (4):
      crypto: amcc - Fix module autoload for OF platform driver
      crypto: picoxcell - Fix module autoload for OF platform driver
      crypto: ux500 - Fix module autoload for OF platform drivers
      hwrng: Fix module autoload for OF platform drivers

Nicolas Iooss (1):
      crypto: crc32c-pclmul - use .rodata instead of .rotata

Russell King (32):
      crypto: marvell/cesa - fix stack smashing in marvell/hash.c
      crypto: marvell/cesa - initialise struct mv_cesa_ahash_req
      crypto: marvell/cesa - fix wrong hash results
      crypto: marvell/cesa - factor out common import/export functions
      crypto: marvell/cesa - easier way to get the transform
      crypto: marvell/cesa - keep creq->state in CPU endian format at all times
      crypto: marvell/cesa - add flag to determine algorithm endianness
      crypto: marvell/cesa - fix the bit length endianness
      crypto: marvell/cesa - ensure template operation is initialised
      crypto: marvell/cesa - const-ify argument to mv_cesa_get_op_cfg()
      crypto: marvell/cesa - factor out first fragment decisions to helper
      crypto: marvell/cesa - factor out adding an operation and launching it
      crypto: marvell/cesa - always ensure mid-fragments after first-fragment
      crypto: marvell/cesa - move mv_cesa_dma_add_frag() calls
      crypto: marvell/cesa - use presence of scatterlist to determine data load
      crypto: marvell/cesa - ensure iter.base.op_len is the full op length
      crypto: marvell/cesa - avoid adding final operation within loop
      crypto: marvell/cesa - rearrange last request handling
      crypto: marvell/cesa - rearrange handling for hw finished hashes
      crypto: marvell/cesa - rearrange handling for sw padded hashes
      crypto: marvell/cesa - fix first-fragment handling in mv_cesa_ahash_dma_last_req()
      crypto: caam - print errno code when hash registration fails
      crypto: caam - avoid needlessly saving and restoring caam_hash_ctx
      crypto: caam - fix non-block aligned hash calculation
      crypto: caam - only export the state we really need to export
      crypto: caam - fix indentation of close braces
      crypto: marvell/cesa - use readl_relaxed()/writel_relaxed()
      crypto: marvell/cesa - use dma_addr_t for cur_dma
      crypto: marvell/cesa - use gfp_t for gfp flags
      crypto: marvell/cesa - use memcpy_fromio()/memcpy_toio()
      crypto: marvell/cesa - fix missing cpu_to_le32() in mv_cesa_dma_add_op()
      crypto: marvell/cesa - use __le32 for hardware descriptors

Sowmini Varadhan (2):
      crypto: pkcs7 - Fix unaligned access in pkcs7_verify()
      crypto: asymmetric_keys - Fix unaligned access in x509_get_sig_params()

Stephan Mueller (4):
      crypto: keywrap - add key wrapping block chaining mode
      crypto: keywrap - enable compilation
      crypto: keywrap - add testmgr support
      lib/mpi: fix off by one in mpi_read_raw_from_sgl

Tadeusz Struk (7):
      crypto: qat - Add load balancing across devices
      crypto: qat - remove empty functions and turn qat_uregister fn to void
      crypto: qat - add support for ctr(aes) and xts(aes)
      crypto: qat - remove unneeded variable
      lib/mpi: Add mpi sgl helpers
      crypto: akcipher - Changes to asymmetric key API
      crypto: qat - fix crypto_get_instance_node function

Thomas Petazzoni (1):
      MAINTAINERS: add maintainers for the Marvell Crypto driver

Tom Lendacky (4):
      crypto: ccp - Replace BUG_ON with WARN_ON and a return code
      crypto: ccp - Remove use ACPI field
      crypto: ccp - Change references to accelerator to offload
      crypto: ccp - Use module name in driver structures

Vaishali Thakkar (1):
      hwrng: octeon - Use devm_hwrng_register

sudip (1):
      crypto: asymmetric_keys - remove always false comparison

tim (7):
      crypto: x86/sha - Intel SHA Extensions optimized SHA1 transform function
      crypto: x86/sha - Intel SHA Extensions optimized SHA256 transform function
      crypto: x86/sha - glue code for Intel SHA extensions optimized SHA1 & SHA256
      crypto: x86/sha - Add build support for Intel SHA Extensions optimized SHA1 and SHA256
      crypto: x86/sha - Restructure x86 sha1 glue code to expose all the available sha1 transforms
      crypto: x86/sha - Restructure x86 sha256 glue code to expose all the available sha256 transforms
      crypto: x86/sha - Restructure x86 sha512 glue code to expose all the available sha512 transforms

 .../bindings/rng/samsung,exynos-rng4.txt           |   17 +
 Documentation/devicetree/bindings/rng/st,rng.txt   |   15 +
 .../devicetree/bindings/rng/st,stm32-rng.txt       |   21 +
 Documentation/hw_random.txt                        |    8 +-
 MAINTAINERS                                        |    8 +
 arch/arm/boot/dts/stih407-family.dtsi              |   14 +
 arch/arm/boot/dts/stm32f429.dtsi                   |    7 +
 arch/s390/crypto/sha.h                             |    2 +-
 arch/x86/Makefile                                  |    6 +-
 arch/x86/crypto/Makefile                           |    8 +
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S          |    2 +-
 arch/x86/crypto/sha1_ni_asm.S                      |  302 +++++++++++++
 arch/x86/crypto/sha1_ssse3_glue.c                  |  314 ++++++++++---
 arch/x86/crypto/sha256_ni_asm.S                    |  353 +++++++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c                |  329 ++++++++++++--
 arch/x86/crypto/sha512_ssse3_glue.c                |  249 +++++++++--
 crypto/Kconfig                                     |   17 +-
 crypto/Makefile                                    |   10 +-
 crypto/akcipher.c                                  |    1 -
 crypto/asymmetric_keys/pkcs7_verify.c              |    5 +-
 crypto/asymmetric_keys/x509_cert_parser.c          |    6 +-
 crypto/asymmetric_keys/x509_public_key.c           |    5 +-
 crypto/jitterentropy-kcapi.c                       |    4 -
 crypto/keywrap.c                                   |  419 +++++++++++++++++
 crypto/rsa.c                                       |   83 ++--
 crypto/rsa_helper.c                                |   42 +-
 crypto/rsakey.asn1                                 |    5 -
 crypto/rsaprivkey.asn1                             |   11 +
 crypto/rsapubkey.asn1                              |    4 +
 crypto/skcipher.c                                  |    4 +-
 crypto/tcrypt.c                                    |   17 +-
 crypto/testmgr.c                                   |   83 ++--
 crypto/testmgr.h                                   |   77 +++-
 drivers/char/hw_random/Kconfig                     |   24 +-
 drivers/char/hw_random/Makefile                    |    2 +
 drivers/char/hw_random/core.c                      |    2 +-
 drivers/char/hw_random/exynos-rng.c                |   58 ++-
 drivers/char/hw_random/mxc-rnga.c                  |   14 +-
 drivers/char/hw_random/octeon-rng.c                |   12 +-
 drivers/char/hw_random/pasemi-rng.c                |    1 +
 drivers/char/hw_random/ppc4xx-rng.c                |    1 +
 drivers/char/hw_random/st-rng.c                    |  151 +++++++
 drivers/char/hw_random/stm32-rng.c                 |  202 +++++++++
 drivers/crypto/Kconfig                             |    5 +-
 drivers/crypto/amcc/crypto4xx_core.c               |   23 +-
 drivers/crypto/atmel-aes.c                         |   44 +-
 drivers/crypto/atmel-sha.c                         |   33 +-
 drivers/crypto/atmel-tdes.c                        |   35 +-
 drivers/crypto/bfin_crc.c                          |   25 +-
 drivers/crypto/caam/caamalg.c                      |  232 +++++++---
 drivers/crypto/caam/caamhash.c                     |  131 +++---
 drivers/crypto/caam/desc.h                         |    1 -
 drivers/crypto/caam/sg_sw_sec4.h                   |   72 +--
 drivers/crypto/ccp/Kconfig                         |   13 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c           |   20 +-
 drivers/crypto/ccp/ccp-crypto-main.c               |    6 +-
 drivers/crypto/ccp/ccp-crypto-sha.c                |   13 +
 drivers/crypto/ccp/ccp-ops.c                       |  108 +++--
 drivers/crypto/ccp/ccp-pci.c                       |    2 +-
 drivers/crypto/ccp/ccp-platform.c                  |    6 +-
 drivers/crypto/marvell/cesa.h                      |   55 ++-
 drivers/crypto/marvell/cipher.c                    |   13 +-
 drivers/crypto/marvell/hash.c                      |  471 ++++++++++----------
 drivers/crypto/marvell/tdma.c                      |   42 +-
 drivers/crypto/n2_core.c                           |    2 +-
 drivers/crypto/nx/nx-842-powernv.c                 |    4 +-
 drivers/crypto/nx/nx-842-pseries.c                 |    8 +-
 drivers/crypto/picoxcell_crypto.c                  |    1 +
 drivers/crypto/qat/qat_common/Makefile             |   12 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    4 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |    6 -
 drivers/crypto/qat/qat_common/adf_init.c           |    8 +-
 drivers/crypto/qat/qat_common/adf_sriov.c          |    7 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |  178 +++++---
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |  213 ++++++---
 drivers/crypto/qat/qat_common/qat_crypto.c         |   79 ++--
 drivers/crypto/qat/qat_common/qat_hal.c            |    5 +-
 drivers/crypto/qat/qat_common/qat_rsakey.asn1      |    5 -
 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1  |   11 +
 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1   |    4 +
 drivers/crypto/qce/ablkcipher.c                    |   30 +-
 drivers/crypto/qce/cipher.h                        |    4 -
 drivers/crypto/qce/dma.c                           |   52 ---
 drivers/crypto/qce/dma.h                           |    5 -
 drivers/crypto/qce/sha.c                           |   18 +-
 drivers/crypto/qce/sha.h                           |    2 -
 drivers/crypto/sahara.c                            |  108 +----
 drivers/crypto/talitos.c                           |  104 +----
 drivers/crypto/ux500/cryp/cryp_core.c              |   71 +--
 drivers/crypto/ux500/hash/hash_core.c              |   50 +--
 include/crypto/akcipher.h                          |   90 +++-
 include/crypto/hash.h                              |   14 +
 include/crypto/internal/rsa.h                      |    7 +-
 include/linux/mpi.h                                |   10 +-
 lib/842/842.h                                      |    2 +
 lib/842/842_compress.c                             |   13 +
 lib/842/842_decompress.c                           |   17 +
 lib/mpi/mpicoder.c                                 |  199 +++++++++
 98 files changed, 4070 insertions(+), 1538 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
