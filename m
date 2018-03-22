From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2] crypto: talitos - fix IPsec cipher in length
Date: Thu, 22 Mar 2018 10:57:01 +0100 (CET)
Message-ID: <20180322095701.4563E6F352@po15720vm.idsi0.si.c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

For SEC 2.x+, cipher in length must contain only the ciphertext length.
In case of using hardware ICV checking, the ICV length is provided via
the "extent" field of the descriptor pointer.

Cc: <stable@vger.kernel.org> # 4.8+
Fixes: 549bd8bc5987 ("crypto: talitos - Implement AEAD for SEC1 using HMAC_SNOOP_NO_AFEU")
Reported-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6882fa2f8bad..016ff8c4c305 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1130,10 +1130,10 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 	return count;
 }
 
-static int talitos_sg_map(struct device *dev, struct scatterlist *src,
-		   unsigned int len, struct talitos_edesc *edesc,
-		   struct talitos_ptr *ptr,
-		   int sg_count, unsigned int offset, int tbl_off)
+static int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
+			      unsigned int len, struct talitos_edesc *edesc,
+			      struct talitos_ptr *ptr, int sg_count,
+			      unsigned int offset, int tbl_off, int elen)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
@@ -1142,6 +1142,7 @@ static int talitos_sg_map(struct device *dev, struct scatterlist *src,
 		to_talitos_ptr(ptr, 0, 0, is_sec1);
 		return 1;
 	}
+	to_talitos_ptr_ext_set(ptr, elen, is_sec1);
 	if (sg_count == 1) {
 		to_talitos_ptr(ptr, sg_dma_address(src) + offset, len, is_sec1);
 		return sg_count;
@@ -1150,7 +1151,7 @@ static int talitos_sg_map(struct device *dev, struct scatterlist *src,
 		to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, len, is_sec1);
 		return sg_count;
 	}
-	sg_count = sg_to_link_tbl_offset(src, sg_count, offset, len,
+	sg_count = sg_to_link_tbl_offset(src, sg_count, offset, len + elen,
 					 &edesc->link_tbl[tbl_off]);
 	if (sg_count == 1) {
 		/* Only one segment now, so no link tbl needed*/
@@ -1164,6 +1165,15 @@ static int talitos_sg_map(struct device *dev, struct scatterlist *src,
 	return sg_count;
 }
 
+static int talitos_sg_map(struct device *dev, struct scatterlist *src,
+			  unsigned int len, struct talitos_edesc *edesc,
+			  struct talitos_ptr *ptr, int sg_count,
+			  unsigned int offset, int tbl_off)
+{
+	return talitos_sg_map_ext(dev, src, len, edesc, ptr, sg_count, offset,
+				  tbl_off, 0);
+}
+
 /*
  * fill in and submit ipsec_esp descriptor
  */
@@ -1181,7 +1191,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	int tbl_off = 0;
 	int sg_count, ret;
-	int sg_link_tbl_len;
+	int elen = 0;
 	bool sync_needed = false;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
@@ -1223,17 +1233,11 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	 * extent is bytes of HMAC postpended to ciphertext,
 	 * typically 12 for ipsec
 	 */
-	sg_link_tbl_len = cryptlen;
-
-	if (is_ipsec_esp) {
-		to_talitos_ptr_ext_set(&desc->ptr[4], authsize, is_sec1);
-
-		if (desc->hdr & DESC_HDR_MODE1_MDEU_CICV)
-			sg_link_tbl_len += authsize;
-	}
+	if (is_ipsec_esp && (desc->hdr & DESC_HDR_MODE1_MDEU_CICV))
+		elen = authsize;
 
-	ret = talitos_sg_map(dev, areq->src, sg_link_tbl_len, edesc,
-			     &desc->ptr[4], sg_count, areq->assoclen, tbl_off);
+	ret = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[4],
+				 sg_count, areq->assoclen, tbl_off, elen);
 
 	if (ret > 1) {
 		tbl_off += ret;
-- 
2.13.3
