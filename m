Return-Path: <SRS0=XejO=AL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811BEC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 17:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48AC3207F9
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 17:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iVPniivc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389990AbgF3RCU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:02:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51952 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727061AbgF3RCU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jun 2020 13:02:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593536537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E+Z0G2RbdilN78NwUNpWpn9S/XlUv+m2apoVQz9iug0=;
        b=iVPniivc6wrpsokrnrGw6yeQRwHKLL6eWTggry8sLjUHs70wn5ajQiL8PbFk1U5E4OPW5C
        24C8A6C75Ce2Vq/ZMui9sTD867fyYy4J+WPfTut7J/2FKZnzIMX0a6oVD/EW2VEWBZ4Yqy
        TCw3PAZoSRY1iHsmqmHAjdxLMsYna+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-_Oqc9SczOza9U8beLCpDKw-1; Tue, 30 Jun 2020 13:02:15 -0400
X-MC-Unique: _Oqc9SczOza9U8beLCpDKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 422FE1800D42;
        Tue, 30 Jun 2020 17:02:14 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F7122B4AD;
        Tue, 30 Jun 2020 17:02:11 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05UH2A7u002432;
        Tue, 30 Jun 2020 13:02:10 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05UH2A1w002427;
        Tue, 30 Jun 2020 13:02:10 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 30 Jun 2020 13:02:10 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Eric Biggers <ebiggers@kernel.org>
cc:     Mike Snitzer <msnitzer@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org,
        Wei Xu <xuwei5@hisilicon.com>, dm-devel@redhat.com,
        George Cherian <gcherian@marvell.com>,
        linux-crypto@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>
Subject: [PATCH 1/3 v5] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
In-Reply-To: <alpine.LRH.2.02.2006301256110.30526@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2006301301260.30526@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com> <20200616173620.GA207319@gmail.com> <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626044534.GA2870@gondor.apana.org.au> <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com> <20200626164617.GA211634@gmail.com>
 <alpine.LRH.2.02.2006281505250.347@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006300954150.15237@file01.intranet.prod.int.rdu2.redhat.com> <20200630163552.GA837@sol.localdomain>
 <alpine.LRH.2.02.2006301256110.30526@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce a new flag CRYPTO_ALG_ALLOCATES_MEMORY and pass it down the
crypto stack.

If the flag is set, then the crypto driver allocates memory in its request
routine. Such drivers are not suitable for disk encryption because
GFP_ATOMIC allocation can fail anytime (causing random I/O errors) and
GFP_KERNEL allocation can recurse into the block layer, causing a
deadlock.

Pass the flag CRYPTO_ALG_ALLOCATES_MEMORY down through the crypto API.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 crypto/adiantum.c         |    8 +++++---
 crypto/authenc.c          |    7 ++++---
 crypto/authencesn.c       |    7 ++++---
 crypto/ccm.c              |    8 ++++----
 crypto/chacha20poly1305.c |    7 ++++---
 crypto/cryptd.c           |   16 +++++++++++-----
 crypto/ctr.c              |    4 ++--
 crypto/cts.c              |    4 ++--
 crypto/essiv.c            |    4 ++--
 crypto/gcm.c              |   15 ++++++++-------
 crypto/geniv.c            |    4 ++--
 crypto/lrw.c              |    4 ++--
 crypto/pcrypt.c           |    9 +++++++--
 crypto/rsa-pkcs1pad.c     |    4 ++--
 crypto/seqiv.c            |    2 ++
 crypto/xts.c              |    4 ++--
 include/crypto/algapi.h   |   10 ++++++----
 include/linux/crypto.h    |   15 +++++++++++++++
 18 files changed, 84 insertions(+), 48 deletions(-)

Index: linux-2.6/include/linux/crypto.h
===================================================================
--- linux-2.6.orig/include/linux/crypto.h	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/include/linux/crypto.h	2020-06-29 16:03:07.336417000 +0200
@@ -102,6 +102,21 @@
 #define CRYPTO_NOLOAD			0x00008000
 
 /*
+ * The driver may allocate memory during request processing, so it shouldn't be
+ * used in cases where memory allocation failures aren't acceptable, such as
+ * during block device encryption.
+ */
+#define CRYPTO_ALG_ALLOCATES_MEMORY	0x00010000
+
+/*
+ * When an algorithm uses another algorithm (e.g., if it's an instance of a
+ * template), these are the flags that always get set on the "outer" algorithm
+ * if any "inner" algorithm has them set.  In some cases other flags are
+ * inherited too; these are just the flags that are *always* inherited.
+ */
+#define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)
+
+/*
  * Transform masks and values (for crt_flags).
  */
 #define CRYPTO_TFM_NEED_KEY		0x00000001
Index: linux-2.6/crypto/authenc.c
===================================================================
--- linux-2.6.orig/crypto/authenc.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/authenc.c	2020-06-30 15:47:56.516417000 +0200
@@ -388,7 +388,7 @@ static int crypto_authenc_create(struct
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -423,8 +423,9 @@ static int crypto_authenc_create(struct
 		     enc->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = (auth_base->cra_flags |
-				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags =
+		(auth_base->cra_flags | enc->base.cra_flags) &
+		CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = enc->base.cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->base.cra_blocksize;
Index: linux-2.6/crypto/authencesn.c
===================================================================
--- linux-2.6.orig/crypto/authencesn.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/authencesn.c	2020-06-30 15:48:11.996417000 +0200
@@ -406,7 +406,7 @@ static int crypto_authenc_esn_create(str
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -437,8 +437,9 @@ static int crypto_authenc_esn_create(str
 		     enc->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = (auth_base->cra_flags |
-				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags =
+		(auth_base->cra_flags | enc->base.cra_flags) &
+		CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = enc->base.cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->base.cra_blocksize;
Index: linux-2.6/crypto/ccm.c
===================================================================
--- linux-2.6.orig/crypto/ccm.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/ccm.c	2020-06-29 16:03:07.336417000 +0200
@@ -462,7 +462,7 @@ static int crypto_ccm_create_common(stru
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
 	if (!inst)
@@ -507,7 +507,7 @@ static int crypto_ccm_create_common(stru
 		     mac->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = ctr->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = ctr->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = (mac->base.cra_priority +
 				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
@@ -726,7 +726,7 @@ static int crypto_rfc4309_create(struct
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -759,7 +759,7 @@ static int crypto_rfc4309_create(struct
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
Index: linux-2.6/crypto/chacha20poly1305.c
===================================================================
--- linux-2.6.orig/crypto/chacha20poly1305.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/chacha20poly1305.c	2020-06-30 15:47:19.816417000 +0200
@@ -573,7 +573,7 @@ static int chachapoly_create(struct cryp
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -613,8 +613,9 @@ static int chachapoly_create(struct cryp
 		     poly->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = (chacha->base.cra_flags |
-				    poly->base.cra_flags) & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags =
+		(chacha->base.cra_flags |
+		poly->base.cra_flags) & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = (chacha->base.cra_priority +
 				       poly->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
Index: linux-2.6/crypto/cryptd.c
===================================================================
--- linux-2.6.orig/crypto/cryptd.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/cryptd.c	2020-06-30 18:49:03.556417000 +0200
@@ -202,6 +202,7 @@ static inline void cryptd_check_internal
 
 	*type |= algt->type & CRYPTO_ALG_INTERNAL;
 	*mask |= algt->mask & CRYPTO_ALG_INTERNAL;
+	*mask |= crypto_alg_inherited_mask(algt->type, algt->mask);
 }
 
 static int cryptd_init_instance(struct crypto_instance *inst,
@@ -395,8 +396,10 @@ static int cryptd_create_skcipher(struct
 	if (err)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
-				   (alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
+	inst->alg.base.cra_flags =
+		CRYPTO_ALG_ASYNC |
+		(alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS) |
+		(alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
 
 	inst->alg.ivsize = crypto_skcipher_alg_ivsize(alg);
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
@@ -663,7 +666,8 @@ static int cryptd_create_hash(struct cry
 
 	inst->alg.halg.base.cra_flags = CRYPTO_ALG_ASYNC |
 		(alg->base.cra_flags & (CRYPTO_ALG_INTERNAL |
-					CRYPTO_ALG_OPTIONAL_KEY));
+					CRYPTO_ALG_OPTIONAL_KEY |
+					CRYPTO_ALG_INHERITED_FLAGS));
 
 	inst->alg.halg.digestsize = alg->digestsize;
 	inst->alg.halg.statesize = alg->statesize;
@@ -848,8 +852,10 @@ static int cryptd_create_aead(struct cry
 	if (err)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
-				   (alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
+	inst->alg.base.cra_flags =
+		CRYPTO_ALG_ASYNC |
+		(alg->base.cra_flags & CRYPTO_ALG_INTERNAL) |
+		(alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS);
 	inst->alg.base.cra_ctxsize = sizeof(struct cryptd_aead_ctx);
 
 	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
Index: linux-2.6/crypto/ctr.c
===================================================================
--- linux-2.6.orig/crypto/ctr.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/ctr.c	2020-06-29 16:03:07.336417000 +0200
@@ -275,7 +275,7 @@ static int crypto_rfc3686_create(struct
 	if (!inst)
 		return -ENOMEM;
 
-	mask = crypto_requires_sync(algt->type, algt->mask) |
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask) |
 		crypto_requires_off(algt->type, algt->mask,
 				    CRYPTO_ALG_NEED_FALLBACK);
 
@@ -310,7 +310,7 @@ static int crypto_rfc3686_create(struct
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 
 	inst->alg.ivsize = CTR_RFC3686_IV_SIZE;
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
Index: linux-2.6/crypto/cts.c
===================================================================
--- linux-2.6.orig/crypto/cts.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/cts.c	2020-06-29 16:03:07.346417000 +0200
@@ -337,7 +337,7 @@ static int crypto_cts_create(struct cryp
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -364,7 +364,7 @@ static int crypto_cts_create(struct cryp
 	if (err)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
Index: linux-2.6/crypto/essiv.c
===================================================================
--- linux-2.6.orig/crypto/essiv.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/essiv.c	2020-06-29 16:03:07.346417000 +0200
@@ -466,7 +466,7 @@ static int essiv_create(struct crypto_te
 		return PTR_ERR(shash_name);
 
 	type = algt->type & algt->mask;
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	switch (type) {
 	case CRYPTO_ALG_TYPE_SKCIPHER:
@@ -557,7 +557,7 @@ static int essiv_create(struct crypto_te
 		     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto out_free_hash;
 
-	base->cra_flags		= block_base->cra_flags & CRYPTO_ALG_ASYNC;
+	base->cra_flags		= block_base->cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	base->cra_blocksize	= block_base->cra_blocksize;
 	base->cra_ctxsize	= sizeof(struct essiv_tfm_ctx);
 	base->cra_alignmask	= block_base->cra_alignmask;
Index: linux-2.6/crypto/gcm.c
===================================================================
--- linux-2.6.orig/crypto/gcm.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/gcm.c	2020-06-30 15:48:26.566417000 +0200
@@ -593,7 +593,7 @@ static int crypto_gcm_create_common(stru
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -635,8 +635,9 @@ static int crypto_gcm_create_common(stru
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = (ghash->base.cra_flags |
-				    ctr->base.cra_flags) & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags =
+		(ghash->base.cra_flags | ctr->base.cra_flags) &
+		CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = (ghash->base.cra_priority +
 				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
@@ -849,7 +850,7 @@ static int crypto_rfc4106_create(struct
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -882,7 +883,7 @@ static int crypto_rfc4106_create(struct
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
@@ -1071,7 +1072,7 @@ static int crypto_rfc4543_create(struct
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -1104,7 +1105,7 @@ static int crypto_rfc4543_create(struct
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
Index: linux-2.6/crypto/geniv.c
===================================================================
--- linux-2.6.orig/crypto/geniv.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/geniv.c	2020-06-29 16:03:07.346417000 +0200
@@ -63,7 +63,7 @@ struct aead_instance *aead_geniv_alloc(s
 	spawn = aead_instance_ctx(inst);
 
 	/* Ignore async algorithms if necessary. */
-	mask |= crypto_requires_sync(algt->type, algt->mask);
+	mask |= crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	err = crypto_grab_aead(spawn, aead_crypto_instance(inst),
 			       crypto_attr_alg_name(tb[1]), type, mask);
@@ -89,7 +89,7 @@ struct aead_instance *aead_geniv_alloc(s
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
Index: linux-2.6/crypto/lrw.c
===================================================================
--- linux-2.6.orig/crypto/lrw.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/lrw.c	2020-06-29 16:03:07.346417000 +0200
@@ -311,7 +311,7 @@ static int create(struct crypto_template
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
@@ -379,7 +379,7 @@ static int create(struct crypto_template
 	} else
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = LRW_BLOCK_SIZE;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
Index: linux-2.6/crypto/rsa-pkcs1pad.c
===================================================================
--- linux-2.6.orig/crypto/rsa-pkcs1pad.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/rsa-pkcs1pad.c	2020-06-30 15:49:13.696417000 +0200
@@ -611,7 +611,7 @@ static int pkcs1pad_create(struct crypto
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -658,7 +658,7 @@ static int pkcs1pad_create(struct crypto
 			goto err_free_inst;
 	}
 
-	inst->alg.base.cra_flags = rsa_alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = rsa_alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = rsa_alg->base.cra_priority;
 	inst->alg.base.cra_ctxsize = sizeof(struct pkcs1pad_ctx);
 
Index: linux-2.6/crypto/xts.c
===================================================================
--- linux-2.6.orig/crypto/xts.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/xts.c	2020-06-29 16:04:38.096417000 +0200
@@ -357,7 +357,7 @@ static int create(struct crypto_template
 
 	mask = crypto_requires_off(algt->type, algt->mask,
 				   CRYPTO_ALG_NEED_FALLBACK |
-				   CRYPTO_ALG_ASYNC);
+				   CRYPTO_ALG_INHERITED_FLAGS);
 
 	err = crypto_grab_skcipher(&ctx->spawn, skcipher_crypto_instance(inst),
 				   cipher_name, 0, mask);
@@ -415,7 +415,7 @@ static int create(struct crypto_template
 	} else
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
Index: linux-2.6/include/crypto/algapi.h
===================================================================
--- linux-2.6.orig/include/crypto/algapi.h	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/include/crypto/algapi.h	2020-06-29 16:03:07.346417000 +0200
@@ -241,12 +241,14 @@ static inline int crypto_requires_off(u3
 }
 
 /*
- * Returns CRYPTO_ALG_ASYNC if type/mask requires the use of sync algorithms.
- * Otherwise returns zero.
+ * Returns the flag CRYPTO_ALG_ASYNC if type/mask requires the use of sync
+ * algorithms.
+ * Returns the flag CRYPTO_ALG_ALLOCATES_MEMORY if type/mask requires the use
+ * of drivers that don't allocate memory. Otherwise returns zero.
  */
-static inline int crypto_requires_sync(u32 type, u32 mask)
+static inline int crypto_alg_inherited_mask(u32 type, u32 mask)
 {
-	return crypto_requires_off(type, mask, CRYPTO_ALG_ASYNC);
+	return crypto_requires_off(type, mask, CRYPTO_ALG_INHERITED_FLAGS);
 }
 
 noinline unsigned long __crypto_memneq(const void *a, const void *b, size_t size);
Index: linux-2.6/crypto/adiantum.c
===================================================================
--- linux-2.6.orig/crypto/adiantum.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/adiantum.c	2020-06-30 18:50:41.306417000 +0200
@@ -507,7 +507,7 @@ static int adiantum_create(struct crypto
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
 	if (!inst)
@@ -565,8 +565,10 @@ static int adiantum_create(struct crypto
 		     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = streamcipher_alg->base.cra_flags &
-				   CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = (streamcipher_alg->base.cra_flags |
+				    blockcipher_alg->cra_flags |
+				    hash_alg->base.cra_flags) &
+				    CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_blocksize = BLOCKCIPHER_BLOCK_SIZE;
 	inst->alg.base.cra_ctxsize = sizeof(struct adiantum_tfm_ctx);
 	inst->alg.base.cra_alignmask = streamcipher_alg->base.cra_alignmask |
Index: linux-2.6/crypto/pcrypt.c
===================================================================
--- linux-2.6.orig/crypto/pcrypt.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/pcrypt.c	2020-06-30 18:45:22.446417000 +0200
@@ -232,12 +232,15 @@ static int pcrypt_create_aead(struct cry
 	struct crypto_attr_type *algt;
 	struct aead_instance *inst;
 	struct aead_alg *alg;
+	u32 mask;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
 		return PTR_ERR(algt);
 
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
+
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
@@ -254,7 +257,7 @@ static int pcrypt_create_aead(struct cry
 		goto err_free_inst;
 
 	err = crypto_grab_aead(&ctx->spawn, aead_crypto_instance(inst),
-			       crypto_attr_alg_name(tb[1]), 0, 0);
+			       crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 
@@ -263,7 +266,9 @@ static int pcrypt_create_aead(struct cry
 	if (err)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags =
+		CRYPTO_ALG_ASYNC |
+		(alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS);
 
 	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
 	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
Index: linux-2.6/crypto/seqiv.c
===================================================================
--- linux-2.6.orig/crypto/seqiv.c	2020-06-29 16:03:07.346417000 +0200
+++ linux-2.6/crypto/seqiv.c	2020-06-29 16:03:07.346417000 +0200
@@ -147,6 +147,8 @@ static int seqiv_aead_create(struct cryp
 	if (inst->alg.ivsize != sizeof(u64))
 		goto free_inst;
 
+	inst->alg.base.cra_flags |= CRYPTO_ALG_ALLOCATES_MEMORY;
+
 	inst->alg.encrypt = seqiv_aead_encrypt;
 	inst->alg.decrypt = seqiv_aead_decrypt;
 

