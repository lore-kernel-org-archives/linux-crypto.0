Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C68B3A9DB2;
	Wed, 23 Sep 2026 03:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790134132; cv=none; b=U83UMu066V8oFCqvyz0hVYeWi4uXOFSIPeu5pLqNqdnZqcjATaXNHyQI7SuikL3dgoJptN9zoCTillaVTBcNZSzflqaBsZI7obZGSwAaplk7O4IfzQwHM0gYlatkwnNg7h3hAZu9slhgL4TZuBkdbsJD9umOFONi9C0kR1cIDTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790134132; c=relaxed/simple;
	bh=+CrSM+yHlgQSZnLvp5Edjr709M3p2nq6Cq1R9tncsuA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uUlsIMUIPy4z+x1b6uA50HZGyd5yHPVB3FP5S5QFja7XNNQrw7EuY+Z1w8wbgUvWxmxfkH1fm6s933G82irdUCDQaae18/TiJ3pauvrw1sPGe/YBPciQuci8Bk57/Kddsq2DPFrOSe180sa79AbZUTn7kiZhQCGTnIksRMW4ILc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ayyi1jjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ayyi1jjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FFF1F000FF;
	Wed, 23 Sep 2026 03:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790134129;
	bh=gxUBRvYi+dZK3toKjOTQpLE7f4LfUvtweJZ4/n8kRb0=;
	h=From:To:Cc:Subject:Date;
	b=Ayyi1jjWjTSvf+VWy4dJ9G4zY3j3BWyynO85v1u6QPYq8yby3dmWFPIWU8lLP01/L
	 kuoNW4HNCQ0jP+CpPVcBiz2WAWwOu7GkkKB7/Vxj8JXfugnts01UjpUaRXKraCYQW5
	 4sl7kJo4ZPTVu//0ygG/uXxOgGqDgnKc3mm5PUK5H0nzD0kRy2I3QxZUd8HXJ9b4EO
	 PMIDTVFdVCS7iISfzoAiBT5BYnUVb3ONs/4imwn4YngqGBrLjcew9sF0WOKgnoSkYs
	 NIuASnZVe0txFkDWk3CBDOkB4Ee7md0G0HncBFnOZ1J880Gl+/ItveAgcbmC7uJgjg
	 z4te2Oo6kGavQ==
From: Eric Biggers <ebiggers@kernel.org>
To: bpf@vger.kernel.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH bpf-next v4] bpf: crypto: Use AES-CBC and AES-ECB libraries
Date: Tue, 22 Sep 2026 20:27:03 -0700
Message-ID: <20260923032703.59816-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BPF crypto was implemented using the lskcipher API, which doesn't seem
to be going anywhere.  lskcipher supports only ARC4 and block ciphers in
CBC and ECB mode, and only with unoptimized implementations.

Library APIs also have been found to be a much better approach, for a
variety of reasons, including reduced overhead, greater flexibility, and
having to be explicit about the crypto algorithms that are supported.

We can safely ignore the theoretical ARC4 and non-AES block cipher
support in BPF crypto as unused, which leaves AES-CBC and AES-ECB.
AES-CBC was stated to be needed for decrypting packets using a homebrew
UDP-based protocol
(https://lore.kernel.org/r/d1cdfc23-b336-49a9-8833-29f05b5b9fec@linux.dev/).
AES-ECB is used by the BPF self-tests, and it was stated to maybe be
used in the future for QUIC-LB
(https://lore.kernel.org/r/5f9c3aab-5339-463c-a86d-edac297e1e95@linux.dev/).

Those reasons don't make much sense either, especially AES-ECB which
isn't appropriate in new systems and should be dropped.  Regardless,
let's assume that both AES-CBC and AES-ECB need to be kept for now.

There are library APIs for both of these now, which are much easier to
use and more efficient.  Reimplement BPF crypto on top of them, greatly
simplifying the code.  As part of this, the bpf_crypto_type abstraction
layer is removed, as it's not useful.

This removes the only user of the lskcipher API, so follow-up patches
will be able to remove that code as well.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

Changed in v4:
    - Switch back to the embedded struct used in v1 and v2.

Changed in v3:
    - Update the #ifdef in kernel/bpf/verifier.c.
    - Store the key behind a void pointer so that BPF programs can't
      read it via BTF, as requested by the bpf-ci AI review.
    - Update the selftests kconfig.
    - Use WARN_ON_ONCE instead of WARN_ON.

Changed in v2:
    - Use 'depends on' instead of 'select', to match the usual
      convention for bpf kfuncs.
    - Keep using EOPNOTSUPP for unsupported algorithms.
    - Avoid reading *err_ret after it's been written.
    - Clarify that non-AES block ciphers are dropped too.
    - Mention that lskcipher will be deleted later.
    - Update a comment.

 MAINTAINERS                        |   2 -
 crypto/Makefile                    |   3 -
 crypto/bpf_crypto_skcipher.c       |  83 ---------
 include/linux/bpf_crypto.h         |  24 ---
 kernel/bpf/Kconfig                 |   9 +
 kernel/bpf/Makefile                |   4 +-
 kernel/bpf/crypto.c                | 288 +++++++++++++----------------
 kernel/bpf/verifier.c              |   2 +-
 tools/testing/selftests/bpf/config |   2 +-
 9 files changed, 136 insertions(+), 281 deletions(-)
 delete mode 100644 crypto/bpf_crypto_skcipher.c
 delete mode 100644 include/linux/bpf_crypto.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 6215fcb077705..0fcdfe48c62a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4936,8 +4936,6 @@ BPF [CRYPTO]
 M:	Vadim Fedorenko <vadim.fedorenko@linux.dev>
 L:	bpf@vger.kernel.org
 S:	Maintained
-F:	crypto/bpf_crypto_skcipher.c
-F:	include/linux/bpf_crypto.h
 F:	kernel/bpf/crypto.c
 
 BPF [DOCUMENTATION] (Related to Standardization)
diff --git a/crypto/Makefile b/crypto/Makefile
index 8386d55a9755e..33bb5ad595e8f 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -22,9 +22,6 @@ crypto_skcipher-y += lskcipher.o
 crypto_skcipher-y += skcipher.o
 
 obj-$(CONFIG_CRYPTO_SKCIPHER2) += crypto_skcipher.o
-ifeq ($(CONFIG_BPF_SYSCALL),y)
-obj-$(CONFIG_CRYPTO_SKCIPHER2) += bpf_crypto_skcipher.o
-endif
 
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 obj-$(CONFIG_CRYPTO_ECHAINIV) += echainiv.o
diff --git a/crypto/bpf_crypto_skcipher.c b/crypto/bpf_crypto_skcipher.c
deleted file mode 100644
index a88798d3e8c87..0000000000000
--- a/crypto/bpf_crypto_skcipher.c
+++ /dev/null
@@ -1,83 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2024 Meta, Inc */
-#include <linux/types.h>
-#include <linux/module.h>
-#include <linux/bpf_crypto.h>
-#include <crypto/skcipher.h>
-
-static void *bpf_crypto_lskcipher_alloc_tfm(const char *algo)
-{
-	return crypto_alloc_lskcipher(algo, 0, 0);
-}
-
-static void bpf_crypto_lskcipher_free_tfm(void *tfm)
-{
-	crypto_free_lskcipher(tfm);
-}
-
-static int bpf_crypto_lskcipher_has_algo(const char *algo)
-{
-	return crypto_has_skcipher(algo, CRYPTO_ALG_TYPE_LSKCIPHER, CRYPTO_ALG_TYPE_MASK);
-}
-
-static int bpf_crypto_lskcipher_setkey(void *tfm, const u8 *key, unsigned int keylen)
-{
-	return crypto_lskcipher_setkey(tfm, key, keylen);
-}
-
-static u32 bpf_crypto_lskcipher_get_flags(void *tfm)
-{
-	return crypto_lskcipher_get_flags(tfm);
-}
-
-static unsigned int bpf_crypto_lskcipher_ivsize(void *tfm)
-{
-	return crypto_lskcipher_ivsize(tfm);
-}
-
-static unsigned int bpf_crypto_lskcipher_statesize(void *tfm)
-{
-	return crypto_lskcipher_statesize(tfm);
-}
-
-static int bpf_crypto_lskcipher_encrypt(void *tfm, const u8 *src, u8 *dst,
-					unsigned int len, u8 *siv)
-{
-	return crypto_lskcipher_encrypt(tfm, src, dst, len, siv);
-}
-
-static int bpf_crypto_lskcipher_decrypt(void *tfm, const u8 *src, u8 *dst,
-					unsigned int len, u8 *siv)
-{
-	return crypto_lskcipher_decrypt(tfm, src, dst, len, siv);
-}
-
-static const struct bpf_crypto_type bpf_crypto_lskcipher_type = {
-	.alloc_tfm	= bpf_crypto_lskcipher_alloc_tfm,
-	.free_tfm	= bpf_crypto_lskcipher_free_tfm,
-	.has_algo	= bpf_crypto_lskcipher_has_algo,
-	.setkey		= bpf_crypto_lskcipher_setkey,
-	.encrypt	= bpf_crypto_lskcipher_encrypt,
-	.decrypt	= bpf_crypto_lskcipher_decrypt,
-	.ivsize		= bpf_crypto_lskcipher_ivsize,
-	.statesize	= bpf_crypto_lskcipher_statesize,
-	.get_flags	= bpf_crypto_lskcipher_get_flags,
-	.owner		= THIS_MODULE,
-	.name		= "skcipher",
-};
-
-static int __init bpf_crypto_skcipher_init(void)
-{
-	return bpf_crypto_register_type(&bpf_crypto_lskcipher_type);
-}
-
-static void __exit bpf_crypto_skcipher_exit(void)
-{
-	int err = bpf_crypto_unregister_type(&bpf_crypto_lskcipher_type);
-	WARN_ON_ONCE(err);
-}
-
-module_init(bpf_crypto_skcipher_init);
-module_exit(bpf_crypto_skcipher_exit);
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Symmetric key cipher support for BPF");
diff --git a/include/linux/bpf_crypto.h b/include/linux/bpf_crypto.h
deleted file mode 100644
index a41e71d4e2d9f..0000000000000
--- a/include/linux/bpf_crypto.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2024 Meta Platforms, Inc. and affiliates. */
-#ifndef _BPF_CRYPTO_H
-#define _BPF_CRYPTO_H
-
-struct bpf_crypto_type {
-	void *(*alloc_tfm)(const char *algo);
-	void (*free_tfm)(void *tfm);
-	int (*has_algo)(const char *algo);
-	int (*setkey)(void *tfm, const u8 *key, unsigned int keylen);
-	int (*setauthsize)(void *tfm, unsigned int authsize);
-	int (*encrypt)(void *tfm, const u8 *src, u8 *dst, unsigned int len, u8 *iv);
-	int (*decrypt)(void *tfm, const u8 *src, u8 *dst, unsigned int len, u8 *iv);
-	unsigned int (*ivsize)(void *tfm);
-	unsigned int (*statesize)(void *tfm);
-	u32 (*get_flags)(void *tfm);
-	struct module *owner;
-	char name[14];
-};
-
-int bpf_crypto_register_type(const struct bpf_crypto_type *type);
-int bpf_crypto_unregister_type(const struct bpf_crypto_type *type);
-
-#endif /* _BPF_CRYPTO_H */
diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index d7d25477ef481..a44ecfa3e9ef5 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -91,6 +91,15 @@ config BPF_UNPRIV_DEFAULT_OFF
 
 	  If you are unsure how to answer this question, answer Y.
 
+config BPF_CRYPTO
+	def_bool y
+	depends on BPF_SYSCALL
+	depends on CRYPTO_LIB_AES_CBC
+	depends on CRYPTO_LIB_AES_ECB
+	help
+	  Provide the kfuncs needed for BPF programs to encrypt and decrypt
+	  data. The supported algorithms are AES-CBC and AES-ECB.
+
 source "kernel/bpf/preload/Kconfig"
 
 config BPF_LSM
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 9a92c348bbda6..c1f9b0d3468d3 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -58,9 +58,7 @@ obj-$(CONFIG_BPF_SYSCALL) += cpumask.o
 # semantics within pahole are revisited accordingly.
 obj-${CONFIG_BPF_LSM} += bpf_lsm_proto.o bpf_lsm.o
 endif
-ifneq ($(CONFIG_CRYPTO),)
-obj-$(CONFIG_BPF_SYSCALL) += crypto.o
-endif
+obj-$(CONFIG_BPF_CRYPTO) += crypto.o
 obj-$(CONFIG_BPF_PRELOAD) += preload/
 
 obj-$(CONFIG_BPF_SYSCALL) += relo_core.o
diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
index 51f89cecefb4d..784e2bd5ca924 100644
--- a/kernel/bpf/crypto.c
+++ b/kernel/bpf/crypto.c
@@ -1,19 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2024 Meta, Inc */
 #include <linux/bpf.h>
-#include <linux/bpf_crypto.h>
 #include <linux/bpf_mem_alloc.h>
 #include <linux/btf.h>
 #include <linux/btf_ids.h>
 #include <linux/filter.h>
-#include <linux/scatterlist.h>
 #include <linux/skbuff.h>
-#include <crypto/skcipher.h>
-
-struct bpf_crypto_type_list {
-	const struct bpf_crypto_type *type;
-	struct list_head list;
-};
+#include <crypto/aes-cbc.h>
+#include <crypto/aes-ecb.h>
 
 /* BPF crypto initialization parameters struct */
 /**
@@ -36,94 +30,53 @@ struct bpf_crypto_params {
 	u32 authsize;
 };
 
-static LIST_HEAD(bpf_crypto_types);
-static DECLARE_RWSEM(bpf_crypto_types_sem);
+enum bpf_crypto_algo_id {
+	BPF_ALGO_AES_CBC,
+	BPF_ALGO_AES_ECB,
+};
+
+static const struct {
+	const char *type_name;
+	const char *algo_name;
+	enum bpf_crypto_algo_id algo;
+} bpf_crypto_algos[] = {
+	{ "skcipher", "cbc(aes)", BPF_ALGO_AES_CBC },
+	{ "skcipher", "ecb(aes)", BPF_ALGO_AES_ECB },
+};
+
+static bool bpf_crypto_find_algo(const struct bpf_crypto_params *params,
+				 enum bpf_crypto_algo_id *id_ret)
+{
+	for (size_t i = 0; i < ARRAY_SIZE(bpf_crypto_algos); i++) {
+		if (strncmp(bpf_crypto_algos[i].type_name, params->type,
+			    sizeof(params->type)) == 0 &&
+		    strncmp(bpf_crypto_algos[i].algo_name, params->algo,
+			    sizeof(params->algo)) == 0) {
+			*id_ret = bpf_crypto_algos[i].algo;
+			return true;
+		}
+	}
+	return false;
+}
 
 /**
  * struct bpf_crypto_ctx - refcounted BPF crypto context structure
- * @type:	The pointer to bpf crypto type
- * @tfm:	The pointer to instance of crypto API struct.
- * @siv_len:    Size of IV and state storage for cipher
+ * @algo:	The crypto algorithm ID
+ * @key:	The crypto key
  * @rcu:	The RCU head used to free the crypto context with RCU safety.
  * @usage:	Object reference counter. When the refcount goes to 0, the
  *		memory is released back to the BPF allocator, which provides
  *		RCU safety.
  */
 struct bpf_crypto_ctx {
-	const struct bpf_crypto_type *type;
-	void *tfm;
-	u32 siv_len;
+	enum bpf_crypto_algo_id algo;
+	union {
+		struct aes_key aes;
+	} key;
 	struct rcu_head rcu;
 	refcount_t usage;
 };
 
-int bpf_crypto_register_type(const struct bpf_crypto_type *type)
-{
-	struct bpf_crypto_type_list *node;
-	int err = -EBUSY;
-
-	down_write(&bpf_crypto_types_sem);
-	list_for_each_entry(node, &bpf_crypto_types, list) {
-		if (!strcmp(node->type->name, type->name))
-			goto unlock;
-	}
-
-	node = kmalloc_obj(*node);
-	err = -ENOMEM;
-	if (!node)
-		goto unlock;
-
-	node->type = type;
-	list_add(&node->list, &bpf_crypto_types);
-	err = 0;
-
-unlock:
-	up_write(&bpf_crypto_types_sem);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(bpf_crypto_register_type);
-
-int bpf_crypto_unregister_type(const struct bpf_crypto_type *type)
-{
-	struct bpf_crypto_type_list *node;
-	int err = -ENOENT;
-
-	down_write(&bpf_crypto_types_sem);
-	list_for_each_entry(node, &bpf_crypto_types, list) {
-		if (strcmp(node->type->name, type->name))
-			continue;
-
-		list_del(&node->list);
-		kfree(node);
-		err = 0;
-		break;
-	}
-	up_write(&bpf_crypto_types_sem);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(bpf_crypto_unregister_type);
-
-static const struct bpf_crypto_type *bpf_crypto_get_type(const char *name)
-{
-	const struct bpf_crypto_type *type = ERR_PTR(-ENOENT);
-	struct bpf_crypto_type_list *node;
-
-	down_read(&bpf_crypto_types_sem);
-	list_for_each_entry(node, &bpf_crypto_types, list) {
-		if (strcmp(node->type->name, name))
-			continue;
-
-		if (try_module_get(node->type->owner))
-			type = node->type;
-		break;
-	}
-	up_read(&bpf_crypto_types_sem);
-
-	return type;
-}
-
 __bpf_kfunc_start_defs();
 
 /**
@@ -132,92 +85,69 @@ __bpf_kfunc_start_defs();
  * Allocates a crypto context that can be used, acquired, and released by
  * a BPF program. The crypto context returned by this function must either
  * be embedded in a map as a kptr, or freed with bpf_crypto_ctx_release().
- * As crypto API functions use GFP_KERNEL allocations, this function can
- * only be used in sleepable BPF programs.
+ * As this uses a GFP_KERNEL allocation, this function can only be used in
+ * sleepable BPF programs.
  *
  * bpf_crypto_ctx_create() allocates memory for crypto context.
  * It may return NULL if no memory is available.
  * @params:	pointer to struct bpf_crypto_params which contains all the
  *		details needed to initialise crypto context.
- * @params__sz:	size of steuct bpf_crypto_params usef by bpf program
- * @err:	integer to store error code when NULL is returned.
+ * @params__sz:	size of struct bpf_crypto_params used by bpf program
+ * @err_ret:	integer to store error code when NULL is returned.
  */
 __bpf_kfunc struct bpf_crypto_ctx *
 bpf_crypto_ctx_create(const struct bpf_crypto_params *params, u32 params__sz,
-		      int *err)
+		      int *err_ret)
 {
-	const struct bpf_crypto_type *type;
 	struct bpf_crypto_ctx *ctx;
+	int err;
 
 	if (!params || params->reserved[0] || params->reserved[1] ||
 	    params__sz != sizeof(struct bpf_crypto_params)) {
-		*err = -EINVAL;
+		*err_ret = -EINVAL;
 		return NULL;
 	}
 
-	type = bpf_crypto_get_type(params->type);
-	if (IS_ERR(type)) {
-		*err = PTR_ERR(type);
-		return NULL;
-	}
-
-	if (!type->has_algo(params->algo)) {
-		*err = -EOPNOTSUPP;
-		goto err_module_put;
-	}
-
-	if (!!params->authsize ^ !!type->setauthsize) {
-		*err = -EOPNOTSUPP;
-		goto err_module_put;
-	}
-
 	if (!params->key_len || params->key_len > sizeof(params->key)) {
-		*err = -EINVAL;
-		goto err_module_put;
+		*err_ret = -EINVAL;
+		return NULL;
 	}
 
 	ctx = kzalloc_obj(*ctx);
 	if (!ctx) {
-		*err = -ENOMEM;
-		goto err_module_put;
+		*err_ret = -ENOMEM;
+		return NULL;
 	}
 
-	ctx->type = type;
-	ctx->tfm = type->alloc_tfm(params->algo);
-	if (IS_ERR(ctx->tfm)) {
-		*err = PTR_ERR(ctx->tfm);
-		goto err_free_ctx;
+	if (!bpf_crypto_find_algo(params, &ctx->algo)) {
+		err = -EOPNOTSUPP;
+		goto out;
 	}
 
-	if (params->authsize) {
-		*err = type->setauthsize(ctx->tfm, params->authsize);
-		if (*err)
-			goto err_free_tfm;
+	switch (ctx->algo) {
+	case BPF_ALGO_AES_CBC:
+	case BPF_ALGO_AES_ECB:
+		if (params->authsize)
+			err = -EOPNOTSUPP;
+		else
+			err = aes_preparekey(&ctx->key.aes, params->key,
+					     params->key_len);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		err = -EOPNOTSUPP;
+		break;
 	}
 
-	*err = type->setkey(ctx->tfm, params->key, params->key_len);
-	if (*err)
-		goto err_free_tfm;
-
-	if (type->get_flags(ctx->tfm) & CRYPTO_TFM_NEED_KEY) {
-		*err = -EINVAL;
-		goto err_free_tfm;
+out:
+	if (err) {
+		kfree_sensitive(ctx);
+		*err_ret = err;
+		return NULL;
 	}
-
-	ctx->siv_len = type->ivsize(ctx->tfm) + type->statesize(ctx->tfm);
-
 	refcount_set(&ctx->usage, 1);
-
+	*err_ret = 0;
 	return ctx;
-
-err_free_tfm:
-	type->free_tfm(ctx->tfm);
-err_free_ctx:
-	kfree(ctx);
-err_module_put:
-	module_put(type->owner);
-
-	return NULL;
 }
 
 static void crypto_free_cb(struct rcu_head *head)
@@ -225,9 +155,7 @@ static void crypto_free_cb(struct rcu_head *head)
 	struct bpf_crypto_ctx *ctx;
 
 	ctx = container_of(head, struct bpf_crypto_ctx, rcu);
-	ctx->type->free_tfm(ctx->tfm);
-	module_put(ctx->type->owner);
-	kfree(ctx);
+	kfree_sensitive(ctx);
 }
 
 /**
@@ -267,27 +195,53 @@ __bpf_kfunc void bpf_crypto_ctx_release_dtor(void *ctx)
 }
 CFI_NOSEAL(bpf_crypto_ctx_release_dtor);
 
+static int bpf_aes_cbc_crypt(u8 *dst, u32 dst_len, const u8 *src, u32 src_len,
+			     u8 *iv, u32 iv_len,
+			     const struct bpf_crypto_ctx *ctx, bool decrypt)
+{
+	if (iv_len != AES_BLOCK_SIZE)
+		return -EINVAL;
+	if (src_len % AES_BLOCK_SIZE || dst_len < src_len)
+		return -EINVAL;
+	if (decrypt)
+		aes_cbc_decrypt(dst, src, src_len, iv, &ctx->key.aes);
+	else
+		aes_cbc_encrypt(dst, src, src_len, iv, &ctx->key.aes);
+	return 0;
+}
+
+static int bpf_aes_ecb_crypt(u8 *dst, u32 dst_len, const u8 *src, u32 src_len,
+			     u8 *iv, u32 iv_len,
+			     const struct bpf_crypto_ctx *ctx, bool decrypt)
+{
+	if (iv_len != 0)
+		return -EINVAL;
+	if (src_len % AES_BLOCK_SIZE || dst_len < src_len)
+		return -EINVAL;
+	if (decrypt)
+		aes_ecb_decrypt(dst, src, src_len, &ctx->key.aes);
+	else
+		aes_ecb_encrypt(dst, src, src_len, &ctx->key.aes);
+	return 0;
+}
+
 static int bpf_crypto_crypt(const struct bpf_crypto_ctx *ctx,
 			    const struct bpf_dynptr_kern *src,
 			    const struct bpf_dynptr_kern *dst,
-			    const struct bpf_dynptr_kern *siv,
+			    const struct bpf_dynptr_kern *iv,
 			    bool decrypt)
 {
-	u32 src_len, dst_len, siv_len;
+	u32 src_len, dst_len, iv_len;
 	const u8 *psrc;
 	u8 *pdst, *piv;
-	int err;
 
 	if (__bpf_dynptr_is_rdonly(dst))
 		return -EINVAL;
 
-	siv_len = siv ? __bpf_dynptr_size(siv) : 0;
+	iv_len = iv ? __bpf_dynptr_size(iv) : 0;
 	src_len = __bpf_dynptr_size(src);
 	dst_len = __bpf_dynptr_size(dst);
-	if (!src_len || !dst_len || src_len > dst_len)
-		return -EINVAL;
-
-	if (siv_len != ctx->siv_len)
+	if (!src_len || !dst_len)
 		return -EINVAL;
 
 	psrc = __bpf_dynptr_data(src, src_len);
@@ -297,14 +251,20 @@ static int bpf_crypto_crypt(const struct bpf_crypto_ctx *ctx,
 	if (!pdst)
 		return -EINVAL;
 
-	piv = siv_len ? __bpf_dynptr_data_rw(siv, siv_len) : NULL;
-	if (siv_len && !piv)
+	piv = iv_len ? __bpf_dynptr_data_rw(iv, iv_len) : NULL;
+	if (iv_len && !piv)
 		return -EINVAL;
 
-	err = decrypt ? ctx->type->decrypt(ctx->tfm, psrc, pdst, src_len, piv)
-		      : ctx->type->encrypt(ctx->tfm, psrc, pdst, src_len, piv);
-
-	return err;
+	switch (ctx->algo) {
+	case BPF_ALGO_AES_CBC:
+		return bpf_aes_cbc_crypt(pdst, dst_len, psrc, src_len, piv,
+					 iv_len, ctx, decrypt);
+	case BPF_ALGO_AES_ECB:
+		return bpf_aes_ecb_crypt(pdst, dst_len, psrc, src_len, piv,
+					 iv_len, ctx, decrypt);
+	default:
+		return -EINVAL;
+	}
 }
 
 /**
@@ -312,20 +272,20 @@ static int bpf_crypto_crypt(const struct bpf_crypto_ctx *ctx,
  * @ctx:		The crypto context being used. The ctx must be a trusted pointer.
  * @src:		bpf_dynptr to the encrypted data. Must be a trusted pointer.
  * @dst:		bpf_dynptr to the buffer where to store the result. Must be a trusted pointer.
- * @siv__nullable:	bpf_dynptr to IV data and state data to be used by decryptor. May be NULL.
+ * @iv__nullable:	bpf_dynptr to the initialization vector. May be NULL.
  *
  * Decrypts provided buffer using IV data and the crypto context. Crypto context must be configured.
  */
 __bpf_kfunc int bpf_crypto_decrypt(struct bpf_crypto_ctx *ctx,
 				   const struct bpf_dynptr *src,
 				   const struct bpf_dynptr *dst,
-				   const struct bpf_dynptr *siv__nullable)
+				   const struct bpf_dynptr *iv__nullable)
 {
 	const struct bpf_dynptr_kern *src_kern = (struct bpf_dynptr_kern *)src;
 	const struct bpf_dynptr_kern *dst_kern = (struct bpf_dynptr_kern *)dst;
-	const struct bpf_dynptr_kern *siv_kern = (struct bpf_dynptr_kern *)siv__nullable;
+	const struct bpf_dynptr_kern *iv_kern = (struct bpf_dynptr_kern *)iv__nullable;
 
-	return bpf_crypto_crypt(ctx, src_kern, dst_kern, siv_kern, true);
+	return bpf_crypto_crypt(ctx, src_kern, dst_kern, iv_kern, true);
 }
 
 /**
@@ -333,20 +293,20 @@ __bpf_kfunc int bpf_crypto_decrypt(struct bpf_crypto_ctx *ctx,
  * @ctx:		The crypto context being used. The ctx must be a trusted pointer.
  * @src:		bpf_dynptr to the plain data. Must be a trusted pointer.
  * @dst:		bpf_dynptr to the buffer where to store the result. Must be a trusted pointer.
- * @siv__nullable:	bpf_dynptr to IV data and state data to be used by decryptor. May be NULL.
+ * @iv__nullable:	bpf_dynptr to the initialization vector. May be NULL.
  *
  * Encrypts provided buffer using IV data and the crypto context. Crypto context must be configured.
  */
 __bpf_kfunc int bpf_crypto_encrypt(struct bpf_crypto_ctx *ctx,
 				   const struct bpf_dynptr *src,
 				   const struct bpf_dynptr *dst,
-				   const struct bpf_dynptr *siv__nullable)
+				   const struct bpf_dynptr *iv__nullable)
 {
 	const struct bpf_dynptr_kern *src_kern = (struct bpf_dynptr_kern *)src;
 	const struct bpf_dynptr_kern *dst_kern = (struct bpf_dynptr_kern *)dst;
-	const struct bpf_dynptr_kern *siv_kern = (struct bpf_dynptr_kern *)siv__nullable;
+	const struct bpf_dynptr_kern *iv_kern = (struct bpf_dynptr_kern *)iv__nullable;
 
-	return bpf_crypto_crypt(ctx, src_kern, dst_kern, siv_kern, false);
+	return bpf_crypto_crypt(ctx, src_kern, dst_kern, iv_kern, false);
 }
 
 __bpf_kfunc_end_defs();
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a7c9e2d8965d5..e9c8f2444a8a0 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4669,7 +4669,7 @@ BTF_ID(struct, cgroup)
 BTF_ID(struct, bpf_cpumask)
 #endif
 BTF_ID(struct, task_struct)
-#ifdef CONFIG_CRYPTO
+#ifdef CONFIG_BPF_CRYPTO
 BTF_ID(struct, bpf_crypto_ctx)
 #endif
 #ifdef CONFIG_INET
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index d292cb60a5a4e..2b883b388f90c 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -18,7 +18,7 @@ CONFIG_CRYPTO_SHA512=y
 CONFIG_CRYPTO_USER_API=y
 CONFIG_CRYPTO_USER_API_HASH=y
 CONFIG_CRYPTO_USER_API_SKCIPHER=y
-CONFIG_CRYPTO_SKCIPHER=y
+CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
 CONFIG_CRYPTO_AES=y
 CONFIG_DEBUG_INFO=y

base-commit: 91f8613d95ad8cd99d8baf094806d1ef98bc6380
-- 
2.55.0

