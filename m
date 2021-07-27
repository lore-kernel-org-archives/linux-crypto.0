Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E9BC19F35
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Jul 2021 10:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FD2E61994
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Jul 2021 10:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbhG0KYq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Jul 2021 06:24:46 -0400
Received: from muru.com ([72.249.23.125]:55854 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236292AbhG0KYF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jul 2021 06:24:05 -0400
Received: from hillo.muru.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTP id DA87E8171;
        Tue, 27 Jul 2021 10:24:21 +0000 (UTC)
From:   Tony Lindgren <tony@atomide.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Lokesh Vutla <lokeshvutla@ti.com>,
        Tero Kristo <kristo@kernel.org>
Subject: [PATCH 6/6] crypto: omap-sham - drop pm_runtime_irqsafe() usage
Date:   Tue, 27 Jul 2021 13:23:39 +0300
Message-Id: <20210727102339.49141-6-tony@atomide.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210727102339.49141-1-tony@atomide.com>
References: <20210727102339.49141-1-tony@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit b0a3d8986a76 ("crypto: omap-sham - Use pm_runtime_irq_safe()") added
the use of pm_runtime_irq_safe() as pm_runtime_get_sync() was called
from a tasklet.

We now use the crypto engine queue instead of a custom queue since
commit 33c3d434d91 ("crypto: omap-sham - convert to use crypto engine").

We want to drop the use of pm_runtime_irq_safe() in general as it takes a
permanent usage count on the parent device causing issues for power
management.

Based on testing with CONFIG_DEBUG_ATOMIC_SLEEP=y, modprobe omap-sham,
followed by modprobe tcrypt sec=1 mode=423, I have not been able to
reproduce the scheduling while atomic issue seen earlier with current
kernels and we can just drop the call to pm_runtime_irq_safe().

Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Tero Kristo <kristo@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/crypto/omap-sham.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2113,7 +2113,6 @@ static int omap_sham_probe(struct platform_device *pdev)
 	dd->fallback_sz = OMAP_SHA_DMA_THRESHOLD;
 
 	pm_runtime_enable(dev);
-	pm_runtime_irq_safe(dev);
 
 	err = pm_runtime_get_sync(dev);
 	if (err < 0) {
-- 
2.32.0
