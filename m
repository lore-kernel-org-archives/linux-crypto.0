From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 2.6.32
Date: Fri, 11 Sep 2009 00:19:05 +1000
Message-ID: <20090910141905.GA17948__2618.46173457361$1252592449$gmane$org@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20090613020512.GA21024@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40440 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755735AbZIJOTK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Sep 2009 10:19:10 -0400
Content-Disposition: inline
In-Reply-To: <20090613020512.GA21024@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 2.6.32:

* Completed hash algorithm transition to shash.
* Convert IPsec over to lockless ahash interface.
* Split GHASH from GCM.
* Orion5X crypto engine support.
* Minor fixes/updates.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Christian Kujau (1):
      crypto: rng - Fix typo

Herbert Xu (75):
      crypto: ansi_cprng - Do not select FIPS
      crypto: tcrypt - Fix module return code when testing by name
      crypto: testmgr - Remove hash size check
      crypto: skcipher - Fix request for sync algorithms
      crypto: skcipher - Change default sync geniv on SMP to eseqiv
      crypto: testmgr - Allow implementation-specific tests
      crypto: api - Add new template create function
      crypto: api - Add crypto_alloc_instance2
      crypto: shash - Add shash_instance
      crypto: api - Add new style spawn support
      crypto: shash - Add spawn support
      crypto: api - Add crypto_attr_alg2 helper
      crypto: shash - Add shash_attr_alg2 helper
      crypto: shash - Add shash_register_instance
      crypto: shash - Add crypto_shash_ctx_aligned
      crypto: shash - Add __crypto_shash_cast
      crypto: shash - Use finup in default digest
      crypto: shash - Propagate reinit return value
      crypto: shash - Add shash_instance_ctx
      crypto: api - Fix crypto_drop_spawn crash on blank spawns
      crypto: shash - Export/import hash state only
      crypto: shash - Move finup/digest null checks to registration time
      crypto: sha1_generic - Add export/import support
      crypto: sha256_generic - Use 64-bit counter like sha1
      crypto: sha256_generic - Add export/import support
      crypto: sha1-s390 - Add export/import support
      crypto: sha256-s390 - Add export/import support
      crypto: padlock - Use shash fallback for sha
      crypto: shash - Move null setkey check to registration time
      crypto: async - Use kzfree for requests
      crypto: shash - Make descsize a run-time attribute
      crypto: padlock - Switch sha to shash
      crypto: hmac - Switch to shash
      crypto: xcbc - Switch to shash
      crypto: authenc - Remove reference to crypto_hash
      crypto: hash - Remove legacy hash/digest implementaion
      crypto: shash - Export async functions
      crypto: cryptd - Use shash algorithms
      crypto: ahash - Add crypto_ahash_set_reqsize
      crypto: cryptd - Use crypto_ahash_set_reqsize
      crypto: crypto4xx - Use crypto_ahash_set_reqsize
      crypto: api - Remove frontend argument from extsize/init_tfm
      crypto: ahash - Convert to new style algorithms
      crypto: ahash - Add instance/spawn support
      crypto: tcrypt - Add mask parameter
      crypto: hash - Add helpers to free spawns
      crypto: cryptd - Switch to template create API
      crypto: cryptd - Switch to new style ahash
      crypto: crypto4xx - Switch to new style ahash
      crypto: ahash - Remove old_ahash_alg
      crypto: hash - Zap unaligned buffers
      crypto: shash - Fix alignment in unaligned operations
      crypto: ahash - Use GFP_KERNEL in unaligned setkey
      crypto: ahash - Add unaligned handling and default operations
      crypto: crypto4xx - Disable SHA implementation
      crypto: hmac - Fix incorrect error value when creating instance
      crypto: xcbc - Fix incorrect error value when creating instance
      crypto: padlock - Fix compile error on i386
      crypto: ahash - Fix setkey crash
      crypto: shash - Fix digest size offset
      crypto: shash - Fix async finup handling of null digest
      crypto: padlock - Fix hashing of partial blocks
      crypto: cryptd - Add finup/export/import for hash
      crypto: xcbc - Use crypto_xor
      crypto: xcbc - Fix shash conversion
      crypto: sha512 - Export struct sha512_state
      crypto: sha512_generic - Use 64-bit counters
      crypto: sha512-s390 - Add export/import support
      crypto: shash - Require all algorithms to support export/import
      crypto: hmac - Prehash ipad/opad
      crypto: api - Fix aligned ctx helper
      Revert crypto: fips - Select CPRNG
      crypto: ctr - Use chainiv on raw counter mode
      crypto: blkcipher - Do not use eseqiv on stream ciphers
      crypto: api - Do not displace newly registered algorithms

Huang Ying (3):
      crypto: ghash - Add GHASH digest algorithm for GCM
      crypto: gcm - Use GHASH digest algorithm
      crypto: cryptd - Add support to access underlaying shash

Jan Glauber (1):
      crypto: sha-s390 - Fix warnings in import function

Jarod Wilson (1):
      crypto: des_s390 - Permit weak keys unless REQ_WEAK_KEY set

Joe Perches (1):
      hwrng: Use PCI_VDEVICE

Kim Phillips (3):
      crypto: talitos - simplify hmac data size calculation
      crypto: talitos - align locks on cache lines
      crypto: talitos - add support for 36 bit addressing

Neil Horman (3):
      random: Add optional continuous repetition test to entropy store based rngs
      crypto: fips - Select CPRNG
      crypto: fips - Depend on ansi_cprng

Phil Carmody (1):
      crypto: aes - Undefined behaviour in crypto_aes_expand_key

Roland Dreier (1):
      crypto: aes-ni - Don't print message with KERN_ERR on old system

Sachin Sant (1):
      crypto: s390 - Fix sha build failure

Sebastian Andrzej Siewior (3):
      crypto: ansi_prng - Use just a BH lock
      crypto: ansi_prng - alloc cipher just in init
      crypto: mv_cesa - Add support for Orion5X crypto engine

Shane Wang (1):
      crypto: vmac - New hash algorithm for intel_txt support

Steffen Klassert (7):
      crypto: tcrypt - Test algorithms by name
      crypto: cryptd - Fix uninitialized return value
      crypto: ahash - Use GFP_KERNEL on allocation if the request can sleep
      crypto: shash - Test for the algorithms import function before exporting it
      crypto: authenc - Convert to ahash
      crypto: xcbc - Fix alignment calculation of xcbc_tfm_ctx
      crypto: ansi_cprng - Fix module initialization

 arch/s390/crypto/des_s390.c          |   11 +-
 arch/s390/crypto/sha1_s390.c         |   26 ++
 arch/s390/crypto/sha256_s390.c       |   26 ++
 arch/s390/crypto/sha512_s390.c       |   36 ++
 arch/x86/crypto/aesni-intel_glue.c   |    2 +-
 crypto/Kconfig                       |   30 ++-
 crypto/Makefile                      |    5 +-
 crypto/ablkcipher.c                  |   29 ++-
 crypto/aes_generic.c                 |    9 +-
 crypto/ahash.c                       |  336 +++++++++++++++--
 crypto/algapi.c                      |  180 ++++++++--
 crypto/algboss.c                     |    5 +
 crypto/ansi_cprng.c                  |   43 +--
 crypto/api.c                         |   54 ++--
 crypto/authenc.c                     |  358 ++++++++++++++----
 crypto/cryptd.c                      |  321 +++++++++++------
 crypto/ctr.c                         |    2 +
 crypto/gcm.c                         |  580 ++++++++++++++++++++---------
 crypto/ghash-generic.c               |  170 +++++++++
 crypto/hmac.c                        |  302 +++++++--------
 crypto/internal.h                    |   28 +--
 crypto/pcompress.c                   |    6 +-
 crypto/rng.c                         |    2 +-
 crypto/sha1_generic.c                |   41 ++-
 crypto/sha256_generic.c              |  100 +++---
 crypto/sha512_generic.c              |   48 +--
 crypto/shash.c                       |  270 ++++++++++----
 crypto/tcrypt.c                      |   22 +-
 crypto/testmgr.c                     |   30 ++-
 crypto/testmgr.h                     |   16 +
 crypto/vmac.c                        |  678 ++++++++++++++++++++++++++++++++++
 crypto/xcbc.c                        |  370 +++++++------------
 drivers/char/hw_random/amd-rng.c     |    4 +-
 drivers/char/hw_random/geode-rng.c   |    3 +-
 drivers/char/random.c                |   14 +
 drivers/crypto/Kconfig               |   15 +-
 drivers/crypto/Makefile              |    1 +
 drivers/crypto/amcc/crypto4xx_alg.c  |    3 +-
 drivers/crypto/amcc/crypto4xx_core.c |   73 ++--
 drivers/crypto/amcc/crypto4xx_core.h |   25 ++-
 drivers/crypto/mv_cesa.c             |  606 ++++++++++++++++++++++++++++++
 drivers/crypto/mv_cesa.h             |  119 ++++++
 drivers/crypto/padlock-sha.c         |  329 +++++++++--------
 drivers/crypto/talitos.c             |  216 +++++------
 drivers/crypto/talitos.h             |    1 +
 include/crypto/algapi.h              |   37 ++-
 include/crypto/cryptd.h              |   17 +
 include/crypto/hash.h                |  147 +++++---
 include/crypto/internal/hash.h       |  147 +++++++-
 include/crypto/sha.h                 |   20 +
 include/crypto/vmac.h                |   61 +++
 include/linux/crypto.h               |   43 +--
 include/linux/fips.h                 |   10 +
 53 files changed, 4515 insertions(+), 1512 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
