Return-Path: <SRS0=9w58=AX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF1EC433E7
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 22:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CD3920672
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 22:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgGLWGC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jul 2020 18:06:02 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48418 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729249AbgGLWGA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jul 2020 18:06:00 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CFA831A0D09;
        Mon, 13 Jul 2020 00:05:58 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C25901A0CFD;
        Mon, 13 Jul 2020 00:05:58 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4F9A7204BE;
        Mon, 13 Jul 2020 00:05:58 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH 2/2] crypto: caam - support tagged keys for skcipher algorithms
Date:   Mon, 13 Jul 2020 01:05:36 +0300
Message-Id: <1594591536-531-3-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com>
References: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Tagged keys are keys that contain metadata indicating what
they are and how to handle them using tag_object API.

Add support, for tagged keys, to skcipher algorithms by
adding new transformations, with _tk_ prefix to distinguish
between plaintext and tagged keys.

For job descriptors a new option (key_cmd_opt) was added for KEY command.
Tagged keys can be loaded using only a KEY command with ENC=1
and the proper setting of the EKT bit. The EKT bit in the
KEY command indicates which encryption algorithm (AES-ECB or
AES-CCM) should be used to decrypt the key. These options will be kept in
key_cmd_opt.

The tk_ transformations can be used directly by their name:
struct sockaddr_alg sa = {
    .salg_family = AF_ALG,
    .salg_type = "skcipher", /* this selects the symmetric cipher */
    .salg_name = "tk(cbc(aes))" /* this is the cipher name */
};
or for dm-crypt, e.g. using dmsetup:
dmsetup -v create encrypted --table "0 $(blockdev --getsz /dev/mmcblk2p10)
crypt capi:tk(cbc(aes))-plain :32:logon:seckey 0 /dev/mmcblk2p10 0 1
sector_size:512".

Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg.c      | 107 +++++++++++++++++++++++++++++++++++--
 drivers/crypto/caam/caamalg_desc.c |  28 ++++++++--
 drivers/crypto/caam/desc_constr.h  |   4 ++
 3 files changed, 131 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b2f9882..9e4206f 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3,7 +3,7 @@
  * caam - Freescale FSL CAAM support for crypto API
  *
  * Copyright 2008-2011 Freescale Semiconductor, Inc.
- * Copyright 2016-2019 NXP
+ * Copyright 2016-2020 NXP
  *
  * Based on talitos crypto API driver.
  *
@@ -58,6 +58,10 @@
 #include "caamalg_desc.h"
 #include <crypto/engine.h>
 
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_TK_API
+#include "tag_object.h"
+#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_TK_API */
+
 /*
  * crypto alg
  */
@@ -84,6 +88,7 @@ struct caam_alg_entry {
 	bool rfc3686;
 	bool geniv;
 	bool nodkp;
+	bool support_tagged_key;
 };
 
 struct caam_aead_alg {
@@ -736,9 +741,16 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
-	ctx->cdata.keylen = keylen;
-	ctx->cdata.key_virt = key;
-	ctx->cdata.key_inline = true;
+	/*
+	 * If the algorithm has support for tagged key,
+	 * this is already set in tk_skcipher_setkey().
+	 * Otherwise, set here the algorithm details.
+	 */
+	if (!alg->caam.support_tagged_key) {
+		ctx->cdata.keylen = keylen;
+		ctx->cdata.key_virt = key;
+		ctx->cdata.key_inline = true;
+	}
 
 	/* skcipher_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
@@ -816,6 +828,56 @@ static int arc4_skcipher_setkey(struct crypto_skcipher *skcipher,
 	return skcipher_setkey(skcipher, key, keylen, 0);
 }
 
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_TK_API
+static int tk_skcipher_setkey(struct crypto_skcipher *skcipher,
+			      const u8 *key, unsigned int keylen)
+{
+	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
+	struct device *jrdev = ctx->jrdev;
+	struct header_conf *header;
+	int ret;
+
+	ctx->cdata.keylen = keylen;
+	ctx->cdata.key_virt = key;
+	ctx->cdata.key_inline = true;
+
+	/* Retrieve the address of the tag object configuration */
+	ret = get_tag_object_header_conf(ctx->cdata.key_virt,
+					 ctx->cdata.keylen, &header);
+	if (ret) {
+		dev_err(jrdev,
+			"unable to get tag object header configuration\n");
+		return ret;
+	}
+
+	/* Check if the tag object header is a black key */
+	if (!is_black_key(header)) {
+		dev_err(jrdev,
+			"tagged key provided is not a black key\n");
+		return -EINVAL;
+	}
+
+	/* Retrieve the black key configuration */
+	get_key_conf(header,
+		     &ctx->cdata.key_real_len,
+		     &ctx->cdata.key_cmd_opt);
+
+	/*
+	 * Retrieve the address of the data
+	 * and size of the tagged object
+	 */
+	ret = get_tagged_data(ctx->cdata.key_virt, ctx->cdata.keylen,
+			      &ctx->cdata.key_virt, &ctx->cdata.keylen);
+	if (ret) {
+		dev_err(jrdev,
+			"unable to get data from tagged object\n");
+		return ret;
+	}
+
+	return skcipher_setkey(skcipher, key, keylen, 0);
+}
+#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_TK_API */
+
 static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
@@ -1833,6 +1895,25 @@ static struct caam_skcipher_alg driver_algs[] = {
 		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 	},
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_TK_API
+	{
+		.skcipher = {
+			.base = {
+				.cra_name = "tk(cbc(aes))",
+				.cra_driver_name = "tk-cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
+			.setkey = tk_skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
+			.min_keysize = TAG_MIN_SIZE,
+			.max_keysize = CAAM_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+		},
+		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+		.caam.support_tagged_key = true,
+	},
+#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_TK_API */
 	{
 		.skcipher = {
 			.base = {
@@ -1952,6 +2033,24 @@ static struct caam_skcipher_alg driver_algs[] = {
 		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_ECB,
 	},
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_TK_API
+	{
+		.skcipher = {
+			.base = {
+				.cra_name = "tk(ecb(aes))",
+				.cra_driver_name = "tk-ecb-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
+			.setkey = tk_skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
+			.min_keysize = TAG_MIN_SIZE,
+			.max_keysize = CAAM_MAX_KEY_SIZE,
+		},
+		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_ECB,
+		.caam.support_tagged_key = true,
+	},
+#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_TK_API */
 	{
 		.skcipher = {
 			.base = {
diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index d6c5818..447f7a5 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -1389,8 +1389,18 @@ void cnstr_shdsc_skcipher_encap(u32 * const desc, struct alginfo *cdata,
 				   JUMP_COND_SHRD);
 
 	/* Load class1 key only */
-	append_key_as_imm(desc, cdata->key_virt, cdata->keylen,
-			  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_FSL_CAAM_TK_API) &&
+	    cdata->key_cmd_opt)
+		/*
+		 * Black keys can be loaded using only a KEY command
+		 * with ENC=1 and the proper setting of the EKT bit.
+		 */
+		append_key_as_imm(desc, cdata->key_virt, cdata->keylen,
+				  cdata->key_real_len, CLASS_1 |
+				  KEY_DEST_CLASS_REG | cdata->key_cmd_opt);
+	else
+		append_key_as_imm(desc, cdata->key_virt, cdata->keylen,
+				  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
 
 	/* Load nonce into CONTEXT1 reg */
 	if (is_rfc3686) {
@@ -1464,8 +1474,18 @@ void cnstr_shdsc_skcipher_decap(u32 * const desc, struct alginfo *cdata,
 				   JUMP_COND_SHRD);
 
 	/* Load class1 key only */
-	append_key_as_imm(desc, cdata->key_virt, cdata->keylen,
-			  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_FSL_CAAM_TK_API) &&
+	    cdata->key_cmd_opt)
+		/*
+		 * Black keys can be loaded using only a KEY command
+		 * with ENC=1 and the proper setting of the EKT bit.
+		 */
+		append_key_as_imm(desc, cdata->key_virt, cdata->keylen,
+				  cdata->key_real_len, CLASS_1 |
+				  KEY_DEST_CLASS_REG | cdata->key_cmd_opt);
+	else
+		append_key_as_imm(desc, cdata->key_virt, cdata->keylen,
+				  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
 
 	/* Load nonce into CONTEXT1 reg */
 	if (is_rfc3686) {
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 62ce642..93b2ab0 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -500,6 +500,8 @@ do { \
  * @key_virt: virtual address where algorithm key resides
  * @key_inline: true - key can be inlined in the descriptor; false - key is
  *              referenced by the descriptor
+ * @key_real_len: size of the key to be loaded by the CAAM
+ * @key_cmd_opt: optional parameters for KEY command
  */
 struct alginfo {
 	u32 algtype;
@@ -508,6 +510,8 @@ struct alginfo {
 	dma_addr_t key_dma;
 	const void *key_virt;
 	bool key_inline;
+	u32 key_real_len;
+	u32 key_cmd_opt;
 };
 
 /**
-- 
2.1.0

