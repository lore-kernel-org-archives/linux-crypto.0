From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Update for 2.6.29
Date: Thu, 25 Dec 2008 11:20:20 +1100
Message-ID: <20081225002020.GA2912@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46379 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751462AbYLYAU0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Dec 2008 19:20:26 -0500
Content-Disposition: inline
In-Reply-To: <20081225001724.GA2813@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 2.6.29:

The main change is the introduction of the shash algorithm type.
It's meant to replace the existing hash type as the main interface
for synchronous hash operations.  Its key feature is support for
simultaneous operations on a single tfm where previously multiple
tfm objects had to be allocated.  A large chunk of the changes
here are simply conversions of existing hash algorithms to use
the new interface.  In particular, the crc32c algorithm has been
converted, which means that the libcrc32c interface can now use
the crypto interface, giving it access to Intel's new CRC32C
instruction.

Apart from that there is the usual collection of bug fixes and
updates to algorithms and drivers.

Now with the pull location :)

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Adrian-Ken Rueegsegger (10):
      libcrc32c: Fix "crc32c undefined" compilation error
      crypto: sha1 - Switch to shash
      crypto: md4 - Switch to shash
      crypto: md5 - Switch to shash
      crypto: sha256 - Switch to shash
      crypto: tgr192 - Switch to shash
      crypto: wp512 - Switch to shash
      crypto: michael_mic - Switch to shash
      crypto: sha512 - Move message schedule W[80] to static percpu area
      crypto: sha512 - Switch to shash

Evgeniy Polyakov (3):
      crypto: hifn - Disable driver when physical size exceeds 32 bits
      crypto: hifn_795x - Fix queue management
      crypto: hifn_795x - Use softirq kernel mapping in bh context

Geert Uytterhoeven (2):
      crypto: testmgr - Validate output length in (de)compression tests
      crypto: testmgr - Correct comment about deflate parameters

Harvey Harrison (3):
      crypto: camellia - use kernel-provided bitops, unaligned access
      crypto: remove uses of __constant_{endian} helpers
      crypto: salsa20 - Remove private wrappers around various operations

Herbert Xu (21):
      crypto: padlock - Avoid resetting cword on successive operations
      crypto: api - Move type exit function into crypto_tfm
      crypto: api - Rebirth of crypto_alloc_tfm
      crypto: hash - Add shash interface
      crypto: hash - Export shash through ahash
      crypto: hash - Add import/export interface
      crypto: api - Call type show function before legacy for proc
      crypto: hash - Export shash through hash
      crypto: crc32c - Switch to shash
      crypto: crc32c-intel - Switch to shash
      crypto: crc32c - Test descriptor context format
      libcrc32c: Move implementation to crypto crc32c
      libcrc32c: Add crc32c_le macro
      libcrc32c: Select CRYPTO in Kconfig
      crypto: hash - Make setkey optional
      crypto: null - Switch to shash
      crypto: rmd128 - Switch to shash
      crypto: rmd160 - Switch to shash
      crypto: rmd256 - Switch to shash
      crypto: rmd320 - Switch to shash
      crypto: aes - Precompute tables

Ingo Molnar (1):
      crypto: testmgr - Fix error flow of test_comp

Jarod Wilson (3):
      crypto: ansi_cprng - Avoid incorrect extra call to _get_more_prng_bytes
      crypto: ansi_cprng - fix inverted DT increment routine
      crypto: des3_ede - permit weak keys unless REQ_WEAK_KEY set

Julia Lawall (1):
      crypto: md4 - Use ARRAY_SIZE

Kent Liu (1):
      crypto: crc32c-intel - Update copyright head

Kim Phillips (2):
      crypto: talitos - Pass correct interrupt status to error handler
      crypto: talitos - Perform auth check in h/w if on sec 2.1 and above

Lee Nipper (2):
      crypto: talitos - Implement done interrupt mitigation
      crypto: talitos - Ack done interrupt in isr instead of tasklet

Neil Horman (2):
      crypto: testmgr - Trigger a panic when self test fails in FIPS mode
      crypto: ansi_cprng - Allow resetting of DT value

Patrick McHardy (5):
      crypto: hifn_795x - Fix DMA setup
      crypto: hifn_795x - Don't copy src sg list
      crypto: hifn_795x - Fix request context corruption
      crypto: hifn_795x - Fix queue processing
      crypto: hifn_795x - Remove some unused cruft

Vishnu Suresh (1):
      crypto: talitos - Preempt overflow interrupts off-by-one fix

 arch/x86/crypto/crc32c-intel.c |  121 +++---
 crypto/Kconfig                 |   29 +-
 crypto/Makefile                |    1 +
 crypto/aes_generic.c           | 1145 ++++++++++++++++++++++++++++++++++++----
 crypto/ahash.c                 |   38 ++-
 crypto/ansi_cprng.c            |   35 +-
 crypto/api.c                   |  121 ++++-
 crypto/authenc.c               |    3 +
 crypto/camellia.c              |   84 ++--
 crypto/crc32c.c                |  290 ++++++-----
 crypto/crypto_null.c           |   64 ++-
 crypto/des_generic.c           |    5 +-
 crypto/fcrypt.c                |    8 +-
 crypto/hmac.c                  |   10 +-
 crypto/internal.h              |    2 +
 crypto/md4.c                   |   56 ++-
 crypto/md5.c                   |   50 +-
 crypto/michael_mic.c           |   72 ++--
 crypto/proc.c                  |   20 +-
 crypto/rmd128.c                |   61 ++-
 crypto/rmd160.c                |   61 ++-
 crypto/rmd256.c                |   61 ++-
 crypto/rmd320.c                |   61 ++-
 crypto/salsa20_generic.c       |   75 ++--
 crypto/sha1_generic.c          |   56 ++-
 crypto/sha256_generic.c        |  104 ++--
 crypto/sha512_generic.c        |  127 +++---
 crypto/shash.c                 |  508 ++++++++++++++++++
 crypto/testmgr.c               |   76 +++-
 crypto/testmgr.h               |    2 +-
 crypto/tgr192.c                |  135 +++---
 crypto/wp512.c                 |  121 +++--
 drivers/crypto/hifn_795x.c     |  494 ++++++++---------
 drivers/crypto/padlock-aes.c   |   52 ++-
 drivers/crypto/talitos.c       |  153 ++++--
 drivers/crypto/talitos.h       |   85 ++--
 include/crypto/aes.h           |    8 +-
 include/crypto/algapi.h        |   16 +-
 include/crypto/hash.h          |  125 +++++
 include/crypto/internal/hash.h |   16 +-
 include/linux/crc32c.h         |    6 +-
 include/linux/crypto.h         |   10 +-
 lib/Kconfig                    |    2 +
 lib/libcrc32c.c                |  182 ++------
 44 files changed, 3331 insertions(+), 1420 deletions(-)
 create mode 100644 crypto/shash.c

> Thanks,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
