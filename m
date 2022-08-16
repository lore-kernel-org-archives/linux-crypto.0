Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD47C25B0E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 11:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbiHPL5t (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 07:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbiHPL5e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 07:57:34 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A5213E8E
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 04:37:26 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r69so8983484pgr.2
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 04:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=rSSYPTI2Wf57wn6lhKbY3EjS72ZBy6TOp30vK8NxH0U=;
        b=mnxp/X6SDX9h6z/M1zEFPWWOLXCPUNv+I5iGrOciM2A+ERoE9qKKz0HvOfw0Tv5j6Z
         mLxoyCSaLoNswAAjBjgP3aQ0BP6AdtVJcpmEruIobXT1roPZAAZ+jATVA06ksjNDA0l7
         U9CtNPJ5nvmSCffOeKYW2Znx+oSFgDQo+I1gjmNZxn9FScurNSmuxAiZ/5/ToulCp1/a
         23pO5xG/w6gfoFtxcPf9wCaoxfdSQuYp3EaCUtjvoQctHpjEtMCW3SC4bInnDIw/AZN1
         8hf83gQNqjYtN622j/wsVy5migKrsNcq+fgv2TqrNuxuO5zUR3/Ti8iJTKe6eqjJ2o1w
         h0GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=rSSYPTI2Wf57wn6lhKbY3EjS72ZBy6TOp30vK8NxH0U=;
        b=UaXHmScMbHR9Ya8ZH+/SzoEdxWtD7XZWSkxNmaFHxTNIUsNOxstxiQHK5q70x9FY+C
         2hsFtKQhux4Kt3bYvSewj53hZB8R4KfZ3L7cV/lKLZHOpsh2+vowzE4IqEKwWdREwlSG
         gm3g2FXpOLMa+CNwJAwBy1lGmNK5NIqf88c8vizz4ZLHVxIv6MjFmJsVvD82HWVziT4P
         ZUpOSd8fdjYqu+lNlFmlUG+d9Bnx9LfeGnnHkJdWsucLcAiiNpLz5bph9fQQ3sNNN3lj
         3eJ5gEMtSuDCaeMc2VW+/H67iQF/8oo/b5zTYWyKBn+PqILNtYdhlBWnxAtJK//lgL1e
         NG5w==
X-Gm-Message-State: ACgBeo2GhEq7NGh3+w5ApJkZ9t66ZJsaV+WjlB8f8l/NYRquVPjz1AZj
        wAoSeuOQAj5lmK5T8eP3shUnEfVu6/o=
X-Google-Smtp-Source: AA6agR5Ma9WCHnYPKYqIco2NpJx3KyJ95qtFOHjqPgRdTp2soLPkaWC6au2OmIWJTSnxIRYTD+lcCg==
X-Received: by 2002:aa7:954d:0:b0:52e:b22c:14a2 with SMTP id w13-20020aa7954d000000b0052eb22c14a2mr20756407pfq.45.1660649846271;
        Tue, 16 Aug 2022 04:37:26 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 72-20020a62164b000000b0052e82c7d91bsm8211929pfw.135.2022.08.16.04.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 04:37:25 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To:     davem@davemloft.net
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] crypto: api - Avoid NULL pointer dereference in crypto_larval_destroy()
Date:   Tue, 16 Aug 2022 11:37:22 +0000
Message-Id: <20220816113722.82894-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

When we have no primary larval or when it's a software node, we may end up
 in the situation when larval is a NULL pointer. There is no point to look
for secondary larval in such case. Add a necessary check to a condition.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 crypto/api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index 69508ae9345e..f2399aac831d 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -96,7 +96,7 @@ static void crypto_larval_destroy(struct crypto_alg *alg)
 	struct crypto_larval *larval = (void *)alg;
 
 	BUG_ON(!crypto_is_larval(alg));
-	if (!IS_ERR_OR_NULL(larval->adult))
+	if (larval && !IS_ERR_OR_NULL(larval->adult))
 		crypto_mod_put(larval->adult);
 	kfree(larval);
 }
-- 
2.25.1
