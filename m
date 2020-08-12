Return-Path: <SRS0=h4Ng=BW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFABC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 12:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6776204FD
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 12:58:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gcr9ZOny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgHLM6g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Aug 2020 08:58:36 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32564 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726722AbgHLM6f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Aug 2020 08:58:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597237113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h7/AMcJUVQBnbpy/ngyc4wn2P1evCtQ3gzW1MMHa/3g=;
        b=gcr9ZOnyU6j9H7vDIEbmIxBffjSC56/bmh7OeJJnB9FL7gU0p+xvyn4WZmD30vHI2R3mSm
        f8znriEQBrL/PfNvCGvKhJeCRVtloPNPC/g+v+J/HbWPI5OuNkfN0FprEpLYKHVgWXMMXO
        FPaL91GGeOwcbIqlp61ueC4SqUvM07A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-_LZZE9BeMs-FQ_-5UUVfcg-1; Wed, 12 Aug 2020 08:58:32 -0400
X-MC-Unique: _LZZE9BeMs-FQ_-5UUVfcg-1
Received: by mail-wm1-f69.google.com with SMTP id s4so688722wmh.1
        for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2020 05:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h7/AMcJUVQBnbpy/ngyc4wn2P1evCtQ3gzW1MMHa/3g=;
        b=n9ull9ocBsmqwIP3I6FyVOEan4qQXgxck97NBZxG4lFyxqIKfX88crjKXYFz4133HE
         UJy3YhxWOP/mDi63GST4Urvd3W6EnASPykLbjl2hxOVkUJrFpToipp8zybLl5MVcCW7p
         nNqbvdZC2NBYqRqsZjitUGTIdR7H437YvTHCbHKyj/Wr7qhxJCc3uA5ggJkVPO+hQJnJ
         VTNnx55318107DVIFt6cmj/UIeUk5rKWw+vbUoWfcwM21/ujY94fX/8dYtXy92fVmHE1
         xcS1l4Uysj8I4oOMnIWohUDhDp84QOMJmxz4qYSk1nHuhYEJM3wXl2fq8B2tLZe95qv8
         /4Hg==
X-Gm-Message-State: AOAM5322PU/NbRsyZYiinn8dj6oLgcr3EZh8i3zrijwYhBz76FZq9Onz
        +Ra7nZdUcWucMhfV5DZynhDf3n6fMQSVt+Hi63z8JTBL1Y+PxWr2fs7pzRWw4EjFDqVGlgxCbbH
        1A7MOVzwXZiAJSZHmBZbCVapG
X-Received: by 2002:a1c:2dcb:: with SMTP id t194mr8161747wmt.94.1597237110447;
        Wed, 12 Aug 2020 05:58:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwklghVO0f2OesRUcMDgJjKJp/0MsFj9CzTLzBjf+KzeXLTqCNEPcyQ968S+Xkl8PRUmp9fng==
X-Received: by 2002:a1c:2dcb:: with SMTP id t194mr8161734wmt.94.1597237110136;
        Wed, 12 Aug 2020 05:58:30 -0700 (PDT)
Received: from omos.redhat.com ([2a02:8308:b13f:2100:8a6a:ec88:3ed7:44b3])
        by smtp.gmail.com with ESMTPSA id p14sm4488436wrg.96.2020.08.12.05.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 05:58:29 -0700 (PDT)
From:   Ondrej Mosnacek <omosnace@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2] crypto: algif_aead - fix uninitialized ctx->init
Date:   Wed, 12 Aug 2020 14:58:25 +0200
Message-Id: <20200812125825.436733-1-omosnace@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In skcipher_accept_parent_nokey() the whole af_alg_ctx structure is
cleared by memset() after allocation, so add such memset() also to
aead_accept_parent_nokey() so that the new "init" field is also
initialized to zero. Without that the initial ctx->init checks might
randomly return true and cause errors.

While there, also remove the redundant zero assignments in both
functions.

Found via libkcapi testsuite.

Cc: Stephan Mueller <smueller@chronox.de>
Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when ctx->more is zero")
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---

v2:
 - intead add missing memset() to algif_aead and remove the redundant
   zero assignments (suggested by Herbert)

 crypto/algif_aead.c     | 6 ------
 crypto/algif_skcipher.c | 7 +------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index d48d2156e6210..43c6aa784858b 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -558,12 +558,6 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
 
 	INIT_LIST_HEAD(&ctx->tsgl_list);
 	ctx->len = len;
-	ctx->used = 0;
-	atomic_set(&ctx->rcvused, 0);
-	ctx->more = 0;
-	ctx->merge = 0;
-	ctx->enc = 0;
-	ctx->aead_assoclen = 0;
 	crypto_init_wait(&ctx->wait);
 
 	ask->private = ctx;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a51ba22fef58f..81c4022285a7c 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -333,6 +333,7 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
+	memset(ctx, 0, len);
 
 	ctx->iv = sock_kmalloc(sk, crypto_skcipher_ivsize(tfm),
 			       GFP_KERNEL);
@@ -340,16 +341,10 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 		sock_kfree_s(sk, ctx, len);
 		return -ENOMEM;
 	}
-
 	memset(ctx->iv, 0, crypto_skcipher_ivsize(tfm));
 
 	INIT_LIST_HEAD(&ctx->tsgl_list);
 	ctx->len = len;
-	ctx->used = 0;
-	atomic_set(&ctx->rcvused, 0);
-	ctx->more = 0;
-	ctx->merge = 0;
-	ctx->enc = 0;
 	crypto_init_wait(&ctx->wait);
 
 	ask->private = ctx;
-- 
2.26.2

