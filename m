Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71B9C4707F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 06:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C51C9613C9
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 06:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhE0G36 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 May 2021 02:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhE0G3u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 May 2021 02:29:50 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81817C061574;
        Wed, 26 May 2021 23:28:15 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id m190so2942302pga.2;
        Wed, 26 May 2021 23:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=vzY8Oad/4R9FZQwiT5mR4g0+2i9N6VivPydMdc1n6Lw=;
        b=jV1LydVtgiAkGzkhsRGre3UOT0KKR7Q6JRQR+9bK/8iY/hT6uZn9cc7AcYtFm8ZoGp
         RNgWfZUxeQjUQtejKhtLzBEC1RkLesoMSMd+/lUATBa47N/T5Lm+xCcQFIi+Ac+P7TDW
         lWpxbifbvjvkyq0SACzQyuuZqUbzbNsbON3+Eo4VGdctbHN/3IagWrDi75F6lJTNsIF0
         AAH6Pq388+sKOxxMmlUuA0we62AIzOw7c87lH+DZRbrmeMLXq8XsMyV2qEs4ZZo3PAN/
         OpkaluVCDZ7v+IYc8t9KxrBb2RByoHDbTMNvwyjbe5OLw/+9EQR2/AGYt7p0ROht9rk3
         fh/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=vzY8Oad/4R9FZQwiT5mR4g0+2i9N6VivPydMdc1n6Lw=;
        b=c/vxr+RlbyKFtvZr1Dl9NQKp6OAy8+R6uuZ0rDZLpz8FWlWds9jMcMEhsQPjomp6jm
         du64IO4vqPMH5CjSazAcQJ2W/fzILdSrZjNpVIWUWhfQ6zBEtMCn3UlCpFZwirLcboRV
         0X5slS8aUhBRFglgwMxC4BH2jp3G0z4L5tPOZH8rPLMmnNd4JOzXH2cuYiQt2xXIpAUU
         1TYHep/299+vDEw1UZasst3WNZPkNVE64GVOwtMtlx5DILp5/O/sjsj7LBg5eW9Yf0hj
         d3xrQZ+35B8t9UAMyZuams+liQG/aXczFZ2TxC851WrDJ9CFVbXPgeYHwzVQbZLJfm9G
         8Ijw==
X-Gm-Message-State: AOAM530pS8EYxuVlLHXx/0Fr57aCMacxvv9lvPR2lPZJMOpgeU0z2Pbs
        Rs9Zj4LiGRS8w0Mfg4b6pmY=
X-Google-Smtp-Source: ABdhPJz6+4e2i6pbAyIN2RXp6pfitGlDeZtSkpa4S/KLBw1iB5ae/NT6z4jfA8knHCP36a+s61zV0w==
X-Received: by 2002:a63:e015:: with SMTP id e21mr2277845pgh.442.1622096895122;
        Wed, 26 May 2021 23:28:15 -0700 (PDT)
Received: from raspberrypi ([125.141.84.155])
        by smtp.gmail.com with ESMTPSA id s123sm935741pfb.78.2021.05.26.23.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 23:28:14 -0700 (PDT)
Date:   Thu, 27 May 2021 07:28:09 +0100
From:   Austin Kim <austindh.kim@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        catalin.marinas@arm.com, will@kernel.org,
        john.johansen@canonical.com, jmorris@namei.org, serge@hallyn.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, austindh.kim@gmail.com,
        austin.kim@lge.com
Subject: [PATCH] crypto: arm64/gcm - remove Wunused-const-variable
 ghash_cpu_feature
Message-ID: <20210527062809.GA1251@raspberrypi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

GCC compiler complains with below messages.

   warning: ‘ghash_cpu_feature’ defined but not used [-Wunused-const-variable=]
   static const struct cpu_feature ghash_cpu_feature[] = {
			    ^~~~~~~~~~~~~~~~~

The variable with MODULE_DEVICE_TABLE() is registered as platform_driver.
But ghash_cpu_feature is not used, so remove ghash_cpu_feature.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 arch/arm64/crypto/ghash-ce-glue.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 720cd3a58da3..c3f27d0d5329 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -615,10 +615,5 @@ static void __exit ghash_ce_mod_exit(void)
 		crypto_unregister_shash(&ghash_alg);
 }
 
-static const struct cpu_feature ghash_cpu_feature[] = {
-	{ cpu_feature(PMULL) }, { }
-};
-MODULE_DEVICE_TABLE(cpu, ghash_cpu_feature);
-
 module_init(ghash_ce_mod_init);
 module_exit(ghash_ce_mod_exit);
-- 
2.20.1

