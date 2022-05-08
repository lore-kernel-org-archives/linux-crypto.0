Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64928C433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  8 May 2022 19:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiEHTWu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 May 2022 15:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237325AbiEHTEX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 May 2022 15:04:23 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B60CBF73
        for <linux-crypto@vger.kernel.org>; Sun,  8 May 2022 12:00:25 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b19so16696450wrh.11
        for <linux-crypto@vger.kernel.org>; Sun, 08 May 2022 12:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ww46m6LdM7MaV4jgNKlRbRSwspMAPKBncRJe9WsCVsI=;
        b=PZlXUeAwiUiO0FNRB1GRfnw2g3hqzaQBu8lU8WX8S24TtOWcnuy3Ku47c1Pqo14GDz
         8btqyUYI4zjBlZEgDLF5QnNO0W72IhkV74VBq/WRw2SDzGaZZ9AhihbE2/0WV5lw2S/6
         2z4tyrPY9ycOqmmfIV82Rl6eMbfpB7pRTvWJQ+edzjzI8LjUMsmmXk2UGotHrrw2VMhe
         v4O1vZE5SJOOSvNEyBmzxhQsdjkbK3mlhfzGj8VSpQVC876erviddGDon1g4Pdx788YG
         Z3bBzEqV6MwJUGtAgsQGn0/jB4oaPYmmTfU0tH19+aUPvWb5yGUx5rarGossWFpyzhbw
         1OVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ww46m6LdM7MaV4jgNKlRbRSwspMAPKBncRJe9WsCVsI=;
        b=WWYtSODMc6ZWaDDvQqkhsTye/bVxbbeYbs5ezdMJ2Jy0AuhKsXszyJea23K+nG4Wpv
         NegvOEOBfFLxp//QuEkSrhKKxbYJjdd9eovXkF8Zr+MXP06HxyrDtOPTVUvCmyO7tOvh
         1WH8gz6NRmKhy+VH47XBjNA0WdODZCCc0RDpw6q7927ovmesHtRNOBLSX/Fd3bMFEfYG
         W2bzF5Se5pjcS/iuD5p+rgx+b+/jmDMPp873fMw7OFM1x6zVdvASk/TEIXzVgIGMRqA+
         eFA3i6zJoytt6zbsHSsnNpKrd58DYNBSg91TYt29VdsS7bt+AkM0Wq4bSwH6O8JCJWZN
         sfbw==
X-Gm-Message-State: AOAM530ZFpa5PvUulynNfVKShy4F3E416+jllHHlXyJv21Pe3HAoTyLC
        5pycELNYVUelHaVAGtu83F8UXw==
X-Google-Smtp-Source: ABdhPJz6At/nDhjD0hMxf1undhS0vkVAdQC6PQe4QWTJ1tobep3Mh9CYE4IruJiAEIYJSR5KFHNaAA==
X-Received: by 2002:adf:d1ec:0:b0:20c:6228:e2c8 with SMTP id g12-20020adfd1ec000000b0020c6228e2c8mr11362929wrd.328.1652036424836;
        Sun, 08 May 2022 12:00:24 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id n16-20020a05600c3b9000b00394699f803dsm10552348wms.46.2022.05.08.12.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 12:00:24 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 19/33] crypto: rockchip: add support for rk3328
Date:   Sun,  8 May 2022 18:59:43 +0000
Message-Id: <20220508185957.3629088-20-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185957.3629088-1-clabbe@baylibre.com>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
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

