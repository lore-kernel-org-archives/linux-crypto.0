Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A92EDE990
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 08:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbjINI25 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 04:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236510AbjINI2j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 04:28:39 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3391FEF
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:35 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1bd9b4f8e0eso4974425ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694680114; x=1695284914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zE3m74Sbzns+Y9g5bw1p0bWYiNqV5keIn4n/iwxY2Kg=;
        b=UZf9L3RUb+fDTemCoeBiDJ7gjlNwBw8Jtc6F9EiVIQ00mzFJlPEt9K61VkS/de7RBA
         GRfapEo8PCyR7SH+011kqu7r5MQc5tmXtoun8zp2lZU9d96j9agSV4W9C41Qncn+IgL+
         Z6oYSMdQoVTYzguWdIHSdcebv9Ii16G153ZWo6OsRe/nlDFkf/bqxgQ9vu4QK4SaLRiw
         lI+Wz5xryjjdBFEJ9cEaeXF/aZGV1p4a3XwAze51c5H2+2niLmHkemAiNcE9zZkSYfYS
         2KNtjpCLyppYFr6UFqXQKJs8LB2dEUYjjkHPUj7X0aVhFB0d7qvJOebTfHTOFLc7qssF
         PxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694680114; x=1695284914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zE3m74Sbzns+Y9g5bw1p0bWYiNqV5keIn4n/iwxY2Kg=;
        b=nTZjeDJelN6QSD8jApVrt1cCTDcBVpZEY3iWeQIk6kFx5BWVXH0a9eRcb65HL39CmV
         HRD3z6aTspXRehttTFqhmgLpTsVfr6Cj765gNYPjZNuPjV0hYvYC5G7h2YgSYgHrFXEN
         o2H2yl75af4ZQmVyMPxEsscTc0HXXikHjsGAeyVbS0sFwDazJI2ysquYkrw1mKdDxydu
         r2bmhbX8jG5Lh9a2m8/KEcMZqIdA8RYCNRsL7pWNjgxjLO0teo0uOF7wvvmGEK9KmKVa
         Krbwq323ZMUd8bkwJjVQBaYXC9owBDDpAf0xv1M7Wd0Nqign/gScaM2+R+F0AP16MgM3
         t+OA==
X-Gm-Message-State: AOJu0Yw0homvH3DjRj5wJWBqwi9spu0Bufd7Oxuylym6ar7bvgfxa7bv
        2XSmhRdpkBZtCI7VWxS2Te+iipiGhMI=
X-Google-Smtp-Source: AGHT+IHlbwn+YpX9S+piMZIoLm7gIZslfwFUkgF+i9b3vSV8I94wWlFn7Tfl1b1Gid4oMXgyMxpCGg==
X-Received: by 2002:a17:902:e841:b0:1b6:bced:1dc2 with SMTP id t1-20020a170902e84100b001b6bced1dc2mr6146936plg.0.1694680113932;
        Thu, 14 Sep 2023 01:28:33 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b001bba3a4888bsm976242plg.102.2023.09.14.01.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 01:28:33 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4/8] crypto: skcipher - Add lskcipher
Date:   Thu, 14 Sep 2023 16:28:24 +0800
Message-Id: <20230914082828.895403-5-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230914082828.895403-1-herbert@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a new API type lskcipher designed for taking straight kernel
pointers instead of SG lists.  Its relationship to skcipher will
be analogous to that between shash and ahash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/Makefile                    |   6 +-
 crypto/cryptd.c                    |   2 +-
 crypto/lskcipher.c                 | 594 +++++++++++++++++++++++++++++
 crypto/skcipher.c                  |  75 +++-
 crypto/skcipher.h                  |  30 ++
 include/crypto/internal/skcipher.h | 114 +++++-
 include/crypto/skcipher.h          | 309 ++++++++++++++-
 include/linux/crypto.h             |   1 +
 8 files changed, 1086 insertions(+), 45 deletions(-)
 create mode 100644 crypto/lskcipher.c
 create mode 100644 crypto/skcipher.h

diff --git a/crypto/Makefile b/crypto/Makefile
index 953a7e105e58..5ac6876f935a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -16,7 +16,11 @@ obj-$(CONFIG_CRYPTO_ALGAPI2) += crypto_algapi.o
 obj-$(CONFIG_CRYPTO_AEAD2) += aead.o
 obj-$(CONFIG_CRYPTO_GENIV) += geniv.o
 
-obj-$(CONFIG_CRYPTO_SKCIPHER2) += skcipher.o
+crypto_skcipher-y += lskcipher.o
+crypto_skcipher-y += skcipher.o
+
+obj-$(CONFIG_CRYPTO_SKCIPHER2) += crypto_skcipher.o
+
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 obj-$(CONFIG_CRYPTO_ECHAINIV) += echainiv.o
 
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index bbcc368b6a55..194a92d677b9 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -929,7 +929,7 @@ static int cryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
 		return PTR_ERR(algt);
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
-	case CRYPTO_ALG_TYPE_SKCIPHER:
+	case CRYPTO_ALG_TYPE_LSKCIPHER:
 		return cryptd_create_skcipher(tmpl, tb, algt, &queue);
 	case CRYPTO_ALG_TYPE_HASH:
 		return cryptd_create_hash(tmpl, tb, algt, &queue);
diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
new file mode 100644
index 000000000000..3343c6d955da
--- /dev/null
+++ b/crypto/lskcipher.c
@@ -0,0 +1,594 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Linear symmetric key cipher operations.
+ *
+ * Generic encrypt/decrypt wrapper for ciphers.
+ *
+ * Copyright (c) 2023 Herbert Xu <herbert@gondor.apana.org.au>
+ */
+
+#include <linux/cryptouser.h>
+#include <linux/err.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <net/netlink.h>
+#include "skcipher.h"
+
+static inline struct crypto_lskcipher *__crypto_lskcipher_cast(
+	struct crypto_tfm *tfm)
+{
+	return container_of(tfm, struct crypto_lskcipher, base);
+}
+
+static inline struct lskcipher_alg *__crypto_lskcipher_alg(
+	struct crypto_alg *alg)
+{
+	return container_of(alg, struct lskcipher_alg, co.base);
+}
+
+static inline struct crypto_istat_cipher *lskcipher_get_stat(
+	struct lskcipher_alg *alg)
+{
+	return skcipher_get_stat_common(&alg->co);
+}
+
+static inline int crypto_lskcipher_errstat(struct lskcipher_alg *alg, int err)
+{
+	struct crypto_istat_cipher *istat = lskcipher_get_stat(alg);
+
+	if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
+		return err;
+
+	if (err)
+		atomic64_inc(&istat->err_cnt);
+
+	return err;
+}
+
+static int lskcipher_setkey_unaligned(struct crypto_lskcipher *tfm,
+				      const u8 *key, unsigned int keylen)
+{
+	unsigned long alignmask = crypto_lskcipher_alignmask(tfm);
+	struct lskcipher_alg *cipher = crypto_lskcipher_alg(tfm);
+	u8 *buffer, *alignbuffer;
+	unsigned long absize;
+	int ret;
+
+	absize = keylen + alignmask;
+	buffer = kmalloc(absize, GFP_ATOMIC);
+	if (!buffer)
+		return -ENOMEM;
+
+	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
+	memcpy(alignbuffer, key, keylen);
+	ret = cipher->setkey(tfm, alignbuffer, keylen);
+	kfree_sensitive(buffer);
+	return ret;
+}
+
+int crypto_lskcipher_setkey(struct crypto_lskcipher *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	unsigned long alignmask = crypto_lskcipher_alignmask(tfm);
+	struct lskcipher_alg *cipher = crypto_lskcipher_alg(tfm);
+
+	if (keylen < cipher->co.min_keysize || keylen > cipher->co.max_keysize)
+		return -EINVAL;
+
+	if ((unsigned long)key & alignmask)
+		return lskcipher_setkey_unaligned(tfm, key, keylen);
+	else
+		return cipher->setkey(tfm, key, keylen);
+}
+EXPORT_SYMBOL_GPL(crypto_lskcipher_setkey);
+
+static int crypto_lskcipher_crypt_unaligned(
+	struct crypto_lskcipher *tfm, const u8 *src, u8 *dst, unsigned len,
+	u8 *iv, int (*crypt)(struct crypto_lskcipher *tfm, const u8 *src,
+			     u8 *dst, unsigned len, u8 *iv, bool final))
+{
+	unsigned ivsize = crypto_lskcipher_ivsize(tfm);
+	unsigned bs = crypto_lskcipher_blocksize(tfm);
+	unsigned cs = crypto_lskcipher_chunksize(tfm);
+	int err;
+	u8 *tiv;
+	u8 *p;
+
+	BUILD_BUG_ON(MAX_CIPHER_BLOCKSIZE > PAGE_SIZE ||
+		     MAX_CIPHER_ALIGNMASK >= PAGE_SIZE);
+
+	tiv = kmalloc(PAGE_SIZE, GFP_ATOMIC);
+	if (!tiv)
+		return -ENOMEM;
+
+	memcpy(tiv, iv, ivsize);
+
+	p = kmalloc(PAGE_SIZE, GFP_ATOMIC);
+	err = -ENOMEM;
+	if (!p)
+		goto out;
+
+	while (len >= bs) {
+		unsigned chunk = min((unsigned)PAGE_SIZE, len);
+		int err;
+
+		if (chunk > cs)
+			chunk &= ~(cs - 1);
+
+		memcpy(p, src, chunk);
+		err = crypt(tfm, p, p, chunk, tiv, true);
+		if (err)
+			goto out;
+
+		memcpy(dst, p, chunk);
+		src += chunk;
+		dst += chunk;
+		len -= chunk;
+	}
+
+	err = len ? -EINVAL : 0;
+
+out:
+	memcpy(iv, tiv, ivsize);
+	kfree_sensitive(p);
+	kfree_sensitive(tiv);
+	return err;
+}
+
+static int crypto_lskcipher_crypt(struct crypto_lskcipher *tfm, const u8 *src,
+				  u8 *dst, unsigned len, u8 *iv,
+				  int (*crypt)(struct crypto_lskcipher *tfm,
+					       const u8 *src, u8 *dst,
+					       unsigned len, u8 *iv,
+					       bool final))
+{
+	unsigned long alignmask = crypto_lskcipher_alignmask(tfm);
+	struct lskcipher_alg *alg = crypto_lskcipher_alg(tfm);
+	int ret;
+
+	if (((unsigned long)src | (unsigned long)dst | (unsigned long)iv) &
+	    alignmask) {
+		ret = crypto_lskcipher_crypt_unaligned(tfm, src, dst, len, iv,
+						       crypt);
+		goto out;
+	}
+
+	ret = crypt(tfm, src, dst, len, iv, true);
+
+out:
+	return crypto_lskcipher_errstat(alg, ret);
+}
+
+int crypto_lskcipher_encrypt(struct crypto_lskcipher *tfm, const u8 *src,
+			     u8 *dst, unsigned len, u8 *iv)
+{
+	struct lskcipher_alg *alg = crypto_lskcipher_alg(tfm);
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		struct crypto_istat_cipher *istat = lskcipher_get_stat(alg);
+
+		atomic64_inc(&istat->encrypt_cnt);
+		atomic64_add(len, &istat->encrypt_tlen);
+	}
+
+	return crypto_lskcipher_crypt(tfm, src, dst, len, iv, alg->encrypt);
+}
+EXPORT_SYMBOL_GPL(crypto_lskcipher_encrypt);
+
+int crypto_lskcipher_decrypt(struct crypto_lskcipher *tfm, const u8 *src,
+			     u8 *dst, unsigned len, u8 *iv)
+{
+	struct lskcipher_alg *alg = crypto_lskcipher_alg(tfm);
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
+		struct crypto_istat_cipher *istat = lskcipher_get_stat(alg);
+
+		atomic64_inc(&istat->decrypt_cnt);
+		atomic64_add(len, &istat->decrypt_tlen);
+	}
+
+	return crypto_lskcipher_crypt(tfm, src, dst, len, iv, alg->decrypt);
+}
+EXPORT_SYMBOL_GPL(crypto_lskcipher_decrypt);
+
+int crypto_lskcipher_setkey_sg(struct crypto_skcipher *tfm, const u8 *key,
+			       unsigned int keylen)
+{
+	struct crypto_lskcipher **ctx = crypto_skcipher_ctx(tfm);
+
+	return crypto_lskcipher_setkey(*ctx, key, keylen);
+}
+
+static int crypto_lskcipher_crypt_sg(struct skcipher_request *req,
+				     int (*crypt)(struct crypto_lskcipher *tfm,
+						  const u8 *src, u8 *dst,
+						  unsigned len, u8 *iv,
+						  bool final))
+{
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	struct crypto_lskcipher **ctx = crypto_skcipher_ctx(skcipher);
+	struct crypto_lskcipher *tfm = *ctx;
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	while (walk.nbytes) {
+		err = crypt(tfm, walk.src.virt.addr, walk.dst.virt.addr,
+			    walk.nbytes, walk.iv, walk.nbytes == walk.total);
+		err = skcipher_walk_done(&walk, err);
+	}
+
+	return err;
+}
+
+int crypto_lskcipher_encrypt_sg(struct skcipher_request *req)
+{
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	struct crypto_lskcipher **ctx = crypto_skcipher_ctx(skcipher);
+	struct lskcipher_alg *alg = crypto_lskcipher_alg(*ctx);
+
+	return crypto_lskcipher_crypt_sg(req, alg->encrypt);
+}
+
+int crypto_lskcipher_decrypt_sg(struct skcipher_request *req)
+{
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	struct crypto_lskcipher **ctx = crypto_skcipher_ctx(skcipher);
+	struct lskcipher_alg *alg = crypto_lskcipher_alg(*ctx);
+
+	return crypto_lskcipher_crypt_sg(req, alg->decrypt);
+}
+
+static void crypto_lskcipher_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_lskcipher *skcipher = __crypto_lskcipher_cast(tfm);
+	struct lskcipher_alg *alg = crypto_lskcipher_alg(skcipher);
+
+	alg->exit(skcipher);
+}
+
+static int crypto_lskcipher_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_lskcipher *skcipher = __crypto_lskcipher_cast(tfm);
+	struct lskcipher_alg *alg = crypto_lskcipher_alg(skcipher);
+
+	if (alg->exit)
+		skcipher->base.exit = crypto_lskcipher_exit_tfm;
+
+	if (alg->init)
+		return alg->init(skcipher);
+
+	return 0;
+}
+
+static void crypto_lskcipher_free_instance(struct crypto_instance *inst)
+{
+	struct lskcipher_instance *skcipher =
+		container_of(inst, struct lskcipher_instance, s.base);
+
+	skcipher->free(skcipher);
+}
+
+static void __maybe_unused crypto_lskcipher_show(
+	struct seq_file *m, struct crypto_alg *alg)
+{
+	struct lskcipher_alg *skcipher = __crypto_lskcipher_alg(alg);
+
+	seq_printf(m, "type         : lskcipher\n");
+	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
+	seq_printf(m, "min keysize  : %u\n", skcipher->co.min_keysize);
+	seq_printf(m, "max keysize  : %u\n", skcipher->co.max_keysize);
+	seq_printf(m, "ivsize       : %u\n", skcipher->co.ivsize);
+	seq_printf(m, "chunksize    : %u\n", skcipher->co.chunksize);
+}
+
+static int __maybe_unused crypto_lskcipher_report(
+	struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct lskcipher_alg *skcipher = __crypto_lskcipher_alg(alg);
+	struct crypto_report_blkcipher rblkcipher;
+
+	memset(&rblkcipher, 0, sizeof(rblkcipher));
+
+	strscpy(rblkcipher.type, "lskcipher", sizeof(rblkcipher.type));
+	strscpy(rblkcipher.geniv, "<none>", sizeof(rblkcipher.geniv));
+
+	rblkcipher.blocksize = alg->cra_blocksize;
+	rblkcipher.min_keysize = skcipher->co.min_keysize;
+	rblkcipher.max_keysize = skcipher->co.max_keysize;
+	rblkcipher.ivsize = skcipher->co.ivsize;
+
+	return nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
+		       sizeof(rblkcipher), &rblkcipher);
+}
+
+static int __maybe_unused crypto_lskcipher_report_stat(
+	struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct lskcipher_alg *skcipher = __crypto_lskcipher_alg(alg);
+	struct crypto_istat_cipher *istat;
+	struct crypto_stat_cipher rcipher;
+
+	istat = lskcipher_get_stat(skcipher);
+
+	memset(&rcipher, 0, sizeof(rcipher));
+
+	strscpy(rcipher.type, "cipher", sizeof(rcipher.type));
+
+	rcipher.stat_encrypt_cnt = atomic64_read(&istat->encrypt_cnt);
+	rcipher.stat_encrypt_tlen = atomic64_read(&istat->encrypt_tlen);
+	rcipher.stat_decrypt_cnt =  atomic64_read(&istat->decrypt_cnt);
+	rcipher.stat_decrypt_tlen = atomic64_read(&istat->decrypt_tlen);
+	rcipher.stat_err_cnt =  atomic64_read(&istat->err_cnt);
+
+	return nla_put(skb, CRYPTOCFGA_STAT_CIPHER, sizeof(rcipher), &rcipher);
+}
+
+static const struct crypto_type crypto_lskcipher_type = {
+	.extsize = crypto_alg_extsize,
+	.init_tfm = crypto_lskcipher_init_tfm,
+	.free = crypto_lskcipher_free_instance,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_lskcipher_show,
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_USER)
+	.report = crypto_lskcipher_report,
+#endif
+#ifdef CONFIG_CRYPTO_STATS
+	.report_stat = crypto_lskcipher_report_stat,
+#endif
+	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
+	.maskset = CRYPTO_ALG_TYPE_MASK,
+	.type = CRYPTO_ALG_TYPE_LSKCIPHER,
+	.tfmsize = offsetof(struct crypto_lskcipher, base),
+};
+
+static void crypto_lskcipher_exit_tfm_sg(struct crypto_tfm *tfm)
+{
+	struct crypto_lskcipher **ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_lskcipher(*ctx);
+}
+
+int crypto_init_lskcipher_ops_sg(struct crypto_tfm *tfm)
+{
+	struct crypto_lskcipher **ctx = crypto_tfm_ctx(tfm);
+	struct crypto_alg *calg = tfm->__crt_alg;
+	struct crypto_lskcipher *skcipher;
+
+	if (!crypto_mod_get(calg))
+		return -EAGAIN;
+
+	skcipher = crypto_create_tfm(calg, &crypto_lskcipher_type);
+	if (IS_ERR(skcipher)) {
+		crypto_mod_put(calg);
+		return PTR_ERR(skcipher);
+	}
+
+	*ctx = skcipher;
+	tfm->exit = crypto_lskcipher_exit_tfm_sg;
+
+	return 0;
+}
+
+int crypto_grab_lskcipher(struct crypto_lskcipher_spawn *spawn,
+			  struct crypto_instance *inst,
+			  const char *name, u32 type, u32 mask)
+{
+	spawn->base.frontend = &crypto_lskcipher_type;
+	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_grab_lskcipher);
+
+struct crypto_lskcipher *crypto_alloc_lskcipher(const char *alg_name,
+						u32 type, u32 mask)
+{
+	return crypto_alloc_tfm(alg_name, &crypto_lskcipher_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_lskcipher);
+
+static int lskcipher_prepare_alg(struct lskcipher_alg *alg)
+{
+	struct crypto_alg *base = &alg->co.base;
+	int err;
+
+	err = skcipher_prepare_alg_common(&alg->co);
+	if (err)
+		return err;
+
+	if (alg->co.chunksize & (alg->co.chunksize - 1))
+		return -EINVAL;
+
+	base->cra_type = &crypto_lskcipher_type;
+	base->cra_flags |= CRYPTO_ALG_TYPE_LSKCIPHER;
+
+	return 0;
+}
+
+int crypto_register_lskcipher(struct lskcipher_alg *alg)
+{
+	struct crypto_alg *base = &alg->co.base;
+	int err;
+
+	err = lskcipher_prepare_alg(alg);
+	if (err)
+		return err;
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_lskcipher);
+
+void crypto_unregister_lskcipher(struct lskcipher_alg *alg)
+{
+	crypto_unregister_alg(&alg->co.base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_lskcipher);
+
+int crypto_register_lskciphers(struct lskcipher_alg *algs, int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = crypto_register_lskcipher(&algs[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	for (--i; i >= 0; --i)
+		crypto_unregister_lskcipher(&algs[i]);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_register_lskciphers);
+
+void crypto_unregister_lskciphers(struct lskcipher_alg *algs, int count)
+{
+	int i;
+
+	for (i = count - 1; i >= 0; --i)
+		crypto_unregister_lskcipher(&algs[i]);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_lskciphers);
+
+int lskcipher_register_instance(struct crypto_template *tmpl,
+				struct lskcipher_instance *inst)
+{
+	int err;
+
+	if (WARN_ON(!inst->free))
+		return -EINVAL;
+
+	err = lskcipher_prepare_alg(&inst->alg);
+	if (err)
+		return err;
+
+	return crypto_register_instance(tmpl, lskcipher_crypto_instance(inst));
+}
+EXPORT_SYMBOL_GPL(lskcipher_register_instance);
+
+static int lskcipher_setkey_simple(struct crypto_lskcipher *tfm, const u8 *key,
+				   unsigned int keylen)
+{
+	struct crypto_lskcipher *cipher = lskcipher_cipher_simple(tfm);
+
+	crypto_lskcipher_clear_flags(cipher, CRYPTO_TFM_REQ_MASK);
+	crypto_lskcipher_set_flags(cipher, crypto_lskcipher_get_flags(tfm) &
+				   CRYPTO_TFM_REQ_MASK);
+	return crypto_lskcipher_setkey(cipher, key, keylen);
+}
+
+static int lskcipher_init_tfm_simple(struct crypto_lskcipher *tfm)
+{
+	struct lskcipher_instance *inst = lskcipher_alg_instance(tfm);
+	struct crypto_lskcipher **ctx = crypto_lskcipher_ctx(tfm);
+	struct crypto_lskcipher_spawn *spawn;
+	struct crypto_lskcipher *cipher;
+
+	spawn = lskcipher_instance_ctx(inst);
+	cipher = crypto_spawn_lskcipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	*ctx = cipher;
+	return 0;
+}
+
+static void lskcipher_exit_tfm_simple(struct crypto_lskcipher *tfm)
+{
+	struct crypto_lskcipher **ctx = crypto_lskcipher_ctx(tfm);
+
+	crypto_free_lskcipher(*ctx);
+}
+
+static void lskcipher_free_instance_simple(struct lskcipher_instance *inst)
+{
+	crypto_drop_lskcipher(lskcipher_instance_ctx(inst));
+	kfree(inst);
+}
+
+/**
+ * lskcipher_alloc_instance_simple - allocate instance of simple block cipher
+ *
+ * Allocate an lskcipher_instance for a simple block cipher mode of operation,
+ * e.g. cbc or ecb.  The instance context will have just a single crypto_spawn,
+ * that for the underlying cipher.  The {min,max}_keysize, ivsize, blocksize,
+ * alignmask, and priority are set from the underlying cipher but can be
+ * overridden if needed.  The tfm context defaults to
+ * struct crypto_lskcipher *, and default ->setkey(), ->init(), and
+ * ->exit() methods are installed.
+ *
+ * @tmpl: the template being instantiated
+ * @tb: the template parameters
+ *
+ * Return: a pointer to the new instance, or an ERR_PTR().  The caller still
+ *	   needs to register the instance.
+ */
+struct lskcipher_instance *lskcipher_alloc_instance_simple(
+	struct crypto_template *tmpl, struct rtattr **tb)
+{
+	u32 mask;
+	struct lskcipher_instance *inst;
+	struct crypto_lskcipher_spawn *spawn;
+	struct lskcipher_alg *cipher_alg;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_LSKCIPHER, &mask);
+	if (err)
+		return ERR_PTR(err);
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return ERR_PTR(-ENOMEM);
+
+	spawn = lskcipher_instance_ctx(inst);
+	err = crypto_grab_lskcipher(spawn,
+				    lskcipher_crypto_instance(inst),
+				    crypto_attr_alg_name(tb[1]), 0, mask);
+	if (err)
+		goto err_free_inst;
+	cipher_alg = crypto_lskcipher_spawn_alg(spawn);
+
+	err = crypto_inst_setname(lskcipher_crypto_instance(inst), tmpl->name,
+				  &cipher_alg->co.base);
+	if (err)
+		goto err_free_inst;
+
+	/* Don't allow nesting. */
+	err = -ELOOP;
+	if ((cipher_alg->co.base.cra_flags & CRYPTO_ALG_INSTANCE))
+		goto err_free_inst;
+
+	err = -EINVAL;
+	if (cipher_alg->co.ivsize)
+		goto err_free_inst;
+
+	inst->free = lskcipher_free_instance_simple;
+
+	/* Default algorithm properties, can be overridden */
+	inst->alg.co.base.cra_blocksize = cipher_alg->co.base.cra_blocksize;
+	inst->alg.co.base.cra_alignmask = cipher_alg->co.base.cra_alignmask;
+	inst->alg.co.base.cra_priority = cipher_alg->co.base.cra_priority;
+	inst->alg.co.min_keysize = cipher_alg->co.min_keysize;
+	inst->alg.co.max_keysize = cipher_alg->co.max_keysize;
+	inst->alg.co.ivsize = cipher_alg->co.base.cra_blocksize;
+
+	/* Use struct crypto_lskcipher * by default, can be overridden */
+	inst->alg.co.base.cra_ctxsize = sizeof(struct crypto_lskcipher *);
+	inst->alg.setkey = lskcipher_setkey_simple;
+	inst->alg.init = lskcipher_init_tfm_simple;
+	inst->alg.exit = lskcipher_exit_tfm_simple;
+
+	return inst;
+
+err_free_inst:
+	lskcipher_free_instance_simple(inst);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(lskcipher_alloc_instance_simple);
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 7b275716cf4e..b9496dc8a609 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -24,8 +24,9 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <net/netlink.h>
+#include "skcipher.h"
 
-#include "internal.h"
+#define CRYPTO_ALG_TYPE_SKCIPHER_MASK	0x0000000e
 
 enum {
 	SKCIPHER_WALK_PHYS = 1 << 0,
@@ -43,6 +44,8 @@ struct skcipher_walk_buffer {
 	u8 buffer[];
 };
 
+static const struct crypto_type crypto_skcipher_type;
+
 static int skcipher_walk_next(struct skcipher_walk *walk);
 
 static inline void skcipher_map_src(struct skcipher_walk *walk)
@@ -89,11 +92,7 @@ static inline struct skcipher_alg *__crypto_skcipher_alg(
 static inline struct crypto_istat_cipher *skcipher_get_stat(
 	struct skcipher_alg *alg)
 {
-#ifdef CONFIG_CRYPTO_STATS
-	return &alg->stat;
-#else
-	return NULL;
-#endif
+	return skcipher_get_stat_common(&alg->co);
 }
 
 static inline int crypto_skcipher_errstat(struct skcipher_alg *alg, int err)
@@ -468,6 +467,7 @@ static int skcipher_walk_skcipher(struct skcipher_walk *walk,
 				  struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 
 	walk->total = req->cryptlen;
 	walk->nbytes = 0;
@@ -485,10 +485,14 @@ static int skcipher_walk_skcipher(struct skcipher_walk *walk,
 		       SKCIPHER_WALK_SLEEP : 0;
 
 	walk->blocksize = crypto_skcipher_blocksize(tfm);
-	walk->stride = crypto_skcipher_walksize(tfm);
 	walk->ivsize = crypto_skcipher_ivsize(tfm);
 	walk->alignmask = crypto_skcipher_alignmask(tfm);
 
+	if (alg->co.base.cra_type != &crypto_skcipher_type)
+		walk->stride = alg->co.chunksize;
+	else
+		walk->stride = alg->walksize;
+
 	return skcipher_walk_first(walk);
 }
 
@@ -616,6 +620,11 @@ int crypto_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	unsigned long alignmask = crypto_skcipher_alignmask(tfm);
 	int err;
 
+	if (cipher->co.base.cra_type != &crypto_skcipher_type) {
+		err = crypto_lskcipher_setkey_sg(tfm, key, keylen);
+		goto out;
+	}
+
 	if (keylen < cipher->min_keysize || keylen > cipher->max_keysize)
 		return -EINVAL;
 
@@ -624,6 +633,7 @@ int crypto_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	else
 		err = cipher->setkey(tfm, key, keylen);
 
+out:
 	if (unlikely(err)) {
 		skcipher_set_needkey(tfm);
 		return err;
@@ -649,6 +659,8 @@ int crypto_skcipher_encrypt(struct skcipher_request *req)
 
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
+	else if (alg->co.base.cra_type != &crypto_skcipher_type)
+		ret = crypto_lskcipher_encrypt_sg(req);
 	else
 		ret = alg->encrypt(req);
 
@@ -671,6 +683,8 @@ int crypto_skcipher_decrypt(struct skcipher_request *req)
 
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
+	else if (alg->co.base.cra_type != &crypto_skcipher_type)
+		ret = crypto_lskcipher_decrypt_sg(req);
 	else
 		ret = alg->decrypt(req);
 
@@ -693,6 +707,9 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 
 	skcipher_set_needkey(skcipher);
 
+	if (tfm->__crt_alg->cra_type != &crypto_skcipher_type)
+		return crypto_init_lskcipher_ops_sg(tfm);
+
 	if (alg->exit)
 		skcipher->base.exit = crypto_skcipher_exit_tfm;
 
@@ -702,6 +719,14 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static unsigned int crypto_skcipher_extsize(struct crypto_alg *alg)
+{
+	if (alg->cra_type != &crypto_skcipher_type)
+		return sizeof(struct crypto_lskcipher *);
+
+	return crypto_alg_extsize(alg);
+}
+
 static void crypto_skcipher_free_instance(struct crypto_instance *inst)
 {
 	struct skcipher_instance *skcipher =
@@ -770,7 +795,7 @@ static int __maybe_unused crypto_skcipher_report_stat(
 }
 
 static const struct crypto_type crypto_skcipher_type = {
-	.extsize = crypto_alg_extsize,
+	.extsize = crypto_skcipher_extsize,
 	.init_tfm = crypto_skcipher_init_tfm,
 	.free = crypto_skcipher_free_instance,
 #ifdef CONFIG_PROC_FS
@@ -783,7 +808,7 @@ static const struct crypto_type crypto_skcipher_type = {
 	.report_stat = crypto_skcipher_report_stat,
 #endif
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
-	.maskset = CRYPTO_ALG_TYPE_MASK,
+	.maskset = CRYPTO_ALG_TYPE_SKCIPHER_MASK,
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.tfmsize = offsetof(struct crypto_skcipher, base),
 };
@@ -834,27 +859,43 @@ int crypto_has_skcipher(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_has_skcipher);
 
-static int skcipher_prepare_alg(struct skcipher_alg *alg)
+int skcipher_prepare_alg_common(struct skcipher_alg_common *alg)
 {
-	struct crypto_istat_cipher *istat = skcipher_get_stat(alg);
+	struct crypto_istat_cipher *istat = skcipher_get_stat_common(alg);
 	struct crypto_alg *base = &alg->base;
 
-	if (alg->ivsize > PAGE_SIZE / 8 || alg->chunksize > PAGE_SIZE / 8 ||
-	    alg->walksize > PAGE_SIZE / 8)
+	if (alg->ivsize > PAGE_SIZE / 8 || alg->chunksize > PAGE_SIZE / 8)
 		return -EINVAL;
 
 	if (!alg->chunksize)
 		alg->chunksize = base->cra_blocksize;
+
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		memset(istat, 0, sizeof(*istat));
+
+	return 0;
+}
+
+static int skcipher_prepare_alg(struct skcipher_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+	int err;
+
+	err = skcipher_prepare_alg_common(&alg->co);
+	if (err)
+		return err;
+
+	if (alg->walksize > PAGE_SIZE / 8)
+		return -EINVAL;
+
 	if (!alg->walksize)
 		alg->walksize = alg->chunksize;
 
 	base->cra_type = &crypto_skcipher_type;
-	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SKCIPHER;
 
-	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
-		memset(istat, 0, sizeof(*istat));
-
 	return 0;
 }
 
diff --git a/crypto/skcipher.h b/crypto/skcipher.h
new file mode 100644
index 000000000000..6f1295f0fef2
--- /dev/null
+++ b/crypto/skcipher.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Cryptographic API.
+ *
+ * Copyright (c) 2023 Herbert Xu <herbert@gondor.apana.org.au>
+ */
+#ifndef _LOCAL_CRYPTO_SKCIPHER_H
+#define _LOCAL_CRYPTO_SKCIPHER_H
+
+#include <crypto/internal/skcipher.h>
+#include "internal.h"
+
+static inline struct crypto_istat_cipher *skcipher_get_stat_common(
+	struct skcipher_alg_common *alg)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	return &alg->stat;
+#else
+	return NULL;
+#endif
+}
+
+int crypto_lskcipher_setkey_sg(struct crypto_skcipher *tfm, const u8 *key,
+			       unsigned int keylen);
+int crypto_lskcipher_encrypt_sg(struct skcipher_request *req);
+int crypto_lskcipher_decrypt_sg(struct skcipher_request *req);
+int crypto_init_lskcipher_ops_sg(struct crypto_tfm *tfm);
+int skcipher_prepare_alg_common(struct skcipher_alg_common *alg);
+
+#endif	/* _LOCAL_CRYPTO_SKCIPHER_H */
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index fb3d9e899f52..4382fd707b8a 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -36,10 +36,25 @@ struct skcipher_instance {
 	};
 };
 
+struct lskcipher_instance {
+	void (*free)(struct lskcipher_instance *inst);
+	union {
+		struct {
+			char head[offsetof(struct lskcipher_alg, co.base)];
+			struct crypto_instance base;
+		} s;
+		struct lskcipher_alg alg;
+	};
+};
+
 struct crypto_skcipher_spawn {
 	struct crypto_spawn base;
 };
 
+struct crypto_lskcipher_spawn {
+	struct crypto_spawn base;
+};
+
 struct skcipher_walk {
 	union {
 		struct {
@@ -80,6 +95,12 @@ static inline struct crypto_instance *skcipher_crypto_instance(
 	return &inst->s.base;
 }
 
+static inline struct crypto_instance *lskcipher_crypto_instance(
+	struct lskcipher_instance *inst)
+{
+	return &inst->s.base;
+}
+
 static inline struct skcipher_instance *skcipher_alg_instance(
 	struct crypto_skcipher *skcipher)
 {
@@ -87,11 +108,23 @@ static inline struct skcipher_instance *skcipher_alg_instance(
 			    struct skcipher_instance, alg);
 }
 
+static inline struct lskcipher_instance *lskcipher_alg_instance(
+	struct crypto_lskcipher *lskcipher)
+{
+	return container_of(crypto_lskcipher_alg(lskcipher),
+			    struct lskcipher_instance, alg);
+}
+
 static inline void *skcipher_instance_ctx(struct skcipher_instance *inst)
 {
 	return crypto_instance_ctx(skcipher_crypto_instance(inst));
 }
 
+static inline void *lskcipher_instance_ctx(struct lskcipher_instance *inst)
+{
+	return crypto_instance_ctx(lskcipher_crypto_instance(inst));
+}
+
 static inline void skcipher_request_complete(struct skcipher_request *req, int err)
 {
 	crypto_request_complete(&req->base, err);
@@ -101,29 +134,56 @@ int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
 			 struct crypto_instance *inst,
 			 const char *name, u32 type, u32 mask);
 
+int crypto_grab_lskcipher(struct crypto_lskcipher_spawn *spawn,
+			  struct crypto_instance *inst,
+			  const char *name, u32 type, u32 mask);
+
 static inline void crypto_drop_skcipher(struct crypto_skcipher_spawn *spawn)
 {
 	crypto_drop_spawn(&spawn->base);
 }
 
+static inline void crypto_drop_lskcipher(struct crypto_lskcipher_spawn *spawn)
+{
+	crypto_drop_spawn(&spawn->base);
+}
+
 static inline struct skcipher_alg *crypto_skcipher_spawn_alg(
 	struct crypto_skcipher_spawn *spawn)
 {
 	return container_of(spawn->base.alg, struct skcipher_alg, base);
 }
 
+static inline struct lskcipher_alg *crypto_lskcipher_spawn_alg(
+	struct crypto_lskcipher_spawn *spawn)
+{
+	return container_of(spawn->base.alg, struct lskcipher_alg, co.base);
+}
+
 static inline struct skcipher_alg *crypto_spawn_skcipher_alg(
 	struct crypto_skcipher_spawn *spawn)
 {
 	return crypto_skcipher_spawn_alg(spawn);
 }
 
+static inline struct lskcipher_alg *crypto_spawn_lskcipher_alg(
+	struct crypto_lskcipher_spawn *spawn)
+{
+	return crypto_lskcipher_spawn_alg(spawn);
+}
+
 static inline struct crypto_skcipher *crypto_spawn_skcipher(
 	struct crypto_skcipher_spawn *spawn)
 {
 	return crypto_spawn_tfm2(&spawn->base);
 }
 
+static inline struct crypto_lskcipher *crypto_spawn_lskcipher(
+	struct crypto_lskcipher_spawn *spawn)
+{
+	return crypto_spawn_tfm2(&spawn->base);
+}
+
 static inline void crypto_skcipher_set_reqsize(
 	struct crypto_skcipher *skcipher, unsigned int reqsize)
 {
@@ -144,6 +204,13 @@ void crypto_unregister_skciphers(struct skcipher_alg *algs, int count);
 int skcipher_register_instance(struct crypto_template *tmpl,
 			       struct skcipher_instance *inst);
 
+int crypto_register_lskcipher(struct lskcipher_alg *alg);
+void crypto_unregister_lskcipher(struct lskcipher_alg *alg);
+int crypto_register_lskciphers(struct lskcipher_alg *algs, int count);
+void crypto_unregister_lskciphers(struct lskcipher_alg *algs, int count);
+int lskcipher_register_instance(struct crypto_template *tmpl,
+				struct lskcipher_instance *inst);
+
 int skcipher_walk_done(struct skcipher_walk *walk, int err);
 int skcipher_walk_virt(struct skcipher_walk *walk,
 		       struct skcipher_request *req,
@@ -166,6 +233,11 @@ static inline void *crypto_skcipher_ctx(struct crypto_skcipher *tfm)
 	return crypto_tfm_ctx(&tfm->base);
 }
 
+static inline void *crypto_lskcipher_ctx(struct crypto_lskcipher *tfm)
+{
+	return crypto_tfm_ctx(&tfm->base);
+}
+
 static inline void *crypto_skcipher_ctx_dma(struct crypto_skcipher *tfm)
 {
 	return crypto_tfm_ctx_dma(&tfm->base);
@@ -209,21 +281,16 @@ static inline unsigned int crypto_skcipher_alg_walksize(
 	return alg->walksize;
 }
 
-/**
- * crypto_skcipher_walksize() - obtain walk size
- * @tfm: cipher handle
- *
- * In some cases, algorithms can only perform optimally when operating on
- * multiple blocks in parallel. This is reflected by the walksize, which
- * must be a multiple of the chunksize (or equal if the concern does not
- * apply)
- *
- * Return: walk size in bytes
- */
-static inline unsigned int crypto_skcipher_walksize(
-	struct crypto_skcipher *tfm)
+static inline unsigned int crypto_lskcipher_alg_min_keysize(
+	struct lskcipher_alg *alg)
 {
-	return crypto_skcipher_alg_walksize(crypto_skcipher_alg(tfm));
+	return alg->co.min_keysize;
+}
+
+static inline unsigned int crypto_lskcipher_alg_max_keysize(
+	struct lskcipher_alg *alg)
+{
+	return alg->co.max_keysize;
 }
 
 /* Helpers for simple block cipher modes of operation */
@@ -249,5 +316,24 @@ static inline struct crypto_alg *skcipher_ialg_simple(
 	return crypto_spawn_cipher_alg(spawn);
 }
 
+static inline struct crypto_lskcipher *lskcipher_cipher_simple(
+	struct crypto_lskcipher *tfm)
+{
+	struct crypto_lskcipher **ctx = crypto_lskcipher_ctx(tfm);
+
+	return *ctx;
+}
+
+struct lskcipher_instance *lskcipher_alloc_instance_simple(
+	struct crypto_template *tmpl, struct rtattr **tb);
+
+static inline struct lskcipher_alg *lskcipher_ialg_simple(
+	struct lskcipher_instance *inst)
+{
+	struct crypto_lskcipher_spawn *spawn = lskcipher_instance_ctx(inst);
+
+	return crypto_lskcipher_spawn_alg(spawn);
+}
+
 #endif	/* _CRYPTO_INTERNAL_SKCIPHER_H */
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 080d1ba3611d..a648ef5ce897 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -49,6 +49,10 @@ struct crypto_sync_skcipher {
 	struct crypto_skcipher base;
 };
 
+struct crypto_lskcipher {
+	struct crypto_tfm base;
+};
+
 /*
  * struct crypto_istat_cipher - statistics for cipher algorithm
  * @encrypt_cnt:	number of encrypt requests
@@ -65,6 +69,43 @@ struct crypto_istat_cipher {
 	atomic64_t err_cnt;
 };
 
+#ifdef CONFIG_CRYPTO_STATS
+#define SKCIPHER_ALG_COMMON_STAT struct crypto_istat_cipher stat;
+#else
+#define SKCIPHER_ALG_COMMON_STAT
+#endif
+
+/*
+ * struct skcipher_alg_common - common properties of skcipher_alg
+ * @min_keysize: Minimum key size supported by the transformation. This is the
+ *		 smallest key length supported by this transformation algorithm.
+ *		 This must be set to one of the pre-defined values as this is
+ *		 not hardware specific. Possible values for this field can be
+ *		 found via git grep "_MIN_KEY_SIZE" include/crypto/
+ * @max_keysize: Maximum key size supported by the transformation. This is the
+ *		 largest key length supported by this transformation algorithm.
+ *		 This must be set to one of the pre-defined values as this is
+ *		 not hardware specific. Possible values for this field can be
+ *		 found via git grep "_MAX_KEY_SIZE" include/crypto/
+ * @ivsize: IV size applicable for transformation. The consumer must provide an
+ *	    IV of exactly that size to perform the encrypt or decrypt operation.
+ * @chunksize: Equal to the block size except for stream ciphers such as
+ *	       CTR where it is set to the underlying block size.
+ * @stat: Statistics for cipher algorithm
+ * @base: Definition of a generic crypto algorithm.
+ */
+#define SKCIPHER_ALG_COMMON {		\
+	unsigned int min_keysize;	\
+	unsigned int max_keysize;	\
+	unsigned int ivsize;		\
+	unsigned int chunksize;		\
+					\
+	SKCIPHER_ALG_COMMON_STAT	\
+					\
+	struct crypto_alg base;		\
+}
+struct skcipher_alg_common SKCIPHER_ALG_COMMON;
+
 /**
  * struct skcipher_alg - symmetric key cipher definition
  * @min_keysize: Minimum key size supported by the transformation. This is the
@@ -120,6 +161,7 @@ struct crypto_istat_cipher {
  * 	      in parallel. Should be a multiple of chunksize.
  * @stat: Statistics for cipher algorithm
  * @base: Definition of a generic crypto algorithm.
+ * @co: see struct skcipher_alg_common
  *
  * All fields except @ivsize are mandatory and must be filled.
  */
@@ -131,17 +173,55 @@ struct skcipher_alg {
 	int (*init)(struct crypto_skcipher *tfm);
 	void (*exit)(struct crypto_skcipher *tfm);
 
-	unsigned int min_keysize;
-	unsigned int max_keysize;
-	unsigned int ivsize;
-	unsigned int chunksize;
 	unsigned int walksize;
 
-#ifdef CONFIG_CRYPTO_STATS
-	struct crypto_istat_cipher stat;
-#endif
+	union {
+		struct SKCIPHER_ALG_COMMON;
+		struct skcipher_alg_common co;
+	};
+};
 
-	struct crypto_alg base;
+/**
+ * struct lskcipher_alg - linear symmetric key cipher definition
+ * @setkey: Set key for the transformation. This function is used to either
+ *	    program a supplied key into the hardware or store the key in the
+ *	    transformation context for programming it later. Note that this
+ *	    function does modify the transformation context. This function can
+ *	    be called multiple times during the existence of the transformation
+ *	    object, so one must make sure the key is properly reprogrammed into
+ *	    the hardware. This function is also responsible for checking the key
+ *	    length for validity. In case a software fallback was put in place in
+ *	    the @cra_init call, this function might need to use the fallback if
+ *	    the algorithm doesn't support all of the key sizes.
+ * @encrypt: Encrypt a number of bytes. This function is used to encrypt
+ *	     the supplied data.  This function shall not modify
+ *	     the transformation context, as this function may be called
+ *	     in parallel with the same transformation object.  Data
+ *	     may be left over if length is not a multiple of blocks
+ *	     and there is more to come (final == false).  The number of
+ *	     left-over bytes should be returned in case of success.
+ * @decrypt: Decrypt a number of bytes. This is a reverse counterpart to
+ *	     @encrypt and the conditions are exactly the same.
+ * @init: Initialize the cryptographic transformation object. This function
+ *	  is used to initialize the cryptographic transformation object.
+ *	  This function is called only once at the instantiation time, right
+ *	  after the transformation context was allocated.
+ * @exit: Deinitialize the cryptographic transformation object. This is a
+ *	  counterpart to @init, used to remove various changes set in
+ *	  @init.
+ * @co: see struct skcipher_alg_common
+ */
+struct lskcipher_alg {
+	int (*setkey)(struct crypto_lskcipher *tfm, const u8 *key,
+	              unsigned int keylen);
+	int (*encrypt)(struct crypto_lskcipher *tfm, const u8 *src,
+		       u8 *dst, unsigned len, u8 *iv, bool final);
+	int (*decrypt)(struct crypto_lskcipher *tfm, const u8 *src,
+		       u8 *dst, unsigned len, u8 *iv, bool final);
+	int (*init)(struct crypto_lskcipher *tfm);
+	void (*exit)(struct crypto_lskcipher *tfm);
+
+	struct skcipher_alg_common co;
 };
 
 #define MAX_SYNC_SKCIPHER_REQSIZE      384
@@ -213,12 +293,36 @@ struct crypto_skcipher *crypto_alloc_skcipher(const char *alg_name,
 struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(const char *alg_name,
 					      u32 type, u32 mask);
 
+
+/**
+ * crypto_alloc_lskcipher() - allocate linear symmetric key cipher handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      lskcipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Allocate a cipher handle for an lskcipher. The returned struct
+ * crypto_lskcipher is the cipher handle that is required for any subsequent
+ * API invocation for that lskcipher.
+ *
+ * Return: allocated cipher handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
+struct crypto_lskcipher *crypto_alloc_lskcipher(const char *alg_name,
+						u32 type, u32 mask);
+
 static inline struct crypto_tfm *crypto_skcipher_tfm(
 	struct crypto_skcipher *tfm)
 {
 	return &tfm->base;
 }
 
+static inline struct crypto_tfm *crypto_lskcipher_tfm(
+	struct crypto_lskcipher *tfm)
+{
+	return &tfm->base;
+}
+
 /**
  * crypto_free_skcipher() - zeroize and free cipher handle
  * @tfm: cipher handle to be freed
@@ -235,6 +339,17 @@ static inline void crypto_free_sync_skcipher(struct crypto_sync_skcipher *tfm)
 	crypto_free_skcipher(&tfm->base);
 }
 
+/**
+ * crypto_free_lskcipher() - zeroize and free cipher handle
+ * @tfm: cipher handle to be freed
+ *
+ * If @tfm is a NULL or error pointer, this function does nothing.
+ */
+static inline void crypto_free_lskcipher(struct crypto_lskcipher *tfm)
+{
+	crypto_destroy_tfm(tfm, crypto_lskcipher_tfm(tfm));
+}
+
 /**
  * crypto_has_skcipher() - Search for the availability of an skcipher.
  * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
@@ -253,6 +368,19 @@ static inline const char *crypto_skcipher_driver_name(
 	return crypto_tfm_alg_driver_name(crypto_skcipher_tfm(tfm));
 }
 
+static inline const char *crypto_lskcipher_driver_name(
+	struct crypto_lskcipher *tfm)
+{
+	return crypto_tfm_alg_driver_name(crypto_lskcipher_tfm(tfm));
+}
+
+static inline struct skcipher_alg_common *crypto_skcipher_alg_common(
+	struct crypto_skcipher *tfm)
+{
+	return container_of(crypto_skcipher_tfm(tfm)->__crt_alg,
+			    struct skcipher_alg_common, base);
+}
+
 static inline struct skcipher_alg *crypto_skcipher_alg(
 	struct crypto_skcipher *tfm)
 {
@@ -260,11 +388,24 @@ static inline struct skcipher_alg *crypto_skcipher_alg(
 			    struct skcipher_alg, base);
 }
 
+static inline struct lskcipher_alg *crypto_lskcipher_alg(
+	struct crypto_lskcipher *tfm)
+{
+	return container_of(crypto_lskcipher_tfm(tfm)->__crt_alg,
+			    struct lskcipher_alg, co.base);
+}
+
 static inline unsigned int crypto_skcipher_alg_ivsize(struct skcipher_alg *alg)
 {
 	return alg->ivsize;
 }
 
+static inline unsigned int crypto_lskcipher_alg_ivsize(
+	struct lskcipher_alg *alg)
+{
+	return alg->co.ivsize;
+}
+
 /**
  * crypto_skcipher_ivsize() - obtain IV size
  * @tfm: cipher handle
@@ -276,7 +417,7 @@ static inline unsigned int crypto_skcipher_alg_ivsize(struct skcipher_alg *alg)
  */
 static inline unsigned int crypto_skcipher_ivsize(struct crypto_skcipher *tfm)
 {
-	return crypto_skcipher_alg(tfm)->ivsize;
+	return crypto_skcipher_alg_common(tfm)->ivsize;
 }
 
 static inline unsigned int crypto_sync_skcipher_ivsize(
@@ -285,6 +426,21 @@ static inline unsigned int crypto_sync_skcipher_ivsize(
 	return crypto_skcipher_ivsize(&tfm->base);
 }
 
+/**
+ * crypto_lskcipher_ivsize() - obtain IV size
+ * @tfm: cipher handle
+ *
+ * The size of the IV for the lskcipher referenced by the cipher handle is
+ * returned. This IV size may be zero if the cipher does not need an IV.
+ *
+ * Return: IV size in bytes
+ */
+static inline unsigned int crypto_lskcipher_ivsize(
+	struct crypto_lskcipher *tfm)
+{
+	return crypto_lskcipher_alg(tfm)->co.ivsize;
+}
+
 /**
  * crypto_skcipher_blocksize() - obtain block size of cipher
  * @tfm: cipher handle
@@ -301,12 +457,34 @@ static inline unsigned int crypto_skcipher_blocksize(
 	return crypto_tfm_alg_blocksize(crypto_skcipher_tfm(tfm));
 }
 
+/**
+ * crypto_lskcipher_blocksize() - obtain block size of cipher
+ * @tfm: cipher handle
+ *
+ * The block size for the lskcipher referenced with the cipher handle is
+ * returned. The caller may use that information to allocate appropriate
+ * memory for the data returned by the encryption or decryption operation
+ *
+ * Return: block size of cipher
+ */
+static inline unsigned int crypto_lskcipher_blocksize(
+	struct crypto_lskcipher *tfm)
+{
+	return crypto_tfm_alg_blocksize(crypto_lskcipher_tfm(tfm));
+}
+
 static inline unsigned int crypto_skcipher_alg_chunksize(
 	struct skcipher_alg *alg)
 {
 	return alg->chunksize;
 }
 
+static inline unsigned int crypto_lskcipher_alg_chunksize(
+	struct lskcipher_alg *alg)
+{
+	return alg->co.chunksize;
+}
+
 /**
  * crypto_skcipher_chunksize() - obtain chunk size
  * @tfm: cipher handle
@@ -321,7 +499,24 @@ static inline unsigned int crypto_skcipher_alg_chunksize(
 static inline unsigned int crypto_skcipher_chunksize(
 	struct crypto_skcipher *tfm)
 {
-	return crypto_skcipher_alg_chunksize(crypto_skcipher_alg(tfm));
+	return crypto_skcipher_alg_common(tfm)->chunksize;
+}
+
+/**
+ * crypto_lskcipher_chunksize() - obtain chunk size
+ * @tfm: cipher handle
+ *
+ * The block size is set to one for ciphers such as CTR.  However,
+ * you still need to provide incremental updates in multiples of
+ * the underlying block size as the IV does not have sub-block
+ * granularity.  This is known in this API as the chunk size.
+ *
+ * Return: chunk size in bytes
+ */
+static inline unsigned int crypto_lskcipher_chunksize(
+	struct crypto_lskcipher *tfm)
+{
+	return crypto_lskcipher_alg_chunksize(crypto_lskcipher_alg(tfm));
 }
 
 static inline unsigned int crypto_sync_skcipher_blocksize(
@@ -336,6 +531,12 @@ static inline unsigned int crypto_skcipher_alignmask(
 	return crypto_tfm_alg_alignmask(crypto_skcipher_tfm(tfm));
 }
 
+static inline unsigned int crypto_lskcipher_alignmask(
+	struct crypto_lskcipher *tfm)
+{
+	return crypto_tfm_alg_alignmask(crypto_lskcipher_tfm(tfm));
+}
+
 static inline u32 crypto_skcipher_get_flags(struct crypto_skcipher *tfm)
 {
 	return crypto_tfm_get_flags(crypto_skcipher_tfm(tfm));
@@ -371,6 +572,23 @@ static inline void crypto_sync_skcipher_clear_flags(
 	crypto_skcipher_clear_flags(&tfm->base, flags);
 }
 
+static inline u32 crypto_lskcipher_get_flags(struct crypto_lskcipher *tfm)
+{
+	return crypto_tfm_get_flags(crypto_lskcipher_tfm(tfm));
+}
+
+static inline void crypto_lskcipher_set_flags(struct crypto_lskcipher *tfm,
+					       u32 flags)
+{
+	crypto_tfm_set_flags(crypto_lskcipher_tfm(tfm), flags);
+}
+
+static inline void crypto_lskcipher_clear_flags(struct crypto_lskcipher *tfm,
+						 u32 flags)
+{
+	crypto_tfm_clear_flags(crypto_lskcipher_tfm(tfm), flags);
+}
+
 /**
  * crypto_skcipher_setkey() - set key for cipher
  * @tfm: cipher handle
@@ -396,16 +614,47 @@ static inline int crypto_sync_skcipher_setkey(struct crypto_sync_skcipher *tfm,
 	return crypto_skcipher_setkey(&tfm->base, key, keylen);
 }
 
+/**
+ * crypto_lskcipher_setkey() - set key for cipher
+ * @tfm: cipher handle
+ * @key: buffer holding the key
+ * @keylen: length of the key in bytes
+ *
+ * The caller provided key is set for the lskcipher referenced by the cipher
+ * handle.
+ *
+ * Note, the key length determines the cipher type. Many block ciphers implement
+ * different cipher modes depending on the key size, such as AES-128 vs AES-192
+ * vs. AES-256. When providing a 16 byte key for an AES cipher handle, AES-128
+ * is performed.
+ *
+ * Return: 0 if the setting of the key was successful; < 0 if an error occurred
+ */
+int crypto_lskcipher_setkey(struct crypto_lskcipher *tfm,
+			    const u8 *key, unsigned int keylen);
+
 static inline unsigned int crypto_skcipher_min_keysize(
 	struct crypto_skcipher *tfm)
 {
-	return crypto_skcipher_alg(tfm)->min_keysize;
+	return crypto_skcipher_alg_common(tfm)->min_keysize;
 }
 
 static inline unsigned int crypto_skcipher_max_keysize(
 	struct crypto_skcipher *tfm)
 {
-	return crypto_skcipher_alg(tfm)->max_keysize;
+	return crypto_skcipher_alg_common(tfm)->max_keysize;
+}
+
+static inline unsigned int crypto_lskcipher_min_keysize(
+	struct crypto_lskcipher *tfm)
+{
+	return crypto_lskcipher_alg(tfm)->co.min_keysize;
+}
+
+static inline unsigned int crypto_lskcipher_max_keysize(
+	struct crypto_lskcipher *tfm)
+{
+	return crypto_lskcipher_alg(tfm)->co.max_keysize;
 }
 
 /**
@@ -457,6 +706,42 @@ int crypto_skcipher_encrypt(struct skcipher_request *req);
  */
 int crypto_skcipher_decrypt(struct skcipher_request *req);
 
+/**
+ * crypto_lskcipher_encrypt() - encrypt plaintext
+ * @tfm: lskcipher handle
+ * @src: source buffer
+ * @dst: destination buffer
+ * @len: number of bytes to process
+ * @iv: IV for the cipher operation which must comply with the IV size defined
+ *      by crypto_lskcipher_ivsize
+ *
+ * Encrypt plaintext data using the lskcipher handle.
+ *
+ * Return: >=0 if the cipher operation was successful, if positive
+ *	   then this many bytes have been left unprocessed;
+ *	   < 0 if an error occurred
+ */
+int crypto_lskcipher_encrypt(struct crypto_lskcipher *tfm, const u8 *src,
+			     u8 *dst, unsigned len, u8 *iv);
+
+/**
+ * crypto_lskcipher_decrypt() - decrypt ciphertext
+ * @tfm: lskcipher handle
+ * @src: source buffer
+ * @dst: destination buffer
+ * @len: number of bytes to process
+ * @iv: IV for the cipher operation which must comply with the IV size defined
+ *      by crypto_lskcipher_ivsize
+ *
+ * Decrypt ciphertext data using the lskcipher handle.
+ *
+ * Return: >=0 if the cipher operation was successful, if positive
+ *	   then this many bytes have been left unprocessed;
+ *	   < 0 if an error occurred
+ */
+int crypto_lskcipher_decrypt(struct crypto_lskcipher *tfm, const u8 *src,
+			     u8 *dst, unsigned len, u8 *iv);
+
 /**
  * DOC: Symmetric Key Cipher Request Handle
  *
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index a0780deb017a..f3c3a3b27fac 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -24,6 +24,7 @@
 #define CRYPTO_ALG_TYPE_CIPHER		0x00000001
 #define CRYPTO_ALG_TYPE_COMPRESS	0x00000002
 #define CRYPTO_ALG_TYPE_AEAD		0x00000003
+#define CRYPTO_ALG_TYPE_LSKCIPHER	0x00000004
 #define CRYPTO_ALG_TYPE_SKCIPHER	0x00000005
 #define CRYPTO_ALG_TYPE_AKCIPHER	0x00000006
 #define CRYPTO_ALG_TYPE_SIG		0x00000007
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

