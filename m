From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 2.6.30
Date: Tue, 24 Mar 2009 12:49:32 +0800
Message-ID: <20090324044932.GA18245__17721.6213931844$1237870321$gmane$org@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33382 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750721AbZCXEto (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Mar 2009 00:49:44 -0400
Content-Disposition: inline
In-Reply-To: <20081225002020.GA2912@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 2.6.30:

* A new compression interface that supports "compress as you go".
 - This includes a patch to move nlattr from net into lib.
* Support for the Intel AES instruction.
* More shash algorithm conversions.
* Multithreaded software crypto through cryptd.
* AMCC crypto driver.
* timeriomem RNG driver.
* Random fixes.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Adrian-Ken Rueegsegger (1):
      crypto: Fix dead links

Alexander Clouter (1):
      hwrng: timeriomem - New driver

Geert Uytterhoeven (5):
      netlink: Move netlink attribute parsing support to lib
      crypto: compress - Add pcomp interface
      crypto: testmgr - Add support for the pcomp interface
      crypto: zlib - New zlib crypto module, using pcomp
      crypto: testmgr - add zlib test

Heiko Carstens (1):
      hwrng: timeriomem - Breaks an allyesconfig build on s390:

Herbert Xu (10):
      crypto: shash - Remove superfluous check in init_tfm
      crypto: shash - Add crypto_shash_blocksize
      crypto: sha-s390 - Switch to shash
      crypto: api - crypto_alg_mod_lookup either tested or untested
      crypto: api - Fix crypto_alloc_tfm/create_create_tfm return convention
      crypto: skcipher - Avoid infinite loop when cipher fails selftest
      crypto: aead - Avoid infinite loop when nivaead fails selftest
      crypto: testmgr - Test skciphers with no IVs
      nlattr: Fix build error with NET off
      crypto: sha512-s390 - Add missing block size

Huang Ying (7):
      crypto: aes - Move key_length in struct crypto_aes_ctx to be the last field
      crypto: aes - Export x86 AES encrypt/decrypt functions
      crypto: cryptd - Add support to access underlying blkcipher
      crypto: aes-ni - Add support to Intel AES-NI instructions for x86_64 platform
      crypto: api - Use dedicated workqueue for crypto subsystem
      crypto: cryptd - Per-CPU thread implementation based on kcrypto_wq
      crypto: chainiv - Use kcrypto_wq instead of keventd_wq

James Hsiao (1):
      crypto: amcc - Add crypt4xx driver

Neil Horman (3):
      crypto: ansi_cprng - Force reset on allocation
      crypto: ansi_cprng - Panic on CPRNG test failure when in FIPS mode
      crypto: ansi_cprng - Add maintainer

 MAINTAINERS                             |    6 +
 arch/powerpc/boot/dts/canyonlands.dts   |    7 +
 arch/powerpc/boot/dts/kilauea.dts       |    7 +
 arch/s390/crypto/sha.h                  |    6 +-
 arch/s390/crypto/sha1_s390.c            |   40 +-
 arch/s390/crypto/sha256_s390.c          |   40 +-
 arch/s390/crypto/sha512_s390.c          |   81 +-
 arch/s390/crypto/sha_common.c           |   20 +-
 arch/x86/crypto/Makefile                |    3 +
 arch/x86/crypto/aes-i586-asm_32.S       |   18 +-
 arch/x86/crypto/aes-x86_64-asm_64.S     |    6 +-
 arch/x86/crypto/aes_glue.c              |   20 +-
 arch/x86/crypto/aesni-intel_asm.S       |  896 +++++++++++++++++++++
 arch/x86/crypto/aesni-intel_glue.c      |  461 +++++++++++
 arch/x86/include/asm/aes.h              |   11 +
 arch/x86/include/asm/cpufeature.h       |    1 +
 crypto/Kconfig                          |   44 +
 crypto/Makefile                         |    5 +
 crypto/ablkcipher.c                     |   19 +
 crypto/aead.c                           |   16 +
 crypto/algboss.c                        |   20 +-
 crypto/ansi_cprng.c                     |   17 +-
 crypto/api.c                            |   17 +-
 crypto/blkcipher.c                      |    2 +-
 crypto/chainiv.c                        |    3 +-
 crypto/cryptd.c                         |  237 +++---
 crypto/crypto_wq.c                      |   38 +
 crypto/gf128mul.c                       |    2 +-
 crypto/internal.h                       |    6 +-
 crypto/pcompress.c                      |   97 +++
 crypto/sha256_generic.c                 |    2 +-
 crypto/shash.c                          |   20 +-
 crypto/tcrypt.c                         |    6 +-
 crypto/testmgr.c                        |  198 +++++
 crypto/testmgr.h                        |  147 ++++
 crypto/zlib.c                           |  378 +++++++++
 drivers/char/hw_random/Kconfig          |   14 +
 drivers/char/hw_random/Makefile         |    1 +
 drivers/char/hw_random/timeriomem-rng.c |  151 ++++
 drivers/crypto/Kconfig                  |   15 +-
 drivers/crypto/Makefile                 |    1 +
 drivers/crypto/amcc/Makefile            |    2 +
 drivers/crypto/amcc/crypto4xx_alg.c     |  293 +++++++
 drivers/crypto/amcc/crypto4xx_core.c    | 1310 +++++++++++++++++++++++++++++++
 drivers/crypto/amcc/crypto4xx_core.h    |  177 +++++
 drivers/crypto/amcc/crypto4xx_reg_def.h |  284 +++++++
 drivers/crypto/amcc/crypto4xx_sa.c      |  108 +++
 drivers/crypto/amcc/crypto4xx_sa.h      |  243 ++++++
 include/crypto/aes.h                    |    6 +-
 include/crypto/compress.h               |  145 ++++
 include/crypto/cryptd.h                 |   27 +
 include/crypto/crypto_wq.h              |    7 +
 include/crypto/hash.h                   |    5 +
 include/crypto/internal/compress.h      |   28 +
 include/linux/crypto.h                  |    4 +-
 include/linux/timeriomem-rng.h          |   21 +
 lib/Kconfig                             |    6 +
 lib/Makefile                            |    2 +
 net/netlink/attr.c => lib/nlattr.c      |   20 +-
 net/Kconfig                             |    1 +
 net/netlink/Makefile                    |    2 +-
 61 files changed, 5506 insertions(+), 264 deletions(-)
 create mode 100644 arch/x86/crypto/aesni-intel_asm.S
 create mode 100644 arch/x86/crypto/aesni-intel_glue.c
 create mode 100644 arch/x86/include/asm/aes.h
 create mode 100644 crypto/crypto_wq.c
 create mode 100644 crypto/pcompress.c
 create mode 100644 crypto/zlib.c
 create mode 100644 drivers/char/hw_random/timeriomem-rng.c
 create mode 100644 drivers/crypto/amcc/Makefile
 create mode 100644 drivers/crypto/amcc/crypto4xx_alg.c
 create mode 100644 drivers/crypto/amcc/crypto4xx_core.c
 create mode 100644 drivers/crypto/amcc/crypto4xx_core.h
 create mode 100644 drivers/crypto/amcc/crypto4xx_reg_def.h
 create mode 100644 drivers/crypto/amcc/crypto4xx_sa.c
 create mode 100644 drivers/crypto/amcc/crypto4xx_sa.h
 create mode 100644 include/crypto/compress.h
 create mode 100644 include/crypto/cryptd.h
 create mode 100644 include/crypto/crypto_wq.h
 create mode 100644 include/crypto/internal/compress.h
 create mode 100644 include/linux/timeriomem-rng.h
 rename net/netlink/attr.c => lib/nlattr.c (99%)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
