Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD46C43600
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 15:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38639611CE
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 15:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350093AbhERPSh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 11:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350105AbhERPSe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 11:18:34 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83C4C06138B
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 08:17:11 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d11so10646198wrw.8
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 08:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u501vdxX7BCRd9YUoTlmX6ILsP+Vrpiggq89mS2FUF0=;
        b=Fso8wwEA/kXfWp8W6m7CMxjNZ34hmwvCvbWMc7jD8groYMR3Q8YixaDBzPObcJpztR
         cnI2ZaR/j7FFu6k1ZlS/Uc1FM/XGM4dxmpZhCgbowlYOcRp9MzIpyUB24br30Zdb/Fcb
         CrQ9aqH2Rw+4A6+oQt5J8KldYSPYk9n8IEnz8990MqF5cJ6yVYJgjPHTtWG5xZSIsRpb
         Hg+7TBK6w8Cvy0/vWR3W4cY6oghCCh/FKO/wtE888v9W71e94ypP0xZLST45+Vo/obuh
         i34fAsQrPNaDdLNEIxeJHLebOoXoo2huEk/oO43lgHgwCxDQxUBQKCB/wNpnJaUrUDZj
         vTzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u501vdxX7BCRd9YUoTlmX6ILsP+Vrpiggq89mS2FUF0=;
        b=juOnWd7HFT5y1msRJFfWYnSLRoOktNFGhQrVArgMUYnrR1P+MTvg3a3Vfyj53xuQ7h
         RhCGyK4pl8nV7Xps2VlC+1XaUMIdnMJKwxwqWlpWhnt+hmFWdV9uY+xOkAF6NP2YXuwH
         8vN/tWbX2wiFus7YKQpymtf0h96ooBaJpRdJ5ftF7C/5YUAB2ukkZL85/fQfbsznDQAs
         sUjbWo73ovCsjyB1W1B4snz/3AD/fNxSqM7oF5pkjaDBQPgOWwQgjgk05BZd0l4HDo7d
         eM+wVshOhaUrpJ0ExCH3Lc4rKhXfgWWc75f+AhJODzKTWOyqNVb7iBu6K1TJDoXsAtbr
         xSZw==
X-Gm-Message-State: AOAM530+mgwboKIDNHo9EZEE0qdb27Jzp1oA2cO8hoIGWl9cz9rfWOgX
        txXFrNkTbVg8Uu/Yfaiyc1+YEg==
X-Google-Smtp-Source: ABdhPJwUKQvqzKuixftwG+d5RY9kxejQJjKFtv1YRGREatCIuS3ZGijo7KG6YIEj9THuo9JtwDKpzg==
X-Received: by 2002:adf:e291:: with SMTP id v17mr7725740wri.149.1621351030606;
        Tue, 18 May 2021 08:17:10 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id z9sm18005808wmi.17.2021.05.18.08.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 08:17:10 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        robh+dt@kernel.org, ulli.kroll@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 4/5] ARM: gemini_config: enable sl3516-ce crypto
Date:   Tue, 18 May 2021 15:16:54 +0000
Message-Id: <20210518151655.125153-5-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210518151655.125153-1-clabbe@baylibre.com>
References: <20210518151655.125153-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Enable the crypto offloader by default.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm/configs/gemini_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/gemini_defconfig b/arch/arm/configs/gemini_defconfig
index d2d5f1cf815f..3ae4b8f62b82 100644
--- a/arch/arm/configs/gemini_defconfig
+++ b/arch/arm/configs/gemini_defconfig
@@ -100,3 +100,4 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_FS=y
+CONFIG_CRYPTO_DEV_SL3516=y
-- 
2.26.3

