Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45BBC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Mar 2022 20:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353101AbiCUULn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Mar 2022 16:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353102AbiCUUKU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Mar 2022 16:10:20 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD8D186160
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 13:08:11 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a1so20846286wrh.10
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 13:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BLjOQyn7vWMkEPL3YYfpuMi7xJgnIr5nJYm6Y0L1/14=;
        b=jKZtZBoF+9D29LJdTrP/WOpH/cL6jYaJC9M0oJuNgOyTdPr1TJAPI1W2pBoz9Layd9
         7uSO+zDYiRBUX0UM8LbbsPxXW91fIBcgIqvMT8eaf1xa2hWGc3CNRNq4CXuQ1Y6eu9eJ
         6hqRRER8yr1rBhBksWX42igHEepCKJnCHaDZbl1Kp7FdNrkS4eBZohJS+YpYLOFo5z/p
         yrr3hOdZpAuRTTFF0I7rHrh+pqKRW7GmLAGgTcNBz/DiHtFUsoM0WMfltE7owv7QMGxZ
         jG9wL+y2FdunXMckttPckesTN2HvpfXNg9vM2yI26FsFxEqFPrWGb4NI9t1tVdn4jlPD
         oHXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BLjOQyn7vWMkEPL3YYfpuMi7xJgnIr5nJYm6Y0L1/14=;
        b=oK7qOGDy05+JRCSY7QorW6sMnkNVNOdg7Y8mhUpaAFPx+Nv1dd2nosEhykDDQcxU+7
         G9JI2MeusPkMHUtp6R2KQJk46t0or9LGIJURgr2CdtK0Nudsna3/51sohdUsd6Bb3VuC
         UGLlEakZDNlP9feIc6OLBHXNYL/WB0z/57zQKSPurTl45qU1slXBfUAwD++c0NJ4Lg1S
         1HbWW0duOFe2QCPop3Kcpw+JvHM8iAjeqDQKZQl6E37EAb1+PwvJDsltszpkP2U6VzBC
         I5unzmqMMZGcgEAPY8XnztzTkeFWrOoKDL6S7mMZt2gt+FiUUmEn5hNdgDJ7JjHijLch
         KX+w==
X-Gm-Message-State: AOAM532DhVU3hBWgKV1xM584/tb4Aefu1D0MdW4NcYzcrYWLRQex5oZM
        qPG5E6H7Vc2jJBu8eZJjbFdC4Q==
X-Google-Smtp-Source: ABdhPJw+15wozTaGAkfF7E2x/BPx9ctqPg1cM7rmgS855iWGEC3nUElEC3OQjcdUVIZxkSJwNtjFmw==
X-Received: by 2002:a5d:59a1:0:b0:204:1777:fc08 with SMTP id p1-20020a5d59a1000000b002041777fc08mr3924749wrr.545.1647893289973;
        Mon, 21 Mar 2022 13:08:09 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id i14-20020a0560001ace00b00203da1fa749sm24426988wry.72.2022.03.21.13.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 13:08:09 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 26/26] crypto: rockchip: use read_poll_timeout
Date:   Mon, 21 Mar 2022 20:07:39 +0000
Message-Id: <20220321200739.3572792-27-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220321200739.3572792-1-clabbe@baylibre.com>
References: <20220321200739.3572792-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use read_poll_timeout instead of open coding it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 1d20f58275f0..0ea47f50607e 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -9,6 +9,7 @@
  * Some ideas are from marvell/cesa.c and s5p-sss.c driver.
  */
 #include <linux/device.h>
+#include <linux/iopoll.h>
 #include <asm/unaligned.h>
 #include "rk3288_crypto.h"
 
@@ -314,8 +315,7 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
 		 * efficiency, and make it response quickly when dma
 		 * complete.
 		 */
-	while (!readl(reg + RK_CRYPTO_HASH_STS))
-		udelay(10);
+	read_poll_timeout(readl, v, v == 0, 10, 1000, false, reg + RK_CRYPTO_HASH_STS);
 
 	for (i = 0; i < crypto_ahash_digestsize(tfm) / 4; i++) {
 		v = readl(reg + RK_CRYPTO_HASH_DOUT_0 + i * 4);
-- 
2.34.1

