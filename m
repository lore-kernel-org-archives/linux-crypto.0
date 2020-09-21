Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A005CC43466
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7961820874
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgIUIBb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:01:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:56980 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgIUH7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C5247B531;
        Mon, 21 Sep 2020 08:00:11 +0000 (UTC)
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
Subject: [RFC PATCH 39/41] random: make the startup tests include muliple APT invocations
Date:   Mon, 21 Sep 2020 09:58:55 +0200
Message-Id: <20200921075857.4424-40-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Given a per-IRQ min-entropy estimate of H, the Adaptive Proportion Tests
(APT) will need to consume at most n = 128/H samples before reaching a
conclusion. The supported values for H are 1, 1/2, 1/4, 1/8, ..., 1/64,
but only 1 and 1/8 are currently being actively used on systems with and
without a high resolution get_cycles() respectively. The corresponding
number of samples consumed by one APT execution are 128, 256, 512, 1024,
2048, 4096 and 8192. Currently, the ->warmup parameter used for controlling
the startup is hardcoded to be initialized to 1024 and the health test
logic won't permit the caller, i.e. add_interrupt_randomness() to dispatch
any entropy to the global balance until that many events have been
processed *and* the first APT has completed, whichever comes later. It
would take roughly eight successful APT invocations for H=1 until the
startup sequence has completed, but for all H <= 1/8, the ->warmup logic is
effectively useless because the first APT would always need to process
>= 1024 samples anyway.

The probabilites of one single APT invocation successfully detecting a
degradation of the per-IRQ min-entopy to H/2 ("power") are as follows for
the different supported H estimates:

   H     n   power
   ---------------
      1  128 64.7%
    1/2  256 79.1%
    1/4  512 81.6%
    1/8 1024 84.0%
   1/16 2048 84.9%
   1/32 4096 86.9%
   1/64 8192 86.4%

Thus, for H=1, the probability that at least one out of those eight APT
invocations will detect a degradation to H/2 is 1 - (1 - 64.7%)^8 = 99.98%,
which is quite good. OTOH, the 84.0% achievable with the single APT
invocation for H = 1/8 is only semi-satisfactory.

Note that as it currently stands, the only point in time where the health
tests can still intervene and keep back low quality noise from
the primary_crng is before the initial seed has happened. Afterwards,
failing continuous health tests would only potentially delay those best
effort reseeds (which is questionable behaviour in itself, as the crng
state's entropy is never reduced in the course of reseeding).

A future patch will enable dynamically switching from the initial H=1 or
1/8 resp. to lower per-IRQ entropy values upon health test failures in
order to keep those systems going where these more or less arbitrary
per-IRQ entropy estimates turn out to be simply wrong. From a paranoia POV,
it is certainly a good idea to run the APT several times in a row during
startup in order to achieve a good statistical power. Extending the warmup
to cover the larger of the 1024 events required by NIST SP800-90B and four
full APT lengths will result in a combined probability of detecting an
entropy degradation to H/2 of >= 99.98% across all supported values of H.
The obvious downside is that the number of IRQ events required for the
initial seed will be qadrupled, at least for H <= 1/8.

Follow this approach. Amend health_test_reset()'s signature by an
additional parameter, event_entropy_shift, and make it set ->warmup to
the larger of 1024 and 4 * 128 / (2^-event_entropy_shift). Adjust all
call sites accordingly.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index bd8c24e433d0..86dd87588b1b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1058,14 +1058,21 @@ health_test_apt(struct health_test *h, unsigned int event_entropy_shift,
 	return health_queue;
 }
 
-static void health_test_reset(struct health_test *h)
+static void health_test_reset(struct health_test *h,
+			      unsigned int event_entropy_shift)
 {
 	/*
-	 * Don't dispatch until at least 1024 events have been
-	 * processed by the continuous health tests as required by
-	 * NIST SP800-90B for the startup tests.
+	 * Let H = 2^-event_entropy_shift equal the estimated per-IRQ
+	 * min-entropy. One APT will consume at most 128 / H samples
+	 * until completion. Run the startup tests for the larger of
+	 * 1024 events as required by NIST or four times the APT
+	 * length. In either case, the combined probability of the
+	 * resulting number of successive APTs to detect a degradation
+	 * of H to H/2 will be >= 99.8%, for any supported value of
+	 * event_entropy_shift.
 	 */
-	h->warmup = 1024;
+	h->warmup = 4 * (128 << event_entropy_shift);
+	h->warmup = max_t(unsigned int, h->warmup, 1024);
 
 	health_apt_reset(h);
 }
@@ -1092,7 +1099,7 @@ health_test_process(struct health_test *h, unsigned int event_entropy_shift,
 		 * (or always been) a constant.
 		 */
 		if (h->warmup)
-			health_test_reset(h);
+			health_test_reset(h, event_entropy_shift);
 		return health_discard;
 	}
 
@@ -1104,7 +1111,7 @@ health_test_process(struct health_test *h, unsigned int event_entropy_shift,
 	apt = health_test_apt(h, event_entropy_shift, sample_delta);
 	if (unlikely(h->warmup) && --h->warmup) {
 		if (apt == health_discard)
-			health_test_reset(h);
+			health_test_reset(h, event_entropy_shift);
 		/*
 		 * Don't allow the caller to dispatch until warmup
 		 * has completed.
@@ -1883,7 +1890,7 @@ static inline void fast_pool_init_accounting(struct fast_pool *f)
 		return;
 
 	f->event_entropy_shift = min_irq_event_entropy_shift();
-	health_test_reset(&f->health);
+	health_test_reset(&f->health, f->event_entropy_shift);
 }
 
 void add_interrupt_randomness(int irq, int irq_flags)
-- 
2.26.2

