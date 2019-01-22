Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14DBAC282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC76A20879
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170115;
	bh=a38eLIHakff3RxdEo1/Wa7SAAon1dgSDDFEp8T+OyX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OYBTM9M0+bbjApJlY8JXk6nK/mx4i9NwcQQ2hGZL6FNMo0EO5WXpZfEQba+Syn1cj
	 SJpjomno3hy9xDG0DwhKRcEG5looqaU5MRDPwXeWIc6c8LX5FIezs/3LheZt7etHAK
	 NXBfyvXKDCGYXXXULqmiEZeKoc+XN3eO+Q4KuweI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbfAVPOl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728953AbfAVPOj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 10:14:39 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F28C217D4;
        Tue, 22 Jan 2019 15:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170078;
        bh=a38eLIHakff3RxdEo1/Wa7SAAon1dgSDDFEp8T+OyX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lx9qJgVkrDzgmX55H/S5PnivaGgWunzrm5Jmgftxgq925pBtf6obUwzdVZFI1KJhm
         BSixnrAN9fkrIgCXjkeDDMJfRx0e1wTvkIUhiquy9EJPG9OX1rXM5fZ1EJWKsmmdxl
         EFgwMek6V+iWA5p6HK+gWre3KiVRwvyDS8JAJTCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yael Chemla <yael.chemla@foss.arm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 2/7] crypto: ccrree: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:14:17 +0100
Message-Id: <20190122151422.14204-3-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190122151422.14204-1-gregkh@linuxfoundation.org>
References: <20190122151422.14204-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Yael Chemla <yael.chemla@foss.arm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccree/cc_debugfs.c | 22 +++-------------------
 drivers/crypto/ccree/cc_debugfs.h |  8 ++------
 drivers/crypto/ccree/cc_driver.c  |  7 +------
 3 files changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_debugfs.c
index 5ca184e42483..5fa05a7bcf36 100644
--- a/drivers/crypto/ccree/cc_debugfs.c
+++ b/drivers/crypto/ccree/cc_debugfs.c
@@ -39,11 +39,9 @@ static struct debugfs_reg32 debug_regs[] = {
 	CC_DEBUG_REG(AXIM_MON_COMP),
 };
 
-int __init cc_debugfs_global_init(void)
+void __init cc_debugfs_global_init(void)
 {
 	cc_debugfs_dir = debugfs_create_dir("ccree", NULL);
-
-	return !cc_debugfs_dir;
 }
 
 void __exit cc_debugfs_global_fini(void)
@@ -56,7 +54,6 @@ int cc_debugfs_init(struct cc_drvdata *drvdata)
 	struct device *dev = drvdata_to_dev(drvdata);
 	struct cc_debugfs_ctx *ctx;
 	struct debugfs_regset32 *regset;
-	struct dentry *file;
 
 	debug_regs[0].offset = drvdata->sig_offset;
 	debug_regs[1].offset = drvdata->ver_offset;
@@ -74,22 +71,9 @@ int cc_debugfs_init(struct cc_drvdata *drvdata)
 	regset->base = drvdata->cc_base;
 
 	ctx->dir = debugfs_create_dir(drvdata->plat_dev->name, cc_debugfs_dir);
-	if (!ctx->dir)
-		return -ENFILE;
-
-	file = debugfs_create_regset32("regs", 0400, ctx->dir, regset);
-	if (!file) {
-		debugfs_remove(ctx->dir);
-		return -ENFILE;
-	}
 
-	file = debugfs_create_bool("coherent", 0400, ctx->dir,
-				   &drvdata->coherent);
-
-	if (!file) {
-		debugfs_remove_recursive(ctx->dir);
-		return -ENFILE;
-	}
+	debugfs_create_regset32("regs", 0400, ctx->dir, regset);
+	debugfs_create_bool("coherent", 0400, ctx->dir, &drvdata->coherent);
 
 	drvdata->debugfs = ctx;
 
diff --git a/drivers/crypto/ccree/cc_debugfs.h b/drivers/crypto/ccree/cc_debugfs.h
index 5b5320eca7d2..01cbd9a95659 100644
--- a/drivers/crypto/ccree/cc_debugfs.h
+++ b/drivers/crypto/ccree/cc_debugfs.h
@@ -5,7 +5,7 @@
 #define __CC_DEBUGFS_H__
 
 #ifdef CONFIG_DEBUG_FS
-int cc_debugfs_global_init(void);
+void cc_debugfs_global_init(void);
 void cc_debugfs_global_fini(void);
 
 int cc_debugfs_init(struct cc_drvdata *drvdata);
@@ -13,11 +13,7 @@ void cc_debugfs_fini(struct cc_drvdata *drvdata);
 
 #else
 
-static inline int cc_debugfs_global_init(void)
-{
-	return 0;
-}
-
+static inline void cc_debugfs_global_init(void) {}
 static inline void cc_debugfs_global_fini(void) {}
 
 static inline int cc_debugfs_init(struct cc_drvdata *drvdata)
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 8ada308d72ee..662738e53ced 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -538,13 +538,8 @@ static struct platform_driver ccree_driver = {
 
 static int __init ccree_init(void)
 {
-	int ret;
-
 	cc_hash_global_init();
-
-	ret = cc_debugfs_global_init();
-	if (ret)
-		return ret;
+	cc_debugfs_global_init();
 
 	return platform_driver_register(&ccree_driver);
 }
-- 
2.20.1

