Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A557FC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 802E164DBA
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235558AbhBDLSE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235712AbhBDLMQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 06:12:16 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58561C061223
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 03:10:21 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o10so5705546wmc.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 03:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uyplMPucg3iOrY2nniY7G/Evy8Npfc2vFaJnW0PI2LM=;
        b=ekSQxHuxk0xtv21ZbQcl2ycKHt8Ml1KkajwaP+MZ+rkIEOSQZN9fbTd68tzTYsXJQ9
         +rQ0llJvLZ8qiSdH/lZPKwZNHsU3cdD+iyEO0eNGKU4JOpzZwnGJJaZ+DDtr5MH6ZZX/
         S8d31UtxU4seUHnrcDhWzqwl0aZcR6YZVZV7M+IvYbDsaRwSgiB987TrWAqzH7pmJVfA
         MfI8emBtsqNE+bdcIo9IVdA0IRz3IANyq3P5wIJHyCQdfz35SGGo6ttWiPDa2cQ7EV8x
         iiYDsDd5ifoCTI86AVcyAe31nuMsbq60tYKq9eTidpAbJ0pDdOS207XZUJ6SjA36ko+4
         eg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uyplMPucg3iOrY2nniY7G/Evy8Npfc2vFaJnW0PI2LM=;
        b=eQnmpYXj2ziLaaNmbAzwpjM+E86VPlAizGLOvAT9srHe9mwGjMJl7YyXhb2uOc2qZw
         bXwPRuEOVPJSxE1vjlYOPyvSzA55EB7SItPSdb+kaHVEjsynCcKoZZNewdR68ySjpopV
         l2AHBL5L9YtpPMIYXAJVSEyry/oscepLVUh9lHsiRnHjja6LwKMNqPurK8z8TnK4JPEc
         sIbxyIJFX8wg2OZXBOT9hPCSa1hKJvP8zmlxE4ArYk0DHLKDqhLJ30rwPrgd766NmtJd
         9Pyihe3lH1UAPe27jQlJzmvIOoW75xrrP6lMY2fyGzJQY3EmFxMqBmgbn9KxSzwDgyl7
         CAAw==
X-Gm-Message-State: AOAM532Pp6y25qEKe5I1zui5S5a4TiBloPJjEpgXJyH+wMZeTjlD3mdv
        Ixl8I5rJ9GKjK4cSrtaVzvrXFw==
X-Google-Smtp-Source: ABdhPJy1JNJu3m4t+MVtGxQYZO5Rm/NID114zcurjbrW+Yzs0lZ8GlMJ8K6ULDLLoxf2mMqmiHtcWQ==
X-Received: by 2002:a1c:720d:: with SMTP id n13mr6860166wmc.103.1612437019961;
        Thu, 04 Feb 2021 03:10:19 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id y18sm7696218wrt.19.2021.02.04.03.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 03:10:19 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 14/20] crypto: caam: caampkc: Provide the name of the function
Date:   Thu,  4 Feb 2021 11:09:54 +0000
Message-Id: <20210204111000.2800436-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204111000.2800436-1-lee.jones@linaro.org>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/caam/caampkc.c:199: warning: expecting prototype for from a given scatterlist(). Prototype was for caam_rsa_count_leading_zeros() instead

Cc: "Horia Geantă" <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/caam/caampkc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index dd5f101e43f83..e313233ec6de7 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -187,7 +187,8 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 }
 
 /**
- * Count leading zeros, need it to strip, from a given scatterlist
+ * caam_rsa_count_leading_zeros - Count leading zeros, need it to strip,
+ *                                from a given scatterlist
  *
  * @sgl   : scatterlist to count zeros from
  * @nbytes: number of zeros, in bytes, to strip
-- 
2.25.1

