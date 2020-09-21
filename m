Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBD1C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5FEF20874
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgIUH7v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:59:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:57702 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbgIUH71 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BB3A9B51A;
        Mon, 21 Sep 2020 08:00:00 +0000 (UTC)
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
Subject: [RFC PATCH 20/41] random: provide min_crng_reseed_pool_entropy()
Date:   Mon, 21 Sep 2020 09:58:36 +0200
Message-Id: <20200921075857.4424-21-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, the current minimum entropy required from the input_pool for
reseeding the primary_crng() is 16 bytes == 128 bits. A future patch will
introduce support for obtaining up to a certain fraction thereof from the
architecture's RNG, if available.

This will effectively lower the minimum input_pool ->entropy_count required
for a successful reseed of the primary_crng.

As this value is used at a couple of places, namely crng_reseed() itself
as well as dispatch_queued_entropy() and __dispatch_queued_entropy_fast(),
introduce min_crng_reseed_pool_entropy() to ensure consistency among
these.

min_crng_reseed_pool_entropy() returns the minimum amount of entropy in
bytes required from the input_pool for a successful reseed of the
primary_crng. Currently it's hardcoded to 16.

Use it in place of the hardcoded constants in crng_reseed(),
dispatch_queued_entropy() and __dispatch_queued_entropy_fast().

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/char/random.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1945249597e0..424de1565927 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -516,6 +516,8 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
 				size_t nbytes, int fips);
 
+static int min_crng_reseed_pool_entropy(void);
+
 static void crng_reseed(struct crng_state *crng, struct entropy_store *r);
 static __u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
 
@@ -916,7 +918,7 @@ static bool __dispatch_queued_entropy_fast(struct entropy_store *r,
 	if (unlikely(r == &input_pool && crng_init < 2)) {
 		const int entropy_bits = entropy_count >> ENTROPY_SHIFT;
 
-		return (entropy_bits >= 128);
+		return (entropy_bits >= min_crng_reseed_pool_entropy() * 8);
 	}
 
 	return false;
@@ -965,7 +967,7 @@ static void dispatch_queued_entropy(struct entropy_store *r,
 		if (crng_init < 2) {
 			const int entropy_bits = entropy_count >> ENTROPY_SHIFT;
 
-			if (entropy_bits < 128)
+			if (entropy_bits < min_crng_reseed_pool_entropy() * 8)
 				return;
 			crng_reseed(&primary_crng, r);
 		}
@@ -1182,6 +1184,15 @@ static int crng_slow_load(const char *cp, size_t len)
 	return 1;
 }
 
+/*
+ * Minimum amount of entropy in bytes required from the input_pool for
+ * a successful reseed of the primary_crng.
+ */
+static int min_crng_reseed_pool_entropy(void)
+{
+	return 16;
+}
+
 static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 {
 	unsigned long	flags;
@@ -1192,7 +1203,8 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 	} buf;
 
 	if (r) {
-		num = extract_entropy(r, &buf, 32, 16);
+		num = extract_entropy(r, &buf, 32,
+				      min_crng_reseed_pool_entropy());
 		if (num == 0)
 			return;
 	} else {
-- 
2.26.2

