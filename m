Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359E5C43463
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F08D220BED
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgIUIBq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:01:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:56892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgIUH7V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4774AB506;
        Mon, 21 Sep 2020 07:59:54 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Roman Drahtmueller <draht@schaltsekun.de>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Petr Tesarik <ptesarik@suse.cz>,
        Nicolai Stange <nstange@suse.de>
Subject: [RFC PATCH 09/41] random: protect ->entropy_count with the pool spinlock
Date:   Mon, 21 Sep 2020 09:58:25 +0200
Message-Id: <20200921075857.4424-10-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, all updates to ->entropy_count are synchronized by means of
cmpxchg-retry loops found in credit_entropy_bits(),
__credit_entropy_bits_fast() and account() respectively.

However, all but one __credit_entropy_bits_fast() call sites grap the pool
->lock already and it would be nice if the potentially costly cmpxchg could
be avoided in these performance critical paths. In addition to that, future
patches will introduce new fields to struct entropy_store which will
required some kinf of synchronization with ->entropy_count updates from
said producer paths as well.

Protect ->entropy_count with the pool ->lock.

- Make callers of __credit_entropy_bits_fast() invoke it with the
  pool ->lock held. Extend existing critical sections where possible.
  Drop the cmpxchg-reply loop in __credit_entropy_bits_fast() in favor of
  a plain assignment.
- Retain the retry loop in credit_entropy_bits(): the potentially
  expensive pool_entropy_delta() should not be called under the lock in
  order to not unnecessarily block contenders. In order to continue to
  synchronize with  __credit_entropy_bits_fast() and account(), the
  cmpxchg gets replaced by a plain comparison + store with the ->lock being
  held.
- Make account() grab the ->lock and drop the cmpxchg-retry loop in favor
  of a plain assignent.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 44 +++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d9e4dd27d45d..9f87332b158f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -718,7 +718,7 @@ static unsigned int pool_entropy_delta(struct entropy_store *r,
  * Credit the entropy store with n bits of entropy.
  * To be used from hot paths when it is either known that nbits is
  * smaller than one half of the pool size or losing anything beyond that
- * doesn't matter.
+ * doesn't matter. Must be called with r->lock being held.
  */
 static bool __credit_entropy_bits_fast(struct entropy_store *r, int nbits)
 {
@@ -727,13 +727,11 @@ static bool __credit_entropy_bits_fast(struct entropy_store *r, int nbits)
 	if (!nbits)
 		return false;
 
-retry:
-	orig = READ_ONCE(r->entropy_count);
+	orig = r->entropy_count;
 	entropy_count = orig + pool_entropy_delta(r, orig,
 						  nbits << ENTROPY_SHIFT,
 						  true);
-	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
-		goto retry;
+	WRITE_ONCE(r->entropy_count, entropy_count);
 
 	trace_credit_entropy_bits(r->name, nbits,
 				  entropy_count >> ENTROPY_SHIFT, _RET_IP_);
@@ -755,17 +753,28 @@ static bool __credit_entropy_bits_fast(struct entropy_store *r, int nbits)
 static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
 	int entropy_count, orig;
+	unsigned long flags;
 
 	if (!nbits)
 		return;
 
 retry:
+	/*
+	 * Don't run the potentially expensive pool_entropy_delta()
+	 * calculations under the spinlock. Instead retry until
+	 * ->entropy_count becomes stable.
+	 */
 	orig = READ_ONCE(r->entropy_count);
 	entropy_count = orig + pool_entropy_delta(r, orig,
 						  nbits << ENTROPY_SHIFT,
 						  false);
-	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+	spin_lock_irqsave(&r->lock, flags);
+	if (r->entropy_count != orig) {
+		spin_unlock_irqrestore(&r->lock, flags);
 		goto retry;
+	}
+	WRITE_ONCE(r->entropy_count, entropy_count);
+	spin_unlock_irqrestore(&r->lock, flags);
 
 	trace_credit_entropy_bits(r->name, nbits,
 				  entropy_count >> ENTROPY_SHIFT, _RET_IP_);
@@ -1203,12 +1212,11 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 	} sample;
 	long delta, delta2, delta3;
 	bool reseed;
+	unsigned long flags;
 
 	sample.jiffies = jiffies;
 	sample.cycles = random_get_entropy();
 	sample.num = num;
-	r = &input_pool;
-	mix_pool_bytes(r, &sample, sizeof(sample));
 
 	/*
 	 * Calculate number of bits of randomness we probably added.
@@ -1235,12 +1243,16 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 	if (delta > delta3)
 		delta = delta3;
 
+	r = &input_pool;
+	spin_lock_irqsave(&r->lock, flags);
+	__mix_pool_bytes(r, &sample, sizeof(sample));
 	/*
 	 * delta is now minimum absolute delta.
 	 * Round down by 1 bit on general principles,
 	 * and limit entropy estimate to 12 bits.
 	 */
 	reseed = __credit_entropy_bits_fast(r, min_t(int, fls(delta>>1), 11));
+	spin_unlock_irqrestore(&r->lock, flags);
 	if (reseed)
 		crng_reseed(&primary_crng, r);
 }
@@ -1358,12 +1370,12 @@ void add_interrupt_randomness(int irq, int irq_flags)
 		__mix_pool_bytes(r, &seed, sizeof(seed));
 		credit = 1;
 	}
-	spin_unlock(&r->lock);
 
 	fast_pool->count = 0;
 
 	/* award one bit for the contents of the fast pool */
 	reseed = __credit_entropy_bits_fast(r, credit + 1);
+	spin_unlock(&r->lock);
 	if (reseed)
 		crng_reseed(&primary_crng, r);
 }
@@ -1393,14 +1405,15 @@ EXPORT_SYMBOL_GPL(add_disk_randomness);
  */
 static size_t account(struct entropy_store *r, size_t nbytes, int min)
 {
-	int entropy_count, orig, have_bytes;
+	int entropy_count, have_bytes;
 	size_t ibytes, nfrac;
+	unsigned long flags;
 
 	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
 
+	spin_lock_irqsave(&r->lock, flags);
 	/* Can we pull enough? */
-retry:
-	entropy_count = orig = READ_ONCE(r->entropy_count);
+	entropy_count = r->entropy_count;
 	ibytes = nbytes;
 	/* never pull more than available */
 	have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
@@ -1420,8 +1433,8 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min)
 	else
 		entropy_count = 0;
 
-	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
-		goto retry;
+	WRITE_ONCE(r->entropy_count, entropy_count);
+	spin_unlock_irqrestore(&r->lock, flags);
 
 	trace_debit_entropy(r->name, 8 * ibytes);
 	if (ibytes && ENTROPY_BITS(r) < random_write_wakeup_bits) {
@@ -1639,8 +1652,11 @@ EXPORT_SYMBOL(get_random_bytes);
 static void entropy_timer(struct timer_list *t)
 {
 	bool reseed;
+	unsigned long flags;
 
+	spin_lock_irqsave(&input_pool.lock, flags);
 	reseed = __credit_entropy_bits_fast(&input_pool, 1);
+	spin_unlock_irqrestore(&input_pool.lock, flags);
 	if (reseed)
 		crng_reseed(&primary_crng, &input_pool);
 }
-- 
2.26.2

