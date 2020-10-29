Return-Path: <SRS0=z7PZ=EE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA30C55179
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Oct 2020 10:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D293620825
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Oct 2020 10:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgJ2KFx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:05:53 -0400
Received: from foss.arm.com ([217.140.110.172]:58638 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgJ2KFx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Oct 2020 06:05:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0F0113D5;
        Thu, 29 Oct 2020 03:05:51 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8039F3F66E;
        Thu, 29 Oct 2020 03:05:49 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] crypto: add eboiv as a crypto API template
Date:   Thu, 29 Oct 2020 12:05:42 +0200
Message-Id: <20201029100546.28686-2-gilad@benyossef.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029100546.28686-1-gilad@benyossef.com>
References: <20201029100546.28686-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Encrypted byte-offset initialization vector (EBOIV) is an IV
generation method that is used in some cases by dm-crypt for
supporting the BitLocker volume encryption used by Windows 8
and onwards as a backwards compatible version in lieu of XTS
support. Support for eboiv was added to dm-crypt in 5.6.

This patch re-implements eboiv as a generic crypto API
template, thus allowing use of a alternative architecture
specific optimzied implementations (as well as saving a
memory allocation along the way).

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig  |  23 +++++
 crypto/Makefile |   1 +
 crypto/eboiv.c  | 269 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 293 insertions(+)
 create mode 100644 crypto/eboiv.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 094ef56ab7b4..57676a2de01e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -538,6 +538,29 @@ config CRYPTO_ESSIV
 	  combined with ESSIV the only feasible mode for h/w accelerated
 	  block encryption)
 
+config CRYPTO_EBOIV
+	tristate "EBOIV support for block encryption"
+	default DM_CRYPT
+	select CRYPTO_CBC
+	help
+	  Encrypted byte-offset initialization vector (EBOIV) is an IV
+	  generation method that is used in some cases by dm-crypt for
+	  supporting the BitLocker volume encryption used by Windows 8
+	  and onwards as a backwards compatible version in lieu of XTS
+	  support.
+
+	  It uses the block encryption key as the symmetric key for a
+	  block encryption pass applied to the sector offset of the block.
+	  Additional details can be found at
+	  https://www.jedec.org/sites/default/files/docs/JESD223C.pdf
+
+	  Note that the use of EBOIV is not recommended for new deployments,
+	  and so this only needs to be enabled when interoperability with
+	  existing encrypted volumes of filesystems is required, or when
+	  building for a particular system that requires it (e.g., when
+	  interop with BitLocker encrypted volumes of Windows systems
+	  prior to Windows 10 is required)
+
 comment "Hash modes"
 
 config CRYPTO_CMAC
diff --git a/crypto/Makefile b/crypto/Makefile
index b279483fba50..9f00b2f1ad9c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -174,6 +174,7 @@ obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 obj-$(CONFIG_CRYPTO_OFB) += ofb.o
 obj-$(CONFIG_CRYPTO_ECC) += ecc.o
 obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
+obj-$(CONFIG_CRYPTO_EBOIV) += eboiv.o
 obj-$(CONFIG_CRYPTO_CURVE25519) += curve25519-generic.o
 
 ecdh_generic-y += ecdh.o
diff --git a/crypto/eboiv.c b/crypto/eboiv.c
new file mode 100644
index 000000000000..4c364aad2ff2
--- /dev/null
+++ b/crypto/eboiv.c
@@ -0,0 +1,269 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * EBOIV skcipher template for block encryption
+ *
+ * This template encapsulates the  Encrypted byte-offset IV generation algorithm
+ * used in Bitlocker in CBC mode by dm-crypt, which converts the initial vector
+ * for the skcipher used for block encryption, by encrypting it using the same
+ * skcipher key as encryption key. Usually, the input IV is a 64-bit sector
+ * offset (the byte offset of the start of the sector) in LE representation
+ * zero-padded to the size of the IV, but this * is not assumed by this driver.
+ *
+ * The typical use of this template is to instantiate the skcipher
+ * 'eboiv(cbc(aes))', which is the only instantiation used by
+ * dm-crypt for supporting BitLocker AES-CBC mode as specified in
+ * https://www.jedec.org/sites/default/files/docs/JESD223C.pdf
+ *
+ * Copyright (C) 2020 ARM Limited or its affiliates.
+ * Written by Gilad Ben-Yossef <gilad@benyossef.com>
+ *
+ * Heavily based on:
+ *
+ * ESSIV skcipher and aead template for block encryption
+ * Copyright (c) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
+ *
+ * and
+ *
+ * dm-crypt eboiv code
+ * by Milan Broz <gmazyland@gmail.com> and Ard Biesheuvel <ardb@kernel.org>
+ *
+ */
+
+#include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
+#include <linux/module.h>
+
+struct eboiv_instance_ctx {
+	struct crypto_skcipher_spawn skcipher_spawn;
+};
+
+struct eboiv_tfm_ctx {
+	struct crypto_skcipher *skcipher;
+};
+
+struct eboiv_req_ctx {
+	struct skcipher_request *req;
+	bool enc;
+	struct scatterlist src;
+	struct scatterlist dst;
+	u8 iv[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
+	struct skcipher_request subreq;
+};
+
+static int eboiv_skcipher_setkey(struct crypto_skcipher *tfm,
+				 const u8 *key, unsigned int keylen)
+{
+	struct eboiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
+
+	crypto_skcipher_clear_flags(tctx->skcipher, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(tctx->skcipher,
+				  crypto_skcipher_get_flags(tfm) &
+				  CRYPTO_TFM_REQ_MASK);
+	return crypto_skcipher_setkey(tctx->skcipher, key, keylen);
+}
+
+static void eboiv_skcipher_done(struct crypto_async_request *areq, int err)
+{
+	struct skcipher_request *req = areq->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	skcipher_request_complete(req, err);
+}
+
+static int eboiv_skcipher_do_crypt(struct skcipher_request *req, bool enc)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct eboiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
+	struct eboiv_req_ctx *req_ctx = skcipher_request_ctx(req);
+	struct skcipher_request *subreq = &req_ctx->subreq;
+
+	skcipher_request_set_tfm(subreq, tctx->skcipher);
+	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen, req_ctx->iv);
+	skcipher_request_set_callback(subreq, skcipher_request_flags(req), eboiv_skcipher_done,
+				      req);
+
+	return enc ? crypto_skcipher_encrypt(subreq) :
+		     crypto_skcipher_decrypt(subreq);
+}
+
+static void eboiv_skcipher_iv_done(struct crypto_async_request *areq, int err)
+{
+	struct eboiv_req_ctx *req_ctx = areq->data;
+	struct skcipher_request *req = req_ctx->req;
+
+	if (!err) {
+
+		err = eboiv_skcipher_do_crypt(req, req_ctx->enc);
+
+		if ((err == -EINPROGRESS) || (err == -EBUSY))
+			return;
+	}
+
+	skcipher_request_complete(req, err);
+}
+
+static int eboiv_skcipher_crypt(struct skcipher_request *req, bool enc)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct eboiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
+	struct eboiv_req_ctx *req_ctx = skcipher_request_ctx(req);
+	struct skcipher_request *subreq = &req_ctx->subreq;
+	size_t iv_size = crypto_skcipher_ivsize(tfm);
+	int ret;
+
+	/* The supplied IV is assumed to be in sector offset format (though
+	 * we don't enforce it) - encrypt it.
+	 */
+	sg_init_one(&req_ctx->src, page_address(ZERO_PAGE(0)), iv_size);
+	sg_init_one(&req_ctx->dst, req_ctx->iv, iv_size);
+	skcipher_request_set_tfm(subreq, tctx->skcipher);
+	skcipher_request_set_crypt(subreq, &req_ctx->src, &req_ctx->dst, iv_size, req->iv);
+
+	req_ctx->req = req;
+	req_ctx->enc = enc;
+
+	skcipher_request_set_callback(subreq, skcipher_request_flags(req), eboiv_skcipher_iv_done,
+				      req_ctx);
+
+	ret = crypto_skcipher_encrypt(subreq);
+
+	if (ret)
+		return ret;
+
+	return eboiv_skcipher_do_crypt(req, enc);
+
+}
+
+static int eboiv_skcipher_encrypt(struct skcipher_request *req)
+{
+	return eboiv_skcipher_crypt(req, true);
+}
+
+static int eboiv_skcipher_decrypt(struct skcipher_request *req)
+{
+	return eboiv_skcipher_crypt(req, false);
+}
+
+static int eboiv_skcipher_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct eboiv_instance_ctx *ictx = skcipher_instance_ctx(inst);
+	struct eboiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *skcipher;
+
+	skcipher = crypto_spawn_skcipher(&ictx->skcipher_spawn);
+	if (IS_ERR(skcipher))
+		return PTR_ERR(skcipher);
+
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct eboiv_req_ctx) +
+				    crypto_skcipher_reqsize(skcipher));
+
+	tctx->skcipher = skcipher;
+	return 0;
+}
+
+static void eboiv_skcipher_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct eboiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_skcipher(tctx->skcipher);
+}
+
+static void eboiv_skcipher_free_instance(struct skcipher_instance *inst)
+{
+	struct eboiv_instance_ctx *ictx = skcipher_instance_ctx(inst);
+
+	crypto_drop_skcipher(&ictx->skcipher_spawn);
+	kfree(inst);
+}
+
+static int eboiv_create(struct crypto_template *tmpl, struct rtattr **tb)
+{
+	struct skcipher_instance *inst;
+	struct eboiv_instance_ctx *ictx;
+	struct skcipher_alg *alg;
+	u32 mask;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
+	if (err)
+		return err;
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	ictx = skcipher_instance_ctx(inst);
+
+	err = crypto_grab_skcipher(&ictx->skcipher_spawn, skcipher_crypto_instance(inst),
+				   crypto_attr_alg_name(tb[1]), 0, mask);
+	if (err)
+		goto err_free_inst;
+	alg = crypto_spawn_skcipher_alg(&ictx->skcipher_spawn);
+
+	err = -EINVAL;
+	if (strncmp(alg->base.cra_name, "cbc(", 4) ||
+	    crypto_skcipher_alg_ivsize(alg) != alg->base.cra_blocksize)
+		goto err_free_inst;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME, "eboiv(%s)",
+		     alg->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
+
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "eboiv(%s)", alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
+
+	inst->alg.base.cra_blocksize	= alg->base.cra_blocksize;
+	inst->alg.base.cra_ctxsize	= sizeof(struct eboiv_tfm_ctx);
+	inst->alg.base.cra_alignmask	= alg->base.cra_alignmask;
+	inst->alg.base.cra_priority	= alg->base.cra_priority;
+
+	inst->alg.setkey	= eboiv_skcipher_setkey;
+	inst->alg.encrypt	= eboiv_skcipher_encrypt;
+	inst->alg.decrypt	= eboiv_skcipher_decrypt;
+	inst->alg.init		= eboiv_skcipher_init_tfm;
+	inst->alg.exit		= eboiv_skcipher_exit_tfm;
+
+	inst->alg.min_keysize	= crypto_skcipher_alg_min_keysize(alg);
+	inst->alg.max_keysize	= crypto_skcipher_alg_max_keysize(alg);
+	inst->alg.ivsize	= crypto_skcipher_alg_ivsize(alg);
+
+	inst->free		= eboiv_skcipher_free_instance;
+
+	err = skcipher_register_instance(tmpl, inst);
+
+	if (err) {
+err_free_inst:
+		eboiv_skcipher_free_instance(inst);
+	}
+
+	return err;
+}
+
+/* eboiv(cipher_name) */
+static struct crypto_template eboiv_tmpl = {
+	.name	= "eboiv",
+	.create	= eboiv_create,
+	.module	= THIS_MODULE,
+};
+
+static int __init eboiv_module_init(void)
+{
+	return crypto_register_template(&eboiv_tmpl);
+}
+
+static void __exit eboiv_module_exit(void)
+{
+	crypto_unregister_template(&eboiv_tmpl);
+}
+
+subsys_initcall(eboiv_module_init);
+module_exit(eboiv_module_exit);
+
+MODULE_DESCRIPTION("EBOIV (BitLocker) skcipher wrapper for block encryption");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("eboiv");
-- 
2.28.0

