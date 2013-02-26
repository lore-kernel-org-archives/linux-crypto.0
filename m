From: agnel.joel@gmail.com
Subject: [PATCH v3 2/2] omap-aes: Use pm_runtime_put instead of pm_runtime_put_sync in tasklet
Date: Tue, 26 Feb 2013 10:04:32 -0600
Message-ID: <1361894672-10431-2-git-send-email-agnel.joel@gmail.com>
References: <1361894672-10431-1-git-send-email-agnel.joel@gmail.com>
Cc: Joel A Fernandes <joelagnel@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61016 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759760Ab3BZQEx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Feb 2013 11:04:53 -0500
Received: by mail-pa0-f47.google.com with SMTP id bj3so2520827pad.6
        for <linux-crypto@vger.kernel.org>; Tue, 26 Feb 2013 08:04:53 -0800 (PST)
In-Reply-To: <1361894672-10431-1-git-send-email-agnel.joel@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Joel A Fernandes <joelagnel@ti.com>

After DMA is complete, the omap_aes_finish_req function is called as
a part of the done_task tasklet. During this its atomic and any calls
to pm functions should not assume they wont sleep.

The patch replaces a call to pm_runtime_put_sync (which can sleep) with
pm_runtime_put thus fixing a kernel panic observed on AM33xx SoC during
AES operation.

Tested on an AM33xx SoC device (beaglebone board).
To reproduce the problem, I used the tcrypt kernel module as:
modprobe tcrypt sec=2 mode=500

Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/crypto/omap-aes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index cf57866..8450bfd2 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -636,7 +636,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
-	pm_runtime_put_sync(dd->dev);
+	pm_runtime_put(dd->dev);
 	dd->flags &= ~FLAGS_BUSY;
 
 	req->base.complete(&req->base, err);
-- 
1.7.4.1
