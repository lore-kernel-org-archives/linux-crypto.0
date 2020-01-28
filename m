Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB54C33CB3
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 05:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D03FA2467B
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 05:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgA1FEN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 00:04:13 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:38204 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgA1FEM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 00:04:12 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iwJ2m-0000lu-Tv; Tue, 28 Jan 2020 13:04:08 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iwJ26-0004xV-5t; Tue, 28 Jan 2020 13:03:26 +0800
Date:   Tue, 28 Jan 2020 13:03:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Update for 5.6
Message-ID: <20200128050326.x3cfjz3rj7ep6xr2@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20191125034536.wlgw25gpgn7y7vni@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191125034536.wlgw25gpgn7y7vni@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

API:

- Removed CRYPTO_TFM_RES flags.
- Extended spawn grabbing to all algorithm types.
- Moved hash descsize verification into API code.

Algorithms:

- Fixed recursive pcrypt dead-lock.
- Added new 32 and 64-bit generic versions of poly1305.
- Added cryptogams implementation of x86/poly1305.
-

Drivers:

- Added support for i.MX8M Mini in caam.
- Added support for i.MX8M Nano in caam.
- Added support for i.MX8M Plus in caam.
- Added support for A33 variant of SS in sun4i-ss.
- Added TEE support for Raven Ridge in ccp.
- Added in-kernel API to submit TEE commands in ccp.
- Added AMD-TEE driver.
- Added support for BCM2711 in iproc-rng200.
- Added support for AES256-GCM based ciphers for chtls.
- Added aead support on SEC2 in hisilicon.

The following changes since commit e42617b825f8073569da76dc4510bfa019b1c35a:

  Linux 5.5-rc1 (2019-12-08 14:57:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to 0bc81767c5bd9d005fae1099fb39eb3688370cb1:

  crypto: arm/chacha - fix build failured when kernel mode NEON is disabled (2020-01-22 16:21:11 +0800)

----------------------------------------------------------------
Adam Ford (1):
      crypto: caam - Add support for i.MX8M Mini

Andrei Botila (2):
      crypto: caam - remove double buffering for ahash
      crypto: caam/qi2 - remove double buffering for ahash

Ard Biesheuvel (9):
      crypto: ccp - set max RSA modulus size for v3 platform devices as well
      crypto: arm64/ghash-neon - bump priority to 150
      crypto: omap-aes - reject invalid input sizes for block modes
      crypto: omap-aes-ctr - set blocksize to 1
      crypto: omap-aes-gcm - deal with memory allocation failure
      crypto: omap-aes-gcm - add missing .setauthsize hooks
      crypto: omap-aes-gcm - check length of assocdata in RFC4106 mode
      crypto: omap-aes-gcm - use the AES library to encrypt the tag
      crypto: arm/chacha - fix build failured when kernel mode NEON is disabled

Arnd Bergmann (1):
      crypto: hisilicon/sec2 - Use atomics instead of __sync

Ayush Sawal (2):
      crypto: chelsio - calculating tx_channel_id as per the max number of channels
      crypto: chelsio - Resetting crypto counters during the driver unregister

Ben Dooks (Codethink) (1):
      crypto: sun4i-ss - make unexported sun4i_ss_pm_ops static

Brendan Higgins (2):
      crypto: inside-secure - add unspecified HAS_IOMEM dependency
      crypto: amlogic - add unspecified HAS_IOMEM dependency

Chen Zhou (2):
      crypto: allwinner - remove unneeded semicolon
      crypto: api - remove unneeded semicolon

Christian Lamparter (2):
      crypto: crypto4xx - reduce memory fragmentation
      crypto: crypto4xx - use GFP_KERNEL for big allocations

Chuhong Yuan (1):
      crypto: picoxcell - adjust the position of tasklet_init and fix missed tasklet_kill

Colin Ian King (2):
      tee: fix memory allocation failure checks on drv_data and amdtee
      crypto: hisilicon - fix spelling mistake "disgest" -> "digest"

Corentin Labbe (5):
      crypto: sun4i-ss - add the A33 variant of SS
      crypto: sun8i-ss - fix removal of module
      crypto: amlogic - fix removal of module
      crypto: sun8i-ce - fix removal of module
      crypto: sun8i-ce - remove dead code

Daniel Axtens (1):
      crypto: vmx - reject xts inputs that are too short

Daniel Jordan (6):
      padata: validate cpumask without removed CPU during offline
      padata: always acquire cpu_hotplug_lock before pinst->lock
      padata: remove cpumask change notifier
      padata: remove reorder_objects
      padata: update documentation
      padata: update documentation file path in MAINTAINERS

Eneas U de Queiroz (6):
      crypto: qce - fix ctr-aes-qce block, chunk sizes
      crypto: qce - fix xts-aes-qce key sizes
      crypto: qce - save a sg table slot for result buf
      crypto: qce - update the skcipher IV
      crypto: qce - initialize fallback only for AES
      crypto: qce - allow building only hashes/ciphers

Eric Biggers (63):
      crypto: hisilicon - select CRYPTO_SKCIPHER, not CRYPTO_BLKCIPHER
      crypto: api - remove another reference to blkcipher
      crypto: skcipher - remove crypto_skcipher::ivsize
      crypto: skcipher - remove crypto_skcipher::keysize
      crypto: skcipher - remove crypto_skcipher::setkey
      crypto: skcipher - remove crypto_skcipher::encrypt
      crypto: skcipher - remove crypto_skcipher::decrypt
      crypto: skcipher - remove crypto_skcipher_extsize()
      crypto: shash - allow essiv and hmac to use OPTIONAL_KEY algorithms
      crypto: aead - move crypto_aead_maxauthsize() to <crypto/aead.h>
      crypto: skcipher - add crypto_skcipher_min_keysize()
      crypto: testmgr - don't try to decrypt uninitialized buffers
      crypto: testmgr - check skcipher min_keysize
      crypto: testmgr - test setting misaligned keys
      crypto: testmgr - create struct aead_extra_tests_ctx
      crypto: testmgr - generate inauthentic AEAD test vectors
      crypto: compress - remove crt_u.compress (struct compress_tfm)
      crypto: cipher - remove crt_u.cipher (struct cipher_tfm)
      crypto: doc - remove references to ARC4
      crypto: algapi - make unregistration functions return void
      crypto: skcipher - remove skcipher_walk_aead()
      crypto: chelsio - fix writing tfm flags to wrong place
      crypto: artpec6 - return correct error code for failed setkey()
      crypto: atmel-sha - fix error handling when setting hmac key
      crypto: remove unused tfm result flags
      crypto: remove CRYPTO_TFM_RES_BAD_BLOCK_LEN
      crypto: remove CRYPTO_TFM_RES_BAD_KEY_LEN
      crypto: remove CRYPTO_TFM_RES_WEAK_KEY
      crypto: remove propagation of CRYPTO_TFM_RES_* flags
      crypto: algapi - make crypto_drop_spawn() a no-op on uninitialized spawns
      crypto: algapi - make crypto_grab_spawn() handle an ERR_PTR() name
      crypto: shash - make struct shash_instance be the full size
      crypto: ahash - make struct ahash_instance be the full size
      crypto: skcipher - pass instance to crypto_grab_skcipher()
      crypto: aead - pass instance to crypto_grab_aead()
      crypto: akcipher - pass instance to crypto_grab_akcipher()
      crypto: algapi - pass instance to crypto_grab_spawn()
      crypto: shash - introduce crypto_grab_shash()
      crypto: ahash - introduce crypto_grab_ahash()
      crypto: cipher - introduce crypto_cipher_spawn and crypto_grab_cipher()
      crypto: adiantum - use crypto_grab_{cipher,shash} and simplify error paths
      crypto: cryptd - use crypto_grab_shash() and simplify error paths
      crypto: hmac - use crypto_grab_shash() and simplify error paths
      crypto: authenc - use crypto_grab_ahash() and simplify error paths
      crypto: authencesn - use crypto_grab_ahash() and simplify error paths
      crypto: gcm - use crypto_grab_ahash() and simplify error paths
      crypto: ccm - use crypto_grab_ahash() and simplify error paths
      crypto: chacha20poly1305 - use crypto_grab_ahash() and simplify error paths
      crypto: skcipher - use crypto_grab_cipher() and simplify error paths
      crypto: cbcmac - use crypto_grab_cipher() and simplify error paths
      crypto: cmac - use crypto_grab_cipher() and simplify error paths
      crypto: vmac - use crypto_grab_cipher() and simplify error paths
      crypto: xcbc - use crypto_grab_cipher() and simplify error paths
      crypto: cipher - make crypto_spawn_cipher() take a crypto_cipher_spawn
      crypto: algapi - remove obsoleted instance creation helpers
      crypto: ahash - unexport crypto_ahash_type
      crypto: algapi - fold crypto_init_spawn() into crypto_grab_spawn()
      crypto: hash - add support for new way of freeing instances
      crypto: geniv - convert to new way of freeing instances
      crypto: cryptd - convert to new way of freeing instances
      crypto: shash - convert shash_free_instance() to new style
      crypto: algapi - remove crypto_template::{alloc,free}()
      crypto: algapi - enforce that all instances have a ->free() method

Gary R Hook (1):
      crypto: ccp - Update MAINTAINERS for CCP driver

Geert Uytterhoeven (1):
      crypto: essiv - fix AEAD capitalization and preposition use in help text

Gilad Ben-Yossef (10):
      crypto: ccree - remove useless define
      crypto: ccree - fix backlog memory leak
      crypto: ccree - fix AEAD decrypt auth fail
      crypto: ccree - turn errors to debug msgs
      crypto: ccree - fix pm wrongful error reporting
      crypto: ccree - cc_do_send_request() is void func
      crypto: ccree - fix PM race condition
      crypto: ccree - split overloaded usage of irq field
      crypto: ccree - make cc_pm_put_suspend() void
      crypto: ccree - erase unneeded inline funcs

Greg Kroah-Hartman (1):
      crypto: hisilicon - still no need to check return value of debugfs_create functions

Hadar Gat (4):
      crypto: ccree - fix typos in comments
      crypto: ccree - fix typos in error msgs
      crypto: ccree - fix typos in error msgs
      crypto: ccree - fix typo in comment

Herbert Xu (18):
      padata: Remove broken queue flushing
      crypto: pcrypt - Fix user-after-free on module unload
      padata: Remove unused padata_remove_cpu
      crypto: pcrypt - Avoid deadlock by using per-instance padata queues
      crypto: pcrypt - Do not clear MAY_SLEEP flag in original request
      crypto: af_alg - Use bh_lock_sock in sk_destruct
      crypto: api - Check spawn->alg under lock in crypto_drop_spawn
      crypto: api - Fix race condition in crypto_spawn_alg
      crypto: api - Do not zap spawn->alg
      crypto: api - Add more comments to crypto_remove_spawns
      crypto: shash - Add init_tfm/exit_tfm and verify descsize
      crypto: padlock-sha - Use init_tfm/exit_tfm interface
      crypto: hmac - Use init_tfm/exit_tfm interface
      crypto: api - fix unexpectedly getting generic implementation
      crypto: api - Retain alg refcount in crypto_grab_spawn
      crypto: skcipher - Add skcipher_ialg_simple helper
      Merge git://git.kernel.org/.../herbert/crypto-2.6
      crypto: curve25519 - Fix selftest build error

Horia Geantă (3):
      crypto: caam - add support for i.MX8M Nano
      crypto: caam/qi2 - fix typo in algorithm's driver name
      crypto: caam - add support for i.MX8M Plus

Iuliana Prodan (1):
      crypto: caam - do not reset pointer size from MCFGR register

Jason A. Donenfeld (9):
      crypto: arm/curve25519 - add arch-specific key generation function
      crypto: lib/curve25519 - re-add selftests
      crypto: poly1305 - add new 32 and 64-bit generic versions
      crypto: x86/poly1305 - import unmodified cryptogams implementation
      crypto: x86/poly1305 - wire up faster implementations for kernel
      crypto: {arm,arm64,mips}/poly1305 - remove redundant non-reduction from emit
      crypto: x86/poly1305 - fix .gitignore typo
      crypto: chacha20poly1305 - add back missing test vectors and test chunking
      crypto: x86/poly1305 - emit does base conversion itself

Jonathan Cameron (2):
      crypto: hisilicon - Fix issue with wrong number of sg elements after dma map
      crypto: hisilicon - Use the offset fields in sqe to avoid need to split scatterlists

Kamil Konieczny (1):
      MAINTAINERS: update my e-mail address

Kees Cook (2):
      crypto: x86 - Regularize glue function prototypes
      crypto: x86/sha - Eliminate casts on asm implementations

Krzysztof Kozlowski (2):
      crypto: Kconfig - Fix indentation
      crypto: exynos-rng - Rename Exynos to lowercase

Mark Brown (1):
      crypto: arm64 - Use modern annotations for assembly functions

Ofir Drang (1):
      crypto: ccree - fix FDE descriptor sequence

Pascal van Leeuwen (3):
      crypto: inside-secure - Fix Unable to fit even 1 command desc error w/ EIP97
      crypto: inside-secure - Fix hang case on EIP97 with zero length input data
      crypto: inside-secure - Fix hang case on EIP97 with basic DES/3DES ops

Peter Ujfalusi (5):
      crypto: atmel-aes - Retire dma_request_slave_channel_compat()
      crypto: atmel-sha - Retire dma_request_slave_channel_compat()
      crypto: atmel-tdes - Retire dma_request_slave_channel_compat()
      crypto: img-hash - Use dma_request_chan instead dma_request_slave_channel
      crypto: stm32/hash - Use dma_request_chan() instead dma_request_slave_channel()

Rijo Thomas (15):
      crypto: ccp - rename psp-dev files to sev-dev
      crypto: ccp - create a generic psp-dev file
      crypto: ccp - move SEV vdata to a dedicated data structure
      crypto: ccp - check whether PSP supports SEV or TEE before initialization
      crypto: ccp - add TEE support for Raven Ridge
      crypto: ccp - provide in-kernel API to submit TEE commands
      tee: allow compilation of tee subsystem for AMD CPUs
      tee: add AMD-TEE driver
      tee: amdtee: check TEE status during driver initialization
      Documentation: tee: add AMD-TEE driver details
      tee: amdtee: remove unused variable initialization
      tee: amdtee: print error message if tee not present
      tee: amdtee: skip tee_device_unregister if tee_device_alloc fails
      tee: amdtee: rename err label to err_device_unregister
      tee: amdtee: remove redundant NULL check for pool

Sami Tolvanen (1):
      crypto: arm64/sha - fix function types

Stefan Wahren (2):
      dt-bindings: rng: add BCM2711 RNG compatible
      hwrng: iproc-rng200 - Add support for BCM2711

Tero Kristo (15):
      crypto: omap-sham - split up data to multiple sg elements with huge data
      crypto: omap-sham - remove the sysfs group during driver removal
      crypto: omap-aes - remove the sysfs group during driver removal
      crypto: omap-des - add IV output handling
      crypto: omap-aes - add IV output handling
      crypto: omap-sham - fix buffer handling for split test cases
      crypto: omap-aes-gcm - fix corner case with only auth data
      crypto: omap-sham - fix split update cases with cryptomgr tests
      crypto: omap-aes - fixup aligned data cleanup
      crypto: omap-aes-gcm - fix failure with assocdata only
      crypto: omap-sham - fix unaligned sg list handling
      crypto: omap-aes-gcm - convert to use crypto engine
      crypto: omap-des - avoid unnecessary spam with bad cryptlen
      crypto: omap-des - handle NULL cipher request
      crypto: omap-crypto - copy the temporary data to output buffer properly

Tudor Ambarus (23):
      crypto: atmel-tdes - Constify value to write to hw
      crypto: atmel-{sha,tdes} - Change algorithm priorities
      crypto: atmel-tdes - Remove unused header includes
      crypto: atmel-{sha,tdes} - Propagate error from _hw_version_init()
      crypto: atmel-{aes,sha,tdes} - Drop superfluous error message in probe()
      crypto: atmel-{aes,sha,tdes} - Rename labels in probe()
      crypto: atmel-tdes - Remove useless write in Control Register
      crypto: atmel-tdes - Map driver data flags to Mode Register
      crypto: atmel-tdes - Drop unnecessary passing of tfm
      crypto: atmel-{aes,tdes} - Do not save IV for ECB mode
      crypto: atmel-aes - Fix counter overflow in CTR mode
      crypto: atmel-aes - Fix saving of IV for CTR mode
      crypto: atmel-{sha,tdes} - Remove unused 'err' member of driver data
      crypto: atmel-sha - Void return type for atmel_sha_update_dma_stop()
      crypto: atmel-aes - Use gcm helper to check authsize
      crypto: atmel-{aes,sha,tdes} - Group common alg type init in dedicated methods
      crypto: atmel-{aes,sha} - Fix incorrect use of dmaengine_terminate_all()
      crypto: atmel-{aes,sha,tdes} - Drop duplicate init of dma_slave_config.direction
      crypto: atmel-{aes,sha,tdes} - Stop passing unused argument in _dma_init()
      crypto: atmel-{sha,tdes} - Print warn message even when deferring
      crypto: atmel-{aes,tdes} - Update the IV only when the op succeeds
      crypto: atmel-aes - Fix CTR counter overflow when multiple fragments
      crypto: atmel-{aes,sha,tdes} - Retire crypto_platform_data

Valdis Kletnieks (1):
      crypto: chacha - fix warning message in header file

Vinay Kumar Yadav (4):
      crypto: chtls - Add support for AES256-GCM based ciphers
      crypto: chtls - Fixed memory leak
      crypto: chtls - Corrected function call context
      crypto: chtls - Fixed listen fail when max stid range reached

Zaibo Xu (13):
      crypto: hisilicon - Update debugfs usage of SEC V2
      crypto: hisilicon - fix print/comment of SEC V2
      crypto: hisilicon - Update some names on SEC V2
      crypto: hisilicon - Update QP resources of SEC V2
      crypto: hisilicon - Adjust some inner logic
      crypto: hisilicon - Add callback error check
      crypto: hisilicon - Add branch prediction macro
      crypto: hisilicon - redefine skcipher initiation
      crypto: hisilicon - Add aead support on SEC2
      crypto: hisilicon - Bugfixed tfm leak
      crypto: hisilicon - Fixed some tiny bugs of HPRE
      crypto: hisilicon - adjust hpre_crt_para_get
      crypto: hisilicon - add branch prediction macro

Zhou Wang (1):
      crypto: hisilicon - Remove useless MODULE macros

zhengbin (1):
      crypto: inside-secure - Use PTR_ERR_OR_ZERO() to simplify code

 .mailmap                                           |    1 +
 Documentation/core-api/index.rst                   |    1 +
 Documentation/core-api/padata.rst                  |  169 +
 Documentation/crypto/devel-algos.rst               |   38 +-
 .../devicetree/bindings/rng/brcm,iproc-rng200.txt  |    1 +
 Documentation/padata.txt                           |  163 -
 Documentation/tee.txt                              |   81 +
 MAINTAINERS                                        |    5 +-
 arch/arm/crypto/aes-ce-glue.c                      |   14 +-
 arch/arm/crypto/chacha-glue.c                      |    4 +-
 arch/arm/crypto/crc32-ce-glue.c                    |    4 +-
 arch/arm/crypto/curve25519-glue.c                  |    7 +
 arch/arm/crypto/ghash-ce-glue.c                    |   11 +-
 arch/arm/crypto/poly1305-glue.c                    |   18 +-
 arch/arm64/crypto/aes-ce-ccm-core.S                |   16 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c                |    8 +-
 arch/arm64/crypto/aes-ce-core.S                    |   16 +-
 arch/arm64/crypto/aes-ce-glue.c                    |    8 +-
 arch/arm64/crypto/aes-ce.S                         |    4 +-
 arch/arm64/crypto/aes-cipher-core.S                |    8 +-
 arch/arm64/crypto/aes-glue.c                       |   31 +-
 arch/arm64/crypto/aes-modes.S                      |   16 +-
 arch/arm64/crypto/aes-neon.S                       |    4 +-
 arch/arm64/crypto/aes-neonbs-core.S                |   40 +-
 arch/arm64/crypto/chacha-neon-core.S               |   16 +-
 arch/arm64/crypto/crct10dif-ce-core.S              |   12 +-
 arch/arm64/crypto/ghash-ce-core.S                  |    8 +-
 arch/arm64/crypto/ghash-ce-glue.c                  |   10 +-
 arch/arm64/crypto/nh-neon-core.S                   |    4 +-
 arch/arm64/crypto/poly1305-glue.c                  |   18 +-
 arch/arm64/crypto/sha1-ce-core.S                   |    4 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |   17 +-
 arch/arm64/crypto/sha2-ce-core.S                   |    4 +-
 arch/arm64/crypto/sha2-ce-glue.c                   |   34 +-
 arch/arm64/crypto/sha256-glue.c                    |   32 +-
 arch/arm64/crypto/sha3-ce-core.S                   |    4 +-
 arch/arm64/crypto/sha512-ce-core.S                 |    4 +-
 arch/arm64/crypto/sha512-ce-glue.c                 |   26 +-
 arch/arm64/crypto/sha512-glue.c                    |   15 +-
 arch/arm64/crypto/sm3-ce-core.S                    |    4 +-
 arch/arm64/crypto/sm4-ce-core.S                    |    4 +-
 arch/mips/crypto/crc32-mips.c                      |    4 +-
 arch/mips/crypto/poly1305-glue.c                   |   18 +-
 arch/powerpc/crypto/aes-spe-glue.c                 |   18 +-
 arch/powerpc/crypto/crc32c-vpmsum_glue.c           |    4 +-
 arch/s390/crypto/aes_s390.c                        |   27 +-
 arch/s390/crypto/crc32-vx.c                        |    8 +-
 arch/s390/crypto/ghash_s390.c                      |    4 +-
 arch/s390/crypto/paes_s390.c                       |   25 +-
 arch/sparc/crypto/aes_glue.c                       |    2 -
 arch/sparc/crypto/camellia_glue.c                  |    5 +-
 arch/sparc/crypto/crc32c_glue.c                    |    4 +-
 arch/x86/crypto/.gitignore                         |    1 +
 arch/x86/crypto/Makefile                           |   11 +-
 arch/x86/crypto/aegis128-aesni-glue.c              |    4 +-
 arch/x86/crypto/aesni-intel_asm.S                  |    8 +-
 arch/x86/crypto/aesni-intel_glue.c                 |   55 +-
 arch/x86/crypto/blake2s-glue.c                     |    4 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c         |   77 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c          |   81 +-
 arch/x86/crypto/camellia_glue.c                    |   54 +-
 arch/x86/crypto/cast6_avx_glue.c                   |   74 +-
 arch/x86/crypto/crc32-pclmul_glue.c                |    4 +-
 arch/x86/crypto/crc32c-intel_glue.c                |    4 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |   11 +-
 arch/x86/crypto/glue_helper.c                      |   23 +-
 arch/x86/crypto/poly1305-avx2-x86_64.S             |  390 --
 arch/x86/crypto/poly1305-sse2-x86_64.S             |  590 ---
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl      | 4265 ++++++++++++++++++++
 arch/x86/crypto/poly1305_glue.c                    |  304 +-
 arch/x86/crypto/serpent_avx2_glue.c                |   65 +-
 arch/x86/crypto/serpent_avx_glue.c                 |   63 +-
 arch/x86/crypto/serpent_sse2_glue.c                |   30 +-
 arch/x86/crypto/sha1_avx2_x86_64_asm.S             |    6 +-
 arch/x86/crypto/sha1_ssse3_asm.S                   |   14 +-
 arch/x86/crypto/sha1_ssse3_glue.c                  |   70 +-
 arch/x86/crypto/sha256-avx-asm.S                   |    4 +-
 arch/x86/crypto/sha256-avx2-asm.S                  |    4 +-
 arch/x86/crypto/sha256-ssse3-asm.S                 |    6 +-
 arch/x86/crypto/sha256_ssse3_glue.c                |   34 +-
 arch/x86/crypto/sha512-avx-asm.S                   |   11 +-
 arch/x86/crypto/sha512-avx2-asm.S                  |   11 +-
 arch/x86/crypto/sha512-ssse3-asm.S                 |   13 +-
 arch/x86/crypto/sha512_ssse3_glue.c                |   31 +-
 arch/x86/crypto/twofish_avx_glue.c                 |   81 +-
 arch/x86/crypto/twofish_glue_3way.c                |   37 +-
 arch/x86/include/asm/crypto/camellia.h             |   65 +-
 arch/x86/include/asm/crypto/glue_helper.h          |   18 +-
 arch/x86/include/asm/crypto/serpent-avx.h          |   20 +-
 arch/x86/include/asm/crypto/serpent-sse2.h         |   28 +-
 arch/x86/include/asm/crypto/twofish.h              |   19 +-
 crypto/Kconfig                                     |    4 +-
 crypto/acompress.c                                 |    4 +-
 crypto/adiantum.c                                  |  102 +-
 crypto/aead.c                                      |   15 +-
 crypto/aegis128-core.c                             |    4 +-
 crypto/aes_generic.c                               |   18 +-
 crypto/af_alg.c                                    |    6 +-
 crypto/ahash.c                                     |   54 +-
 crypto/akcipher.c                                  |    9 +-
 crypto/algapi.c                                    |  248 +-
 crypto/algboss.c                                   |   12 +-
 crypto/anubis.c                                    |    2 -
 crypto/api.c                                       |   24 +-
 crypto/authenc.c                                   |   70 +-
 crypto/authencesn.c                                |   70 +-
 crypto/blake2b_generic.c                           |    4 +-
 crypto/blake2s_generic.c                           |    4 +-
 crypto/camellia_generic.c                          |    5 +-
 crypto/cast6_generic.c                             |   28 +-
 crypto/cbc.c                                       |   15 +-
 crypto/ccm.c                                       |  136 +-
 crypto/cfb.c                                       |    5 +-
 crypto/chacha20poly1305.c                          |   96 +-
 crypto/cipher.c                                    |   93 +-
 crypto/cmac.c                                      |   40 +-
 crypto/compress.c                                  |   31 +-
 crypto/crc32_generic.c                             |    4 +-
 crypto/crc32c_generic.c                            |    4 +-
 crypto/cryptd.c                                    |  131 +-
 crypto/crypto_user_base.c                          |    3 +-
 crypto/ctr.c                                       |   26 +-
 crypto/cts.c                                       |   15 +-
 crypto/des_generic.c                               |   10 +-
 crypto/ecb.c                                       |    5 +-
 crypto/echainiv.c                                  |   20 +-
 crypto/essiv.c                                     |   44 +-
 crypto/gcm.c                                       |   96 +-
 crypto/geniv.c                                     |   19 +-
 crypto/ghash-generic.c                             |    4 +-
 crypto/hmac.c                                      |   62 +-
 crypto/internal.h                                  |    4 -
 crypto/keywrap.c                                   |   15 +-
 crypto/lrw.c                                       |   17 +-
 crypto/michael_mic.c                               |    4 +-
 crypto/nhpoly1305.c                                |    2 +-
 crypto/ofb.c                                       |    5 +-
 crypto/pcbc.c                                      |    5 +-
 crypto/pcrypt.c                                    |   44 +-
 crypto/poly1305_generic.c                          |   25 +-
 crypto/rsa-pkcs1pad.c                              |    8 +-
 crypto/scompress.c                                 |    4 +-
 crypto/seqiv.c                                     |   20 +-
 crypto/serpent_generic.c                           |    6 +-
 crypto/shash.c                                     |   95 +-
 crypto/simd.c                                      |   12 +-
 crypto/skcipher.c                                  |   97 +-
 crypto/sm4_generic.c                               |   16 +-
 crypto/testmgr.c                                   |  584 ++-
 crypto/testmgr.h                                   |   14 +-
 crypto/twofish_common.c                            |    8 +-
 crypto/vmac.c                                      |   44 +-
 crypto/xcbc.c                                      |   45 +-
 crypto/xts.c                                       |   17 +-
 crypto/xxhash_generic.c                            |    4 +-
 drivers/char/hw_random/Kconfig                     |    2 +-
 drivers/char/hw_random/iproc-rng200.c              |    1 +
 drivers/crypto/Kconfig                             |   89 +-
 .../crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c    |    1 -
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c  |   24 +-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c  |    5 +-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h       |    9 +
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |    6 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |    6 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |    8 -
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |    2 -
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |    4 +-
 drivers/crypto/amcc/crypto4xx_alg.c                |   31 +-
 drivers/crypto/amcc/crypto4xx_core.c               |   37 +-
 drivers/crypto/amlogic/Kconfig                     |    1 +
 drivers/crypto/amlogic/amlogic-gxl-cipher.c        |    1 -
 drivers/crypto/amlogic/amlogic-gxl-core.c          |    4 +-
 drivers/crypto/atmel-aes.c                         |  359 +-
 drivers/crypto/atmel-authenc.h                     |    3 +-
 drivers/crypto/atmel-sha.c                         |  473 +--
 drivers/crypto/atmel-tdes.c                        |  375 +-
 drivers/crypto/axis/artpec6_crypto.c               |   10 +-
 drivers/crypto/bcm/cipher.c                        |   17 +-
 drivers/crypto/caam/Kconfig                        |   14 +-
 drivers/crypto/caam/caamalg.c                      |   33 +-
 drivers/crypto/caam/caamalg_qi.c                   |   44 +-
 drivers/crypto/caam/caamalg_qi2.c                  |  206 +-
 drivers/crypto/caam/caamhash.c                     |  167 +-
 drivers/crypto/caam/ctrl.c                         |   15 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c             |    2 -
 drivers/crypto/cavium/nitrox/nitrox_aead.c         |    4 +-
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c     |   12 +-
 drivers/crypto/ccp/Makefile                        |    4 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c           |    1 -
 drivers/crypto/ccp/ccp-crypto-aes-galois.c         |    1 -
 drivers/crypto/ccp/ccp-crypto-aes.c                |    1 -
 drivers/crypto/ccp/ccp-crypto-sha.c                |    4 +-
 drivers/crypto/ccp/ccp-dev-v3.c                    |    1 +
 drivers/crypto/ccp/psp-dev.c                       | 1042 +----
 drivers/crypto/ccp/psp-dev.h                       |   51 +-
 drivers/crypto/ccp/sev-dev.c                       | 1077 +++++
 drivers/crypto/ccp/sev-dev.h                       |   63 +
 drivers/crypto/ccp/sp-dev.h                        |   17 +-
 drivers/crypto/ccp/sp-pci.c                        |   43 +-
 drivers/crypto/ccp/tee-dev.c                       |  375 ++
 drivers/crypto/ccp/tee-dev.h                       |  110 +
 drivers/crypto/ccree/cc_aead.c                     |   43 +-
 drivers/crypto/ccree/cc_cipher.c                   |   58 +-
 drivers/crypto/ccree/cc_driver.c                   |   24 +-
 drivers/crypto/ccree/cc_driver.h                   |    6 +-
 drivers/crypto/ccree/cc_fips.c                     |    2 +-
 drivers/crypto/ccree/cc_hash.c                     |    8 -
 drivers/crypto/ccree/cc_pm.c                       |   39 +-
 drivers/crypto/ccree/cc_pm.h                       |   17 +-
 drivers/crypto/ccree/cc_request_mgr.c              |  103 +-
 drivers/crypto/ccree/cc_request_mgr.h              |    8 -
 drivers/crypto/chelsio/Kconfig                     |   30 +-
 drivers/crypto/chelsio/chcr_algo.c                 |   53 +-
 drivers/crypto/chelsio/chcr_core.c                 |   10 +-
 drivers/crypto/chelsio/chtls/chtls.h               |    7 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c            |   57 +-
 drivers/crypto/chelsio/chtls/chtls_cm.h            |   21 +
 drivers/crypto/chelsio/chtls/chtls_hw.c            |   65 +-
 drivers/crypto/chelsio/chtls/chtls_main.c          |   28 +-
 drivers/crypto/geode-aes.c                         |   24 +-
 drivers/crypto/hisilicon/Kconfig                   |   11 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |  141 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   60 +-
 drivers/crypto/hisilicon/sec2/sec.h                |   53 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  963 ++++-
 drivers/crypto/hisilicon/sec2/sec_crypto.h         |   22 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |   19 +-
 drivers/crypto/hisilicon/sgl.c                     |   17 +-
 drivers/crypto/hisilicon/zip/zip.h                 |    4 +
 drivers/crypto/hisilicon/zip/zip_crypto.c          |   92 +-
 drivers/crypto/img-hash.c                          |    6 +-
 drivers/crypto/inside-secure/safexcel.c            |   12 +-
 drivers/crypto/inside-secure/safexcel.h            |   34 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |  600 +--
 drivers/crypto/inside-secure/safexcel_hash.c       |   36 +-
 drivers/crypto/inside-secure/safexcel_ring.c       |  130 +-
 drivers/crypto/ixp4xx_crypto.c                     |   31 +-
 drivers/crypto/marvell/cipher.c                    |    4 +-
 drivers/crypto/mediatek/mtk-aes.c                  |    4 -
 drivers/crypto/mxs-dcp.c                           |   12 +-
 drivers/crypto/n2_core.c                           |    1 -
 drivers/crypto/omap-aes-gcm.c                      |  223 +-
 drivers/crypto/omap-aes.c                          |  142 +-
 drivers/crypto/omap-aes.h                          |   12 +-
 drivers/crypto/omap-crypto.c                       |   37 +-
 drivers/crypto/omap-des.c                          |   13 +-
 drivers/crypto/omap-sham.c                         |  191 +-
 drivers/crypto/padlock-aes.c                       |    9 +-
 drivers/crypto/padlock-sha.c                       |   26 +-
 drivers/crypto/picoxcell_crypto.c                  |   30 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |    6 +-
 drivers/crypto/qce/Makefile                        |    7 +-
 drivers/crypto/qce/common.c                        |  244 +-
 drivers/crypto/qce/core.c                          |    4 +
 drivers/crypto/qce/dma.c                           |    6 +-
 drivers/crypto/qce/dma.h                           |    3 +-
 drivers/crypto/qce/sha.c                           |    2 -
 drivers/crypto/qce/skcipher.c                      |   41 +-
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c   |    4 +-
 drivers/crypto/sahara.c                            |    9 +-
 drivers/crypto/stm32/Kconfig                       |    6 +-
 drivers/crypto/stm32/stm32-crc32.c                 |    4 +-
 drivers/crypto/stm32/stm32-hash.c                  |    6 +-
 drivers/crypto/talitos.c                           |   15 +-
 drivers/crypto/ux500/Kconfig                       |   16 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |    2 -
 drivers/crypto/virtio/virtio_crypto_algs.c         |    8 +-
 drivers/crypto/vmx/aes_xts.c                       |    3 +
 drivers/tee/Kconfig                                |    4 +-
 drivers/tee/Makefile                               |    1 +
 drivers/tee/amdtee/Kconfig                         |    8 +
 drivers/tee/amdtee/Makefile                        |    5 +
 drivers/tee/amdtee/amdtee_if.h                     |  183 +
 drivers/tee/amdtee/amdtee_private.h                |  159 +
 drivers/tee/amdtee/call.c                          |  373 ++
 drivers/tee/amdtee/core.c                          |  518 +++
 drivers/tee/amdtee/shm_pool.c                      |   93 +
 fs/ecryptfs/crypto.c                               |    2 +-
 fs/ecryptfs/keystore.c                             |    4 +-
 include/crypto/aead.h                              |   10 +
 include/crypto/algapi.h                            |   84 +-
 include/crypto/cast6.h                             |    7 +-
 include/crypto/hash.h                              |   13 +
 include/crypto/internal/acompress.h                |    4 +-
 include/crypto/internal/aead.h                     |   21 +-
 include/crypto/internal/akcipher.h                 |   12 +-
 include/crypto/internal/chacha.h                   |    2 +-
 include/crypto/internal/des.h                      |   23 +-
 include/crypto/internal/geniv.h                    |    1 -
 include/crypto/internal/hash.h                     |   90 +-
 include/crypto/internal/poly1305.h                 |   45 +-
 include/crypto/internal/scompress.h                |    4 +-
 include/crypto/internal/skcipher.h                 |   27 +-
 include/crypto/nhpoly1305.h                        |    4 +-
 include/crypto/poly1305.h                          |   26 +-
 include/crypto/serpent.h                           |    4 +-
 include/crypto/skcipher.h                          |   26 +-
 include/crypto/twofish.h                           |    2 +-
 include/crypto/xts.h                               |   21 +-
 include/linux/cpuhotplug.h                         |    1 +
 include/linux/crypto.h                             |  104 +-
 include/linux/padata.h                             |   56 +-
 include/linux/platform_data/crypto-atmel.h         |   23 -
 include/linux/psp-tee.h                            |   91 +
 include/uapi/linux/tee.h                           |    1 +
 kernel/padata.c                                    |  386 +-
 lib/crypto/Kconfig                                 |    2 +-
 lib/crypto/Makefile                                |   14 +-
 lib/crypto/chacha20poly1305-selftest.c             | 1712 +++++++-
 lib/crypto/curve25519-generic.c                    |   24 +
 lib/crypto/curve25519-selftest.c                   | 1321 ++++++
 lib/crypto/curve25519.c                            |   20 +-
 lib/crypto/poly1305-donna32.c                      |  204 +
 lib/crypto/poly1305-donna64.c                      |  185 +
 lib/crypto/poly1305.c                              |  169 +-
 315 files changed, 16794 insertions(+), 8204 deletions(-)
 create mode 100644 Documentation/core-api/padata.rst
 delete mode 100644 Documentation/padata.txt
 create mode 100644 arch/x86/crypto/.gitignore
 delete mode 100644 arch/x86/crypto/poly1305-avx2-x86_64.S
 delete mode 100644 arch/x86/crypto/poly1305-sse2-x86_64.S
 create mode 100644 arch/x86/crypto/poly1305-x86_64-cryptogams.pl
 create mode 100644 drivers/crypto/ccp/sev-dev.c
 create mode 100644 drivers/crypto/ccp/sev-dev.h
 create mode 100644 drivers/crypto/ccp/tee-dev.c
 create mode 100644 drivers/crypto/ccp/tee-dev.h
 create mode 100644 drivers/tee/amdtee/Kconfig
 create mode 100644 drivers/tee/amdtee/Makefile
 create mode 100644 drivers/tee/amdtee/amdtee_if.h
 create mode 100644 drivers/tee/amdtee/amdtee_private.h
 create mode 100644 drivers/tee/amdtee/call.c
 create mode 100644 drivers/tee/amdtee/core.c
 create mode 100644 drivers/tee/amdtee/shm_pool.c
 delete mode 100644 include/linux/platform_data/crypto-atmel.h
 create mode 100644 include/linux/psp-tee.h
 create mode 100644 lib/crypto/curve25519-generic.c
 create mode 100644 lib/crypto/curve25519-selftest.c
 create mode 100644 lib/crypto/poly1305-donna32.c
 create mode 100644 lib/crypto/poly1305-donna64.c

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
