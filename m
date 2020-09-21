Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A83C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2043020874
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgIUIBa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:01:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:56802 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726588AbgIUH7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ED703B521;
        Mon, 21 Sep 2020 08:00:05 +0000 (UTC)
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
Subject: [RFC PATCH 29/41] random: move definition of struct queued_entropy and related API upwards
Date:   Mon, 21 Sep 2020 09:58:45 +0200
Message-Id: <20200921075857.4424-30-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The next patch will add a member of type struct queued_entropy to struct
fast_pool and thus, the former's definition needs to be visible at the
latter's.

Move the definition of struct queued_entropy upwards in the file so that
it comes before the definition struct fast_pool. Move the associated
function definitions as well in order to keep everything together.

Note that said function definitions had originally been inserted at the
old location with the intent to minimize their introducing patch's diff
by placing them near the now removed credit_entropy_delta() they
superseded.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 243 +++++++++++++++++++++---------------------
 1 file changed, 124 insertions(+), 119 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 680ccc82a436..55e784a5a2ec 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -519,6 +519,10 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
 				size_t nbytes, int fips);
 
+static unsigned int pool_entropy_delta(struct entropy_store *r,
+				       int base_entropy_count,
+				       int nfrac, bool fast);
+
 static int min_crng_reseed_pool_entropy(void);
 
 static void crng_reseed(struct crng_state *crng, struct entropy_store *r);
@@ -610,125 +614,6 @@ static void mix_pool_bytes(struct entropy_store *r, const void *in,
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
-struct fast_pool {
-	__u32		pool[4];
-	unsigned long	last;
-	unsigned short	reg_idx;
-	unsigned char	count;
-	int		event_entropy_shift;
-};
-
-/*
- * This is a fast mixing routine used by the interrupt randomness
- * collector.  It's hardcoded for an 128 bit pool and assumes that any
- * locks that might be needed are taken by the caller.
- */
-static void fast_mix(struct fast_pool *f)
-{
-	__u32 a = f->pool[0],	b = f->pool[1];
-	__u32 c = f->pool[2],	d = f->pool[3];
-
-	a += b;			c += d;
-	b = rol32(b, 6);	d = rol32(d, 27);
-	d ^= a;			b ^= c;
-
-	a += b;			c += d;
-	b = rol32(b, 16);	d = rol32(d, 14);
-	d ^= a;			b ^= c;
-
-	a += b;			c += d;
-	b = rol32(b, 6);	d = rol32(d, 27);
-	d ^= a;			b ^= c;
-
-	a += b;			c += d;
-	b = rol32(b, 16);	d = rol32(d, 14);
-	d ^= a;			b ^= c;
-
-	f->pool[0] = a;  f->pool[1] = b;
-	f->pool[2] = c;  f->pool[3] = d;
-	f->count++;
-}
-
-static void process_random_ready_list(void)
-{
-	unsigned long flags;
-	struct random_ready_callback *rdy, *tmp;
-
-	spin_lock_irqsave(&random_ready_list_lock, flags);
-	list_for_each_entry_safe(rdy, tmp, &random_ready_list, list) {
-		struct module *owner = rdy->owner;
-
-		list_del_init(&rdy->list);
-		rdy->func(rdy);
-		module_put(owner);
-	}
-	spin_unlock_irqrestore(&random_ready_list_lock, flags);
-}
-
-/*
- * Based on the pool's current entropy fill level, specified as
- * base_entropy_count, and the number of new entropy bits in units of
- * 2^-ENTROPY_SHIFT to add, return the amount of new entropy to
- * credit. If the 'fast' parameter is set to true, the calculation
- * will be guaranteed to terminate quickly, but this comes at the
- * expense of capping nbits to one half of the pool size.
- */
-static unsigned int pool_entropy_delta(struct entropy_store *r,
-				       int base_entropy_count,
-				       int nfrac, bool fast)
-{
-	const int pool_size = r->poolinfo->poolfracbits;
-	int entropy_count = base_entropy_count;
-
-	if (!nfrac)
-		return 0;
-
-	if (pool_size <= base_entropy_count)
-		return 0;
-
-	/*
-	 * Credit: we have to account for the possibility of
-	 * overwriting already present entropy.	 Even in the
-	 * ideal case of pure Shannon entropy, new contributions
-	 * approach the full value asymptotically:
-	 *
-	 * entropy <- entropy + (pool_size - entropy) *
-	 *	(1 - exp(-add_entropy/pool_size))
-	 *
-	 * For add_entropy <= pool_size/2 then
-	 * (1 - exp(-add_entropy/pool_size)) >=
-	 *    (add_entropy/pool_size)*0.7869...
-	 * so we can approximate the exponential with
-	 * 3/4*add_entropy/pool_size and still be on the
-	 * safe side by adding at most pool_size/2 at a time.
-	 *
-	 * The use of pool_size-2 in the while statement is to
-	 * prevent rounding artifacts from making the loop
-	 * arbitrarily long; this limits the loop to log2(pool_size)*2
-	 * turns no matter how large nbits is.
-	 */
-	do {
-		/* The +2 corresponds to the /4 in the denominator */
-		const int s = r->poolinfo->poolbitshift + ENTROPY_SHIFT + 2;
-		unsigned int anfrac = min(nfrac, pool_size/2);
-		unsigned int add =
-			((pool_size - entropy_count)*anfrac*3) >> s;
-
-		entropy_count += add;
-		nfrac -= anfrac;
-	} while (unlikely(!fast && entropy_count < pool_size-2 && nfrac));
-
-	if (WARN_ON(entropy_count < 0)) {
-		pr_warn("negative entropy/overflow: pool %s count %d\n",
-			r->name, entropy_count);
-		entropy_count = base_entropy_count;
-	} else if (entropy_count > pool_size) {
-		entropy_count = pool_size;
-	}
-
-	return entropy_count - base_entropy_count;
-}
-
 struct queued_entropy {
 	unsigned int pool_watermark_seq;
 	unsigned int queued_entropy_fracbits;
@@ -994,6 +879,126 @@ static void discard_queued_entropy(struct entropy_store *r,
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
+struct fast_pool {
+	__u32		pool[4];
+	unsigned long	last;
+	unsigned short	reg_idx;
+	unsigned char	count;
+	int		event_entropy_shift;
+};
+
+/*
+ * This is a fast mixing routine used by the interrupt randomness
+ * collector.  It's hardcoded for an 128 bit pool and assumes that any
+ * locks that might be needed are taken by the caller.
+ */
+static void fast_mix(struct fast_pool *f)
+{
+	__u32 a = f->pool[0],	b = f->pool[1];
+	__u32 c = f->pool[2],	d = f->pool[3];
+
+	a += b;			c += d;
+	b = rol32(b, 6);	d = rol32(d, 27);
+	d ^= a;			b ^= c;
+
+	a += b;			c += d;
+	b = rol32(b, 16);	d = rol32(d, 14);
+	d ^= a;			b ^= c;
+
+	a += b;			c += d;
+	b = rol32(b, 6);	d = rol32(d, 27);
+	d ^= a;			b ^= c;
+
+	a += b;			c += d;
+	b = rol32(b, 16);	d = rol32(d, 14);
+	d ^= a;			b ^= c;
+
+	f->pool[0] = a;  f->pool[1] = b;
+	f->pool[2] = c;  f->pool[3] = d;
+	f->count++;
+}
+
+static void process_random_ready_list(void)
+{
+	unsigned long flags;
+	struct random_ready_callback *rdy, *tmp;
+
+	spin_lock_irqsave(&random_ready_list_lock, flags);
+	list_for_each_entry_safe(rdy, tmp, &random_ready_list, list) {
+		struct module *owner = rdy->owner;
+
+		list_del_init(&rdy->list);
+		rdy->func(rdy);
+		module_put(owner);
+	}
+	spin_unlock_irqrestore(&random_ready_list_lock, flags);
+}
+
+/*
+ * Based on the pool's current entropy fill level, specified as
+ * base_entropy_count, and the number of new entropy bits in units of
+ * 2^-ENTROPY_SHIFT to add, return the amount of new entropy to
+ * credit. If the 'fast' parameter is set to true, the calculation
+ * will be guaranteed to terminate quickly, but this comes at the
+ * expense of capping nbits to one half of the pool size.
+ */
+static unsigned int pool_entropy_delta(struct entropy_store *r,
+				       int base_entropy_count,
+				       int nfrac, bool fast)
+{
+	const int pool_size = r->poolinfo->poolfracbits;
+	int entropy_count = base_entropy_count;
+
+	if (!nfrac)
+		return 0;
+
+	if (pool_size <= base_entropy_count)
+		return 0;
+
+	/*
+	 * Credit: we have to account for the possibility of
+	 * overwriting already present entropy.	 Even in the
+	 * ideal case of pure Shannon entropy, new contributions
+	 * approach the full value asymptotically:
+	 *
+	 * entropy <- entropy + (pool_size - entropy) *
+	 *	(1 - exp(-add_entropy/pool_size))
+	 *
+	 * For add_entropy <= pool_size/2 then
+	 * (1 - exp(-add_entropy/pool_size)) >=
+	 *    (add_entropy/pool_size)*0.7869...
+	 * so we can approximate the exponential with
+	 * 3/4*add_entropy/pool_size and still be on the
+	 * safe side by adding at most pool_size/2 at a time.
+	 *
+	 * The use of pool_size-2 in the while statement is to
+	 * prevent rounding artifacts from making the loop
+	 * arbitrarily long; this limits the loop to log2(pool_size)*2
+	 * turns no matter how large nbits is.
+	 */
+	do {
+		/* The +2 corresponds to the /4 in the denominator */
+		const int s = r->poolinfo->poolbitshift + ENTROPY_SHIFT + 2;
+		unsigned int anfrac = min(nfrac, pool_size/2);
+		unsigned int add =
+			((pool_size - entropy_count)*anfrac*3) >> s;
+
+		entropy_count += add;
+		nfrac -= anfrac;
+	} while (unlikely(!fast && entropy_count < pool_size-2 && nfrac));
+
+	if (WARN_ON(entropy_count < 0)) {
+		pr_warn("negative entropy/overflow: pool %s count %d\n",
+			r->name, entropy_count);
+		entropy_count = base_entropy_count;
+	} else if (entropy_count > pool_size) {
+		entropy_count = pool_size;
+	}
+
+	return entropy_count - base_entropy_count;
+}
+
+
 /*********************************************************************
  *
  * CRNG using CHACHA20
-- 
2.26.2

