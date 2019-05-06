Return-Path: <SRS0=vipQ=TG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52306C004C9
	for <linux-crypto@archiver.kernel.org>; Mon,  6 May 2019 03:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED920205F4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 May 2019 03:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbfEFD3s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 May 2019 23:29:48 -0400
Received: from [5.180.42.13] ([5.180.42.13]:56872 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfEFD3s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 May 2019 23:29:48 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hNUJx-00045F-Hb; Mon, 06 May 2019 11:29:41 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hNUJu-0001Ib-Cr; Mon, 06 May 2019 11:29:38 +0800
Date:   Mon, 6 May 2019 11:29:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT] Crypto Update for 5.2
Message-ID: <20190506032938.fgyw2qupyktvsx7w@gondor.apana.org.au>
References: <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190305081155.7rpkydnc4ipm43o6@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190305081155.7rpkydnc4ipm43o6@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus: 

Here is the crypto update for 5.2:

API:

- Add support for AEAD in simd.
- Add fuzz testing to testmgr.
- Add panic_on_fail module parameter to testmgr.
- Use per-CPU struct instead multiple variables in scompress.
- Change verify API for akcipher.

Algorithms:

- Convert x86 AEAD algorithms over to simd.
- Forbid 2-key 3DES in FIPS mode.
- Add EC-RDSA (GOST 34.10) algorithm.

Drivers:

- Set output IV with ctr-aes in crypto4xx.
- Set output IV in rockchip.
- Fix potential length overflow with hashing in sun4i-ss.
- Fix computation error with ctr in vmx.
- Add SM4 protected keys support in ccree.
- Remove long-broken mxc-scc driver.
- Add rfc4106(gcm(aes)) cipher support in cavium/nitrox.
 

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Andi Kleen (1):
      crypto: aes - Use ___cacheline_aligned for aes data

Arnd Bergmann (1):
      crypto: ccree - reduce kernel stack usage with clang

Christian Lamparter (4):
      crypto: crypto4xx - fix ctr-aes missing output IV
      crypto: crypto4xx - fix cfb and ofb "overran dst buffer" issues
      crypto: crypto4xx - use sync skcipher for fallback
      crypto: crypto4xx - get rid of redundant using_sd variable

Colin Ian King (2):
      crypto: caam - fix spelling mistake "cannote" -> "cannot"
      crypto: ccree - fix spelling mistake "protedcted" -> "protected"

Corentin Labbe (4):
      crypto: sun4i-ss - Handle better absence/presence of IV
      crypto: sun4i-ss - remove ivsize from ECB
      crypto: sun4i-ss - Fix invalid calculation of hash end
      crypto: sun4i-ss - fallback when length is not multiple of blocksize

Dan Carpenter (1):
      crypto: caam/qi - Change a couple IS_ERR_OR_NULL() checks to IS_ERR()

Daniel Axtens (1):
      crypto: vmx - fix copy-paste error in CTR mode

Eric Biggers (48):
      crypto: simd - support wrapping AEAD algorithms
      crypto: x86/aesni - convert to use skcipher SIMD bulk registration
      crypto: x86/aesni - convert to use AEAD SIMD helpers
      crypto: x86/aegis128 - convert to use AEAD SIMD helpers
      crypto: x86/aegis128l - convert to use AEAD SIMD helpers
      crypto: x86/aegis256 - convert to use AEAD SIMD helpers
      crypto: x86/morus640 - convert to use AEAD SIMD helpers
      crypto: x86/morus1280 - convert to use AEAD SIMD helpers
      crypto: testmgr - remove workaround for AEADs that modify aead_request
      crypto: chacha-generic - fix use as arm64 no-NEON fallback
      crypto: arm64/gcm-aes-ce - fix no-NEON fallback code
      crypto: simd,testmgr - introduce crypto_simd_usable()
      crypto: x86 - convert to use crypto_simd_usable()
      crypto: arm - convert to use crypto_simd_usable()
      crypto: arm64 - convert to use crypto_simd_usable()
      crypto: simd - convert to use crypto_simd_usable()
      crypto: testmgr - test the !may_use_simd() fallback code
      crypto: chacha-generic - use crypto_xor_cpy()
      crypto: salsa20-generic - use crypto_xor_cpy()
      crypto: crct10dif-generic - fix use via crypto_shash_digest()
      crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()
      crypto: skcipher - don't WARN on unprocessed data after slow walk step
      crypto: chacha20poly1305 - set cra_name correctly
      crypto: streebog - fix unaligned memory accesses
      crypto: cts - don't support empty messages
      crypto: arm64/cbcmac - handle empty messages in same way as template
      crypto: testmgr - add panic_on_fail module parameter
      crypto: lrw - don't access already-freed walk.iv
      crypto: salsa20 - don't access already-freed walk.iv
      crypto: arm/aes-neonbs - don't access already-freed walk.iv
      crypto: arm64/aes-neonbs - don't access already-freed walk.iv
      crypto: vmx - return correct error code on failed setkey
      crypto: testmgr - expand ability to test for errors
      crypto: testmgr - identify test vectors by name rather than number
      crypto: testmgr - add helpers for fuzzing against generic implementation
      crypto: testmgr - fuzz hashes against their generic implementation
      crypto: testmgr - fuzz skciphers against their generic implementation
      crypto: testmgr - fuzz AEADs against their generic implementation
      crypto: run initcalls for generic implementations earlier
      crypto: cryptd - remove ability to instantiate ablkciphers
      crypto: cavium - remove bogus code handling cryptd
      crypto: powerpc - convert to use crypto_simd_usable()
      crypto: shash - fix missed optimization in shash_ahash_digest()
      crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
      crypto: ccm - fix incompatibility between "ccm" and "ccm_base"
      crypto: shash - remove useless crypto_yield() in shash_ahash_digest()
      crypto: nx - don't abuse shash MAY_SLEEP flag
      crypto: shash - remove shash_desc::flags

Geert Uytterhoeven (1):
      crypto: fips - Grammar s/options/option/, s/to/the/

Gilad Ben-Yossef (31):
      crypto: testmgr - add missing self test entries for protected keys
      crypto: ccree - move key load desc. before flow desc.
      crypto: ccree - move MLLI desc. before key load
      crypto: ccree - add support for sec disabled mode
      crypto: ccree - add CPP completion handling
      crypto: ccree - add remaining logic for CPP
      crypto: ccree - add SM4 protected keys support
      crypto: ccree - adapt CPP descriptor to new HW
      crypto: ccree - read next IV from HW
      crypto: ccree - add CID and PID support
      crypto: ccree - fix backlog notifications
      crypto: ccree - use proper callback completion api
      crypto: ccree - remove special handling of chained sg
      crypto: ccree - fix typo in debugfs error path
      crypto: ccree - fix mem leak on error path
      crypto: ccree - use devm_kzalloc for device data
      crypto: ccree - use std api when possible
      crypto: ccree - copyright header update
      crypto: ccree - zero out internal struct before use
      crypto: ccree - do not copy zero size MLLI table
      crypto: ccree - remove unused defines
      crypto: ccree - simplify fragment ICV detection
      crypto: ccree - simplify AEAD ICV addr calculation
      crypto: ccree - don't mangle the request assoclen
      crypto: ccree - make AEAD sgl iterator well behaved
      crypto: ccree - zap entire sg on aead request unmap
      crypto: ccree - use correct internal state sizes for export
      crypto: ccree - allow more AEAD assoc data fragments
      crypto: ccree - don't map MAC key on stack
      crypto: ccree - don't map AEAD key and IV on stack
      crypto: ccree - use a proper le32 type for le32 val

Herbert Xu (25):
      crypto: mxc-scc - Remove broken driver
      crypto: des_generic - Forbid 2-key in 3DES and add helpers
      crypto: s390 - Forbid 2-key 3DES in FIPS mode
      crypto: sparc - Forbid 2-key 3DES in FIPS mode
      crypto: atmel - Forbid 2-key 3DES in FIPS mode
      crypto: bcm - Forbid 2-key 3DES in FIPS mode
      crypto: caam - Forbid 2-key 3DES in FIPS mode
      crypto: cavium - Forbid 2-key 3DES in FIPS mode
      crypto: nitrox - Forbid 2-key 3DES in FIPS mode
      crypto: ccp - Forbid 2-key 3DES in FIPS mode
      crypto: ccree - Forbid 2-key 3DES in FIPS mode
      crypto: hifn_795x - Forbid 2-key 3DES in FIPS mode
      crypto: hisilicon - Forbid 2-key 3DES in FIPS mode
      crypto: inside-secure - Forbid 2-key 3DES in FIPS mode
      crypto: ixp4xx - Forbid 2-key 3DES in FIPS mode
      crypto: marvell - Forbid 2-key 3DES in FIPS mode
      crypto: n2 - Forbid 2-key 3DES in FIPS mode
      crypto: omap - Forbid 2-key 3DES in FIPS mode
      crypto: picoxcell - Forbid 2-key 3DES in FIPS mode
      crypto: qce - Forbid 2-key 3DES in FIPS mode
      crypto: rockchip - Forbid 2-key 3DES in FIPS mode
      crypto: stm32 - Forbid 2-key 3DES in FIPS mode
      crypto: sun4i-ss - Forbid 2-key 3DES in FIPS mode
      crypto: talitos - Forbid 2-key 3DES in FIPS mode
      crypto: ux500 - Forbid 2-key 3DES in FIPS mode

Horia Geantă (4):
      crypto: caam/jr - update gcm detection logic
      crypto: caam/qi2 - fix zero-length buffer DMA mapping
      crypto: caam/qi2 - fix DMA mapping of stack memory
      crypto: caam/qi2 - generate hash keys in-place

Iuliana Prodan (1):
      crypto: caam - limit AXI pipeline to a depth of 1

Joe Perches (1):
      crypto: sahara - Convert IS_ENABLED uses to __is_defined

Kefeng Wang (1):
      crypto: picoxcell - Use dev_get_drvdata()

Lionel Debieve (6):
      hwrng: stm32 - fix unbalanced pm_runtime_enable
      hwrng: stm32 - set default random quality
      crypto: stm32/hash - Fix self test issue during export
      crypto: stm32/cryp - add weak key check for DES
      crypto: stm32/cryp - remove request mutex protection
      crypto: stm32/cryp - update to return iv_out

Masahiro Yamada (1):
      crypto: ux500 - use ccflags-y instead of CFLAGS_<basename>.o

Nagadheeraj Rottela (2):
      crypto: cavium/nitrox - Added rfc4106(gcm(aes)) cipher support
      crypto: cavium/nitrox - Fix HW family part name format

Ofir Drang (5):
      crypto: ccree - pm resume first enable the source clk
      crypto: ccree - remove cc7x3 obsoleted AXIM configs
      crypto: ccree - HOST_POWER_DOWN_EN should be the last CC access during suspend
      crypto: ccree - add function to handle cryptocell tee fips error
      crypto: ccree - handle tee fips error during power management resume

Ondrej Mosnacek (1):
      crypto: Kconfig - fix typos AEGSI -> AEGIS

Rouven Czerwinski (1):
      hwrng: omap - Set default quality

Sebastian Andrzej Siewior (3):
      crypto: scompress - return proper error code for allocation failure
      crypto: scompress - Use per-CPU struct instead multiple variables
      crypto: scompress - initialize per-CPU variables on each CPU

Singh, Brijesh (2):
      crypto: ccp - introduce SEV_GET_ID2 command
      crypto: ccp - Do not free psp_master when PLATFORM_INIT fails

Vakul Garg (5):
      crypto: caam/jr - optimize job ring enqueue and dequeue operations
      crypto: caam/jr - Remove spinlock for output job ring
      crypto: caam/jr - Removed redundant vars from job ring private data
      crypto: caam/jr - Remove extra memory barrier during job ring enqueue
      crypto: caam/jr - Remove extra memory barrier during job ring dequeue

Vitaly Chikunov (11):
      crypto: akcipher - default implementations for request callbacks
      crypto: rsa - unimplement sign/verify for raw RSA backends
      crypto: akcipher - new verify API for public key algorithms
      KEYS: do not kmemdup digest in {public,tpm}_key_verify_signature
      X.509: parse public key parameters from x509 for akcipher
      crypto: Kconfig - create Public-key cryptography section
      crypto: ecc - make ecc into separate module
      crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm
      crypto: ecrdsa - add EC-RDSA test vectors to testmgr
      integrity: support EC-RDSA signatures for asymmetric_verify
      crypto: ecrdsa - select ASN1 and OID_REGISTRY for EC-RDSA

YueHaibing (15):
      crypto: cavium - remove unused fucntions
      crypto: cavium - Make some functions static
      crypto: ccp - Make ccp_register_rsa_alg static
      crypto: zip - Make some functions static
      crypto: bcm - remove unused array tag_to_hash_idx
      crypto: cavium - Make cptvf_device_init static
      crypto: vmx - Make p8_init and p8_exit static
      crypto: ccp - Use kmemdup in ccp_copy_and_save_keypart()
      crypto: marvell - remove set but not used variable 'index'
      crypto: mxs-dcp - return errcode in mxs_dcp_aes_enqueue and dcp_sha_update_fx
      crypto: nx842 - remove set but not used variables 'dpadding' and 'max_sync_size'
      crypto: mxs-dcp - remove set but not used variable 'fini'
      crypto: atmel - remove set but not used variable 'alg_name'
      crypto: ccree - Make cc_sec_disable static
      crypto: ccree - remove set but not used variable 'du_size'

Zhang Zhijie (1):
      crypto: rockchip - update IV buffer to contain the next IV

 Documentation/crypto/api-samples.rst               |    1 -
 arch/arm/crypto/aes-neonbs-glue.c                  |    2 +
 arch/arm/crypto/chacha-neon-glue.c                 |    5 +-
 arch/arm/crypto/crc32-ce-glue.c                    |    5 +-
 arch/arm/crypto/crct10dif-ce-glue.c                |    3 +-
 arch/arm/crypto/ghash-ce-glue.c                    |   10 +-
 arch/arm/crypto/nhpoly1305-neon-glue.c             |    3 +-
 arch/arm/crypto/sha1-ce-glue.c                     |    5 +-
 arch/arm/crypto/sha1_neon_glue.c                   |    5 +-
 arch/arm/crypto/sha2-ce-glue.c                     |    5 +-
 arch/arm/crypto/sha256_neon_glue.c                 |    5 +-
 arch/arm/crypto/sha512-neon-glue.c                 |    5 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c                |    7 +-
 arch/arm64/crypto/aes-ce-glue.c                    |    5 +-
 arch/arm64/crypto/aes-glue.c                       |    6 +-
 arch/arm64/crypto/aes-neonbs-glue.c                |    4 +-
 arch/arm64/crypto/chacha-neon-glue.c               |    5 +-
 arch/arm64/crypto/crct10dif-ce-glue.c              |    5 +-
 arch/arm64/crypto/ghash-ce-glue.c                  |   17 +-
 arch/arm64/crypto/nhpoly1305-neon-glue.c           |    3 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |    7 +-
 arch/arm64/crypto/sha2-ce-glue.c                   |    7 +-
 arch/arm64/crypto/sha256-glue.c                    |    5 +-
 arch/arm64/crypto/sha3-ce-glue.c                   |    5 +-
 arch/arm64/crypto/sha512-ce-glue.c                 |    7 +-
 arch/arm64/crypto/sm3-ce-glue.c                    |    7 +-
 arch/arm64/crypto/sm4-ce-glue.c                    |    5 +-
 arch/powerpc/crypto/crc32c-vpmsum_glue.c           |    4 +-
 arch/powerpc/crypto/crct10dif-vpmsum_glue.c        |    4 +-
 arch/powerpc/include/asm/Kbuild                    |    1 +
 arch/s390/crypto/des_s390.c                        |   21 +-
 arch/sparc/crypto/des_glue.c                       |   11 +-
 arch/x86/crypto/aegis128-aesni-glue.c              |  157 +--
 arch/x86/crypto/aegis128l-aesni-glue.c             |  157 +--
 arch/x86/crypto/aegis256-aesni-glue.c              |  157 +--
 arch/x86/crypto/aesni-intel_glue.c                 |  212 +---
 arch/x86/crypto/chacha_glue.c                      |    6 +-
 arch/x86/crypto/crc32-pclmul_glue.c                |    5 +-
 arch/x86/crypto/crc32c-intel_glue.c                |    7 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c            |   20 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |   11 +-
 arch/x86/crypto/morus1280-avx2-glue.c              |   12 +-
 arch/x86/crypto/morus1280-sse2-glue.c              |   12 +-
 arch/x86/crypto/morus1280_glue.c                   |   85 --
 arch/x86/crypto/morus640-sse2-glue.c               |   12 +-
 arch/x86/crypto/morus640_glue.c                    |   85 --
 arch/x86/crypto/nhpoly1305-avx2-glue.c             |    5 +-
 arch/x86/crypto/nhpoly1305-sse2-glue.c             |    5 +-
 arch/x86/crypto/poly1305_glue.c                    |    4 +-
 arch/x86/crypto/sha1_ssse3_glue.c                  |    7 +-
 arch/x86/crypto/sha256_ssse3_glue.c                |    7 +-
 arch/x86/crypto/sha512_ssse3_glue.c                |   10 +-
 arch/x86/power/hibernate.c                         |    1 -
 crypto/842.c                                       |    2 +-
 crypto/Kconfig                                     |   85 +-
 crypto/Makefile                                    |   10 +-
 crypto/adiantum.c                                  |    3 +-
 crypto/aegis128.c                                  |    2 +-
 crypto/aegis128l.c                                 |    2 +-
 crypto/aegis256.c                                  |    2 +-
 crypto/aes_generic.c                               |   10 +-
 crypto/akcipher.c                                  |   14 +
 crypto/algboss.c                                   |    8 +-
 crypto/ansi_cprng.c                                |    2 +-
 crypto/anubis.c                                    |    2 +-
 crypto/arc4.c                                      |    2 +-
 crypto/asymmetric_keys/asym_tpm.c                  |   43 +-
 crypto/asymmetric_keys/pkcs7_verify.c              |    1 -
 crypto/asymmetric_keys/public_key.c                |  105 +-
 crypto/asymmetric_keys/verify_pefile.c             |    1 -
 crypto/asymmetric_keys/x509.asn1                   |    2 +-
 crypto/asymmetric_keys/x509_cert_parser.c          |   57 +-
 crypto/asymmetric_keys/x509_public_key.c           |    1 -
 crypto/authenc.c                                   |    2 +-
 crypto/authencesn.c                                |    2 +-
 crypto/blowfish_generic.c                          |    2 +-
 crypto/camellia_generic.c                          |    2 +-
 crypto/cast5_generic.c                             |    2 +-
 crypto/cast6_generic.c                             |    2 +-
 crypto/cbc.c                                       |    2 +-
 crypto/ccm.c                                       |   46 +-
 crypto/cfb.c                                       |    2 +-
 crypto/chacha20poly1305.c                          |    6 +-
 crypto/chacha_generic.c                            |   12 +-
 crypto/cmac.c                                      |    2 +-
 crypto/crc32_generic.c                             |    2 +-
 crypto/crc32c_generic.c                            |    2 +-
 crypto/crct10dif_generic.c                         |   13 +-
 crypto/cryptd.c                                    |  252 ----
 crypto/crypto_null.c                               |    2 +-
 crypto/ctr.c                                       |    2 +-
 crypto/cts.c                                       |   20 +-
 crypto/deflate.c                                   |    2 +-
 crypto/des_generic.c                               |   13 +-
 crypto/dh.c                                        |    2 +-
 crypto/drbg.c                                      |    3 +-
 crypto/ecb.c                                       |    2 +-
 crypto/ecc.c                                       |  417 ++++++-
 crypto/ecc.h                                       |  153 ++-
 crypto/ecc_curve_defs.h                            |   15 -
 crypto/ecdh.c                                      |    2 +-
 crypto/echainiv.c                                  |    2 +-
 crypto/ecrdsa.c                                    |  296 +++++
 crypto/ecrdsa_defs.h                               |  225 ++++
 crypto/ecrdsa_params.asn1                          |    4 +
 crypto/ecrdsa_pub_key.asn1                         |    1 +
 crypto/fcrypt.c                                    |    2 +-
 crypto/fips.c                                      |    2 +-
 crypto/gcm.c                                       |   36 +-
 crypto/ghash-generic.c                             |    2 +-
 crypto/hmac.c                                      |   13 +-
 crypto/jitterentropy-kcapi.c                       |    2 +-
 crypto/keywrap.c                                   |    2 +-
 crypto/khazad.c                                    |    2 +-
 crypto/lrw.c                                       |    6 +-
 crypto/lz4.c                                       |    2 +-
 crypto/lz4hc.c                                     |    2 +-
 crypto/lzo-rle.c                                   |    2 +-
 crypto/lzo.c                                       |    2 +-
 crypto/md4.c                                       |    2 +-
 crypto/md5.c                                       |    2 +-
 crypto/michael_mic.c                               |    2 +-
 crypto/morus1280.c                                 |    2 +-
 crypto/morus640.c                                  |    2 +-
 crypto/nhpoly1305.c                                |    2 +-
 crypto/ofb.c                                       |    2 +-
 crypto/pcbc.c                                      |    2 +-
 crypto/pcrypt.c                                    |    2 +-
 crypto/poly1305_generic.c                          |    2 +-
 crypto/rmd128.c                                    |    2 +-
 crypto/rmd160.c                                    |    2 +-
 crypto/rmd256.c                                    |    2 +-
 crypto/rmd320.c                                    |    2 +-
 crypto/rsa-pkcs1pad.c                              |   33 +-
 crypto/rsa.c                                       |  111 +-
 crypto/salsa20_generic.c                           |   13 +-
 crypto/scompress.c                                 |  129 +-
 crypto/seed.c                                      |    2 +-
 crypto/seqiv.c                                     |    2 +-
 crypto/serpent_generic.c                           |    2 +-
 crypto/sha1_generic.c                              |    2 +-
 crypto/sha256_generic.c                            |    2 +-
 crypto/sha3_generic.c                              |    2 +-
 crypto/sha512_generic.c                            |    2 +-
 crypto/shash.c                                     |    7 +-
 crypto/simd.c                                      |  273 ++++-
 crypto/skcipher.c                                  |    9 +-
 crypto/sm3_generic.c                               |    2 +-
 crypto/sm4_generic.c                               |    2 +-
 crypto/streebog_generic.c                          |   27 +-
 crypto/tcrypt.c                                    |    2 +-
 crypto/tea.c                                       |    2 +-
 crypto/testmgr.c                                   | 1242 +++++++++++++++++---
 crypto/testmgr.h                                   |  181 ++-
 crypto/tgr192.c                                    |    2 +-
 crypto/twofish_generic.c                           |    2 +-
 crypto/vmac.c                                      |    2 +-
 crypto/wp512.c                                     |    2 +-
 crypto/xcbc.c                                      |    2 +-
 crypto/xts.c                                       |    2 +-
 crypto/zstd.c                                      |    2 +-
 drivers/block/drbd/drbd_receiver.c                 |    1 -
 drivers/block/drbd/drbd_worker.c                   |    2 -
 drivers/char/hw_random/omap-rng.c                  |    1 +
 drivers/char/hw_random/stm32-rng.c                 |    9 +
 drivers/crypto/Kconfig                             |    9 -
 drivers/crypto/Makefile                            |    1 -
 drivers/crypto/amcc/crypto4xx_alg.c                |   24 +-
 drivers/crypto/amcc/crypto4xx_core.c               |   48 +-
 drivers/crypto/amcc/crypto4xx_core.h               |    3 +-
 drivers/crypto/atmel-tdes.c                        |  106 +-
 drivers/crypto/axis/artpec6_crypto.c               |    2 -
 drivers/crypto/bcm/cipher.c                        |   22 +-
 drivers/crypto/bcm/spu.c                           |    3 -
 drivers/crypto/bcm/util.c                          |    1 -
 drivers/crypto/caam/caamalg.c                      |   75 +-
 drivers/crypto/caam/caamalg_qi.c                   |   66 +-
 drivers/crypto/caam/caamalg_qi2.c                  |  243 ++--
 drivers/crypto/caam/caamalg_qi2.h                  |    2 -
 drivers/crypto/caam/caampkc.c                      |    2 -
 drivers/crypto/caam/ctrl.c                         |   20 +
 drivers/crypto/caam/error.c                        |    2 +-
 drivers/crypto/caam/intern.h                       |    4 +-
 drivers/crypto/caam/jr.c                           |   33 +-
 drivers/crypto/caam/qi.c                           |    4 +-
 drivers/crypto/caam/regs.h                         |   11 +
 drivers/crypto/cavium/cpt/cptvf_algs.c             |   30 +-
 drivers/crypto/cavium/cpt/cptvf_main.c             |    2 +-
 drivers/crypto/cavium/cpt/cptvf_mbox.c             |   17 -
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c       |    6 +-
 drivers/crypto/cavium/nitrox/nitrox_aead.c         |  337 ++++--
 drivers/crypto/cavium/nitrox/nitrox_hal.c          |   65 +-
 drivers/crypto/cavium/nitrox/nitrox_req.h          |   46 +-
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c     |    8 +-
 drivers/crypto/cavium/zip/zip_crypto.c             |    8 +-
 drivers/crypto/ccp/ccp-crypto-des3.c               |   21 +-
 drivers/crypto/ccp/ccp-crypto-rsa.c                |    8 +-
 drivers/crypto/ccp/ccp-crypto-sha.c                |    2 -
 drivers/crypto/ccp/psp-dev.c                       |   69 +-
 drivers/crypto/ccree/Makefile                      |    1 +
 drivers/crypto/ccree/cc_aead.c                     |  118 +-
 drivers/crypto/ccree/cc_aead.h                     |    3 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |  341 ++----
 drivers/crypto/ccree/cc_buffer_mgr.h               |    2 +-
 drivers/crypto/ccree/cc_cipher.c                   |  585 +++++----
 drivers/crypto/ccree/cc_cipher.h                   |    3 +-
 drivers/crypto/ccree/cc_crypto_ctx.h               |   10 +-
 drivers/crypto/ccree/cc_debugfs.c                  |   44 +-
 drivers/crypto/ccree/cc_debugfs.h                  |    2 +-
 drivers/crypto/ccree/cc_driver.c                   |  120 +-
 drivers/crypto/ccree/cc_driver.h                   |   36 +-
 drivers/crypto/ccree/cc_fips.c                     |   29 +-
 drivers/crypto/ccree/cc_fips.h                     |    4 +-
 drivers/crypto/ccree/cc_hash.c                     |   64 +-
 drivers/crypto/ccree/cc_hash.h                     |    2 +-
 drivers/crypto/ccree/cc_host_regs.h                |  123 +-
 drivers/crypto/ccree/cc_hw_queue_defs.h            |   35 +-
 drivers/crypto/ccree/cc_ivgen.c                    |   11 +-
 drivers/crypto/ccree/cc_ivgen.h                    |    2 +-
 drivers/crypto/ccree/cc_kernel_regs.h              |    2 +-
 drivers/crypto/ccree/cc_lli_defs.h                 |    4 +-
 drivers/crypto/ccree/cc_pm.c                       |   11 +-
 drivers/crypto/ccree/cc_pm.h                       |    2 +-
 drivers/crypto/ccree/cc_request_mgr.c              |  116 +-
 drivers/crypto/ccree/cc_request_mgr.h              |    2 +-
 drivers/crypto/ccree/cc_sram_mgr.c                 |    7 +-
 drivers/crypto/ccree/cc_sram_mgr.h                 |    2 +-
 drivers/crypto/chelsio/chcr_algo.c                 |    2 -
 drivers/crypto/hifn_795x.c                         |   31 +-
 drivers/crypto/hisilicon/sec/sec_algs.c            |   12 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |   11 +-
 drivers/crypto/ixp4xx_crypto.c                     |   64 +-
 drivers/crypto/marvell/cipher.c                    |   11 +-
 drivers/crypto/marvell/hash.c                      |    3 +-
 drivers/crypto/mediatek/mtk-sha.c                  |    3 -
 drivers/crypto/mxc-scc.c                           |  767 ------------
 drivers/crypto/mxs-dcp.c                           |   14 +-
 drivers/crypto/n2_core.c                           |   15 +-
 drivers/crypto/nx/nx-842-pseries.c                 |    6 +-
 drivers/crypto/nx/nx-842.c                         |    3 +-
 drivers/crypto/nx/nx-aes-xcbc.c                    |   12 +-
 drivers/crypto/nx/nx-sha256.c                      |    6 +-
 drivers/crypto/nx/nx-sha512.c                      |    6 +-
 drivers/crypto/omap-des.c                          |   29 +-
 drivers/crypto/omap-sham.c                         |    2 -
 drivers/crypto/padlock-sha.c                       |    5 -
 drivers/crypto/picoxcell_crypto.c                  |   35 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |    1 -
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |    2 -
 drivers/crypto/qce/ablkcipher.c                    |   22 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |   61 +-
 drivers/crypto/s5p-sss.c                           |    1 -
 drivers/crypto/sahara.c                            |    6 +-
 drivers/crypto/stm32/Kconfig                       |    1 +
 drivers/crypto/stm32/stm32-cryp.c                  |   74 +-
 drivers/crypto/stm32/stm32-hash.c                  |    4 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c          |   78 +-
 drivers/crypto/sunxi-ss/sun4i-ss-core.c            |   19 +-
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c            |    5 +-
 drivers/crypto/sunxi-ss/sun4i-ss.h                 |    2 +
 drivers/crypto/talitos.c                           |  108 +-
 drivers/crypto/ux500/cryp/Makefile                 |    6 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |   86 +-
 drivers/crypto/vmx/aes.c                           |   14 +-
 drivers/crypto/vmx/aes_cbc.c                       |   14 +-
 drivers/crypto/vmx/aes_ctr.c                       |   10 +-
 drivers/crypto/vmx/aes_xts.c                       |   14 +-
 drivers/crypto/vmx/aesp8-ppc.pl                    |    4 +-
 drivers/crypto/vmx/ghash.c                         |   10 +-
 drivers/crypto/vmx/vmx.c                           |    4 +-
 drivers/infiniband/sw/rxe/rxe.h                    |    1 -
 drivers/md/dm-crypt.c                              |    3 -
 drivers/md/dm-integrity.c                          |    2 -
 drivers/net/ppp/ppp_mppe.c                         |    1 -
 drivers/net/wireless/intersil/orinoco/mic.c        |    1 -
 drivers/nfc/s3fwrn5/firmware.c                     |    1 -
 drivers/staging/ks7010/ks_hostif.c                 |    1 -
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c       |    1 -
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      |    1 -
 drivers/target/iscsi/iscsi_target_auth.c           |    1 -
 drivers/thunderbolt/domain.c                       |    1 -
 fs/cifs/misc.c                                     |    1 -
 fs/crypto/keyinfo.c                                |    1 -
 fs/ecryptfs/crypto.c                               |    1 -
 fs/ecryptfs/keystore.c                             |    1 -
 fs/ext4/ext4.h                                     |    1 -
 fs/f2fs/f2fs.h                                     |    1 -
 fs/nfsd/nfs4recover.c                              |    1 -
 fs/ubifs/auth.c                                    |    6 -
 fs/ubifs/replay.c                                  |    2 -
 include/crypto/aes.h                               |    8 +-
 include/crypto/akcipher.h                          |   54 +-
 include/crypto/cryptd.h                            |   18 +-
 include/crypto/des.h                               |   43 +
 include/crypto/hash.h                              |   10 +-
 include/crypto/internal/simd.h                     |   44 +
 include/crypto/morus1280_glue.h                    |   79 +-
 include/crypto/morus640_glue.h                     |   79 +-
 include/crypto/public_key.h                        |    4 +
 include/crypto/streebog.h                          |    5 +-
 include/linux/jbd2.h                               |    1 -
 include/linux/oid_registry.h                       |   18 +
 include/linux/psp-sev.h                            |    3 +-
 include/uapi/linux/psp-sev.h                       |   18 +-
 kernel/kexec_file.c                                |    1 -
 lib/crc-t10dif.c                                   |    1 -
 lib/digsig.c                                       |    1 -
 lib/libcrc32c.c                                    |    1 -
 net/bluetooth/amp.c                                |    1 -
 net/bluetooth/smp.c                                |    1 -
 net/sctp/auth.c                                    |    1 -
 net/sctp/sm_make_chunk.c                           |    2 -
 net/sunrpc/auth_gss/gss_krb5_crypto.c              |    2 -
 net/sunrpc/auth_gss/gss_krb5_mech.c                |    1 -
 net/wireless/lib80211_crypt_tkip.c                 |    1 -
 security/apparmor/crypto.c                         |    2 -
 security/integrity/digsig_asymmetric.c             |   11 +-
 security/integrity/evm/evm_crypto.c                |    1 -
 security/integrity/ima/ima_crypto.c                |    4 -
 security/keys/dh.c                                 |    1 -
 security/keys/encrypted-keys/encrypted.c           |    1 -
 security/keys/trusted.c                            |    1 -
 322 files changed, 5973 insertions(+), 4248 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
