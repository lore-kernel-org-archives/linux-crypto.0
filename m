Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1411C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Apr 2022 20:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352080AbiDAUVI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352157AbiDAUUt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Apr 2022 16:20:49 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0232D270853
        for <linux-crypto@vger.kernel.org>; Fri,  1 Apr 2022 13:18:25 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h4so5726230wrc.13
        for <linux-crypto@vger.kernel.org>; Fri, 01 Apr 2022 13:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FcH8eAoI6yz+8TC9BMdMFxwPGrpdfZxlhw/9L623qlU=;
        b=llsrWDxNsvEMzNlzLU35oj0tkJ0Y7D2I5R00fLAEedh+oepe72uq1hj/+DV5thVha8
         MOwOBAubNz7hOE9SG5/J+GOdeEeOfomzibIyfFgBNL6TK4FHGB9W7kRl7IVFMm8NNwaI
         k8ttDsR8fw38yuiR2SKn8CQ/Uv/SMH5/ZLP3HUuFJmyr/R/TOwSV3Qjco1tOqHRmUJ+q
         JzYL5DrxggHdIBxEJkOT//D1ExWyHndxqGUusZOYpzYMNbZi+8LYwBumNMXyb9F3C376
         rXiAKWkih8+yQk+spVNJy5Fgit1HNX/dKraydCblNQLPSAUrjTQLi1ntgw7KY1X9HsmL
         tcjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FcH8eAoI6yz+8TC9BMdMFxwPGrpdfZxlhw/9L623qlU=;
        b=H4Xa/6nE7HmKj+PTYhMx+uWH8twdVVRNGLIxT9mnmm2CblH36n/P0u0OFwwCFxA7Dd
         92twXQE+9y6icrd6nt3OmNqkvT9PoWIu+CC2p+M85XnRTidkBU+1CU9kLF89z1Bnqrdy
         76nRHnsUAeUnno3KhM4L9tcNEwNhfw7EjBtpYwcISd+QW08jZVWLFcRtk0fbzY1v3Tr2
         lZEMVwk2dPyynicQ5YF1x1ckw6lv5WEN/Yj3UI3e7qajFwhW8tBwTanDNsGqdYLLzA6P
         tqx8ZDea6I4B5YTjrIxPb2NRaEal+7AkiK9XrCc3F4wi8is4uC4XtgQUVgDFDt5UJGNo
         HQQg==
X-Gm-Message-State: AOAM530pCSp4feWICA83EC1No5teUmGOlM2EfqpCTdBJAZZZzBCiKwG3
        wGFF1y19NJTwl6zoXFMjdROtEQ==
X-Google-Smtp-Source: ABdhPJzTOemI9rOSCOekpTcQ631Yx6r9L6brdVTB1mC6yBy5nExdFsXzYxX4lJq0AzOsYlxq5h2XjQ==
X-Received: by 2002:adf:eb4d:0:b0:1ed:c1f7:a951 with SMTP id u13-20020adfeb4d000000b001edc1f7a951mr8648033wrn.454.1648844303336;
        Fri, 01 Apr 2022 13:18:23 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm17823838wmq.27.2022.04.01.13.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:18:23 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 17/33] crypto: rockchip: use read_poll_timeout
Date:   Fri,  1 Apr 2022 20:17:48 +0000
Message-Id: <20220401201804.2867154-18-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401201804.2867154-1-clabbe@baylibre.com>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use read_poll_timeout instead of open coding it

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 137013bd4410..21c9a0327ddf 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -10,6 +10,7 @@
  */
 #include <linux/device.h>
 #include <asm/unaligned.h>
+#include <linux/iopoll.h>
 #include "rk3288_crypto.h"
 
 /*
@@ -305,8 +306,8 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
 		 * efficiency, and make it response quickly when dma
 		 * complete.
 		 */
-	while (!CRYPTO_READ(tctx->dev, RK_CRYPTO_HASH_STS))
-		udelay(10);
+	read_poll_timeout(readl, v, v == 0, 10, 1000, false,
+			  tctx->dev->dev + RK_CRYPTO_HASH_STS);
 
 	for (i = 0; i < crypto_ahash_digestsize(tfm) / 4; i++) {
 		v = readl(tctx->dev->reg + RK_CRYPTO_HASH_DOUT_0 + i * 4);
-- 
2.35.1

