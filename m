Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C3CC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Apr 2022 16:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241145AbiDNQyw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Apr 2022 12:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241639AbiDNQyY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Apr 2022 12:54:24 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F86713E433
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 09:23:41 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i10-20020a170902e48a00b00153f493fa9aso2950267ple.17
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 09:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lkcJCQOlm2DvsqWy2MKlxrSAJLim0ircZ4vwjXzXvbI=;
        b=hCNy1KMQ7JjgZ4WuXbtrx/T51qoLvLajJzC1K/yHLNkvWw+lwem1UlEPaV8SYkj2Wl
         ue/t0zAxe1uZM6XPv3QKIZkxQ0XeyRpHYHntGv2shl/x1ICJg1sBwkUjsVYriWi/LJId
         GRzCydsD7povLWp7OEltVgQlkd1Q5zerPmfNsrVXZPPIzBKp4bdrJveOHaiVy4li0UCn
         24OMzn3f8dIXFJ0v6SfCZTIBfjN2OxiC0vrue2s4FJDSisbZ5EjNSTgZVQPYuRK3FYoG
         7C6296YKureshdeoM02PEvVM/mABL8bjzFcY1LHQB87vRlVNfeVsliuE2PyvacRWO1QU
         +B1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lkcJCQOlm2DvsqWy2MKlxrSAJLim0ircZ4vwjXzXvbI=;
        b=5jeRV3rcM5IcfJb5UVKNb5V/gZTl0TTNM3LAEBQkVRoh7or9ejuy5Lu7JxpRG9HuCV
         +UrRJmMeNKe5+fYvuw10Joml4vfT9VD2DJHxLlIYV5H5lVUjMV/nSU7EwSgk0AfIFSXu
         bStkiqwupOz8soTREkiE2zee/qVm1BeJ0I2u29GK5SGWnjaOTjxXha2o2BLnT9gXOzBL
         gVh18i2YRUKb+6UzlP5a7eB7ZEF6H3jr/UQvBuY5svc7neUwsBwaxAVgQMixo40xqSJu
         hU2OnBg+H8yZX8HjAp+euZq5Z7p2vLhqSGCJy+t4yfGJmJb/LM+etiue027H9fGCr2+r
         je2Q==
X-Gm-Message-State: AOAM533rxB4TH2TqG1hi+lQQF/oN2SJGGPUgkh6ccvCHW9Btv1KauiCP
        9+/nlTs/XXy5oBW39j3aiGz7ODU0v+s=
X-Google-Smtp-Source: ABdhPJx0wBN0movEBXl1rplnG+T/dJFn5xqS9a+dvsi2cDVnCxfhNdrOb/0tuqQOtQRGmEEN5zN+Psvj0/zO
X-Received: from jackyli.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3b51])
 (user=jackyli job=sendgmr) by 2002:a17:90b:3613:b0:1cb:66f4:fcad with SMTP id
 ml19-20020a17090b361300b001cb66f4fcadmr5104050pjb.82.1649953420652; Thu, 14
 Apr 2022 09:23:40 -0700 (PDT)
Date:   Thu, 14 Apr 2022 16:23:25 +0000
Message-Id: <20220414162325.1830014-1-jackyli@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v2] crypto: ccp - Fix the INIT_EX data file open failure
From:   Jacky Li <jackyli@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Orr <marcorr@google.com>, Alper Gun <alpergun@google.com>,
        Peter Gonda <pgonda@google.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jacky Li <jackyli@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are 2 common cases when INIT_EX data file might not be
opened successfully and fail the sev initialization:

1. In user namespaces, normal user tasks (e.g. VMM) can change their
   current->fs->root to point to arbitrary directories. While
   init_ex_path is provided as a module param related to root file
   system. Solution: use the root directory of init_task to avoid
   accessing the wrong file.

2. Normal user tasks (e.g. VMM) don't have the privilege to access
   the INIT_EX data file. Solution: open the file as root and
   restore permissions immediately.

Fixes: 3d725965f836 ("crypto: ccp - Add SEV_INIT_EX support")
Signed-off-by: Jacky Li <jackyli@google.com>
Reviewed-by: Peter Gonda <pgonda@google.com>
---
Changelog since v1:
- Added Fixes tag and Reviewed-By tag.

 drivers/crypto/ccp/sev-dev.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6ab93dfd478a..3aefb177715e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -23,6 +23,7 @@
 #include <linux/gfp.h>
 #include <linux/cpufeature.h>
 #include <linux/fs.h>
+#include <linux/fs_struct.h>
 
 #include <asm/smp.h>
 
@@ -170,6 +171,31 @@ static void *sev_fw_alloc(unsigned long len)
 	return page_address(page);
 }
 
+static struct file *open_file_as_root(const char *filename, int flags, umode_t mode)
+{
+	struct file *fp;
+	struct path root;
+	struct cred *cred;
+	const struct cred *old_cred;
+
+	task_lock(&init_task);
+	get_fs_root(init_task.fs, &root);
+	task_unlock(&init_task);
+
+	cred = prepare_creds();
+	if (!cred)
+		return ERR_PTR(-ENOMEM);
+	cred->fsuid = GLOBAL_ROOT_UID;
+	old_cred = override_creds(cred);
+
+	fp = file_open_root(&root, filename, flags, mode);
+	path_put(&root);
+
+	revert_creds(old_cred);
+
+	return fp;
+}
+
 static int sev_read_init_ex_file(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -181,7 +207,7 @@ static int sev_read_init_ex_file(void)
 	if (!sev_init_ex_buffer)
 		return -EOPNOTSUPP;
 
-	fp = filp_open(init_ex_path, O_RDONLY, 0);
+	fp = open_file_as_root(init_ex_path, O_RDONLY, 0);
 	if (IS_ERR(fp)) {
 		int ret = PTR_ERR(fp);
 
@@ -217,7 +243,7 @@ static void sev_write_init_ex_file(void)
 	if (!sev_init_ex_buffer)
 		return;
 
-	fp = filp_open(init_ex_path, O_CREAT | O_WRONLY, 0600);
+	fp = open_file_as_root(init_ex_path, O_CREAT | O_WRONLY, 0600);
 	if (IS_ERR(fp)) {
 		dev_err(sev->dev,
 			"SEV: could not open file for write, error %ld\n",
-- 
2.36.0.rc0.470.gd361397f0d-goog

