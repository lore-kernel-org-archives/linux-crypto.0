Return-Path: <SRS0=o6su=76=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECA0C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jun 2020 15:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D203D20734
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jun 2020 15:09:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EmEgiUKE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgFQPJm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jun 2020 11:09:42 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49047 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726494AbgFQPJk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jun 2020 11:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592406577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XJIjB3KluGPOS99cfWCeVFCgy7K/vHZimTMALSjV3jA=;
        b=EmEgiUKEDas4abkCI3X4TgfN7ERc7lrq9ud2wTSG9M7KCYmarHQio8n2586U4I3fgbDDcw
        oIaBYD0N59nyhK3GXTUrcTnF9dA5Jxwsm0SmSzw7cYLPAt9ZxFZju9tXpS98s2igeZDSjW
        Q16RRvokq13ISJw5QPQEvBF6iaIXFMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-Np-6jTcjOdySOK2kF0r0OA-1; Wed, 17 Jun 2020 11:09:33 -0400
X-MC-Unique: Np-6jTcjOdySOK2kF0r0OA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A44981100F7F;
        Wed, 17 Jun 2020 15:09:31 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B85BC19C71;
        Wed, 17 Jun 2020 15:09:28 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05HF9So5028895;
        Wed, 17 Jun 2020 11:09:28 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05HF9Sax028891;
        Wed, 17 Jun 2020 11:09:28 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 17 Jun 2020 11:09:28 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Eric Biggers <ebiggers@kernel.org>
cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Mike Snitzer <msnitzer@redhat.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
        George Cherian <gcherian@marvell.com>,
        Wei Xu <xuwei5@hisilicon.com>, Zaibo Xu <xuzaibo@Huawei.com>
Subject: [PATCH 1/3] crypto: pass the flag CRYPTO_ALG_ALLOCATES_MEMORY
In-Reply-To: <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com> <20200610010450.GA6449@gondor.apana.org.au> <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com> <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com> <20200616173620.GA207319@gmail.com>
 <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
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

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 crypto/adiantum.c         |    3 ++-
 crypto/authenc.c          |    5 +++--
 crypto/authencesn.c       |    5 +++--
 crypto/ccm.c              |    7 ++++---
 crypto/chacha20poly1305.c |    5 +++--
 crypto/cryptd.c           |    9 ++++++---
 crypto/ctr.c              |    3 ++-
 crypto/cts.c              |    5 +++--
 crypto/essiv.c            |    5 +++--
 crypto/gcm.c              |   15 +++++++++------
 crypto/geniv.c            |    3 ++-
 crypto/lrw.c              |    5 +++--
 crypto/rsa-pkcs1pad.c     |    5 +++--
 crypto/xts.c              |    2 +-
 include/crypto/algapi.h   |    9 +++++++++
 include/linux/crypto.h    |   11 ++++++++++-
 16 files changed, 66 insertions(+), 31 deletions(-)

Index: linux-2.6/include/linux/crypto.h
===================================================================
--- linux-2.6.orig/include/linux/crypto.h
+++ linux-2.6/include/linux/crypto.h
@@ -97,9 +97,18 @@
 #define CRYPTO_ALG_OPTIONAL_KEY		0x00004000
 
 /*
+ * The driver may allocate memory during request processing, so it shouldn't be
+ * used in cases where memory allocation failures aren't acceptable, such as
+ * during block device encryption.
+ */
+#define CRYPTO_ALG_ALLOCATES_MEMORY	0x00008000
+
+/*
  * Don't trigger module loading
  */
-#define CRYPTO_NOLOAD			0x00008000
+#define CRYPTO_NOLOAD			0x00010000
+
+#define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)
 
 /*
  * Transform masks and values (for crt_flags).
Index: linux-2.6/crypto/authenc.c
===================================================================
--- linux-2.6.orig/crypto/authenc.c
+++ linux-2.6/crypto/authenc.c
@@ -388,7 +388,8 @@ static int crypto_authenc_create(struct
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+	       crypto_requires_nomem(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -424,7 +425,7 @@ static int crypto_authenc_create(struct
 		goto err_free_inst;
 
 	inst->alg.base.cra_flags = (auth_base->cra_flags |
-				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
+			enc->base.cra_flags) & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = enc->base.cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->base.cra_blocksize;
Index: linux-2.6/crypto/authencesn.c
===================================================================
--- linux-2.6.orig/crypto/authencesn.c
+++ linux-2.6/crypto/authencesn.c
@@ -406,7 +406,8 @@ static int crypto_authenc_esn_create(str
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+	       crypto_requires_nomem(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -438,7 +439,7 @@ static int crypto_authenc_esn_create(str
 		goto err_free_inst;
 
 	inst->alg.base.cra_flags = (auth_base->cra_flags |
-				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
+			enc->base.cra_flags) & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = enc->base.cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->base.cra_blocksize;
Index: linux-2.6/crypto/ccm.c
===================================================================
--- linux-2.6.orig/crypto/ccm.c
+++ linux-2.6/crypto/ccm.c
@@ -462,7 +462,8 @@ static int crypto_ccm_create_common(stru
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+	       crypto_requires_nomem(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
 	if (!inst)
@@ -507,7 +508,7 @@ static int crypto_ccm_create_common(stru
 		     mac->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = ctr->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = ctr->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = (mac->base.cra_priority +
 				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
@@ -759,7 +760,7 @@ static int crypto_rfc4309_create(struct
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
Index: linux-2.6/crypto/chacha20poly1305.c
===================================================================
--- linux-2.6.orig/crypto/chacha20poly1305.c
+++ linux-2.6/crypto/chacha20poly1305.c
@@ -573,7 +573,8 @@ static int chachapoly_create(struct cryp
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+	       crypto_requires_nomem(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -614,7 +615,7 @@ static int chachapoly_create(struct cryp
 		goto err_free_inst;
 
 	inst->alg.base.cra_flags = (chacha->base.cra_flags |
-				    poly->base.cra_flags) & CRYPTO_ALG_ASYNC;
+			poly->base.cra_flags) & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = (chacha->base.cra_priority +
 				       poly->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
Index: linux-2.6/crypto/cryptd.c
===================================================================
--- linux-2.6.orig/crypto/cryptd.c
+++ linux-2.6/crypto/cryptd.c
@@ -396,7 +396,8 @@ static int cryptd_create_skcipher(struct
 		goto err_free_inst;
 
 	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
-				   (alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
+			(alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS) |
+			(alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
 
 	inst->alg.ivsize = crypto_skcipher_alg_ivsize(alg);
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
@@ -663,7 +664,8 @@ static int cryptd_create_hash(struct cry
 
 	inst->alg.halg.base.cra_flags = CRYPTO_ALG_ASYNC |
 		(alg->base.cra_flags & (CRYPTO_ALG_INTERNAL |
-					CRYPTO_ALG_OPTIONAL_KEY));
+					CRYPTO_ALG_OPTIONAL_KEY |
+					CRYPTO_ALG_INHERITED_FLAGS));
 
 	inst->alg.halg.digestsize = alg->digestsize;
 	inst->alg.halg.statesize = alg->statesize;
@@ -849,7 +851,8 @@ static int cryptd_create_aead(struct cry
 		goto err_free_inst;
 
 	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
-				   (alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
+			(alg->base.cra_flags & CRYPTO_ALG_INTERNAL) |
+			(alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS);
 	inst->alg.base.cra_ctxsize = sizeof(struct cryptd_aead_ctx);
 
 	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
Index: linux-2.6/crypto/ctr.c
===================================================================
--- linux-2.6.orig/crypto/ctr.c
+++ linux-2.6/crypto/ctr.c
@@ -276,6 +276,7 @@ static int crypto_rfc3686_create(struct
 		return -ENOMEM;
 
 	mask = crypto_requires_sync(algt->type, algt->mask) |
+		crypto_requires_nomem(algt->type, algt->mask) |
 		crypto_requires_off(algt->type, algt->mask,
 				    CRYPTO_ALG_NEED_FALLBACK);
 
@@ -310,7 +311,7 @@ static int crypto_rfc3686_create(struct
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 
 	inst->alg.ivsize = CTR_RFC3686_IV_SIZE;
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
Index: linux-2.6/crypto/cts.c
===================================================================
--- linux-2.6.orig/crypto/cts.c
+++ linux-2.6/crypto/cts.c
@@ -337,7 +337,8 @@ static int crypto_cts_create(struct cryp
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+	       crypto_requires_nomem(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -364,7 +365,7 @@ static int crypto_cts_create(struct cryp
 	if (err)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
Index: linux-2.6/crypto/essiv.c
===================================================================
--- linux-2.6.orig/crypto/essiv.c
+++ linux-2.6/crypto/essiv.c
@@ -468,7 +468,8 @@ static int essiv_create(struct crypto_te
 		return PTR_ERR(shash_name);
 
 	type = algt->type & algt->mask;
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+	       crypto_requires_nomem(algt->type, algt->mask);
 
 	switch (type) {
 	case CRYPTO_ALG_TYPE_SKCIPHER:
@@ -559,7 +560,7 @@ static int essiv_create(struct crypto_te
 		     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto out_free_hash;
 
-	base->cra_flags		= block_base->cra_flags & CRYPTO_ALG_ASYNC;
+	base->cra_flags		= block_base->cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	base->cra_blocksize	= block_base->cra_blocksize;
 	base->cra_ctxsize	= sizeof(struct essiv_tfm_ctx);
 	base->cra_alignmask	= block_base->cra_alignmask;
Index: linux-2.6/crypto/gcm.c
===================================================================
--- linux-2.6.orig/crypto/gcm.c
+++ linux-2.6/crypto/gcm.c
@@ -593,7 +593,8 @@ static int crypto_gcm_create_common(stru
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+	       crypto_requires_nomem(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -636,7 +637,7 @@ static int crypto_gcm_create_common(stru
 		goto err_free_inst;
 
 	inst->alg.base.cra_flags = (ghash->base.cra_flags |
-				    ctr->base.cra_flags) & CRYPTO_ALG_ASYNC;
+			ctr->base.cra_flags) & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = (ghash->base.cra_priority +
 				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
@@ -849,7 +850,8 @@ static int crypto_rfc4106_create(struct
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+	       crypto_requires_nomem(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -882,7 +884,7 @@ static int crypto_rfc4106_create(struct
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
@@ -1071,7 +1073,8 @@ static int crypto_rfc4543_create(struct
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+	       crypto_requires_nomem(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -1104,7 +1107,7 @@ static int crypto_rfc4543_create(struct
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
Index: linux-2.6/crypto/geniv.c
===================================================================
--- linux-2.6.orig/crypto/geniv.c
+++ linux-2.6/crypto/geniv.c
@@ -64,6 +64,7 @@ struct aead_instance *aead_geniv_alloc(s
 
 	/* Ignore async algorithms if necessary. */
 	mask |= crypto_requires_sync(algt->type, algt->mask);
+	mask |= crypto_requires_nomem(algt->type, algt->mask);
 
 	err = crypto_grab_aead(spawn, aead_crypto_instance(inst),
 			       crypto_attr_alg_name(tb[1]), type, mask);
@@ -89,7 +90,7 @@ struct aead_instance *aead_geniv_alloc(s
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
Index: linux-2.6/crypto/lrw.c
===================================================================
--- linux-2.6.orig/crypto/lrw.c
+++ linux-2.6/crypto/lrw.c
@@ -311,7 +311,8 @@ static int create(struct crypto_template
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+	       crypto_requires_nomem(algt->type, algt->mask);
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
@@ -379,7 +380,7 @@ static int create(struct crypto_template
 	} else
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = LRW_BLOCK_SIZE;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
Index: linux-2.6/crypto/rsa-pkcs1pad.c
===================================================================
--- linux-2.6.orig/crypto/rsa-pkcs1pad.c
+++ linux-2.6/crypto/rsa-pkcs1pad.c
@@ -611,7 +611,8 @@ static int pkcs1pad_create(struct crypto
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+	       crypto_requires_nomem(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -658,7 +659,7 @@ static int pkcs1pad_create(struct crypto
 			goto err_free_inst;
 	}
 
-	inst->alg.base.cra_flags = rsa_alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = rsa_alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = rsa_alg->base.cra_priority;
 	inst->alg.base.cra_ctxsize = sizeof(struct pkcs1pad_ctx);
 
Index: linux-2.6/crypto/xts.c
===================================================================
--- linux-2.6.orig/crypto/xts.c
+++ linux-2.6/crypto/xts.c
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
--- linux-2.6.orig/include/crypto/algapi.h
+++ linux-2.6/include/crypto/algapi.h
@@ -247,6 +247,15 @@ static inline int crypto_requires_sync(u
 	return crypto_requires_off(type, mask, CRYPTO_ALG_ASYNC);
 }
 
+/*
+ * Returns CRYPTO_ALG_ALLOCATES_MEMORY if type/mask requires the use of drivers
+ * that don't allocate memory. Otherwise returns zero.
+ */
+static inline int crypto_requires_nomem(u32 type, u32 mask)
+{
+	return crypto_requires_off(type, mask, CRYPTO_ALG_ALLOCATES_MEMORY);
+}
+
 noinline unsigned long __crypto_memneq(const void *a, const void *b, size_t size);
 
 /**
Index: linux-2.6/crypto/adiantum.c
===================================================================
--- linux-2.6.orig/crypto/adiantum.c
+++ linux-2.6/crypto/adiantum.c
@@ -507,7 +507,8 @@ static int adiantum_create(struct crypto
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_sync(algt->type, algt->mask) |
+	       crypto_requires_nomem(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
 	if (!inst)

