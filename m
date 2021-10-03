Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79616C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 605BC61A35
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhJCSRG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Oct 2021 14:17:06 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50862 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbhJCSRC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Oct 2021 14:17:02 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F31972218D;
        Sun,  3 Oct 2021 18:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633284913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qhv2+vYlcI291SP2REKJE8w2xNUeOIz7+A3x97DTCJ8=;
        b=td0yrrgpOvz6tM0QZn3YFHnrLbs6qJ2M8KFDQd/VKgdWUEWdOZA/5e41flNFwaBikLVAZS
        t4XAoFGMSP/RtIjO0CcrQikrI6I5CkyPIW+sGbN24cluXLqtcpMF6u8oUCQE26oGvmzXKh
        ROvQ/7bGTn1Cphj4bxHAISPxYV4AaMY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633284914;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qhv2+vYlcI291SP2REKJE8w2xNUeOIz7+A3x97DTCJ8=;
        b=YPu2vygvSsTSZTbpGkXqme/+693hKeqiN58BdjVv/IXfp7mgH4L1e2AurnlpSBx+HVRQm5
        8G0NEqvyJpxxZvBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DE87913A09;
        Sun,  3 Oct 2021 18:15:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HSXKNDHzWWG7EwAAMHmgww
        (envelope-from <nstange@suse.de>); Sun, 03 Oct 2021 18:15:13 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Nicolai Stange <nstange@suse.de>
Subject: [PATCH 5/8] crypto: api - always set CRYPTO_ALG_TESTED in lookup larvals' ->mask/type
Date:   Sun,  3 Oct 2021 20:14:10 +0200
Message-Id: <20211003181413.12465-6-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211003181413.12465-1-nstange@suse.de>
References: <20211003181413.12465-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For crypto_alg_lookup(), the input parameter combination of mask and type
where both have CRYPTO_ALG_TESTED unset is special in that it is supposed
to be handled as if said flag had been set in both for convenience.

However, the code in crypto_alg_lookup() is not equivalent between these
two cases:
- If CRYPTO_ALG_TESTED is unset in both type and mask, a pending
  lookup larval with or without ->CRYPTO_ALG_TESTED being set in its
  ->mask and ->type can potentially get returned, whereas if
  CRYPTO_ALG_TESTED is set in both, only the former is possible.
- If CRYPTO_ALG_TESTED is unset in both type and mask, an error would get
  returned if there was one or more matching algorithms which all had
  failed their selftests. If OTOH CRYPTO_ALG_TESTED had been set in both
  type and mask, NULL would get returned in this case of universal failure
  and the caller would proceed to re-request the algorithm in question,
  which is not desired.

Even though the first issue is only a cosmetic one and does not affect
functionality in any way AFAICT, addressing it with this patch here will
improve consistency and allow for streamlining crypto_alg_lookup() a bit
later in this series. The second item in the list from above will be left
to a later patch.

Remember that crypto_larval_lookup() will only invoke crypto_larval_add()
if CRYPTO_ALG_TESTED has been set in either none or both of mask and type.
Make crypto_larval_lookup() always set CRYPTO_ALG_TESTED for the mask
and type values passed to crypto_larval_add(). That is, the "issue"
described above is being addressed by sticking to a canonical lookup larval
representation for the two equivalent cases.

There is no change in functionality.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 crypto/api.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 3bee52d7fe4b..71406f486c65 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -284,17 +284,17 @@ static struct crypto_alg *crypto_larval_lookup(const char *name, u32 type,
 	if (!IS_ERR_OR_NULL(alg) && crypto_is_larval(alg))
 		alg = crypto_larval_wait(alg);
 	else if (!alg) {
+		if (!(mask & CRYPTO_ALG_TESTED)) {
+			WARN_ON_ONCE((type & CRYPTO_ALG_TESTED));
+			mask |= CRYPTO_ALG_TESTED;
+			type |= CRYPTO_ALG_TESTED;
+		}
+
 		/*
 		 * Only add a lookup larval if the request is for a
 		 * tested algorithm, everything else makes no sense.
 		 */
-		bool tested = type & mask & CRYPTO_ALG_TESTED;
-
-		if (!(mask & CRYPTO_ALG_TESTED)) {
-			WARN_ON_ONCE((type & CRYPTO_ALG_TESTED));
-			tested = true;
-		}
-		if (tested)
+		if (type & CRYPTO_ALG_TESTED)
 			alg = crypto_larval_add(name, type, mask);
 		else
 			alg = ERR_PTR(-ENOENT);
-- 
2.26.2

