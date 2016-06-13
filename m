From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v4 0/7] random: replace urandom pool with a CRNG
Date: Mon, 13 Jun 2016 11:48:32 -0400
Message-ID: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de,
	herbert@gondor.apana.org.au, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com,
	Theodore Ts'o <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I plan to push this set of changes in the next merge window.  Last
call for comments....

By using a CRNG to replace the urandom pool, we can more quickly
initialized the random number generator used for getrandom(2) and
/dev/urandom.  On bare metal hardware this tends to get initialized
before the devices are finished being probed.  We use a more
aggressive accounting for entropy accounting initially, and then fall
back to the original slower/more conservative entropy accounting
scheme.

We will also use a hardware rng (such as virtio-rng), if available to
initialize the getrandom(2) / /dev/urandom entropy pool.

In addition, on NUMA systems we make the CRNG state per-NUMA socket, to
address the NUMA locking contention problem which Andi Kleen has been
complaining about.  I'm not entirely sure this will work well on the
crazy big SGI systems, but they are rare.  Whether they are rarer than
abusive userspace programs that are continuously pounding /dev/urandom
is unclear.  If necessary we can make a config option to turn off the
per-NUMA socket hack if it proves to be problematic.

Eric Biggers (1):
  random: properly align get_random_int_hash

Stephan Mueller (1):
  random: add interrupt callback to VMBus IRQ handler

Theodore Ts'o (5):
  random: initialize the non-blocking pool via
    add_hwgenerator_randomness()
  random: print a warning for the first ten uninitialized random users
  random: replace non-blocking pool with a Chacha20-based CRNG
  random: make /dev/urandom scalable for silly userspace programs
  random: add backtracking protection to the CRNG

Changes since -v3:
 * Use a hardware rng (e.g., virtio-rng) if possible to initialize the
   getrandom/urandom pool if available
 * Print up to 10 warnings for uninitialized /dev/urandom reads, not just one
 * Back out experiment to block /dev/urandom reads, since this will
   break too many distributions or other user space setups (including
   Python 3.5.2 and Debian Stretch's systemd-crontab-generator)
 * Mark bug fixes for stable kernel backports

Changes since -v2:
  * Rebased to v4.7-rc1
  * Improved/reworked CRNG reseeding and backtracking protection
  * Preseed the CRNG state from system data
  * Added fix to properly align the get_random_int_hash[] array

 crypto/chacha20_generic.c |  61 ------
 drivers/char/random.c     | 465 +++++++++++++++++++++++++++++++++++++---------
 drivers/hv/vmbus_drv.c    |   3 +
 include/crypto/chacha20.h |   1 +
 lib/Makefile              |   2 +-
 lib/chacha20.c            |  79 ++++++++
 6 files changed, 457 insertions(+), 154 deletions(-)
 create mode 100644 lib/chacha20.c

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git  1d6e2eda6f60

-- 
2.5.0
