Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CF5C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Oct 2021 09:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ED0E60FD7
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Oct 2021 09:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhJYJ2g (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Oct 2021 05:28:36 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33648 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbhJYJ2R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Oct 2021 05:28:17 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 65B1921916;
        Mon, 25 Oct 2021 09:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635153954; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Vfb3Gtu7ZmdOe0eMqblCdOxevp/gJDSVxLwlSbaQDE=;
        b=Lv4dMTp1FVYdrtLkxGl5AmrH96g6DpJLehYy4GcI176E0jrVp5nzqZSTK7o6kTj449HIB4
        tamLiOQJh38G/28T6rtMhW+z4+0WIUchdsXy/65VZigh5cbb28TDDw7ye1QumsC5KAvmgA
        Mv6cTJNh8nT/1N7tEIAmu67D4bkiJ+0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635153954;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Vfb3Gtu7ZmdOe0eMqblCdOxevp/gJDSVxLwlSbaQDE=;
        b=N2cNn66ujxoWE4wXIXrd3B2swUUOdVOc931fc9JAV+IMdbGZJFwxHL46/1Z2WeQsopZvtl
        f0qxM07V7QmWHBCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 52EEB1377E;
        Mon, 25 Oct 2021 09:25:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id J9rWEiJ4dmHwSQAAMHmgww
        (envelope-from <nstange@suse.de>); Mon, 25 Oct 2021 09:25:54 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Torsten Duwe <duwe@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.de>
Subject: [PATCH 5/6] crypto: DRBG - make drbg_prepare_hrng() handle jent instantiation errors
Date:   Mon, 25 Oct 2021 11:25:24 +0200
Message-Id: <20211025092525.12805-6-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211025092525.12805-1-nstange@suse.de>
References: <20211025092525.12805-1-nstange@suse.de>
MIME-Version: 1.0
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
---
 crypto/drbg.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index d9f7dddfd683..f5947211e0bf 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1518,6 +1518,14 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
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
@@ -1573,14 +1581,6 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
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

