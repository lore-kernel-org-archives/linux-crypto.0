Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0474EB64D9
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jun 2023 17:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239281AbjFNRrM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jun 2023 13:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237458AbjFNRqy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jun 2023 13:46:54 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2A21BF0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 10:46:53 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f7fcdc7f7fso7402165e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 10:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686764812; x=1689356812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jpKktw2GOMmJzC6I0CuPo4dMIuJ2XtzOWEy+kYSxtr4=;
        b=Dyad7FZhMwfiAfRmBkixVnagPSVRz8eheSxTFkov/8nLIhmyyvSvWPizdtZw2nA6Zc
         7tpNRwPGmkfEvVsbvUwBdcmN+zSoRgfuxQ58Td9Agwejb2VIMPYeZhtQXmUERcUMJ1Jt
         yhF4MIPwGbij+iXf0/vYCmc33Kqiao8OKcfmFjWIBLixqdHLN4NZaPv45x4EQlbqzeck
         1LsiN5o8hMlVAk6WHV8GKI+JFZT/P+37GsAWAt3BBs9z94mX6BDO1bPQOi1oE88jhJoD
         9th/ZbrjOEsiIPXnJ1MrZQ/P8zsx6FUlFzHduq0Xlh+rfpVcP2kQjVAiOk3QNzOOlhWJ
         l7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686764812; x=1689356812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpKktw2GOMmJzC6I0CuPo4dMIuJ2XtzOWEy+kYSxtr4=;
        b=jbs1qDK8B+CykD077E9Z8xLmlU6xhn2nOuXROiNvg3TeGwcvOCNXgVH2j+jCDwe/IY
         jvZ6EZ4SUNGx9NMxVejzpeXah7DoN95pMY3G9gINKDA+0ZStnPmC+OSfLemH9kVyBJMx
         eGHNszkldshnTQzacmvOy2t61zd2nc4oxcDSAgbLUZrhIbXlDblgrQeF/uyTxmOPvulB
         HXUbRyPfyIxkhO+T0+lu29w4jxUvYj6juUUtJUtbCDd+d3SYTSqIa4omggyRFaw4t0wC
         xk5TBgaCCCbXz6H4n+qoflA2Cc83MrPXVPcqGEnKBSphJkehM66stTDmgKO8UA48yP3h
         YyJA==
X-Gm-Message-State: AC+VfDyJ2+dXSV0Lqs+Mtk7U+e+b0odDDXqdQnZ66ENv0Mey/ljLq/tH
        pcY6JHs5oVO+1mXB3u+/NwgtjA==
X-Google-Smtp-Source: ACHHUZ4tY7VFK/WQ07OvcIDpYAn/ug8h5uEtmcneDLElzLV6ReMtEengirK7m3oS4agXI0TCC3AT0Q==
X-Received: by 2002:a5d:4846:0:b0:30f:bde3:aa6 with SMTP id n6-20020a5d4846000000b0030fbde30aa6mr1889121wrs.15.1686764812023;
        Wed, 14 Jun 2023 10:46:52 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m4-20020a056000180400b0030633152664sm18738740wrh.87.2023.06.14.10.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 10:46:51 -0700 (PDT)
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
Subject: [PATCH-next 1/3] crypto: api - Remove crypto_init_ops()
Date:   Wed, 14 Jun 2023 18:46:41 +0100
Message-Id: <20230614174643.3836590-2-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230614174643.3836590-1-dima@arista.com>
References: <20230614174643.3836590-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Purge crypto_type::init() as well.
The last user seems to be gone with commit d63007eb954e ("crypto:
ablkcipher - remove deprecated and unused ablkcipher support").

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 crypto/api.c            | 14 --------------
 include/crypto/algapi.h |  1 -
 2 files changed, 15 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index d375e8cd770d..a94bd0695719 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -345,15 +345,6 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alg_mod_lookup);
 
-static int crypto_init_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
-{
-	const struct crypto_type *type_obj = tfm->__crt_alg->cra_type;
-
-	if (type_obj)
-		return type_obj->init(tfm, type, mask);
-	return 0;
-}
-
 static void crypto_exit_ops(struct crypto_tfm *tfm)
 {
 	const struct crypto_type *type = tfm->__crt_alg->cra_type;
@@ -410,10 +401,6 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 	tfm->__crt_alg = alg;
 	refcount_set(&tfm->refcnt, 1);
 
-	err = crypto_init_ops(tfm, type, mask);
-	if (err)
-		goto out_free_tfm;
-
 	if (!tfm->exit && alg->cra_init && (err = alg->cra_init(tfm)))
 		goto cra_init_failed;
 
@@ -421,7 +408,6 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 
 cra_init_failed:
 	crypto_exit_ops(tfm);
-out_free_tfm:
 	if (err == -EAGAIN)
 		crypto_shoot_alg(alg);
 	kfree(tfm);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 016d5a302b84..6156161b181f 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -56,7 +56,6 @@ struct sk_buff;
 struct crypto_type {
 	unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 mask);
 	unsigned int (*extsize)(struct crypto_alg *alg);
-	int (*init)(struct crypto_tfm *tfm, u32 type, u32 mask);
 	int (*init_tfm)(struct crypto_tfm *tfm);
 	void (*show)(struct seq_file *m, struct crypto_alg *alg);
 	int (*report)(struct sk_buff *skb, struct crypto_alg *alg);
-- 
2.40.0

