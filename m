Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC961C433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B26B161A35
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhJCSRF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Oct 2021 14:17:05 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50842 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhJCSRB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Oct 2021 14:17:01 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7732722188;
        Sun,  3 Oct 2021 18:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633284912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C4It3Crvsgci8LL9uk9/4Ibxe6/puzhSaqOGEO6h/s8=;
        b=py82Nf+CmigVKZ/7tXtyptQnN6/QyQFXbr5+TnsFAopI8L0K4CxqZlyu6h6lOSBwQa8OnO
        y/+NDjgfQMmvXPPMcR+M85uR8it7hHJKifjBcbwYv8dBlVLSHRe1Guhv2rOWaDgO8I1U+u
        HYAb+06ExUPObO7+iiH7qmeT+D2fZuI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633284912;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C4It3Crvsgci8LL9uk9/4Ibxe6/puzhSaqOGEO6h/s8=;
        b=MPqTk80oaHSZYBrL7XGcgmQ0Y0tXtrMcKCyxT6cmA1B5C2zVqj1DmF7uXdzQUOXZ9wrSnc
        XlR360KtHnULIjDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6362D13A09;
        Sun,  3 Oct 2021 18:15:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tmjYFjDzWWG1EwAAMHmgww
        (envelope-from <nstange@suse.de>); Sun, 03 Oct 2021 18:15:12 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Nicolai Stange <nstange@suse.de>
Subject: [PATCH 4/8] crypto: api - don't add larvals for !(type & CRYPTO_ALG_TESTED) lookups
Date:   Sun,  3 Oct 2021 20:14:09 +0200
Message-Id: <20211003181413.12465-5-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211003181413.12465-1-nstange@suse.de>
References: <20211003181413.12465-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As of now, the only valid (and existent) usecase for requesting an
algorithm with !(type & CRYPTO_ALG_TESTED) and (mask & CRYPTO_ALG_TESTED)
via crypto_alg_mod_lookup() is the testmgr invoked upon a
CRYPTO_MSG_ALG_REGISTER notification.

However, in this case it is expected and required that the lookup returns
the actual crypto_alg instance subject to testing.

If OTOH we were to assume for a moment that the crypto_larval_lookup()
called from crypto_alg_mod_lookup() would allocate and return a lookup
larval (which cannot happen, except for perhaps in some corner case like
with concurrent crypto_alg unregistrations), the subsequent wait in
crypto_alg_mod_lookup() would timeout anyway.

Make crypto_larval_wait() skip the lookup larval allocation if the
specified values of mask and type indicate a lookup request for some
crypto_alg instance still not in CRYPTO_ALG_TESTED state and the search for
such one failed. Instead, fail the call with -ENOENT in this case.

This reduces the number of possible ->mask and ->type configurations with
respect to CRYPTO_ALG_TESTED for pending lookup larvals and will enable
further cleanup with subsequent patches.

There is no change in functionality.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 crypto/api.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 5cced204b6b4..3bee52d7fe4b 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -283,8 +283,22 @@ static struct crypto_alg *crypto_larval_lookup(const char *name, u32 type,
 
 	if (!IS_ERR_OR_NULL(alg) && crypto_is_larval(alg))
 		alg = crypto_larval_wait(alg);
-	else if (!alg)
-		alg = crypto_larval_add(name, type, mask);
+	else if (!alg) {
+		/*
+		 * Only add a lookup larval if the request is for a
+		 * tested algorithm, everything else makes no sense.
+		 */
+		bool tested = type & mask & CRYPTO_ALG_TESTED;
+
+		if (!(mask & CRYPTO_ALG_TESTED)) {
+			WARN_ON_ONCE((type & CRYPTO_ALG_TESTED));
+			tested = true;
+		}
+		if (tested)
+			alg = crypto_larval_add(name, type, mask);
+		else
+			alg = ERR_PTR(-ENOENT);
+	}
 
 	return alg;
 }
-- 
2.26.2

