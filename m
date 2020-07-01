Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8FACC433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 21:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2A652082F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 21:48:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cHVLargt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgGAVsI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 17:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgGAVsH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 17:48:07 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10905C08C5C1;
        Wed,  1 Jul 2020 14:48:07 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id m26so14590309lfo.13;
        Wed, 01 Jul 2020 14:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VIrf36LHUGhDoMCxDA0a8b1GW5wPUKeQuj2rQuLiuEc=;
        b=cHVLargtKOSuIVSQy/EoW0f7ezdcsv5A6YxDnv+0g14JvkY9lbcoZo3SaV3nYObVen
         PVAvRou9QHdEtLwmWraMDwRAt/gai7M2Y/tqtqHRp+L5MXyvjCbeUP8grDjJ/mmMqjhL
         rlYSc9Q7tm9tmg7L7dW0lcHXX2srCCav8bCm2c99dGCsJtl8NzMMtufZg8keqZq+o8or
         iX524GSokG+N4cvWy96bFNETeDuTJD9gMd6I/AwvCpd54fATmlH5Dfs4KkemrtWCb4WC
         qEY4i7xLcP7xw7tndEKiaorgFZK/64UaEGAv8L4gpoDDsvGnwN7Q6vXwwLYRALqqF3o4
         +dcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VIrf36LHUGhDoMCxDA0a8b1GW5wPUKeQuj2rQuLiuEc=;
        b=oobL7b/lo0XKYz5yBB/CJfqJBtjTN397lRRfY7Uo39+/z2aysToWuYr3sly9iBWuWB
         vUoqqwK7IkwcfQPr6Fs1FLvCWg3twGliH6th2jz8GfmYIsV9Lk6kh/bcLwN14W09MUdI
         or1URUWdjpnuFun0XWXEKCBpKOyW8WvBkm6oF42Jmx7C0OYgeyifaRZESBg4jIBVoODe
         NPu25nUpQUeK3fhg1fhVCsJXPw8rKiEoYusZOUGaLTeJmgKWDITyLeodbQQIi21A2XRD
         4mG3q6xHQrDWhcncgymrz6SEYeF9lyvgyiowWOAXY5BJEj5oM7b2s025OI6gIg2WMk9F
         Og+Q==
X-Gm-Message-State: AOAM533WH1Qog397YQOW/IKEHxjiNGwYU01NizxtXmZKBZvHJfEdUaBQ
        5niVe2EgQ+CGzCfhNH4SyA9clF10fTg=
X-Google-Smtp-Source: ABdhPJzexXT6w7XOuAgwFHpQ0Aqq9iajCASf7I+zO/gKC7SKjv13LxECN/Alr8ZgKv7kCHsaCwb3NA==
X-Received: by 2002:a19:48d3:: with SMTP id v202mr16627841lfa.202.1593640084785;
        Wed, 01 Jul 2020 14:48:04 -0700 (PDT)
Received: from localhost.localdomain (h-98-128-181-241.NA.cust.bahnhof.se. [98.128.181.241])
        by smtp.gmail.com with ESMTPSA id d3sm2476812lfe.93.2020.07.01.14.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 14:48:04 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/5] hwrng: bcm2835 - Constify bcm2835_rng_devtype[]
Date:   Wed,  1 Jul 2020 22:09:46 +0200
Message-Id: <20200701200950.30314-2-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701200950.30314-1-rikard.falkeborn@gmail.com>
References: <20200701200950.30314-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

bcm2835_rng_devtype[] is not modified and can be made const to allow the
compiler to put it in read-only memory.

Before:
   text    data     bss     dec     hex filename
   2392     176       0    2568     a08 drivers/char/hw_random/bcm2835-rng.o

After:
   text    data     bss     dec     hex filename
   2464     104       0    2568     a08 drivers/char/hw_random/bcm2835-rng.o

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index cbf5eaea662c..0839236a6d19 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -188,7 +188,7 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 
 MODULE_DEVICE_TABLE(of, bcm2835_rng_of_match);
 
-static struct platform_device_id bcm2835_rng_devtype[] = {
+static const struct platform_device_id bcm2835_rng_devtype[] = {
 	{ .name = "bcm2835-rng" },
 	{ .name = "bcm63xx-rng" },
 	{ /* sentinel */ }
-- 
2.27.0

