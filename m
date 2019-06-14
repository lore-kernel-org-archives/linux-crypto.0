Return-Path: <SRS0=me0G=UN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBBE4C31E4B
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 08:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0CD520851
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 08:34:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bjQHrky/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFNIeS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jun 2019 04:34:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34150 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfFNIeS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jun 2019 04:34:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id k11so1591531wrl.1
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jun 2019 01:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2JnPzFNbdRwXDsysadhK09T0Ip1d7jTBj++NzJyAjtI=;
        b=bjQHrky/kpPTO4CIpuqkcodMkaIxzuuiRQ3KeSAZydNXshbsxs8lo3GslLVB1iA5J2
         d0QA3yG1LBTb4jWx84Ne8Y05InG/O77c7M6I8JjIcVNHFcl8d7lbTggGpXEIRWrOZ3ke
         i7ilJeJNFQLl9vcTNJn8x/ERRJJzPmOfaH966bB3x6MyVyd/frOkYxrErOYzHxxALy7h
         sirh1Ejq2kOemBUD7MoOhuvgTzBVwaCXxAdlRsvFt1eobF0tfy8ZSuUY6DyDdPhl1cm0
         gV6wzxYMIIDaPHXnCDivLUvc6neUrCxdqAHJHAVudUmLFOkoB3WxO/jb8OaJYs3XmNwZ
         W5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2JnPzFNbdRwXDsysadhK09T0Ip1d7jTBj++NzJyAjtI=;
        b=OmhLrwV8DKNg32A09ad2zl+4V3JvMeHjqtm6hgPnsz+2UYSs4bo9dz6bCaEbVaXwFA
         jZzKNPHcHNangFI/pIjcOa3S3dEtMCpHsh9Zcb7Qw3k2r7qyMHTsaq+X93ibhjDr0JpG
         CEnYpKaS7pVUazFd5fujEv9SUzOM5qHFGcJuRQ+ji0yAE/Nenblju8a3sherSsbAsZV2
         Bw6zsAfZUBYBL15Q+6wbOdUsoWFlcgzyW2thSBqXwlbSvwCIcDwDKZ5WnZICX9timhcu
         Fscy4D/peX1vt8uoMZmGn4/TeuG2K0qtj0EQFV61+2AIm0ZFqnA4W9JhiSiL5gXcay4Q
         weYg==
X-Gm-Message-State: APjAAAVRDbqJb0zsvzadsizq0HP5ASTBOfIvnBllDnARGRYzpthJlZgX
        FfwDT9icgLNuMEDRip9E9kDg2vZ6X1MCVQ==
X-Google-Smtp-Source: APXvYqyTxcj/eMvzafhvuxQpeFKgJq/tQx3nsN1Ry85sW/xCCus5C+wro5OSpjN3aZJk0diL354CiA==
X-Received: by 2002:a5d:55cb:: with SMTP id i11mr1885723wrw.62.1560501254614;
        Fri, 14 Jun 2019 01:34:14 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:8d0e:a5b1:c005:e3b5])
        by smtp.gmail.com with ESMTPSA id f3sm1710802wre.93.2019.06.14.01.34.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 01:34:13 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>
Subject: [RFC PATCH 1/3] crypto: essiv - create a new shash template for IV generation
Date:   Fri, 14 Jun 2019 10:34:02 +0200
Message-Id: <20190614083404.20514-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Two different users of ESSIV (encrypted salt|sector IV) implement the
algorithm using bare shash and cipher transform. This is not a huge
deal, since the algorithm is fairly simple, but it does require us to
keep the cipher interface public. Since the cipher interface is often
used incorrectly, and typically is not the correct primitive to use
outside of the crypto API, the intention is to turn it into an internal
primitive, only to be used by other crypto code.

In anticipation of that, this driver moves the essiv handling into the
crypto subsystem, where it can keep using the cipher interface. This
will also permit accelerated implementations to be provided, that
implement all the transformations directly rather than wiring together
other transforms.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig  |   3 +
 crypto/Makefile |   1 +
 crypto/essiv.c  | 275 ++++++++++++++++++++
 3 files changed, 279 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index efeb307c0594..2e040514fa44 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1882,6 +1882,9 @@ config CRYPTO_STATS
 config CRYPTO_HASH_INFO
 	bool
 
+config CRYPTO_ESSIV
+	tristate
+
 source "drivers/crypto/Kconfig"
 source "crypto/asymmetric_keys/Kconfig"
 source "certs/Kconfig"
diff --git a/crypto/Makefile b/crypto/Makefile
index 266a4cdbb9e2..ad1d99ba6d56 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -148,6 +148,7 @@ obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
 obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 obj-$(CONFIG_CRYPTO_OFB) += ofb.o
 obj-$(CONFIG_CRYPTO_ECC) += ecc.o
+obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
 
 ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
diff --git a/crypto/essiv.c b/crypto/essiv.c
new file mode 100644
index 000000000000..b985de394aa6
--- /dev/null
+++ b/crypto/essiv.c
@@ -0,0 +1,275 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Cryptographic API.
+ *
+ * ESSIV: encrypted sector/salt initial vector (for block encryption)
+ *
+ * Copyright (c) 2019 Ard Biesheuvel <ard.biesheuvel@linaro.org>
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include <crypto/internal/hash.h>
+
+struct essiv_instance_ctx {
+	struct crypto_shash_spawn	hash;
+	struct crypto_spawn		enc;
+};
+
+struct essiv_tfm_ctx {
+	struct crypto_shash		*hash;
+	struct crypto_cipher		*enc;
+};
+
+struct essiv_desc_ctx {
+	unsigned int			len;
+	unsigned int			max;
+	u8				buf[];
+};
+
+static int essiv_setkey(struct crypto_shash *tfm, const u8 *inkey,
+			unsigned int keylen)
+{
+	struct essiv_tfm_ctx *ctx = crypto_shash_ctx(tfm);
+	SHASH_DESC_ON_STACK(desc, ctx->hash);
+	u8 *digest = NULL;
+	int ret;
+
+	if (keylen) {
+		digest = kmalloc(crypto_shash_digestsize(ctx->hash),
+				 GFP_KERNEL);
+		if (!digest)
+			return -ENOMEM;
+
+		desc->tfm = ctx->hash;
+		crypto_shash_digest(desc, inkey, keylen, digest);
+	}
+	ret = crypto_cipher_setkey(ctx->enc,
+				   digest ?: page_address(ZERO_PAGE(0)),
+				   crypto_shash_digestsize(ctx->hash));
+
+	kzfree(digest);
+	return ret;
+}
+
+static int essiv_init(struct shash_desc *desc)
+{
+	struct essiv_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	ctx->len = 0;
+	ctx->max = crypto_shash_digestsize(desc->tfm);
+	memset(ctx->buf, 0, ctx->max);
+
+	return 0;
+}
+
+static int essiv_update(struct shash_desc *desc, const u8 *p, unsigned int len)
+{
+	struct essiv_desc_ctx *ctx = shash_desc_ctx(desc);
+	int nbytes = min(len, ctx->max - ctx->len);
+
+	/* only permit input up to the block size of the cipher */
+	if (nbytes < len)
+		return -EINVAL;
+
+	memcpy(ctx->buf + ctx->len, p, nbytes);
+	ctx->len += nbytes;
+
+	return 0;
+}
+
+static int essiv_final(struct shash_desc *desc, u8 *out)
+{
+	struct essiv_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct essiv_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	crypto_cipher_encrypt_one(tctx->enc, out, ctx->buf);
+
+	return 0;
+}
+
+static int essiv_digest(struct shash_desc *desc, const u8 *p, unsigned int len,
+			u8 *out)
+{
+	struct essiv_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct essiv_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	if (len > ctx->max)
+		return -EINVAL;
+
+	memcpy(ctx->buf, p, len);
+	crypto_cipher_encrypt_one(tctx->enc, out, ctx->buf);
+
+	return 0;
+}
+
+static int essiv_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct essiv_instance_ctx *ictx = crypto_instance_ctx(inst);
+	struct essiv_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
+
+	tctx->hash = crypto_spawn_shash(&ictx->hash);
+	if (IS_ERR(tctx->hash))
+		return PTR_ERR(tctx->hash);
+
+	tctx->enc = crypto_spawn_cipher(&ictx->enc);
+	if (IS_ERR(tctx->enc)) {
+		crypto_free_shash(tctx->hash);
+		return PTR_ERR(tctx->hash);
+	}
+	return 0;
+};
+
+static void essiv_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct essiv_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_cipher(tctx->enc);
+	crypto_free_shash(tctx->hash);
+}
+
+static void crypto_essiv_free(struct crypto_instance *inst)
+{
+	struct essiv_instance_ctx *ictx = crypto_instance_ctx(inst);
+
+	crypto_drop_shash(&ictx->hash);
+	crypto_drop_spawn(&ictx->enc);
+	kfree(inst);
+}
+
+static int crypto_essiv_create(struct crypto_template *tmpl,
+			       struct rtattr **tb)
+{
+	struct shash_instance *inst;
+	struct essiv_instance_ctx *ictx;
+	struct crypto_alg *hash_alg, *enc_alg;
+	struct cipher_alg *calg;
+	struct shash_alg *salg;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
+	if (err)
+		return err;
+
+	salg = shash_attr_alg(tb[1], 0, 0);
+	if (IS_ERR(salg))
+		return PTR_ERR(salg);
+	hash_alg = &salg->base;
+
+	/* The underlying hash algorithm must be unkeyed */
+	err = -EINVAL;
+	if (crypto_shash_alg_has_setkey(salg)) {
+		pr_err("essiv: keyed hash algorithm '%s' not supported\n",
+		       hash_alg->cra_driver_name);
+		goto out_put_hash_alg;
+	}
+
+	enc_alg = crypto_attr_alg(tb[2], CRYPTO_ALG_TYPE_CIPHER,
+				     CRYPTO_ALG_TYPE_MASK);
+	if (IS_ERR(enc_alg)) {
+		err = PTR_ERR(enc_alg);
+		goto out_put_hash_alg;
+	}
+	calg = &enc_alg->cra_cipher;
+
+	if (salg->digestsize < calg->cia_min_keysize ||
+	    salg->digestsize > calg->cia_max_keysize) {
+		pr_err("essiv: digest size of '%s' unsupported as key size for '%s'\n",
+		       hash_alg->cra_driver_name, enc_alg->cra_driver_name);
+		goto out_put_algs;
+	}
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
+	if (!inst) {
+		err = -ENOMEM;
+		goto out_put_algs;
+	}
+	ictx = shash_instance_ctx(inst);
+
+	err = crypto_init_shash_spawn(&ictx->hash, salg,
+				      shash_crypto_instance(inst));
+	if (err)
+		goto out_free_inst;
+
+	err = crypto_init_spawn(&ictx->enc, enc_alg,
+				shash_crypto_instance(inst),
+				CRYPTO_ALG_TYPE_MASK);
+	if (err)
+		goto out_drop_hash;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "essiv(%s,%s)", enc_alg->cra_name,
+		     hash_alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
+		goto out_drop_spawns;
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "essiv(%s,%s)", enc_alg->cra_driver_name,
+		     hash_alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		goto out_drop_spawns;
+
+	inst->alg.base.cra_priority	= (hash_alg->cra_priority +
+				           enc_alg->cra_priority) / 2;
+	inst->alg.base.cra_blocksize	= enc_alg->cra_blocksize;
+	inst->alg.base.cra_ctxsize	= sizeof(struct essiv_tfm_ctx);
+
+	inst->alg.digestsize		= enc_alg->cra_blocksize;
+	inst->alg.descsize		= sizeof(struct essiv_desc_ctx) +
+					  enc_alg->cra_blocksize;
+	inst->alg.setkey		= essiv_setkey;
+	inst->alg.init			= essiv_init;
+	inst->alg.update		= essiv_update;
+	inst->alg.final			= essiv_final;
+	inst->alg.digest		= essiv_digest;
+
+	inst->alg.base.cra_init		= essiv_init_tfm;
+	inst->alg.base.cra_exit		= essiv_exit_tfm;
+
+	err = shash_register_instance(tmpl, inst);
+	if (err)
+		goto out_drop_spawns;
+
+	crypto_mod_put(enc_alg);
+	crypto_mod_put(hash_alg);
+	return 0;
+
+out_drop_spawns:
+	crypto_drop_spawn(&ictx->enc);
+out_drop_hash:
+	crypto_drop_shash(&ictx->hash);
+out_free_inst:
+	kfree(inst);
+out_put_algs:
+	crypto_mod_put(enc_alg);
+out_put_hash_alg:
+	crypto_mod_put(hash_alg);
+	return err;
+}
+
+static struct crypto_template crypto_essiv_tmpl = {
+	.name		= "essiv",
+	.create		= crypto_essiv_create,
+	.free		= crypto_essiv_free,
+	.module		= THIS_MODULE,
+};
+
+static int __init crypto_essiv_module_init(void)
+{
+	return crypto_register_template(&crypto_essiv_tmpl);
+}
+
+static void __exit crypto_essiv_module_exit(void)
+{
+	crypto_unregister_template(&crypto_essiv_tmpl);
+}
+
+subsys_initcall(crypto_essiv_module_init);
+module_exit(crypto_essiv_module_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("shash template to generate ESSIV tags");
+MODULE_ALIAS_CRYPTO("essiv");
-- 
2.20.1

