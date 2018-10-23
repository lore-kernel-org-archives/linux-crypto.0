Return-Path: <SRS0=BLQr=ND=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57130 "EHLO
        fornost.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbeJWScv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Oct 2018 14:32:51 -0400
Date: Tue, 23 Oct 2018 21:09:59 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 4.20
Message-ID: <20181023100958.GA11991@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170904101225.GA12613@gondor.apana.org.au>
 <20171113074346.GA20245@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171113074346.GA20245@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

Here is the crypto update for 4.20:

API:

- Remove VLA usage.
- Add cryptostat user-space interface.
- Add notifier for new crypto algorithms.

Algorithms:

- Add OFB mode.
- Remove speck.

Drivers:

- Remove x86/sha*-mb as they are buggy.
- Remove pcbc(aes) from x86/aesni.
- Improve performance of arm/ghash-ce by up to 85%.
- Implement CTS-CBC in arm64/aes-blk, faster by up to 50%.
- Remove PMULL based arm64/crc32 driver.
- Use PMULL in arm64/crct10dif.
- Add aes-ctr support in s5p-sss.
- Add caam/qi2 driver.

Others:

- Pick better transform if one becomes available in crc-t10dif.

Please note that there is a conflict with the compiler-attributes
tree as one of the lines that was removed by a patch in the crypto
tree was moved to a different file in the compiler-attributes tree.
The fix is to remove that line from the moved file.

There is also a conflict with the mac80211 tree because the code
modified by the VLA fixes in the crypto tree has been removed in
the mac80211 tree.  The resolution is to simply use the mac80211
file.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ard Biesheuvel (17):
      crypto: ccm - Remove VLA usage
      crypto: x86 - remove SHA multibuffer routines and mcryptd
      crypto: arm/ghash-ce - implement support for 4-way aggregation
      crypto: arm64/aes-modes - get rid of literal load of addend vector
      crypto: arm64/crc32 - remove PMULL based CRC32 driver
      crypto: arm64/crct10dif - preparatory refactor for 8x8 PMULL version
      crypto: arm64/crct10dif - implement non-Crypto Extensions alternative
      crypto: arm64/aes-blk - remove pointless (u8 *) casts
      crypto: arm64/aes-blk - revert NEON yield for skciphers
      crypto: arm64/aes-blk - add support for CTS-CBC mode
      crypto: arm64/aes-blk - improve XTS mask handling
      crypto: x86/aes-ni - remove special handling of AES in PCBC mode
      crypto: qat - move temp buffers off the stack
      crypto: lrw - fix rebase error after out of bounds fix
      crypto: morus/generic - fix for big endian systems
      crypto: aegis/generic - fix for big endian systems
      crypto: arm64/aes-blk - ensure XTS mask is always loaded

Arnd Bergmann (2):
      crypto: caam/qi2 - add CONFIG_NETDEVICES dependency
      crypto: caam/qi2 - avoid double export

Brijesh Singh (1):
      crypto: ccp - add timeout support in the SEV command

Christoph Manszewski (4):
      crypto: s5p-sss: Fix race in error handling
      crypto: s5p-sss: Fix Fix argument list alignment
      crypto: s5p-sss: Minor code cleanup
      crypto: s5p-sss: Add aes-ctr support

Corentin Labbe (2):
      crypto: user - Implement a generic crypto statistics
      crypto: tools - Add cryptostat userspace

Dan Aloni (1):
      crypto: fix a memory leak in rsa-kcs1pad's encryption mode

Dan Douglass (1):
      crypto: mxs-dcp - Implement sha import/export

Eric Biggers (4):
      crypto: arm/chacha20 - faster 8-bit rotations and other optimizations
      crypto: chacha20 - Fix chacha20_block() keystream alignment (again)
      crypto: arm64/aes - fix handling sub-block CTS-CBC inputs
      crypto: x86/aes-ni - fix build error following fpu template removal

Gilad Ben-Yossef (3):
      crypto: testmgr - update sm4 test vectors
      crypto: ofb - add output feedback mode
      crypto: tcrypt - add OFB functional tests

Harsh Jain (1):
      crypto: chelsio - Update ntx queue received from cxgb4

Herbert Xu (2):
      Merge git://git.kernel.org/.../herbert/crypto-2.6
      Merge git://git.kernel.org/.../herbert/crypto-2.6

Horia Geantă (20):
      crypto: caam/jr - remove ablkcipher IV generation
      crypto: caam/qi - remove ablkcipher IV generation
      crypto: caam/jr - ablkcipher -> skcipher conversion
      crypto: caam/qi - ablkcipher -> skcipher conversion
      bus: fsl-mc: add support for dpseci device type
      soc: fsl: dpio: add back some frame queue functions
      soc: fsl: dpio: add frame list format support
      soc: fsl: dpio: add congestion notification support
      crypto: caam - fix implicit casts in endianness helpers
      crypto: caam - add DPAA2-CAAM (DPSECI) backend API
      crypto: caam - add Queue Interface v2 error codes
      crypto: caam/qi2 - add DPAA2-CAAM driver
      crypto: caam/qi2 - add skcipher algorithms
      crypto: caam - export ahash shared descriptor generation
      crypto: caam/qi2 - add support for ahash algorithms
      arm64: defconfig: enable CAAM crypto engine on QorIQ DPAA2 SoCs
      crypto: tcrypt - fix ghash-generic speed test
      crypto: tcrypt - remove remnants of pcomp-based zlib
      crypto: caam/qi - simplify CGR allocation, freeing
      crypto: caam - add SPDX license identifier to all files

Janakarajan Natarajan (2):
      crypto: ccp - Fix static checker warning
      crypto: ccp - Allow SEV firmware to be chosen based on Family and Model

Jason A. Donenfeld (1):
      crypto: speck - remove Speck

Kees Cook (30):
      crypto: xcbc - Remove VLA usage
      crypto: cbc - Remove VLA usage
      crypto: hash - Remove VLA usage
      crypto: api - Introduce generic max blocksize and alignmask
      crypto: qat - Remove VLA usage
      crypto: shash - Remove VLA usage in unaligned hashing
      dm: Remove VLA usage from hashes
      crypto: skcipher - Introduce crypto_sync_skcipher
      gss_krb5: Remove VLA usage of skcipher
      lib80211: Remove VLA usage of skcipher
      mac802154: Remove VLA usage of skcipher
      s390/crypto: Remove VLA usage of skcipher
      x86/fpu: Remove VLA usage of skcipher
      block: cryptoloop: Remove VLA usage of skcipher
      libceph: Remove VLA usage of skcipher
      ppp: mppe: Remove VLA usage of skcipher
      rxrpc: Remove VLA usage of skcipher
      wusb: Remove VLA usage of skcipher
      crypto: ccp - Remove VLA usage of skcipher
      crypto: vmx - Remove VLA usage of skcipher
      crypto: null - Remove VLA usage of skcipher
      crypto: cryptd - Remove VLA usage of skcipher
      crypto: sahara - Remove VLA usage of skcipher
      crypto: qce - Remove VLA usage of skcipher
      crypto: artpec6 - Remove VLA usage of skcipher
      crypto: chelsio - Remove VLA usage of skcipher
      crypto: mxs-dcp - Remove VLA usage of skcipher
      crypto: omap-aes - Remove VLA usage of skcipher
      crypto: picoxcell - Remove VLA usage of skcipher
      crypto: skcipher - Remove SKCIPHER_REQUEST_ON_STACK()

Martin K. Petersen (3):
      crypto: api - Introduce notifier for new crypto algorithms
      crc-t10dif: Pick better transform if one becomes available
      crc-t10dif: Allow current transform to be inspected in sysfs

Michael S. Tsirkin (1):
      hwrng: core - document the quality field

Michael Schupikov (1):
      crypto: testmgr - fix sizeof() on COMP_BUF_SIZE

Mikulas Patocka (1):
      crypto: aesni - don't use GFP_ATOMIC allocation if the request doesn't cross a page in gcm

Nathan Chancellor (2):
      crypto: ccp - Remove forward declaration
      crypto: ccree - avoid implicit enum conversion

Ondrej Mosnacek (5):
      crypto: xts - Drop use of auxiliary buffer
      crypto: lrw - Fix out-of bounds access on counter overflow
      crypto: testmgr - Add test for LRW counter wrap-around
      crypto: lrw - Optimize tweak computation
      crypto: lrw - Do not use auxiliary buffer

Radu Solea (2):
      crypto: mxs-dcp - Fix SHA null hashes and output length
      crypto: mxs-dcp - Fix AES issues

Srikanth Jampala (9):
      crypto: cavium/nitrox - Added support for SR-IOV configuration.
      crypto: cavium/nitrox - use dma_pool_zalloc()
      crypto: cavium/nitrox - added support to identify the NITROX device partname.
      crypto: cavium/nitrox - add support for per device request statistics.
      crypto: cavium/nitrox - updated debugfs information.
      crypto: cavium/nitrox - fix warnings while printing atomic64_t types
      crypto: cavium/nitrox - use pcie_flr instead of duplicating it
      crypto: cavium/nitrox - NITROX command queue changes.
      crypto: cavium/nitrox - use pci_alloc_irq_vectors() while enabling MSI-X.

Stefan Agner (2):
      cpufeature: avoid warning when compiling with clang
      crypto: arm/crc32 - avoid warning when compiling with Clang

Tudor Ambarus (1):
      crypto: atmel - switch to SPDX license identifiers

Valdis Kletnieks (1):
      crypto/morus(640,1280) - make crypto_...-algs static

Wei Yongjun (2):
      crypto: ccp - Make function sev_get_firmware() static
      crypto: mxs-dcp - make symbols 'sha1_null_hash' and 'sha256_null_hash' static

YueHaibing (2):
      crypto: axis - fix platform_no_drv_owner.cocci warnings
      crypto: chtls - remove set but not used variable 'csk'

kbuild test robot (1):
      crc-t10dif: crc_t10dif_mutex can be static

zhong jiang (2):
      crypto: chtls - remove redundant null pointer check before kfree_skb
      crypto: cavium - remove redundant null pointer check before kfree

 Documentation/filesystems/fscrypt.rst              |   10 -
 MAINTAINERS                                        |    8 -
 arch/arm/crypto/Kconfig                            |    7 +-
 arch/arm/crypto/Makefile                           |    2 -
 arch/arm/crypto/chacha20-neon-core.S               |  277 +-
 arch/arm/crypto/crc32-ce-glue.c                    |    2 +-
 arch/arm/crypto/ghash-ce-core.S                    |  108 +-
 arch/arm/crypto/ghash-ce-glue.c                    |   38 +-
 arch/arm/crypto/speck-neon-core.S                  |  434 --
 arch/arm/crypto/speck-neon-glue.c                  |  288 --
 arch/arm64/configs/defconfig                       |    2 +-
 arch/arm64/crypto/Kconfig                          |   11 -
 arch/arm64/crypto/Makefile                         |    6 -
 arch/arm64/crypto/aes-ce.S                         |    5 +
 arch/arm64/crypto/aes-glue.c                       |  217 +-
 arch/arm64/crypto/aes-modes.S                      |  416 +-
 arch/arm64/crypto/aes-neon.S                       |    6 +
 arch/arm64/crypto/crc32-ce-core.S                  |  287 --
 arch/arm64/crypto/crc32-ce-glue.c                  |  244 -
 arch/arm64/crypto/crct10dif-ce-core.S              |  314 +-
 arch/arm64/crypto/crct10dif-ce-glue.c              |   14 +-
 arch/arm64/crypto/speck-neon-core.S                |  352 --
 arch/arm64/crypto/speck-neon-glue.c                |  282 --
 arch/m68k/configs/amiga_defconfig                  |    2 -
 arch/m68k/configs/apollo_defconfig                 |    2 -
 arch/m68k/configs/atari_defconfig                  |    2 -
 arch/m68k/configs/bvme6000_defconfig               |    2 -
 arch/m68k/configs/hp300_defconfig                  |    2 -
 arch/m68k/configs/mac_defconfig                    |    2 -
 arch/m68k/configs/multi_defconfig                  |    2 -
 arch/m68k/configs/mvme147_defconfig                |    2 -
 arch/m68k/configs/mvme16x_defconfig                |    2 -
 arch/m68k/configs/q40_defconfig                    |    2 -
 arch/m68k/configs/sun3_defconfig                   |    2 -
 arch/m68k/configs/sun3x_defconfig                  |    2 -
 arch/s390/configs/debug_defconfig                  |    1 -
 arch/s390/configs/performance_defconfig            |    1 -
 arch/s390/crypto/aes_s390.c                        |   48 +-
 arch/s390/defconfig                                |    1 -
 arch/x86/crypto/Makefile                           |    5 +-
 arch/x86/crypto/aesni-intel_glue.c                 |   47 +-
 arch/x86/crypto/fpu.c                              |  207 -
 arch/x86/crypto/sha1-mb/Makefile                   |   14 -
 arch/x86/crypto/sha1-mb/sha1_mb.c                  | 1011 ----
 arch/x86/crypto/sha1-mb/sha1_mb_ctx.h              |  134 -
 arch/x86/crypto/sha1-mb/sha1_mb_mgr.h              |  110 -
 arch/x86/crypto/sha1-mb/sha1_mb_mgr_datastruct.S   |  287 --
 arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S   |  304 --
 arch/x86/crypto/sha1-mb/sha1_mb_mgr_init_avx2.c    |   64 -
 arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S  |  209 -
 arch/x86/crypto/sha1-mb/sha1_x8_avx2.S             |  492 --
 arch/x86/crypto/sha256-mb/Makefile                 |   14 -
 arch/x86/crypto/sha256-mb/sha256_mb.c              | 1013 ----
 arch/x86/crypto/sha256-mb/sha256_mb_ctx.h          |  134 -
 arch/x86/crypto/sha256-mb/sha256_mb_mgr.h          |  108 -
 .../crypto/sha256-mb/sha256_mb_mgr_datastruct.S    |  304 --
 .../crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S    |  307 --
 .../x86/crypto/sha256-mb/sha256_mb_mgr_init_avx2.c |   65 -
 .../crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S   |  214 -
 arch/x86/crypto/sha256-mb/sha256_x8_avx2.S         |  598 ---
 arch/x86/crypto/sha512-mb/Makefile                 |   12 -
 arch/x86/crypto/sha512-mb/sha512_mb.c              | 1047 ----
 arch/x86/crypto/sha512-mb/sha512_mb_ctx.h          |  128 -
 arch/x86/crypto/sha512-mb/sha512_mb_mgr.h          |  104 -
 .../crypto/sha512-mb/sha512_mb_mgr_datastruct.S    |  281 --
 .../crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S    |  297 --
 .../x86/crypto/sha512-mb/sha512_mb_mgr_init_avx2.c |   69 -
 .../crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S   |  224 -
 arch/x86/crypto/sha512-mb/sha512_x4_avx2.S         |  531 --
 crypto/Kconfig                                     |  101 +-
 crypto/Makefile                                    |    4 +-
 crypto/aegis.h                                     |   20 +-
 crypto/ahash.c                                     |   25 +-
 crypto/algapi.c                                    |   17 +-
 crypto/algboss.c                                   |    2 +
 crypto/algif_aead.c                                |   12 +-
 crypto/algif_hash.c                                |    2 +-
 crypto/authenc.c                                   |    8 +-
 crypto/authencesn.c                                |    8 +-
 crypto/ccm.c                                       |    9 +-
 crypto/chacha20_generic.c                          |    7 +-
 crypto/cryptd.c                                    |   32 +-
 crypto/crypto_null.c                               |   11 +-
 crypto/{crypto_user.c => crypto_user_base.c}       |    9 +-
 crypto/crypto_user_stat.c                          |  463 ++
 crypto/echainiv.c                                  |    4 +-
 crypto/gcm.c                                       |    8 +-
 crypto/internal.h                                  |    8 -
 crypto/lrw.c                                       |  339 +-
 crypto/mcryptd.c                                   |  675 ---
 crypto/morus1280.c                                 |    7 +-
 crypto/morus640.c                                  |   16 +-
 crypto/ofb.c                                       |  225 +
 crypto/rng.c                                       |    1 +
 crypto/rsa-pkcs1pad.c                              |    9 -
 crypto/seqiv.c                                     |    4 +-
 crypto/shash.c                                     |   33 +-
 crypto/skcipher.c                                  |   24 +
 crypto/speck.c                                     |  307 --
 crypto/tcrypt.c                                    |   27 +-
 crypto/tcrypt.h                                    |    1 +
 crypto/testmgr.c                                   |   42 +-
 crypto/testmgr.h                                   |  863 +---
 crypto/xcbc.c                                      |    8 +-
 crypto/xts.c                                       |  269 +-
 drivers/block/cryptoloop.c                         |   22 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |    5 +
 drivers/char/hw_random/core.c                      |    4 +-
 drivers/char/random.c                              |   24 +-
 drivers/crypto/Makefile                            |    2 +-
 drivers/crypto/atmel-aes.c                         |    5 +-
 drivers/crypto/atmel-authenc.h                     |   13 +-
 drivers/crypto/atmel-ecc.c                         |   11 +-
 drivers/crypto/atmel-ecc.h                         |   14 +-
 drivers/crypto/atmel-sha.c                         |    5 +-
 drivers/crypto/atmel-tdes.c                        |    5 +-
 drivers/crypto/axis/artpec6_crypto.c               |   20 +-
 drivers/crypto/caam/Kconfig                        |   57 +-
 drivers/crypto/caam/Makefile                       |   10 +-
 drivers/crypto/caam/caamalg.c                      |  728 +--
 drivers/crypto/caam/caamalg_desc.c                 |  143 +-
 drivers/crypto/caam/caamalg_desc.h                 |   28 +-
 drivers/crypto/caam/caamalg_qi.c                   |  627 +--
 drivers/crypto/caam/caamalg_qi2.c                  | 5165 ++++++++++++++++++++
 drivers/crypto/caam/caamalg_qi2.h                  |  223 +
 drivers/crypto/caam/caamhash.c                     |   80 +-
 drivers/crypto/caam/caamhash_desc.c                |   80 +
 drivers/crypto/caam/caamhash_desc.h                |   21 +
 drivers/crypto/caam/caampkc.c                      |    1 +
 drivers/crypto/caam/caamrng.c                      |    1 +
 drivers/crypto/caam/compat.h                       |    2 +
 drivers/crypto/caam/ctrl.c                         |    1 +
 drivers/crypto/caam/dpseci.c                       |  426 ++
 drivers/crypto/caam/dpseci.h                       |  333 ++
 drivers/crypto/caam/dpseci_cmd.h                   |  149 +
 drivers/crypto/caam/error.c                        |   79 +-
 drivers/crypto/caam/error.h                        |    6 +-
 drivers/crypto/caam/jr.c                           |    1 +
 drivers/crypto/caam/qi.c                           |   43 +-
 drivers/crypto/caam/qi.h                           |    3 +-
 drivers/crypto/caam/regs.h                         |   30 +-
 drivers/crypto/caam/sg_sw_qm.h                     |   29 +-
 drivers/crypto/caam/sg_sw_qm2.h                    |   30 +-
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c       |   20 +-
 drivers/crypto/cavium/nitrox/Makefile              |    3 +
 drivers/crypto/cavium/nitrox/nitrox_common.h       |   19 +-
 drivers/crypto/cavium/nitrox/nitrox_csr.h          |  111 +
 drivers/crypto/cavium/nitrox/nitrox_debugfs.c      |  115 +
 drivers/crypto/cavium/nitrox/nitrox_dev.h          |  162 +-
 drivers/crypto/cavium/nitrox/nitrox_hal.c          |   71 +-
 drivers/crypto/cavium/nitrox/nitrox_hal.h          |   23 +
 drivers/crypto/cavium/nitrox/nitrox_isr.c          |  337 +-
 drivers/crypto/cavium/nitrox/nitrox_isr.h          |   10 +
 drivers/crypto/cavium/nitrox/nitrox_lib.c          |   98 +-
 drivers/crypto/cavium/nitrox/nitrox_main.c         |  203 +-
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c       |   49 +-
 drivers/crypto/cavium/nitrox/nitrox_sriov.c        |  151 +
 drivers/crypto/ccp/ccp-crypto-aes-xts.c            |   13 +-
 drivers/crypto/ccp/ccp-crypto.h                    |    2 +-
 drivers/crypto/ccp/psp-dev.c                       |   47 +-
 drivers/crypto/ccp/sp-platform.c                   |   53 +-
 drivers/crypto/ccree/cc_hw_queue_defs.h            |    6 +-
 drivers/crypto/chelsio/chcr_algo.c                 |   30 +-
 drivers/crypto/chelsio/chcr_core.c                 |    2 +-
 drivers/crypto/chelsio/chcr_crypto.h               |    2 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c            |    7 +-
 drivers/crypto/chelsio/chtls/chtls_main.c          |    3 +-
 drivers/crypto/mxs-dcp.c                           |  142 +-
 drivers/crypto/omap-aes.c                          |   17 +-
 drivers/crypto/omap-aes.h                          |    2 +-
 drivers/crypto/picoxcell_crypto.c                  |   21 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |   60 +-
 drivers/crypto/qce/ablkcipher.c                    |   13 +-
 drivers/crypto/qce/cipher.h                        |    2 +-
 drivers/crypto/s5p-sss.c                           |  113 +-
 drivers/crypto/sahara.c                            |   31 +-
 drivers/crypto/vmx/aes_cbc.c                       |   22 +-
 drivers/crypto/vmx/aes_ctr.c                       |   18 +-
 drivers/crypto/vmx/aes_xts.c                       |   18 +-
 drivers/md/dm-integrity.c                          |   23 +-
 drivers/md/dm-verity-fec.c                         |    5 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c     |   20 +-
 drivers/net/ppp/ppp_mppe.c                         |   27 +-
 drivers/soc/fsl/dpio/dpio-service.c                |   58 +
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c       |   34 +-
 drivers/staging/rtl8192e/rtllib_crypt_wep.c        |   28 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      |   34 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c       |   26 +-
 drivers/usb/wusbcore/crypto.c                      |   16 +-
 fs/crypto/fscrypt_private.h                        |    4 -
 fs/crypto/keyinfo.c                                |   10 -
 include/crypto/acompress.h                         |   38 +-
 include/crypto/aead.h                              |   51 +-
 include/crypto/akcipher.h                          |   76 +-
 include/crypto/algapi.h                            |   14 +-
 include/crypto/cbc.h                               |    2 +-
 include/crypto/chacha20.h                          |    3 +-
 include/crypto/hash.h                              |   38 +-
 include/crypto/internal/cryptouser.h               |    8 +
 include/crypto/internal/geniv.h                    |    2 +-
 include/crypto/kpp.h                               |   51 +-
 include/crypto/mcryptd.h                           |  114 -
 include/crypto/morus1280_glue.h                    |    2 +-
 include/crypto/morus640_glue.h                     |    2 +-
 include/crypto/null.h                              |    2 +-
 include/crypto/rng.h                               |   29 +-
 include/crypto/skcipher.h                          |  118 +-
 include/crypto/speck.h                             |   62 -
 include/linux/compiler_types.h                     |    1 -
 include/linux/cpufeature.h                         |    2 +-
 include/linux/crc-t10dif.h                         |    1 +
 include/linux/crypto.h                             |  110 +-
 include/linux/fsl/mc.h                             |    6 +
 include/linux/hw_random.h                          |    3 +-
 include/linux/sunrpc/gss_krb5.h                    |   30 +-
 include/soc/fsl/dpaa2-fd.h                         |  242 +
 include/soc/fsl/dpaa2-global.h                     |   15 +
 include/soc/fsl/dpaa2-io.h                         |    4 +
 include/uapi/linux/cryptouser.h                    |   52 +
 include/uapi/linux/fs.h                            |    4 +-
 lib/chacha20.c                                     |    6 +-
 lib/crc-t10dif.c                                   |   57 +-
 net/ceph/crypto.c                                  |   12 +-
 net/ceph/crypto.h                                  |    2 +-
 net/mac802154/llsec.c                              |   16 +-
 net/mac802154/llsec.h                              |    2 +-
 net/rxrpc/ar-internal.h                            |    2 +-
 net/rxrpc/rxkad.c                                  |   44 +-
 net/sunrpc/auth_gss/gss_krb5_crypto.c              |   87 +-
 net/sunrpc/auth_gss/gss_krb5_keys.c                |    9 +-
 net/sunrpc/auth_gss/gss_krb5_mech.c                |   53 +-
 net/sunrpc/auth_gss/gss_krb5_seqnum.c              |   18 +-
 net/sunrpc/auth_gss/gss_krb5_wrap.c                |   20 +-
 net/wireless/lib80211_crypt_tkip.c                 |   34 +-
 net/wireless/lib80211_crypt_wep.c                  |   28 +-
 tools/crypto/getstat.c                             |  294 ++
 236 files changed, 11951 insertions(+), 15861 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
