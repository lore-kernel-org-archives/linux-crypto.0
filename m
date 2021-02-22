Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708E9C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Feb 2021 19:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16A8B64E31
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Feb 2021 19:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhBVTvZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Feb 2021 14:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhBVTvY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Feb 2021 14:51:24 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DBCC061786;
        Mon, 22 Feb 2021 11:50:44 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id i9so349375wml.5;
        Mon, 22 Feb 2021 11:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MfN9Cgym1FbsMVOmP8YcLwSJUz55n9T6vsrfPvdXcUk=;
        b=EZcjwsDZ8hKOkl4+hJ1+TzRFkoBNFQeFzt/9YNFA72zbPtAUu5F42HJelDudXgXz2E
         oU6hqvYlAFTy0NuoNedM6NlEuHOGvVXFFp2aoyUjPXPrTU50xe5nO8UsniTpKf2yX5ld
         A9faKDe8lW6S4089xdILMSCao51emUGKi9EC7sO7CZl87k88bX00rzgXxuNJDZ9PapTM
         5DTPG/+ugwj0OafqSyQ1LlQTLxdIlh+SGiA+fQwHxEOjyTbeA5RYfy2DH7xu0ddGorIE
         fNMtwQZk9Shj2clEqEwCY11BaaiDF+bo9/6G0XqFplGp6yYhXV03kz5dFyCo5RTktzT0
         AQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MfN9Cgym1FbsMVOmP8YcLwSJUz55n9T6vsrfPvdXcUk=;
        b=JHsqwyBEgl4i0sthe8e0CkmqpoDiaRU31UjV+yBKRHTwwGtuLQ2V1jMuTHZYiHUDHu
         AGkc18y82qfIZ16KbPNfPfkGUicf1WkPskPvFPD+sUe+XWyEjNMem7X28JjWR0hon4zH
         BfhNNnTPL+C9O5Ho6DRy9DrcW53lXOxXXIVR1FKA38RNOW75itKPK99le6xh6FaswyIT
         rzWT6I3pUk7RMsY2RB/jk3xNF2PKD4KF/uYsLTodXrT8v72KJKI+eN7GLlxl6FbPAsmL
         UT4cGyagy8b8Gej9StCYb4YQ2lMPjhKkeW3Atgu5vcA1d+DfzHOgatdbVL2H1tRxpujw
         abOA==
X-Gm-Message-State: AOAM531XbYQsNDRewRgz1onJfXT44FoaERlN2sfNAO/YhlRpJUF75oH0
        pyVDsNmp+vz6DCGFRkhlov4=
X-Google-Smtp-Source: ABdhPJy2ifgy8J+cwpkeeQYb40XpclKC9lDt6RF4Y3BvYOmHi6zm4x3CP/D/ulT0lNWGPVs5nMeGgQ==
X-Received: by 2002:a05:600c:350c:: with SMTP id h12mr21264827wmq.39.1614023442747;
        Mon, 22 Feb 2021 11:50:42 -0800 (PST)
Received: from skynet.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id o15sm302426wmh.39.2021.02.22.11.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 11:50:42 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     mpm@selenic.com, herbert@gondor.apana.org.au,
        nsaenzjulienne@suse.de, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        rikard.falkeborn@gmail.com, noltari@gmail.com,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stijn@linux-ipv6.be, ynezz@true.cz
Subject: [PATCH v3] hwrng: bcm2835: set quality
Date:   Mon, 22 Feb 2021 20:50:40 +0100
Message-Id: <20210222195040.16900-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210220195748.3153-1-noltari@gmail.com>
References: <20210220195748.3153-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This allows devices without a high precission timer to speed up boot from
more than 100s to lest than 30s.

BCM2835 rngtest:
root@OpenWrt:/# cat /dev/hwrng | rngtest -c 1000
rngtest 6.10
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 996
rngtest: FIPS 140-2 failures: 4
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 1
rngtest: FIPS 140-2(2001-10-10) Long run: 3
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=146.002; avg=349.394;
max=1302083.333)Kibits/s
rngtest: FIPS tests speed: (min=12.126; avg=22.750; max=23.432)Mibits/s
rngtest: Program run time: 56826982 microseconds

996 successes and 4 failures -> 99.6% success rate
1024 * 99.6% = 1019 (rounded down to 1000)

BCM6368 rngtest:
root@OpenWrt:/# root@OpenWrt:/# cat /dev/hwrng | rngtest -c 1000
rngtest 6.10
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 751
rngtest: FIPS 140-2 failures: 249
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 34
rngtest: FIPS 140-2(2001-10-10) Runs: 245
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=1.202; avg=16.434; max=1003.868)Mibits/s
rngtest: FIPS tests speed: (min=761.155; avg=8343.383; max=15662.590)Kibits/s
rngtest: Program run time: 3539183 microseconds
cat: write error: Broken pipe

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 v3: set different qualities for each SoC
 v2: add jusftification

 drivers/char/hw_random/bcm2835-rng.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 1a7c43b43c6b..a6121a04f624 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -121,6 +121,15 @@ static void bcm2835_rng_cleanup(struct hwrng *rng)
 
 struct bcm2835_rng_of_data {
 	bool mask_interrupts;
+	unsigned short quality;
+};
+
+static const struct bcm2835_rng_of_data bcm283x_rng_of_data = {
+	.quality = 1000,
+};
+
+static const struct bcm2835_rng_of_data bcm6368_rng_of_data = {
+	.quality = 700,
 };
 
 static const struct bcm2835_rng_of_data nsp_rng_of_data = {
@@ -128,10 +137,10 @@ static const struct bcm2835_rng_of_data nsp_rng_of_data = {
 };
 
 static const struct of_device_id bcm2835_rng_of_match[] = {
-	{ .compatible = "brcm,bcm2835-rng"},
+	{ .compatible = "brcm,bcm2835-rng", .data = &bcm283x_rng_of_data },
 	{ .compatible = "brcm,bcm-nsp-rng", .data = &nsp_rng_of_data },
 	{ .compatible = "brcm,bcm5301x-rng", .data = &nsp_rng_of_data },
-	{ .compatible = "brcm,bcm6368-rng"},
+	{ .compatible = "brcm,bcm6368-rng", .data = &bcm6368_rng_of_data },
 	{},
 };
 
@@ -171,8 +180,10 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 
 		/* Check for rng init function, execute it */
 		of_data = rng_id->data;
-		if (of_data)
+		if (of_data) {
 			priv->mask_interrupts = of_data->mask_interrupts;
+			priv->rng.quality = of_data->quality;
+		}
 	}
 
 	/* register driver */
-- 
2.20.1

