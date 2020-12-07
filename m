Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1A7C4361B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CE782333D
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgLGJCJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgLGJCH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:02:07 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DDFC0613D1
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:01:24 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id f9so8578975pfc.11
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KSAoCdQyf0n+bqp1cHBDvxl2KUOc51F/2ZEjX4jvHOA=;
        b=B+bGkccBb1FmrPahytnbZhW/9ccgGXKkJ/W9Ct81ShecGWT7LvG2E/2nFXwUn/GHT6
         ehKdH97gvzHEQ+ClFGTZcPOAYBCeJXVwjgTm4uApffXtktUqD7jlSoeKKZK8YI93ERRe
         qTJmb3b0+BUKgIrJofJ4nmiYbwy904H+fE3mq//7GgFKNFutjZhIh5EhnsnxxHKGzswP
         i272itG1s54SXVUOoYbJkE8GPEgOMYtfiBC3sDIll5J7a9jmPnVFT+sRMs1Z3sABjOmS
         KQ7k1iFeRsc+EKN+dghJr9v1YQOWXzVXehXxlQvdgJM1lBpc98iTSTcy02/uJxyU8ohu
         o2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KSAoCdQyf0n+bqp1cHBDvxl2KUOc51F/2ZEjX4jvHOA=;
        b=Z0feKv8zkLbh2TEG9s0JrkJkVviZ/YWvZJpxap9KDUZFJDBgF8USINVofTI7bg7Ad9
         1vyCGqmCY+D4F6PpSuxmheC1v2LzcXjHRl6Pcq/o39J+8fkX338RdHa43fuevYDpahhI
         KWuij/qjFcuvBwfugJJs+H1Cum4hwBaAfh2RS8tPOhZTU2/jdZIQ6cEqbnd/7tqMMjIW
         i9i/PNAMSv8oWooEQdMb4i6uuUNnY59b5aSyWEsk3tHQBRQidTDcCzA6n9BA9C4dmv+m
         uqEPGj0pz5RPB1NxK8QLXVgmhDvXyhZOBOFoMzF5JMp5KCzmshMTn+KgCp2KmMDKpMcj
         JcYA==
X-Gm-Message-State: AOAM533fRTSSzHEfEPIA1hYeyvXClyM4I6nwjjNaaajknWMGPDT3EFgF
        7BVPU1gHuC324twyQUkPU/w=
X-Google-Smtp-Source: ABdhPJxHCxzuT9Qd65It9W8hO2z1stjNAx3iTCzYAK10xY0x5v50jrjQNVZYNs7hZaBVW4MbPGlhgw==
X-Received: by 2002:aa7:93cf:0:b029:19d:e287:b02b with SMTP id y15-20020aa793cf0000b029019de287b02bmr7097813pff.66.1607331684143;
        Mon, 07 Dec 2020 01:01:24 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.01.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:01:23 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, matthias.bgg@gmail.com,
        heiko@sntech.de, krzk@kernel.org, vz@mleia.com,
        k.konieczny@samsung.com, linux-crypto@vger.kernel.org,
        Allen Pais <apais@microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND 15/19] crypto: qce: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:27 +0530
Message-Id: <20201207085931.661267-16-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207085931.661267-1-allen.lkml@gmail.com>
References: <20201207085931.661267-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@microsoft.com>
---
 drivers/crypto/qce/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index ea616b7259ae..b817c74a281c 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -117,9 +117,9 @@ static int qce_handle_queue(struct qce_device *qce,
 	return ret;
 }
 
-static void qce_tasklet_req_done(unsigned long data)
+static void qce_tasklet_req_done(struct tasklet_struct *t)
 {
-	struct qce_device *qce = (struct qce_device *)data;
+	struct qce_device *qce = from_tasklet(qce, t, done_tasklet);
 	struct crypto_async_request *req;
 	unsigned long flags;
 
@@ -222,8 +222,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 		goto err_clks;
 
 	spin_lock_init(&qce->lock);
-	tasklet_init(&qce->done_tasklet, qce_tasklet_req_done,
-		     (unsigned long)qce);
+	tasklet_setup(&qce->done_tasklet, qce_tasklet_req_done);
 	crypto_init_queue(&qce->queue, QCE_QUEUE_LENGTH);
 
 	qce->async_req_enqueue = qce_async_request_enqueue;
-- 
2.25.1

