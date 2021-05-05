Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2941C433B4
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86AF2613FE
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbhEEU1Z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 16:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234960AbhEEU1Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 16:27:25 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7599AC061761
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 13:26:27 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id l14so3219604wrx.5
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 13:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S273ylil1PBH+oZMCXQ1Btaew0sXCYLtOcO/7ouch+o=;
        b=Bp6HZMSaLNoIULe4qbu9CLZlGZ7utjPsMXEQtuOG8/BtcvADcx19+D/9ww7KNqF+7D
         M2n4Cqq4ih3tGNbo+PgFTs0taaA9Lt6AwnZLPhEj/2mJbsrsYAiE/RrCugW52xwX68Fu
         hYK511GB88qex+LnAw07rP3R+dluaG4oJdjUVJDMkSSS2CX80QwZb0HKA9d60K9HKzs7
         9hZNNnHfxeIhQZ9zd0EL1PabJh8kjYxdFoxfsBHr0EFRLCVbEa0U3pv/yKgyYsI/yul+
         YeifOi1qU/6UP0n2Vitst52NyhU514Z2fzc2vLNgTrVqOmJFHOhbfJDUuUrRYbx++G5L
         ae1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S273ylil1PBH+oZMCXQ1Btaew0sXCYLtOcO/7ouch+o=;
        b=W8D3A8QHIKVtVPmH7Ifo5Gt3Q8ScvqbHcdJ8S4f5QaJ3zAkX2TLLVVFFSUhTDYD8uT
         kpOukM/2n2SNDd7XCnTDHs/1Ptue7ev8oefI4R68cbAYAbLcvrzN4aFkNB1koAVtjXA0
         6D/XHDEAgrZOZs8qZl6gBAPtbthru4QqMoWGj96sgYVQjICoz5SxzGnpae4R7HyAF1Vi
         br0DzqF6OsKOkAF91NlTE4xK4LtEXH0ujDzbyrywqepYWM9n3i1MOJoZKDHDKVL9Sh99
         IxikgY8TOvL2oDbWpcOR+8c7G4NcFT2PwLbK9MDtee/qDXRrMjNhnzxfYCBHCobI5Ios
         lpjQ==
X-Gm-Message-State: AOAM5306XlJUPKiaOJg35I8hRXWpYW9di0vNIKBZdufkYjUZ7OcPwxCb
        ySrwFsS1zM6RvPO9bgvc/pCORg==
X-Google-Smtp-Source: ABdhPJxACmwt02PG410uR0gx8Unli3fyhvkP/Vj4uJ7iNpjW4OQhnE9zZ1GjnCbbKd0+5wCmoamg/A==
X-Received: by 2002:a5d:4e06:: with SMTP id p6mr880333wrt.378.1620246386091;
        Wed, 05 May 2021 13:26:26 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id a15sm497245wrr.53.2021.05.05.13.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:26:25 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     chohnstaedt@innominate.com, davem@davemloft.net,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 01/11] crypto: ixp4xx: dma_unmap the correct address
Date:   Wed,  5 May 2021 20:26:08 +0000
Message-Id: <20210505202618.2663889-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210505202618.2663889-1-clabbe@baylibre.com>
References: <20210505202618.2663889-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Testing ixp4xx_crypto with CONFIG_DMA_API_DEBUG lead to the following error:
DMA-API: platform ixp4xx_crypto.0: device driver tries to free DMA memory it has not allocated [device address=0x0000000000000000] [size=24 bytes]

This is due to dma_unmap using the wrong address.

Fixes: 0d44dc59b2b4 ("crypto: ixp4xx - Fix handling of chained sg buffers")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/ixp4xx_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 0616e369522e..ed3deaa5ed2b 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -330,7 +330,7 @@ static void free_buf_chain(struct device *dev, struct buffer_desc *buf,
 
 		buf1 = buf->next;
 		phys1 = buf->phys_next;
-		dma_unmap_single(dev, buf->phys_next, buf->buf_len, buf->dir);
+		dma_unmap_single(dev, buf->phys_addr, buf->buf_len, buf->dir);
 		dma_pool_free(buffer_pool, buf, phys);
 		buf = buf1;
 		phys = phys1;
-- 
2.26.3

