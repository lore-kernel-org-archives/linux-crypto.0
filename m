Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1641BC43603
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 22:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D250621556
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 22:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576017540;
	bh=fPYe7mybRTtgS7TF3dXPM7tzpbCplt6obj5+mrw1UTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=S8nIEK3MAdEOMSTBwZXDsZN97epmbkSm3LzH+Dm5z974jjYM+c+ns/QXPqZkywiCa
	 XvieS5NZZ5udd8z+eJuqhuZYh10vyCyVdB6TTcqFaz6apk+nriGsSGsFcY+JRU5yFn
	 ue70vnPWxsbH4FWKWH4oRlHnwcbYT/ZXOfcPrwdY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfLJWiz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 17:38:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729831AbfLJWde (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 17:33:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E56C521556;
        Tue, 10 Dec 2019 22:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017214;
        bh=fPYe7mybRTtgS7TF3dXPM7tzpbCplt6obj5+mrw1UTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vD4XuOi05HviiHFHJQ4XyD1rNMl3tof2BxftD2hJ9uGRw/Ed0S6LQWy6XHRoM8ZWM
         LNjCmp9N+R0k7nBNfkxz6FPTLuXzjR23OxN4rKRON+18VYzFwnBhKnWRNZGJYbubJD
         xaF1O4gR56tz3Ni+0xGwKuLsiZMS1iQhCktrOguE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Adam Ford <aford173@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 14/71] hwrng: omap3-rom - Call clk_disable_unprepare() on exit only if not idled
Date:   Tue, 10 Dec 2019 17:32:19 -0500
Message-Id: <20191210223316.14988-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223316.14988-1-sashal@kernel.org>
References: <20191210223316.14988-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit eaecce12f5f0d2c35d278e41e1bc4522393861ab ]

When unloading omap3-rom-rng, we'll get the following:

WARNING: CPU: 0 PID: 100 at drivers/clk/clk.c:948 clk_core_disable

This is because the clock may be already disabled by omap3_rom_rng_idle().
Let's fix the issue by checking for rng_idle on exit.

Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Adam Ford <aford173@gmail.com>
Cc: Pali Rohár <pali.rohar@gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Tero Kristo <t-kristo@ti.com>
Fixes: 1c6b7c2108bd ("hwrng: OMAP3 ROM Random Number Generator support")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/omap3-rom-rng.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
index a405cdcd8dd23..4813f9406a8fa 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -119,7 +119,8 @@ static int omap3_rom_rng_probe(struct platform_device *pdev)
 static int omap3_rom_rng_remove(struct platform_device *pdev)
 {
 	hwrng_unregister(&omap3_rom_rng_ops);
-	clk_disable_unprepare(rng_clk);
+	if (!rng_idle)
+		clk_disable_unprepare(rng_clk);
 	return 0;
 }
 
-- 
2.20.1

