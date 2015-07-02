From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 07/10] crypto: omap-aes: gcm: Add support for unaligned lengths
Date: Thu, 2 Jul 2015 10:48:37 +0530
Message-ID: <1435814320-30347-8-git-send-email-lokeshvutla@ti.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33846 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbbGBFWD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 01:22:03 -0400
In-Reply-To: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Check if the inputs are not aligned, if not process
the input before starting the hw acceleration.
Similarly after completition of hw acceleration.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-aes-gcm.c |   82 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 74 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
index 72815af..9c68ff0 100644
--- a/drivers/crypto/omap-aes-gcm.c
+++ b/drivers/crypto/omap-aes-gcm.c
@@ -48,8 +48,9 @@ static void omap_aes_gcm_finish_req(struct omap_aes_dev *dd, int ret)
 
 static void omap_aes_gcm_done_task(struct omap_aes_dev *dd)
 {
+	void *buf;
 	u8 *tag;
-	int alen, clen, i, ret = 0, nsg;
+	int pages, alen, clen, i, ret = 0, nsg;
 
 	alen = ALIGN(dd->assoc_len, AES_BLOCK_SIZE);
 	clen = ALIGN(dd->total, AES_BLOCK_SIZE);
@@ -65,10 +66,29 @@ static void omap_aes_gcm_done_task(struct omap_aes_dev *dd)
 		omap_aes_crypt_dma_stop(dd);
 	}
 
+	if (dd->sgs_copied & AES_OUT_DATA_COPIED) {
+		buf = sg_virt(&dd->out_sgl);
+		scatterwalk_map_and_copy(buf, dd->orig_out, 0, dd->total, 1);
+
+		pages = get_order(clen);
+		free_pages((unsigned long)buf, pages);
+	}
+
 	if (dd->flags & FLAGS_ENCRYPT)
 		scatterwalk_map_and_copy(dd->ctx->auth_tag, dd->aead_req->dst,
 					 dd->total, dd->authsize, 1);
 
+	if (dd->sgs_copied & AES_ASSOC_DATA_COPIED) {
+		buf = sg_virt(&dd->in_sgl[0]);
+		pages = get_order(alen);
+		free_pages((unsigned long)buf, pages);
+	}
+	if (dd->sgs_copied & AES_IN_DATA_COPIED) {
+		buf = sg_virt(&dd->in_sgl[nsg - 1]);
+		pages = get_order(clen);
+		free_pages((unsigned long)buf, pages);
+	}
+
 	if (!(dd->flags & FLAGS_ENCRYPT)) {
 		tag = (u8 *)dd->ctx->auth_tag;
 		for (i = 0; i < dd->authsize; i++) {
@@ -87,13 +107,14 @@ static int omap_aes_gcm_copy_buffers(struct omap_aes_dev *dd,
 				     struct aead_request *req)
 {
 	void *buf_in;
-	int alen, clen, nsg;
+	int pages, alen, clen, cryptlen, nsg;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	unsigned int authlen = crypto_aead_authsize(aead);
 	u32 dec = !(dd->flags & FLAGS_ENCRYPT);
 
-	alen = req->assoclen;
-	clen = req->cryptlen - (dec * authlen);
+	alen = ALIGN(req->assoclen, AES_BLOCK_SIZE);
+	cryptlen = req->cryptlen - (dec * authlen);
+	clen = ALIGN(cryptlen, AES_BLOCK_SIZE);
 
 	dd->sgs_copied = 0;
 
@@ -101,20 +122,65 @@ static int omap_aes_gcm_copy_buffers(struct omap_aes_dev *dd,
 
 	sg_init_table(dd->in_sgl, nsg);
 	if (req->assoclen) {
-		buf_in = sg_virt(req->assoc);
+		if (omap_aes_check_aligned(req->assoc, req->assoclen)) {
+			dd->sgs_copied |= AES_ASSOC_DATA_COPIED;
+			pages = get_order(alen);
+			buf_in = (void *)__get_free_pages(GFP_ATOMIC, pages);
+			if (!buf_in) {
+				pr_err("Couldn't allocate for unaligncases.\n");
+				return -1;
+			}
+
+			scatterwalk_map_and_copy(buf_in, req->assoc, 0,
+						 req->assoclen, 0);
+			memset(buf_in + req->assoclen, 0, alen - req->assoclen);
+		} else {
+			buf_in = sg_virt(req->assoc);
+		}
 		sg_set_buf(dd->in_sgl, buf_in, alen);
 	}
 
 	if (req->cryptlen) {
-		buf_in = sg_virt(req->src);
+		if (omap_aes_check_aligned(req->src, req->cryptlen)) {
+			dd->sgs_copied |= AES_IN_DATA_COPIED;
+			pages = get_order(clen);
+			buf_in = (void *)__get_free_pages(GFP_ATOMIC, pages);
+			if (!buf_in) {
+				pr_err("Couldn't allocate for unaligncases.\n");
+				return -1;
+			}
+
+			memset(buf_in + cryptlen, 0, clen - cryptlen);
+			scatterwalk_map_and_copy(buf_in, req->src, 0, cryptlen,
+						 0);
+		} else {
+			buf_in = sg_virt(req->src);
+		}
 		sg_set_buf(&dd->in_sgl[nsg - 1], buf_in, clen);
 	}
 
 	dd->in_sg = dd->in_sgl;
-	dd->total = clen;
+	dd->total = cryptlen;
 	dd->assoc_len = req->assoclen;
 	dd->authsize = authlen;
-	dd->out_sg = req->dst;
+
+	if (omap_aes_check_aligned(req->dst, cryptlen)) {
+		pages = get_order(clen);
+
+		buf_in = (void *)__get_free_pages(GFP_ATOMIC, pages);
+
+		if (!buf_in) {
+			pr_err("Couldn't allocate for unaligned cases.\n");
+			return -1;
+		}
+
+		sg_init_one(&dd->out_sgl, buf_in, clen);
+		dd->out_sg = &dd->out_sgl;
+		dd->orig_out = req->dst;
+		dd->sgs_copied |= AES_OUT_DATA_COPIED;
+	} else {
+		dd->out_sg = req->dst;
+	}
 
 	dd->in_sg_len = scatterwalk_bytes_sglen(dd->in_sg, alen + clen);
 	dd->out_sg_len = scatterwalk_bytes_sglen(dd->out_sg, clen);
-- 
1.7.9.5
