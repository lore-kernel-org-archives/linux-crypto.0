Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9268CC072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 16:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B7762075D
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 16:27:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HTvI2d+K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390354AbfEXQ1m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 12:27:42 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38762 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390623AbfEXQ1l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 12:27:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so10633831wrs.5
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 09:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OpsVci6NS0D6Bf/3Go8WTx/jss3RyzyovCrA3zpdENw=;
        b=HTvI2d+KNikWYtCfyv9ErbQwk9U7SN4mNO0FU31r9IcRKjdCFOiEcfX3ljB4rfrA7R
         yNGT8C22B7n34+vtuGrX0SE/9+OZk7/YSy95mqEufDiSS3QtYDIWRpn06g5wDqHGarzk
         VuJ8l5PyKvcxzI+r0snAiTATtmCo0eQ1MjuCyGnc2IOntuJCoLmTOVwwxUzP7T+UZ2/w
         cKka3JVXHe4l873jUF1KaU6L2vm+jRkc1Abj3aOtTx4wDUfleGbOcmdq29+P0kMlfTtZ
         bnAErkDLh1l1nPQaT/eKmolaXaddGRqUPRn2sgqfrP9tT+UPY2slGZ8DoELeVWsyuHTu
         +DYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OpsVci6NS0D6Bf/3Go8WTx/jss3RyzyovCrA3zpdENw=;
        b=g1IwkvkgCd2xXHyPPu3hxxPt1cvIrbdJiH8e7/e9zMIbBxKroSiS1/1Jg5WPVGi7k1
         ZN6J1EWPNOGsurpp3jpdOjKQvEayHlrLyHZkPgvyk/fYrvae49rM4S66oIVm7StDkrrj
         2o1QDqb0q5D3TrP7lZvN3woOV1JjW8Yu2OBauNrkMZwwawOUm655itT8guZZdLTqg5Wt
         udKgVu47WIWA5BBdFG3l8ReytPiI9JkXLNlaD+s31dWCtfBdIaU3tGGKiM9TbKFGFNK9
         hWLDQItt361hftUKDBbFyxH1hO7NebiQ+HP62vmo6MZB+hktwPI12akNu2qQCwSy1uby
         t3Zg==
X-Gm-Message-State: APjAAAUdIBoWyHJ6iyT+zrH0mBrUZKOWqWT6UXuaSEEQ5LD6K+ACswjQ
        SgQ93dyODqpmLfNbs8JF/rIitlTn7Hfn+UxD
X-Google-Smtp-Source: APXvYqxRYQNMM2ILDaTxPlZrMk+NmwszppDLWVn4iyYwh8pn7KIzGpqZNUrsEYDpGPRnbbFmLAxWHQ==
X-Received: by 2002:adf:edce:: with SMTP id v14mr59665675wro.94.1558715259395;
        Fri, 24 May 2019 09:27:39 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:2042:d8f2:ded8:fa95])
        by smtp.gmail.com with ESMTPSA id l6sm2200320wmi.24.2019.05.24.09.27.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 09:27:38 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 2/6] crypto: atmel-ecc: add support for ACPI probing on non-AT91 platforms
Date:   Fri, 24 May 2019 18:26:47 +0200
Message-Id: <20190524162651.28189-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524162651.28189-1-ard.biesheuvel@linaro.org>
References: <20190524162651.28189-1-ard.biesheuvel@linaro.org>
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
index 0af08081e305..97ec8107eeef 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -522,7 +522,6 @@ config CRYPTO_DEV_ATMEL_SHA
 
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

