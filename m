Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE057C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 14:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA76761B54
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 14:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhKOOVi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 09:21:38 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:53290 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbhKOOVg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 09:21:36 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6BCE2218A9;
        Mon, 15 Nov 2021 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636985920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5IBbslE/oPZTVzl0ADEJvMszbGx/M29SMnXhxo3GSkY=;
        b=1oqLrfuK3l1C8qlUsWayOd1sNuLRrgq8A8B6ldWRt+hyV+WmhR0Le1swh0OJiaBZ+UdAuk
        TvwJ0eHf+qbq/9SsuFtZFXe5vQsJAI87A3Hn2ppXX6W3L/JTjN6T+39FWcN4qEywlndrtg
        92/8zkbW32eFTCMNxSKfyJ6+y77tH+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636985920;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5IBbslE/oPZTVzl0ADEJvMszbGx/M29SMnXhxo3GSkY=;
        b=1JkmHmUmlRaVcx7G3/yX6URAOakAGfG6uDoQqU8DMiKZp5kKi4mMsOoNa5G2qnKsiaWdHk
        Z+nrLSH2cy8v8ADQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 55EE813476;
        Mon, 15 Nov 2021 14:18:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ch6eE0BskmGNHwAAMHmgww
        (envelope-from <nstange@suse.de>); Mon, 15 Nov 2021 14:18:40 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Torsten Duwe <duwe@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.de>
Subject: [PATCH v2 2/6] crypto: DRBG - track whether DRBG was seeded with !rng_is_initialized()
Date:   Mon, 15 Nov 2021 15:18:05 +0100
Message-Id: <20211115141809.11420-3-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211115141809.11420-1-nstange@suse.de>
References: <20211115141809.11420-1-nstange@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, the DRBG implementation schedules asynchronous works from
random_ready_callbacks for reseeding the DRBG instances with output from
get_random_bytes() once the latter has sufficient entropy available.

However, as the get_random_bytes() initialization state can get queried by
means of rng_is_initialized() now, there is no real need for this
asynchronous reseeding logic anymore and it's better to keep things simple
by doing it synchronously when needed instead, i.e. from drbg_generate()
once rng_is_initialized() has flipped to true.

Of course, for this to work, drbg_generate() would need some means by which
it can tell whether or not rng_is_initialized() has flipped to true since
the last seeding from get_random_bytes(). Or equivalently, whether or not
the last seed from get_random_bytes() has happened when
rng_is_initialized() was still evaluating to false.

As it currently stands, enum drbg_seed_state allows for the representation
of two different DRBG seeding states: DRBG_SEED_STATE_UNSEEDED and
DRBG_SEED_STATE_FULL. The former makes drbg_generate() to invoke a full
reseeding operation involving both, the rather expensive jitterentropy as
well as the get_random_bytes() randomness sources. The DRBG_SEED_STATE_FULL
state on the other hand implies that no reseeding at all is required for a
!->pr DRBG variant.

Introduce the new DRBG_SEED_STATE_PARTIAL state to enum drbg_seed_state for
representing the condition that a DRBG was being seeded when
rng_is_initialized() had still been false. In particular, this new state
implies that
- the given DRBG instance has been fully seeded from the jitterentropy
  source (if enabled)
- and drbg_generate() is supposed to reseed from get_random_bytes()
  *only* once rng_is_initialized() turns to true.

Up to now, the __drbg_seed() helper used to set the given DRBG instance's
->seeded state to constant DRBG_SEED_STATE_FULL. Introduce a new argument
allowing for the specification of the to be written ->seeded value instead.
Make the first of its two callers, drbg_seed(), determine the appropriate
value based on rng_is_initialized(). The remaining caller,
drbg_async_seed(), is known to get invoked only once rng_is_initialized()
is true, hence let it pass constant DRBG_SEED_STATE_FULL for the new
argument to __drbg_seed().

There is no change in behaviour, except for that the pr_devel() in
drbg_generate() would now report "unseeded" for ->pr DRBG instances which
had last been seeded when rng_is_initialized() was still evaluating to
false.

Signed-off-by: Nicolai Stange <nstange@suse.de>
Reviewed-by: Stephan Müller <smueller@chronox.de>
---
 crypto/drbg.c         | 12 ++++++++----
 include/crypto/drbg.h |  1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 6329c70e5bbb..d71c704d0cd2 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1036,14 +1036,14 @@ static const struct drbg_state_ops drbg_hash_ops = {
  ******************************************************************/
 
 static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
-			      int reseed)
+			      int reseed, enum drbg_seed_state new_seed_state)
 {
 	int ret = drbg->d_ops->update(drbg, seed, reseed);
 
 	if (ret)
 		return ret;
 
-	drbg->seeded = DRBG_SEED_STATE_FULL;
+	drbg->seeded = new_seed_state;
 	/* 10.1.1.2 / 10.1.1.3 step 5 */
 	drbg->reseed_ctr = 1;
 
@@ -1093,7 +1093,7 @@ static void drbg_async_seed(struct work_struct *work)
 	 */
 	drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
 
-	__drbg_seed(drbg, &seedlist, true);
+	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
 
 	if (drbg->seeded == DRBG_SEED_STATE_FULL)
 		drbg->reseed_threshold = drbg_max_requests(drbg);
@@ -1123,6 +1123,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
 	struct drbg_string data1;
 	LIST_HEAD(seedlist);
+	enum drbg_seed_state new_seed_state = DRBG_SEED_STATE_FULL;
 
 	/* 9.1 / 9.2 / 9.3.1 step 3 */
 	if (pers && pers->len > (drbg_max_addtl(drbg))) {
@@ -1150,6 +1151,9 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		BUG_ON((entropylen * 2) > sizeof(entropy));
 
 		/* Get seed from in-kernel /dev/urandom */
+		if (!rng_is_initialized())
+			new_seed_state = DRBG_SEED_STATE_PARTIAL;
+
 		ret = drbg_get_random_bytes(drbg, entropy, entropylen);
 		if (ret)
 			goto out;
@@ -1206,7 +1210,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		memset(drbg->C, 0, drbg_statelen(drbg));
 	}
 
-	ret = __drbg_seed(drbg, &seedlist, reseed);
+	ret = __drbg_seed(drbg, &seedlist, reseed, new_seed_state);
 
 out:
 	memzero_explicit(entropy, entropylen * 2);
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 92a87b23ad2f..3ebdb1effe74 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -107,6 +107,7 @@ struct drbg_test_data {
 
 enum drbg_seed_state {
 	DRBG_SEED_STATE_UNSEEDED,
+	DRBG_SEED_STATE_PARTIAL, /* Seeded with !rng_is_initialized() */
 	DRBG_SEED_STATE_FULL,
 };
 
-- 
2.26.2

