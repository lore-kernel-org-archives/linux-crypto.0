Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE08C2BB9A
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12AD22255F
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502859AbgLNUDu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502869AbgLNUDn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 15:03:43 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507A6C06179C
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:03:03 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id w16so13356146pga.9
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BdxMVC3y5nlR7LDMxIQSz3qWj9jrWm9Nsf2wISBO6pc=;
        b=LFVHg2rNbEt02LLPnkWOohGk8VIhywesyIxgHiqAVoru6cI75unOmiStz32cZ6y+5B
         GL+mJ6YH7mTcGxudEG3o5arOqjNvAQrUwRWzSPqM3W3iJv9O34xi9vG3w41FH5zMUvN1
         3ADDsOv8n7jI+sQAcZBmLufNtQsEwc1/LoOT/1hVCz/kru0CHAKgtKnTGlmeHskONmo+
         CEAoXXJ3X+2jP2fcKovBAXjO4XiHWndTM5VjpJcyjYGp+eqkdDH2c+691UZpMUAAERWu
         8ScMA0Hp3TEsajRGKrtzklh2DM7t/Vu5rGcrKy+t2aRigykj3BF+P0iSSeHgZ4TQ6FQ/
         93bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BdxMVC3y5nlR7LDMxIQSz3qWj9jrWm9Nsf2wISBO6pc=;
        b=O6OB0867OqHROFNp9Wr6b8CUesr9nkp1Ipd1AWqzzIrC3wBti+hkAtYu2YXJclEFVS
         Wj8UDaGW5L+fFTBq93aRSReRmjDpU7/VPUwn72AolyQZUNjXUGkBSgVIJv07oOWgjiHu
         ootlqpQe9LLqo/cfZzfcegYe06izpuV2yJ1yZVsdtzNDh1beDxnq5WTmZXtcn4BQi3v6
         jVqNj1oWqVi0/f2QZAw9PgL8dpKao9Lsws8KSNPf6UZ9YyCXLxkfCX2BDdVuslRedWhO
         mvJTdlXxu9tiZ5hVRgJosXDUtMlACwzDEYKTfNNoBHRxFe02F1fRMXBxKdP/RANBGkXJ
         8iNA==
X-Gm-Message-State: AOAM5312NcqE6iB5q864aGuZ7kX1h16N2FcopjQ/Un5dZiXnDqyCOUe+
        RdNPV4Yobp+RDOzZpXsaWPKsiw==
X-Google-Smtp-Source: ABdhPJzKh8HJaK54TRvEM5Wt0CA7yuq8pZy4BPn2IMdwD95gbsiCsgLgHhwTk/FqSplATiFqAetjqw==
X-Received: by 2002:a63:c04b:: with SMTP id z11mr25034328pgi.74.1607976182932;
        Mon, 14 Dec 2020 12:03:02 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id js9sm22434109pjb.2.2020.12.14.12.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:03:02 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v4 2/8] crypto: sun4i-ss: checking sg length is not sufficient
Date:   Mon, 14 Dec 2020 20:02:26 +0000
Message-Id: <20201214200232.17357-3-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214200232.17357-1-clabbe@baylibre.com>
References: <20201214200232.17357-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The optimized cipher function need length multiple of 4 bytes.
But it get sometimes odd length.
This is due to SG data could be stored with an offset.

So the fix is to check also if the offset is aligned with 4 bytes.
Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index 19f1aa577ed4..f49797588329 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -186,12 +186,12 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	 * we can use the SS optimized function
 	 */
 	while (in_sg && no_chunk == 1) {
-		if (in_sg->length % 4)
+		if ((in_sg->length | in_sg->offset) & 3u)
 			no_chunk = 0;
 		in_sg = sg_next(in_sg);
 	}
 	while (out_sg && no_chunk == 1) {
-		if (out_sg->length % 4)
+		if ((out_sg->length | out_sg->offset) & 3u)
 			no_chunk = 0;
 		out_sg = sg_next(out_sg);
 	}
-- 
2.26.2

