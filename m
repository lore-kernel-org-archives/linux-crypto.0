From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: xts - Fix an error handling path in 'create()'
Date: Tue, 26 Sep 2017 08:17:44 +0200
Message-ID: <20170926061744.31587-1-christophe.jaillet@wanadoo.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:39136 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933842AbdIZGS0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Sep 2017 02:18:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All error handling paths 'goto err_drop_spawn' except this one.
In order to avoid some resources leak, we should do it as well here.

Fixes: f1c131b45410 ("crypto: xts - Convert to skcipher")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 crypto/xts.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index d86c11a8c882..e31828ed0046 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -554,8 +554,10 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 		ctx->name[len - 1] = 0;
 
 		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-			     "xts(%s)", ctx->name) >= CRYPTO_MAX_ALG_NAME)
-			return -ENAMETOOLONG;
+			     "xts(%s)", ctx->name) >= CRYPTO_MAX_ALG_NAME) {
+			err = -ENAMETOOLONG;
+			goto err_drop_spawn;
+		}
 	} else
 		goto err_drop_spawn;
 
-- 
2.11.0
