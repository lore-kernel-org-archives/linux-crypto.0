From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: caam - Clamp AEAD SG list by input length
Date: Mon, 8 Jun 2015 16:38:24 +0800
Message-ID: <20150608083824.GA26193@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Kim Phillips <kim.phillips@freescale.com>,
	Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55427 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbbFHIia (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 04:38:30 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently caam assumes that the SG list contains exactly the number
of bytes required.  This assumption is incorrect.

Up until now this has been harmless.  However with the new AEAD
interface this now breaks as the AD SG list contains more bytes
than just the AD.

This patch fixes this by always clamping the AD SG list by the
specified AD length.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/caam/caamalg.c    |   20 ++++++++------------
 drivers/crypto/caam/sg_sw_sec4.h |   15 +++++++++++++++
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 3d850ab..3c37fe6 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2713,10 +2713,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	sec4_sg_index = 0;
 	if (!all_contig) {
 		if (!is_gcm) {
-			sg_to_sec4_sg(req->assoc,
-				      assoc_nents,
-				      edesc->sec4_sg +
-				      sec4_sg_index, 0);
+			sg_to_sec4_sg_len(req->assoc, req->assoclen,
+					  edesc->sec4_sg + sec4_sg_index);
 			sec4_sg_index += assoc_nents;
 		}
 
@@ -2725,10 +2723,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		sec4_sg_index += 1;
 
 		if (is_gcm) {
-			sg_to_sec4_sg(req->assoc,
-				      assoc_nents,
-				      edesc->sec4_sg +
-				      sec4_sg_index, 0);
+			sg_to_sec4_sg_len(req->assoc, req->assoclen,
+					  edesc->sec4_sg + sec4_sg_index);
 			sec4_sg_index += assoc_nents;
 		}
 
@@ -2953,8 +2949,8 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 	sec4_sg_index = 0;
 	if (!(contig & GIV_SRC_CONTIG)) {
 		if (!is_gcm) {
-			sg_to_sec4_sg(req->assoc, assoc_nents,
-				      edesc->sec4_sg + sec4_sg_index, 0);
+			sg_to_sec4_sg_len(req->assoc, req->assoclen,
+					  edesc->sec4_sg + sec4_sg_index);
 			sec4_sg_index += assoc_nents;
 		}
 
@@ -2963,8 +2959,8 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 		sec4_sg_index += 1;
 
 		if (is_gcm) {
-			sg_to_sec4_sg(req->assoc, assoc_nents,
-				      edesc->sec4_sg + sec4_sg_index, 0);
+			sg_to_sec4_sg_len(req->assoc, req->assoclen,
+					  edesc->sec4_sg + sec4_sg_index);
 			sec4_sg_index += assoc_nents;
 		}
 
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index 3b91821..efbc1db 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -55,6 +55,21 @@ static inline void sg_to_sec4_sg_last(struct scatterlist *sg, int sg_count,
 	sec4_sg_ptr->len |= SEC4_SG_LEN_FIN;
 }
 
+static inline struct sec4_sg_entry *sg_to_sec4_sg_len(
+	struct scatterlist *sg, unsigned int total,
+	struct sec4_sg_entry *sec4_sg_ptr)
+{
+	do {
+		unsigned int len = min(sg_dma_len(sg), total);
+
+		dma_to_sec4_sg_one(sec4_sg_ptr, sg_dma_address(sg), len, 0);
+		sec4_sg_ptr++;
+		sg = sg_next(sg);
+		total -= len;
+	} while (total);
+	return sec4_sg_ptr - 1;
+}
+
 /* count number of elements in scatterlist */
 static inline int __sg_count(struct scatterlist *sg_list, int nbytes,
 			     bool *chained)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
