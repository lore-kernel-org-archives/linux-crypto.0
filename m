Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2A7C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6365F20874
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgIUIAq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:00:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:57298 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgIUH7k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A947EB52B;
        Mon, 21 Sep 2020 08:00:07 +0000 (UTC)
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
Subject: [RFC PATCH 32/41] random: introduce health test stub and wire it up
Date:   Mon, 21 Sep 2020 09:58:48 +0200
Message-Id: <20200921075857.4424-33-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

NIST SP800-90B requires certain statistical tests to be run continuously on
a noise source's output.

In preparation to implementing those, introduce an empty stub,
health_test_process() and wire it up to add_interrupt_randomness(). This
patch does not implement any actual testing functionality yet, it's mereley
meant to define the interactions between add_interrupt_randomness() and
the health tests.

health_test_process() is to be invoked on individual noise samples, i.e.
cycle counter values and returns, either of three possible status
codes indicating to the calling add_interrupt_randomness() that
- either some more samples are needed in order to complete the statistical
  tests,
- that the tests have finished with positive result on the latest run
  of noise samples or
- that the tests have failed.

Introduce an enum health_result defining constants corresponding to these
resp. cases: health_queue, health_dispatch and health_discard. Provide
another value, health_none, to indicate the case that the health tests
are disabled, because e.g. fips_enabled is unset. Make the stub
health_test_process() return this value for now.

As long as the statistical tests need more input noise samples before
reaching a conclusion, health_queue will get returned from
health_test_process(). FWIW, the number of successive input samples needed
by the tests will be at the order of 128 to 8192, depending on the per-IRQ
entropy estimate. add_interrupt_randomness() currently attempts to transfer
the noise kept within in the per-CPU fast_pool, which is of limited
capacity, to the global input_pool as soon as a threshold of 64 events is
reached and it will continue to do so. However, as long as some tests are
pending, i.e. keep returning health_queue, the associated amount of
estimated entropy must not get added to the global input_pool balance, but
queued up at the fast_pool's queued_entropy instance. Once the health test
have eventually succeeded, as indiciated by health_test_process(), the
entropy previously queued up may get dispatched to the global reserve.
OTOH, on test failure health_discard will get returned and all entropy
queued up from add_interrupt_randomness() since the last dispatch (or
discard resp.) must get discarded.

Note that add_interrupt_randomness() will continue to unconditionally mix
the samples into the fast_pools and eventually into the global input_pool
-- the health test results really only affect the entropy accounting.

So, make add_interrupt_randomness() invoke health_test_process() on
the current cycle counter value in case fips_enabled is set.

In case a fast_pool's fill level threshold of 64 events is reached at a
time when health tests are still pending and keep returning health_queue,
let add_interrupt_randomness() continue to mix the fast_pool's contents
into the input_pool as before, but enqueue the associated amount of entropy
at the fast_pool's associated queued_entropy instance for later dispatch.

Both, entropy dispatch as well as discard operations, require a call to
__dequeue_entropy(), which in turn must only get invoked with the
input_pool's ->lock being held. It follows that in case the spin_trylock()
in add_interrupt_randomness() failed, the latter would not be able to
perform entropy dispatch or discard operations immediately at the time
those have been requested by the health tests. Add two new boolean flags,
->dispatch_needed and ->discard_needed, to struct fast_pool. Set them from
add_interrupt_randomness() in case health_test_process() returned
health_dispatch or health_discard resp.. Make the current and subsequent
add_interrupt_randomness() invocations to check for ->dispatch_needed and
->discard_needed and to attempt to execute any pending dispatch/discard
request. Clear ->dispatch_needed and ->discard_needed again when the
prerequisite ->lock could eventually be obtained.

As actual health tests returning anything but health_none haven't been
implemented yet, there is no behavioural change at this point.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 78 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 75 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0f56c873a501..cb6441b96b8e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -881,14 +881,30 @@ static void discard_queued_entropy(struct entropy_store *r,
 
 struct health_test {};
 
+enum health_result {
+	health_none,
+	health_queue,
+	health_dispatch,
+	health_discard,
+};
+
 static void health_test_reset(struct health_test *h)
 {}
 
+static enum health_result
+health_test_process(struct health_test *h, unsigned int event_entropy_shift,
+		    u8 sample)
+{
+	return health_none;
+}
+
 struct fast_pool {
 	__u32		pool[4];
 	unsigned long	last;
 	unsigned short	reg_idx;
 	unsigned char	count;
+	bool		dispatch_needed : 1;
+	bool		discard_needed : 1;
 	int		event_entropy_shift;
 	struct queued_entropy	q;
 	struct health_test	health;
@@ -1662,9 +1678,10 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	cycles_t		cycles = random_get_entropy();
 	__u32			c_high, j_high;
 	__u64			ip;
-	bool			reseed;
+	bool			reseed = false;
 	struct queued_entropy	*q = &fast_pool->q;
 	unsigned int		nfrac;
+	enum health_result	health_result = health_none;
 
 	if (cycles == 0)
 		cycles = get_reg(fast_pool, regs);
@@ -1682,6 +1699,12 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	this_cpu_add(net_rand_state.s1, fast_pool->pool[cycles & 3]);
 
 	fast_pool_init_accounting(fast_pool);
+	if (fips_enabled) {
+		health_result =
+			health_test_process(&fast_pool->health,
+					    fast_pool->event_entropy_shift,
+					    cycles);
+	}
 
 	if (unlikely(crng_init == 0)) {
 		if ((fast_pool->count >= 64) &&
@@ -1693,8 +1716,48 @@ void add_interrupt_randomness(int irq, int irq_flags)
 		return;
 	}
 
+	switch (health_result) {
+	case health_dispatch:
+		/*
+		 * Still haven't made it around processing a previous
+		 * entropy discard request?
+		 */
+		fast_pool->dispatch_needed = !fast_pool->discard_needed;
+		break;
+
+	case health_discard:
+		/*
+		 * Still haven't made it around processing a previous
+		 * entropy dispatch request?
+		 */
+		fast_pool->discard_needed = !fast_pool->dispatch_needed;
+		break;
+
+	case health_queue:
+		/*
+		 * If a previous sample triggered a dispatch which is
+		 * still pending, it's impossible to add new events on
+		 * top as far as entropy accounting is
+		 * concerned. Don't count any events until we get a
+		 * hold of the input_pool ->lock and complete the
+		 * dispatch below. Undo the increment from fast_mix()
+		 * above.
+		 */
+		if (fast_pool->dispatch_needed)
+			fast_pool->count--;
+		break;
+
+	case health_none:
+		/*
+		 * fips_enabled is unset, suppress compiler warnings.
+		 */
+		break;
+	};
+
 	if ((fast_pool->count < 64) &&
-	    !time_after(now, fast_pool->last + HZ))
+	    !(health_result == health_none &&
+	      time_after(now, fast_pool->last + HZ)) &&
+	    !fast_pool->dispatch_needed && !fast_pool->discard_needed)
 		return;
 
 	r = &input_pool;
@@ -1710,7 +1773,16 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	}
 	__queue_entropy(r, q, nfrac);
 	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool));
-	reseed = __dispatch_queued_entropy_fast(r, q);
+
+	if (fast_pool->dispatch_needed || health_result == health_none) {
+		reseed = __dispatch_queued_entropy_fast(r, q);
+		fast_pool->dispatch_needed = false;
+	} else if (fast_pool->discard_needed) {
+		int dummy;
+
+		__dequeue_entropy(r, q, &dummy);
+		fast_pool->discard_needed = false;
+	}
 	spin_unlock(&r->lock);
 
 	fast_pool->last = now;
-- 
2.26.2

