Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53996C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36AF861A0A
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhJCSRA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Oct 2021 14:17:00 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50830 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbhJCSQ7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Oct 2021 14:16:59 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 12CD92218C;
        Sun,  3 Oct 2021 18:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633284911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iH2JsL7W0xFKKIPPGaOXY8EOQcn93ljDlGisHT9c2fU=;
        b=LE2B/ax5Jrt6VMxT4z7VrQN2dEWSIOffeumzR30X8ppJhW4Cw6Mq+Bi9TT1qVRIffTzRD8
        5um3UEUWndbhFxKlCBrMXVKBLNHVY3l1g5xFgEI0nWJ0Bp3ZFh4Jx+UlTK0HjdGUjFxY/W
        WJbB/0Saqk8lzDbMQd+asewoViud59Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633284911;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iH2JsL7W0xFKKIPPGaOXY8EOQcn93ljDlGisHT9c2fU=;
        b=r3Nv3qg+c+kaifURTfwv4KCKuNOLXnj3PrQPlusz/HxPetTY2kRD3UibonraDd7raGqFjU
        MHMVBMTxx7H3rVDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F3AC213A09;
        Sun,  3 Oct 2021 18:15:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id f44ZOi7zWWGtEwAAMHmgww
        (envelope-from <nstange@suse.de>); Sun, 03 Oct 2021 18:15:10 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Nicolai Stange <nstange@suse.de>
Subject: [PATCH 3/8] crypto: api - only support lookups for specific CRYPTO_ALG_TESTED status
Date:   Sun,  3 Oct 2021 20:14:08 +0200
Message-Id: <20211003181413.12465-4-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211003181413.12465-1-nstange@suse.de>
References: <20211003181413.12465-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit ff753308d2f7 ("crypto: api - crypto_alg_mod_lookup either tested
or untested") introduced support to crypto_alg_lookup() for
ignoring the CRYPTO_ALG_TESTED status in the search. According to the
patch description, this had been needed at the time for "constructing
givcipher and aead". Callers of crypto_alg_lookup() would enable this
behaviour by the special combination of setting CRYPTO_ALG_TESTED in
type only, but not in mask.

However, the last user invoking this functionality has been gone with
commit 3a01d0ee2b99 ("crypto: skcipher - Remove top-level givcipher
interface"). With the previous two patches making the userspace facing APIs
to validate the mask and type values passed in, the combination of
(type & CRYPTO_ALG_TESTED), but !(mask & CRYPTO_ALG_TESTED) is not
possible in crypto_alg_lookup() anymore.

In preparation for subsequent patches, make this explicit by effectively
applying what is a revert of commit ff753308d2f7 ("crypto: api -
crypto_alg_mod_lookup either tested or untested") and adding a
corresponding WARN_ON_ONCE() to crypto_alg_mod_lookup().

There is no change in behaviour.

Note that it is now guaranteed that the first  __crypto_alg_lookup()
invocation from crypto_alg_mod_lookup() will always have CRYPTO_ALG_TESTED
in the mask passed in, which will be needed for a subsequent patch
enforcing the same for lookup larvals.

Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 crypto/api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index ee5991fe11f8..5cced204b6b4 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -239,8 +239,10 @@ static struct crypto_alg *crypto_alg_lookup(const char *name, u32 type,
 	struct crypto_alg *alg;
 	u32 test = 0;
 
-	if (!((type | mask) & CRYPTO_ALG_TESTED))
+	if (!(mask & CRYPTO_ALG_TESTED)) {
+		WARN_ON_ONCE(type & CRYPTO_ALG_TESTED);
 		test |= CRYPTO_ALG_TESTED;
+	}
 
 	down_read(&crypto_alg_sem);
 	alg = __crypto_alg_lookup(name, type | test, mask | test);
-- 
2.26.2

