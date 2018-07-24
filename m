From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 00/18] crypto: Remove VLA usage
Date: Tue, 24 Jul 2018 09:49:18 -0700
Message-ID: <20180724164936.37477-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	linux-wireless@vger.kernel.org,
	Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>, dm-devel@redhat.com,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-afs@lists.infradead.org,
	Alasdair Kergon <agk@redhat.com>,
	Kees Cook <keescook@chromium.org>, devel@driverdev.osuosl.org,
	x86@kernel.org, qat-linux@intel.com, Ingo Molnar <mingo@redhat.com>,
	Eric Biggers <ebiggers@google.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	drbd-dev@lists.linbit.com, Rabin Vincent <rabinv@axis.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
	linux-block@vger.kernel.org, Josh Poimboeuf
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

For newly added CCs on this series: your Ack/Review would be very
welcome! Especially for the ahash-to-shash conversion patches.

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

Ard Biesheuvel (1):
  crypto: ccm: Remove VLA usage

Kees Cook (17):
  crypto: xcbc: Remove VLA usage
  crypto: cbc: Remove VLA usage
  crypto: hash: Remove VLA usage
  dm: Remove VLA usage from hashes
  crypto alg: Introduce generic max blocksize and alignmask
  crypto: qat: Remove VLA usage
  crypto: shash: Remove VLA usage in unaligned hashing
  crypto: skcipher: Remove VLA usage for SKCIPHER_REQUEST_ON_STACK
  ppp: mppe: Remove VLA usage
  x86/power/64: Remove VLA usage
  dm crypt: Convert essiv from ahash to shash
  drbd: Convert from ahash to shash
  wireless/lib80211: Convert from ahash to shash
  staging: rtl8192u: ieee80211: Convert from ahash to shash
  staging: rtl8192e: ieee80211: Convert from ahash to shash
  rxrpc: Reuse SKCIPHER_REQUEST_ON_STACK buffer
  crypto: Remove AHASH_REQUEST_ON_STACK

 arch/x86/power/hibernate_64.c                 | 36 +++++++-----
 crypto/ahash.c                                |  4 +-
 crypto/algapi.c                               |  7 ++-
 crypto/algif_hash.c                           |  2 +-
 crypto/ccm.c                                  |  9 ++-
 crypto/shash.c                                | 33 ++++++-----
 crypto/xcbc.c                                 |  8 ++-
 drivers/block/drbd/drbd_int.h                 | 13 +++--
 drivers/block/drbd/drbd_main.c                | 14 ++---
 drivers/block/drbd/drbd_nl.c                  | 39 ++++---------
 drivers/block/drbd/drbd_receiver.c            | 35 +++++------
 drivers/block/drbd/drbd_worker.c              | 56 ++++++++----------
 drivers/crypto/qat/qat_common/qat_algs.c      |  8 ++-
 drivers/md/dm-crypt.c                         | 31 +++++-----
 drivers/md/dm-integrity.c                     | 23 ++++++--
 drivers/md/dm-verity-fec.c                    |  5 +-
 drivers/net/ppp/ppp_mppe.c                    | 56 +++++++++---------
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c  | 56 +++++++++---------
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c | 57 +++++++++---------
 include/crypto/algapi.h                       |  4 +-
 include/crypto/cbc.h                          |  4 +-
 include/crypto/hash.h                         | 11 ++--
 include/crypto/internal/skcipher.h            |  1 +
 include/crypto/skcipher.h                     |  4 +-
 include/linux/compiler-gcc.h                  |  1 -
 net/rxrpc/rxkad.c                             | 25 ++++----
 net/wireless/lib80211_crypt_tkip.c            | 58 +++++++++----------
 27 files changed, 313 insertions(+), 287 deletions(-)

-- 
2.17.1
