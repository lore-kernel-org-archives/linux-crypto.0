Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE70EC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 09:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbiGFJGj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 05:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbiGFJF5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 05:05:57 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445DA24BFE
        for <linux-crypto@vger.kernel.org>; Wed,  6 Jul 2022 02:04:53 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n185so8422432wmn.4
        for <linux-crypto@vger.kernel.org>; Wed, 06 Jul 2022 02:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V0VQZblY3ilqDl88ksU7sNdmpCxvXcKe3g1VMncWlyM=;
        b=e0yxJClSSXUpxDCwHaDOIvRbSdrRABgnEeecbOpuZA4XLCVBkpW4gXL+Wk1VaIiSVL
         /yCdOstHJFcouC915CbdVqS7Tx868WNSlZHGvvOdjzkN+8V4Iv948hnotFeMmebif5KJ
         jIcJMhNoBQlK/G0WDrkfLcATnb9vue15d+/tkV0tTl32cpb+D5dpTGg0Xj77/c19ZvxH
         WPqz6PrZNnUt8yLrm11Rz6kMcDArUEH6QWDdDV8MwpK3kf9HDJ+QTxhEc+4S0/vzEyPb
         3lGPUJhBlXEb7UCNljr3yotpXx9k6NmWl69/f13H4yxs8XCnIHf4nt4r8hN3UbP+WjrO
         hs5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V0VQZblY3ilqDl88ksU7sNdmpCxvXcKe3g1VMncWlyM=;
        b=KcZbIbAhMT2G+5iZwHtymCY1nBwmaNq0c2Mg55T3vXw9seDtw1y/pieG+SNFZGpjOC
         108Xqb1QK5d10JWgMjCpDZlqFiJh/kaSk8CKRdd36GPbyIomFP0qQYDuGYgcKkMwwYO4
         fFMLB4YeSsUkpZUfr5gmvTeZdM3aG+FZVeBYSMc2PeW2BqQqJR8KQCPoZZGkscFAi97Y
         6s2wu0VE1Q3zlSsXK6VnmpjS/LTOFep0VXPCKIL2+lPpNflE6jozAWH7UwPCaamnc+Xe
         Bx8k92G/GRHg8hbqnVooZUiOjqOjXE/DWi3QLrcSRxu5zjfSAt3MlCCUdYjt8ffMOYba
         FvhA==
X-Gm-Message-State: AJIora+8DcxpXezLxG4wMpaxq2h4eS5AVfpY+e6yZVj1XXOjBtiYjHwe
        9YpM0WAgyKKbfAUWHwCPdZOOng==
X-Google-Smtp-Source: AGRyM1vhku6FFRqMSgg0ZToVK+4jD8sS/eXzzi4dV/619Zhx8Ilio+pxWWjXHv62NgKXwOO5OBzU6w==
X-Received: by 2002:a7b:ca54:0:b0:3a0:522c:d0ec with SMTP id m20-20020a7bca54000000b003a0522cd0ecmr40784122wml.63.1657098292893;
        Wed, 06 Jul 2022 02:04:52 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v11-20020adfe28b000000b0021d6ef34b2asm5230223wri.51.2022.07.06.02.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 02:04:52 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
        p.zabel@pengutronix.de, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        john@metanate.com, didi.debian@cknow.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v8 19/33] crypto: rockchip: add support for rk3328
Date:   Wed,  6 Jul 2022 09:03:58 +0000
Message-Id: <20220706090412.806101-20-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220706090412.806101-1-clabbe@baylibre.com>
References: <20220706090412.806101-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rk3328 could be used as-is by the rockchip driver.

Reviewed-by: John Keeping <john@metanate.com>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index a635029ac71d..c92559b83f7d 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -202,6 +202,7 @@ static void rk_crypto_unregister(void)
 
 static const struct of_device_id crypto_of_id_table[] = {
 	{ .compatible = "rockchip,rk3288-crypto" },
+	{ .compatible = "rockchip,rk3328-crypto" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, crypto_of_id_table);
-- 
2.35.1

