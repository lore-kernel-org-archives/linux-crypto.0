Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75866C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 01:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44DDB6500F
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 01:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhCEB5d (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 20:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhCEB5d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 20:57:33 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEE6C061574;
        Thu,  4 Mar 2021 17:57:33 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id s16so550685plr.9;
        Thu, 04 Mar 2021 17:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=a/gfEUi1TGx/uGFvjKHJAmJ/48p70i3b6PrBu0uiDH8=;
        b=TTgjvJmgbgPpOS9oC00BHC+0UhExKhAKgWLnGRwlsJCoUIXze0fUxVJJjGgMElU9+b
         ByBecrh4+GJAkVGACMK8+937UQ9g9OThfvjEB5IhUys+dDLOam7Tsa2yS+Mr5oUBsZpK
         b5FE8/BKVn3CLZQesa0uRlfHwDqJ3cP7qk+qGMmFtErGs8a1b4rQmAZn3WQNhspkaTV8
         104afembidoAsFmiebnh08Tu9dOrD4QZMGlXUj/L8gMa+690dS+yD9sB8/01+LSbpx/R
         rJrRuqrAPp4LCrkRAKxJc07OOW9dvLCmb59q21ogvtlGIIOiCDbYdV/OlH6MTn5CLHIe
         vzCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=a/gfEUi1TGx/uGFvjKHJAmJ/48p70i3b6PrBu0uiDH8=;
        b=tqXHUYlkRpplyAbxzMSIzxBZR9mZ/d6o+TFcSTl8JNuz2VqbfLEvR5pWZegQuhJ00Z
         PORI10oorid9LP4PmLuk25U3lCYO9H0KhYfX33PsyUucZytRIiWKdJwOo6EzEytdmbn8
         O73XSTFviwy0OFpUVw0l5Z9fCybQu08Z02FA14CZ5/ZCq4n0d7qXK2RX4RRsSSMUCU28
         IfMId7o9k3PkA1iEIdGVWpucPD2iIwwXOl4aSVpFQKLTbgCi4u4wUmdigEKBiEniB/Zb
         jxy77OMbxh4L8krVjo0Yv4VKhxUEeF4Zd6LlRwW8OTq4f6yddHs1l2sGiMkF87YjQPQG
         uC1Q==
X-Gm-Message-State: AOAM530YUU9+I0DLyNyOdztSWepL29cav7ZAnGE2FX3AmXr1mfReEN8g
        cstAb3p0JKRDBE6AvqfdbzY=
X-Google-Smtp-Source: ABdhPJwWgNTHIaiWh6RMrtnHdMheXZ5FBab63ta04GetaMWGSp67CWGXuUGMfIzmARwF/Qo6JlHFtw==
X-Received: by 2002:a17:902:6b88:b029:df:ff72:7bc6 with SMTP id p8-20020a1709026b88b02900dfff727bc6mr6577192plk.23.1614909452764;
        Thu, 04 Mar 2021 17:57:32 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.46])
        by smtp.gmail.com with ESMTPSA id x7sm459494pjr.7.2021.03.04.17.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 17:57:32 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     clabbe.montjoie@gmail.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, mripard@kernel.org, wens@csie.org,
        jernej.skrabec@siol.net, mchehab+huawei@kernel.org, corbet@lwn.net
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] crypto: allwinner: sun8i-ce: fix error return code in sun8i_ce_prng_generate()
Date:   Thu,  4 Mar 2021 17:57:17 -0800
Message-Id: <20210305015717.2908-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When dma_mapping_error() returns an error, no error return code of 
sun8i_ce_prng_generate() is assigned.
To fix this bug, err is assigned with -EFAULT as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
index cfde9ee4356b..cd1baee424a1 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
@@ -99,6 +99,7 @@ int sun8i_ce_prng_generate(struct crypto_rng *tfm, const u8 *src,
 	dma_iv = dma_map_single(ce->dev, ctx->seed, ctx->slen, DMA_TO_DEVICE);
 	if (dma_mapping_error(ce->dev, dma_iv)) {
 		dev_err(ce->dev, "Cannot DMA MAP IV\n");
+		err = -EFAULT;
 		goto err_iv;
 	}
 
-- 
2.17.1

