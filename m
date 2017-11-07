From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 5/8] staging: ccree: fold common code into function
Date: Tue,  7 Nov 2017 09:40:01 +0000
Message-ID: <1510047606-5589-6-git-send-email-gilad@benyossef.com>
References: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Fold common code copying MAC to/from a temp. buffer
into an inline function instead of keeping multiple
open coded versions of same.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 92 ++++++++++++++--------------------
 1 file changed, 38 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index b3ca249..f3076f3 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -65,6 +65,27 @@ struct buffer_array {
 };
 
 /**
+ * cc_copy_mac() - Copy MAC to temporary location
+ *
+ * @dev: device object
+ * @req: aead request object
+ * @dir: [IN] copy from/to sgl
+ */
+static inline void cc_copy_mac(struct device *dev, struct aead_request *req,
+			       enum ssi_sg_cpy_direct dir)
+{
+	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	u32 skip = req->assoclen + req->cryptlen;
+
+	if (areq_ctx->is_gcm4543)
+		skip += crypto_aead_ivsize(tfm);
+
+	cc_copy_sg_portion(dev, areq_ctx->backup_mac, req->src,
+			   (skip - areq_ctx->req_authsize), skip, dir);
+}
+
+/**
  * cc_get_sgl_nents() - Get scatterlist number of entries.
  *
  * @sg_list: SG list
@@ -669,21 +690,12 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	}
 	if (drvdata->coherent &&
 	    (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
-	    likely(req->src == req->dst)) {
-		u32 size_to_skip = req->assoclen;
-
-		if (areq_ctx->is_gcm4543)
-			size_to_skip += crypto_aead_ivsize(tfm);
+	    likely(req->src == req->dst))
 
-		/* copy mac to a temporary location to deal with possible
+		/* copy back mac from temporary location to deal with possible
 		 * data memory overriding that caused by cache coherence problem.
 		 */
-		cc_copy_sg_portion(dev, areq_ctx->backup_mac, req->src,
-				   (size_to_skip + req->cryptlen -
-				    areq_ctx->req_authsize),
-				   (size_to_skip + req->cryptlen),
-				   SSI_SG_FROM_BUF);
-	}
+		cc_copy_mac(dev, req, SSI_SG_FROM_BUF);
 }
 
 static inline int cc_get_aead_icv_nents(
@@ -918,7 +930,6 @@ static inline int cc_prepare_aead_data_mlli(
 	enum drv_crypto_direction direct = areq_ctx->gen_ctx.op_type;
 	unsigned int authsize = areq_ctx->req_authsize;
 	int rc = 0, icv_nents;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	if (likely(req->src == req->dst)) {
@@ -943,24 +954,14 @@ static inline int cc_prepare_aead_data_mlli(
 			 * MAC verification upon request completion
 			 */
 			if (direct == DRV_CRYPTO_DIRECTION_DECRYPT) {
-				if (!drvdata->coherent) {
 				/* In coherent platforms (e.g. ACP)
 				 * already copying ICV for any
 				 * INPLACE-DECRYPT operation, hence
 				 * we must neglect this code.
 				 */
-					u32 skip = req->assoclen;
-
-					if (areq_ctx->is_gcm4543)
-						skip += crypto_aead_ivsize(tfm);
-
-					cc_copy_sg_portion(dev,
-							   areq_ctx->backup_mac,
-							   req->src,
-							   (skip + req->cryptlen - areq_ctx->req_authsize),
-							   (skip + req->cryptlen),
-							   SSI_SG_TO_BUF);
-				}
+				if (!drvdata->coherent)
+					cc_copy_mac(dev, req, SSI_SG_TO_BUF);
+
 				areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
 			} else {
 				areq_ctx->icv_virt_addr = areq_ctx->mac_buf;
@@ -996,22 +997,14 @@ static inline int cc_prepare_aead_data_mlli(
 			goto prepare_data_mlli_exit;
 		}
 
+		/* Backup happens only when ICV is fragmented, ICV
+		 * verification is made by CPU compare in order to simplify
+		 * MAC verification upon request completion
+		 */
 		if (unlikely(areq_ctx->is_icv_fragmented)) {
-			/* Backup happens only when ICV is fragmented, ICV
-			 * verification is made by CPU compare in order to simplify
-			 * MAC verification upon request completion
-			 */
-			u32 size_to_skip = req->assoclen;
-
-			if (areq_ctx->is_gcm4543)
-				size_to_skip += crypto_aead_ivsize(tfm);
-
-			  cc_copy_sg_portion(dev, areq_ctx->backup_mac,
-					     req->src,
-					     (size_to_skip + req->cryptlen - areq_ctx->req_authsize),
-					     (size_to_skip + req->cryptlen),
-					     SSI_SG_TO_BUF);
+			cc_copy_mac(dev, req, SSI_SG_TO_BUF);
 			areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
+
 		} else { /* Contig. ICV */
 			/*Should hanlde if the sg is not contig.*/
 			areq_ctx->icv_dma_addr = sg_dma_address(
@@ -1249,22 +1242,13 @@ int cc_map_aead_request(
 	mlli_params->curr_pool = NULL;
 	sg_data.num_of_buffers = 0;
 
+	/* copy mac to a temporary location to deal with possible
+	 * data memory overriding that caused by cache coherence problem.
+	 */
 	if (drvdata->coherent &&
 	    (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) &&
-	    likely(req->src == req->dst)) {
-		u32 size_to_skip = req->assoclen;
-
-		if (is_gcm4543)
-			size_to_skip += crypto_aead_ivsize(tfm);
-
-		/* copy mac to a temporary location to deal with possible
-		 * data memory overriding that caused by cache coherence problem.
-		 */
-		cc_copy_sg_portion(dev, areq_ctx->backup_mac, req->src,
-				   (size_to_skip + req->cryptlen - areq_ctx->req_authsize),
-				   (size_to_skip + req->cryptlen),
-				   SSI_SG_TO_BUF);
-	}
+	    likely(req->src == req->dst))
+		cc_copy_mac(dev, req, SSI_SG_TO_BUF);
 
 	/* cacluate the size for cipher remove ICV in decrypt*/
 	areq_ctx->cryptlen = (areq_ctx->gen_ctx.op_type ==
-- 
2.7.4
