Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6054CC64E7C
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 13:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A45422280
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 13:55:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="iblwlVcd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbgKPNyv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Nov 2020 08:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729825AbgKPNyt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Nov 2020 08:54:49 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D2CC0613D1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2020 05:54:47 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id v12so14160075pfm.13
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2020 05:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LA6HiyjtrQWg93rXzUxCKFCbWr20SEsMu/GK7GDnTM4=;
        b=iblwlVcd2lUD/gwKL5jWgNtBU8xtXkfkke8Of+1dHqmGyy37nax0rkrq4lAXptvJVb
         AXqrTry0jNdofQ+ymr26F5xvtaGj2ALrfbMCnUWvEynp27GBSifY99vEi2dweI6enESU
         vy36OwiE+cI6m+WwQAamyl1AOUTuLz4liMHynQe16YSSqU+JdC4W2cKigHXBhsY+lJfD
         df9hu4J1U6K00TDaQluTa930RJUmRhNzpxugl2rmno4CG3ZBTDMbYQWTfAJdDl9Vm86E
         zQDaMD03Wj8qHlYlgW3jmyS7s2L/bHD9blRaKnd4GVwAh71hLJPRRdAdhXjqbvQRg633
         0j2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LA6HiyjtrQWg93rXzUxCKFCbWr20SEsMu/GK7GDnTM4=;
        b=tWlx6+1E7/IypBCOUn0ZEa5tqMJG/hucMP84Kn7rOfoPra1W4QeHUDUYR/g8Pd7Nrr
         IJCbtns2TlOi2c7ZNeslhTFo5GP1mbE0o0xE4cCju4IX3hqH9SUF51OTQA3CcSYO2goI
         /MD1sqz9NProMW1Dq0Vc7dMEW7OQaldi3D35EL16C/8vwDHj1hh/0Y0UrXZJLk831q0q
         6ELlqaoY12cX0v+1+87lG/iG5j2bys68jYMOSdDA0UfjPsYoegPct0LCFAbfroNfAki5
         MRmpRaPa5sJ02hVxtwyA/vIJ+BBmJxnCO5uZzU5BXn4p7MjnmvKi9g3HdGmCRkmtM10m
         naJg==
X-Gm-Message-State: AOAM531WLCwUlCK+dxrBnJddHsDZ7rCiFM77OgGwdC9MKU04Ka7N+cO6
        nArhuIIqpweC7Z9INX2+lFAuLA==
X-Google-Smtp-Source: ABdhPJxtV8S3t14TtRMP1LjRfXosxCQyIdl5lzyfHOzvv6zyR1P0pO6Y21nlXDj/H4LetTS7oza29Q==
X-Received: by 2002:a17:90b:4c0b:: with SMTP id na11mr3329213pjb.0.1605534887618;
        Mon, 16 Nov 2020 05:54:47 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id u22sm15864031pgf.24.2020.11.16.05.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 05:54:47 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v3 5/7] crypto: sun4i-ss: initialize need_fallback
Date:   Mon, 16 Nov 2020 13:53:43 +0000
Message-Id: <20201116135345.11834-6-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201116135345.11834-1-clabbe@baylibre.com>
References: <20201116135345.11834-1-clabbe@baylibre.com>
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
index 8f4621826330..7f4c97cc9627 100644
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

