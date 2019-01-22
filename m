Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CCEC282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6A15217D8
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170090;
	bh=vUng/3Gdb3oYCxJxe2+j1CCWbQwGwRefUqh8xBlE5wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=W9haU5jGQK1YA9WmWrDxMENL/H/6qnusTJOY4cixTa44d8CB5mdNDQ7UQcna9Zpkn
	 R9y8eKCJIibtQjVC1VUcAxZ4M7nt9W70ba35v7DN4kwhEae3PSW6wH9tdAfsa+xXYz
	 IS65kdbIpQ04GVG9O15qKFpPZ0TNo2Ghy176RPe8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbfAVPOs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:14:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729199AbfAVPOs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 10:14:48 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81A3C217D6;
        Tue, 22 Jan 2019 15:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170087;
        bh=vUng/3Gdb3oYCxJxe2+j1CCWbQwGwRefUqh8xBlE5wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WqCBMm70GDCL7uH2zNImPNcxOTmzD/xiG0ZU2eQCEvQ8hUMLPGI2AUyTjlVoIUF80
         nEN1TTKKnVm+Dkq02s5wUhFjANshzZCo9Fh/j7rNYnuXXZBX2J08hBUcxacNaClzL4
         J90mfo1vSZb+uIDjmGRCRs4iKlVOSYQx5sLaasuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Gadam Sreerama <sgadam@cavium.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5/7] crypto: cavium: nitrox: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:14:20 +0100
Message-Id: <20190122151422.14204-6-gregkh@linuxfoundation.org>
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

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Cc: Yangtao Li <tiny.windzz@gmail.com>
Cc: Gadam Sreerama <sgadam@cavium.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/cavium/nitrox/nitrox_debugfs.c | 27 ++++---------------
 drivers/crypto/cavium/nitrox/nitrox_debugfs.h |  5 ++--
 drivers/crypto/cavium/nitrox/nitrox_main.c    |  4 +--
 3 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_debugfs.c b/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
index 0196b992280f..848ec93d4333 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_debugfs.c
@@ -55,31 +55,14 @@ void nitrox_debugfs_exit(struct nitrox_device *ndev)
 	ndev->debugfs_dir = NULL;
 }
 
-int nitrox_debugfs_init(struct nitrox_device *ndev)
+void nitrox_debugfs_init(struct nitrox_device *ndev)
 {
-	struct dentry *dir, *f;
+	struct dentry *dir;
 
 	dir = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	if (!dir)
-		return -ENOMEM;
 
 	ndev->debugfs_dir = dir;
-	f = debugfs_create_file("firmware", 0400, dir, ndev,
-				&firmware_fops);
-	if (!f)
-		goto err;
-	f = debugfs_create_file("device", 0400, dir, ndev,
-				&device_fops);
-	if (!f)
-		goto err;
-	f = debugfs_create_file("stats", 0400, dir, ndev,
-				&stats_fops);
-	if (!f)
-		goto err;
-
-	return 0;
-
-err:
-	nitrox_debugfs_exit(ndev);
-	return -ENODEV;
+	debugfs_create_file("firmware", 0400, dir, ndev, &firmware_fops);
+	debugfs_create_file("device", 0400, dir, ndev, &device_fops);
+	debugfs_create_file("stats", 0400, dir, ndev, &stats_fops);
 }
diff --git a/drivers/crypto/cavium/nitrox/nitrox_debugfs.h b/drivers/crypto/cavium/nitrox/nitrox_debugfs.h
index a8d85ffa619c..f177b79bbab0 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_debugfs.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_debugfs.h
@@ -5,12 +5,11 @@
 #include "nitrox_dev.h"
 
 #ifdef CONFIG_DEBUG_FS
-int nitrox_debugfs_init(struct nitrox_device *ndev);
+void nitrox_debugfs_init(struct nitrox_device *ndev);
 void nitrox_debugfs_exit(struct nitrox_device *ndev);
 #else
-static inline int nitrox_debugfs_init(struct nitrox_device *ndev)
+static inline void nitrox_debugfs_init(struct nitrox_device *ndev)
 {
-	return 0;
 }
 
 static inline void nitrox_debugfs_exit(struct nitrox_device *ndev)
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index 014e9863c20e..faa78f651238 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -404,9 +404,7 @@ static int nitrox_probe(struct pci_dev *pdev,
 	if (err)
 		goto pf_hw_fail;
 
-	err = nitrox_debugfs_init(ndev);
-	if (err)
-		goto pf_hw_fail;
+	nitrox_debugfs_init(ndev);
 
 	/* clear the statistics */
 	atomic64_set(&ndev->stats.posted, 0);
-- 
2.20.1

