Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6137BEB64DC
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jun 2023 17:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239113AbjFNRrN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jun 2023 13:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239210AbjFNRq5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jun 2023 13:46:57 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCDF1FC4
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 10:46:56 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-30aeee7c8a0so5277695f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 10:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686764814; x=1689356814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FnQy3LIARieYREiW9Ccv3J1qltaXMlHsSeiVItoMb4w=;
        b=LRJDEUf43vD8BUpN2Fp0vlm+aErjd9CjmJlwiQ/YjQy6BKRuPVNQIgSNQi1+YuB+vO
         pgOyDjXLIF6vIpolxt5KmQyvKUenboC+4M2q9t6WWIoImIzBnQ8i7DwLWicSDGP+qOOy
         Fpy8n42VosWUf40ZI/JujL4mhgQTTKdwBl9m0XzkhWLfhZvgD9F/SRMB5yjGADiXhkJM
         uF1BuELXWyUsXeV/FscPUwT5Y4jfiMbLxD5exUVQFnfOj3nut/MMWqWUGXcStxT1OvJo
         BeIe1bbJf8Veu5s77lEciJ1NAMlx+dmRbZArR5Y+GL8ZMLUOlvuT+jACPNznVNIs2EQJ
         AyYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686764814; x=1689356814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FnQy3LIARieYREiW9Ccv3J1qltaXMlHsSeiVItoMb4w=;
        b=lE7UFtPFU6IWs/q9MDuB1nLKoiShDpOO2HwzBDQlKmwO1yQIvHXM/vDZcfrw1P40X/
         J6rIzsCYpjzqWbxRVJnWqucxYN7DE9PdGc2AfEHZxYQp/VjsoKQAde3tFqIozQe0GmCo
         mKE//GhGdYiSotAqDuIWr3HCFyHecpN2o89rDI+aWMrYieVyXn8CJPn1FQYBaEBUzaCE
         x2i5viLh9JX4pR6ggjdfEBxi/lr3LYKvGrM3VZRV3YIyly81GdDUf9kdR+JsnKQS5agt
         D9kviXZ3yMzy6aihi7pOUhIvmAiLTvazOHuzjhgurXrOgyc+n8iZEJnt7s9Sd47Icuav
         4vRA==
X-Gm-Message-State: AC+VfDwMUimAJhXIyX+X7S3oW+TaS+DBNvPh8GT7+jl8izfI+o1bx1W7
        0Km7zjqbuoGxEmPH6aS+GkzqSQ==
X-Google-Smtp-Source: ACHHUZ5hDdZj30AnmiktJ9+d4NQK64QDazLJ4dt8FLdh1wyoKyGo22bd6EhVI1V13Jo8Pt88JTpvXQ==
X-Received: by 2002:a5d:440c:0:b0:30f:c56c:b5a8 with SMTP id z12-20020a5d440c000000b0030fc56cb5a8mr2262496wrq.2.1686764814527;
        Wed, 14 Jun 2023 10:46:54 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m4-20020a056000180400b0030633152664sm18738740wrh.87.2023.06.14.10.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 10:46:54 -0700 (PDT)
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
Subject: [PATCH-next 3/3] crypto: cipher - On clone do crypto_mod_get()
Date:   Wed, 14 Jun 2023 18:46:43 +0100
Message-Id: <20230614174643.3836590-4-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230614174643.3836590-1-dima@arista.com>
References: <20230614174643.3836590-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The refcounter of underlying algorithm should be incremented, otherwise
it'll be destroyed with the cloned cipher, wrecking the original cipher.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 crypto/cipher.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/crypto/cipher.c b/crypto/cipher.c
index 184188339a4a..b53bf3cda826 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -101,10 +101,15 @@ struct crypto_cipher *crypto_clone_cipher(struct crypto_cipher *cipher)
 	if (alg->cra_init)
 		return ERR_PTR(-ENOSYS);
 
+	if (unlikely(!crypto_mod_get(alg)))
+		return ERR_PTR(-ESTALE);
+
 	ntfm = __crypto_alloc_tfm(alg, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK, GFP_ATOMIC);
-	if (IS_ERR(ntfm))
+	if (IS_ERR(ntfm)) {
+		crypto_mod_put(alg);
 		return ERR_CAST(ntfm);
+	}
 
 	ntfm->crt_flags = tfm->crt_flags;
 
-- 
2.40.0

