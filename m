Return-Path: <SRS0=1Cfx=ZR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8440BC432C3
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 03:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14B9620748
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Nov 2019 03:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKYDpo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Nov 2019 22:45:44 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:36894 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfKYDpo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Nov 2019 22:45:44 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iZ5Jj-0002Rm-OL; Mon, 25 Nov 2019 11:45:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iZ5Jg-0006Dg-IA; Mon, 25 Nov 2019 11:45:36 +0800
Date:   Mon, 25 Nov 2019 11:45:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 5.5
Message-ID: <20191125034536.wlgw25gpgn7y7vni@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190916084901.GA20338@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

API:

- Add library interfaces of certain crypto algorithms for WireGuard.
- Remove the obsolete ablkcipher and blkcipher interfaces.
- Move add_early_randomness() out of rng_mutex.

Algorithms:

- Add blake2b shash algorithm.
- Add blake2s shash algorithm.
- Add curve25519 kpp algorithm.
- Implement 4 way interleave in arm64/gcm-ce.
- Implement ciphertext stealing in powerpc/spe-xts.
- Add Eric Biggers's scalar accelerated ChaCha code for ARM.
- Add accelerated 32r2 code from Zinc for MIPS.
- Add OpenSSL/CRYPTOGRAMS poly1305 implementation for ARM and MIPS.
 
Drivers:
 
- Fix entropy reading failures in ks-sa.
- Add support for sam9x60 in atmel.
- Add crypto accelerator for amlogic GXL.
- Add sun8i-ce Crypto Engine.
- Add sun8i-ss cryptographic offloader.
- Add a host of algorithms to inside-secure.
- Add NPCM RNG driver.
- add HiSilicon HPRE accelerator.
- Add HiSilicon TRNG driver.

Please note that there is a conflict with mainline due to the
modification of arch/arm/crypto/Kconfig by the crypto tree for
v5.4.  The resolution should be fairly trivial though.

The following changes since commit 54ecb8f7028c5eb3d740bb82b0f1d90f2df63c5c:

  Linux 5.4-rc1 (2019-09-30 10:35:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git 

for you to fetch changes up to 4ee812f6143d78d8ba1399671d78c8d78bf2817c:

  crypto: vmx - Avoid weird build failures (2019-11-22 18:48:39 +0800)

----------------------------------------------------------------
Alexander E. Patrakov (1):
      crypto: jitter - fix comments

Alexander Sverdlin (1):
      hwrng: ks-sa - Add minimum sleep time before ready-polling

Andrey Smirnov (6):
      crypto: caam - use devres to unmap memory
      crypto: caam - use devres to remove debugfs
      crypto: caam - use devres to de-initialize the RNG
      crypto: caam - use devres to de-initialize QI
      crypto: caam - use devres to populate platform devices
      crypto: caam - populate platform devices last

Ard Biesheuvel (66):
      crypto: testmgr - add another gcm(aes) testcase
      crypto: arm64/gcm-ce - implement 4 way interleave
      crypto: aegis128-neon - use Clang compatible cflags for ARM
      crypto: aegis128/simd - build 32-bit ARM for v8 architecture explicitly
      crypto: geode-aes - switch to skcipher for cbc(aes) fallback
      crypto: arm - use Kconfig based compiler checks for crypto opcodes
      crypto: aegis128 - avoid function pointers for parameterization
      crypto: aegis128 - duplicate init() and final() hooks in SIMD code
      crypto: powerpc/spe-xts - implement support for ciphertext stealing
      crypto: ecdh - fix big endian bug in ECC library
      crypto: lib - tidy up lib/crypto Kconfig and Makefile
      crypto: chacha - move existing library code into lib/crypto
      crypto: x86/chacha - depend on generic chacha library instead of crypto driver
      crypto: x86/chacha - expose SIMD ChaCha routine as library function
      crypto: arm64/chacha - depend on generic chacha library instead of crypto driver
      crypto: arm64/chacha - expose arm64 ChaCha routine as library function
      crypto: arm/chacha - import Eric Biggers's scalar accelerated ChaCha code
      crypto: arm/chacha - remove dependency on generic ChaCha driver
      crypto: arm/chacha - expose ARM ChaCha routine as library function
      crypto: mips/chacha - wire up accelerated 32r2 code from Zinc
      crypto: chacha - unexport chacha_generic routines
      crypto: poly1305 - move core routines into a separate library
      crypto: x86/poly1305 - unify Poly1305 state struct with generic code
      crypto: poly1305 - expose init/update/final library interface
      crypto: x86/poly1305 - depend on generic library not generic shash
      crypto: x86/poly1305 - expose existing driver as poly1305 library
      crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation
      crypto: arm/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation
      crypto: mips/poly1305 - incorporate OpenSSL/CRYPTOGAMS optimized implementation
      int128: move __uint128_t compiler test to Kconfig
      crypto: testmgr - add test cases for Blake2s
      crypto: blake2s - implement generic shash driver
      crypto: curve25519 - add kpp selftest
      crypto: curve25519 - implement generic KPP driver
      crypto: lib/curve25519 - work around Clang stack spilling issue
      crypto: chacha20poly1305 - import construction and selftest from Zinc
      crypto: lib/chacha20poly1305 - reimplement crypt_from_sg() routine
      crypto: virtio - implement missing support for output IVs
      crypto: virtio - deal with unsupported input sizes
      crypto: virtio - switch to skcipher API
      crypto: ccp - switch from ablkcipher to skcipher
      crypto: omap - switch to skcipher API
      crypto: ux500 - switch to skcipher API
      crypto: s5p - switch to skcipher API
      crypto: atmel-aes - switch to skcipher API
      crypto: atmel-tdes - switch to skcipher API
      crypto: bcm-spu - switch to skcipher API
      crypto: nitrox - remove cra_type reference to ablkcipher
      crypto: cavium/cpt - switch to skcipher API
      crypto: chelsio - switch to skcipher API
      crypto: hifn - switch to skcipher API
      crypto: ixp4xx - switch to skcipher API
      crypto: mxs - switch to skcipher API
      crypto: mediatek - switch to skcipher API
      crypto: sahara - switch to skcipher API
      crypto: picoxcell - switch to skcipher API
      crypto: qce - switch to skcipher API
      crypto: stm32 - switch to skcipher API
      crypto: niagara2 - switch to skcipher API
      crypto: rockchip - switch to skcipher API
      crypto: talitos - switch to skcipher API
      crypto: qat - switch to skcipher API
      crypto: marvell/cesa - rename blkcipher to skcipher
      crypto: nx - remove stale comment referring to the blkcipher walk API
      crypto: ablkcipher - remove deprecated and unused ablkcipher support
      crypto: ccree - update a stale reference to ablkcipher

Arnd Bergmann (4):
      crypto: hisilicon - allow compile-testing on x86
      crypto: inside-secure - Fix a maybe-uninitialized warning
      crypto: inside-secure - Remove #ifdef checks
      hwrng: omap3-rom - Fix unused function warnings

Ashish Kalra (1):
      crypto: ccp - Retry SEV INIT command in case of integrity check failure.

Ayush Sawal (1):
      crypto: af_alg - cast ki_complete ternary op to int

Ben Dooks (2):
      crypto: jitter - add header to fix buildwarnings
      hwrng: ka-sa - fix __iomem on registers

Ben Dooks (Codethink) (1):
      crypto: atmel - fix data types for __be{32,64}

Brijesh Singh (1):
      crypto: ccp - add SEV command privilege separation

Chen Wandun (1):
      crypto: essiv - remove redundant null pointer check before kfree

Christian Lamparter (2):
      crypto: amcc - restore CRYPTO_AES dependency
      crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr

Christophe JAILLET (1):
      crypto: chtls - simplify a bit 'create_flowc_wr_skb()'

Christophe Leroy (1):
      crypto: talitos - fix hash result for VMAP_STACK

Chuhong Yuan (1):
      crypto: inside-secure - Add missed clk_disable_unprepare

Codrin Ciubotariu (2):
      dt-bindings: rng: atmel-trng: add new compatible
      hwrng: atmel - add new platform support for sam9x60

Colin Ian King (4):
      crypto: inside-secure - fix spelling mistake "algorithmn" -> "algorithm"
      crypto: mediatek - remove redundant bitwise-or
      crypto: amlogic - ensure error variable err is set before returning it
      crypto: allwinner - fix some spelling mistakes

Corentin Labbe (20):
      crypto: sun4i-ss - simplify enable/disable of the device
      crypto: sun4i-ss - enable pm_runtime
      dt-bindings: crypto: Add DT bindings documentation for amlogic-crypto
      MAINTAINERS: Add myself as maintainer of amlogic crypto
      crypto: amlogic - Add crypto accelerator for amlogic GXL
      crypto: allwinner - Add allwinner subdirectory
      crypto: allwinner - Add sun8i-ce Crypto Engine
      crypto: sun4i-ss - Move to Allwinner directory
      crypto: allwinner - Add sun8i-ss cryptographic offloader
      dt-bindings: crypto: Add DT bindings documentation for sun8i-ss Security System
      crypto: amlogic - fix two resources leak
      MAINTAINERS: add linux-amlogic list for amlogic crypto
      crypto: tcrypt - constify check alg list
      crypto: sun4i-ss - Fix 64-bit size_t warnings on sun4i-ss-hash.c
      crypto: sun4i-ss - remove dependency on not 64BIT
      crypto: sun4i-ss - use crypto_ahash_digestsize
      crypto: sun4i-ss - hide the Invalid keylen message
      crypto: sun4i-ss - fix big endian issues
      crypto: sun8i-ce - enable working on big endian
      crypto: amlogic - enable working on big endian kernel

David Sterba (9):
      crypto: blake2b - add blake2b generic implementation
      crypto: testmgr - add test vectors for blake2b
      crypto: blake2b - merge _final implementation to callback
      crypto: blake2b - merge blake2 init to api callback
      crypto: blake2b - simplify key init
      crypto: blake2b - delete unused structs or members
      crypto: blake2b - open code set last block helper
      crypto: blake2b - merge _update to api callback
      crypto: blake2b - rename tfm context and _setkey callback

Eneas U de Queiroz (1):
      crypto: qce - add CRYPTO_ALG_KERN_DRIVER_ONLY flag

Eric Biggers (24):
      crypto: geode-aes - convert to skcipher API and make thread-safe
      crypto: sparc/aes - convert to skcipher API
      crypto: sparc/camellia - convert to skcipher API
      crypto: sparc/des - convert to skcipher API
      crypto: s390/aes - convert to skcipher API
      crypto: s390/paes - convert to skcipher API
      crypto: s390/des - convert to skcipher API
      crypto: padlock-aes - convert to skcipher API
      crypto: nx - don't abuse blkcipher_desc to pass iv around
      crypto: nx - convert AES-ECB to skcipher API
      crypto: nx - convert AES-CBC to skcipher API
      crypto: nx - convert AES-CTR to skcipher API
      crypto: powerpc - don't unnecessarily use atomic scatterwalk
      crypto: powerpc - don't set ivsize for AES-ECB
      crypto: powerpc - convert SPE AES algorithms to skcipher API
      crypto: skcipher - unify the crypto_has_skcipher*() functions
      crypto: skcipher - remove crypto_has_ablkcipher()
      crypto: skcipher - rename crypto_skcipher_type2 to crypto_skcipher_type
      crypto: skcipher - remove the "blkcipher" algorithm type
      crypto: skcipher - rename the crypto_blkcipher module and kconfig option
      crypto: mips/chacha - select CRYPTO_SKCIPHER, not CRYPTO_BLKCIPHER
      crypto: chacha_generic - remove unnecessary setkey() functions
      crypto: x86/chacha - only unregister algorithms if registered
      crypto: lib/chacha20poly1305 - use chacha20_crypt()

Geert Uytterhoeven (1):
      crypto: nx - Improve debugfs_create_u{32,64}() handling for atomics

Greg Kroah-Hartman (1):
      crypto: hisilicon - no need to check return value of debugfs_create functions

Hao Fang (1):
      crypto: hisilicon - add vfs_num module param for zip

Herbert Xu (7):
      crypto: algif_skcipher - Use chunksize instead of blocksize
      crypto: atmel - Fix authenc support when it is set to m
      crypto: atmel - Fix remaining endianess warnings
      crypto: api - Add softdep on cryptomgr
      crypto: aead - Split out geniv into its own module
      crypto: sun4i-ss - Fix 64-bit size_t warnings
      hwrng: ks-sa - Enable COMPILE_TEST

Hook, Gary (2):
      crypto: ccp - Change a message to reflect status instead of failure
      crypto: ccp - Verify access to device registers before initializing

Iuliana Prodan (1):
      crypto: caam - use mapped_{src,dst}_nents for descriptor

Jason A. Donenfeld (7):
      crypto: mips/chacha - import 32r2 ChaCha code from Zinc
      crypto: blake2s - generic C library implementation and selftest
      crypto: blake2s - x86_64 SIMD implementation
      crypto: curve25519 - generic C library implementations
      crypto: curve25519 - x86_64 library and KPP implementations
      crypto: arm/curve25519 - import Bernstein and Schwabe's Curve25519 ARM implementation
      crypto: arm/curve25519 - wire up NEON implementation

Laurent Vivier (2):
      hwrng: core - move add_early_randomness() out of rng_mutex
      hwrng: core - Fix use-after-free warning in hwrng_register()

Longfang Liu (1):
      Documentation: add DebugFS doc for HiSilicon SEC

Mark Salter (1):
      crypto: ccp - fix uninitialized list head

Markus Elfring (2):
      hwrng: iproc-rng200 - Use devm_platform_ioremap_resource() in iproc_rng200_probe()
      hwrng: mediatek - Use devm_platform_ioremap_resource() in mtk_rng_probe()

Michael Ellerman (1):
      crypto: vmx - Avoid weird build failures

Nagadheeraj Rottela (3):
      crypto: cavium/nitrox - check assoclen and authsize for gcm(aes) cipher
      crypto: cavium/nitrox - Fix cbc ciphers self test failures
      crypto: cavium/nitrox - Add mailbox message to get mcode info in VF

Navid Emamdoost (3):
      crypto: ccp - Release all allocated memory if sha type is invalid
      crypto: user - fix memory leak in crypto_report
      crypto: user - fix memory leak in crypto_reportstat

Pascal van Leeuwen (37):
      crypto: inside-secure - Added support for CRC32
      crypto: inside-secure - Added support for the AES CBCMAC ahash
      crypto: inside-secure - Added support for the AES XCBC ahash
      crypto: inside-secure - Added support for the AES-CMAC ahash
      crypto: inside-secure - Added support for the CHACHA20 skcipher
      crypto: inside-secure - Add support for the Chacha20-Poly1305 AEAD
      crypto: inside-secure - Add CRYPTO_CHACHA20POLY1305 to CRYPTO_DEV_SAFEXCEL
      crypto: inside-secure - Added support for basic SM3 ahash
      crypto: inside-secure - Added support for HMAC-SM3 ahash
      crypto: testmgr - Added testvectors for the hmac(sm3) ahash
      crypto: inside-secure - Add support for the ecb(sm4) skcipher
      crypto: inside-secure - Add support for the cbc(sm4) skcipher
      crypto: inside-secure - Add support for the ofb(sm4) skcipher
      crypto: testmgr - Added testvectors for the ofb(sm4) & cfb(sm4) skciphers
      crypto: inside-secure - Add support for the cfb(sm4) skcipher
      crypto: inside-secure - Add support for the rfc3685(ctr(sm4)) skcipher
      crypto: testmgr - Added testvectors for the rfc3686(ctr(sm4)) skcipher
      crypto: inside-secure - Add SM4 based authenc AEAD ciphersuites
      crypto: inside-secure - Add SHA3 family of basic hash algorithms
      crypto: inside-secure - Add HMAC-SHA3 family of authentication algorithms
      crypto: inside-secure - Add CRYPTO_SHA3 to CRYPTO_DEV_SAFEXCEL
      crypto: inside-secure - Added support for authenc HMAC-SHA1/DES-CBC
      crypto: inside-secure - Added support for authenc HMAC-SHA2/3DES-CBC
      crypto: inside-secure - Added support for authenc HMAC-SHA2/DES-CBC
      crypto: inside-secure - Fix stability issue with Macchiatobin
      crypto: inside-secure - Fixed corner case TRC admin RAM probing issue
      crypto: inside-secure - Added support for the rfc4106(gcm(aes)) AEAD
      crypto: inside-secure - Added support for the rfc4543(gcm(aes)) "AEAD"
      crypto: inside-secure - Added support for the rfc4309(ccm(aes)) AEAD
      crypto: inside-secure - Add support for 256 bit wide internal bus
      crypto: inside-secure - Add support for HW with less ring AIC's than rings
      crypto: inside-secure - Add support for the EIP196
      crypto: inside-secure - Fix build error with CONFIG_CRYPTO_SM3=m
      crypto: inside-secure - Made locally used safexcel_pci_remove() static
      crypto: inside-secure - Fixed warnings on inconsistent byte order handling
      crypto: inside-secure - Fix hangup during probing for EIP97 engine
      crypto: inside-secure - Fixed authenc w/ (3)DES fails on Macchiatobin

Peter Ujfalusi (1):
      crypto: qce/dma - Use dma_request_chan() directly for channel request

Phani Kiran Hemadri (1):
      crypto: cavium/nitrox - fix firmware assignment to AE cores

Rikard Falkeborn (1):
      crypto: hisilicon: Fix misuse of GENMASK macro

Shukun Tan (4):
      crypto: hisilicon - add sgl_sge_nr module param for zip
      crypto: hisilicon - Fix using plain integer as NULL pointer
      crypto: hisilicon - fix param should be static when not external.
      crypto: hisilicon - fix endianness verification problem of QM

Sumit Garg (1):
      hwrng: omap - Fix RNG wait loop timeout

Tian Tao (2):
      crypto: ccree - fix comparison of unsigned expression warning
      crypto: tgr192 - remove unneeded semicolon

Tomer Maimon (2):
      dt-binding: hwrng: add NPCM RNG documentation
      hwrng: npcm - add NPCM RNG driver

Tony Lindgren (7):
      ARM: OMAP2+: Check omap3-rom-rng for GP device instead of HS device
      hwrng: omap3-rom - Fix missing clock by probing with device tree
      hwrng: omap3-rom - Call clk_disable_unprepare() on exit only if not idled
      hwrng: omap3-rom - Initialize default quality to get data
      hwrng: omap3-rom - Update to use standard driver data
      hwrng: omap3-rom - Use runtime PM instead of custom functions
      hwrng: omap3-rom - Use devm hwrng and runtime PM

Tudor Ambarus (4):
      crypto: atmel-aes - Fix IV handling when req->nbytes < ivsize
      crypto: atmel - Fix selection of CRYPTO_AUTHENC
      crypto: atmel-tdes - Set the IV after {en,de}crypt
      crypto: atmel-aes - Change data type for "lastc" buffer

YueHaibing (17):
      crypto: inside-secure - Use PTR_ERR_OR_ZERO in safexcel_xcbcmac_cra_init()
      hwrng: atmel - use devm_platform_ioremap_resource() to simplify code
      hwrng: bcm2835 - use devm_platform_ioremap_resource() to simplify code
      hwrng: exynos - use devm_platform_ioremap_resource() to simplify code
      hwrng: hisi - use devm_platform_ioremap_resource() to simplify code
      hwrng: ks-sa - use devm_platform_ioremap_resource() to simplify code
      hwrng: meson - use devm_platform_ioremap_resource() to simplify code
      hwrng: npcm - use devm_platform_ioremap_resource() to simplify code
      hwrng: omap - use devm_platform_ioremap_resource() to simplify code
      hwrng: pasemi - use devm_platform_ioremap_resource() to simplify code
      hwrng: pic32 - use devm_platform_ioremap_resource() to simplify code
      hwrng: st - use devm_platform_ioremap_resource() to simplify code
      hwrng: tx4939 - use devm_platform_ioremap_resource() to simplify code
      hwrng: xgene - use devm_platform_ioremap_resource() to simplify code
      crypto: amlogic - Use kmemdup in meson_aes_setkey()
      crypto: sun8i-ce - Fix memdup.cocci warnings
      crypto: atmel - Fix build error of CRYPTO_AUTHENC

Yunfeng Ye (2):
      crypto: chtls - remove the redundant check in chtls_recvmsg()
      crypto: arm64/aes-neonbs - add return value of skcipher_walk_done() in __xts_crypt()

Zaibo Xu (11):
      crypto: hisilicon - add HiSilicon HPRE accelerator
      crypto: hisilicon - add SRIOV support for HPRE
      Documentation: Add debugfs doc for hisi_hpre
      crypto: hisilicon - Add debugfs for HPRE
      MAINTAINERS: Add maintainer for HiSilicon HPRE driver
      hwrng: hisi - add HiSilicon TRNG driver support
      MAINTAINERS: Add maintainer for HiSilicon TRNG V2 driver
      crypto: hisilicon - add HiSilicon SEC V2 driver
      crypto: hisilicon - add SRIOV for HiSilicon SEC
      crypto: hisilicon - add DebugFS for HiSilicon SEC
      MAINTAINERS: Add maintainer for HiSilicon SEC V2 driver

Zhou Wang (8):
      crypto: hisilicon - merge sgl support to hisi_qm module
      crypto: hisilicon - fix large sgl memory allocation problem when disable smmu
      crypto: hisilicon - misc fix about sgl
      crypto: hisilicon - select NEED_SG_DMA_LENGTH in qm Kconfig
      crypto: hisilicon - tiny fix about QM/ZIP error callback print
      crypto: hisilicon - use sgl API to get sgl dma addr and len
      crypto: hisilicon - fix to return sub-optimal device when best device has no qps
      crypto: hisilicon - replace #ifdef with IS_ENABLED for CONFIG_NUMA

kbuild test robot (1):
      crypto: sun8i-ss - fix memdup.cocci warnings

kbuild test robot Remove unneeded semicolon (1):
      crypto: sun8i-ss - fix semicolon.cocci warnings

zhengbin (1):
      crypto: ux500 - Remove set but not used variable 'cookie'

Łukasz Stelmach (1):
      dt-bindings: hwrng: Add Samsung Exynos 5250+ True RNG bindings

 Documentation/ABI/testing/debugfs-hisi-hpre        |   57 +
 Documentation/ABI/testing/debugfs-hisi-sec         |   43 +
 Documentation/crypto/api-skcipher.rst              |   29 +-
 Documentation/crypto/architecture.rst              |    4 -
 Documentation/crypto/crypto_engine.rst             |    4 -
 Documentation/crypto/devel-algos.rst               |   27 +-
 .../bindings/crypto/allwinner,sun8i-ss.yaml        |   60 +
 .../bindings/crypto/amlogic,gxl-crypto.yaml        |   52 +
 .../devicetree/bindings/rng/atmel-trng.txt         |    2 +-
 .../devicetree/bindings/rng/nuvoton,npcm-rng.txt   |   12 +
 .../devicetree/bindings/rng/omap3_rom_rng.txt      |   27 +
 .../bindings/rng/samsung,exynos5250-trng.txt       |   17 +
 MAINTAINERS                                        |   37 +-
 arch/arm/boot/dts/omap3-n900.dts                   |    6 +
 arch/arm/crypto/Kconfig                            |   36 +-
 arch/arm/crypto/Makefile                           |   49 +-
 arch/arm/crypto/aes-ce-core.S                      |    1 +
 arch/arm/crypto/chacha-glue.c                      |  343 +
 arch/arm/crypto/chacha-neon-glue.c                 |  202 -
 arch/arm/crypto/chacha-scalar-core.S               |  460 ++
 arch/arm/crypto/crct10dif-ce-core.S                |    2 +-
 arch/arm/crypto/curve25519-core.S                  | 2062 ++++++
 arch/arm/crypto/curve25519-glue.c                  |  127 +
 arch/arm/crypto/ghash-ce-core.S                    |    1 +
 arch/arm/crypto/poly1305-armv4.pl                  | 1236 ++++
 arch/arm/crypto/poly1305-core.S_shipped            | 1158 +++
 arch/arm/crypto/poly1305-glue.c                    |  276 +
 arch/arm/crypto/sha1-ce-core.S                     |    1 +
 arch/arm/crypto/sha2-ce-core.S                     |    1 +
 arch/arm/mach-omap2/pdata-quirks.c                 |   14 +-
 arch/arm64/Kconfig                                 |    2 +-
 arch/arm64/crypto/Kconfig                          |   17 +-
 arch/arm64/crypto/Makefile                         |   10 +-
 arch/arm64/crypto/aes-neonbs-glue.c                |    2 +-
 arch/arm64/crypto/chacha-neon-glue.c               |   81 +-
 arch/arm64/crypto/ghash-ce-core.S                  |  501 +-
 arch/arm64/crypto/ghash-ce-glue.c                  |  293 +-
 arch/arm64/crypto/poly1305-armv8.pl                |  913 +++
 arch/arm64/crypto/poly1305-core.S_shipped          |  835 +++
 arch/arm64/crypto/poly1305-glue.c                  |  237 +
 arch/mips/Makefile                                 |    2 +-
 arch/mips/crypto/Makefile                          |   18 +
 arch/mips/crypto/chacha-core.S                     |  497 ++
 arch/mips/crypto/chacha-glue.c                     |  150 +
 arch/mips/crypto/poly1305-glue.c                   |  203 +
 arch/mips/crypto/poly1305-mips.pl                  | 1273 ++++
 arch/powerpc/crypto/aes-spe-glue.c                 |  454 +-
 arch/riscv/Kconfig                                 |    2 +-
 arch/s390/crypto/aes_s390.c                        |  609 +-
 arch/s390/crypto/des_s390.c                        |  419 +-
 arch/s390/crypto/paes_s390.c                       |  414 +-
 arch/sparc/crypto/aes_glue.c                       |  310 +-
 arch/sparc/crypto/camellia_glue.c                  |  217 +-
 arch/sparc/crypto/des_glue.c                       |  499 +-
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/crypto/Makefile                           |    3 +
 arch/x86/crypto/blake2s-core.S                     |  258 +
 arch/x86/crypto/blake2s-glue.c                     |  233 +
 arch/x86/crypto/chacha_glue.c                      |  184 +-
 arch/x86/crypto/curve25519-x86_64.c                | 2475 +++++++
 arch/x86/crypto/poly1305_glue.c                    |  199 +-
 crypto/Kconfig                                     |  171 +-
 crypto/Makefile                                    |   11 +-
 crypto/ablkcipher.c                                |  407 --
 crypto/adiantum.c                                  |    5 +-
 crypto/aead.c                                      |  165 +-
 crypto/aegis128-core.c                             |  125 +-
 crypto/aegis128-neon-inner.c                       |   50 +
 crypto/aegis128-neon.c                             |   21 +
 crypto/af_alg.c                                    |    2 +-
 crypto/algapi.c                                    |   26 -
 crypto/algif_skcipher.c                            |    2 +-
 crypto/api.c                                       |    3 +-
 crypto/blake2b_generic.c                           |  320 +
 crypto/blake2s_generic.c                           |  171 +
 crypto/blkcipher.c                                 |  548 --
 crypto/chacha_generic.c                            |   94 +-
 crypto/cryptd.c                                    |    2 +-
 crypto/crypto_engine.c                             |   29 -
 crypto/crypto_user_base.c                          |    4 +-
 crypto/crypto_user_stat.c                          |    8 +-
 crypto/curve25519-generic.c                        |   90 +
 crypto/ecc.c                                       |    5 +-
 crypto/essiv.c                                     |    9 +-
 crypto/geniv.c                                     |  176 +
 crypto/jitterentropy-kcapi.c                       |    8 +-
 crypto/jitterentropy.c                             |   13 +-
 crypto/jitterentropy.h                             |   17 +
 crypto/nhpoly1305.c                                |    3 +-
 crypto/poly1305_generic.c                          |  228 +-
 crypto/skcipher.c                                  |  230 +-
 crypto/tcrypt.c                                    |    4 +-
 crypto/testmgr.c                                   |   82 +
 crypto/testmgr.h                                   | 2124 ++++++
 crypto/tgr192.c                                    |    4 +-
 drivers/char/hw_random/Kconfig                     |   28 +-
 drivers/char/hw_random/Makefile                    |    2 +
 drivers/char/hw_random/atmel-rng.c                 |   43 +-
 drivers/char/hw_random/bcm2835-rng.c               |    5 +-
 drivers/char/hw_random/core.c                      |   61 +-
 drivers/char/hw_random/exynos-trng.c               |    4 +-
 drivers/char/hw_random/hisi-rng.c                  |    4 +-
 drivers/char/hw_random/hisi-trng-v2.c              |   99 +
 drivers/char/hw_random/iproc-rng200.c              |    9 +-
 drivers/char/hw_random/ks-sa-rng.c                 |   44 +-
 drivers/char/hw_random/meson-rng.c                 |    4 +-
 drivers/char/hw_random/mtk-rng.c                   |    9 +-
 drivers/char/hw_random/npcm-rng.c                  |  184 +
 drivers/char/hw_random/omap-rng.c                  |   13 +-
 drivers/char/hw_random/omap3-rom-rng.c             |  168 +-
 drivers/char/hw_random/pasemi-rng.c                |    4 +-
 drivers/char/hw_random/pic32-rng.c                 |    4 +-
 drivers/char/hw_random/st-rng.c                    |    4 +-
 drivers/char/hw_random/tx4939-rng.c                |    4 +-
 drivers/char/hw_random/xgene-rng.c                 |    4 +-
 drivers/crypto/Kconfig                             |   92 +-
 drivers/crypto/Makefile                            |    3 +-
 drivers/crypto/allwinner/Kconfig                   |   87 +
 drivers/crypto/allwinner/Makefile                  |    3 +
 .../{sunxi-ss => allwinner/sun4i-ss}/Makefile      |    0
 .../sun4i-ss}/sun4i-ss-cipher.c                    |   34 +-
 .../sun4i-ss}/sun4i-ss-core.c                      |  139 +-
 .../sun4i-ss}/sun4i-ss-hash.c                      |   47 +-
 .../sun4i-ss}/sun4i-ss-prng.c                      |    9 +-
 .../{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss.h    |    2 +
 drivers/crypto/allwinner/sun8i-ce/Makefile         |    2 +
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |  438 ++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |  676 ++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |  254 +
 drivers/crypto/allwinner/sun8i-ss/Makefile         |    2 +
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |  436 ++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |  642 ++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |  218 +
 drivers/crypto/amcc/crypto4xx_core.c               |    6 +-
 drivers/crypto/amlogic/Kconfig                     |   24 +
 drivers/crypto/amlogic/Makefile                    |    2 +
 drivers/crypto/amlogic/amlogic-gxl-cipher.c        |  382 +
 drivers/crypto/amlogic/amlogic-gxl-core.c          |  332 +
 drivers/crypto/amlogic/amlogic-gxl.h               |  161 +
 drivers/crypto/atmel-aes.c                         |  590 +-
 drivers/crypto/atmel-authenc.h                     |    2 +-
 drivers/crypto/atmel-sha.c                         |    4 +-
 drivers/crypto/atmel-tdes.c                        |  469 +-
 drivers/crypto/bcm/cipher.c                        |  373 +-
 drivers/crypto/bcm/cipher.h                        |   10 +-
 drivers/crypto/bcm/spu2.c                          |    6 +-
 drivers/crypto/caam/Kconfig                        |    6 +-
 drivers/crypto/caam/caampkc.c                      |   72 +-
 drivers/crypto/caam/caampkc.h                      |    8 +-
 drivers/crypto/caam/ctrl.c                         |  222 +-
 drivers/crypto/caam/intern.h                       |    4 -
 drivers/crypto/caam/qi.c                           |    8 +-
 drivers/crypto/caam/qi.h                           |    1 -
 drivers/crypto/cavium/cpt/cptvf_algs.c             |  292 +-
 drivers/crypto/cavium/nitrox/Kconfig               |    2 +-
 drivers/crypto/cavium/nitrox/nitrox_aead.c         |   39 +-
 drivers/crypto/cavium/nitrox/nitrox_dev.h          |   15 +
 drivers/crypto/cavium/nitrox/nitrox_main.c         |    9 +-
 drivers/crypto/cavium/nitrox/nitrox_mbx.c          |    8 +
 drivers/crypto/cavium/nitrox/nitrox_req.h          |    4 +
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c     |  134 +-
 drivers/crypto/ccp/Kconfig                         |    2 +-
 drivers/crypto/ccp/ccp-crypto-aes-galois.c         |    7 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c            |   94 +-
 drivers/crypto/ccp/ccp-crypto-aes.c                |  169 +-
 drivers/crypto/ccp/ccp-crypto-des3.c               |  100 +-
 drivers/crypto/ccp/ccp-crypto-main.c               |   14 +-
 drivers/crypto/ccp/ccp-crypto.h                    |   13 +-
 drivers/crypto/ccp/ccp-dev-v5.c                    |   14 +-
 drivers/crypto/ccp/ccp-dev.c                       |   15 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |    1 +
 drivers/crypto/ccp/ccp-ops.c                       |    3 +-
 drivers/crypto/ccp/psp-dev.c                       |   59 +-
 drivers/crypto/ccp/psp-dev.h                       |    1 +
 drivers/crypto/ccree/cc_aead.c                     |    3 +-
 drivers/crypto/ccree/cc_cipher.c                   |    4 +-
 drivers/crypto/chelsio/chcr_algo.c                 |  334 +-
 drivers/crypto/chelsio/chcr_algo.h                 |    2 +-
 drivers/crypto/chelsio/chcr_crypto.h               |   16 +-
 drivers/crypto/chelsio/chtls/chtls_io.c            |    5 +-
 drivers/crypto/geode-aes.c                         |  433 +-
 drivers/crypto/geode-aes.h                         |   15 +-
 drivers/crypto/hifn_795x.c                         |  183 +-
 drivers/crypto/hisilicon/Kconfig                   |   45 +-
 drivers/crypto/hisilicon/Makefile                  |    6 +-
 drivers/crypto/hisilicon/hpre/Makefile             |    2 +
 drivers/crypto/hisilicon/hpre/hpre.h               |   83 +
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        | 1137 +++
 drivers/crypto/hisilicon/hpre/hpre_main.c          | 1052 +++
 drivers/crypto/hisilicon/qm.c                      |  142 +-
 drivers/crypto/hisilicon/qm.h                      |   17 +-
 drivers/crypto/hisilicon/sec2/Makefile             |    2 +
 drivers/crypto/hisilicon/sec2/sec.h                |  156 +
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  889 +++
 drivers/crypto/hisilicon/sec2/sec_crypto.h         |  198 +
 drivers/crypto/hisilicon/sec2/sec_main.c           | 1095 +++
 drivers/crypto/hisilicon/sgl.c                     |  184 +-
 drivers/crypto/hisilicon/sgl.h                     |   24 -
 drivers/crypto/hisilicon/zip/zip.h                 |    1 -
 drivers/crypto/hisilicon/zip/zip_crypto.c          |   46 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |  294 +-
 drivers/crypto/inside-secure/safexcel.c            |  329 +-
 drivers/crypto/inside-secure/safexcel.h            |  131 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     | 2062 +++++-
 drivers/crypto/inside-secure/safexcel_hash.c       | 1475 +++-
 drivers/crypto/inside-secure/safexcel_ring.c       |    5 +-
 drivers/crypto/ixp4xx_crypto.c                     |  228 +-
 drivers/crypto/marvell/cesa.h                      |    6 +-
 drivers/crypto/marvell/cipher.c                    |   14 +-
 drivers/crypto/mediatek/mtk-aes.c                  |  250 +-
 drivers/crypto/mxs-dcp.c                           |  140 +-
 drivers/crypto/n2_core.c                           |  194 +-
 drivers/crypto/nx/nx-aes-cbc.c                     |   81 +-
 drivers/crypto/nx/nx-aes-ccm.c                     |   45 +-
 drivers/crypto/nx/nx-aes-ctr.c                     |   87 +-
 drivers/crypto/nx/nx-aes-ecb.c                     |   76 +-
 drivers/crypto/nx/nx-aes-gcm.c                     |   29 +-
 drivers/crypto/nx/nx.c                             |   64 +-
 drivers/crypto/nx/nx.h                             |   19 +-
 drivers/crypto/nx/nx_debugfs.c                     |   18 +-
 drivers/crypto/omap-aes.c                          |  209 +-
 drivers/crypto/omap-aes.h                          |    4 +-
 drivers/crypto/omap-des.c                          |  232 +-
 drivers/crypto/padlock-aes.c                       |  157 +-
 drivers/crypto/picoxcell_crypto.c                  |  386 +-
 drivers/crypto/qat/Kconfig                         |    2 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |  304 +-
 drivers/crypto/qat/qat_common/qat_crypto.h         |    4 +-
 drivers/crypto/qce/Makefile                        |    2 +-
 drivers/crypto/qce/cipher.h                        |    8 +-
 drivers/crypto/qce/common.c                        |   12 +-
 drivers/crypto/qce/common.h                        |    3 +-
 drivers/crypto/qce/core.c                          |    2 +-
 drivers/crypto/qce/dma.c                           |    4 +-
 drivers/crypto/qce/sha.c                           |    2 +-
 drivers/crypto/qce/{ablkcipher.c => skcipher.c}    |  172 +-
 drivers/crypto/rockchip/Makefile                   |    2 +-
 drivers/crypto/rockchip/rk3288_crypto.c            |    8 +-
 drivers/crypto/rockchip/rk3288_crypto.h            |    3 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |  556 --
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c   |  538 ++
 drivers/crypto/s5p-sss.c                           |  187 +-
 drivers/crypto/sahara.c                            |  156 +-
 drivers/crypto/stm32/stm32-cryp.c                  |  338 +-
 drivers/crypto/talitos.c                           |  314 +-
 drivers/crypto/ux500/Kconfig                       |    2 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |  371 +-
 drivers/crypto/ux500/hash/hash_core.c              |    3 +-
 drivers/crypto/virtio/Kconfig                      |    2 +-
 drivers/crypto/virtio/virtio_crypto_algs.c         |  192 +-
 drivers/crypto/virtio/virtio_crypto_common.h       |    2 +-
 drivers/crypto/vmx/Makefile                        |    6 +-
 drivers/net/wireless/cisco/Kconfig                 |    2 +-
 include/crypto/aead.h                              |    2 +-
 include/crypto/algapi.h                            |  149 -
 include/crypto/blake2s.h                           |  106 +
 include/crypto/chacha.h                            |   83 +-
 include/crypto/chacha20poly1305.h                  |   48 +
 include/crypto/curve25519.h                        |   71 +
 include/crypto/engine.h                            |    4 -
 include/crypto/hash.h                              |    2 +-
 include/crypto/internal/blake2s.h                  |   24 +
 include/crypto/internal/chacha.h                   |   43 +
 include/crypto/internal/des.h                      |   12 -
 include/crypto/internal/poly1305.h                 |   58 +
 include/crypto/internal/skcipher.h                 |   62 -
 include/crypto/poly1305.h                          |   69 +-
 include/crypto/skcipher.h                          |   49 +-
 include/linux/crypto.h                             |  861 +--
 include/linux/pci.h                                |    1 +
 include/uapi/linux/psp-sev.h                       |    3 +
 init/Kconfig                                       |    4 +
 lib/Makefile                                       |    3 +-
 lib/crypto/Kconfig                                 |  130 +
 lib/crypto/Makefile                                |   42 +-
 lib/crypto/blake2s-generic.c                       |  111 +
 lib/crypto/blake2s-selftest.c                      |  622 ++
 lib/crypto/blake2s.c                               |  126 +
 lib/{ => crypto}/chacha.c                          |   20 +-
 lib/crypto/chacha20poly1305-selftest.c             | 7393 ++++++++++++++++++++
 lib/crypto/chacha20poly1305.c                      |  369 +
 lib/crypto/curve25519-fiat32.c                     |  864 +++
 lib/crypto/curve25519-hacl64.c                     |  788 +++
 lib/crypto/curve25519.c                            |   25 +
 lib/crypto/libchacha.c                             |   35 +
 lib/crypto/poly1305.c                              |  232 +
 lib/ubsan.c                                        |    2 +-
 lib/ubsan.h                                        |    2 +-
 net/bluetooth/Kconfig                              |    2 +-
 net/rxrpc/Kconfig                                  |    2 +-
 net/xfrm/Kconfig                                   |    2 +-
 net/xfrm/xfrm_algo.c                               |    4 +-
 292 files changed, 47110 insertions(+), 11394 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-hpre
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-sec
 create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
 create mode 100644 Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
 create mode 100644 Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/omap3_rom_rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
 create mode 100644 arch/arm/crypto/chacha-glue.c
 delete mode 100644 arch/arm/crypto/chacha-neon-glue.c
 create mode 100644 arch/arm/crypto/chacha-scalar-core.S
 create mode 100644 arch/arm/crypto/curve25519-core.S
 create mode 100644 arch/arm/crypto/curve25519-glue.c
 create mode 100644 arch/arm/crypto/poly1305-armv4.pl
 create mode 100644 arch/arm/crypto/poly1305-core.S_shipped
 create mode 100644 arch/arm/crypto/poly1305-glue.c
 create mode 100644 arch/arm64/crypto/poly1305-armv8.pl
 create mode 100644 arch/arm64/crypto/poly1305-core.S_shipped
 create mode 100644 arch/arm64/crypto/poly1305-glue.c
 create mode 100644 arch/mips/crypto/chacha-core.S
 create mode 100644 arch/mips/crypto/chacha-glue.c
 create mode 100644 arch/mips/crypto/poly1305-glue.c
 create mode 100644 arch/mips/crypto/poly1305-mips.pl
 create mode 100644 arch/x86/crypto/blake2s-core.S
 create mode 100644 arch/x86/crypto/blake2s-glue.c
 create mode 100644 arch/x86/crypto/curve25519-x86_64.c
 delete mode 100644 crypto/ablkcipher.c
 create mode 100644 crypto/blake2b_generic.c
 create mode 100644 crypto/blake2s_generic.c
 delete mode 100644 crypto/blkcipher.c
 create mode 100644 crypto/curve25519-generic.c
 create mode 100644 crypto/geniv.c
 create mode 100644 crypto/jitterentropy.h
 create mode 100644 drivers/char/hw_random/hisi-trng-v2.c
 create mode 100644 drivers/char/hw_random/npcm-rng.c
 create mode 100644 drivers/crypto/allwinner/Kconfig
 create mode 100644 drivers/crypto/allwinner/Makefile
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/Makefile (100%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-cipher.c (95%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-core.c (87%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-hash.c (93%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss-prng.c (92%)
 rename drivers/crypto/{sunxi-ss => allwinner/sun4i-ss}/sun4i-ss.h (98%)
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/Makefile
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/Makefile
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
 create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
 create mode 100644 drivers/crypto/amlogic/Kconfig
 create mode 100644 drivers/crypto/amlogic/Makefile
 create mode 100644 drivers/crypto/amlogic/amlogic-gxl-cipher.c
 create mode 100644 drivers/crypto/amlogic/amlogic-gxl-core.c
 create mode 100644 drivers/crypto/amlogic/amlogic-gxl.h
 create mode 100644 drivers/crypto/hisilicon/hpre/Makefile
 create mode 100644 drivers/crypto/hisilicon/hpre/hpre.h
 create mode 100644 drivers/crypto/hisilicon/hpre/hpre_crypto.c
 create mode 100644 drivers/crypto/hisilicon/hpre/hpre_main.c
 create mode 100644 drivers/crypto/hisilicon/sec2/Makefile
 create mode 100644 drivers/crypto/hisilicon/sec2/sec.h
 create mode 100644 drivers/crypto/hisilicon/sec2/sec_crypto.c
 create mode 100644 drivers/crypto/hisilicon/sec2/sec_crypto.h
 create mode 100644 drivers/crypto/hisilicon/sec2/sec_main.c
 delete mode 100644 drivers/crypto/hisilicon/sgl.h
 rename drivers/crypto/qce/{ablkcipher.c => skcipher.c} (62%)
 delete mode 100644 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
 create mode 100644 drivers/crypto/rockchip/rk3288_crypto_skcipher.c
 create mode 100644 include/crypto/blake2s.h
 create mode 100644 include/crypto/chacha20poly1305.h
 create mode 100644 include/crypto/curve25519.h
 create mode 100644 include/crypto/internal/blake2s.h
 create mode 100644 include/crypto/internal/chacha.h
 create mode 100644 include/crypto/internal/poly1305.h
 create mode 100644 lib/crypto/Kconfig
 create mode 100644 lib/crypto/blake2s-generic.c
 create mode 100644 lib/crypto/blake2s-selftest.c
 create mode 100644 lib/crypto/blake2s.c
 rename lib/{ => crypto}/chacha.c (88%)
 create mode 100644 lib/crypto/chacha20poly1305-selftest.c
 create mode 100644 lib/crypto/chacha20poly1305.c
 create mode 100644 lib/crypto/curve25519-fiat32.c
 create mode 100644 lib/crypto/curve25519-hacl64.c
 create mode 100644 lib/crypto/curve25519.c
 create mode 100644 lib/crypto/libchacha.c
 create mode 100644 lib/crypto/poly1305.c

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
