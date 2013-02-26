From: agnel.joel@gmail.com
Subject: [PATCH v3 1/2] omap-sham: Use pm_runtime_put instead of pm_runtime_put_sync in tasklet
Date: Tue, 26 Feb 2013 10:04:31 -0600
Message-ID: <1361894672-10431-1-git-send-email-agnel.joel@gmail.com>
Cc: Joel A Fernandes <joelagnel@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:40479 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759709Ab3BZQEu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Feb 2013 11:04:50 -0500
Received: by mail-da0-f48.google.com with SMTP id w4so2070442dam.21
        for <linux-crypto@vger.kernel.org>; Tue, 26 Feb 2013 08:04:49 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Joel A Fernandes <joelagnel@ti.com>

After DMA is complete, the omap_sham_finish_req function is called as
a part of the done_task tasklet. During this its atomic and any calls
to pm functions should not assume they wont sleep.

The patch replaces a call to pm_runtime_put_sync (which can sleep) with
pm_runtime_put thus fixing a kernel panic observed on AM33xx SoC during
SHA operation.

Tested on an AM33xx SoC device (beaglebone board).
To reproduce the problem, used the tcrypt kernel module as:
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
