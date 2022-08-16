Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E951C25B0E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235887AbiHPOE2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235889AbiHPODq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:46 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F31348EAA
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:33 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id v2so15063856lfi.6
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Ivipl+R3KaUVhvm6+/uc6buRF+V3GiyHLaPQIyOLyJY=;
        b=Ku1K8okvTsqZWSrom1nyEPa7LmVHnQw789D3bH6894IPwQtY+0d2dodISIkXHyeaeH
         E8n8wJxFOkUX/r0rFiIgDkvibh5Yd8Fh+7lJB1A0tb2M+dew+gIV2JXtmwyz/xMc5f3Z
         a3cZDinMYLRUHNhMAukJupNxPEzKF5l6XKdjbADByRRik4xEq8WRhoaM1xJDkSh2C/Kq
         LwTPQ8FYf3rIfMQjHxkIbp+wXuFQYeHtCG8CwvXimPjjVEsoCVyfS8RAEOwIHv+JuYDD
         wIcelH0p5cgFlROcDJTOhKnRH3QpruaVhueEvNoFCXE+sV+Yl5XpCAnqEESAgkPIMMIo
         Vhxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Ivipl+R3KaUVhvm6+/uc6buRF+V3GiyHLaPQIyOLyJY=;
        b=jFS5vqFpoaDLU03pJkLGnuM2f6KLqwHa2i08GlnsmPr2rzHUmP8o8olfN6K5Fo5T3X
         1hdX+TkfA1EzgTGm2YvCINsYyJdvYNpoer9heoDbVwYpjIKj2C/QgPDPnARLMgz/vOv8
         woClIfNUZ+/wtJq3ZRQgcwUh0B0hML7Ub5dRIzlEm0U4VxM0ZQRdQg0/5tsUjdU3AVSq
         JrYkeLt9grr7iwIIcNxrIGieo5NT6jR/w2uRVCY6QqwdGc9hI2vE8rDGg3rOnx40J3uO
         tEKVKzteAMaFn1qAQky+dFwQWIyy22605LW3SQXBaRM5Dibb6gV45NQpcX2dtYbbd+U2
         oCYg==
X-Gm-Message-State: ACgBeo1Hj6Ik6adrTCPVN37qeK8ajcOZecSFsVYwDXmiE9r4dSFpeCC5
        L66rRAmgj/Ep8kF82iJf5OT1hwNNjzl9wQ==
X-Google-Smtp-Source: AA6agR5zEyGUE1TDC7NRh/f0M+uxNMd9TqVSjpi8cB6WPiMB+kEZel1mzRADhq01cn8D4hMOSBpcRw==
X-Received: by 2002:a05:6512:a82:b0:48b:1241:f4cc with SMTP id m2-20020a0565120a8200b0048b1241f4ccmr6929877lfu.141.1660658612646;
        Tue, 16 Aug 2022 07:03:32 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:32 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 16/16] crypto: ux500/hash: Use accelerated noinc MMIO
Date:   Tue, 16 Aug 2022 16:00:49 +0200
Message-Id: <20220816140049.102306-17-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

After fixes to regmap we can use accelerated MMIO access to
quickly fill up the hash with new data.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v3:
- New patch based on v6.0-rc1
---
 drivers/crypto/ux500/hash/hash_core.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index be703fe4d0ec..aa91bfecba15 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -256,18 +256,13 @@ static void hash_fill_din(struct hash_device_data *device_data,
 			  const void *data, unsigned int len)
 {
 	const u8 *datap = data;
+	int evenbytes = (len / 4) * 4;
 	u32 val;
 
-	/*
-	 * We cannot use regmap_write_noinc() because regmap MMIO does
-	 * not support the noinc operations (requires .write() callback).
-	 * TODO: revisit when regmap MMIO supports regmap_write_noinc().
-	 */
-	while (len > 4) {
-		val = *((u32 *)datap);
-		regmap_write(device_data->map, UX500_HASH_DIN, val);
-		datap += 4;
-		len -= 4;
+	if (evenbytes) {
+		regmap_noinc_write(device_data->map, UX500_HASH_DIN,
+				   data, evenbytes);
+		len -= evenbytes;
 	}
 
 	if (len) {
@@ -1472,6 +1467,7 @@ static bool ux500_hash_reg_volatile(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case UX500_HASH_CR:
+	case UX500_HASH_DIN:
 	case UX500_HASH_STR:
 	case UX500_HASH_H(0) ... UX500_HASH_H(7):
 	case UX500_HASH_ITCR:
-- 
2.37.2

