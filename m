Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184F4EB64DB
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jun 2023 17:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbjFNRrM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jun 2023 13:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239113AbjFNRq4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jun 2023 13:46:56 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B681BE9
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 10:46:54 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-30fc26affa9so2916094f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 10:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686764813; x=1689356813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Eq3cXmTlVfU7159EnlgUU5JLlIDCLN+3DHm0kLajtM=;
        b=CgAlly5McM8RcBW6caBKl8PmBgannQmzsPYLMudUMj0xOeDQH+x9Nqgs+jzENspund
         VHULCsNUqBJhqnKdbkn969JcJty7oua6hbzFSKhySd4S89t644fHDFgwFTFFoAAK9Beo
         g/Fp5DZDpKtRT71DRXlaT5aXOhfev+xF+DqJ6X5ufIT/37gdpIeWUS6XWlOSfIPU4MN0
         pMP6qBkpmS2MsqjCQkTbxSmS/85sb6A3iOPFNfEwDPiKBK9AMhPGpU05+OnH0M85v6cu
         8FU9J1IGk2YDqJUGOXqTMFA4prrzqhtQAQF286CbLczCcOkEPaYmLLeGMhhVtj8vF6wn
         ApyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686764813; x=1689356813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Eq3cXmTlVfU7159EnlgUU5JLlIDCLN+3DHm0kLajtM=;
        b=gG2gvNVog7iK3nk/qyao9h2ytYBNmYmy5Q0/Va3Btuj1oRhU/DvJ3+K7POuKle8E+1
         RHv+6gkRRhXv2h+iYPmiUiYZGXMAyrNuOG/H6O66sclWkNUFxwkSPh+4KHu8buMa5MYy
         p2ORkthKxyfcZxN+P4xzuwQpBGneOb1ZK2jWIU2TQagin7tfwpqsiyCTWDpq6AcC7YjX
         qB2URkP8WW401YXrxYhSE5Zhse3Yr8EUtwe5mjLpvtrjQctXakXAyRbmOOo4Sbkru6y+
         9CyNAl9/rhRi05bnbGfjIZfFZH1UwoXyPpF+ZOcpGlcForCoS9Z5J8tVBYSGwtqqwVgy
         l+9A==
X-Gm-Message-State: AC+VfDzkrX7HkMmw7vL/S0cLSRfcq5jcsKby2y7XaO1mV9Po2pimvjia
        eFislgEqKMUetsEa9VBdROYoOQ==
X-Google-Smtp-Source: ACHHUZ7OorwlC9ByO9iXEaGNKOvjYJ+8qfGIx80q4b1nqd9FAQZeMIJ4boZE8ucIPyG5JJY6DlNluQ==
X-Received: by 2002:a5d:528e:0:b0:30f:ccca:f482 with SMTP id c14-20020a5d528e000000b0030fcccaf482mr3786136wrv.71.1686764813289;
        Wed, 14 Jun 2023 10:46:53 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m4-20020a056000180400b0030633152664sm18738740wrh.87.2023.06.14.10.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 10:46:52 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH-next 2/3] crypto: api - Provide gfp mask for tfm allocation
Date:   Wed, 14 Jun 2023 18:46:42 +0100
Message-Id: <20230614174643.3836590-3-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230614174643.3836590-1-dima@arista.com>
References: <20230614174643.3836590-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use it straight away in crypto_clone_cipher(), as that is not meant to
sleep.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 crypto/algapi.c   | 2 +-
 crypto/api.c      | 6 +++---
 crypto/cipher.c   | 2 +-
 crypto/internal.h | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 5e7cd603d489..8d7d9cc008ff 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -798,7 +798,7 @@ struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 	if (unlikely((alg->cra_flags ^ type) & mask))
 		goto out_put_alg;
 
-	tfm = __crypto_alloc_tfm(alg, type, mask);
+	tfm = __crypto_alloc_tfm(alg, type, mask, GFP_KERNEL);
 	if (IS_ERR(tfm))
 		goto out_put_alg;
 
diff --git a/crypto/api.c b/crypto/api.c
index a94bd0695719..54bf7c71b482 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -387,14 +387,14 @@ void crypto_shoot_alg(struct crypto_alg *alg)
 EXPORT_SYMBOL_GPL(crypto_shoot_alg);
 
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
-				      u32 mask)
+				      u32 mask, gfp_t gfp)
 {
 	struct crypto_tfm *tfm = NULL;
 	unsigned int tfm_size;
 	int err = -ENOMEM;
 
 	tfm_size = sizeof(*tfm) + crypto_ctxsize(alg, type, mask);
-	tfm = kzalloc(tfm_size, GFP_KERNEL);
+	tfm = kzalloc(tfm_size, gfp);
 	if (tfm == NULL)
 		goto out_err;
 
@@ -454,7 +454,7 @@ struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask)
 			goto err;
 		}
 
-		tfm = __crypto_alloc_tfm(alg, type, mask);
+		tfm = __crypto_alloc_tfm(alg, type, mask, GFP_KERNEL);
 		if (!IS_ERR(tfm))
 			return tfm;
 
diff --git a/crypto/cipher.c b/crypto/cipher.c
index d39ef5f72ab8..184188339a4a 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -102,7 +102,7 @@ struct crypto_cipher *crypto_clone_cipher(struct crypto_cipher *cipher)
 		return ERR_PTR(-ENOSYS);
 
 	ntfm = __crypto_alloc_tfm(alg, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
+				  CRYPTO_ALG_TYPE_MASK, GFP_ATOMIC);
 	if (IS_ERR(ntfm))
 		return ERR_CAST(ntfm);
 
diff --git a/crypto/internal.h b/crypto/internal.h
index 8dd746b1130b..eba723a57689 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -103,7 +103,7 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 void crypto_remove_final(struct list_head *list);
 void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
-				      u32 mask);
+				      u32 mask, gfp_t gfp);
 void *crypto_create_tfm_node(struct crypto_alg *alg,
 			const struct crypto_type *frontend, int node);
 void *crypto_clone_tfm(const struct crypto_type *frontend,
-- 
2.40.0

