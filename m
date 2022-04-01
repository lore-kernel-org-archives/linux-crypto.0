Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A734C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Apr 2022 20:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351902AbiDAUUN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351936AbiDAUUI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Apr 2022 16:20:08 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADF0270874
        for <linux-crypto@vger.kernel.org>; Fri,  1 Apr 2022 13:18:15 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id r83-20020a1c4456000000b0038ccb70e239so404274wma.3
        for <linux-crypto@vger.kernel.org>; Fri, 01 Apr 2022 13:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w4B/nkw6c+X0giFcf3xLDnzS4+ocxAJWfds+bZ7Txos=;
        b=KxcxtcbRb2QPgVauezedV7SNYLp5vmgrnnYhE00v0LZbmM6JqQASdazz176kksIVQY
         BxP0dW3xTidets43zID6Q986jQbuLAr4pLOapROvgXbDtduSqxudXk+/9sMDk14WaxAN
         3sWgsBLDqkr3F5a9fha4I7gWSvQgzr/2JSEFmnLw+/sbOWbztPJ08dTZjIo2eE2Ls79B
         tsPtZoP74ZxmBwAT54g9XchOKH1wC4lE0Q+l+SZTgFFXRRF+ryEdl8J3M2byJeg7C5Xr
         GLmmyLryweoDTXnscdokkziggZBgAOkIV+73uachetlN83ZCXh3cjjbb0xvzO97UKSGH
         HnEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w4B/nkw6c+X0giFcf3xLDnzS4+ocxAJWfds+bZ7Txos=;
        b=OZzFItv7Dm4g1RVzspqovoO32VAF9CRh1fV4X+lpTpaLT32wThHqPqoTftW3SB/XXZ
         Ua6tKOkYndA9Lhh5Hbc8ET+5x+bb3g+F6WTL5v0zcSRIE5I8PQ4xyXYl7j+9JwEJFo+r
         SEGOI7YnPZEVSntco1wVF6C1cS8if0vmg07RqeKBA0/GMBncwUf7muULL6X3KYEm1g0V
         plhxelacQgtux+xUMpZ+txA2JdBUF63y02zEP/LWXdgQE4D8t1Wfi93FYK3M7Q6EPaZK
         bkLsrZEuCx00C68pjHeDU64u36QvomDfJH5ptAxeq8WvAfTBGi0DJA8EhSQ0gog9TQrs
         uQqw==
X-Gm-Message-State: AOAM532io9HGBCcKRWSLEglmixWWuTeOPih+gTNTOzjNR1DIQgGkfR1k
        MucLpxiNCppC77GFIhQDb0mo6g==
X-Google-Smtp-Source: ABdhPJyaIe8Lc7psoRcrDK2ZUQlV88j42ewUBPlq5iu0doBl94rx+Sy8DDzBtsVAMdfXe0hJ+AFlRQ==
X-Received: by 2002:a1c:7302:0:b0:38c:bb21:faf7 with SMTP id d2-20020a1c7302000000b0038cbb21faf7mr10125930wmb.31.1648844293709;
        Fri, 01 Apr 2022 13:18:13 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm17823838wmq.27.2022.04.01.13.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:18:13 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 04/33] crypto: rockchip: fix privete/private typo
Date:   Fri,  1 Apr 2022 20:17:35 +0000
Message-Id: <20220401201804.2867154-5-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401201804.2867154-1-clabbe@baylibre.com>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
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

