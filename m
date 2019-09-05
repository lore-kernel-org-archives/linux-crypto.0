Return-Path: <SRS0=9BFZ=XA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4A6C3A5A5
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 04:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 452EB20870
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 04:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfIEEvk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:51:40 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60466 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725209AbfIEEvk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 00:51:40 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i5jk9-0006Df-6s; Thu, 05 Sep 2019 14:51:38 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Sep 2019 14:51:37 +1000
Date:   Thu, 5 Sep 2019 14:51:37 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: crypto: ux500 - Fix COMPILE_TEST warnings
Message-ID: <20190905045137.GA31882@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes a number of warnings encountered when this driver
is built on a 64-bit platform with COMPILE_TEST.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index e966e9a64501..1628ae7a1467 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -528,9 +528,9 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
 
 	dev_dbg(ctx->device->dev, "[%s]: ", __func__);
 
-	if (unlikely(!IS_ALIGNED((u32)sg, 4))) {
+	if (unlikely(!IS_ALIGNED((unsigned long)sg, 4))) {
 		dev_err(ctx->device->dev, "[%s]: Data in sg list isn't "
-			"aligned! Addr: 0x%08x", __func__, (u32)sg);
+			"aligned! Addr: 0x%08lx", __func__, (unsigned long)sg);
 		return -EFAULT;
 	}
 
@@ -763,9 +763,9 @@ static int hw_crypt_noxts(struct cryp_ctx *ctx,
 
 	ctx->outlen = ctx->datalen;
 
-	if (unlikely(!IS_ALIGNED((u32)indata, 4))) {
+	if (unlikely(!IS_ALIGNED((unsigned long)indata, 4))) {
 		pr_debug(DEV_DBG_NAME " [%s]: Data isn't aligned! Addr: "
-			 "0x%08x", __func__, (u32)indata);
+			 "0x%08lx", __func__, (unsigned long)indata);
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index f1ebc3dfa21e..c172a6953477 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -806,7 +806,7 @@ static int hash_process_data(struct hash_device_data *device_data,
 			 * HW peripheral, otherwise we first copy data
 			 * to a local buffer
 			 */
-			if ((0 == (((u32)data_buffer) % 4)) &&
+			if (IS_ALIGNED((unsigned long)data_buffer, 4) &&
 			    (0 == *index))
 				hash_processblock(device_data,
 						  (const u32 *)data_buffer,
@@ -864,7 +864,8 @@ static int hash_dma_final(struct ahash_request *req)
 	if (ret)
 		return ret;
 
-	dev_dbg(device_data->dev, "%s: (ctx=0x%x)!\n", __func__, (u32) ctx);
+	dev_dbg(device_data->dev, "%s: (ctx=0x%lx)!\n", __func__,
+		(unsigned long)ctx);
 
 	if (req_ctx->updated) {
 		ret = hash_resume_state(device_data, &device_data->state);
@@ -969,7 +970,8 @@ static int hash_hw_final(struct ahash_request *req)
 	if (ret)
 		return ret;
 
-	dev_dbg(device_data->dev, "%s: (ctx=0x%x)!\n", __func__, (u32) ctx);
+	dev_dbg(device_data->dev, "%s: (ctx=0x%lx)!\n", __func__,
+		(unsigned long)ctx);
 
 	if (req_ctx->updated) {
 		ret = hash_resume_state(device_data, &device_data->state);
@@ -1272,8 +1274,8 @@ void hash_get_digest(struct hash_device_data *device_data,
 	else
 		loop_ctr = SHA256_DIGEST_SIZE / sizeof(u32);
 
-	dev_dbg(device_data->dev, "%s: digest array:(0x%x)\n",
-		__func__, (u32) digest);
+	dev_dbg(device_data->dev, "%s: digest array:(0x%lx)\n",
+		__func__, (unsigned long)digest);
 
 	/* Copy result into digest array */
 	for (count = 0; count < loop_ctr; count++) {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
