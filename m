Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E29AC38142
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjAaIDE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjAaICq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:02:46 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFB84109B
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:02:28 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlaz-005voU-HY; Tue, 31 Jan 2023 16:02:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:02:25 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:02:25 +0800
Subject: [PATCH 20/32] crypto: hisilicon - Use request_complete helpers
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
Message-Id: <E1pMlaz-005voU-HY@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the request_complete helpers instead of calling the completion
function directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/hisilicon/sec/sec_algs.c    |    6 +++---
 drivers/crypto/hisilicon/sec2/sec_crypto.c |   10 ++++------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 490e1542305e..1189effcdad0 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -504,8 +504,8 @@ static void sec_skcipher_alg_callback(struct sec_bd_info *sec_resp,
 		     kfifo_avail(&ctx->queue->softqueue) >
 		     backlog_req->num_elements)) {
 			sec_send_request(backlog_req, ctx->queue);
-			backlog_req->req_base->complete(backlog_req->req_base,
-							-EINPROGRESS);
+			crypto_request_complete(backlog_req->req_base,
+						-EINPROGRESS);
 			list_del(&backlog_req->backlog_head);
 		}
 	}
@@ -534,7 +534,7 @@ static void sec_skcipher_alg_callback(struct sec_bd_info *sec_resp,
 		if (skreq->src != skreq->dst)
 			dma_unmap_sg(dev, skreq->dst, sec_req->len_out,
 				     DMA_BIDIRECTIONAL);
-		skreq->base.complete(&skreq->base, sec_req->err);
+		skcipher_request_complete(skreq, sec_req->err);
 	}
 }
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index f5bfc9755a4a..074e50ef512c 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1459,12 +1459,11 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req,
 			break;
 
 		backlog_sk_req = backlog_req->c_req.sk_req;
-		backlog_sk_req->base.complete(&backlog_sk_req->base,
-						-EINPROGRESS);
+		skcipher_request_complete(backlog_sk_req, -EINPROGRESS);
 		atomic64_inc(&ctx->sec->debug.dfx.recv_busy_cnt);
 	}
 
-	sk_req->base.complete(&sk_req->base, err);
+	skcipher_request_complete(sk_req, err);
 }
 
 static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
@@ -1736,12 +1735,11 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 			break;
 
 		backlog_aead_req = backlog_req->aead_req.aead_req;
-		backlog_aead_req->base.complete(&backlog_aead_req->base,
-						-EINPROGRESS);
+		aead_request_complete(backlog_aead_req, -EINPROGRESS);
 		atomic64_inc(&c->sec->debug.dfx.recv_busy_cnt);
 	}
 
-	a_req->base.complete(&a_req->base, err);
+	aead_request_complete(a_req, err);
 }
 
 static void sec_request_uninit(struct sec_ctx *ctx, struct sec_req *req)
