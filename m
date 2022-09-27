Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124F7C54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 07:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiI0Hzp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Sep 2022 03:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiI0Hzl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2022 03:55:41 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495CE7B7A4
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:55:38 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v28so844629wrd.3
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=e93jdwU7lOD2x9pMhJTBQN+yJo5I1w/iWBnUD+AsvRI=;
        b=P95BMFMDCHcO/e4sMvbmMHIOXf3JyWC1JZaC8Mwvo8kE2gufm3WLSd6cGrmXuuXlwX
         U7DwYY4omAj6WdZCKCSGyChwxyh19b4NogvvtB9PucKATKIlova7ivlr6I8uP8KDJsYU
         3lhY1Zo8/s961maBxbAyjey46UF/rv1BR4Kz8Lb1k7ht+7NE4Shw5RiSheKPr0MIR89l
         geDeZ3nV+XPKarqYxmhTRBCfOlelWva94NRZNlFq/meiEsxlFveBeR4OiZBa5FImhFuA
         /Act2YafmvPTSX0K+Fyq1iRCzhjcpbN/ZN1PSbmxlEzLN3g5A0WQ13IERLR1x5Usocjz
         Mp0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=e93jdwU7lOD2x9pMhJTBQN+yJo5I1w/iWBnUD+AsvRI=;
        b=UQ5GGOSHyKsyAcjmLdrW7XBHHiLVkb+XiKLxLzIQbz7dAmIJKHyfAxASDb5JU5vVZg
         FGjHCqagK/jMOerNvPy17EdhwRvtZvboPlD2MHP7Ool4IqS50femvs0lUAC34fOXwsG5
         LOeWGEPcef/DhcvOscdd9NT2rA539DXfOESgRbiWSiYXugwNOsnbOhKEwkkWBfPP9JS8
         fZRLlsYPdMcnWcyXbieML1wyYE0TTZWxxwyv4TDWY6ZdpkJNuJLQF2Djnnln8SMvmJx8
         GHBxuvIXuEtNGo3+T+CeMoMJe/6kKulSo1tA83m8pobO6itf1iAsG9C5uxYkx11S6Gs5
         mugQ==
X-Gm-Message-State: ACrzQf3hVD75QNGbOk4+gN539XX5qojUaWSrl5whttqNelKgcde5MLVA
        Hl8VcJxj1QMrt0OajQAtCh9qew==
X-Google-Smtp-Source: AMsMyM5wMBHZjEBDjBgQmGUPkspEyex1NfqvseieXleEWYVoezEZEP/zQqKwVAGX27Q/YbgBLAP4DA==
X-Received: by 2002:a05:6000:154a:b0:22a:b8eb:ba53 with SMTP id 10-20020a056000154a00b0022ab8ebba53mr15726563wry.594.1664265337400;
        Tue, 27 Sep 2022 00:55:37 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id x8-20020adfdcc8000000b0022afbd02c69sm1076654wrm.56.2022.09.27.00.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:55:36 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>,
        John Keeping <john@metanate.com>
Subject: [PATCH v10 04/33] crypto: rockchip: fix privete/private typo
Date:   Tue, 27 Sep 2022 07:54:42 +0000
Message-Id: <20220927075511.3147847-5-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220927075511.3147847-1-clabbe@baylibre.com>
References: <20220927075511.3147847-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fix a simple typo on private word.

Reviewed-by: John Keeping <john@metanate.com>
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

