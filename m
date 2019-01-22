Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DC8C282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D959C20879
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170104;
	bh=pNi+plpGvyZxFABsBAWchMyav3BimwX0bOsD7fo9jVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0BknoM8wcTI6dGCGRfLRPDeUka/luVf8T/XAiEmXtok/YOYCZ6yohu5B+6WEiGvgt
	 51ESDZkFBwYLC1UkADo8U4vvhGXddQd1XoIk6oGyi9Vm1JBsCuRPCwpRdMlA5eehEF
	 g1pmAPPRdCtBzWzNEV9A/JyHViGwlllD+mO9/bZs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbfAVPOw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:14:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729304AbfAVPOv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 10:14:51 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8692320879;
        Tue, 22 Jan 2019 15:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170090;
        bh=pNi+plpGvyZxFABsBAWchMyav3BimwX0bOsD7fo9jVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZ0eftAGBx4/n2UxdJBhiDLZu96vPxCTZXz626Db1qsm+zHD6Z7oj1q5fho0IJoWn
         vUlXC3/dZt0ytHfhWcbQtO2viHuHmzNQU4RRTdsoQE0vJ9asxzxb6Qf92ZuWzHHYFe
         jyuZJu10qHaYDMasDwzLN8m+gt4HXi4WClr6PuHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>
Subject: [PATCH 6/7] crypto: ccp: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:14:21 +0100
Message-Id: <20190122151422.14204-7-gregkh@linuxfoundation.org>
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

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/ccp-debugfs.c | 36 +++++++-------------------------
 1 file changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-debugfs.c b/drivers/crypto/ccp/ccp-debugfs.c
index 1a734bd2070a..4bd26af7098d 100644
--- a/drivers/crypto/ccp/ccp-debugfs.c
+++ b/drivers/crypto/ccp/ccp-debugfs.c
@@ -286,10 +286,7 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
 {
 	struct ccp_cmd_queue *cmd_q;
 	char name[MAX_NAME_LEN + 1];
-	struct dentry *debugfs_info;
-	struct dentry *debugfs_stats;
 	struct dentry *debugfs_q_instance;
-	struct dentry *debugfs_q_stats;
 	int i;
 
 	if (!debugfs_initialized())
@@ -299,24 +296,14 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
 	if (!ccp_debugfs_dir)
 		ccp_debugfs_dir = debugfs_create_dir(KBUILD_MODNAME, NULL);
 	mutex_unlock(&ccp_debugfs_lock);
-	if (!ccp_debugfs_dir)
-		return;
 
 	ccp->debugfs_instance = debugfs_create_dir(ccp->name, ccp_debugfs_dir);
-	if (!ccp->debugfs_instance)
-		goto err;
 
-	debugfs_info = debugfs_create_file("info", 0400,
-					   ccp->debugfs_instance, ccp,
-					   &ccp_debugfs_info_ops);
-	if (!debugfs_info)
-		goto err;
+	debugfs_create_file("info", 0400, ccp->debugfs_instance, ccp,
+			    &ccp_debugfs_info_ops);
 
-	debugfs_stats = debugfs_create_file("stats", 0600,
-					    ccp->debugfs_instance, ccp,
-					    &ccp_debugfs_stats_ops);
-	if (!debugfs_stats)
-		goto err;
+	debugfs_create_file("stats", 0600, ccp->debugfs_instance, ccp,
+			    &ccp_debugfs_stats_ops);
 
 	for (i = 0; i < ccp->cmd_q_count; i++) {
 		cmd_q = &ccp->cmd_q[i];
@@ -325,21 +312,12 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
 
 		debugfs_q_instance =
 			debugfs_create_dir(name, ccp->debugfs_instance);
-		if (!debugfs_q_instance)
-			goto err;
-
-		debugfs_q_stats =
-			debugfs_create_file("stats", 0600,
-					    debugfs_q_instance, cmd_q,
-					    &ccp_debugfs_queue_ops);
-		if (!debugfs_q_stats)
-			goto err;
+
+		debugfs_create_file("stats", 0600, debugfs_q_instance, cmd_q,
+				    &ccp_debugfs_queue_ops);
 	}
 
 	return;
-
-err:
-	debugfs_remove_recursive(ccp->debugfs_instance);
 }
 
 void ccp5_debugfs_destroy(void)
-- 
2.20.1

