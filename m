Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C10AC4743C
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jun 2021 18:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2994960FD8
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jun 2021 18:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhFUTBu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Jun 2021 15:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhFUTBt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Jun 2021 15:01:49 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58046C061574
        for <linux-crypto@vger.kernel.org>; Mon, 21 Jun 2021 11:59:34 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b3so10581965wrm.6
        for <linux-crypto@vger.kernel.org>; Mon, 21 Jun 2021 11:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tDnzs4S5mWCJVykG1gJ2TrxiTAKGRBG0mNiuKKTkJDc=;
        b=IQZsErqzy0GD9BWUQSt0y7ojPiV79nkjcR0kDron5cYD9Prlnll6+uKAgSinS6BxCq
         wbd3Xhdz/kHPMBUqpr63I6CIdVMO4TJfQvx0Ji2YypFcd6QpzNPPI+h62pqXlvki9XbR
         CmbBAoEVcnKTZaFpO0ZujR/yV3r39AOG1YcDYI865wT3i2qR1VxJ6cP1VO4VrnAt9s9j
         WKZAlwh4SAdvqrRZxjwvqcQp9uazkFd0Uht6WrDoSKTocQqI7rH3J6LdXvR8KLzKMqqX
         dk3oFK+rNgEtDKTqV/B58tDy3Etkj98Anynkh8czotG46uDpBZuYqChfgr7M6It13SK9
         Z/TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tDnzs4S5mWCJVykG1gJ2TrxiTAKGRBG0mNiuKKTkJDc=;
        b=UWfkVeCIO7Dz0uEcgIheZ7pBH7IHMDXs23p5C5qoEBcbfNLUYP2BWlu5oCwn8nByaG
         v1bKBkSoHLjFpFCmXWGUk3KwCSEaTtm5Ms8rRR+O5wF9/8Xx+wr/1jVv+VjwKhal0WLZ
         rjQnPTDPiGOKI/gHN9byAj+7o/e4oWSjedFQ5ZZPcYUBPgHb4Fy/rNvIgPcG6BwlJCIX
         apcNepnh3sSu8Omw+XQSlv3tTmxd6dF6dpNJVkN/PMB0fB1vrUKGR/5y55qECW/aIKFO
         dvqzS5OKO/BHeezpXLk9Gxmm1+WhT0YKxVAZ57hyvWCYRVeKzfE80G5BWysG/81TiW+I
         yjHw==
X-Gm-Message-State: AOAM531AmdOm3AjZew9abaYJFx+Pv8RkMQJZ+Lm4P5z8mcoIV4HSrv8x
        oUtYfN8t5pUjI/wMtlebt2KMCg==
X-Google-Smtp-Source: ABdhPJzWBDHT4D757byXSDoPav1GnjgxtqgyBjgjRQ96BEfuZx3DWW6os8cshh4J3zQ0QMTS3s0PEQ==
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr29381043wrr.188.1624301973014;
        Mon, 21 Jun 2021 11:59:33 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id 9sm458818wmf.3.2021.06.21.11.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 11:59:32 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linus.walleij@linaro.org, ulli.kroll@googlemail.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, lkp@intel.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: sl3516: depends on HAS_IOMEM
Date:   Mon, 21 Jun 2021 18:59:26 +0000
Message-Id: <20210621185926.4181785-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The sl3516 driver need to depend on HAS_IOMEM.
This fixes a build error:
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/crypto/gemini/sl3516-ce.ko] undefined!

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 99b090790178..4f3b7da24495 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -268,6 +268,7 @@ config CRYPTO_DEV_NIAGARA2
 
 config CRYPTO_DEV_SL3516
 	tristate "Stormlink SL3516 crypto offloader"
+	depends on HAS_IOMEM
 	select CRYPTO_SKCIPHER
 	select CRYPTO_ENGINE
 	select CRYPTO_ECB
-- 
2.31.1

