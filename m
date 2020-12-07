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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2BD0C4361B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F8223341
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgLGJBC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgLGJBC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:01:02 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A70DC061A51
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:00:24 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 131so9160937pfb.9
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hl02x8ql2XGF95XIKstR0+VLj5TGwdqR79qBtHrvrJQ=;
        b=PVBEZVERiXtOe7GDNM4swZX2Y6AWjP/R8pT+Rp5j9PHLnL2m1kOSQ98NjSUdAYVu0h
         nsnAM6SKAaxxcMWBhRZyp1dASFMBQfGpAqR2Q69cGboEQshl2mlYOW6V1j3F2XZxK1tM
         wiSQMTIb8n1nYuojfYuUBWLb7MQBgRVtXWUy17cPQNbFEsQaHQJG1berm6bBL+jMecLS
         yLHtVovq3C7/oTatiV5kl/jhRMK9R6Y0N393PLN/e6Sn7eu5gfS2RTI/1+Ik4N80LXBz
         Zm+t+O248Cj+x+ZY++H80AYXSH4J/wgXrG6cCkk5WeiG+R3S5CSZ7sxCvi7m7TcL7tHU
         jrNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hl02x8ql2XGF95XIKstR0+VLj5TGwdqR79qBtHrvrJQ=;
        b=lM4zTLFXz5qKnNC8oKFKWDeXkRJqbb9WybdGJRlTaNZ22u+8cp4gLO0/gqgS4a4Xk2
         iBFfa4vUnv4hDM6Yqs3USoWVyc5zvEEi+C5AsT5yDsVyYW6VK41GnTypOq4JKPJ/4d0i
         IJr55vAaR8SOmXDTQWzxhF9NPkooJWhOz/shlQPtsAZSAA4rfcwgc1CNGeMT9W4hoj00
         o4GPUqHdGgBEsXda8SPMQHpuTAzUZ8Esnbuf6Iz4IBXW/TatQtPyqeZhJ2DI4VI190t+
         Q3KHP4KkT+jeZtOe7cThJ3WsrUVXkzWQWgJ0VmZhR2h/bYuQ3JsdwZcB+pnNLLpQtEYd
         rXYw==
X-Gm-Message-State: AOAM532xjbruDlJLc6tyGtKgDbplcKV6JpbPTsJNA4csYGEpwvJkUm70
        I5EpWdwYUPxqD20Lxix5q3k=
X-Google-Smtp-Source: ABdhPJwzFrdQQVvhHkK5bfWwvpLahJG1logcT+5pTHKLEcZY3C3N8k6fPf0QFDslFhmgcjMybBiRRQ==
X-Received: by 2002:a62:8cd6:0:b029:18b:ad92:503b with SMTP id m205-20020a628cd60000b029018bad92503bmr15037751pfd.77.1607331624096;
        Mon, 07 Dec 2020 01:00:24 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.01.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:00:23 -0800 (PST)
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
Subject: [RESEND 06/19] crypto: ccp: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:18 +0530
Message-Id: <20201207085931.661267-7-allen.lkml@gmail.com>
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
 drivers/crypto/ccp/ccp-dev-v3.c    | 9 ++++-----
 drivers/crypto/ccp/ccp-dev-v5.c    | 9 ++++-----
 drivers/crypto/ccp/ccp-dmaengine.c | 7 +++----
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index 0d5576f6ad21..858566867fa3 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -321,9 +321,9 @@ static void ccp_enable_queue_interrupts(struct ccp_device *ccp)
 	iowrite32(ccp->qim, ccp->io_regs + IRQ_MASK_REG);
 }
 
-static void ccp_irq_bh(unsigned long data)
+static void ccp_irq_bh(struct tasklet_struct *t)
 {
-	struct ccp_device *ccp = (struct ccp_device *)data;
+	struct ccp_device *ccp = from_tasklet(ccp, t, irq_tasklet);
 	struct ccp_cmd_queue *cmd_q;
 	u32 q_int, status;
 	unsigned int i;
@@ -361,7 +361,7 @@ static irqreturn_t ccp_irq_handler(int irq, void *data)
 	if (ccp->use_tasklet)
 		tasklet_schedule(&ccp->irq_tasklet);
 	else
-		ccp_irq_bh((unsigned long)ccp);
+		ccp_irq_bh(&ccp->irq_tasklet);
 
 	return IRQ_HANDLED;
 }
@@ -457,8 +457,7 @@ static int ccp_init(struct ccp_device *ccp)
 
 	/* Initialize the ISR tasklet? */
 	if (ccp->use_tasklet)
-		tasklet_init(&ccp->irq_tasklet, ccp_irq_bh,
-			     (unsigned long)ccp);
+		tasklet_setup(&ccp->irq_tasklet, ccp_irq_bh);
 
 	dev_dbg(dev, "Starting threads...\n");
 	/* Create a kthread for each queue */
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 7838f63bab32..e68b05a3169b 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -733,9 +733,9 @@ static void ccp5_enable_queue_interrupts(struct ccp_device *ccp)
 		iowrite32(SUPPORTED_INTERRUPTS, ccp->cmd_q[i].reg_int_enable);
 }
 
-static void ccp5_irq_bh(unsigned long data)
+static void ccp5_irq_bh(struct tasklet_struct *t)
 {
-	struct ccp_device *ccp = (struct ccp_device *)data;
+	struct ccp_device *ccp = from_tasklet(ccp, t, irq_tasklet);
 	u32 status;
 	unsigned int i;
 
@@ -772,7 +772,7 @@ static irqreturn_t ccp5_irq_handler(int irq, void *data)
 	if (ccp->use_tasklet)
 		tasklet_schedule(&ccp->irq_tasklet);
 	else
-		ccp5_irq_bh((unsigned long)ccp);
+		ccp5_irq_bh(&ccp->irq_tasklet);
 	return IRQ_HANDLED;
 }
 
@@ -894,8 +894,7 @@ static int ccp5_init(struct ccp_device *ccp)
 	}
 	/* Initialize the ISR tasklet */
 	if (ccp->use_tasklet)
-		tasklet_init(&ccp->irq_tasklet, ccp5_irq_bh,
-			     (unsigned long)ccp);
+		tasklet_setup(&ccp->irq_tasklet, ccp5_irq_bh);
 
 	dev_dbg(dev, "Loading LSB map...\n");
 	/* Copy the private LSB mask to the public registers */
diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index 0770a83bf1a5..a85690866b05 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -121,9 +121,9 @@ static void ccp_cleanup_desc_resources(struct ccp_device *ccp,
 	}
 }
 
-static void ccp_do_cleanup(unsigned long data)
+static void ccp_do_cleanup(struct tasklet_struct *t)
 {
-	struct ccp_dma_chan *chan = (struct ccp_dma_chan *)data;
+	struct ccp_dma_chan *chan = from_tasklet(chan, t, cleanup_tasklet);
 	unsigned long flags;
 
 	dev_dbg(chan->ccp->dev, "%s - chan=%s\n", __func__,
@@ -712,8 +712,7 @@ int ccp_dmaengine_register(struct ccp_device *ccp)
 		INIT_LIST_HEAD(&chan->active);
 		INIT_LIST_HEAD(&chan->complete);
 
-		tasklet_init(&chan->cleanup_tasklet, ccp_do_cleanup,
-			     (unsigned long)chan);
+		tasklet_setup(&chan->cleanup_tasklet, ccp_do_cleanup);
 
 		dma_chan->device = dma_dev;
 		dma_cookie_init(dma_chan);
-- 
2.25.1

