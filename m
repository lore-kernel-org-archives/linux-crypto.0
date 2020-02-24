Return-Path: <SRS0=ApwQ=4M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D149C3567B
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 07:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01F472072D
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 07:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vt4uH1X7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgBXHJe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Feb 2020 02:09:34 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46239 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgBXHJe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Feb 2020 02:09:34 -0500
Received: by mail-pl1-f196.google.com with SMTP id y8so3655529pll.13
        for <linux-crypto@vger.kernel.org>; Sun, 23 Feb 2020 23:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=/uPpAa8jWLyAfBp8dYHRA7/+Um011bRC49XujdAf5Gw=;
        b=Vt4uH1X74Vz34W4kXqEU9GjpdIZaRNOAYiAWTOQ1UMED+e4JPXHiBpOaVyjcaVd6Xr
         mwMnRNpFFPHTP7Gh8z4MbfmYwCoLizdEfNCeHaaBFRVzWWW3uAGRXaHOh8xOlsePS3Xk
         KJndJ4aA72+df4iyDsnn1aOnF+Q9uxP6u4F5HkUf+K6q1mKovKBf66+1zFlqN1LyzOa8
         LbMnvdTdK3XIXzEvXZjgnMxWI/yQ+gXwotfTyHJ3RLQEjWJPxj5t+Egdz+lUhJo9dRfa
         u/D2StJKNQqVIu12NKg5SEGQNT5MF+9ByQWsSxLoCgpc2V2hImqq6MQgaUExsrNZq+iP
         F8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/uPpAa8jWLyAfBp8dYHRA7/+Um011bRC49XujdAf5Gw=;
        b=OfPwJW0IZfTAxWEOBVcuY/NG5xx3z4SPHMA/HJ8CT199A1JmTCeW1Q2GXd0q0BU6ox
         2xsRoKXCzfwvTXP1rIKAgcu3JiIUed/w9Yp+VAlA3lTYj+KbXS9gHMTAe+IeBSy4qetl
         i9a+6NDHgL1OjxmJRVE+ignmPrde9wb/55X4QcLncT1lWhaUsjMb/IWq6A311FjbbuPN
         apIoCfgl4qrlxPmMd1Bpcwt40uTeMO9ff+9j44WeEQnnqnuMp8f/N/xEgCTs7h3G09xZ
         90KJh5NHipwAz9V9Lb6NS2/5TXeTjjjOZTe/87eEl0/CHeT8oid/qXL5HP/lcx8veweX
         zC3w==
X-Gm-Message-State: APjAAAVLRoxBDHWwkSzvaI8QhaNwG7dELS+44+W7XRsFT1xOzky1ZtUH
        iEAr/02G49bzmJibEi/1MZzJHw==
X-Google-Smtp-Source: APXvYqx0OSRTVCSeiYO1FV+Igbe6EP8kYjyMiN+xj3uIr/PdSbQKLLUBdVhv8Rkb7x00XxnT3mbpQA==
X-Received: by 2002:a17:90a:d789:: with SMTP id z9mr18855684pju.5.1582528173696;
        Sun, 23 Feb 2020 23:09:33 -0800 (PST)
Received: from localhost.localdomain (li1566-229.members.linode.com. [139.162.86.229])
        by smtp.gmail.com with ESMTPSA id d24sm11522905pfq.75.2020.02.23.23.09.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 23 Feb 2020 23:09:32 -0800 (PST)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, dave.jiang@intel.com,
        grant.likely@arm.com, jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org
Cc:     linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH] uacce: unmap remaining mmapping from user space
Date:   Mon, 24 Feb 2020 15:06:56 +0800
Message-Id: <1582528016-2873-1-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When uacce parent device module is removed, user app may
still keep the mmaped area, which can be accessed unsafely.
When rmmod, Parent device drvier will call uacce_remove,
which unmap all remaining mapping from user space for safety.
VM_FAULT_SIGBUS is also reported to user space accordingly.

Suggested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/misc/uacce/uacce.c | 17 +++++++++++++++++
 include/linux/uacce.h      |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index ffced4d..1bcc5e6 100644
--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -224,6 +224,7 @@ static int uacce_fops_open(struct inode *inode, struct file *filep)
 
 	init_waitqueue_head(&q->wait);
 	filep->private_data = q;
+	uacce->inode = inode;
 	q->state = UACCE_Q_INIT;
 
 	return 0;
@@ -253,6 +254,14 @@ static int uacce_fops_release(struct inode *inode, struct file *filep)
 	return 0;
 }
 
+static vm_fault_t uacce_vma_fault(struct vm_fault *vmf)
+{
+	if (vmf->flags & (FAULT_FLAG_MKWRITE | FAULT_FLAG_WRITE))
+		return VM_FAULT_SIGBUS;
+
+	return 0;
+}
+
 static void uacce_vma_close(struct vm_area_struct *vma)
 {
 	struct uacce_queue *q = vma->vm_private_data;
@@ -265,6 +274,7 @@ static void uacce_vma_close(struct vm_area_struct *vma)
 }
 
 static const struct vm_operations_struct uacce_vm_ops = {
+	.fault = uacce_vma_fault,
 	.close = uacce_vma_close,
 };
 
@@ -585,6 +595,13 @@ void uacce_remove(struct uacce_device *uacce)
 		cdev_device_del(uacce->cdev, &uacce->dev);
 	xa_erase(&uacce_xa, uacce->dev_id);
 	put_device(&uacce->dev);
+
+	/*
+	 * unmap remainning mapping from user space, preventing user still
+	 * access the mmaped area while parent device is already removed
+	 */
+	if (uacce->inode)
+		unmap_mapping_range(uacce->inode->i_mapping, 0, 0, 1);
 }
 EXPORT_SYMBOL_GPL(uacce_remove);
 
diff --git a/include/linux/uacce.h b/include/linux/uacce.h
index 904a461..0e215e6 100644
--- a/include/linux/uacce.h
+++ b/include/linux/uacce.h
@@ -98,6 +98,7 @@ struct uacce_queue {
  * @priv: private pointer of the uacce
  * @mm_list: list head of uacce_mm->list
  * @mm_lock: lock for mm_list
+ * @inode: core vfs
  */
 struct uacce_device {
 	const char *algs;
@@ -113,6 +114,7 @@ struct uacce_device {
 	void *priv;
 	struct list_head mm_list;
 	struct mutex mm_lock;
+	struct inode *inode;
 };
 
 /**
-- 
2.7.4

