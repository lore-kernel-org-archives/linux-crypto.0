From: Dave Watson <davejwatson@fb.com>
Subject: [PATCH v2 14/14] x86/crypto: aesni: Update aesni-intel_glue to use
 scatter/gather
Date: Wed, 14 Feb 2018 09:40:58 -0800
Message-ID: <20180214174058.GA62239@davejwatson-mba>
References: <cover.1518628278.git.davejwatson@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "David S. Miller" <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Ilya Lesokhin <ilyal@mellanox.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53384 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1161361AbeBNRlp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Feb 2018 12:41:45 -0500
Content-Disposition: inline
In-Reply-To: <cover.1518628278.git.davejwatson@fb.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add gcmaes_crypt_by_sg routine, that will do scatter/gather
by sg. Either src or dst may contain multiple buffers, so
iterate over both at the same time if they are different.
If the input is the same as the output, iterate only over one.

Currently both the AAD and TAG must be linear, so copy them out
with scatterlist_map_and_copy.  If first buffer contains the
entire AAD, we can optimize and not copy.   Since the AAD
can be any size, if copied it must be on the heap.  TAG can
be on the stack since it is always < 16 bytes.

Only the SSE routines are updated so far, so leave the previous
gcmaes_en/decrypt routines, and branch to the sg ones if the
keysize is inappropriate for avx, or we are SSE only.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 133 +++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index de986f9..acbe7e8 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -791,6 +791,127 @@ static int generic_gcmaes_set_authsize(struct crypto_aead *tfm,
 	return 0;
 }
 
+static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
+			      unsigned int assoclen, u8 *hash_subkey,
+			      u8 *iv, void *aes_ctx)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
+	struct gcm_context_data data AESNI_ALIGN_ATTR;
+	struct scatter_walk dst_sg_walk = {};
+	unsigned long left = req->cryptlen;
+	unsigned long len, srclen, dstlen;
+	struct scatter_walk assoc_sg_walk;
+	struct scatter_walk src_sg_walk;
+	struct scatterlist src_start[2];
+	struct scatterlist dst_start[2];
+	struct scatterlist *src_sg;
+	struct scatterlist *dst_sg;
+	u8 *src, *dst, *assoc;
+	u8 *assocmem = NULL;
+	u8 authTag[16];
+
+	if (!enc)
+		left -= auth_tag_len;
+
+	/* Linearize assoc, if not already linear */
+	if (req->src->length >= assoclen && req->src->length &&
+		(!PageHighMem(sg_page(req->src)) ||
+			req->src->offset + req->src->length < PAGE_SIZE)) {
+		scatterwalk_start(&assoc_sg_walk, req->src);
+		assoc = scatterwalk_map(&assoc_sg_walk);
+	} else {
+		/* assoc can be any length, so must be on heap */
+		assocmem = kmalloc(assoclen, GFP_ATOMIC);
+		if (unlikely(!assocmem))
+			return -ENOMEM;
+		assoc = assocmem;
+
+		scatterwalk_map_and_copy(assoc, req->src, 0, assoclen, 0);
+	}
+
+	src_sg = scatterwalk_ffwd(src_start, req->src, req->assoclen);
+	scatterwalk_start(&src_sg_walk, src_sg);
+	if (req->src != req->dst) {
+		dst_sg = scatterwalk_ffwd(dst_start, req->dst, req->assoclen);
+		scatterwalk_start(&dst_sg_walk, dst_sg);
+	}
+
+	kernel_fpu_begin();
+	aesni_gcm_init(aes_ctx, &data, iv,
+		hash_subkey, assoc, assoclen);
+	if (req->src != req->dst) {
+		while (left) {
+			src = scatterwalk_map(&src_sg_walk);
+			dst = scatterwalk_map(&dst_sg_walk);
+			srclen = scatterwalk_clamp(&src_sg_walk, left);
+			dstlen = scatterwalk_clamp(&dst_sg_walk, left);
+			len = min(srclen, dstlen);
+			if (len) {
+				if (enc)
+					aesni_gcm_enc_update(aes_ctx, &data,
+							     dst, src, len);
+				else
+					aesni_gcm_dec_update(aes_ctx, &data,
+							     dst, src, len);
+			}
+			left -= len;
+
+			scatterwalk_unmap(src);
+			scatterwalk_unmap(dst);
+			scatterwalk_advance(&src_sg_walk, len);
+			scatterwalk_advance(&dst_sg_walk, len);
+			scatterwalk_done(&src_sg_walk, 0, left);
+			scatterwalk_done(&dst_sg_walk, 1, left);
+		}
+	} else {
+		while (left) {
+			dst = src = scatterwalk_map(&src_sg_walk);
+			len = scatterwalk_clamp(&src_sg_walk, left);
+			if (len) {
+				if (enc)
+					aesni_gcm_enc_update(aes_ctx, &data,
+							     src, src, len);
+				else
+					aesni_gcm_dec_update(aes_ctx, &data,
+							     src, src, len);
+			}
+			left -= len;
+			scatterwalk_unmap(src);
+			scatterwalk_advance(&src_sg_walk, len);
+			scatterwalk_done(&src_sg_walk, 1, left);
+		}
+	}
+	aesni_gcm_finalize(aes_ctx, &data, authTag, auth_tag_len);
+	kernel_fpu_end();
+
+	if (!assocmem)
+		scatterwalk_unmap(assoc);
+	else
+		kfree(assocmem);
+
+	if (!enc) {
+		u8 authTagMsg[16];
+
+		/* Copy out original authTag */
+		scatterwalk_map_and_copy(authTagMsg, req->src,
+					 req->assoclen + req->cryptlen -
+					 auth_tag_len,
+					 auth_tag_len, 0);
+
+		/* Compare generated tag with passed in tag. */
+		return crypto_memneq(authTagMsg, authTag, auth_tag_len) ?
+			-EBADMSG : 0;
+	}
+
+	/* Copy in the authTag */
+	scatterwalk_map_and_copy(authTag, req->dst,
+				 req->assoclen + req->cryptlen,
+				 auth_tag_len, 1);
+
+	return 0;
+}
+
 static int gcmaes_encrypt(struct aead_request *req, unsigned int assoclen,
 			  u8 *hash_subkey, u8 *iv, void *aes_ctx)
 {
@@ -802,6 +923,12 @@ static int gcmaes_encrypt(struct aead_request *req, unsigned int assoclen,
 	struct scatter_walk dst_sg_walk = {};
 	struct gcm_context_data data AESNI_ALIGN_ATTR;
 
+	if (((struct crypto_aes_ctx *)aes_ctx)->key_length != AES_KEYSIZE_128 ||
+		aesni_gcm_enc_tfm == aesni_gcm_enc ||
+		req->cryptlen < AVX_GEN2_OPTSIZE) {
+		return gcmaes_crypt_by_sg(true, req, assoclen, hash_subkey, iv,
+					  aes_ctx);
+	}
 	if (sg_is_last(req->src) &&
 	    (!PageHighMem(sg_page(req->src)) ||
 	    req->src->offset + req->src->length <= PAGE_SIZE) &&
@@ -868,6 +995,12 @@ static int gcmaes_decrypt(struct aead_request *req, unsigned int assoclen,
 	struct gcm_context_data data AESNI_ALIGN_ATTR;
 	int retval = 0;
 
+	if (((struct crypto_aes_ctx *)aes_ctx)->key_length != AES_KEYSIZE_128 ||
+		aesni_gcm_enc_tfm == aesni_gcm_enc ||
+		req->cryptlen < AVX_GEN2_OPTSIZE) {
+		return gcmaes_crypt_by_sg(false, req, assoclen, hash_subkey, iv,
+					  aes_ctx);
+	}
 	tempCipherLen = (unsigned long)(req->cryptlen - auth_tag_len);
 
 	if (sg_is_last(req->src) &&
-- 
2.9.5
