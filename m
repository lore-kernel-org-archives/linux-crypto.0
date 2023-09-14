Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD41EEDE994
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 08:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbjINI2u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 04:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbjINI2g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 04:28:36 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B5E1FD9
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:32 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-5774b3de210so512099a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694680111; x=1695284911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wqi+NuwsYIx4ELvz9MrnCIei/niqfV1tNLHt9gSq9Lg=;
        b=iXVEu7uhUaQQShd8WAuPQg5R6cbi0YlhmpqkEfbqyPtSl41raP8r44BICZjPvy/IvU
         Rlr+HOobcnr7CbyVYZi0QTebbPn9sjTVFTeTunqqT4a/rG0garrx5oWeriU1tv8hlah/
         IMbATdV5aZVBIzeRfGSwo8BdkPMK/72voAZ3g4qQqjyFPmjiHgQ2FWzgE9OmbO+b/ehR
         eR+ejsM+/PUA6CFQI3qHhzeQSYBfomgsT1Bp9UMLwGJv9HDuwu3UL2puYI5zq4NdPia9
         aeW85n9JnQzTyDQGObg+PQa6r/gtj1plLiludQeTNY91T8yjfyJ7XWHDOUzb7jMYVWQL
         x4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694680111; x=1695284911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wqi+NuwsYIx4ELvz9MrnCIei/niqfV1tNLHt9gSq9Lg=;
        b=RUQnVSMCxtzprjxPbxBmLunYLZ7jmGwy08kyDJqw0+u/Kb9i6+JQtQOtafOR5FWtA9
         G2ZgNB4HW3T4HAlf+3ZkQkMPVA6oFxot8WH6axl4PWQsplCL7HVsLS2FzRBRhfnkCkUG
         pLpLlYf4X/rY+QAiPl9dckG+imp0+g5Kewvytw+KKhHPhu1qBremUQSxQxpDr1/3JQL+
         XNMSWrDzk1julG6AtJcvddimt/yPk8ktIwW91Y2cU4uyLwFJm2/ywvxAU0N64Beswn5L
         Wz8VhHKfz/WzHaqXffLSrkoK7nisA9u0pO+IGJuP5XqUMf00gJPDpKaB43ShR2mSotnx
         1hFQ==
X-Gm-Message-State: AOJu0YzQi21yOLMDU4uPEt+5Uck8HKdlXYXghPqg2OnCNQSEGPESZMFN
        vEar0urLOkS44VJAtSmQgQyXt00TiMk=
X-Google-Smtp-Source: AGHT+IGc3SAHfD9Ho+bp46T8HT9GRvSo6alchksbpAWDWQvBTXxD6X8hFeOWxEnMJaMw6sj+rK7HoA==
X-Received: by 2002:a05:6a21:4988:b0:151:991c:84b6 with SMTP id ax8-20020a056a21498800b00151991c84b6mr4283566pzc.59.1694680111166;
        Thu, 14 Sep 2023 01:28:31 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b001bba3a4888bsm976242plg.102.2023.09.14.01.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 01:28:30 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/8] ipsec: Stop using crypto_has_alg
Date:   Thu, 14 Sep 2023 16:28:22 +0800
Message-Id: <20230914082828.895403-3-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230914082828.895403-1-herbert@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Stop using the obsolete crypto_has_alg helper that is type-agnostic.
Instead use the type-specific helpers such as the newly added
crypto_has_aead.

This means that changes in the underlying type/mask values won't
affect IPsec.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 net/xfrm/xfrm_algo.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 094734fbec96..41533c631431 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  */
 
+#include <crypto/aead.h>
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
 #include <linux/module.h>
@@ -644,38 +645,33 @@ static inline int calg_entries(void)
 }
 
 struct xfrm_algo_list {
+	int (*find)(const char *name, u32 type, u32 mask);
 	struct xfrm_algo_desc *algs;
 	int entries;
-	u32 type;
-	u32 mask;
 };
 
 static const struct xfrm_algo_list xfrm_aead_list = {
+	.find = crypto_has_aead,
 	.algs = aead_list,
 	.entries = ARRAY_SIZE(aead_list),
-	.type = CRYPTO_ALG_TYPE_AEAD,
-	.mask = CRYPTO_ALG_TYPE_MASK,
 };
 
 static const struct xfrm_algo_list xfrm_aalg_list = {
+	.find = crypto_has_ahash,
 	.algs = aalg_list,
 	.entries = ARRAY_SIZE(aalg_list),
-	.type = CRYPTO_ALG_TYPE_HASH,
-	.mask = CRYPTO_ALG_TYPE_HASH_MASK,
 };
 
 static const struct xfrm_algo_list xfrm_ealg_list = {
+	.find = crypto_has_skcipher,
 	.algs = ealg_list,
 	.entries = ARRAY_SIZE(ealg_list),
-	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-	.mask = CRYPTO_ALG_TYPE_MASK,
 };
 
 static const struct xfrm_algo_list xfrm_calg_list = {
+	.find = crypto_has_comp,
 	.algs = calg_list,
 	.entries = ARRAY_SIZE(calg_list),
-	.type = CRYPTO_ALG_TYPE_COMPRESS,
-	.mask = CRYPTO_ALG_TYPE_MASK,
 };
 
 static struct xfrm_algo_desc *xfrm_find_algo(
@@ -696,8 +692,7 @@ static struct xfrm_algo_desc *xfrm_find_algo(
 		if (!probe)
 			break;
 
-		status = crypto_has_alg(list[i].name, algo_list->type,
-					algo_list->mask);
+		status = algo_list->find(list[i].name, 0, 0);
 		if (!status)
 			break;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

