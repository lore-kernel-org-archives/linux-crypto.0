From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 1/8] random: remove stale maybe_reseed_primary_crng
Date: Tue, 27 Dec 2016 23:39:04 +0100
Message-ID: <3312945.6Q4mfWFxoU@positron.chronox.de>
References: <3254875.f5A5oHPdxF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3254875.f5A5oHPdxF@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>From 5e84a71d4c4b3c7f015878c0907102634603d270 Mon Sep 17 00:00:00 2001
From: Stephan Mueller <stephan.mueller@atsec.com>
Date: Thu, 15 Dec 2016 12:42:33 +0100
Subject: 

The function maybe_reseed_primary_crng is not used anywhere and thus can
be removed. Besides, it contains the check crng_init > 2 which will
never become true and thus would never trigger a reseed of the ChaCha20
primary DRNG.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1ef2640..8e5ab20 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -855,13 +855,6 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 	spin_unlock_irqrestore(&primary_crng.lock, flags);
 }
 
-static inline void maybe_reseed_primary_crng(void)
-{
-	if (crng_init > 2 &&
-	    time_after(jiffies, primary_crng.init_time + CRNG_RESEED_INTERVAL))
-		crng_reseed(&primary_crng, &input_pool);
-}
-
 static inline void crng_wait_ready(void)
 {
 	wait_event_interruptible(crng_init_wait, crng_ready());
-- 
2.9.3
