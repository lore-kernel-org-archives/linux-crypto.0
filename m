Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5322DC433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Feb 2022 10:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiBIKbu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Feb 2022 05:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiBIKbt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Feb 2022 05:31:49 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B90E1397E0
        for <linux-crypto@vger.kernel.org>; Wed,  9 Feb 2022 02:22:07 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id m14so3091305wrg.12
        for <linux-crypto@vger.kernel.org>; Wed, 09 Feb 2022 02:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KHn/1GnLkO+cAfLyFzRg/GDk3ijEdB8uM8SM4d9QIy4=;
        b=KLxD3BmGKTKsbl31hONDsn+QLA8sf00qG4CDP7rwSaqjzmWawGylMu0ZPHWA+d9ggb
         FqugVsdV4JNntA55ZyL0Qp214YaLayaYgUVQHXS3PwiCu3z76W4j1bsfb3ePNnZ+UjC/
         G5Xa7+cMzlMBZxpKWE+uYVN3uCa7UJ1c5MRy9O+gdJ8FlFest5VNJEwJ5g5yEN57x9LI
         kcTFHV8Pu1/UN8Od/ixxNfOgft0g1Q2S5L8TlKrokHAfhGIt+4ENckOspP2qA5NjV988
         3dPap8OlEW6Q75vafMhv4z8idGJ1y+xS0x86sf0VbRS/XmJD5kIf6k92oFvvJyPA4p66
         lBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KHn/1GnLkO+cAfLyFzRg/GDk3ijEdB8uM8SM4d9QIy4=;
        b=DcmKmiKc77qAr0hIBLJcKzMYhFP05vSQNrI58Us0M7PtvupLRSFEREIyvu7zo4zIfh
         UEztT+gfC5LnJf9O0RYfhhpUh9FgMuPubRv+a7KhSk8t6XM4UjxKuY5Nhxdsk7tBJAAd
         gty8zT8GXtTfxIIK1gEq/B/uamimfAtK7wA/o88yt4QTY31vWcu7PuubD7CL9WsqN3u+
         2oO+wtoe9gHwOLYAnMlmVqHZLKl5ufUwllgauHUB1W3zm750SWMQU+ozy/9cJaW1U9Lc
         XISpcFD3Nny2RfjiwM5V4hnm25GD92svUNMNQGnvNjlgE2jXeu4ue0GPBtyKDIOxkMBI
         /V8g==
X-Gm-Message-State: AOAM531keURfaVYGi2aUAqqhvyOmMbD+HF68Wadt1JnHYZpmtG9/feUJ
        72hyoGkNk8cBKtWdnFOgTLOHcA==
X-Google-Smtp-Source: ABdhPJzR0ymzxsVN/1lOSnhyjzWRuaU9S9tnS9OP9miFe2z9vDbMl/4a8hLFMgbN079yxZ7zkvP9kw==
X-Received: by 2002:adf:f58b:: with SMTP id f11mr589980wro.427.1644402124499;
        Wed, 09 Feb 2022 02:22:04 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id z17sm4360429wmf.11.2022.02.09.02.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 02:22:04 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: cavium/nitro: fix typo on crypto
Date:   Wed,  9 Feb 2022 10:21:58 +0000
Message-Id: <20220209102158.1661976-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto had a typo, fix it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/cavium/nitrox/nitrox_req.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_req.h b/drivers/crypto/cavium/nitrox/nitrox_req.h
index ed174883c8e3..6bf088bcdd11 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_req.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_req.h
@@ -440,7 +440,7 @@ struct aqmq_command_s {
 /**
  * struct ctx_hdr - Book keeping data about the crypto context
  * @pool: Pool used to allocate crypto context
- * @dma: Base DMA address of the cypto context
+ * @dma: Base DMA address of the crypto context
  * @ctx_dma: Actual usable crypto context for NITROX
  */
 struct ctx_hdr {
-- 
2.34.1

