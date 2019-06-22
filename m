Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3968CC43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BE5D2084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RzKaFWEn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfFVAb4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:31:56 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34799 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfFVAb4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:31:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id w9so10135990wmd.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V8X5/ubFSdpIRa9WveOdT0HY/2abExAr4F4rR7aDxfE=;
        b=RzKaFWEnOJnOBsr5iz0AqZQj9K4SOtwFtcdFG7aU0nWBa+BTfm4JpSzY8c0LCagqre
         n/9X0nJd1SI/wD1+ZchGtq/zPRU7QjiGkR2tmvdVk+BzDpDn1uuL7dJWf3olDLoaqcdv
         UarlIbwv52qJnwr+TvdwAmhcg2DOMMbZEF2gHV/MUwVN69qqtFSuz3boQ20kikEtCwqI
         V5yXGDqOy15WBTDYXZQO1jTpXCNYoa1zn0PD7+zV+s0oO48vgY0Mlbu2ow0CNjw5AfSV
         JDGYVDpiVzwr93wNqiMlbVAoGiWBxuO+EO2XhsY/u/g2eB9J68LJa1WnE+I89nUntrxb
         lowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V8X5/ubFSdpIRa9WveOdT0HY/2abExAr4F4rR7aDxfE=;
        b=ZxJlZJJ3Q1hffvkOzNJHkTiCOSSFykiERheWn0gDtfnLiuVOv1mbZGmMUp0jfos8T7
         SXPn8C2u76fHNBPZ5UDslqjAC5KKkj0l4aTWPXfd6kllM8zvy+AC9B9dCZWy9XK+QzVN
         OxueXL+Iu/BVWXtLNXQ+o8qFO/ckY/WpQSFszygCRDoLxlsiQV55yoyAhkbvI07w+xyi
         ig7zsbcpVa9YKUNrrnKJITWW15hpaivcRKNcuRprTxJdE8r+Lo5e40JbKt9mclbXIbaq
         o0PCPp366Ggb8S8gwOODN7kISM5OhI7JgH+4hUwqgBsVn2fjD5oq2pAFHf2jHXDfZDCx
         vutw==
X-Gm-Message-State: APjAAAVKUCjWVvMSIfjChkZKKvGXICitTXtC4GKQxVQKxZNaZDzpwsrN
        p3icsYojhfOy0IUcPaw/Ik/b95qMof3yqsYG
X-Google-Smtp-Source: APXvYqyFuGoqxps1mMEd9DkejRgFQmlBxXbZ97q/pO+uFXucMpzbhGRJyU090bWEy6XWyKG3SYMGxA==
X-Received: by 2002:a1c:1a06:: with SMTP id a6mr5651678wma.128.1561163513830;
        Fri, 21 Jun 2019 17:31:53 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:53 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 09/30] crypto: ccp/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:51 +0200
Message-Id: <20190622003112.31033-10-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ccp/ccp-crypto-des3.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-des3.c b/drivers/crypto/ccp/ccp-crypto-des3.c
index 91482ffcac59..6c99abf68c0d 100644
--- a/drivers/crypto/ccp/ccp-crypto-des3.c
+++ b/drivers/crypto/ccp/ccp-crypto-des3.c
@@ -17,7 +17,7 @@
 #include <linux/crypto.h>
 #include <crypto/algapi.h>
 #include <crypto/scatterwalk.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 #include "ccp-crypto.h"
 
@@ -42,10 +42,10 @@ static int ccp_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ablkcipher_tfm(tfm));
 	struct ccp_crypto_ablkcipher_alg *alg =
 		ccp_crypto_ablkcipher_alg(crypto_ablkcipher_tfm(tfm));
-	u32 *flags = &tfm->base.crt_flags;
 	int err;
 
-	err = __des3_verify_key(flags, key);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key,
+					 key_len);
 	if (unlikely(err))
 		return err;
 
-- 
2.20.1

