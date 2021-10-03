Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92F9C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B26BA61A0C
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhJCSRQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Oct 2021 14:17:16 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:38432 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbhJCSRH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Oct 2021 14:17:07 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A6F961FFB6;
        Sun,  3 Oct 2021 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633284918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1SyehLyUF0k4CXVaaOscaGHRcLN40Oiw8DIwqmaEfZk=;
        b=N0R4Izri/hZyt0I25gbBFPKSsrkipJloNSHydGQJ2cPbz1owODQkq7pmo2FUS1JfcPQRz0
        e/aEf3LY2LqHATq54O9+XH0/TIvFv0YSIa5rdih/SlzQXQC0l6D9/0U+YS0BLnbTMzQshw
        bf4ao4WpIVDfktVx3Ghp9FWZsqLNtp4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633284918;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1SyehLyUF0k4CXVaaOscaGHRcLN40Oiw8DIwqmaEfZk=;
        b=T11BUxDuyE6HuxzrEg7aPf5kXztCyVf3waTtowb2ns7ARNnrbQ1NtR9AOiq91Jpp8PfQk/
        OGtsuLE8YV/Bz6Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9129613A09;
        Sun,  3 Oct 2021 18:15:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id inMqIjbzWWHHEwAAMHmgww
        (envelope-from <nstange@suse.de>); Sun, 03 Oct 2021 18:15:18 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Nicolai Stange <nstange@suse.de>
Subject: [PATCH 7/8] crypto: api - lift common mask + type adjustment to crypto_larval_lookup()
Date:   Sun,  3 Oct 2021 20:14:12 +0200
Message-Id: <20211003181413.12465-8-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211003181413.12465-1-nstange@suse.de>
References: <20211003181413.12465-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Both crypto_larval_lookup() as well as the crypto_alg_lookup() called
therefrom (and only therefrom) will apply the very same adjustments to
their mask and type parameters if the original mask value is found to not
have CRYPTO_ALG_TESTED set.

There is no point in having the code duplicated, do it once near the entry
of crypto_larval_lookup().

There is no change in behaviour.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 crypto/api.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index b96b65b3d5c7..594c494a27d9 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -238,12 +238,6 @@ static struct crypto_alg *crypto_alg_lookup(const char *name, u32 type,
 {
 	struct crypto_alg *alg;
 
-	if (!(mask & CRYPTO_ALG_TESTED)) {
-		WARN_ON_ONCE(type & CRYPTO_ALG_TESTED);
-		mask |= CRYPTO_ALG_TESTED;
-		type |= CRYPTO_ALG_TESTED;
-	}
-
 	down_read(&crypto_alg_sem);
 	alg = __crypto_alg_lookup(name, type, mask);
 	if (!alg && (type & CRYPTO_ALG_TESTED)) {
@@ -276,6 +270,12 @@ static struct crypto_alg *crypto_larval_lookup(const char *name, u32 type,
 	type &= ~(CRYPTO_ALG_LARVAL | CRYPTO_ALG_DEAD);
 	mask &= ~(CRYPTO_ALG_LARVAL | CRYPTO_ALG_DEAD);
 
+	if (!(mask & CRYPTO_ALG_TESTED)) {
+		WARN_ON_ONCE(type & CRYPTO_ALG_TESTED);
+		mask |= CRYPTO_ALG_TESTED;
+		type |= CRYPTO_ALG_TESTED;
+	}
+
 	alg = crypto_alg_lookup(name, type, mask);
 	if (!alg && !(mask & CRYPTO_NOLOAD)) {
 		request_module("crypto-%s", name);
@@ -290,12 +290,6 @@ static struct crypto_alg *crypto_larval_lookup(const char *name, u32 type,
 	if (!IS_ERR_OR_NULL(alg) && crypto_is_larval(alg))
 		alg = crypto_larval_wait(alg);
 	else if (!alg) {
-		if (!(mask & CRYPTO_ALG_TESTED)) {
-			WARN_ON_ONCE((type & CRYPTO_ALG_TESTED));
-			mask |= CRYPTO_ALG_TESTED;
-			type |= CRYPTO_ALG_TESTED;
-		}
-
 		/*
 		 * Only add a lookup larval if the request is for a
 		 * tested algorithm, everything else makes no sense.
-- 
2.26.2

