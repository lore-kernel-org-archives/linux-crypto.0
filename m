Return-Path: <SRS0=RIhc=ZC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6420BC17444
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Nov 2019 03:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39C1D21850
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Nov 2019 03:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573355360;
	bh=yJKOytNiRp6mynj2eZgoh5EtBSLaCklidigKKkpoB9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zJVHZqpSg4fHFZE0Ri7yI7gCYVIS99Q9n0jLVzw70HQzRgjKDlmpM6TQIHDWTosLC
	 87r6+n614Np5Pu/z5NxWlPRgj33v+mIYPfLQad0HZWTItlfGDnqctYH/rHkmVrJSj9
	 DQCPCqZoC8psTIe9h0GhOU1pg/OmTS/9KVr/QGvY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfKJDJJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 22:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbfKJCol (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80CC4215EA;
        Sun, 10 Nov 2019 02:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353880;
        bh=yJKOytNiRp6mynj2eZgoh5EtBSLaCklidigKKkpoB9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cf+tH+gv2nFWIFeQ2gkfxethrtLgzwf3NP+10AzIJqiKY1xH4DR17JR9pV5nwNOVo
         yVF+ITGCeyYnZNU5O7KOF2plGwR6f6pdknFlEH2cAdBugWeC0rsDZ18vus1snUHTQ/
         hEowB1HChVgGm7XxHQE4TcjU7oEoeAMpzvgjLo34=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Manszewski <c.manszewski@samsung.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 157/191] crypto: s5p-sss: Fix race in error handling
Date:   Sat,  9 Nov 2019 21:39:39 -0500
Message-Id: <20191110024013.29782-157-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Christoph Manszewski <c.manszewski@samsung.com>

[ Upstream commit 5842cd44786055231b233ed5ed98cdb63ffb7db3 ]

Remove a race condition introduced by error path in functions:
s5p_aes_interrupt and s5p_aes_crypt_start. Setting the busy field of
struct s5p_aes_dev to false made it possible for s5p_tasklet_cb to
change the req field, before s5p_aes_complete was called.

Change the first parameter of s5p_aes_complete to struct
ablkcipher_request. Before spin_unlock, make a copy of the currently
handled request, to ensure s5p_aes_complete function call with the
correct request.

Signed-off-by: Christoph Manszewski <c.manszewski@samsung.com>
Acked-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/s5p-sss.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index faa282074e5aa..9021ad9df0c45 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -475,9 +475,9 @@ static void s5p_sg_done(struct s5p_aes_dev *dev)
 }
 
 /* Calls the completion. Cannot be called with dev->lock hold. */
-static void s5p_aes_complete(struct s5p_aes_dev *dev, int err)
+static void s5p_aes_complete(struct ablkcipher_request *req, int err)
 {
-	dev->req->base.complete(&dev->req->base, err);
+	req->base.complete(&req->base, err);
 }
 
 static void s5p_unset_outdata(struct s5p_aes_dev *dev)
@@ -655,6 +655,7 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
 	struct s5p_aes_dev *dev = platform_get_drvdata(pdev);
+	struct ablkcipher_request *req;
 	int err_dma_tx = 0;
 	int err_dma_rx = 0;
 	int err_dma_hx = 0;
@@ -727,7 +728,7 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 
 		spin_unlock_irqrestore(&dev->lock, flags);
 
-		s5p_aes_complete(dev, 0);
+		s5p_aes_complete(dev->req, 0);
 		/* Device is still busy */
 		tasklet_schedule(&dev->tasklet);
 	} else {
@@ -752,11 +753,12 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 error:
 	s5p_sg_done(dev);
 	dev->busy = false;
+	req = dev->req;
 	if (err_dma_hx == 1)
 		s5p_set_dma_hashdata(dev, dev->hash_sg_iter);
 
 	spin_unlock_irqrestore(&dev->lock, flags);
-	s5p_aes_complete(dev, err);
+	s5p_aes_complete(req, err);
 
 hash_irq_end:
 	/*
@@ -1983,7 +1985,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	s5p_sg_done(dev);
 	dev->busy = false;
 	spin_unlock_irqrestore(&dev->lock, flags);
-	s5p_aes_complete(dev, err);
+	s5p_aes_complete(req, err);
 }
 
 static void s5p_tasklet_cb(unsigned long data)
-- 
2.20.1

