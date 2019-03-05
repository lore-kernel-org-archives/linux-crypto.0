Return-Path: <SRS0=Q7wt=RI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE357C43381
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 08:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9941A20675
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Mar 2019 08:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfCEIMB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Mar 2019 03:12:01 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:41054 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfCEIMB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Mar 2019 03:12:01 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h15B7-0004Wf-MM; Tue, 05 Mar 2019 16:11:57 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h15B5-0000f8-AG; Tue, 05 Mar 2019 16:11:55 +0800
Date:   Tue, 5 Mar 2019 16:11:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT] Crypto Update for 5.1
Message-ID: <20190305081155.7rpkydnc4ipm43o6@gondor.apana.org.au>
References: <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus: 

Here is the crypto update for 5.1:

Please note that there is a merge of the Freescale SoC tree in
order to pull in changes required by patches to the caam/qi2 driver.

API:

- Add helper for simple skcipher modes.
- Add helper to register multiple templates.
- Set CRYPTO_TFM_NEED_KEY when setkey fails.
- Require neither or both of export/import in shash.
- AEAD decryption test vectors are now generated from encryption ones.
- New option CONFIG_CRYPTO_MANAGER_EXTRA_TESTS that includes random fuzzing.

Algorithms:

- Conversions to skcipher and helper for many templates.
- Add more test vectors for nhpoly1305 and adiantum.

Drivers:

- Add crypto4xx prng support.
- Add xcbc/cmac/ecb support in caam.
- Add AES support for Exynos5433 in s5p.
- Remove sha384/sha512 from artpec7 as hardware cannot do partial hash.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ard Biesheuvel (9):
      crypto: arm64/aes-ccm - fix logical bug in AAD MAC handling
      crypto: arm64/aes-ccm - fix bugs in non-NEON fallback routine
      crypto: arm64/aes-ccm - don't use an atomic walk needlessly
      crypto: arm64/ghash - register PMULL variants as separate algos
      crypto: arm/crct10dif - revert to C code for short inputs
      crypto: arm64/crct10dif - revert to C code for short inputs
      crypto: arm/crct10dif - remove dead code
      crypto: arm64/crct10dif - remove dead code
      crypto: arm64/crct10dif - register PMULL variants as separate algos

Atul Gupta (3):
      crypto: chelsio - avoid using sa_entry imm
      crypto: chelsio - Inline single pdu only
      crypto: chelsio - Fixed Traffic Stall

Chengguang Xu (1):
      crypto: caam - remove redundant likely/unlikely annotation

Christian Lamparter (1):
      crypto: crypto4xx - add prng crypto support

Christopher Diaz Riveros (1):
      crypto: testmgr - use kmemdup

Colin Ian King (1):
      crypto: virtio - clean up indentation, replace spaces with tab

Corentin Labbe (1):
      crypto: crypto4xx - Fix wrong ppc4xx_trng_probe()/ppc4xx_trng_remove() arguments

David Tolnay (1):
      hwrng: virtio - Avoid repeated init of completion

Eric Biggers (69):
      crypto: cipher - remove struct cipher_desc
      crypto: cfb - add missing 'chunksize' property
      crypto: cfb - remove bogus memcpy() with src == dest
      crypto: ofb - fix handling partial blocks and make thread-safe
      crypto: pcbc - remove bogus memcpy()s with src == dest
      crypto: skcipher - add helper for simple block cipher modes
      crypto: cbc - convert to skcipher_alloc_instance_simple()
      crypto: cfb - convert to skcipher_alloc_instance_simple()
      crypto: ctr - convert to skcipher API
      crypto: ecb - convert to skcipher API
      crypto: keywrap - convert to skcipher API
      crypto: ofb - convert to skcipher_alloc_instance_simple()
      crypto: pcbc - remove ability to wrap internal ciphers
      crypto: pcbc - convert to skcipher_alloc_instance_simple()
      crypto: arc4 - convert to skcipher API
      crypto: null - convert ecb-cipher_null to skcipher API
      crypto: algapi - remove crypto_alloc_instance()
      crypto: algapi - reject NULL crypto_spawn::inst
      crypto: hash - set CRYPTO_TFM_NEED_KEY if ->setkey() fails
      crypto: skcipher - set CRYPTO_TFM_NEED_KEY if ->setkey() fails
      crypto: aead - set CRYPTO_TFM_NEED_KEY if ->setkey() fails
      crypto: shash - require neither or both ->export() and ->import()
      crypto: shash - remove pointless checks of shash_alg::{export,import}
      crypto: gcm - use correct endianness type in gcm_hash_len()
      crypto: rsa-pkcs1pad - include <crypto/internal/rsa.h>
      crypto: streebog - use correct endianness type
      crypto: testmgr - handle endianness correctly in alg_test_crc32c()
      crypto: user - forward declare crypto_nlsk
      crypto: x86/aesni-gcm - make 'struct aesni_gcm_tfm_s' static const
      crypto: tgr192 - fix unaligned memory access
      crypto: stat - remove unused mutex
      crypto: af_alg - make some functions static
      crypto: af_alg - use list_for_each_entry() in af_alg_count_tsgl()
      crypto: af_alg - remove redundant initializations of sk_family
      crypto: testmgr - skip AEAD encryption test vectors with novrfy set
      crypto: testmgr - add ccm(aes) decryption tests to encryption tests
      crypto: testmgr - add gcm(aes) decryption tests to encryption tests
      crypto: testmgr - add rfc4543(gcm(aes)) decryption test to encryption tests
      crypto: testmgr - unify the AEAD encryption and decryption test vectors
      crypto: bcm - remove unused function do_decrypt()
      crypto: clarify name of WEAK_KEY request flag
      crypto: testmgr - skip crc32c context test for ahash algorithms
      crypto: x86/crct10dif-pcl - cleanup and optimizations
      crypto: arm/crct10dif-ce - cleanup and optimizations
      crypto: arm64/crct10dif-ce - cleanup and optimizations
      crypto: aegis - fix handling chunked inputs
      crypto: morus - fix handling chunked inputs
      crypto: x86/aegis - fix handling chunked inputs and MAY_SLEEP
      crypto: x86/morus - fix handling chunked inputs and MAY_SLEEP
      crypto: x86/aesni-gcm - fix crash on empty plaintext
      crypto: ahash - fix another early termination in hash walk
      crypto: arm64/aes-neonbs - fix returning final keystream block
      crypto: testmgr - add testvec_config struct and helper functions
      crypto: testmgr - introduce CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
      crypto: testmgr - implement random testvec_config generation
      crypto: testmgr - convert skcipher testing to use testvec_configs
      crypto: testmgr - convert aead testing to use testvec_configs
      crypto: testmgr - convert hash testing to use testvec_configs
      crypto: testmgr - check for skcipher_request corruption
      crypto: testmgr - check for aead_request corruption
      crypto: testmgr - remove extra bytes from 3DES-CTR IVs
      crypto: testmgr - support checking skcipher output IV
      crypto: testmgr - add iv_out to all CBC test vectors
      crypto: testmgr - add iv_out to all CTR test vectors
      crypto: arm64/aes-blk - update IV after partial final CTR block
      crypto: arm/aes-ce - update IV after partial final CTR block
      crypto: nhpoly1305 - add a test vector with len % 16 != 0
      crypto: adiantum - add 1536 and 4096-byte test vectors
      crypto: cavium/zip - fix collision with generic cra_driver_name

Franck LENORMAND (1):
      crypto: caam - fix hash context DMA unmap size

Gilad Ben-Yossef (4):
      crypto: ccree - unmap buffer before copying IV
      crypto: ccree - shared irq lines are not a bug
      crypto: ccree - don't copy zero size ciphertext
      MAINTAINERS: crypto: ccree: remove co-maintainer

Greg Kroah-Hartman (7):
      crypto: qat - no need to check return value of debugfs_create functions
      crypto: ccree - no need to check return value of debugfs_create functions
      crypto: axis - no need to check return value of debugfs_create functions
      crypto: cavium/zip - no need to check return value of debugfs_create functions
      crypto: cavium/nitrox - no need to check return value of debugfs_create functions
      crypto: ccp - no need to check return value of debugfs_create functions
      crypto: caam - no need to check return value of debugfs_create functions

Gustavo A. R. Silva (2):
      crypto: ccree - fix missing break in switch statement
      crypto: af_alg - use struct_size() in sock_kfree_s()

Hadar Gat (4):
      crypto: ccree - improve error handling
      crypto: ccree - add error message
      crypto: ccree - fix free of unallocated mlli buffer
      crypto: ccree - remove legacy leftover

Herbert Xu (2):
      crypto: qat - Remove unused goto label
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/leo/linux next

Hook, Gary (1):
      crypto: ccp - Update copyright notices and dates

Horia Geantă (8):
      crypto: caam - move shared symbols in a common location
      crypto: caam - handle zero-length AEAD output
      crypto: caam - fix DMA mapping of stack memory
      crypto: caam/qi2 - use affine DPIOs
      crypto: caam/qi2 - rate-limit enqueue failure prints
      crypto: caam/qi2 - relax busy polling while enqueuing FDs
      crypto: caam - fix DMA mapping xcbc key twice
      crypto: caam - generate hash keys in-place

Ioana Ciornei (6):
      soc: fsl: dpio: cleanup the cpu array on dpaa2_io_down
      soc: fsl: dpio: use a cpumask to identify which cpus are unused
      soc: fsl: dpio: keep a per dpio device MC portal
      soc: fsl: dpio: store a backpointer to the device backing the dpaa2_io
      soc: fsl: dpio: add a device_link at dpaa2_io_service_register
      bus: fsl-mc: automatically add a device_link on fsl_mc_[portal,object]_allocate

Iuliana Prodan (8):
      crypto: caam - fix error reporting for caam_hash_alloc
      crypto: caam - create ahash shared descriptors only once
      crypto: caam - add support for xcbc(aes)
      crypto: caam - add support for cmac(aes)
      crypto: caam - use mapped_{src,dst}_nents for job descriptor
      crypto: export arc4 defines
      crypto: caam - add ecb(*) support
      crypto: caam - weak key checking for cbc des, 3des

Jonas Gorski (1):
      hwrng: bcm2835 - fix probe as platform device

Julia Lawall (1):
      crypto: crypto4xx - add missing of_node_put after of_device_is_available

Kamil Konieczny (3):
      crypto: s5p - update iv after AES-CBC op end
      dt-bindings: crypto: document Exynos5433 SlimSSS
      crypto: s5p - add AES support for Exynos5433

Krzysztof Kozlowski (1):
      crypto: s5p-sss - Use AES_BLOCK_SIZE define instead of number

Lars Persson (6):
      crypto: axis - remove sha384 support for artpec7
      crypto: axis - remove sha512 support for artpec7
      crypto: axis - fix for recursive locking from bottom half
      crypto: axis - give DMA the start of the status buffer
      crypto: axis - support variable AEAD tag length
      crypto: axis - use a constant time tag compare

Lendacky, Thomas (1):
      crypto: ccp - Update driver messages to remove some confusion

Mao Wenan (1):
      crypto: stm32 - drop pointless static qualifier in stm32_hash_remove()

Masahiro Yamada (2):
      crypto: prefix header search paths with $(srctree)/
      crypto: bcm - remove -I. header search path and unused macro define

Milan Broz (1):
      crypto: testmgr - mark crc32 checksum as FIPS allowed

Pankaj Gupta (1):
      crypto: caam - fixed handling of sg list

Roland Hieber (1):
      crypto: caam - fix indentation of goto label

Roy Pledge (1):
      soc: fsl: dpio: perform DPIO Reset on Probe

Sebastian Andrzej Siewior (1):
      crypto: chtls - remove cdev_list_lock

Singh, Brijesh (1):
      crypto: ccp - fix the SEV probe in kexec boot path

Thomas Gleixner (4):
      crypto: aegis - Cleanup license mess
      crypto: morus - Cleanup license mess
      crypto: aegis - Convert to SPDX license identifiers
      crypto: morus - Convert to SPDX license identifiers

Tommi Hirvola (1):
      crypto: x86/poly1305 - Clear key material from stack in SSE2 variant

Vincent Whitchurch (1):
      crypto: axis - move request unmap outside of the queue lock

Vitaly Chikunov (1):
      crypto: testmgr - split akcipher tests by a key type

Xiongfeng Wang (5):
      crypto: api - add a helper to (un)register a array of templates
      crypto: ccm - use template array registering API to simplify the code
      crypto: gcm - use template array registering API to simplify the code
      crypto: ctr - use template array registering API to simplify the code
      crypto: chacha20poly1305 - use template array registering API to simplify the code

YueHaibing (8):
      crypto: chtls - remove set but not used variables 'err, adap, request, hws'
      crypto: ux500 - catch dma submission error
      crypto: chelsio - check set_msg_len overflow in generate_b0
      crypto: chelsio - remove set but not used variables 'adap'
      crypto: brcm - Fix some set-but-not-used warning
      crypto: seqiv - Use kmemdup in seqiv_aead_encrypt()
      crypto: chelsio - Fix passing zero to 'PTR_ERR' warning in chcr_aead_op
      crypto: marvell - Remove set but not used variable 'ivsize'

Zhang Zhijie (2):
      crypto: rockchip - fix scatterlist nents error
      crypto: rockchip - update new iv to device in multiple operations

haco (1):
      crypto: Kconfig - Fix typo in "pclmul"

 .../devicetree/bindings/crypto/samsung-slimsss.txt |    19 +
 MAINTAINERS                                        |     1 -
 arch/arm/crypto/aes-ce-core.S                      |    26 +-
 arch/arm/crypto/crct10dif-ce-core.S                |   568 +-
 arch/arm/crypto/crct10dif-ce-glue.c                |    25 +-
 arch/arm64/crypto/aes-ce-ccm-core.S                |     5 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c                |     8 +-
 arch/arm64/crypto/aes-modes.S                      |     3 +-
 arch/arm64/crypto/aes-neonbs-core.S                |     8 +-
 arch/arm64/crypto/crct10dif-ce-core.S              |   513 +-
 arch/arm64/crypto/crct10dif-ce-glue.c              |    75 +-
 arch/arm64/crypto/ghash-ce-glue.c                  |   118 +-
 arch/s390/crypto/des_s390.c                        |     4 +-
 arch/sparc/crypto/des_glue.c                       |     4 +-
 arch/x86/crypto/aegis128-aesni-glue.c              |    38 +-
 arch/x86/crypto/aegis128l-aesni-glue.c             |    38 +-
 arch/x86/crypto/aegis256-aesni-glue.c              |    38 +-
 arch/x86/crypto/aesni-intel_glue.c                 |    47 +-
 arch/x86/crypto/crct10dif-pcl-asm_64.S             |   782 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c            |    12 +-
 arch/x86/crypto/morus1280_glue.c                   |    40 +-
 arch/x86/crypto/morus640_glue.c                    |    39 +-
 arch/x86/crypto/poly1305-sse2-x86_64.S             |     4 +
 crypto/Kconfig                                     |    14 +-
 crypto/aead.c                                      |     4 +-
 crypto/aegis.h                                     |     7 +-
 crypto/aegis128.c                                  |    20 +-
 crypto/aegis128l.c                                 |    20 +-
 crypto/aegis256.c                                  |    20 +-
 crypto/af_alg.c                                    |    36 +-
 crypto/ahash.c                                     |    42 +-
 crypto/algapi.c                                    |    63 +-
 crypto/arc4.c                                      |    87 +-
 crypto/cbc.c                                       |   131 +-
 crypto/ccm.c                                       |    78 +-
 crypto/cfb.c                                       |   139 +-
 crypto/chacha20poly1305.c                          |    37 +-
 crypto/crypto_null.c                               |    57 +-
 crypto/crypto_user_stat.c                          |     4 -
 crypto/ctr.c                                       |   200 +-
 crypto/des_generic.c                               |     4 +-
 crypto/ecb.c                                       |   151 +-
 crypto/gcm.c                                       |    75 +-
 crypto/keywrap.c                                   |   198 +-
 crypto/morus1280.c                                 |    19 +-
 crypto/morus640.c                                  |    19 +-
 crypto/ofb.c                                       |   202 +-
 crypto/pcbc.c                                      |   143 +-
 crypto/rsa-pkcs1pad.c                              |     1 +
 crypto/seqiv.c                                     |     7 +-
 crypto/shash.c                                     |    27 +-
 crypto/skcipher.c                                  |   158 +-
 crypto/streebog_generic.c                          |     2 +-
 crypto/testmgr.c                                   |  2760 ++--
 crypto/testmgr.h                                   | 15649 ++++++++-----------
 crypto/tgr192.c                                    |     6 +-
 drivers/bus/fsl-mc/fsl-mc-allocator.c              |    11 +
 drivers/bus/fsl-mc/mc-io.c                         |    13 +
 drivers/char/hw_random/bcm2835-rng.c               |    18 +-
 drivers/char/hw_random/virtio-rng.c                |     2 +-
 drivers/crypto/amcc/crypto4xx_core.c               |    87 +
 drivers/crypto/amcc/crypto4xx_core.h               |     4 +
 drivers/crypto/amcc/crypto4xx_reg_def.h            |     1 +
 drivers/crypto/amcc/crypto4xx_trng.c               |     4 +-
 drivers/crypto/amcc/crypto4xx_trng.h               |     4 +-
 drivers/crypto/atmel-tdes.c                        |     2 +-
 drivers/crypto/axis/artpec6_crypto.c               |   326 +-
 drivers/crypto/bcm/Makefile                        |     2 -
 drivers/crypto/bcm/cipher.c                        |    10 +-
 drivers/crypto/bcm/cipher.h                        |     4 +-
 drivers/crypto/bcm/util.c                          |    40 -
 drivers/crypto/bcm/util.h                          |     6 -
 drivers/crypto/caam/Kconfig                        |     1 +
 drivers/crypto/caam/caamalg.c                      |   238 +-
 drivers/crypto/caam/caamalg_desc.c                 |    18 +-
 drivers/crypto/caam/caamalg_qi.c                   |    29 +-
 drivers/crypto/caam/caamalg_qi2.c                  |    85 +-
 drivers/crypto/caam/caamalg_qi2.h                  |     2 +
 drivers/crypto/caam/caamhash.c                     |   429 +-
 drivers/crypto/caam/caamhash_desc.c                |    68 +-
 drivers/crypto/caam/caamhash_desc.h                |     8 +
 drivers/crypto/caam/compat.h                       |     1 +
 drivers/crypto/caam/ctrl.c                         |    25 +-
 drivers/crypto/caam/error.c                        |     6 +
 drivers/crypto/caam/intern.h                       |     1 -
 drivers/crypto/caam/key_gen.c                      |    30 +-
 drivers/crypto/caam/qi.c                           |     4 +-
 drivers/crypto/cavium/nitrox/nitrox_debugfs.c      |    27 +-
 drivers/crypto/cavium/nitrox/nitrox_debugfs.h      |     5 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c         |     4 +-
 drivers/crypto/cavium/zip/zip_main.c               |    58 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c           |     2 +-
 drivers/crypto/ccp/ccp-crypto-des3.c               |     2 +-
 drivers/crypto/ccp/ccp-crypto-sha.c                |     2 +-
 drivers/crypto/ccp/ccp-debugfs.c                   |    36 +-
 drivers/crypto/ccp/ccp-ops.c                       |     2 +-
 drivers/crypto/ccp/psp-dev.c                       |    37 +-
 drivers/crypto/ccp/psp-dev.h                       |     2 +-
 drivers/crypto/ccp/sp-dev.c                        |     2 +-
 drivers/crypto/ccp/sp-dev.h                        |     2 +-
 drivers/crypto/ccp/sp-pci.c                        |     6 +-
 drivers/crypto/ccp/sp-platform.c                   |     2 +-
 drivers/crypto/ccree/cc_buffer_mgr.c               |    87 +-
 drivers/crypto/ccree/cc_cipher.c                   |    10 +-
 drivers/crypto/ccree/cc_debugfs.c                  |    22 +-
 drivers/crypto/ccree/cc_debugfs.h                  |     8 +-
 drivers/crypto/ccree/cc_driver.c                   |    13 +-
 drivers/crypto/ccree/cc_driver.h                   |     2 -
 drivers/crypto/chelsio/Makefile                    |     2 +-
 drivers/crypto/chelsio/chcr_algo.c                 |    12 +-
 drivers/crypto/chelsio/chcr_core.h                 |     2 +-
 drivers/crypto/chelsio/chcr_ipsec.c                |    42 +-
 drivers/crypto/chelsio/chtls/Makefile              |     3 +-
 drivers/crypto/chelsio/chtls/chtls_io.c            |    12 +-
 drivers/crypto/chelsio/chtls/chtls_main.c          |     1 -
 drivers/crypto/hifn_795x.c                         |     3 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |     2 +-
 drivers/crypto/ixp4xx_crypto.c                     |     4 +-
 drivers/crypto/marvell/cipher.c                    |     4 +-
 drivers/crypto/n2_core.c                           |     2 +-
 drivers/crypto/omap-des.c                          |     2 +-
 drivers/crypto/picoxcell_crypto.c                  |     3 +-
 drivers/crypto/qat/qat_c3xxx/Makefile              |     2 +-
 drivers/crypto/qat/qat_c3xxx/adf_drv.c             |     5 -
 drivers/crypto/qat/qat_c3xxxvf/Makefile            |     2 +-
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c           |     5 -
 drivers/crypto/qat/qat_c62x/Makefile               |     2 +-
 drivers/crypto/qat/qat_c62x/adf_drv.c              |     5 -
 drivers/crypto/qat/qat_c62xvf/Makefile             |     2 +-
 drivers/crypto/qat/qat_c62xvf/adf_drv.c            |     5 -
 drivers/crypto/qat/qat_common/adf_cfg.c            |     7 -
 drivers/crypto/qat/qat_common/adf_transport.c      |     7 -
 .../crypto/qat/qat_common/adf_transport_debug.c    |    15 -
 drivers/crypto/qat/qat_dh895xcc/Makefile           |     2 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |     5 -
 drivers/crypto/qat/qat_dh895xccvf/Makefile         |     2 +-
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |     5 -
 drivers/crypto/qce/ablkcipher.c                    |     4 +-
 drivers/crypto/rockchip/rk3288_crypto.c            |     2 +-
 drivers/crypto/rockchip/rk3288_crypto.h            |     4 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |    41 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |     2 +-
 drivers/crypto/s5p-sss.c                           |    64 +-
 drivers/crypto/stm32/stm32-hash.c                  |     2 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c          |     2 +-
 drivers/crypto/talitos.c                           |     2 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |    26 +-
 drivers/crypto/virtio/virtio_crypto_algs.c         |     2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |     9 +-
 drivers/soc/fsl/dpio/dpio-cmd.h                    |     1 +
 drivers/soc/fsl/dpio/dpio-driver.c                 |    41 +-
 drivers/soc/fsl/dpio/dpio-service.c                |    41 +-
 drivers/soc/fsl/dpio/dpio.c                        |    23 +
 drivers/soc/fsl/dpio/dpio.h                        |     4 +
 fs/crypto/keyinfo.c                                |     4 +-
 fs/ecryptfs/crypto.c                               |     5 +-
 include/crypto/algapi.h                            |     8 +-
 include/crypto/arc4.h                              |    13 +
 include/crypto/if_alg.h                            |     7 -
 include/crypto/internal/cryptouser.h               |     2 +
 include/crypto/internal/hash.h                     |     6 +-
 include/crypto/internal/skcipher.h                 |    15 +
 include/crypto/morus1280_glue.h                    |     7 +-
 include/crypto/morus640_glue.h                     |     7 +-
 include/crypto/morus_common.h                      |     7 +-
 include/crypto/streebog.h                          |     2 +-
 include/crypto/xts.h                               |     4 +-
 include/linux/crypto.h                             |    10 +-
 include/linux/fsl/mc.h                             |     1 +
 include/soc/fsl/dpaa2-io.h                         |    11 +-
 170 files changed, 11316 insertions(+), 13833 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
