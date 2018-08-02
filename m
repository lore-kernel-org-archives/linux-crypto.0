From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v7 0/9] crypto: Remove VLA usage
Date: Thu,  2 Aug 2018 15:51:43 -0700
Message-ID: <20180802225152.19194-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>, linux-kernel@vger.kernel.org,
	Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
	Will Deacon <will.deacon@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"David S. Miller" <davem@davemloft.net>, dm-devel@redhat.com,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	David Woodhouse <dwmw@amazon.co.uk>, qat-linux@intel.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alasdair Kergon <agk@redhat.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

v7 cover letter:

Since the ahash->shash conversions are going via separate trees, I've
removed those patches from this series. In the meantime, this contains
all the remaining patches for getting rid of almost all VLAs in crypto.
I'd _really_ like to get this landed for v4.19. Any chance of that
happening?

Series cover letter:

This is nearly the last of the VLA removals[1], but it's one of the
largest because crypto gets used in lots of places. After looking
through code, usage, reading the threads Gustavo started, and comparing
the use-cases to the other VLA removals that have landed in the kernel,
I think this series is likely the best way forward to shut the door on
VLAs forever.

For background, the crypto stack usage is for callers to do an immediate
bit of work that doesn't allocate new memory. This means that other VLA
removal techniques (like just using kmalloc) aren't workable, and the
next common technique is needed: examination of maximum stack usage and
the addition of sanity checks. This series does that, and in several
cases, these maximums were already implicit in the code.

This series is intended to land via the crypto tree for 4.19, though it
touches dm, networking, and a few other things as well, since there are
dependent patches (new crypto #defines being used, etc).

Thanks!

-Kees

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Changelog:

v7:
- refresh and reorganization without ahash->shash conversions

v6:
- make xcbc blocksize unconditional
- add ahash-to-shash conversion patch series to entirely remove
  AHASH_REQUEST_ON_STACK from the kernel

v5:
- limit AHASH_REQUEST_ON_STACK size only to non-async hash wrapping.
- sanity-check ahash reqsize only when doing shash wrapping.
- remove frame_warn changes in favor of shash conversions and other fixes.
- send ahash to shash conversion patches and other fixes separately.

v4:
- add back *_REQUEST_ON_STACK patches.
- programmatically find stack sizes for *_REQUEST_ON_STACK patches.
- whitelist some code that trips FRAME_WARN on 32-bit builds.
- fix alignment patches.

v3:
- drop *_REQUEST_ON_STACK patches. The rest of this series is pretty
  straight-forward, and I'd like to get them tested in -next while
  we continue to chip away at the *_REQUEST_ON_STACK VLA removal patches
  separately. "Part 2" will continue with those.

v2:
- use 512 instead of PAGE_SIZE / 8 to avoid bloat on large-page archs.
- swtich xcbc to "16" max universally.
- fix typo in bounds check for dm buffer size.
- examine actual reqsizes for skcipher and ahash instead of guessing.
- improve names and comments for alg maxes


Ard Biesheuvel (1):
  crypto: ccm: Remove VLA usage

Kees Cook (8):
  crypto: xcbc: Remove VLA usage
  crypto: cbc: Remove VLA usage
  crypto: hash: Remove VLA usage
  dm: Remove VLA usage from hashes
  crypto alg: Introduce generic max blocksize and alignmask
  crypto: qat: Remove VLA usage
  crypto: shash: Remove VLA usage in unaligned hashing
  crypto: skcipher: Remove VLA usage for SKCIPHER_REQUEST_ON_STACK

 crypto/ahash.c                           |  4 +--
 crypto/algapi.c                          |  7 ++++-
 crypto/algif_hash.c                      |  2 +-
 crypto/ccm.c                             |  9 ++++---
 crypto/shash.c                           | 33 ++++++++++++++----------
 crypto/xcbc.c                            |  8 +++---
 drivers/crypto/qat/qat_common/qat_algs.c |  8 ++++--
 drivers/md/dm-integrity.c                | 23 ++++++++++++-----
 drivers/md/dm-verity-fec.c               |  5 +++-
 include/crypto/algapi.h                  |  4 ++-
 include/crypto/cbc.h                     |  4 ++-
 include/crypto/hash.h                    |  6 ++++-
 include/crypto/internal/skcipher.h       |  1 +
 include/crypto/skcipher.h                |  4 ++-
 include/linux/compiler-gcc.h             |  1 -
 15 files changed, 81 insertions(+), 38 deletions(-)

-- 
2.17.1
