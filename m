From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 4.15
Date: Mon, 13 Nov 2017 18:43:46 +1100
Message-ID: <20171113074346.GA20245@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170904101225.GA12613@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:36974 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751547AbdKMHoC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Nov 2017 02:44:02 -0500
Content-Disposition: inline
In-Reply-To: <20170904101225.GA12613@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

Here is the crypto update for 4.15:

API:

- Disambiguate EBUSY when queueing crypto request by adding ENOSPC.
  This change touches code outside the crypto API.
- Reset settings when empty string is written to rng_current.

Algorithms:

- Add OSCCA SM3 secure hash.

Drivers:

- Remove old mv_cesa driver (replaced by marvell/cesa).
- Enable rfc3686/ecb/cfb/ofb AES in crypto4xx.
- Add ccm/gcm AES in crypto4xx.
- Add support for BCM7278 in iproc-rng200.
- Add hash support on Exynos in s5p-sss.
- Fix fallback-induced error in vmx.
- Fix output IV in atmel-aes.
- Fix empty GCM hash in mediatek.

Others:

- Fix DoS potential in lib/mpi.
- Fix potential out-of-order issues with padata.

Please note that there may be a conflict with the tips tree due
to the timer_setup patch being applied in both cryptodev and
the tips tree.  The version in the tips tree also touchs the
mv_cesa driver which just happens to have been removed in this
cycle in cryptodev.  Any changes to mv_cesa may be safely discarded.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Allen (1):
      crypto: omap - return -ENOMEM on allocation failure.

Arnd Bergmann (1):
      crypto: axis - hide an unused variable

Arvind Yadav (11):
      crypto: nx - constify vio_device_id
      crypto: nx-842 - constify vio_device_id
      hwrng: pseries - constify vio_device_id
      crypto: padlock-aes - constify x86_cpu_id
      crypto: padlock-sha - constify x86_cpu_id
      hwrng: core - pr_err() strings should end with newlines
      crypto: omap-aes - pr_err() strings should end with newlines
      crypto: virtio - pr_err() strings should end with newlines
      crypto: chelsio - pr_err() strings should end with newlines
      crypto: qat - pr_err() strings should end with newlines
      crypto: bcm - pr_err() strings should end with newlines

Boris BREZILLON (5):
      crypto: marvell - Add a platform_device_id table
      ARM: configs: Stop selecting the old CESA driver
      crypto: marvell - Remove the old mv_cesa driver
      crypto: marvell - Switch cipher algs to the skcipher interface
      crypto: marvell - Add a NULL entry at the end of mv_cesa_plat_id_table[]

Christian Lamparter (25):
      crypto: crypto4xx - remove bad list_del
      crypto: crypto4xx - remove unused definitions and write-only variables
      crypto: crypto4xx - set CRYPTO_ALG_KERN_DRIVER_ONLY flag
      crypto: crypto4xx - remove extern statement before function declaration
      crypto: crypto4xx - remove double assignment of pd_uinfo->state
      crypto: crypto4xx - fix dynamic_sa_ctl's sa_contents declaration
      crypto: crypto4xx - move and refactor dynamic_contents helpers
      crypto: crypto4xx - enable AES RFC3686, ECB, CFB and OFB offloads
      crypto: crypto4xx - refactor crypto4xx_copy_pkt_to_dst()
      crypto: crypto4xx - replace crypto4xx_dev's scatter_buffer_size with constant
      crypto: crypto4xx - fix crypto4xx_build_pdr, crypto4xx_build_sdr leak
      crypto: crypto4xx - pointer arithmetic overhaul
      crypto: crypto4xx - wire up hmac_mc to hmac_muting
      crypto: crypto4xx - fix off-by-one AES-OFB
      crypto: crypto4xx - fix type mismatch compiler error
      crypto: crypto4xx - increase context and scatter ring buffer elements
      crypto: crypto4xx - add backlog queue support
      crypto: crypto4xx - use the correct LE32 format for IV and key defs
      crypto: crypto4xx - overhaul crypto4xx_build_pd()
      crypto: crypto4xx - fix various warnings
      crypto: crypto4xx - fix stalls under heavy load
      crypto: crypto4xx - simplify sa and state context acquisition
      crypto: crypto4xx - prepare for AEAD support
      crypto: crypto4xx - add aes-ccm support
      crypto: crypto4xx - add aes-gcm support

Christophe Jaillet (2):
      crypto: lrw - Fix an error handling path in 'create()'
      crypto: lrw - Check for incorrect cipher name

Colin Ian King (5):
      crypto: aesni - make arrays aesni_simd_skciphers and aesni_simd_skciphers2 static
      crypto: algboss - remove redundant setting of len to zero
      crypto: cavium - clean up clang warning on unread variable offset
      crypto: ccp - remove unused variable qim
      crypto: qat - remove unused and redundant pointer vf_info

Corentin LABBE (14):
      crypto: gcm - add GCM IV size constant
      crypto: caam - Use GCM IV size constant
      crypto: ccp - Use GCM IV size constant
      crypto: nx - Use GCM IV size constant
      crypto: atmel - Use GCM IV size constant
      crypto: bcm - Use GCM IV size constant
      crypto: mediatek - Use GCM IV size constant
      crypto: chelsio - Use GCM IV size constant
      crypto: omap - Use GCM IV size constant
      crypto: gcm - Use GCM IV size constant
      crypto: aesni - Use GCM IV size constant
      crypto: stm32 - use of_device_get_match_data
      crypto: omap - use of_device_get_match_data
      crypto: bcm - use of_device_get_match_data

Eric Biggers (6):
      crypto: dh - Fix double free of ctx->p
      crypto: dh - Don't permit 'p' to be 0
      crypto: dh - Don't permit 'key' or 'g' size longer than 'p'
      crypto: qat - Clean up error handling in qat_dh_set_secret()
      crypto: dh - Remove pointless checks for NULL 'p' and 'g'
      lib/mpi: call cond_resched() from mpi_powm() loop

Florian Fainelli (2):
      dt-bindings: rng: Document BCM7278 RNG200 compatible
      hwrng: iproc-rng200 - Add support for BCM7278

Geliang Tang (1):
      crypto: drop unnecessary return statements

Gilad Ben-Yossef (22):
      crypto: sm3 - add OSCCA SM3 secure hash
      crypto: sm3 - add SM3 test vectors
      crypto: change transient busy return code to -ENOSPC
      crypto: ccp - use -ENOSPC for transient busy indication
      net: use -ENOSPC for transient busy indication
      crypto: remove redundant backlog checks on EBUSY
      crypto: marvell/cesa - remove redundant backlog checks on EBUSY
      crypto: introduce crypto wait for async op
      crypto: algif - move to generic async completion
      crypto: move pub key to generic async completion
      crypto: drbg - move to generic async completion
      crypto: gcm - move to generic async completion
      crypto: testmgr - move to generic async completion
      fscrypt: move to generic async completion
      dm: move dm-verity to generic async completion
      cifs: move to generic async completion
      ima: move to generic async completion
      crypto: tcrypt - move to generic async completion
      crypto: talitos - move to generic async completion
      crypto: qce - move to generic async completion
      crypto: mediatek - move to generic async completion
      crypto: doc - adapt api sample to use async. op wait

Gustavo A. R. Silva (3):
      crypto: tcrypt - mark expected switch fall-throughs in do_test()
      crypto: qat - mark expected switch fall-throughs in qat_uclo
      crypto: chcr - Replace _manual_ swap with swap macro

Harsh Jain (5):
      crypto: gf128mul - The x8_ble multiplication functions
      crypto: chelsio - Use x8_ble gf multiplication to calculate IV.
      crypto: chelsio - Remove allocation of sg list to implement 2K limit of dsgl header
      crypto: chelsio - Move DMA un/mapping to chcr from lld cxgb4 driver
      crypto: chelsio - Fix memory leak

Herbert Xu (1):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux

Himanshu Jha (3):
      crypto: n2 - remove null check before kfree
      crypto: inside-secure - remove null check before kfree
      crypto: Use PTR_ERR_ZERO

Horia Geantă (4):
      MAINTAINERS: update caam crypto driver maintainers list
      crypto: caam/qi - abort algorithm setup on DPAA2 parts
      crypto: caam - remove unneeded edesc zeroization
      crypto: caam - remove unused param of ctx_map_to_sec4_sg()

Jim Quigley (1):
      hwrng: virtio - Virtio RNG devices need to be re-registered after suspend/resume

Kamil Konieczny (3):
      crypto: doc - clarify return values for async hash methods
      crypto: s5p-sss - Change spaces to tabs
      crypto: s5p-sss - Add HASH support for Exynos

Kees Cook (2):
      hwrng: xgene - Convert timers to use timer_setup()
      crypto: drivers - Convert timers to use timer_setup()

LEROY Christophe (18):
      crypto: talitos - fix AEAD test failures
      crypto: talitos - fix memory corruption on SEC2
      crypto: talitos - fix setkey to check key weakness
      crypto: talitos - fix AEAD for sha224 on non sha224 capable chips
      crypto: talitos - fix use of sg_link_tbl_len
      crypto: talitos - fix ctr-aes-talitos
      crypto: talitos - zeroize the descriptor with memset()
      crypto: talitos - declare local functions static
      crypto: talitos - use devm_kmalloc()
      crypto: talitos - use of_property_read_u32()
      crypto: talitos - use devm_ioremap()
      crypto: talitos - don't check the number of channels at each interrupt
      crypto: talitos - remove to_talitos_ptr_len()
      crypto: talitos - simplify tests in ipsec_esp()
      crypto: talitos - DMA map key in setkey()
      crypto: talitos - do hw_context DMA mapping outside the requests
      crypto: talitos - chain in buffered data for ahash on SEC1
      crypto: talitos - avoid useless copy

Lionel Debieve (1):
      crypto: stm32/hash - Fix return issue on update

Mathias Krause (3):
      padata: set cpu_index of unused CPUs to -1
      padata: ensure the reorder timer callback runs on the correct CPU
      padata: ensure padata_do_serial() runs on the correct CPU

Mikulas Patocka (1):
      crypto: crc32-pclmul - remove useless relative addressing

Paulo Flabiano Smorigo (1):
      crypto: vmx - Use skcipher for ctr fallback

PrasannaKumar Muralidharan (3):
      hwrng: timeriomem - Remove 'max < 4' condition check
      dt/bindings: exynos-rng: Move dt binding documentation to bindings/crypto
      hwrng: core - Reset user selected rng by writing "" to rng_current

Radu Alexe (1):
      crypto: caam - fix incorrect define

Robert Baronescu (1):
      crypto: tcrypt - fix buffer lengths in test_aead_speed()

Romain Izard (2):
      crypto: atmel-aes - properly set IV after {en,de}crypt
      crypto: atmel-aes - Reset the controller before each use

Ryder Lee (1):
      crypto: mediatek - Add empty messages check in GCM mode

Salvatore Benedetto (1):
      MAINTAINERS: update maintainer for qat

Stephan Mueller (1):
      crypto: keywrap - simplify code

Tudor-Dan Ambarus (7):
      crypto: ecdh - return unsigned value for crypto_ecdh_key_len()
      crypto: dh - return unsigned int for dh_data_size()
      crypto: dh - return unsigned value for crypto_dh_key_len()
      crypto: atmel - return appropriate error code
      crypto: atmel - remove useless irq init
      crypto: ecdh - remove empty exit()
      crypto: atmel - remove empty functions

Yeshaswi M R Gowda (2):
      crypto: chelsio - Remove unused parameter
      crypto: chelsio - Check error code with IS_ERR macro

amd (2):
      crypto: ccp - unmap pages and remove unmap objects in callback
      crypto:ccp - invoke the DMA callback in a standard way

lionel.debieve@st.com (1):
      crypto: stm32/hash - Remove uninitialized symbol

raveendra padasalagi (1):
      crypto: brcm - Explicity ACK mailbox message

 Documentation/crypto/api-samples.rst               |   52 +-
 .../{rng => crypto}/samsung,exynos-rng4.txt        |    0
 .../devicetree/bindings/rng/brcm,iproc-rng200.txt  |    4 +-
 MAINTAINERS                                        |    5 +-
 arch/arm/configs/dove_defconfig                    |    2 +-
 arch/arm/configs/multi_v5_defconfig                |    2 +-
 arch/arm/configs/orion5x_defconfig                 |    2 +-
 arch/x86/crypto/aesni-intel_glue.c                 |   10 +-
 arch/x86/crypto/crc32-pclmul_asm.S                 |   17 +-
 crypto/Kconfig                                     |   11 +
 crypto/Makefile                                    |    1 +
 crypto/af_alg.c                                    |   27 -
 crypto/ahash.c                                     |   12 +-
 crypto/algapi.c                                    |    6 +-
 crypto/algboss.c                                   |    1 -
 crypto/algif_aead.c                                |    8 +-
 crypto/algif_hash.c                                |   30 +-
 crypto/algif_skcipher.c                            |    9 +-
 crypto/api.c                                       |   13 +
 crypto/asymmetric_keys/public_key.c                |   28 +-
 crypto/cryptd.c                                    |    4 +-
 crypto/cts.c                                       |    6 +-
 crypto/dh.c                                        |   36 +-
 crypto/dh_helper.c                                 |   20 +-
 crypto/drbg.c                                      |   36 +-
 crypto/ecdh.c                                      |    6 -
 crypto/ecdh_helper.c                               |    2 +-
 crypto/gcm.c                                       |   55 +-
 crypto/gf128mul.c                                  |   13 +
 crypto/keywrap.c                                   |   84 +-
 crypto/lrw.c                                       |   17 +-
 crypto/rmd128.c                                    |    2 -
 crypto/rmd160.c                                    |    2 -
 crypto/rmd256.c                                    |    2 -
 crypto/rmd320.c                                    |    2 -
 crypto/rsa-pkcs1pad.c                              |   16 +-
 crypto/sm3_generic.c                               |  210 +++
 crypto/tcrypt.c                                    |  209 +--
 crypto/testmgr.c                                   |  210 +--
 crypto/testmgr.h                                   |   67 +
 crypto/xts.c                                       |    8 +-
 drivers/char/hw_random/Kconfig                     |    6 +-
 drivers/char/hw_random/core.c                      |   53 +-
 drivers/char/hw_random/iproc-rng200.c              |    1 +
 drivers/char/hw_random/pseries-rng.c               |    2 +-
 drivers/char/hw_random/timeriomem-rng.c            |    7 -
 drivers/char/hw_random/virtio-rng.c                |   21 +-
 drivers/char/hw_random/xgene-rng.c                 |    8 +-
 drivers/crypto/Kconfig                             |   40 +-
 drivers/crypto/Makefile                            |    1 -
 drivers/crypto/amcc/Makefile                       |    2 +-
 drivers/crypto/amcc/crypto4xx_alg.c                |  512 +++++-
 drivers/crypto/amcc/crypto4xx_core.c               |  831 +++++----
 drivers/crypto/amcc/crypto4xx_core.h               |  199 ++-
 drivers/crypto/amcc/crypto4xx_reg_def.h            |    3 +
 drivers/crypto/amcc/crypto4xx_sa.c                 |   85 -
 drivers/crypto/amcc/crypto4xx_sa.h                 |   99 +-
 drivers/crypto/atmel-aes.c                         |   80 +-
 drivers/crypto/atmel-sha.c                         |    5 +-
 drivers/crypto/atmel-tdes.c                        |   23 +-
 drivers/crypto/axis/artpec6_crypto.c               |   10 +-
 drivers/crypto/bcm/cipher.c                        |  116 +-
 drivers/crypto/bcm/cipher.h                        |    3 +-
 drivers/crypto/bcm/util.c                          |   14 +-
 drivers/crypto/caam/caamalg.c                      |   10 +-
 drivers/crypto/caam/caamalg_qi.c                   |    7 +-
 drivers/crypto/caam/caamhash.c                     |   12 +-
 drivers/crypto/caam/compat.h                       |    1 +
 drivers/crypto/caam/desc.h                         |    2 +-
 drivers/crypto/cavium/nitrox/nitrox_hal.c          |    2 +-
 drivers/crypto/ccp/ccp-crypto-aes-galois.c         |    9 +-
 drivers/crypto/ccp/ccp-crypto-main.c               |    8 +-
 drivers/crypto/ccp/ccp-dev-v5.c                    |    3 +-
 drivers/crypto/ccp/ccp-dev.c                       |    7 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |    5 +-
 drivers/crypto/chelsio/chcr_algo.c                 | 1798 ++++++++++++--------
 drivers/crypto/chelsio/chcr_algo.h                 |   57 +-
 drivers/crypto/chelsio/chcr_core.c                 |   10 +-
 drivers/crypto/chelsio/chcr_core.h                 |    2 +-
 drivers/crypto/chelsio/chcr_crypto.h               |  121 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |    6 +-
 drivers/crypto/ixp4xx_crypto.c                     |    1 -
 drivers/crypto/marvell/cesa.c                      |   29 +-
 drivers/crypto/marvell/cesa.h                      |   27 +-
 drivers/crypto/marvell/cipher.c                    |  476 +++---
 drivers/crypto/marvell/tdma.c                      |    5 +-
 drivers/crypto/mediatek/mtk-aes.c                  |   39 +-
 drivers/crypto/mv_cesa.c                           | 1216 -------------
 drivers/crypto/mv_cesa.h                           |  150 --
 drivers/crypto/n2_core.c                           |   12 +-
 drivers/crypto/nx/nx-842-pseries.c                 |    2 +-
 drivers/crypto/nx/nx-aes-gcm.c                     |    9 +-
 drivers/crypto/nx/nx.c                             |    2 +-
 drivers/crypto/omap-aes-gcm.c                      |   11 +-
 drivers/crypto/omap-aes.c                          |   12 +-
 drivers/crypto/omap-des.c                          |    7 +-
 drivers/crypto/omap-sham.c                         |    7 +-
 drivers/crypto/padlock-aes.c                       |    2 +-
 drivers/crypto/padlock-sha.c                       |    2 +-
 drivers/crypto/picoxcell_crypto.c                  |    7 +-
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |    3 -
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |   18 +-
 drivers/crypto/qat/qat_common/qat_uclo.c           |   15 +-
 drivers/crypto/qce/ablkcipher.c                    |    5 +-
 drivers/crypto/qce/sha.c                           |   30 +-
 drivers/crypto/s5p-sss.c                           | 1596 +++++++++++++++--
 drivers/crypto/stm32/stm32-hash.c                  |   20 +-
 drivers/crypto/talitos.c                           |  582 ++++---
 drivers/crypto/talitos.h                           |    7 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |    1 -
 drivers/crypto/virtio/virtio_crypto_algs.c         |    2 +-
 drivers/crypto/vmx/aes_ctr.c                       |   33 +-
 drivers/md/dm-verity-target.c                      |   81 +-
 drivers/md/dm-verity.h                             |    5 -
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |    8 +-
 fs/cifs/smb2ops.c                                  |   30 +-
 fs/crypto/crypto.c                                 |   28 +-
 fs/crypto/fname.c                                  |   36 +-
 fs/crypto/fscrypt_private.h                        |   10 -
 fs/crypto/keyinfo.c                                |   21 +-
 include/crypto/dh.h                                |    2 +-
 include/crypto/drbg.h                              |    3 +-
 include/crypto/ecdh.h                              |    2 +-
 include/crypto/gcm.h                               |    8 +
 include/crypto/gf128mul.h                          |    2 +-
 include/crypto/hash.h                              |   28 +-
 include/crypto/if_alg.h                            |   15 +-
 include/crypto/sm3.h                               |   40 +
 include/crypto/sm3_base.h                          |  117 ++
 include/linux/crypto.h                             |   40 +
 include/linux/padata.h                             |    4 +
 kernel/padata.c                                    |   71 +-
 lib/mpi/mpi-pow.c                                  |    2 +
 net/ipv4/ah4.c                                     |    2 +-
 net/ipv4/esp4.c                                    |    2 +-
 net/ipv6/ah6.c                                     |    2 +-
 net/ipv6/esp6.c                                    |    2 +-
 security/integrity/ima/ima_crypto.c                |   56 +-
 138 files changed, 5712 insertions(+), 4661 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
