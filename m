Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502FAC433E4
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 04:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22E6620747
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 04:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593579153;
	bh=yymED4mIlgOamRIn2UQQ7nEfeSHwrZxgwTr02dIAyJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WkgDNaSDFCAXo5q3xZjTFfk+nhrlvTtT89oLT9ACCcIUuZIL+ci5UE5rN+GXvpunI
	 1nj1lo9c6y1E9IogovaiXNwrNhDP6JpwRxv/25ZxO+XumFh8bCMTXP4L/e6hq9MWpT
	 w1n728Qcl+lKSa4CjHblH2kWvZH3rrhm2DKGhObw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgGAEwc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 00:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgGAEwa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 00:52:30 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08F742074D;
        Wed,  1 Jul 2020 04:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593579149;
        bh=yymED4mIlgOamRIn2UQQ7nEfeSHwrZxgwTr02dIAyJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nAxVDc5QJucBHBsPsDCYV6hRkHi+kDfSwqLZiDdcZVnLv7p1d0wsQvesrrTfDCTCs
         ZqFlE/aGkTmvYKxu6vf0zV8GZYTA8XutSduViM/IwE4lDWBfy7xOAQzb6buhUf2w6q
         tWTXM8635B1oxLL9DE+/JnDw8IdHiFp5eDHVvrk0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com
Subject: [PATCH 2/6] crypto: algapi - use common mechanism for inheriting flags
Date:   Tue, 30 Jun 2020 21:52:13 -0700
Message-Id: <20200701045217.121126-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701045217.121126-1-ebiggers@kernel.org>
References: <20200701045217.121126-1-ebiggers@kernel.org>
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

  - Make crypto_grab_*() propagate these flags to the template instance
    being created so that templates don't have to do this themselves.

Make crypto/simd.c propagate these flags too, since it "wraps" another
algorithm, similar to a template.

Originally-from: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/adiantum.c         |  4 +--
 crypto/algapi.c           |  2 ++
 crypto/authenc.c          |  4 +--
 crypto/authencesn.c       |  4 +--
 crypto/ccm.c              | 23 +++++++++------
 crypto/chacha20poly1305.c |  4 +--
 crypto/cmac.c             | 15 +++++++---
 crypto/cryptd.c           | 59 ++++++++++++++++++++-------------------
 crypto/ctr.c              |  8 ++----
 crypto/cts.c              |  3 +-
 crypto/essiv.c            | 11 ++++++--
 crypto/gcm.c              | 10 ++-----
 crypto/geniv.c            |  4 +--
 crypto/hmac.c             | 15 +++++++---
 crypto/lrw.c              |  3 +-
 crypto/pcrypt.c           | 14 ++++------
 crypto/rsa-pkcs1pad.c     |  3 +-
 crypto/simd.c             |  6 ++--
 crypto/skcipher.c         |  3 +-
 crypto/vmac.c             | 15 +++++++---
 crypto/xcbc.c             | 15 +++++++---
 crypto/xts.c              |  3 +-
 include/crypto/algapi.h   | 21 ++++++++++----
 23 files changed, 140 insertions(+), 109 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index cf2b9f4103dd..6e9aa611992c 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -507,7 +507,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
 	if (!inst)
@@ -565,8 +565,6 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 		     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = streamcipher_alg->base.cra_flags &
-				   CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_blocksize = BLOCKCIPHER_BLOCK_SIZE;
 	inst->alg.base.cra_ctxsize = sizeof(struct adiantum_tfm_ctx);
 	inst->alg.base.cra_alignmask = streamcipher_alg->base.cra_alignmask |
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 92abdf675992..24a56279ca80 100644
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
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 775e7138fd10..ae66561d1af2 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -388,7 +388,7 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -423,8 +423,6 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 		     enc->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = (auth_base->cra_flags |
-				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = enc->base.cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->base.cra_blocksize;
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 149b70df2a91..9847339aa4ef 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -406,7 +406,7 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -437,8 +437,6 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 		     enc->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = (auth_base->cra_flags |
-				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = enc->base.cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->base.cra_blocksize;
diff --git a/crypto/ccm.c b/crypto/ccm.c
index d1fb01bbc814..320fe85a1bfe 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -462,7 +462,7 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
 	if (!inst)
@@ -470,7 +470,7 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 	ictx = aead_instance_ctx(inst);
 
 	err = crypto_grab_ahash(&ictx->mac, aead_crypto_instance(inst),
-				mac_name, 0, CRYPTO_ALG_ASYNC);
+				mac_name, 0, mask | CRYPTO_ALG_ASYNC);
 	if (err)
 		goto err_free_inst;
 	mac = crypto_spawn_ahash_alg(&ictx->mac);
@@ -507,7 +507,6 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 		     mac->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = ctr->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (mac->base.cra_priority +
 				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
@@ -726,7 +725,7 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -759,7 +758,6 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
@@ -875,14 +873,21 @@ static void cbcmac_exit_tfm(struct crypto_tfm *tfm)
 
 static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
+	struct crypto_attr_type *algt;
 	struct shash_instance *inst;
 	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
+	u32 mask;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
-	if (err)
-		return err;
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_SHASH) & algt->mask)
+		return -EINVAL;
+
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -890,7 +895,7 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = shash_instance_ctx(inst);
 
 	err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
-				 crypto_attr_alg_name(tb[1]), 0, 0);
+				 crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 	alg = crypto_spawn_cipher_alg(spawn);
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index ccaea5cb66d1..a14a5fc39c81 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -573,7 +573,7 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -613,8 +613,6 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 		     poly->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = (chacha->base.cra_flags |
-				    poly->base.cra_flags) & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (chacha->base.cra_priority +
 				       poly->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
diff --git a/crypto/cmac.c b/crypto/cmac.c
index 143a6544c873..04f293cb1a1a 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -221,15 +221,22 @@ static void cmac_exit_tfm(struct crypto_tfm *tfm)
 
 static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
+	struct crypto_attr_type *algt;
 	struct shash_instance *inst;
 	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
 	unsigned long alignmask;
+	u32 mask;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
-	if (err)
-		return err;
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_SHASH) & algt->mask)
+		return -EINVAL;
+
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -237,7 +244,7 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
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
index 31ac4ae598e1..b8b01eeb9fa1 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -275,9 +275,9 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	if (!inst)
 		return -ENOMEM;
 
-	mask = crypto_requires_sync(algt->type, algt->mask) |
-		crypto_requires_off(algt->type, algt->mask,
-				    CRYPTO_ALG_NEED_FALLBACK);
+	mask = crypto_requires_off(algt->type, algt->mask,
+				   CRYPTO_ALG_NEED_FALLBACK |
+				   CRYPTO_ALG_INHERITED_FLAGS);
 
 	spawn = skcipher_instance_ctx(inst);
 
@@ -310,8 +310,6 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
-
 	inst->alg.ivsize = CTR_RFC3686_IV_SIZE;
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) +
diff --git a/crypto/cts.c b/crypto/cts.c
index 5e005c4f0221..203d0281106a 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -337,7 +337,7 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -364,7 +364,6 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
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
index 0103d28c541e..246511264343 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -593,7 +593,7 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -635,8 +635,6 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = (ghash->base.cra_flags |
-				    ctr->base.cra_flags) & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (ghash->base.cra_priority +
 				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
@@ -849,7 +847,7 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -882,7 +880,6 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
@@ -1071,7 +1068,7 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -1104,7 +1101,6 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
diff --git a/crypto/geniv.c b/crypto/geniv.c
index 07496c8af0ab..0143a24cf503 100644
--- a/crypto/geniv.c
+++ b/crypto/geniv.c
@@ -63,8 +63,7 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 
 	spawn = aead_instance_ctx(inst);
 
-	/* Ignore async algorithms if necessary. */
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	err = crypto_grab_aead(spawn, aead_crypto_instance(inst),
 			       crypto_attr_alg_name(tb[1]), 0, mask);
@@ -90,7 +89,6 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
diff --git a/crypto/hmac.c b/crypto/hmac.c
index e38bfb948278..ccbd8a8b11b0 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -164,17 +164,24 @@ static void hmac_exit_tfm(struct crypto_shash *parent)
 
 static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
+	struct crypto_attr_type *algt;
 	struct shash_instance *inst;
 	struct crypto_shash_spawn *spawn;
 	struct crypto_alg *alg;
 	struct shash_alg *salg;
+	u32 mask;
 	int err;
 	int ds;
 	int ss;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
-	if (err)
-		return err;
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_SHASH) & algt->mask)
+		return -EINVAL;
+
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -182,7 +189,7 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = shash_instance_ctx(inst);
 
 	err = crypto_grab_shash(spawn, shash_crypto_instance(inst),
-				crypto_attr_alg_name(tb[1]), 0, 0);
+				crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 	salg = crypto_spawn_shash_alg(spawn);
diff --git a/crypto/lrw.c b/crypto/lrw.c
index 5b07a7c09296..8d99da8c1e27 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -311,7 +311,7 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
@@ -379,7 +379,6 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
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
index d31031de51bc..ebbb098d470c 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -611,7 +611,7 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -658,7 +658,6 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
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
index 7221def7b9a7..e1c33a0214ca 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -949,7 +949,8 @@ struct skcipher_instance *skcipher_alloc_instance_simple(
 		return ERR_PTR(-EINVAL);
 
 	mask = crypto_requires_off(algt->type, algt->mask,
-				   CRYPTO_ALG_NEED_FALLBACK);
+				   CRYPTO_ALG_NEED_FALLBACK |
+				   CRYPTO_ALG_INHERITED_FLAGS);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
diff --git a/crypto/vmac.c b/crypto/vmac.c
index 2d906830df96..4c5e340e14bc 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -617,14 +617,21 @@ static void vmac_exit_tfm(struct crypto_tfm *tfm)
 
 static int vmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
+	struct crypto_attr_type *algt;
 	struct shash_instance *inst;
 	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
+	u32 mask;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
-	if (err)
-		return err;
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_SHASH) & algt->mask)
+		return -EINVAL;
+
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -632,7 +639,7 @@ static int vmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = shash_instance_ctx(inst);
 
 	err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
-				 crypto_attr_alg_name(tb[1]), 0, 0);
+				 crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 	alg = crypto_spawn_cipher_alg(spawn);
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 598ec88abf0f..7288ce777720 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -187,15 +187,22 @@ static void xcbc_exit_tfm(struct crypto_tfm *tfm)
 
 static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
+	struct crypto_attr_type *algt;
 	struct shash_instance *inst;
 	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
 	unsigned long alignmask;
+	u32 mask;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
-	if (err)
-		return err;
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_SHASH) & algt->mask)
+		return -EINVAL;
+
+	mask = crypto_algt_inherited_mask(algt);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -203,7 +210,7 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	spawn = shash_instance_ctx(inst);
 
 	err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
-				 crypto_attr_alg_name(tb[1]), 0, 0);
+				 crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 	alg = crypto_spawn_cipher_alg(spawn);
diff --git a/crypto/xts.c b/crypto/xts.c
index 3565f3b863a6..3efee995aeeb 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -357,7 +357,7 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	mask = crypto_requires_off(algt->type, algt->mask,
 				   CRYPTO_ALG_NEED_FALLBACK |
-				   CRYPTO_ALG_ASYNC);
+				   CRYPTO_ALG_INHERITED_FLAGS);
 
 	err = crypto_grab_skcipher(&ctx->spawn, skcipher_crypto_instance(inst),
 				   cipher_name, 0, mask);
@@ -415,7 +415,6 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	} else
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 00a9cf98debe..5385443dcf9b 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -235,18 +235,29 @@ static inline struct crypto_async_request *crypto_get_backlog(
 	       container_of(queue->backlog, struct crypto_async_request, list);
 }
 
-static inline int crypto_requires_off(u32 type, u32 mask, u32 off)
+static inline u32 crypto_requires_off(u32 type, u32 mask, u32 off)
 {
 	return (type ^ off) & mask & off;
 }
 
 /*
- * Returns CRYPTO_ALG_ASYNC if type/mask requires the use of sync algorithms.
- * Otherwise returns zero.
+ * When an algorithm uses another algorithm (e.g., if it's an instance of a
+ * template), these are the flags that should always be set on the "outer"
+ * algorithm if any "inner" algorithm has them set.  In some cases other flags
+ * are inherited too; these are just the flags that are *always* inherited.
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
+	return crypto_requires_off(algt->type, algt->mask,
+				   CRYPTO_ALG_INHERITED_FLAGS);
 }
 
 noinline unsigned long __crypto_memneq(const void *a, const void *b, size_t size);
-- 
2.27.0

