Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB07AC43463
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73D0820EDD
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgIUIAO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:00:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:57440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgIUH7Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ECF35B515;
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
Subject: [RFC PATCH 17/41] random: drop credit_entropy_bits() and credit_entropy_bits_safe()
Date:   Mon, 21 Sep 2020 09:58:33 +0200
Message-Id: <20200921075857.4424-18-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

All former call sites of credit_entropy_bits() and
credit_entropy_bits_safe() respectively have been converted to the new
dispatch_queued_entropy() API. Drop the now unused functions.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 29 +----------------------------
 1 file changed, 1 insertion(+), 28 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 03eadefabbca..a49805d0d23c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -533,7 +533,7 @@ static __u32 const twist_table[8] = {
 /*
  * This function adds bytes into the entropy "pool".  It does not
  * update the entropy estimate.  The caller should call
- * credit_entropy_bits if this is appropriate.
+ * queue_entropy()+dispatch_queued_entropy() if this is appropriate.
  *
  * The pool is stirred with a primitive polynomial of the appropriate
  * degree, and then twisted.  We twist by three bits at a time because
@@ -988,33 +988,6 @@ static void discard_queued_entropy(struct entropy_store *r,
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
-/*
- * Credit the entropy store with n bits of entropy.
- * Use credit_entropy_bits_safe() if the value comes from userspace
- * or otherwise should be checked for extreme values.
- */
-static void credit_entropy_bits(struct entropy_store *r, int nbits)
-{
-	struct queued_entropy q = { 0 };
-
-	queue_entropy(r, &q, nbits << ENTROPY_SHIFT);
-	dispatch_queued_entropy(r, &q);
-}
-
-static int credit_entropy_bits_safe(struct entropy_store *r, int nbits)
-{
-	const int nbits_max = r->poolinfo->poolwords * 32;
-
-	if (nbits < 0)
-		return -EINVAL;
-
-	/* Cap the value to avoid overflows */
-	nbits = min(nbits,  nbits_max);
-
-	credit_entropy_bits(r, nbits);
-	return 0;
-}
-
 /*********************************************************************
  *
  * CRNG using CHACHA20
-- 
2.26.2

