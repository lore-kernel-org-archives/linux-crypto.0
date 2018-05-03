From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 4.9.y, 4.14.y] crypto: talitos - fix IPsec cipher in length
Date: Thu,  3 May 2018 12:05:13 +0300
Message-ID: <20180503090513.7412-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

commit 2b1227301a8e4729409694e323b72c064c47cb6b upstream.

For SEC 2.x+, cipher in length must contain only the ciphertext length.
In case of using hardware ICV checking, the ICV length is provided via
the "extent" field of the descriptor pointer.

Cc: <stable@vger.kernel.org> # 4.8+
Fixes: 549bd8bc5987 ("crypto: talitos - Implement AEAD for SEC1 using HMAC_SNOOP_NO_AFEU")
Reported-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Tested-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[backported to 4.9.y, 4.14.y]
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
The upstream fix has already been applied "as is" on 4.15.y.
Submitting this backport since it failed to apply on 4.9.y and 4.14.y.

 drivers/crypto/talitos.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 42c060c7ae15..7c71722be395 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1116,10 +1116,10 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 	return count;
 }
 
-int talitos_sg_map(struct device *dev, struct scatterlist *src,
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
@@ -1130,7 +1130,7 @@ int talitos_sg_map(struct device *dev, struct scatterlist *src,
 	}
 
 	to_talitos_ptr_len(ptr, len, is_sec1);
-	to_talitos_ptr_ext_set(ptr, 0, is_sec1);
+	to_talitos_ptr_ext_set(ptr, elen, is_sec1);
 
 	if (sg_count == 1) {
 		to_talitos_ptr(ptr, sg_dma_address(src) + offset, is_sec1);
@@ -1140,7 +1140,7 @@ int talitos_sg_map(struct device *dev, struct scatterlist *src,
 		to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, is_sec1);
 		return sg_count;
 	}
-	sg_count = sg_to_link_tbl_offset(src, sg_count, offset, len,
+	sg_count = sg_to_link_tbl_offset(src, sg_count, offset, len + elen,
 					 &edesc->link_tbl[tbl_off]);
 	if (sg_count == 1) {
 		/* Only one segment now, so no link tbl needed*/
@@ -1154,6 +1154,15 @@ int talitos_sg_map(struct device *dev, struct scatterlist *src,
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
@@ -1171,7 +1180,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	int tbl_off = 0;
 	int sg_count, ret;
-	int sg_link_tbl_len;
+	int elen = 0;
 	bool sync_needed = false;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
@@ -1225,20 +1234,12 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	 * extent is bytes of HMAC postpended to ciphertext,
 	 * typically 12 for ipsec
 	 */
-	to_talitos_ptr_len(&desc->ptr[4], cryptlen, is_sec1);
-	to_talitos_ptr_ext_set(&desc->ptr[4], 0, is_sec1);
-
-	sg_link_tbl_len = cryptlen;
-
-	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP) {
-		to_talitos_ptr_ext_set(&desc->ptr[4], authsize, is_sec1);
-
-		if (edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV)
-			sg_link_tbl_len += authsize;
-	}
+	if ((desc->hdr & DESC_HDR_TYPE_IPSEC_ESP) &&
+	    (desc->hdr & DESC_HDR_MODE1_MDEU_CICV))
+		elen = authsize;
 
-	ret = talitos_sg_map(dev, areq->src, sg_link_tbl_len, edesc,
-			     &desc->ptr[4], sg_count, areq->assoclen, tbl_off);
+	ret = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[4],
+				 sg_count, areq->assoclen, tbl_off, elen);
 
 	if (ret > 1) {
 		tbl_off += ret;
-- 
2.16.2
