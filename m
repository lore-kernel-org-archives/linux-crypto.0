From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: ixp4xx - Fix error handling path in 'aead_perform()'
Date: Wed, 19 Jul 2017 23:47:57 +0200
Message-ID: <20170719214757.29203-1-christophe.jaillet@wanadoo.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: herbert@gondor.apana.org.au, davem@davemloft.net, arnd@arndb.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:58766 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753952AbdGSVsI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2017 17:48:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In commit 0f987e25cb8a, the source processing has been moved in front of
the destination processing, but the error handling path has not been
modified accordingly.
Free resources in the correct order to avoid some leaks.

Fixes: 0f987e25cb8a ("crypto: ixp4xx - Fix false lastlen uninitialised warning")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/ixp4xx_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 427cbe012729..1ccbe15b5f16 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -1088,10 +1088,10 @@ static int aead_perform(struct aead_request *req, int encrypt,
 	BUG_ON(qmgr_stat_overflow(SEND_QID));
 	return -EINPROGRESS;
 
-free_buf_src:
-	free_buf_chain(dev, req_ctx->src, crypt->src_buf);
 free_buf_dst:
 	free_buf_chain(dev, req_ctx->dst, crypt->dst_buf);
+free_buf_src:
+	free_buf_chain(dev, req_ctx->src, crypt->src_buf);
 	crypt->ctl_flags = CTL_FLAG_UNUSED;
 	return -ENOMEM;
 }
-- 
2.11.0
