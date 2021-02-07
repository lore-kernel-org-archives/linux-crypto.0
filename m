Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D8AC433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35FAE64E42
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhBGOlt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Feb 2021 09:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhBGOl2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Feb 2021 09:41:28 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238E7C06121C
        for <linux-crypto@vger.kernel.org>; Sun,  7 Feb 2021 06:39:55 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id h21so5824859qvb.8
        for <linux-crypto@vger.kernel.org>; Sun, 07 Feb 2021 06:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aBCNw2sBGbDAVprr4vYeHsYbO7AgbkLvqbpGnAY2zpA=;
        b=eQIjWXsRruSo59w86ZyCxMtGc79M6RTNi9zn5ZsDr0mNYjdxPflsIDBEa2OSsTF8LN
         4v5IpdnR0tyhszxBPoVX4n1Xw3D9BfJVxqBr9TvkSymIuPkDzuQN/VsS7sMWhrTAvvhX
         cn5TSLTzx70MNAsq7M3Mj9yiLoWZSGy8jon9TeKsI9LnepNiF2GgKrjK822FsrDEPSMe
         zTxeZ1x8IYuTTC10Xq2nzr9Yt0OU2m5Rh8Nlvt0a7ioQT/esnmVTV146gQkd9IZCpDpf
         Y8xRYiBW87z7eqaIWELirH1o7pVQ1lI1Fd0C2FS18nAq7XtFK8XUY6+nqOI4bY1l0ocF
         X/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aBCNw2sBGbDAVprr4vYeHsYbO7AgbkLvqbpGnAY2zpA=;
        b=jEcPBAd6MSNVh341GZfBMq4Nxyzr/CBdQ3oTeyu+SuqHQlCk3TWBzQ0IuubXjJYFQT
         hJ+hKsZ6VRBzslptUr7wbP7rqRhR1b9SQhCN6K3BxVC024xFL6nSQTEx8Mwa6XuriOzc
         fXidWj+geXnn/NqJl5MOijS6NeSPLNNuf9Vi1LDH+19AQgD19sBk0dKxOuP3hxFYgR69
         ZKo1hrIceckT0YHqW27ipwszs2Wc4RZxUUO1Z2Ze+KSjUx97xGpUE19AcQ7tVtMkkyGh
         AETTKI6zzMIFDu12VIbZYxlUMLwLwVqQNu3Om9PeIhhaVjvJwWjgArOLPDecl9mjHxva
         kdGg==
X-Gm-Message-State: AOAM530ase4kXaaX6khTdhhBVO3GuEBeoeuhbIURTnIPv0qfuhCr9z8r
        IaExlLyq0iVHladbMxjSi1KZAA==
X-Google-Smtp-Source: ABdhPJzq9BMxWKK98fGBJllyBTJ97Qqb5nuUy1iC5ToySlb0CKTBsnix10+G69zNvQ6Y81OHP096bA==
X-Received: by 2002:a0c:dd8b:: with SMTP id v11mr12497164qvk.31.1612708794395;
        Sun, 07 Feb 2021 06:39:54 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id c81sm13941493qkb.88.2021.02.07.06.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 06:39:53 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 07/11] crypto: qce: skcipher: Set ivsize to 0 for ecb(aes)
Date:   Sun,  7 Feb 2021 09:39:42 -0500
Message-Id: <20210207143946.2099859-8-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207143946.2099859-1-thara.gopinath@linaro.org>
References: <20210207143946.2099859-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ECB transformations do not have an IV and hence set the ivsize to 0 for
ecb(aes).

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index d24d96ed5be9..64f661d7335f 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -353,7 +353,7 @@ static const struct qce_skcipher_def skcipher_def[] = {
 		.name		= "ecb(aes)",
 		.drv_name	= "ecb-aes-qce",
 		.blocksize	= AES_BLOCK_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
+		.ivsize		= 0,
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
 	},
-- 
2.25.1

