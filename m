Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF61C35278
	for <linux-crypto@archiver.kernel.org>; Sun,  8 May 2022 19:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiEHTWG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 May 2022 15:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbiEHTEH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 May 2022 15:04:07 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7530BBF76
        for <linux-crypto@vger.kernel.org>; Sun,  8 May 2022 12:00:10 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id c11so16688955wrn.8
        for <linux-crypto@vger.kernel.org>; Sun, 08 May 2022 12:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w4B/nkw6c+X0giFcf3xLDnzS4+ocxAJWfds+bZ7Txos=;
        b=xBSYfhNPKFBsV+MtL63+YdwE8hQ6fJsFoeJ/NI05jA46yo1oCGQ3z8PdsPl+JYA3gP
         U1/Kv+Ub5+GRq5e84yegbawuogXnvwtrbdiD/m7J2zgnsoDYwOjQMPbJBh8bcZ+DdIJW
         RpxAszcV1sc8sfVrTD26+ZhNdCn8cr92KtUpRYC4nLWsmzg+9vy57PK0TilpO46jZHEF
         ZBkPE2SDXEONC1SsQ2Q6TUqDHuaHDlKJyZdPnlSFr6XoT7YgvEm3uTSZqXNGUSZVs8VI
         R/gIXVgu1gihaAlZkovWuJN2a2Mcsz2EOEpKt5fsj6buzvzyL1gjugmUK+U7/i1TX3bF
         6Ibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w4B/nkw6c+X0giFcf3xLDnzS4+ocxAJWfds+bZ7Txos=;
        b=sykpPwooucctmWFgPPQ7Z0SY3IZGIE82g4OieDnb2kdqNs4hdzmiBteoXLSgD8i6+a
         JFmECGhMOaPkbvG5t9PjPZ/L/0ifxcjVL435DUyH31DqgpivZeBThUY3+Jv7EZIpkYoC
         BeRLSd5E/joir6r4zFzRv449uY7M8Z2n6U4YbN81QFxs8oWlVZB2WnRNBLjbeEWTV5cw
         MG5HbRZflPhornV7ppCt8iqh0fK1n4c+EhnAA011u5qIuvDgwPv1QCyMHoMSWE7MVpz2
         pDF2hJofR6i7TkNjJpyrB3vZuYTEkyphXR2GhisTwsYUWMzKofuoex0thmS9PMMzSC+g
         Y7VQ==
X-Gm-Message-State: AOAM5332pAOHIewrBNGDHaZxqXbOuGr9PTBu8U1nRA2jOuibEzBmNNOy
        IlNMap8bQcAKGKTkc9nJQTIKUA==
X-Google-Smtp-Source: ABdhPJz+zcX6PpbigBW8fFjw5HibjVnV6t/DKE9y2/UY9F/UqoPIK67DLqN+Mp6QsZ4+JlfLut+ZDA==
X-Received: by 2002:a05:6000:1681:b0:20c:5aa2:ae14 with SMTP id y1-20020a056000168100b0020c5aa2ae14mr10796973wrd.443.1652036409039;
        Sun, 08 May 2022 12:00:09 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id n16-20020a05600c3b9000b00394699f803dsm10552348wms.46.2022.05.08.12.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 12:00:08 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 04/33] crypto: rockchip: fix privete/private typo
Date:   Sun,  8 May 2022 18:59:28 +0000
Message-Id: <20220508185957.3629088-5-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185957.3629088-1-clabbe@baylibre.com>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fix a simple typo on private word.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index 2fa7131e4060..656d6795d400 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -235,7 +235,7 @@ struct rk_ahash_ctx {
 	struct crypto_ahash		*fallback_tfm;
 };
 
-/* the privete variable of hash for fallback */
+/* the private variable of hash for fallback */
 struct rk_ahash_rctx {
 	struct ahash_request		fallback_req;
 	u32				mode;
-- 
2.35.1

