Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8D5C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EEBC238E2
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbhAUEvt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 23:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727317AbhAUEpA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 23:45:00 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7311CC061798;
        Wed, 20 Jan 2021 20:44:14 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id x18so588473pln.6;
        Wed, 20 Jan 2021 20:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gQh2IwNxftbR34HfI9l3nT7vPGQ8lmvW4dX0b9EAc7Y=;
        b=BupZcrXhhNK8Ef6ojLlQM42EwDg3c1oTSVd8H+/oHXiemqGl5WEzw5ar1WiOZx+iC1
         jvVMgDVDYdxjTtfxYu78QrlC0iD6CqYMsHQO14d3u/k/FzKXX6SQP2XOINno1iXJgCld
         4rZ5ayp0ch64tHhDbqoBufiU0rftkrB4lzOgJvHfBiRYnwclH042wfAC1IOVo8or3EvO
         JrX4jA2FS/PZ0Oi6MEceS+MYxaga4gy2lmJSbASRPTx+WtxyunTISoxeVi7oSbv5GNe+
         oHPTQXwPGwEWVuhWPI9AHbUS2BYxMiz7KP0iypNrPDePZi/GniAt/ru7X3bHn5ZdOkwi
         5zVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gQh2IwNxftbR34HfI9l3nT7vPGQ8lmvW4dX0b9EAc7Y=;
        b=um+o6HckUMgmvlRn3y9CUtEGK1KrHOs05ng1CRw+/p6zVhMIVKYprfuM9haWD/U7hA
         TOzxvBYqmHnYDBdoM7kICYXsiwnQxhYt/pvjSomf9ylSojiPs8PvXEb+8eAYvukvVkiq
         K0CuTluJ1/Wn6l5pHboSVxHCOSQj9W+pGygUn0EV2Ot1+8Lu48RbOHsYzrA0uCZBdOhn
         mmhMPmbeFZhBFoXd8LzoHhH33gjLChDyvCT4jIEXQER2y9EQINHvDsomUk2yvZt3OOfU
         XlDEGT3ttDJMT8S84A/yC0JU3G1DGMCuYbPV14vlDY2IUFW/bxB4GzAGd8wwGtFGtYPI
         Od9Q==
X-Gm-Message-State: AOAM531WjaKknG18zP68W4MIqjiGcmpv7lzgcdAcraqrTAj0jBhWl8hi
        zJ0rHAzeDJ+QZnZ1gE8JeAM=
X-Google-Smtp-Source: ABdhPJxihhD7rtz9KUgJnDNb27lJMLl+Qqb3jgEHtXH3KDbu2VD5PkvZTpN9Xi673Iz88wL6BF/1ZA==
X-Received: by 2002:a17:902:a501:b029:dc:3e1d:4ddb with SMTP id s1-20020a170902a501b02900dc3e1d4ddbmr13240061plq.60.1611204254054;
        Wed, 20 Jan 2021 20:44:14 -0800 (PST)
Received: from localhost.localdomain ([49.207.210.174])
        by smtp.gmail.com with ESMTPSA id jx15sm3916014pjb.17.2021.01.20.20.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:44:13 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v4 15/19] crypto: qce: convert tasklets to use new tasklet_setup() API
Date:   Thu, 21 Jan 2021 10:11:22 +0530
Message-Id: <20210121044126.152274-16-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121044126.152274-1-allen.lkml@gmail.com>
References: <20210121044126.152274-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/crypto/qce/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 80b75085c265..374281e9d6b9 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -116,9 +116,9 @@ static int qce_handle_queue(struct qce_device *qce,
 	return ret;
 }
 
-static void qce_tasklet_req_done(unsigned long data)
+static void qce_tasklet_req_done(struct tasklet_struct *t)
 {
-	struct qce_device *qce = (struct qce_device *)data;
+	struct qce_device *qce = from_tasklet(qce, t, done_tasklet);
 	struct crypto_async_request *req;
 	unsigned long flags;
 
@@ -235,8 +235,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 		goto err_clks;
 
 	spin_lock_init(&qce->lock);
-	tasklet_init(&qce->done_tasklet, qce_tasklet_req_done,
-		     (unsigned long)qce);
+	tasklet_setup(&qce->done_tasklet, qce_tasklet_req_done);
 	crypto_init_queue(&qce->queue, QCE_QUEUE_LENGTH);
 
 	qce->async_req_enqueue = qce_async_request_enqueue;
-- 
2.25.1

