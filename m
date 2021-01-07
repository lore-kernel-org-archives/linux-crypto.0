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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA27C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B4C823359
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbhAGMcU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbhAGMcU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:32:20 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2015FC0612F5;
        Thu,  7 Jan 2021 04:31:40 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id n25so4755469pgb.0;
        Thu, 07 Jan 2021 04:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gQh2IwNxftbR34HfI9l3nT7vPGQ8lmvW4dX0b9EAc7Y=;
        b=dGL5mWBcvHj+vnm8AjPqTntimPrEpTab2oHNsQsqlAP4yzhRCgol10ddlQIvkn9d82
         MLJ0MLh7mDWgvRyIEPRVqdGXqg7s9ab3x42Fsln6gs+5WzcEecWA6SVU8egl/Fb2FKtK
         sZgzq5Dvj7PqobU9umm8h3OyP0xgxLanlAv4AbOpuarLKRGZshQtqEJWHWPQKNeQF/o6
         w7D2oDO2FZrhKFjEgJP/vrw/Rtvr3F0Tpd0nty03wEGe9bmOK3jWo5pFcuiWAlMDsRco
         vmlzTBAnx4s/Krb3Di3bXmQ+yBl+I7KYs9ytlPK4k0aGmu3GCSerCTNwmgEFjr9h8Woz
         66Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gQh2IwNxftbR34HfI9l3nT7vPGQ8lmvW4dX0b9EAc7Y=;
        b=bO/cGlfw7ol8qBteGshaNt+W64EfnjVIguGExs0qy2MDThjk8bW50Xs08RkZW1W4Sh
         aHWEu2JQwZyO7mhPt2KKj7zAkcS98KfewlRtdIT0CmgPRL/ZkOgD1gDL065KJ2e6MP1G
         RjYi3Z8tB+8d5ftKmHdzxqW7txR6lMAaGhdgovZ59SolsjDzf7gXdddOK6aioXtIYogY
         jm0CQLtWfuYd+SBdvCGLfagsHPPR3P8i/me56UUFKCPDJUoPOJV0dno35xzqttkDDvWC
         DOEhVfXvI3ayZ4C5y8GpGIEyNtyefmoeISSIVTYgIKEDFvtgWaZH3/Cy95b5A92xaSay
         EyqQ==
X-Gm-Message-State: AOAM530I1961IKae+Ze2/4Zu6YJ+c+TCKtWxyrXNfR9HM330+E8J2102
        H+wRTn4BUhldq8zE/Ul7nNhLPrS24N0=
X-Google-Smtp-Source: ABdhPJz2CQX6v8/ZMQe6yTXb9e0CjOlBzYMMgjcHw7ulFh1JTqqcMFPoU5EF0ZbAkB/+YlsC8YdOFA==
X-Received: by 2002:a62:874a:0:b029:19e:6e03:cfc3 with SMTP id i71-20020a62874a0000b029019e6e03cfc3mr8250704pfe.67.1610022699768;
        Thu, 07 Jan 2021 04:31:39 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.201])
        by smtp.gmail.com with ESMTPSA id h12sm6356014pgk.70.2021.01.07.04.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 04:31:39 -0800 (PST)
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
Subject: [PATCH v2 15/19] crypto: qce: convert tasklets to use new tasklet_setup() API
Date:   Thu,  7 Jan 2021 17:59:40 +0530
Message-Id: <20210107122944.16363-12-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107122944.16363-1-allen.lkml@gmail.com>
References: <20210107122944.16363-1-allen.lkml@gmail.com>
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

