Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66F0C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B4BC20BED
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgIUIAy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:00:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:57702 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgIUH7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 591BBB529;
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
Subject: [RFC PATCH 28/41] random: don't award entropy to disk + input events if in FIPS mode
Date:   Mon, 21 Sep 2020 09:58:44 +0200
Message-Id: <20200921075857.4424-29-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

NIST SP800-90C prohibits the use of multiple correlated entropy sources.

Obviously, add_disk_randomness(), add_input_randomness() and
add_interrupt_randomness() are not independent.

Follow the approach taken by Stephan Müller's LRNG patchset ([1]) and don't
award any entropy to the former two if fips_enabled is true.
Note that the entropy loss has already been compensated for by a previous
patch increasing the IRQ event estimate.

The actual entropy accounting from add_disk_randomness() and
add_input_randomness() is implemented in the common add_timer_randomness()
called therefrom.

Make the latter to not dispatch any entropy to the global entropy balance
if fips_enabled is on.

[1] https://lkml.kernel.org/r/5695397.lOV4Wx5bFT@positron.chronox.de

Suggested-by: Stephan Müller <smueller@chronox.de>
Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 8f79e90f2429..680ccc82a436 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1481,12 +1481,24 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 
 	r = &input_pool;
 	spin_lock_irqsave(&r->lock, flags);
-	/*
-	 * delta is now minimum absolute delta.
-	 * Round down by 1 bit on general principles,
-	 * and limit entropy estimate to 12 bits.
-	 */
-	__queue_entropy(r, &q, min_t(int, fls(delta>>1), 11) << ENTROPY_SHIFT);
+	if (!fips_enabled) {
+		unsigned int nfrac;
+
+		/*
+		 * delta is now minimum absolute delta.
+		 * Round down by 1 bit on general principles,
+		 * and limit entropy estimate to 12 bits.
+		 */
+		nfrac = min_t(int, fls(delta>>1), 11) << ENTROPY_SHIFT;
+		__queue_entropy(r, &q, nfrac);
+	} else {
+		/*
+		 * Multiple correlated entropy sources are prohibited
+		 * by NIST SP800-90C. Leave it up to
+		 * add_interrupt_randomness() to contribute any
+		 * entropy.
+		 */
+	}
 	__mix_pool_bytes(r, &sample, sizeof(sample));
 	reseed = __dispatch_queued_entropy_fast(r, &q);
 	spin_unlock_irqrestore(&r->lock, flags);
-- 
2.26.2

