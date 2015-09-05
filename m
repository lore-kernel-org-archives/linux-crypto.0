From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Subject: [RFC PATCH] crypto: RSA padding transform
Date: Sun,  6 Sep 2015 01:00:29 +0200
Message-ID: <1441494029-6765-1-git-send-email-andrew.zaborowski@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:32846 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbbIEXAl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Sep 2015 19:00:41 -0400
Received: by wiclk2 with SMTP id lk2so53835134wic.0
        for <linux-crypto@vger.kernel.org>; Sat, 05 Sep 2015 16:00:39 -0700 (PDT)
Received: from localhost.localdomain (245.Red-2-136-112.dynamicIP.rima-tde.net. [2.136.112.245])
        by smtp.gmail.com with ESMTPSA id t5sm5306680wiy.18.2015.09.05.16.00.38
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 05 Sep 2015 16:00:39 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds PKCS#1 v1.5 standard RSA padding as a separate template.
This way an RSA cipher with padding can be obtained by instantiating
"pkcs1pad(rsa-generic)".  The reason for adding this is that RSA is almost
never used without this padding (or OAEP) so it will be needed for
either certificate work in the kernel or the userspace, and also I hear
that it is likely implemented by hardware RSA.

>From the generic code I could not figure out why the crypto_type.init and
.ctxsize functions are needed for a template but not for a standalone
algorithm but I see the word "compat" in their implementations for
shash or blkcipher.  If they are to be added for akcipher it should
probably be a separate patch.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 crypto/Makefile               |   1 +
 crypto/akcipher.c             |  16 +-
 crypto/rsa-padding.c          | 438 ++++++++++++++++++++++++++++++++++++++++++
 crypto/rsa.c                  |  16 +-
 include/crypto/akcipher.h     |   4 +-
 include/crypto/algapi.h       |   1 +
 include/crypto/internal/rsa.h |   2 +
 7 files changed, 474 insertions(+), 4 deletions(-)
 create mode 100644 crypto/rsa-padding.c

diff --git a/crypto/Makefile b/crypto/Makefile
index a16a7e7..b548a27 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -36,6 +36,7 @@ clean-files += rsakey-asn1.c rsakey-asn1.h
 rsa_generic-y := rsakey-asn1.o
 rsa_generic-y += rsa.o
 rsa_generic-y += rsa_helper.o
+rsa_generic-y += rsa-padding.o
 obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o
 
 cryptomgr-y := algboss.o testmgr.o
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 528ae6a..7f82ee8 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -54,6 +54,11 @@ static void crypto_akcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_puts(m, "type         : akcipher\n");
 }
 
+static int crypto_akcipher_init(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	return 0;
+}
+
 static void crypto_akcipher_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_akcipher *akcipher = __crypto_akcipher_tfm(tfm);
@@ -76,8 +81,16 @@ static int crypto_akcipher_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static const struct crypto_type crypto_akcipher_type = {
+static unsigned int crypto_akcipher_ctxsize(struct crypto_alg *alg, u32 type,
+					    u32 mask)
+{
+	return alg->cra_ctxsize;
+}
+
+const struct crypto_type crypto_akcipher_type = {
+	.ctxsize = crypto_akcipher_ctxsize,
 	.extsize = crypto_alg_extsize,
+	.init = crypto_akcipher_init,
 	.init_tfm = crypto_akcipher_init_tfm,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_akcipher_show,
@@ -88,6 +101,7 @@ static const struct crypto_type crypto_akcipher_type = {
 	.type = CRYPTO_ALG_TYPE_AKCIPHER,
 	.tfmsize = offsetof(struct crypto_akcipher, base),
 };
+EXPORT_SYMBOL_GPL(crypto_akcipher_type);
 
 struct crypto_akcipher *crypto_alloc_akcipher(const char *alg_name, u32 type,
 					      u32 mask)
diff --git a/crypto/rsa-padding.c b/crypto/rsa-padding.c
new file mode 100644
index 0000000..106ce62
--- /dev/null
+++ b/crypto/rsa-padding.c
@@ -0,0 +1,438 @@
+/*
+ * RSA padding templates.
+ *
+ * Copyright (c) 2015  Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/akcipher.h>
+#include <crypto/internal/akcipher.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/random.h>
+
+struct pkcs1pad_ctx {
+	struct crypto_akcipher *child;
+
+	unsigned int key_size;
+};
+
+static int pkcs1pad_setkey(struct crypto_akcipher *tfm, const void *key,
+		unsigned int keylen)
+{
+	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct akcipher_request *req;
+	int err;
+
+	err = crypto_akcipher_setkey(ctx->child, key, keylen);
+
+	if (!err) {
+		/* Find out new modulus size from rsa implementation */
+		req = akcipher_request_alloc(ctx->child, GFP_KERNEL);
+		if (IS_ERR(req))
+			return PTR_ERR(req);
+
+		akcipher_request_set_crypt(req, NULL, NULL, 0, 0);
+		if (crypto_akcipher_encrypt(req) != -EOVERFLOW)
+			err = -EINVAL;
+
+		ctx->key_size = req->dst_len;
+		akcipher_request_free(req);
+	}
+
+	return err;
+}
+
+static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, int err)
+{
+	struct akcipher_request *child_req = akcipher_request_ctx(req);
+
+	kfree(child_req->src);
+	req->dst_len = child_req->dst_len;
+	return err;
+}
+
+static void pkcs1pad_encrypt_sign_complete_cb(
+		struct crypto_async_request *child_async_req, int err)
+{
+	struct akcipher_request *req = child_async_req->data;
+	struct crypto_async_request async_req;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	async_req.data = req->base.data;
+	async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
+	async_req.flags = child_async_req->flags;
+	req->base.complete(&async_req,
+			pkcs1pad_encrypt_sign_complete(req, err));
+}
+
+static int pkcs1pad_encrypt(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct akcipher_request *child_req = akcipher_request_ctx(req);
+	int err, i, ps_len;
+	uint8_t *src;
+
+	if (!ctx->key_size)
+		return -EINVAL;
+
+	if (req->src_len > ctx->key_size - 11)
+		return -EOVERFLOW;
+
+	src = kmalloc(ctx->key_size,
+			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC);
+	if (!src)
+		return -ENOMEM;
+
+	/* Reuse output buffer, add padding in the input */
+	child_req->src = src;
+	child_req->src_len = ctx->key_size;
+	child_req->dst = req->dst;
+	child_req->dst_len = req->dst_len;
+
+	ps_len = ctx->key_size - req->src_len - 3;
+	src[0] = 0x00;
+	src[1] = 0x02;
+	for (i = 0; i < ps_len; i++)
+		src[2 + i] = 1 + prandom_u32_max(255);
+	src[ps_len + 2] = 0x00;
+	memcpy(src + ps_len + 3, req->src, req->src_len);
+
+	akcipher_request_set_tfm(child_req, ctx->child);
+	akcipher_request_set_callback(child_req, req->base.flags,
+			pkcs1pad_encrypt_sign_complete_cb, req);
+
+	err = crypto_akcipher_encrypt(child_req);
+	if (err != -EINPROGRESS && err != -EBUSY)
+		return pkcs1pad_encrypt_sign_complete(req, err);
+
+	return err;
+}
+
+static int pkcs1pad_decrypt_complete(struct akcipher_request *req, int err)
+{
+	struct akcipher_request *child_req = akcipher_request_ctx(req);
+	int pos;
+	uint8_t *dst = child_req->dst;
+
+	BUG_ON(err == -EOVERFLOW);
+
+	if (err)
+		goto done;
+
+	if (dst[0] != 0x00) {
+		err = -EINVAL;
+		goto done;
+	}
+	if (dst[1] != 0x02) {
+		err = -EINVAL;
+		goto done;
+	}
+	for (pos = 2; pos < child_req->dst_len; pos++)
+		if (dst[pos] == 0x00)
+			break;
+	if (pos < 10 || pos == child_req->dst_len) {
+		err = -EINVAL;
+		goto done;
+	}
+	pos++;
+
+	if (req->dst_len < child_req->dst_len - pos)
+		err = -EOVERFLOW;
+	req->dst_len = child_req->dst_len - pos;
+
+	if (!err)
+		memcpy(req->dst, dst + pos, req->dst_len);
+
+done:
+	kfree(dst);
+	return err;
+}
+
+static void pkcs1pad_decrypt_complete_cb(
+		struct crypto_async_request *child_async_req, int err)
+{
+	struct akcipher_request *req = child_async_req->data;
+	struct crypto_async_request async_req;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	async_req.data = req->base.data;
+	async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
+	async_req.flags = child_async_req->flags;
+	req->base.complete(&async_req, pkcs1pad_decrypt_complete(req, err));
+}
+
+static int pkcs1pad_decrypt(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct akcipher_request *child_req = akcipher_request_ctx(req);
+	int err;
+	uint8_t *dst;
+
+	if (!ctx->key_size)
+		return -EINVAL;
+
+	dst = kmalloc(ctx->key_size,
+			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC);
+	if (!dst)
+		return -ENOMEM;
+
+	/* Reuse input buffer, strip padding from the output */
+	child_req->src = req->src;
+	child_req->src_len = req->src_len;
+	child_req->dst = dst;
+	child_req->dst_len = ctx->key_size;
+
+	akcipher_request_set_tfm(child_req, ctx->child);
+	akcipher_request_set_callback(child_req, req->base.flags,
+			pkcs1pad_decrypt_complete_cb, req);
+
+	err = crypto_akcipher_decrypt(child_req);
+	if (err != -EINPROGRESS && err != -EBUSY)
+		return pkcs1pad_decrypt_complete(req, err);
+
+	return err;
+}
+
+static int pkcs1pad_sign(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct akcipher_request *child_req = akcipher_request_ctx(req);
+	int err, i, ps_len;
+	uint8_t *src;
+
+	if (!ctx->key_size)
+		return -EINVAL;
+
+	if (req->src_len > ctx->key_size - 11)
+		return -EOVERFLOW;
+
+	src = kmalloc(ctx->key_size,
+			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC);
+	if (!src)
+		return -ENOMEM;
+
+	/* Reuse output buffer, add padding in the input */
+	child_req->src = src;
+	child_req->src_len = ctx->key_size;
+	child_req->dst = req->dst;
+	child_req->dst_len = req->dst_len;
+
+	ps_len = ctx->key_size - req->src_len - 3;
+	src[0] = 0x00;
+	src[1] = 0x01;
+	for (i = 0; i < ps_len; i++)
+		src[2 + i] = 0xff;
+	src[ps_len + 2] = 0x00;
+	memcpy(src + ps_len + 3, req->src, req->src_len);
+
+	akcipher_request_set_tfm(child_req, ctx->child);
+	akcipher_request_set_callback(child_req, req->base.flags,
+			pkcs1pad_encrypt_sign_complete_cb, req);
+
+	err = crypto_akcipher_sign(child_req);
+	if (err != -EINPROGRESS && err != -EBUSY)
+		return pkcs1pad_encrypt_sign_complete(req, err);
+
+	return err;
+}
+
+static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
+{
+	struct akcipher_request *child_req = akcipher_request_ctx(req);
+	int pos;
+	uint8_t *dst = child_req->dst;
+
+	BUG_ON(err == -EOVERFLOW);
+
+	if (err)
+		goto done;
+
+	if (dst[0] != 0x00) {
+		err = -EINVAL;
+		goto done;
+	}
+	if (dst[1] != 0x01) {
+		err = -EINVAL;
+		goto done;
+	}
+	for (pos = 2; pos < child_req->dst_len; pos++)
+		if (dst[pos] != 0xff)
+			break;
+	if (pos < 10 || pos == child_req->dst_len || dst[pos] != 0x00) {
+		err = -EINVAL;
+		goto done;
+	}
+	pos++;
+
+	if (req->dst_len < child_req->dst_len - pos)
+		err = -EOVERFLOW;
+	req->dst_len = child_req->dst_len - pos;
+
+	if (!err)
+		memcpy(req->dst, dst + pos, req->dst_len);
+
+done:
+	kfree(dst);
+	return err;
+}
+
+static void pkcs1pad_verify_complete_cb(
+		struct crypto_async_request *child_async_req, int err)
+{
+	struct akcipher_request *req = child_async_req->data;
+	struct crypto_async_request async_req;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	async_req.data = req->base.data;
+	async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
+	async_req.flags = child_async_req->flags;
+	req->base.complete(&async_req, pkcs1pad_verify_complete(req, err));
+}
+
+static int pkcs1pad_verify(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct akcipher_request *child_req = akcipher_request_ctx(req);
+	int err;
+	uint8_t *dst;
+
+	if (!ctx->key_size)
+		return -EINVAL;
+
+	dst = kmalloc(ctx->key_size,
+			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC);
+	if (!dst)
+		return -ENOMEM;
+
+	/* Reuse input buffer, strip padding from the output */
+	child_req->src = req->src;
+	child_req->src_len = req->src_len;
+	child_req->dst = dst;
+	child_req->dst_len = ctx->key_size;
+
+	akcipher_request_set_tfm(child_req, ctx->child);
+	akcipher_request_set_callback(child_req, req->base.flags,
+			pkcs1pad_verify_complete_cb, req);
+
+	err = crypto_akcipher_verify(child_req);
+	if (err != -EINPROGRESS && err != -EBUSY)
+		return pkcs1pad_verify_complete(req, err);
+
+	return err;
+}
+
+static int pkcs1pad_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = (void *) tfm->__crt_alg;
+	struct pkcs1pad_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_tfm *new_tfm;
+
+	new_tfm = crypto_spawn_tfm(crypto_instance_ctx(inst),
+			CRYPTO_ALG_TYPE_AKCIPHER, CRYPTO_ALG_TYPE_MASK);
+	if (IS_ERR(new_tfm))
+		return PTR_ERR(new_tfm);
+
+	ctx->child = __crypto_akcipher_tfm(new_tfm);
+
+	return 0;
+}
+
+static void pkcs1pad_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct pkcs1pad_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_akcipher(ctx->child);
+}
+
+static struct crypto_instance *pkcs1pad_alloc(struct rtattr **tb)
+{
+	struct crypto_instance *inst = NULL;
+	struct crypto_alg *alg;
+	struct akcipher_alg *akalg;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AKCIPHER);
+	if (err)
+		return ERR_PTR(err);
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_AKCIPHER,
+				  CRYPTO_ALG_TYPE_MASK);
+	if (IS_ERR(alg))
+		return ERR_CAST(alg);
+
+	akalg = crypto_alloc_instance2("pkcs1pad", alg,
+			crypto_akcipher_type.tfmsize);
+	if (IS_ERR(akalg)) {
+		inst = ERR_CAST(akalg);
+		goto out_put_alg;
+	}
+
+	inst = container_of(&akalg->base, struct crypto_instance, alg);
+
+	err = crypto_init_spawn2(crypto_instance_ctx(inst), alg, inst,
+			&crypto_akcipher_type);
+	if (err) {
+		inst = ERR_PTR(err);
+		kfree(akalg);
+
+		goto out_put_alg;
+	}
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AKCIPHER;
+	inst->alg.cra_priority = alg->cra_priority;
+	inst->alg.cra_type = alg->cra_type;
+
+	inst->alg.cra_ctxsize = sizeof(struct pkcs1pad_ctx);
+
+	inst->alg.cra_init = pkcs1pad_init_tfm;
+	inst->alg.cra_exit = pkcs1pad_exit_tfm;
+
+	akalg->encrypt = pkcs1pad_encrypt;
+	akalg->decrypt = pkcs1pad_decrypt;
+	akalg->sign = pkcs1pad_sign;
+	akalg->verify = pkcs1pad_verify;
+	akalg->setkey = pkcs1pad_setkey;
+	akalg->reqsize = sizeof(struct akcipher_request) +
+		__crypto_akcipher_alg(alg)->reqsize;
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return inst;
+}
+
+static void pkcs1pad_free(struct crypto_instance *inst)
+{
+	struct akcipher_alg *akalg = __crypto_akcipher_alg(&inst->alg);
+
+	crypto_drop_spawn(crypto_instance_ctx(inst));
+	kfree(akalg);
+}
+
+struct crypto_template rsa_pkcs1pad_tmpl = {
+	.name = "pkcs1pad",
+	.alloc = pkcs1pad_alloc,
+	.free = pkcs1pad_free,
+	.module = THIS_MODULE,
+};
diff --git a/crypto/rsa.c b/crypto/rsa.c
index 752af06..1f030fa 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -13,6 +13,7 @@
 #include <crypto/internal/rsa.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/akcipher.h>
+#include <crypto/algapi.h>
 
 /*
  * RSAEP function [RFC3447 sec 5.1.1]
@@ -300,11 +301,24 @@ static struct akcipher_alg rsa = {
 
 static int rsa_init(void)
 {
-	return crypto_register_akcipher(&rsa);
+	int err;
+
+	err = crypto_register_akcipher(&rsa);
+	if (err)
+		return err;
+
+	err = crypto_register_template(&rsa_pkcs1pad_tmpl);
+	if (err) {
+		crypto_unregister_akcipher(&rsa);
+		return err;
+	}
+
+	return 0;
 }
 
 static void rsa_exit(void)
 {
+	crypto_unregister_template(&rsa_pkcs1pad_tmpl);
 	crypto_unregister_akcipher(&rsa);
 }
 
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 69d163e..6ab7a7f 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -330,8 +330,8 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
  *
  * Return: zero on success; error code in case of error
  */
-static inline int crypto_akcipher_setkey(struct crypto_akcipher *tfm, void *key,
-					 unsigned int keylen)
+static inline int crypto_akcipher_setkey(struct crypto_akcipher *tfm,
+					 const void *key, unsigned int keylen)
 {
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index d4ebf6e..b48ed67 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -128,6 +128,7 @@ struct ablkcipher_walk {
 
 extern const struct crypto_type crypto_ablkcipher_type;
 extern const struct crypto_type crypto_blkcipher_type;
+extern const struct crypto_type crypto_akcipher_type;
 
 void crypto_mod_put(struct crypto_alg *alg);
 
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index a8c8636..162baf9 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -24,4 +24,6 @@ int rsa_parse_key(struct rsa_key *rsa_key, const void *key,
 		  unsigned int key_len);
 
 void rsa_free_key(struct rsa_key *rsa_key);
+
+extern struct crypto_template rsa_pkcs1pad_tmpl;
 #endif
-- 
2.1.4
