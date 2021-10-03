Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AF2C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A4C461A58
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhJCSR0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Oct 2021 14:17:26 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50896 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbhJCSRJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Oct 2021 14:17:09 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 987AC22188;
        Sun,  3 Oct 2021 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633284920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QHjcDVVUouu29tsx4dLsP3winaBc90JSA/WlZXQce5w=;
        b=1+uekvGTjlw4cXArRNyEBNDOOk2NC8ve/KZ6ptteCneb3/sUzVuPQI3VAfa1HhsCch9th2
        7uws+R2eSzdHsq/NJ0EUNK02w9KNsR1yo7yDrd+CASLgEwEDDcxrVEuNCRtyBHAWpcRCWb
        MUNS4rHQ5Jy1Es3I9RoWxdJFaMq8wHs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633284920;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QHjcDVVUouu29tsx4dLsP3winaBc90JSA/WlZXQce5w=;
        b=2/V2yKc5PcrHcHKPkdESkTbJuk7SAeBCvzcH4gLK9c9/Erke+PieJDKpU0JJv4+V6Jn+Fy
        ZoiljKS5I/eD3CCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8203313A09;
        Sun,  3 Oct 2021 18:15:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xHjaHjjzWWHPEwAAMHmgww
        (envelope-from <nstange@suse.de>); Sun, 03 Oct 2021 18:15:20 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Nicolai Stange <nstange@suse.de>
Subject: [PATCH 8/8] crypto: api - make the algorithm lookup priorize non-larvals
Date:   Sun,  3 Oct 2021 20:14:13 +0200
Message-Id: <20211003181413.12465-9-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211003181413.12465-1-nstange@suse.de>
References: <20211003181413.12465-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto_alg_mod_lookup() invokes the crypto_larval_lookup() helper
to run the actual search for matching crypto_alg implementation and
larval entries. The latter is currently considering only the individual
entries' relative ->cra_priority for determining which one out of multiple
matches to return. This means that it would potentially dismiss a matching
crypto_alg implementation in working state in favor of some pending
testing larval of higher ->cra_priority. Now, if the testmgr instance
invoked asynchronously on that testing larval came to the conclusion that
it should mark the tests as failed, any pending crypto_alg_mod_lookup()
waiting for it would be made to fail as well with -EAGAIN.

In summary, crypto_alg_mod_lookup() can fail spuriously with -EAGAIN even
though an implementation in working state would have been available, namely
if the testmgr asynchronously marked another, competing implementation of
higher ->cra_priority as failed.

This is normally not a problem at all with upstream, because the situation
where one algorithm passed its tests, but another competing one failed to
do so, would indicate a bug anyway.

However, for downstream distributions seeking FIPS certification, simply
amending the list in crypto/testmgr.c with ->fips_allowed = 0 entries
matching on ->cra_driver_name would provide a convenient way of
selectively blacklisting implementations from drivers/crypto in fips
mode. Note that in this scenario failure of competing crypto_alg
implementations would become more common, in particular during device
enumeration. If the algorithm in question happened to be needed for e.g.
module signature verification, module loading could spuriously fail during
bootup, which is certainly not desired.

For transparency: this has not actually been observed, I merely came to
the conclusion that it would be possible by reading the code.

Make crypto_alg_lookup() run an additional search for non-larval matches
upfront in the common case that the request has been made for
CRYPTO_ALG_TESTED instances.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 crypto/api.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index 594c494a27d9..4251eedef668 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -239,8 +239,25 @@ static struct crypto_alg *crypto_alg_lookup(const char *name, u32 type,
 	struct crypto_alg *alg;
 
 	down_read(&crypto_alg_sem);
+	/*
+	 * If the request is for an algorithm having passed its
+	 * selftests, try to serve it with a matching instance already
+	 * in operational state. That is, skip pending larvals in a
+	 * first search: for these it is not guaranteed that they will
+	 * eventually turn out successful and it would be a pity to
+	 * potentially fail the request even though a working
+	 * implementation would have been available. If OTOH the
+	 * request is *not* for an algorithm having passed its
+	 * selftest (yet), no larval can match it anyway, so the
+	 * CRYPTO_ALG_LARVAL in the mask below won't make a
+	 * difference.
+	 */
+	alg = __crypto_alg_lookup(name, type, mask | CRYPTO_ALG_LARVAL);
+	if (alg || !(type & CRYPTO_ALG_TESTED))
+		goto out;
+
 	alg = __crypto_alg_lookup(name, type, mask);
-	if (!alg && (type & CRYPTO_ALG_TESTED)) {
+	if (!alg) {
 		/*
 		 * Check whether there's an instance which failed the
 		 * selftests in order to avoid pointless retries.
@@ -254,6 +271,8 @@ static struct crypto_alg *crypto_alg_lookup(const char *name, u32 type,
 			alg = ERR_PTR(-ELIBBAD);
 		}
 	}
+
+out:
 	up_read(&crypto_alg_sem);
 
 	return alg;
-- 
2.26.2

