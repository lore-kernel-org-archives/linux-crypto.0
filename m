From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/6] [CRYPTO] api: Remove deprecated interface
Date: Wed, 24 Jan 2007 21:29:17 +1100
Message-ID: <E1H9fNV-0005n2-00@gondolin.me.apana.org.au>
References: <20070124102736.GA21977@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2899 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751019AbXAXK3V (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jan 2007 05:29:21 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1H9fNV-0005wc-Uy
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:29:18 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1H9fNV-0005n2-00
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:29:17 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Remove deprecated interface

This patch removes the old cipher interface and related code.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c        |    2 
 crypto/api.c           |   63 ------
 crypto/cipher.c        |  447 -------------------------------------------------
 crypto/compress.c      |    5 
 crypto/digest.c        |    5 
 crypto/internal.h      |   26 --
 include/linux/crypto.h |  127 -------------
 7 files changed, 16 insertions(+), 659 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -396,7 +396,7 @@ struct crypto_tfm *crypto_spawn_tfm(stru
 		return ERR_PTR(-EAGAIN);
 	}
 
-	tfm = __crypto_alloc_tfm(alg, 0);
+	tfm = __crypto_alloc_tfm(alg);
 	if (IS_ERR(tfm))
 		crypto_mod_put(alg);
 
diff --git a/crypto/api.c b/crypto/api.c
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -212,25 +212,6 @@ struct crypto_alg *crypto_alg_mod_lookup
 }
 EXPORT_SYMBOL_GPL(crypto_alg_mod_lookup);
 
-static int crypto_init_flags(struct crypto_tfm *tfm, u32 flags)
-{
-	tfm->crt_flags = flags & CRYPTO_TFM_REQ_MASK;
-	flags &= ~CRYPTO_TFM_REQ_MASK;
-	
-	switch (crypto_tfm_alg_type(tfm)) {
-	case CRYPTO_ALG_TYPE_CIPHER:
-		return crypto_init_cipher_flags(tfm, flags);
-		
-	case CRYPTO_ALG_TYPE_DIGEST:
-		return crypto_init_digest_flags(tfm, flags);
-		
-	case CRYPTO_ALG_TYPE_COMPRESS:
-		return crypto_init_compress_flags(tfm, flags);
-	}
-	
-	return 0;
-}
-
 static int crypto_init_ops(struct crypto_tfm *tfm)
 {
 	const struct crypto_type *type = tfm->__crt_alg->cra_type;
@@ -285,7 +266,7 @@ static void crypto_exit_ops(struct crypt
 	}
 }
 
-static unsigned int crypto_ctxsize(struct crypto_alg *alg, int flags)
+static unsigned int crypto_ctxsize(struct crypto_alg *alg)
 {
 	const struct crypto_type *type = alg->cra_type;
 	unsigned int len;
@@ -299,15 +280,15 @@ static unsigned int crypto_ctxsize(struc
 		BUG();
 
 	case CRYPTO_ALG_TYPE_CIPHER:
-		len += crypto_cipher_ctxsize(alg, flags);
+		len += crypto_cipher_ctxsize(alg);
 		break;
 		
 	case CRYPTO_ALG_TYPE_DIGEST:
-		len += crypto_digest_ctxsize(alg, flags);
+		len += crypto_digest_ctxsize(alg);
 		break;
 		
 	case CRYPTO_ALG_TYPE_COMPRESS:
-		len += crypto_compress_ctxsize(alg, flags);
+		len += crypto_compress_ctxsize(alg);
 		break;
 	}
 
@@ -322,23 +303,19 @@ void crypto_shoot_alg(struct crypto_alg 
 }
 EXPORT_SYMBOL_GPL(crypto_shoot_alg);
 
-struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 flags)
+struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg)
 {
 	struct crypto_tfm *tfm = NULL;
 	unsigned int tfm_size;
 	int err = -ENOMEM;
 
-	tfm_size = sizeof(*tfm) + crypto_ctxsize(alg, flags);
+	tfm_size = sizeof(*tfm) + crypto_ctxsize(alg);
 	tfm = kzalloc(tfm_size, GFP_KERNEL);
 	if (tfm == NULL)
 		goto out_err;
 
 	tfm->__crt_alg = alg;
 
-	err = crypto_init_flags(tfm, flags);
-	if (err)
-		goto out_free_tfm;
-		
 	err = crypto_init_ops(tfm);
 	if (err)
 		goto out_free_tfm;
@@ -362,31 +339,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
 
-struct crypto_tfm *crypto_alloc_tfm(const char *name, u32 flags)
-{
-	struct crypto_tfm *tfm = NULL;
-	int err;
-
-	do {
-		struct crypto_alg *alg;
-
-		alg = crypto_alg_mod_lookup(name, 0, CRYPTO_ALG_ASYNC);
-		err = PTR_ERR(alg);
-		if (IS_ERR(alg))
-			continue;
-
-		tfm = __crypto_alloc_tfm(alg, flags);
-		err = 0;
-		if (IS_ERR(tfm)) {
-			crypto_mod_put(alg);
-			err = PTR_ERR(tfm);
-			tfm = NULL;
-		}
-	} while (err == -EAGAIN && !signal_pending(current));
-
-	return tfm;
-}
-
 /*
  *	crypto_alloc_base - Locate algorithm and allocate transform
  *	@alg_name: Name of algorithm
@@ -420,7 +372,7 @@ struct crypto_tfm *crypto_alloc_base(con
 			goto err;
 		}
 
-		tfm = __crypto_alloc_tfm(alg, 0);
+		tfm = __crypto_alloc_tfm(alg);
 		if (!IS_ERR(tfm))
 			return tfm;
 
@@ -466,7 +418,6 @@ void crypto_free_tfm(struct crypto_tfm *
 	kfree(tfm);
 }
 
-EXPORT_SYMBOL_GPL(crypto_alloc_tfm);
 EXPORT_SYMBOL_GPL(crypto_free_tfm);
 
 int crypto_has_alg(const char *name, u32 type, u32 mask)
diff --git a/crypto/cipher.c b/crypto/cipher.c
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -12,274 +12,13 @@
  * any later version.
  *
  */
-#include <linux/compiler.h>
+
 #include <linux/kernel.h>
 #include <linux/crypto.h>
 #include <linux/errno.h>
-#include <linux/mm.h>
-#include <linux/slab.h>
+#include <linux/scatterlist.h>
 #include <linux/string.h>
-#include <asm/scatterlist.h>
 #include "internal.h"
-#include "scatterwalk.h"
-
-struct cipher_alg_compat {
-	unsigned int cia_min_keysize;
-	unsigned int cia_max_keysize;
-	int (*cia_setkey)(struct crypto_tfm *tfm, const u8 *key,
-	                  unsigned int keylen);
-	void (*cia_encrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
-	void (*cia_decrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
-
-	unsigned int (*cia_encrypt_ecb)(const struct cipher_desc *desc,
-					u8 *dst, const u8 *src,
-					unsigned int nbytes);
-	unsigned int (*cia_decrypt_ecb)(const struct cipher_desc *desc,
-					u8 *dst, const u8 *src,
-					unsigned int nbytes);
-	unsigned int (*cia_encrypt_cbc)(const struct cipher_desc *desc,
-					u8 *dst, const u8 *src,
-					unsigned int nbytes);
-	unsigned int (*cia_decrypt_cbc)(const struct cipher_desc *desc,
-					u8 *dst, const u8 *src,
-					unsigned int nbytes);
-};
-
-static inline void xor_64(u8 *a, const u8 *b)
-{
-	((u32 *)a)[0] ^= ((u32 *)b)[0];
-	((u32 *)a)[1] ^= ((u32 *)b)[1];
-}
-
-static inline void xor_128(u8 *a, const u8 *b)
-{
-	((u32 *)a)[0] ^= ((u32 *)b)[0];
-	((u32 *)a)[1] ^= ((u32 *)b)[1];
-	((u32 *)a)[2] ^= ((u32 *)b)[2];
-	((u32 *)a)[3] ^= ((u32 *)b)[3];
-}
-
-static unsigned int crypt_slow(const struct cipher_desc *desc,
-			       struct scatter_walk *in,
-			       struct scatter_walk *out, unsigned int bsize)
-{
-	unsigned long alignmask = crypto_tfm_alg_alignmask(desc->tfm);
-	u8 buffer[bsize * 2 + alignmask];
-	u8 *src = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
-	u8 *dst = src + bsize;
-
-	scatterwalk_copychunks(src, in, bsize, 0);
-	desc->prfn(desc, dst, src, bsize);
-	scatterwalk_copychunks(dst, out, bsize, 1);
-
-	return bsize;
-}
-
-static inline unsigned int crypt_fast(const struct cipher_desc *desc,
-				      struct scatter_walk *in,
-				      struct scatter_walk *out,
-				      unsigned int nbytes, u8 *tmp)
-{
-	u8 *src, *dst;
-	u8 *real_src, *real_dst;
-
-	real_src = scatterwalk_map(in, 0);
-	real_dst = scatterwalk_map(out, 1);
-
-	src = real_src;
-	dst = scatterwalk_samebuf(in, out) ? src : real_dst;
-
-	if (tmp) {
-		memcpy(tmp, src, nbytes);
-		src = tmp;
-		dst = tmp;
-	}
-
-	nbytes = desc->prfn(desc, dst, src, nbytes);
-
-	if (tmp)
-		memcpy(real_dst, tmp, nbytes);
-
-	scatterwalk_unmap(real_src, 0);
-	scatterwalk_unmap(real_dst, 1);
-
-	scatterwalk_advance(in, nbytes);
-	scatterwalk_advance(out, nbytes);
-
-	return nbytes;
-}
-
-/* 
- * Generic encrypt/decrypt wrapper for ciphers, handles operations across
- * multiple page boundaries by using temporary blocks.  In user context,
- * the kernel is given a chance to schedule us once per page.
- */
-static int crypt(const struct cipher_desc *desc,
-		 struct scatterlist *dst,
-		 struct scatterlist *src,
-		 unsigned int nbytes)
-{
-	struct scatter_walk walk_in, walk_out;
-	struct crypto_tfm *tfm = desc->tfm;
-	const unsigned int bsize = crypto_tfm_alg_blocksize(tfm);
-	unsigned int alignmask = crypto_tfm_alg_alignmask(tfm);
-	unsigned long buffer = 0;
-
-	if (!nbytes)
-		return 0;
-
-	if (nbytes % bsize) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
-		return -EINVAL;
-	}
-
-	scatterwalk_start(&walk_in, src);
-	scatterwalk_start(&walk_out, dst);
-
-	for(;;) {
-		unsigned int n = nbytes;
-		u8 *tmp = NULL;
-
-		if (!scatterwalk_aligned(&walk_in, alignmask) ||
-		    !scatterwalk_aligned(&walk_out, alignmask)) {
-			if (!buffer) {
-				buffer = __get_free_page(GFP_ATOMIC);
-				if (!buffer)
-					n = 0;
-			}
-			tmp = (u8 *)buffer;
-		}
-
-		n = scatterwalk_clamp(&walk_in, n);
-		n = scatterwalk_clamp(&walk_out, n);
-
-		if (likely(n >= bsize))
-			n = crypt_fast(desc, &walk_in, &walk_out, n, tmp);
-		else
-			n = crypt_slow(desc, &walk_in, &walk_out, bsize);
-
-		nbytes -= n;
-
-		scatterwalk_done(&walk_in, 0, nbytes);
-		scatterwalk_done(&walk_out, 1, nbytes);
-
-		if (!nbytes)
-			break;
-
-		crypto_yield(tfm->crt_flags);
-	}
-
-	if (buffer)
-		free_page(buffer);
-
-	return 0;
-}
-
-static int crypt_iv_unaligned(struct cipher_desc *desc,
-			      struct scatterlist *dst,
-			      struct scatterlist *src,
-			      unsigned int nbytes)
-{
-	struct crypto_tfm *tfm = desc->tfm;
-	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
-	u8 *iv = desc->info;
-
-	if (unlikely(((unsigned long)iv & alignmask))) {
-		unsigned int ivsize = tfm->crt_cipher.cit_ivsize;
-		u8 buffer[ivsize + alignmask];
-		u8 *tmp = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
-		int err;
-
-		desc->info = memcpy(tmp, iv, ivsize);
-		err = crypt(desc, dst, src, nbytes);
-		memcpy(iv, tmp, ivsize);
-
-		return err;
-	}
-
-	return crypt(desc, dst, src, nbytes);
-}
-
-static unsigned int cbc_process_encrypt(const struct cipher_desc *desc,
-					u8 *dst, const u8 *src,
-					unsigned int nbytes)
-{
-	struct crypto_tfm *tfm = desc->tfm;
-	void (*xor)(u8 *, const u8 *) = tfm->crt_u.cipher.cit_xor_block;
-	int bsize = crypto_tfm_alg_blocksize(tfm);
-
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) = desc->crfn;
-	u8 *iv = desc->info;
-	unsigned int done = 0;
-
-	nbytes -= bsize;
-
-	do {
-		xor(iv, src);
-		fn(tfm, dst, iv);
-		memcpy(iv, dst, bsize);
-
-		src += bsize;
-		dst += bsize;
-	} while ((done += bsize) <= nbytes);
-
-	return done;
-}
-
-static unsigned int cbc_process_decrypt(const struct cipher_desc *desc,
-					u8 *dst, const u8 *src,
-					unsigned int nbytes)
-{
-	struct crypto_tfm *tfm = desc->tfm;
-	void (*xor)(u8 *, const u8 *) = tfm->crt_u.cipher.cit_xor_block;
-	int bsize = crypto_tfm_alg_blocksize(tfm);
-	unsigned long alignmask = crypto_tfm_alg_alignmask(desc->tfm);
-
-	u8 stack[src == dst ? bsize + alignmask : 0];
-	u8 *buf = (u8 *)ALIGN((unsigned long)stack, alignmask + 1);
-	u8 **dst_p = src == dst ? &buf : &dst;
-
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) = desc->crfn;
-	u8 *iv = desc->info;
-	unsigned int done = 0;
-
-	nbytes -= bsize;
-
-	do {
-		u8 *tmp_dst = *dst_p;
-
-		fn(tfm, tmp_dst, src);
-		xor(tmp_dst, iv);
-		memcpy(iv, src, bsize);
-		if (tmp_dst != dst)
-			memcpy(dst, tmp_dst, bsize);
-
-		src += bsize;
-		dst += bsize;
-	} while ((done += bsize) <= nbytes);
-
-	return done;
-}
-
-static unsigned int ecb_process(const struct cipher_desc *desc, u8 *dst,
-				const u8 *src, unsigned int nbytes)
-{
-	struct crypto_tfm *tfm = desc->tfm;
-	int bsize = crypto_tfm_alg_blocksize(tfm);
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) = desc->crfn;
-	unsigned int done = 0;
-
-	nbytes -= bsize;
-
-	do {
-		fn(tfm, dst, src);
-
-		src += bsize;
-		dst += bsize;
-	} while ((done += bsize) <= nbytes);
-
-	return done;
-}
 
 static int setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 {
@@ -293,122 +32,6 @@ static int setkey(struct crypto_tfm *tfm
 		return cia->cia_setkey(tfm, key, keylen);
 }
 
-static int ecb_encrypt(struct crypto_tfm *tfm,
-		       struct scatterlist *dst,
-                       struct scatterlist *src, unsigned int nbytes)
-{
-	struct cipher_desc desc;
-	struct cipher_alg_compat *cipher = (void *)&tfm->__crt_alg->cra_cipher;
-
-	desc.tfm = tfm;
-	desc.crfn = cipher->cia_encrypt;
-	desc.prfn = cipher->cia_encrypt_ecb ?: ecb_process;
-
-	return crypt(&desc, dst, src, nbytes);
-}
-
-static int ecb_decrypt(struct crypto_tfm *tfm,
-                       struct scatterlist *dst,
-                       struct scatterlist *src,
-		       unsigned int nbytes)
-{
-	struct cipher_desc desc;
-	struct cipher_alg_compat *cipher = (void *)&tfm->__crt_alg->cra_cipher;
-
-	desc.tfm = tfm;
-	desc.crfn = cipher->cia_decrypt;
-	desc.prfn = cipher->cia_decrypt_ecb ?: ecb_process;
-
-	return crypt(&desc, dst, src, nbytes);
-}
-
-static int cbc_encrypt(struct crypto_tfm *tfm,
-                       struct scatterlist *dst,
-                       struct scatterlist *src,
-		       unsigned int nbytes)
-{
-	struct cipher_desc desc;
-	struct cipher_alg_compat *cipher = (void *)&tfm->__crt_alg->cra_cipher;
-
-	desc.tfm = tfm;
-	desc.crfn = cipher->cia_encrypt;
-	desc.prfn = cipher->cia_encrypt_cbc ?: cbc_process_encrypt;
-	desc.info = tfm->crt_cipher.cit_iv;
-
-	return crypt(&desc, dst, src, nbytes);
-}
-
-static int cbc_encrypt_iv(struct crypto_tfm *tfm,
-                          struct scatterlist *dst,
-                          struct scatterlist *src,
-                          unsigned int nbytes, u8 *iv)
-{
-	struct cipher_desc desc;
-	struct cipher_alg_compat *cipher = (void *)&tfm->__crt_alg->cra_cipher;
-
-	desc.tfm = tfm;
-	desc.crfn = cipher->cia_encrypt;
-	desc.prfn = cipher->cia_encrypt_cbc ?: cbc_process_encrypt;
-	desc.info = iv;
-
-	return crypt_iv_unaligned(&desc, dst, src, nbytes);
-}
-
-static int cbc_decrypt(struct crypto_tfm *tfm,
-                       struct scatterlist *dst,
-                       struct scatterlist *src,
-		       unsigned int nbytes)
-{
-	struct cipher_desc desc;
-	struct cipher_alg_compat *cipher = (void *)&tfm->__crt_alg->cra_cipher;
-
-	desc.tfm = tfm;
-	desc.crfn = cipher->cia_decrypt;
-	desc.prfn = cipher->cia_decrypt_cbc ?: cbc_process_decrypt;
-	desc.info = tfm->crt_cipher.cit_iv;
-
-	return crypt(&desc, dst, src, nbytes);
-}
-
-static int cbc_decrypt_iv(struct crypto_tfm *tfm,
-                          struct scatterlist *dst,
-                          struct scatterlist *src,
-                          unsigned int nbytes, u8 *iv)
-{
-	struct cipher_desc desc;
-	struct cipher_alg_compat *cipher = (void *)&tfm->__crt_alg->cra_cipher;
-
-	desc.tfm = tfm;
-	desc.crfn = cipher->cia_decrypt;
-	desc.prfn = cipher->cia_decrypt_cbc ?: cbc_process_decrypt;
-	desc.info = iv;
-
-	return crypt_iv_unaligned(&desc, dst, src, nbytes);
-}
-
-static int nocrypt(struct crypto_tfm *tfm,
-                   struct scatterlist *dst,
-                   struct scatterlist *src,
-		   unsigned int nbytes)
-{
-	return -ENOSYS;
-}
-
-static int nocrypt_iv(struct crypto_tfm *tfm,
-                      struct scatterlist *dst,
-                      struct scatterlist *src,
-                      unsigned int nbytes, u8 *iv)
-{
-	return -ENOSYS;
-}
-
-int crypto_init_cipher_flags(struct crypto_tfm *tfm, u32 flags)
-{
-	u32 mode = flags & CRYPTO_TFM_MODE_MASK;
-	tfm->crt_cipher.cit_mode = mode ? mode : CRYPTO_TFM_MODE_ECB;
-	return 0;
-}
-
 static void cipher_crypt_unaligned(void (*fn)(struct crypto_tfm *, u8 *,
 					      const u8 *),
 				   struct crypto_tfm *tfm,
@@ -454,7 +77,6 @@ static void cipher_decrypt_unaligned(str
 
 int crypto_init_cipher_ops(struct crypto_tfm *tfm)
 {
-	int ret = 0;
 	struct cipher_tfm *ops = &tfm->crt_cipher;
 	struct cipher_alg *cipher = &tfm->__crt_alg->cra_cipher;
 
@@ -464,70 +86,7 @@ int crypto_init_cipher_ops(struct crypto
 	ops->cit_decrypt_one = crypto_tfm_alg_alignmask(tfm) ?
 		cipher_decrypt_unaligned : cipher->cia_decrypt;
 
-	switch (tfm->crt_cipher.cit_mode) {
-	case CRYPTO_TFM_MODE_ECB:
-		ops->cit_encrypt = ecb_encrypt;
-		ops->cit_decrypt = ecb_decrypt;
-		ops->cit_encrypt_iv = nocrypt_iv;
-		ops->cit_decrypt_iv = nocrypt_iv;
-		break;
-		
-	case CRYPTO_TFM_MODE_CBC:
-		ops->cit_encrypt = cbc_encrypt;
-		ops->cit_decrypt = cbc_decrypt;
-		ops->cit_encrypt_iv = cbc_encrypt_iv;
-		ops->cit_decrypt_iv = cbc_decrypt_iv;
-		break;
-		
-	case CRYPTO_TFM_MODE_CFB:
-		ops->cit_encrypt = nocrypt;
-		ops->cit_decrypt = nocrypt;
-		ops->cit_encrypt_iv = nocrypt_iv;
-		ops->cit_decrypt_iv = nocrypt_iv;
-		break;
-	
-	case CRYPTO_TFM_MODE_CTR:
-		ops->cit_encrypt = nocrypt;
-		ops->cit_decrypt = nocrypt;
-		ops->cit_encrypt_iv = nocrypt_iv;
-		ops->cit_decrypt_iv = nocrypt_iv;
-		break;
-
-	default:
-		BUG();
-	}
-	
-	if (ops->cit_mode == CRYPTO_TFM_MODE_CBC) {
-		unsigned long align;
-		unsigned long addr;
-	    	
-	    	switch (crypto_tfm_alg_blocksize(tfm)) {
-	    	case 8:
-	    		ops->cit_xor_block = xor_64;
-	    		break;
-	    		
-	    	case 16:
-	    		ops->cit_xor_block = xor_128;
-	    		break;
-	    		
-	    	default:
-	    		printk(KERN_WARNING "%s: block size %u not supported\n",
-	    		       crypto_tfm_alg_name(tfm),
-	    		       crypto_tfm_alg_blocksize(tfm));
-	    		ret = -EINVAL;
-	    		goto out;
-	    	}
-	    	
-		ops->cit_ivsize = crypto_tfm_alg_blocksize(tfm);
-		align = crypto_tfm_alg_alignmask(tfm) + 1;
-		addr = (unsigned long)crypto_tfm_ctx(tfm);
-		addr = ALIGN(addr, align);
-		addr += ALIGN(tfm->__crt_alg->cra_ctxsize, align);
-		ops->cit_iv = (void *)addr;
-	}
-
-out:	
-	return ret;
+	return 0;
 }
 
 void crypto_exit_cipher_ops(struct crypto_tfm *tfm)
diff --git a/crypto/compress.c b/crypto/compress.c
--- a/crypto/compress.c
+++ b/crypto/compress.c
@@ -34,11 +34,6 @@ static int crypto_decompress(struct cryp
 	                                                   dlen);
 }
 
-int crypto_init_compress_flags(struct crypto_tfm *tfm, u32 flags)
-{
-	return flags ? -EINVAL : 0;
-}
-
 int crypto_init_compress_ops(struct crypto_tfm *tfm)
 {
 	struct compress_tfm *ops = &tfm->crt_compress;
diff --git a/crypto/digest.c b/crypto/digest.c
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -136,11 +136,6 @@ static int digest(struct hash_desc *desc
 	return final(desc, out);
 }
 
-int crypto_init_digest_flags(struct crypto_tfm *tfm, u32 flags)
-{
-	return flags ? -EINVAL : 0;
-}
-
 int crypto_init_digest_ops(struct crypto_tfm *tfm)
 {
 	struct hash_tfm *ops = &tfm->crt_hash;
diff --git a/crypto/internal.h b/crypto/internal.h
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -83,8 +83,7 @@ static inline void crypto_exit_proc(void
 { }
 #endif
 
-static inline unsigned int crypto_digest_ctxsize(struct crypto_alg *alg,
-						 int flags)
+static inline unsigned int crypto_digest_ctxsize(struct crypto_alg *alg)
 {
 	unsigned int len = alg->cra_ctxsize;
 
@@ -96,23 +95,12 @@ static inline unsigned int crypto_digest
 	return len;
 }
 
-static inline unsigned int crypto_cipher_ctxsize(struct crypto_alg *alg,
-						 int flags)
+static inline unsigned int crypto_cipher_ctxsize(struct crypto_alg *alg)
 {
-	unsigned int len = alg->cra_ctxsize;
-	
-	switch (flags & CRYPTO_TFM_MODE_MASK) {
-	case CRYPTO_TFM_MODE_CBC:
-		len = ALIGN(len, (unsigned long)alg->cra_alignmask + 1);
-		len += alg->cra_blocksize;
-		break;
-	}
-
-	return len;
+	return alg->cra_ctxsize;
 }
 
-static inline unsigned int crypto_compress_ctxsize(struct crypto_alg *alg,
-						   int flags)
+static inline unsigned int crypto_compress_ctxsize(struct crypto_alg *alg)
 {
 	return alg->cra_ctxsize;
 }
@@ -121,10 +109,6 @@ struct crypto_alg *crypto_mod_get(struct
 struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type, u32 mask);
 struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask);
 
-int crypto_init_digest_flags(struct crypto_tfm *tfm, u32 flags);
-int crypto_init_cipher_flags(struct crypto_tfm *tfm, u32 flags);
-int crypto_init_compress_flags(struct crypto_tfm *tfm, u32 flags);
-
 int crypto_init_digest_ops(struct crypto_tfm *tfm);
 int crypto_init_cipher_ops(struct crypto_tfm *tfm);
 int crypto_init_compress_ops(struct crypto_tfm *tfm);
@@ -136,7 +120,7 @@ void crypto_exit_compress_ops(struct cry
 void crypto_larval_error(const char *name, u32 type, u32 mask);
 
 void crypto_shoot_alg(struct crypto_alg *alg);
-struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 flags);
+struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg);
 
 int crypto_register_instance(struct crypto_template *tmpl,
 			     struct crypto_instance *inst);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -51,15 +51,9 @@
 /*
  * Transform masks and values (for crt_flags).
  */
-#define CRYPTO_TFM_MODE_MASK		0x000000ff
 #define CRYPTO_TFM_REQ_MASK		0x000fff00
 #define CRYPTO_TFM_RES_MASK		0xfff00000
 
-#define CRYPTO_TFM_MODE_ECB		0x00000001
-#define CRYPTO_TFM_MODE_CBC		0x00000002
-#define CRYPTO_TFM_MODE_CFB		0x00000004
-#define CRYPTO_TFM_MODE_CTR		0x00000008
-
 #define CRYPTO_TFM_REQ_WEAK_KEY		0x00000100
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
 #define CRYPTO_TFM_RES_WEAK_KEY		0x00100000
@@ -71,12 +65,8 @@
 /*
  * Miscellaneous stuff.
  */
-#define CRYPTO_UNSPEC			0
 #define CRYPTO_MAX_ALG_NAME		64
 
-#define CRYPTO_DIR_ENCRYPT		1
-#define CRYPTO_DIR_DECRYPT		0
-
 /*
  * The macro CRYPTO_MINALIGN_ATTR (along with the void * type in the actual
  * declaration) is used to ensure that the crypto_tfm context structure is
@@ -148,19 +138,6 @@ struct cipher_alg {
 	                  unsigned int keylen);
 	void (*cia_encrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 	void (*cia_decrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
-
-	unsigned int (*cia_encrypt_ecb)(const struct cipher_desc *desc,
-					u8 *dst, const u8 *src,
-					unsigned int nbytes) __deprecated;
-	unsigned int (*cia_decrypt_ecb)(const struct cipher_desc *desc,
-					u8 *dst, const u8 *src,
-					unsigned int nbytes) __deprecated;
-	unsigned int (*cia_encrypt_cbc)(const struct cipher_desc *desc,
-					u8 *dst, const u8 *src,
-					unsigned int nbytes) __deprecated;
-	unsigned int (*cia_decrypt_cbc)(const struct cipher_desc *desc,
-					u8 *dst, const u8 *src,
-					unsigned int nbytes) __deprecated;
 };
 
 struct digest_alg {
@@ -243,11 +220,6 @@ int crypto_unregister_alg(struct crypto_
 #ifdef CONFIG_CRYPTO
 int crypto_has_alg(const char *name, u32 type, u32 mask);
 #else
-static inline int crypto_alg_available(const char *name, u32 flags)
-{
-	return 0;
-}
-
 static inline int crypto_has_alg(const char *name, u32 type, u32 mask)
 {
 	return 0;
@@ -395,40 +367,11 @@ static inline u32 crypto_tfm_alg_type(st
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
 }
 
-static unsigned int crypto_tfm_alg_min_keysize(struct crypto_tfm *tfm)
-	__deprecated;
-static inline unsigned int crypto_tfm_alg_min_keysize(struct crypto_tfm *tfm)
-{
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
-	return tfm->__crt_alg->cra_cipher.cia_min_keysize;
-}
-
-static unsigned int crypto_tfm_alg_max_keysize(struct crypto_tfm *tfm)
-	__deprecated;
-static inline unsigned int crypto_tfm_alg_max_keysize(struct crypto_tfm *tfm)
-{
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
-	return tfm->__crt_alg->cra_cipher.cia_max_keysize;
-}
-
-static unsigned int crypto_tfm_alg_ivsize(struct crypto_tfm *tfm) __deprecated;
-static inline unsigned int crypto_tfm_alg_ivsize(struct crypto_tfm *tfm)
-{
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
-	return tfm->crt_cipher.cit_ivsize;
-}
-
 static inline unsigned int crypto_tfm_alg_blocksize(struct crypto_tfm *tfm)
 {
 	return tfm->__crt_alg->cra_blocksize;
 }
 
-static inline unsigned int crypto_tfm_alg_digestsize(struct crypto_tfm *tfm)
-{
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_DIGEST);
-	return tfm->__crt_alg->cra_digest.dia_digestsize;
-}
-
 static inline unsigned int crypto_tfm_alg_alignmask(struct crypto_tfm *tfm)
 {
 	return tfm->__crt_alg->cra_alignmask;
@@ -809,76 +752,6 @@ static inline int crypto_hash_setkey(str
 	return crypto_hash_crt(hash)->setkey(hash, key, keylen);
 }
 
-static int crypto_cipher_encrypt(struct crypto_tfm *tfm,
-				 struct scatterlist *dst,
-				 struct scatterlist *src,
-				 unsigned int nbytes) __deprecated;
-static inline int crypto_cipher_encrypt(struct crypto_tfm *tfm,
-                                        struct scatterlist *dst,
-                                        struct scatterlist *src,
-                                        unsigned int nbytes)
-{
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
-	return tfm->crt_cipher.cit_encrypt(tfm, dst, src, nbytes);
-}                                        
-
-static int crypto_cipher_encrypt_iv(struct crypto_tfm *tfm,
-				    struct scatterlist *dst,
-				    struct scatterlist *src,
-				    unsigned int nbytes, u8 *iv) __deprecated;
-static inline int crypto_cipher_encrypt_iv(struct crypto_tfm *tfm,
-                                           struct scatterlist *dst,
-                                           struct scatterlist *src,
-                                           unsigned int nbytes, u8 *iv)
-{
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
-	return tfm->crt_cipher.cit_encrypt_iv(tfm, dst, src, nbytes, iv);
-}                                        
-
-static int crypto_cipher_decrypt(struct crypto_tfm *tfm,
-				 struct scatterlist *dst,
-				 struct scatterlist *src,
-				 unsigned int nbytes) __deprecated;
-static inline int crypto_cipher_decrypt(struct crypto_tfm *tfm,
-                                        struct scatterlist *dst,
-                                        struct scatterlist *src,
-                                        unsigned int nbytes)
-{
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
-	return tfm->crt_cipher.cit_decrypt(tfm, dst, src, nbytes);
-}
-
-static int crypto_cipher_decrypt_iv(struct crypto_tfm *tfm,
-				    struct scatterlist *dst,
-				    struct scatterlist *src,
-				    unsigned int nbytes, u8 *iv) __deprecated;
-static inline int crypto_cipher_decrypt_iv(struct crypto_tfm *tfm,
-                                           struct scatterlist *dst,
-                                           struct scatterlist *src,
-                                           unsigned int nbytes, u8 *iv)
-{
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
-	return tfm->crt_cipher.cit_decrypt_iv(tfm, dst, src, nbytes, iv);
-}
-
-static void crypto_cipher_set_iv(struct crypto_tfm *tfm,
-				 const u8 *src, unsigned int len) __deprecated;
-static inline void crypto_cipher_set_iv(struct crypto_tfm *tfm,
-                                        const u8 *src, unsigned int len)
-{
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
-	memcpy(tfm->crt_cipher.cit_iv, src, len);
-}
-
-static void crypto_cipher_get_iv(struct crypto_tfm *tfm,
-				 u8 *dst, unsigned int len) __deprecated;
-static inline void crypto_cipher_get_iv(struct crypto_tfm *tfm,
-                                        u8 *dst, unsigned int len)
-{
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
-	memcpy(dst, tfm->crt_cipher.cit_iv, len);
-}
-
 static inline struct crypto_comp *__crypto_comp_cast(struct crypto_tfm *tfm)
 {
 	return (struct crypto_comp *)tfm;
