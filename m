Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D4BC43466
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CCE720C56
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="bx1BdrV4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgIRHXt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgIRHXc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:23:32 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BED5C061797
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:32 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w2so4292837wmi.1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=liOvMqJ23zZD+1Jnxjs/VNAD87FK/p7rypoysOK5cqw=;
        b=bx1BdrV4GJAO799G5rMuNP1Wi9OxGF2UQxzFxqD/9SJmHlRj8nE4EHOqgVtrPyihJM
         QOZt+l2otxqb5G005pcL1V63Mlp+a5H2s3oRqllvvF/RIhHpL0m+nQd/4qVOhHAkRE+s
         tepfsQN1MM2baWw+R/ECdFJqDbrCXdEXpiDSWcF+WsenT3EGWfmPbjF498CK+4bgp2QA
         0bCOZR55FPDs2rDvR0PRzNJaT7CrmHFMXM2pSS6oavjicH/cqzPIdQdD2cCrUqHBu+AH
         xnnErBytRoKkmboXbyfhV0ytX5iB6WisFJzXwG+go83ElxVWZdBk8Bip2kUAS6DDzft1
         UZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=liOvMqJ23zZD+1Jnxjs/VNAD87FK/p7rypoysOK5cqw=;
        b=uLfcv2JUfRwGovp7ioz49M8WA5KaXkVqhGvoZMe5hyvdMkxFoPB3yg5JtIaJzCvncF
         ir5o8s87/sWYO4VqEar7MZdKOunbLSXVbskITRS2zJn7ULuu8j8P1kZE/+DeK+x8yZtJ
         C3K3UFwpx1GvFs0RPaKoNWULL8YbN+/eQsNRWy9XFe9njiRJ7johXI9sKToMuXANkOQv
         cXfPpeRJpdBjjvZ8evD2diPTVSAnUVuwZLt7XpP+/BBOpmvuTsFPfCmJXRMO+TJ2xp4B
         bU3BH9sfsj7N8lXuThUGwnTlW946W6/9nR5QiOCgn+W0S1cFigu78EqdU+KrA6DtUg78
         G+ZA==
X-Gm-Message-State: AOAM532iFNY/sW4AS7M1jWwtq9cNLRC/mMWB2sLcDa5Pbjk/RDw2eThU
        3rDyfHnQC+2o2Zbk8pNrnEZrgw==
X-Google-Smtp-Source: ABdhPJwggzaPpmO/GlnSibDjImTt0eHP9toHfxUgTG7utiNlAxM0Nt8knmdxYBJu8e0Z27YJhgO0bA==
X-Received: by 2002:a1c:5641:: with SMTP id k62mr14795715wmb.13.1600413810909;
        Fri, 18 Sep 2020 00:23:30 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id z19sm3349546wmi.3.2020.09.18.00.23.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2020 00:23:30 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 05/17] crypto: sun8i-ss: Add more comment on some structures
Date:   Fri, 18 Sep 2020 07:23:03 +0000
Message-Id: <1600413795-39256-6-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
References: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds some comment on structures used by sun8i-ss.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index da71d8059019..1a66457f4a20 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -195,6 +195,8 @@ struct sun8i_cipher_req_ctx {
  * @keylen:		len of the key
  * @ss:			pointer to the private data of driver handling this TFM
  * @fallback_tfm:	pointer to the fallback TFM
+ *
+ * enginectx must be the first element
  */
 struct sun8i_cipher_tfm_ctx {
 	struct crypto_engine_ctx enginectx;
-- 
2.26.2

