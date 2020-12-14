Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51885C2BB40
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1401B207A0
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503006AbgLNUEk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503000AbgLNUEb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 15:04:31 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9095C0611CB
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:03:23 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id 4so9381493plk.5
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=id/Q5ao6THistubUC4V3inH2fBZpq87NgTKXp27iujY=;
        b=Ah7IwggI4z9FHB9YbqLDpj0nCp9uUjVuQkXErTXTYqynlfQmuvYA/CfhxB8gw6N9BC
         HG67Iq68JFApt8mGenms10a8fNTb5JsuoWXEtogvyqPdZP7FmFkB9ljRwdL4NRpuwzjG
         M0Bpfdrwg3x31h+drs15tcIqwfjErlthCxte5M7XGlRzs02sCnVvcLOYKhedn8YGB0vE
         KzlYatfyyvZVCZ2VOypXNWPdCmSDNoTSDYLhI4cHDorUzuAOrqbFJmx8qb3mUHU+ghLD
         TmzGTf1nHnES3uxiI8qn3B6pkHyELmsBOf6IK5Dn/JaVIaOYWJgIKwlIQRx/g61ecqAx
         ME3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=id/Q5ao6THistubUC4V3inH2fBZpq87NgTKXp27iujY=;
        b=PvvT/+eopO+ijYCmTwFm2RapnKIXTw1RNZn77RBVmu9T1Hyg5FbZ2GuEQxOxmvjZ67
         9nJchV5zqavu3J8lvhZuhEusBhlhX2Cbk2Iv6AFci868MVbRbDZHx7ZI494YnzEcazRl
         oeccxamYWEEfQKOzmhlnSjDirqYPsob6tQ5aQc0BsLbQ7Tgnt5SUVkbJ38FVVHWSSJlF
         wEcofEyGrsvzf8kx3Vajc0Rda5vzR5ByOC9zLq4DuWHL8bn+uQ0240EbHoX/ngeMAtkN
         cZPovsrdVCMvryD9A9uXlUlFanmy8AMSFiAiP5rMbImdKdgHKTEe2XwYDV8Cb6h2isjj
         QfUg==
X-Gm-Message-State: AOAM531zXjsReCAXAE7Ms6FhKudJEQDqJNw2zE3RKkr9XgcgHZsJ76+v
        Zj8ZWTSO+UHS7xIs6bmk8TOCUw==
X-Google-Smtp-Source: ABdhPJwqXwB839aTHuuRfA5fv8f6XIPiV7G7EQ2SPaHJbY5OdwVed//y4tVkvbHpfUDXRFHMnDxotg==
X-Received: by 2002:a17:90b:1294:: with SMTP id fw20mr26654548pjb.187.1607976203320;
        Mon, 14 Dec 2020 12:03:23 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id js9sm22434109pjb.2.2020.12.14.12.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:03:22 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v4 5/8] crypto: sun4i-ss: initialize need_fallback
Date:   Mon, 14 Dec 2020 20:02:29 +0000
Message-Id: <20201214200232.17357-6-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214200232.17357-1-clabbe@baylibre.com>
References: <20201214200232.17357-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The need_fallback is never initialized and seem to be always true at runtime.
So all hardware operations are always bypassed.

Fixes: 0ae1f46c55f87 ("crypto: sun4i-ss - fallback when length is not multiple of blocksize")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index e097f4c3e68f..5759fa79f293 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -179,7 +179,7 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int obo = 0;	/* offset in bufo*/
 	unsigned int obl = 0;	/* length of data in bufo */
 	unsigned long flags;
-	bool need_fallback;
+	bool need_fallback = false;
 
 	if (!areq->cryptlen)
 		return 0;
-- 
2.26.2

