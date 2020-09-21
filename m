Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8526C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E2802151B
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgIUH7W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:59:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:56798 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgIUH7T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8BDECB502;
        Mon, 21 Sep 2020 07:59:52 +0000 (UTC)
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
Subject: [RFC PATCH 06/41] random: factor the exponential approximation in credit_entropy_bits() out
Date:   Mon, 21 Sep 2020 09:58:22 +0200
Message-Id: <20200921075857.4424-7-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In the course of calculating the actual amount of new entropy to credit,
credit_entropy_bits() applies a linear approximation to
exp(-nbits/pool_size)) (neglecting scaling factors in the exponent for
the sake of simplicity).

In order to limit approximation errors for large nbits, nbits is divided
into chunks of maximum value pool_size/2 each and said approximation is
applied to these individually in a loop. That loop has a theoretic upper
bound of 2*log2(pool_size), which, with the given pool_size of 128 * 32
bits, equals 24.

However, in practice nbits hardly ever exceeds values as a large as
pool_size/2 == 2048, especially not when called from interrupt context,
i.e. from add_interrupt_randomness() and alike. Thus, imposing a limit of
one single iteration in these contexts would yield a good guarantee with
respect to runtime while not losing any entropy.

In preparation to enabling that, move the approximation code in
credit_entropy_bits() into a separate function, pool_entropy_delta().
Based on the initial pool entropy count and the number of new entropy bits
to credit, it calculates and returns a (positive) delta to add to the
former. In case the 'fast' parameter is set to true, the calculation
will be terminated after the first iteration, effectively capping the input
nbits to one half of the pool size.

There is no functional change; callers with 'fast' set to true will be
introduced in a future patch.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 53 ++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6adac462aa0d..15dd22d74029 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -366,7 +366,7 @@
  * denominated in units of 1/8th bits.
  *
  * 2*(ENTROPY_SHIFT + poolbitshift) must <= 31, or the multiply in
- * credit_entropy_bits() needs to be 64 bits wide.
+ * pool_entropy_delta() needs to be 64 bits wide.
  */
 #define ENTROPY_SHIFT 3
 #define ENTROPY_BITS(r) ((r)->entropy_count >> ENTROPY_SHIFT)
@@ -654,22 +654,24 @@ static void process_random_ready_list(void)
 }
 
 /*
- * Credit the entropy store with n bits of entropy.
- * Use credit_entropy_bits_safe() if the value comes from userspace
- * or otherwise should be checked for extreme values.
+ * Based on the pool's current entropy fill level, specified as
+ * base_entropy_count, and the number of new entropy bits to add,
+ * return the amount of new entropy to credit. If the 'fast'
+ * parameter is set to true, the calculation will be guaranteed to
+ * terminate quickly, but this comes at the expense of capping
+ * nbits to one half of the pool size.
  */
-static void credit_entropy_bits(struct entropy_store *r, int nbits)
+static unsigned int pool_entropy_delta(struct entropy_store *r,
+				       int base_entropy_count,
+				       int nbits, bool fast)
 {
-	int entropy_count, orig;
 	const int pool_size = r->poolinfo->poolfracbits;
+	int entropy_count = base_entropy_count;
 	int nfrac = nbits << ENTROPY_SHIFT;
-	int pnfrac;
 
 	if (!nbits)
-		return;
+		return 0;
 
-retry:
-	entropy_count = orig = READ_ONCE(r->entropy_count);
 	/*
 	 * Credit: we have to account for the possibility of
 	 * overwriting already present entropy.	 Even in the
@@ -691,24 +693,43 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 	 * arbitrarily long; this limits the loop to log2(pool_size)*2
 	 * turns no matter how large nbits is.
 	 */
-	pnfrac = nfrac;
 	do {
 		/* The +2 corresponds to the /4 in the denominator */
 		const int s = r->poolinfo->poolbitshift + ENTROPY_SHIFT + 2;
-		unsigned int anfrac = min(pnfrac, pool_size/2);
+		unsigned int anfrac = min(nfrac, pool_size/2);
 		unsigned int add =
 			((pool_size - entropy_count)*anfrac*3) >> s;
 
 		entropy_count += add;
-		pnfrac -= anfrac;
-	} while (unlikely(entropy_count < pool_size-2 && pnfrac));
+		nfrac -= anfrac;
+	} while (unlikely(!fast && entropy_count < pool_size-2 && nfrac));
 
 	if (WARN_ON(entropy_count < 0)) {
 		pr_warn("negative entropy/overflow: pool %s count %d\n",
 			r->name, entropy_count);
-		entropy_count = orig;
-	} else if (entropy_count > pool_size)
+		entropy_count = base_entropy_count;
+	} else if (entropy_count > pool_size) {
 		entropy_count = pool_size;
+	}
+
+	return entropy_count - base_entropy_count;
+}
+
+/*
+ * Credit the entropy store with n bits of entropy.
+ * Use credit_entropy_bits_safe() if the value comes from userspace
+ * or otherwise should be checked for extreme values.
+ */
+static void credit_entropy_bits(struct entropy_store *r, int nbits)
+{
+	int entropy_count, orig;
+
+	if (!nbits)
+		return;
+
+retry:
+	orig = READ_ONCE(r->entropy_count);
+	entropy_count = orig + pool_entropy_delta(r, orig, nbits, false);
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
-- 
2.26.2

