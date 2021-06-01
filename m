Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8DA7C47080
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 15:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E06C6128A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 15:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhFAPN2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Jun 2021 11:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbhFAPNZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Jun 2021 11:13:25 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A023C0613CE
        for <linux-crypto@vger.kernel.org>; Tue,  1 Jun 2021 08:11:43 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q5so4088633wrm.1
        for <linux-crypto@vger.kernel.org>; Tue, 01 Jun 2021 08:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+GjmxYyUga7B4GL+GCcTHSSwwi6F91q3aeKrD7ugyx4=;
        b=ALrkzpxJ1biPvqhqumjgIqBXq+bep0HrKvz3jz+nlA/sKQvui6LfibMA1czxiBD2Tn
         BpvnZsNvgMoxqhyDcLqpwiK99vAb7nBCtcE803sHwg0yjzhiqlV/5NoTKT+6UkqfnVlt
         lrwL7hY9Sm4oa+XH4zoClOyt+8AvjI+Lq7rwZLjuS4QDoWUU5xgDAyyFsOmovjSGq7cj
         QuJg8XIWB41cFrLz3/xvhn3TmRYzCywHyFVmYqSyXa/y2v+4S6ecV0MW3XWbdSng0Ico
         wzHmja10yvaOc+U5fydDd6RLs9FNUUF0dtJR+2Lk3jOufW/Lb01JReqM6+0S7FMCs+mN
         mYpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+GjmxYyUga7B4GL+GCcTHSSwwi6F91q3aeKrD7ugyx4=;
        b=hl8uGDjhvbvUOCg1lYZyDnoRHc7tDqlbRWRJoU3n/uy3bt1vlOV5aBXMo7uPbBZnXp
         I7i48oWdGvHR0urhZ3DQohXekd7bafVn99zwN+Z9aEwwhtICyKJBSXAjFNhkPKWRg9oQ
         qzLNPLHs4uAn6O24fXY8V9LzgwcYlcPyOWa48UCQNyGZwBr24D2OaYaOcmRvYpEejj4X
         VrbV6GKbXZngOjoD7ZxD/iEvaJ5DfqHcMrFlooB2gegbJkwkY0yqWThc0foglLJGX/ud
         3+5e93Y3Knzy54qRm1LElJageJhKt6quQu7zcr5YBFBqYMohtFdt/atrsaamKI2BRYLf
         j5jA==
X-Gm-Message-State: AOAM530fCytfD/K5MgZh2/+0D20Ho7e0yM9wVdkOKrDIX4FUyBHMDLNI
        AYrr/26uD1V2jJNOzeHebNcv4g==
X-Google-Smtp-Source: ABdhPJyV59TMbxN75gBzpa2VPvEZRuB+a5vUoi7VNyYoZhJaB1DMacQ4LthLe9mCtnE3Cn36NQ270A==
X-Received: by 2002:a5d:4f05:: with SMTP id c5mr2512404wru.341.1622560302106;
        Tue, 01 Jun 2021 08:11:42 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id f20sm22344163wmh.41.2021.06.01.08.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 08:11:41 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        robh+dt@kernel.org, ulli.kroll@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 4/5] ARM: gemini_config: enable sl3516-ce crypto
Date:   Tue,  1 Jun 2021 15:11:31 +0000
Message-Id: <20210601151132.1893443-5-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601151132.1893443-1-clabbe@baylibre.com>
References: <20210601151132.1893443-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Enable the crypto offloader by default.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm/configs/gemini_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/gemini_defconfig b/arch/arm/configs/gemini_defconfig
index d2d5f1cf815f..3ae4b8f62b82 100644
--- a/arch/arm/configs/gemini_defconfig
+++ b/arch/arm/configs/gemini_defconfig
@@ -100,3 +100,4 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_FS=y
+CONFIG_CRYPTO_DEV_SL3516=y
-- 
2.31.1

