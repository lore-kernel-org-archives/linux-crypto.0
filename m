Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045D411712
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742088093; cv=none; b=d9wThUS5wUK3rL67OpN/UOfWmaXCR3P+nq8RMRupJKtsQ/c6se5sV0OnRqf3hr1ytx30dLcJLRNA7MLPhB9DzApTAQg6V0l13ED+rAZWBkV3kF4PwUIkzmmjrKt/fI3s9H31i+gDgFiDBRlZeRaYqHmYXyoYMFB+xRYeWJayzEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742088093; c=relaxed/simple;
	bh=GuS1MEmyHyAarmhejQ37lxUnp64Vrn26S/2JYf5rkU8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=Cbp/ZvFEa36oIJy6BCtzzYP7Z2tAfjbgIRvSRTHKsw7jnlQtpdRj3+mH+vnKEShOUnHISRg+n5Ydh0gwameLHcYIntjbhW83YJJCr9JOJq8X98a+vbjXSffONj4PSqmXy9HQOoUI9WpY5VXAHAkH7tGnc6KNRQKiL4txylnKyhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hUk27jCL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hUk27jCL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qMzgq2qrATfmyGeK1dAA0SL9kMIVNSfj8CGgyWvBfYo=; b=hUk27jCLlBRLDcZK3WvdAtOCzg
	vb55rDLqQtgjKCUVDUnNmSddN07u2pB1lPNsewMECcAOrpNIb4Gft9MUzNbN7l9RfyWPp4UXMwziR
	vcRWn3SKILPxH76qiiIHSmncMmoKTb63H1Xz3toDtn20uBY0/9m2KH95qnUHOjKDPOSnIGodv+2Sq
	huJXmA8y+wrgb05R7qJUXdcJpGuS95OtY+78+DuK5iUOOCpO12m4tPEUnQnnPzzoyyZArO8ZBkkaV
	29jShiNcdSjjY0jYxiPUCebIA5MXQqjAjyHz/3CcsumCzLgHO6Ecy9onR9huEgWyeE3Q1hoP6TNci
	uAHX9T8A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttcgx-006xbL-0L;
	Sun, 16 Mar 2025 09:21:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 09:21:27 +0800
Date: Sun, 16 Mar 2025 09:21:27 +0800
Message-Id: <4f47b62846cac0cc656c0c70cd1fbbfa7cdc0799.1742087941.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742087941.git.herbert@gondor.apana.org.au>
References: <cover.1742087941.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/11] crypto: remove obsolete 'comp' compression API
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

From: Ard Biesheuvel <ardb@kernel.org>

The 'comp' compression API has been superseded by the acomp API, which
is a bit more cumbersome to use, but ultimately more flexible when it
comes to hardware implementations.

Now that all the users and implementations have been removed, let's
remove the core plumbing of the 'comp' API as well.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 Documentation/crypto/architecture.rst |   2 -
 crypto/Makefile                       |   2 +-
 crypto/api.c                          |   4 -
 crypto/compress.c                     |  32 ------
 crypto/crypto_user.c                  |  16 ---
 crypto/proc.c                         |   3 -
 crypto/testmgr.c                      | 150 +++-----------------------
 include/linux/crypto.h                |  76 +------------
 8 files changed, 14 insertions(+), 271 deletions(-)
 delete mode 100644 crypto/compress.c

diff --git a/Documentation/crypto/architecture.rst b/Documentation/crypto/architecture.rst
index 15dcd62fd22f..249b54d0849f 100644
--- a/Documentation/crypto/architecture.rst
+++ b/Documentation/crypto/architecture.rst
@@ -196,8 +196,6 @@ the aforementioned cipher types:
 
 -  CRYPTO_ALG_TYPE_CIPHER Single block cipher
 
--  CRYPTO_ALG_TYPE_COMPRESS Compression
-
 -  CRYPTO_ALG_TYPE_AEAD Authenticated Encryption with Associated Data
    (MAC)
 
diff --git a/crypto/Makefile b/crypto/Makefile
index d1e422249af6..f22ebd6fb221 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -4,7 +4,7 @@
 #
 
 obj-$(CONFIG_CRYPTO) += crypto.o
-crypto-y := api.o cipher.o compress.o
+crypto-y := api.o cipher.o
 
 obj-$(CONFIG_CRYPTO_ENGINE) += crypto_engine.o
 obj-$(CONFIG_CRYPTO_FIPS) += fips.o
diff --git a/crypto/api.c b/crypto/api.c
index 91957bb52f3f..3416e98128a0 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -383,10 +383,6 @@ static unsigned int crypto_ctxsize(struct crypto_alg *alg, u32 type, u32 mask)
 	case CRYPTO_ALG_TYPE_CIPHER:
 		len += crypto_cipher_ctxsize(alg);
 		break;
-
-	case CRYPTO_ALG_TYPE_COMPRESS:
-		len += crypto_compress_ctxsize(alg);
-		break;
 	}
 
 	return len;
diff --git a/crypto/compress.c b/crypto/compress.c
deleted file mode 100644
index 9048fe390c46..000000000000
--- a/crypto/compress.c
+++ /dev/null
@@ -1,32 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Cryptographic API.
- *
- * Compression operations.
- *
- * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
- */
-#include <linux/crypto.h>
-#include "internal.h"
-
-int crypto_comp_compress(struct crypto_comp *comp,
-			 const u8 *src, unsigned int slen,
-			 u8 *dst, unsigned int *dlen)
-{
-	struct crypto_tfm *tfm = crypto_comp_tfm(comp);
-
-	return tfm->__crt_alg->cra_compress.coa_compress(tfm, src, slen, dst,
-	                                                 dlen);
-}
-EXPORT_SYMBOL_GPL(crypto_comp_compress);
-
-int crypto_comp_decompress(struct crypto_comp *comp,
-			   const u8 *src, unsigned int slen,
-			   u8 *dst, unsigned int *dlen)
-{
-	struct crypto_tfm *tfm = crypto_comp_tfm(comp);
-
-	return tfm->__crt_alg->cra_compress.coa_decompress(tfm, src, slen, dst,
-	                                                   dlen);
-}
-EXPORT_SYMBOL_GPL(crypto_comp_decompress);
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 6c571834e86a..aad429bef03e 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -84,17 +84,6 @@ static int crypto_report_cipher(struct sk_buff *skb, struct crypto_alg *alg)
 		       sizeof(rcipher), &rcipher);
 }
 
-static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_report_comp rcomp;
-
-	memset(&rcomp, 0, sizeof(rcomp));
-
-	strscpy(rcomp.type, "compression", sizeof(rcomp.type));
-
-	return nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS, sizeof(rcomp), &rcomp);
-}
-
 static int crypto_report_one(struct crypto_alg *alg,
 			     struct crypto_user_alg *ualg, struct sk_buff *skb)
 {
@@ -135,11 +124,6 @@ static int crypto_report_one(struct crypto_alg *alg,
 		if (crypto_report_cipher(skb, alg))
 			goto nla_put_failure;
 
-		break;
-	case CRYPTO_ALG_TYPE_COMPRESS:
-		if (crypto_report_comp(skb, alg))
-			goto nla_put_failure;
-
 		break;
 	}
 
diff --git a/crypto/proc.c b/crypto/proc.c
index 522b27d90d29..82f15b967e85 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -72,9 +72,6 @@ static int c_show(struct seq_file *m, void *p)
 		seq_printf(m, "max keysize  : %u\n",
 					alg->cra_cipher.cia_max_keysize);
 		break;
-	case CRYPTO_ALG_TYPE_COMPRESS:
-		seq_printf(m, "type         : compression\n");
-		break;
 	default:
 		seq_printf(m, "type         : unknown\n");
 		break;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 9c5648c45ff0..1b2387291787 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3320,112 +3320,6 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 	return err;
 }
 
-static int test_comp(struct crypto_comp *tfm,
-		     const struct comp_testvec *ctemplate,
-		     const struct comp_testvec *dtemplate,
-		     int ctcount, int dtcount)
-{
-	const char *algo = crypto_tfm_alg_driver_name(crypto_comp_tfm(tfm));
-	char *output, *decomp_output;
-	unsigned int i;
-	int ret;
-
-	output = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
-	if (!output)
-		return -ENOMEM;
-
-	decomp_output = kmalloc(COMP_BUF_SIZE, GFP_KERNEL);
-	if (!decomp_output) {
-		kfree(output);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < ctcount; i++) {
-		int ilen;
-		unsigned int dlen = COMP_BUF_SIZE;
-
-		memset(output, 0, COMP_BUF_SIZE);
-		memset(decomp_output, 0, COMP_BUF_SIZE);
-
-		ilen = ctemplate[i].inlen;
-		ret = crypto_comp_compress(tfm, ctemplate[i].input,
-					   ilen, output, &dlen);
-		if (ret) {
-			printk(KERN_ERR "alg: comp: compression failed "
-			       "on test %d for %s: ret=%d\n", i + 1, algo,
-			       -ret);
-			goto out;
-		}
-
-		ilen = dlen;
-		dlen = COMP_BUF_SIZE;
-		ret = crypto_comp_decompress(tfm, output,
-					     ilen, decomp_output, &dlen);
-		if (ret) {
-			pr_err("alg: comp: compression failed: decompress: on test %d for %s failed: ret=%d\n",
-			       i + 1, algo, -ret);
-			goto out;
-		}
-
-		if (dlen != ctemplate[i].inlen) {
-			printk(KERN_ERR "alg: comp: Compression test %d "
-			       "failed for %s: output len = %d\n", i + 1, algo,
-			       dlen);
-			ret = -EINVAL;
-			goto out;
-		}
-
-		if (memcmp(decomp_output, ctemplate[i].input,
-			   ctemplate[i].inlen)) {
-			pr_err("alg: comp: compression failed: output differs: on test %d for %s\n",
-			       i + 1, algo);
-			hexdump(decomp_output, dlen);
-			ret = -EINVAL;
-			goto out;
-		}
-	}
-
-	for (i = 0; i < dtcount; i++) {
-		int ilen;
-		unsigned int dlen = COMP_BUF_SIZE;
-
-		memset(decomp_output, 0, COMP_BUF_SIZE);
-
-		ilen = dtemplate[i].inlen;
-		ret = crypto_comp_decompress(tfm, dtemplate[i].input,
-					     ilen, decomp_output, &dlen);
-		if (ret) {
-			printk(KERN_ERR "alg: comp: decompression failed "
-			       "on test %d for %s: ret=%d\n", i + 1, algo,
-			       -ret);
-			goto out;
-		}
-
-		if (dlen != dtemplate[i].outlen) {
-			printk(KERN_ERR "alg: comp: Decompression test %d "
-			       "failed for %s: output len = %d\n", i + 1, algo,
-			       dlen);
-			ret = -EINVAL;
-			goto out;
-		}
-
-		if (memcmp(decomp_output, dtemplate[i].output, dlen)) {
-			printk(KERN_ERR "alg: comp: Decompression test %d "
-			       "failed for %s\n", i + 1, algo);
-			hexdump(decomp_output, dlen);
-			ret = -EINVAL;
-			goto out;
-		}
-	}
-
-	ret = 0;
-
-out:
-	kfree(decomp_output);
-	kfree(output);
-	return ret;
-}
-
 static int test_acomp(struct crypto_acomp *tfm,
 		      const struct comp_testvec *ctemplate,
 		      const struct comp_testvec *dtemplate,
@@ -3684,42 +3578,22 @@ static int alg_test_cipher(const struct alg_test_desc *desc,
 static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
-	struct crypto_comp *comp;
 	struct crypto_acomp *acomp;
 	int err;
-	u32 algo_type = type & CRYPTO_ALG_TYPE_ACOMPRESS_MASK;
 
-	if (algo_type == CRYPTO_ALG_TYPE_ACOMPRESS) {
-		acomp = crypto_alloc_acomp(driver, type, mask);
-		if (IS_ERR(acomp)) {
-			if (PTR_ERR(acomp) == -ENOENT)
-				return 0;
-			pr_err("alg: acomp: Failed to load transform for %s: %ld\n",
-			       driver, PTR_ERR(acomp));
-			return PTR_ERR(acomp);
-		}
-		err = test_acomp(acomp, desc->suite.comp.comp.vecs,
-				 desc->suite.comp.decomp.vecs,
-				 desc->suite.comp.comp.count,
-				 desc->suite.comp.decomp.count);
-		crypto_free_acomp(acomp);
-	} else {
-		comp = crypto_alloc_comp(driver, type, mask);
-		if (IS_ERR(comp)) {
-			if (PTR_ERR(comp) == -ENOENT)
-				return 0;
-			pr_err("alg: comp: Failed to load transform for %s: %ld\n",
-			       driver, PTR_ERR(comp));
-			return PTR_ERR(comp);
-		}
-
-		err = test_comp(comp, desc->suite.comp.comp.vecs,
-				desc->suite.comp.decomp.vecs,
-				desc->suite.comp.comp.count,
-				desc->suite.comp.decomp.count);
-
-		crypto_free_comp(comp);
+	acomp = crypto_alloc_acomp(driver, type, mask);
+	if (IS_ERR(acomp)) {
+		if (PTR_ERR(acomp) == -ENOENT)
+			return 0;
+		pr_err("alg: acomp: Failed to load transform for %s: %ld\n",
+		       driver, PTR_ERR(acomp));
+		return PTR_ERR(acomp);
 	}
+	err = test_acomp(acomp, desc->suite.comp.comp.vecs,
+			 desc->suite.comp.decomp.vecs,
+			 desc->suite.comp.comp.count,
+			 desc->suite.comp.decomp.count);
+	crypto_free_acomp(acomp);
 	return err;
 }
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ea3b95bdbde3..1e3809d28abd 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -24,7 +24,6 @@
  */
 #define CRYPTO_ALG_TYPE_MASK		0x0000000f
 #define CRYPTO_ALG_TYPE_CIPHER		0x00000001
-#define CRYPTO_ALG_TYPE_COMPRESS	0x00000002
 #define CRYPTO_ALG_TYPE_AEAD		0x00000003
 #define CRYPTO_ALG_TYPE_LSKCIPHER	0x00000004
 #define CRYPTO_ALG_TYPE_SKCIPHER	0x00000005
@@ -246,26 +245,7 @@ struct cipher_alg {
 	void (*cia_decrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 };
 
-/**
- * struct compress_alg - compression/decompression algorithm
- * @coa_compress: Compress a buffer of specified length, storing the resulting
- *		  data in the specified buffer. Return the length of the
- *		  compressed data in dlen.
- * @coa_decompress: Decompress the source buffer, storing the uncompressed
- *		    data in the specified buffer. The length of the data is
- *		    returned in dlen.
- *
- * All fields are mandatory.
- */
-struct compress_alg {
-	int (*coa_compress)(struct crypto_tfm *tfm, const u8 *src,
-			    unsigned int slen, u8 *dst, unsigned int *dlen);
-	int (*coa_decompress)(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen);
-};
-
 #define cra_cipher	cra_u.cipher
-#define cra_compress	cra_u.compress
 
 /**
  * struct crypto_alg - definition of a cryptograpic cipher algorithm
@@ -316,7 +296,7 @@ struct compress_alg {
  *	      transformation types. There are multiple options, such as
  *	      &crypto_skcipher_type, &crypto_ahash_type, &crypto_rng_type.
  *	      This field might be empty. In that case, there are no common
- *	      callbacks. This is the case for: cipher, compress, shash.
+ *	      callbacks. This is the case for: cipher.
  * @cra_u: Callbacks implementing the transformation. This is a union of
  *	   multiple structures. Depending on the type of transformation selected
  *	   by @cra_type and @cra_flags above, the associated structure must be
@@ -335,8 +315,6 @@ struct compress_alg {
  *	      @cra_init.
  * @cra_u.cipher: Union member which contains a single-block symmetric cipher
  *		  definition. See @struct @cipher_alg.
- * @cra_u.compress: Union member which contains a (de)compression algorithm.
- *		    See @struct @compress_alg.
  * @cra_module: Owner of this transformation implementation. Set to THIS_MODULE
  * @cra_list: internally used
  * @cra_users: internally used
@@ -366,7 +344,6 @@ struct crypto_alg {
 
 	union {
 		struct cipher_alg cipher;
-		struct compress_alg compress;
 	} cra_u;
 
 	int (*cra_init)(struct crypto_tfm *tfm);
@@ -440,10 +417,6 @@ struct crypto_tfm {
 	void *__crt_ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
-struct crypto_comp {
-	struct crypto_tfm base;
-};
-
 /* 
  * Transform user interface.
  */
@@ -500,53 +473,6 @@ static inline unsigned int crypto_tfm_ctx_alignment(void)
 	return __alignof__(tfm->__crt_ctx);
 }
 
-static inline struct crypto_comp *__crypto_comp_cast(struct crypto_tfm *tfm)
-{
-	return (struct crypto_comp *)tfm;
-}
-
-static inline struct crypto_comp *crypto_alloc_comp(const char *alg_name,
-						    u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_COMPRESS;
-	mask |= CRYPTO_ALG_TYPE_MASK;
-
-	return __crypto_comp_cast(crypto_alloc_base(alg_name, type, mask));
-}
-
-static inline struct crypto_tfm *crypto_comp_tfm(struct crypto_comp *tfm)
-{
-	return &tfm->base;
-}
-
-static inline void crypto_free_comp(struct crypto_comp *tfm)
-{
-	crypto_free_tfm(crypto_comp_tfm(tfm));
-}
-
-static inline int crypto_has_comp(const char *alg_name, u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_COMPRESS;
-	mask |= CRYPTO_ALG_TYPE_MASK;
-
-	return crypto_has_alg(alg_name, type, mask);
-}
-
-static inline const char *crypto_comp_name(struct crypto_comp *tfm)
-{
-	return crypto_tfm_alg_name(crypto_comp_tfm(tfm));
-}
-
-int crypto_comp_compress(struct crypto_comp *tfm,
-			 const u8 *src, unsigned int slen,
-			 u8 *dst, unsigned int *dlen);
-
-int crypto_comp_decompress(struct crypto_comp *tfm,
-			   const u8 *src, unsigned int slen,
-			   u8 *dst, unsigned int *dlen);
-
 static inline void crypto_reqchain_init(struct crypto_async_request *req)
 {
 	req->err = -EINPROGRESS;
-- 
2.39.5

