From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/7] random: initialize the non-blocking pool via add_hwgenerator_randomness()
Date: Mon, 13 Jun 2016 11:48:33 -0400
Message-ID: <1465832919-11316-2-git-send-email-tytso@mit.edu>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de,
	herbert@gondor.apana.org.au, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com,
	Theodore Ts'o <tytso@mit.edu>, stable@kernel.org
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

If we have a hardware RNG and are using the in-kernel rngd, we should
use this to initialize the non-blocking pool so that getrandom(2)
doesn't block unnecessarily.

Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0158d3b..4e2627a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1849,12 +1849,18 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 {
 	struct entropy_store *poolp = &input_pool;
 
-	/* Suspend writing if we're above the trickle threshold.
-	 * We'll be woken up again once below random_write_wakeup_thresh,
-	 * or when the calling thread is about to terminate.
-	 */
-	wait_event_interruptible(random_write_wait, kthread_should_stop() ||
+	if (unlikely(nonblocking_pool.initialized == 0))
+		poolp = &nonblocking_pool;
+	else {
+		/* Suspend writing if we're above the trickle
+		 * threshold.  We'll be woken up again once below
+		 * random_write_wakeup_thresh, or when the calling
+		 * thread is about to terminate.
+		 */
+		wait_event_interruptible(random_write_wait,
+					 kthread_should_stop() ||
 			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
+	}
 	mix_pool_bytes(poolp, buffer, count);
 	credit_entropy_bits(poolp, entropy);
 }
-- 
2.5.0
