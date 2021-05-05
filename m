Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D01AC433ED
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E5E9613D6
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhEEU1k (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 16:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbhEEU1b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 16:27:31 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1406BC06138D
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 13:26:32 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id l13so3203175wru.11
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 13:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TsTr8xhyvOq2/KUMVDYhNF2zkO3qagBOj+gKv7W+VAE=;
        b=xwhYVR3pXtNBDDAdWPckdTbhc5SdSF3gpi71wNopA7snaNRwF0AJMIdZMpCIXIBdpd
         01HVLi77gO/8O5MqHXuCxsinWxrIH4ny3UpahG3+YeIks5nGfDodRRLuRvJveqYzS+LX
         QyB1aX0tKGnEhFmKnVTrO/8iGDbbElMyKb19z0ZF9GKqE9Ahb5yyNwnFXHiANMS/p5qL
         Mvpdds1lJEE/mwRVhaaTckHWQQ0slAT3pp6/oC6deyNLoNSPWJbqfrOcFWXAN/6jM6oe
         VeHCy39MoUH9PXf64zgrwhYEfz0iGEn/NBQCbgeKa8GjBKL/CKIHw4hr58TU1QA3UpvH
         QA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TsTr8xhyvOq2/KUMVDYhNF2zkO3qagBOj+gKv7W+VAE=;
        b=jZbPGGPSfyTnklSmotIt8Aa/govxQ0kN895cTPTNkfx0lNV7AsBdWzvEYDrke3gkbu
         aiVPPNGVmLLCbqpyC7BA2CP+KCeRjyeXtTlHj0/8M6cyCH2vIuuoMCW58fBineQ4W7oN
         04NA9Pm5HHN7iflTGr5e0Xm9Zi21xhVQHeSyHHZv+qi3XsWNehFox8mwiG96M2t2jfxg
         nZUmm73J2HoM2MKxyqL6GN2tGFWb2mr510tokLhJ20bKwzHApWS8FkgV5kCm019txPms
         DkLI1LzmePk6MxjK2YJB0jt+DioDNNOVEZofm9hOduuT03omg4UTI5XlV8PX4kMyM+px
         Vi5A==
X-Gm-Message-State: AOAM531fONxyyUEBX7KTe/NLxlWNmBJAlmWwxY+nrUxYc+7yqyg1x8GP
        XZHtCvMf/XJN8CPNf4Jo78gg0A==
X-Google-Smtp-Source: ABdhPJzJwSWhqGP8eX2CBd79ELjEJRHC/2Mz/y4/G3T2FEYUUPGebl79MKevNoKTcP0DX7ZqC1c+zg==
X-Received: by 2002:adf:efc3:: with SMTP id i3mr875780wrp.243.1620246390870;
        Wed, 05 May 2021 13:26:30 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id a15sm497245wrr.53.2021.05.05.13.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:26:30 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     chohnstaedt@innominate.com, davem@davemloft.net,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 07/11] crypto: ixp4xx: Do not initialize static to NULL
Date:   Wed,  5 May 2021 20:26:14 +0000
Message-Id: <20210505202618.2663889-8-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210505202618.2663889-1-clabbe@baylibre.com>
References: <20210505202618.2663889-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes all checkpatch report about static init.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/ixp4xx_crypto.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 5b8ffa4db45d..954696a39875 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -221,10 +221,10 @@ static const struct ix_hash_algo hash_alg_sha1 = {
 };
 
 static struct npe *npe_c;
-static struct dma_pool *buffer_pool = NULL;
-static struct dma_pool *ctx_pool = NULL;
+static struct dma_pool *buffer_pool;
+static struct dma_pool *ctx_pool;
 
-static struct crypt_ctl *crypt_virt = NULL;
+static struct crypt_ctl *crypt_virt;
 static dma_addr_t crypt_phys;
 
 static int support_aes = 1;
@@ -275,7 +275,7 @@ static DEFINE_SPINLOCK(desc_lock);
 static struct crypt_ctl *get_crypt_desc(void)
 {
 	int i;
-	static int idx = 0;
+	static int idx;
 	unsigned long flags;
 
 	spin_lock_irqsave(&desc_lock, flags);
-- 
2.26.3

