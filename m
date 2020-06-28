Return-Path: <SRS0=vlpe=AJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F22C433DF
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jun 2020 19:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AC33206C0
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jun 2020 19:06:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BuI8pwKM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgF1TGB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Jun 2020 15:06:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58762 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726585AbgF1TGB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Jun 2020 15:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593371158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FByjgnRDooBHKFtRzVeZOLTLB8Hlwx3m501tDUzjdwQ=;
        b=BuI8pwKMFcR8TQta8VcdPCpV1oABhID398v9B89KDGxfA8ZI4UdxRqVkrmLqvUhbRVtJ3r
        gG5uLvdPHjZUIGRJl1PW+bkH94vsC9p5ScMRJOjZm/ldTDHdHWEX23yWCh+eD0e810ImEf
        Gq6TFo9GmA5lFaq91lbb962QZIEsN/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36---eEAd9TPXOjUhh7IN9NKA-1; Sun, 28 Jun 2020 15:05:56 -0400
X-MC-Unique: --eEAd9TPXOjUhh7IN9NKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B31C8015F4;
        Sun, 28 Jun 2020 19:05:55 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AABD90345;
        Sun, 28 Jun 2020 19:05:51 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05SJ5oWJ003634;
        Sun, 28 Jun 2020 15:05:50 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05SJ5oUo003630;
        Sun, 28 Jun 2020 15:05:50 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Sun, 28 Jun 2020 15:05:50 -0400 (EDT)
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
Subject: [PATCH 1/3 v3] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
In-Reply-To: <20200626164617.GA211634@gmail.com>
Message-ID: <alpine.LRH.2.02.2006281505250.347@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com> <20200610121106.GA23137@gondor.apana.org.au> <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616173620.GA207319@gmail.com> <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com> <20200626044534.GA2870@gondor.apana.org.au>
 <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com> <20200626164617.GA211634@gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 crypto/adiantum.c         |    2 +-
 crypto/authenc.c          |    4 ++--
 crypto/authencesn.c       |    4 ++--
 crypto/ccm.c              |    9 +++++----
 crypto/chacha20poly1305.c |    4 ++--
 crypto/cryptd.c           |   12 +++++++++---
 crypto/ctr.c              |    4 ++--
 crypto/cts.c              |    4 ++--
 crypto/essiv.c            |    4 ++--
 crypto/gcm.c              |   12 ++++++------
 crypto/geniv.c            |    4 ++--
 crypto/lrw.c              |    4 ++--
 crypto/pcrypt.c           |    4 +++-
 crypto/rsa-pkcs1pad.c     |    4 ++--
 crypto/xts.c              |    2 +-
 include/crypto/algapi.h   |   10 ++++++----
 include/linux/crypto.h    |   15 +++++++++++++++
 17 files changed, 64 insertions(+), 38 deletions(-)

Index: linux-2.6/include/linux/crypto.h
===================================================================
--- linux-2.6.orig/include/linux/crypto.h	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/include/linux/crypto.h	2020-06-28 17:55:21.976417000 +0200
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
--- linux-2.6.orig/crypto/authenc.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/authenc.c	2020-06-28 20:33:29.136417000 +0200
@@ -388,7 +388,7 @@ static int crypto_authenc_create(struct
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_inherited(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -424,7 +424,7 @@ static int crypto_authenc_create(struct
 		goto err_free_inst;
 
 	inst->alg.base.cra_flags = (auth_base->cra_flags |
-				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
+			enc->base.cra_flags) & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = enc->base.cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->base.cra_blocksize;
Index: linux-2.6/crypto/authencesn.c
===================================================================
--- linux-2.6.orig/crypto/authencesn.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/authencesn.c	2020-06-28 20:33:32.556417000 +0200
@@ -406,7 +406,7 @@ static int crypto_authenc_esn_create(str
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_inherited(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -438,7 +438,7 @@ static int crypto_authenc_esn_create(str
 		goto err_free_inst;
 
 	inst->alg.base.cra_flags = (auth_base->cra_flags |
-				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
+			enc->base.cra_flags) & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = enc->base.cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->base.cra_blocksize;
Index: linux-2.6/crypto/ccm.c
===================================================================
--- linux-2.6.orig/crypto/ccm.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/ccm.c	2020-06-28 20:43:42.456417000 +0200
@@ -462,7 +462,7 @@ static int crypto_ccm_create_common(stru
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_inherited(algt->type, algt->mask);
 
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
+	mask = crypto_requires_inherited(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -759,7 +759,8 @@ static int crypto_rfc4309_create(struct
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = CRYPTO_ALG_ALLOCATES_MEMORY |
+			(alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS);
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
Index: linux-2.6/crypto/chacha20poly1305.c
===================================================================
--- linux-2.6.orig/crypto/chacha20poly1305.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/chacha20poly1305.c	2020-06-28 20:31:34.036417000 +0200
@@ -573,7 +573,7 @@ static int chachapoly_create(struct cryp
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_inherited(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -614,7 +614,7 @@ static int chachapoly_create(struct cryp
 		goto err_free_inst;
 
 	inst->alg.base.cra_flags = (chacha->base.cra_flags |
-				    poly->base.cra_flags) & CRYPTO_ALG_ASYNC;
+			poly->base.cra_flags) & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = (chacha->base.cra_priority +
 				       poly->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
Index: linux-2.6/crypto/cryptd.c
===================================================================
--- linux-2.6.orig/crypto/cryptd.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/cryptd.c	2020-06-28 20:42:42.246417000 +0200
@@ -396,7 +396,9 @@ static int cryptd_create_skcipher(struct
 		goto err_free_inst;
 
 	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
-				   (alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
+			CRYPTO_ALG_ALLOCATES_MEMORY |
+			(alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS) |
+			(alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
 
 	inst->alg.ivsize = crypto_skcipher_alg_ivsize(alg);
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
@@ -662,8 +664,10 @@ static int cryptd_create_hash(struct cry
 		goto err_free_inst;
 
 	inst->alg.halg.base.cra_flags = CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_ALLOCATES_MEMORY |
 		(alg->base.cra_flags & (CRYPTO_ALG_INTERNAL |
-					CRYPTO_ALG_OPTIONAL_KEY));
+					CRYPTO_ALG_OPTIONAL_KEY |
+					CRYPTO_ALG_INHERITED_FLAGS));
 
 	inst->alg.halg.digestsize = alg->digestsize;
 	inst->alg.halg.statesize = alg->statesize;
@@ -849,7 +853,9 @@ static int cryptd_create_aead(struct cry
 		goto err_free_inst;
 
 	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
-				   (alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
+			CRYPTO_ALG_ALLOCATES_MEMORY |
+			(alg->base.cra_flags & CRYPTO_ALG_INTERNAL) |
+			(alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS);
 	inst->alg.base.cra_ctxsize = sizeof(struct cryptd_aead_ctx);
 
 	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
Index: linux-2.6/crypto/ctr.c
===================================================================
--- linux-2.6.orig/crypto/ctr.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/ctr.c	2020-06-28 20:32:19.326417000 +0200
@@ -275,7 +275,7 @@ static int crypto_rfc3686_create(struct
 	if (!inst)
 		return -ENOMEM;
 
-	mask = crypto_requires_sync(algt->type, algt->mask) |
+	mask = crypto_requires_inherited(algt->type, algt->mask) |
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
--- linux-2.6.orig/crypto/cts.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/cts.c	2020-06-28 20:33:16.076417000 +0200
@@ -337,7 +337,7 @@ static int crypto_cts_create(struct cryp
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_inherited(algt->type, algt->mask);
 
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
--- linux-2.6.orig/crypto/essiv.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/essiv.c	2020-06-28 20:32:36.206417000 +0200
@@ -466,7 +466,7 @@ static int essiv_create(struct crypto_te
 		return PTR_ERR(shash_name);
 
 	type = algt->type & algt->mask;
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_inherited(algt->type, algt->mask);
 
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
--- linux-2.6.orig/crypto/gcm.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/gcm.c	2020-06-28 20:34:48.526417000 +0200
@@ -593,7 +593,7 @@ static int crypto_gcm_create_common(stru
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_inherited(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -636,7 +636,7 @@ static int crypto_gcm_create_common(stru
 		goto err_free_inst;
 
 	inst->alg.base.cra_flags = (ghash->base.cra_flags |
-				    ctr->base.cra_flags) & CRYPTO_ALG_ASYNC;
+			ctr->base.cra_flags) & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = (ghash->base.cra_priority +
 				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
@@ -849,7 +849,7 @@ static int crypto_rfc4106_create(struct
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_inherited(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
@@ -882,7 +882,7 @@ static int crypto_rfc4106_create(struct
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
@@ -1071,7 +1071,7 @@ static int crypto_rfc4543_create(struct
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_inherited(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -1104,7 +1104,7 @@ static int crypto_rfc4543_create(struct
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
Index: linux-2.6/crypto/geniv.c
===================================================================
--- linux-2.6.orig/crypto/geniv.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/geniv.c	2020-06-28 20:33:05.206417000 +0200
@@ -63,7 +63,7 @@ struct aead_instance *aead_geniv_alloc(s
 	spawn = aead_instance_ctx(inst);
 
 	/* Ignore async algorithms if necessary. */
-	mask |= crypto_requires_sync(algt->type, algt->mask);
+	mask |= crypto_requires_inherited(algt->type, algt->mask);
 
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
--- linux-2.6.orig/crypto/lrw.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/lrw.c	2020-06-28 20:31:40.686417000 +0200
@@ -311,7 +311,7 @@ static int create(struct crypto_template
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_inherited(algt->type, algt->mask);
 
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
--- linux-2.6.orig/crypto/rsa-pkcs1pad.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/rsa-pkcs1pad.c	2020-06-28 20:33:47.686417000 +0200
@@ -611,7 +611,7 @@ static int pkcs1pad_create(struct crypto
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_inherited(algt->type, algt->mask);
 
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
--- linux-2.6.orig/crypto/xts.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/xts.c	2020-06-26 17:24:03.566417000 +0200
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
--- linux-2.6.orig/include/crypto/algapi.h	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/include/crypto/algapi.h	2020-06-28 20:37:40.956417000 +0200
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
+static inline int crypto_requires_inherited(u32 type, u32 mask)
 {
-	return crypto_requires_off(type, mask, CRYPTO_ALG_ASYNC);
+	return crypto_requires_off(type, mask, CRYPTO_ALG_INHERITED_FLAGS);
 }
 
 noinline unsigned long __crypto_memneq(const void *a, const void *b, size_t size);
Index: linux-2.6/crypto/adiantum.c
===================================================================
--- linux-2.6.orig/crypto/adiantum.c	2020-06-26 17:24:03.566417000 +0200
+++ linux-2.6/crypto/adiantum.c	2020-06-28 20:31:46.616417000 +0200
@@ -507,7 +507,7 @@ static int adiantum_create(struct crypto
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
-	mask = crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_inherited(algt->type, algt->mask);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
 	if (!inst)
Index: linux-2.6/crypto/pcrypt.c
===================================================================
--- linux-2.6.orig/crypto/pcrypt.c	2020-04-06 19:39:51.559996000 +0200
+++ linux-2.6/crypto/pcrypt.c	2020-06-28 20:44:39.066417000 +0200
@@ -263,7 +263,9 @@ static int pcrypt_create_aead(struct cry
 	if (err)
 		goto err_free_inst;
 
-	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_ALLOCATES_MEMORY |
+				(alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS);
 
 	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
 	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);

