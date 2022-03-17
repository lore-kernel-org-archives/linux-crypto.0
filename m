Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EBDBC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 20:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiCQU5c (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 16:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiCQU5b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 16:57:31 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F701544BF
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:13 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v130-20020a1cac88000000b00389d0a5c511so5595851wme.5
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FDPzallkxZHrwYGOlhVbPbIqdaMTkxdkI7weP88y4Cg=;
        b=F+oR8ZJqpHJsxjl0c3X+43Uxvn4qu91BG1wLTrWZa6BEx6hfV5Bx/jtufjc4fYKiTd
         niZ2DOD0y9nTtR8fpiSZUYWmZK8Lo9L4gznSGEYBYNMW1luvYr8hG4WEjWcA9J3aX8ka
         xGrIauj8hye7PYByLPCzkKEihjbxWMv6ygX10GFjp9BWh+R7d9qEu1i1rqTEu9q2AlG6
         ld3rIaiffB/vSsYldxmLqijnWhwpwc1RYBsaVsBBD2IW71FqrifEycqj2MTUMa9O4iz1
         +1e4YA2nImwikiTMxsrDb06O99jUtwND3MDsXl/ru1HXCmMVl+EFN+C5Dz8tuhG7PJjx
         Ckjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FDPzallkxZHrwYGOlhVbPbIqdaMTkxdkI7weP88y4Cg=;
        b=cwT87r/EF+eiBuH+yCT0i09KXA2cM3ObyqwmZiwrBDfrgoc8Q+doIVNuQiBCYdJROP
         zrr/J1wOp4FqSA7fJfSDv/3WvBGOJBjP0BbQS2ZI3sc6jPmtxpasBAbNqXGIx8bxP/N9
         7YiMC58kQtP1jcds05iX41/5VstMf+OQY1GDDvURaZJ6Fds3wvKXw4jgRtFo9eS2hE+H
         vbuHzPFXnUKQLpfMTDrDLnHjf350EJMhLNko8jIUzlDvaeIIQzeIkwzssMXiUDPt5pm8
         a99TRBZr2pQkRwc0ZYwsKrJwGO5weHDtBdfk/Y30Rtx+c0ZgZbyrTxpizWJ9VHN1lAkU
         zGww==
X-Gm-Message-State: AOAM531PjSENcnmUqbsKor2rZOQLQaJWZPzZ0yITVLokjqUXaDv1qrVe
        0ckgxa/Kiu/Zm6Q6tZrNUAnQqg==
X-Google-Smtp-Source: ABdhPJyA6v3tzW6pBOq5BDaDhMkbXkD+9ITBlMrutFmQXIA+EA1OcHttTwjC8fP3bmUU6MYWk44YAg==
X-Received: by 2002:a05:600c:1f11:b0:38c:6ce7:69c5 with SMTP id bd17-20020a05600c1f1100b0038c6ce769c5mr5690186wmb.64.1647550572234;
        Thu, 17 Mar 2022 13:56:12 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id r4-20020a05600c35c400b00389f368cf1esm3695424wmq.40.2022.03.17.13.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 13:56:11 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 01/19] crypto: sun8i-ce: Fix minor style issue
Date:   Thu, 17 Mar 2022 20:55:47 +0000
Message-Id: <20220317205605.3924836-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317205605.3924836-1-clabbe@baylibre.com>
References: <20220317205605.3924836-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch remove a double blank line.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 35e3cadccac2..01d032e08825 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -398,7 +398,6 @@ int sun8i_ce_cipher_init(struct crypto_tfm *tfm)
 	sktfm->reqsize = sizeof(struct sun8i_cipher_req_ctx) +
 			 crypto_skcipher_reqsize(op->fallback_tfm);
 
-
 	dev_info(op->ce->dev, "Fallback for %s is %s\n",
 		 crypto_tfm_alg_driver_name(&sktfm->base),
 		 crypto_tfm_alg_driver_name(crypto_skcipher_tfm(op->fallback_tfm)));
-- 
2.34.1

