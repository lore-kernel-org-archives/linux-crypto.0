Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7A0C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 14:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C774761B5E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 14:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhKOOVj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 09:21:39 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:53316 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbhKOOVi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 09:21:38 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5A025218B5;
        Mon, 15 Nov 2021 14:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636985922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sVl47t53ZfFto04rlocM/MRR9iN2YiroVf3A3A/3Ixc=;
        b=OQTi44+dbWW4iI0X55Xrmi2ezlGXkgGJ9FN+KnHssTlas21HLsBcE+sLl3pZILlIA+w9R2
        CD3WcExbmdQnjEwVigWH8wc9XxlE9gt1uGsjFTPcEZ7d9GPCdA71zLdVNuYpGesBkw2dqj
        yKHMtuOdDsNJzjNz+hWE6S+rYOY+lRk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636985922;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sVl47t53ZfFto04rlocM/MRR9iN2YiroVf3A3A/3Ixc=;
        b=z14cpa6h11A4nu1RdpcvDC1FRaA452JVtHqe3sHhj26iaM+XFl+rqqP6FN78mazU6QSQa+
        ZJWxun4pclHZyaBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4553413476;
        Mon, 15 Nov 2021 14:18:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3KuRD0JskmGTHwAAMHmgww
        (envelope-from <nstange@suse.de>); Mon, 15 Nov 2021 14:18:42 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Torsten Duwe <duwe@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.de>
Subject: [PATCH v2 3/6] crypto: DRBG - move dynamic ->reseed_threshold adjustments to __drbg_seed()
Date:   Mon, 15 Nov 2021 15:18:06 +0100
Message-Id: <20211115141809.11420-4-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211115141809.11420-1-nstange@suse.de>
References: <20211115141809.11420-1-nstange@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since commit 42ea507fae1a ("crypto: drbg - reseed often if seedsource is
degraded"), the maximum seed lifetime represented by ->reseed_threshold
gets temporarily lowered if the get_random_bytes() source cannot provide
sufficient entropy yet, as is common during boot, and restored back to
the original value again once that has changed.

More specifically, if the add_random_ready_callback() invoked from
drbg_prepare_hrng() in the course of DRBG instantiation does not return
-EALREADY, that is, if get_random_bytes() has not been fully initialized
at this point yet, drbg_prepare_hrng() will lower ->reseed_threshold
to a value of 50. The drbg_async_seed() scheduled from said
random_ready_callback will eventually restore the original value.

A future patch will replace the random_ready_callback based notification
mechanism and thus, there will be no add_random_ready_callback() return
value anymore which could get compared to -EALREADY.

However, there's __drbg_seed() which gets invoked in the course of both,
the DRBG instantiation as well as the eventual reseeding from
get_random_bytes() in aforementioned drbg_async_seed(), if any. Moreover,
it knows about the get_random_bytes() initialization state by the time the
seed data had been obtained from it: the new_seed_state argument introduced
with the previous patch would get set to DRBG_SEED_STATE_PARTIAL in case
get_random_bytes() had not been fully initialized yet and to
DRBG_SEED_STATE_FULL otherwise. Thus, __drbg_seed() provides a convenient
alternative for managing that ->reseed_threshold lowering and restoring at
a central place.

Move all ->reseed_threshold adjustment code from drbg_prepare_hrng() and
drbg_async_seed() respectively to __drbg_seed(). Make __drbg_seed()
lower the ->reseed_threshold to 50 in case its new_seed_state argument
equals DRBG_SEED_STATE_PARTIAL and let it restore the original value
otherwise.

There is no change in behaviour.

Signed-off-by: Nicolai Stange <nstange@suse.de>
Reviewed-by: Stephan Müller <smueller@chronox.de>
---
 crypto/drbg.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index d71c704d0cd2..9b233e86a5f0 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1047,6 +1047,27 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 	/* 10.1.1.2 / 10.1.1.3 step 5 */
 	drbg->reseed_ctr = 1;
 
+	switch (drbg->seeded) {
+	case DRBG_SEED_STATE_UNSEEDED:
+		/* Impossible, but handle it to silence compiler warnings. */
+		fallthrough;
+	case DRBG_SEED_STATE_PARTIAL:
+		/*
+		 * Require frequent reseeds until the seed source is
+		 * fully initialized.
+		 */
+		drbg->reseed_threshold = 50;
+		break;
+
+	case DRBG_SEED_STATE_FULL:
+		/*
+		 * Seed source has become fully initialized, frequent
+		 * reseeds no longer required.
+		 */
+		drbg->reseed_threshold = drbg_max_requests(drbg);
+		break;
+	}
+
 	return ret;
 }
 
@@ -1095,9 +1116,6 @@ static void drbg_async_seed(struct work_struct *work)
 
 	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
 
-	if (drbg->seeded == DRBG_SEED_STATE_FULL)
-		drbg->reseed_threshold = drbg_max_requests(drbg);
-
 unlock:
 	mutex_unlock(&drbg->drbg_mutex);
 
@@ -1534,12 +1552,6 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
 		return err;
 	}
 
-	/*
-	 * Require frequent reseeds until the seed source is fully
-	 * initialized.
-	 */
-	drbg->reseed_threshold = 50;
-
 	return err;
 }
 
-- 
2.26.2

