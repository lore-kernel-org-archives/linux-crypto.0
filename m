From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 3.20
Date: Sat, 14 Feb 2015 22:43:29 +1300
Message-ID: <20150214094328.GA7457@gondor.apana.org.au>
References: <20121214103156.GA5840@gondor.apana.org.au>
 <20130223023331.GA11002@gondor.apana.org.au>
 <20130907035544.GA22658@gondor.apana.org.au>
 <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:55512 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbbBNJno (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Feb 2015 04:43:44 -0500
Content-Disposition: inline
In-Reply-To: <20141211125119.GA12380@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 3.20:

* Added 192/256-bit key support to aesni GCM.
* Added MIPS OCTEON MD5 support.
* Fixed hwrng starvation and race conditions.
* Added note that memzero_explicit is not a subsitute for memset.
* Added user-space interface for crypto_rng.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Aaro Koskinen (5):
      MIPS: OCTEON: add crypto helper functions
      crypto: octeon - add instruction definitions for MD5
      MIPS: OCTEON: reintroduce crypto features check
      crypto: octeon - add MD5 module
      crypto: octeon - enable OCTEON MD5 module selection

Allan, Bruce W (5):
      crypto: qat - fix device reset flow
      crypto: qat - correctly type a boolean
      crypto: qat - adf_ae_stop() is never called
      crypto: qat - use pci_wait_for_pending_transaction()
      crypto: qat - remove unnecessary include of atomic.h header file

Amos Kong (1):
      hwrng: move some code out mutex_lock for avoiding underlying dead=
lock

Andrey Ryabinin (1):
      crypto: ccp - terminate ccp_support array with empty element

Asaf Vertz (2):
      crypto: ux500 - fix checkpatch errors
      crypto: omap-des - fix BUG_ON condition

Christophe Jaillet (1):
      crypto: atmel - Free memory in error path

Cristian Stoica (8):
      crypto: replace scatterwalk_sg_next with sg_next
      crypto: caam - remove dead code
      crypto: caam - remove unused local variable
      crypto: caam - pair irq map and dispose in the same function
      crypto: caam - fix resource clean-up on error path for caam_jr_in=
it
      crypto: tcrypt - fix buflen reminder calculation
      crypto: testmgr - limit IV copy length in aead tests
      crypto: tcrypt - do not allocate iv on stack for aead speed tests

Daniel Borkmann (1):
      lib: memzero_explicit: add comment for its usage

Herbert Xu (11):
      hwrng: core - Use struct completion for cleanup_done
      hwrng: core - Fix current_rng init/cleanup race yet again
      hwrng: core - Do not register device opportunistically
      hwrng: core - Drop current rng in set_current_rng
      hwrng: core - Move hwrng_init call into set_current_rng
      Revert "crypto: drbg - use memzero_explicit() for clearing sensit=
ive data"
      crypto: qat - Fix incorrect uses of memzero_explicit
      crypto: qat - Ensure ipad and opad are zeroed
      crypto: cts - Remove bogus use of seqiv
      crypto: cts - Weed out non-CBC algorithms
      crypto: seqiv - Ensure that IV size is at least 8 bytes

Jarod Wilson (1):
      crypto: testmgr - mark rfc4106(gcm(aes)) as fips_allowed

Joshua I. James (5):
      crypto: ablkcipher - fixed style errors in ablkcipher.c
      crypto: aead - fixed style error in aead.c
      crypto: af_alg - fixed style error in af_alg.c
      crypto: ahash - fixed style error in ahash.c
      crypto: api - fixed style erro in algapi.c

Kim Phillips (1):
      crypto: caam - don't emit ICV check failures to dmesg

Masanari Iida (1):
      crypto: bfin_crc - Remove unnecessary KERN_ERR in bfin_crc.c

Mathias Krause (5):
      crypto: sparc64/aes - fix module description
      crypto: sparc64/camellia - fix module alias
      crypto: sparc64/des - add "des3_ede" module alias
      crypto: sparc64/md5 - fix module description
      crypto: x86/des3_ede - drop bogus module aliases

Michael S. Tsirkin (2):
      MAINTAINERS: add linux-crypto to hw random
      hwrng: virtio - drop extra empty line

Rabin Vincent (1):
      crypto: testmgr - don't use interruptible wait in tests

Rickard Strandqvist (1):
      crypto: amcc - Remove unused function

Rusty Russell (5):
      hwrng: place mutex around read functions and buffers.
      hwrng: use reference counts on each struct hwrng.
      hwrng: fix unregister race.
      hwrng: don't double-check old_rng.
      hwrng: don't init list element we're about to add to list.

Stephan Mueller (7):
      crypto: drbg - panic on continuous self test error
      crypto: af_alg - add setsockopt for auth tag size
      crypto: af_alg - zeroize key data
      crypto: algif_rng - add random number generator support
      crypto: algif_rng - enable RNG interface compilation
      crypto: aead - add check for presence of auth tag
      crypto: doc - remove colons in comments

Svenning S=F8rensen (1):
      crypto: atmel_sha - remove unused shash fallback instance.

Tadeusz Struk (4):
      crypto: algif - Mark sgl end at the end of data
      crypto: qat - Fix assumption that sg in and out will have the sam=
e nents
      crypto: qat - add support for cbc(aes) ablkcipher
      crypto: qat - don't need qat_auth_state struct

Timothy McCaffrey (1):
      crypto: aesni - Add support for 192 & 256 bit keys to AESNI RFC41=
06

Wei Yongjun (1):
      crypto: algif_rng - fix sparse non static symbol warning

 MAINTAINERS                                        |    1 +
 arch/mips/cavium-octeon/Makefile                   |    1 +
 arch/mips/cavium-octeon/crypto/Makefile            |    7 +
 arch/mips/cavium-octeon/crypto/octeon-crypto.c     |   66 ++
 arch/mips/cavium-octeon/crypto/octeon-crypto.h     |   75 +++
 arch/mips/cavium-octeon/crypto/octeon-md5.c        |  216 +++++++
 arch/mips/cavium-octeon/executive/octeon-model.c   |    6 +
 arch/mips/include/asm/octeon/octeon-feature.h      |   17 +-
 arch/mips/include/asm/octeon/octeon.h              |    5 -
 arch/sparc/crypto/aes_glue.c                       |    2 +-
 arch/sparc/crypto/camellia_glue.c                  |    2 +-
 arch/sparc/crypto/des_glue.c                       |    1 +
 arch/sparc/crypto/md5_glue.c                       |    2 +-
 arch/x86/crypto/aesni-intel_asm.S                  |  343 ++++++-----
 arch/x86/crypto/aesni-intel_glue.c                 |   34 +-
 arch/x86/crypto/des3_ede_glue.c                    |    2 -
 crypto/Kconfig                                     |   18 +
 crypto/Makefile                                    |    1 +
 crypto/ablkcipher.c                                |    7 +-
 crypto/aead.c                                      |    3 +-
 crypto/af_alg.c                                    |   11 +-
 crypto/ahash.c                                     |    3 +-
 crypto/algapi.c                                    |    1 +
 crypto/algif_rng.c                                 |  192 ++++++
 crypto/algif_skcipher.c                            |    8 +
 crypto/cts.c                                       |    5 +-
 crypto/drbg.c                                      |   34 +-
 crypto/scatterwalk.c                               |    6 +-
 crypto/seqiv.c                                     |   12 +
 crypto/tcrypt.c                                    |   37 +-
 crypto/testmgr.c                                   |   58 +-
 drivers/char/hw_random/core.c                      |  215 ++++---
 drivers/char/hw_random/virtio-rng.c                |    1 -
 drivers/crypto/amcc/crypto4xx_sa.c                 |   23 -
 drivers/crypto/atmel-aes.c                         |    2 +-
 drivers/crypto/atmel-sha.c                         |   50 +-
 drivers/crypto/atmel-tdes.c                        |    2 +-
 drivers/crypto/bfin_crc.c                          |    4 +-
 drivers/crypto/caam/caamalg.c                      |   14 +-
 drivers/crypto/caam/ctrl.c                         |    6 +-
 drivers/crypto/caam/error.c                        |   13 +-
 drivers/crypto/caam/jr.c                           |   37 +-
 drivers/crypto/caam/sg_sw_sec4.h                   |    8 +-
 drivers/crypto/ccp/ccp-dev.c                       |    1 +
 drivers/crypto/ixp4xx_crypto.c                     |    4 +-
 drivers/crypto/nx/nx.c                             |    6 +-
 drivers/crypto/omap-aes.c                          |    4 +-
 drivers/crypto/omap-des.c                          |    8 +-
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    6 +-
 drivers/crypto/qat/qat_common/adf_aer.c            |   24 +-
 drivers/crypto/qat/qat_common/adf_cfg.c            |    2 +
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    2 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |    7 +-
 drivers/crypto/qat/qat_common/adf_init.c           |   98 ++-
 .../crypto/qat/qat_common/adf_transport_internal.h |    1 -
 drivers/crypto/qat/qat_common/icp_qat_hw.h         |    2 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |  642 ++++++++++++=
+++-----
 drivers/crypto/qat/qat_common/qat_crypto.h         |   16 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |   19 +
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |   42 +-
 drivers/crypto/qce/dma.c                           |    6 +-
 drivers/crypto/qce/sha.c                           |    2 +-
 drivers/crypto/sahara.c                            |    2 +-
 drivers/crypto/talitos.c                           |    8 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |   10 +-
 include/crypto/if_alg.h                            |    1 +
 include/crypto/scatterwalk.h                       |   10 +-
 include/linux/crypto.h                             |   11 +-
 include/linux/hw_random.h                          |    4 +
 lib/string.c                                       |    5 +
 70 files changed, 1785 insertions(+), 709 deletions(-)

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
