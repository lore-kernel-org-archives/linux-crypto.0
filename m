Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBB8C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 19:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbiDMTPq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 15:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238182AbiDMTPP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 15:15:15 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F0D7247A
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:12:02 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id c7so4059529wrd.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b4u0FSgm7UEprR/XOQsUro7nRxCCkzBs0dJXK5VF/nw=;
        b=be2XYlIV3hKuMHZFfs8ZgBhkPTakJ/0hO/iue5Z9Kxxn6Ubxh4af/umxn+J3DscMba
         JQU57e8smOdtiaSa5iIkpnF463fAwCXB1VXZwgdbhuEUUS0HcabTZtPZ97zNXURgaKtl
         Vnqs4DIw2TLx2psZVueuti+6LyTa+uSBem33NxP40D+mP1PIVE6iDpinvWBzpLZgKo5z
         AOUgO81VsI+KeXCbHPXyY7Ep1qo9E1TYxxecm3irzNJ7awAJCliiF7MIm/81I/uuIhXD
         RHe2IeDavYS3xaGYb19vOHTfmYkQoI6pwCBvy86e+09+MtU8vSc49r95vLgLLAEfOx9r
         A4Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b4u0FSgm7UEprR/XOQsUro7nRxCCkzBs0dJXK5VF/nw=;
        b=wgreCFGL9s2mgOdCuFGMa9qg+KcU8H91dIyy/v5hc6Cq3P3w06MphYDQ+9O6Rh3R+z
         fxzb+x5KrOSEsoIpFHbttRDeqAFicPzYgXhLSejnJnBMh+AjgfTixpS1xUUQe8lYAH3V
         x7zJ1Z8GBAgikval9/31hGaWh0+nFFHqQwD+NmYu4KOnq8O777ZtRYNiA53Rso6Qx27N
         YoadrxP9DyPEKsoMc7GRlmCdlRz1SpjulOiFRBT6+fQmz7fGRP4Mx1SNzoW2fOj/3fYI
         VvWgvOwt7Jn/JJqJk8SNA5CXosaZDuUbkximjRxFGfTFxdGmpYB0YwFIx0U1XNSSrqJz
         D02g==
X-Gm-Message-State: AOAM532YngVsMU2CArg+NWQ8lv7ZdEjEDrjz6KGJPUCZAC/5N+8uv4Kg
        l5Masqx72qTt2WLaElfqOVxtWxI8vrKm1w==
X-Google-Smtp-Source: ABdhPJyIhECBx1HpwCm7GI17j6xzSXop0bZhpHOm87wOsfJOmVErCvF2jL7dngSacO+wqhrLtSmpnw==
X-Received: by 2002:a5d:6983:0:b0:207:a226:df4b with SMTP id g3-20020a5d6983000000b00207a226df4bmr269887wru.192.1649877121261;
        Wed, 13 Apr 2022 12:12:01 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o6-20020a05600002c600b00207a389117csm11963336wry.53.2022.04.13.12.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:12:00 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arno@natisbad.org, bbrezillon@kernel.org,
        herbert@gondor.apana.org.au, schalla@marvell.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 1/2] crypto: marvell: cesa: ECB does not IV
Date:   Wed, 13 Apr 2022 19:11:54 +0000
Message-Id: <20220413191155.1429137-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The DES3 ECB has an IV size set but ECB does not need one.

Fixes: 4ada483978237 ("crypto: marvell/cesa - add Triple-DES support")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/marvell/cesa/cipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index b739d3b873dc..c6f2fa753b7c 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -624,7 +624,6 @@ struct skcipher_alg mv_cesa_ecb_des3_ede_alg = {
 	.decrypt = mv_cesa_ecb_des3_ede_decrypt,
 	.min_keysize = DES3_EDE_KEY_SIZE,
 	.max_keysize = DES3_EDE_KEY_SIZE,
-	.ivsize = DES3_EDE_BLOCK_SIZE,
 	.base = {
 		.cra_name = "ecb(des3_ede)",
 		.cra_driver_name = "mv-ecb-des3-ede",
-- 
2.35.1

