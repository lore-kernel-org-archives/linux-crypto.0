Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09C5C4361A
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 796BD64FDD
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344113AbhCDAHW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243833AbhCCOhu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 09:37:50 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09C5C061A27
        for <linux-crypto@vger.kernel.org>; Wed,  3 Mar 2021 06:35:05 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id j2so11074921wrx.9
        for <linux-crypto@vger.kernel.org>; Wed, 03 Mar 2021 06:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=51h0lVd1c7+OEvoO2UQG6dIvRRvCEl0n5KWV8010Ypo=;
        b=GkxKVVq7IkiWjmYpMI1QVOgqWdbTVgDmPsYWZtIM68tQPUU+sP13OEYiyBs7aFTC2a
         zjmRxkMeM+VRRDJ9Q5Rh9pBjyAFKdijQa8mT2gzs9NvNFqiC2NEcVB/uDxFrokKlnXKk
         bUlxZ6zLSS/x4qjwXKMAAvEP35y0gRtmxAGxNehjhnbhkOQSNXsjL27K/rnVwnn1foky
         Kyliq/xAiJ2BM7u/vcf/HELPZf6g99B0srUDNT4+SGm3MDy4FO7gs9k1VkIPtuO/G01u
         7ysCOpvwI9sSB+zwadrwca55dMboDEOYQ8xBCqNCsZCMQMgDB5Uw0yfMXh3bS4Ffy7Gd
         OQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=51h0lVd1c7+OEvoO2UQG6dIvRRvCEl0n5KWV8010Ypo=;
        b=Rii6bD5zcnZ9rgpCYMoKwATVtyQzbEies16YTxK5zA7bs2Jj25WxIxIQey4peaepbl
         AWmlw/QnszBPpJw7yG0iXMZgy1/aoOqgBVXpQJTU5H03WwuCZXg+KvEaIAx9P/sxKyu+
         oqZ1dn9Pfmx3bXGNhTkqI0Wqtx/i1fLakJckKVd4zNAQopRwWMusvkOhn+utd12pKHuR
         4Z0jS8JduCVtdWW5GY0I+bgVzAedhvCHOTKwK1jBtUVEwyBa/LPMEfKvBIri9CR0oqz8
         7vn8DfJZd9mZ2xDvD05cmk5nrG8nlOTP/5PjDcTq3kUq4dTkqjb9hzI3tq2+TQgOkmEO
         ugYA==
X-Gm-Message-State: AOAM532J5ws3xA0k3TE74zOhpiIIwp3Ln4fflvHzaO1SooI7gLHuzDK6
        GHg6X6wOzAANSws53+KwnafPvw==
X-Google-Smtp-Source: ABdhPJy6p+2gqBDKWQdfVK+vUYUsxiwwW6yVEu3D+yA9Si/XotFwXicN4U/A30h6CcBslOXvHnZcyg==
X-Received: by 2002:a5d:4903:: with SMTP id x3mr23880148wrq.143.1614782104546;
        Wed, 03 Mar 2021 06:35:04 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id f16sm31475923wrt.21.2021.03.03.06.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:35:04 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 07/10] crypto: caam: caampkc: Provide the name of the function and provide missing descriptions
Date:   Wed,  3 Mar 2021 14:34:46 +0000
Message-Id: <20210303143449.3170813-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303143449.3170813-1-lee.jones@linaro.org>
References: <20210303143449.3170813-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/caam/caampkc.c:199: warning: expecting prototype for from a given scatterlist(). Prototype was for caam_rsa_count_leading_zeros() instead
 drivers/crypto/caam/caamalg_qi2.c:87: warning: Function parameter or member 'xts_key_fallback' not described in 'caam_ctx'
 drivers/crypto/caam/caamalg_qi2.c:87: warning: Function parameter or member 'fallback' not described in 'caam_ctx'

Cc: "Horia Geantă" <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/caam/caamalg_qi2.c | 2 ++
 drivers/crypto/caam/caampkc.c     | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index a780e627838ae..22e45c5bf2023 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -71,6 +71,8 @@ struct caam_skcipher_alg {
  * @adata: authentication algorithm details
  * @cdata: encryption algorithm details
  * @authsize: authentication tag (a.k.a. ICV / MAC) size
+ * @xts_key_fallback: whether to set the fallback key
+ * @fallback: the fallback key
  */
 struct caam_ctx {
 	struct caam_flc flc[NUM_OP];
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
2.27.0

