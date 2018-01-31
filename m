From: Junaid Shahid <junaids@google.com>
Subject: [PATCH v3 3/4] crypto: aesni - Directly use kmap_atomic instead of scatter_walk object in gcm(aes)
Date: Wed, 31 Jan 2018 12:27:21 -0800
Message-ID: <20180131202722.212273-4-junaids@google.com>
References: <20180131202722.212273-1-junaids@google.com>
Cc: linux-crypto@vger.kernel.org, andreslc@google.com,
        davem@davemloft.net, gthelen@google.com, ebiggers3@gmail.com,
        smueller@chronox.de
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:46476 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbeAaU1a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 15:27:30 -0500
Received: by mail-pg0-f66.google.com with SMTP id s9so10972030pgq.13
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jan 2018 12:27:29 -0800 (PST)
In-Reply-To: <20180131202722.212273-1-junaids@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

gcmaes_crypt uses a scatter_walk object to map and unmap the crypto
request sglists. But the only purpose that appears to serve here is to allow
the D-Cache to be flushed at the end for pages that were used as output.
However, that is not applicable on x86, so we can avoid using the scatter_walk
object for simplicity.

Signed-off-by: Junaid Shahid <junaids@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index c11e531d21dd..9e69e02076d2 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -750,6 +750,11 @@ static bool is_mappable(struct scatterlist *sgl, unsigned long len)
 	       (!PageHighMem(sg_page(sgl)) || sgl->offset + len <= PAGE_SIZE);
 }
 
+static u8 *map_buffer(struct scatterlist *sgl)
+{
+	return kmap_atomic(sg_page(sgl)) + sgl->offset;
+}
+
 /*
  * Maps the sglist buffer and returns a pointer to the mapped buffer in
  * data_buf.
@@ -762,14 +767,12 @@ static bool is_mappable(struct scatterlist *sgl, unsigned long len)
  * the data_buf and the bounce_buf should be freed using kfree().
  */
 static int get_request_buffer(struct scatterlist *sgl,
-			      struct scatter_walk *sg_walk,
 			      unsigned long bounce_buf_size,
 			      u8 **data_buf, u8 **bounce_buf, bool *mapped)
 {
 	if (sg_is_last(sgl) && is_mappable(sgl, sgl->length)) {
 		*mapped = true;
-		scatterwalk_start(sg_walk, sgl);
-		*data_buf = scatterwalk_map(sg_walk);
+		*data_buf = map_buffer(sgl);
 		return 0;
 	}
 
@@ -785,14 +788,10 @@ static int get_request_buffer(struct scatterlist *sgl,
 	return 0;
 }
 
-static void put_request_buffer(u8 *data_buf, unsigned long len, bool mapped,
-			       struct scatter_walk *sg_walk, bool output)
+static void put_request_buffer(u8 *data_buf, bool mapped)
 {
-	if (mapped) {
-		scatterwalk_unmap(data_buf);
-		scatterwalk_advance(sg_walk, len);
-		scatterwalk_done(sg_walk, output, 0);
-	}
+	if (mapped)
+		kunmap_atomic(data_buf);
 }
 
 /*
@@ -809,16 +808,14 @@ static int gcmaes_crypt(struct aead_request *req, unsigned int assoclen,
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
 	unsigned long data_len = req->cryptlen - (decrypt ? auth_tag_len : 0);
-	struct scatter_walk src_sg_walk;
-	struct scatter_walk dst_sg_walk = {};
 	int retval = 0;
 	unsigned long bounce_buf_size = data_len + auth_tag_len + req->assoclen;
 
 	if (auth_tag_len > 16)
 		return -EINVAL;
 
-	retval = get_request_buffer(req->src, &src_sg_walk, bounce_buf_size,
-				    &assoc, &bounce_buf, &src_mapped);
+	retval = get_request_buffer(req->src, bounce_buf_size, &assoc,
+				    &bounce_buf, &src_mapped);
 	if (retval)
 		goto exit;
 
@@ -828,9 +825,8 @@ static int gcmaes_crypt(struct aead_request *req, unsigned int assoclen,
 		dst = src;
 		dst_mapped = src_mapped;
 	} else {
-		retval = get_request_buffer(req->dst, &dst_sg_walk,
-					    bounce_buf_size, &dst, &bounce_buf,
-					    &dst_mapped);
+		retval = get_request_buffer(req->dst, bounce_buf_size, &dst,
+					    &bounce_buf, &dst_mapped);
 		if (retval)
 			goto exit;
 
@@ -866,11 +862,9 @@ static int gcmaes_crypt(struct aead_request *req, unsigned int assoclen,
 					 1);
 exit:
 	if (req->dst != req->src)
-		put_request_buffer(dst - req->assoclen, req->dst->length,
-				   dst_mapped, &dst_sg_walk, true);
+		put_request_buffer(dst - req->assoclen, dst_mapped);
 
-	put_request_buffer(assoc, req->src->length, src_mapped, &src_sg_walk,
-			   false);
+	put_request_buffer(assoc, src_mapped);
 
 	kfree(bounce_buf);
 	return retval;
-- 
2.16.0.rc1.238.g530d649a79-goog
