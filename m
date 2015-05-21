From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: random: Wake up all getrandom(2) callers when pool is ready
Date: Thu, 21 May 2015 16:19:54 +0800
Message-ID: <20150521081953.GA22301@gondor.apana.org.au>
References: <3340545.QDDPvU7BuN@tachyon.chronox.de>
 <12904468.qCSNRrkb6t@tachyon.chronox.de>
 <20150520214408.GA17264@gondor.apana.org.au>
 <9182932.rX0DhQWPrJ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9182932.rX0DhQWPrJ@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 21, 2015 at 09:55:17AM +0200, Stephan Mueller wrote:
>
> So, I will create a 2nd wait queue in random.c for uninterruptible waits, 
> change the get_blocking_random_bytes back to void and use wait_event to wait 
> for the initialization.

Hold your horses.  You don't need a second queue, you just need to
change wake_up_interruptible to wake_up.

Hmm, in fact shouldn't this be wake_up_all? Otherwise what are the
other getrandom(2) callers going to do? Ted?

---8<---
If more than one application invokes getrandom(2) before the pool
is ready, then all bar one will be stuck forever because we use
wake_up_interruptible which wakes up a single task.

This patch replaces it with wake_up_all.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9cd6968..8b8c46b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -660,7 +660,7 @@ retry:
 		r->entropy_total = 0;
 		if (r == &nonblocking_pool) {
 			prandom_reseed_late();
-			wake_up_interruptible(&urandom_init_wait);
+			wake_up_all(&urandom_init_wait);
 			pr_notice("random: %s pool is initialized\n", r->name);
 		}
 	}

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
