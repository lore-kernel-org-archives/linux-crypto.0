Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD34C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8976561A6E
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhJCSRM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Oct 2021 14:17:12 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50878 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbhJCSRF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Oct 2021 14:17:05 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E52332218C;
        Sun,  3 Oct 2021 18:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633284916; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IXz0rPGeOFNXSRerxqWOPo9hzzsKQyz3winrnMFJ2Rg=;
        b=d0dzHAL81ueM4f/4EVo6rojUNoknlq1KAHTX+3mKf6mo9LWiIoMpdE3dRTZHJYfIitLkpO
        8WdlUZIRcSnzXWsLvmvqNHSGvMoet2lr+CfnPofVt5BafPWofeUTIul80cax2+Zzd1tC7K
        7Zx2/qQFZSDAVz8kY2fEMESjN6Qq7FI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633284916;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IXz0rPGeOFNXSRerxqWOPo9hzzsKQyz3winrnMFJ2Rg=;
        b=ZF5iAmKmWHML9wbWsLFlFS8C7ubFBWOR2izVMaoPBEgHAnxKAi7ebOQAsAIl2cx5H1bQEv
        Bubg3h91CQIEdkDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D048713A09;
        Sun,  3 Oct 2021 18:15:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vnrpMTTzWWHDEwAAMHmgww
        (envelope-from <nstange@suse.de>); Sun, 03 Oct 2021 18:15:16 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Nicolai Stange <nstange@suse.de>
Subject: [PATCH 6/8] crypto: api - make crypto_alg_lookup() consistently check for failed algos
Date:   Sun,  3 Oct 2021 20:14:11 +0200
Message-Id: <20211003181413.12465-7-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211003181413.12465-1-nstange@suse.de>
References: <20211003181413.12465-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For convenience, input parameters to crypto_alg_lookup() where
!(mask & CRYPTO_ALG_TESTED) holds are supposed to be equivalent to those
having CRYPTO_ALG_TESTED set in both type and mask.

However the crypto_alg_lookup() code does not behave equivalently in
these two cases, in particular not in regard to the additional check for
failed algorithms introduced with commit eb02c38f0197 ("crypto: api - Keep
failed instances alive").

That is, if the user had explicitly set CRYPTO_ALG_TESTED in mask, the
additional check for failed algorithms would never get to run.

Make crypto_alg_lookup() behave the same for parameter sets considered
equivalent.

Note that with the current code, the first invocation of
__crypto_alg_lookup() from crypto_alg_lookup() always receives a mask with
CRYPTO_ALG_TESTED being set: either because that flag had been set from the
beginning or because the local variable 'test' has been set to
CRYPTO_ALG_TESTED otherwise. As lookup larvals always have
CRYPTO_ALG_TESTED included in their ->mask by now, the first
__crypto_alg_lookup() is guaranteed to find such lookup larvals. In
particular, the second call of __crypto_alg_lookup(), which used to get
invoked with a mask having CRYPTO_ALG_TESTED clear, is not needed anymore
for matching any existing lookup larvals and, in fact, won't find any. In
this context, also c.f. commit b346e492d712 ("crypto: api - fix finding
algorithm currently being tested").

Moreover, because testing larvals have CRYPTO_ALG_TESTED set in their
->type, the first __crypto_alg_lookup() is and always has been able to
find those, for any suitable initial combination of mask and value.

In summary,
- the second __crypto_alg_lookup() won't ever return a larval by now and
- invoking it with the original values of mask and value, i.e. those
  specified by the user at function entry, is not needed anymore.

As it currently stands, the only purpose of that second
__crypto_alg_lookup() invocation is to check whether all matching
algorithms, if any, have failed their selftests.

This allows  for the elimination of the local 'test' variable and some
minor code simplification in crypto_alg_lookup(). More specifically,
rather than keeping track of whether or not CRYPTO_ALG_TESTED had
initially been set via said local 'test', simply set CRYPTO_ALG_TESTED
in both mask and type at function entry if it had initially been unset in
mask. That is, enforce equivalent behaviour for parameter sets considered
equivalent.

Adapt the if-condition guarding that second __crypto_alg_lookup()
invocation as well as the invocation itself accordingly: the search is to
be conducted only in the common case of the user asking for tested
algorithms and it should watch out for failed algorithms, i.e. those
crypto_alg instances having CRYPTO_ALG_TESTED clear in their ->type.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 crypto/api.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 71406f486c65..b96b65b3d5c7 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -237,18 +237,24 @@ static struct crypto_alg *crypto_alg_lookup(const char *name, u32 type,
 					    u32 mask)
 {
 	struct crypto_alg *alg;
-	u32 test = 0;
 
 	if (!(mask & CRYPTO_ALG_TESTED)) {
 		WARN_ON_ONCE(type & CRYPTO_ALG_TESTED);
-		test |= CRYPTO_ALG_TESTED;
+		mask |= CRYPTO_ALG_TESTED;
+		type |= CRYPTO_ALG_TESTED;
 	}
 
 	down_read(&crypto_alg_sem);
-	alg = __crypto_alg_lookup(name, type | test, mask | test);
-	if (!alg && test) {
+	alg = __crypto_alg_lookup(name, type, mask);
+	if (!alg && (type & CRYPTO_ALG_TESTED)) {
+		/*
+		 * Check whether there's an instance which failed the
+		 * selftests in order to avoid pointless retries.
+		 */
+		type &= ~CRYPTO_ALG_TESTED;
 		alg = __crypto_alg_lookup(name, type, mask);
-		if (alg && !crypto_is_larval(alg)) {
+		WARN_ON_ONCE(alg && crypto_is_larval(alg));
+		if (alg) {
 			/* Test failed */
 			crypto_mod_put(alg);
 			alg = ERR_PTR(-ELIBBAD);
-- 
2.26.2

