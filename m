Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040D4C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B68652085B
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgIUIA1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:00:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:56980 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbgIUH7W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DFDBDB507;
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
Subject: [RFC PATCH 10/41] random: implement support for delayed entropy dispatching
Date:   Mon, 21 Sep 2020 09:58:26 +0200
Message-Id: <20200921075857.4424-11-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Consider the following scenario:

  Producer                                        Consumer
  --------                                        --------
  mix_pool_bytes()
                                                  account()
                                                    ->entropy_count -= n
                                                  extract_buf()
  credit_entropy_bits()
    ->entropy_count += pool_entropy_delta()

The amount of entropy to credit as calculated by pool_entropy_delta()
depends on the current pool fill level: the higher the current
->entropy_count, the less the amount of new entropy credited. In the
situation above, a too small value of ->entropy_count would have been
observed and thus, too much entropy attributed to the new batch.

I do recognize the fact that this is currently more of a theoretical
concern. However, future patches will implement some statistical "health
tests" to be run on raw samples like e.g. cycle counts obtained and mixed
into the fast_pools in add_interrupt_randomness(). These tests must have
processed more events than can fit into the fast_pools (~64) before the
outcome is known. Thus, add_interrupt_randomness() will have to dump its
fast_pool into the global input_pool a couple of times before the tests
have completed and hence before the (accumulated) entropy credit may be
released to input_pool's ->entropy_count. It follows that the final entropy
credit attribution can be delayed for arbitrarily long to after the
corresponding mix_pool_bytes() operation.

The simplest solution would be to maintain a sequence counter which gets
incremented from account(). The producer side would take a snapshot before
mix_pool_bytes() and only eventually credit any entropy if it hasn't
changed in the meanwhile. However, that would mean that a lot of precious
entropy would be discarded, especially at boot time: as soon as the first
CPU seeds the primary_crng(), a large part of the entropy accumulated
through add_interrupt_randomness() on all other CPUs would be lost.

So follow a watermark based approach instead. That is, provide the producer
side with an ->entropy_count watermark which is guaranteed to not be less
than the value of ->entropy_count at any point in time from before to after
the mix_pool_bytes() operation(s). Note that the order in which concurrent
producers credit entropy doesn't matter, because
  e1 = e0 + pool_entropy_delta(e0, n1)
  e2 = e1 + pool_entropy_delta(e1, n2)
is equivalent (modulo approximation artifacts) to
  e2 = e0 + pool_entropy_delta(e0, n1 + n2).
Thus, taking the larger of said watermark and the latest ->entropy_count
value for the pool fill level when calculating pool_entropy_delta() will
guarantee that the result won't exceed the true value.

Introduce the new __queue_entropy() and __dequeue_entropy() functions
intended to be used for delimiting one or more successive mix_pool_bytes()
invocations for which the pool watermark tracking is needed. Both take a
pointer to the target pool as well as to an instance of the new
struct queued_entropy. For reasons explained below, __queue_entropy() also
receives the amount of entropy transferred in the subsequent
mix_pool_bytes() operation as an argument and accumulates that at the given
struct queued_entropy instance. __queue_entropy() may be called any number
of times on the same struct queued_entropy instance until a matching
__dequeue_entropy() gets eventually invoked. The latter will return the
total number of (fractional) entropy bits accumulated at queued_entropy as
well as an appropriate pool watermark. Both are intended to be used for
that pool_entropy_delta() calculation when subsequently dispatching the
accumulated entropy to the pool.

Producers are not actually expected to call __dequeue_entropy() directly.
Instead, provide the new dispatch_queued_entropy() and
__dispatch_queued_entropy_fast() helpers. These will eventually supersede
credit_entropy_bits() respectively __credit_entropy_bits_fast(). Both take
a queued_entropy instance, run __dequeue_entropy() on it, carry out the
required pool_entropy_delta() calculations and add the result to the
target pool's ->entropy_count. Conversion of the individual entropy
producers to the new API will be the subject of future patches for the sake
of better reviewability. For now, merely reimplement credit_entropy_bits()
and __credit_entropy_bits_fast() on top of it in order to avoid excessive
code duplication.

Obviously, it's the consumer side's job to maintain the pool watermark:
whenever ->entropy_count decreases, the watermark needs updating. Maintain
the pool entropy watermark in the form of a delta to be added to the
current ->entropy_count to obtain the actual value. To this end, introduce
a new field ->entropy_watermark_delta to struct entropy_store.

Rename the existing account(), which gets called right before the
corresponding extract_buf()s in extract_entropy(), to account_begin(). Make
it add the allocated entropy count, i.e. the amount by which the pool's
->entropy_count has been reduced, to ->entropy_watermark_delta.

If possible, this watermark increment should be undone after the subsequent
extract_buf()s have completed, because otherwise the watermark would grow
unboundedly beyond the pool size over time. Note that this would render
producers unable to dispatch any new non-zero entropy to ->entropy_count.
Introduce the new account_complete() for handling the
->entropy_watermark_delta decrements and call it from extract_entropy()
right after the extract_buf()s following the preceding account_begin()
have finished.

Obviously it's safe to decrement the watermark again in case nobody cares
at all -- that is, if there currently isn't any entropy queued at the
producer side. Introduce a new field ->queued_entropy_batches to struct
entropy_store for keeping track of that. Make __queue_entropy() increment
it upon the first request to queue a non-zero amount of entropy at a given
struct queued_entropy instance. Likewise, make __dequeue_entropy()
decrement it again iff a non-zero amount of entropy has been queued.
Finally, make account_complete() undo the ->entropy_watermark_delta
increment from the preceding account_begin() in case
->queued_entropy_batches is zero.

Note that if ->queued_entropy_batches is found to be non-zero in
account_complete(), ->entropy_watermark_delta is left untouched, i.e. the
increment from the preceding account_begin() is "leaked". It follows
that the watermark can still grow beyond any bound over time. However, if
at the time account_complete() runs there is no entropy queued at the
producer side *and* there is no other, concurrent extraction pending an
upcoming __queue_entropy() could possibly interfere with, the watermark may
even get reset to zero and thus, any leakages left from former invocations
cleaned up. Introduce a new field ->pending_extractions to
struct entropy_store for keeping track of the number of pending entropy
extractions. Make account_begin() increment it and make account_complete()
decrement it again. Make account_complete() reset ->entropy_watermark_delta
in case ->queued_entropy_batches and ->entropy_watermark_delta are both
zero.

Once the initially mentioned health tests have been implemented and
enabled, it will not be unlikely that there's always at least one CPU
having some entropy queued at any point in time and thus, that
->queued_entropy_batches will never be found to equal zero in
account_complete(). As a last resort, enforce upper bounds on the magnitude
as well as on the lifetime of the pool watermark and reset it if any has
been exceeded. All entropy currently queued up on the producer side needs
to be invalidated in this case. Introduce a new field
->entropy_watermark_seq to struct entropy_store for maintaing a sequence
count needed to implement entropy invalidations. Make __queue_entropy()
take a snapshot at the first invocation and make it revalidate the
snapshot when accumulating additional entropy in subsequent invocations.
Make the final __dequeue_entropy() validate the snapshot and return zero
for the amount of dequeued entropy on failure. Make account_complete()
increment the sequence count when resetting the pool watermark even though
->queued_entropy_batches is non-zero.

Note that this sequence count based invalidation scheme does not allow
for watermark resets when there are multiple concurrent extractions
pending: a future __queue_entropy() could potentially interfere with any
of the other extractions and there is no way to invalidate it "in advance".
However, this doesn't matter because there are hardly any concurrent
entropy extractions after boot and even if there were: some
account_complete() would always come last.

What remains to be clarified is under which exact circumstances
account_complete() would resort to resetting the pool watermark and
invalidating all currently queued entropy. The limit on the watermark
magnitude, ->entropy_watermark_delta to be more specific, has been set to
one eighth of the pool size == 1/8 * 4096 bits == 512 bits. This has been
chosen as a compromise between allowing for up to two 256 bit
extractions/reseeds without invalidating queued entropy and not reducing
the efficiency of new entropy contributions too much. Assuming a watermark
value of 512 bits over the current ->entropy_count, the entropy credits as
calculated by pool_entropy_delta() for new contributions are 87.5%, 75%
and 50% respectively for pool fill levels of 0%, 50% and 75% of what they
would have been with a ->entropy_watermark_delta of zero. In order to avoid
a situation where a smallish ->entropy_watermark_delta which accumulated
during boot time, but never manages to increase beyond the reset threshold,
is kept forever, also impose a lifetime limit. The choice of
2 * CRNG_RESEED_INTERVAL for the maximum watermark lifetime follows the
same line of reasoning as for the chosen magnitude limit.

In order to enable this watermark lifetime management, add yet another new
field ->entropy_watermark_leak_time to struct entropy_store. Make
account_begin() set it to the current jiffies upon the first increment of
->entropy_watermark_delta from zero. Make account_complete() reset
->entropy_watermark_delta and invalidate all queued entropy as
described above whenever ->pending_extractions is zero and either
->entropy_watermark_leak_time is older than two times CRNG_RESEED_INTERVAL
or if ->entropy_watermark_delta exceeds one fourth of the pool size.

As entropy producers haven't been converted to the new __queue_entropy() +
dispatch_queued_entropy()/__dispatch_queued_entropy_fast() API yet, the net
effect of this patch is to "fix" a scenario similar to the one initially
described for those producers that call __mix_pool_bytes() and
__credit_entropy_bits_fast() without dropping the pool's ->lock inbetween,
i.e. for add_interrupt_randomness() and add_timer_randomness(). Namely, if
said sequence happens to get serialized inbetween the account_begin()
(formerly account()) and the last extract_buf() from a concurrent
extraction, the pool's entropy watermark will now be taken into account
when calculating the amount of new entropy to credit in
__credit_entropy_bits_fast(), because the latter has been reimplemented on
top of the new API.

Other than that, it's noteworthy that the pool entropy watermark might
exceed unexpectedly high levels at boot time, namely if multiple producers
happen to trigger the initial seeding of the primary_crng and the
subsequent entropy extractions complete when entropy has been queued up
somewhere else, e.g. in try_to_generate_entropy(). As detailed above, high
values of the pool watermark will reduce the efficiency when dispatching
new entropy attributions, but note that
- There are mechanisms in place to limit the effect in magnitude and
  time.
- The watermark can never exceed the total amount of entropy collected
  so far. So entropy collection at boot time would have to be terribly
  efficient in order for this to matter.
- As seeding the primary_crng is a prerequisite for the described scenario,
  a temporarily reduced entropy collection efficiency isn't really
  concerning: getting towards a seeded primary_crng is all that matters at
  this point.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 315 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 292 insertions(+), 23 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9f87332b158f..b91d1fc08ac5 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -499,7 +499,13 @@ struct entropy_store {
 	spinlock_t lock;
 	unsigned short add_ptr;
 	unsigned short input_rotate;
+
 	int entropy_count;
+	unsigned int entropy_watermark_delta;
+	unsigned int entropy_watermark_seq;
+	unsigned int queued_entropy_batches;
+	unsigned int pending_extractions;
+	unsigned long entropy_watermark_leak_time;
 	unsigned int initialized:1;
 	unsigned int last_data_init:1;
 	__u8 last_data[EXTRACT_SIZE];
@@ -671,6 +677,9 @@ static unsigned int pool_entropy_delta(struct entropy_store *r,
 	if (!nfrac)
 		return 0;
 
+	if (pool_size <= base_entropy_count)
+		return 0;
+
 	/*
 	 * Credit: we have to account for the possibility of
 	 * overwriting already present entropy.	 Even in the
@@ -714,26 +723,172 @@ static unsigned int pool_entropy_delta(struct entropy_store *r,
 	return entropy_count - base_entropy_count;
 }
 
+struct queued_entropy {
+	unsigned int pool_watermark_seq;
+	unsigned int queued_entropy_fracbits;
+};
+
 /*
- * Credit the entropy store with n bits of entropy.
- * To be used from hot paths when it is either known that nbits is
- * smaller than one half of the pool size or losing anything beyond that
- * doesn't matter. Must be called with r->lock being held.
+ * Queue a given amount of new entropy which is about to mixed into
+ * the entropy pool for later dispatch.
+ *
+ * __queue_entropy() may be called one or more time on the same struct
+ * queued_entropy instance in order to accumulate entropy for later
+ * dispatch. However, any such sequence of invocations must eventually
+ * be followed by exactly one call to either of __dequeue_entropy(),
+ * __dispatch_queued_entropy_fast() or dispatch_queued_entropy()
+ * when the actual pool mixing has completed.
+ * __queue_entropy() must be called with r->lock held.
+ *
+ * Entropy extraction is a two-step process:
+ * 1.) The allocated amount of entropy gets subtracted from ->entropy_count.
+ * 2.) The entropy is actually extracted from the pool by means of one or more
+ *     extract_buf() invocations.
+ * Likewise for the mixing side:
+ * 1.) The new entropy data gets mixed into the pool via __mix_pool_bytes() and
+ * 2.) the pool's ->entropy_count incremented by a certain amount afterwards.
+ * However, that amount of new entropy credited in the last step depends
+ * on the current pool fill level: the higher the current ->entropy_count,
+ * the less the amount of new entropy credited, c.f. pool_entropy_delta().
+ *
+ * This must be accounted for in a scenario involving concurrent producers
+ * and consumers like the following:
+ *   Producer                                     Consumer
+ *   --------                                     --------
+ *                                                ->entropy_count -= n
+ *   __mix_pool_bytes()
+ *   ->entropy_count += pool_entropy_delta()
+ *                                                extract_buf()
+ * Note how the pool_entropy_delta() would observe a too small pool
+ * fill level and thus, credits too much entropy to the new batch.
+ *
+ * The solution to work around this is to maintain a watermark, which
+ * is guaranteed to be >= than the pool's ->entropy_count value
+ * at any point in time from before __mix_pool_bytes() to after it.
+ *
+ * A call to __queue_entropy() enables watermark tracking from the
+ * producers side, the final __dequeue_entropy() disables it and
+ * returns the watermark. See also account_begin() and
+ * account_complete().
+ *
+ * Note there's no problem wuth multiple concurrent producers, because
+ *   e1 = e0 + pool_entropy_delta(e0, n1);
+ *   e2 = e1 + pool_entropy_delta(e1, n2);
+ * is equivalent (modulo approximation artifacts) to
+ *   e2 = e0 + pool_entropy_delta(e0, n1 + n2);
  */
-static bool __credit_entropy_bits_fast(struct entropy_store *r, int nbits)
+static void __queue_entropy(struct entropy_store *r, struct queued_entropy *q,
+			    unsigned int nfrac)
+{
+	if (!nfrac)
+		return;
+
+	if (!q->queued_entropy_fracbits) {
+		/*
+		 * First call with non-zero nbits, enable watermark
+		 * tracking.
+		 */
+		q->pool_watermark_seq = r->entropy_watermark_seq;
+		r->queued_entropy_batches++;
+	} else if (q->pool_watermark_seq != r->entropy_watermark_seq) {
+		/*
+		 * Previously queued entropy is doomed because
+		 * the ->pool_watermark_delta had been reset.
+		 * Don't add any more entropy on top of that.
+		 */
+		q->pool_watermark_seq = r->entropy_watermark_seq;
+		q->queued_entropy_fracbits = 0;
+	}
+
+	q->queued_entropy_fracbits += nfrac;
+}
+
+static void queue_entropy(struct entropy_store *r, struct queued_entropy *q,
+			  unsigned int nfrac)
 {
-	int entropy_count, orig;
+	unsigned long flags;
 
-	if (!nbits)
+	spin_lock_irqsave(&r->lock, flags);
+	__queue_entropy(r, q, nfrac);
+	spin_unlock_irqrestore(&r->lock, flags);
+}
+
+/*
+ * Dequeue previously queued entropy and return the pool entropy
+ * watermark to be used in pool_entropy_delta().
+ *
+ * Must only be called after a sequence of one or more matching
+ * __queue_entropy() invocations. Must be called with r->lock
+ * held.
+ *
+ * __dequeue_entropy() returns the number of queued bits and resets
+ * q. *pool_watermark receives the pool entropy watermark as tracked
+ * from the beginning of the first preceding __queue_entropy() call
+ * up to the __dequeue_entropy() invocation.
+ *
+ * The number of returned fractional bits is intended to get
+ * subsequently passed together with the larger of *pool_watermark and
+ * r->entropy_count to pool_entropy_delta().
+ * If r->lock is not dropped inbetween *pool_watermark and the load
+ * of r->entropy_count, the former is guaranteed to equal the maximum.
+ */
+static unsigned int __dequeue_entropy(struct entropy_store *r,
+				      struct queued_entropy *q,
+				      int *pool_watermark)
+{
+	unsigned int nfrac;
+
+	nfrac = q->queued_entropy_fracbits;
+	if (!nfrac)
+		return 0;
+
+	/* Disable watermark tracking. */
+	q->queued_entropy_fracbits = 0;
+	r->queued_entropy_batches--;
+
+	/*
+	 * The watermark has been invalidated in the meanwhile and
+	 * the queued entropy is lost.
+	 */
+	if (q->pool_watermark_seq != r->entropy_watermark_seq)
+		return 0;
+
+	*pool_watermark = r->entropy_count + r->entropy_watermark_delta;
+	if (*pool_watermark < 0)
+		return 0;
+
+	return nfrac;
+}
+
+/*
+ * Credit the pool with previously queued entropy.
+ *
+ * Must only be called after a sequence of one or more matching
+ * __queue_entropy() invocations. Must be called with r->lock
+ * held.
+ *
+ * To be used from hot paths when it is either known that the amount
+ * of queued entropy is smaller than one half of the pool size or
+ * losing anything beyond that doesn't matter.
+ *
+ * Returns true if the caller is supposed to seed the primary_crng.
+ */
+static bool __dispatch_queued_entropy_fast(struct entropy_store *r,
+					   struct queued_entropy *q)
+{
+	unsigned int nfrac;
+	int entropy_count, orig, pool_watermark;
+
+	nfrac = __dequeue_entropy(r, q, &pool_watermark);
+	if (!nfrac)
 		return false;
 
 	orig = r->entropy_count;
-	entropy_count = orig + pool_entropy_delta(r, orig,
-						  nbits << ENTROPY_SHIFT,
+	entropy_count = orig + pool_entropy_delta(r, pool_watermark, nfrac,
 						  true);
 	WRITE_ONCE(r->entropy_count, entropy_count);
 
-	trace_credit_entropy_bits(r->name, nbits,
+	trace_credit_entropy_bits(r->name, nfrac >> ENTROPY_SHIFT,
 				  entropy_count >> ENTROPY_SHIFT, _RET_IP_);
 
 	if (unlikely(r == &input_pool && crng_init < 2)) {
@@ -747,15 +902,35 @@ static bool __credit_entropy_bits_fast(struct entropy_store *r, int nbits)
 
 /*
  * Credit the entropy store with n bits of entropy.
- * Use credit_entropy_bits_safe() if the value comes from userspace
- * or otherwise should be checked for extreme values.
+ * To be used from hot paths when it is either known that nbits is
+ * smaller than one half of the pool size or losing anything beyond that
+ * doesn't matter. Must be called with r->lock being held.
  */
-static void credit_entropy_bits(struct entropy_store *r, int nbits)
+static bool __credit_entropy_bits_fast(struct entropy_store *r, int nbits)
+{
+	struct queued_entropy q = { 0 };
+
+	__queue_entropy(r, &q, nbits << ENTROPY_SHIFT);
+	return __dispatch_queued_entropy_fast(r, &q);
+}
+
+/*
+ * Credit the pool with previously queued entropy.
+ *
+ * Must only be called after a sequence of one or more matching
+ * __queue_entropy() invocations.
+ */
+static void dispatch_queued_entropy(struct entropy_store *r,
+				    struct queued_entropy *q)
 {
-	int entropy_count, orig;
+	unsigned int nfrac;
+	int entropy_count, orig, pool_watermark, base;
 	unsigned long flags;
 
-	if (!nbits)
+	spin_lock_irqsave(&r->lock, flags);
+	nfrac = __dequeue_entropy(r, q, &pool_watermark);
+	spin_unlock_irqrestore(&r->lock, flags);
+	if (!nfrac)
 		return;
 
 retry:
@@ -765,9 +940,8 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 	 * ->entropy_count becomes stable.
 	 */
 	orig = READ_ONCE(r->entropy_count);
-	entropy_count = orig + pool_entropy_delta(r, orig,
-						  nbits << ENTROPY_SHIFT,
-						  false);
+	base = max_t(int, pool_watermark, orig);
+	entropy_count = orig + pool_entropy_delta(r, base, nfrac, false);
 	spin_lock_irqsave(&r->lock, flags);
 	if (r->entropy_count != orig) {
 		spin_unlock_irqrestore(&r->lock, flags);
@@ -776,7 +950,7 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 	WRITE_ONCE(r->entropy_count, entropy_count);
 	spin_unlock_irqrestore(&r->lock, flags);
 
-	trace_credit_entropy_bits(r->name, nbits,
+	trace_credit_entropy_bits(r->name, nfrac >> ENTROPY_SHIFT,
 				  entropy_count >> ENTROPY_SHIFT, _RET_IP_);
 
 	if (r == &input_pool) {
@@ -790,6 +964,19 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 	}
 }
 
+/*
+ * Credit the entropy store with n bits of entropy.
+ * Use credit_entropy_bits_safe() if the value comes from userspace
+ * or otherwise should be checked for extreme values.
+ */
+static void credit_entropy_bits(struct entropy_store *r, int nbits)
+{
+	struct queued_entropy q = { 0 };
+
+	queue_entropy(r, &q, nbits << ENTROPY_SHIFT);
+	dispatch_queued_entropy(r, &q);
+}
+
 static int credit_entropy_bits_safe(struct entropy_store *r, int nbits)
 {
 	const int nbits_max = r->poolinfo->poolwords * 32;
@@ -1402,8 +1589,12 @@ EXPORT_SYMBOL_GPL(add_disk_randomness);
 /*
  * This function decides how many bytes to actually take from the
  * given pool, and also debits the entropy count accordingly.
+ *
+ * Increases the pool entropy watermark (c.f. __queue_entropy() and
+ * __dequeue_entropy()) and must be followed with a matching
+ * account_complete() in order to decrease it again, if possible.
  */
-static size_t account(struct entropy_store *r, size_t nbytes, int min)
+static size_t account_begin(struct entropy_store *r, size_t nbytes, int min)
 {
 	int entropy_count, have_bytes;
 	size_t ibytes, nfrac;
@@ -1419,6 +1610,7 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min)
 	have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
 
 	ibytes = min_t(size_t, ibytes, have_bytes);
+
 	if (ibytes < min)
 		ibytes = 0;
 
@@ -1434,6 +1626,18 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min)
 		entropy_count = 0;
 
 	WRITE_ONCE(r->entropy_count, entropy_count);
+
+	if (!r->entropy_watermark_delta) {
+		/*
+		 * This is not exact. In fact it is not known yet if
+		 * the watermark entropy added below will be actually
+		 * be leaked in account_complete(). But there can be
+		 * concurrent consumers and someone has to set this.
+		 */
+		r->entropy_watermark_leak_time = jiffies;
+	}
+	r->entropy_watermark_delta += nfrac;
+	r->pending_extractions++;
 	spin_unlock_irqrestore(&r->lock, flags);
 
 	trace_debit_entropy(r->name, 8 * ibytes);
@@ -1445,6 +1649,69 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min)
 	return ibytes;
 }
 
+/*
+ * Undo the pool watermark increment from a preceding
+ * account_begin(), if possible.
+ */
+static void account_complete(struct entropy_store *r, size_t ibytes)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&r->lock, flags);
+	r->pending_extractions--;
+	if (!r->queued_entropy_batches) {
+		/*
+		 * There's currently no entropy queued at the producer
+		 * side and at the very least it is safe to undo the
+		 * watermark increment from the matching
+		 * account_begin().
+		 */
+		if (!r->pending_extractions) {
+			/*
+			 * No other extractions pending. It is even
+			 * safe to dismiss all watermark increments
+			 * which had to be leaked from previous,
+			 * unrelated account_complete() invocations
+			 * because there had been some entropy queued
+			 * at their time.
+			 */
+			r->entropy_watermark_delta = 0;
+		} else {
+			unsigned int nfrac;
+
+			nfrac = ibytes << (ENTROPY_SHIFT + 3);
+			r->entropy_watermark_delta -= nfrac;
+		}
+	} else if (!r->pending_extractions) {
+		/*
+		 * There is currently some entropy queued at the
+		 * producer side and there's no choice but to leave
+		 * the pool watermark untouched and thus, to "leak"
+		 * the increment from the matching account_begin().
+		 *
+		 * However, if it gets too wild, the watermark is
+		 * reset and all currently queued entropy invalidated.
+		 * We don't want to keep leaked watermark increments
+		 * forever and also keep them bounded by 1/8 of the
+		 * pool size in total in order to limit its damping
+		 * effect on new entropy in pool_entropy_delta().
+		 */
+		int leak_limit;
+		unsigned long leak_cleanup_time;
+
+		leak_limit = r->poolinfo->poolfracbits >> 3;
+		leak_cleanup_time = (r->entropy_watermark_leak_time +
+				     2 * CRNG_RESEED_INTERVAL);
+		if (r->entropy_watermark_delta > leak_limit ||
+		    time_after(jiffies, leak_cleanup_time)) {
+			r->entropy_watermark_delta = 0;
+			/* Invalidate all queued entropy. */
+			r->entropy_watermark_seq++;
+		}
+	}
+	spin_unlock_irqrestore(&r->lock, flags);
+}
+
 /*
  * This function does the actual extraction for extract_entropy and
  * extract_entropy_user.
@@ -1547,6 +1814,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 {
 	__u8 tmp[EXTRACT_SIZE];
 	unsigned long flags;
+	ssize_t ret;
 
 	/* if last_data isn't primed, we need EXTRACT_SIZE extra bytes */
 	if (fips_enabled) {
@@ -1564,9 +1832,10 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	}
 
 	trace_extract_entropy(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
-	nbytes = account(r, nbytes, min);
-
-	return _extract_entropy(r, buf, nbytes, fips_enabled);
+	nbytes = account_begin(r, nbytes, min);
+	ret = _extract_entropy(r, buf, nbytes, fips_enabled);
+	account_complete(r, nbytes);
+	return ret;
 }
 
 #define warn_unseeded_randomness(previous) \
-- 
2.26.2

