Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B58C43217
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Apr 2022 20:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352067AbiDAUVF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352169AbiDAUUu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Apr 2022 16:20:50 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5A0273819
        for <linux-crypto@vger.kernel.org>; Fri,  1 Apr 2022 13:18:26 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id b19so5760688wrh.11
        for <linux-crypto@vger.kernel.org>; Fri, 01 Apr 2022 13:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ww46m6LdM7MaV4jgNKlRbRSwspMAPKBncRJe9WsCVsI=;
        b=RELHFC5FWmfF+AjoiKkjqiFFsOiSKjcK5ZHv43xMZ3b6+ClXsTUB/dUxqR2EhYZ0B7
         DitCTQK5oB8Zqmzc4acLq0NDJAiMv/EVmg04civzZzfxCV77hbF72gLQjLvsUa3P1gaQ
         YAZdrW4VCYvHDIXVVjaULC5Sd3Mofrw2wt5BtrLjDr4ZF0Y34ziIk6KFupiRunFC2Soo
         iSpclLza5C8IvqJ7LLB8O/KrN6vBp8gXsK4w6d8+EFWxnt2dQgvSMT74B4XBrRkHnE6/
         S+fTL74s9vhIY9JsR9hUf58ucvYTZsUt6D/8Stq82s0887jJCAZt2EYBY0K1LMtbKJk6
         Ozgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ww46m6LdM7MaV4jgNKlRbRSwspMAPKBncRJe9WsCVsI=;
        b=Sm3NgI1L6YPsK1jR5rPA2GvH29ViwYxRG4nea7NNQW6mjoKEYmUD4SzOBOVHP39zTT
         V1yJHtDiUqUi/x26z6su8RGtPPgweCODXMlAWOe74J7CZwkr5aEsI0oe++QUO42QHjfW
         m175zAf+0erFRYFLogZ3E8LPq7B6FlQ3ndSagX1z1x5ZUXoFgL82JjbBSByjo3MTGmyx
         QlxbpMAGpuniNvpJCY+D1fWQ4iQjqNQ9Kx3hXvJrXPGqXA2jOGrEEEw8V7fYPM76x2WT
         dAjWl0/GqY3X0h7hGZq/lM75RQ0mbiBqkD2VOwPySO+EhJ2vubTRrFewvp2aOUryLDPn
         zRPw==
X-Gm-Message-State: AOAM5316mRvYxjNXMSLvwIYSIL9rHt7+XQ//jAkpC/m9a9sodh5Lu0yG
        C8j7+b28EbAPNnRZWXRTSmxmtQ==
X-Google-Smtp-Source: ABdhPJz8d4mcqg7Tmry7+8UnkFbgtg923ACNX5ZxEwiUhfhMK0O09cJFC/MYtSt2QT8qvVp0UObzuQ==
X-Received: by 2002:a05:6000:1445:b0:204:1ca1:67b0 with SMTP id v5-20020a056000144500b002041ca167b0mr8818523wrx.507.1648844304813;
        Fri, 01 Apr 2022 13:18:24 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm17823838wmq.27.2022.04.01.13.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:18:24 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 19/33] crypto: rockchip: add support for rk3328
Date:   Fri,  1 Apr 2022 20:17:50 +0000
Message-Id: <20220401201804.2867154-20-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401201804.2867154-1-clabbe@baylibre.com>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rk3328 could be used as-is by the rockchip driver.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 97ef59a36be6..6147ce44f757 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -197,6 +197,7 @@ static void rk_crypto_unregister(void)
 
 static const struct of_device_id crypto_of_id_table[] = {
 	{ .compatible = "rockchip,rk3288-crypto" },
+	{ .compatible = "rockchip,rk3328-crypto" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, crypto_of_id_table);
-- 
2.35.1

