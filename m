From: Junaid Shahid <junaids@google.com>
Subject: [PATCH 2/4] crypto: aesni - Enable one-sided zero copy for gcm(aes) request buffers
Date: Mon, 22 Jan 2018 15:04:01 -0800
Message-ID: <20180122230403.52572-3-junaids@google.com>
References: <20180122230403.52572-1-junaids@google.com>
Cc: linux-crypto@vger.kernel.org, andreslc@google.com,
        davem@davemloft.net, gthelen@google.com, ebiggers3@gmail.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35984 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbeAVXEI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jan 2018 18:04:08 -0500
Received: by mail-pg0-f65.google.com with SMTP id k68so8267249pga.3
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jan 2018 15:04:08 -0800 (PST)
In-Reply-To: <20180122230403.52572-1-junaids@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

gcmaes_encrypt/decrypt perform zero-copy crypto if both the source and
destination satisfy certain conditions (single sglist entry located in
low-mem or within a single high-mem page). But two copies are done
otherwise, even if one of source or destination still satisfies the
zero-copy conditions. This optimization is now extended to avoid the
copy on the side that does satisfy the zero-copy conditions.

Signed-off-by: Junaid Shahid <junaids@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 256 +++++++++++++++++++------------------
 1 file changed, 134 insertions(+), 122 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 3bf3dcf29825..a46eb2d25f71 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -744,136 +744,148 @@ static int generic_gcmaes_set_authsize(struct crypto_aead *tfm,
 	return 0;
 }
 
+static bool is_mappable(struct scatterlist *sgl, unsigned long len)
+{
+	return (!PageHighMem(sg_page(sgl)) || sgl->offset + len <= PAGE_SIZE)
+	       && len <= sgl->length;
+}
+
+/*
+ * Maps the sglist buffer and returns a pointer to the mapped buffer in
+ * data_buf.
+ *
+ * If direct mapping is not feasible, then allocates a bounce buffer if one
+ * isn't already available in bounce_buf, and returns a pointer to the bounce
+ * buffer in data_buf.
+ *
+ * When the buffer is no longer needed, put_request_buffer() should be called on
+ * the data_buf and the bounce_buf should be freed using kfree().
+ */
+static int get_request_buffer(struct scatterlist *sgl,
+			      struct scatter_walk *sg_walk,
+			      unsigned long bounce_buf_size,
+			      u8 **data_buf, u8 **bounce_buf, bool *mapped)
+{
+	if (sg_is_last(sgl) && is_mappable(sgl, sgl->length)) {
+		*mapped = true;
+		scatterwalk_start(sg_walk, sgl);
+		*data_buf = scatterwalk_map(sg_walk);
+		return 0;
+	}
+
+	*mapped = false;
+
+	if (*bounce_buf == NULL) {
+		*bounce_buf = kmalloc(bounce_buf_size, GFP_ATOMIC);
+		if (unlikely(*bounce_buf == NULL))
+			return -ENOMEM;
+	}
+
+	*data_buf = *bounce_buf;
+	return 0;
+}
+
+static void put_request_buffer(u8 *data_buf, unsigned long len, bool mapped,
+			       struct scatter_walk *sg_walk, bool output)
+{
+	if (mapped) {
+		scatterwalk_unmap(data_buf);
+		scatterwalk_advance(sg_walk, len);
+		scatterwalk_done(sg_walk, output, 0);
+	}
+}
+
+/*
+ * Performs the encryption/decryption operation for the given request. The src
+ * and dst sglists in the request are directly mapped if possible. Otherwise, a
+ * bounce buffer is allocated and used to copy the data from the src or to the
+ * dst, or both.
+ */
+static int gcmaes_crypt(struct aead_request *req, unsigned int assoclen,
+			u8 *hash_subkey, u8 *iv, void *aes_ctx, bool decrypt)
+{
+	u8 *src, *dst, *assoc, *bounce_buf = NULL;
+	bool src_mapped = false, dst_mapped = false;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
+	unsigned long data_len = req->cryptlen - (decrypt ? auth_tag_len : 0);
+	struct scatter_walk src_sg_walk;
+	struct scatter_walk dst_sg_walk = {};
+	int retval = 0;
+	unsigned long bounce_buf_size = data_len + auth_tag_len + req->assoclen;
+
+	if (auth_tag_len > 16)
+		return -EINVAL;
+
+	retval = get_request_buffer(req->src, &src_sg_walk, bounce_buf_size,
+				    &assoc, &bounce_buf, &src_mapped);
+	if (retval)
+		goto exit;
+
+	src = assoc + req->assoclen;
+
+	if (req->src == req->dst) {
+		dst = src;
+		dst_mapped = src_mapped;
+	} else {
+		retval = get_request_buffer(req->dst, &dst_sg_walk,
+					    bounce_buf_size, &dst, &bounce_buf,
+					    &dst_mapped);
+		if (retval)
+			goto exit;
+
+		dst += req->assoclen;
+	}
+
+	if (!src_mapped)
+		scatterwalk_map_and_copy(bounce_buf, req->src, 0,
+					 req->assoclen + req->cryptlen, 0);
+
+	kernel_fpu_begin();
+
+	if (decrypt) {
+		u8 gen_auth_tag[16];
+
+		aesni_gcm_dec_tfm(aes_ctx, dst, src, data_len, iv,
+				  hash_subkey, assoc, assoclen,
+				  gen_auth_tag, auth_tag_len);
+		/* Compare generated tag with passed in tag. */
+		if (crypto_memneq(src + data_len, gen_auth_tag, auth_tag_len))
+			retval = -EBADMSG;
+
+	} else
+		aesni_gcm_enc_tfm(aes_ctx, dst, src, data_len, iv,
+				  hash_subkey, assoc, assoclen,
+				  dst + data_len, auth_tag_len);
+
+	kernel_fpu_end();
+
+	if (!dst_mapped)
+		scatterwalk_map_and_copy(dst, req->dst, req->assoclen,
+					 data_len + (decrypt ? 0 : auth_tag_len),
+					 1);
+exit:
+	if (req->dst != req->src)
+		put_request_buffer(dst - req->assoclen, req->dst->length,
+				   dst_mapped, &dst_sg_walk, true);
+
+	put_request_buffer(assoc, req->src->length, src_mapped, &src_sg_walk,
+			   false);
+
+	kfree(bounce_buf);
+	return retval;
+}
+
 static int gcmaes_encrypt(struct aead_request *req, unsigned int assoclen,
 			  u8 *hash_subkey, u8 *iv, void *aes_ctx)
 {
-	u8 one_entry_in_sg = 0;
-	u8 *src, *dst, *assoc;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
-	struct scatter_walk src_sg_walk;
-	struct scatter_walk dst_sg_walk = {};
-
-	if (sg_is_last(req->src) &&
-	    (!PageHighMem(sg_page(req->src)) ||
-	    req->src->offset + req->src->length <= PAGE_SIZE) &&
-	    sg_is_last(req->dst) &&
-	    (!PageHighMem(sg_page(req->dst)) ||
-	    req->dst->offset + req->dst->length <= PAGE_SIZE)) {
-		one_entry_in_sg = 1;
-		scatterwalk_start(&src_sg_walk, req->src);
-		assoc = scatterwalk_map(&src_sg_walk);
-		src = assoc + req->assoclen;
-		dst = src;
-		if (unlikely(req->src != req->dst)) {
-			scatterwalk_start(&dst_sg_walk, req->dst);
-			dst = scatterwalk_map(&dst_sg_walk) + req->assoclen;
-		}
-	} else {
-		/* Allocate memory for src, dst, assoc */
-		assoc = kmalloc(req->cryptlen + auth_tag_len + req->assoclen,
-			GFP_ATOMIC);
-		if (unlikely(!assoc))
-			return -ENOMEM;
-		scatterwalk_map_and_copy(assoc, req->src, 0,
-					 req->assoclen + req->cryptlen, 0);
-		src = assoc + req->assoclen;
-		dst = src;
-	}
-
-	kernel_fpu_begin();
-	aesni_gcm_enc_tfm(aes_ctx, dst, src, req->cryptlen, iv,
-			  hash_subkey, assoc, assoclen,
-			  dst + req->cryptlen, auth_tag_len);
-	kernel_fpu_end();
-
-	/* The authTag (aka the Integrity Check Value) needs to be written
-	 * back to the packet. */
-	if (one_entry_in_sg) {
-		if (unlikely(req->src != req->dst)) {
-			scatterwalk_unmap(dst - req->assoclen);
-			scatterwalk_advance(&dst_sg_walk, req->dst->length);
-			scatterwalk_done(&dst_sg_walk, 1, 0);
-		}
-		scatterwalk_unmap(assoc);
-		scatterwalk_advance(&src_sg_walk, req->src->length);
-		scatterwalk_done(&src_sg_walk, req->src == req->dst, 0);
-	} else {
-		scatterwalk_map_and_copy(dst, req->dst, req->assoclen,
-					 req->cryptlen + auth_tag_len, 1);
-		kfree(assoc);
-	}
-	return 0;
+	return gcmaes_crypt(req, assoclen, hash_subkey, iv, aes_ctx, false);
 }
 
 static int gcmaes_decrypt(struct aead_request *req, unsigned int assoclen,
 			  u8 *hash_subkey, u8 *iv, void *aes_ctx)
 {
-	u8 one_entry_in_sg = 0;
-	u8 *src, *dst, *assoc;
-	unsigned long tempCipherLen = 0;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
-	u8 authTag[16];
-	struct scatter_walk src_sg_walk;
-	struct scatter_walk dst_sg_walk = {};
-	int retval = 0;
-
-	tempCipherLen = (unsigned long)(req->cryptlen - auth_tag_len);
-
-	if (sg_is_last(req->src) &&
-	    (!PageHighMem(sg_page(req->src)) ||
-	    req->src->offset + req->src->length <= PAGE_SIZE) &&
-	    sg_is_last(req->dst) &&
-	    (!PageHighMem(sg_page(req->dst)) ||
-	    req->dst->offset + req->dst->length <= PAGE_SIZE)) {
-		one_entry_in_sg = 1;
-		scatterwalk_start(&src_sg_walk, req->src);
-		assoc = scatterwalk_map(&src_sg_walk);
-		src = assoc + req->assoclen;
-		dst = src;
-		if (unlikely(req->src != req->dst)) {
-			scatterwalk_start(&dst_sg_walk, req->dst);
-			dst = scatterwalk_map(&dst_sg_walk) + req->assoclen;
-		}
-	} else {
-		/* Allocate memory for src, dst, assoc */
-		assoc = kmalloc(req->cryptlen + req->assoclen, GFP_ATOMIC);
-		if (!assoc)
-			return -ENOMEM;
-		scatterwalk_map_and_copy(assoc, req->src, 0,
-					 req->assoclen + req->cryptlen, 0);
-		src = assoc + req->assoclen;
-		dst = src;
-	}
-
-
-	kernel_fpu_begin();
-	aesni_gcm_dec_tfm(aes_ctx, dst, src, tempCipherLen, iv,
-			  hash_subkey, assoc, assoclen,
-			  authTag, auth_tag_len);
-	kernel_fpu_end();
-
-	/* Compare generated tag with passed in tag. */
-	retval = crypto_memneq(src + tempCipherLen, authTag, auth_tag_len) ?
-		-EBADMSG : 0;
-
-	if (one_entry_in_sg) {
-		if (unlikely(req->src != req->dst)) {
-			scatterwalk_unmap(dst - req->assoclen);
-			scatterwalk_advance(&dst_sg_walk, req->dst->length);
-			scatterwalk_done(&dst_sg_walk, 1, 0);
-		}
-		scatterwalk_unmap(assoc);
-		scatterwalk_advance(&src_sg_walk, req->src->length);
-		scatterwalk_done(&src_sg_walk, req->src == req->dst, 0);
-	} else {
-		scatterwalk_map_and_copy(dst, req->dst, req->assoclen,
-					 tempCipherLen, 1);
-		kfree(assoc);
-	}
-	return retval;
-
+	return gcmaes_crypt(req, assoclen, hash_subkey, iv, aes_ctx, true);
 }
 
 static int helper_rfc4106_encrypt(struct aead_request *req)
-- 
2.16.0.rc1.238.g530d649a79-goog
