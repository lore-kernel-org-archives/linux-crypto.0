Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21042C282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6B9520879
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170109;
	bh=pdbZX+e4YaHZHBBu2G1bBtBhTN0QM+ePWfjLnLkX1eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=y98lBriMEQHrN8t8qrRuhpoKoPk9V/vtu19bcj1O7Kic+393wmJVZ5mFBYCbuSb1I
	 Lw9neQCOwl3EIsTYAEGG2pI0W0D04Ri2pLIuHJBWbDzU4AFGxKlhtWNFRodS1tLdz0
	 hKn//LmbrUoahPQtEl5/5/qNvOFLSWrvlxqOhxDk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfAVPOp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:14:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729199AbfAVPOp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 10:14:45 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E84F6217D4;
        Tue, 22 Jan 2019 15:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170084;
        bh=pdbZX+e4YaHZHBBu2G1bBtBhTN0QM+ePWfjLnLkX1eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtFVwwMK4eO7yrOesrEBE+Mju+V+R/xSkFM0dpRjAX0r7x23OUW3kdEjqKYx6L1Ng
         X1Tp8wGdk6GPjGvAqBTUOII5FLV1gmEYuwLvjSLcfJQq40Ml3BvxUTQydn1u0LdSMm
         Y4pFixfZebdj0MHHiPvWzXziFfNtumj6Mm9VXraw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Robert Richter <rrichter@cavium.com>,
        Jan Glauber <jglauber@cavium.com>
Subject: [PATCH 4/7] crypto: cavium: zip: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:14:19 +0100
Message-Id: <20190122151422.14204-5-gregkh@linuxfoundation.org>
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
Cc: Robert Richter <rrichter@cavium.com>
Cc: Jan Glauber <jglauber@cavium.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/cavium/zip/zip_main.c | 52 ++++++----------------------
 1 file changed, 11 insertions(+), 41 deletions(-)

diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
index be055b9547f6..e6b09e784e66 100644
--- a/drivers/crypto/cavium/zip/zip_main.c
+++ b/drivers/crypto/cavium/zip/zip_main.c
@@ -618,41 +618,23 @@ static const struct file_operations zip_regs_fops = {
 /* Root directory for thunderx_zip debugfs entry */
 static struct dentry *zip_debugfs_root;
 
-static int __init zip_debugfs_init(void)
+static void __init zip_debugfs_init(void)
 {
-	struct dentry *zip_stats, *zip_clear, *zip_regs;
-
 	if (!debugfs_initialized())
-		return -ENODEV;
+		return;
 
 	zip_debugfs_root = debugfs_create_dir("thunderx_zip", NULL);
-	if (!zip_debugfs_root)
-		return -ENOMEM;
 
 	/* Creating files for entries inside thunderx_zip directory */
-	zip_stats = debugfs_create_file("zip_stats", 0444,
-					zip_debugfs_root,
-					NULL, &zip_stats_fops);
-	if (!zip_stats)
-		goto failed_to_create;
-
-	zip_clear = debugfs_create_file("zip_clear", 0444,
-					zip_debugfs_root,
-					NULL, &zip_clear_fops);
-	if (!zip_clear)
-		goto failed_to_create;
-
-	zip_regs = debugfs_create_file("zip_regs", 0444,
-				       zip_debugfs_root,
-				       NULL, &zip_regs_fops);
-	if (!zip_regs)
-		goto failed_to_create;
+	debugfs_create_file("zip_stats", 0444, zip_debugfs_root, NULL,
+			    &zip_stats_fops);
 
-	return 0;
+	debugfs_create_file("zip_clear", 0444, zip_debugfs_root, NULL,
+			    &zip_clear_fops);
+
+	debugfs_create_file("zip_regs", 0444, zip_debugfs_root, NULL,
+			    &zip_regs_fops);
 
-failed_to_create:
-	debugfs_remove_recursive(zip_debugfs_root);
-	return -ENOENT;
 }
 
 static void __exit zip_debugfs_exit(void)
@@ -661,13 +643,8 @@ static void __exit zip_debugfs_exit(void)
 }
 
 #else
-static int __init zip_debugfs_init(void)
-{
-	return 0;
-}
-
+static void __init zip_debugfs_init(void) { }
 static void __exit zip_debugfs_exit(void) { }
-
 #endif
 /* debugfs - end */
 
@@ -691,17 +668,10 @@ static int __init zip_init_module(void)
 	}
 
 	/* comp-decomp statistics are handled with debugfs interface */
-	ret = zip_debugfs_init();
-	if (ret < 0) {
-		zip_err("ZIP: debugfs initialization failed\n");
-		goto err_crypto_unregister;
-	}
+	zip_debugfs_init();
 
 	return ret;
 
-err_crypto_unregister:
-	zip_unregister_compression_device();
-
 err_pci_unregister:
 	pci_unregister_driver(&zip_driver);
 	return ret;
-- 
2.20.1

