Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744B1182B7;
	Wed, 25 Feb 2026 20:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772051386; cv=none; b=CLud2P5uMCqFntb9vmdzNiznRcR6CKoGX1ar7HdCBQuw/8AAewRQkXJNT4fJYfdrMwIIzLj2+cW/W0r4fvjBZNcL51LhOAufoi8FmmDR61qttfi9npGO1ZiksqrngzwhH2Aquxs4kLrXV0DuCcEs+OQnyJyqzm/qwJJG/TaAp70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772051386; c=relaxed/simple;
	bh=MsjBP+XADbnF2pGp+2ZYR3FW34IqUtLzh0Krsr1pUWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snCP98xTzyzhDLpky4pFllbnGUrnZdf0fPDKKqkudthZIM7G9q+kb7QaujraTWpz5Lcy9prQmBwoWHSZtEbeRSi9yLvZoI2wGt6ODhjjMHtdB7x+nK8qtS6ZvBAZap1Efi9CYObrfkq6mW+whKmR0jkkxarXFscoOWQFhHV4IR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=Q8CjVEgM; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=eC+t3KsH; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="Q8CjVEgM";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="eC+t3KsH"
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1772051376; bh=PCmcFIzhjnC9egGss+/wXYW
	qg/CtCSq4+JEDJ67Gi8g=; b=Q8CjVEgMx+wbWePMjVJemh4cmhVePvhQX2m3209eMrULgJj6dD
	1+Y1NWW/GD5I1LWxeYVOKzp0QPdKC0s8vJTI98p6hFhZoz5IwpPfETJL+ndBjJcObDVLQoI/xYv
	inBcfj2hSVXf3RVkSjwK2OtWM5roqQI8K5ZW9M4U0y1+D9o/Rd2ysMbw0tallRQ9CXL8c/3lhpD
	OdLBhKdnVU1zZj2j3VawrrzNQ7wzxdTsQU4f+BVDo009PQwUiNDsfReUm782OCnAoy1C6OQSs7t
	K5vyImEDXFOCi0/DFdtnxawad6JV0MQW7/+dJ1NjD9wTEKtVPD8YWpxVZIcQBBtzWYQ==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1772051376; bh=PCmcFIzhjnC9egGss+/wXYW
	qg/CtCSq4+JEDJ67Gi8g=; b=eC+t3KsHksvQ6o9Wdn2RFDOkol/mMsfRgL/zGSWhuV/3AOe+L8
	B9z5mu1AYkoKsrAeud1D61jymSS/+slEcnCw==;
From: Daniel Hodges <git@danielhodges.dev>
To: bpf@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: ast@kernel.org,
	andrii@kernel.org,
	daniel@iogearbox.net,
	vadim.fedorenko@linux.dev,
	song@kernel.org,
	yatsenko@meta.com,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	haoluo@google.com,
	jolsa@kernel.org,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	yonghong.song@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	Daniel Hodges <git@danielhodges.dev>
Subject: [PATCH bpf-next v8 1/4] bpf: Add hash kfunc for cryptographic hashing
Date: Wed, 25 Feb 2026 15:29:32 -0500
Message-ID: <20260225202935.31986-2-git@danielhodges.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260225202935.31986-1-git@danielhodges.dev>
References: <20260225202935.31986-1-git@danielhodges.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add bpf_crypto_shash module that registers a hash type with the BPF
crypto infrastructure, enabling BPF programs to access kernel hash
algorithms through a unified interface.

The bpf_crypto_type interface is extended with hash-specific callbacks:
   - alloc_tfm: Allocates crypto_shash context with proper descriptor size
   - free_tfm: Releases hash transform and context memory
   - has_algo: Checks algorithm availability via crypto_has_shash()
   - hash: Performs single-shot hashing via crypto_shash_digest()
   - digestsize: Returns the output size for the hash algorithm
   - get_flags: Exposes transform flags to BPF programs

Add bpf_crypto_hash() kfunc that works with any hash algorithm
registered in the kernel's crypto API through the BPF crypto type
system. This enables BPF programs to compute cryptographic hashes for
use cases such as content verification, integrity checking, and data
authentication.

Update bpf_crypto_ctx_create() to support keyless operations:
   - Hash algorithms don't require keys, unlike ciphers
   - Only validates key presence if type->setkey is defined
   - Conditionally sets IV/state length for cipher operations only

Signed-off-by: Daniel Hodges <git@danielhodges.dev>
---
 MAINTAINERS                  |  1 +
 crypto/Makefile              |  3 ++
 crypto/bpf_crypto_shash.c    | 96 ++++++++++++++++++++++++++++++++++++
 crypto/bpf_crypto_skcipher.c |  1 +
 include/linux/bpf_crypto.h   |  9 ++++
 kernel/bpf/crypto.c          | 93 ++++++++++++++++++++++++++++++----
 6 files changed, 194 insertions(+), 9 deletions(-)
 create mode 100644 crypto/bpf_crypto_shash.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 55af015174a5..6c78aae1bc6c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4801,6 +4801,7 @@ BPF [CRYPTO]
 M:	Vadim Fedorenko <vadim.fedorenko@linux.dev>
 L:	bpf@vger.kernel.org
 S:	Maintained
+F:	crypto/bpf_crypto_shash.c
 F:	crypto/bpf_crypto_skcipher.c
 F:	include/linux/bpf_crypto.h
 F:	kernel/bpf/crypto.c
diff --git a/crypto/Makefile b/crypto/Makefile
index 04e269117589..4db6a76d4c3e 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -32,6 +32,9 @@ obj-$(CONFIG_CRYPTO_ECHAINIV) += echainiv.o
 crypto_hash-y += ahash.o
 crypto_hash-y += shash.o
 obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
+ifeq ($(CONFIG_BPF_SYSCALL),y)
+obj-$(CONFIG_CRYPTO_HASH2) += bpf_crypto_shash.o
+endif
 
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 obj-$(CONFIG_CRYPTO_SIG2) += sig.o
diff --git a/crypto/bpf_crypto_shash.c b/crypto/bpf_crypto_shash.c
new file mode 100644
index 000000000000..6e9b0d757ec9
--- /dev/null
+++ b/crypto/bpf_crypto_shash.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/bpf_crypto.h>
+#include <crypto/hash.h>
+
+struct bpf_shash_ctx {
+	struct crypto_shash *tfm;
+	struct shash_desc desc;
+};
+
+static void *bpf_crypto_shash_alloc_tfm(const char *algo)
+{
+	struct bpf_shash_ctx *ctx;
+	struct crypto_shash *tfm;
+
+	tfm = crypto_alloc_shash(algo, 0, 0);
+	if (IS_ERR(tfm))
+		return tfm;
+
+	ctx = kzalloc(sizeof(*ctx) + crypto_shash_descsize(tfm), GFP_KERNEL);
+	if (!ctx) {
+		crypto_free_shash(tfm);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ctx->tfm = tfm;
+	ctx->desc.tfm = tfm;
+
+	return ctx;
+}
+
+static void bpf_crypto_shash_free_tfm(void *tfm)
+{
+	struct bpf_shash_ctx *ctx = tfm;
+
+	crypto_free_shash(ctx->tfm);
+	kfree(ctx);
+}
+
+static int bpf_crypto_shash_has_algo(const char *algo)
+{
+	return crypto_has_shash(algo, 0, 0);
+}
+
+static int bpf_crypto_shash_hash(void *tfm, const u8 *data, u8 *out,
+				 unsigned int len)
+{
+	struct bpf_shash_ctx *ctx = tfm;
+
+	return crypto_shash_digest(&ctx->desc, data, len, out);
+}
+
+static unsigned int bpf_crypto_shash_digestsize(void *tfm)
+{
+	struct bpf_shash_ctx *ctx = tfm;
+
+	return crypto_shash_digestsize(ctx->tfm);
+}
+
+static u32 bpf_crypto_shash_get_flags(void *tfm)
+{
+	struct bpf_shash_ctx *ctx = tfm;
+
+	return crypto_shash_get_flags(ctx->tfm);
+}
+
+static const struct bpf_crypto_type bpf_crypto_shash_type = {
+	.alloc_tfm	= bpf_crypto_shash_alloc_tfm,
+	.free_tfm	= bpf_crypto_shash_free_tfm,
+	.has_algo	= bpf_crypto_shash_has_algo,
+	.hash		= bpf_crypto_shash_hash,
+	.digestsize	= bpf_crypto_shash_digestsize,
+	.get_flags	= bpf_crypto_shash_get_flags,
+	.owner		= THIS_MODULE,
+	.type_id	= BPF_CRYPTO_TYPE_HASH,
+	.name		= "hash",
+};
+
+static int __init bpf_crypto_shash_init(void)
+{
+	return bpf_crypto_register_type(&bpf_crypto_shash_type);
+}
+
+static void __exit bpf_crypto_shash_exit(void)
+{
+	int err = bpf_crypto_unregister_type(&bpf_crypto_shash_type);
+
+	WARN_ON_ONCE(err);
+}
+
+module_init(bpf_crypto_shash_init);
+module_exit(bpf_crypto_shash_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Hash algorithm support for BPF");
diff --git a/crypto/bpf_crypto_skcipher.c b/crypto/bpf_crypto_skcipher.c
index a88798d3e8c8..79d310fbcc48 100644
--- a/crypto/bpf_crypto_skcipher.c
+++ b/crypto/bpf_crypto_skcipher.c
@@ -63,6 +63,7 @@ static const struct bpf_crypto_type bpf_crypto_lskcipher_type = {
 	.statesize	= bpf_crypto_lskcipher_statesize,
 	.get_flags	= bpf_crypto_lskcipher_get_flags,
 	.owner		= THIS_MODULE,
+	.type_id	= BPF_CRYPTO_TYPE_SKCIPHER,
 	.name		= "skcipher",
 };
 
diff --git a/include/linux/bpf_crypto.h b/include/linux/bpf_crypto.h
index a41e71d4e2d9..cf2c66f9782b 100644
--- a/include/linux/bpf_crypto.h
+++ b/include/linux/bpf_crypto.h
@@ -3,6 +3,12 @@
 #ifndef _BPF_CRYPTO_H
 #define _BPF_CRYPTO_H
 
+enum bpf_crypto_type_id {
+	BPF_CRYPTO_TYPE_SKCIPHER = 1,
+	BPF_CRYPTO_TYPE_HASH,
+	BPF_CRYPTO_TYPE_SIG,
+};
+
 struct bpf_crypto_type {
 	void *(*alloc_tfm)(const char *algo);
 	void (*free_tfm)(void *tfm);
@@ -11,10 +17,13 @@ struct bpf_crypto_type {
 	int (*setauthsize)(void *tfm, unsigned int authsize);
 	int (*encrypt)(void *tfm, const u8 *src, u8 *dst, unsigned int len, u8 *iv);
 	int (*decrypt)(void *tfm, const u8 *src, u8 *dst, unsigned int len, u8 *iv);
+	int (*hash)(void *tfm, const u8 *data, u8 *out, unsigned int len);
 	unsigned int (*ivsize)(void *tfm);
 	unsigned int (*statesize)(void *tfm);
+	unsigned int (*digestsize)(void *tfm);
 	u32 (*get_flags)(void *tfm);
 	struct module *owner;
+	enum bpf_crypto_type_id type_id;
 	char name[14];
 };
 
diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
index 51f89cecefb4..3b2b0d06f1b2 100644
--- a/kernel/bpf/crypto.c
+++ b/kernel/bpf/crypto.c
@@ -139,7 +139,7 @@ __bpf_kfunc_start_defs();
  * It may return NULL if no memory is available.
  * @params:	pointer to struct bpf_crypto_params which contains all the
  *		details needed to initialise crypto context.
- * @params__sz:	size of steuct bpf_crypto_params usef by bpf program
+ * @params__sz:	size of struct bpf_crypto_params used by bpf program
  * @err:	integer to store error code when NULL is returned.
  */
 __bpf_kfunc struct bpf_crypto_ctx *
@@ -171,7 +171,12 @@ bpf_crypto_ctx_create(const struct bpf_crypto_params *params, u32 params__sz,
 		goto err_module_put;
 	}
 
-	if (!params->key_len || params->key_len > sizeof(params->key)) {
+	/* Hash operations don't require a key, but cipher operations do */
+	if (params->key_len > sizeof(params->key)) {
+		*err = -EINVAL;
+		goto err_module_put;
+	}
+	if (!params->key_len && type->setkey) {
 		*err = -EINVAL;
 		goto err_module_put;
 	}
@@ -195,16 +200,23 @@ bpf_crypto_ctx_create(const struct bpf_crypto_params *params, u32 params__sz,
 			goto err_free_tfm;
 	}
 
-	*err = type->setkey(ctx->tfm, params->key, params->key_len);
-	if (*err)
-		goto err_free_tfm;
+	if (params->key_len) {
+		if (!type->setkey) {
+			*err = -EINVAL;
+			goto err_free_tfm;
+		}
+		*err = type->setkey(ctx->tfm, params->key, params->key_len);
+		if (*err)
+			goto err_free_tfm;
 
-	if (type->get_flags(ctx->tfm) & CRYPTO_TFM_NEED_KEY) {
-		*err = -EINVAL;
-		goto err_free_tfm;
+		if (type->get_flags(ctx->tfm) & CRYPTO_TFM_NEED_KEY) {
+			*err = -EINVAL;
+			goto err_free_tfm;
+		}
 	}
 
-	ctx->siv_len = type->ivsize(ctx->tfm) + type->statesize(ctx->tfm);
+	if (type->ivsize && type->statesize)
+		ctx->siv_len = type->ivsize(ctx->tfm) + type->statesize(ctx->tfm);
 
 	refcount_set(&ctx->usage, 1);
 
@@ -325,6 +337,9 @@ __bpf_kfunc int bpf_crypto_decrypt(struct bpf_crypto_ctx *ctx,
 	const struct bpf_dynptr_kern *dst_kern = (struct bpf_dynptr_kern *)dst;
 	const struct bpf_dynptr_kern *siv_kern = (struct bpf_dynptr_kern *)siv__nullable;
 
+	if (ctx->type->type_id != BPF_CRYPTO_TYPE_SKCIPHER)
+		return -EINVAL;
+
 	return bpf_crypto_crypt(ctx, src_kern, dst_kern, siv_kern, true);
 }
 
@@ -346,9 +361,64 @@ __bpf_kfunc int bpf_crypto_encrypt(struct bpf_crypto_ctx *ctx,
 	const struct bpf_dynptr_kern *dst_kern = (struct bpf_dynptr_kern *)dst;
 	const struct bpf_dynptr_kern *siv_kern = (struct bpf_dynptr_kern *)siv__nullable;
 
+	if (ctx->type->type_id != BPF_CRYPTO_TYPE_SKCIPHER)
+		return -EINVAL;
+
 	return bpf_crypto_crypt(ctx, src_kern, dst_kern, siv_kern, false);
 }
 
+#if IS_ENABLED(CONFIG_CRYPTO_HASH2)
+/**
+ * bpf_crypto_hash() - Compute hash using configured context
+ * @ctx:	The crypto context being used. The ctx must be a trusted pointer.
+ * @data:	bpf_dynptr to the input data to hash. Must be a trusted pointer.
+ * @out:	bpf_dynptr to the output buffer. Must be a trusted pointer.
+ *
+ * Computes hash of the input data using the crypto context. The output buffer
+ * must be at least as large as the digest size of the hash algorithm.
+ */
+__bpf_kfunc int bpf_crypto_hash(struct bpf_crypto_ctx *ctx,
+				const struct bpf_dynptr *data,
+				const struct bpf_dynptr *out)
+{
+	const struct bpf_dynptr_kern *data_kern = (struct bpf_dynptr_kern *)data;
+	const struct bpf_dynptr_kern *out_kern = (struct bpf_dynptr_kern *)out;
+	unsigned int digestsize;
+	u64 data_len, out_len;
+	const u8 *data_ptr;
+	u8 *out_ptr;
+
+	if (ctx->type->type_id != BPF_CRYPTO_TYPE_HASH)
+		return -EINVAL;
+
+	if (!ctx->type->hash)
+		return -EOPNOTSUPP;
+
+	data_len = __bpf_dynptr_size(data_kern);
+	out_len = __bpf_dynptr_size(out_kern);
+
+	if (data_len == 0 || data_len > UINT_MAX)
+		return -EINVAL;
+
+	if (!ctx->type->digestsize)
+		return -EOPNOTSUPP;
+
+	digestsize = ctx->type->digestsize(ctx->tfm);
+	if (out_len < digestsize)
+		return -EINVAL;
+
+	data_ptr = __bpf_dynptr_data(data_kern, data_len);
+	if (!data_ptr)
+		return -EINVAL;
+
+	out_ptr = __bpf_dynptr_data_rw(out_kern, out_len);
+	if (!out_ptr)
+		return -EINVAL;
+
+	return ctx->type->hash(ctx->tfm, data_ptr, out_ptr, data_len);
+}
+#endif /* CONFIG_CRYPTO_HASH2 */
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(crypt_init_kfunc_btf_ids)
@@ -365,6 +435,9 @@ static const struct btf_kfunc_id_set crypt_init_kfunc_set = {
 BTF_KFUNCS_START(crypt_kfunc_btf_ids)
 BTF_ID_FLAGS(func, bpf_crypto_decrypt, KF_RCU)
 BTF_ID_FLAGS(func, bpf_crypto_encrypt, KF_RCU)
+#if IS_ENABLED(CONFIG_CRYPTO_HASH2)
+BTF_ID_FLAGS(func, bpf_crypto_hash, KF_RCU)
+#endif
 BTF_KFUNCS_END(crypt_kfunc_btf_ids)
 
 static const struct btf_kfunc_id_set crypt_kfunc_set = {
@@ -389,6 +462,8 @@ static int __init crypto_kfunc_init(void)
 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &crypt_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT, &crypt_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &crypt_kfunc_set);
+	/* Register for SYSCALL programs to enable testing and debugging */
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &crypt_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
 					       &crypt_init_kfunc_set);
 	return  ret ?: register_btf_id_dtor_kfuncs(bpf_crypto_dtors,
-- 
2.52.0

