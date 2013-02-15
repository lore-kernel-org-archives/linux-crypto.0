From: Joel A Fernandes <agnel.joel@gmail.com>
Subject: [PATCH 1/2] omap-sham: Use pm_runtime_put instead of pm_runtime_put_sync
Date: Fri, 15 Feb 2013 01:59:27 -0600
Message-ID: <1360915168-28786-1-git-send-email-agnel.joel@gmail.com>
Cc: Joel A Fernandes <joelagnel@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:38324 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900Ab3BOIAv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Feb 2013 03:00:51 -0500
Received: by mail-oa0-f53.google.com with SMTP id m1so3446415oag.26
        for <linux-crypto@vger.kernel.org>; Fri, 15 Feb 2013 00:00:51 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Joel A Fernandes <joelagnel@ti.com>

Not doing so could cause sleep in interrupt context resulting in a kernel panic.

Tested on an AM33xx SoC device (beaglebone board).

To reproduce the problem, I used the tcrypt kernel module as:
modprobe tcrypt sec=2 mode=403

Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/crypto/omap-sham.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index edff981..b8bb583 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -923,7 +923,7 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 	dd->flags &= ~(BIT(FLAGS_BUSY) | BIT(FLAGS_FINAL) | BIT(FLAGS_CPU) |
 			BIT(FLAGS_DMA_READY) | BIT(FLAGS_OUTPUT_READY));
 
-	pm_runtime_put_sync(dd->dev);
+	pm_runtime_put(dd->dev);
 
 	if (req->base.complete)
 		req->base.complete(&req->base, err);
-- 
1.7.4.1
