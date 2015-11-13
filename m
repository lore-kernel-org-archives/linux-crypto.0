From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Subject: [PATCH 4/4] crypto: RSA padding algorithm
Date: Fri, 13 Nov 2015 12:01:35 +0100
Message-ID: <1447412495-4370-4-git-send-email-andrew.zaborowski@intel.com>
References: <1447412495-4370-1-git-send-email-andrew.zaborowski@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:32816 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbKMLBz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Nov 2015 06:01:55 -0500
Received: by wmec201 with SMTP id c201so75598753wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2015 03:01:54 -0800 (PST)
Received: from localhost.localdomain (9.Red-2-136-109.dynamicIP.rima-tde.net. [2.136.109.9])
        by smtp.gmail.com with ESMTPSA id w73sm3401681wme.12.2015.11.13.03.01.52
        for <linux-crypto@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 13 Nov 2015 03:01:53 -0800 (PST)
In-Reply-To: <1447412495-4370-1-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds PKCS#1 v1.5 standard RSA padding as a separate template.
This way an RSA cipher with padding can be obtained by instantiating
"pkcs1pad(rsa)".  The reason for adding this is that RSA is almost
never used without this padding (or OAEP) so it will be needed for
either certificate work in the kernel or the userspace, and also I hear
that it is likely implemented by hardware RSA in which case an
implementation of the whole of pkcs1pad(rsa) can be provided.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 crypto/Makefile               |   1 +
 crypto/rsa-pkcs1pad.c         | 593 ++++++++++++++++++++++++++++++++++++++++++
 crypto/rsa.c                  |  16 +-
 include/crypto/internal/rsa.h |   2 +
 4 files changed, 611 insertions(+), 1 deletion(-)
 create mode 100644 crypto/rsa-pkcs1pad.c

diff --git a/crypto/Makefile b/crypto/Makefile
index f7aba92..2acdbbd 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -40,6 +40,7 @@ rsa_generic-y := rsapubkey-asn1.o
 rsa_generic-y += rsaprivkey-asn1.o
 rsa_generic-y += rsa.o
 rsa_generic-y += rsa_helper.o
+rsa_generic-y += rsa-pkcs1pad.o
 obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o
 
 cryptomgr-y := algboss.o testmgr.o
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
new file mode 100644
index 0000000..d8e0c71
--- /dev/null
+++ b/crypto/rsa-pkcs1pad.c
@@ -0,0 +1,593 @@
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
+struct pkcs1pad_request {
+	struct akcipher_request child_req;
+
+	struct scatterlist in_sg[3], out_sg[2];
+	uint8_t *in_buf, *out_buf;
+};
+
+static int pkcs1pad_set_pub_key(struct crypto_akcipher *tfm, const void *key,
+		unsigned int keylen)
+{
+	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
+	int err, size;
+
+	err = crypto_akcipher_set_pub_key(ctx->child, key, keylen);
+
+	if (!err) {
+		/* Find out new modulus size from rsa implementation */
+		size = crypto_akcipher_maxsize(ctx->child);
+
+		ctx->key_size = size > 0 ? size : 0;
+		if (size <= 0)
+			err = size;
+	}
+
+	return err;
+}
+
+static int pkcs1pad_set_priv_key(struct crypto_akcipher *tfm, const void *key,
+		unsigned int keylen)
+{
+	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
+	int err, size;
+
+	err = crypto_akcipher_set_priv_key(ctx->child, key, keylen);
+
+	if (!err) {
+		/* Find out new modulus size from rsa implementation */
+		size = crypto_akcipher_maxsize(ctx->child);
+
+		ctx->key_size = size > 0 ? size : 0;
+		if (size <= 0)
+			err = size;
+	}
+
+	return err;
+}
+
+static int pkcs1pad_get_max_size(struct crypto_akcipher *tfm)
+{
+	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
+
+	/*
+	 * The maximum destination buffer size for the encrypt/sign operations
+	 * will be the same as for RSA, even though it's smaller for
+	 * decrypt/verify.
+	 */
+
+	return ctx->key_size ?: -EINVAL;
+}
+
+static void pkcs1pad_sg_set_buf(struct scatterlist *sg, void *buf, size_t len,
+		struct scatterlist *next)
+{
+	int nsegs = next ? 1 : 0;
+
+	if (offset_in_page(buf) + len <= PAGE_SIZE) {
+		nsegs += 1;
+		sg_init_table(sg, nsegs);
+		sg_set_buf(sg, buf, len);
+	} else {
+		nsegs += 2;
+		sg_init_table(sg, nsegs);
+		sg_set_buf(sg + 0, buf, PAGE_SIZE - offset_in_page(buf));
+		sg_set_buf(sg + 1, buf + PAGE_SIZE - offset_in_page(buf),
+				offset_in_page(buf) + len - PAGE_SIZE);
+	}
+
+	if (next)
+		sg_chain(sg, nsegs, next);
+}
+
+static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, int err)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
+	uint8_t zeros[ctx->key_size - req_ctx->child_req.dst_len];
+
+	if (!err) {
+		if (req_ctx->child_req.dst_len < ctx->key_size) {
+			memset(zeros, 0, sizeof(zeros));
+			sg_copy_from_buffer(req->dst,
+					sg_nents_for_len(req->dst,
+						sizeof(zeros)),
+					zeros, sizeof(zeros));
+		}
+
+		sg_pcopy_from_buffer(req->dst,
+				sg_nents_for_len(req->dst, ctx->key_size),
+				req_ctx->out_buf, req_ctx->child_req.dst_len,
+				sizeof(zeros));
+	}
+	req->dst_len = ctx->key_size;
+
+	kfree(req_ctx->in_buf);
+	kzfree(req_ctx->out_buf);
+
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
+	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
+	int err;
+	unsigned int i, ps_end;
+
+	if (!ctx->key_size)
+		return -EINVAL;
+
+	if (req->src_len > ctx->key_size - 11)
+		return -EOVERFLOW;
+
+	if (req->dst_len < ctx->key_size) {
+		req->dst_len = ctx->key_size;
+		return -EOVERFLOW;
+	}
+
+	if (ctx->key_size > PAGE_SIZE)
+		return -ENOTSUPP;
+
+	/*
+	 * Replace both input and output to add the padding in the input and
+	 * the potential missing leading zeros in the output.
+	 */
+	req_ctx->child_req.src = req_ctx->in_sg;
+	req_ctx->child_req.src_len = ctx->key_size - 1;
+	req_ctx->child_req.dst = req_ctx->out_sg;
+	req_ctx->child_req.dst_len = ctx->key_size;
+
+	req_ctx->in_buf = kmalloc(ctx->key_size - 1 - req->src_len,
+			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC);
+	if (!req_ctx->in_buf)
+		return -ENOMEM;
+
+	ps_end = ctx->key_size - req->src_len - 2;
+	req_ctx->in_buf[0] = 0x02;
+	for (i = 1; i < ps_end; i++)
+		req_ctx->in_buf[i] = 1 + prandom_u32_max(255);
+	req_ctx->in_buf[ps_end] = 0x00;
+
+	pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
+			ctx->key_size - 1 - req->src_len, req->src);
+
+	req_ctx->out_buf = kmalloc(ctx->key_size,
+			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC);
+	if (!req_ctx->out_buf) {
+		kfree(req_ctx->in_buf);
+		return -ENOMEM;
+	}
+
+	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
+			ctx->key_size, NULL);
+
+	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
+	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
+			pkcs1pad_encrypt_sign_complete_cb, req);
+
+	err = crypto_akcipher_encrypt(&req_ctx->child_req);
+	if (err != -EINPROGRESS && err != -EBUSY)
+		return pkcs1pad_encrypt_sign_complete(req, err);
+
+	return err;
+}
+
+static int pkcs1pad_decrypt_complete(struct akcipher_request *req, int err)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
+	unsigned int pos;
+
+	if (err == -EOVERFLOW)
+		/* Decrypted value had no leading 0 byte */
+		err = -EINVAL;
+
+	if (err)
+		goto done;
+
+	if (req_ctx->child_req.dst_len != ctx->key_size - 1) {
+		err = -EINVAL;
+		goto done;
+	}
+
+	if (req_ctx->out_buf[0] != 0x02) {
+		err = -EINVAL;
+		goto done;
+	}
+	for (pos = 1; pos < req_ctx->child_req.dst_len; pos++)
+		if (req_ctx->out_buf[pos] == 0x00)
+			break;
+	if (pos < 9 || pos == req_ctx->child_req.dst_len) {
+		err = -EINVAL;
+		goto done;
+	}
+	pos++;
+
+	if (req->dst_len < req_ctx->child_req.dst_len - pos)
+		err = -EOVERFLOW;
+	req->dst_len = req_ctx->child_req.dst_len - pos;
+
+	if (!err)
+		sg_copy_from_buffer(req->dst,
+				sg_nents_for_len(req->dst, req->dst_len),
+				req_ctx->out_buf + pos, req->dst_len);
+
+done:
+	kzfree(req_ctx->out_buf);
+
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
+	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
+	int err;
+
+	if (!ctx->key_size || req->src_len != ctx->key_size)
+		return -EINVAL;
+
+	if (ctx->key_size > PAGE_SIZE)
+		return -ENOTSUPP;
+
+	/* Reuse input buffer, output to a new buffer */
+	req_ctx->child_req.src = req->src;
+	req_ctx->child_req.src_len = req->src_len;
+	req_ctx->child_req.dst = req_ctx->out_sg;
+	req_ctx->child_req.dst_len = ctx->key_size - 1;
+
+	req_ctx->out_buf = kmalloc(ctx->key_size - 1,
+			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC);
+	if (!req_ctx->out_buf)
+		return -ENOMEM;
+
+	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
+			ctx->key_size - 1, NULL);
+
+	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
+	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
+			pkcs1pad_decrypt_complete_cb, req);
+
+	err = crypto_akcipher_decrypt(&req_ctx->child_req);
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
+	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
+	int err;
+	unsigned int ps_end;
+
+	if (!ctx->key_size)
+		return -EINVAL;
+
+	if (req->src_len > ctx->key_size - 11)
+		return -EOVERFLOW;
+
+	if (req->dst_len < ctx->key_size) {
+		req->dst_len = ctx->key_size;
+		return -EOVERFLOW;
+	}
+
+	if (ctx->key_size > PAGE_SIZE)
+		return -ENOTSUPP;
+
+	/*
+	 * Replace both input and output to add the padding in the input and
+	 * the potential missing leading zeros in the output.
+	 */
+	req_ctx->child_req.src = req_ctx->in_sg;
+	req_ctx->child_req.src_len = ctx->key_size - 1;
+	req_ctx->child_req.dst = req_ctx->out_sg;
+	req_ctx->child_req.dst_len = ctx->key_size;
+
+	req_ctx->in_buf = kmalloc(ctx->key_size - 1 - req->src_len,
+			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC);
+	if (!req_ctx->in_buf)
+		return -ENOMEM;
+
+	ps_end = ctx->key_size - req->src_len - 2;
+	req_ctx->in_buf[0] = 0x01;
+	memset(req_ctx->in_buf + 1, 0xff, ps_end - 1);
+	req_ctx->in_buf[ps_end] = 0x00;
+
+	pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
+			ctx->key_size - 1 - req->src_len, req->src);
+
+	req_ctx->out_buf = kmalloc(ctx->key_size,
+			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC);
+	if (!req_ctx->out_buf) {
+		kfree(req_ctx->in_buf);
+		return -ENOMEM;
+	}
+
+	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
+			ctx->key_size, NULL);
+
+	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
+	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
+			pkcs1pad_encrypt_sign_complete_cb, req);
+
+	err = crypto_akcipher_sign(&req_ctx->child_req);
+	if (err != -EINPROGRESS && err != -EBUSY)
+		return pkcs1pad_encrypt_sign_complete(req, err);
+
+	return err;
+}
+
+static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
+	unsigned int pos;
+
+	if (err == -EOVERFLOW)
+		/* Decrypted value had no leading 0 byte */
+		err = -EINVAL;
+
+	if (err)
+		goto done;
+
+	if (req_ctx->child_req.dst_len != ctx->key_size - 1) {
+		err = -EINVAL;
+		goto done;
+	}
+
+	if (req_ctx->out_buf[0] != 0x01) {
+		err = -EINVAL;
+		goto done;
+	}
+	for (pos = 1; pos < req_ctx->child_req.dst_len; pos++)
+		if (req_ctx->out_buf[pos] != 0xff)
+			break;
+	if (pos < 9 || pos == req_ctx->child_req.dst_len ||
+			req_ctx->out_buf[pos] != 0x00) {
+		err = -EINVAL;
+		goto done;
+	}
+	pos++;
+
+	if (req->dst_len < req_ctx->child_req.dst_len - pos)
+		err = -EOVERFLOW;
+	req->dst_len = req_ctx->child_req.dst_len - pos;
+
+	if (!err)
+		sg_copy_from_buffer(req->dst,
+				sg_nents_for_len(req->dst, req->dst_len),
+				req_ctx->out_buf + pos, req->dst_len);
+
+done:
+	kzfree(req_ctx->out_buf);
+
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
+/*
+ * The verify operation is here for completeness similar to the verification
+ * defined in RFC2313 section 10.2 except that block type 0 is not accepted,
+ * as in RFC2437.  RFC2437 section 9.2 doesn't define any operation to
+ * retrieve the DigestInfo from a signature, instead the user is expected
+ * to call the sign operation to generate the expected signature and compare
+ * signatures instead of the message-digests.
+ */
+static int pkcs1pad_verify(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
+	int err;
+
+	if (!ctx->key_size || req->src_len != ctx->key_size)
+		return -EINVAL;
+
+	if (ctx->key_size > PAGE_SIZE)
+		return -ENOTSUPP;
+
+	/* Reuse input buffer, output to a new buffer */
+	req_ctx->child_req.src = req->src;
+	req_ctx->child_req.src_len = req->src_len;
+	req_ctx->child_req.dst = req_ctx->out_sg;
+	req_ctx->child_req.dst_len = ctx->key_size - 1;
+
+	req_ctx->out_buf = kmalloc(ctx->key_size - 1,
+			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC);
+	if (!req_ctx->out_buf)
+		return -ENOMEM;
+
+	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
+			ctx->key_size - 1, NULL);
+
+	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
+	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
+			pkcs1pad_verify_complete_cb, req);
+
+	err = crypto_akcipher_verify(&req_ctx->child_req);
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
+			offsetof(struct akcipher_alg, base));
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
+	akalg->set_pub_key = pkcs1pad_set_pub_key;
+	akalg->set_priv_key = pkcs1pad_set_priv_key;
+	akalg->max_size = pkcs1pad_get_max_size;
+	akalg->reqsize = sizeof(struct pkcs1pad_request) +
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
index 58aad69..77d737f 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -13,6 +13,7 @@
 #include <crypto/internal/rsa.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/akcipher.h>
+#include <crypto/algapi.h>
 
 /*
  * RSAEP function [RFC3447 sec 5.1.1]
@@ -315,11 +316,24 @@ static struct akcipher_alg rsa = {
 
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
 
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index f997e2d..c7585bd 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -27,4 +27,6 @@ int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
 		       unsigned int key_len);
 
 void rsa_free_key(struct rsa_key *rsa_key);
+
+extern struct crypto_template rsa_pkcs1pad_tmpl;
 #endif
-- 
2.1.4
