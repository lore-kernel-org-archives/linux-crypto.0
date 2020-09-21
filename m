Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46910C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D07620EDD
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgIUIA2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:00:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:56802 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgIUH7W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B03C1B50E;
        Mon, 21 Sep 2020 07:59:56 +0000 (UTC)
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
Subject: [RFC PATCH 13/41] random: convert try_to_generate_entropy() to queued_entropy API
Date:   Mon, 21 Sep 2020 09:58:29 +0200
Message-Id: <20200921075857.4424-14-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In an effort to drop __credit_entropy_bits_fast() in favor of the new
__queue_entropy()/__dispatch_queued_entropy_fast() API, convert
try_to_generate_entropy() from the former to the latter.

Replace the call to __credit_entropy_bits_fast() from the timer callback,
entropy_timer(), by a queue_entropy() operation. Dispatch it from the loop
in try_to_generate_entropy() by invoking __dispatch_queued_entropy_fast()
after the timestamp has been mixed into the input_pool.

In order to provide the timer callback and try_to_generate_entropy() with
access to a common struct queued_entropy instance, move the currently
anonymous struct definition from the local 'stack' variable declaration in
try_to_generate_entropy() to file scope and assign it a name,
"struct try_to_generate_entropy_stack". Make entropy_timer() obtain a
pointer to the corresponding instance by means of container_of() on the
->timer member contained therein. Amend struct
try_to_generate_entropy_stack by a new member ->q of type struct
queued_entropy.

Note that the described scheme alters behaviour a bit: first of all, new
entropy credit now gets only dispatched to the pool after the actual mixing
has completed rather than in an unsynchronized manner directly from the
timer callback. As the mixing loop try_to_generate_entropy() is expected to
run at higher frequency than the timer, this is unlikely to make any
difference in practice.

Furthermore, the pool entropy watermark as tracked over the period from
queuing the entropy in the timer callback and to its subsequent dispatch
from try_to_generate_entropy() is now taken into account when calculating
the actual credit at dispatch. In consequence, the amount of new entropy
dispatched to the pool will potentially be lowered if said period happens
to overlap with the pool extraction from an initial crng_reseed() on the
primary_crng. However, as getting the primary_crng seeded is the whole
point of the try_to_generate_entropy() exercise, this won't matter.

Note that instead of calling queue_entropy() from the timer callback,
an alternative would have been to maintain an invocation counter and queue
that up from try_to_generate_entropy() right before the mix operation.
This would have reduced the described effect of the pool's entropy
watermark and in fact matched the intended queue_entropy() API usage
better. However, in this particular case of try_to_generate_entropy(),
jitter is desired and invoking queue_entropy() with its buffer locking etc.
from the timer callback could potentially contribute to that.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index bd3774c6be4b..dfbe49fdbcf1 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1911,6 +1911,12 @@ void get_random_bytes(void *buf, int nbytes)
 EXPORT_SYMBOL(get_random_bytes);
 
 
+struct try_to_generate_entropy_stack {
+	unsigned long now;
+	struct timer_list timer;
+	struct queued_entropy q;
+} stack;
+
 /*
  * Each time the timer fires, we expect that we got an unpredictable
  * jump in the cycle counter. Even if the timer is running on another
@@ -1926,14 +1932,10 @@ EXPORT_SYMBOL(get_random_bytes);
  */
 static void entropy_timer(struct timer_list *t)
 {
-	bool reseed;
-	unsigned long flags;
+	struct try_to_generate_entropy_stack *stack;
 
-	spin_lock_irqsave(&input_pool.lock, flags);
-	reseed = __credit_entropy_bits_fast(&input_pool, 1);
-	spin_unlock_irqrestore(&input_pool.lock, flags);
-	if (reseed)
-		crng_reseed(&primary_crng, &input_pool);
+	stack = container_of(t, struct try_to_generate_entropy_stack, timer);
+	queue_entropy(&input_pool, &stack->q, 1 << ENTROPY_SHIFT);
 }
 
 /*
@@ -1942,10 +1944,9 @@ static void entropy_timer(struct timer_list *t)
  */
 static void try_to_generate_entropy(void)
 {
-	struct {
-		unsigned long now;
-		struct timer_list timer;
-	} stack;
+	struct try_to_generate_entropy_stack stack = { 0 };
+	unsigned long flags;
+	bool reseed;
 
 	stack.now = random_get_entropy();
 
@@ -1957,14 +1958,29 @@ static void try_to_generate_entropy(void)
 	while (!crng_ready()) {
 		if (!timer_pending(&stack.timer))
 			mod_timer(&stack.timer, jiffies+1);
-		mix_pool_bytes(&input_pool, &stack.now, sizeof(stack.now));
+		spin_lock_irqsave(&input_pool.lock, flags);
+		__mix_pool_bytes(&input_pool, &stack.now, sizeof(stack.now));
+		reseed = __dispatch_queued_entropy_fast(&input_pool, &stack.q);
+		spin_unlock_irqrestore(&input_pool.lock, flags);
+
+		if (reseed)
+			crng_reseed(&primary_crng, &input_pool);
+
 		schedule();
 		stack.now = random_get_entropy();
 	}
 
 	del_timer_sync(&stack.timer);
 	destroy_timer_on_stack(&stack.timer);
-	mix_pool_bytes(&input_pool, &stack.now, sizeof(stack.now));
+	spin_lock_irqsave(&input_pool.lock, flags);
+	__mix_pool_bytes(&input_pool, &stack.now, sizeof(stack.now));
+	/*
+	 * Must be called here once more in order to complete a
+	 * previously unmatched queue_entropy() from entropy_timer(),
+	 * if any.
+	 */
+	__dispatch_queued_entropy_fast(&input_pool, &stack.q);
+	spin_unlock_irqrestore(&input_pool.lock, flags);
 }
 
 /*
-- 
2.26.2

