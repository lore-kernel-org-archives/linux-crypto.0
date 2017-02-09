From: Alden Tondettar <alden.tondettar@gmail.com>
Subject: [PATCH] random: Don't overwrite CRNG state in crng_initialize()
Date: Wed,  8 Feb 2017 20:31:26 -0700
Message-ID: <1486611086-2290-1-git-send-email-alden.tondettar@gmail.com>
Cc: Alden Tondettar <alden.tondettar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The new non-blocking system introduced in commit e192be9d9a30 ("random:
replace non-blocking pool with a Chacha20-based CRNG") can under
some circumstances report itself initialized while it still contains
dangerously little entropy, as follows:

Approximately every 64th call to add_interrupt_randomness(), the "fast"
pool of interrupt-timing-based entropy is fed into one of two places. At
calls numbered <= 256, the fast pool is XORed into the primary CRNG state.
At call 256, the CRNG is deemed initialized, getrandom(2) is unblocked,
and reading from /dev/urandom no longer gives warnings.

At calls > 256, the fast pool is fed into the input pool, leaving the CRNG
untouched.

The problem arises between call number 256 and 320. If crng_initialize()
is called at this time, it will overwrite the _entire_ CRNG state with
48 bytes generated from the input pool. But the add_interrupt_randomness()
entropy was never _in_ the input pool, so instead we destroy all of
add_interrupt_randomness()'s hard work and replace it with the possibly
feeble entropy from a few calls to add_device_randomness(),
init_std_data(), etc.

Nevertheless crng_ready() will happily inform us that getrandom(2) and
/dev/urandom are ready to go. This state of affairs will continue until
the next call to crng_reseed() dumps more entropy into the CRNG and _that_
won't happen until the input pool entropy estimate exceeds 128 bits. On a
system with no rotational drives and little or no user input it could be
a long wait (minutes).

Dumping /var/foo/random-seed into /dev/urandom won't help here because
that only adds entropy to the pool without increasing the estimate.

In short, the situation is:

A) No usable hardware RNG or arch_get_random() (or we don't trust it...)
B) add_interrupt_randomness() called 256-320 times but other
   add_*_randomness() functions aren't adding much entropy.
C) then crng_initialize() is called
D) not enough calls to add_*_randomness() to push the entropy
   estimate over 128 (yet)
E) getrandom(2) or /dev/urandom used for something important

Based on a few experiments with VMs, A) through D) can occur easily in
practice. And with no HDD we have a window of about a minute or two for
E) to happen before add_interrupt_randomness() finally pushes the
estimate over 128 on its own.

The fix is simple enough: XOR the input pool randomness into the CRNG state
instead of overwriting it.

Fixes: e192be9d9a30 ("random: replace non-blocking pool with a Chacha20-based CRNG")
Signed-off-by: Alden Tondettar <alden.tondettar@gmail.com>
---
 drivers/char/random.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1ef2640..bda30df 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -777,20 +777,22 @@ static void crng_initialize(struct crng_state *crng)
 {
 	int		i;
 	unsigned long	rv;
+	__u32 tmp[12];
 
 	memcpy(&crng->state[0], "expand 32-byte k", 16);
 	if (crng == &primary_crng)
-		_extract_entropy(&input_pool, &crng->state[4],
-				 sizeof(__u32) * 12, 0);
+		_extract_entropy(&input_pool, tmp, sizeof(__u32) * 12, 0);
 	else
-		get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
+		get_random_bytes(tmp, sizeof(__u32) * 12);
 	for (i = 4; i < 16; i++) {
 		if (!arch_get_random_seed_long(&rv) &&
 		    !arch_get_random_long(&rv))
 			rv = random_get_entropy();
-		crng->state[i] ^= rv;
+		crng->state[i] ^= tmp[i - 4] ^ rv;
 	}
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
+
+	memzero_explicit(tmp, sizeof(tmp));
 }
 
 static int crng_fast_load(const char *cp, size_t len)
-- 
2.1.4
