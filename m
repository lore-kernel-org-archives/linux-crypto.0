Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E05C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1BA92072E
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594362110;
	bh=wxEb59jp12RHv1nowhC6Rp+VV8UlTt0bI/dpPQO8vSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qFuFBn3sp9N/KQ8atrAlutarNJ8IC1TVZEaIVqwsyrA6AQ3CnX9U0rDeMvOzLh/0Q
	 drLujo56Cv1keNG8v7uyYY4qP/UZITm8TBh+zbPNQwALjEf3ofSuuZu4Lu67UjXujO
	 20iNAKKtc9yXlch2uh7DGCpIxJqtcCYBLt+hgwRc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgGJGVt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 02:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgGJGVr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 02:21:47 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1E682078C;
        Fri, 10 Jul 2020 06:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594362105;
        bh=wxEb59jp12RHv1nowhC6Rp+VV8UlTt0bI/dpPQO8vSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MucZkCEjLIw0gQXu5l5fShQBVDp6QDLACDKPf6L4EiNnitwk3Nwc7eZ5fjd9SZJs2
         xjSzV3E4KOvO3Zcmll4Q+aK0UqLdh/0UGV2/1agll3jW/Ibn5K7GT3c+BStkPY3W0s
         xOSKrYSMbAUPrQ86AmNHXJ3A0gOcUcJeFfBh27Vs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com
Subject: [PATCH v2 3/7] crypto: algapi - use common mechanism for inheriting flags
Date:   Thu,  9 Jul 2020 23:20:38 -0700
Message-Id: <20200710062042.113842-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200710062042.113842-1-ebiggers@kernel.org>
References: <20200710062042.113842-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The flag CRYPTO_ALG_ASYNC is "inherited" in the sense that when a
template is instantiated, the template will have CRYPTO_ALG_ASYNC set if
any of the algorithms it uses has CRYPTO_ALG_ASYNC set.

We'd like to add a second flag (CRYPTO_ALG_ALLOCATES_MEMORY) that gets
"inherited" in the same way.  This is difficult because the handling of
CRYPTO_ALG_ASYNC is hardcoded everywhere.  Address this by:

  - Add CRYPTO_ALG_INHERITED_FLAGS, which contains the set of flags that
    have these inheritance semantics.

  - Add crypto_algt_inherited_mask(), for use by template ->create()
    methods.  It returns any of these flags that the user asked to be
    unset and thus must be passed in the 'mask' to crypto_grab_*().

  - Also modify crypto_check_attr_type() to handle computing the 'mask'
    so that most templates can just use this.

  - Make crypto_grab_*() propagate these flags to the template instance
    being created so that templates don't have to do this themselves.

Make crypto/simd.c propagate these flags too, since it "wraps" another
algorithm, similar to a template.

Based on a patch by Mikulas Patocka <mpatocka@redhat.com>
(https://lore.kernel.org/r/alpine.LRH.2.02.2006301414580.30526@file01.intranet.prod.int.rdu2.redhat.com).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/adiantum.c         | 14 ++--------
 crypto/algapi.c           | 21 +++++++++++++-
 crypto/authenc.c          | 14 ++--------
 crypto/authencesn.c       | 14 ++--------
 crypto/ccm.c              | 33 +++++++---------------
 crypto/chacha20poly1305.c | 14 ++--------
 crypto/cmac.c             |  5 ++--
 crypto/cryptd.c           | 59 ++++++++++++++++++++-------------------
 crypto/ctr.c              | 19 ++++---------
 crypto/cts.c              | 13 ++-------
 crypto/essiv.c            | 11 ++++++--
 crypto/gcm.c              | 40 ++++++--------------------
 crypto/geniv.c            | 14 ++--------
 crypto/hmac.c             |  5 ++--
 crypto/lrw.c              | 13 ++-------
 crypto/pcrypt.c           | 14 ++++------
 crypto/rsa-pkcs1pad.c     | 13 ++-------
 crypto/simd.c             |  6 ++--
 crypto/skcipher.c         | 15 ++++------
 crypto/vmac.c             |  5 ++--
 crypto/xcbc.c             |  5 ++--
 crypto/xts.c              | 17 ++++-------
 include/crypto/algapi.h   | 23 ++++++++++-----
 23 files changed, 153 insertions(+), 234 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index cf2b9f4103dd..7fbdc3270984 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -490,7 +490,6 @@ static bool adiantum_supported_algorithms(struct skcipher_alg *streamcipher_alg,
 
 static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct crypto_attr_type *algt;
 	u32 mask;
 	const char *nhpoly1305_name;
 	struct skcipher_instance *inst;
@@ -500,14 +499,9 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct shash_alg *hash_alg;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
-		return -EINVAL;
-
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
+	if (err)
+		return err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
 	if (!inst)
@@ -565,8 +559,6 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 		     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = streamcipher_alg->base.cra_flags &
-				   CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_blocksize = BLOCKCIPHER_BLOCK_SIZE;
 	inst->alg.base.cra_ctxsize = sizeof(struct adiantum_tfm_ctx);
 	inst->alg.base.cra_alignmask = streamcipher_alg->base.cra_alignmask |
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 92abdf675992..fdabf2675b63 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -690,6 +690,8 @@ int crypto_grab_spawn(struct crypto_spawn *spawn, struct crypto_instance *inst,
 		spawn->mask = mask;
 		spawn->next = inst->spawns;
 		inst->spawns = spawn;
+		inst->alg.cra_flags |=
+			(alg->cra_flags & CRYPTO_ALG_INHERITED_FLAGS);
 		err = 0;
 	}
 	up_write(&crypto_alg_sem);
@@ -816,7 +818,23 @@ struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb)
 }
 EXPORT_SYMBOL_GPL(crypto_get_attr_type);
 
-int crypto_check_attr_type(struct rtattr **tb, u32 type)
+/**
+ * crypto_check_attr_type() - check algorithm type and compute inherited mask
+ * @tb: the template parameters
+ * @type: the algorithm type the template would be instantiated as
+ * @mask_ret: (output) the mask that should be passed to crypto_grab_*()
+ *	      to restrict the flags of any inner algorithms
+ *
+ * Validate that the algorithm type the user requested is compatible with the
+ * one the template would actually be instantiated as.  E.g., if the user is
+ * doing crypto_alloc_shash("cbc(aes)", ...), this would return an error because
+ * the "cbc" template creates an "skcipher" algorithm, not an "shash" algorithm.
+ *
+ * Also compute the mask to use to restrict the flags of any inner algorithms.
+ *
+ * Return: 0 on success; -errno on failure
+ */
+int crypto_check_attr_type(struct rtattr **tb, u32 type, u32 *mask_ret)
 {
 	struct crypto_attr_type *algt;
 
@@ -827,6 +845,7 @@ int crypto_check_attr_type(struct rtattr **tb, u32 type)
 	if ((algt->type ^ type) & algt->mask)
 		return -EINVAL;
 
+	*mask_ret = crypto_algt_inherited_mask(algt);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_check_attr_type);
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 775e7138fd10..670bf1a01d00 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -372,7 +372,6 @@ static void crypto_authenc_free(struct aead_instance *inst)
 static int crypto_authenc_create(struct crypto_template *tmpl,
 				 struct rtattr **tb)
 {
-	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
 	struct authenc_instance_ctx *ctx;
@@ -381,14 +380,9 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 	struct skcipher_alg *enc;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return -EINVAL;
-
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD, &mask);
+	if (err)
+		return err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -423,8 +417,6 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 		     enc->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = (auth_base->cra_flags |
-				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = enc->base.cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->base.cra_blocksize;
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 149b70df2a91..b60e61b1904c 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -390,7 +390,6 @@ static void crypto_authenc_esn_free(struct aead_instance *inst)
 static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 				     struct rtattr **tb)
 {
-	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
 	struct authenc_esn_instance_ctx *ctx;
@@ -399,14 +398,9 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 	struct skcipher_alg *enc;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return -EINVAL;
-
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD, &mask);
+	if (err)
+		return err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -437,8 +431,6 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 		     enc->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = (auth_base->cra_flags |
-				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = enc->base.cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->base.cra_blocksize;
diff --git a/crypto/ccm.c b/crypto/ccm.c
index d1fb01bbc814..494d70901186 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -447,7 +447,6 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 				    const char *ctr_name,
 				    const char *mac_name)
 {
-	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
 	struct ccm_instance_ctx *ictx;
@@ -455,14 +454,9 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 	struct hash_alg_common *mac;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return -EINVAL;
-
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD, &mask);
+	if (err)
+		return err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
 	if (!inst)
@@ -470,7 +464,7 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 	ictx = aead_instance_ctx(inst);
 
 	err = crypto_grab_ahash(&ictx->mac, aead_crypto_instance(inst),
-				mac_name, 0, CRYPTO_ALG_ASYNC);
+				mac_name, 0, mask | CRYPTO_ALG_ASYNC);
 	if (err)
 		goto err_free_inst;
 	mac = crypto_spawn_ahash_alg(&ictx->mac);
@@ -507,7 +501,6 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 		     mac->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = ctr->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (mac->base.cra_priority +
 				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
@@ -712,21 +705,15 @@ static void crypto_rfc4309_free(struct aead_instance *inst)
 static int crypto_rfc4309_create(struct crypto_template *tmpl,
 				 struct rtattr **tb)
 {
-	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
 	struct crypto_aead_spawn *spawn;
 	struct aead_alg *alg;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return -EINVAL;
-
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD, &mask);
+	if (err)
+		return err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -759,7 +746,6 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
@@ -878,9 +864,10 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct shash_instance *inst;
 	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
+	u32 mask;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH, &mask);
 	if (err)
 		return err;
 
@@ -890,7 +877,7 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = shash_instance_ctx(inst);
 
 	err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
-				 crypto_attr_alg_name(tb[1]), 0, 0);
+				 crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 	alg = crypto_spawn_cipher_alg(spawn);
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index ccaea5cb66d1..97bbb135e9a6 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -555,7 +555,6 @@ static void chachapoly_free(struct aead_instance *inst)
 static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 			     const char *name, unsigned int ivsize)
 {
-	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
 	struct chachapoly_instance_ctx *ctx;
@@ -566,14 +565,9 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	if (ivsize > CHACHAPOLY_IV_SIZE)
 		return -EINVAL;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return -EINVAL;
-
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD, &mask);
+	if (err)
+		return err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -613,8 +607,6 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 		     poly->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = (chacha->base.cra_flags |
-				    poly->base.cra_flags) & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (chacha->base.cra_priority +
 				       poly->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
diff --git a/crypto/cmac.c b/crypto/cmac.c
index 143a6544c873..df36be1efb81 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -225,9 +225,10 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
 	unsigned long alignmask;
+	u32 mask;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH, &mask);
 	if (err)
 		return err;
 
@@ -237,7 +238,7 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = shash_instance_ctx(inst);
 
 	err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
-				 crypto_attr_alg_name(tb[1]), 0, 0);
+				 crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 	alg = crypto_spawn_cipher_alg(spawn);
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 283212262adb..a1bea0f4baa8 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -191,17 +191,20 @@ static inline struct cryptd_queue *cryptd_get_queue(struct crypto_tfm *tfm)
 	return ictx->queue;
 }
 
-static inline void cryptd_check_internal(struct rtattr **tb, u32 *type,
-					 u32 *mask)
+static void cryptd_type_and_mask(struct crypto_attr_type *algt,
+				 u32 *type, u32 *mask)
 {
-	struct crypto_attr_type *algt;
+	/*
+	 * cryptd is allowed to wrap internal algorithms, but in that case the
+	 * resulting cryptd instance will be marked as internal as well.
+	 */
+	*type = algt->type & CRYPTO_ALG_INTERNAL;
+	*mask = algt->mask & CRYPTO_ALG_INTERNAL;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return;
+	/* No point in cryptd wrapping an algorithm that's already async. */
+	*mask |= CRYPTO_ALG_ASYNC;
 
-	*type |= algt->type & CRYPTO_ALG_INTERNAL;
-	*mask |= algt->mask & CRYPTO_ALG_INTERNAL;
+	*mask |= crypto_algt_inherited_mask(algt);
 }
 
 static int cryptd_init_instance(struct crypto_instance *inst,
@@ -364,6 +367,7 @@ static void cryptd_skcipher_free(struct skcipher_instance *inst)
 
 static int cryptd_create_skcipher(struct crypto_template *tmpl,
 				  struct rtattr **tb,
+				  struct crypto_attr_type *algt,
 				  struct cryptd_queue *queue)
 {
 	struct skcipherd_instance_ctx *ctx;
@@ -373,10 +377,7 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 	u32 mask;
 	int err;
 
-	type = 0;
-	mask = CRYPTO_ALG_ASYNC;
-
-	cryptd_check_internal(tb, &type, &mask);
+	cryptd_type_and_mask(algt, &type, &mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -395,9 +396,8 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 	if (err)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
-				   (alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
-
+	inst->alg.base.cra_flags |= CRYPTO_ALG_ASYNC |
+		(alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
 	inst->alg.ivsize = crypto_skcipher_alg_ivsize(alg);
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
@@ -633,16 +633,17 @@ static void cryptd_hash_free(struct ahash_instance *inst)
 }
 
 static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
+			      struct crypto_attr_type *algt,
 			      struct cryptd_queue *queue)
 {
 	struct hashd_instance_ctx *ctx;
 	struct ahash_instance *inst;
 	struct shash_alg *alg;
-	u32 type = 0;
-	u32 mask = 0;
+	u32 type;
+	u32 mask;
 	int err;
 
-	cryptd_check_internal(tb, &type, &mask);
+	cryptd_type_and_mask(algt, &type, &mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -661,10 +662,9 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	if (err)
 		goto err_free_inst;
 
-	inst->alg.halg.base.cra_flags = CRYPTO_ALG_ASYNC |
-		(alg->base.cra_flags & (CRYPTO_ALG_INTERNAL |
+	inst->alg.halg.base.cra_flags |= CRYPTO_ALG_ASYNC |
+		(alg->base.cra_flags & (CRYPTO_ALG_INTERNAL|
 					CRYPTO_ALG_OPTIONAL_KEY));
-
 	inst->alg.halg.digestsize = alg->digestsize;
 	inst->alg.halg.statesize = alg->statesize;
 	inst->alg.halg.base.cra_ctxsize = sizeof(struct cryptd_hash_ctx);
@@ -820,16 +820,17 @@ static void cryptd_aead_free(struct aead_instance *inst)
 
 static int cryptd_create_aead(struct crypto_template *tmpl,
 		              struct rtattr **tb,
+			      struct crypto_attr_type *algt,
 			      struct cryptd_queue *queue)
 {
 	struct aead_instance_ctx *ctx;
 	struct aead_instance *inst;
 	struct aead_alg *alg;
-	u32 type = 0;
-	u32 mask = CRYPTO_ALG_ASYNC;
+	u32 type;
+	u32 mask;
 	int err;
 
-	cryptd_check_internal(tb, &type, &mask);
+	cryptd_type_and_mask(algt, &type, &mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -848,8 +849,8 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 	if (err)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
-				   (alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
+	inst->alg.base.cra_flags |= CRYPTO_ALG_ASYNC |
+		(alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
 	inst->alg.base.cra_ctxsize = sizeof(struct cryptd_aead_ctx);
 
 	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
@@ -884,11 +885,11 @@ static int cryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_SKCIPHER:
-		return cryptd_create_skcipher(tmpl, tb, &queue);
+		return cryptd_create_skcipher(tmpl, tb, algt, &queue);
 	case CRYPTO_ALG_TYPE_HASH:
-		return cryptd_create_hash(tmpl, tb, &queue);
+		return cryptd_create_hash(tmpl, tb, algt, &queue);
 	case CRYPTO_ALG_TYPE_AEAD:
-		return cryptd_create_aead(tmpl, tb, &queue);
+		return cryptd_create_aead(tmpl, tb, algt, &queue);
 	}
 
 	return -EINVAL;
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 31ac4ae598e1..ae8d88c715d6 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -256,29 +256,22 @@ static void crypto_rfc3686_free(struct skcipher_instance *inst)
 static int crypto_rfc3686_create(struct crypto_template *tmpl,
 				 struct rtattr **tb)
 {
-	struct crypto_attr_type *algt;
 	struct skcipher_instance *inst;
 	struct skcipher_alg *alg;
 	struct crypto_skcipher_spawn *spawn;
 	u32 mask;
-
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
-		return -EINVAL;
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
+	if (err)
+		return err;
+	mask |= crypto_requires_off(crypto_get_attr_type(tb),
+				    CRYPTO_ALG_NEED_FALLBACK);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
 
-	mask = crypto_requires_sync(algt->type, algt->mask) |
-		crypto_requires_off(algt->type, algt->mask,
-				    CRYPTO_ALG_NEED_FALLBACK);
-
 	spawn = skcipher_instance_ctx(inst);
 
 	err = crypto_grab_skcipher(spawn, skcipher_crypto_instance(inst),
@@ -310,8 +303,6 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
-
 	inst->alg.ivsize = CTR_RFC3686_IV_SIZE;
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) +
diff --git a/crypto/cts.c b/crypto/cts.c
index 5e005c4f0221..3766d47ebcc0 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -325,19 +325,13 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct crypto_skcipher_spawn *spawn;
 	struct skcipher_instance *inst;
-	struct crypto_attr_type *algt;
 	struct skcipher_alg *alg;
 	u32 mask;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
-		return -EINVAL;
-
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
+	if (err)
+		return err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -364,7 +358,6 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
diff --git a/crypto/essiv.c b/crypto/essiv.c
index a7f45dbc4ee2..d012be23d496 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -466,7 +466,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 		return PTR_ERR(shash_name);
 
 	type = algt->type & algt->mask;
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	switch (type) {
 	case CRYPTO_ALG_TYPE_SKCIPHER:
@@ -525,7 +525,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	/* Synchronous hash, e.g., "sha256" */
 	_hash_alg = crypto_alg_mod_lookup(shash_name,
 					  CRYPTO_ALG_TYPE_SHASH,
-					  CRYPTO_ALG_TYPE_MASK);
+					  CRYPTO_ALG_TYPE_MASK | mask);
 	if (IS_ERR(_hash_alg)) {
 		err = PTR_ERR(_hash_alg);
 		goto out_drop_skcipher;
@@ -557,7 +557,12 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 		     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto out_free_hash;
 
-	base->cra_flags		= block_base->cra_flags & CRYPTO_ALG_ASYNC;
+	/*
+	 * hash_alg wasn't gotten via crypto_grab*(), so we need to inherit its
+	 * flags manually.
+	 */
+	base->cra_flags        |= (hash_alg->base.cra_flags &
+				   CRYPTO_ALG_INHERITED_FLAGS);
 	base->cra_blocksize	= block_base->cra_blocksize;
 	base->cra_ctxsize	= sizeof(struct essiv_tfm_ctx);
 	base->cra_alignmask	= block_base->cra_alignmask;
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 0103d28c541e..3a36a9533c96 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -578,7 +578,6 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 				    const char *ctr_name,
 				    const char *ghash_name)
 {
-	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
 	struct gcm_instance_ctx *ctx;
@@ -586,14 +585,9 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	struct hash_alg_common *ghash;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return -EINVAL;
-
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD, &mask);
+	if (err)
+		return err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -635,8 +629,6 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = (ghash->base.cra_flags |
-				    ctr->base.cra_flags) & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (ghash->base.cra_priority +
 				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
@@ -835,21 +827,15 @@ static void crypto_rfc4106_free(struct aead_instance *inst)
 static int crypto_rfc4106_create(struct crypto_template *tmpl,
 				 struct rtattr **tb)
 {
-	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
 	struct crypto_aead_spawn *spawn;
 	struct aead_alg *alg;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return -EINVAL;
-
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD, &mask);
+	if (err)
+		return err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -882,7 +868,6 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
@@ -1057,21 +1042,15 @@ static void crypto_rfc4543_free(struct aead_instance *inst)
 static int crypto_rfc4543_create(struct crypto_template *tmpl,
 				struct rtattr **tb)
 {
-	struct crypto_attr_type *algt;
 	u32 mask;
 	struct aead_instance *inst;
 	struct aead_alg *alg;
 	struct crypto_rfc4543_instance_ctx *ctx;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return -EINVAL;
-
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD, &mask);
+	if (err)
+		return err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -1104,7 +1083,6 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
diff --git a/crypto/geniv.c b/crypto/geniv.c
index 07496c8af0ab..bee4621b4f12 100644
--- a/crypto/geniv.c
+++ b/crypto/geniv.c
@@ -42,7 +42,6 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 				       struct rtattr **tb)
 {
 	struct crypto_aead_spawn *spawn;
-	struct crypto_attr_type *algt;
 	struct aead_instance *inst;
 	struct aead_alg *alg;
 	unsigned int ivsize;
@@ -50,12 +49,9 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	u32 mask;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return ERR_CAST(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
-		return ERR_PTR(-EINVAL);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD, &mask);
+	if (err)
+		return ERR_PTR(err);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -63,9 +59,6 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 
 	spawn = aead_instance_ctx(inst);
 
-	/* Ignore async algorithms if necessary. */
-	mask = crypto_requires_sync(algt->type, algt->mask);
-
 	err = crypto_grab_aead(spawn, aead_crypto_instance(inst),
 			       crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
@@ -90,7 +83,6 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
diff --git a/crypto/hmac.c b/crypto/hmac.c
index e38bfb948278..25856aa7ccbf 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -168,11 +168,12 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct crypto_shash_spawn *spawn;
 	struct crypto_alg *alg;
 	struct shash_alg *salg;
+	u32 mask;
 	int err;
 	int ds;
 	int ss;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH, &mask);
 	if (err)
 		return err;
 
@@ -182,7 +183,7 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = shash_instance_ctx(inst);
 
 	err = crypto_grab_shash(spawn, shash_crypto_instance(inst),
-				crypto_attr_alg_name(tb[1]), 0, 0);
+				crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 	salg = crypto_spawn_shash_alg(spawn);
diff --git a/crypto/lrw.c b/crypto/lrw.c
index 5b07a7c09296..a709c801ee45 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -297,21 +297,15 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct crypto_skcipher_spawn *spawn;
 	struct skcipher_instance *inst;
-	struct crypto_attr_type *algt;
 	struct skcipher_alg *alg;
 	const char *cipher_name;
 	char ecb_name[CRYPTO_MAX_ALG_NAME];
 	u32 mask;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
-		return -EINVAL;
-
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
+	if (err)
+		return err;
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
@@ -379,7 +373,6 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	} else
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = LRW_BLOCK_SIZE;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 8bddc65cd509..cbc383a1a3fe 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -226,18 +226,14 @@ static int pcrypt_init_instance(struct crypto_instance *inst,
 }
 
 static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
-			      u32 type, u32 mask)
+			      struct crypto_attr_type *algt)
 {
 	struct pcrypt_instance_ctx *ctx;
-	struct crypto_attr_type *algt;
 	struct aead_instance *inst;
 	struct aead_alg *alg;
+	u32 mask = crypto_algt_inherited_mask(algt);
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
@@ -254,7 +250,7 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 		goto err_free_inst;
 
 	err = crypto_grab_aead(&ctx->spawn, aead_crypto_instance(inst),
-			       crypto_attr_alg_name(tb[1]), 0, 0);
+			       crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 
@@ -263,7 +259,7 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 	if (err)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags |= CRYPTO_ALG_ASYNC;
 
 	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
 	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
@@ -298,7 +294,7 @@ static int pcrypt_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_AEAD:
-		return pcrypt_create_aead(tmpl, tb, algt->type, algt->mask);
+		return pcrypt_create_aead(tmpl, tb, algt);
 	}
 
 	return -EINVAL;
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index d31031de51bc..4983b2b4a223 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -596,7 +596,6 @@ static void pkcs1pad_free(struct akcipher_instance *inst)
 
 static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct crypto_attr_type *algt;
 	u32 mask;
 	struct akcipher_instance *inst;
 	struct pkcs1pad_inst_ctx *ctx;
@@ -604,14 +603,9 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 	const char *hash_name;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AKCIPHER) & algt->mask)
-		return -EINVAL;
-
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AKCIPHER, &mask);
+	if (err)
+		return err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -658,7 +652,6 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 			goto err_free_inst;
 	}
 
-	inst->alg.base.cra_flags = rsa_alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = rsa_alg->base.cra_priority;
 	inst->alg.base.cra_ctxsize = sizeof(struct pkcs1pad_ctx);
 
diff --git a/crypto/simd.c b/crypto/simd.c
index 56885af49c24..edaa479a1ec5 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -171,7 +171,8 @@ struct simd_skcipher_alg *simd_skcipher_create_compat(const char *algname,
 		     drvname) >= CRYPTO_MAX_ALG_NAME)
 		goto out_free_salg;
 
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC |
+		(ialg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS);
 	alg->base.cra_priority = ialg->base.cra_priority;
 	alg->base.cra_blocksize = ialg->base.cra_blocksize;
 	alg->base.cra_alignmask = ialg->base.cra_alignmask;
@@ -417,7 +418,8 @@ struct simd_aead_alg *simd_aead_create_compat(const char *algname,
 		     drvname) >= CRYPTO_MAX_ALG_NAME)
 		goto out_free_salg;
 
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC |
+		(ialg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS);
 	alg->base.cra_priority = ialg->base.cra_priority;
 	alg->base.cra_blocksize = ialg->base.cra_blocksize;
 	alg->base.cra_alignmask = ialg->base.cra_alignmask;
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 7221def7b9a7..3b93a74ad124 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -934,22 +934,17 @@ static void skcipher_free_instance_simple(struct skcipher_instance *inst)
 struct skcipher_instance *skcipher_alloc_instance_simple(
 	struct crypto_template *tmpl, struct rtattr **tb)
 {
-	struct crypto_attr_type *algt;
 	u32 mask;
 	struct skcipher_instance *inst;
 	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *cipher_alg;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return ERR_CAST(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
-		return ERR_PTR(-EINVAL);
-
-	mask = crypto_requires_off(algt->type, algt->mask,
-				   CRYPTO_ALG_NEED_FALLBACK);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
+	if (err)
+		return ERR_PTR(err);
+	mask |= crypto_requires_off(crypto_get_attr_type(tb),
+				    CRYPTO_ALG_NEED_FALLBACK);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
diff --git a/crypto/vmac.c b/crypto/vmac.c
index 2d906830df96..9b565d1040d6 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -620,9 +620,10 @@ static int vmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct shash_instance *inst;
 	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
+	u32 mask;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH, &mask);
 	if (err)
 		return err;
 
@@ -632,7 +633,7 @@ static int vmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = shash_instance_ctx(inst);
 
 	err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
-				 crypto_attr_alg_name(tb[1]), 0, 0);
+				 crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 	alg = crypto_spawn_cipher_alg(spawn);
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 598ec88abf0f..af3b7eb5d7c7 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -191,9 +191,10 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
 	unsigned long alignmask;
+	u32 mask;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH, &mask);
 	if (err)
 		return err;
 
@@ -203,7 +204,7 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = shash_instance_ctx(inst);
 
 	err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
-				 crypto_attr_alg_name(tb[1]), 0, 0);
+				 crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 	alg = crypto_spawn_cipher_alg(spawn);
diff --git a/crypto/xts.c b/crypto/xts.c
index 3565f3b863a6..35a30610569b 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -331,19 +331,17 @@ static void crypto_xts_free(struct skcipher_instance *inst)
 static int create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct skcipher_instance *inst;
-	struct crypto_attr_type *algt;
 	struct xts_instance_ctx *ctx;
 	struct skcipher_alg *alg;
 	const char *cipher_name;
 	u32 mask;
 	int err;
 
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
-		return -EINVAL;
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
+	if (err)
+		return err;
+	mask |= crypto_requires_off(crypto_get_attr_type(tb),
+				    CRYPTO_ALG_NEED_FALLBACK);
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
@@ -355,10 +353,6 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	ctx = skcipher_instance_ctx(inst);
 
-	mask = crypto_requires_off(algt->type, algt->mask,
-				   CRYPTO_ALG_NEED_FALLBACK |
-				   CRYPTO_ALG_ASYNC);
-
 	err = crypto_grab_skcipher(&ctx->spawn, skcipher_crypto_instance(inst),
 				   cipher_name, 0, mask);
 	if (err == -ENOENT) {
@@ -415,7 +409,6 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	} else
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 00a9cf98debe..da64c37482b4 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -116,7 +116,7 @@ struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 void *crypto_spawn_tfm2(struct crypto_spawn *spawn);
 
 struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
-int crypto_check_attr_type(struct rtattr **tb, u32 type);
+int crypto_check_attr_type(struct rtattr **tb, u32 type, u32 *mask_ret);
 const char *crypto_attr_alg_name(struct rtattr *rta);
 int crypto_attr_u32(struct rtattr *rta, u32 *num);
 int crypto_inst_setname(struct crypto_instance *inst, const char *name,
@@ -235,18 +235,27 @@ static inline struct crypto_async_request *crypto_get_backlog(
 	       container_of(queue->backlog, struct crypto_async_request, list);
 }
 
-static inline int crypto_requires_off(u32 type, u32 mask, u32 off)
+static inline u32 crypto_requires_off(struct crypto_attr_type *algt, u32 off)
 {
-	return (type ^ off) & mask & off;
+	return (algt->type ^ off) & algt->mask & off;
 }
 
 /*
- * Returns CRYPTO_ALG_ASYNC if type/mask requires the use of sync algorithms.
- * Otherwise returns zero.
+ * When an algorithm uses another algorithm (e.g., if it's an instance of a
+ * template), these are the flags that should always be set on the "outer"
+ * algorithm if any "inner" algorithm has them set.
  */
-static inline int crypto_requires_sync(u32 type, u32 mask)
+#define CRYPTO_ALG_INHERITED_FLAGS	CRYPTO_ALG_ASYNC
+
+/*
+ * Given the type and mask that specify the flags restrictions on a template
+ * instance being created, return the mask that should be passed to
+ * crypto_grab_*() (along with type=0) to honor any request the user made to
+ * have any of the CRYPTO_ALG_INHERITED_FLAGS clear.
+ */
+static inline u32 crypto_algt_inherited_mask(struct crypto_attr_type *algt)
 {
-	return crypto_requires_off(type, mask, CRYPTO_ALG_ASYNC);
+	return crypto_requires_off(algt, CRYPTO_ALG_INHERITED_FLAGS);
 }
 
 noinline unsigned long __crypto_memneq(const void *a, const void *b, size_t size);
-- 
2.27.0

