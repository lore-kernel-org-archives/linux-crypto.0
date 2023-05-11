Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D457C77B7F
	for <linux-crypto@archiver.kernel.org>; Thu, 11 May 2023 10:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbjEKKAD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 May 2023 06:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237889AbjEKJ76 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 May 2023 05:59:58 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FB41FF3
        for <linux-crypto@vger.kernel.org>; Thu, 11 May 2023 02:59:57 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-3077d134028so4759606f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 May 2023 02:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683799195; x=1686391195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7gMr5NOPVmuNsZ2AgAQsBS1s/tGTLr7USPVZEmTtLAM=;
        b=P69Q7bzbfakRA/K9JgmDghQPAMnRpt0SCpQ7ZEumIPlKWL6gppMxmleXCq84NRDQec
         L2leVzR/3FWZLsOj6Tl6Lex+dPFazIfbltuPkNdELguYK9TjZf/WA3SwYldnKNuD33cY
         i6uyQL+VVn9SJjeCEw1kfc9ZC3MC3bElmvRDJRLebt/SEChGfGw+F+z5Xcf2FixWs+Xp
         Sg7ShRary7Rz+qfF4Bwfz3G5Fgox00N/+dYFL+zNdz36daMbcPuLYtYVi8wEXEoFrAq3
         tYrRDOVU9B+js8/ZnaxWh01dOtRU60ZLFi0ybj43WSF9n9IwXb3clh60dC0V+yh+OPsZ
         m9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683799195; x=1686391195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7gMr5NOPVmuNsZ2AgAQsBS1s/tGTLr7USPVZEmTtLAM=;
        b=k8LGHTmth72w/Fl3nUEkN7eUkhkn2LtkbHVPhempqvXGAEqB4nmmpfhJmLIt7vbK9L
         fMkXB3FC9LlzxhalR3tvHGDXcYcxeINaWUNpdcUGy2rJIw0ewcMKDBwIFrDEWpPGl7aq
         2FPcmEeKguK+oY87y7AZRXWWURCgfZUvahKwANI1KobTF1NgxkCpqb0sDcW/Xlo1KO4r
         DnWQME91ARHvsR8KBrL63QLYUHj97dPBDQ3qGG1EuCfHvbX3M11CC4+1dCsXBL39meSF
         BzLZ2hz8vEl//94lHjFtXK96GhkxzUTv5N0N60TpmIUO2aYVqddYWlx3OsIoEbb4pQOm
         YDgA==
X-Gm-Message-State: AC+VfDy1jhVrXdiOz1jbVWVlIN3qzkp5rGnFvMhxHTZpf0bZMH6G1ERt
        SXaGF8s76MBrIS31U54PcP21lQ==
X-Google-Smtp-Source: ACHHUZ4pzscXK11l7u6GlPD+PahTw1+974nMATdOD8dNFVVaDttsw1qXyCihSWf8jbDdM1+W/oZSLg==
X-Received: by 2002:adf:d0c7:0:b0:306:372d:7891 with SMTP id z7-20020adfd0c7000000b00306372d7891mr14334874wrh.59.1683799195475;
        Thu, 11 May 2023 02:59:55 -0700 (PDT)
Received: from localhost.localdomain ([64.64.123.10])
        by smtp.gmail.com with ESMTPSA id k9-20020a05600c1c8900b003f4283f5c1bsm12122791wms.2.2023.05.11.02.59.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 May 2023 02:59:55 -0700 (PDT)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jean-philippe <jean-philippe@linaro.org>,
        Wangzhou <wangzhou1@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux.dev, acc@lists.linaro.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v2 2/2] uacce: vma_close clears q->qfrs when freeing qfrs
Date:   Thu, 11 May 2023 17:59:21 +0800
Message-Id: <20230511095921.9331-3-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230511095921.9331-1-zhangfei.gao@linaro.org>
References: <20230511021553.44318-1-zhangfei.gao@linaro.org>
 <20230511095921.9331-1-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

vma_close frees qfrs but not clears q->qfrs, which still points
to the freed object, leading to subsequent mmap fail.
So vma_close clears q->qfrs as well.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/misc/uacce/uacce.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 338b59ef5493..930c252753a0 100644
--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -200,12 +200,15 @@ static int uacce_fops_release(struct inode *inode, struct file *filep)
 static void uacce_vma_close(struct vm_area_struct *vma)
 {
 	struct uacce_queue *q = vma->vm_private_data;
-	struct uacce_qfile_region *qfr = NULL;
 
-	if (vma->vm_pgoff < UACCE_MAX_REGION)
-		qfr = q->qfrs[vma->vm_pgoff];
+	if (vma->vm_pgoff < UACCE_MAX_REGION) {
+		struct uacce_qfile_region *qfr = q->qfrs[vma->vm_pgoff];
 
-	kfree(qfr);
+		mutex_lock(&q->mutex);
+		q->qfrs[vma->vm_pgoff] = NULL;
+		mutex_unlock(&q->mutex);
+		kfree(qfr);
+	}
 }
 
 static const struct vm_operations_struct uacce_vm_ops = {
-- 
2.39.2 (Apple Git-143)

