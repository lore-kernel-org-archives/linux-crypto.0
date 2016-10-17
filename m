From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 15/28] crypto: aesni: avoid -Wmaybe-uninitialized warning
Date: Tue, 18 Oct 2016 00:13:36 +0200
Message-ID: <20161017221355.1861551-3-arnd@arndb.de>
References: <20161017220342.1627073-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:51064 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759383AbcJQWQt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Oct 2016 18:16:49 -0400
In-Reply-To: <20161017220342.1627073-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The rfc4106 encrypy/decrypt helper functions cause an annoying
false-positive warning in allmodconfig if we turn on
-Wmaybe-uninitialized warnings again:

arch/x86/crypto/aesni-intel_glue.c: In function ‘helper_rfc4106_decrypt’:
include/linux/scatterlist.h:67:31: warning: ‘dst_sg_walk.sg’ may be used uninitialized in this function [-Wmaybe-uninitialized]

The problem seems to be that the compiler doesn't track the state of the
'one_entry_in_sg' variable across the kernel_fpu_begin/kernel_fpu_end
section.

This reorganizes the code to avoid that variable and have the shared
code in a separate function to avoid some of the conditional branches.

The resulting functions are a bit longer but also slightly less complex,
leaving no room for speculation on the part of the compiler.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
The conversion is nontrivial, and I have only build-tested it, so this
could use a careful review and testing.
---
 arch/x86/crypto/aesni-intel_glue.c | 121 ++++++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 48 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 0ab5ee1..054155b 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -269,6 +269,34 @@ static void (*aesni_gcm_dec_tfm)(void *ctx, u8 *out,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
 
+static inline void aesni_do_gcm_enc_tfm(void *ctx, u8 *out,
+			const u8 *in, unsigned long plaintext_len, u8 *iv,
+			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
+			u8 *auth_tag, unsigned long auth_tag_len)
+{
+	kernel_fpu_begin();
+	aesni_gcm_enc_tfm(ctx, out, in, plaintext_len, iv, hash_subkey,
+			  aad, aad_len, auth_tag, auth_tag_len);
+	kernel_fpu_end();
+}
+
+static inline int aesni_do_gcm_dec_tfm(void *ctx, u8 *out,
+			const u8 *in, unsigned long ciphertext_len, u8 *iv,
+			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
+			u8 *auth_tag, unsigned long auth_tag_len)
+{
+	kernel_fpu_begin();
+	aesni_gcm_dec_tfm(ctx, out, in, ciphertext_len, iv, hash_subkey, aad,
+			  aad_len, auth_tag, auth_tag_len);
+	kernel_fpu_end();
+
+	/* Compare generated tag with passed in tag. */
+	if (crypto_memneq(in + ciphertext_len, auth_tag, auth_tag_len))
+		return -EBADMSG;
+
+	return 0;
+}
+
 static inline struct
 aesni_rfc4106_gcm_ctx *aesni_rfc4106_gcm_ctx_get(struct crypto_aead *tfm)
 {
@@ -879,7 +907,6 @@ static int rfc4106_set_authsize(struct crypto_aead *parent,
 
 static int helper_rfc4106_encrypt(struct aead_request *req)
 {
-	u8 one_entry_in_sg = 0;
 	u8 *src, *dst, *assoc;
 	__be32 counter = cpu_to_be32(1);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
@@ -908,7 +935,6 @@ static int helper_rfc4106_encrypt(struct aead_request *req)
 	    req->src->offset + req->src->length <= PAGE_SIZE &&
 	    sg_is_last(req->dst) &&
 	    req->dst->offset + req->dst->length <= PAGE_SIZE) {
-		one_entry_in_sg = 1;
 		scatterwalk_start(&src_sg_walk, req->src);
 		assoc = scatterwalk_map(&src_sg_walk);
 		src = assoc + req->assoclen;
@@ -916,7 +942,23 @@ static int helper_rfc4106_encrypt(struct aead_request *req)
 		if (unlikely(req->src != req->dst)) {
 			scatterwalk_start(&dst_sg_walk, req->dst);
 			dst = scatterwalk_map(&dst_sg_walk) + req->assoclen;
+
+			aesni_do_gcm_enc_tfm(aes_ctx, dst, src, req->cryptlen, iv,
+					     ctx->hash_subkey, assoc, req->assoclen - 8,
+					     dst + req->cryptlen, auth_tag_len);
+
+			scatterwalk_unmap(dst - req->assoclen);
+			scatterwalk_advance(&dst_sg_walk, req->dst->length);
+			scatterwalk_done(&dst_sg_walk, 1, 0);
+		} else {
+			aesni_do_gcm_enc_tfm(aes_ctx, dst, src, req->cryptlen, iv,
+					     ctx->hash_subkey, assoc, req->assoclen - 8,
+					     dst + req->cryptlen, auth_tag_len);
 		}
+
+		scatterwalk_unmap(assoc);
+		scatterwalk_advance(&src_sg_walk, req->src->length);
+		scatterwalk_done(&src_sg_walk, req->src == req->dst, 0);
 	} else {
 		/* Allocate memory for src, dst, assoc */
 		assoc = kmalloc(req->cryptlen + auth_tag_len + req->assoclen,
@@ -925,28 +967,14 @@ static int helper_rfc4106_encrypt(struct aead_request *req)
 			return -ENOMEM;
 		scatterwalk_map_and_copy(assoc, req->src, 0,
 					 req->assoclen + req->cryptlen, 0);
-		src = assoc + req->assoclen;
-		dst = src;
-	}
+		dst = src = assoc + req->assoclen;
 
-	kernel_fpu_begin();
-	aesni_gcm_enc_tfm(aes_ctx, dst, src, req->cryptlen, iv,
-			  ctx->hash_subkey, assoc, req->assoclen - 8,
-			  dst + req->cryptlen, auth_tag_len);
-	kernel_fpu_end();
+		aesni_gcm_enc_tfm(aes_ctx, dst, src, req->cryptlen, iv,
+				  ctx->hash_subkey, assoc, req->assoclen - 8,
+				  dst + req->cryptlen, auth_tag_len);
 
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
+		/* The authTag (aka the Integrity Check Value) needs to be written
+		 * back to the packet. */
 		scatterwalk_map_and_copy(dst, req->dst, req->assoclen,
 					 req->cryptlen + auth_tag_len, 1);
 		kfree(assoc);
@@ -956,7 +984,6 @@ static int helper_rfc4106_encrypt(struct aead_request *req)
 
 static int helper_rfc4106_decrypt(struct aead_request *req)
 {
-	u8 one_entry_in_sg = 0;
 	u8 *src, *dst, *assoc;
 	unsigned long tempCipherLen = 0;
 	__be32 counter = cpu_to_be32(1);
@@ -990,47 +1017,45 @@ static int helper_rfc4106_decrypt(struct aead_request *req)
 	    req->src->offset + req->src->length <= PAGE_SIZE &&
 	    sg_is_last(req->dst) &&
 	    req->dst->offset + req->dst->length <= PAGE_SIZE) {
-		one_entry_in_sg = 1;
 		scatterwalk_start(&src_sg_walk, req->src);
 		assoc = scatterwalk_map(&src_sg_walk);
 		src = assoc + req->assoclen;
-		dst = src;
 		if (unlikely(req->src != req->dst)) {
 			scatterwalk_start(&dst_sg_walk, req->dst);
 			dst = scatterwalk_map(&dst_sg_walk) + req->assoclen;
-		}
-
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
 
-	kernel_fpu_begin();
-	aesni_gcm_dec_tfm(aes_ctx, dst, src, tempCipherLen, iv,
-			  ctx->hash_subkey, assoc, req->assoclen - 8,
-			  authTag, auth_tag_len);
-	kernel_fpu_end();
-
-	/* Compare generated tag with passed in tag. */
-	retval = crypto_memneq(src + tempCipherLen, authTag, auth_tag_len) ?
-		-EBADMSG : 0;
+			retval = aesni_do_gcm_dec_tfm(aes_ctx, dst, src,
+					tempCipherLen, iv, ctx->hash_subkey,
+					assoc, req->assoclen - 8, authTag,
+					auth_tag_len);
 
-	if (one_entry_in_sg) {
-		if (unlikely(req->src != req->dst)) {
 			scatterwalk_unmap(dst - req->assoclen);
 			scatterwalk_advance(&dst_sg_walk, req->dst->length);
 			scatterwalk_done(&dst_sg_walk, 1, 0);
+		} else {
+			dst = src;
+			retval = aesni_do_gcm_dec_tfm(aes_ctx, dst, src,
+					tempCipherLen, iv, ctx->hash_subkey,
+					assoc, req->assoclen - 8, authTag,
+					auth_tag_len);
 		}
 		scatterwalk_unmap(assoc);
 		scatterwalk_advance(&src_sg_walk, req->src->length);
 		scatterwalk_done(&src_sg_walk, req->src == req->dst, 0);
 	} else {
+		/* Allocate memory for src, dst, assoc */
+		assoc = kmalloc(req->cryptlen + req->assoclen, GFP_ATOMIC);
+		if (!assoc)
+			return -ENOMEM;
+		scatterwalk_map_and_copy(assoc, req->src, 0,
+					 req->assoclen + req->cryptlen, 0);
+		dst = src = assoc + req->assoclen;
+
+		retval = aesni_do_gcm_dec_tfm(aes_ctx, dst, src, tempCipherLen,
+					      iv, ctx->hash_subkey, assoc,
+					      req->assoclen - 8, authTag,
+					      auth_tag_len);
+
 		scatterwalk_map_and_copy(dst, req->dst, req->assoclen,
 					 tempCipherLen, 1);
 		kfree(assoc);
-- 
2.9.0
