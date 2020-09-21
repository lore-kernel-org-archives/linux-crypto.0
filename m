Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F224AC43463
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAE8420874
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgIUH7V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:59:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:56832 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbgIUH7U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A8BF3B504;
        Mon, 21 Sep 2020 07:59:53 +0000 (UTC)
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
Subject: [RFC PATCH 08/41] random: introduce __credit_entropy_bits_fast() for hot paths
Date:   Mon, 21 Sep 2020 09:58:24 +0200
Message-Id: <20200921075857.4424-9-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When transferring entropy from the fast_pool into the global input_pool
from add_interrupt_randomness(), there are at least two atomic operations
involved: one when taking the input_pool's spinlock for the actual mixing
and another one in the cmpxchg loop in credit_entropy_bits() for
updating the pool's ->entropy_count. Because cmpxchg is potentially costly,
it would be nice if it could be avoided.

As said, the input_pool's spinlock is taken anyway, and I see no reason
why its scope should not be extended to protect ->entropy_count as well.
Performance considerations set aside, this will also facilitate future
changes introducing additional fields to input_pool which will also have to
get updated atomically from the consumer/producer sides.

The actual move to extend the spinlock's scope to cover ->entropy_count
will be the subject of a future patch. Prepare for that by putting
a limit on the work to be done with the lock being held.

In order to avoid releasing and regrabbing from hot producer paths, they'll
keep the lock when executing those calculations in pool_entropy_delta().
The loop found in the latter has a theoretical upper bound of
2 * log2(pool_size) == 24 iterations. However, as all entropy increments
awarded from the interrupt path are less than pool_size/2 in magnitude,
it is safe to enforce a guaranteed limit of one on the iteration count
by setting pool_entropy_delta()'s 'fast' parameter.

Introduce __credit_entropy_bits_fast() doing exactly that. Currently
it resembles the behaviour from credit_entropy_bits() except that
- pool_entropy_delta() gets called with 'fast' set to true and
- that __credit_entropy_bits_fast() returns a bool indicating whether
  the caller should reseed the primary_crng.

Note that unlike it's the case with credit_entropy_bits(), the reseeding
won't be possible from within __credit_entropy_bits_fast() anymore once it
actually gets invoked with the pool lock being held in the future.

There is no functional change.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 49 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 08caa7a691a5..d9e4dd27d45d 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -714,6 +714,39 @@ static unsigned int pool_entropy_delta(struct entropy_store *r,
 	return entropy_count - base_entropy_count;
 }
 
+/*
+ * Credit the entropy store with n bits of entropy.
+ * To be used from hot paths when it is either known that nbits is
+ * smaller than one half of the pool size or losing anything beyond that
+ * doesn't matter.
+ */
+static bool __credit_entropy_bits_fast(struct entropy_store *r, int nbits)
+{
+	int entropy_count, orig;
+
+	if (!nbits)
+		return false;
+
+retry:
+	orig = READ_ONCE(r->entropy_count);
+	entropy_count = orig + pool_entropy_delta(r, orig,
+						  nbits << ENTROPY_SHIFT,
+						  true);
+	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+		goto retry;
+
+	trace_credit_entropy_bits(r->name, nbits,
+				  entropy_count >> ENTROPY_SHIFT, _RET_IP_);
+
+	if (unlikely(r == &input_pool && crng_init < 2)) {
+		const int entropy_bits = entropy_count >> ENTROPY_SHIFT;
+
+		return (entropy_bits >= 128);
+	}
+
+	return false;
+}
+
 /*
  * Credit the entropy store with n bits of entropy.
  * Use credit_entropy_bits_safe() if the value comes from userspace
@@ -1169,6 +1202,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 		unsigned num;
 	} sample;
 	long delta, delta2, delta3;
+	bool reseed;
 
 	sample.jiffies = jiffies;
 	sample.cycles = random_get_entropy();
@@ -1206,7 +1240,9 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 	 * Round down by 1 bit on general principles,
 	 * and limit entropy estimate to 12 bits.
 	 */
-	credit_entropy_bits(r, min_t(int, fls(delta>>1), 11));
+	reseed = __credit_entropy_bits_fast(r, min_t(int, fls(delta>>1), 11));
+	if (reseed)
+		crng_reseed(&primary_crng, r);
 }
 
 void add_input_randomness(unsigned int type, unsigned int code,
@@ -1274,6 +1310,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	__u64			ip;
 	unsigned long		seed;
 	int			credit = 0;
+	bool			reseed;
 
 	if (cycles == 0)
 		cycles = get_reg(fast_pool, regs);
@@ -1326,7 +1363,9 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	fast_pool->count = 0;
 
 	/* award one bit for the contents of the fast pool */
-	credit_entropy_bits(r, credit + 1);
+	reseed = __credit_entropy_bits_fast(r, credit + 1);
+	if (reseed)
+		crng_reseed(&primary_crng, r);
 }
 EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 
@@ -1599,7 +1638,11 @@ EXPORT_SYMBOL(get_random_bytes);
  */
 static void entropy_timer(struct timer_list *t)
 {
-	credit_entropy_bits(&input_pool, 1);
+	bool reseed;
+
+	reseed = __credit_entropy_bits_fast(&input_pool, 1);
+	if (reseed)
+		crng_reseed(&primary_crng, &input_pool);
 }
 
 /*
-- 
2.26.2

