From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 4/4] crypto: ccree: remove dead legacy code
Date: Thu, 28 Jun 2018 08:32:54 +0100
Message-ID: <1530171175-31960-5-git-send-email-gilad@benyossef.com>
References: <1530171175-31960-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530171175-31960-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove legacy code no longer used by anything.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 3af44a5..8204c87 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -730,12 +730,6 @@ static int cc_cipher_process(struct skcipher_request *req,
 	cc_req.user_cb = (void *)cc_cipher_complete;
 	cc_req.user_arg = (void *)req;
 
-#ifdef ENABLE_CYCLE_COUNT
-	cc_req.op_type = (direction == DRV_CRYPTO_DIRECTION_DECRYPT) ?
-		STAT_OP_TYPE_DECODE : STAT_OP_TYPE_ENCODE;
-
-#endif
-
 	/* Setup request context */
 	req_ctx->gen_ctx.op_type = direction;
 
-- 
2.7.4
