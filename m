Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4CEC43468
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B910720BED
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgIUIBH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:01:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:58098 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726577AbgIUH7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 43BD2B52E;
        Mon, 21 Sep 2020 08:00:08 +0000 (UTC)
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
Subject: [RFC PATCH 33/41] random: make health_test_process() maintain the get_cycles() delta
Date:   Mon, 21 Sep 2020 09:58:49 +0200
Message-Id: <20200921075857.4424-34-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The min-entropy estimate has been made for the lower eight bits of the
deltas between cycle counter values from successive IRQ events and thus,
the upcoming health tests should actually be run on these deltas.

Introduce a new field ->previous_sample to struct health_test for storing
the previous get_cycles() value. Make health_test_process() maintain it
and also calculate the delta between the current and the previous value
at this point already in preparation to passing it to the upcoming health
tests. Note that ->previous_sample is deliberately not touched from
health_test_reset() in order to maintain a steady flow of correctly
calculated deltas across health test resets.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index cb6441b96b8e..33f9b7b59f92 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -879,7 +879,9 @@ static void discard_queued_entropy(struct entropy_store *r,
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
-struct health_test {};
+struct health_test {
+	u8 previous_sample;
+};
 
 enum health_result {
 	health_none,
@@ -895,6 +897,16 @@ static enum health_result
 health_test_process(struct health_test *h, unsigned int event_entropy_shift,
 		    u8 sample)
 {
+	u8 sample_delta;
+
+	/*
+	 * The min-entropy estimate has been made for the lower eight
+	 * bits of the deltas between cycle counter values from
+	 * successive IRQ events.
+	 */
+	sample_delta = sample - h->previous_sample;
+	h->previous_sample = sample;
+
 	return health_none;
 }
 
-- 
2.26.2

