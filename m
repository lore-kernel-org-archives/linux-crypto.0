Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B6336E496;
	Mon,  2 Feb 2026 14:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770043711; cv=none; b=TsbU/On3vKb1ydKhNi162qyu5N6l21022wuoUPi5HzjJLfDSn4sQ37SBdADmMZJvnaq/vIqsNhtNmJupH5s8SH40Z1xkkaEIifXworqO3xIPINZZ1GlelLfT0WroAzFIGZ3lJeEFFNy3zgdHswLbcKvQoOwTIcrrvPajKlf2FHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770043711; c=relaxed/simple;
	bh=hfR2t+Rj4L43274MI7GD78u5hjokRkYxEt/Ipw6lK/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIJ6UGTTac7zquPfv4Es/ZPT42TzfQgJ9igLyx7Q/3L3vhGMWmtM+ljkpnURWGA6pukcoV14PcCBRgOiORyibEgj+7nH7gOfpNxuIdRWMUAwco7eICGYO5SSnQXxcu19VaQbMGumsjWRFqQPq+kxleAhUpvSoH//CeVJWijGvqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=kGZxPC+V; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=/6Ri1U5Z; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="kGZxPC+V";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="/6Ri1U5Z"
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1770043671; bh=yXk4mfEUy0B9smgA0To3U/i
	eCUmK0yOemXhDKbFrGBw=; b=kGZxPC+VEgru8zi8ZPiABLzqG0le1MNkttUMN/2mw8SEZwRSUz
	llVwlzO0agPpCC5wzseVR5YOrxYINNud6DPOFpx77U+vbfx3UwuSH7uxyoTXB4nDrvuJLLa8G3C
	qTRwSoXr6hXSmfhwmeIXHuzMi1BsY9gbkPuwUa3n2/Z+b3zrjSbsFF9SEOGC32yR6v4e/OpBWAK
	BTQB6ooWRWM9cPn6GQ45mgUiitICUH7MN7UmWnihbPJn8X1lff2CnDo1TVORx5CciaSUP0Cyasd
	OvUnmCVPzlEO4fyj+vdIwCQizJykSLC8cRLyvt6Y+Dj6j/upNqXHQVpKK9TPVhqsHCg==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1770043671; bh=yXk4mfEUy0B9smgA0To3U/i
	eCUmK0yOemXhDKbFrGBw=; b=/6Ri1U5Z7AKIld4/y1FLLGuYklkykok0+LOqhWtVcRKv0H2FzS
	5+sezEF1R2XwBumySa5+tcZ3yGA5OXen2uAw==;
From: Daniel Hodges <git@danielhodges.dev>
To: bpf@vger.kernel.org
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
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Daniel Hodges <git@danielhodges.dev>
Subject: [PATCH bpf-next v7 3/4] bpf: Add signature verification kfuncs
Date: Mon,  2 Feb 2026 09:47:48 -0500
Message-ID: <20260202144749.22932-4-git@danielhodges.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260202144749.22932-1-git@danielhodges.dev>
References: <20260202144749.22932-1-git@danielhodges.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a bpf_crypto_sig module that registers signature verification
algorithms with the BPF crypto type system. This enables signature
operations (like ECDSA) to use the unified bpf_crypto_ctx structure.

The module provides:
   - alloc_tfm/free_tfm for crypto_sig transform lifecycle
   - has_algo to check algorithm availability
   - setkey for public key configuration
   - verify for signature verification
   - get_flags for crypto API flags

Introduce bpf_sig_verify, bpf_sig_keysize, bpf_sig_digestsize,
and bpf_sig_maxsize kfuncs enabling BPF programs to verify digital
signatures using the kernel's crypto infrastructure.

Add enum bpf_crypto_type_id for runtime type checking to ensure
operations are performed on the correct crypto context type. The enum
values are assigned to all crypto type modules (skcipher, hash, sig).

The verify kfunc takes a crypto context (initialized with the sig
type and appropriate algorithm like "ecdsa-nist-p256"), a message
digest, and a signature. These kfuncs support any signature algorithm
registered with the crypto subsystem (e.g., ECDSA, RSA).

Signed-off-by: Daniel Hodges <git@danielhodges.dev>
---
 MAINTAINERS                |   1 +
 crypto/Makefile            |   3 +
 crypto/bpf_crypto_sig.c    |  89 ++++++++++++++++++++++++++++
 include/linux/bpf_crypto.h |   4 ++
 kernel/bpf/crypto.c        | 117 +++++++++++++++++++++++++++++++++++++
 5 files changed, 214 insertions(+)
 create mode 100644 crypto/bpf_crypto_sig.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 9602b6216ab9..d23ea38b606f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4714,6 +4714,7 @@ M:	Vadim Fedorenko <vadim.fedorenko@linux.dev>
 L:	bpf@vger.kernel.org
 S:	Maintained
 F:	crypto/bpf_crypto_shash.c
+F:	crypto/bpf_crypto_sig.c
 F:	crypto/bpf_crypto_skcipher.c
 F:	include/linux/bpf_crypto.h
 F:	kernel/bpf/crypto.c
diff --git a/crypto/Makefile b/crypto/Makefile
index 853dff375906..c9ab98b57bc0 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -36,6 +36,9 @@ endif
 
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 obj-$(CONFIG_CRYPTO_SIG2) += sig.o
+ifeq ($(CONFIG_BPF_SYSCALL),y)
+obj-$(CONFIG_CRYPTO_SIG2) += bpf_crypto_sig.o
+endif
 obj-$(CONFIG_CRYPTO_KPP2) += kpp.o
 obj-$(CONFIG_CRYPTO_HKDF) += hkdf.o
 
diff --git a/crypto/bpf_crypto_sig.c b/crypto/bpf_crypto_sig.c
new file mode 100644
index 000000000000..2dc82c5f9abb
--- /dev/null
+++ b/crypto/bpf_crypto_sig.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/bpf_crypto.h>
+#include <linux/crypto.h>
+#include <crypto/sig.h>
+
+static void *bpf_crypto_sig_alloc_tfm(const char *algo)
+{
+	return crypto_alloc_sig(algo, 0, 0);
+}
+
+static void bpf_crypto_sig_free_tfm(void *tfm)
+{
+	crypto_free_sig(tfm);
+}
+
+static int bpf_crypto_sig_has_algo(const char *algo)
+{
+	return crypto_has_alg(algo, CRYPTO_ALG_TYPE_SIG, CRYPTO_ALG_TYPE_MASK);
+}
+
+static u32 bpf_crypto_sig_get_flags(void *tfm)
+{
+	return crypto_tfm_get_flags(crypto_sig_tfm(tfm));
+}
+
+static int bpf_crypto_sig_setkey(void *tfm, const u8 *key, unsigned int keylen)
+{
+	return crypto_sig_set_pubkey(tfm, key, keylen);
+}
+
+static int bpf_crypto_sig_verify(void *tfm, const u8 *sig, unsigned int sig_len,
+				 const u8 *msg, unsigned int msg_len)
+{
+	return crypto_sig_verify(tfm, sig, sig_len, msg, msg_len);
+}
+
+static unsigned int bpf_crypto_sig_keysize(void *tfm)
+{
+	return crypto_sig_keysize(tfm);
+}
+
+static unsigned int bpf_crypto_sig_digestsize(void *tfm)
+{
+	struct sig_alg *alg = crypto_sig_alg(tfm);
+
+	return alg->digest_size ? alg->digest_size(tfm) : 0;
+}
+
+static unsigned int bpf_crypto_sig_maxsize(void *tfm)
+{
+	struct sig_alg *alg = crypto_sig_alg(tfm);
+
+	return alg->max_size ? alg->max_size(tfm) : 0;
+}
+
+static const struct bpf_crypto_type bpf_crypto_sig_type = {
+	.alloc_tfm	= bpf_crypto_sig_alloc_tfm,
+	.free_tfm	= bpf_crypto_sig_free_tfm,
+	.has_algo	= bpf_crypto_sig_has_algo,
+	.get_flags	= bpf_crypto_sig_get_flags,
+	.setkey		= bpf_crypto_sig_setkey,
+	.verify		= bpf_crypto_sig_verify,
+	.keysize	= bpf_crypto_sig_keysize,
+	.digestsize	= bpf_crypto_sig_digestsize,
+	.maxsize	= bpf_crypto_sig_maxsize,
+	.owner		= THIS_MODULE,
+	.type_id	= BPF_CRYPTO_TYPE_SIG,
+	.name		= "sig",
+};
+
+static int __init bpf_crypto_sig_init(void)
+{
+	return bpf_crypto_register_type(&bpf_crypto_sig_type);
+}
+
+static void __exit bpf_crypto_sig_exit(void)
+{
+	int err = bpf_crypto_unregister_type(&bpf_crypto_sig_type);
+
+	WARN_ON_ONCE(err);
+}
+
+module_init(bpf_crypto_sig_init);
+module_exit(bpf_crypto_sig_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Signature algorithm support for BPF");
diff --git a/include/linux/bpf_crypto.h b/include/linux/bpf_crypto.h
index cf2c66f9782b..e0f946926f69 100644
--- a/include/linux/bpf_crypto.h
+++ b/include/linux/bpf_crypto.h
@@ -18,9 +18,13 @@ struct bpf_crypto_type {
 	int (*encrypt)(void *tfm, const u8 *src, u8 *dst, unsigned int len, u8 *iv);
 	int (*decrypt)(void *tfm, const u8 *src, u8 *dst, unsigned int len, u8 *iv);
 	int (*hash)(void *tfm, const u8 *data, u8 *out, unsigned int len);
+	int (*verify)(void *tfm, const u8 *sig, unsigned int sig_len,
+		      const u8 *msg, unsigned int msg_len);
 	unsigned int (*ivsize)(void *tfm);
 	unsigned int (*statesize)(void *tfm);
 	unsigned int (*digestsize)(void *tfm);
+	unsigned int (*keysize)(void *tfm);
+	unsigned int (*maxsize)(void *tfm);
 	u32 (*get_flags)(void *tfm);
 	struct module *owner;
 	enum bpf_crypto_type_id type_id;
diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
index bf14856ab5b1..b763a6c5cdd3 100644
--- a/kernel/bpf/crypto.c
+++ b/kernel/bpf/crypto.c
@@ -419,6 +419,117 @@ __bpf_kfunc int bpf_crypto_hash(struct bpf_crypto_ctx *ctx,
 }
 #endif /* CONFIG_CRYPTO_HASH2 */
 
+#if IS_ENABLED(CONFIG_CRYPTO_SIG2)
+/**
+ * bpf_sig_verify() - Verify digital signature using configured context
+ * @ctx:	The crypto context being used. The ctx must be a trusted pointer.
+ * @message:	bpf_dynptr to the message hash to verify. Must be a trusted pointer.
+ * @signature:	bpf_dynptr to the signature. Must be a trusted pointer.
+ *
+ * Verifies a digital signature over a message hash using the public key
+ * configured in the crypto context. Supports any signature algorithm
+ * registered with the crypto subsystem (e.g., ECDSA, RSA).
+ *
+ * Return: 0 on success (valid signature), negative error code on failure.
+ */
+__bpf_kfunc int bpf_sig_verify(struct bpf_crypto_ctx *ctx,
+				 const struct bpf_dynptr *message,
+				 const struct bpf_dynptr *signature)
+{
+	const struct bpf_dynptr_kern *msg_kern = (struct bpf_dynptr_kern *)message;
+	const struct bpf_dynptr_kern *sig_kern = (struct bpf_dynptr_kern *)signature;
+	u64 msg_len, sig_len;
+	const u8 *msg_ptr, *sig_ptr;
+
+	if (ctx->type->type_id != BPF_CRYPTO_TYPE_SIG)
+		return -EINVAL;
+
+	if (!ctx->type->verify)
+		return -EOPNOTSUPP;
+
+	msg_len = __bpf_dynptr_size(msg_kern);
+	sig_len = __bpf_dynptr_size(sig_kern);
+
+	if (msg_len == 0 || msg_len > UINT_MAX)
+		return -EINVAL;
+	if (sig_len == 0 || sig_len > UINT_MAX)
+		return -EINVAL;
+
+	msg_ptr = __bpf_dynptr_data(msg_kern, msg_len);
+	if (!msg_ptr)
+		return -EINVAL;
+
+	sig_ptr = __bpf_dynptr_data(sig_kern, sig_len);
+	if (!sig_ptr)
+		return -EINVAL;
+
+	return ctx->type->verify(ctx->tfm, sig_ptr, sig_len, msg_ptr, msg_len);
+}
+
+/**
+ * bpf_sig_keysize() - Get the key size for signature context
+ * @ctx:	The crypto context being used. The ctx must be a trusted pointer.
+ *
+ * Return: The key size in bytes, or negative error code on failure.
+ */
+__bpf_kfunc int bpf_sig_keysize(struct bpf_crypto_ctx *ctx)
+{
+	if (ctx->type->type_id != BPF_CRYPTO_TYPE_SIG)
+		return -EINVAL;
+
+	if (!ctx->type->keysize)
+		return -EOPNOTSUPP;
+
+	return ctx->type->keysize(ctx->tfm);
+}
+
+/**
+ * bpf_sig_digestsize() - Get the digest size for signature context
+ * @ctx:	The crypto context being used. The ctx must be a trusted pointer.
+ *
+ * Return: The digest size in bytes, or negative error code on failure.
+ */
+__bpf_kfunc int bpf_sig_digestsize(struct bpf_crypto_ctx *ctx)
+{
+	unsigned int size;
+
+	if (ctx->type->type_id != BPF_CRYPTO_TYPE_SIG)
+		return -EINVAL;
+
+	if (!ctx->type->digestsize)
+		return -EOPNOTSUPP;
+
+	size = ctx->type->digestsize(ctx->tfm);
+	if (!size)
+		return -EOPNOTSUPP;
+
+	return size;
+}
+
+/**
+ * bpf_sig_maxsize() - Get the maximum signature size for signature context
+ * @ctx:	The crypto context being used. The ctx must be a trusted pointer.
+ *
+ * Return: The maximum signature size in bytes, or negative error code on failure.
+ */
+__bpf_kfunc int bpf_sig_maxsize(struct bpf_crypto_ctx *ctx)
+{
+	unsigned int size;
+
+	if (ctx->type->type_id != BPF_CRYPTO_TYPE_SIG)
+		return -EINVAL;
+
+	if (!ctx->type->maxsize)
+		return -EOPNOTSUPP;
+
+	size = ctx->type->maxsize(ctx->tfm);
+	if (!size)
+		return -EOPNOTSUPP;
+
+	return size;
+}
+#endif /* CONFIG_CRYPTO_SIG2 */
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(crypt_init_kfunc_btf_ids)
@@ -438,6 +549,12 @@ BTF_ID_FLAGS(func, bpf_crypto_encrypt, KF_RCU)
 #if IS_ENABLED(CONFIG_CRYPTO_HASH2)
 BTF_ID_FLAGS(func, bpf_crypto_hash, KF_RCU)
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_SIG2)
+BTF_ID_FLAGS(func, bpf_sig_verify, KF_RCU)
+BTF_ID_FLAGS(func, bpf_sig_keysize)
+BTF_ID_FLAGS(func, bpf_sig_digestsize)
+BTF_ID_FLAGS(func, bpf_sig_maxsize)
+#endif
 BTF_KFUNCS_END(crypt_kfunc_btf_ids)
 
 static const struct btf_kfunc_id_set crypt_kfunc_set = {
-- 
2.52.0

