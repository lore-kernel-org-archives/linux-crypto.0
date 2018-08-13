From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] random updates for 4.19
Date: Mon, 13 Aug 2018 19:11:14 -0400
Message-ID: <20180813231114.GA19929@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The following changes since commit 81e69df38e2911b642ec121dec319fad2a4782f3:

  random: mix rdrand with entropy sent in from userspace (2018-07-17 21:32:36 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus

for you to fetch changes up to 9a47249d444d344051c7c0e909fad0e88515a5c2:

  random: Make crng state queryable (2018-08-02 17:33:06 -0400)

----------------------------------------------------------------
Some changes to trust cpu-based hwrng (such as RDRAND) for
initializing hashed pointers and (optionally, controlled by a config
option) to initialize the CRNG to avoid boot hangs.

----------------------------------------------------------------
Ingo Molnar (1):
      random: remove preempt disabled region

Jason A. Donenfeld (1):
      random: Make crng state queryable

Theodore Ts'o (1):
      random: add a config option to trust the CPU's hwrng

Tobin C. Harding (4):
      random: Fix whitespace pre random-bytes work
      random: Return nbytes filled from hw RNG
      vsprintf: Use hw RNG for ptr_key
      vsprintf: Add command line option debug_boot_weak_hash

 Documentation/admin-guide/kernel-parameters.txt |  8 ++++++++
 drivers/char/Kconfig                            | 14 ++++++++++++++
 drivers/char/random.c                           | 49 +++++++++++++++++++++++++++++++++++--------------
 include/linux/random.h                          |  3 ++-
 lib/vsprintf.c                                  | 27 ++++++++++++++++++++++++++-
 5 files changed, 85 insertions(+), 16 deletions(-)
