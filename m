Return-Path: <SRS0=KAtS=VF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CECC606BD
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jul 2019 15:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF39020844
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jul 2019 15:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbfGHPIH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Jul 2019 11:08:07 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56218 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbfGHPIH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jul 2019 11:08:07 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hkVFL-0000T0-MF; Mon, 08 Jul 2019 23:08:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hkVFI-0000mM-Vs; Mon, 08 Jul 2019 23:08:01 +0800
Date:   Mon, 8 Jul 2019 23:08:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT] Crypto Update for 5.3
Message-ID: <20190708150800.6xjc4idh2ppbxyn6@gondor.apana.org.au>
References: <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190305081155.7rpkydnc4ipm43o6@gondor.apana.org.au>
 <20190506032938.fgyw2qupyktvsx7w@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190506032938.fgyw2qupyktvsx7w@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus: 

Here is the crypto update for 5.3:

API:

- Test shash interface directly in testmgr.
- cra_driver_name is now mandatory.

Algorithms:

- Replace arc4 crypto_cipher with library helper.
- Implement 5 way interleave for ECB, CBC and CTR on arm64.
- Add xxhash.
- Add continuous self-test on noise source to drbg.
- Update jitter RNG.

Drivers:

- Add support for SHA204A random number generator.
- Add support for 7211 in iproc-rng200.
- Fix fuzz test failures in inside-secure.
- Fix fuzz test failures in talitos.
- Fix fuzz test failures in qat.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Antoine Tenart (14):
      crypto: inside-secure - remove empty line
      crypto: inside-secure - move comment
      crypto: inside-secure - fix coding style for a condition
      crypto: inside-secure - remove useless check
      crypto: inside-secure - improve the result error format when displayed
      crypto: inside-secure - change returned error when a descriptor reports an error
      crypto: inside-secure - enable context reuse
      crypto: inside-secure - unify cache reset
      crypto: inside-secure - fix zeroing of the request in ahash_exit_inv
      crypto: inside-secure - fix queued len computation
      crypto: inside-secure - implement IV retrieval
      crypto: inside-secure - add support for HMAC updates
      crypto: inside-secure - fix use of the SG list
      crypto: inside-secure - do not rely on the hardware last bit for result descriptors

Ard Biesheuvel (16):
      i2c: acpi: permit bus speed to be discovered after enumeration
      crypto: atmel-ecc - add support for ACPI probing on non-AT91 platforms
      crypto: atmel-ecc - factor out code that can be shared
      crypto: atmel-i2c - add support for SHA204A random number generator
      dt-bindings: add Atmel SHA204A I2C crypto processor
      dt-bindings: move Atmel ECC508A I2C crypto processor to trivial-devices
      crypto: caam - limit output IV to CBC to work around CTR mode DMA issue
      crypto: arc4 - refactor arc4 core code into separate library
      net/mac80211: move WEP handling to ARC4 library interface
      net/lib80211: move WEP handling to ARC4 library code
      net/lib80211: move TKIP handling to ARC4 library code
      crypto: arc4 - remove cipher implementation
      ppp: mppe: switch to RC4 library interface
      fs: cifs: switch to RC4 library interface
      crypto: arm64/aes-ce - add 5 way interleave routines
      crypto: arm64/aes-ce - implement 5 way interleave for ECB, CBC and CTR

Arnd Bergmann (5):
      crypto: sun4i-ss - reduce stack usage
      crypto: testmgr - dynamically allocate testvec_config
      crypto: testmgr - dynamically allocate crypto_shash
      crypto: serpent - mark __serpent_setkey_sbox noinline
      crypto: asymmetric_keys - select CRYPTO_HASH where needed

Christian Lamparter (3):
      crypto: crypto4xx - fix AES CTR blocksize value
      crypto: crypto4xx - fix blocksize for cfb and ofb
      crypto: crypto4xx - block ciphers should only accept complete blocks

Christophe Leroy (21):
      crypto: talitos - fix skcipher failure due to wrong output IV
      crypto: talitos - rename alternative AEAD algos.
      crypto: talitos - reduce max key size for SEC1
      crypto: talitos - check AES key size
      crypto: talitos - fix CTR alg blocksize
      crypto: talitos - check data blocksize in ablkcipher.
      crypto: talitos - fix ECB algs ivsize
      crypto: talitos - Do not modify req->cryptlen on decryption.
      crypto: talitos - HMAC SNOOP NO AFEU mode requires SW icv checking.
      crypto: talitos - properly handle split ICV.
      crypto: talitos - Align SEC1 accesses to 32 bits boundaries.
      crypto: talitos - fix AEAD processing.
      Revert "crypto: talitos - export the talitos_submit function"
      crypto: talitos - use IS_ENABLED() in has_ftr_sec1()
      crypto: talitos - use SPDX-License-Identifier
      crypto: talitos - fix max key size for sha384 and sha512
      crypto: talitos - eliminate unneeded 'done' functions at build time
      lib/scatterlist: Fix mapping iterator when sg->offset is greater than PAGE_SIZE
      crypto: talitos - move struct talitos_edesc into talitos.h
      crypto: talitos - fix hash on SEC1.
      crypto: talitos - drop icv_ool

Daniel Axtens (3):
      crypto: vmx - CTR: always increment IV as quadword
      crypto: vmx - ghash: do nosimd fallback manually
      crypto: vmx - Document CTR mode counter width quirks

Elena Petrova (2):
      crypto: arm64/sha1-ce - correct digest for empty data in finup
      crypto: arm64/sha2-ce - correct digest for empty data in finup

Eric Biggers (27):
      crypto: hash - fix incorrect HASH_MAX_DESCSIZE
      crypto: jitterentropy - change back to module_init()
      crypto: hmac - fix memory leak in hmac_init_tfm()
      crypto: vmx - convert to SPDX license identifiers
      crypto: vmx - convert to skcipher API
      crypto: testmgr - fix length truncation with large page size
      crypto: testmgr - make extra tests depend on cryptomgr
      crypto: make all templates select CRYPTO_MANAGER
      crypto: echainiv - change to 'default n'
      crypto: gf128mul - make unselectable by user
      crypto: cryptd - move kcrypto_wq into cryptd
      crypto: hash - remove CRYPTO_ALG_TYPE_DIGEST
      crypto: algapi - remove crypto_tfm_in_queue()
      crypto: testmgr - test the shash API
      crypto: ghash - fix unaligned memory access in ghash_setkey()
      crypto: lrw - use correct alignmask
      crypto: chacha20poly1305 - fix atomic sleep when using async algorithm
      crypto: make all generic algorithms set cra_driver_name
      crypto: algapi - require cra_name and cra_driver_name
      crypto: testmgr - add some more preemption points
      crypto: doc - improve the skcipher API example code
      crypto: x86/aesni - remove unused internal cipher algorithm
      crypto: aead - un-inline encrypt and decrypt functions
      crypto: skcipher - un-inline encrypt and decrypt functions
      crypto: skcipher - make chunksize and walksize accessors internal
      crypto: chacha20poly1305 - a few cleanups
      crypto: chacha - constify ctx and iv arguments

Fabio Estevam (2):
      crypto: mxs-dcp - Use devm_platform_ioremap_resource()
      crypto: sahara - Use devm_platform_ioremap_resource()

Florian Fainelli (2):
      dt-bindings: rng: Document BCM7211 RNG compatible string
      hwrng: iproc-rng200 - Add support for 7211

Fuqian Huang (1):
      crypto: amcc - remove memset after dma_alloc_coherent

Gilad Ben-Yossef (1):
      crypto: ccree - add HW engine config check

Giovanni Cabiddu (5):
      crypto: qat - update iv after encryption or decryption operations
      crypto: qat - fix block size for aes ctr mode
      crypto: qat - return proper error code in setkey
      crypto: qat - return error for block ciphers for invalid requests
      crypto: qat - do not offload zero length requests

Greg Kroah-Hartman (1):
      crypto: nx - no need to check return value of debugfs_create functions

Gustavo A. R. Silva (1):
      crypto: qat - use struct_size() helper

Haren Myneni (1):
      crypto/NX: Set receive window credits to max number of CRBs in RxFIFO

Herbert Xu (3):
      crypto: ixp4xx - Fix cross-compile errors due to type mismatch
      crypto: atmel - Fix sparse endianness warnings
      Merge git://git.kernel.org/.../herbert/crypto-2.6

Hook, Gary (7):
      crypto: ccp - AES CFB mode is a stream cipher
      crypto: ccp - fix AES CFB error exposed by new test vectors
      crypto: ccp - Fix 3DES complaint from ccp-crypto module
      crypto: doc - Add parameter documentation
      crypto: doc - Fix formatting of new crypto engine content
      crypto: ccp - Validate the the error value used to index error messages
      crypto: ccp - Switch to SPDX license identifiers

Horia Geantă (8):
      crypto: caam - avoid S/G table fetching for AEAD zero-length output
      crypto: caam - fix S/G table passing page boundary
      crypto: caam - convert top level drivers to libraries
      crypto: caam/qi - don't allocate an extra platform device
      crypto: caam/qi - fix address translations with IOMMU enabled
      crypto: caam/qi - DMA map keys using proper device
      crypto: caam - use len instead of nents for bulding HW S/G table
      crypto: caam - update IV using HW support

Iuliana Prodan (5):
      crypto: caam - fix typo in i.MX6 devices list for errata
      crypto: caam - fix pkcs1pad(rsa-caam, sha256) failure because of invalid input
      crypto: caam - strip input without changing crypto request
      crypto: caam - disable some clock checks for iMX7ULP
      ARM: dts: imx7ulp: add crypto support

Lionel Debieve (3):
      crypto: stm32/crc32 - rename driver file
      crypto: stm32/hash - Fix hmac issue more than 256 bytes
      crypto: stm32/hash - remove interruptible condition for dma

Neil Armstrong (1):
      hwrng: meson - update with SPDX Licence identifier

Nikolay Borisov (1):
      crypto: xxhash - Implement xxhash support

Nishad Kamdar (2):
      crypto: cavium/nitrox - Use the correct style for SPDX License Identifier
      crypto: hisilicon - Use the correct style for SPDX License Identifier

Ofir Drang (2):
      crypto: ccree - check that cryptocell reset completed
      crypto: ccree - prevent isr handling in case driver is suspended

Sascha Hauer (5):
      crypto: caam - print debugging hex dumps after unmapping
      crypto: caam - print IV only when non NULL
      crypto: caam - remove unused defines
      crypto: caam - print debug messages at debug level
      crypto: caam - print messages in caam_dump_sg at debug level

Shant KumarX Sonnad (1):
      crypto: qat - add check for negative offset in alg precompute function

Stephan Mueller (1):
      crypto: drbg - add FIPS 140-2 CTRNG for noise source

Stephan Müller (1):
      crypto: jitter - update implementation to 2.1.2

Xin Zeng (1):
      crypto: qat - remove spin_lock in qat_ablkcipher_setkey

YueHaibing (3):
      crypto: arm/sha512 - Make sha512_arm_final static
      crypto: atmel-i2c - Fix build error while CRC16 set to m
      crypto: bcm - Make some symbols static

ofir.drang@arm.com (1):
      crypto: ccree - Relocate driver irq registration after clk init

 Documentation/crypto/api-samples.rst               | 176 ++++----
 Documentation/crypto/api-skcipher.rst              |   2 +-
 Documentation/crypto/architecture.rst              |   4 +-
 Documentation/crypto/crypto_engine.rst             | 111 +++--
 .../devicetree/bindings/crypto/atmel-crypto.txt    |  13 -
 .../devicetree/bindings/rng/brcm,iproc-rng200.txt  |   1 +
 .../devicetree/bindings/trivial-devices.yaml       |   4 +
 MAINTAINERS                                        |   1 +
 arch/arm/boot/dts/imx7ulp.dtsi                     |  23 +
 arch/arm/crypto/chacha-neon-glue.c                 |   2 +-
 arch/arm/crypto/sha512-glue.c                      |   2 +-
 arch/arm64/crypto/aes-ce.S                         |  60 ++-
 arch/arm64/crypto/aes-modes.S                      | 118 +++--
 arch/arm64/crypto/aes-neon.S                       |  48 +--
 arch/arm64/crypto/chacha-neon-glue.c               |   2 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |   2 +-
 arch/arm64/crypto/sha2-ce-glue.c                   |   2 +-
 arch/x86/crypto/aesni-intel_glue.c                 |  45 +-
 arch/x86/crypto/chacha_glue.c                      |   2 +-
 crypto/Kconfig                                     |  39 +-
 crypto/Makefile                                    |   3 +-
 crypto/aead.c                                      |  36 ++
 crypto/algapi.c                                    |  35 +-
 crypto/anubis.c                                    |   1 +
 crypto/arc4.c                                      | 125 +-----
 crypto/asymmetric_keys/Kconfig                     |   3 +
 crypto/chacha20poly1305.c                          |  73 ++--
 crypto/chacha_generic.c                            |   4 +-
 crypto/cryptd.c                                    |  26 +-
 crypto/crypto_null.c                               |   3 +
 crypto/crypto_wq.c                                 |  40 --
 crypto/deflate.c                                   |   1 +
 crypto/drbg.c                                      |  94 +++-
 crypto/fcrypt.c                                    |   1 +
 crypto/ghash-generic.c                             |   8 +-
 crypto/hmac.c                                      |   4 +
 crypto/jitterentropy-kcapi.c                       |   7 +-
 crypto/jitterentropy.c                             | 305 ++++---------
 crypto/khazad.c                                    |   1 +
 crypto/lrw.c                                       |   2 +-
 crypto/lz4.c                                       |   1 +
 crypto/lz4hc.c                                     |   1 +
 crypto/lzo-rle.c                                   |   1 +
 crypto/lzo.c                                       |   1 +
 crypto/md4.c                                       |   7 +-
 crypto/md5.c                                       |   7 +-
 crypto/michael_mic.c                               |   1 +
 crypto/rmd128.c                                    |   1 +
 crypto/rmd160.c                                    |   1 +
 crypto/rmd256.c                                    |   1 +
 crypto/rmd320.c                                    |   1 +
 crypto/serpent_generic.c                           |   9 +-
 crypto/skcipher.c                                  |  34 ++
 crypto/tea.c                                       |   3 +
 crypto/testmgr.c                                   | 478 +++++++++++++++++----
 crypto/testmgr.h                                   | 116 ++++-
 crypto/tgr192.c                                    |  21 +-
 crypto/wp512.c                                     |  21 +-
 crypto/xxhash_generic.c                            | 108 +++++
 crypto/zstd.c                                      |   1 +
 drivers/char/hw_random/iproc-rng200.c              |   1 +
 drivers/char/hw_random/meson-rng.c                 |  52 +--
 drivers/crypto/Kconfig                             |  20 +-
 drivers/crypto/Makefile                            |   2 +
 drivers/crypto/amcc/crypto4xx_alg.c                |  36 +-
 drivers/crypto/amcc/crypto4xx_core.c               |  25 +-
 drivers/crypto/amcc/crypto4xx_core.h               |  10 +-
 drivers/crypto/atmel-ecc.c                         | 403 +----------------
 drivers/crypto/atmel-ecc.h                         | 116 -----
 drivers/crypto/atmel-i2c.c                         | 364 ++++++++++++++++
 drivers/crypto/atmel-i2c.h                         | 197 +++++++++
 drivers/crypto/atmel-sha204a.c                     | 171 ++++++++
 drivers/crypto/bcm/cipher.c                        |   8 +-
 drivers/crypto/bcm/spu2.c                          |  10 +-
 drivers/crypto/caam/Kconfig                        |  46 +-
 drivers/crypto/caam/Makefile                       |  18 +-
 drivers/crypto/caam/caamalg.c                      | 338 +++++++--------
 drivers/crypto/caam/caamalg_desc.c                 | 147 +++----
 drivers/crypto/caam/caamalg_desc.h                 |   4 +-
 drivers/crypto/caam/caamalg_qi.c                   | 267 ++++++------
 drivers/crypto/caam/caamalg_qi2.c                  | 202 +++++----
 drivers/crypto/caam/caamhash.c                     | 329 ++++++--------
 drivers/crypto/caam/caampkc.c                      | 177 ++++----
 drivers/crypto/caam/caampkc.h                      |   9 +-
 drivers/crypto/caam/caamrng.c                      |  76 +---
 drivers/crypto/caam/ctrl.c                         |  58 +--
 drivers/crypto/caam/desc_constr.h                  |  11 +
 drivers/crypto/caam/error.c                        |   8 +-
 drivers/crypto/caam/error.h                        |   2 +-
 drivers/crypto/caam/intern.h                       | 102 ++++-
 drivers/crypto/caam/jr.c                           |  43 ++
 drivers/crypto/caam/key_gen.c                      |  28 +-
 drivers/crypto/caam/qi.c                           |  52 +--
 drivers/crypto/caam/sg_sw_qm.h                     |  18 +-
 drivers/crypto/caam/sg_sw_qm2.h                    |  18 +-
 drivers/crypto/caam/sg_sw_sec4.h                   |  26 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c             |   1 -
 drivers/crypto/cavium/nitrox/nitrox_debugfs.h      |   2 +-
 drivers/crypto/cavium/nitrox/nitrox_mbx.h          |   2 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c           |   5 +-
 drivers/crypto/ccp/ccp-crypto-aes-galois.c         |   5 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c            |   5 +-
 drivers/crypto/ccp/ccp-crypto-aes.c                |  12 +-
 drivers/crypto/ccp/ccp-crypto-des3.c               |   5 +-
 drivers/crypto/ccp/ccp-crypto-main.c               |   5 +-
 drivers/crypto/ccp/ccp-crypto-rsa.c                |   5 +-
 drivers/crypto/ccp/ccp-crypto-sha.c                |   5 +-
 drivers/crypto/ccp/ccp-crypto.h                    |   5 +-
 drivers/crypto/ccp/ccp-debugfs.c                   |   5 +-
 drivers/crypto/ccp/ccp-dev-v3.c                    |   5 +-
 drivers/crypto/ccp/ccp-dev-v5.c                    |   5 +-
 drivers/crypto/ccp/ccp-dev.c                       | 101 ++---
 drivers/crypto/ccp/ccp-dev.h                       |   7 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |   5 +-
 drivers/crypto/ccp/ccp-ops.c                       |  25 +-
 drivers/crypto/ccp/psp-dev.c                       |   5 +-
 drivers/crypto/ccp/psp-dev.h                       |   5 +-
 drivers/crypto/ccp/sp-dev.c                        |   5 +-
 drivers/crypto/ccp/sp-dev.h                        |   5 +-
 drivers/crypto/ccp/sp-pci.c                        |   5 +-
 drivers/crypto/ccp/sp-platform.c                   |   5 +-
 drivers/crypto/ccree/cc_driver.c                   |  70 ++-
 drivers/crypto/ccree/cc_driver.h                   |   6 +
 drivers/crypto/ccree/cc_host_regs.h                |  20 +
 drivers/crypto/ccree/cc_pm.c                       |  11 +
 drivers/crypto/ccree/cc_pm.h                       |   7 +
 drivers/crypto/hisilicon/sec/sec_drv.h             |   2 +-
 drivers/crypto/inside-secure/safexcel.c            |  13 +-
 drivers/crypto/inside-secure/safexcel.h            |  17 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     | 116 +++--
 drivers/crypto/inside-secure/safexcel_hash.c       |  92 ++--
 drivers/crypto/inside-secure/safexcel_ring.c       |   3 +
 drivers/crypto/ixp4xx_crypto.c                     |  15 +-
 drivers/crypto/mxs-dcp.c                           |   5 +-
 drivers/crypto/nx/nx-842-powernv.c                 |   8 +-
 drivers/crypto/nx/nx.c                             |   4 +-
 drivers/crypto/nx/nx.h                             |  12 +-
 drivers/crypto/nx/nx_debugfs.c                     |  71 +--
 drivers/crypto/qat/qat_common/qat_algs.c           | 294 ++++++++-----
 drivers/crypto/qat/qat_common/qat_crypto.h         |   2 +
 drivers/crypto/sahara.c                            |   4 +-
 drivers/crypto/stm32/Makefile                      |   2 +-
 .../crypto/stm32/{stm32_crc32.c => stm32-crc32.c}  |   0
 drivers/crypto/stm32/stm32-hash.c                  |   6 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c          |  47 +-
 drivers/crypto/talitos.c                           | 383 ++++++++---------
 drivers/crypto/talitos.h                           |  73 ++--
 drivers/crypto/vmx/aes.c                           |  14 +-
 drivers/crypto/vmx/aes_cbc.c                       | 197 +++------
 drivers/crypto/vmx/aes_ctr.c                       | 179 +++-----
 drivers/crypto/vmx/aes_xts.c                       | 189 ++++----
 drivers/crypto/vmx/aesp8-ppc.h                     |   2 -
 drivers/crypto/vmx/aesp8-ppc.pl                    |  22 +-
 drivers/crypto/vmx/ghash.c                         | 211 ++++-----
 drivers/crypto/vmx/vmx.c                           |  86 ++--
 drivers/i2c/i2c-core-acpi.c                        |   6 +-
 drivers/net/ppp/Kconfig                            |   3 +-
 drivers/net/ppp/ppp_mppe.c                         |  97 +----
 fs/cifs/Kconfig                                    |   2 +-
 fs/cifs/cifsencrypt.c                              |  62 +--
 fs/cifs/cifsfs.c                                   |   1 -
 include/crypto/aead.h                              |  34 +-
 include/crypto/algapi.h                            |   7 -
 include/crypto/arc4.h                              |  10 +
 include/crypto/chacha.h                            |   2 +-
 include/crypto/crypto_wq.h                         |   8 -
 include/crypto/drbg.h                              |   2 +
 include/crypto/hash.h                              |   8 +-
 include/crypto/internal/hash.h                     |   6 -
 include/crypto/internal/skcipher.h                 |  60 +++
 include/crypto/skcipher.h                          |  92 +---
 include/linux/crypto.h                             |  12 +-
 lib/Makefile                                       |   2 +-
 lib/crypto/Makefile                                |   4 +
 lib/crypto/arc4.c                                  |  74 ++++
 lib/scatterlist.c                                  |   9 +-
 net/mac80211/Kconfig                               |   2 +-
 net/mac80211/cfg.c                                 |   4 +-
 net/mac80211/ieee80211_i.h                         |   4 +-
 net/mac80211/key.h                                 |   1 +
 net/mac80211/main.c                                |   6 +-
 net/mac80211/mlme.c                                |   3 +-
 net/mac80211/tkip.c                                |   8 +-
 net/mac80211/tkip.h                                |   4 +-
 net/mac80211/wep.c                                 |  49 +--
 net/mac80211/wep.h                                 |   5 +-
 net/mac80211/wpa.c                                 |   4 +-
 net/wireless/Kconfig                               |   2 +
 net/wireless/lib80211_crypt_tkip.c                 |  48 +--
 net/wireless/lib80211_crypt_wep.c                  |  51 +--
 190 files changed, 4654 insertions(+), 4098 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
