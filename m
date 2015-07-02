From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 06/10] crypto: omap-aes: gcm: Handle inputs properly
Date: Thu, 2 Jul 2015 10:48:36 +0530
Message-ID: <1435814320-30347-7-git-send-email-lokeshvutla@ti.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Its not necessary that assoc data and plain text is passed always.
Add these checks before processing the input.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-aes-gcm.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
index 1be9d91..72815af 100644
--- a/drivers/crypto/omap-aes-gcm.c
+++ b/drivers/crypto/omap-aes-gcm.c
@@ -87,7 +87,7 @@ static int omap_aes_gcm_copy_buffers(struct omap_aes_dev *dd,
 				     struct aead_request *req)
 {
 	void *buf_in;
-	int alen, clen;
+	int alen, clen, nsg;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	unsigned int authlen = crypto_aead_authsize(aead);
 	u32 dec = !(dd->flags & FLAGS_ENCRYPT);
@@ -97,12 +97,18 @@ static int omap_aes_gcm_copy_buffers(struct omap_aes_dev *dd,
 
 	dd->sgs_copied = 0;
 
-	sg_init_table(dd->in_sgl, 2);
-	buf_in = sg_virt(req->assoc);
-	sg_set_buf(dd->in_sgl, buf_in, alen);
+	nsg = 1 + !!(req->assoclen && req->cryptlen);
 
-	buf_in = sg_virt(req->src);
-	sg_set_buf(&dd->in_sgl[1], buf_in, clen);
+	sg_init_table(dd->in_sgl, nsg);
+	if (req->assoclen) {
+		buf_in = sg_virt(req->assoc);
+		sg_set_buf(dd->in_sgl, buf_in, alen);
+	}
+
+	if (req->cryptlen) {
+		buf_in = sg_virt(req->src);
+		sg_set_buf(&dd->in_sgl[nsg - 1], buf_in, clen);
+	}
 
 	dd->in_sg = dd->in_sgl;
 	dd->total = clen;
@@ -258,6 +264,8 @@ static int omap_aes_gcm_crypt(struct aead_request *req, unsigned long mode)
 {
 	struct omap_aes_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct omap_aes_reqctx *rctx = aead_request_ctx(req);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	unsigned int authlen = crypto_aead_authsize(aead);
 	struct omap_aes_dev *dd;
 	__be32 counter = cpu_to_be32(1);
 	int err;
@@ -270,6 +278,12 @@ static int omap_aes_gcm_crypt(struct aead_request *req, unsigned long mode)
 	if (err)
 		return err;
 
+	if (req->assoclen + req->cryptlen == 0) {
+		scatterwalk_map_and_copy(ctx->auth_tag, req->dst, 0, authlen,
+					 1);
+		return 0;
+	}
+
 	dd = omap_aes_find_dev(ctx);
 	if (!dd)
 		return -ENODEV;
-- 
1.7.9.5
