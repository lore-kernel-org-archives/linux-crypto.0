Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EDBC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Apr 2022 18:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240928AbiDKSC5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Apr 2022 14:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243222AbiDKSC4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Apr 2022 14:02:56 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEF13467F
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 11:00:41 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id p4-20020a631e44000000b00399598a48c5so9272002pgm.1
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 11:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DJ4Nu7yeQzPIBeWZ/OUHX9Ih+tVIkR2u7MIpes1TbYg=;
        b=U1HrGRdF/DcfNx25R540JqgwiF6jiJIFY0lo51vYR5zRmd7Ee6GvZQx+BsvxCXZdCD
         Ibts10zHeKtsdrQm1l0s10GjAeTxXDjxTdNoOPP9LfxW+Zenmsx/2sXPy1X94RPpHgjG
         cnE03GOJWM+z4/tV90uhWtTXOiUzqZRRZ4kuEZTMFc1fTGpsyq8+vtlUQgDOMWEg4t+a
         Ha6g5sNa3OqtqcN+qg/vxr3C2eJW9Oj1Djs9BO9Si2/WCU4FOhqEccUXIjuKOSNGPopK
         Ggv0Zw/oUMxi8yk0klZqcom/GO1WabQAUhz+6wOCqxH4Ut+p/bhH6Y9/dm9HoY5OIotH
         ZLxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DJ4Nu7yeQzPIBeWZ/OUHX9Ih+tVIkR2u7MIpes1TbYg=;
        b=rntliemEubYOoZPYAo8dPfEGm1ioftHI9eg2X9byOhYiaNySWgJcCXyuHClW/z/S0g
         ZDHUhCVHHfV/JI3IbmRsNtylGUfJWbn3euqij2BAe0EIaUIWSsM10Cxc86sKtjf19pAB
         SumJ+0TI3Hbp9xMpjyWmOimujp2GloZ3m4kfnyBemCPFGQHj/UcC9//NtxeEFgyZ5MW0
         iGVvpaDzUZ7UtKSd3bSUyuGJ027Q2S//SlZt8PbXSEXNIEPmcdK0SqtBxqVGBSNUUAhe
         RaUZrziz804KzWSA+QHCcHTOoP05tAOMmw7J806LYZusMndWzK3qlN5/YGhHOaP2HTng
         OMvg==
X-Gm-Message-State: AOAM533uOe2J6mavkVKG/f2NhXTvX6lXwKLavlmv8l9USlBV+gxQtBPI
        Jq6ngFcNqzU0igMmZM60a0ILPVrXagU=
X-Google-Smtp-Source: ABdhPJyBkI1R7smhNlPUQCI6QekCggtL//GX9vN4f51Y9CkbxIX5Kp68NuT5D+AdEna3Gzr6K/huqYOC0eP1
X-Received: from jackyli.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3b51])
 (user=jackyli job=sendgmr) by 2002:a65:654f:0:b0:378:b8f6:ebe4 with SMTP id
 a15-20020a65654f000000b00378b8f6ebe4mr27192887pgw.399.1649700040430; Mon, 11
 Apr 2022 11:00:40 -0700 (PDT)
Date:   Mon, 11 Apr 2022 18:00:06 +0000
Message-Id: <20220411180006.4187548-1-jackyli@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH] crypto: ccp - Fix the INIT_EX data file open failure
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

Signed-off-by: Jacky Li <jackyli@google.com>
---
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
2.35.1.1178.g4f1659d476-goog

