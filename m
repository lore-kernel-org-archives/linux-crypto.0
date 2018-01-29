From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.16
Date: Mon, 29 Jan 2018 22:50:12 +0800
Message-ID: <20180129145012.GA12805@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170904101225.GA12613@gondor.apana.org.au>
 <20171113074346.GA20245@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:44904 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbeA2Ou2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jan 2018 09:50:28 -0500
Content-Disposition: inline
In-Reply-To: <20171113074346.GA20245@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

Here is the crypto update for 4.16:

API:

- Enforce the setting of keys for keyed aead/hash/skcipher
algorithms.
- Add multibuf speed tests in tcrypt.

Algorithms:

- Improve performance of sha3-generic.
- Add native sha512 support on arm64.
- Add v8.2 Crypto Extentions version of sha3/sm3 on arm64.
- Avoid hmac nesting by requiring underlying algorithm to be unkeyed.
- Add cryptd_max_cpu_qlen module parameter to cryptd.

Drivers:

- Add support for EIP97 engine in inside-secure.
- Add inline IPsec support to chelsio.
- Add RevB core support to crypto4xx.
- Fix AEAD ICV check in crypto4xx.
- Add stm32 crypto driver.
- Add support for BCM63xx platforms in bcm2835 and remove bcm63xx.
- Add Derived Key Protocol (DKP) support in caam.
- Add Samsung Exynos True RNG driver.
- Add support for Exynos5250+ SoCs in exynos PRNG driver.

Please note that there will be a conflict with the net tree due
updates to the same header file in the chelsio driver.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Alexey Khoroshilov (1):
      crypto: picoxcell - Fix error handling in spacc_probe()

Antoine Tenart (1):
      Documentation/bindings: crypto: document the SafeXcel EIP97 compatible

Antoine Ténart (14):
      crypto: inside-secure - remove extra empty line
      crypto: inside-secure - fix typo in a comment
      crypto: inside-secure - remove useless memset
      crypto: inside-secure - comment the caching function
      crypto: inside-secure - move request dequeueing into a workqueue
      crypto: inside-secure - use threaded IRQs for result handling
      crypto: inside-secure - dequeue all requests at once
      crypto: inside-secure - increase the ring size
      crypto: inside-secure - acknowledge the result requests all at once
      crypto: inside-secure - handle more result requests when counter is full
      crypto: inside-secure - retry to proceed the request later on fail
      crypto: inside-secure - EIP97 support
      crypto: inside-secure - avoid unmapping DMA memory that was not mapped
      crypto: inside-secure - fix hash when length is a multiple of a block

Ard Biesheuvel (16):
      crypto: arm64/aes-ce-cipher - move assembler code to .S file
      crypto: arm64 - implement SHA-512 using special instructions
      crypto: arm64/aes-cipher - move S-box to .rodata section
      crypto: arm64/aes-neon - move literal data to .rodata section
      crypto: arm64/crc32 - move literal data to .rodata section
      crypto: arm64/crct10dif - move literal data to .rodata section
      crypto: arm64/sha2-ce - move the round constant table to .rodata section
      crypto: arm64/sha1-ce - get rid of literal pool
      crypto: sha3-generic - fixes for alignment and big endian operation
      crypto: sha3-generic - rewrite KECCAK transform to help the compiler optimize
      crypto: sha3-generic - simplify code
      crypto: sha3-generic - export init/update/final routines
      crypto: testmgr - add new testcases for sha3
      crypto: arm64/sha3 - new v8.2 Crypto Extensions implementation
      crypto: arm64/sm3 - new v8.2 Crypto Extensions implementation
      crypto: arm64/sha512 - fix/improve new v8.2 Crypto Extensions code

Arnd Bergmann (3):
      crypto: qat - reduce stack size with KASAN
      crypto: aes-generic - build with -Os on gcc-7+
      crypto: aes-generic - fix aes-generic regression on powerpc

Atul Gupta (3):
      cxgb4: Add support for Inline IPSec Tx
      chcr: Add support for Inline IPSec
      crypto: chelsio - fix a type cast error

Cheah Kok Cheong (1):
      padata: add SPDX identifier

Christian Lamparter (5):
      crypto: crypto4xx - shuffle iomap in front of request_irq
      crypto: crypto4xx - support Revision B parts
      crypto: crypto4xx - fix missing irq devname
      crypto: crypto4xx - kill MODULE_NAME
      crypto: crypto4xx - perform aead icv check in the driver

Christophe Jaillet (1):
      crypto: hifn_795x - Fix a memory leak in the error handling path of 'hifn_probe()'

Colin Ian King (10):
      crypto: chelsio - remove redundant assignments to reqctx and dst_size
      crypto: nx - fix spelling mistake: "availavle" -> "available"
      crypto: cavium - fix memory leak on info
      crypto: cryptd - make cryptd_max_cpu_qlen module parameter static
      crypto: chelsio - make arrays sgl_ent_len and dsgl_ent_len static
      chcr: remove unused variables net_device, pi, adap and cntrl
      chcr: ensure cntrl is initialized to fix bit-wise or'ing of garabage data
      crypto: tcrypt - fix spelling mistake: "bufufer"-> "buffer"
      crypto: tcrypt - free xoutbuf instead of axbuf
      crypto: inside-secure - make function safexcel_try_push_requests static

Corentin LABBE (2):
      crypto: stm32 - fix module device table name
      crypto: artpec6 - remove select on non-existing CRYPTO_SHA384

Corentin Labbe (4):
      crypto: arm64/aes - do not call crypto_unregister_skcipher twice on error
      crypto: echainiv - Remove unused alg/spawn variable
      crypto: seqiv - Remove unused alg/spawn variable
      crypto: stm32 - Use standard CONFIG name

Dan Carpenter (3):
      crypto: chelsio - Fix an error code in chcr_hash_dma_map()
      crypto: s5p-sss - Remove a stray tab
      hwrng: exynos - Signedness bug in exynos_trng_do_read()

Eric Biggers (32):
      crypto: rsa - fix buffer overread when stripping leading zeroes
      crypto: algif_aead - fix reference counting of null skcipher
      crypto: af_alg - fix NULL pointer dereference in
      crypto: hmac - require that the underlying hash algorithm is unkeyed
      crypto: salsa20 - fix blkcipher_walk API usage
      crypto: chacha20 - Fix unaligned access when loading constants
      crypto: chacha20 - Use unaligned access macros when loading key and IV
      crypto: chacha20 - Remove cra_alignmask
      crypto: x86/chacha20 - Remove cra_alignmask
      crypto: chacha20 - Fix keystream alignment for chacha20_block()
      crypto: api - Unexport crypto_larval_lookup()
      crypto: null - Get rid of crypto_{get,put}_default_null_skcipher2()
      crypto: gf128mul - remove incorrect comment
      crypto: x86/twofish-3way - Fix %rbp usage
      crypto: algapi - convert cra_refcnt to refcount_t
      crypto: algapi - remove unused notifications
      crypto: poly1305 - use unaligned access macros to output digest
      crypto: poly1305 - remove cra_alignmask
      crypto: x86/poly1305 - remove cra_alignmask
      crypto: chacha20 - use rol32() macro from bitops.h
      crypto: hash - introduce crypto_hash_alg_has_setkey()
      crypto: cryptd - pass through absence of ->setkey()
      crypto: mcryptd - pass through absence of ->setkey()
      crypto: poly1305 - remove ->setkey() method
      crypto: hash - annotate algorithms taking optional key
      crypto: hash - prevent using keyed hashes without setting key
      crypto: ghash - remove checks for key being set
      crypto: skcipher - prevent using skciphers without setting key
      crypto: aead - prevent using AEADs without setting key
      crypto: salsa20-generic - cleanup and convert to skcipher API
      crypto: salsa20 - export generic helpers
      crypto: x86/salsa20 - cleanup and convert to skcipher API

Fabien DESSENNE (2):
      dt-bindings: Document STM32 CRYP bindings
      crypto: stm32 - Support for STM32 CRYP crypto module

Florian Fainelli (12):
      hwrng: bcm2835 - Obtain base register via resource
      hwrng: bcm2835 - Define a driver private context
      hwrng: bcm2835 - Move enabling to hwrng::init
      hwrng: bcm2835 - Implementation cleanup callback
      hwrng: bcm2835 - Use device managed helpers
      hwrng: bcm2835 - Rework interrupt masking
      hwrng: bcm2835 - Manage an optional clock
      hwrng: bcm2835 - Abstract I/O accessors
      hwrng: bcm2835 - Add Broadcom MIPS I/O accessors
      dt-bindings: rng: Incorporate brcm,bcm6368.txt binding
      hwrng: bcm2835 - Enable BCM2835 RNG to work on BCM63xx platforms
      hwrng: bcm63xx - Remove since bcm2835-rng takes over

Gary R Hook (1):
      hwrng: core - Clean up RNG list when last hwrng is unregistered

Geert Uytterhoeven (1):
      crypto: keywrap - Add missing ULL suffixes for 64-bit constants

Gilad Ben-Yossef (7):
      dt-bindings: add device tree binding for Arm TrustZone CryptoCell crypto engine
      crypto: tcrypt - use multi buf for ahash mb test
      crypto: tcrypt - fix AEAD decryption speed test
      crypto: tcrypt - allow setting num of bufs
      crypto: tcrypt - add multi buf ahash jiffies test
      crypto: tcrypt - add multibuf skcipher speed test
      crypto: tcrypt - add multibuf aead speed test

Gomonovych, Vasyl (1):
      crypto: arm/aes-neonbs - Use PTR_ERR_OR_ZERO()

Harsh Jain (6):
      crypto: chelsio - Fix Indentation
      crypto: chelsio - check for sg null
      crypto: chelsio - Fix IV updated in XTS operation
      crypto: chelsio - Add authenc versions of ctr and sha
      crypto: chelsio - Remove dst sg size zero check
      crypto: chelsio - Fix indentation warning

Hauke Mehrtens (1):
      crypto: ecdh - fix typo in KPP dependency of CRYPTO_ECDH

Herbert Xu (1):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

Himanshu Jha (1):
      crypto: Use zeroing memory allocator instead of allocator/memset

Horia Geantă (5):
      crypto: caam/qi - use correct print specifier for size_t
      crypto: caam - constify key data
      crypto: caam - remove needless ablkcipher key copy
      crypto: caam - save Era in driver's private data
      crypto: caam - add Derived Key Protocol (DKP) support

Joey Pabalinas (1):
      crypto: testmgr - change `guard` to unsigned char

Jon Maxwell (1):
      crypto: cryptd - Add cryptd_max_cpu_qlen module parameter

Junaid Shahid (2):
      crypto: aesni - Fix out-of-bounds access of the data buffer in generic-gcm-aesni
      crypto: aesni - Fix out-of-bounds access of the AAD buffer in generic-gcm-aesni

Kamil Konieczny (2):
      MAINTAINERS: Add myself as co-maintainer for s5p-sss.c
      crypto: testmgr - test misuse of result in ahash

Krzysztof Kozlowski (2):
      crypto: exynos-rng - Add SPDX license identifier and correct module license
      crypto: s5p-sss - Add SPDX license identifier

Lars Persson (1):
      crypto: artpec6 - set correct iv size for gcm(aes)

Martin Kaiser (1):
      hwrng: imx-rngc - simplify the power management definitions

Martin Kepplinger (1):
      crypto: replace FSF address with web source in license notices

Ofer Heifetz (4):
      crypto: inside-secure - refrain from unneeded invalidations
      crypto: inside-secure - EBUSY is not an error on async request
      crypto: inside-secure - move cipher crypto mode to request context
      crypto: inside-secure - remove unused parameter in invalidate_cache

Pierre (1):
      crypto: ecc - Fix NULL pointer deref. on no default_rng

Pravin Shedge (1):
      crypto: drivers - remove duplicate includes

Robert Baronescu (1):
      crypto: tcrypt - fix S/G table for test_aead_speed()

Robin Murphy (1):
      crypto: marvell/cesa - Fix DMA API misuse

Sabrina Dubroca (2):
      crypto: aesni - fix typo in generic_gcmaes_decrypt
      crypto: aesni - add wrapper for generic gcm(aes)

Sean Wang (1):
      hwrng: mediatek - Setup default RNG quality

Stephan Mueller (2):
      crypto: af_alg - whitelist mask and type
      crypto: aesni - handle zero length dst buffer

Tudor-Dan Ambarus (1):
      crypto: tcrypt - set assoc in sg_init_aead()

Yang Shi (1):
      crypto: remove unused hardirq.h

Zhou Wang (1):
      crypto: scomp - delete unused comments

tcharding (1):
      crypto: doc - clear htmldocs build warnings for crypto/hash

weiyongjun \(A\) (4):
      hwrng: exynos - remove redundant dev_err call in exynos_trng_probe()
      crypto: axis - remove unnecessary platform_get_resource() error check
      crypto: stm32 - remove redundant dev_err call in stm32_cryp_probe()
      hwrng: bcm2835 - Remove redundant dev_err call in bcm2835_rng_probe()

Łukasz Stelmach (6):
      crypto: exynos - Icrease the priority of the driver
      crypto: exynos - Support Exynos5250+ SoCs
      crypto: exynos - Improve performance of PRNG
      crypto: exynos - Reseed PRNG after generating 2^16 random bytes
      crypto: exynos - Introduce mutex to prevent concurrent access to hardware
      hwrng: exynos - add Samsung Exynos True RNG driver

 .../devicetree/bindings/crypto/arm-cryptocell.txt  |   22 +
 .../bindings/crypto/inside-secure-safexcel.txt     |    3 +-
 .../bindings/crypto/samsung,exynos-rng4.txt        |    4 +-
 .../devicetree/bindings/crypto/st,stm32-cryp.txt   |   19 +
 .../devicetree/bindings/rng/brcm,bcm2835.txt       |   22 +-
 .../devicetree/bindings/rng/brcm,bcm6368.txt       |   17 -
 MAINTAINERS                                        |    8 +
 arch/arm/crypto/aes-neonbs-glue.c                  |   10 +-
 arch/arm/crypto/crc32-ce-glue.c                    |    2 +
 arch/arm64/crypto/Kconfig                          |   18 +
 arch/arm64/crypto/Makefile                         |   11 +-
 arch/arm64/crypto/aes-ce-core.S                    |   87 ++
 .../crypto/{aes-ce-cipher.c => aes-ce-glue.c}      |  115 +-
 arch/arm64/crypto/aes-cipher-core.S                |   19 +-
 arch/arm64/crypto/aes-glue.c                       |    1 +
 arch/arm64/crypto/aes-neon.S                       |    8 +-
 arch/arm64/crypto/crc32-ce-core.S                  |    7 +-
 arch/arm64/crypto/crc32-ce-glue.c                  |    2 +
 arch/arm64/crypto/crct10dif-ce-core.S              |   17 +-
 arch/arm64/crypto/sha1-ce-core.S                   |   20 +-
 arch/arm64/crypto/sha2-ce-core.S                   |    4 +-
 arch/arm64/crypto/sha3-ce-core.S                   |  210 ++++
 arch/arm64/crypto/sha3-ce-glue.c                   |  161 +++
 arch/arm64/crypto/sha512-ce-core.S                 |  204 ++++
 arch/arm64/crypto/sha512-ce-glue.c                 |  119 ++
 arch/arm64/crypto/sha512-glue.c                    |    1 +
 arch/arm64/crypto/sm3-ce-core.S                    |  141 +++
 arch/arm64/crypto/sm3-ce-glue.c                    |   92 ++
 arch/powerpc/crypto/crc32c-vpmsum_glue.c           |    1 +
 arch/s390/crypto/crc32-vx.c                        |    3 +
 arch/sparc/crypto/crc32c_glue.c                    |    1 +
 arch/x86/crypto/aesni-intel_asm.S                  |  199 +---
 arch/x86/crypto/aesni-intel_glue.c                 |   70 +-
 arch/x86/crypto/chacha20_glue.c                    |    1 -
 arch/x86/crypto/crc32-pclmul_glue.c                |    1 +
 arch/x86/crypto/crc32c-intel_glue.c                |    1 +
 arch/x86/crypto/poly1305_glue.c                    |    2 -
 arch/x86/crypto/salsa20-i586-asm_32.S              |  184 +--
 arch/x86/crypto/salsa20-x86_64-asm_64.S            |  114 --
 arch/x86/crypto/salsa20_glue.c                     |  110 +-
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S       |  112 +-
 crypto/Kconfig                                     |    4 +-
 crypto/Makefile                                    |    1 +
 crypto/ablk_helper.c                               |    5 +-
 crypto/aead.c                                      |   19 +-
 crypto/af_alg.c                                    |   23 +-
 crypto/ahash.c                                     |   33 +-
 crypto/algapi.c                                    |   13 +-
 crypto/algif_aead.c                                |   15 +-
 crypto/algif_hash.c                                |   52 +-
 crypto/algif_skcipher.c                            |   59 +-
 crypto/api.c                                       |    6 +-
 crypto/authenc.c                                   |    4 +-
 crypto/authencesn.c                                |    4 +-
 crypto/blkcipher.c                                 |    1 -
 crypto/camellia_generic.c                          |    3 +-
 crypto/cast5_generic.c                             |    3 +-
 crypto/cast6_generic.c                             |    3 +-
 crypto/chacha20_generic.c                          |   33 +-
 crypto/crc32_generic.c                             |    1 +
 crypto/crc32c_generic.c                            |    1 +
 crypto/cryptd.c                                    |   17 +-
 crypto/crypto_user.c                               |    4 +-
 crypto/ecc.c                                       |    2 +-
 crypto/echainiv.c                                  |    5 -
 crypto/gcm.c                                       |    4 +-
 crypto/gf128mul.c                                  |    2 -
 crypto/ghash-generic.c                             |    6 -
 crypto/hmac.c                                      |    6 +-
 crypto/internal.h                                  |    8 +-
 crypto/keywrap.c                                   |    4 +-
 crypto/mcryptd.c                                   |   11 +-
 crypto/poly1305_generic.c                          |   27 +-
 crypto/proc.c                                      |    2 +-
 crypto/rsa_helper.c                                |    2 +-
 crypto/salsa20_generic.c                           |  245 ++--
 crypto/seqiv.c                                     |    5 -
 crypto/sha3_generic.c                              |  332 +++---
 crypto/shash.c                                     |   30 +-
 crypto/simd.c                                      |    4 +-
 crypto/skcipher.c                                  |   30 +-
 crypto/tcrypt.c                                    | 1085 ++++++++++++++++--
 crypto/testmgr.c                                   |   41 +-
 crypto/testmgr.h                                   |  550 +++++++++
 crypto/twofish_common.c                            |    5 +-
 crypto/twofish_generic.c                           |    5 +-
 crypto/xcbc.c                                      |    3 +-
 drivers/char/hw_random/Kconfig                     |   32 +-
 drivers/char/hw_random/Makefile                    |    2 +-
 drivers/char/hw_random/bcm2835-rng.c               |  169 ++-
 drivers/char/hw_random/bcm63xx-rng.c               |  154 ---
 drivers/char/hw_random/core.c                      |    4 +
 drivers/char/hw_random/exynos-trng.c               |  235 ++++
 drivers/char/hw_random/imx-rngc.c                  |   13 +-
 drivers/char/hw_random/mtk-rng.c                   |    1 +
 drivers/char/random.c                              |   24 +-
 drivers/crypto/Kconfig                             |    1 -
 drivers/crypto/amcc/crypto4xx_alg.c                |    6 +-
 drivers/crypto/amcc/crypto4xx_core.c               |  131 ++-
 drivers/crypto/amcc/crypto4xx_core.h               |    4 +-
 drivers/crypto/amcc/crypto4xx_reg_def.h            |    4 +-
 drivers/crypto/amcc/crypto4xx_trng.c               |    2 +-
 drivers/crypto/axis/artpec6_crypto.c               |    8 +-
 drivers/crypto/bcm/cipher.c                        |    1 -
 drivers/crypto/bfin_crc.c                          |    3 +-
 drivers/crypto/caam/caamalg.c                      |  120 +-
 drivers/crypto/caam/caamalg_desc.c                 |  182 +--
 drivers/crypto/caam/caamalg_desc.h                 |   10 +-
 drivers/crypto/caam/caamalg_qi.c                   |   68 +-
 drivers/crypto/caam/caamhash.c                     |   73 +-
 drivers/crypto/caam/ctrl.c                         |    4 +-
 drivers/crypto/caam/desc.h                         |   29 +
 drivers/crypto/caam/desc_constr.h                  |   51 +-
 drivers/crypto/caam/intern.h                       |    1 +
 drivers/crypto/caam/key_gen.c                      |   30 -
 drivers/crypto/caam/key_gen.h                      |   30 +
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c       |    3 +-
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c       |    1 -
 drivers/crypto/ccp/ccp-crypto-aes-galois.c         |    1 -
 drivers/crypto/chelsio/Kconfig                     |   10 +
 drivers/crypto/chelsio/Makefile                    |    1 +
 drivers/crypto/chelsio/chcr_algo.c                 |  540 +++++----
 drivers/crypto/chelsio/chcr_algo.h                 |   15 -
 drivers/crypto/chelsio/chcr_core.c                 |   14 +
 drivers/crypto/chelsio/chcr_core.h                 |   38 +
 drivers/crypto/chelsio/chcr_crypto.h               |   76 +-
 drivers/crypto/chelsio/chcr_ipsec.c                |  654 +++++++++++
 drivers/crypto/exynos-rng.c                        |  108 +-
 drivers/crypto/hifn_795x.c                         |    1 +
 drivers/crypto/inside-secure/safexcel.c            |  370 ++++---
 drivers/crypto/inside-secure/safexcel.h            |  173 ++-
 drivers/crypto/inside-secure/safexcel_cipher.c     |   53 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |  125 ++-
 drivers/crypto/ixp4xx_crypto.c                     |    7 +-
 drivers/crypto/marvell/cesa.c                      |   19 +-
 drivers/crypto/nx/nx-842-powernv.c                 |    4 +-
 drivers/crypto/picoxcell_crypto.c                  |   27 +-
 drivers/crypto/qat/qat_common/qat_hal.c            |  133 +--
 drivers/crypto/s5p-sss.c                           |   26 +-
 drivers/crypto/stm32/Kconfig                       |   13 +-
 drivers/crypto/stm32/Makefile                      |    5 +-
 drivers/crypto/stm32/stm32-cryp.c                  | 1170 ++++++++++++++++++++
 drivers/crypto/stm32/stm32_crc32.c                 |    2 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   23 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |    2 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c     |    1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |    3 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |  102 +-
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      |    7 +
 .../lustre/lnet/libcfs/linux/linux-crypto-adler.c  |    1 +
 include/crypto/aead.h                              |   10 +-
 include/crypto/chacha20.h                          |    3 +-
 include/crypto/hash.h                              |   46 +-
 include/crypto/internal/hash.h                     |   10 +
 include/crypto/internal/scompress.h                |   11 -
 include/crypto/null.h                              |   10 -
 include/crypto/poly1305.h                          |    2 -
 include/crypto/salsa20.h                           |   27 +
 include/crypto/sha3.h                              |    6 +-
 include/crypto/skcipher.h                          |   11 +-
 include/linux/crypto.h                             |   10 +-
 kernel/padata.c                                    |    1 +
 lib/chacha20.c                                     |   71 +-
 164 files changed, 7495 insertions(+), 2706 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
