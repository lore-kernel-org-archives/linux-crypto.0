Return-Path: <SRS0=YET+=TA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DF5C04AA6
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 16:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE17B20645
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 16:29:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YNoNPHIY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfD3Q3t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Apr 2019 12:29:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41920 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfD3Q3s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Apr 2019 12:29:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id c12so21740863wrt.8
        for <linux-crypto@vger.kernel.org>; Tue, 30 Apr 2019 09:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wHdMgh05X5RySoTsMAgv4VWozpEYjOO1CNr0hCQjnMI=;
        b=YNoNPHIYlhOHy5BbiESIrSs5mP4dL7RkV+WQhY0iIZ2aTAH5yJglhjF/aZJFFXhhb6
         YG68LGDZPu9NFGeYrlni84yvoKJLYSDmWmKXk+6O6UE0dCvbhqclYFQ3QkXH/B7bIm2C
         8wiv9eggkeesBqh9vtm8Savbeht7l/c1LkkLd8te/2kIu07rOaUcGmtrefxPAl6S4Csr
         S6E+sfYt9NlsaQ11rhaF1Kq9mElWI2fmN5VtFNgFtxv1Z4wxICQdAKlHW3BZaQKXIRmd
         k/9f3ordMFRQO97TBpOxUjhZaiP7GEfAS3pdsyhdW8vZmXTS9eOzRO7pkXq3aLKM0Ehd
         X+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wHdMgh05X5RySoTsMAgv4VWozpEYjOO1CNr0hCQjnMI=;
        b=ddugyb9fkEm2KLyL0qyl02NdsyxZgJ/RxHfO3q+mlyEMqR3AraR3setB6bP7WVR643
         4kx14dEi2DCtRRssBbZBUamU8FxEEC0qrW2v9V7vOYGnfFzS0Q5zkzUUA0uQ0JYKYMZT
         Gc6518qPPk4RFSe50Xsj0P4N2BaV2uJwJnPAM7SwBUgynOm2MCOnJHOJdxo4/xp20H7o
         eZRjn20Rhi5Qc0Yuu1hhaZwQcT7voe60QvvU0xf1uPJCRPvdS5ClpJ1/GNhxpJJSMbK3
         tSrIpe3Y1F4nN1bL42OZEo/CJskmLtqa/Ge97o5R5A8NXKE3uD5YGaLmpUoat+/OhENe
         XtCg==
X-Gm-Message-State: APjAAAVV81tmmUHtFv8ee34IltFgvAgE//5gyp+gx7qm1eafcRAYaYEO
        Q/OYQKdK01IVmAZClw21j586qwEzS20BUA==
X-Google-Smtp-Source: APXvYqxc+FxQYD3Ixi+POp1EZQ6x7Ndehssi2GBNN0ehouv+vtnvpfe6TxMLvR4f4mUOOFc5SmwgXA==
X-Received: by 2002:adf:f7cd:: with SMTP id a13mr30802602wrq.289.1556641786342;
        Tue, 30 Apr 2019 09:29:46 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:1ca3:6afc:30c:1068])
        by smtp.gmail.com with ESMTPSA id t67sm5848890wmg.0.2019.04.30.09.29.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 09:29:45 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linus.walleij@linaro.org,
        joakim.bech@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/5] crypto: atmel-ecc: add support for ACPI probing on non-AT91 platforms
Date:   Tue, 30 Apr 2019 18:29:06 +0200
Message-Id: <20190430162910.16771-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190430162910.16771-1-ard.biesheuvel@linaro.org>
References: <20190430162910.16771-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Atmel/Microchip EC508A is a I2C device that could be wired into
any platform, and is being used on the Linaro/96boards Secure96
mezzanine adapter. This means it could be found on any platform, even
on ones that use ACPI enumeration (via PRP0001 devices). So update the
code to enable this use case.

This involves tweaking the bus rate discovery code to take ACPI probing
into account, which records the maximum bus rate as a property of the
slave device. For the atmel-ecc code, this means that the effective bus
rate should never exceed the maximum rate, unless we are dealing with
buggy firmware. Nonetheless, let's just use the existing plumbing to
discover the bus rate and keep the existing logic intact.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/Kconfig     |  1 -
 drivers/crypto/atmel-ecc.c | 13 ++++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0be55fcc19ba..4c95567e188f 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -530,7 +530,6 @@ config CRYPTO_DEV_ATMEL_SHA
 
 config CRYPTO_DEV_ATMEL_ECC
 	tristate "Support for Microchip / Atmel ECC hw accelerator"
-	depends on ARCH_AT91 || COMPILE_TEST
 	depends on I2C
 	select CRYPTO_ECDH
 	select CRC16
diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index ba00e4563ca0..5705348f540f 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -657,11 +657,14 @@ static int atmel_ecc_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	ret = of_property_read_u32(client->adapter->dev.of_node,
-				   "clock-frequency", &bus_clk_rate);
-	if (ret) {
-		dev_err(dev, "of: failed to read clock-frequency property\n");
-		return ret;
+	clk_rate = i2c_acpi_find_bus_speed(&client->adapter->dev);
+	if (!clk_rate) {
+		ret = device_property_read_u32(&client->adapter->dev,
+					       "clock-frequency", &bus_clk_rate);
+		if (ret) {
+			dev_err(dev, "failed to read clock-frequency property\n");
+			return ret;
+		}
 	}
 
 	if (bus_clk_rate > 1000000L) {
-- 
2.20.1

