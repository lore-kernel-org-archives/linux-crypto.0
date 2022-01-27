Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C026DC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 13:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242052AbiA0NhU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 08:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242112AbiA0NfT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 08:35:19 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A915C061747
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 05:33:42 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id v13so4786090wrv.10
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 05:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wBYBbfKnJeYUc1b/K/sTSN+3xZ7MU+5mXvQbL+YBpf0=;
        b=cvPQcV2+PDwUikYRGtN5buRuUCbCyeHatX24qTROl5cP0nZft/HvlADmJb3FsIMn1f
         fjLp2P9E5DTJISf+1KsyACgSb5gMrobgOnLq5ULTIgPRe/6Hn+WOg5WxW4zfAgwMMFTg
         3/wJnwuKUpAdXO/JcEtYKbV1ImMSu7S+bn0BWxAXKTq9XPcpkjrMriBsW5KPnnpkrq7v
         bJ5n8m/T7+/oc5kiAhuiYqB4gKE4WxMu/ngxO4aSAAYNszNC+jqwBp65Zq4QYWbTHSXs
         EcbsRhQfQJkHf0pmYGfOfxBOYVjzYdrYI7VXZCy6fOFIPKhhB07JjOVREZaxu7GN9fT6
         p6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wBYBbfKnJeYUc1b/K/sTSN+3xZ7MU+5mXvQbL+YBpf0=;
        b=SZuV1vnX4Pa2GF4ff6F/0a/0Lpi15aPShg1px/hiHyV8OCsbi/Av+11Vlzwk8rnfbr
         YP8bkBuKL9cSSMWh0fcdGQvFSR1Vez/lSWdQMa0PVKaz0zJZoYmCAlAY+nPkPShBEknj
         EdPwYKXYniggkkHH6k9WNZb8jA70QPneBCM1XhEtWHOK2OgJRbPEgPFbNIUdBCQN6Vk9
         TTpXSAAdbFtO0dNJPQGI55YNZ/4t4MNx6lvZKgYSWR/CUQupviUw5KqB2iJbzlcqncaZ
         Wcph7x4XTyZ060muqQ3Ez2jRg5PQX45yT3dW0i4j1talbtXYeh8HoBm+CYArd/kJsUmZ
         r5Ow==
X-Gm-Message-State: AOAM5320QKBojYRKCQWWU6L60bS3VLnhbgH4R/YLFjyPxesD66RPPz4f
        l5t9e0filLj4WlTJ1N4FE69ted2Q979h0A==
X-Google-Smtp-Source: ABdhPJw7/2XzmcS9TsTU/CyIVS/eE4HyfQhTzGPBJzPM3C0dRA1zgz92f00V7ixt0lmnb4l9Fk/cSw==
X-Received: by 2002:a5d:4c81:: with SMTP id z1mr3090423wrs.568.1643290421013;
        Thu, 27 Jan 2022 05:33:41 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id w8sm2173912wrq.3.2022.01.27.05.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 05:33:40 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: engine: disable BH during completion
Date:   Thu, 27 Jan 2022 13:33:32 +0000
Message-Id: <20220127133332.4011509-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When doing iperf over ipsec with crypto hardware sun8i-ce, I hit some
spinlock recursion bug.

This is due to crypto/crypto_engine not disabling BH when calling
completion function.

Fixes: 735d37b5424b ("crypto: engine - Introduce the block request crypto engine framework")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/crypto_engine.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index fb07da9920ee..b3844f6d98a3 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -7,6 +7,7 @@
  * Author: Baolin Wang <baolin.wang@linaro.org>
  */
 
+#include <linux/bottom_half.h>
 #include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -53,7 +54,9 @@ static void crypto_finalize_request(struct crypto_engine *engine,
 				dev_err(engine->dev, "failed to unprepare request\n");
 		}
 	}
+	local_bh_disable();
 	req->complete(req, err);
+	local_bh_enable();
 
 	kthread_queue_work(engine->kworker, &engine->pump_requests);
 }
-- 
2.34.1

