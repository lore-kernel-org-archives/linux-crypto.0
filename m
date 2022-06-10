Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15532C43334
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jun 2022 12:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbiFJMem (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jun 2022 08:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235263AbiFJMel (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jun 2022 08:34:41 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490DF37B7F5
        for <linux-crypto@vger.kernel.org>; Fri, 10 Jun 2022 05:34:39 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c196so23774786pfb.1
        for <linux-crypto@vger.kernel.org>; Fri, 10 Jun 2022 05:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fTnCXFuyCstJMPBhMqFKxxK2N1Yz6X1NLjBKTceklwM=;
        b=vur4KePcrSZwfP7+Gdvgv0bt/L+tZYdakOo7NYRMZrInzrC3kXcg9wHBqc9MWv59Gj
         fi3P0bGnYTLmFOCZOY87UWoPPXuY7QJc+kIO6+6PEhjv/QoGHk5E8Xl1QDeHaoxjM925
         7xHg3+imavV8cUH2qIm005hgrV6avSWy6ajROWVEsYy7wiHGbBStoGiNN9f9L+gfFgpZ
         0hM+Bhq6E/tbkoP6LyawPOMZPovEbkWNCktkNCzVL5E8bPvYCQx+Fa/+mN4cjMn9Ikdx
         ZCD5YqgYZsorAql4dSYI3nUD28lL5b4p/v+pdAwut8e7y3TlwPgakW7CIcLmmASc46Jo
         k8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fTnCXFuyCstJMPBhMqFKxxK2N1Yz6X1NLjBKTceklwM=;
        b=nP/slZJ1bbmunwyGgPYtsxiXRYtSF2uWAaM/e/0IAsuMNGdyEwqVlppyBthLZ7kPeL
         ew1rJGXFFrqmALS0Dv9bHojnctGdNJx7hE7vpHNG1SnWCl4ajDSok/UOjBE378hXFm3c
         2E7xqtAkCPRQG//jFhzcMINftd+mSF5hnCKce/uN/rb++ZR1oJ8Jl1A2c+a/0e4VGihP
         ejptVEo2hZr4z7uIJ9h45NtNGjnKBMun0fUvs1fXBSDeEj0Ck1JRRRYcCxzBHOjjTrWe
         sYYAecpckxMKbklmymZhqy03m9zeY+9xc/SKAa4IOAp06DsIKp0SWdv5ouh5CWe6bwTH
         cx3g==
X-Gm-Message-State: AOAM5319df3mVZmixtXFWoAjUDITntuS+8xig2S3HrrYUzEuKEfbXezU
        Yhxu+oJvHykDc6DvzcFdap7unbkYwOZbcYqZ
X-Google-Smtp-Source: ABdhPJye0lkqFNoSURlpFSaRubFAyvZ7H6pZUjfbwhCtArda1i/1Oz2vnL3TD6wFmZ1x8rh776n3gQ==
X-Received: by 2002:a63:2160:0:b0:3fc:b8ac:1976 with SMTP id s32-20020a632160000000b003fcb8ac1976mr40229774pgm.453.1654864478105;
        Fri, 10 Jun 2022 05:34:38 -0700 (PDT)
Received: from localhost.localdomain ([94.177.118.5])
        by smtp.gmail.com with ESMTPSA id a14-20020a1709027e4e00b0016892555955sm5867860pln.179.2022.06.10.05.34.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Jun 2022 05:34:37 -0700 (PDT)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jean-philippe <jean-philippe@linaro.org>,
        Wangzhou <wangzhou1@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Yang Shen <shenyang39@huawei.com>
Subject: [PATCH] uacce: fix concurrency of fops_open and uacce_remove
Date:   Fri, 10 Jun 2022 20:34:23 +0800
Message-Id: <20220610123423.27496-1-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The uacce parent's module can be removed when uacce is working,
which may cause troubles.

If rmmod/uacce_remove happens just after fops_open: bind_queue,
the uacce_remove can not remove the bound queue since it is not
added to the queue list yet, which blocks the uacce_disable_sva.

Change queues_lock area to make sure the bound queue is added to
the list thereby can be searched in uacce_remove.

And uacce->parent->driver is checked immediately in case rmmod is
just happening.

Also the parent driver must always stop DMA before calling
uacce_remove.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/misc/uacce/uacce.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 281c54003edc..b6219c6bfb48 100644
--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -136,9 +136,16 @@ static int uacce_fops_open(struct inode *inode, struct file *filep)
 	if (!q)
 		return -ENOMEM;
 
+	mutex_lock(&uacce->queues_lock);
+
+	if (!uacce->parent->driver) {
+		ret = -ENODEV;
+		goto out_with_lock;
+	}
+
 	ret = uacce_bind_queue(uacce, q);
 	if (ret)
-		goto out_with_mem;
+		goto out_with_lock;
 
 	q->uacce = uacce;
 
@@ -153,7 +160,6 @@ static int uacce_fops_open(struct inode *inode, struct file *filep)
 	uacce->inode = inode;
 	q->state = UACCE_Q_INIT;
 
-	mutex_lock(&uacce->queues_lock);
 	list_add(&q->list, &uacce->queues);
 	mutex_unlock(&uacce->queues_lock);
 
@@ -161,7 +167,8 @@ static int uacce_fops_open(struct inode *inode, struct file *filep)
 
 out_with_bond:
 	uacce_unbind_queue(q);
-out_with_mem:
+out_with_lock:
+	mutex_unlock(&uacce->queues_lock);
 	kfree(q);
 	return ret;
 }
@@ -171,10 +178,10 @@ static int uacce_fops_release(struct inode *inode, struct file *filep)
 	struct uacce_queue *q = filep->private_data;
 
 	mutex_lock(&q->uacce->queues_lock);
-	list_del(&q->list);
-	mutex_unlock(&q->uacce->queues_lock);
 	uacce_put_queue(q);
 	uacce_unbind_queue(q);
+	list_del(&q->list);
+	mutex_unlock(&q->uacce->queues_lock);
 	kfree(q);
 
 	return 0;
@@ -513,10 +520,10 @@ void uacce_remove(struct uacce_device *uacce)
 		uacce_put_queue(q);
 		uacce_unbind_queue(q);
 	}
-	mutex_unlock(&uacce->queues_lock);
 
 	/* disable sva now since no opened queues */
 	uacce_disable_sva(uacce);
+	mutex_unlock(&uacce->queues_lock);
 
 	if (uacce->cdev)
 		cdev_device_del(uacce->cdev, &uacce->dev);
-- 
2.36.1

