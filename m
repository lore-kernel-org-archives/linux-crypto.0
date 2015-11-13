From: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Subject: Re: [PATCH 4/4] crypto: RSA padding algorithm
Date: Fri, 13 Nov 2015 10:52:21 +0100
Message-ID: <CAOq732L9PynQjqdXzsXszvBVSf-jkXB7RhKpjr6nnFj84_OqWg@mail.gmail.com>
References: <1447203525-16796-1-git-send-email-andrew.zaborowski@intel.com>
	<1447203525-16796-4-git-send-email-andrew.zaborowski@intel.com>
	<1592431.XvasPcx0bt@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35889 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbbKMJwX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Nov 2015 04:52:23 -0500
Received: by wmww144 with SMTP id w144so21480166wmw.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2015 01:52:21 -0800 (PST)
In-Reply-To: <1592431.XvasPcx0bt@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On 11 November 2015 at 14:19, Stephan Mueller <smueller@chronox.de> wrote:
> Am Mittwoch, 11. November 2015, 01:58:45 schrieb Andrew Zaborowski:
>
> Hi Andrew,
>
>>This patch adds PKCS#1 v1.5 standard RSA padding as a separate template.
>>This way an RSA cipher with padding can be obtained by instantiating
>>"pkcs1pad(rsa)".  The reason for adding this is that RSA is almost
>>never used without this padding (or OAEP) so it will be needed for
>>either certificate work in the kernel or the userspace, and also I hear
>>that it is likely implemented by hardware RSA in which case an
>>implementation of the whole "pkcs1pad(rsa)" can be provided.
>
> In general, I think that there is a PKCS 1 implementation in the kernel in
> crypto/asymmetric_keys/rsa.c
>
> Shouldn't that all somehow being synchronized?

Probably as Marcel says the certificate code should use the crypto
algorithm API.  In its current form it won't be able to take advantage
of hardware acceleration but it must have tons of overhead less than
if it used the crypto API.

>
> Maybe this patch should go in but then crypto/asymmetric_keys/rsa.c should
> kind of being removed or point to kernel crypto API?
>>
>>Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
>>---
>> crypto/Makefile               |   1 +
>> crypto/rsa-padding.c          | 586
>>++++++++++++++++++++++++++++++++++++++++++ crypto/rsa.c                  |
>>16 +-
>> include/crypto/internal/rsa.h |   2 +
>> 4 files changed, 604 insertions(+), 1 deletion(-)
>> create mode 100644 crypto/rsa-padding.c
>>
>>diff --git a/crypto/Makefile b/crypto/Makefile
>>index f7aba92..46fe0b4 100644
>>--- a/crypto/Makefile
>>+++ b/crypto/Makefile
>>@@ -40,6 +40,7 @@ rsa_generic-y := rsapubkey-asn1.o
>> rsa_generic-y += rsaprivkey-asn1.o
>> rsa_generic-y += rsa.o
>> rsa_generic-y += rsa_helper.o
>>+rsa_generic-y += rsa-padding.o
>> obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o
>>
>> cryptomgr-y := algboss.o testmgr.o
>>diff --git a/crypto/rsa-padding.c b/crypto/rsa-padding.c
>>new file mode 100644
>>index 0000000..b9f9f31
>>--- /dev/null
>>+++ b/crypto/rsa-padding.c
>>@@ -0,0 +1,586 @@
>>+/*
>>+ * RSA padding templates.
>>+ *
>>+ * Copyright (c) 2015  Intel Corporation
>>+ *
>>+ * This program is free software; you can redistribute it and/or modify it
>>+ * under the terms of the GNU General Public License as published by the
>>Free + * Software Foundation; either version 2 of the License, or (at your
>>option) + * any later version.
>>+ */
>>+
>>+#include <crypto/algapi.h>
>>+#include <crypto/akcipher.h>
>>+#include <crypto/internal/akcipher.h>
>>+#include <linux/err.h>
>>+#include <linux/init.h>
>>+#include <linux/kernel.h>
>>+#include <linux/module.h>
>>+#include <linux/random.h>
>>+
>>+struct pkcs1pad_ctx {
>>+      struct crypto_akcipher *child;
>>+
>>+      unsigned int key_size;
>>+};
>>+
>>+struct pkcs1pad_request {
>>+      struct akcipher_request child_req;
>>+
>>+      struct scatterlist in_sg[3], out_sg[2];
>>+      uint8_t *in_buf, *out_buf;
>>+};
>>+
>>+static int pkcs1pad_set_pub_key(struct crypto_akcipher *tfm, const void
>>*key, +                unsigned int keylen)
>>+{
>>+      struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
>>+      int err, size;
>>+
>>+      err = crypto_akcipher_set_pub_key(ctx->child, key, keylen);
>>+
>>+      if (!err) {
>>+              /* Find out new modulus size from rsa implementation */
>>+              size = crypto_akcipher_maxsize(ctx->child);
>>+
>>+              ctx->key_size = size > 0 ? size : 0;
>>+              if (size <= 0)
>>+                      err = size;
>>+      }
>>+
>>+      return err;
>>+}
>>+
>>+static int pkcs1pad_set_priv_key(struct crypto_akcipher *tfm, const void
>>*key, +                unsigned int keylen)
>>+{
>>+      struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
>>+      int err, size;
>>+
>>+      err = crypto_akcipher_set_priv_key(ctx->child, key, keylen);
>>+
>>+      if (!err) {
>>+              /* Find out new modulus size from rsa implementation */
>>+              size = crypto_akcipher_maxsize(ctx->child);
>>+
>>+              ctx->key_size = size > 0 ? size : 0;
>>+              if (size <= 0)
>>+                      err = size;
>>+      }
>>+
>>+      return err;
>>+}
>>+
>>+static int pkcs1pad_get_max_size(struct crypto_akcipher *tfm)
>>+{
>>+      struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
>>+
>>+      /*
>>+       * The maximum destination buffer size for the encrypt/sign operations
>>+       * will be the same as for RSA, even though it's smaller for
>>+       * decrypt/verify.
>>+       */
>>+
>>+      return ctx->key_size ?: -EINVAL;
>>+}
>>+
>>+static void pkcs1pad_sg_set_buf(struct scatterlist *sg, void *buf, size_t
>>len, +         struct scatterlist *next)
>>+{
>>+      int nsegs = next ? 1 : 0;
>>+
>>+      if (offset_in_page(buf) + len <= PAGE_SIZE) {
>>+              nsegs += 1;
>>+              sg_init_table(sg, nsegs);
>>+              sg_set_buf(sg, buf, len);
>>+      } else {
>>+              nsegs += 2;
>>+              sg_init_table(sg, nsegs);
>>+              sg_set_buf(sg + 0, buf, PAGE_SIZE - offset_in_page(buf));
>>+              sg_set_buf(sg + 1, buf + PAGE_SIZE - offset_in_page(buf),
>>+                              offset_in_page(buf) + len - PAGE_SIZE);
>>+      }
>>+
>>+      if (next)
>>+              sg_chain(sg, nsegs, next);
>>+}
>>+
>>+static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, int
>>err) +{
>>+      struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
>>+      struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
>>+      struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
>>+      uint8_t zeros[ctx->key_size - req_ctx->child_req.dst_len];
>>+
>>+      if (!err) {
>>+              if (req_ctx->child_req.dst_len < ctx->key_size) {
>>+                      memset(zeros, 0, sizeof(zeros));
>>+                      sg_copy_from_buffer(req->dst,
>>+                                      sg_nents_for_len(req->dst,
>>+                                              sizeof(zeros)),
>>+                                      zeros, sizeof(zeros));
>>+              }
>>+
>>+              sg_pcopy_from_buffer(req->dst,
>>+                              sg_nents_for_len(req->dst, ctx->key_size),
>>+                              req_ctx->out_buf, req_ctx->child_req.dst_len,
>>+                              sizeof(zeros));
>>+      }
>>+      req->dst_len = ctx->key_size;
>>+
>>+      kfree(req_ctx->in_buf);
>>+      kzfree(req_ctx->out_buf);
>>+
>>+      return err;
>>+}
>>+
>>+static void pkcs1pad_encrypt_sign_complete_cb(
>>+              struct crypto_async_request *child_async_req, int err)
>>+{
>>+      struct akcipher_request *req = child_async_req->data;
>>+      struct crypto_async_request async_req;
>>+
>>+      if (err == -EINPROGRESS)
>>+              return;
>>+
>>+      async_req.data = req->base.data;
>>+      async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
>>+      async_req.flags = child_async_req->flags;
>>+      req->base.complete(&async_req,
>>+                      pkcs1pad_encrypt_sign_complete(req, err));
>>+}
>>+
>>+static int pkcs1pad_encrypt(struct akcipher_request *req)
>>+{
>>+      struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
>>+      struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
>>+      struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
>>+      int err;
>>+      unsigned int i, ps_end;
>>+
>>+      if (!ctx->key_size)
>>+              return -EINVAL;
>>+
>>+      if (req->src_len > ctx->key_size - 11)
>>+              return -EOVERFLOW;
>>+
>>+      if (req->dst_len < ctx->key_size) {
>>+              req->dst_len = ctx->key_size;
>>+              return -EOVERFLOW;
>>+      }
>>+
>>+      if (ctx->key_size > PAGE_SIZE)
>>+              return -ENOTSUPP;
>>+
>>+      /*
>>+       * Replace both input and output to add the padding in the input and
>>+       * the potential missing leading zeros in the output.
>>+       */
>>+      req_ctx->child_req.src = req_ctx->in_sg;
>>+      req_ctx->child_req.src_len = ctx->key_size - 1;
>>+      req_ctx->child_req.dst = req_ctx->out_sg;
>>+      req_ctx->child_req.dst_len = ctx->key_size;
>>+
>>+      req_ctx->in_buf = kmalloc(ctx->key_size - 1 - req->src_len,
>>+                      (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
>>+                      GFP_KERNEL : GFP_ATOMIC);
>>+      if (!req_ctx->in_buf)
>>+              return -ENOMEM;
>>+
>>+      ps_end = ctx->key_size - req->src_len - 2;
>>+      req_ctx->in_buf[0] = 0x02;
>>+      for (i = 1; i < ps_end; i++)
>>+              req_ctx->in_buf[i] = 1 + prandom_u32_max(255);
>>+      req_ctx->in_buf[ps_end] = 0x00;
>>+
>>+      pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
>>+                      ctx->key_size - 1 - req->src_len, req->src);
>>+
>>+      req_ctx->out_buf = kmalloc(ctx->key_size,
>>+                      (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
>>+                      GFP_KERNEL : GFP_ATOMIC);
>>+      if (!req_ctx->out_buf) {
>>+              kfree(req_ctx->in_buf);
>>+              return -ENOMEM;
>>+      }
>>+
>>+      pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
>>+                      ctx->key_size, NULL);
>>+
>>+      akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
>>+      akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
>>+                      pkcs1pad_encrypt_sign_complete_cb, req);
>>+
>>+      err = crypto_akcipher_encrypt(&req_ctx->child_req);
>>+      if (err != -EINPROGRESS && err != -EBUSY)
>>+              return pkcs1pad_encrypt_sign_complete(req, err);
>>+
>>+      return err;
>>+}
>>+
>>+static int pkcs1pad_decrypt_complete(struct akcipher_request *req, int err)
>>+{
>>+      struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
>>+      struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
>>+      struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
>>+      unsigned int pos;
>>+
>>+      if (err == -EOVERFLOW)
>>+              /* Decrypted value had no leading 0 byte */
>>+              err = -EINVAL;
>>+
>>+      if (err)
>>+              goto done;
>>+
>>+      if (req_ctx->child_req.dst_len != ctx->key_size - 1) {
>>+              err = -EINVAL;
>>+              goto done;
>>+      }
>>+
>>+      if (req_ctx->out_buf[0] != 0x02) {
>>+              err = -EINVAL;
>>+              goto done;
>>+      }
>>+      for (pos = 1; pos < req_ctx->child_req.dst_len; pos++)
>>+              if (req_ctx->out_buf[pos] == 0x00)
>>+                      break;
>>+      if (pos < 9 || pos == req_ctx->child_req.dst_len) {
>>+              err = -EINVAL;
>>+              goto done;
>>+      }
>>+      pos++;
>>+
>>+      if (req->dst_len < req_ctx->child_req.dst_len - pos)
>>+              err = -EOVERFLOW;
>>+      req->dst_len = req_ctx->child_req.dst_len - pos;
>>+
>>+      if (!err)
>>+              sg_copy_from_buffer(req->dst,
>>+                              sg_nents_for_len(req->dst, req->dst_len),
>>+                              req_ctx->out_buf + pos, req->dst_len);
>>+
>>+done:
>>+      kzfree(req_ctx->out_buf);
>>+
>>+      return err;
>>+}
>>+
>>+static void pkcs1pad_decrypt_complete_cb(
>>+              struct crypto_async_request *child_async_req, int err)
>>+{
>>+      struct akcipher_request *req = child_async_req->data;
>>+      struct crypto_async_request async_req;
>>+
>>+      if (err == -EINPROGRESS)
>>+              return;
>>+
>>+      async_req.data = req->base.data;
>>+      async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
>>+      async_req.flags = child_async_req->flags;
>>+      req->base.complete(&async_req, pkcs1pad_decrypt_complete(req, err));
>>+}
>>+
>>+static int pkcs1pad_decrypt(struct akcipher_request *req)
>>+{
>>+      struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
>>+      struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
>>+      struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
>>+      int err;
>>+
>>+      if (!ctx->key_size || req->src_len != ctx->key_size)
>>+              return -EINVAL;
>>+
>>+      if (ctx->key_size > PAGE_SIZE)
>>+              return -ENOTSUPP;
>>+
>>+      /* Reuse input buffer, output to a new buffer */
>>+      req_ctx->child_req.src = req->src;
>>+      req_ctx->child_req.src_len = req->src_len;
>>+      req_ctx->child_req.dst = req_ctx->out_sg;
>>+      req_ctx->child_req.dst_len = ctx->key_size - 1;
>>+
>>+      req_ctx->out_buf = kmalloc(ctx->key_size - 1,
>>+                      (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
>>+                      GFP_KERNEL : GFP_ATOMIC);
>>+      if (!req_ctx->out_buf)
>>+              return -ENOMEM;
>>+
>>+      pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
>>+                      ctx->key_size - 1, NULL);
>>+
>>+      akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
>>+      akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
>>+                      pkcs1pad_decrypt_complete_cb, req);
>>+
>>+      err = crypto_akcipher_decrypt(&req_ctx->child_req);
>>+      if (err != -EINPROGRESS && err != -EBUSY)
>>+              return pkcs1pad_decrypt_complete(req, err);
>>+
>>+      return err;
>>+}
>>+
>>+static int pkcs1pad_sign(struct akcipher_request *req)
>>+{
>>+      struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
>>+      struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
>>+      struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
>>+      int err;
>>+      unsigned int i, ps_end;
>>+
>>+      if (!ctx->key_size)
>>+              return -EINVAL;
>>+
>>+      if (req->src_len > ctx->key_size - 11)
>>+              return -EOVERFLOW;
>>+
>>+      if (req->dst_len < ctx->key_size) {
>>+              req->dst_len = ctx->key_size;
>>+              return -EOVERFLOW;
>>+      }
>>+
>>+      if (ctx->key_size > PAGE_SIZE)
>>+              return -ENOTSUPP;
>>+
>>+      /*
>>+       * Replace both input and output to add the padding in the input and
>>+       * the potential missing leading zeros in the output.
>>+       */
>>+      req_ctx->child_req.src = req_ctx->in_sg;
>>+      req_ctx->child_req.src_len = ctx->key_size - 1;
>>+      req_ctx->child_req.dst = req_ctx->out_sg;
>>+      req_ctx->child_req.dst_len = ctx->key_size;
>>+
>>+      req_ctx->in_buf = kmalloc(ctx->key_size - 1 - req->src_len,
>>+                      (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
>>+                      GFP_KERNEL : GFP_ATOMIC);
>>+      if (!req_ctx->in_buf)
>>+              return -ENOMEM;
>>+
>>+      ps_end = ctx->key_size - req->src_len - 2;
>>+      req_ctx->in_buf[0] = 0x01;
>>+      for (i = 1; i < ps_end; i++)
>>+              req_ctx->in_buf[i] = 0xff;
>
> why not using memset here?

I will do this, also rename the file as suggested by Tadeusz, add one
missing check, and resend.

Best regards
