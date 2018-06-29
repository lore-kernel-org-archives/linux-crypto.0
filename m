From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 0/9] Crypto: Remove VLA usage (part 1)
Date: Thu, 28 Jun 2018 17:28:34 -0700
Message-ID: <20180629002843.31095-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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

This series is intended to land via the crypto tree, though it touches
dm as well, since there are dependent patches (new crypto #defines
being used).

Thanks!

-Kees

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Kees Cook (9):
  crypto: xcbc: Remove VLA usage
  crypto: cbc: Remove VLA usage
  crypto: shash: Remove VLA usage
  dm integrity: Remove VLA usage
  crypto: ahash: Remove VLA usage
  dm verity fec: Remove VLA usage
  crypto alg: Introduce generic max blocksize and alignmask
  crypto: qat: Remove VLA usage
  crypto: shash: Remove VLA usage in unaligned hashing

 crypto/ahash.c                           |  4 ++--
 crypto/algapi.c                          |  7 ++++++-
 crypto/algif_hash.c                      |  2 +-
 crypto/shash.c                           | 25 +++++++++++-------------
 crypto/xcbc.c                            |  9 +++++++--
 drivers/crypto/qat/qat_common/qat_algs.c |  8 ++++++--
 drivers/md/dm-integrity.c                | 23 ++++++++++++++++------
 drivers/md/dm-verity-fec.c               |  5 ++++-
 include/crypto/algapi.h                  |  4 +++-
 include/crypto/cbc.h                     |  4 +++-
 include/crypto/hash.h                    |  9 ++++++++-
 include/linux/compiler-gcc.h             |  1 -
 12 files changed, 68 insertions(+), 33 deletions(-)

-- 
2.17.1
