From: Joel A Fernandes <agnel.joel@gmail.com>
Subject: [PATCH 2/2] omap-aes: Use pm_runtime_put instead of pm_runtime_put_sync
Date: Fri, 15 Feb 2013 01:59:28 -0600
Message-ID: <1360915168-28786-2-git-send-email-agnel.joel@gmail.com>
References: <1360915168-28786-1-git-send-email-agnel.joel@gmail.com>
Cc: Joel A Fernandes <joelagnel@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:49930 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900Ab3BOIBA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Feb 2013 03:01:00 -0500
Received: by mail-ob0-f180.google.com with SMTP id ef5so3358760obb.11
        for <linux-crypto@vger.kernel.org>; Fri, 15 Feb 2013 00:00:59 -0800 (PST)
In-Reply-To: <1360915168-28786-1-git-send-email-agnel.joel@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Joel A Fernandes <joelagnel@ti.com>

Not doing so could cause sleep in interrupt context resulting in a kernel panic.

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
