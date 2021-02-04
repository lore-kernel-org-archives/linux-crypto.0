Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C45C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E786E64F60
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbhBDLPx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235749AbhBDLNX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 06:13:23 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD59EC061A10
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 03:10:29 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id w4so2744954wmi.4
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 03:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hrNr+lBWtFId4EzjUkysKAYnQC+wg9XBY1JaRyhRGmU=;
        b=wCl0IaHIQhVpYAG4G1XGZ11OJZCpT+nf40JxNtK/yc+i2oMo9dm0aJhJzAqrUs5tZq
         FvFd5kcpNZcSkMIkXUKXojCIAXax2YYl6f3UUb7+IcUKpRf4nxy2ZTwBCW79IwyBXPxe
         nopVLMan39vBhud+20LlTluJ6uScxi/yGDBBp/YSapWUhKBRLo35hbP6iqXDZBnKJcbC
         CFwip/DRDdTdyItXEtbWAmYNzhJE8Vvg7y6c3IcP5y2n5d0INnR0TZodPX/41Y5ytAoQ
         RaM+Ba3HalHyJBPImyICoe+EABpG6OYlwTQ/m0DC5KZBtguzx6yVEoQh2iE7p8a7P0UZ
         abBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hrNr+lBWtFId4EzjUkysKAYnQC+wg9XBY1JaRyhRGmU=;
        b=UypXwHa7zEC4vRfs1hOd8Etp0T+MxhHH5VSUqFKyzbNfZbtzMxyMEBhETZydy9izEi
         7dh9An/n5n+nie0YIxjcQkZiKkyQHELL113bOXbpuvsMQQGW0xSBfYd4YJo9/N0LqNx8
         etFhZU6VFjR4v7PzeSnPkttKlGsZeyLL0Yd4hNI2SNNsNauu96CQn1EunTzPq3e/fZYr
         0YHoJTFUV499UYTsH3D1BUS/3oeMMFpMXBnHSWexpmUXNqTwCf6MwRmi216JXSuu1DLE
         yZA+MPv367xJsnGim0BmIwh2kMrc1UcZQr1159TL4+yS+siA3g2Wek0XvMfPz2YJCwZn
         Uweg==
X-Gm-Message-State: AOAM5337TqzxsRgeK6B3i1bihCaLOuOPMjnTJNhPZINaXV0Ldp2OmnUa
        DZnvwNuOzQVDkmGj2vqqWuIf2A==
X-Google-Smtp-Source: ABdhPJyQt1sKw0ek1Sz27bkoNIJ4Dc3TqSZmz3zCEA0n7R042NG3hUP1E6LQ8QMiCibzFOUbIpWBnA==
X-Received: by 2002:a1c:9ec9:: with SMTP id h192mr7238710wme.28.1612437028668;
        Thu, 04 Feb 2021 03:10:28 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id y18sm7696218wrt.19.2021.02.04.03.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 03:10:27 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 20/20] crypto: cavium: nitrox_isr: Demote non-compliant kernel-doc headers
Date:   Thu,  4 Feb 2021 11:10:00 +0000
Message-Id: <20210204111000.2800436-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204111000.2800436-1-lee.jones@linaro.org>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/cavium/nitrox/nitrox_isr.c:17: warning: expecting prototype for One vector for each type of ring(). Prototype was for NR_RING_VECTORS() instead
 drivers/crypto/cavium/nitrox/nitrox_isr.c:224: warning: Function parameter or member 'irq' not described in 'nps_core_int_isr'
 drivers/crypto/cavium/nitrox/nitrox_isr.c:224: warning: Function parameter or member 'data' not described in 'nps_core_int_isr'

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/cavium/nitrox/nitrox_isr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.c b/drivers/crypto/cavium/nitrox/nitrox_isr.c
index 99b053094f5af..c288c4b51783d 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -10,7 +10,7 @@
 #include "nitrox_isr.h"
 #include "nitrox_mbx.h"
 
-/**
+/*
  * One vector for each type of ring
  *  - NPS packet ring, AQMQ ring and ZQMQ ring
  */
@@ -216,7 +216,7 @@ static void nps_core_int_tasklet(unsigned long data)
 	}
 }
 
-/**
+/*
  * nps_core_int_isr - interrupt handler for NITROX errors and
  *   mailbox communication
  */
-- 
2.25.1

