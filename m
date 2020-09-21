Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732DAC43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 471D920874
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgIUIAO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:00:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:57374 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgIUH7Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 66493B511;
        Mon, 21 Sep 2020 07:59:58 +0000 (UTC)
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
Subject: [RFC PATCH 16/41] random: convert random_ioctl() to queued_entropy API
Date:   Mon, 21 Sep 2020 09:58:32 +0200
Message-Id: <20200921075857.4424-17-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In an effort to drop credit_entropy_bits_safe() in favor of the new
queue_entropy()/dispatch_queued_entropy() API, convert random_ioctl() from
the former to the latter.

Implement two helpers:
- queue_entropy_bits_safe(), which checks the entropy passed from userspace
  for extreme values in analogy to what credit_entropy_bits_safe() did
- discard_queue_entropy(), which is invoked from random_ioctly() to discard
  the entropy queued prior to the write_pool() call in case the latter
  fails.

Use them to convert the two call sites of credit_entropy_bits_safe()
in random_ioctl() to the new API.

As a side effect, the pool entropy watermark as tracked over the duration
of the write_pool() operation is now taken correctly taken into account
when calulating the amount of new entropy to dispatch to the pool based on
the latter's fill level.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 57 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 78e65367ea86..03eadefabbca 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -737,7 +737,9 @@ struct queued_entropy {
  * dispatch. However, any such sequence of invocations must eventually
  * be followed by exactly one call to either of __dequeue_entropy(),
  * __dispatch_queued_entropy_fast() or dispatch_queued_entropy()
- * when the actual pool mixing has completed.
+ * when the actual pool mixing has completed. Alternatively,
+ * discard_queued_entropy() may be called in case the mixing has
+ * failed.
  * __queue_entropy() must be called with r->lock held.
  *
  * Entropy extraction is a two-step process:
@@ -813,6 +815,26 @@ static void queue_entropy(struct entropy_store *r, struct queued_entropy *q,
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
+/*
+ * Queue entropy which comes from userspace and might take extreme
+ * values.
+ */
+static int queue_entropy_bits_safe(struct entropy_store *r,
+				   struct queued_entropy *q,
+				   int nbits)
+{
+	const int nbits_max = r->poolinfo->poolwords * 32;
+
+	if (nbits < 0)
+		return -EINVAL;
+
+	/* Cap the value to avoid overflows */
+	nbits = min(nbits,  nbits_max);
+
+	queue_entropy(r, q, nbits << ENTROPY_SHIFT);
+	return 0;
+}
+
 /*
  * Dequeue previously queued entropy and return the pool entropy
  * watermark to be used in pool_entropy_delta().
@@ -950,6 +972,22 @@ static void dispatch_queued_entropy(struct entropy_store *r,
 	}
 }
 
+/*
+ * Discard queued entropy. May be called when e.g. a write_pool()
+ * operation failed and the corresponding previously queued entropy
+ * should not get dispatched to the pool.
+ */
+static void discard_queued_entropy(struct entropy_store *r,
+				   struct queued_entropy *q)
+{
+	unsigned long flags;
+	int pool_watermark;
+
+	spin_lock_irqsave(&r->lock, flags);
+	__dequeue_entropy(r, q, &pool_watermark);
+	spin_unlock_irqrestore(&r->lock, flags);
+}
+
 /*
  * Credit the entropy store with n bits of entropy.
  * Use credit_entropy_bits_safe() if the value comes from userspace
@@ -2272,6 +2310,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	int size, ent_count;
 	int __user *p = (int __user *)arg;
 	int retval;
+	struct queued_entropy q = { 0 };
 
 	switch (cmd) {
 	case RNDGETENTCNT:
@@ -2285,7 +2324,11 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 			return -EPERM;
 		if (get_user(ent_count, p))
 			return -EFAULT;
-		return credit_entropy_bits_safe(&input_pool, ent_count);
+		retval = queue_entropy_bits_safe(&input_pool, &q, ent_count);
+		if (retval < 0)
+			return retval;
+		dispatch_queued_entropy(&input_pool, &q);
+		return 0;
 	case RNDADDENTROPY:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
@@ -2295,11 +2338,17 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 			return -EINVAL;
 		if (get_user(size, p++))
 			return -EFAULT;
+		retval = queue_entropy_bits_safe(&input_pool, &q, ent_count);
+		if (retval < 0)
+			return retval;
 		retval = write_pool(&input_pool, (const char __user *)p,
 				    size);
-		if (retval < 0)
+		if (retval < 0) {
+			discard_queued_entropy(&input_pool, &q);
 			return retval;
-		return credit_entropy_bits_safe(&input_pool, ent_count);
+		}
+		discard_queued_entropy(&input_pool, &q);
+		return 0;
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
 		/*
-- 
2.26.2

