From: Jamie Iles <jamie@jamieiles.com>
Subject: [PATCH] crypto: picoxcell: fix possible invalid pointer dereference
Date: Tue,  2 Aug 2011 11:29:06 +0100
Message-ID: <1312280946-4451-1-git-send-email-jamie@jamieiles.com>
Cc: Jamie Iles <jamie@jamieiles.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47524 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1HBK3O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Aug 2011 06:29:14 -0400
Received: by wwe5 with SMTP id 5so6580176wwe.1
        for <linux-crypto@vger.kernel.org>; Tue, 02 Aug 2011 03:29:12 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The completion callback will free the request so we must remove it from
the completion list before calling the callback.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/crypto/picoxcell_crypto.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 017340c..a2b553e 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1242,8 +1242,8 @@ static void spacc_spacc_complete(unsigned long data)
 	spin_unlock_irqrestore(&engine->hw_lock, flags);
 
 	list_for_each_entry_safe(req, tmp, &completed, list) {
-		req->complete(req);
 		list_del(&req->list);
+		req->complete(req);
 	}
 }
 
-- 
1.7.4.1
