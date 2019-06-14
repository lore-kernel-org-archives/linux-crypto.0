Return-Path: <SRS0=me0G=UN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3BAC31E4B
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 13:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCB932168B
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 13:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560520237;
	bh=Gko3ADTpWvlugdQMPv4rjs/zDLbwe8iI2q557FWXTvg=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=RR3/BnXp9Kj0qd34E8BE8qq7pTq03c3bBoJyknDQTv5fRMIZM+JT6/wjcA2U9wogj
	 Mv6J38+6LDTF7awhIQoEYWdcT2qf5pRU86JbzQAd4jJmTVpAWhePT3Rm7EpZe6EuZA
	 tKkP86R3PX1P66SfObs4idBtXpZFv3CEDlxauiRs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfFNNug (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbfFNNuf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jun 2019 09:50:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2048120850;
        Fri, 14 Jun 2019 13:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560520233;
        bh=Gko3ADTpWvlugdQMPv4rjs/zDLbwe8iI2q557FWXTvg=;
        h=Date:From:To:Cc:Subject:From;
        b=ltHpPMHDvmk9Z3+wJTqeqQP9O7ax8nr7Wa5CcXcH8MJJr2QlbKOmWdWJlA5jWp0ds
         h5+4weyk1sPc8jQuVNQi13zHuCpxk1rTqdayPUF7n+uhbiZAnP0kCfB2nIGm8ta1wd
         EF/y/ZZw5n5PM+1gO+GjMWMIZht3aOqWvUglAeeI=
Date:   Fri, 14 Jun 2019 15:50:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] crypto: nx: no need to check return value of debugfs_create
 functions
Message-ID: <20190614135031.GA5809@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Also, there is no need to store the individual debugfs file names,
especially as the whole directiry is deleted at once, so remove the
unneeded structure entirely.

Cc: "Breno Leitão" <leitao@debian.org>
Cc: Nayna Jain <nayna@linux.ibm.com>
Cc: Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/nx/nx.c         |  4 +-
 drivers/crypto/nx/nx.h         | 12 +-----
 drivers/crypto/nx/nx_debugfs.c | 71 +++++++++++-----------------------
 3 files changed, 26 insertions(+), 61 deletions(-)

diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 3a5e31be4764..20b5e276f184 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -581,9 +581,7 @@ static int nx_register_algs(void)
 
 	memset(&nx_driver.stats, 0, sizeof(struct nx_stats));
 
-	rc = NX_DEBUGFS_INIT(&nx_driver);
-	if (rc)
-		goto out;
+	NX_DEBUGFS_INIT(&nx_driver);
 
 	nx_driver.of.status = NX_OKAY;
 
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index c3e54af18645..c6b5a3be02be 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -76,20 +76,12 @@ struct nx_stats {
 	atomic_t last_error_pid;
 };
 
-struct nx_debugfs {
-	struct dentry *dfs_root;
-	struct dentry *dfs_aes_ops, *dfs_aes_bytes;
-	struct dentry *dfs_sha256_ops, *dfs_sha256_bytes;
-	struct dentry *dfs_sha512_ops, *dfs_sha512_bytes;
-	struct dentry *dfs_errors, *dfs_last_error, *dfs_last_error_pid;
-};
-
 struct nx_crypto_driver {
 	struct nx_stats    stats;
 	struct nx_of       of;
 	struct vio_dev    *viodev;
 	struct vio_driver  viodriver;
-	struct nx_debugfs  dfs;
+	struct dentry     *dfs_root;
 };
 
 #define NX_GCM4106_NONCE_LEN		(4)
@@ -177,7 +169,7 @@ struct nx_sg *nx_walk_and_build(struct nx_sg *, unsigned int,
 #define NX_DEBUGFS_INIT(drv)	nx_debugfs_init(drv)
 #define NX_DEBUGFS_FINI(drv)	nx_debugfs_fini(drv)
 
-int nx_debugfs_init(struct nx_crypto_driver *);
+void nx_debugfs_init(struct nx_crypto_driver *);
 void nx_debugfs_fini(struct nx_crypto_driver *);
 #else
 #define NX_DEBUGFS_INIT(drv)	(0)
diff --git a/drivers/crypto/nx/nx_debugfs.c b/drivers/crypto/nx/nx_debugfs.c
index 7ab2e8dcd9b4..3aa80a6e34a1 100644
--- a/drivers/crypto/nx/nx_debugfs.c
+++ b/drivers/crypto/nx/nx_debugfs.c
@@ -42,62 +42,37 @@
  * Documentation/ABI/testing/debugfs-pfo-nx-crypto
  */
 
-int nx_debugfs_init(struct nx_crypto_driver *drv)
+void nx_debugfs_init(struct nx_crypto_driver *drv)
 {
-	struct nx_debugfs *dfs = &drv->dfs;
+	struct dentry *root;
 
-	dfs->dfs_root = debugfs_create_dir(NX_NAME, NULL);
+	root = debugfs_create_dir(NX_NAME, NULL);
+	drv->dfs_root = root;
 
-	dfs->dfs_aes_ops =
-		debugfs_create_u32("aes_ops",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   dfs->dfs_root, (u32 *)&drv->stats.aes_ops);
-	dfs->dfs_sha256_ops =
-		debugfs_create_u32("sha256_ops",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   dfs->dfs_root,
-				   (u32 *)&drv->stats.sha256_ops);
-	dfs->dfs_sha512_ops =
-		debugfs_create_u32("sha512_ops",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   dfs->dfs_root,
-				   (u32 *)&drv->stats.sha512_ops);
-	dfs->dfs_aes_bytes =
-		debugfs_create_u64("aes_bytes",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   dfs->dfs_root,
-				   (u64 *)&drv->stats.aes_bytes);
-	dfs->dfs_sha256_bytes =
-		debugfs_create_u64("sha256_bytes",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   dfs->dfs_root,
-				   (u64 *)&drv->stats.sha256_bytes);
-	dfs->dfs_sha512_bytes =
-		debugfs_create_u64("sha512_bytes",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   dfs->dfs_root,
-				   (u64 *)&drv->stats.sha512_bytes);
-	dfs->dfs_errors =
-		debugfs_create_u32("errors",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   dfs->dfs_root, (u32 *)&drv->stats.errors);
-	dfs->dfs_last_error =
-		debugfs_create_u32("last_error",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   dfs->dfs_root,
-				   (u32 *)&drv->stats.last_error);
-	dfs->dfs_last_error_pid =
-		debugfs_create_u32("last_error_pid",
-				   S_IRUSR | S_IRGRP | S_IROTH,
-				   dfs->dfs_root,
-				   (u32 *)&drv->stats.last_error_pid);
-	return 0;
+	debugfs_create_u32("aes_ops", S_IRUSR | S_IRGRP | S_IROTH,
+			   root, (u32 *)&drv->stats.aes_ops);
+	debugfs_create_u32("sha256_ops", S_IRUSR | S_IRGRP | S_IROTH,
+			   root, (u32 *)&drv->stats.sha256_ops);
+	debugfs_create_u32("sha512_ops", S_IRUSR | S_IRGRP | S_IROTH,
+			   root, (u32 *)&drv->stats.sha512_ops);
+	debugfs_create_u64("aes_bytes", S_IRUSR | S_IRGRP | S_IROTH,
+			   root, (u64 *)&drv->stats.aes_bytes);
+	debugfs_create_u64("sha256_bytes", S_IRUSR | S_IRGRP | S_IROTH,
+			   root, (u64 *)&drv->stats.sha256_bytes);
+	debugfs_create_u64("sha512_bytes", S_IRUSR | S_IRGRP | S_IROTH,
+			   root, (u64 *)&drv->stats.sha512_bytes);
+	debugfs_create_u32("errors", S_IRUSR | S_IRGRP | S_IROTH,
+			   root, (u32 *)&drv->stats.errors);
+	debugfs_create_u32("last_error", S_IRUSR | S_IRGRP | S_IROTH,
+			   root, (u32 *)&drv->stats.last_error);
+	debugfs_create_u32("last_error_pid", S_IRUSR | S_IRGRP | S_IROTH,
+			   dfs_root, (u32 *)&drv->stats.last_error_pid);
 }
 
 void
 nx_debugfs_fini(struct nx_crypto_driver *drv)
 {
-	debugfs_remove_recursive(drv->dfs.dfs_root);
+	debugfs_remove_recursive(drv->dfs_root);
 }
 
 #endif
-- 
2.22.0

