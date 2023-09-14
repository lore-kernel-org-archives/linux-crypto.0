Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A436EDE98F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 08:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236405AbjINI2w (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 04:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236482AbjINI2h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 04:28:37 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557091FDF
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:33 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1c3bd829b86so5657565ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694680112; x=1695284912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5wsrFzDnYNpX/WAtiyiXQo2OYmq81oAKpg2275TX5w=;
        b=GW5moggkbaRkNMdaIPVCQT4dlCNFrb8TEx2xgCJmfHwNi1a7AuOkvSAp2UxkMO7381
         reghtz0F9554E3QINPyE/sgva2XnK+jpMmQCvY4ztoEw4MDB4V7eYM37TvInKFaiLmCO
         k8cLVId7a1v9O1MEPzUdbXRH0xKLoKwA2yK4Yqom0Q2e3pRtGa4W3FeToKbSbhG/+jxm
         Tyy5HVUEeS8XY0Ji9o7EJQsPjdop8OCmj72P366LijE5PMTEtDLvmL6Ky7m30UrZHw9D
         n6cb5UrTqUJiY+jg5fiF8Qawiu0LGgkldJwzvNFBplw78iZLym7nj2zmIoMjxrYe5NXT
         Z3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694680112; x=1695284912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b5wsrFzDnYNpX/WAtiyiXQo2OYmq81oAKpg2275TX5w=;
        b=cnvK0eQ3nifG89+DWYMiz5pVed1Nczm7lY1qhgSVs2iMvadsvevOMqQCmvz9cxuQi3
         T3Dy6dJXrjdqSlRc+14RMOOL2+4w9KespedmLxRBzjbbrKwUiON3P41QNeZSfILddSwN
         mLM1Gsnsz+kTOuoJlCZFZ9FrAPMTlfx+BdABqhQYkSRMDZR48uvA8Ir+1DyHEknDeVfB
         Xg/hygnsq+XoFRpGmsiXpEFvzW/CeYSS0pvREUozJLJlox9be5C37g7Qex6c5w2N2SgB
         uhlWeDEVc1npRmXeV3rTwEPNvqy5boxQQNZH2h92B4ymAeVNC7x+qDjPcAjl14FqCjzX
         uxNA==
X-Gm-Message-State: AOJu0Ywk9eJDaNXiQkmGGHo3npUmCi3cig3IqcmMOgXxxDj9IzLtLneX
        p8p2Ah/oLJHAlHmhN3u71igRihtXdhc=
X-Google-Smtp-Source: AGHT+IGJWqqzryMIkArt8eA+hwwaqCHgWkhTCeKvJOzcYV0TcpvzjKToQTQHqR9vWBd/RYCaHN6JZQ==
X-Received: by 2002:a17:902:a418:b0:1c0:aa07:1792 with SMTP id p24-20020a170902a41800b001c0aa071792mr4463171plq.36.1694680112456;
        Thu, 14 Sep 2023 01:28:32 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b001bba3a4888bsm976242plg.102.2023.09.14.01.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 01:28:32 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 3/8] crypto: hash - Hide CRYPTO_ALG_TYPE_AHASH_MASK
Date:   Thu, 14 Sep 2023 16:28:23 +0800
Message-Id: <20230914082828.895403-4-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230914082828.895403-1-herbert@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move the macro CRYPTO_ALG_TYPE_AHASH_MASK out of linux/crypto.h
and into crypto/ahash.c so that it's not visible to users of the
Crypto API.

Also remove the unused CRYPTO_ALG_TYPE_HASH_MASK macro.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c         | 2 ++
 include/linux/crypto.h | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 709ef0940799..213bb3e9f245 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -21,6 +21,8 @@
 
 #include "hash.h"
 
+#define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
+
 static const struct crypto_type crypto_ahash_type;
 
 struct ahash_request_priv {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 31f6fee0c36c..a0780deb017a 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -35,8 +35,6 @@
 #define CRYPTO_ALG_TYPE_SHASH		0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000f
 
-#define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
-#define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_ACOMPRESS_MASK	0x0000000e
 
 #define CRYPTO_ALG_LARVAL		0x00000010
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

