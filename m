Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1D3C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Jul 2022 13:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiGAN1u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Jul 2022 09:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiGAN1u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Jul 2022 09:27:50 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DA5675B8
        for <linux-crypto@vger.kernel.org>; Fri,  1 Jul 2022 06:27:48 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id h14-20020a1ccc0e000000b0039eff745c53so1574358wmb.5
        for <linux-crypto@vger.kernel.org>; Fri, 01 Jul 2022 06:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vElcCtw04QzuAH22LcbLyJ8OXVl5mqZvOzdsJCSKnNs=;
        b=SV30SZRPWDjribOlXEJdd/yg3juNcqboVOE6JCXCYDcrNei6x23hGFFoTjLeyG5w7s
         8oWs+rkoN0jpkAG4owViglzYHdY/zoC59LuweSuaQMU2oES6Las75LQWod71360VGQsQ
         fxqF643w/vVY4wq3myXS+WkUSXtZVMLQrFyYzdUD020PR2lwg4J/PIIorUhbPHjLyKXl
         eWVvO6aIheXIFXR7rptanl2FwKYc2LwRJXbKOgGiGarJkmhPSIpXFuqrjll593pSlad6
         njT/YBsVcJ///r28v3LoGpgwQSDPxp1VzpKJzu+OD9htbnF4+kaQ3t6G/3lIkRRyuduV
         n4Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vElcCtw04QzuAH22LcbLyJ8OXVl5mqZvOzdsJCSKnNs=;
        b=zpn2ICSqXPVofGZMKSFjyOeT4DLAa0m4zuuadqf+cb3tHkXx2cTwuFppv+KKjKQ7Al
         yRhMD4frnvZfp/4Cq7kmi5wGgF8IlePxKuSn7BAffJo+D4it3GGY6cC6lWFpa6SS1iP1
         Ovr7zEdMT/zgRfAc7PaOmPBp53EdFlzyDgdJ0lkMTk/Tz+djSdMEdNsXGvfG2/VtIWhC
         M9BmL3jDXKrPEH+GJkZSJ4bRZs0oJPqh9UCpFMH8qiXRuy5YWBJIbFs1ldIDHXwhO6zd
         wbVi1mD1Eepr5uQKrTFtRWI29jCSw1V7zcp2S2a7H7SWub8Cv25NsQLPmjejNIolmoiY
         V61g==
X-Gm-Message-State: AJIora+pS2DSVyFvUAlRQVDEeKBTAF6uqt41GEmuOaJeRLlZB4L7udRs
        7eeWqMf2NBP0ye4qRhe7vgQnug==
X-Google-Smtp-Source: AGRyM1sWqkqw8VCKFu9qbSXKAUEUl2mZp5uKcKNoVZAyGcrDq9btYZgn0zHEhiuQOLpImL9tx3r5+w==
X-Received: by 2002:a1c:f20b:0:b0:39e:f4b9:24e3 with SMTP id s11-20020a1cf20b000000b0039ef4b924e3mr16541364wmc.51.1656682066956;
        Fri, 01 Jul 2022 06:27:46 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id h13-20020adff4cd000000b002103aebe8absm22354337wrp.93.2022.07.01.06.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 06:27:46 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, hch@lst.de, heiko@sntech.de
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [RFC PATCH] crypto: flush poison data
Date:   Fri,  1 Jul 2022 13:27:35 +0000
Message-Id: <20220701132735.1594822-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On my Allwinner D1 nezha, the sun8i-ce fail self-tests due to:
alg: skcipher: cbc-des3-sun8i-ce encryption overran dst buffer on test vector 0

In fact the buffer is not overran by device but by the dma_map_single() operation.

To prevent any corruption of the poisoned data, simply flush them before
giving the buffer to the tested driver.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---

Hello

I put this patch as RFC, since this behavour happen only on non yet merged RISCV code.
(Mostly riscv: implement Zicbom-based CMO instructions + the t-head variant)

Regards

 crypto/testmgr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index c59bd9e07978..187163e2e593 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -19,6 +19,7 @@
 #include <crypto/aead.h>
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
+#include <linux/cacheflush.h>
 #include <linux/err.h>
 #include <linux/fips.h>
 #include <linux/module.h>
@@ -205,6 +206,8 @@ static void testmgr_free_buf(char *buf[XBUFSIZE])
 static inline void testmgr_poison(void *addr, size_t len)
 {
 	memset(addr, TESTMGR_POISON_BYTE, len);
+	/* Be sure data is written to prevent corruption from some DMA sync */
+	flush_icache_range((unsigned long)addr, (unsigned long)addr + len);
 }
 
 /* Is the memory region still fully poisoned? */
-- 
2.35.1

