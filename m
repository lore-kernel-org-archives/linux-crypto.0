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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6264DC433DB
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 20:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFD1364EB3
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 20:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBTUB4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Feb 2021 15:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhBTUBz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Feb 2021 15:01:55 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA81C061574;
        Sat, 20 Feb 2021 12:01:14 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id l13so1256655wmg.5;
        Sat, 20 Feb 2021 12:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=FDj/N3A3UZzHY2jS3uuQDHMTqWCBFhnvDduPlmq6FjM=;
        b=FrT4KyE0ckn8zIW6tSMilMD2F8kmDmys1wTM1tr/T3HiBIToOPb39uHtXHz9XcNY2C
         iRyvmhf4Ryc3utkf0462Qfv+hHNPzjI3whZ9cAS7dgTUzckuLS1SGC8ZlcqqxwaqRH7F
         0FlD1BUjDdJctVQYAn5b2gbA0DaIHNU5tjZvekVy5BT3tJFLi2Zzv/GZYtMYURufhMXW
         +6R7qOCtL1IygVz0pUdY6ZdC4wLMwCKRhAgl4U+uENEq0qSKuLAXsxrQAUYiea2/JmR7
         rBDkaJiNVYf7OeauDeCvl0k5to1kKqZdyNalfvTfyphwvzo3xslcc4i2wrhiRNDWpD6X
         FLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FDj/N3A3UZzHY2jS3uuQDHMTqWCBFhnvDduPlmq6FjM=;
        b=OxwHc1rti9NqF4WVFdMXuZaBixNqMg4g7ZytSZ3AwLVV64sojpTsayoZUSZPI/bvLh
         cK+Qk7LqPmORGFlOqTLz9XwuEiMEI3wZR++fENU11EvhKDt0GxxbiXdH+j1rZ2WHQ7vU
         fw4/iZixLcm1yL0b6ZYKAircBuRiLerclmN8yZ+3hjratRbGqJoZcGfph6pbmXjq/8cH
         5b+jCKtq7F4ynRvthuPgPJn6Jpp7t27lgmL0MDynlmdrLZhSgp/n/nqak8XF8DXrJA51
         KNbXuWDK5q5J6Bf/LX41o716rxt6Zgx2xD1kPeg7hwVzDNCyL5YV/zmTHg/wESH34ALN
         Yh6A==
X-Gm-Message-State: AOAM532Hp5wq3BMaBzgJ3TfMs0PHK2sADk0R0157WMlx9aQD4SMSkOOV
        vX0XgHSse0Co2gFBQysLtgQ=
X-Google-Smtp-Source: ABdhPJzFvcyep69YVP92PWZAjrZpOXNb+MQyVizWH1oZZzEBN8ix0dJ+szzU32RAZc7BwgfPA/ChUQ==
X-Received: by 2002:a1c:6402:: with SMTP id y2mr13213967wmb.43.1613851273606;
        Sat, 20 Feb 2021 12:01:13 -0800 (PST)
Received: from skynet.lan (23.red-2-137-25.dynamicip.rima-tde.net. [2.137.25.23])
        by smtp.gmail.com with ESMTPSA id n186sm18626900wmn.22.2021.02.20.12.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 12:01:13 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     mpm@selenic.com, herbert@gondor.apana.org.au, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        Julia.Lawall@inria.fr, noltari@gmail.com, f.fainelli@gmail.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] hwrng: iproc: set quality to 1024
Date:   Sat, 20 Feb 2021 21:01:07 +0100
Message-Id: <20210220200107.4833-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210220182935.11247-1-noltari@gmail.com>
References: <20210220182935.11247-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This allows khwrngd to make use of iproc-rng200.

Justification:
cat /dev/hwrng | rngtest -c 1000
rngtest 6.10
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 1000
rngtest: FIPS 140-2 failures: 0
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 0
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=107.179; avg=200.770; max=9765625.000)Kibits/s
rngtest: FIPS tests speed: (min=34.742; avg=39.905; max=66.458)Mibits/s
rngtest: Program run time: 97829648 microseconds

1000 successes and 0 failures -> 100% success rate

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 v2: set quality to 1024 and add justification

 drivers/char/hw_random/iproc-rng200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
index 01583faf9893..d22406528ac5 100644
--- a/drivers/char/hw_random/iproc-rng200.c
+++ b/drivers/char/hw_random/iproc-rng200.c
@@ -199,6 +199,7 @@ static int iproc_rng200_probe(struct platform_device *pdev)
 	priv->rng.read = iproc_rng200_read;
 	priv->rng.init = iproc_rng200_init;
 	priv->rng.cleanup = iproc_rng200_cleanup;
+	priv->rng.quality = 1024;
 
 	/* Register driver */
 	ret = devm_hwrng_register(dev, &priv->rng);
-- 
2.20.1

