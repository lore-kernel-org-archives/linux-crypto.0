From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.12
Date: Mon, 1 May 2017 22:26:21 +0800
Message-ID: <20170501142621.GA14379@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40176 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1424756AbdEAO0n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 May 2017 10:26:43 -0400
Content-Disposition: inline
In-Reply-To: <20170223125141.GA17400@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

Here is the crypto update for 4.12:

API:

- Add batch registration for acomp/scomp.
- Change acomp testing to non-unique compressed result.
- Extend algorithm name limit to 128 bytes.
- Require setkey before accept(2) in algif_aead.

Algorithms:

- Add support for deflate rfc1950 (zlib).

Drivers:

- Add accelerated crct10dif for powerpc.
- Add crc32 in stm32.
- Add sha384/sha512 in ccp.
- Add 3des/gcm(aes) for v5 devices in ccp.
- Add Queue Interface (QI) backend support in caam.
- Add new Exynos RNG driver.
- Add ThunderX ZIP driver.
- Add driver for hardware random generator on MT7623 SoC.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ard Biesheuvel (2):
      crypto: arm/aes-neonbs - resolve fallback cipher at runtime
      crypto: algapi - annotate expected branch behavior in crypto_inc()

Arnd Bergmann (1):
      crypto: zip - add a cast for printing atomic64_t values

Christophe Jaillet (1):
      crypto: chcr - Fix error handling related to 'chcr_alloc_shash'

Colin Ian King (2):
      crypto: bcm - fix spelling mistake: "genereate" -> "generate"
      crypto: crypto4xx - rename ce_ring_contol to ce_ring_control

Dan Carpenter (1):
      crypto: zip - Memory corruption in zip_clear_stats()

Daniel Axtens (4):
      crypto: powerpc - Factor out the core CRC vpmsum algorithm
      crypto: powerpc - Re-enable non-REFLECTed CRCs
      crypto: powerpc - Add CRC-T10DIF acceleration
      crypto: powerpc - Stress test for vpmsum implementations

Eric Biggers (7):
      crypto: gf128mul - fix some comments
      crypto: gf128mul - remove xx() macro
      crypto: gf128mul - rename the byte overflow tables
      crypto: gf128mul - constify 4k and 64k multiplication tables
      crypto: kpp - constify buffer passed to crypto_kpp_set_secret()
      crypto: testmgr - constify all test vectors
      crypto: xts,lrw - fix out-of-bounds write after kmalloc failure

Fabien DESSENNE (6):
      crypto: doc - fix typo (struct sdesc)
      dt-bindings: Document STM32 CRC bindings
      crypto: stm32 - Support for STM32 CRC32 crypto module
      ARM: dts: stm32: Add CRC support to stm32f746
      ARM: dts: stm32: enable CRC on stm32746g-eval board
      ARM: configs: stm32: Add crypto support

Gary R Hook (11):
      crypto: ccp - Assign DMA commands to the channel's CCP
      crypto: ccp - Make some CCP DMA channels private
      crypto: ccp - Add SHA-2 384- and 512-bit support
      crypto: ccp - Enable 3DES function on v5 CCPs
      crypto: ccp - Enable support for AES GCM on v5 CCPs
      crypto: ccp - Remove redundant cpu-to-le32 macros
      crypto: ccp - Rearrange structure members to minimize size
      crypto: ccp - Use only the relevant interrupt bits
      crypto: ccp - Disable interrupts early on unload
      crypto: ccp - Change ISR handler method for a v3 CCP
      crypto: ccp - Change ISR handler method for a v5 CCP

Geliang Tang (1):
      crypto: ixp4xx - Use sg_virt()

Giovanni Cabiddu (4):
      crypto: acomp - allow registration of multiple acomps
      crypto: testmgr - replace compression known answer test
      crypto: scomp - allow registration of multiple scomps
      crypto: scomp - add support for deflate rfc1950 (zlib)

Haren Myneni (1):
      crypto: nx - Update MAINTAINERS entry for 842 compression

Harsh Jain (4):
      crypto: chcr - Increase priority of AEAD algos.
      crypto: chcr - Set hmac_ctrl bit to use HW register HMAC_CFG[456]
      crypto: chcr - Fix txq ids.
      crypto: chcr - Add fallback for AEAD algos

Heiner Kallweit (4):
      clk: meson-gxbb: expose clock CLKID_RNG0
      dt-bindings: rng: add clock to DT binding documentation for hwrng
      ARM64: dts: meson-gx: add clock CLKID_RNG0 to hwrng node
      hwrng: meson - add clock handling to driver

Herbert Xu (7):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
      crypto: user - Prepare for CRYPTO_MAX_ALG_NAME expansion
      crypto: af_alg - Allow arbitrarily long algorithm names
      xfrm: Prepare for CRYPTO_MAX_ALG_NAME expansion
      crypto: api - Extend algorithm name limit to 128 bytes
      Revert "crypto: arm64/sha - Add constant operand modifier to ASM_EXPORT"

Horia Geantă (10):
      soc/qman: export volatile dequeue related structs
      soc/qman: add dedicated channel ID for CAAM
      soc/qman: export non-programmable FQD fields query
      soc/qman: add macros needed by caam/qi driver
      crypto: caam - avoid double inclusion in desc_constr.h
      crypto: caam - add Queue Interface (QI) backend support
      crypto: caam/qi - add ablkcipher and authenc algorithms
      crypto: caam - fix JR platform device subsequent (re)creations
      crypto: caam - fix invalid dereference in caam_rsa_init_tfm()
      crypto: caam - fix RNG deinstantiation error checking

Jason A. Donenfeld (4):
      padata: avoid race in reordering
      md5: remove from lib and only live in crypto
      padata: free correct variable
      padata: get_next is never NULL

Krzysztof Kozlowski (6):
      MAINTAINERS: Add maintianer entry for crypto/s5p-sss
      crypto: s5p-sss - Close possible race for completed requests
      crypto: s5p-sss - Remove unused variant field from state container
      crypto: s5p-sss - Document the struct s5p_aes_dev
      linux/kernel.h: Add ALIGN_DOWN macro
      crypto: exynos - Add new Exynos RNG driver

Mahipal Challa (3):
      crypto: zip - Add ThunderX ZIP driver core
      crypto: zip - Wire-up Compression / decompression HW offload
      crypto: zip - Add Compression/Decompression statistics

Marcelo Cerri (3):
      crypto: cbc - Propagate NEED_FALLBACK bit
      crypto: ctr - Propagate NEED_FALLBACK bit
      crypto: testmgr - mark ctr(des3_ede) as fips_allowed

Markus Elfring (1):
      hwrng: n2 - Use devm_kcalloc() in n2rng_probe()

Matthias Kaehlcke (1):
      crypto: arm64/sha - Add constant operand modifier to ASM_EXPORT

Michael Davidson (1):
      crypto, x86: aesni - fix token pasting for clang

Michael Ellerman (1):
      crypto: crct10dif-vpmsum - Fix missing preempt_disable()

Milan Broz (1):
      crypto: testmgr - Allow ecb(cipher_null) in FIPS mode

Myungho Jung (1):
      crypto: lz4 - fixed decompress function to return error code

Ondrej Mosnáček (4):
      crypto: gf128mul - define gf128mul_x_* in gf128mul.h
      crypto: gf128mul - switch gf128mul_x_ble to le128
      crypto: glue_helper - remove the le128_gf128mul_x_ble function
      crypto: xts - drop gf128mul dependency

Prarit Bhargava (2):
      hwrng: amd - Revert managed API changes
      hwrng: geode - Revert managed API changes

Rick Altherr (3):
      hwrng: timeriomem - Migrate to new API
      hwrng: timeriomem - Shorten verbose type and variable names
      hwrng: timeriomem - Improve performance for sub-jiffie update periods

Ryder Lee (8):
      crypto: mediatek - rework interrupt handler
      crypto: mediatek - add MTK_* prefix and correct annotations.
      crypto: mediatek - make mtk_sha_xmit() more generic
      crypto: mediatek - simplify descriptor ring management
      crypto: mediatek - add queue_task tasklet
      crypto: mediatek - fix error handling in mtk_aes_complete()
      crypto: mediatek - add mtk_aes_gcm_tag_verify()
      crypto: mediatek - make hardware operation flow more efficient

Sean Wang (2):
      dt-bindings: hwrng: Add Mediatek hardware random generator bindings
      hwrng: mtk - Add driver for hardware random generator on MT7623 SoC

Stephan Mueller (2):
      crypto: DRBG - initialize SGL only once
      crypto: algif_aead - Require setkey before accept(2)

Thomas Petazzoni (2):
      hwrng: omap - move clock related code to omap_rng_probe()
      dt-bindings: rng: clocks property on omap_rng not always mandatory

Wei Yongjun (2):
      crypto: caam - fix error return code in caam_qi_init()
      crypto: stm32 - Fix OF module alias information

 Documentation/crypto/api-samples.rst               |    6 +-
 .../devicetree/bindings/crypto/st,stm32-crc.txt    |   16 +
 .../devicetree/bindings/rng/amlogic,meson-rng.txt  |   11 +-
 Documentation/devicetree/bindings/rng/mtk-rng.txt  |   18 +
 Documentation/devicetree/bindings/rng/omap_rng.txt |    3 +-
 MAINTAINERS                                        |   18 +-
 arch/arm/boot/dts/stm32746g-eval.dts               |    4 +
 arch/arm/boot/dts/stm32f746.dtsi                   |    7 +
 arch/arm/configs/stm32_defconfig                   |    2 +
 arch/arm/crypto/Kconfig                            |    2 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |   60 +-
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |    2 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi        |    5 +
 arch/metag/kernel/stacktrace.c                     |    2 -
 arch/powerpc/crypto/Makefile                       |    3 +
 arch/powerpc/crypto/crc-vpmsum_test.c              |  137 ++
 arch/powerpc/crypto/crc32-vpmsum_core.S            |  755 +++++++
 arch/powerpc/crypto/crc32c-vpmsum_asm.S            |  715 +-----
 arch/powerpc/crypto/crct10dif-vpmsum_asm.S         |  850 +++++++
 arch/powerpc/crypto/crct10dif-vpmsum_glue.c        |  128 ++
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S            |    7 +-
 arch/x86/crypto/camellia_glue.c                    |    4 +-
 arch/x86/crypto/glue_helper.c                      |    3 +-
 arch/x86/crypto/serpent_sse2_glue.c                |    4 +-
 arch/x86/crypto/twofish_glue_3way.c                |    4 +-
 arch/x86/include/asm/crypto/glue_helper.h          |   10 -
 crypto/Kconfig                                     |   18 +-
 crypto/acompress.c                                 |   29 +
 crypto/af_alg.c                                    |    4 +-
 crypto/algapi.c                                    |    4 +-
 crypto/algif_aead.c                                |  157 +-
 crypto/cbc.c                                       |   15 +-
 crypto/crypto_user.c                               |   18 +-
 crypto/ctr.c                                       |   23 +-
 crypto/deflate.c                                   |   61 +-
 crypto/dh.c                                        |    3 +-
 crypto/drbg.c                                      |    5 +-
 crypto/ecdh.c                                      |    3 +-
 crypto/gf128mul.c                                  |  111 +-
 crypto/lrw.c                                       |    7 +-
 crypto/lz4.c                                       |    2 +-
 crypto/lz4hc.c                                     |    2 +-
 crypto/md5.c                                       |   95 +-
 crypto/scompress.c                                 |   29 +
 crypto/testmgr.c                                   |  112 +-
 crypto/testmgr.h                                   |  587 ++---
 crypto/xts.c                                       |   45 +-
 drivers/char/hw_random/Kconfig                     |   28 +-
 drivers/char/hw_random/Makefile                    |    2 +-
 drivers/char/hw_random/amd-rng.c                   |   42 +-
 drivers/char/hw_random/exynos-rng.c                |  231 --
 drivers/char/hw_random/geode-rng.c                 |   50 +-
 drivers/char/hw_random/meson-rng.c                 |   22 +
 drivers/char/hw_random/mtk-rng.c                   |  168 ++
 drivers/char/hw_random/n2-drv.c                    |    4 +-
 drivers/char/hw_random/omap-rng.c                  |   22 +-
 drivers/char/hw_random/timeriomem-rng.c            |  157 +-
 drivers/clk/meson/gxbb.h                           |    2 +-
 drivers/crypto/Kconfig                             |   24 +
 drivers/crypto/Makefile                            |    3 +
 drivers/crypto/amcc/crypto4xx_core.c               |    2 +-
 drivers/crypto/amcc/crypto4xx_reg_def.h            |    2 +-
 drivers/crypto/bcm/util.c                          |    2 +-
 drivers/crypto/caam/Kconfig                        |   20 +-
 drivers/crypto/caam/Makefile                       |    5 +
 drivers/crypto/caam/caamalg.c                      |    9 +-
 drivers/crypto/caam/caamalg_desc.c                 |   77 +-
 drivers/crypto/caam/caamalg_desc.h                 |   15 +-
 drivers/crypto/caam/caamalg_qi.c                   | 2387 ++++++++++++++++++++
 drivers/crypto/caam/caampkc.c                      |    2 +-
 drivers/crypto/caam/ctrl.c                         |  121 +-
 drivers/crypto/caam/desc_constr.h                  |    5 +
 drivers/crypto/caam/intern.h                       |   25 +-
 drivers/crypto/caam/qi.c                           |  805 +++++++
 drivers/crypto/caam/qi.h                           |  201 ++
 drivers/crypto/caam/sg_sw_qm.h                     |  108 +
 drivers/crypto/cavium/Makefile                     |    4 +
 drivers/crypto/cavium/zip/Makefile                 |   11 +
 drivers/crypto/cavium/zip/common.h                 |  202 ++
 drivers/crypto/cavium/zip/zip_crypto.c             |  313 +++
 drivers/crypto/cavium/zip/zip_crypto.h             |   79 +
 drivers/crypto/cavium/zip/zip_deflate.c            |  200 ++
 drivers/crypto/cavium/zip/zip_deflate.h            |   62 +
 drivers/crypto/cavium/zip/zip_device.c             |  202 ++
 drivers/crypto/cavium/zip/zip_device.h             |  108 +
 drivers/crypto/cavium/zip/zip_inflate.c            |  223 ++
 drivers/crypto/cavium/zip/zip_inflate.h            |   62 +
 drivers/crypto/cavium/zip/zip_main.c               |  729 ++++++
 drivers/crypto/cavium/zip/zip_main.h               |  121 +
 drivers/crypto/cavium/zip/zip_mem.c                |  114 +
 drivers/crypto/cavium/zip/zip_mem.h                |   78 +
 drivers/crypto/cavium/zip/zip_regs.h               | 1347 +++++++++++
 drivers/crypto/ccp/Makefile                        |    2 +
 drivers/crypto/ccp/ccp-crypto-aes-galois.c         |  252 +++
 drivers/crypto/ccp/ccp-crypto-des3.c               |  254 +++
 drivers/crypto/ccp/ccp-crypto-main.c               |   22 +
 drivers/crypto/ccp/ccp-crypto-sha.c                |   22 +
 drivers/crypto/ccp/ccp-crypto.h                    |   44 +-
 drivers/crypto/ccp/ccp-dev-v3.c                    |  121 +-
 drivers/crypto/ccp/ccp-dev-v5.c                    |  169 +-
 drivers/crypto/ccp/ccp-dev.c                       |    5 +-
 drivers/crypto/ccp/ccp-dev.h                       |   35 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |   42 +
 drivers/crypto/ccp/ccp-ops.c                       |  522 +++++
 drivers/crypto/ccp/ccp-pci.c                       |    2 +
 drivers/crypto/chelsio/chcr_algo.c                 |  304 ++-
 drivers/crypto/chelsio/chcr_algo.h                 |    4 +
 drivers/crypto/chelsio/chcr_core.h                 |    2 +
 drivers/crypto/chelsio/chcr_crypto.h               |   10 +-
 drivers/crypto/exynos-rng.c                        |  389 ++++
 drivers/crypto/ixp4xx_crypto.c                     |    2 +-
 drivers/crypto/mediatek/mtk-aes.c                  |  421 ++--
 drivers/crypto/mediatek/mtk-platform.c             |   15 +-
 drivers/crypto/mediatek/mtk-platform.h             |   56 +-
 drivers/crypto/mediatek/mtk-sha.c                  |  309 +--
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |    2 +-
 drivers/crypto/s5p-sss.c                           |   35 +-
 drivers/crypto/stm32/Kconfig                       |    7 +
 drivers/crypto/stm32/Makefile                      |    2 +
 drivers/crypto/stm32/stm32_crc32.c                 |  324 +++
 drivers/gpu/drm/udl/udl_fb.c                       |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |    9 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |    1 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      |    3 +-
 drivers/soc/fsl/qbman/qman.c                       |    4 +-
 drivers/soc/fsl/qbman/qman_ccsr.c                  |    6 +-
 drivers/soc/fsl/qbman/qman_priv.h                  |   97 -
 include/crypto/gf128mul.h                          |   87 +-
 include/crypto/internal/acompress.h                |    3 +
 include/crypto/internal/scompress.h                |    3 +
 include/crypto/kpp.h                               |    6 +-
 include/crypto/xts.h                               |    2 +-
 include/dt-bindings/clock/gxbb-clkc.h              |    3 +-
 include/linux/ccp.h                                |   70 +-
 include/linux/crypto.h                             |    2 +-
 include/linux/cryptohash.h                         |    5 -
 include/linux/kernel.h                             |    1 +
 include/soc/fsl/qman.h                             |  109 +
 include/uapi/linux/cryptouser.h                    |   10 +-
 include/video/udlfb.h                              |    2 +-
 kernel/padata.c                                    |   20 +-
 lib/Makefile                                       |    2 +-
 lib/md5.c                                          |   95 -
 net/xfrm/xfrm_user.c                               |    6 +-
 144 files changed, 13867 insertions(+), 2557 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
