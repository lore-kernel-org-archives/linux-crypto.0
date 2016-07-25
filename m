From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] /dev/random driver changes for 4.8
Date: Mon, 25 Jul 2016 02:44:24 -0400
Message-ID: <20160725064424.GA29098@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32874 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbcGYGo2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jul 2016 02:44:28 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following changes since commit 1a695a905c18548062509178b98bc91e67510864:

  Linux 4.7-rc1 (2016-05-29 09:29:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus

for you to fetch changes up to 86a574de4590ffe6fd3f3ca34cdcf655a78e36ec:

  random: strengthen input validation for RNDADDTOENTCNT (2016-07-03 17:09:33 -0400)

----------------------------------------------------------------
A number of improvements for the /dev/random driver; the most
important is the use of a ChaCha20-based CRNG for /dev/urandom, which
is faster, more efficient, and easier to make scalable for
silly/abusive userspace programs that want to read from /dev/urandom
in a tight loop on NUMA systems.

This set of patches also improves entropy gathering on VM's running on
Microsoft Azure, and will take advantage of a hw random number
generator (if present) to initialize the /dev/urandom pool.

----------------------------------------------------------------
Eric Biggers (1):
      random: properly align get_random_int_hash

Stephan Mueller (1):
      random: add interrupt callback to VMBus IRQ handler

Theodore Ts'o (6):
      random: initialize the non-blocking pool via add_hwgenerator_randomness()
      random: print a warning for the first ten uninitialized random users
      random: replace non-blocking pool with a Chacha20-based CRNG
      random: make /dev/urandom scalable for silly userspace programs
      random: add backtracking protection to the CRNG
      random: strengthen input validation for RNDADDTOENTCNT

 crypto/chacha20_generic.c |  61 ----------
 drivers/char/random.c     | 482 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 drivers/hv/vmbus_drv.c    |   3 +
 include/crypto/chacha20.h |   1 +
 lib/Makefile              |   2 +-
 lib/chacha20.c            |  79 ++++++++++++
 6 files changed, 468 insertions(+), 160 deletions(-)
 create mode 100644 lib/chacha20.c
