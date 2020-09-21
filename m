Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B5CC43465
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3D2F20EDD
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgIUH7R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:59:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:56334 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgIUH7R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 29F86B340;
        Mon, 21 Sep 2020 07:59:51 +0000 (UTC)
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
Subject: [RFC PATCH 02/41] random: remove dead code for nbits < 0 in credit_entropy_bits()
Date:   Mon, 21 Sep 2020 09:58:18 +0200
Message-Id: <20200921075857.4424-3-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The nbits argument to credit_entropy_bits() is never negative and
the branch handling it is dead code. Remove it.

The code for handling the regular nbits > 0 case used to live in the
corresponding else branch, but has now been lifted up to function scope.
Move the declaration of 'pnfrac' to the function prologue in order to
adhere to C99 rules. Likewise, move the declaration of 's' into the
body loop, the only scope it's referenced from.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 69 ++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 37 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0580968fd28c..c4b7bdbd460e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -654,7 +654,7 @@ static void process_random_ready_list(void)
 }
 
 /*
- * Credit (or debit) the entropy store with n bits of entropy.
+ * Credit the entropy store with n bits of entropy.
  * Use credit_entropy_bits_safe() if the value comes from userspace
  * or otherwise should be checked for extreme values.
  */
@@ -663,50 +663,45 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 	int entropy_count, orig;
 	const int pool_size = r->poolinfo->poolfracbits;
 	int nfrac = nbits << ENTROPY_SHIFT;
+	int pnfrac;
 
 	if (!nbits)
 		return;
 
 retry:
 	entropy_count = orig = READ_ONCE(r->entropy_count);
-	if (nfrac < 0) {
-		/* Debit */
-		entropy_count += nfrac;
-	} else {
-		/*
-		 * Credit: we have to account for the possibility of
-		 * overwriting already present entropy.	 Even in the
-		 * ideal case of pure Shannon entropy, new contributions
-		 * approach the full value asymptotically:
-		 *
-		 * entropy <- entropy + (pool_size - entropy) *
-		 *	(1 - exp(-add_entropy/pool_size))
-		 *
-		 * For add_entropy <= pool_size/2 then
-		 * (1 - exp(-add_entropy/pool_size)) >=
-		 *    (add_entropy/pool_size)*0.7869...
-		 * so we can approximate the exponential with
-		 * 3/4*add_entropy/pool_size and still be on the
-		 * safe side by adding at most pool_size/2 at a time.
-		 *
-		 * The use of pool_size-2 in the while statement is to
-		 * prevent rounding artifacts from making the loop
-		 * arbitrarily long; this limits the loop to log2(pool_size)*2
-		 * turns no matter how large nbits is.
-		 */
-		int pnfrac = nfrac;
-		const int s = r->poolinfo->poolbitshift + ENTROPY_SHIFT + 2;
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
+	pnfrac = nfrac;
+	do {
 		/* The +2 corresponds to the /4 in the denominator */
+		const int s = r->poolinfo->poolbitshift + ENTROPY_SHIFT + 2;
+		unsigned int anfrac = min(pnfrac, pool_size/2);
+		unsigned int add =
+			((pool_size - entropy_count)*anfrac*3) >> s;
 
-		do {
-			unsigned int anfrac = min(pnfrac, pool_size/2);
-			unsigned int add =
-				((pool_size - entropy_count)*anfrac*3) >> s;
-
-			entropy_count += add;
-			pnfrac -= anfrac;
-		} while (unlikely(entropy_count < pool_size-2 && pnfrac));
-	}
+		entropy_count += add;
+		pnfrac -= anfrac;
+	} while (unlikely(entropy_count < pool_size-2 && pnfrac));
 
 	if (WARN_ON(entropy_count < 0)) {
 		pr_warn("negative entropy/overflow: pool %s count %d\n",
-- 
2.26.2

