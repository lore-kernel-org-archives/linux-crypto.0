Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE9FC433DB
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 17:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C0B464EC0
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 17:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhBTRs2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Feb 2021 12:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhBTRs2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Feb 2021 12:48:28 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592DBC061574;
        Sat, 20 Feb 2021 09:47:45 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id v15so14381048wrx.4;
        Sat, 20 Feb 2021 09:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a1BxLT6TTwR7kgXfpKHC0HTJGnheN1Wm7GXvvk+jB+Y=;
        b=uMW3cRB1DkbL39Ci6QxiBQIjIcYRu/1aG4KKIoyItDROE8XmHTW75sUkW2urRgS+DA
         aRMpayha90JQJaTcC0j7+RoZIYejr3n8M1EkOL9+YnQ95YAAplxpBOpb8qe1bpPmwNnS
         fmIB2PPzgzniPU8H6kndz9n4xVnGEtlxTkusQjGhHyiNPjPOMAA26+hDWV87E5Q+eF03
         CNo+0Q0G/Tfi+Kl1y5SpaVOifjKjky3YpOdodzFpp+7ywg6y534SxXiqlIG4JY9rchFe
         NW0Tczs7SkqYekvMoex/TFZUL/6FD8L1L9vcsoJ4brVU5ZCl4ox7Jqc3Cz+8EGVDVDKg
         AO3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a1BxLT6TTwR7kgXfpKHC0HTJGnheN1Wm7GXvvk+jB+Y=;
        b=el6KVekPYAJeZ9PZ5v1lJeupKwUIUavRAwe9PlRq8+7/Ujyc/CUlWcMg3/hliEagOn
         ML++nHcUj622nmo3M1GhCpjCUn++jKJCQFwgbEWCtE7JsqOKHkJ2qIOE5tAxmjxyiy4Z
         9m3vWmfaC9OCAK8dOXtVSvj9suAs9ITCatsNAKihFoIGTAcH7BiE9EgJaPh2DKrjr5Sk
         3e8NdqpH+CnIQv8SGxE9u9aGV/rNLBS3thEx+A17Br+f6FSw9b2SoCXUyOHKerft0VXg
         lHNJchvCBSmqGeOGWpR0fxBm+OxrE6BUoC2FCJpkrTEk/zdb+qlBP9c5wBLu10p6gLX6
         rzYg==
X-Gm-Message-State: AOAM530TTJ4Zmn9x1Q0dADLMakSL01xRueRQIz4z0KW3klKhP3UFvHY1
        +OLw+J0PlLkvMwFVmWsIK78=
X-Google-Smtp-Source: ABdhPJyJq7oTgyPIzNjMsvHM/GF5ZcPuKuzQYDKYmPp78cTcvZM6aOMkhcLR18NdhtKrE6nzdrWqcQ==
X-Received: by 2002:adf:ed87:: with SMTP id c7mr741974wro.113.1613843264108;
        Sat, 20 Feb 2021 09:47:44 -0800 (PST)
Received: from skynet.lan (23.red-2-137-25.dynamicip.rima-tde.net. [2.137.25.23])
        by smtp.gmail.com with ESMTPSA id t15sm17903083wmi.48.2021.02.20.09.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 09:47:43 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     mpm@selenic.com, herbert@gondor.apana.org.au,
        nsaenzjulienne@suse.de, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        rikard.falkeborn@gmail.com, noltari@gmail.com,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stijn@linux-ipv6.be, ynezz@true.cz
Subject: [PATCH] hwrng: bcm2835: set quality to 1000
Date:   Sat, 20 Feb 2021 18:47:40 +0100
Message-Id: <20210220174741.23665-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This allows devices without a high precission timer to reduce boot from >100s
to <30s.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
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

