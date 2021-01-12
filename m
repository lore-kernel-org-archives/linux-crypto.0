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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 109D7C433E6
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD21522E03
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbhALBuM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729542AbhALBuM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 20:50:12 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDB4C061575;
        Mon, 11 Jan 2021 17:49:31 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id p12so623458pju.5;
        Mon, 11 Jan 2021 17:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gQh2IwNxftbR34HfI9l3nT7vPGQ8lmvW4dX0b9EAc7Y=;
        b=vLF+0YKIHD+wGmKY0SoKMw0rAk9JDQg+HeCpWTOTEn6g1z7DwBlA2q6bHAc5CVXUKZ
         UcFLvngbyhZMclhG8HpkJo8jzPS1dPlFleIhsrlkKFBw/7XEEX4c6UkJoIxbFh71fYdn
         ikp6SJdofZ8MqY7WJQ4to3GVn6DEpl9Z7U7N5uQjzX2IMnbwUZBMBOVv95kMQ7Yd6u+P
         3rjEm8QD0Fx1dPrjo6r20e3wZcDOf3k/0M1M128fGhhHm5fPzSDWow+cLM48vC65S/Jb
         mB9Y7pC+UPbldzDUSc5RKiZSxafKuXD3o3j80jmf6tLzR6tUeU58PSo01Km7fymI6UG1
         N2zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gQh2IwNxftbR34HfI9l3nT7vPGQ8lmvW4dX0b9EAc7Y=;
        b=DYVh0PdzscUM65MSZBKhTB/R/BAHcB8nTZrR0mOWYOYTT41ceoosh4NKuTa8C2D0DV
         woU5JeFQBFHwjOCnyOLw7//r4OusVryhcTHq5YmCzkXkWFoG0V7ASs7PX+ybjMfhWExV
         3pWFrl5zSwjkdwM3QjwPp/zFDFRZ9NUlDtcjL+cjQQjQY0Albg6khP625d8MBhYmF+vL
         g4gfpzeBypM+OPe9juYeuh76KL1tqnb26ro7dKZ2N4aJNbUHi4sHAnCVbaI6jyGqCIBN
         /Mbgy5D4YeTuMqvmBdSJmiwF3O5FP8jtBPYrWuf1beJjQiuketmxpPVqy0pU3DZBc7pO
         1qQg==
X-Gm-Message-State: AOAM5312zOmbjQYHqsSvGcpyfiJ3zfNEVr5N+7WJNHt7o83rYzvSYckc
        YWo/4vVm009Spk1lSGh0xOQ=
X-Google-Smtp-Source: ABdhPJyVBiLzaMU6e2OS0Djecxz6eUuTJelAmDYbc4kyrummQIG5Z07jUvLZwAFcWoD+PGSMTS79zA==
X-Received: by 2002:a17:90b:346:: with SMTP id fh6mr1785782pjb.225.1610416171302;
        Mon, 11 Jan 2021 17:49:31 -0800 (PST)
Received: from localhost.localdomain ([49.207.194.207])
        by smtp.gmail.com with ESMTPSA id 14sm904376pfy.55.2021.01.11.17.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 17:49:30 -0800 (PST)
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
Subject: [PATCH v3 15/19] crypto: qce: convert tasklets to use new tasklet_setup() API
Date:   Tue, 12 Jan 2021 07:16:46 +0530
Message-Id: <20210112014650.10887-16-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112014650.10887-1-allen.lkml@gmail.com>
References: <20210112014650.10887-1-allen.lkml@gmail.com>
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

