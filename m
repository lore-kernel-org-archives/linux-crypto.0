Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF0CC43600
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 13:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C732613B4
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 13:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238641AbhETOBO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 10:01:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3633 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243483AbhETN7w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 09:59:52 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FmB911qMZzmWsr;
        Thu, 20 May 2021 21:56:05 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 21:58:22 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 20
 May 2021 21:58:21 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <yuehaibing@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] hwrng: core - Use DEVICE_ATTR_<RW|RO> macro
Date:   Thu, 20 May 2021 21:57:13 +0800
Message-ID: <20210520135713.32464-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use DEVICE_ATTR_RW()/DEVICE_ATTR_RO() helper instead of
plain DEVICE_ATTR, which makes the code a bit shorter and
easier to read.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/char/hw_random/core.c | 36 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index adb3c2bd7783..59beaf4d29bd 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -319,9 +319,9 @@ static int enable_best_rng(void)
 	return ret;
 }
 
-static ssize_t hwrng_attr_current_store(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t len)
+static ssize_t rng_current_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t len)
 {
 	int err = -ENODEV;
 	struct hwrng *rng, *old_rng, *new_rng;
@@ -354,9 +354,9 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 	return err ? : len;
 }
 
-static ssize_t hwrng_attr_current_show(struct device *dev,
-				       struct device_attribute *attr,
-				       char *buf)
+static ssize_t rng_current_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
 {
 	ssize_t ret;
 	struct hwrng *rng;
@@ -371,9 +371,9 @@ static ssize_t hwrng_attr_current_show(struct device *dev,
 	return ret;
 }
 
-static ssize_t hwrng_attr_available_show(struct device *dev,
-					 struct device_attribute *attr,
-					 char *buf)
+static ssize_t rng_available_show(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
 {
 	int err;
 	struct hwrng *rng;
@@ -392,22 +392,16 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
 	return strlen(buf);
 }
 
-static ssize_t hwrng_attr_selected_show(struct device *dev,
-					struct device_attribute *attr,
-					char *buf)
+static ssize_t rng_selected_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
 {
 	return sysfs_emit(buf, "%d\n", cur_rng_set_by_user);
 }
 
-static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
-		   hwrng_attr_current_show,
-		   hwrng_attr_current_store);
-static DEVICE_ATTR(rng_available, S_IRUGO,
-		   hwrng_attr_available_show,
-		   NULL);
-static DEVICE_ATTR(rng_selected, S_IRUGO,
-		   hwrng_attr_selected_show,
-		   NULL);
+static DEVICE_ATTR_RW(rng_current);
+static DEVICE_ATTR_RO(rng_available);
+static DEVICE_ATTR_RO(rng_selected);
 
 static struct attribute *rng_dev_attrs[] = {
 	&dev_attr_rng_current.attr,
-- 
2.17.1

