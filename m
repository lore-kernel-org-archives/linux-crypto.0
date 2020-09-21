Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF82C43465
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C92D620EDD
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgIUIBH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:01:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:58044 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgIUH7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1D565B52C;
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
Subject: [RFC PATCH 31/41] random: introduce struct health_test + health_test_reset() placeholders
Date:   Mon, 21 Sep 2020 09:58:47 +0200
Message-Id: <20200921075857.4424-32-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The to be implemented health tests will maintain some per-CPU state as they
successively process the IRQ samples fed into the resp. fast_pool from
add_interrupt_randomness().

In order to not to clutter future patches with trivialities, introduce
an empty struct health_test supposed to keep said state in the future.
Add a member of this new type to struct fast_pool.

Introduce a health_test_reset() stub, which is supposed to (re)initialize
instances of struct health_test.

Invoke it from the fast_pool_init_accounting() to make sure that a
fast_pool's contained health_test instance gets initialized once before
its first usage.

Make add_interrupt_randomness call fast_pool_init_accounting() earlier:
health test functionality will get invoked before the latter's old location
and it must have been initialized by that time.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 37746df53acf..0f56c873a501 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -879,6 +879,11 @@ static void discard_queued_entropy(struct entropy_store *r,
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
+struct health_test {};
+
+static void health_test_reset(struct health_test *h)
+{}
+
 struct fast_pool {
 	__u32		pool[4];
 	unsigned long	last;
@@ -886,6 +891,7 @@ struct fast_pool {
 	unsigned char	count;
 	int		event_entropy_shift;
 	struct queued_entropy	q;
+	struct health_test	health;
 };
 
 /*
@@ -1644,6 +1650,7 @@ static inline void fast_pool_init_accounting(struct fast_pool *f)
 		return;
 
 	f->event_entropy_shift = min_irq_event_entropy_shift();
+	health_test_reset(&f->health);
 }
 
 void add_interrupt_randomness(int irq, int irq_flags)
@@ -1674,6 +1681,8 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	add_interrupt_bench(cycles);
 	this_cpu_add(net_rand_state.s1, fast_pool->pool[cycles & 3]);
 
+	fast_pool_init_accounting(fast_pool);
+
 	if (unlikely(crng_init == 0)) {
 		if ((fast_pool->count >= 64) &&
 		    crng_fast_load((char *) fast_pool->pool,
@@ -1692,8 +1701,6 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	if (!spin_trylock(&r->lock))
 		return;
 
-	fast_pool_init_accounting(fast_pool);
-
 	if (!fips_enabled) {
 		/* award one bit for the contents of the fast pool */
 		nfrac = 1 << ENTROPY_SHIFT;
-- 
2.26.2

