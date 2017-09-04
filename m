From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.14
Date: Mon, 4 Sep 2017 18:12:25 +0800
Message-ID: <20170904101225.GA12613@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170223125141.GA17400@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

Here is the crypto update for 4.14:

API:

- Defer scompress scratch buffer allocation to first use.
- Add __crypto_xor that takes separte src and dst operands.
- Add ahash multiple registration interface.
- Revamped aead/skcipher algif code to fix async IO properly.

Drivers:

- Add non-SIMD fallback code path on ARM for SVE.
- Add AMD Security Processor framework for ccp.
- Add support for RSA in ccp.
- Add XTS-AES-256 support for CCP version 5.
- Add support for PRNG in sun4i-ss.
- Add support for DPAA2 in caam.
- Add ARTPEC crypto support.
- Add Freescale RNGC hwrng support.
- Add Microchip / Atmel ECC driver.
- Add support for STM32 HASH module.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ard Biesheuvel (21):
      crypto: scompress - don't sleep with preemption disabled
      crypto: scompress - free partially allocated scratch buffers on failure
      crypto: scompress - defer allocation of scratch buffer to first use
      crypto: algapi - use separate dst and src operands for __crypto_xor()
      crypto: algapi - make crypto_xor() take separate dst and src arguments
      crypto: arm64/ghash-ce - add non-SIMD scalar fallback
      crypto: arm64/crct10dif - add non-SIMD generic fallback
      crypto: arm64/crc32 - add non-SIMD scalar fallback
      crypto: arm64/sha1-ce - add non-SIMD generic fallback
      crypto: arm64/sha2-ce - add non-SIMD scalar fallback
      crypto: arm64/aes-ce-cipher - match round key endianness with generic code
      crypto: arm64/aes-ce-cipher: add non-SIMD generic fallback
      crypto: arm64/aes-ce-ccm: add non-SIMD generic fallback
      crypto: arm64/aes-blk - add a non-SIMD fallback for synchronous CTR
      crypto: arm64/chacha20 - take may_use_simd() into account
      crypto: arm64/aes-bs - implement non-SIMD fallback for AES-CTR
      crypto: arm64/gcm - implement native driver using v8 Crypto Extensions
      crypto: arm/ghash - add NEON accelerated fallback for vmull.p64
      crypto: arm64/ghash - add NEON accelerated fallback for 64-bit PMULL
      crypto: arm/aes - avoid expanded lookup tables in the final round
      crypto: arm64/aes - avoid expanded lookup tables in the final round

Arnd Bergmann (3):
      crypto: serpent - improve __serpent_setkey with UBSAN
      crypto: ccp - avoid uninitialized variable warning
      crypto: ccp - select CONFIG_CRYPTO_RSA

Arvind Yadav (2):
      crypto: sahara - make of_device_ids const
      crypto: sahara - constify platform_device_id

Brijesh Singh (6):
      crypto: ccp - Use devres interface to allocate PCI/iomap and cleanup
      crypto: ccp - Introduce the AMD Secure Processor device
      crypto: ccp - Abstract interrupt registeration
      crypto: ccp - rename ccp driver initialize files as sp device
      crypto: ccp - remove ccp_present() check from device initialize
      crypto: ccp - remove duplicate module version and author entry

Chris Gorman (1):
      crypto: geode-aes - fixed coding style warnings and error

Christophe Jaillet (2):
      crypto: inside-secure - fix an error handling path in safexcel_probe()
      crypto: cavium/nitrox - Fix an error handling path in 'nitrox_probe()'

Colin Ian King (2):
      crypto: qat - fix spelling mistake: "runing" -> "running"
      Crypto: atmel-ecc: Make a couple of local functions static

Corentin LABBE (2):
      crypto: sun4i-ss - support the Security System PRNG
      crypto: cavium - add release_firmware to all return case

Fabio Estevam (1):
      crypto: caam - Remove unused dentry members

Gary R Hook (12):
      crypto: ccp - Fix some line spacing
      crypto: ccp - Change all references to use the JOB ID macro
      crypto: ccp - Provide an error path for debugfs setup failure
      crypto: ccp - Update copyright dates for 2017.
      crypto: ccp - Fix base RSA function for version 5 CCPs
      crypto: Add akcipher_set_reqsize() function
      crypto: ccp - Add support for RSA on the CCP
      csrypto: ccp - Expand RSA support for a v5 ccp
      crypto: ccp - Fix XTS-AES-128 support on v5 CCPs
      crypto: ccp - Add a call to xts_check_key()
      crypto: ccp - Rework the unit-size check for XTS-AES
      crypto: ccp - Add XTS-AES-256 support for CCP version 5

Gustavo A. R. Silva (11):
      crypto: ccp - print error message on platform_get_irq failure
      crypto: mediatek - fix error return code in mtk_crypto_probe()
      crypto: mxc-scc - fix error code in mxc_scc_probe()
      crypto: mxs-dcp - print error message on platform_get_irq failure
      crypto: omap-aes - fix error return code in omap_aes_probe()
      crypto: omap-des - fix error return code in omap_des_probe()
      crypto: brcm - add NULL check on of_match_device() return value
      crypto: omap-sham - remove unnecessary static in omap_sham_remove()
      crypto: atmel-sha - remove unnecessary static in atmel_sha_remove()
      crypto: atmel-tdes - remove unnecessary static in atmel_tdes_remove()
      crypto: img-hash - remove unnecessary static in img_hash_remove()

Harald Freudenberger (2):
      hwrng: use rng source with best quality
      hwrng: remember rng chosen by user

Herbert Xu (1):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

Horia Geantă (13):
      crypto: caam/qi - fix typo in authenc alg driver name
      crypto: caam/qi - fix compilation with DEBUG enabled
      crypto: caam/qi - fix compilation with CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
      crypto: caam/qi - properly set IV after {en,de}crypt
      crypto: caam/qi - handle large number of S/Gs case
      crypto: caam/qi - fix AD length endianness in S/G entry
      crypto: caam/qi - explicitly set dma_ops
      crypto: caam/qi - remove unused header sg_sw_sec4.h
      crypto: caam/qi - lower driver verbosity
      crypto: caam - remove unused sg_to_sec4_sg_len()
      crypto: caam - clean-up in caam_init_rng()
      crypto: caam/jr - add support for DPAA2 parts
      crypto: tcrypt - remove AES-XTS-192 speed tests

Jason A. Donenfeld (1):
      crypto: rng - ensure that the RNG is ready before using

Lars Persson (3):
      dt-bindings: crypto: add ARTPEC crypto
      crypto: axis - add ARTPEC-6/7 crypto accelerator driver
      MAINTAINERS: Add ARTPEC crypto maintainer

Martin Kaiser (1):
      hwrng: mx-rngc - add a driver for Freescale RNGC

Mogens Lauridsen (2):
      crypto: sahara - Fix dma unmap direction
      crypto: sahara - Remove leftover from previous used spinlock

Pan Bian (1):
      crypto: ccp - use dma_mapping_error to check map error

PrasannaKumar Muralidharan (1):
      hwrng: Kconfig - Correct help text about feeding entropy pool

Rabin Vincent (1):
      crypto: hash - add crypto_(un)register_ahashes()

Rob Herring (1):
      crypto: n2 - Convert to using %pOF instead of full_name

Stefan Agner (1):
      lib/mpi: fix build with clang

Steffen Trumtrar (1):
      Documentation: devicetree: add Freescale RNGC binding

Stephan Mueller (7):
      crypto: algif_skcipher - overhaul memory management
      crypto: algif_aead - overhaul memory management
      crypto: algif - return error code when no data was processed
      crypto: algif_aead - copy AAD from src to dst
      crypto: af_alg - consolidation of duplicate code
      crypto: algif_aead - fix comment regarding memory layout
      crypto: af_alg - get_page upon reassignment to TX SGL

Tudor Ambarus (2):
      crypto: caam - remove unused variables in caam_drv_private
      crypto: caam - fix condition for the jump over key(s) command

Tudor-Dan Ambarus (5):
      crypto: kpp - add get/set_flags helpers
      crypto: atmel-ecc - introduce Microchip / Atmel ECC driver
      MAINTAINERS: add a maintainer for Microchip / Atmel ECC driver
      crypto: ecdh - fix concurrency on shared secret and pubkey
      crypto: atmel-ecc - fix signed integer to u8 assignment

Xulin Sun (1):
      crypto: caam - free qman_fq after kill_fq

Zain Wang (3):
      crypto: rockchip - move the crypto completion from interrupt context
      crypto: rockchip - return the err code when unable dequeue the crypto request
      crypto: rockchip - Don't dequeue the request when device is busy

Zeng, Xin (1):
      crypto: virtio - Refacotor virtio_crypto driver for new virito crypto services

lionel.debieve@st.com (5):
      crypto: stm32 - CRC use relaxed function
      crypto: stm32 - solve crc issue during unbind
      crypto: stm32 - Rename module to use generic crypto
      dt-bindings: Document STM32 HASH bindings
      crypto: stm32 - Support for STM32 HASH module

raveendra padasalagi (1):
      crypto: brcm - Support more FlexRM rings than SPU engines.

 .../devicetree/bindings/crypto/artpec6-crypto.txt  |   16 +
 .../devicetree/bindings/crypto/atmel-crypto.txt    |   13 +
 .../devicetree/bindings/crypto/st,stm32-hash.txt   |   30 +
 Documentation/devicetree/bindings/rng/imx-rngc.txt |   21 +
 MAINTAINERS                                        |    7 +
 arch/arm/crypto/Kconfig                            |    5 +-
 arch/arm/crypto/aes-ce-glue.c                      |    4 +-
 arch/arm/crypto/aes-cipher-core.S                  |   88 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |    5 +-
 arch/arm/crypto/ghash-ce-core.S                    |  234 +-
 arch/arm/crypto/ghash-ce-glue.c                    |   24 +-
 arch/arm64/crypto/Kconfig                          |   22 +-
 arch/arm64/crypto/aes-ce-ccm-core.S                |   30 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c                |  174 +-
 arch/arm64/crypto/aes-ce-cipher.c                  |   55 +-
 arch/arm64/crypto/aes-ce.S                         |   12 +-
 arch/arm64/crypto/aes-cipher-core.S                |  152 +-
 arch/arm64/crypto/aes-ctr-fallback.h               |   53 +
 arch/arm64/crypto/aes-glue.c                       |   63 +-
 arch/arm64/crypto/aes-neonbs-glue.c                |   53 +-
 arch/arm64/crypto/chacha20-neon-glue.c             |    5 +-
 arch/arm64/crypto/crc32-ce-glue.c                  |   11 +-
 arch/arm64/crypto/crct10dif-ce-glue.c              |   13 +-
 arch/arm64/crypto/ghash-ce-core.S                  |  401 ++-
 arch/arm64/crypto/ghash-ce-glue.c                  |  517 +++-
 arch/arm64/crypto/sha1-ce-glue.c                   |   18 +-
 arch/arm64/crypto/sha2-ce-glue.c                   |   30 +-
 arch/arm64/crypto/sha256-glue.c                    |    1 +
 arch/sparc/crypto/aes_glue.c                       |    3 +-
 arch/x86/crypto/aesni-intel_glue.c                 |    4 +-
 arch/x86/crypto/blowfish_glue.c                    |    3 +-
 arch/x86/crypto/cast5_avx_glue.c                   |    3 +-
 arch/x86/crypto/des3_ede_glue.c                    |    3 +-
 crypto/Kconfig                                     |    2 +
 crypto/af_alg.c                                    |  691 +++++
 crypto/ahash.c                                     |   29 +
 crypto/algapi.c                                    |   25 +-
 crypto/algif_aead.c                                |  864 ++----
 crypto/algif_skcipher.c                            |  834 +----
 crypto/ctr.c                                       |    3 +-
 crypto/ecdh.c                                      |   51 +-
 crypto/pcbc.c                                      |   12 +-
 crypto/rng.c                                       |    6 +-
 crypto/scompress.c                                 |   55 +-
 crypto/serpent_generic.c                           |   77 +-
 crypto/tcrypt.c                                    |    8 +-
 drivers/char/hw_random/Kconfig                     |   20 +-
 drivers/char/hw_random/Makefile                    |    1 +
 drivers/char/hw_random/core.c                      |   42 +-
 drivers/char/hw_random/imx-rngc.c                  |  331 ++
 drivers/crypto/Kconfig                             |   49 +-
 drivers/crypto/Makefile                            |    4 +-
 drivers/crypto/atmel-ecc.c                         |  781 +++++
 drivers/crypto/atmel-ecc.h                         |  128 +
 drivers/crypto/atmel-sha.c                         |    2 +-
 drivers/crypto/atmel-tdes.c                        |    2 +-
 drivers/crypto/axis/Makefile                       |    1 +
 drivers/crypto/axis/artpec6_crypto.c               | 3192 ++++++++++++++++++++
 drivers/crypto/bcm/cipher.c                        |  114 +-
 drivers/crypto/bcm/cipher.h                        |   13 +-
 drivers/crypto/caam/caamalg.c                      |   66 +-
 drivers/crypto/caam/caamalg_desc.c                 |    5 +-
 drivers/crypto/caam/caamalg_qi.c                   |   55 +-
 drivers/crypto/caam/caamhash.c                     |    7 +-
 drivers/crypto/caam/caamrng.c                      |    6 +-
 drivers/crypto/caam/ctrl.c                         |  127 +-
 drivers/crypto/caam/ctrl.h                         |    2 +
 drivers/crypto/caam/error.c                        |   40 +
 drivers/crypto/caam/error.h                        |    4 +
 drivers/crypto/caam/intern.h                       |   11 -
 drivers/crypto/caam/jr.c                           |    7 +-
 drivers/crypto/caam/qi.c                           |   30 +-
 drivers/crypto/caam/qi.h                           |    3 +
 drivers/crypto/caam/regs.h                         |    1 +
 drivers/crypto/caam/sg_sw_qm2.h                    |   81 +
 drivers/crypto/caam/sg_sw_sec4.h                   |   43 +-
 drivers/crypto/cavium/cpt/cptpf_main.c             |   13 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c         |    4 +-
 drivers/crypto/ccp/Kconfig                         |   22 +-
 drivers/crypto/ccp/Makefile                        |    7 +-
 drivers/crypto/ccp/ccp-crypto-aes-galois.c         |    2 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c            |   96 +-
 drivers/crypto/ccp/ccp-crypto-des3.c               |    2 +-
 drivers/crypto/ccp/ccp-crypto-main.c               |   21 +-
 drivers/crypto/ccp/ccp-crypto-rsa.c                |  299 ++
 drivers/crypto/ccp/ccp-crypto-sha.c                |    2 +-
 drivers/crypto/ccp/ccp-crypto.h                    |   36 +-
 drivers/crypto/ccp/ccp-debugfs.c                   |   15 +-
 drivers/crypto/ccp/ccp-dev-v3.c                    |   20 +-
 drivers/crypto/ccp/ccp-dev-v5.c                    |   28 +-
 drivers/crypto/ccp/ccp-dev.c                       |  134 +-
 drivers/crypto/ccp/ccp-dev.h                       |   30 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |    2 +-
 drivers/crypto/ccp/ccp-ops.c                       |  133 +-
 drivers/crypto/ccp/ccp-pci.c                       |  356 ---
 drivers/crypto/ccp/ccp-platform.c                  |  293 --
 drivers/crypto/ccp/sp-dev.c                        |  277 ++
 drivers/crypto/ccp/sp-dev.h                        |  133 +
 drivers/crypto/ccp/sp-pci.c                        |  276 ++
 drivers/crypto/ccp/sp-platform.c                   |  256 ++
 drivers/crypto/geode-aes.c                         |   17 +-
 drivers/crypto/img-hash.c                          |    2 +-
 drivers/crypto/inside-secure/safexcel.c            |    5 +-
 drivers/crypto/mediatek/mtk-platform.c             |    2 +-
 drivers/crypto/mxc-scc.c                           |    4 +-
 drivers/crypto/mxs-dcp.c                           |    8 +-
 drivers/crypto/n2_core.c                           |   60 +-
 drivers/crypto/omap-aes.c                          |    1 +
 drivers/crypto/omap-des.c                          |    3 +-
 drivers/crypto/omap-sham.c                         |    2 +-
 drivers/crypto/qat/qat_common/adf_aer.c            |    2 +-
 drivers/crypto/rockchip/rk3288_crypto.c            |   74 +-
 drivers/crypto/rockchip/rk3288_crypto.h            |   15 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |  103 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |  119 +-
 drivers/crypto/sahara.c                            |   14 +-
 drivers/crypto/stm32/Kconfig                       |   19 +-
 drivers/crypto/stm32/Makefile                      |    4 +-
 drivers/crypto/stm32/stm32-hash.c                  | 1575 ++++++++++
 drivers/crypto/stm32/stm32_crc32.c                 |   17 +-
 drivers/crypto/sunxi-ss/Makefile                   |    1 +
 drivers/crypto/sunxi-ss/sun4i-ss-core.c            |   30 +
 drivers/crypto/sunxi-ss/sun4i-ss-prng.c            |   56 +
 drivers/crypto/sunxi-ss/sun4i-ss.h                 |   11 +
 drivers/crypto/virtio/virtio_crypto_algs.c         |  109 +-
 drivers/crypto/virtio/virtio_crypto_common.h       |   22 +-
 drivers/crypto/virtio/virtio_crypto_core.c         |   37 +-
 drivers/crypto/vmx/aes_ctr.c                       |    3 +-
 drivers/md/dm-crypt.c                              |   11 +-
 include/crypto/algapi.h                            |   23 +-
 include/crypto/if_alg.h                            |  170 ++
 include/crypto/internal/akcipher.h                 |    6 +
 include/crypto/internal/hash.h                     |    2 +
 include/crypto/kpp.h                               |   10 +
 include/linux/ccp.h                                |   11 +-
 lib/mpi/longlong.h                                 |   24 +-
 136 files changed, 11758 insertions(+), 3169 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
