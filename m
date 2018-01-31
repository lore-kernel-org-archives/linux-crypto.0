From: Junaid Shahid <junaids@google.com>
Subject: [PATCH v3 4/4] crypto: aesni - Use zero-copy for gcm(aes) even if the AAD/Data/AuthTag are separate
Date: Wed, 31 Jan 2018 12:27:22 -0800
Message-ID: <20180131202722.212273-5-junaids@google.com>
References: <20180131202722.212273-1-junaids@google.com>
Cc: linux-crypto@vger.kernel.org, andreslc@google.com,
        davem@davemloft.net, gthelen@google.com, ebiggers3@gmail.com,
        smueller@chronox.de
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:45869 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751579AbeAaU1a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 15:27:30 -0500
Received: by mail-pf0-f195.google.com with SMTP id a88so13831496pfe.12
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jan 2018 12:27:30 -0800 (PST)
In-Reply-To: <20180131202722.212273-1-junaids@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enable the use of zero-copy even if the AAD and/or Auth Tag are in different
buffers than the actual data, as long as each of them individually satisfies
the zero-copy conditions (i.e. the entire buffer is either in low-mem or
within a single high-mem page).

Signed-off-by: Junaid Shahid <junaids@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 121 +++++++++++++++++++++++++++----------
 1 file changed, 89 insertions(+), 32 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 9e69e02076d2..7cebc99a0405 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -756,42 +756,91 @@ static u8 *map_buffer(struct scatterlist *sgl)
 }
 
 /*
- * Maps the sglist buffer and returns a pointer to the mapped buffer in
- * data_buf.
+ * Maps the sglist buffer and returns pointers to the mapped buffers in assoc,
+ * data and (optionally) auth_tag.
  *
  * If direct mapping is not feasible, then allocates a bounce buffer if one
- * isn't already available in bounce_buf, and returns a pointer to the bounce
- * buffer in data_buf.
+ * isn't already available in bounce_buf, and returns pointers within the bounce
+ * buffer in assoc, data and auth_tag.
  *
- * When the buffer is no longer needed, put_request_buffer() should be called on
- * the data_buf and the bounce_buf should be freed using kfree().
+ * When the buffers are no longer needed, put_request_buffers() should be called
+ * and the bounce_buf should be freed using kfree().
  */
-static int get_request_buffer(struct scatterlist *sgl,
-			      unsigned long bounce_buf_size,
-			      u8 **data_buf, u8 **bounce_buf, bool *mapped)
+static int get_request_buffers(struct scatterlist *sgl,
+			       unsigned long assoc_len, unsigned long data_len,
+			       unsigned long auth_tag_len,
+			       u8 **assoc, u8 **data, u8 **auth_tag,
+			       u8 **bounce_buf, bool *mapped)
 {
-	if (sg_is_last(sgl) && is_mappable(sgl, sgl->length)) {
+	struct scatterlist sgl_data_chain[2], sgl_auth_tag_chain[2];
+	struct scatterlist *sgl_data, *sgl_auth_tag;
+
+	sgl_data = scatterwalk_ffwd(sgl_data_chain, sgl, assoc_len);
+	sgl_auth_tag = scatterwalk_ffwd(sgl_auth_tag_chain, sgl,
+					assoc_len + data_len);
+
+	if (is_mappable(sgl, assoc_len) && is_mappable(sgl_data, data_len) &&
+	    (auth_tag == NULL || is_mappable(sgl_auth_tag, auth_tag_len))) {
 		*mapped = true;
-		*data_buf = map_buffer(sgl);
+
+		*assoc = map_buffer(sgl);
+
+		if (sgl->length >= assoc_len + data_len)
+			*data = *assoc + assoc_len;
+		else
+			*data = map_buffer(sgl_data);
+
+		if (auth_tag != NULL) {
+			if (sgl_data->length >= data_len + auth_tag_len)
+				*auth_tag = *data + data_len;
+			else
+				*auth_tag = map_buffer(sgl_auth_tag);
+		}
+
 		return 0;
 	}
 
 	*mapped = false;
 
 	if (*bounce_buf == NULL) {
-		*bounce_buf = kmalloc(bounce_buf_size, GFP_ATOMIC);
+		*bounce_buf = kmalloc(assoc_len + data_len + auth_tag_len,
+				      GFP_ATOMIC);
 		if (unlikely(*bounce_buf == NULL))
 			return -ENOMEM;
 	}
 
-	*data_buf = *bounce_buf;
+	*assoc = *bounce_buf;
+	*data = *assoc + assoc_len;
+
+	if (auth_tag != NULL)
+		*auth_tag = *data + data_len;
+
 	return 0;
 }
 
-static void put_request_buffer(u8 *data_buf, bool mapped)
+static void put_request_buffers(struct scatterlist *sgl, bool mapped,
+				u8 *assoc, u8 *data, u8 *auth_tag,
+				unsigned long assoc_len,
+				unsigned long data_len,
+				unsigned long auth_tag_len)
 {
-	if (mapped)
-		kunmap_atomic(data_buf);
+	struct scatterlist sgl_data_chain[2];
+	struct scatterlist *sgl_data;
+
+	if (!mapped)
+		return;
+
+	sgl_data = scatterwalk_ffwd(sgl_data_chain, sgl, assoc_len);
+
+	/* The unmaps need to be done in reverse order of the maps. */
+
+	if (auth_tag != NULL && sgl_data->length < data_len + auth_tag_len)
+		kunmap_atomic(auth_tag);
+
+	if (sgl->length < assoc_len + data_len)
+		kunmap_atomic(data);
+
+	kunmap_atomic(assoc);
 }
 
 /*
@@ -803,34 +852,38 @@ static void put_request_buffer(u8 *data_buf, bool mapped)
 static int gcmaes_crypt(struct aead_request *req, unsigned int assoclen,
 			u8 *hash_subkey, u8 *iv, void *aes_ctx, bool decrypt)
 {
-	u8 *src, *dst, *assoc, *bounce_buf = NULL;
+	u8 *src, *src_assoc;
+	u8 *dst, *dst_assoc;
+	u8 *auth_tag;
+	u8 *bounce_buf = NULL;
 	bool src_mapped = false, dst_mapped = false;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
 	unsigned long data_len = req->cryptlen - (decrypt ? auth_tag_len : 0);
 	int retval = 0;
-	unsigned long bounce_buf_size = data_len + auth_tag_len + req->assoclen;
 
 	if (auth_tag_len > 16)
 		return -EINVAL;
 
-	retval = get_request_buffer(req->src, bounce_buf_size, &assoc,
-				    &bounce_buf, &src_mapped);
+	retval = get_request_buffers(req->src, req->assoclen, data_len,
+				     auth_tag_len, &src_assoc, &src,
+				     (decrypt || req->src == req->dst)
+				     ? &auth_tag : NULL,
+				     &bounce_buf, &src_mapped);
 	if (retval)
 		goto exit;
 
-	src = assoc + req->assoclen;
-
 	if (req->src == req->dst) {
+		dst_assoc = src_assoc;
 		dst = src;
 		dst_mapped = src_mapped;
 	} else {
-		retval = get_request_buffer(req->dst, bounce_buf_size, &dst,
-					    &bounce_buf, &dst_mapped);
+		retval = get_request_buffers(req->dst, req->assoclen, data_len,
+					     auth_tag_len, &dst_assoc, &dst,
+					     decrypt ? NULL : &auth_tag,
+					     &bounce_buf, &dst_mapped);
 		if (retval)
 			goto exit;
-
-		dst += req->assoclen;
 	}
 
 	if (!src_mapped)
@@ -843,16 +896,16 @@ static int gcmaes_crypt(struct aead_request *req, unsigned int assoclen,
 		u8 gen_auth_tag[16];
 
 		aesni_gcm_dec_tfm(aes_ctx, dst, src, data_len, iv,
-				  hash_subkey, assoc, assoclen,
+				  hash_subkey, src_assoc, assoclen,
 				  gen_auth_tag, auth_tag_len);
 		/* Compare generated tag with passed in tag. */
-		if (crypto_memneq(src + data_len, gen_auth_tag, auth_tag_len))
+		if (crypto_memneq(auth_tag, gen_auth_tag, auth_tag_len))
 			retval = -EBADMSG;
 
 	} else
 		aesni_gcm_enc_tfm(aes_ctx, dst, src, data_len, iv,
-				  hash_subkey, assoc, assoclen,
-				  dst + data_len, auth_tag_len);
+				  hash_subkey, src_assoc, assoclen,
+				  auth_tag, auth_tag_len);
 
 	kernel_fpu_end();
 
@@ -862,9 +915,13 @@ static int gcmaes_crypt(struct aead_request *req, unsigned int assoclen,
 					 1);
 exit:
 	if (req->dst != req->src)
-		put_request_buffer(dst - req->assoclen, dst_mapped);
+		put_request_buffers(req->dst, dst_mapped, dst_assoc, dst,
+				    decrypt ? NULL : auth_tag,
+				    req->assoclen, data_len, auth_tag_len);
 
-	put_request_buffer(assoc, src_mapped);
+	put_request_buffers(req->src, src_mapped, src_assoc, src,
+			    (decrypt || req->src == req->dst) ? auth_tag : NULL,
+			    req->assoclen, data_len, auth_tag_len);
 
 	kfree(bounce_buf);
 	return retval;
-- 
2.16.0.rc1.238.g530d649a79-goog
