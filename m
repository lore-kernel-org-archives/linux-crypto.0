Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA88C352A3
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEFA420848
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731173AbgBKSTp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 13:19:45 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:44982 "EHLO
        laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731161AbgBKSTf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 13:19:35 -0500
Received: from ramsan ([84.195.182.253])
        by laurent.telenet-ops.be with bizsmtp
        id 1WKW220035USYZQ01WKW3L; Tue, 11 Feb 2020 19:19:30 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1j1a8A-0002oY-0Z; Tue, 11 Feb 2020 19:19:30 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1j1a89-0003yz-Vb; Tue, 11 Feb 2020 19:19:29 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        linux-crypto@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 19/34] crypto: ccree - remove struct cc_debugfs_ctx
Date:   Tue, 11 Feb 2020 19:19:13 +0100
Message-Id: <20200211181928.15178-20-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211181928.15178-1-geert+renesas@glider.be>
References: <20200211181928.15178-1-geert+renesas@glider.be>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The cc_debugfs_ctx structure contains only a single member, and only one
instance exists.  Simplify the code and reduce memory consumption by
moving this member to struct cc_drvdata.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - New.

 drivers/crypto/ccree/cc_debugfs.c | 27 +++++++--------------------
 drivers/crypto/ccree/cc_driver.h  |  2 +-
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_debugfs.c
index 35f3a2137502bd96..c454afce7781017b 100644
--- a/drivers/crypto/ccree/cc_debugfs.c
+++ b/drivers/crypto/ccree/cc_debugfs.c
@@ -8,10 +8,6 @@
 #include "cc_crypto_ctx.h"
 #include "cc_debugfs.h"
 
-struct cc_debugfs_ctx {
-	struct dentry *dir;
-};
-
 #define CC_DEBUG_REG(_X) {	\
 	.name = __stringify(_X),\
 	.offset = CC_REG(_X)	\
@@ -67,13 +63,8 @@ void __exit cc_debugfs_global_fini(void)
 int cc_debugfs_init(struct cc_drvdata *drvdata)
 {
 	struct device *dev = drvdata_to_dev(drvdata);
-	struct cc_debugfs_ctx *ctx;
 	struct debugfs_regset32 *regset, *verset;
 
-	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
-
 	regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
 	if (!regset)
 		return -ENOMEM;
@@ -83,15 +74,16 @@ int cc_debugfs_init(struct cc_drvdata *drvdata)
 	regset->base = drvdata->cc_base;
 	regset->dev = dev;
 
-	ctx->dir = debugfs_create_dir(drvdata->plat_dev->name, cc_debugfs_dir);
+	drvdata->dir = debugfs_create_dir(drvdata->plat_dev->name,
+					  cc_debugfs_dir);
 
-	debugfs_create_regset32("regs", 0400, ctx->dir, regset);
-	debugfs_create_bool("coherent", 0400, ctx->dir, &drvdata->coherent);
+	debugfs_create_regset32("regs", 0400, drvdata->dir, regset);
+	debugfs_create_bool("coherent", 0400, drvdata->dir, &drvdata->coherent);
 
 	verset = devm_kzalloc(dev, sizeof(*verset), GFP_KERNEL);
 	/* Failing here is not important enough to fail the module load */
 	if (!verset)
-		goto out;
+		return 0;
 
 	if (drvdata->hw_rev <= CC_HW_REV_712) {
 		ver_sig_regs[0].offset = drvdata->sig_offset;
@@ -105,16 +97,11 @@ int cc_debugfs_init(struct cc_drvdata *drvdata)
 	verset->base = drvdata->cc_base;
 	verset->dev = dev;
 
-	debugfs_create_regset32("version", 0400, ctx->dir, verset);
-
-out:
-	drvdata->debugfs = ctx;
+	debugfs_create_regset32("version", 0400, drvdata->dir, verset);
 	return 0;
 }
 
 void cc_debugfs_fini(struct cc_drvdata *drvdata)
 {
-	struct cc_debugfs_ctx *ctx = (struct cc_debugfs_ctx *)drvdata->debugfs;
-
-	debugfs_remove_recursive(ctx->dir);
+	debugfs_remove_recursive(drvdata->dir);
 }
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index 7e483c22858245f9..7360b403655c96f7 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -147,7 +147,7 @@ struct cc_drvdata {
 	void *request_mgr_handle;
 	void *fips_handle;
 	u32 sram_free_offset;	/* offset to non-allocated area in SRAM */
-	void *debugfs;
+	struct dentry *dir;	/* for debugfs */
 	struct clk *clk;
 	bool coherent;
 	char *hw_rev_name;
-- 
2.17.1

