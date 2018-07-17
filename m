From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v5 00/11] crypto: Remove VLA usage
Date: Mon, 16 Jul 2018 21:21:39 -0700
Message-ID: <20180717042150.37761-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Eric Biggers <ebiggers@google.com>, qat-linux@intel.com,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	linux-crypto@vger.kernel.org, Lars Persson <larper@axis.com>,
	Tim Chen <tim.c.chen@linux.intel.com>, Alasdair Kergon <agk@redhat.com>,
	Rabin Vincent <rabinv@axis.com>
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


This is nearly the last of the VLA removals[1], but it's one of the
largest because crypto gets used in lots of places. After looking
through code, usage, reading the threads Gustavo started, and comparing
the use-cases to the other VLA removals that have landed in the kernel,
I think this series is likely the best way forward to shut the door on
VLAs forever.

As background, the crypto stack usage is for callers to do an immediate
bit of work that doesn't allocate new memory. This means that other VLA
removal techniques (like just using kmalloc) aren't workable, and the
next common technique is needed: examination of maximum stack usage and
the addition of sanity checks. This series does that, and in several
cases, these maximums were already implicit in the code.

This series is intended to land via the crypto tree for 4.19, though
it touches dm and a few other things as well, since there are dependent
patches (new crypto #defines being used, kbuild, etc).

Thanks!

-Kees

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Kees Cook (11):
  crypto: xcbc: Remove VLA usage
  crypto: cbc: Remove VLA usage
  crypto: shash: Remove VLA usage
  dm integrity: Remove VLA usage
  crypto: ahash: Remove VLA usage
  dm verity fec: Remove VLA usage
  crypto alg: Introduce generic max blocksize and alignmask
  crypto: qat: Remove VLA usage
  crypto: shash: Remove VLA usage in unaligned hashing
  crypto: ahash: Remove VLA usage for AHASH_REQUEST_ON_STACK
  crypto: skcipher: Remove VLA usage for SKCIPHER_REQUEST_ON_STACK

 crypto/ahash.c                           |  4 +--
 crypto/algapi.c                          |  7 +++-
 crypto/algif_hash.c                      |  2 +-
 crypto/shash.c                           | 42 +++++++++++++++---------
 crypto/xcbc.c                            |  9 +++--
 drivers/crypto/qat/qat_common/qat_algs.c |  8 +++--
 drivers/md/dm-integrity.c                | 23 +++++++++----
 drivers/md/dm-verity-fec.c               |  5 ++-
 include/crypto/algapi.h                  |  4 ++-
 include/crypto/cbc.h                     |  4 ++-
 include/crypto/hash.h                    | 19 +++++++++--
 include/crypto/internal/skcipher.h       |  1 +
 include/crypto/skcipher.h                |  4 ++-
 include/linux/compiler-gcc.h             |  1 -
 14 files changed, 97 insertions(+), 36 deletions(-)

-- 
2.17.1
