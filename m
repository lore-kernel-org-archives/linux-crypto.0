From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/5] random: crng_reseed() should lock the crng instance that it is modifying
Date: Thu, 12 Apr 2018 21:30:45 -0400
Message-ID: <20180413013046.404-4-tytso@mit.edu>
References: <20180413013046.404-1-tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, stable@kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180413013046.404-1-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Reported-by: Jann Horn <jannh@google.com>
Fixes: 1e7f583af67b ("random: make /dev/urandom scalable for silly...")
Cc: stable@kernel.org # 4.8+
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jann Horn <jannh@google.com>
---
 drivers/char/random.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 681ee0c0de24..6e7fa13b1a89 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -906,7 +906,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 		_crng_backtrack_protect(&primary_crng, buf.block,
 					CHACHA20_KEY_SIZE);
 	}
-	spin_lock_irqsave(&primary_crng.lock, flags);
+	spin_lock_irqsave(&crng->lock, flags);
 	for (i = 0; i < 8; i++) {
 		unsigned long	rv;
 		if (!arch_get_random_seed_long(&rv) &&
@@ -916,7 +916,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 	}
 	memzero_explicit(&buf, sizeof(buf));
 	crng->init_time = jiffies;
-	spin_unlock_irqrestore(&primary_crng.lock, flags);
+	spin_unlock_irqrestore(&crng->lock, flags);
 	if (crng == &primary_crng && crng_init < 2) {
 		invalidate_batched_entropy();
 		numa_crng_init();
-- 
2.16.1.72.g5be1f00a9a
