From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.10
Date: Tue, 13 Dec 2016 21:24:14 +0800
Message-ID: <20161213132414.GA7898@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58113 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932567AbcLMNYd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2016 08:24:33 -0500
Content-Disposition: inline
In-Reply-To: <20161119102748.GA4277@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

Here is the crypto update for 4.10:

API:

- Add skcipher walk interface.
- Add asynchronous compression (acomp) interface.
- Fix algif_aed AIO handling of zero buffer.

Algorithms:

- Fix unaligned access in poly1305.
- Fix DRBG output to large buffers.

Drivers:

- Add support for iMX6UL to caam.
- Fix givenc descriptors (used by IPsec) in caam.
- Accelerated SHA256/SHA512 for ARM64 from OpenSSL.
- Add SSE CRCT10DIF and CRC32 to ARM/ARM64.
- Add AEAD support to Chelsio chcr.
- Add Armada 8K support to omap-rng.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Alec Ari (1):
      crypto: api - Fix Kconfig dependencies for FIPS

Alex Cope (2):
      crypto: gf128mul - remove dead gf128mul_64k_lle code
      crypto: gf128mul - Zero memory when freeing multiplication table

Alex Porosanu (1):
      crypto: caam - fix AEAD givenc descriptors

Ard Biesheuvel (21):
      crypto: arm64/aes-ce - fix for big endian
      crypto: arm64/ghash-ce - fix for big endian
      crypto: arm64/sha1-ce - fix for big endian
      crypto: arm64/sha2-ce - fix for big endian
      crypto: arm64/aes-ccm-ce: fix for big endian
      crypto: arm64/aes-neon - fix for big endian
      crypto: arm64/aes-xts-ce: fix for big endian
      crypto: arm/aes-ce - fix for big endian
      crypto: arm64/sha2 - integrate OpenSSL implementations of SHA256/SHA512
      crypto: arm64/sha2 - add generated .S files to .gitignore
      crypto: arm/aes-ce - fix broken monolithic build
      crypto: skcipher - fix crash in skcipher_walk_aead()
      crypto: arm64/aes-ce-ctr - fix skcipher conversion
      crypto: arm/aesbs - fix brokenness after skcipher conversion
      crypto: testmgr - avoid overlap in chunked tests
      crypto: testmgr - add/enhance test cases for CRC-T10DIF
      crypto: arm64/crct10dif - port x86 SSE implementation to arm64
      crypto: arm/crct10dif - port x86 SSE implementation to ARM
      crypto: arm64/crc32 - accelerated support based on x86 SSE implementation
      crypto: arm/crc32 - accelerated support based on x86 SSE implementation
      crypto: testmgr - fix overlap in chunked tests again

Arnd Bergmann (3):
      crypto: caam - fix type mismatch warning
      crypto: caam - pass key buffers with typesafe pointers
      crypto: caam - make aamalg_desc a proper module

Baruch Siach (4):
      crypto: api - fix comment typo
      crypto: doc - fix header file name
      crypt: doc - remove misleading mention of async API
      MAINTAINERS: add crypto headers to crypto entry

Christophe Jaillet (1):
      crypto: crypto4xx - Fix size used in dma_free_coherent()

Colin Ian King (2):
      crypto: sahara - fix typo "Decidated" -> "Dedicated"
      crypto: talitos - fix spelling mistake

Cyrille Pitchen (2):
      crypto: atmel-aes - fix compiler error when VERBOSE_DEBUG is defined
      crypto: atmel-aes - add support to the XTS mode

Dan Carpenter (1):
      crypto: chcr - checking for IS_ERR() instead of NULL

Eric Biggers (7):
      crypto: skcipher - Remove unused crypto_lookup_skcipher() declaration
      crypto: api - Remove no-op exit_ops code
      crypto: cmac - return -EINVAL if block size is unsupported
      crypto: cmac - fix alignment of 'consts'
      crypto: skcipher - Get rid of crypto_grab_skcipher2()
      crypto: skcipher - Get rid of crypto_spawn_skcipher2()
      crypto: testmgr - don't use stack buffer in test_acomp()

Gary R Hook (5):
      crypto: ccp - change type of struct member lsb to signed
      crypto: ccp - change bitfield type to unsigned ints
      crypto: ccp - remove unneeded code
      crypto: ccp - Clean up the LSB slot allocation code
      crypto: ccp - Fix handling of RSA exponent on a v5 device

Geliang Tang (2):
      crypto: jitterentropy - drop duplicate header module.h
      crypto: nx - drop duplicate header types.h

Giovanni Cabiddu (9):
      crypto: acomp - add asynchronous compression api
      crypto: acomp - add driver-side scomp interface
      crypto: acomp - add support for lzo via scomp
      crypto: acomp - add support for lz4 via scomp
      crypto: acomp - add support for lz4hc via scomp
      crypto: acomp - add support for 842 via scomp
      crypto: acomp - add support for deflate via scomp
      crypto: acomp - update testmgr with support for acomp
      crypto: acomp - fix dependency in Makefile

Greg Tucker (1):
      crypto: sha-mb - Fix total_len for correct hash when larger than 512MB

Harsh Jain (9):
      crypto: chcr - Cosmetic change
      crypto: chcr - Added new structure chcr_wr
      crypto: chcr - Fixes Unchecked dereference inside function
      crypto: chcr - Remove dynamic allocation
      crypto: chcr - Calculate Reverse round key in setkey callback.
      crypto: chcr - Adjust Dest. buffer size
      crypto: chcr - Use SHASH_DESC_ON_STACK
      crypto: chcr - Move tfm ctx variable to request context
      crypto: chcr - Add AEAD algos.

Herbert Xu (22):
      crypto: skcipher - Add skcipher walk interface
      crypto: aes-ce-ccm - Use skcipher walk interface
      crypto: lrw - Convert to skcipher
      crypto: xts - Convert to skcipher
      crypto: api - Do not clear type bits in crypto_larval_lookup
      crypto: cryptd - Add support for skcipher
      crypto: simd - Add simd skcipher helper
      crypto: pcbc - Convert to skcipher
      crypto: glue_helper - Add skcipher xts helpers
      crypto: testmgr - Do not test internal algorithms
      crypto: aesni - Convert to skcipher
      crypto: arm64/aes - Convert to skcipher
      crypto: aes-ce - Convert to skcipher
      crypto: cbc - Convert to skcipher
      crypto: cbc - Export CBC implementation
      crypto: aesbs - Convert to skcipher
      crypto: arm/aes - Select SIMD in Kconfig
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
      crypto: arm/aes - Add missing SIMD select for aesbs
      crypto: skcipher - Add separate walker for AEAD decryption
      crypto: arm64/aes-ce-ccm - Fix AEAD decryption length
      crypto: aes-ce - Make aes_simd_algs static

Horia Geantă (23):
      crypto: caam - completely remove error propagation handling
      crypto: caam - desc.h fixes
      crypto: caam - fix sparse warnings
      crypto: caam - fix smatch warnings
      crypto: caam - remove unused may_sleep in dbg_dump_sg()
      crypto: caam - remove unused command from aead givencrypt
      crypto: caam - trivial code clean-up
      crypto: caam - remove unreachable code in report_ccb_status()
      crypto: caam - fix DMA API mapping leak in ablkcipher code
      Revert "crypto: caam - get rid of tasklet"
      crypto: caam - move sec4_sg_entry to sg_sw_sec4.h
      crypto: caam - constify pointer to descriptor buffer
      crypto: caam - merge identical ahash_final/finup shared desc
      crypto: caam - move append_key_aead() into init_sh_desc_key_aead()
      crypto: caam - group algorithm related params
      crypto: caam - remove superfluous alg_op algorithm param
      crypto: caam - improve key inlining
      crypto: caam - rewrite some generic inline append cmds
      crypto: caam - remove unneded dependencies on CRYPTO_DEV_FSL_CAAM
      crypto: caam - refactor encryption descriptors generation
      crypto: caam - consolidate split key length computation
      crypto: caam - refactor ahash shared descriptor generation
      MAINTAINERS: add maintainers for caam crypto driver

Jason A. Donenfeld (1):
      crypto: poly1305 - Use unaligned access where required

Javier Martinez Canillas (2):
      hwrng: meson - Fix module autoload for OF registration
      hwrng: meson - Remove unneeded platform MODULE_ALIAS

Jean Delvare (1):
      crypto: crc32c-vpmsum - Rename CRYPT_CRC32C_VPMSUM option

Marcus Folkesson (2):
      crypto: caam - add support for iMX6UL
      crypto: caam - check caam_emi_slow instead of re-lookup platform

Mat Martineau (1):
      crypto: dh - Consistenly return negative error codes

Nadim almas (1):
      Crypto: mv_cesa - Switch to using managed resources

Naveen N. Rao (1):
      crypto: vmx - various build fixes

Pan Bian (1):
      crypto: algif_skcipher - set error code when kcalloc fails

Paul Bolle (1):
      crypto: ccp - fix typo "CPP"

Petr Mladek (1):
      crypto: engine - Handle the kthread worker using the new API

PrasannaKumar Muralidharan (1):
      hwrng: Make explicit that max >= 32 always

Romain Perier (10):
      dt-bindings: Add vendor prefix for INSIDE Secure
      dt-bindings: omap-rng: Document SafeXcel IP-76 device variant
      hwrng: omap - Switch to non-obsolete read API implementation
      hwrng: omap - Remove global definition of hwrng
      hwrng: omap - Add support for 128-bit output of data
      hwrng: omap - Don't prefix the probe message with OMAP
      hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K
      arm64: dts: marvell: add TRNG description for Armada 8K CP
      crypto: marvell - Use an unique pool to copy results of requests
      crypto: marvell - Don't break chain for computable last ahash requests

Stephan Mueller (3):
      hwrng: core - zeroize buffers with random data
      crypto: drbg - advance output buffer pointer
      crypto: algif_aead - fix AIO handling of zero buffer

Tobias Klauser (2):
      padata: Remove unused but set variables
      crypto: cryptd - Remove unused but set variable 'tfm'

Wei Yongjun (4):
      crypto: ccp - Fix non static symbol warning
      crypto: gcm - Fix error return code in crypto_gcm_create_common()
      crypto: atmel - drop pointless static qualifier in atmel_aes_probe()
      hwrng: atmel - use clk_disable_unprepare instead of clk_disable

Wenyou Yang (1):
      hwrng: atmel - disable TRNG during suspend

 Documentation/crypto/api-intro.txt                 |    5 +-
 .../devicetree/bindings/crypto/fsl-sec4.txt        |   20 +
 Documentation/devicetree/bindings/rng/omap_rng.txt |   14 +-
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 MAINTAINERS                                        |    9 +
 arch/arm/crypto/Kconfig                            |   18 +-
 arch/arm/crypto/Makefile                           |    4 +
 arch/arm/crypto/aes-ce-glue.c                      |  395 ++--
 arch/arm/crypto/aesbs-glue.c                       |  380 ++--
 arch/arm/crypto/crc32-ce-core.S                    |  306 +++
 arch/arm/crypto/crc32-ce-glue.c                    |  242 +++
 arch/arm/crypto/crct10dif-ce-core.S                |  427 ++++
 arch/arm/crypto/crct10dif-ce-glue.c                |  101 +
 .../boot/dts/marvell/armada-cp110-master.dtsi      |    8 +
 .../arm64/boot/dts/marvell/armada-cp110-slave.dtsi |    8 +
 arch/arm64/crypto/.gitignore                       |    2 +
 arch/arm64/crypto/Kconfig                          |   23 +-
 arch/arm64/crypto/Makefile                         |   23 +
 arch/arm64/crypto/aes-ce-ccm-core.S                |   53 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c                |   50 +-
 arch/arm64/crypto/aes-ce-cipher.c                  |   25 +-
 arch/arm64/crypto/aes-ce.S                         |    1 +
 arch/arm64/crypto/aes-glue.c                       |  381 ++--
 arch/arm64/crypto/aes-modes.S                      |    3 +-
 arch/arm64/crypto/aes-neon.S                       |   25 +-
 arch/arm64/crypto/crc32-ce-core.S                  |  266 +++
 arch/arm64/crypto/crc32-ce-glue.c                  |  212 ++
 arch/arm64/crypto/crct10dif-ce-core.S              |  392 ++++
 arch/arm64/crypto/crct10dif-ce-glue.c              |   95 +
 arch/arm64/crypto/ghash-ce-core.S                  |    6 +-
 arch/arm64/crypto/sha1-ce-core.S                   |    4 +-
 arch/arm64/crypto/sha2-ce-core.S                   |    4 +-
 arch/arm64/crypto/sha256-core.S_shipped            | 2061 ++++++++++++++++++++
 arch/arm64/crypto/sha256-glue.c                    |  185 ++
 arch/arm64/crypto/sha512-armv8.pl                  |  778 ++++++++
 arch/arm64/crypto/sha512-core.S_shipped            | 1085 +++++++++++
 arch/arm64/crypto/sha512-glue.c                    |   94 +
 arch/powerpc/crypto/Makefile                       |    2 +-
 arch/x86/crypto/aesni-intel_glue.c                 |  705 +++----
 arch/x86/crypto/fpu.c                              |  207 +-
 arch/x86/crypto/glue_helper.c                      |   74 +-
 arch/x86/crypto/sha1-mb/sha1_mb.c                  |    2 +-
 arch/x86/crypto/sha1-mb/sha1_mb_ctx.h              |    2 +-
 arch/x86/crypto/sha256-mb/sha256_mb.c              |    2 +-
 arch/x86/crypto/sha256-mb/sha256_mb_ctx.h          |    2 +-
 arch/x86/crypto/sha512-mb/sha512_mb.c              |    2 +-
 arch/x86/crypto/sha512-mb/sha512_mb_ctx.h          |    2 +-
 arch/x86/include/asm/crypto/glue_helper.h          |   39 +-
 crypto/842.c                                       |   81 +-
 crypto/Kconfig                                     |   32 +-
 crypto/Makefile                                    |    6 +
 crypto/acompress.c                                 |  169 ++
 crypto/algboss.c                                   |    8 +-
 crypto/algif_aead.c                                |    5 +-
 crypto/algif_skcipher.c                            |    4 +-
 crypto/api.c                                       |   22 +-
 crypto/authenc.c                                   |    8 +-
 crypto/authencesn.c                                |    8 +-
 crypto/cbc.c                                       |  269 +--
 crypto/ccm.c                                       |    8 +-
 crypto/chacha20poly1305.c                          |    8 +-
 crypto/cipher.c                                    |    4 -
 crypto/cmac.c                                      |   14 +-
 crypto/compress.c                                  |    4 -
 crypto/cryptd.c                                    |  286 ++-
 crypto/crypto_engine.c                             |   26 +-
 crypto/crypto_user.c                               |   19 +
 crypto/ctr.c                                       |    8 +-
 crypto/cts.c                                       |    8 +-
 crypto/deflate.c                                   |  111 +-
 crypto/dh.c                                        |    2 +-
 crypto/drbg.c                                      |    1 +
 crypto/gcm.c                                       |   10 +-
 crypto/gf128mul.c                                  |   59 +-
 crypto/internal.h                                  |    3 -
 crypto/jitterentropy-kcapi.c                       |    1 -
 crypto/lrw.c                                       |  507 +++--
 crypto/lz4.c                                       |   91 +-
 crypto/lz4hc.c                                     |   92 +-
 crypto/lzo.c                                       |   97 +-
 crypto/pcbc.c                                      |  201 +-
 crypto/poly1305_generic.c                          |   34 +-
 crypto/scompress.c                                 |  356 ++++
 crypto/simd.c                                      |  226 +++
 crypto/skcipher.c                                  |  540 +++++
 crypto/testmgr.c                                   |  318 +--
 crypto/testmgr.h                                   |   70 +-
 crypto/xts.c                                       |  547 ++++--
 drivers/char/hw_random/Kconfig                     |    2 +-
 drivers/char/hw_random/atmel-rng.c                 |   26 +-
 drivers/char/hw_random/core.c                      |    3 +
 drivers/char/hw_random/meson-rng.c                 |    2 +-
 drivers/char/hw_random/msm-rng.c                   |    4 -
 drivers/char/hw_random/omap-rng.c                  |  162 +-
 drivers/char/hw_random/pic32-rng.c                 |    3 -
 drivers/char/hw_random/pseries-rng.c               |    5 +-
 drivers/crypto/amcc/crypto4xx_core.c               |    3 +-
 drivers/crypto/atmel-aes-regs.h                    |    4 +
 drivers/crypto/atmel-aes.c                         |  189 +-
 drivers/crypto/caam/Kconfig                        |   11 +-
 drivers/crypto/caam/Makefile                       |    1 +
 drivers/crypto/caam/caamalg.c                      | 1505 +++-----------
 drivers/crypto/caam/caamalg_desc.c                 | 1306 +++++++++++++
 drivers/crypto/caam/caamalg_desc.h                 |   97 +
 drivers/crypto/caam/caamhash.c                     |  227 +--
 drivers/crypto/caam/caampkc.c                      |    4 +-
 drivers/crypto/caam/caamrng.c                      |   10 +-
 drivers/crypto/caam/ctrl.c                         |   75 +-
 drivers/crypto/caam/desc.h                         |   22 +-
 drivers/crypto/caam/desc_constr.h                  |  133 +-
 drivers/crypto/caam/error.c                        |    5 +-
 drivers/crypto/caam/intern.h                       |    1 +
 drivers/crypto/caam/jr.c                           |   27 +-
 drivers/crypto/caam/key_gen.c                      |   62 +-
 drivers/crypto/caam/key_gen.h                      |    6 +-
 drivers/crypto/caam/sg_sw_sec4.h                   |    6 +-
 drivers/crypto/ccp/ccp-dev-v3.c                    |    4 -
 drivers/crypto/ccp/ccp-dev-v5.c                    |   30 +-
 drivers/crypto/ccp/ccp-dev.c                       |    6 +-
 drivers/crypto/ccp/ccp-dev.h                       |   45 +-
 drivers/crypto/chelsio/Kconfig                     |    1 +
 drivers/crypto/chelsio/chcr_algo.c                 | 2001 ++++++++++++++++---
 drivers/crypto/chelsio/chcr_algo.h                 |  103 +-
 drivers/crypto/chelsio/chcr_core.c                 |    8 +-
 drivers/crypto/chelsio/chcr_core.h                 |   18 +-
 drivers/crypto/chelsio/chcr_crypto.h               |  115 +-
 drivers/crypto/marvell/cesa.c                      |    4 -
 drivers/crypto/marvell/cesa.h                      |    5 +-
 drivers/crypto/marvell/cipher.c                    |    8 +-
 drivers/crypto/marvell/hash.c                      |   65 +-
 drivers/crypto/marvell/tdma.c                      |   33 +-
 drivers/crypto/mv_cesa.c                           |    4 +-
 drivers/crypto/nx/nx.c                             |    1 -
 drivers/crypto/sahara.c                            |    2 +-
 drivers/crypto/talitos.c                           |    2 +-
 drivers/crypto/vmx/Makefile                        |   12 +-
 include/crypto/acompress.h                         |  269 +++
 include/crypto/cbc.h                               |  146 ++
 include/crypto/cryptd.h                            |   13 +-
 include/crypto/engine.h                            |    6 +-
 include/crypto/gf128mul.h                          |   15 +-
 include/crypto/internal/acompress.h                |   81 +
 include/crypto/internal/scompress.h                |  136 ++
 include/crypto/internal/simd.h                     |   17 +
 include/crypto/internal/skcipher.h                 |   65 +-
 include/crypto/xts.h                               |   26 +-
 include/linux/ccp.h                                |    6 +-
 include/linux/crypto.h                             |    5 +-
 include/linux/hw_random.h                          |    3 +-
 include/uapi/linux/cryptouser.h                    |    5 +
 kernel/padata.c                                    |    4 -
 151 files changed, 15711 insertions(+), 4462 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
