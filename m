From: Jamie Iles <jamie@jamieiles.com>
Subject: [PATCH] crypto: picoxcell: fix possible invalid pointer dereference
Date: Mon,  6 Jun 2011 12:31:17 +0100
Message-ID: <1307359877-14946-1-git-send-email-jamie@jamieiles.com>
Cc: Jamie Iles <jamie@jamieiles.com>, stable@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51108 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab1FFLbX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jun 2011 07:31:23 -0400
Received: by wya21 with SMTP id 21so2702966wya.19
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jun 2011 04:31:22 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The completion callback will free the request so we must remove it from
the completion list before calling the callback.

Cc: stable@kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/crypto/picoxcell_crypto.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index db7cb31..a1b4ca2 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1267,8 +1267,8 @@ static void spacc_spacc_complete(unsigned long data)
 	spin_unlock_irqrestore(&engine->hw_lock, flags);
 
 	list_for_each_entry_safe(req, tmp, &completed, list) {
-		req->complete(req);
 		list_del(&req->list);
+		req->complete(req);
 	}
 }
 
-- 
1.7.4.1
