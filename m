Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F94C433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Oct 2022 16:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJHQyA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Oct 2022 12:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJHQx7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Oct 2022 12:53:59 -0400
X-Greylist: delayed 479 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 08 Oct 2022 09:53:58 PDT
Received: from mxout4.routing.net (mxout4.routing.net [IPv6:2a03:2900:1:a::9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8826C4316A
        for <linux-crypto@vger.kernel.org>; Sat,  8 Oct 2022 09:53:58 -0700 (PDT)
Received: from mxbox2.masterlogin.de (unknown [192.168.10.89])
        by mxout4.routing.net (Postfix) with ESMTP id CDE6E1008F7;
        Sat,  8 Oct 2022 16:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1665247557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ukf4dE615x0DESNVVTZIQKgBm7oCRLwwO/K4NDp2D4U=;
        b=RGW/fnkVu099eEytt5RqUWDS3UiEsoxLt9uwoxVrN+7FkATC4gQCslUR3Hyiwhv+FNxbSc
        0H9+ektC1+w/udzgxvx9wZJlGN4HOe1SG1ml5kjdU132rGAaf1evJ4Th8sgibOJL4aT1Wx
        UfQBUZvuro6h4BYmiN6jTCsYsIS9U0I=
Received: from frank-G5.. (fttx-pool-217.61.149.60.bambit.de [217.61.149.60])
        by mxbox2.masterlogin.de (Postfix) with ESMTPSA id 1421710042C;
        Sat,  8 Oct 2022 16:45:57 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org
Cc:     "Mingming.Su" <Mingming.Su@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>
Subject: [PATCH] hwrng: mediatek: add mt7986 support
Date:   Sat,  8 Oct 2022 18:45:53 +0200
Message-Id: <20221008164553.113260-1-linux@fw-web.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: 955c1372-43fb-49a3-a48a-2ecb07b1de5f
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: "Mingming.Su" <Mingming.Su@mediatek.com>

1. Add trng compatible name for MT7986
2. Fix mtk_rng_wait_ready() function

Signed-off-by: Mingming.Su <Mingming.Su@mediatek.com>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
 drivers/char/hw_random/mtk-rng.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 6c00ea008555..aa993753ab12 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -22,7 +22,7 @@
 #define RNG_AUTOSUSPEND_TIMEOUT		100
 
 #define USEC_POLL			2
-#define TIMEOUT_POLL			20
+#define TIMEOUT_POLL			60
 
 #define RNG_CTRL			0x00
 #define RNG_EN				BIT(0)
@@ -77,7 +77,7 @@ static bool mtk_rng_wait_ready(struct hwrng *rng, bool wait)
 		readl_poll_timeout_atomic(priv->base + RNG_CTRL, ready,
 					  ready & RNG_READY, USEC_POLL,
 					  TIMEOUT_POLL);
-	return !!ready;
+	return !!(ready & RNG_READY);
 }
 
 static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -179,6 +179,7 @@ static const struct dev_pm_ops mtk_rng_pm_ops = {
 #endif	/* CONFIG_PM */
 
 static const struct of_device_id mtk_rng_match[] = {
+	{ .compatible = "mediatek,mt7986-rng" },
 	{ .compatible = "mediatek,mt7623-rng" },
 	{},
 };
-- 
2.34.1

