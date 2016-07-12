From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 20/30] crypto: omap - Stop using crypto scatterwalk_bytes_sglen
Date: Tue, 12 Jul 2016 13:17:52 +0800
Message-ID: <E1bMq4u-0007TG-Rm@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41148 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955AbcGLFR4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:56 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4v-0004fG-0T
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:53 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We already have a generic function sg_nents_for_len which does
the same thing.  This patch switches omap over to it and also
adds error handling in case the SG list is short.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/omap-aes.c |   16 ++++++++++------
 drivers/crypto/omap-des.c |   14 ++++++++++----
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 8178632..4ab53a6 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -578,10 +578,12 @@ static int omap_aes_copy_sgs(struct omap_aes_dev *dd)
 	sg_init_table(&dd->in_sgl, 1);
 	sg_set_buf(&dd->in_sgl, buf_in, total);
 	dd->in_sg = &dd->in_sgl;
+	dd->in_sg_len = 1;
 
 	sg_init_table(&dd->out_sgl, 1);
 	sg_set_buf(&dd->out_sgl, buf_out, total);
 	dd->out_sg = &dd->out_sgl;
+	dd->out_sg_len = 1;
 
 	return 0;
 }
@@ -602,7 +604,6 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_aes_dev *dd = omap_aes_find_dev(ctx);
 	struct omap_aes_reqctx *rctx;
-	int len;
 
 	if (!dd)
 		return -ENODEV;
@@ -614,6 +615,14 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
 	dd->in_sg = req->src;
 	dd->out_sg = req->dst;
 
+	dd->in_sg_len = sg_nents_for_len(dd->in_sg, dd->total);
+	if (dd->in_sg_len < 0)
+		return dd->in_sg_len;
+
+	dd->out_sg_len = sg_nents_for_len(dd->out_sg, dd->total);
+	if (dd->out_sg_len < 0)
+		return dd->out_sg_len;
+
 	if (omap_aes_check_aligned(dd->in_sg, dd->total) ||
 	    omap_aes_check_aligned(dd->out_sg, dd->total)) {
 		if (omap_aes_copy_sgs(dd))
@@ -623,11 +632,6 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
 		dd->sgs_copied = 0;
 	}
 
-	len = ALIGN(dd->total, AES_BLOCK_SIZE);
-	dd->in_sg_len = scatterwalk_bytes_sglen(dd->in_sg, len);
-	dd->out_sg_len = scatterwalk_bytes_sglen(dd->out_sg, len);
-	BUG_ON(dd->in_sg_len < 0 || dd->out_sg_len < 0);
-
 	rctx = ablkcipher_request_ctx(req);
 	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
 	rctx->mode &= FLAGS_MODE_MASK;
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 3eedb03..5691434 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -560,10 +560,12 @@ static int omap_des_copy_sgs(struct omap_des_dev *dd)
 	sg_init_table(&dd->in_sgl, 1);
 	sg_set_buf(&dd->in_sgl, buf_in, dd->total);
 	dd->in_sg = &dd->in_sgl;
+	dd->in_sg_len = 1;
 
 	sg_init_table(&dd->out_sgl, 1);
 	sg_set_buf(&dd->out_sgl, buf_out, dd->total);
 	dd->out_sg = &dd->out_sgl;
+	dd->out_sg_len = 1;
 
 	return 0;
 }
@@ -595,6 +597,14 @@ static int omap_des_prepare_req(struct crypto_engine *engine,
 	dd->in_sg = req->src;
 	dd->out_sg = req->dst;
 
+	dd->in_sg_len = sg_nents_for_len(dd->in_sg, dd->total);
+	if (dd->in_sg_len < 0)
+		return dd->in_sg_len;
+
+	dd->out_sg_len = sg_nents_for_len(dd->out_sg, dd->total);
+	if (dd->out_sg_len < 0)
+		return dd->out_sg_len;
+
 	if (omap_des_copy_needed(dd->in_sg) ||
 	    omap_des_copy_needed(dd->out_sg)) {
 		if (omap_des_copy_sgs(dd))
@@ -604,10 +614,6 @@ static int omap_des_prepare_req(struct crypto_engine *engine,
 		dd->sgs_copied = 0;
 	}
 
-	dd->in_sg_len = scatterwalk_bytes_sglen(dd->in_sg, dd->total);
-	dd->out_sg_len = scatterwalk_bytes_sglen(dd->out_sg, dd->total);
-	BUG_ON(dd->in_sg_len < 0 || dd->out_sg_len < 0);
-
 	rctx = ablkcipher_request_ctx(req);
 	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
 	rctx->mode &= FLAGS_MODE_MASK;
