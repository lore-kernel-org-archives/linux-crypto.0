Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BFDC433DB
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 19:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98C9964EB3
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 19:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBTT6d (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Feb 2021 14:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbhBTT6d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Feb 2021 14:58:33 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF17C061574;
        Sat, 20 Feb 2021 11:57:52 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id l12so14647942wry.2;
        Sat, 20 Feb 2021 11:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7/YI9giWpjqI5r/4UtRT8Ox2ib3gDsyQ3SVmoldJkv4=;
        b=LwlVaqGGeEC5xdjBj4ZnRTLmJX4o9I413e0uaXlkXRkVskBWCQfLgsm7c0K2xLhO+G
         cSx5Kt4ZhtbVY50jXLdvqS6nbk+tuWA8sDhvrILtbDVFn92k0a+bFp/yFpDM4NqeymaX
         UC5A2vz6CSzngCqFfe2O9RXFAEZqDEYfzH4geNLtg0hKTo9W16ojA6IqDgycZ+5I1vR5
         vX0g/XobJ/CyUREE5DghgTiahZyWYAUzcJVyxHcXTi9oKpaEM3g8v44NmcM1S5JchK2c
         gpCXMwwd9ty+F2dYNOKyHKQwsEy+xR23LDYq2Rhnz704h/4IOt8f4KLtI0k6/cpEHXfr
         sZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/YI9giWpjqI5r/4UtRT8Ox2ib3gDsyQ3SVmoldJkv4=;
        b=V4gnc26wZB6fQ2YYU+jEUJyI1PbXLm66BeLNR0cSZeFXr+oN5Tja+M/5qUZIHnJ++i
         Hc5mvkadQijimxUS+FuEIc/pWpCp+RUqZKjZCESGmF7gxl7nLuUHocleEzT+mU16z+T2
         LusBO/gKfeoPpoJJpdbdkaeCgBf5rbic5mJ7oP6rtg3Q0vG4t1rD9XlzjDzfzZqNuRdi
         BZOr4Kh4skxkcZFLJotptA5D20QNYU1USXQ3iGcyRoBFpZMAhgIixiN+4L3LPXkKvaIF
         NBAELqWjD0EmJnUFFhsCpesvlEkvTIZ8TCGfD3AYCQYZXf2htCOBAQp5GTKeB8ylqwIt
         8haQ==
X-Gm-Message-State: AOAM531MelkKI1O1ogOzCjWEtTiCWjTo0Z5evVa3kqtJzP/vllYHCmvK
        Ids9V/0Y2IpqnYd04F8JGFg=
X-Google-Smtp-Source: ABdhPJxcpifGJsT4KUrjGOroCawQkEiz2wm9Q3azOK62Vldn7Cwc1D7k0GVBzgCmGCEYbmH70zQJeg==
X-Received: by 2002:a5d:4e10:: with SMTP id p16mr14672801wrt.360.1613851071410;
        Sat, 20 Feb 2021 11:57:51 -0800 (PST)
Received: from skynet.lan (23.red-2-137-25.dynamicip.rima-tde.net. [2.137.25.23])
        by smtp.gmail.com with ESMTPSA id w81sm18368158wmb.3.2021.02.20.11.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 11:57:51 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     mpm@selenic.com, herbert@gondor.apana.org.au,
        nsaenzjulienne@suse.de, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        rikard.falkeborn@gmail.com, noltari@gmail.com,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stijn@linux-ipv6.be, ynezz@true.cz
Subject: [PATCH v2] hwrng: bcm2835: set quality to 1000
Date:   Sat, 20 Feb 2021 20:57:48 +0100
Message-Id: <20210220195748.3153-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210220174741.23665-1-noltari@gmail.com>
References: <20210220174741.23665-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This allows devices without a high precission timer to speed up boot from
more 100 s to lest than 30s.

Justification:
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

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 v2: add jusftification

 drivers/char/hw_random/bcm2835-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 1a7c43b43c6b..4b48cb7176b0 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -163,6 +163,7 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	priv->rng.init = bcm2835_rng_init;
 	priv->rng.read = bcm2835_rng_read;
 	priv->rng.cleanup = bcm2835_rng_cleanup;
+	priv->rng.quality = 1000;
 
 	if (dev_of_node(dev)) {
 		rng_id = of_match_node(bcm2835_rng_of_match, dev->of_node);
-- 
2.20.1

