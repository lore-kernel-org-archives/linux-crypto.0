Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D02AC636CC
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjAaIC5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjAaIC0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:02:26 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0990E42BEE
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:02:22 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlat-005vmv-9T; Tue, 31 Jan 2023 16:02:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:02:19 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:02:19 +0800
Subject: [PATCH 17/32] crypto: ccp - Use request_complete helpers
References: <Y9jKmRsdHsIwfFLo@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        linux-arm-kernel@axis.com,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        George Cherian <gcherian@marvell.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Kai Ye <yekai13@huawei.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        qat-linux@intel.com, Thara Gopinath <thara.gopinath@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Message-Id: <E1pMlat-005vmv-9T@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the request_complete helpers instead of calling the completion
function directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ccp/ccp-crypto-main.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 73442a382f68..ecd58b38c46e 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -146,7 +146,7 @@ static void ccp_crypto_complete(void *data, int err)
 		/* Only propagate the -EINPROGRESS if necessary */
 		if (crypto_cmd->ret == -EBUSY) {
 			crypto_cmd->ret = -EINPROGRESS;
-			req->complete(req, -EINPROGRESS);
+			crypto_request_complete(req, -EINPROGRESS);
 		}
 
 		return;
@@ -159,18 +159,18 @@ static void ccp_crypto_complete(void *data, int err)
 	held = ccp_crypto_cmd_complete(crypto_cmd, &backlog);
 	if (backlog) {
 		backlog->ret = -EINPROGRESS;
-		backlog->req->complete(backlog->req, -EINPROGRESS);
+		crypto_request_complete(backlog->req, -EINPROGRESS);
 	}
 
 	/* Transition the state from -EBUSY to -EINPROGRESS first */
 	if (crypto_cmd->ret == -EBUSY)
-		req->complete(req, -EINPROGRESS);
+		crypto_request_complete(req, -EINPROGRESS);
 
 	/* Completion callbacks */
 	ret = err;
 	if (ctx->complete)
 		ret = ctx->complete(req, ret);
-	req->complete(req, ret);
+	crypto_request_complete(req, ret);
 
 	/* Submit the next cmd */
 	while (held) {
@@ -186,12 +186,12 @@ static void ccp_crypto_complete(void *data, int err)
 		ctx = crypto_tfm_ctx_dma(held->req->tfm);
 		if (ctx->complete)
 			ret = ctx->complete(held->req, ret);
-		held->req->complete(held->req, ret);
+		crypto_request_complete(held->req, ret);
 
 		next = ccp_crypto_cmd_complete(held, &backlog);
 		if (backlog) {
 			backlog->ret = -EINPROGRESS;
-			backlog->req->complete(backlog->req, -EINPROGRESS);
+			crypto_request_complete(backlog->req, -EINPROGRESS);
 		}
 
 		kfree(held);
