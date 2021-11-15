Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F77C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 14:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E60161BD4
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 14:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhKOOWI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 09:22:08 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:53324 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbhKOOVm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 09:21:42 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2E4EC2190B;
        Mon, 15 Nov 2021 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636985926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ELD7ckOBA3FfF0+2VR+R3sIsgiBxhb1ptnJoCXXlug=;
        b=HGbqy5Uco4ZKCsqpoEyp4uRgZ6Zdo06gafYUw7fwd5K+zNfC0Iz4db36kmbTgtB4QnfPp3
        FfMqyA84w+AtFnGtBD9b3MDrHiDuiTUerUY6xa2w2VmrojzA0Yl68RapmViNF7YasvCYuE
        h3NnUT7UPxf4oXVl4wg4NkoIuHaxd1o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636985926;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ELD7ckOBA3FfF0+2VR+R3sIsgiBxhb1ptnJoCXXlug=;
        b=TFlmk34IDgvuvz+3rBdKCBETjRrLbK3OJVtwkMH/Oj39qGaem0mjqnaBqJH/5aaFNrcFHu
        50tks8iSRjMDoEAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 18D3213476;
        Mon, 15 Nov 2021 14:18:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KUthBEZskmGbHwAAMHmgww
        (envelope-from <nstange@suse.de>); Mon, 15 Nov 2021 14:18:46 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Torsten Duwe <duwe@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.de>
Subject: [PATCH v2 5/6] crypto: DRBG - make drbg_prepare_hrng() handle jent instantiation errors
Date:   Mon, 15 Nov 2021 15:18:08 +0100
Message-Id: <20211115141809.11420-6-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211115141809.11420-1-nstange@suse.de>
References: <20211115141809.11420-1-nstange@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that drbg_prepare_hrng() doesn't do anything but to instantiate a
jitterentropy crypto_rng instance, it looks a little odd to have the
related error handling at its only caller, drbg_instantiate().

Move the handling of jitterentropy allocation failures from
drbg_instantiate() close to the allocation itself in drbg_prepare_hrng().

There is no change in behaviour.

Signed-off-by: Nicolai Stange <nstange@suse.de>
Reviewed-by: Stephan Müller <smueller@chronox.de>
---
 crypto/drbg.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 2b03a05a9e99..9f6485962ecc 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1516,6 +1516,14 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
 		return 0;
 
 	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
+	if (IS_ERR(drbg->jent)) {
+		const int err = PTR_ERR(drbg->jent);
+
+		drbg->jent = NULL;
+		if (fips_enabled || err != -ENOENT)
+			return err;
+		pr_info("DRBG: Continuing without Jitter RNG\n");
+	}
 
 	return 0;
 }
@@ -1571,14 +1579,6 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 		if (ret)
 			goto free_everything;
 
-		if (IS_ERR(drbg->jent)) {
-			ret = PTR_ERR(drbg->jent);
-			drbg->jent = NULL;
-			if (fips_enabled || ret != -ENOENT)
-				goto free_everything;
-			pr_info("DRBG: Continuing without Jitter RNG\n");
-		}
-
 		reseed = false;
 	}
 
-- 
2.26.2

